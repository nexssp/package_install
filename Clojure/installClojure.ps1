
$input | . "$($env:NEXSS_PACKAGES_PATH)/Nexss/Lib/NexssIn.ps1"

iwr -useb download.clojure.org/install/win-install-1.10.1.547.ps1 | iex

nxsInfo("Done.")