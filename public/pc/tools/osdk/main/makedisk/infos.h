

#define TOOL_VERSION_MAJOR	0
#define TOOL_VERSION_MINOR	11

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

*/
