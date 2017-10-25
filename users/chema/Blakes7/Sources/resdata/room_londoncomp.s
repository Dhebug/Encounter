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

*=$500

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Room: London-comp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.(
	.byt RESOURCE_ROOM
	.word (res_end - res_start + 4)
	.byt 17
res_start
; No. columns, offset to tile map, offset to tiles
	.byt 38, <(column_data-res_start), >(column_data-res_start), <(tiles_start-res_start), >(tiles_start-res_start)
; No. zplanes and offsets to zplanes
	.byt 0
; No. Walkboxes and offsets to wb data and matrix
	.byt 6, <(wb_data-res_start), >(wb_data-res_start), <(wb_matrix-res_start), >(wb_matrix-res_start)
; Offset to palette
	.byt 0,0
	;.byt <(palette-res_start), >(palette-res_start)
; Entry and exit scripts
	.byt 200, 255
; Number of objects in the room and list of ids
	.byt 0
; Room name (null terminated)
	.asc "London-comp", 0
; Room tile map
column_data
	.byt 001, 001, 016, 025, 025, 025, 025, 059, 001, 001, 001, 120, 138, 155, 169, 180, 192
	.byt 001, 001, 017, 025, 025, 025, 046, 060, 074, 086, 099, 000, 000, 156, 001, 181, 001
	.byt 002, 001, 018, 026, 025, 025, 047, 000, 000, 000, 000, 000, 000, 156, 001, 001, 001
	.byt 003, 001, 001, 027, 025, 025, 048, 000, 000, 000, 000, 121, 139, 156, 001, 001, 001
	.byt 004, 010, 001, 028, 025, 025, 049, 061, 075, 087, 100, 122, 140, 157, 001, 001, 001
	.byt 005, 011, 001, 029, 026, 025, 050, 001, 076, 088, 101, 025, 141, 158, 001, 001, 001
	.byt 005, 012, 019, 030, 036, 040, 051, 062, 025, 025, 025, 025, 141, 158, 001, 001, 001
	.byt 005, 005, 020, 025, 025, 025, 025, 025, 025, 025, 025, 025, 141, 158, 001, 001, 001
	.byt 005, 005, 020, 025, 025, 025, 025, 025, 025, 025, 025, 025, 141, 158, 001, 001, 001
	.byt 005, 005, 020, 025, 025, 025, 025, 025, 025, 025, 025, 025, 141, 158, 001, 001, 001
	.byt 005, 005, 020, 025, 025, 025, 025, 025, 025, 025, 025, 025, 141, 158, 001, 001, 001
	.byt 005, 005, 020, 025, 037, 041, 041, 063, 041, 041, 102, 123, 142, 159, 001, 001, 001
	.byt 005, 005, 020, 025, 038, 042, 052, 064, 077, 077, 103, 124, 143, 160, 158, 001, 001
	.byt 005, 005, 020, 025, 038, 042, 042, 064, 078, 089, 104, 125, 143, 160, 158, 001, 001
	.byt 005, 005, 020, 025, 038, 042, 042, 064, 078, 089, 105, 124, 143, 160, 158, 001, 001
	.byt 005, 005, 020, 025, 038, 042, 042, 064, 078, 089, 106, 125, 143, 160, 158, 001, 001
	.byt 005, 005, 020, 025, 038, 043, 042, 064, 078, 089, 107, 124, 143, 160, 158, 001, 001
	.byt 005, 005, 020, 025, 025, 044, 044, 065, 078, 089, 108, 125, 143, 160, 158, 001, 001
	.byt 005, 005, 020, 025, 037, 041, 041, 066, 078, 089, 107, 124, 143, 160, 158, 001, 001
	.byt 005, 005, 020, 025, 038, 042, 052, 064, 077, 077, 108, 125, 143, 160, 158, 001, 001
	.byt 005, 005, 020, 025, 038, 042, 042, 064, 079, 090, 105, 124, 143, 160, 158, 001, 001
	.byt 005, 005, 020, 025, 038, 042, 042, 064, 079, 091, 106, 125, 143, 160, 158, 001, 001
	.byt 005, 005, 020, 025, 038, 042, 042, 064, 079, 092, 107, 124, 143, 160, 158, 001, 001
	.byt 005, 005, 020, 025, 038, 043, 042, 064, 077, 077, 108, 125, 143, 160, 158, 001, 001
	.byt 005, 005, 020, 025, 025, 044, 044, 035, 044, 044, 109, 126, 144, 161, 009, 001, 001
	.byt 005, 005, 020, 025, 025, 025, 025, 025, 025, 025, 025, 025, 141, 158, 001, 001, 001
	.byt 005, 005, 020, 025, 025, 025, 025, 025, 025, 025, 025, 025, 141, 158, 001, 001, 001
	.byt 005, 005, 020, 025, 025, 025, 025, 025, 025, 025, 110, 127, 145, 162, 170, 182, 001
	.byt 005, 005, 020, 025, 025, 025, 025, 025, 025, 025, 111, 128, 146, 163, 171, 183, 193
	.byt 005, 005, 020, 025, 025, 025, 025, 025, 025, 025, 112, 129, 147, 000, 000, 000, 194
	.byt 005, 005, 020, 025, 025, 025, 025, 025, 025, 025, 113, 130, 148, 000, 172, 184, 195
	.byt 005, 013, 021, 031, 039, 045, 053, 067, 025, 025, 114, 131, 149, 000, 173, 185, 196
	.byt 005, 014, 001, 032, 035, 025, 054, 068, 080, 093, 115, 132, 148, 000, 174, 186, 197
	.byt 006, 015, 001, 033, 025, 025, 055, 069, 081, 094, 094, 133, 150, 164, 175, 187, 198
	.byt 007, 001, 001, 034, 025, 025, 056, 070, 082, 095, 116, 134, 151, 165, 176, 188, 199
	.byt 008, 001, 022, 035, 025, 025, 057, 071, 083, 096, 117, 135, 152, 166, 177, 189, 200
	.byt 009, 001, 023, 025, 025, 025, 058, 072, 084, 097, 118, 136, 153, 167, 178, 190, 201
	.byt 001, 001, 024, 025, 025, 025, 025, 073, 085, 098, 119, 137, 154, 168, 179, 191, 202

; Room tile set
tiles_start
	.byt $6A, $55, $6A, $55, $6A, $55, $6A, $55	; tile #1
	.byt $E0, $F8, $69, $54, $6A, $55, $6A, $55	; tile #2
	.byt $C0, $C0, $C0, $E0, $D8, $53, $68, $55	; tile #3
	.byt $C0, $C0, $C0, $C0, $C0, $C0, $C0, $F0	; tile #4
	.byt $C0, $C0, $C0, $C0, $C0, $C0, $C0, $C0	; tile #5
	.byt $C0, $C0, $C0, $C0, $C0, $C0, $C0, $C3	; tile #6
	.byt $C0, $C0, $C0, $C1, $C7, $75, $4A, $55	; tile #7
	.byt $C1, $C6, $62, $55, $6A, $55, $6A, $55	; tile #8
	.byt $4A, $55, $6A, $55, $6A, $55, $6A, $55	; tile #9
	.byt $DC, $54, $6A, $55, $6A, $55, $6A, $55	; tile #10
	.byt $C0, $C0, $E0, $47, $69, $54, $6A, $55	; tile #11
	.byt $C0, $C0, $C0, $C0, $C0, $E0, $D0, $EC	; tile #12
	.byt $C0, $C0, $C0, $C0, $C0, $C1, $C3, $CE	; tile #13
	.byt $C0, $C0, $C1, $C6, $62, $55, $6A, $55	; tile #14
	.byt $CD, $45, $6A, $55, $6A, $55, $6A, $55	; tile #15
	.byt $4A, $51, $7C, $55, $7F, $55, $7F, $55	; tile #16
	.byt $6A, $55, $6A, $45, $78, $54, $7F, $55	; tile #17
	.byt $6A, $55, $6A, $55, $6A, $55, $62, $51	; tile #18
	.byt $68, $54, $69, $55, $69, $51, $6B, $55	; tile #19
	.byt $40, $55, $7F, $55, $7F, $55, $7F, $55	; tile #20
	.byt $4A, $55, $6A, $45, $6A, $55, $72, $51	; tile #21
	.byt $6A, $55, $6A, $55, $6A, $54, $69, $45	; tile #22
	.byt $6A, $55, $6A, $50, $67, $55, $7F, $55	; tile #23
	.byt $68, $51, $4F, $55, $7F, $55, $7F, $55	; tile #24
	.byt $7F, $55, $7F, $55, $7F, $55, $7F, $55	; tile #25
	.byt $7E, $55, $7F, $55, $7F, $55, $7F, $55	; tile #26
	.byt $4A, $41, $7C, $55, $7F, $55, $7F, $55	; tile #27
	.byt $6A, $55, $6A, $45, $72, $54, $7F, $55	; tile #28
	.byt $6A, $55, $6A, $55, $6A, $55, $4A, $50	; tile #29
	.byt $67, $55, $6F, $45, $5F, $55, $5F, $55	; tile #30
	.byt $7A, $51, $7C, $55, $7E, $54, $7E, $55	; tile #31
	.byt $6A, $55, $6A, $55, $6A, $55, $68, $41	; tile #32
	.byt $6A, $55, $6A, $54, $63, $45, $7F, $55	; tile #33
	.byt $6A, $51, $4F, $55, $7F, $55, $7F, $55	; tile #34
	.byt $5F, $55, $7F, $55, $7F, $55, $7F, $55	; tile #35
	.byt $5F, $55, $6F, $45, $6F, $55, $77, $55	; tile #36
	.byt $7F, $55, $7F, $55, $7F, $55, $7F, $54	; tile #37
	.byt $7F, $55, $7F, $55, $7F, $55, $7F, $40	; tile #38
	.byt $7E, $54, $7D, $55, $7D, $51, $7B, $51	; tile #39
	.byt $7B, $51, $7D, $55, $7D, $54, $7E, $54	; tile #40
	.byt $7E, $54, $7E, $54, $7E, $54, $7E, $54	; tile #41
	.byt $FF, $40, $FF, $40, $FF, $40, $FF, $40	; tile #42
	.byt $D3, $40, $FD, $40, $FD, $40, $FD, $40	; tile #43
	.byt $5F, $55, $5F, $55, $5F, $55, $5F, $55	; tile #44
	.byt $77, $55, $6F, $45, $6F, $55, $5F, $55	; tile #45
	.byt $7F, $55, $7F, $54, $78, $54, $7E, $50	; tile #46
	.byt $7F, $55, $70, $40, $40, $40, $40, $40	; tile #47
	.byt $7E, $40, $40, $40, $40, $40, $40, $40	; tile #48
	.byt $47, $41, $40, $40, $40, $40, $40, $41	; tile #49
	.byt $7F, $54, $42, $55, $6A, $55, $6A, $55	; tile #50
	.byt $70, $45, $69, $55, $6B, $51, $6B, $55	; tile #51
	.byt $FF, $40, $EF, $40, $EF, $40, $F0, $40	; tile #52
	.byt $43, $44, $6A, $45, $72, $55, $72, $51	; tile #53
	.byt $7F, $45, $60, $55, $6A, $55, $6A, $51	; tile #54
	.byt $7F, $55, $5F, $41, $6A, $55, $6A, $55	; tile #55
	.byt $7F, $55, $7F, $55, $47, $50, $6A, $55	; tile #56
	.byt $7F, $55, $7F, $55, $7F, $55, $61, $54	; tile #57
	.byt $7F, $55, $7F, $55, $7F, $55, $7F, $45	; tile #58
	.byt $7E, $41, $4A, $55, $6A, $55, $6A, $55	; tile #59
	.byt $42, $55, $6A, $54, $6A, $54, $6A, $54	; tile #60
	.byt $40, $41, $40, $41, $40, $41, $42, $41	; tile #61
	.byt $67, $55, $6F, $45, $6F, $55, $5F, $55	; tile #62
	.byt $7E, $55, $7F, $55, $7F, $55, $7F, $54	; tile #63
	.byt $40, $55, $7F, $55, $7F, $55, $7F, $40	; tile #64
	.byt $5F, $55, $7F, $55, $7F, $55, $7F, $40	; tile #65
	.byt $7E, $55, $7F, $55, $7F, $55, $7F, $40	; tile #66
	.byt $7A, $51, $7C, $55, $7C, $54, $7E, $54	; tile #67
	.byt $60, $50, $68, $54, $68, $54, $6A, $55	; tile #68
	.byt $4A, $41, $5C, $5F, $4F, $4E, $45, $47	; tile #69
	.byt $6A, $55, $4A, $60, $7C, $5F, $6F, $72	; tile #70
	.byt $6A, $55, $6A, $55, $42, $60, $7E, $4F	; tile #71
	.byt $68, $55, $6A, $55, $6A, $55, $42, $70	; tile #72
	.byt $5F, $41, $6A, $55, $6A, $55, $6A, $55	; tile #73
	.byt $6A, $54, $68, $54, $68, $54, $68, $50	; tile #74
	.byt $42, $41, $42, $41, $42, $45, $42, $45	; tile #75
	.byt $6A, $54, $6A, $54, $69, $55, $69, $51	; tile #76
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F	; tile #77
	.byt $7F, $7F, $7B, $75, $7B, $7F, $DC, $DC	; tile #78
	.byt $7F, $7F, $CC, $D2, $ED, $E1, $FF, $7F	; tile #79
	.byt $4A, $55, $62, $51, $78, $53, $7A, $52	; tile #80
	.byt $41, $50, $6A, $55, $4A, $45, $70, $4D	; tile #81
	.byt $7F, $7B, $4F, $51, $6A, $55, $6A, $55	; tile #82
	.byt $7B, $4F, $76, $7F, $4F, $51, $6A, $55	; tile #83
	.byt $7E, $5F, $7F, $43, $7D, $7E, $5F, $47	; tile #84
	.byt $40, $78, $5F, $67, $5D, $77, $7F, $73	; tile #85
	.byt $68, $50, $68, $50, $60, $50, $60, $50	; tile #86
	.byt $42, $45, $4A, $45, $4A, $45, $4A, $45	; tile #87
	.byt $6B, $51, $67, $55, $67, $45, $6F, $45	; tile #88
	.byt $7F, $73, $6D, $6D, $73, $7F, $7F, $E7	; tile #89
	.byt $7F, $CC, $DE, $CC, $DE, $CC, $DE, $CC	; tile #90
	.byt $7F, $C0, $DE, $C0, $DE, $73, $DE, $73	; tile #91
	.byt $7F, $C0, $DE, $CC, $DE, $CC, $DE, $CC	; tile #92
	.byt $7A, $53, $7A, $52, $7B, $52, $7A, $53	; tile #93
	.byt $45, $55, $45, $75, $45, $65, $55, $4D	; tile #94
	.byt $62, $59, $46, $41, $40, $58, $46, $40	; tile #95
	.byt $6A, $55, $4A, $45, $70, $4C, $43, $41	; tile #96
	.byt $68, $55, $6A, $55, $6A, $55, $42, $41	; tile #97
	.byt $7D, $47, $68, $55, $6A, $55, $6A, $55	; tile #98
	.byt $60, $50, $60, $40, $60, $40, $60, $40	; tile #99
	.byt $4A, $55, $4A, $54, $4A, $54, $69, $55	; tile #100
	.byt $5F, $55, $5F, $55, $7F, $55, $7F, $55	; tile #101
	.byt $7E, $54, $7E, $54, $7D, $53, $77, $4F	; tile #102
	.byt $7F, $7F, $7F, $40, $CC, $7F, $E6, $7F	; tile #103
	.byt $7F, $7F, $7F, $40, $D2, $7F, $E5, $7F	; tile #104
	.byt $7F, $7F, $7F, $40, $C6, $7F, $C0, $7F	; tile #105
	.byt $7F, $7F, $7F, $40, $C0, $7F, $CD, $7F	; tile #106
	.byt $7F, $7F, $7F, $40, $C0, $D6, $C0, $7F	; tile #107
	.byt $7F, $7F, $7F, $40, $C4, $7F, $D6, $7F	; tile #108
	.byt $5F, $55, $5F, $55, $6F, $75, $E4, $7D	; tile #109
	.byt $7F, $55, $7F, $55, $7C, $53, $77, $4F	; tile #110
	.byt $7F, $55, $7F, $55, $40, $57, $6F, $6D	; tile #111
	.byt $7F, $55, $7F, $55, $40, $5D, $7F, $60	; tile #112
	.byt $7F, $55, $7F, $55, $40, $77, $7F, $40	; tile #113
	.byt $7F, $55, $7F, $55, $40, $5D, $7F, $40	; tile #114
	.byt $7A, $53, $7A, $52, $43, $50, $7C, $5D	; tile #115
	.byt $40, $45, $62, $58, $64, $52, $45, $54	; tile #116
	.byt $41, $59, $41, $51, $4D, $45, $61, $51	; tile #117
	.byt $5C, $53, $50, $50, $50, $50, $52, $51	; tile #118
	.byt $4A, $45, $70, $4C, $43, $40, $40, $40	; tile #119
	.byt $6A, $55, $6A, $55, $6A, $55, $6A, $54	; tile #120
	.byt $40, $40, $40, $40, $40, $41, $40, $41	; tile #121
	.byt $69, $55, $6B, $51, $6B, $55, $67, $55	; tile #122
	.byt $40, $5D, $E0, $57, $E0, $5D, $E0, $40	; tile #123
	.byt $40, $77, $C0, $5D, $C0, $77, $C0, $40	; tile #124
	.byt $40, $5D, $C0, $77, $C0, $5D, $C0, $40	; tile #125
	.byt $40, $76, $C1, $5C, $C1, $76, $C1, $40	; tile #126
	.byt $5F, $5F, $4F, $57, $56, $59, $5D, $55	; tile #127
	.byt $77, $73, $6D, $5E, $7E, $7F, $7F, $7F	; tile #128
	.byt $60, $50, $78, $74, $7E, $5D, $6F, $77	; tile #129
	.byt $E3, $40, $40, $E5, $40, $42, $60, $50	; tile #130
	.byt $54, $42, $C7, $41, $4A, $40, $70, $40	; tile #131
	.byt $4F, $47, $53, $41, $48, $60, $CB, $40	; tile #132
	.byt $73, $5D, $7E, $77, $7F, $5D, $6F, $47	; tile #133
	.byt $40, $45, $62, $58, $64, $72, $7D, $5E	; tile #134
	.byt $41, $59, $41, $51, $4D, $45, $61, $55	; tile #135
	.byt $52, $52, $50, $50, $54, $52, $51, $54	; tile #136
	.byt $40, $5A, $52, $44, $42, $40, $60, $50	; tile #137
	.byt $6A, $54, $6A, $54, $68, $54, $68, $54	; tile #138
	.byt $40, $41, $42, $41, $42, $41, $42, $40	; tile #139
	.byt $6F, $45, $6F, $55, $40, $40, $40, $40	; tile #140
	.byt $7F, $55, $7F, $55, $40, $40, $40, $40	; tile #141
	.byt $60, $50, $7E, $54, $40, $40, $40, $40	; tile #142
	.byt $40, $40, $40, $55, $40, $55, $40, $55	; tile #143
	.byt $41, $45, $4F, $45, $40, $40, $40, $40	; tile #144
	.byt $5E, $5C, $5F, $57, $5F, $5D, $5F, $57	; tile #145
	.byt $7F, $7F, $5E, $4D, $6B, $77, $7B, $5B	; tile #146
	.byt $67, $59, $7D, $7C, $78, $70, $60, $40	; tile #147
	.byt $7F, $77, $7F, $40, $40, $40, $40, $40	; tile #148
	.byt $7F, $5D, $7F, $40, $40, $40, $40, $40	; tile #149
	.byt $7F, $5D, $7F, $77, $5F, $4D, $67, $53	; tile #150
	.byt $7F, $77, $7F, $5D, $7F, $77, $7F, $5D	; tile #151
	.byt $61, $51, $79, $75, $7E, $5D, $7F, $77	; tile #152
	.byt $52, $52, $50, $54, $51, $48, $64, $53	; tile #153
	.byt $40, $5A, $52, $44, $42, $70, $68, $4A	; tile #154
	.byt $68, $50, $68, $50, $6A, $51, $6A, $55	; tile #155
	.byt $40, $40, $40, $40, $6A, $55, $6A, $55	; tile #156
	.byt $40, $45, $4A, $55, $6A, $55, $6A, $55	; tile #157
	.byt $40, $55, $6A, $55, $6A, $55, $6A, $55	; tile #158
	.byt $40, $54, $6A, $54, $6A, $54, $6A, $54	; tile #159
	.byt $40, $55, $40, $55, $40, $55, $40, $55	; tile #160
	.byt $40, $45, $4A, $45, $4A, $45, $4A, $45	; tile #161
	.byt $5F, $5D, $5F, $57, $5F, $5D, $5F, $57	; tile #162
	.byt $7C, $76, $7E, $5C, $7E, $76, $7E, $5C	; tile #163
	.byt $69, $54, $6A, $55, $6A, $55, $6A, $55	; tile #164
	.byt $7F, $77, $5F, $4D, $67, $53, $69, $54	; tile #165
	.byt $7F, $5D, $7F, $77, $7F, $5D, $7F, $77	; tile #166
	.byt $78, $76, $7F, $5D, $7F, $77, $7F, $5D	; tile #167
	.byt $62, $58, $44, $72, $79, $5E, $7F, $77	; tile #168
	.byt $62, $55, $62, $55, $62, $45, $6A, $45	; tile #169
	.byt $6F, $4D, $67, $57, $6B, $51, $69, $55	; tile #170
	.byt $7E, $76, $7E, $5C, $7E, $76, $7E, $5C	; tile #171
	.byt $40, $40, $40, $40, $40, $40, $41, $43	; tile #172
	.byt $40, $41, $46, $4F, $5F, $7F, $7F, $7F	; tile #173
	.byt $40, $77, $7F, $5D, $5F, $67, $77, $79	; tile #174
	.byt $40, $5D, $7F, $77, $7F, $40, $61, $72	; tile #175
	.byt $40, $77, $7F, $5D, $7F, $40, $40, $48	; tile #176
	.byt $7F, $5D, $7F, $77, $7F, $40, $40, $C7	; tile #177
	.byt $7F, $77, $7F, $5D, $7F, $40, $53, $40	; tile #178
	.byt $7F, $5D, $7F, $77, $7F, $5D, $4F, $67	; tile #179
	.byt $60, $40, $60, $40, $40, $40, $40, $41	; tile #180
	.byt $40, $41, $42, $45, $4A, $55, $6A, $55	; tile #181
	.byt $6A, $54, $6A, $55, $6A, $55, $6A, $55	; tile #182
	.byt $7E, $76, $7E, $5C, $5E, $46, $6E, $54	; tile #183
	.byt $43, $41, $45, $46, $47, $47, $47, $45	; tile #184
	.byt $7F, $7F, $7F, $7F, $5F, $6F, $6F, $77	; tile #185
	.byt $7B, $7D, $7E, $7F, $7F, $7F, $7F, $7F	; tile #186
	.byt $78, $5C, $7E, $57, $6F, $6D, $77, $7B	; tile #187
	.byt $58, $61, $40, $46, $60, $70, $78, $5C	; tile #188
	.byt $41, $40, $D4, $40, $49, $40, $E3, $40	; tile #189
	.byt $44, $42, $40, $F2, $40, $40, $FD, $40	; tile #190
	.byt $43, $41, $44, $42, $40, $40, $E3, $40	; tile #191
	.byt $42, $45, $4A, $55, $6A, $55, $6A, $55	; tile #192
	.byt $66, $52, $6A, $54, $6A, $55, $6A, $55	; tile #193
	.byt $40, $40, $40, $40, $40, $55, $6A, $55	; tile #194
	.byt $47, $47, $47, $45, $47, $57, $67, $55	; tile #195
	.byt $7B, $5B, $7D, $76, $7F, $5D, $7F, $77	; tile #196
	.byt $7F, $7F, $7F, $7F, $5F, $5F, $6F, $57	; tile #197
	.byt $7D, $7E, $7E, $7F, $7E, $7D, $7B, $77	; tile #198
	.byt $7E, $77, $7F, $5D, $6F, $77, $7B, $79	; tile #199
	.byt $F9, $41, $60, $70, $78, $58, $7C, $76	; tile #200
	.byt $FB, $41, $60, $40, $66, $50, $60, $40	; tile #201
	.byt $F9, $40, $59, $40, $F3, $40, $70, $FB	; tile #202
; Walkbox Data
wb_data
	.byt 001, 003, 013, 014, $01
	.byt 004, 007, 013, 016, $01
	.byt 008, 021, 014, 016, $01
	.byt 022, 025, 015, 016, $01
	.byt 002, 003, 015, 016, $01
	.byt 001, 001, 016, 016, $01
; Walk matrix
wb_matrix
	.byt 0, 1, 1, 1, 4, 4
	.byt 0, 1, 2, 2, 4, 4
	.byt 1, 1, 2, 3, 1, 1
	.byt 2, 2, 2, 3, 2, 2
	.byt 0, 1, 1, 1, 4, 5
	.byt 4, 4, 4, 4, 4, 5
; Palette Information is stored as one column only for now...
; Palette
/*
palette
.byt 3, 6, 3, 6, 3, 6, 3, 6, 3, 6, 3, 6, 3, 6, 3, 6
.byt 3, 6, 3, 6, 3, 6, 3, 6, 3, 6, 3, 6, 3, 6, 3, 6
.byt 3, 6, 3, 6, 3, 6, 3, 6, 3, 6, 3, 6, 3, 6, 3, 6
.byt 3, 6, 3, 6, 3, 6, 3, 6, 3, 6, 3, 6, 3, 6, 3, 6
.byt 3, 6, 3, 6, 3, 6, 3, 6, 3, 6, 3, 6, 3, 6, 3, 6
.byt 3, 6, 3, 6, 3, 6, 3, 6, 3, 6, 3, 6, 3, 6, 3, 6
.byt 3, 6, 3, 6, 3, 6, 3, 6, 3, 6, 3, 6, 3, 6, 3, 6
.byt 3, 6, 3, 6, 3, 6, 3, 6, 3, 6, 3, 6, 3, 6, 3, 6
.byt 3, 6, 3, 6, 3, 6, 3, 6
*/

res_end
.)


; Object resource 200: TV
.(
	.byt RESOURCE_OBJECT|$80
	.word (res_end-res_start+4)
	.byt 200
res_start
	.byt 0
	.byt 3,2	;Size (cols, rows)
	.byt 255	;Initial room
	.byt 13,6	;Location (col, row)
	.byt ZPLANE_0	;Zplane
	.byt 13,14	;Walk position (col, row)
	.byt FACING_UP
	.byt 0	; Color of text
	; tiles and pointers to animatory states are setup in the costume
	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt 200		; costume ($ff for none) and skip the rest
	.byt 0			; entry in costume resource		
	.byt 0			; direction (0 or LOOK_RIGHT for animstate 0)
	.byt 0			; animation speed		
	.asc "Screen",0	;Object's name
res_end
.)


; Costume for TV object
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
; Animatory state 0 (1-faceA.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 0, 0
.byt 4, 5, 6, 0, 0
; Animatory state 1 (2-faceB.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 0, 0
.byt 7, 8, 9, 0, 0
; Animatory state 2 (3-faceB.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 0, 0
.byt 7, 10, 9, 0, 0
costume_tiles
; Tile graphic 1
.byt $3, $4, $b, $b, $a, $b, $13, $17
; Tile graphic 2
.byt $3f, $f, $30, $3f, $c, $1e, $3f, $2d
; Tile graphic 3
.byt $30, $38, $c, $34, $14, $34, $32, $3a
; Tile graphic 4
.byt $17, $b, $5, $5, $2, $1, $f, $1f
; Tile graphic 5
.byt $33, $3f, $21, $3f, $33, $1e, $21, $3f
; Tile graphic 6
.byt $3a, $34, $28, $28, $10, $20, $3c, $3e
; Tile graphic 7
.byt $17, $b, $5, $5, $2, $0, $f, $1f
; Tile graphic 8
.byt $33, $3f, $21, $21, $3f, $33, $1e, $21
; Tile graphic 9
.byt $3a, $34, $28, $28, $10, $0, $3c, $3e
; Tile graphic 10
.byt $33, $3f, $33, $33, $3f, $33, $1e, $21
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
res_end
.)


; Object resource 201: Door
.(
	.byt RESOURCE_OBJECT|$80
	.word (res_end-res_start+4)
	.byt 201
res_start
	.byt 0
	.byt 2,7	;Size (cols, rows)
	.byt 255	;Initial room
	.byt 0,14	;Location (col, row)
	.byt ZPLANE_0	;Zplane
	.byt 3,14	;Walk position (col, row)
	.byt FACING_LEFT
	.byt 0	; Color of text
	; tiles and pointers to animatory states are setup in the costume
	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt 201		; costume ($ff for none) and skip the rest
	.byt 0			; entry in costume resource		
	.byt 0			; direction (0 or LOOK_RIGHT for animstate 0)
	.byt 0			; animation speed		
	.asc "Door",0	;Object's name
res_end
.)


; Costume for Door Closing
.(
.byt RESOURCE_COSTUME|$80
.word (res_end - res_start + 4)
.byt 201
res_start
	; Pointers to tiles
	.byt <(costume_tiles-res_start-8), >(costume_tiles-res_start-8)
	.byt <(costume_masks-res_start-8), >(costume_masks-res_start-8)
	; Number of costumes included
	.byt 1
	;Offsets to animatory states for each costume
	.byt <(anim_states - res_start), >(anim_states - res_start)
anim_states
; Animatory state 0 (0-closing.png)
.byt 1, 2, 0, 0, 0
.byt 1, 3, 0, 0, 0
.byt 1, 4, 0, 0, 0
.byt 5, 6, 0, 0, 0
.byt 7, 6, 0, 0, 0
.byt 8, 9, 0, 0, 0
.byt 10, 11, 0, 0, 0
; Animatory state 1 (1-closed.png)
.byt 1, 12, 0, 0, 0
.byt 1, 13, 0, 0, 0
.byt 1, 14, 0, 0, 0
.byt 15, 16, 0, 0, 0
.byt 17, 18, 0, 0, 0
.byt 19, 20, 0, 0, 0
.byt 21, 22, 0, 0, 0
costume_tiles
; Tile graphic 1
.byt $2a, $15, $2a, $15, $2a, $15, $2a, $15
; Tile graphic 2
.byt $2a, $14, $28, $14, $28, $14, $28, $10
; Tile graphic 3
.byt $28, $10, $28, $10, $20, $10, $20, $10
; Tile graphic 4
.byt $20, $10, $20, $20, $20, $20, $20, $20
; Tile graphic 5
.byt $2a, $14, $2a, $15, $2b, $16, $28, $14
; Tile graphic 6
.byt $20, $20, $20, $20, $20, $20, $20, $20
; Tile graphic 7
.byt $29, $17, $2a, $14, $2a, $16, $2e, $16
; Tile graphic 8
.byt $2e, $1e, $2e, $1e, $2e, $1e, $2e, $1e
; Tile graphic 9
.byt $20, $20, $20, $20, $2a, $35, $2a, $35
; Tile graphic 10
.byt $2e, $1e, $3e, $1f, $2e, $1d, $2a, $d
; Tile graphic 11
.byt $2a, $35, $2a, $15, $2a, $15, $2a, $15
; Tile graphic 12
.byt $29, $17, $2d, $15, $2d, $15, $2d, $1d
; Tile graphic 13
.byt $2d, $1d, $2d, $1d, $3d, $1d, $3d, $1d
; Tile graphic 14
.byt $3d, $1d, $3d, $3d, $3d, $3d, $3b, $37
; Tile graphic 15
.byt $2b, $15, $2b, $15, $2b, $15, $2b, $17
; Tile graphic 16
.byt $2d, $29, $29, $2b, $2f, $2d, $29, $25
; Tile graphic 17
.byt $2b, $17, $2b, $17, $2f, $17, $2f, $17
; Tile graphic 18
.byt $3d, $3d, $3d, $3d, $3d, $3d, $3d, $3d
; Tile graphic 19
.byt $2f, $1f, $2f, $1f, $2f, $1f, $2f, $1f
; Tile graphic 20
.byt $3d, $3d, $3d, $3d, $3d, $3d, $3e, $3d
; Tile graphic 21
.byt $2f, $1f, $3f, $1f, $2e, $1d, $2a, $d
; Tile graphic 22
.byt $3a, $35, $2a, $15, $2a, $15, $2a, $15
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
; Tile mask 20
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 21
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 22
.byt $40, $40, $40, $40, $40, $40, $40, $40
res_end
.)






#include "..\scripts\londoncomp.s"


