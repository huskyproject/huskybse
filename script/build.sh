#!/bin/sh
#
# build.sh
#

VERSION="1.1"

die()
{
    printf '%s\n' "$1" >&2
    exit 1
}

show_help()
{
    cat <<EOF

Download the necessary sources and build executables for the programs
specified in PROGRAMS setting of huskymak.cfg and for the libraries
they depend on.

Usage:.
    build.sh [-v|--version] [-h|-\?|--help]
Options:
    -v
    --version
        Print the script version and exit.

    -h
    -?
    --help
        Print this help and exit.

    -n
    --no-update
        Do not update Makefile, huskymak.cfg, build.sh

    -p
        Prohibit parallel makefile execution

EOF
}

help=0
no_update=0
parallel=-j

case $1 in
    -h|-\?|--help)
        help=1
        ;;
    -v|--version)
        echo "version = $VERSION"
        exit
        ;;
    -n|--no-update)
        no_update=1
        ;;
    -p)
        parallel=
        ;;
    -*)
        printf 'WARN: Unknown option (ignored): %s\n' "$1" >&2
        ;;
    *)
        ;;
esac

if [ $help -eq 1 ]
then
    show_help
    exit
fi


# Check that the script is not run by root
[ "$(id -u)" -eq 0 ] && die "DO NOT run this as root"

MAKE=make
[ "$(uname -s)" = FreeBSD ] && MAKE=gmake

${MAKE} $parallel update

restart=0

if [ "$no_update" -eq 0 ] && [ -n "$(diff ./Makefile huskybse/Makefile)" ]
then
    cp -p -f huskybse/Makefile ./
fi

if [ "$no_update" -eq 0 ] && \
   [ -n "$(diff ./huskymak.cfg.new huskybse/huskymak.cfg)" ]
then
    mv -f ./huskymak.cfg.new huskymak.cfg.old
    cp -p -f huskybse/huskymak.cfg huskymak.cfg.new
    if [ ! -e ./huskymak.cfg ]
    then
        cp -p ./huskymak.cfg.new huskymak.cfg
    fi
    echo
    echo "\"huskybse/huskymak.cfg\" has changed"
    echo
    echo "A new version of \"huskybse/huskymak.cfg\" is now"
    echo "in \"./huskymak.cfg.new\" and its old version"
    echo "is now in \"./huskymak.cfg.old\"."
    echo "Please adjust your \"./huskymak.cfg\" to the changes"
    echo "in \"./huskymak.cfg.new\" and run \"build.sh\" once more."
    echo
    restart=1
fi

if [ "$no_update" -eq 0 ] && \
   [ -n "$(diff ./build.sh huskybse/script/build.sh)" ]
then
    cp -p -f huskybse/script/build.sh ./
    if [ "$restart" -ne 1 ]
    then
    echo
    echo 'The "build.sh" script has changed. Please restart it.'
    echo
    restart=1
    fi
fi

[ "$restart" -eq 1 ] && exit

${MAKE} $parallel depend && ${MAKE} $parallel
