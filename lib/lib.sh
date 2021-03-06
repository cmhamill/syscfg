# lib.sh - shared shell script constants and functions.

set -o nounset  # error on undefined variables

# Exit code values from <sysexits.h>.
EX_OK=0             # successful termination
EX_USAGE=64	    # command line usage error
EX_DATAERR=65	    # data format error
EX_NOINPUT=66	    # cannot open input
EX_NOUSER=67	    # addressee unknown
EX_NOHOST=68	    # host name unknown
EX_UNAVAILABLE=69   # service unavailable
EX_SOFTWARE=70	    # internal software error
EX_OSERR=71	    # system error (e.g., can't fork)
EX_OSFILE=72	    # critical OS file missing
EX_CANTCREAT=73	    # can't create (user) output file
EX_IOERR=74	    # input/output error
EX_TEMPFAIL=75	    # temp failure; user is invited to retry
EX_PROTOCOL=76	    # remote error in protocol
EX_NOPERM=77	    # permission denied
EX_CONFIG=78	    # configuration error

say() {
    echo "$PROG: $1"
}

say_err() {
    say "$1" >&2
}

err() {
    say_err "$2"
    exit $1
}

need_cmd() {
    if ! command -v "$1" > /dev/null 2>&1; then
        err $EX_UNAVAILABLE "need '$1' (command not found)"
    fi
}

print_usage() {
    echo "$USAGE" | head -n 1 >&2
    exit $EX_USAGE
}

print_help() {
    echo "$USAGE"
    exit $EX_OK
}

task_start() {
    say ">>> ${1}..."
}

task_done() {
    say "...done."
}

task_failed() {
    say "...failed!"
    exit $EX_UNAVAILABLE
}

need_cmd getopt
