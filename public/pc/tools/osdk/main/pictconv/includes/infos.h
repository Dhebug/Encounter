/*

Change history for the PictConv



Version 0.1
- First beta release

Version 0.2
- New version with basic dithering

Version 0.3
- Riemersman dithering implemented 

Version 0.4
- Allow free size pictures (bigger than screen size except for colored mode)

Version 0.5
- Debugged the -o6 format.
- Debugged the -f1 mode.

Version 0.6
- A message is given if the picture is not found or invalid.
- Colored mode had some bugs: all now corrected ???

Version 0.7
- Removed the timer check in the colored conversion mode. It was producing bad conversion on slow computers. Anyway, if you are unlucky, a conversion could now take hours to perform if the tool has to perform ALL possible combinations. 

Version 0.8
- Added "test" mode that's usefull to debug a picture in colored mode 

Version 0.9
- New option for generating 'masks' in bits 6 and 7 based on what is presents in bits 0/1/2 and 3/4/5.
(Twilighte's request for his new games)
- Added a way to convert pictures to something that can be used on an Atari ST.
(needed that for my entry to the 20 years anniversary Atari ST compo)

Version 0.10
- If there is something specified after -o3 or -o4 modes, it's used as a label name to use when generating source code data.
- If there is a 'z' specified after -f0 mode (monochrome conversion), it means that bit 6 should not be set in converted bytes
- Added -n switch to set the number of values per line (stolen from Bin2Txt !)

Version 0.11
- Added the -o7 format to generate BASIC source codes.
- Removed the constraints in the -f1 mode, pictures just need to be multiple of 6 in width, and no more than 240 pixel wide. 

Version 0.12
- Lot of modifications in the codebase to handle more cleanly the various types of machines.
- The Atari ST now can generate multi-palette pictures.
- Color reduction is now done by PictConv, no need to reduce to 16 colors manually.

Version 0.13
- It is now possible to lock some colors index to some particular values.

Version 0.14
- ?

Version 0.15
- ?

Version 0.16
- New option to skip the conversion if the target file is more recent than the source file (-u)
- New option to enable/disable information about what happens (-v)

Version 0.17
- Fixed a the update code, was failing if the target file did not exist (facepalm)

Version 0.18
- Added the -f6 conversion mode for Oric pictures. This is the method used in Img2Oric/LibPipi and generally gives much better results when converting - albeit much much slower than other methods.

Version 0.19
- Fixed a buffer overflow in the -f6 conversion mode happening when images are not 240x200
- Changed the depth mode from 3 to 2 to speed-up the conversion

Version 0.20
- The -f6 mode can now be used for pictures that are taller than the screen
- Fixed the percentage calculation so it actually goes from 0 to 100 even when pictures are not 200 pixel tall.

Version 0.21
- Added support for 32bit picture, to handle things like masking/opacity in the picture formats
- The -a1 mode will generate bytes with null value for blocks of 6 pixels with transparent alpha values (only active in monochrome or AIC conversion modes)
- Added the -f7 conversion mode for Oric pictures using the AIC coloring method.

Version 0.22
- Fixed the -f5 (charmap generator) to work correctly without crashing.
- Inverted -o0 and -o1 in the description of commands (issue #3)

Version 0.23
- Added the -f2 option to the Atari ST converter, with support for monochrome pictures
- Added the -s1 option to generate two pictures that can be swapped each frame to generate more colors

Version 0.24
- Fixed a problem in the color reduction code failing on a 32bit source image

*/

#define TOOL_VERSION_MAJOR	0
#define TOOL_VERSION_MINOR	24
