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
; Room: London-cell
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.(
	.byt RESOURCE_ROOM
	.word (res_end - res_start + 4)
	.byt 15
res_start
; No. columns, offset to tile map, offset to tiles
	.byt 51, <(column_data-res_start), >(column_data-res_start), <(tiles_start-res_start), >(tiles_start-res_start)
; No. zplanes and offsets to zplanes
	.byt 0
; No. Walkboxes and offsets to wb data and matrix
	.byt 6, <(wb_data-res_start), >(wb_data-res_start), <(wb_matrix-res_start), >(wb_matrix-res_start)
; Offset to palette
	.byt 0, 0	; No palette information
; Entry and exit scripts
	.byt 255, 255
; Number of objects in the room and list of ids
	.byt 5,200,201,202,203,204
; Room name (null terminated)
	.asc "London-cell", 0
; Room tile map
column_data
	.byt 001, 001, 020, 028, 028, 028, 075, 095, 102, 108, 116, 126, 126, 152, 163, 168, 174
	.byt 001, 001, 021, 028, 028, 028, 076, 000, 000, 000, 000, 000, 000, 153, 001, 169, 001
	.byt 002, 001, 022, 029, 028, 028, 077, 000, 000, 000, 000, 096, 136, 154, 001, 001, 001
	.byt 003, 001, 001, 030, 028, 028, 078, 096, 103, 109, 117, 001, 137, 155, 001, 001, 001
	.byt 004, 012, 001, 031, 028, 028, 079, 097, 001, 110, 118, 127, 138, 156, 001, 001, 001
	.byt 005, 013, 001, 032, 029, 028, 080, 001, 104, 111, 119, 028, 139, 156, 001, 001, 001
	.byt 005, 014, 023, 033, 039, 055, 081, 098, 028, 028, 028, 028, 139, 156, 001, 001, 001
	.byt 005, 005, 024, 028, 028, 028, 028, 028, 028, 028, 028, 028, 139, 156, 001, 001, 001
	.byt 005, 005, 024, 028, 028, 028, 028, 028, 028, 028, 028, 028, 139, 156, 001, 001, 001
	.byt 005, 005, 024, 028, 040, 056, 082, 040, 056, 082, 040, 056, 140, 156, 001, 001, 001
	.byt 005, 005, 024, 028, 041, 057, 083, 041, 057, 083, 041, 057, 141, 156, 001, 001, 001
	.byt 005, 005, 024, 028, 042, 058, 084, 042, 058, 084, 042, 058, 142, 156, 001, 001, 001
	.byt 005, 005, 024, 028, 043, 059, 083, 043, 059, 083, 043, 059, 141, 156, 001, 001, 001
	.byt 005, 005, 024, 028, 043, 059, 083, 043, 059, 083, 043, 059, 141, 156, 001, 001, 001
	.byt 005, 005, 024, 028, 043, 059, 083, 043, 059, 083, 043, 059, 141, 156, 001, 001, 001
	.byt 005, 005, 024, 028, 043, 059, 083, 043, 059, 083, 043, 059, 141, 156, 001, 001, 001
	.byt 005, 005, 024, 028, 043, 059, 083, 043, 059, 083, 043, 059, 141, 156, 001, 001, 001
	.byt 005, 005, 024, 028, 043, 059, 083, 043, 059, 083, 043, 059, 141, 156, 001, 001, 001
	.byt 005, 005, 024, 028, 043, 060, 084, 043, 060, 084, 043, 060, 142, 156, 001, 001, 001
	.byt 005, 005, 024, 028, 043, 061, 083, 043, 061, 083, 043, 061, 141, 156, 001, 001, 001
	.byt 005, 005, 024, 028, 044, 062, 085, 044, 062, 085, 044, 062, 143, 156, 001, 001, 001
	.byt 005, 005, 024, 028, 045, 063, 063, 063, 063, 063, 063, 063, 144, 156, 001, 001, 001
	.byt 005, 005, 024, 028, 046, 064, 064, 064, 064, 064, 064, 064, 064, 156, 001, 001, 001
	.byt 005, 005, 024, 028, 047, 065, 065, 065, 065, 065, 065, 065, 065, 156, 001, 001, 001
	.byt 005, 005, 024, 028, 048, 066, 066, 066, 066, 066, 066, 128, 145, 156, 001, 001, 001
	.byt 006, 005, 024, 028, 049, 067, 086, 099, 105, 112, 120, 129, 139, 156, 001, 001, 001
	.byt 007, 015, 024, 028, 049, 068, 087, 099, 106, 112, 121, 129, 139, 156, 001, 001, 001
	.byt 008, 016, 024, 028, 050, 069, 069, 069, 069, 069, 069, 130, 139, 156, 001, 001, 001
	.byt 005, 005, 024, 028, 045, 063, 063, 063, 063, 063, 063, 063, 144, 156, 001, 001, 001
	.byt 005, 005, 024, 028, 046, 064, 064, 064, 064, 064, 064, 064, 064, 156, 001, 001, 001
	.byt 005, 005, 024, 028, 047, 065, 065, 065, 065, 065, 065, 065, 065, 156, 001, 001, 001
	.byt 005, 005, 024, 028, 051, 070, 088, 051, 070, 088, 051, 070, 146, 156, 001, 001, 001
	.byt 005, 005, 024, 028, 043, 071, 083, 043, 071, 083, 043, 071, 141, 156, 001, 001, 001
	.byt 005, 005, 024, 028, 043, 058, 084, 043, 058, 084, 043, 058, 142, 156, 001, 001, 001
	.byt 005, 005, 024, 028, 043, 059, 083, 043, 059, 083, 043, 059, 141, 156, 001, 001, 001
	.byt 005, 005, 024, 028, 043, 059, 083, 043, 059, 083, 043, 059, 141, 156, 001, 001, 001
	.byt 005, 005, 024, 028, 043, 059, 083, 043, 059, 083, 043, 059, 141, 156, 001, 001, 001
	.byt 005, 005, 024, 028, 043, 059, 083, 043, 059, 083, 043, 059, 141, 156, 001, 001, 001
	.byt 005, 005, 024, 028, 043, 059, 083, 043, 059, 083, 043, 059, 141, 156, 001, 001, 001
	.byt 005, 005, 024, 028, 043, 059, 083, 043, 059, 083, 043, 059, 141, 156, 001, 001, 001
	.byt 005, 005, 024, 028, 043, 060, 084, 043, 060, 084, 043, 060, 142, 156, 001, 001, 001
	.byt 005, 005, 024, 028, 052, 072, 083, 052, 072, 083, 052, 072, 141, 156, 001, 001, 001
	.byt 005, 005, 024, 028, 053, 073, 085, 053, 073, 085, 053, 073, 143, 156, 001, 001, 001
	.byt 005, 005, 024, 028, 028, 028, 028, 028, 028, 028, 028, 028, 139, 156, 001, 001, 001
	.byt 005, 005, 024, 028, 028, 028, 028, 028, 028, 028, 028, 131, 147, 157, 001, 001, 001
	.byt 005, 017, 025, 034, 054, 074, 089, 100, 028, 028, 028, 132, 148, 158, 164, 001, 001
	.byt 005, 018, 001, 035, 038, 028, 090, 001, 107, 113, 122, 133, 149, 159, 165, 170, 001
	.byt 009, 019, 001, 036, 028, 028, 091, 001, 001, 114, 123, 134, 150, 160, 166, 171, 001
	.byt 010, 001, 001, 037, 028, 028, 092, 001, 001, 115, 101, 135, 151, 160, 167, 172, 175
	.byt 011, 001, 026, 038, 028, 028, 093, 001, 001, 001, 124, 001, 001, 161, 160, 173, 176
	.byt 001, 001, 027, 028, 028, 028, 094, 101, 001, 001, 125, 001, 001, 162, 160, 160, 159

; Room tile set
tiles_start
	.byt $6A, $55, $6A, $55, $6A, $55, $6A, $55	; tile #1
	.byt $E0, $F8, $69, $54, $6A, $55, $6A, $55	; tile #2
	.byt $C0, $C0, $C0, $E0, $D8, $53, $68, $55	; tile #3
	.byt $C0, $C0, $C0, $C0, $C0, $C0, $C0, $F0	; tile #4
	.byt $C0, $C0, $C0, $C0, $C0, $C0, $C0, $C0	; tile #5
	.byt $C0, $C0, $C3, $CF, $6B, $D6, $CE, $C7	; tile #6
	.byt $C0, $C0, $FF, $FF, $7F, $55, $7F, $C0	; tile #7
	.byt $C0, $C0, $F8, $FE, $7A, $ED, $CE, $DC	; tile #8
	.byt $C0, $C0, $C0, $C0, $C0, $C0, $C0, $C3	; tile #9
	.byt $C0, $C0, $C0, $C1, $C7, $75, $4A, $55	; tile #10
	.byt $C1, $C6, $62, $55, $6A, $55, $6A, $55	; tile #11
	.byt $DC, $54, $6A, $55, $6A, $55, $6A, $55	; tile #12
	.byt $C0, $C0, $E0, $F8, $69, $54, $6A, $55	; tile #13
	.byt $C0, $C0, $C0, $C0, $C0, $E0, $D8, $EC	; tile #14
	.byt $FF, $CE, $C0, $C0, $C0, $C0, $C0, $C0	; tile #15
	.byt $E0, $C0, $C0, $C0, $C0, $C0, $C0, $C0	; tile #16
	.byt $C0, $C0, $C0, $C0, $C0, $C1, $C3, $CE	; tile #17
	.byt $C0, $C0, $C1, $C6, $62, $55, $6A, $55	; tile #18
	.byt $CD, $45, $6A, $55, $6A, $55, $6A, $55	; tile #19
	.byt $4A, $51, $7C, $55, $7F, $55, $7F, $55	; tile #20
	.byt $6A, $55, $6A, $45, $78, $54, $7F, $55	; tile #21
	.byt $6A, $55, $6A, $55, $6A, $55, $62, $51	; tile #22
	.byt $68, $54, $69, $55, $69, $51, $6B, $55	; tile #23
	.byt $40, $55, $7F, $55, $7F, $55, $7F, $55	; tile #24
	.byt $4A, $45, $4A, $45, $6A, $55, $72, $51	; tile #25
	.byt $6A, $55, $6A, $55, $6A, $54, $69, $45	; tile #26
	.byt $6A, $55, $6A, $50, $67, $55, $7F, $55	; tile #27
	.byt $7F, $55, $7F, $55, $7F, $55, $7F, $55	; tile #28
	.byt $7E, $55, $7F, $55, $7F, $55, $7F, $55	; tile #29
	.byt $4A, $41, $7C, $55, $7F, $55, $7F, $55	; tile #30
	.byt $6A, $55, $6A, $45, $72, $54, $7F, $55	; tile #31
	.byt $6A, $55, $6A, $55, $6A, $55, $4A, $50	; tile #32
	.byt $67, $55, $6F, $45, $5F, $55, $5F, $55	; tile #33
	.byt $7A, $51, $7C, $55, $7E, $54, $7E, $55	; tile #34
	.byt $6A, $55, $6A, $55, $6A, $55, $68, $41	; tile #35
	.byt $6A, $55, $6A, $54, $63, $45, $7F, $55	; tile #36
	.byt $6A, $51, $4F, $55, $7F, $55, $7F, $55	; tile #37
	.byt $5F, $55, $7F, $55, $7F, $55, $7F, $55	; tile #38
	.byt $5F, $55, $6F, $45, $6F, $55, $77, $55	; tile #39
	.byt $7F, $56, $7C, $50, $78, $52, $60, $40	; tile #40
	.byt $7F, $41, $64, $40, $40, $48, $40, $40	; tile #41
	.byt $7F, $55, $40, $5F, $5F, $5F, $7F, $7F	; tile #42
	.byt $7F, $55, $40, $7F, $7F, $7F, $7F, $7F	; tile #43
	.byt $7F, $55, $4F, $65, $67, $75, $73, $79	; tile #44
	.byt $7F, $58, $77, $78, $7F, $70, $60, $60	; tile #45
	.byt $7F, $40, $7F, $40, $7F, $40, $40, $40	; tile #46
	.byt $7F, $43, $7D, $43, $7F, $41, $40, $40	; tile #47
	.byt $7F, $55, $7F, $55, $7F, $5F, $7B, $75	; tile #48
	.byt $7F, $55, $7F, $55, $7F, $55, $7F, $40	; tile #49
	.byt $7F, $55, $7F, $55, $7F, $5F, $7B, $55	; tile #50
	.byt $7F, $55, $7C, $51, $7B, $53, $77, $57	; tile #51
	.byt $7F, $60, $49, $40, $40, $44, $40, $40	; tile #52
	.byt $7F, $55, $4F, $45, $43, $53, $41, $40	; tile #53
	.byt $7E, $54, $7D, $55, $7D, $51, $7B, $51	; tile #54
	.byt $7B, $51, $7D, $55, $7D, $54, $7E, $54	; tile #55
	.byt $4F, $50, $40, $5F, $40, $4F, $4F, $40	; tile #56
	.byt $71, $49, $43, $7F, $40, $7F, $7F, $40	; tile #57
	.byt $60, $5F, $50, $57, $50, $57, $57, $50	; tile #58
	.byt $40, $7F, $40, $7F, $40, $7F, $7F, $40	; tile #59
	.byt $4F, $77, $57, $57, $50, $57, $57, $50	; tile #60
	.byt $7F, $7F, $7F, $7F, $40, $7F, $7F, $40	; tile #61
	.byt $7B, $79, $7D, $7D, $41, $79, $79, $41	; tile #62
	.byt $60, $63, $67, $6F, $60, $60, $60, $60	; tile #63
	.byt $40, $7F, $7F, $7F, $40, $40, $40, $40	; tile #64
	.byt $40, $78, $7C, $7E, $40, $40, $40, $40	; tile #65
	.byt $75, $75, $75, $75, $75, $75, $75, $75	; tile #66
	.byt $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E2	; tile #67
	.byt $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E8	; tile #68
	.byt $55, $55, $55, $55, $55, $55, $55, $55	; tile #69
	.byt $67, $4F, $60, $4F, $60, $47, $67, $40	; tile #70
	.byt $7F, $7F, $40, $7F, $40, $7F, $7F, $40	; tile #71
	.byt $63, $64, $70, $7F, $40, $7F, $7F, $40	; tile #72
	.byt $7C, $42, $40, $7D, $41, $79, $79, $41	; tile #73
	.byt $77, $55, $6F, $45, $6F, $45, $5F, $55	; tile #74
	.byt $7F, $55, $7F, $54, $78, $54, $7E, $50	; tile #75
	.byt $7F, $55, $70, $40, $40, $40, $40, $40	; tile #76
	.byt $7E, $40, $40, $40, $40, $40, $40, $40	; tile #77
	.byt $47, $41, $40, $40, $40, $40, $40, $40	; tile #78
	.byt $7F, $55, $7F, $55, $48, $41, $4A, $55	; tile #79
	.byt $7F, $54, $78, $45, $4A, $55, $6A, $55	; tile #80
	.byt $70, $45, $69, $55, $6B, $51, $6B, $55	; tile #81
	.byt $40, $60, $7F, $55, $7F, $55, $7F, $55	; tile #82
	.byt $40, $40, $7F, $55, $7F, $55, $7F, $55	; tile #83
	.byt $50, $40, $7F, $55, $7F, $55, $7F, $55	; tile #84
	.byt $41, $43, $7F, $55, $7F, $55, $7F, $55	; tile #85
	.byt $E2, $E2, $E0, $E0, $E0, $E0, $E0, $E0	; tile #86
	.byt $E8, $E8, $E0, $E0, $E0, $E0, $E0, $E0	; tile #87
	.byt $60, $50, $7F, $55, $7F, $55, $7F, $55	; tile #88
	.byt $43, $44, $6A, $45, $72, $55, $72, $51	; tile #89
	.byt $7F, $45, $60, $55, $6A, $55, $6A, $55	; tile #90
	.byt $7F, $55, $5F, $41, $6A, $55, $6A, $55	; tile #91
	.byt $7F, $55, $7F, $55, $47, $50, $6A, $55	; tile #92
	.byt $7F, $55, $7F, $55, $7F, $55, $61, $54	; tile #93
	.byt $7F, $55, $7F, $55, $7F, $55, $7F, $45	; tile #94
	.byt $42, $54, $6A, $54, $6A, $54, $6A, $54	; tile #95
	.byt $40, $40, $40, $40, $40, $41, $40, $41	; tile #96
	.byt $4A, $55, $6A, $55, $6A, $55, $6A, $55	; tile #97
	.byt $67, $55, $6F, $45, $6F, $55, $5F, $55	; tile #98
	.byt $E0, $E0, $FF, $E0, $E0, $E0, $E0, $E0	; tile #99
	.byt $7A, $51, $7C, $55, $7C, $54, $7E, $54	; tile #100
	.byt $68, $55, $6A, $55, $6A, $55, $6A, $55	; tile #101
	.byt $6A, $54, $68, $54, $68, $54, $68, $54	; tile #102
	.byt $42, $41, $42, $41, $42, $45, $42, $45	; tile #103
	.byt $6A, $54, $6A, $54, $69, $55, $69, $51	; tile #104
	.byt $E0, $E0, $E2, $E2, $E2, $E0, $E0, $E0	; tile #105
	.byt $E0, $E0, $E8, $E8, $E8, $E0, $E0, $E0	; tile #106
	.byt $4A, $55, $4A, $55, $6A, $45, $6A, $55	; tile #107
	.byt $64, $54, $64, $54, $64, $54, $64, $54	; tile #108
	.byt $42, $45, $4A, $45, $4A, $45, $4A, $45	; tile #109
	.byt $68, $42, $E1, $52, $ED, $52, $E3, $41	; tile #110
	.byt $6B, $51, $67, $55, $67, $45, $6F, $45	; tile #111
	.byt $E0, $E0, $E0, $E0, $E0, $FF, $E0, $E0	; tile #112
	.byt $72, $55, $7A, $50, $7A, $55, $7C, $55	; tile #113
	.byt $6A, $55, $6A, $55, $42, $51, $6A, $55	; tile #114
	.byt $6A, $55, $6A, $55, $6A, $55, $4A, $41	; tile #115
	.byt $64, $44, $64, $44, $64, $64, $64, $64	; tile #116
	.byt $4A, $55, $4A, $55, $4A, $55, $6A, $55	; tile #117
	.byt $6A, $F6, $62, $F6, $62, $41, $6A, $54	; tile #118
	.byt $5F, $55, $5F, $55, $5F, $55, $7F, $55	; tile #119
	.byt $E0, $E0, $E0, $E0, $E2, $E2, $E2, $E0	; tile #120
	.byt $E0, $E0, $E0, $E0, $E8, $E8, $E8, $E0	; tile #121
	.byt $7E, $54, $7E, $55, $7F, $55, $7F, $55	; tile #122
	.byt $6A, $55, $6A, $55, $4A, $55, $6A, $45	; tile #123
	.byt $6A, $45, $62, $54, $6A, $55, $6A, $55	; tile #124
	.byt $6A, $55, $6A, $55, $62, $51, $6A, $55	; tile #125
	.byt $64, $64, $64, $64, $64, $64, $64, $64	; tile #126
	.byt $69, $55, $6B, $51, $6B, $55, $67, $55	; tile #127
	.byt $75, $75, $75, $75, $75, $75, $7B, $7F	; tile #128
	.byt $E0, $E0, $E0, $E0, $E0, $E0, $E0, $40	; tile #129
	.byt $55, $55, $55, $55, $55, $55, $5B, $5F	; tile #130
	.byt $7F, $55, $7F, $58, $CD, $54, $CA, $55	; tile #131
	.byt $7F, $55, $7F, $40, $D5, $40, $EA, $55	; tile #132
	.byt $7F, $55, $7F, $43, $D7, $44, $EA, $54	; tile #133
	.byt $6A, $55, $72, $51, $78, $55, $4F, $60	; tile #134
	.byt $6A, $55, $6A, $55, $6A, $55, $6A, $75	; tile #135
	.byt $40, $41, $42, $41, $42, $41, $42, $41	; tile #136
	.byt $6A, $55, $6A, $55, $6A, $54, $68, $50	; tile #137
	.byt $6F, $45, $6F, $55, $40, $40, $40, $40	; tile #138
	.byt $7F, $55, $7F, $55, $40, $40, $40, $40	; tile #139
	.byt $40, $60, $7F, $55, $40, $40, $40, $40	; tile #140
	.byt $40, $40, $7F, $55, $40, $40, $40, $40	; tile #141
	.byt $50, $40, $7F, $55, $40, $40, $40, $40	; tile #142
	.byt $41, $43, $7F, $55, $40, $40, $40, $40	; tile #143
	.byt $60, $63, $67, $6F, $40, $40, $40, $40	; tile #144
	.byt $7F, $75, $7F, $55, $40, $40, $40, $40	; tile #145
	.byt $60, $50, $7F, $55, $40, $40, $40, $40	; tile #146
	.byt $CA, $55, $CA, $55, $FA, $45, $FA, $45	; tile #147
	.byt $EA, $55, $EA, $55, $EA, $50, $4F, $57	; tile #148
	.byt $EB, $55, $EA, $55, $EB, $40, $7F, $7F	; tile #149
	.byt $ED, $49, $DB, $52, $41, $40, $7F, $7F	; tile #150
	.byt $5A, $4D, $6A, $4D, $4A, $41, $7C, $7E	; tile #151
	.byt $64, $64, $64, $64, $64, $64, $60, $61	; tile #152
	.byt $40, $40, $40, $40, $40, $55, $6A, $55	; tile #153
	.byt $42, $45, $42, $40, $40, $55, $6A, $55	; tile #154
	.byt $60, $45, $4A, $55, $6A, $55, $6A, $55	; tile #155
	.byt $40, $55, $6A, $55, $6A, $55, $6A, $55	; tile #156
	.byt $44, $53, $60, $54, $6A, $55, $6A, $55	; tile #157
	.byt $5B, $5D, $4E, $47, $63, $51, $68, $40	; tile #158
	.byt $7F, $7F, $7F, $5F, $6F, $77, $7B, $5D	; tile #159
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F	; tile #160
	.byt $6A, $71, $7C, $7E, $7F, $7F, $7F, $7F	; tile #161
	.byt $6A, $55, $6A, $55, $6A, $71, $7C, $7E	; tile #162
	.byt $62, $45, $4A, $55, $6A, $55, $6A, $55	; tile #163
	.byt $60, $50, $68, $54, $6A, $55, $6A, $55	; tile #164
	.byt $4E, $47, $43, $41, $40, $40, $60, $50	; tile #165
	.byt $7F, $5F, $6F, $77, $7B, $5D, $4E, $47	; tile #166
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $7F, $5F	; tile #167
	.byt $6A, $55, $40, $40, $40, $40, $40, $41	; tile #168
	.byt $6A, $55, $42, $45, $4A, $55, $6A, $55	; tile #169
	.byt $68, $54, $6A, $55, $6A, $55, $6A, $55	; tile #170
	.byt $43, $41, $40, $40, $60, $50, $68, $54	; tile #171
	.byt $6F, $77, $7B, $5D, $4E, $47, $43, $41	; tile #172
	.byt $7F, $7F, $7F, $7F, $7F, $5F, $6F, $77	; tile #173
	.byt $42, $45, $4A, $55, $6A, $55, $6A, $55	; tile #174
	.byt $40, $40, $60, $50, $68, $54, $6A, $55	; tile #175
	.byt $7B, $5D, $4E, $47, $43, $41, $40, $40	; tile #176
; Walkbox Data
wb_data
	.byt 000, 003, 015, 016, $01
	.byt 004, 037, 013, 016, $01
	.byt 038, 040, 013, 016, $01
	.byt 000, 003, 013, 014, $01
	.byt 041, 041, 013, 016, $01
	.byt 042, 044, 015, 016, $01
; Walk matrix
wb_matrix
	.byt 0, 1, 1, 3, 1, 1
	.byt 0, 1, 2, 3, 2, 2
	.byt 1, 1, 2, 1, 4, 4
	.byt 0, 1, 1, 3, 1, 1
	.byt 2, 2, 2, 2, 4, 5
	.byt 4, 4, 4, 4, 4, 5
res_end
.)




; Object resource 200: Cell door
.(
	.byt RESOURCE_OBJECT|$80
	.word (res_end-res_start+4)
	.byt 200
res_start
	.byt 0
	.byt 1,7	;Size (cols, rows)
	.byt 255	;Initial room
	.byt 0,14	;Location (col, row)
	.byt ZPLANE_0	;Zplane
	.byt 1,14	;Walk position (col, row)
	.byt FACING_LEFT
	.byt 0	; Color of text
	; tiles and pointers to animatory states are setup in the costume
	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt 200		; costume ($ff for none) and skip the rest
	.byt 0			; entry in costume resource		
	.byt 0			; direction (0 or LOOK_RIGHT for animstate 0)
	.byt 0			; animation speed	
#ifdef ENGLISH	
	.asc "Door",0	;Object's name
#endif
#ifdef SPANISH
	.asc "Puerta",0	;Object's name
#endif	
#ifdef FRENCH
	.asc "Porte",0
#endif
res_end
.)


; Object resource 201: Alarm
.(
	.byt RESOURCE_OBJECT|$80
	.word (res_end-res_start+4)
	.byt 201
res_start
	.byt 0|OBJ_FLAG_PROP
	.byt 3,1	;Size (cols, rows)
	.byt 255	;Initial room
	.byt 25,0	;Location (col, row)
	.byt ZPLANE_1	;Zplane
	.byt 25,14	;Walk position (col, row)
	.byt FACING_DOWN
	.byt 0	; Color of text
#ifdef ENGLISH	
	.asc "Alarm",0	;Object's name
#endif
#ifdef SPANISH
	.asc "Alarma",0	;Object's name
#endif		
#ifdef FRENCH
	.asc "Alarme",0
#endif
res_end
.)


; Object resource 202: Dustbin
.(
	.byt RESOURCE_OBJECT|$80
	.word (res_end-res_start+4)
	.byt 202
res_start
	.byt 0|OBJ_FLAG_PROP
	.byt 3,3	;Size (cols, rows)
	.byt 255	;Initial room
	.byt 44,13	;Location (col, row)
	.byt ZPLANE_1	;Zplane
	.byt 39,13	;Walk position (col, row)
	.byt FACING_RIGHT
	.byt 0	; Color of text
#ifdef ENGLISH	
	.asc "Bin",0	;Object's name
#endif
#ifdef SPANISH
	.asc "Papelera",0	;Object's name
#endif		
#ifdef FRENCH
	.asc "Poubelle",0
#endif
res_end
.)


; Object resource 203: Lock
.(
	.byt RESOURCE_OBJECT|$80
	.word (res_end-res_start+4)
	.byt 203
res_start
	.byt 0|OBJ_FLAG_PROP
	.byt 1,3	;Size (cols, rows)
	.byt 255	;Initial room
	.byt 4,10	;Location (col, row)
	.byt ZPLANE_1	;Zplane
	.byt 5,13	;Walk position (col, row)
	.byt FACING_LEFT
	.byt 0	; Color of text
#ifdef ENGLISH	
	.asc "Door lock",0	;Object's name
#endif
#ifdef SPANISH
	.asc "Cerradura",0	;Object's name
#endif	
#ifdef FRENCH
	.asc "Serrure",0
#endif
res_end
.)


; Object resource 204: Lockers
.(
	.byt RESOURCE_OBJECT|$80
	.word (res_end-res_start+4)
	.byt 204
res_start
	.byt 0|OBJ_FLAG_PROP
	.byt 2,7	;Size (cols, rows)
	.byt 255	;Initial room
	.byt 25,11	;Location (col, row)
	.byt ZPLANE_1	;Zplane
	.byt 24,13	;Walk position (col, row)
	.byt FACING_UP
	.byt 0	; Color of text
#ifdef ENGLISH	
	.asc "Lockers",0	;Object's name
#endif
#ifdef SPANISH
	.asc "Taquillas",0	;Object's name
#endif	
#ifdef FRENCH
	.asc "Casiers",0
#endif
res_end
.)


/* Gum wrappers, battery and watch for puzzle here, are all locals... object
object code and strings will be here.
Probably guards entering too! */

; Battery 205
.(
	.byt RESOURCE_OBJECT|$80
	.word (res_end-res_start+4)
	.byt 205
res_start
	.byt OBJ_FLAG_USEDWITHOTHER
	.byt 3,2	;Size (cols, rows)
	.byt ROOM_BROOM	;Initial room
	.byt 0,14	;Location (col, row)
	.byt ZPLANE_1	;Zplane
	.byt 8,14	;Walk position (col, row)
	.byt FACING_LEFT
	.byt 0	; Color of text

	; tiles and pointers to animatory states are setup in the costume
	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt $ff		; costume ($ff for none) and skip the rest
	.byt 0			; entry in costume resource		
	.byt 0			; direction (0 or LOOK_RIGHT for animstate 0)
	.byt 0			; animation speed	
#ifdef ENGLISH	
	.asc "Battery",0	;Object's name
#endif
#ifdef SPANISH
	.asc "Bater","Z"+3,"a",0	;Object's name
#endif	
#ifdef FRENCH
	.asc "Batterie",0
#endif
res_end
.)


; Wrapper: 206
.(
	.byt RESOURCE_OBJECT|$80
	.word (res_end-res_start+4)
	.byt 206
res_start
	.byt OBJ_FLAG_USEDWITHOTHER
	.byt 3,2	;Size (cols, rows)
	.byt ROOM_BROOM	;Initial room
	.byt 0,14	;Location (col, row)
	.byt ZPLANE_1	;Zplane
	.byt 8,14	;Walk position (col, row)
	.byt FACING_LEFT
	.byt 0	; Color of text

	; tiles and pointers to animatory states are setup in the costume
	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt $ff		; costume ($ff for none) and skip the rest
	.byt 0			; entry in costume resource		
	.byt 0			; direction (0 or LOOK_RIGHT for animstate 0)
	.byt 0			; animation speed	
#ifdef ENGLISH	
	.asc "Wrapper",0	;Object's name
#endif
#ifdef SPANISH
	.asc "Envoltorio",0	;Object's name
#endif	
#ifdef FRENCH
	.asc "Emballage",0
#endif
res_end
.)

; Card: 207
.(
	.byt RESOURCE_OBJECT|$80
	.word (res_end-res_start+4)
	.byt 207
res_start
	.byt OBJ_FLAG_USEDWITHOTHER
	.byt 3,2	;Size (cols, rows)
	.byt ROOM_BROOM	;Initial room
	.byt 0,14	;Location (col, row)
	.byt ZPLANE_1	;Zplane
	.byt 8,14	;Walk position (col, row)
	.byt FACING_LEFT
	.byt 0	; Color of text

	; tiles and pointers to animatory states are setup in the costume
	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt $ff		; costume ($ff for none) and skip the rest
	.byt 0			; entry in costume resource		
	.byt 0			; direction (0 or LOOK_RIGHT for animstate 0)
	.byt 0			; animation speed	
#ifdef ENGLISH	
	.asc "Keycard",0	;Object's name
#endif
#ifdef SPANISH
	.asc "Tarjeta",0	;Object's name
#endif	
#ifdef FRENCH
	.asc "Carte",0 ;  [laurentd75]: "Carte d'acces" est mieux, mais peut causer un bug d'affichage persistant
	               ;  si on tente de réaliser l'action "UTILISE Carte d'acces AVEC Jenna Stannis":
	               ;  Cette phrase fait 40 caracteres, et on a donc un "U" parasite qui s'affiche à gauche de
	               ;  la zone de commande et qui déstabilise également l'affichage double-hauteur des actions...
#endif
res_end
.)

/* Local costume for cell door */
.(
.byt RESOURCE_COSTUME|$80
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
; Animatory state 0 (cell-A.png)
.byt 1, 2, 2, 0, 0
.byt 3, 2, 2, 0, 0
.byt 4, 2, 2, 0, 0
.byt 5, 2, 6, 0, 0
.byt 5, 2, 7, 0, 0
.byt 8, 9, 10, 0, 0
.byt 11, 12, 12, 0, 0
; Animatory state 1 (cell-B.png)
.byt 1, 2, 2, 0, 0
.byt 13, 2, 2, 0, 0
.byt 14, 2, 2, 0, 0
.byt 15, 2, 6, 0, 0
.byt 15, 2, 7, 0, 0
.byt 16, 9, 10, 0, 0
.byt 17, 12, 12, 0, 0
; Animatory state 2 (cell-C.png)
.byt 1, 2, 2, 0, 0
.byt 13, 2, 2, 0, 0
.byt 18, 2, 2, 0, 0
.byt 2, 2, 6, 0, 0
.byt 2, 2, 7, 0, 0
.byt 19, 9, 10, 0, 0
.byt 17, 12, 12, 0, 0
costume_tiles
; Tile graphic 1
.byt $2a, $14, $28, $14, $28, $14, $28, $14
; Tile graphic 2
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 3
.byt $24, $14, $24, $14, $24, $14, $24, $14
; Tile graphic 4
.byt $24, $4, $24, $4, $24, $24, $24, $24
; Tile graphic 5
.byt $24, $24, $24, $24, $24, $24, $24, $24
; Tile graphic 6
.byt $0, $0, $0, $0, $0, $1, $0, $1
; Tile graphic 7
.byt $0, $1, $2, $1, $2, $1, $2, $1
; Tile graphic 8
.byt $24, $24, $24, $24, $24, $24, $20, $21
; Tile graphic 9
.byt $0, $0, $0, $0, $0, $15, $2a, $15
; Tile graphic 10
.byt $2, $5, $2, $0, $0, $15, $2a, $15
; Tile graphic 11
.byt $22, $5, $a, $15, $2a, $15, $2a, $15
; Tile graphic 12
.byt $2a, $15, $2a, $15, $2a, $15, $2a, $15
; Tile graphic 13
.byt $20, $10, $20, $10, $20, $10, $20, $10
; Tile graphic 14
.byt $30, $10, $30, $10, $10, $10, $10, $10
; Tile graphic 15
.byt $10, $10, $10, $10, $10, $10, $10, $10
; Tile graphic 16
.byt $10, $10, $10, $10, $10, $10, $10, $11
; Tile graphic 17
.byt $2, $5, $a, $15, $2a, $15, $2a, $15
; Tile graphic 18
.byt $30, $10, $20, $0, $0, $0, $0, $0
; Tile graphic 19
.byt $0, $0, $0, $0, $0, $0, $0, $1
costume_masks
; Tile mask 1
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 2
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 3
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 4
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 5
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 6
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 7
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 8
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 9
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 10
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 11
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 12
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 13
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 14
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 15
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 16
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 17
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 18
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 19
.byt $40, $40, $40, $40, $40, $40, $40, $40
res_end
.)



#include "..\scripts\londoncell.s"



