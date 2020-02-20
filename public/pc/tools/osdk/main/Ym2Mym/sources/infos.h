/*

Change history for the Ym2Mym

0.1 - 30.1.2000 
- Marq/Lieves!Tuore & Fit (marq@iki.fi)

0.2 - 3.2.2000  
- Added a rude YM5 loader. Skips most of the header.

1.0 - 2013/12/18
- Added support for retuning (Atari ST songs are at 2mhz, Amstrad ones at 1mhz, ZX Spectrum at 1.7734mz)
- Added rude support for YM6 format (also skips most of the header)

1.1 - 2014/01/12
- The tool is now able to extract LHA compressed YM files directly, should make the process much easier :)

1.2 - 2014/01/13 [Broken do not use]
- Added a -v flag to enable/disable verbosity
- Added a -h flag to add a tape compatible header

1.3 - 2014/01/13 [Broken do not use]
- Added a -m flag to check if the exported file fits a maximum size

1.4 - 2014/01/14
- Fixed a stupid bug of signed data added in version 1.2

1.5 - 2014/12/06
- The verbose mode (-v1) now displays the embedded informations such as author name, song name, and extra comments
- Interleave register format is now also supported

1.6 - 2015/05/29
- Added a -d flag that can be used to shorten a music. "-dt" truncates the music, "-df" fades it out. (example: -dt50 will cut the music after 1 second - 50 frames - )

1.7 - 2015/05/29
- Added a -f flag that can be used to export the music to WAV format instead of MYM

1.8 - 2020/01/18
- Modified the semantics of the -t flag (now means Target Frequency) and added a -r flag (Reference Frequency) which both accept decimal values (like 1.0, 2.0 or 1.77340)

*/



#define TOOL_VERSION_MAJOR	1
#define TOOL_VERSION_MINOR	8

