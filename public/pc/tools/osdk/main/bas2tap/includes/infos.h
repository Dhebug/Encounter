 /*

Change history for the Bas2Tap

0.1 - First version, based on Fabrice Frances Txt2Bas

0.2 - 2014/03/16
- Fixed the missing byte that lead to Oricutron failing to load some basic files

1.0 - 2018/03/11
- Added the handling of token codes over 246 to allow the dump of corrupted files, these will have a CORRUPTED_ERROR_CODE_nnn message at the location of the corrupted data (in this particular case it was the game ENCOUNTER from Severn Software at line 11150 having a "NEXT WITHOUT FOR" message displayed
- Fixed the program so it can output to a file instead of stdout

1.1 - 2018/04/07
- Added filtering of strings before parsing, to remove superfluous spaces, tabs and other carriage returns before starting the syntax conversion pass

1.2 - 2018/06/25
- Support for pure comments without line numbers (accepts lines starting by ' or ; or //)

*/


#define TOOL_VERSION_MAJOR	1
#define TOOL_VERSION_MINOR	2

