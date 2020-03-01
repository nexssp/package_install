# Nexss PROGRAMMER 2.0 - Package Install/Configure
# This one will be removed after package run ends

$nxsParameters = @("configureSourcePath", "configureSubPath", "configureBinFilePath", "configureDestination")
$input | . "$($env:NEXSS_PACKAGES_PATH)/Nexss/Lib/NexssIn.ps1"
. "$($env:NEXSS_PACKAGES_PATH)/Nexss/Lib/Posix.ps1"

if (!$NexssStdout.configureSourcePath) {
    nxsError("You need to specify --configureSourcePath eg. c:\Users\mapoart\.nexss\cache\downloads\tcl8610-src.\n\r This can be taken from Nexss Programmer's FS/Unpack module.")
    break
}

if (!$NexssStdout.configureSubPath) {
    nxsError("You need to specify --configureSubPath eg. tcl8.6.10/win. So for example it is subfolder inside your unpacked source.")
    break
}

if (!$NexssStdout.configureBinFilePath) {
    nxsError("You need to specify --configureBinFilePath eg. bin/tclsh86.exe. It will allow to check if this package is already installed, but also can be added to your PATH so you can access it from everywere in your OS.")
    break
}

if (!$NexssStdout.configureDestination) {
    $NexssStdout | Add-Member -Force -NotePropertyMembers @{configureDestination = "$env:NEXSS_APPS_PATH/$($NexssStdout.configureSubPath)" }
}
else {
    $NexssStdout | Add-Member -Force -NotePropertyMembers @{configureDestination = "$env:NEXSS_APPS_PATH/$($NexssStdout.configureDestination)" }
}

if (!$NexssStdout.configureExtraParams) {
    $NexssStdout | Add-Member -Force -NotePropertyMembers @{configureExtraParams = "" }
}

nxsInfo("$($NexssStdout.configureAppName) will be installed in: $($NexssStdout.configureDestination)")

$conf = pathWinToPosix("$($NexssStdout.configureSourcePath)/$($NexssStdout.configureSubPath)/configure")

if (! (test-path $NexssStdout.configureDestination)) {
    New-Item -ItemType Directory -Path $NexssStdout.configureDestination
}
cd $NexssStdout.configureDestination
$destination = pathWinToPosix($NexssStdout.configureDestination)

if (!(test-path "$($NexssStdout.configureDestination)/$($NexssStdout.configureBinFilePath)")) {
    nxsInfo("Conf: $conf")
    nxsInfo("Destination: $destination")
    mingw64 -c "$conf --prefix=`"$destination` $($NexssStdout.configureExtraParams) && make && make install"  
    nxsOk("$($NexssStdout.configureAppName) has been installed")
}
else {
    nxsInfo("$($NexssStdout.configureAppName) is already installed.")
}

nxsInfo("To access $($NexssStdout.configureAppName) type in the terminal $(Split-Path -Leaf $NexssStdout.configureBinFilePath) (or without .exe)")

. "$($env:NEXSS_PACKAGES_PATH)/Nexss/Lib/Env.ps1"
# We remove *.exe file to take only path
ensureEnvPath "$($NexssStdout.configureDestination)/$(Split-Path $NexssStdout.configureBinFilePath)"

. "$($env:NEXSS_PACKAGES_PATH)/Nexss/Lib/NexssOut.ps1"
