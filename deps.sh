#!/bin/bash

set -x

JOBS=8
uname -a | grep Darwin >> /dev/null && is_mac=1 || true
uname -a | grep Ubuntu >> /dev/null && is_ubuntu=1 || true

# Parse args
read -r -d '' USAGE << EOM
deps.sh [-x] [-j num_jobs]
        -x enable to print the debug info
        -j number of paralle jobs to use during the build (default: 8)
EOM

[ $# -eq 0 ] && echo "$USAGE" && exit 1

while getopts "xj:" opt; do
    case $opt in
        x)
            SET_X=1;;
        j)
            JOBS=$OPTARG;;
        *)
            echo "$USAGE"
            exit 1;;
        \?)
            echo "Invalid option: -$OPTARG"
            exit 1;;
        :)
            echo "Option $OPTARG requires an argument." >&2
            exit 1
    esac
done

[ -z "$SET_X" ] && echo "SET_X is empty!" >> /dev/null
[ -n "$SET_X" ] && echo "SET_X is not empty!" >> /dev/null && set -x

script_dir=`cd $(dirname $0); pwd`
work_dir=$script_dir
deps_prefix=$work_dir/deps_prefix
deps_src=$work_dir/deps_src

set -eE #enable bash debug mode
error() {
   local sourcefile=$1
   local lineno=$2
   echo abnormal exit at $sourcefile, line $lineno
}
trap 'error "${BASH_SOURCE}" "${LINENO}"' ERR

mkdir -p $deps_prefix

function do-cmake() 
{
    cmake -H. -Bcmake-build -DCMAKE_INSTALL_PREFIX:PATH=$deps_prefix \
          -DCMAKE_PREFIX_PATH=$deps_prefix \
          -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE:-Release} \
          -DCMAKE_CXX_FLAGS="$CMAKE_CXX_FLAGS" \
          "$@"
    cmake --build cmake-build -- -j$JOBS
    cmake --build cmake-build -- $make_target install
    rm -rf cmake-build
}

function do-configure () 
{
    ./configure --prefix=$deps_prefix "$@"
}

function do-make() 
{
    make -j$JOBS "$@"
    make install
}

function do-make_no_install() 
{
    make -j$JOBS "$@"
}

function do-make_install() 
{
    make install "$@"
}

# function protobuf()
# {
#     if [ -f ${deps_prefix}/lib/libprotobuf.a ];then
#         echo "protobuf alrady been builded, skip!"
#         return
#     fi

#     cd $deps_src/$FUNCNAME
#     ./autogen.sh
#     do-configure
#     do-make CFLAGS='-Wno-implicit-fallthrough -Werror=switch'
#     cd $work_dir
# }
# protobuf

function grpc()
{
    if [ -f ${deps_prefix}/lib/libgrpc.a ];then
        echo "grpc alrady been builded, skip!"
        return
    fi

    cd $deps_src/$FUNCNAME
    git submodule update --init
    cd third_party/zlib
    ./configure
    make $1
    cd -

    do-make_no_install CFLAGS='-Wno-implicit-fallthrough -Wno-error' \
                       CXXFLAGS='-Wno-implicit-fallthrough -Wno-error -std=c++11'\
                       EMBED_OPENSSL=true \
                       HAS_SYSTEM_HAS_ZLIB=false EMBED_ZLIB=true \
                       HAS_SYSTEM_PROTOBUF=false
    do-make_install prefix=${deps_prefix}
    cd $work_dir
}
grpc

# function libevent()
# {
#     if [ -f ${deps_prefix}/lib/libevent.a ];then
#         echo "libevent alrady been builded, skip!"
#         return
#     fi

#     cd $deps_src/$FUNCNAME
#     ./autogen.sh
#     do-configure
#     do-make
#     cd $work_dir
# }
# libevent

