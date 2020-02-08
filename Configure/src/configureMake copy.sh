DESTINATION=$1
CurrentDir=$(pwd)

echo "Configuring Package.."
# export CC=gcc

echo "Current directory: $CurrentDir, configure start from path: $1"
CC=gcc $1/configure --prefix=${PWD}/usr/local --exec-prefix=${PWD}/usr/local
echo "Configured pwd: $PWD."
echo "Current directory: $CurrentDir, configure start from path: $1"


make