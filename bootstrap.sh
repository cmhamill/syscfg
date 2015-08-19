#!/usr/bin/env bash

# Global constants.
BOOT_DEVICE="/dev/sda2"
BOOT_KEYFILE_PATH="/etc/boot_keyfile"

source "$(dirname "$(readlink -f "$0")")/lib/lib.sh"

PATH="$(dirname "$(readlink -f "$0")")/bin:$PATH"

PROG="bootstrap.sh"
USAGE="Usage: $PROG [-h]

Bootstrap a new workstation.

    -h, --help  print this help message

Assumptions about workstation state:
- system has just come out of a debian-installer run
- system is the current Debian stable distribution
- /boot is on an encrypted partition
"

ARGS=$(getopt -o h --long help -n "$PROG" -- "$@")
[ $? == 0 ] || print_usage
eval set -- "$ARGS"

while true; do
    case "$1" in
        -h|--help)  print_help;;
        --)         shift; break;;
        *)          err $EX_SOFTWARE "internal error!";;
    esac
done

need_cmd setup-crypted-boot-automounting
task_start "configuring automounting of encrypted /boot"
setup-crypted-boot-automounting \
    "$BOOT_DEVICE" \
    "$(basename "$BOOT_DEVICE")_crypt" \
    "$BOOT_KEYFILE_PATH" \
    || task_failed
task_done

need_cmd wget
task_start "checking internet connectivity"
wget -q --spider http://google.com || task_failed
task_done

need_cmd apt-get
task_start "updating package cache"
apt-get update || task_failed
task_done

task_start "upgrading to latest packages in current release"
apt-get upgrade || task_failed
apt-get dist-upgrade || task_failed
task_done
