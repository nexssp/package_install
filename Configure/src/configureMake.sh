# ConfigureMake for Nexss Programmer 2
# $1 - Folder from current path eg: tcl8.6.10/win
# $2 - Configure Folder eg: /c/Users/mapoart/.nexss/cache/downloads/tcl8610-src/
# $3 - Installation Path eg: /C/Users/mapoart/.nexssApps/

# export CC=gcc

echo "Subfolder(1) $1"
echo "Source Path(2): $2"
echo "Installation Path(3): $3"


cd "$2/$1"
# cd ../../

CC=gcc ./configure --prefix="$3/$1" --exec-prefix="$3/$1"

make
make install

echo "pwd $(pwd)"
echo "Subfolder(1): $1"
echo "Source Path(2): $2"
echo "Installation Path(3): $3"