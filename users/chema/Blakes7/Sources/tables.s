;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ------------------------------------------
;;                 OASIS
;; Oric Adventure Script Interpreting System
;; ------------------------------------------
;;	       (c) Chema 2015
;;            enguita@gmail.com
;; ------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#include "params.h"
#include "object.h"
#include "language.h"

#define MAX_THREADS 16

; Some useful tables

; For x8
; WARNING: if FULLTABLEMUL8 is defined, it stores the result of all 8-bit values x8, 
; using 512 bytes!
#ifdef FULLTABLEMUL8
tab_mul8hi
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
#endif
tab_mul8
	.byt 0
	.byt 8
	.byt 16
	.byt 24
	.byt 32
	.byt 40
	.byt 48
	.byt 56
	.byt 64
	.byt 72
	.byt 80
	.byt 88
	.byt 96
	.byt 104
	.byt 112
	.byt 120
	.byt 128
	.byt 136
	.byt 144
	.byt 152
	.byt 160
	.byt 168
	.byt 176
	.byt 184
	.byt 192
	.byt 200
	.byt 208
	.byt 216
	.byt 224
	.byt 232
	.byt 240
	.byt 248
#ifdef FULLTABLEMUL8
	.byt 0
	.byt 8
	.byt 16
	.byt 24
	.byt 32
	.byt 40
	.byt 48
	.byt 56
	.byt 64
	.byt 72
	.byt 80
	.byt 88
	.byt 96
	.byt 104
	.byt 112
	.byt 120
	.byt 128
	.byt 136
	.byt 144
	.byt 152
	.byt 160
	.byt 168
	.byt 176
	.byt 184
	.byt 192
	.byt 200
	.byt 208
	.byt 216
	.byt 224
	.byt 232
	.byt 240
	.byt 248
	.byt 0
	.byt 8
	.byt 16
	.byt 24
	.byt 32
	.byt 40
	.byt 48
	.byt 56
	.byt 64
	.byt 72
	.byt 80
	.byt 88
	.byt 96
	.byt 104
	.byt 112
	.byt 120
	.byt 128
	.byt 136
	.byt 144
	.byt 152
	.byt 160
	.byt 168
	.byt 176
	.byt 184
	.byt 192
	.byt 200
	.byt 208
	.byt 216
	.byt 224
	.byt 232
	.byt 240
	.byt 248
	.byt 0
	.byt 8
	.byt 16
	.byt 24
	.byt 32
	.byt 40
	.byt 48
	.byt 56
	.byt 64
	.byt 72
	.byt 80
	.byt 88
	.byt 96
	.byt 104
	.byt 112
	.byt 120
	.byt 128
	.byt 136
	.byt 144
	.byt 152
	.byt 160
	.byt 168
	.byt 176
	.byt 184
	.byt 192
	.byt 200
	.byt 208
	.byt 216
	.byt 224
	.byt 232
	.byt 240
	.byt 248
	.byt 0
	.byt 8
	.byt 16
	.byt 24
	.byt 32
	.byt 40
	.byt 48
	.byt 56
	.byt 64
	.byt 72
	.byt 80
	.byt 88
	.byt 96
	.byt 104
	.byt 112
	.byt 120
	.byt 128
	.byt 136
	.byt 144
	.byt 152
	.byt 160
	.byt 168
	.byt 176
	.byt 184
	.byt 192
	.byt 200
	.byt 208
	.byt 216
	.byt 224
	.byt 232
	.byt 240
	.byt 248
	.byt 0
	.byt 8
	.byt 16
	.byt 24
	.byt 32
	.byt 40
	.byt 48
	.byt 56
	.byt 64
	.byt 72
	.byt 80
	.byt 88
	.byt 96
	.byt 104
	.byt 112
	.byt 120
	.byt 128
	.byt 136
	.byt 144
	.byt 152
	.byt 160
	.byt 168
	.byt 176
	.byt 184
	.byt 192
	.byt 200
	.byt 208
	.byt 216
	.byt 224
	.byt 232
	.byt 240
	.byt 248
	.byt 0
	.byt 8
	.byt 16
	.byt 24
	.byt 32
	.byt 40
	.byt 48
	.byt 56
	.byt 64
	.byt 72
	.byt 80
	.byt 88
	.byt 96
	.byt 104
	.byt 112
	.byt 120
	.byt 128
	.byt 136
	.byt 144
	.byt 152
	.byt 160
	.byt 168
	.byt 176
	.byt 184
	.byt 192
	.byt 200
	.byt 208
	.byt 216
	.byt 224
	.byt 232
	.byt 240
	.byt 248
	.byt 0
	.byt 8
	.byt 16
	.byt 24
	.byt 32
	.byt 40
	.byt 48
	.byt 56
	.byt 64
	.byt 72
	.byt 80
	.byt 88
	.byt 96
	.byt 104
	.byt 112
	.byt 120
	.byt 128
	.byt 136
	.byt 144
	.byt 152
	.byt 160
	.byt 168
	.byt 176
	.byt 184
	.byt 192
	.byt 200
	.byt 208
	.byt 216
	.byt 224
	.byt 232
	.byt 240
	.byt 248
#endif

_YM_FREQUENCIESHI
.byt 14,14,13,12,11,11,10,9,9,8,8,7,7,7,6,6,5,5,5,4,4,4,4,3,3,3,3,3,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
_YM_FREQUENCIESLO
.byt 239,25,78,141,218,47,143,247,104,225,97,233,119,12,167,71,237,152,71,252,180,112,49,244,188,134,83,36,246,204,164,126,90,56,24,250,222,195,170,146,123,102,82,63,45,28,12,253,239,225,213,201,190,179,169,159,150,142,134,127,119,113,106,100,95,89,84,80,75,71,67,63,60,56,53,50,47,45,42,40,38,36,34,32,30,28,27,25,24,22,21,20,19,18,17,16,15,14,13,13


tab_bit8
	.byt %10000000
	.byt %01000000
	.byt %00100000
	.byt %00010000
	.byt %00001000
	.byt %00000100
	.byt %00000010
	.byt %00000001

#define AS_SIZE 35
tab_animstate_offsets_hi
	.byt >(0*AS_SIZE),>(1*AS_SIZE),>(2*AS_SIZE),>(3*AS_SIZE),>(4*AS_SIZE),>(5*AS_SIZE),>(6*AS_SIZE),>(7*AS_SIZE),>(8*AS_SIZE),>(9*AS_SIZE),>(10*AS_SIZE),>(11*AS_SIZE),>(12*AS_SIZE),>(13*AS_SIZE),>(14*AS_SIZE),>(15*AS_SIZE)


_TableDiv6              
	.byt 0,0,0,0,0,0	; 0
	.byt 1,1,1,1,1,1	; 6
	.byt 2,2,2,2,2,2	; 12
	.byt 3,3,3,3,3,3	; 18
	.byt 4,4,4,4,4,4	; 24
	.byt 5,5,5,5,5,5	; 30
	.byt 6,6,6,6,6,6	; 36
	.byt 7,7,7,7,7,7	; 42
	.byt 8,8,8,8,8,8	; 48
	.byt 9,9,9,9,9,9	; 54
	.byt 10,10,10,10,10,10	; 60 
	.byt 11,11,11,11,11,11	; 66 
	.byt 12,12,12,12,12,12	; 72 
	.byt 13,13,13,13,13,13	; 78 
	.byt 14,14,14,14,14,14	; 84 
	.byt 15,15,15,15,15,15	; 90 
	.byt 16,16,16,16,16,16	; 96 
	.byt 17,17,17,17,17,17	; 102
	.byt 18,18,18,18,18,18	; 108
	.byt 19,19,19,19,19,19	; 114
	.byt 20,20,20,20,20,20	; 120
	.byt 21,21,21,21,21,21	; 126
	.byt 22,22,22,22,22,22	; 132
	.byt 23,23,23,23,23,23	; 138
	.byt 24,24,24,24,24,24	; 144
	.byt 25,25,25,25,25,25	; 150
	.byt 26,26,26,26,26,26	; 156
	.byt 27,27,27,27,27,27	; 162
	.byt 28,28,28,28,28,28	; 168
	.byt 29,29,29,29,29,29	; 174
	.byt 30,30,30,30,30,30	; 180
	.byt 31,31,31,31,31,31	; 186
	.byt 32,32,32,32,32,32	; 192
	.byt 33,33,33,33,33,33	; 198
	.byt 34,34,34,34,34,34	; 204
	.byt 35,35,35,35,35,35	; 210
	.byt 36,36,36,36,36,36	; 216
	.byt 37,37,37,37,37,37	; 222
	.byt 38,38,38,38,38,38	; 228
	.byt 39,39,39,39,39,39	; 234

; Tables of x*Animatory state sizxe, x=[0..15] for calculating offsets to animatory states. Used in core.s
; defined just for the 15 current animatory states. Should be made larger up to the max
; animatory states allowed.

tab_animstate_offsets_lo
	.byt <(0*AS_SIZE),<(1*AS_SIZE),<(2*AS_SIZE),<(3*AS_SIZE),<(4*AS_SIZE),<(5*AS_SIZE),<(6*AS_SIZE),<(7*AS_SIZE),<(8*AS_SIZE),<(9*AS_SIZE),<(10*AS_SIZE),<(11*AS_SIZE),<(12*AS_SIZE),<(13*AS_SIZE),<(14*AS_SIZE),<(15*AS_SIZE)

	
; Tables of routines for user interaction, script commands and keycode to ascii conversions are still kept in their
; respective files

; For pixel address, scan/SRB matching, etc.
_HiresAddrLow
	.byt <((DUMP_ADDRESS)+40*0), <((DUMP_ADDRESS)+40*1), <((DUMP_ADDRESS)+40*2), <((DUMP_ADDRESS)+40*3), <((DUMP_ADDRESS)+40*4), <((DUMP_ADDRESS)+40*5), <((DUMP_ADDRESS)+40*6), <((DUMP_ADDRESS)+40*7)
	.byt <((DUMP_ADDRESS)+40*8), <((DUMP_ADDRESS)+40*9), <((DUMP_ADDRESS)+40*10), <((DUMP_ADDRESS)+40*11), <((DUMP_ADDRESS)+40*12), <((DUMP_ADDRESS)+40*13), <((DUMP_ADDRESS)+40*14), <((DUMP_ADDRESS)+40*15)
	.byt <((DUMP_ADDRESS)+40*16), <((DUMP_ADDRESS)+40*17), <((DUMP_ADDRESS)+40*18), <((DUMP_ADDRESS)+40*19), <((DUMP_ADDRESS)+40*20), <((DUMP_ADDRESS)+40*21), <((DUMP_ADDRESS)+40*22), <((DUMP_ADDRESS)+40*23)
	.byt <((DUMP_ADDRESS)+40*24), <((DUMP_ADDRESS)+40*25), <((DUMP_ADDRESS)+40*26), <((DUMP_ADDRESS)+40*27), <((DUMP_ADDRESS)+40*28), <((DUMP_ADDRESS)+40*29), <((DUMP_ADDRESS)+40*30), <((DUMP_ADDRESS)+40*31)
	.byt <((DUMP_ADDRESS)+40*32), <((DUMP_ADDRESS)+40*33), <((DUMP_ADDRESS)+40*34), <((DUMP_ADDRESS)+40*35), <((DUMP_ADDRESS)+40*36), <((DUMP_ADDRESS)+40*37), <((DUMP_ADDRESS)+40*38), <((DUMP_ADDRESS)+40*39)
	.byt <((DUMP_ADDRESS)+40*40), <((DUMP_ADDRESS)+40*41), <((DUMP_ADDRESS)+40*42), <((DUMP_ADDRESS)+40*43), <((DUMP_ADDRESS)+40*44), <((DUMP_ADDRESS)+40*45), <((DUMP_ADDRESS)+40*46), <((DUMP_ADDRESS)+40*47)
	.byt <((DUMP_ADDRESS)+40*48), <((DUMP_ADDRESS)+40*49), <((DUMP_ADDRESS)+40*50), <((DUMP_ADDRESS)+40*51), <((DUMP_ADDRESS)+40*52), <((DUMP_ADDRESS)+40*53), <((DUMP_ADDRESS)+40*54), <((DUMP_ADDRESS)+40*55)
	.byt <((DUMP_ADDRESS)+40*56), <((DUMP_ADDRESS)+40*57), <((DUMP_ADDRESS)+40*58), <((DUMP_ADDRESS)+40*59), <((DUMP_ADDRESS)+40*60), <((DUMP_ADDRESS)+40*61), <((DUMP_ADDRESS)+40*62), <((DUMP_ADDRESS)+40*63)
	.byt <((DUMP_ADDRESS)+40*64), <((DUMP_ADDRESS)+40*65), <((DUMP_ADDRESS)+40*66), <((DUMP_ADDRESS)+40*67), <((DUMP_ADDRESS)+40*68), <((DUMP_ADDRESS)+40*69), <((DUMP_ADDRESS)+40*70), <((DUMP_ADDRESS)+40*71)
	.byt <((DUMP_ADDRESS)+40*72), <((DUMP_ADDRESS)+40*73), <((DUMP_ADDRESS)+40*74), <((DUMP_ADDRESS)+40*75), <((DUMP_ADDRESS)+40*76), <((DUMP_ADDRESS)+40*77), <((DUMP_ADDRESS)+40*78), <((DUMP_ADDRESS)+40*79)
	.byt <((DUMP_ADDRESS)+40*80), <((DUMP_ADDRESS)+40*81), <((DUMP_ADDRESS)+40*82), <((DUMP_ADDRESS)+40*83), <((DUMP_ADDRESS)+40*84), <((DUMP_ADDRESS)+40*85), <((DUMP_ADDRESS)+40*86), <((DUMP_ADDRESS)+40*87)
	.byt <((DUMP_ADDRESS)+40*88), <((DUMP_ADDRESS)+40*89), <((DUMP_ADDRESS)+40*90), <((DUMP_ADDRESS)+40*91), <((DUMP_ADDRESS)+40*92), <((DUMP_ADDRESS)+40*93), <((DUMP_ADDRESS)+40*94), <((DUMP_ADDRESS)+40*95)
	.byt <((DUMP_ADDRESS)+40*96), <((DUMP_ADDRESS)+40*97), <((DUMP_ADDRESS)+40*98), <((DUMP_ADDRESS)+40*99), <((DUMP_ADDRESS)+40*100), <((DUMP_ADDRESS)+40*101), <((DUMP_ADDRESS)+40*102), <((DUMP_ADDRESS)+40*103)
	.byt <((DUMP_ADDRESS)+40*104), <((DUMP_ADDRESS)+40*105), <((DUMP_ADDRESS)+40*106), <((DUMP_ADDRESS)+40*107), <((DUMP_ADDRESS)+40*108), <((DUMP_ADDRESS)+40*109), <((DUMP_ADDRESS)+40*110), <((DUMP_ADDRESS)+40*111)
	.byt <((DUMP_ADDRESS)+40*112), <((DUMP_ADDRESS)+40*113), <((DUMP_ADDRESS)+40*114), <((DUMP_ADDRESS)+40*115), <((DUMP_ADDRESS)+40*116), <((DUMP_ADDRESS)+40*117), <((DUMP_ADDRESS)+40*118), <((DUMP_ADDRESS)+40*119)
	.byt <((DUMP_ADDRESS)+40*120), <((DUMP_ADDRESS)+40*121), <((DUMP_ADDRESS)+40*122), <((DUMP_ADDRESS)+40*123), <((DUMP_ADDRESS)+40*124), <((DUMP_ADDRESS)+40*125), <((DUMP_ADDRESS)+40*126), <((DUMP_ADDRESS)+40*127)
	.byt <((DUMP_ADDRESS)+40*128), <((DUMP_ADDRESS)+40*129), <((DUMP_ADDRESS)+40*130), <((DUMP_ADDRESS)+40*131), <((DUMP_ADDRESS)+40*132), <((DUMP_ADDRESS)+40*133), <((DUMP_ADDRESS)+40*134), <((DUMP_ADDRESS)+40*135)
	.byt <((DUMP_ADDRESS)+40*136), <((DUMP_ADDRESS)+40*137), <((DUMP_ADDRESS)+40*138), <((DUMP_ADDRESS)+40*139), <((DUMP_ADDRESS)+40*140), <((DUMP_ADDRESS)+40*141), <((DUMP_ADDRESS)+40*142), <((DUMP_ADDRESS)+40*143)
	.byt <((DUMP_ADDRESS)+40*144), <((DUMP_ADDRESS)+40*145), <((DUMP_ADDRESS)+40*146), <((DUMP_ADDRESS)+40*147), <((DUMP_ADDRESS)+40*148), <((DUMP_ADDRESS)+40*149), <((DUMP_ADDRESS)+40*150), <((DUMP_ADDRESS)+40*151)
	.byt <((DUMP_ADDRESS)+40*152), <((DUMP_ADDRESS)+40*153), <((DUMP_ADDRESS)+40*154), <((DUMP_ADDRESS)+40*155), <((DUMP_ADDRESS)+40*156), <((DUMP_ADDRESS)+40*157), <((DUMP_ADDRESS)+40*158), <((DUMP_ADDRESS)+40*159)
	.byt <((DUMP_ADDRESS)+40*160), <((DUMP_ADDRESS)+40*161), <((DUMP_ADDRESS)+40*162), <((DUMP_ADDRESS)+40*163), <((DUMP_ADDRESS)+40*164), <((DUMP_ADDRESS)+40*165), <((DUMP_ADDRESS)+40*166), <((DUMP_ADDRESS)+40*167)
	.byt <((DUMP_ADDRESS)+40*168), <((DUMP_ADDRESS)+40*169), <((DUMP_ADDRESS)+40*170), <((DUMP_ADDRESS)+40*171), <((DUMP_ADDRESS)+40*172), <((DUMP_ADDRESS)+40*173), <((DUMP_ADDRESS)+40*174), <((DUMP_ADDRESS)+40*175)
	.byt <((DUMP_ADDRESS)+40*176), <((DUMP_ADDRESS)+40*177), <((DUMP_ADDRESS)+40*178), <((DUMP_ADDRESS)+40*179), <((DUMP_ADDRESS)+40*180), <((DUMP_ADDRESS)+40*181), <((DUMP_ADDRESS)+40*182), <((DUMP_ADDRESS)+40*183)
	.byt <((DUMP_ADDRESS)+40*184), <((DUMP_ADDRESS)+40*185), <((DUMP_ADDRESS)+40*186), <((DUMP_ADDRESS)+40*187), <((DUMP_ADDRESS)+40*188), <((DUMP_ADDRESS)+40*189), <((DUMP_ADDRESS)+40*190), <((DUMP_ADDRESS)+40*191)
	.byt <((DUMP_ADDRESS)+40*192), <((DUMP_ADDRESS)+40*193), <((DUMP_ADDRESS)+40*194), <((DUMP_ADDRESS)+40*195), <((DUMP_ADDRESS)+40*196), <((DUMP_ADDRESS)+40*197), <((DUMP_ADDRESS)+40*198), <((DUMP_ADDRESS)+40*199)
	.byt <((DUMP_ADDRESS)+40*200), <((DUMP_ADDRESS)+40*201), <((DUMP_ADDRESS)+40*202), <((DUMP_ADDRESS)+40*203), <((DUMP_ADDRESS)+40*204), <((DUMP_ADDRESS)+40*205), <((DUMP_ADDRESS)+40*206), <((DUMP_ADDRESS)+40*207)
	.byt <((DUMP_ADDRESS)+40*208), <((DUMP_ADDRESS)+40*209), <((DUMP_ADDRESS)+40*210), <((DUMP_ADDRESS)+40*211), <((DUMP_ADDRESS)+40*212), <((DUMP_ADDRESS)+40*213), <((DUMP_ADDRESS)+40*214), <((DUMP_ADDRESS)+40*215)
	.byt <((DUMP_ADDRESS)+40*216), <((DUMP_ADDRESS)+40*217), <((DUMP_ADDRESS)+40*218), <((DUMP_ADDRESS)+40*219), <((DUMP_ADDRESS)+40*220), <((DUMP_ADDRESS)+40*221), <((DUMP_ADDRESS)+40*222), <((DUMP_ADDRESS)+40*223)
	.byt <((DUMP_ADDRESS)+40*224), <((DUMP_ADDRESS)+40*225), <((DUMP_ADDRESS)+40*226), <((DUMP_ADDRESS)+40*227), <((DUMP_ADDRESS)+40*228), <((DUMP_ADDRESS)+40*229), <((DUMP_ADDRESS)+40*230), <((DUMP_ADDRESS)+40*231)
	.byt <((DUMP_ADDRESS)+40*232), <((DUMP_ADDRESS)+40*233), <((DUMP_ADDRESS)+40*234), <((DUMP_ADDRESS)+40*235), <((DUMP_ADDRESS)+40*236), <((DUMP_ADDRESS)+40*237), <((DUMP_ADDRESS)+40*238), <((DUMP_ADDRESS)+40*239)
;.dsb 256-(*&255)
thread_script_pt_lo		.dsb MAX_THREADS,0	; Low byte of script pointer
_HiresAddrHigh
	.byt >((DUMP_ADDRESS)+40*0), >((DUMP_ADDRESS)+40*1), >((DUMP_ADDRESS)+40*2), >((DUMP_ADDRESS)+40*3), >((DUMP_ADDRESS)+40*4), >((DUMP_ADDRESS)+40*5), >((DUMP_ADDRESS)+40*6), >((DUMP_ADDRESS)+40*7)
	.byt >((DUMP_ADDRESS)+40*8), >((DUMP_ADDRESS)+40*9), >((DUMP_ADDRESS)+40*10), >((DUMP_ADDRESS)+40*11), >((DUMP_ADDRESS)+40*12), >((DUMP_ADDRESS)+40*13), >((DUMP_ADDRESS)+40*14), >((DUMP_ADDRESS)+40*15)
	.byt >((DUMP_ADDRESS)+40*16), >((DUMP_ADDRESS)+40*17), >((DUMP_ADDRESS)+40*18), >((DUMP_ADDRESS)+40*19), >((DUMP_ADDRESS)+40*20), >((DUMP_ADDRESS)+40*21), >((DUMP_ADDRESS)+40*22), >((DUMP_ADDRESS)+40*23)
	.byt >((DUMP_ADDRESS)+40*24), >((DUMP_ADDRESS)+40*25), >((DUMP_ADDRESS)+40*26), >((DUMP_ADDRESS)+40*27), >((DUMP_ADDRESS)+40*28), >((DUMP_ADDRESS)+40*29), >((DUMP_ADDRESS)+40*30), >((DUMP_ADDRESS)+40*31)
	.byt >((DUMP_ADDRESS)+40*32), >((DUMP_ADDRESS)+40*33), >((DUMP_ADDRESS)+40*34), >((DUMP_ADDRESS)+40*35), >((DUMP_ADDRESS)+40*36), >((DUMP_ADDRESS)+40*37), >((DUMP_ADDRESS)+40*38), >((DUMP_ADDRESS)+40*39)
	.byt >((DUMP_ADDRESS)+40*40), >((DUMP_ADDRESS)+40*41), >((DUMP_ADDRESS)+40*42), >((DUMP_ADDRESS)+40*43), >((DUMP_ADDRESS)+40*44), >((DUMP_ADDRESS)+40*45), >((DUMP_ADDRESS)+40*46), >((DUMP_ADDRESS)+40*47)
	.byt >((DUMP_ADDRESS)+40*48), >((DUMP_ADDRESS)+40*49), >((DUMP_ADDRESS)+40*50), >((DUMP_ADDRESS)+40*51), >((DUMP_ADDRESS)+40*52), >((DUMP_ADDRESS)+40*53), >((DUMP_ADDRESS)+40*54), >((DUMP_ADDRESS)+40*55)
	.byt >((DUMP_ADDRESS)+40*56), >((DUMP_ADDRESS)+40*57), >((DUMP_ADDRESS)+40*58), >((DUMP_ADDRESS)+40*59), >((DUMP_ADDRESS)+40*60), >((DUMP_ADDRESS)+40*61), >((DUMP_ADDRESS)+40*62), >((DUMP_ADDRESS)+40*63)
	.byt >((DUMP_ADDRESS)+40*64), >((DUMP_ADDRESS)+40*65), >((DUMP_ADDRESS)+40*66), >((DUMP_ADDRESS)+40*67), >((DUMP_ADDRESS)+40*68), >((DUMP_ADDRESS)+40*69), >((DUMP_ADDRESS)+40*70), >((DUMP_ADDRESS)+40*71)
	.byt >((DUMP_ADDRESS)+40*72), >((DUMP_ADDRESS)+40*73), >((DUMP_ADDRESS)+40*74), >((DUMP_ADDRESS)+40*75), >((DUMP_ADDRESS)+40*76), >((DUMP_ADDRESS)+40*77), >((DUMP_ADDRESS)+40*78), >((DUMP_ADDRESS)+40*79)
	.byt >((DUMP_ADDRESS)+40*80), >((DUMP_ADDRESS)+40*81), >((DUMP_ADDRESS)+40*82), >((DUMP_ADDRESS)+40*83), >((DUMP_ADDRESS)+40*84), >((DUMP_ADDRESS)+40*85), >((DUMP_ADDRESS)+40*86), >((DUMP_ADDRESS)+40*87)
	.byt >((DUMP_ADDRESS)+40*88), >((DUMP_ADDRESS)+40*89), >((DUMP_ADDRESS)+40*90), >((DUMP_ADDRESS)+40*91), >((DUMP_ADDRESS)+40*92), >((DUMP_ADDRESS)+40*93), >((DUMP_ADDRESS)+40*94), >((DUMP_ADDRESS)+40*95)
	.byt >((DUMP_ADDRESS)+40*96), >((DUMP_ADDRESS)+40*97), >((DUMP_ADDRESS)+40*98), >((DUMP_ADDRESS)+40*99), >((DUMP_ADDRESS)+40*100), >((DUMP_ADDRESS)+40*101), >((DUMP_ADDRESS)+40*102), >((DUMP_ADDRESS)+40*103)
	.byt >((DUMP_ADDRESS)+40*104), >((DUMP_ADDRESS)+40*105), >((DUMP_ADDRESS)+40*106), >((DUMP_ADDRESS)+40*107), >((DUMP_ADDRESS)+40*108), >((DUMP_ADDRESS)+40*109), >((DUMP_ADDRESS)+40*110), >((DUMP_ADDRESS)+40*111)
	.byt >((DUMP_ADDRESS)+40*112), >((DUMP_ADDRESS)+40*113), >((DUMP_ADDRESS)+40*114), >((DUMP_ADDRESS)+40*115), >((DUMP_ADDRESS)+40*116), >((DUMP_ADDRESS)+40*117), >((DUMP_ADDRESS)+40*118), >((DUMP_ADDRESS)+40*119)
	.byt >((DUMP_ADDRESS)+40*120), >((DUMP_ADDRESS)+40*121), >((DUMP_ADDRESS)+40*122), >((DUMP_ADDRESS)+40*123), >((DUMP_ADDRESS)+40*124), >((DUMP_ADDRESS)+40*125), >((DUMP_ADDRESS)+40*126), >((DUMP_ADDRESS)+40*127)
	.byt >((DUMP_ADDRESS)+40*128), >((DUMP_ADDRESS)+40*129), >((DUMP_ADDRESS)+40*130), >((DUMP_ADDRESS)+40*131), >((DUMP_ADDRESS)+40*132), >((DUMP_ADDRESS)+40*133), >((DUMP_ADDRESS)+40*134), >((DUMP_ADDRESS)+40*135)
	.byt >((DUMP_ADDRESS)+40*136), >((DUMP_ADDRESS)+40*137), >((DUMP_ADDRESS)+40*138), >((DUMP_ADDRESS)+40*139), >((DUMP_ADDRESS)+40*140), >((DUMP_ADDRESS)+40*141), >((DUMP_ADDRESS)+40*142), >((DUMP_ADDRESS)+40*143)
	.byt >((DUMP_ADDRESS)+40*144), >((DUMP_ADDRESS)+40*145), >((DUMP_ADDRESS)+40*146), >((DUMP_ADDRESS)+40*147), >((DUMP_ADDRESS)+40*148), >((DUMP_ADDRESS)+40*149), >((DUMP_ADDRESS)+40*150), >((DUMP_ADDRESS)+40*151)
	.byt >((DUMP_ADDRESS)+40*152), >((DUMP_ADDRESS)+40*153), >((DUMP_ADDRESS)+40*154), >((DUMP_ADDRESS)+40*155), >((DUMP_ADDRESS)+40*156), >((DUMP_ADDRESS)+40*157), >((DUMP_ADDRESS)+40*158), >((DUMP_ADDRESS)+40*159)
	.byt >((DUMP_ADDRESS)+40*160), >((DUMP_ADDRESS)+40*161), >((DUMP_ADDRESS)+40*162), >((DUMP_ADDRESS)+40*163), >((DUMP_ADDRESS)+40*164), >((DUMP_ADDRESS)+40*165), >((DUMP_ADDRESS)+40*166), >((DUMP_ADDRESS)+40*167)
	.byt >((DUMP_ADDRESS)+40*168), >((DUMP_ADDRESS)+40*169), >((DUMP_ADDRESS)+40*170), >((DUMP_ADDRESS)+40*171), >((DUMP_ADDRESS)+40*172), >((DUMP_ADDRESS)+40*173), >((DUMP_ADDRESS)+40*174), >((DUMP_ADDRESS)+40*175)
	.byt >((DUMP_ADDRESS)+40*176), >((DUMP_ADDRESS)+40*177), >((DUMP_ADDRESS)+40*178), >((DUMP_ADDRESS)+40*179), >((DUMP_ADDRESS)+40*180), >((DUMP_ADDRESS)+40*181), >((DUMP_ADDRESS)+40*182), >((DUMP_ADDRESS)+40*183)
	.byt >((DUMP_ADDRESS)+40*184), >((DUMP_ADDRESS)+40*185), >((DUMP_ADDRESS)+40*186), >((DUMP_ADDRESS)+40*187), >((DUMP_ADDRESS)+40*188), >((DUMP_ADDRESS)+40*189), >((DUMP_ADDRESS)+40*190), >((DUMP_ADDRESS)+40*191)
	.byt >((DUMP_ADDRESS)+40*192), >((DUMP_ADDRESS)+40*193), >((DUMP_ADDRESS)+40*194), >((DUMP_ADDRESS)+40*195), >((DUMP_ADDRESS)+40*196), >((DUMP_ADDRESS)+40*197), >((DUMP_ADDRESS)+40*198), >((DUMP_ADDRESS)+40*199)
	.byt >((DUMP_ADDRESS)+40*200), >((DUMP_ADDRESS)+40*201), >((DUMP_ADDRESS)+40*202), >((DUMP_ADDRESS)+40*203), >((DUMP_ADDRESS)+40*204), >((DUMP_ADDRESS)+40*205), >((DUMP_ADDRESS)+40*206), >((DUMP_ADDRESS)+40*207)
	.byt >((DUMP_ADDRESS)+40*208), >((DUMP_ADDRESS)+40*209), >((DUMP_ADDRESS)+40*210), >((DUMP_ADDRESS)+40*211), >((DUMP_ADDRESS)+40*212), >((DUMP_ADDRESS)+40*213), >((DUMP_ADDRESS)+40*214), >((DUMP_ADDRESS)+40*215)
	.byt >((DUMP_ADDRESS)+40*216), >((DUMP_ADDRESS)+40*217), >((DUMP_ADDRESS)+40*218), >((DUMP_ADDRESS)+40*219), >((DUMP_ADDRESS)+40*220), >((DUMP_ADDRESS)+40*221), >((DUMP_ADDRESS)+40*222), >((DUMP_ADDRESS)+40*223)
	.byt >((DUMP_ADDRESS)+40*224), >((DUMP_ADDRESS)+40*225), >((DUMP_ADDRESS)+40*226), >((DUMP_ADDRESS)+40*227), >((DUMP_ADDRESS)+40*228), >((DUMP_ADDRESS)+40*229), >((DUMP_ADDRESS)+40*230), >((DUMP_ADDRESS)+40*231)
	.byt >((DUMP_ADDRESS)+40*232), >((DUMP_ADDRESS)+40*233), >((DUMP_ADDRESS)+40*234), >((DUMP_ADDRESS)+40*235), >((DUMP_ADDRESS)+40*236), >((DUMP_ADDRESS)+40*237), >((DUMP_ADDRESS)+40*238), >((DUMP_ADDRESS)+40*239)
;.dsb 256-(*&255)
thread_script_pt_hi		.dsb MAX_THREADS,0	; High byte of script pointer
_TableBit6Reverse
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1

    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1

    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1

    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1
    .byt 32,16,8,4,2,1

; Codes for animstates when drawing them mirrored	
mirror_codes 
	.byt 4,3,2,1,0
	.byt 9,8,7,6,5
	.byt 14,13,12,11,10
	.byt 19,18,17,16,15
	.byt 24,23,22,21,20
	.byt 29,28,27,26,25
	.byt 34,33,32,31,30

    
;__freespace2    
 ; Table for mirroring graphics... This should fit in a page to avoid penalties!
;.dsb 256-(*&255) 
inverse_table
	.byt $00+$0,$20+$0,$10+$0,$30+$0,$08+$0,$28+$0,$18+$0,$38+$0,$04+$0,$24+$0,$14+$0,$34+$0,$0C+$0,$2C+$0,$1C+$0,$3C+$0,$02+$0,$22+$0,$12+$0,$32+$0
	.byt $0A+$0,$2A+$0,$1A+$0,$3A+$0,$06+$0,$26+$0,$16+$0,$36+$0,$0E+$0,$2E+$0,$1E+$0,$3E+$0,$01+$0,$21+$0,$11+$0,$31+$0,$09+$0,$29+$0,$19+$0,$39+$0
	.byt $05+$0,$25+$0,$15+$0,$35+$0,$0D+$0,$2D+$0,$1D+$0,$3D+$0,$03+$0,$23+$0,$13+$0,$33+$0,$0B+$0,$2B+$0,$1B+$0,$3B+$0,$07+$0,$27+$0,$17+$0,$37+$0
	.byt $0F+$0,$2F+$0,$1F+$0,$3F+$0
	.byt $00+$40,$20+$40,$10+$40,$30+$40,$08+$40,$28+$40,$18+$40,$38+$40,$04+$40,$24+$40,$14+$40,$34+$40,$0C+$40,$2C+$40,$1C+$40,$3C+$40,$02+$40,$22+$40,$12+$40,$32+$40
	.byt $0A+$40,$2A+$40,$1A+$40,$3A+$40,$06+$40,$26+$40,$16+$40,$36+$40,$0E+$40,$2E+$40,$1E+$40,$3E+$40,$01+$40,$21+$40,$11+$40,$31+$40,$09+$40,$29+$40,$19+$40,$39+$40
	.byt $05+$40,$25+$40,$15+$40,$35+$40,$0D+$40,$2D+$40,$1D+$40,$3D+$40,$03+$40,$23+$40,$13+$40,$33+$40,$0B+$40,$2B+$40,$1B+$40,$3B+$40,$07+$40,$27+$40,$17+$40,$37+$40
	.byt $0F+$40,$2F+$40,$1F+$40,$3F+$40
   
	
;.dsb 256-(*&255)
tab_div5
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 8
	.byt 8
	.byt 8
	.byt 8
	.byt 8
	.byt 9
	.byt 9
	.byt 9
	.byt 9
	.byt 9
	.byt 10
	.byt 10
	.byt 10
	.byt 10
	.byt 10
	.byt 11
	.byt 11
	.byt 11
	.byt 11
	.byt 11
	.byt 12
	.byt 12
	.byt 12
	.byt 12
	.byt 12
	.byt 13
	.byt 13
	.byt 13
	.byt 13
	.byt 13
	.byt 14
	.byt 14
	.byt 14
	.byt 14
	.byt 14
	.byt 15
	.byt 15
	.byt 15
	.byt 15
	.byt 15
	.byt 16
	.byt 16
	.byt 16
	.byt 16
	.byt 16
	.byt 17
	.byt 17
	.byt 17
	.byt 17
	.byt 17
	.byt 18
	.byt 18
	.byt 18
	.byt 18
	.byt 18
	.byt 19
	.byt 19
	.byt 19
	.byt 19
	.byt 19
	.byt 20
	.byt 20
	.byt 20
	.byt 20
	.byt 20

	
; Empty mask data used in the drawing functions in engine.s 
empty_mask .dsb 8,$40	
	
tab_mod5
	.byt 0
	.byt 8
	.byt 16
	.byt 24
	.byt 32
	.byt 0
	.byt 8
	.byt 16
	.byt 24
	.byt 32
	.byt 0
	.byt 8
	.byt 16
	.byt 24
	.byt 32
	.byt 0
	.byt 8
	.byt 16
	.byt 24
	.byt 32
	.byt 0
	.byt 8
	.byt 16
	.byt 24
	.byt 32
	.byt 0
	.byt 8
	.byt 16
	.byt 24
	.byt 32
	.byt 0
	.byt 8
	.byt 16
	.byt 24
	.byt 32
	.byt 0
	.byt 8
	.byt 16
	.byt 24
	.byt 32
	.byt 0
	.byt 8
	.byt 16
	.byt 24
	.byt 32
	.byt 0
	.byt 8
	.byt 16
	.byt 24
	.byt 32
	.byt 0
	.byt 8
	.byt 16
	.byt 24
	.byt 32
	.byt 0
	.byt 8
	.byt 16
	.byt 24
	.byt 32
	.byt 0
	.byt 8
	.byt 16
	.byt 24
	.byt 32
	.byt 0
	.byt 8
	.byt 16
	.byt 24
	.byt 32
	.byt 0
	.byt 8
	.byt 16
	.byt 24
	.byt 32
	.byt 0
	.byt 8
	.byt 16
	.byt 24
	.byt 32
	.byt 0
	.byt 8
	.byt 16
	.byt 24
	.byt 32
	.byt 0
	.byt 8
	.byt 16
	.byt 24
	.byt 32
	.byt 0
	.byt 8
	.byt 16
	.byt 24
	.byt 32
	.byt 0
	.byt 8
	.byt 16
	.byt 24
	.byt 32
	.byt 0
	.byt 8
	.byt 16
	.byt 24
	.byt 32

	
; These are the resources directories. For the time being they will be all
; in main memory and won't be discarded. If room becomes a problem, they may go
; into a disk chunk and loaded whenever necessary even compacting memory beforehand.

#include "floppycode\floppy_description.h"


__resource_directories_start

; Directories with resources
dir_scripts
	.byt 0, LOADER_SCRIPT0, 1, LOADER_SCRIPT1, 2, LOADER_SCRIPT2, 3, LOADER_SCRIPT3
	.byt 4, LOADER_SCRIPT4, 5, LOADER_SCRIPT5, 6, LOADER_SCRIPT6, 7, LOADER_SCRIPT7
	.byt 8, LOADER_SCRIPT8, 9, LOADER_SCRIPT9, 10, LOADER_SCRIPT10, 11, LOADER_SCRIPT11
	.byt 15, LOADER_SCRIPT15, 16, LOADER_SCRIPT16, 17, LOADER_SCRIPT17, 18, LOADER_SCRIPT18
	.byt 19, LOADER_SCRIPT19, 20, LOADER_SCRIPT20, 21, LOADER_SCRIPT21
	.byt 30, LOADER_SCRIPT30
	.byt $ff
dir_strings
	.byt 0, LOADER_STRINGS
	.byt 100, LOADER_STRINGSINTROSVILA
	.byt 101, LOADER_STRINGSLONDONPLAN
	.byt 102, LOADER_STRINGSLONDONDLG
	
	; This strings are stored with the object code. Need this for saving to work
	.byt 2, LOADER_OCODEGUARD
	.byt 3, LOADER_OCODESANDWICH, 4, LOADER_OCODEMUG, 5, LOADER_OCODELAXATIVE
	.byt 6, LOADER_OCODECOIN, 7, LOADER_OCODEDECAF, 8, LOADER_OCODEKEY, 10, LOADER_OCODETECHCAM
	.byt 11, LOADER_OCODEMAN, 9, LOADER_OCODEMAP
	.byt 20, LOADER_OCODEJENNA, 21, LOADER_OCODEVILA, 22, LOADER_OCODEAVON, 23, LOADER_OCODEGAN
	.byt 24, LOADER_OCODECALLY
	.byt 28, LOADER_OCODEDRONE, 29, LOADER_OCODETRANSMITTER, 30, LOADER_OCODEWSWITCH
	.byt 31, LOADER_OCODEYPIPE, 32, LOADER_OCODEBEARING, 33, LOADER_OCODECINCH, 34, LOADER_OCODECATPULT
	.byt 37, LOADER_OCODEBALLROBOT
	.byt 38, LOADER_OCODESCISSORS, 39, LOADER_OCODEPLIERS, 40, LOADER_OCODEWRENCH, 41, LOADER_OCODESPRAY
	.byt 35, LOADER_OCODEBRACELET, 36, LOADER_OCODEGUN, 42, LOADER_OCODEBRACELETS
	.byt 43, LOADER_OCODEROPE, 44, LOADER_OCODELAMP, 45, LOADER_OCODEVARGAS
	.byt 48, LOADER_OCODELOG, 49, LOADER_OCODECUP, 15, LOADER_OCODEGUARD2, 50, LOADER_OCODEUNIFORM
	.byt 51, LOADER_OCODETRASPONDER, 52, LOADER_OCODEECELL
	.byt $ff
/* META: some objects are not here, as they are always in memory when loaded, but they should anyway! */ 
dir_objects
	.byt 0, LOADER_OBJBLAKE, 5, LOADER_OBJBLAKE, 6, LOADER_OBJBLAKE, 7, LOADER_OBJBLAKE
	.byt 8, LOADER_OBJBLAKE, 9, LOADER_OBJBLAKE
	.byt 10, LOADER_OBJBLAKE, 11, LOADER_OBJBLAKE
	.byt 15, LOADER_OBJBLAKE
	/* Servalan and Travis */
	.byt 25, LOADER_OBJBLAKE, 26, LOADER_OBJBLAKE
	/* Rest of B7's characters */
	.byt 20, LOADER_OBJEP2,	21, LOADER_OBJEP2, 22, LOADER_OBJEP2, 23, LOADER_OBJEP2
	.byt 24, LOADER_OBJEP3
	.byt 28, LOADER_OBJEP2, 29, LOADER_OBJEP3, 30, LOADER_OBJEP3	; Drone, transmitter and switch
	.byt 31, LOADER_OBJEP2, 32, LOADER_OBJEP2, 33, LOADER_OBJEP2, 34, LOADER_OBJEP2
	.byt 35, LOADER_OBJEP2, 36, LOADER_OBJEP2 ; Bracelet and gun
	.byt 37, LOADER_OBJEP2	; Defense ball-robot in Liberator
	.byt 38, LOADER_OBJEP2, 39, LOADER_OBJEP2, 40, LOADER_OBJEP2, 41, LOADER_OBJEP2 ; Tools in workshop
	.byt 42, LOADER_OBJEP2, 43, LOADER_OBJEP2, 44, LOADER_OBJEP2
	.byt 45, LOADER_OBJEP2, 46, LOADER_OBJEP2, 47, LOADER_OBJEP2
	.byt 48, LOADER_OBJEP3, 49, LOADER_OBJEP3, 50, LOADER_OBJEP3
	.byt 51, LOADER_OBJEP3, 52, LOADER_OBJEP2
	.byt $ff
dir_ocode
	.byt 2, LOADER_OCODEGUARD
	.byt 3, LOADER_OCODESANDWICH, 4, LOADER_OCODEMUG, 5, LOADER_OCODELAXATIVE
	.byt 6, LOADER_OCODECOIN, 7, LOADER_OCODEDECAF, 8, LOADER_OCODEKEY, 10, LOADER_OCODETECHCAM
	.byt 11, LOADER_OCODEMAN, 9, LOADER_OCODEMAP
	.byt 20, LOADER_OCODEJENNA, 21, LOADER_OCODEVILA, 22, LOADER_OCODEAVON, 23, LOADER_OCODEGAN
	.byt 24, LOADER_OCODECALLY
	.byt 28, LOADER_OCODEDRONE, 29, LOADER_OCODETRANSMITTER, 30, LOADER_OCODEWSWITCH	
	.byt 31, LOADER_OCODEYPIPE, 32, LOADER_OCODEBEARING, 33, LOADER_OCODECINCH, 34, LOADER_OCODECATPULT
	.byt 37, LOADER_OCODEBALLROBOT
	.byt 38, LOADER_OCODESCISSORS, 39, LOADER_OCODEPLIERS, 40, LOADER_OCODEWRENCH, 41, LOADER_OCODESPRAY
	.byt 35, LOADER_OCODEBRACELET, 36, LOADER_OCODEGUN, 42, LOADER_OCODEBRACELETS, 43, LOADER_OCODEROPE
	.byt 44, LOADER_OCODELAMP, 45, LOADER_OCODEVARGAS
	.byt 48, LOADER_OCODELOG, 49, LOADER_OCODECUP, 15, LOADER_OCODEGUARD2, 50, LOADER_OCODEUNIFORM
	.byt 51, LOADER_OCODETRASPONDER, 52, LOADER_OCODEECELL
	.byt $ff
dir_costumes
	.byt 0, LOADER_COSBLAKE, 1, LOADER_COSJENNA, 2, LOADER_COSCAMERA, 3, LOADER_COSGUARD
	.byt 4, LOADER_COSTECHCAM, 5, LOADER_COSMAN, 6, LOADER_COSMAN2
	.byt 7, LOADER_COSTRAVIS, 8, LOADER_COSSERVALAN
	.byt 10, LOADER_COSVILA
	.byt 11, LOADER_COSAVON
	.byt 12, LOADER_COSGAN
	.byt 13, LOADER_COSCALLY
	.byt 14, LOADER_COSBEXTRAS
	.byt 15, LOADER_COSBALL 
	.byt 16, LOADER_COSMONK	
	.byt 17, LOADER_COSVARGAS
	.byt $ff
dir_rooms
	; Intro and Episode 1
	.byt 0, LOADER_ROOM0, 1, LOADER_ROOM1, 2, LOADER_ROOM2, 3, LOADER_ROOM3
	.byt 4, LOADER_ROOM4, 6, LOADER_ROOM6, 7, LOADER_ROOM7, 8, LOADER_ROOM8
	.byt 9, LOADER_ROOM9, 10, LOADER_ROOM10, 5, LOADER_ROOM5, 11, LOADER_ROOM11, 12, LOADER_ROOM12
	.byt 13, LOADER_ROOM13
	; Episode 2
	.byt 14, LOADER_ROOM14, 15, LOADER_ROOM15
	.byt 17, LOADER_ROOM17, 18, LOADER_ROOM18
	.byt 20, LOADER_ROOM20, 21, LOADER_ROOM21, 22, LOADER_ROOM22, 23, LOADER_ROOM23, 24, LOADER_ROOM24, 25, LOADER_ROOM25
	.byt 30, LOADER_ROOM30, 31, LOADER_ROOM31, 32, LOADER_ROOM32, 33, LOADER_ROOM33, 34, LOADER_ROOM34, 35, LOADER_ROOM35
	.byt 36, LOADER_ROOM36, 37, LOADER_ROOM37
	.byt 40, LOADER_ROOM40, 41, LOADER_ROOM41, 42, LOADER_ROOM42, 43, LOADER_ROOM43, 44, LOADER_ROOM44, 45, LOADER_ROOM45
	.byt 47, LOADER_ROOM47
	.byt 49, LOADER_ROOM49, 50, LOADER_ROOM50, 51, LOADER_ROOM51, 52, LOADER_ROOM52, 53, LOADER_ROOM53, 54, LOADER_ROOM54
	.byt 55, LOADER_ROOM55
	.byt $ff
dir_musics
	.byt 0, LOADER_MAINTHEME, 1, LOADER_ENDEPTHEME, 2, LOADER_FINALTHEME, 3, LOADER_FEDMARCHTHEME, $ff
__resource_directories_end

#echo Resource directories size:
#print  (__resource_directories_end-__resource_directories_start)
#echo		
		
; Logo for the menu
logo
	.byt $40,$47,$61,$70,$40,$40,$5c,$40,$4c,$40,$40,$70,$40,$46,$40,$41
	.byt $60,$40,$43,$40,$40,$40,$40,$40,$40,$5f,$7f,$7f,$7f,$7e,$43,$7f
	.byt $7f,$7f,$78,$44,$5f,$7f,$7f,$60,$46,$47,$7f,$7f,$50,$46,$41,$7f
	.byt $7c,$70,$46,$40,$7f,$70,$70,$46,$41,$7f,$40,$70,$46,$43,$7c,$40
	.byt $70,$43,$47,$70,$41,$60,$43,$6f,$60,$41,$60,$41,$5e,$40,$43,$40
	.byt $40,$78,$40,$46,$40,$41,$60,$40,$4c,$40,$42,$4c,$40,$58,$40,$40
	.byt $43,$63,$60,$40

; Mod to generate the save icon and also buffer for exchange
saviconbuff	
	.byt $7F, $60, $6F, $6E, $66, $6B, $4C, $7E	; tile #1
	.byt $7F, $7E, $4C, $6B, $67, $6F, $6F, $7F	; tile #3	
	

; AY Register number
ayRealRegister
 .byt 0,2,4,1,3,5,6,7,8,9,10,11,12,13

ayw_Bank
ayw_PitchLo	.byt 0,0,0
ayw_PitchHi	.byt 0,0,0
ayw_Noise	.byt 0
ayw_Status	.byt %01111000
ayw_Volume	.byt 0,0,0
ayw_EGPeriod	.byt 0,0
ayw_Cycle	.byt 0

ReferenceBlock
ayr_Bank
ayr_PitchLo	.byt 128,128,128
ayr_PitchHi	.byt 128,128,128
ayr_Noise	.byt 128
ayr_Status	.byt 128
ayr_Volume	.byt 128,128,128
ayr_EGPeriod	.byt 128,128
ayr_Cycle	.byt 128

/*
#ifdef LOADING_MSG 
; Loading strings

loading_msg
#ifdef ENGLISH
.asc  A_FWMAGENTA+A_FWCYAN*8+128,"Loading game data... please wait",0
#endif

#ifdef SPANISH
.asc  A_FWMAGENTA+A_FWCYAN*8+128,"Cargando el juego...  un segundo",0
#endif

#endif
*/
		
; Strings for menu
menu_title
.asc A_FWMAGENTA+A_FWCYAN*8+128,"Blake's 7",$7,0

menu_str
#ifdef ENGLISH
.asc 2,"  R", 6, "Redefine keys",7,0
.asc 2,"  V", 6, "Volume level:",5
#endif
#ifdef SPANISH
.asc 2,"  R", 6, "Redefinir teclas",7,0
.asc 2,"  V", 6, "Volumen:",5
#endif

vlevel
#ifdef ENGLISH
.asc "high   ", 7,0
#ifdef SPEECHSOUND
.asc 2,"  T",6, "Talk sounds:",5
#else
.asc 2,"  T",6, "Talk speed:",5
#endif


tspeed
#ifdef SPEECHSOUND
.asc "yes    ", 7,0
#else
.asc "normal ", 7,0
#endif
.asc   " ",0
.asc 3,"  ESC", 6, "Continue game",7,0
#endif
#ifdef SPANISH
.asc "alto   ", 7,0
#ifdef SPEECHSOUND
.asc 2,"  T",6, "sonido Texto:",5
#else
.asc 2,"  T",6, "velocidad Texto:",5
#endif
tspeed
#ifdef SPEECHSOUND
.asc "s","Z"+3,"     ", 7,0
#else
.asc "normal ", 7,0
#endif
.asc   " ",0
.asc 3,"  ESC", 6, "Continuar juego",7,0
#endif

#ifdef ENGLISH
stv
.asc "high   "
.asc "normal "
.asc "soft   "
.asc "silence"
stt
#ifdef SPEECHSOUND
.asc "no     "
.asc "yes    "
#else
.asc "fast   "
.asc "normal "
#endif

#endif
#ifdef SPANISH
stv
.asc "alto   "
.asc "normal "
.asc "suave  "
.asc "apagado"
stt
#ifdef SPEECHSOUND
.asc "no     "
.asc "s","Z"+3,"     "
#else
.asc "r","Z"+1,"pida "
.asc "normal "

#endif


#endif

#ifdef ENGLISH
menusave_str
.asc 3,"  C", 6, "Continue saved game",7,0
menusave_str2
.asc 3,"  N", 6, "New game",1,"(clears progress)",7,0
;menusave_str3
;.asc 3,"    ARE YOU SURE (Y/N)?",7,0
#endif
#ifdef SPANISH
menusave_str
.asc 3,"  C", 6, "Continua juego",7,0
menusave_str2
.asc 3,"  N", 6, "Nuevo",1,"(borra tu progreso)",7,0
#endif
		
; META: TODO: This should go to a resource???
; or, at least somewhere else?
verbs
#ifdef ENGLISH
.asc "Give",0
.asc "Pick up",0
.asc "Use",0
.asc "Open",0
.asc "Look at",0
.asc "Push",0
.asc "Close",0
.asc "Talk to",0
.asc "Pull",0
.asc "Walk to",0
#endif
#ifdef SPANISH
.asc "Dale",0
.asc "Coge",0
.asc "Usa",0
.asc "Abre",0
.asc "Mira",0
.asc "Empuja",0
.asc "Cierra",0
.asc "Habla",0
.asc "Tira",0
.asc "Ve a",0
#endif

verb_active 	.dsb 9

#ifdef SPANISH
verb_pos_X 	.byt 1*6,  8*6, 14*6, 1*6,  8*6, 14*6, 1*6,  8*6, 14*6
verb_pos_X2 	.byt 5*6, 12*6, 17*6, 5*6, 12*6, 20*6, 7*6, 13*6, 18*6
verb_pos_Y 	.byt 144+1, 144+1, 144+1, 144+16+1, 144+16+1, 144+16+1, 144+32+1, 144+32+1, 144+32+1 
#endif
#ifdef ENGLISH
verb_pos_X 	.byt 1*6,  7*6, 15*6, 1*6,  7*6, 15*6, 1*6,  7*6, 15*6
verb_pos_X2 	.byt 5*6, 14*6, 18*6, 5*6, 14*6, 19*6, 5*6, 14*6, 19*6
verb_pos_Y 	.byt 144+1, 144+1, 144+1, 144+16+1, 144+16+1, 144+16+1, 144+32+1, 144+32+1, 144+32+1 
#endif


; Prepositions to use with some verbs... META: TODO: How to actually do this?
preps
#ifdef ENGLISH
.asc "to",0
.asc "with",0
verb_prep		.byt 0, $ff, 1, $ff, $ff, $ff, $ff, $ff, $ff, $ff 
#endif
#ifdef SPANISH
.asc "a",0
.asc "con",0
verb_prep		.byt 0, $ff, 1, $ff, $ff, $ff, $ff, $ff, $ff, $ff 
#endif
		
		
; Usually it is a good idea to keep 0 all the unused
; entries, as it speeds up things. Z=1 means no key
; pressed and there is no need to look in tables later on. 
tab_ascii
    .asc "7","N","5","V",KET_RCTRL,"1","X","3"
    .asc "J","T","R","F",0,KEY_ESC,"Q","D"
    .asc "M","6","B","4",KEY_LCTRL,"Z","2","C"
    .asc "K","9",38,"-",0,0,42,39
    .asc " ",",",".",KEY_UP,KEY_LSHIFT,KEY_LEFT,KEY_DOWN,KEY_RIGHT
    .asc "U","I","O","P",KEY_FUNCT,KEY_DEL,")","("
    .asc "Y","H","G","E",0,"A","S","W"
    .asc "8","L","0","/",KEY_RSHIFT,KEY_RETURN,0,"+"

redefine_strings    
#ifdef SPANISH
.asc A_FWMAGENTA,"Arriba..",A_FWWHITE,0
.asc A_FWMAGENTA,"Abajo..",A_FWWHITE,0
.asc A_FWMAGENTA,"Izquierda..",A_FWWHITE,0
.asc A_FWMAGENTA,"Derecha..",A_FWWHITE,0
.asc A_FWMAGENTA,"Selecci","Z"+4,"n..",A_FWWHITE,0
#endif
#ifdef ENGLISH
.asc A_FWMAGENTA,"Up..",A_FWWHITE,0
.asc A_FWMAGENTA,"Down..",A_FWWHITE,0
.asc A_FWMAGENTA,"Left..",A_FWWHITE,0
.asc A_FWMAGENTA,"Right..",A_FWWHITE,0
.asc A_FWMAGENTA,"Select..",A_FWWHITE,0
#endif

tab_knames
; Strings for keys with no letter
.asc "UP",0
.asc "LEFT",0
.asc "DOWN",0
.asc "RIGHT",0
.asc "LCTRL",0
.asc "RCTRL",0
.asc "LSHIFT",0
.asc "RSHIFT",0
.asc "FUNCT",0
.asc "E",0		; Escape, not used, but good idea to keep it here.
.asc "DEL",0
.asc "RET",0
.asc "SPACE",0
    
	
; Tables for keyboard handling		
tab_banks 		.byt 4,4,4,4,4
tab_bits 		.byt %00000001,%10000000,%00100000,%01000000,%00001000

		
; Table to handle corner walkboxes
tab_adj_lcols
	.byt 0,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32

; Table for handling steps
step_anim .byt WALK_RIGHT_2, WALK_RIGHT_1, WALK_RIGHT_2, WALK_RIGHT_3
step_inc  .byt 1, 0, 1, 0

; Table to relate directions and animatory states... moved to tables.s
; FACING_RIGHT, FACING_LEFT, FACING_UP, FACING_DOWN
tab_dirs_as .byt LOOK_RIGHT,LOOK_RIGHT,LOOK_BACK,LOOK_FRONT	

; Table for speaking speed
saytime .byt 14+4,20+4,30+4,35+4,40+4	; Default is normal speed
	
; Volume table for different choices	
vol_table 	.byt 0,3,5,15	
	
; SFX data

SFX_Sounding			.byt $ff,$ff,$ff

; Instrument definition

Envelope_table
	; For music
	.byt 6,10,12,13,10,11,8,6	; Thrill tune
	;.byt 13,13,13,13,10,11,8,6	; Success
	.byt 0,6,8,10,12,14,10,8	; Success, Minitune
	.byt 8,10,12,13,14,12,10,8	; Main Tune
	.byt 10,10,12,13,15,15,14,10	; Main Tune
; drums
	.byt 0,2,6,7,8,10,12,15
	.byt 9,10,11,13,12,14,15,12	; Main Tune	
	.byt 0,2,6,10,12,15,12,10
	
	; For sfx
	.byt 0,0,0,0,0,0,0,6			; Step
	.byt 8,8,9,10,10,11,8,0 		; Pick 	
	.byt 8,8,9,10,10,11,8,0 		; Drop 	
	.byt 3,4,6,8,8,7,6,4 	 		; Door
	.byt 8,10,11,11,11,11,10,8		; Beepler
	.byt 8,8,9,10,10,11,8,0 		; Chuic 	
	.byt 15,15,15,14,13,12,11,10		; Alert	
	.byt 8,8,8,9,9,10,11,11			; Explosion (phase 1)
	.byt 0,4,4,6,6,6,7,7			; Explosion (phase 2)
#ifdef SPEECHSOUND	
	.byt 8,10,8,00,00,10,8,8 		; Speech
#endif	
	
Ornament_table
	; For Music	
	.byt 0,0,0,0,0,0,0,0			; Main Tune, thrill, Explosion
	.byt 0,$ff-1,0,1+1,0,$ff-1,0,1+1	; Main Tune
	.byt 0,$fd-2,0,3+2,0,$fd-2,0,3+2	; Main Tune
	.byt 0,$ff,0,1,0,$ff,0,1		; Minitune		
	; For sfx
	.byt 0,0,0,0,0,$f0,0,16				; Step
	.byt 8,16,32,48,64,80,96,112			; Pick
	.byt 112,96,80,64,48,31,16,80			; Drop
	.byt $ff,0,$ff,0,2,8,14,28		  	; Door (phase 1)
	;.byt $ff,0,$ff,0,2,8,14,28			; Beepler
	.byt 8,16,32,48,64,80,96,112			; Chuic
	.byt 14,14,14,14,0,0,0,0			; Teleport 1
	.byt 0,$f0,0,16,0,0,$f0,16			; Teleport 2
	;.byt $c0, $e0, $f0, 0, 31, 62, 94, 127  	; alert (unused?)
	;.byt $e0, 32, $f0, 16, $f8, 8, 0, 0		; boing
	.byt 105,90,75,60,45,30,15,0			; Alien Shoot
#ifdef SPEECHSOUND
	.byt 100,80,90,60,40,30,10,5			; Speech
#endif

#include "sound.h"

#define FIRST_SFX_PAT 	0
#define FIRST_SFX_ORN 	4
#define FIRST_SFX_ENV	7

; With first SFX_ORN (4) and FIRST_SFX_ENV+1 it sounds like a good bell!	
sfx_pic
	.byt 5*12
	.byt END
List_pic
	.byt ENV, 4, ORN, 0, FIRST_SFX_PAT+12
	.byt END	
	
sfx_explosion
	.byt 9*12+0
	.byt END
List_explosion
	.byt NON, TOFF, NVAL, 30, ENV, FIRST_SFX_ENV+7, ORN, 0, FIRST_SFX_PAT+11
	.byt ENV, FIRST_SFX_ENV+8, FIRST_SFX_PAT+11, NOFF, TON, END	
		
sfx_stepA
	.byt 0*12+0 
	.byt END	
	
List_stepA
	.byt NON, TOFF, NVAL, 10 ;Activate for grass
	.byt ENV, FIRST_SFX_ENV+0, ORN, FIRST_SFX_ORN+0, FIRST_SFX_PAT+0	
	.byt NOFF, TON
	.byt END

sfx_pick
	.byt 7*12
	.byt END
List_pick
	.byt ENV, FIRST_SFX_ENV+1, ORN, FIRST_SFX_ORN+1, FIRST_SFX_PAT+1, END	
		
sfx_drop
	.byt 7*12
	.byt END
List_drop
	.byt ENV, FIRST_SFX_ENV+2, ORN, FIRST_SFX_ORN+2, FIRST_SFX_PAT+2,END	
	
sfx_door
	.byt 3*12+0,RST+3
	.byt END	
List_door
	.byt NON, TOFF, NVAL, 1
	.byt ENV, FIRST_SFX_ENV+3, ORN,  FIRST_SFX_ORN+3, FIRST_SFX_PAT+3
	.byt NOFF, TON, END

sfx_beeple
	.byt 6*12+0 
	.byt END	
List_beeple
	.byt ENV, FIRST_SFX_ENV+4, ORN, FIRST_SFX_ORN+3, FIRST_SFX_PAT+4, END		

sfx_chuic
	.byt 5*12+10
	.byt END	
List_chuic
	.byt ENV, FIRST_SFX_ENV+5, ORN, FIRST_SFX_ORN+4, FIRST_SFX_PAT+5, END

sfx_success
	.byt 4*12+CS_,4*12+CS_,RST+1,3*12+B_,3*12+B_,RST+1
	.byt 4*12+CS_,4*12+CS_,3*12+B_,3*12+B_, 4*12+CS_,4*12+CS_
	.byt RST+4
	.byt END
List_success
	.byt ENV, 1, ORN, 3, FIRST_SFX_PAT+6, END	
	
sfx_minitune1
	.byt 5*12+C_,RST+1,5*12+D_,RST+1		
	.byt 5*12+F_,RST+1+2,5*12+E_,RST,5*12+E_/*(OCTM-1)*12+B_*/,RST+2+4
	.byt END
List_minitune1
	.byt SETVOL, 1
	.byt ENV, 1, ORN, 0, FIRST_SFX_PAT+7
	.byt SETVOL, 0
	.byt END

sfx_thrill1
	.byt 2*12+C_,RST,1*12+AS_,RST,1*12+GS_,RST,1*12+G_,RST+3
	.byt END
List_thrill1
	.byt ENV, 0, ORN, 4, FIRST_SFX_PAT+8, END

sfx_teleport
	.byt 2*12+4,RST+10
	.byt SETFLG+1
	.byt END	
List_teleport
	.byt ENV, 2, ORN, FIRST_SFX_ORN+5, FIRST_SFX_PAT+9, NOFFSET, 15,ORN,FIRST_SFX_ORN+6 , FIRST_SFX_PAT+9,NOFFSET, 0 
	.byt END
	
sfx_alert
	.byt (4+1)*12+0, RST+2, SIL, RST+2
	.byt END
List_alert
	.byt SETVOL, 2, ENV, FIRST_SFX_ENV+6, ORN, 1/*FIRST_SFX_ORN+4*/, FIRST_SFX_PAT+10, LOOP, 6, END	
sfx_shoot
	.byt 6*12+8,RST
	.byt END	
List_shoot
	.byt ENV, FIRST_SFX_ENV+7, ORN, FIRST_SFX_ORN+7, FIRST_SFX_PAT+13
	.byt END	
	
sfx_uiA
	.byt 6*12 
	.byt END	
List_uiA
	.byt SETVOL, 2 ,ENV, FIRST_SFX_ENV+0, ORN, 0, FIRST_SFX_PAT+14	
	.byt END	
sfx_uiB
	.byt 7*12 
	.byt END	
List_uiB
	.byt SETVOL, 2 ,ENV, FIRST_SFX_ENV+0, ORN, 0, FIRST_SFX_PAT+15	
	.byt END	

sfx_ESC
	.byt 3*12,RST
	.byt END	
List_ESC
	.byt SETVOL, 1 ,ENV, 4, ORN, 1, FIRST_SFX_PAT+16	
	.byt END
sfx_trr
	.byt 0*12+3,RST+1
	.byt END	
List_trr
	.byt SETVOL,4
	.byt ENV, FIRST_SFX_ENV+1, ORN,  1, FIRST_SFX_PAT+17
	.byt END	
	
#ifdef SPEECHSOUND	
List_speech
	.byt SETVOL, 15, ENV,FIRST_SFX_ENV+9,ORN,FIRST_SFX_ORN+12, FIRST_SFX_PAT+18,END
#endif
	
; Fade table for room transitions
fade_table .byt A_FWBLACK, A_FWBLUE, A_FWCYAN, A_FWWHITE	
	
; Random seed
randseed .word $dead 	; will it be $dead again? 	

	
; Include the character font here
#include "build\files\BFont6x8.asm"



