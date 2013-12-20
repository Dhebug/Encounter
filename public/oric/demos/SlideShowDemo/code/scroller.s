


	.dsb 256-(*&255)
	
; // - Entry #23 '..\build\files\font_24x20.hir ' loads at address 40960 starts on the second side on track 2 sector 9 and is 19 sectors long (4800 bytes).	
; 20*3=60
_FontBuffer	.dsb 4864			; 19*256 (Because it loads full sectors...)

	.dsb 256-(*&255)

_ScrollBuffer_0	.dsb 128*20
_ScrollBuffer_1	.dsb 128*20
_ScrollBuffer_2	.dsb 128*20
_ScrollBuffer_3	.dsb 128*20
_ScrollBuffer_4	.dsb 128*20
_ScrollBuffer_5	.dsb 128*20


_ScrollerMessage
	.byt "WELCOME TO THE DEFENCE FORCE SLIDE SHOW"


_ScrollerGenerate
.(
	lda _ScrollerMessage,x

	rts
.)

; Using the 24x20 font, each letter is 3 bytes large (in practice the largest is 20 pixels wide)
; Say a buffer 128 bytes large
; 128/3 bytes=42 characters large
; "WELCOME TO THE DEFENCE FORCE SLIDE SHOW" <- That's about 40 characters :S
; 128*20=2560
; 2560*6=15360
;



/*
 Fonts infos: http://cgi.algonet.se/htbin/cgiwrap?user=guld1&script=fonts.pl

Some scroll computation.

Say we have a 32x24 font

Displaying this message: "WELCOME TO DEFENCE FORCE ULTIMATE SLIDE DISK MUSIC SHOW, HOPE YOU WILL ENJOY IT!!!" (83 characters)
would use:
83*32=2656 pixels
2656/240=about 11 screens wide,
2656/50 =about 53 seconds scrolling time (at one pixel per frame - which is super slow)

2656/32 =83 bytes wide
83*24=1992 bytes for one scroll buffer
1992*6=11952 bytes for six preshifted buffers


32/6=5.3
5*6=30
6*6=36

Miriam's choices:
- millitary_15
- spaz_20 (19x20 plus spacing)
- classic_21_nice

Me:
- outline_24


*/

