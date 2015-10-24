/*

Change history for the FloppyBuilder

0.2 - Makedisk (c) 2002 Jérome Debrune, used on all Defence Force demos until 2013
0.3 - 2013/11/24
- Work started in 2013 by Mickaël Pointier for the Oric 30th birthday

0.5 - 2013/12/12
- Fixed parsing of comments
- added a 'OutputFloppyFile' command
- validated that the number of sectors and tracks is correct in the 'SetPosition' command.
- removed some unused variables
- cleaned the offset/track/sector management code
- the 'SetBootSector' command is now 'WriteSector' and automatically move to the next sector after writing data

0.6 - 2013/12/14
- Added the 'LoadDiskTemplate' and 'DefineDisk' commands (and removed these parameters from the command line)
- Added the 'AddTapFile' command, similar to 'AddFile' but automatically removes the header and extract the start address of the file

0.7 - 2013/12/14
- The code now automatically compute the gaps values based on the floppy structure parameters
- The 'DefineDisk' command now works (at least for 2 sided, 42 tracks and 17 sectors floppies)

0.8 - 2013/12/15
- Cleaned up a bit the output description generation

0.9 - 2013/12/15
- Added the 'SetCompressionMode' command. Possible parameters are 'None' (default value) and 'FilePack'

0.10 - 2013/12/17
- The compression code now generates correct data (it was using the Atari ST mode encoding, making the unpacking code not happy)
- Added to the report file the occupation ratio of the floppy (by maintaining an internal list of used sectors also used to check if there's no overlap)

0.11 - 2013/12/19
- Added support for metadata that can be used later on by the programmer

0.12 - 2013/12/27
- The 'DefineDisk' command accepts a variable set of track definition values

0.13 - 2014/01/08
- Added a new parameter to make it possible to bootstrap the floppy building process: With 'init' a description fill be generated even if data is missing,
this makes it possible to do a multi-pass build process which will not fail because it depends on things not yet generated :)

0.14 - 2014/01/08
- The MetaData tables will now not contain any information after the last file that declared metadata, this allows to not waste room in the loader for dummy data

0.15 - 2014/01/08
- The output file now clearly states how much free room is available in bytes on the disk

0.16 - 2014/04/06
- Added a mode where data can be extracted from an existing DSK file
- The parser now accepts quoted strings

0.17 - 2015/05/29
- A macro expansion now accept the new value {FileSize} which gets expanded to the size of the previous file inserted in the script

0.18 - 2015/08/15
- Added a 'ReserveSectors' command that can be used to leave room on the disk for save games or stuff like that.

*/

#define TOOL_VERSION_MAJOR	0
#define TOOL_VERSION_MINOR	18
