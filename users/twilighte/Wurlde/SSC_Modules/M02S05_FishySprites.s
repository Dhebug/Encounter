;Fish Animation frames and water disturbance frames

;Fish Frame Pointers - contains a list of the frames to use for a particular route through the air (like arc right)
;The end of the animation sequence is flagged with a minus (128)
FishPath_RightArc
 .byt 0,1,2,3,4                         ;Rising bubbles(5)
 .byt 0,1,2,3,4                         ;Rising bubbles(5)
 .byt 0,1,2,3,4                         ;Rising bubbles(5)
 .byt 5,6,7,8,9                         ;Fish rising(5)
 .byt 10+64,11+64,10+64,11+64,10+64,11+64,10+64,11+64,10+64,11+64     ;Fish ascension(10)
 .byt 12+64,13+64,14+64,15+64,16+64,17+64,18+64,19+64,20+64,21+64,22+64  ;Fish turning 180(11)
 .byt 23+64,24+64,23+64,24+64,23+64,24+64,23+64,24+64,23+64,24+64     ;Fish descension(10)
 .byt 25,26,27,128			;Fish reenters with splash(4)


;Fish Frame Address Tables - Index by frame to get each frame memory address
FishFrameAddressTableLo
 .byt <FishFrame00
 .byt <FishFrame01
 .byt <FishFrame02
 .byt <FishFrame03
 .byt <FishFrame04
 .byt <FishFrame05
 .byt <FishFrame06
 .byt <FishFrame07
 .byt <FishFrame08
 .byt <FishFrame09
 .byt <FishFrame10
 .byt <FishFrame11
 .byt <FishFrame12
 .byt <FishFrame13
 .byt <FishFrame14
 .byt <FishFrame15
 .byt <FishFrame16
 .byt <FishFrame17
 .byt <FishFrame18
 .byt <FishFrame19
 .byt <FishFrame20
 .byt <FishFrame21
 .byt <FishFrame22
 .byt <FishFrame23
 .byt <FishFrame24
 .byt <FishFrame25
 .byt <FishFrame26
 .byt <FishFrame27

FishFrameAddressTableHi
 .byt >FishFrame00
 .byt >FishFrame01
 .byt >FishFrame02
 .byt >FishFrame03
 .byt >FishFrame04
 .byt >FishFrame05
 .byt >FishFrame06
 .byt >FishFrame07
 .byt >FishFrame08
 .byt >FishFrame09
 .byt >FishFrame10
 .byt >FishFrame11
 .byt >FishFrame12
 .byt >FishFrame13
 .byt >FishFrame14
 .byt >FishFrame15
 .byt >FishFrame16
 .byt >FishFrame17
 .byt >FishFrame18
 .byt >FishFrame19
 .byt >FishFrame20
 .byt >FishFrame21
 .byt >FishFrame22
 .byt >FishFrame23
 .byt >FishFrame24
 .byt >FishFrame25
 .byt >FishFrame26
 .byt >FishFrame27

;Fish Frames - Each frame contains header and data sections

;Header..
;+00 Fish Frame Width (Bytes)
;+01 Fish Frame Height (odd Pixels)
;+02 Fish X Step (2's Compliment)
;+03 Fish Y Step (2's Compliment)

;Bubble frames are plotted directly to screen and use both even and odd lines
FishFrame00	;Bubbles
 .byt 2,4,255,255
 .byt 7,%01000000
 .byt 3,%01000000
 .byt 6,%01000000
 .byt 2,%01001000
FishFrame01	;Bubbles
 .byt 2,4,255,255
 .byt 7,%01000000
 .byt 3,%01000000
 .byt 6,%01000100
 .byt 2,%01000000
FishFrame02	;Bubbles
 .byt 2,4,255,255
 .byt 7,%01000000
 .byt 3,%01001000
 .byt 6,%01000000
 .byt 2,%01000000
FishFrame03	;Bubbles
 .byt 2,4,255,255
 .byt 7,%01000100
 .byt 3,%01000000
 .byt 6,%01000000
 .byt 2,%01000000
FishFrame04	;Bubbles
 .byt 2,4,255,255
 .byt 7,%01000000
 .byt 3,%01000000
 .byt 6,%01000000
 .byt 2,%01000000

;Rising fish follow on from bubbles and so still observe full res
FishFrame05	;Rising Fish
 .byt 2,4,255,255
 .byt 7,%01000000
 .byt 3,%01000000
 .byt 6,%01000000
 .byt 6,%01010000
FishFrame06	;Rising Fish
 .byt 2,4,255,255
 .byt 7,%01000000
 .byt 3,%01000000
 .byt 6,%01010000
 .byt 5,%01010000
FishFrame07	;Rising Fish
 .byt 2,4,255,255
 .byt 7,%01000000
 .byt 6,%01010000
 .byt 5,%01011000
 .byt 5,%01001000
FishFrame08	;Rising Fish
 .byt 2,4,255,255
 .byt 6,%01010000
 .byt 5,%01011000
 .byt 5,%01011000
 .byt 5,%01001000
FishFrame09	;Rising Fish
 .byt 2,5,255,253
 .byt 7,%01010000	;This row now out of water
 .byt 5,%01011000
 .byt 5,%01110000
 .byt 5,%01011000
 .byt 5,%01101000

FishFrame10	;Flying Fish (odd lines only) For vertical ascension we alternate between this and the next frame
 .byt 2,4,255,251
 .byt 7,%01010000

 .byt 1,%01110000

 .byt 5,%01011000

 .byt 1,%01101000
FishFrame11	;Flying Fish (odd lines only)
 .byt 2,4,255,251
 .byt 7,%01010000

 .byt 1,%01011000

 .byt 5,%01110000

 .byt 1,%01010100

FishFrame12	;Still flying fish but now gradual angling from vertical ascension to horizontal right
 .byt 2,5,255,253
 .byt 7,%01000100

 .byt 1,%01011000

 .byt 5,%01110000

 .byt 5,%01011000

 .byt 1,%01101000
FishFrame13
 .byt 2,5,255,253
 .byt 7,%01000001

 .byt 1,%01000110

 .byt 5,%01000110

 .byt 1,%01001100

 .byt 1,%01010100
FishFrame14
 .byt 3,5,255,253
 .byt 7,%01000000,%01000100

 .byt 1,%01000000,%01011000

 .byt 1,%01000001,%01110000

 .byt 5,%01000011,%01000000

 .byt 1,%01001010,%01000000
FishFrame15
 .byt 3,4,0,253
 .byt 7,%01000000,%01010000

 .byt 1,%01000001,%01100000

 .byt 5,%01001110,%01000000

 .byt 1,%01101000,%01000000
FishFrame16
 .byt 3,4,0,255
 .byt 7,%01000000,%01100000

 .byt 1,%01100111,%01000000

 .byt 5,%01001100,%01000000

 .byt 1,%01010000,%01000000
FishFrame17		;Horizontal Right
 .byt 3,3,0,255
 .byt 1,%01110000,%01000000

 .byt 5,%01011111,%01010000

 .byt 1,%01110000,%01000000

FishFrame18	;Still flying fish but now gradual angling from horizontal right to vertical descension
 .byt 3,4,0,0
 .byt 1,%01010000,%01000000	;Reverse of 16

 .byt 5,%01001100,%01000000

 .byt 1,%01100111,%01000000

 .byt 7,%01000000,%01100000
FishFrame19
 .byt 3,4,0,0
 .byt 1,%01101000,%01000000	;reverse of 15

 .byt 5,%01001110,%01000000

 .byt 1,%01000001,%01100000

 .byt 7,%01000000,%01010000
FishFrame20
 .byt 3,5,255,0
 .byt 1,%01001010,%01000000   ;reverse of 14

 .byt 5,%01000011,%01000000

 .byt 1,%01000001,%01110000

 .byt 1,%01000000,%01011000

 .byt 7,%01000000,%01000100
FishFrame21
 .byt 2,5,255,0
 .byt 1,%01010100	;Reverse of 13

 .byt 1,%01001100

 .byt 5,%01000110

 .byt 1,%01000110

 .byt 7,%01000001
FishFrame22
 .byt 2,5,255,0
 .byt 1,%01101000	;Reverse of 12

 .byt 5,%01011000

 .byt 1,%01110000

 .byt 1,%01011000

 .byt 7,%01000100
FishFrame23	;Flying Fish (odd lines only) For vertical descension we alternate between this and the next frame
 .byt 2,4,255,4
 .byt 1,%01101000	;Reverse of 10

 .byt 5,%01011000

 .byt 1,%01110000

 .byt 7,%01010000
FishFrame24
 .byt 2,4,255,3	;Reverse of 11
 .byt 1,%01010100

 .byt 5,%01110000

 .byt 1,%01011000

 .byt 7,%01010000

FishFrame25	;Splash frames as Fish reenters water (Still odd lines only)
 .byt 2,4,255,0
 .byt 1,%01010100
 .byt 5,%01011000
 .byt 1,%01001100
 .byt 7,%01101010
FishFrame26
 .byt 2,3,255,0
 .byt 1,%01010100
 .byt 7,%01111001
 .byt 7,%01001100
FishFrame27
 .byt 2,2,255,0
 .byt 7,%01010100
 .byt 7,%01011001












