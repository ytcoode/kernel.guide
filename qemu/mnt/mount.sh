#!/usr/bin/env bash

# Change to the directory where the script resides
cd "$(dirname "$0")"

mount -t 9p -o trans=virtio mnt /mnt
