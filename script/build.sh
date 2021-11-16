#!/bin/sh
#
# build.sh
#

VERSION="1.3"

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
    build.sh [-n|--no-update] [-j JOBS] [-v|--version] [-h|-\?|--help]
Options:

    -n
    --no-update
        Do not update Makefile, huskymak.cfg, build.sh

    -j JOBS
        JOBS is a positive integer. It specifies the number of makefile
        recipes to run simultaneously. If you omit the option, make runs
        as many recipes simultaneously as possible. To switch the parallel
        makefile execution off, use "-j 1".

    -v
    --version
        Print the script version and exit.

    -h
    -?
    --help
        Print this help and exit.
EOF
}

help=0
no_update=0
jobs=-j

while :
do
    case $1 in
        -h|-\?|--help)
            help=1
            break
            ;;
        -v|--version)
            echo "version = $VERSION"
            exit
            ;;
        -n|--no-update)
            no_update=1
            ;;
        -j)
            if [ "$2" ]
            then
                if [ -z "${2##*[!0-9]*}" ] || [ "$2" -eq 0 ]
                then
                    die 'ERROR: "-j" requires a positive integer argument'
                else
                    jobs=-j$2
                    shift
                fi
            else
                die 'ERROR: "-j" requires a positive integer argument'
            fi
            ;;
        -*)
            printf 'WARN: Unknown option (ignored): %s\n' "$1" >&2
            ;;
        *)
            break
    esac
    shift
done

if [ $help -eq 1 ]
then
    show_help
    exit
fi


# Check that the script is not run by root
[ "$(id -u)" -eq 0 ] && die "DO NOT run this as root"

MAKE=make
[ "$(uname -s)" = FreeBSD ] && MAKE=gmake

${MAKE} $jobs update
[ "$?" -ne 0 ] && exit 1

restart=0

if [ "$no_update" -eq 0 ] && [ -n "$(diff ./Makefile huskybse/Makefile)" ]
then
    cp -p -f huskybse/Makefile ./
fi

huskymak=huskybse/huskymak.cfg
[ "$(uname -s)" = FreeBSD ] && huskymak=huskybse/huskymak.cfg.bsd
[ "$(uname -s)" = Darwin ] && huskymak=huskybse/huskymak.cfg.macos

if [ "$no_update" -eq 0 ] && \
   [ -n "$(diff ./huskymak.cfg.new $huskymak)" ]
then
    mv -f ./huskymak.cfg.new huskymak.cfg.old
    cp -p -f $huskymak huskymak.cfg.new
    if [ ! -e ./huskymak.cfg ]
    then
        cp -p ./huskymak.cfg.new huskymak.cfg
    fi
    echo
    echo "\"$huskymak\" has changed"
    echo
    echo "A new version of \"$huskymak\" is now"
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

${MAKE} $jobs depend && ${MAKE} $jobs
