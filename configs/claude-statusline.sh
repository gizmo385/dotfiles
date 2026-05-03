#!/usr/bin/env bash
input=$(cat)
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
model=$(echo "$input" | jq -r '.model.display_name // empty')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

user=$(whoami)
host=$(hostname -s)

# Bold green user@host, reset, colon, bold blue cwd, reset
ps1_part=$(printf "\033[01;32m%s@%s\033[00m:\033[01;34m%s\033[00m" "$user" "$host" "$cwd")

extras=""
if [ -n "$model" ]; then
    extras="$model"
fi
if [ -n "$used" ]; then
    used_int=$(printf "%.0f" "$used")
    if [ -n "$extras" ]; then
        extras="$extras | ctx: ${used_int}%"
    else
        extras="ctx: ${used_int}%"
    fi
fi

if [ -n "$extras" ]; then
    printf "%s  [%s]\n" "$ps1_part" "$extras"
else
    printf "%s\n" "$ps1_part"
fi
