#!/usr/bin/env bash

# Global constants.
BOOT_DEVICE="/dev/sda2"
BOOT_KEYFILE_PATH="/etc/boot_keyfile"

BASEDIR="$(dirname "$(readlink -f "$0")")"

source "${BASEDIR}/lib/lib.sh"
PATH="${BASEDIR}/bin:$PATH"

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

[ "$(id -u)" -eq 0 ] || err $EX_SOFTWARE "must be run as root"

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

task_start "changing /etc/apt/sources.list to point to testing"
CODENAME="$(awk -F"[)(]+" '/VERSION=/ { print $2 }' /etc/os-release)"
sed -i "s/${CODENAME}/testing/" /etc/apt/sources.list || task_failed
task_done

task_start "updating package cache again"
apt-get update || task_failed
task_done

task_start "upgrading to testing"
apt-get upgrade || task_failed
apt-get dist-upgrade || task_failed
task_done

task_start "updating package cache yet again"
apt-get update || task_failed
task_done

task_start "removing unused packages"
apt-get autoremove --purge || task_failed
task_done

task_start "purging removed packages"
apt-get purge $(dpkg -l | awk '/^rc/ { print $2 }') || task_failed
task_done

task_start "cleaning obsolete packages from cache"
apt-get autoclean || task_failed
task_done

task_start "rebooting into upgraded system"
read -p "reboot now? (y/n) [n]:" REBOOT_NOW
if [[ "${REBOOT_NOW:-n}" == y* ]]; then
    shutdown -r now
else
    say "reboot machine to ensure successful boot configuration"
fi
exit $EX_OK
