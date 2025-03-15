#!/usr/bin/env bash

if [ $# -lt 2 ]; then
  echo "Error: At least 2 arguments are required (template and title parts)"
  exit 1
fi

template="$1"

shift

filename=$(echo "$@" | tr " " "-")

date_filename=$(date "+%Y-%m-%d")_$filename.md

cd "/mnt/g/Meine Ablage/Obsidian/Main_vault" || { echo "Directory not found"; exit 1; }

touch "inbox/$date_filename"

nvim "inbox/$date_filename" \
  -c "lua pcall(vim.cmd, 'ObsidianTemplate ${template}')" \
  -c "silent! execute '12s/\\(# \\)[^_]*_/\\1/'" \
  -c "silent! execute '12s/-/ /g'" \
  -c "execute 'normal! 2o'" \
  -c "startinsert"   # Enter insert mode at the new cursor position
