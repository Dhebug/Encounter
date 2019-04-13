/*

The 6502 Linker, for the lcc or similar, that produce .s files
to be processed later by a cross assembler

List of modifications:

Change history for the Linker

0.00:
- Originaly created by Vagelis Blathras

0.56 
- Handling of lines that have more than 180 characters

0.57
- Added '-B' option to suppress inclusion of HEADER and TAIL

0.58 - January 2004
- Added filtering of all '#' directives
- Added an icon to the executable file to make it more 'OSDK' integrated :)
- Added '-F' option to enable #file directive (requires modified XA assembler)
- Modified the handling of comments to avoid crashes on C and C++ comments

0.59 - June the 4th 2006
- Corrected a bug that made it impossible to 'link' only one source file

0.63 - 2009-02-14
Fixed a number of issues in the linker:
- (WIP) The old linked filtered out comments, need to implement this feature as well
- removed some test code
- fixed the loading of symbols from the library index  file
- Fixed a problem of text file parsings. Mixed unix/dos cariage return would result in very long lines (containing many lines), leading to some crashes later on.
- Also fixed a problem in reporting the parsed files.

0.64 - 2016/01/17
- Fixed the age old problem if includes from assembler sources leading to Unresolved External errors

0.65 - 2017/03/18
- Fixed some issues in the token pattern matching used to detect labels resulting in #includes containing relative paths to be incorrectly parsed

0.66 - 2019/04/06
- The new macro file generate lines that contain multiple instructions, the linker stopped at the first encountered instruction, this new version correctly parses that

*/



#define TOOL_VERSION_MAJOR	0
#define TOOL_VERSION_MINOR	66
