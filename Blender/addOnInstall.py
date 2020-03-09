# nexss-compiler: blender --background
import sys
import os
sys.path.append(os.getenv("NEXSS_PACKAGES_PATH") + "\\Nexss\\Lib\\")
from NexssIn import *
import NexssZip
import bpy
import NexssBlender

if "nxsIn" in NexssStdout:
    addOnFile = NexssStdout['nxsIn'][0]
    try:
        addOnName = NexssStdout['nxsIn'][1]
    except IndexError:
        if NexssZip.isZip(addOnFile):
            # We get first folder
            addOnName = NexssZip.listRootDirs(addOnFile)[0]
        else:
            # This is just python file
            addOnName = addOnFile

    # print(NexssBlender.addonsInstalled())
    NexssBlender.addonInstall(addOnFile, addOnName)
else:
    nxsError("Enter AddOn path and(optional) Addon Id.")
    sys.exit()


import json
NexssStdout = json.dumps(NexssStdout, ensure_ascii=False).encode('utf8','surrogateescape')
# STDOUT
print(NexssStdout.decode('utf8','surrogateescape'))
