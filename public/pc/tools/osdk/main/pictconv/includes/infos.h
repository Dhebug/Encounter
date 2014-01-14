/*

Change history for the PictConv



Version 0.001
- First beta release

Version 0.002
- New version with basic dithering

Version 0.003
- Riemersman dithering implemented 

Version 0.004
- Allow free size pictures (bigger than screen size except for colored mode)

Version 0.005
- Debugged the -o6 format.
- Debugged the -f1 mode.

Version 0.006
- A message is given if the picture is not found or invalid.
- Colored mode had some bugs: all now corrected ???

Version 0.007
- Removed the timer check in the colored conversion mode. It was producing bad conversion on slow computers. Anyway, if you are unlucky, a conversion could now take hours to perform if the tool has to perform ALL possible combinations. 

Version 0.008
- Added "test" mode that's usefull to debug a picture in colored mode 

Version 0.009
- New option for generating 'masks' in bits 6 and 7 based on what is presents in bits 0/1/2 and 3/4/5.
(Twilighte's request for his new games)
- Added a way to convert pictures to something that can be used on an Atari ST.
(needed that for my entry to the 20 years anniversary Atari ST compo)

Version 0.010
- If there is something specified after -o3 or -o4 modes, it's used as a label name to use when generating source code data.
- If there is a 'z' specified after -f0 mode (monochrome conversion), it means that bit 6 should not be set in converted bytes
- Added -n switch to set the number of values per line (stolen from Bin2Txt !)

Version 0.011
- Added the -o7 format to generate BASIC source codes.
- Removed the constraints in the -f1 mode, pictures just need to be multiple of 6 in width, and no more than 240 pixel wide. 

Version 0.012
- Lot of modifications in the codebase to handle more cleanly the various types of machines.
- The Atari ST now can generate multi-palette pictures.
- Color reduction is now done by PictConv, no need to reduce to 16 colors manually.

Version 0.013
- It is now possible to lock some colors index to some particular values.

Version 0.014
- ?

Version 0.015
- ?

Version 0.016
- New option to skip the conversion if the target file is more recent than the source file (-u)
- New option to enable/disable information about what happens (-v)

Version 0.017
- Fixed a the update code, was failing if the target file did not exist (facepalm)

*/

#define TOOL_VERSION_MAJOR	0
#define TOOL_VERSION_MINOR	17

