;;;;;;;;;;;;;;;;;;;;;;;;;;;
; OASIS resource data file
;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Common header
#include "..\params.h"
#include "..\object.h"
#include "..\script.h"
#include "..\resource.h"
#include "..\verbs.h"

#include "..\gameids.h"

#include "..\language.h"

*=$500

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Room: Laundry
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.(
	.byt RESOURCE_ROOM
	.word (res_end - res_start + 4)
	.byt 52
res_start
; No. columns, offset to tile map, offset to tiles
	.byt 38, <(column_data-res_start), >(column_data-res_start), <(tiles_start-res_start), >(tiles_start-res_start)
; No. zplanes and offsets to zplanes
	.byt 0
; No. Walkboxes and offsets to wb data and matrix
	.byt 1, <(wb_data-res_start), >(wb_data-res_start), <(wb_matrix-res_start), >(wb_matrix-res_start)
; Offset to palette
	.byt 0, 0	; No palette information
; Entry and exit scripts
	.byt 255, 255
; Number of objects in the room and list of ids
	.byt 2,200,201
; Room name (null terminated)
	.asc "Laundry", 0
; Room tile map
column_data
	.byt 001, 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 094
	.byt 002, 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 090, 095
	.byt 003, 008, 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 084, 091, 086
	.byt 004, 009, 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 085, 087, 087
	.byt 004, 002, 007, 007, 007, 014, 014, 014, 014, 014, 014, 014, 014, 076, 086, 086, 086
	.byt 004, 010, 014, 014, 014, 030, 034, 034, 051, 030, 034, 034, 051, 077, 087, 087, 087
	.byt 004, 004, 015, 007, 007, 031, 035, 042, 052, 031, 035, 042, 052, 078, 086, 086, 086
	.byt 004, 004, 015, 007, 007, 032, 036, 043, 053, 032, 036, 043, 053, 079, 087, 087, 087
	.byt 004, 004, 015, 007, 007, 033, 037, 044, 054, 033, 037, 044, 054, 078, 086, 086, 086
	.byt 004, 004, 015, 007, 007, 030, 034, 034, 051, 030, 034, 034, 051, 079, 087, 087, 087
	.byt 004, 004, 015, 007, 007, 031, 035, 042, 052, 031, 035, 042, 052, 078, 086, 086, 086
	.byt 004, 004, 015, 007, 007, 032, 036, 043, 053, 032, 036, 043, 053, 079, 087, 087, 087
	.byt 004, 004, 015, 007, 007, 033, 037, 044, 054, 033, 037, 044, 054, 078, 086, 086, 086
	.byt 004, 004, 015, 007, 007, 030, 034, 034, 051, 030, 034, 034, 051, 079, 087, 087, 087
	.byt 004, 004, 015, 007, 007, 031, 035, 042, 052, 031, 035, 042, 052, 078, 086, 086, 086
	.byt 004, 004, 016, 014, 027, 032, 036, 043, 053, 032, 036, 043, 053, 079, 087, 087, 087
	.byt 004, 004, 017, 020, 028, 033, 037, 044, 054, 033, 037, 070, 073, 080, 086, 086, 086
	.byt 004, 004, 017, 021, 028, 030, 034, 034, 051, 030, 034, 071, 074, 081, 087, 087, 087
	.byt 004, 004, 017, 022, 028, 031, 035, 042, 052, 031, 035, 071, 074, 081, 086, 086, 086
	.byt 004, 004, 017, 023, 028, 032, 036, 043, 053, 032, 036, 071, 074, 081, 087, 087, 087
	.byt 004, 004, 017, 024, 028, 033, 037, 044, 054, 033, 037, 071, 074, 081, 086, 086, 086
	.byt 004, 004, 018, 025, 029, 026, 026, 026, 026, 026, 026, 071, 074, 081, 087, 087, 087
	.byt 004, 004, 015, 007, 007, 007, 007, 007, 007, 007, 064, 071, 074, 081, 086, 086, 086
	.byt 004, 004, 015, 007, 007, 007, 007, 007, 055, 059, 065, 071, 074, 081, 087, 087, 087
	.byt 004, 004, 015, 007, 007, 007, 007, 045, 056, 060, 066, 071, 074, 081, 086, 086, 086
	.byt 004, 004, 015, 007, 007, 007, 007, 046, 057, 060, 066, 071, 074, 081, 087, 087, 087
	.byt 004, 004, 015, 007, 007, 007, 007, 007, 058, 061, 067, 071, 074, 081, 086, 086, 086
	.byt 004, 004, 015, 007, 007, 007, 007, 007, 007, 007, 068, 071, 074, 081, 087, 087, 087
	.byt 004, 004, 015, 007, 007, 007, 007, 007, 007, 007, 069, 071, 074, 081, 086, 086, 086
	.byt 004, 004, 015, 007, 007, 007, 038, 047, 047, 047, 047, 071, 074, 081, 087, 087, 087
	.byt 004, 004, 015, 007, 007, 007, 039, 048, 048, 048, 048, 071, 074, 081, 086, 086, 086
	.byt 004, 004, 015, 007, 007, 007, 040, 049, 049, 062, 049, 071, 074, 081, 087, 087, 087
	.byt 004, 004, 015, 007, 007, 007, 041, 050, 050, 063, 050, 071, 074, 081, 086, 086, 086
	.byt 004, 011, 019, 026, 026, 026, 026, 026, 026, 026, 026, 071, 074, 081, 087, 087, 087
	.byt 004, 012, 007, 007, 007, 007, 007, 007, 007, 007, 007, 072, 075, 082, 086, 086, 086
	.byt 004, 013, 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 083, 088, 087, 087
	.byt 005, 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 089, 092, 086
	.byt 006, 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 093, 096

; Room tile set
tiles_start
	.byt $5F, $67, $50, $7F, $55, $7F, $55, $7F	; tile #1
	.byt $7F, $7F, $7F, $4F, $53, $7C, $55, $7F	; tile #2
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $4F, $71	; tile #3
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F	; tile #4
	.byt $7F, $7F, $7F, $7F, $7F, $7E, $79, $47	; tile #5
	.byt $7F, $7F, $7E, $79, $65, $5F, $55, $7F	; tile #6
	.byt $55, $7F, $55, $7F, $55, $7F, $55, $7F	; tile #7
	.byt $54, $7F, $55, $7F, $55, $7F, $55, $7F	; tile #8
	.byt $5F, $67, $51, $7E, $55, $7F, $55, $7F	; tile #9
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $4F, $73	; tile #10
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $7C, $73	; tile #11
	.byt $7F, $7F, $7F, $7C, $71, $4F, $55, $7F	; tile #12
	.byt $7C, $73, $45, $7F, $55, $7F, $55, $7F	; tile #13
	.byt $54, $7E, $54, $7E, $54, $7E, $54, $7E	; tile #14
	.byt $40, $7F, $55, $7F, $55, $7F, $55, $7F	; tile #15
	.byt $40, $7F, $55, $7F, $55, $7F, $54, $7E	; tile #16
	.byt $40, $7F, $55, $7F, $55, $7F, $40, $C0	; tile #17
	.byt $40, $7F, $55, $7F, $55, $7F, $55, $5F	; tile #18
	.byt $45, $5F, $55, $5F, $55, $5F, $55, $5F	; tile #19
	.byt $C3, $C4, $C0, $C0, $C1, $C1, $C2, $C4	; tile #20
	.byt $FE, $F1, $E0, $E1, $FA, $C4, $C1, $C1	; tile #21
	.byt $C0, $C0, $C0, $E6, $E9, $EE, $C8, $C6	; tile #22
	.byt $C0, $C0, $C0, $CC, $D1, $D1, $CA, $F2	; tile #23
	.byt $D0, $E0, $E0, $E0, $F0, $C8, $D0, $D8	; tile #24
	.byt $45, $4F, $45, $4F, $45, $4F, $45, $4F	; tile #25
	.byt $55, $5F, $55, $5F, $55, $5F, $55, $5F	; tile #26
	.byt $54, $7E, $55, $7F, $55, $7F, $55, $7F	; tile #27
	.byt $C0, $40, $40, $7F, $55, $7F, $55, $7F	; tile #28
	.byt $45, $4F, $55, $7F, $55, $7F, $55, $7F	; tile #29
	.byt $40, $E0, $EF, $E9, $EF, $EF, $E0, $FF	; tile #30
	.byt $40, $C0, $C7, $C0, $C7, $C0, $C0, $FF	; tile #31
	.byt $40, $C0, $FC, $C0, $FC, $C0, $C0, $FF	; tile #32
	.byt $40, $C1, $D9, $E5, $ED, $D9, $C1, $FF	; tile #33
	.byt $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0	; tile #34
	.byt $C0, $C0, $C0, $C0, $C0, $C1, $C7, $CD	; tile #35
	.byt $C0, $C0, $C0, $C0, $C0, $E0, $F8, $DC	; tile #36
	.byt $C1, $C1, $C1, $C1, $C1, $C1, $C1, $C1	; tile #37
	.byt $40, $5F, $50, $57, $55, $57, $57, $57	; tile #38
	.byt $40, $7F, $40, $7F, $77, $7F, $5D, $7F	; tile #39
	.byt $40, $7F, $40, $7F, $5D, $7F, $77, $7F	; tile #40
	.byt $40, $7F, $41, $7D, $75, $7D, $5D, $7D	; tile #41
	.byt $DF, $D5, $FF, $F5, $FF, $F5, $FF, $D5	; tile #42
	.byt $FE, $D6, $FF, $D5, $FC, $D5, $FF, $D6	; tile #43
	.byt $C1, $C1, $C1, $C1, $F1, $C1, $C1, $C1	; tile #44
	.byt $55, $7F, $54, $7B, $5B, $7B, $54, $7E	; tile #45
	.byt $55, $7F, $4D, $77, $75, $77, $4D, $5F	; tile #46
	.byt $55, $57, $57, $57, $55, $57, $57, $57	; tile #47
	.byt $77, $7F, $5D, $7F, $77, $7F, $5D, $7F	; tile #48
	.byt $5D, $7F, $77, $7F, $5D, $7F, $77, $7F	; tile #49
	.byt $75, $7D, $5D, $7D, $75, $7D, $5D, $7D	; tile #50
	.byt $E0, $E0, $E0, $E0, $E0, $E0, $E0, $FF	; tile #51
	.byt $DF, $CD, $C7, $C1, $C0, $C0, $C0, $FF	; tile #52
	.byt $FE, $DC, $F8, $E0, $C0, $C0, $C0, $FF	; tile #53
	.byt $C1, $C1, $C1, $C1, $C1, $C1, $C1, $FF	; tile #54
	.byt $55, $7F, $50, $6F, $40, $6D, $41, $6D	; tile #55
	.byt $54, $7C, $40, $7F, $40, $7F, $63, $63	; tile #56
	.byt $4D, $4F, $40, $7F, $40, $7F, $71, $71	; tile #57
	.byt $55, $7F, $41, $7D, $41, $6D, $61, $6D	; tile #58
	.byt $41, $6E, $40, $6F, $40, $70, $53, $78	; tile #59
	.byt $7F, $7F, $40, $7F, $40, $40, $7F, $40	; tile #60
	.byt $61, $5D, $41, $7D, $41, $43, $75, $47	; tile #61
	.byt $5D, $7F, $76, $7F, $5D, $7F, $77, $7F	; tile #62
	.byt $75, $45, $5D, $7D, $75, $7D, $5D, $7D	; tile #63
	.byt $55, $7E, $74, $64, $44, $7E, $41, $63	; tile #64
	.byt $40, $40, $4A, $40, $48, $40, $4A, $40	; tile #65
	.byt $40, $FF, $6A, $40, $6A, $40, $6A, $40	; tile #66
	.byt $41, $40, $6A, $40, $62, $40, $6A, $40	; tile #67
	.byt $55, $5F, $4B, $49, $48, $5F, $60, $71	; tile #68
	.byt $55, $7F, $55, $7F, $75, $7F, $75, $7F	; tile #69
	.byt $60, $5F, $5F, $5F, $5F, $5F, $5F, $5F	; tile #70
	.byt $40, $7F, $7F, $7F, $7F, $7F, $7F, $7F	; tile #71
	.byt $40, $7E, $7E, $7E, $7E, $7E, $7E, $7E	; tile #72
	.byt $6F, $70, $C4, $C2, $C3, $C2, $C4, $40	; tile #73
	.byt $7F, $40, $C0, $C0, $FF, $C0, $C0, $40	; tile #74
	.byt $7E, $5E, $5E, $5E, $5E, $5E, $5E, $5E	; tile #75
	.byt $54, $7F, $54, $7D, $53, $75, $4F, $57	; tile #76
	.byt $40, $57, $7F, $5D, $7F, $77, $7F, $5D	; tile #77
	.byt $40, $5D, $7F, $77, $7F, $5D, $7F, $77	; tile #78
	.byt $40, $77, $7F, $5D, $7F, $77, $7F, $5D	; tile #79
	.byt $4F, $5F, $5F, $5F, $5F, $5F, $5F, $60	; tile #80
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $7F, $40	; tile #81
	.byt $7E, $7E, $7E, $7E, $7E, $7E, $7E, $40	; tile #82
	.byt $55, $7F, $55, $7F, $55, $7F, $55, $5F	; tile #83
	.byt $55, $7F, $55, $7F, $55, $7F, $54, $7D	; tile #84
	.byt $54, $7D, $53, $75, $4F, $57, $7F, $5D	; tile #85
	.byt $7F, $5D, $7F, $77, $7F, $5D, $7F, $77	; tile #86
	.byt $7F, $77, $7F, $5D, $7F, $77, $7F, $5D	; tile #87
	.byt $65, $77, $79, $5D, $7E, $77, $7F, $5D	; tile #88
	.byt $55, $7F, $55, $7F, $55, $5F, $65, $77	; tile #89
	.byt $55, $7F, $55, $7F, $54, $7D, $53, $75	; tile #90
	.byt $53, $75, $4F, $57, $7F, $5D, $7F, $77	; tile #91
	.byt $79, $5D, $7E, $77, $7F, $5D, $7F, $77	; tile #92
	.byt $55, $7F, $55, $5F, $65, $77, $79, $5D	; tile #93
	.byt $55, $7F, $54, $7D, $53, $75, $4F, $57	; tile #94
	.byt $4F, $57, $7F, $5D, $7F, $77, $7F, $5D	; tile #95
	.byt $7E, $77, $7F, $5D, $7F, $77, $7F, $5D	; tile #96
; Walkbox Data
wb_data
	.byt 016, 031, 014, 016, $00
; Walk matrix
wb_matrix
	.byt 0


res_end
.)

; Exit to corridor
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 200
res_start
	.byt OBJ_FLAG_PROP	; If OBJ_FLAG_PROP skip all costume data
	.byt 38,1		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 0,16		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt 16,16		; Walk position (col, row)
	.byt FACING_DOWN	; Facing direction for interaction
	.byt 00			; Color of text
#ifdef ENGLISH
	.asc "Exit",0
#endif
#ifdef SPANISH
	.asc "Salida",0
#endif
res_end	
.)

; Robot in laundry
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 201
res_start
	.byt 0			; If OBJ_FLAG_PROP skip all costume data
	.byt 4,2		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 23,9		; Pos (col, row)
	.byt ZPLANE_0		; Zplane
	.byt 28,14		; Walk position (col, row)
	.byt FACING_LEFT	; Facing direction for interaction
	.byt 00			; Color of text
	; tiles and pointers to animatory states are setup in the costume
	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt 200		; costume ($ff for none) and skip the rest
	.byt 0			; entry in costume resource		
	.byt 0			; direction (0 or LOOK_RIGHT for animstate 0)
	.byt 0			; animation speed	
#ifdef ENGLISH
	.asc "Robot",0
#endif
#ifdef SPANISH
	.asc "Robot",0
#endif
res_end	
.)





; Costume for robot in laundry
.(
.byt RESOURCE_COSTUME
.word (res_end - res_start + 4)
.byt 200
res_start
	; Pointers to tiles
	.byt <(costume_tiles-res_start-8), >(costume_tiles-res_start-8)
	.byt <(costume_masks-res_start-8), >(costume_masks-res_start-8)
	; Number of costumes included
	.byt 1
	;Offsets to animatory states for each costume
	.byt <(anim_states - res_start), >(anim_states - res_start)
anim_states
; Animatory state 0 (laundryrobot0.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 0
.byt 5, 6, 6, 7, 0
; Animatory state 1 (laundryrobot1.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 0
.byt 5, 8, 9, 7, 0
costume_tiles
; Tile graphic 1
.byt $0, $0, $0, $f, $0, $d, $1, $d
; Tile graphic 2
.byt $0, $0, $0, $3f, $0, $3f, $23, $23
; Tile graphic 3
.byt $0, $0, $0, $3f, $0, $3f, $31, $31
; Tile graphic 4
.byt $0, $0, $0, $3c, $0, $2c, $20, $2c
; Tile graphic 5
.byt $1, $e, $0, $f, $0, $0, $3, $0
; Tile graphic 6
.byt $3f, $3f, $0, $3f, $0, $0, $3f, $0
; Tile graphic 7
.byt $20, $1c, $0, $3c, $0, $0, $30, $0
; Tile graphic 8
.byt $3e, $38, $0, $3f, $0, $0, $3f, $0
; Tile graphic 9
.byt $1f, $7, $0, $3f, $0, $0, $3f, $0
costume_masks
; Tile mask 1
.byt $ff, $ff, $70, $60, $60, $60, $60, $60
; Tile mask 2
.byt $7e, $7c, $40, $40, $40, $40, $40, $40
; Tile mask 3
.byt $5f, $4f, $40, $40, $40, $40, $40, $40
; Tile mask 4
.byt $ff, $ff, $43, $41, $41, $41, $41, $41
; Tile mask 5
.byt $60, $60, $60, $60, $60, $70, $78, $78
; Tile mask 6
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 7
.byt $41, $41, $41, $41, $41, $43, $47, $47
; Tile mask 8
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 9
.byt $40, $40, $40, $40, $40, $40, $40, $40
res_end
.)



#include "..\scripts\laundry.s"

