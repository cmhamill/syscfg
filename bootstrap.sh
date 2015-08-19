#!/usr/bin/env bash

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
