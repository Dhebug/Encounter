#import "build/symbols"

10 ' This is an example that calls
20 ' an assembler routine from a 
30 ' BASIC program by name.
55 HIMEM#7FFF:CLOAD"" ' Load module
60 PRINT "This is some Text displayed in BASIC"
70 PRINT "And the italics effect is done by "
80 PRINT "calling an ASM routine."
90 CALL MakeItalics ' Italics!
