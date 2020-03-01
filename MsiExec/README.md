# Configure

Using ./configure and bash(wsl), msys or migw. Now only Mingw supported

## Examples

```yml
data:
  configureAppName: Tcl # default to app
  configureSourcePath: c:\Users\mapoart\.nexss\cache\downloads\tcl8610-src
  configureSubPath: tcl8.6.10/win
  configureBinFilePath: bin/tclsh86.exe
  # configureDestination: bin/tclsh86.exe # optional default to NEXSS_APPS_PATH/$configureSubPath
  # best to use automatic but you can change it if you like.
  # Make sure you know what you are doing as you can overwrite your other apps..
```

## Parameters

**--downloadPathCache** - will download to the cache folder (not the current folder)
**--donwloadNocache** - will not use cache and re-download if already exists.
