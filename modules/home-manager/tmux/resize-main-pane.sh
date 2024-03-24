#!/bin/sh

window_width=$(tmux display -p '#{window_width}')
resize_width=$(echo "${window_width}/1.618" | bc)

tmux setw main-pane-width $((resize_width>120 ? resize_width : 120)); \
  tmux select-layout main-vertical
