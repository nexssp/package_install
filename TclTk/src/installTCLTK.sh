
scoop install gcc

mkdir -p opt/tcl
# TCL
mkdir -p build/tcl
# cd build/tcl
# ../../tcl8.6.10/win/configure --prefix=${PWD}/../opt/tcl && make && make install

# cd ../../
#mkdir -p build/tk
######################################################
# TK

# echo "Configuring and installing TCL"
# cd build/tk
# ../../tk8.6.10/win/configure --prefix=${PWD}/../opt/tcl --with-tcl=${PWD}/../../build/tcl && make && make install
# cd ../../
######################################################


echo "Configuring and Installing Tcllib"
# https://core.tcl-lang.org/tcllib/uv/tcllib-1.19.zip
cd tcllib-1.19/
../build/opt/tcl/bin/tclsh86.exe installer.tcl -no-gui -no-wait #--help


SET VS100COMNTOOLS="C:\Users\mapoart\scoop\apps\visualc\current\program files\Microsoft Visual Studio 10.0\Common7\"

$env:VS100COMNTOOLS="C:\Users\mapoart\scoop\apps\visualc\current\program files\Microsoft Visual Studio 10.0\Common7\"    




# c:\tcl_src\win\>nmake -f makefile.vc install INSTALLDIR=c:\progra~1\tcl