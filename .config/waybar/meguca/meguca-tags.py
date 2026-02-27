#!/usr/bin/env python3
"""Waybar custom module for meguca tag state.

Usage in waybar config:
    "custom/tags": {
        "exec": "/path/to/meguca-tags.py",
        "return-type": "json",
        "format": "{}"
    }

Waybar sets WAYBAR_OUTPUT_NAME (e.g. "HDMI-A-1") so each bar
reads the correct per-output file.

Tags are styled via Pango alpha/weight attributes only.
Set the base color in style.css on #custom-tags — alpha
controls how bright each tag appears relative to that color.

Tag states (alpha index):
    0 = focused + seat here  (100% alpha, bold, brackets)
    1 = focused, seat away   (65% alpha, brackets)
    2 = active (other output) (55% alpha, braces)
    3 = occupied             (35% alpha, no delimiters)

Module-level CSS classes (target with: #custom-tags.CLASS):
    seat-focused      = seat is on this output
    seat-unfocused    = seat is on another output
"""

import ctypes
import json
import os
import select
import signal
import struct

IN_CLOSE_WRITE = 0x00000008
IN_MOVED_TO = 0x00000080
IN_DELETE_SELF = 0x00000400
IN_IGNORED = 0x00008000
IN_CLOEXEC = 0o2000000

INOTIFY_EVENT_HEADER_FORMAT = "iIII"
INOTIFY_EVENT_HEADER_SIZE = struct.calcsize(INOTIFY_EVENT_HEADER_FORMAT)
INOTIFY_BUFFER_SIZE = 4096
DIRECTORY_POLL_INTERVAL = 1.0

WATCH_MASK = IN_CLOSE_WRITE | IN_MOVED_TO | IN_DELETE_SELF

libc = ctypes.CDLL("libc.so.6", use_errno=True)
libc.inotify_init1.argtypes = [ctypes.c_int]
libc.inotify_init1.restype = ctypes.c_int
libc.inotify_add_watch.argtypes = [ctypes.c_int, ctypes.c_char_p, ctypes.c_uint32]
libc.inotify_add_watch.restype = ctypes.c_int

STATES = [
    {"alpha": "100%", "weight": "bold"},
    {"alpha": "85%"},
    {"alpha": "75%"},
    {"alpha": "35%"},
]

# Self-pipe for clean shutdown. Signal handlers write a byte here
# to wake select() without raising exceptions from C-level calls.
_shutdown_read, _shutdown_write = os.pipe()
os.set_blocking(_shutdown_read, False)
os.set_blocking(_shutdown_write, False)


def _request_shutdown(_signal_number, _stack_frame):
    try:
        os.write(_shutdown_write, b"\x00")
    except OSError:
        pass


class WatchInvalidated(Exception):
    pass


class ShutdownRequested(Exception):
    pass


class FileWatcher:
    def __init__(self, filepath):
        self.directory = os.path.dirname(filepath)
        self.filename = os.path.basename(filepath)
        self.inotify_fd = -1

    def wait_for_directory(self):
        while not os.path.isdir(self.directory):
            readable, _, _ = select.select(
                [_shutdown_read],
                [],
                [],
                DIRECTORY_POLL_INTERVAL,
            )
            if readable:
                raise ShutdownRequested()

    def setup(self):
        self.inotify_fd = libc.inotify_init1(IN_CLOEXEC)
        if self.inotify_fd < 0:
            errno = ctypes.get_errno()
            raise OSError(errno, os.strerror(errno))

        watch_descriptor = libc.inotify_add_watch(
            self.inotify_fd,
            self.directory.encode(),
            WATCH_MASK,
        )

        if watch_descriptor < 0:
            errno = ctypes.get_errno()
            self.close()
            raise OSError(errno, os.strerror(errno))

    def wait_for_change(self):
        try:
            readable, _, _ = select.select(
                [self.inotify_fd, _shutdown_read],
                [],
                [],
            )
        except OSError:
            raise WatchInvalidated()

        if _shutdown_read in readable:
            raise ShutdownRequested()

        if self.inotify_fd not in readable:
            return False

        try:
            raw_events = os.read(self.inotify_fd, INOTIFY_BUFFER_SIZE)
        except OSError:
            raise WatchInvalidated()

        if not raw_events:
            raise WatchInvalidated()

        file_changed = False
        watch_invalidated = False
        offset = 0

        while offset < len(raw_events):
            _watch_descriptor, mask, _cookie, name_length = struct.unpack_from(
                INOTIFY_EVENT_HEADER_FORMAT,
                raw_events,
                offset,
            )
            offset += INOTIFY_EVENT_HEADER_SIZE

            if name_length > 0:
                event_name = (
                    raw_events[offset : offset + name_length].rstrip(b"\0").decode()
                )
                if event_name == self.filename:
                    file_changed = True

            if mask & (IN_DELETE_SELF | IN_IGNORED):
                watch_invalidated = True

            offset += name_length

        if watch_invalidated:
            self.close()
            raise WatchInvalidated()

        return file_changed

    def close(self):
        if self.inotify_fd >= 0:
            os.close(self.inotify_fd)
            self.inotify_fd = -1


def tags_file():
    runtime = os.environ.get("XDG_RUNTIME_DIR", "/tmp")
    output_name = os.environ.get("WAYBAR_OUTPUT_NAME", "")
    if output_name:
        return os.path.join(runtime, "meguca", f"tags-{output_name}.json")
    return os.path.join(runtime, "meguca", "tags.json")


def _span(text, state_index):
    state = STATES[state_index]
    attrs = " ".join(f"{k}='{v}'" for k, v in state.items())
    return f"<span {attrs}>{text}</span>"


def format_tags(path):
    try:
        with open(path) as f:
            data = json.load(f)
    except (FileNotFoundError, json.JSONDecodeError):
        return json.dumps({"text": "", "tooltip": "no tag data"})

    focused = set(data.get("focused", []))
    active = set(data.get("active", []))
    occupied = set(data.get("occupied", []))
    seat_focused = data.get("seat_focused", False)

    all_tags = focused | active | occupied
    parts = []
    tooltip_lines = []

    for tag in sorted(all_tags):
        label = "0" if tag == 10 else str(tag)

        if tag in focused and seat_focused:
            part = _span("[", 0) + _span(label, 0) + _span("]", 0)
            tooltip_lines.append(f"Tag {label}: focused (seat here)")
        elif tag in focused:
            part = _span("[", 1) + _span(label, 1) + _span("]", 1)
            tooltip_lines.append(f"Tag {label}: focused (seat elsewhere)")
        elif tag in active:
            part = _span("{", 2) + _span(label, 2) + _span("}", 2)
            tooltip_lines.append(f"Tag {label}: active (other output)")
        else:
            part = _span(label, 3)
            tooltip_lines.append(f"Tag {label}: occupied")

        parts.append(part)

    return json.dumps(
        {
            "text": "  ".join(parts),
            "tooltip": "\n".join(tooltip_lines),
            "class": ["seat-focused"] if seat_focused else ["seat-unfocused"],
        }
    )


def main():
    signal.signal(signal.SIGTERM, _request_shutdown)
    signal.signal(signal.SIGINT, _request_shutdown)

    path = tags_file()
    watcher = FileWatcher(path)

    try:
        while True:
            watcher.wait_for_directory()
            watcher.setup()
            print(format_tags(path), flush=True)

            try:
                while True:
                    if watcher.wait_for_change():
                        print(format_tags(path), flush=True)
            except WatchInvalidated:
                continue
    except ShutdownRequested:
        pass
    finally:
        watcher.close()
        os.close(_shutdown_read)
        os.close(_shutdown_write)


if __name__ == "__main__":
    main()
