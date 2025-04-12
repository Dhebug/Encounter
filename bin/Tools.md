# Tools

There are big discussions about putting binaries in a source code repository.

My take on that is that it makes sense to limit the external dependencies as much as possible, if only because they can disappear, tools can get updated and become incompatible, and it's a real pain to find what to use if you revisit a project a few years later.

# OSDK 
Most of the Encounter build process is done using the **OSDK**.

**_build.bat** and **_build_pass.bat** are part of the build process.

**_PictConv.bat** is part of the asset generation in the build process.

You can find the OSDK here: https://osdk.org


# Arkos tools
Both **SongToAky.exe** and **SongToEvents.exe** are part of the **Arkos Tracker 2** (from Julien Nevo) and are used to export the Arkos tracker songs into runtime friendly formats.

**_ArkosConv.bat** is just a small script that calls these executables as part of the build process.

You can find the Arkos Tracker here: https://www.julien-nevo.com/arkostracker/


# HxC tools

**hxcfe.exe**, **libhxcfe.dll** and **libusbhxcfe.dll** are part of the **HxC Floppy Emulator** software suite (from Jean-François DEL NERO) and are used to convert the Oric **DSK** image files into **HFE** format usable on Cumana Reborn as well as on HxC Floppy Emulator or Gotek devices.

You can find the HxC project here: https://hxc2001.com

The license for the tool can be found by running **hxcfe.exe -license**



