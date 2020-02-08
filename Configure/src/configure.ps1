# Nexss PROGRAMMER 2.0.0 - PowerShell
# Default template for JSON Data
# STDIN
[Console]::OutputEncoding = [Text.UTF8Encoding]::UTF8
[Console]::InputEncoding = [Text.UTF8Encoding]::UTF8
$NexssStdin = $input

$NexssStdout = $NexssStdin | ConvertFrom-Json

$select_1 = 'c:\Users\mapoart\.nexss\cache\downloads\tcl8610-src\'
$folder = 'tcl8.6.10/win'
$srcFolder = "$select_1"
$command = "mingw" # mingw or bash / bash default

$destination = "$env:NEXSS_APPS_PATH"
# if (!(Test-Path $destination)) {
#     mkdir -p $destination
# }

function uniqPath() {
    echo $(wsl wslpath -a "'$1'")
}

$configure = "/" + (($configure -replace "\\", "/") -replace ":", "")
if (!(Get-Command $command -errorAction SilentlyContinue)) { 
    switch ($command) {
        "mingw" { 
            [Console]::Error.WriteLine("NEXSS/info:Downloading mingw/msys2. Please wait..")     
            # $NexssDownloadInfo = $(nexss Download --files=http://repo.msys2.org/distrib/x86_64/msys2-x86_64-20190524.exe) | ConvertFrom-Json             
            # & $NexssDownloadInfo.files

            scoop install msys2 
            [Console]::Error.Write("NEXSS/info:After installing mingw/msys2 You need to restart your terminal") 
            [Console]::Error.Write("NEXSS/info:If this step is repeating please try to install msys 2 manually https://www.msys2.org/")       
            [Console]::Error.Write("NEXSS/info:Press any key to exit...")
            $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
            exit
        }
        "cygwin" { 
            # $NexssDownloadInfo = $(nexss Download --files=https://www.cygwin.com/setup-x86_64.exe 2>$null) | ConvertFrom-Json             
            # & "$($NexssDownloadInfo.files)" --quiet-mode --verbose --no-desktop --no-shortcuts  --root "$($env:NEXSS_APPS_PATH)\cygwin\" --packages "$($env:NEXSS_APPS_PATH)\cygwin\packages" --packages gcc, make
            $command = "$($env:NEXSS_APPS_PATH)\cygwin\bin\bash -l"
            # "%PROGRAMFILES%\cygwinx86\setup-x86.exe" ^
            # --site http://cygwin.mirror.constant.com ^
            # --no-shortcuts ^
            # --no-desktop ^
            # --quiet-mode ^
            # --root "%PROGRAMFILES%\cygwinx86\cygwin" ^
            # --arch x86 ^
            # --local-package-dir "%PROGRAMFILES%\cygwinx86\cygwin-packages" ^
            # --verbose ^
            # --prune-install ^
            # --packages openssh, git, rsync, nano

        }
        "bash" { 
            [Console]::Error.WriteLine("NEXSS/info:Enabling WSL (Windows Subsystem Linux)..")     
            # bash has 
            dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
            dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
        }
        Default {
            Write-Error "You can only use bash or mingw as type.";
            exit;
        }
    }
}

if ($command -eq "bash") {
    $configure = "/mnt$($configure.ToLower())"
}

# if (!(Get-Command $command -errorAction SilentlyContinue)) { 
#     Write-Error "Installation has been finished however you may need to restart your terminal/powershell?"
#     exit;
# }

[Console]::Error.Write("NEXSS/info:Source path: $srcFolder")    
[Console]::Error.Write("NEXSS/info:Using $command to configure. Configuring..")     
[Console]::Error.Write("NEXSS/info:Package will be installed: $destination") 

cd $destination

# if (test-path "$destination/Makefile") {
#     [Console]::Error.Write("NEXSS/info: (ommiting configure) Package is already configured in: $destination") 
# }
# else {
#     & $command "$configure"
#     [Console]::Error.Write("NEXSS/ok:Package has been configured with $command in: $destination") 
# }

$configureScript = "$($NexssStdout.cwd)\src\configureMake.sh"


$wslConfigureScript = $(wsl wslpath -a "'$configureScript'")
$wslConfigureScript = ($wslConfigureScript -replace "/mnt/", "/")

$wslSrcFolder = $(wsl wslpath -a "'$srcFolder'")
$wslSrcFolder = ($wslSrcFolder -replace "/mnt/", "/")

$destination = "/" + (($destination -replace "\\", "/") -replace ":", "")
$wslDestination = ($destination -replace "/mnt/", "/")

mingw "$wslConfigureScript" "$folder" "$wslSrcFolder" "$wslDestination" 
# $configureScript = "/mnt/" + (($configureScript -replace "\\", "/") -replace ":", "");
# & $command  -c -i $configure
# & $command  -c -i make
# & bash $configureScript
# Modify Data
$NexssStdout | Add-Member -Force -NotePropertyMembers @{PowerShellOutput = "OutputFromPowershell" + $PSVersionTable.PSVersion }


# STDOUT
Write-Host (ConvertTo-Json -Compress $NexssStdout)
