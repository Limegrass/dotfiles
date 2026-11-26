---
name: dotfiles
description: >
  Read, edit, move, stage, commit, or restore files in the home-directory config repository --
  a bare git repo whose work tree is $HOME. Use when touching tracked config under $HOME: shell,
  editor, browser, git, agent instructions and skills under ~/.agents. Triggers on "dotfiles",
  "commit my config", "restore .bashrc", "track this file", and on git reporting
  "not a git repository" under $HOME.
---

# Dotfiles

Bare repository: git dir `$HOME/.dotfiles`, work tree `$HOME`, pushed to a personal remote.

## Command

```sh
git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" <command>
```

Spell out both flags. The `dotfiles` shell alias exists only in interactive shells.

## Traps

- Plain `git` under `$HOME` reports "not a git repository" or reaches a nested repository -- neither is this one.
- `status.showUntrackedFiles=no` hides untracked files. A move shows only the deletion; add the new path explicitly.
- `add -A`, `add .`, `add -u`, and `commit -a` span all of `$HOME` and sweep in unrelated in-progress edits. Stage by explicit path.
- Pathspecs and `status`/`diff` output resolve against the current directory, not `$HOME`. Run from `$HOME` so both read as `$HOME`-relative.
- Review `diff --cached --stat` before committing; the work tree routinely holds unrelated edits.

## Content

The repository is reused under any employer and any agent harness, so tracked files and commit messages name neither:

- employer names, internal tools, services, URLs, template filenames
- harness names, harness tool names, harness CLI flags, harness install paths
- ticket, review, or account identifiers, work aliases

Name the mechanism instead: "the review tool", "the build command", "ask the user".
Work-specific content belongs in a separate repository; harness-specific config stays untracked.

Never commit:

- agent scratch directories: plans, specs, drafts
- files that name an employer or harness -- keep them local

## Commits

Conventional Commits, scope is the config directory: `ai`, `nvim`, `tridactyl`.
Message content follows the `commit-message` skill.
