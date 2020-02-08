DESTINATION=$1
CurrentDir=$(pwd)

echo "Configuring Package.."
# export CC=gcc

echo "Current directory: $CurrentDir, configure start from path: $1"

cd $1
cd ../../

CC=gcc ./tcl8.6.10/win/configure --prefix=${PWD}/usr/local --exec-prefix=${PWD}/usr/local
echo "Configured pwd: $PWD."
echo "Current directory: $CurrentDir, configure start from path: $1"


make
make install