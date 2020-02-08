DESTINATION=$1
CurrentDir=$(pwd)

echo "Configuring Package.."
# export CC=gcc

echo "Current directory: $CurrentDir, 2: $2 configure start from path: $1"

cd $1
cd ../../

CC=gcc ./tcl8.6.10/win/configure --prefix=$2 --exec-prefix=$2
echo "Configured pwd: $PWD."
echo "Current directory: $CurrentDir, 2: $2, configure start from path: $1"


make
make install