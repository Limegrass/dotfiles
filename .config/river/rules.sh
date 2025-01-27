#! /bin/sh

all_tags=$(((1 << 32) - 1))
# float and borderless Picture-in-Picture
riverctl rule-add -title "Picture-in-Picture" float
riverctl rule-add -title "Picture-in-Picture" csd
riverctl rule-add -title "Picture-in-Picture" tags $all_tags
