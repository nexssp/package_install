$nxsParameters = @("msiExecInstallPath")
$input | . "$($env:NEXSS_PACKAGES_PATH)/Nexss/Lib/NexssIn.ps1"

$ErrorActionPreference = "Stop"
# Write-Host $NexssStdout
# exit

$msiExecInstallPath = $NexssStdout.msiExecInstallPath;


nxsInfo("msiExecFile: $msiExecFile")
if (!$msiExecInstallPath) {
    nxsError("Specify --msiExecInstallPath absolute path parameter.")       
    exit
}
elseif (!([System.IO.Path]::IsPathRooted($msiExecInstallPath))) {
    nxsError("Parameter --msiExecInstallPath must be absolute path. passed: $msiExecInstallPath")       
    exit
}

nxsInfo("Install folder: $msiExecInstallPath")

$installedPaths = @()

foreach ($msiExecFile in $inFieldValue_1) { 
    # each value is $value
    if ($msiExecFile) {
        nxsInfo("msiExecFile: $msiExecFile")
        if (!(test-path $msiExecFile)) {
            nxsError("File not found: $msiExecFile")       
            exit
        }
    
        $installCommand = ( -join ('/i "', "$msiExecFile", '"'))

        # Custom application dir
        if ($msiExecInstallPath) {
            $installCommand = ( -join ($installCommand, " APPLICATIONFOLDER=`"$msiExecInstallPath`""))
        }   
    
        # LOGDIR
        if ($Log) {
            $installCommand = ( -join ($installCommand, " /L*V $Log"))
            Write-Host "Log file will be at $Log" 
        }

        $installCommand = ( -join ($installCommand, " /passive /norestart"))

        nxsInfo("Command: msiexec.exe $installCommand")
        if ($msiExecInstallPath) {
            nxsInfo("Installing application to $msiExecInstallPath")
        }    
    
        Start-Process msiexec.exe $installCommand -Wait

        $installedPaths += $msiExecInstallPath
    }
}

if ( $installedPaths) {  
    $NexssStdout | Add-Member -Force -NotePropertyMembers  @{"$resultField_1" = $installedPaths }
}
else {
    $NexssStdout.PSObject.Properties.Remove($resultField_1)   
}

. "$($env:NEXSS_PACKAGES_PATH)/Nexss/Lib/NexssOut.ps1"