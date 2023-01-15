' Set a few defines that can be useful
#define TextStart #BB80
#define ScreenWidth 40

#define Paper 16

#define Red 1
#define Green 2


10 '
20 ' This shows how to use
30 ' symbolic names instead
40 ' of hardcoded values
50 '
60 ' RED PAPER on top left
60 POKE#BB80,16+1
70 ' and GREEN PAPER next
80 POKE TextStart+1,Paper+Green



