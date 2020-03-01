param
(
    [Parameter(Mandatory)]
    # [ValidateScript( { Test-Path $_ -PathType leaf })]
    [Alias("F")] 
    [string]$File,
    # [ValidateScript( { Test-Path $_ -PathType container })]
    [Parameter(Mandatory)]
    [Alias("P")] 
    [string]$Path, # = "$HOME\.nexssPROApps\TclTk",
    [Parameter()]
    [Alias("B")] 
    [string]$Bin = "bin",
    [Parameter()]
    [Alias("L")] 
    [string]$Log,
    [Parameter()]    
    [switch]$CreateDir
)
$ErrorActionPreference = 'Stop'
function Write-Error($message) {
    [Console]::ForegroundColor = 'yellow'
    [Console]::Error.WriteLine($message)
    [Console]::ResetColor()
}

if (!(Test-Path $File -PathType leaf)) {
    if ($File) {
        Write-Error "$File  has not been found."
    }
    else {
        Write-Error "First/-File parameter is mendatory and must exist."
    } 
    exit
}
else {
    if (!($File -Like "*.msi" -or $File -Like "*.exe")) {
        Write-Error "First/-File parameter must be .msi or .exe file type.";
        exit
    }
}

if (!(Test-Path $Path -PathType container)) {
    if ($Path) {
        if ($CreateDir) {
            Write-Host "Creating new directory.. $Path"
            New-Item -ItemType Directory -Path $Path | Out-Null
        }
        else {
            Write-Error "$Path has not been found. Correct the path: $Path or use -CreateDir"
            exit
        }  
    }
    else {
        Write-Error "Where you want to install the application? -Path parameter is mendatory and must exist."
        exit
    }   
}

$installCommand = ( -join ('/i "', "$File", '"', " APPLICATIONFOLDER=`"$Path`"", " /passive /norestart"))

# LOGDIR
if ($Log) {
    $installCommand = ( -join ($installCommand, " /L*V $Log"))
    Write-Host "Log file will be at $Log" 
}

Write-Host "Command: $installCommand"
Write-Host "Installing application to $Path" 
Start-Process msiexec.exe $installCommand -Wait

# Bin handling
$binFolder = Join-Path $Path $Bin
if (!(Test-Path $binFolder )) {
    Write-Host "bin folder: $binFolder does not exist and won't be added to the system path."
    exit
}
else {
    Write-Host "bin folder does exist. We add to the system path: $binFolder"
    if (!($([System.Environment]::GetEnvironmentVariable("Path", "User") ).ToLower().Contains($($binFolder).ToLower()) -eq $true)) { 
        nxsInfo("Adding $path to the users PATH environment variable.") 
        [System.Environment]::SetEnvironmentVariable("Path", $binFolder + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User"), "User")
    }

    Write-Host "Reloading System Vars"
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User") 
}

