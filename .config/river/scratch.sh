#! /bin/sh

scratch_tag=$(( 1 << 20 ))

riverctl map normal Super B toggle-focused-tags ${scratch_tag}
riverctl map normal Super+Shift B set-view-tags ${scratch_tag}

# Set spawn tagmask to ensure new windows don't have the scratchpad tag unless
# explicitly set.
all_but_scratch_tag=$(( ((1 << 32) - 1) ^ scratch_tag ))
riverctl spawn-tagmask ${all_but_scratch_tag}
