#!/bin/sh
printf '\033c\033]0;%s\a' Yam
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Yam_Linux.x86_64" "$@"
