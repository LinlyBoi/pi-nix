#!/usr/bin/env sh
REMOTE='nixos@raspberrypi'
REMOTE_PATH='/home/nixos/.config/nixos/'
rsync -avz -e ssh --exclude-from='exclude.txt' "$(pwd)/" "$REMOTE":"$REMOTE_PATH"

