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
; Room: Blake's room
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.(
	.byt RESOURCE_ROOM
	.word (res_end - res_start + 4)
	.byt ROOM_BROOM
res_start
; No. columns, offset to tile map, offset to tiles
	.byt 38, <(column_data-res_start), >(column_data-res_start), <(tiles_start-res_start), >(tiles_start-res_start)
; No. zplanes and offsets to zplanes
	.byt 0
; No. Walkboxes and offsets to wb data and matrix
	.byt 4, <(wb_data-res_start), >(wb_data-res_start), <(wb_matrix-res_start), >(wb_matrix-res_start)
; Offset to palette
	.byt 0, 0	; No palette information
; Entry and exit scripts
	.byt 201, 255
; Number of objects in the room and list of ids
	.byt 8, 200, 201,202,203,204,205,206,207
; Room name (null terminated)
	.asc "Blake's room", 0
; Room tile map
column_data
	.byt 001, 013, 013, 013, 013, 013, 013, 013, 013, 013, 013, 131, 071, 071, 071, 071, 213
	.byt 002, 014, 014, 014, 014, 014, 014, 014, 014, 014, 014, 132, 071, 071, 071, 193, 214
	.byt 003, 013, 013, 013, 013, 013, 013, 013, 013, 013, 013, 133, 071, 071, 174, 194, 215
	.byt 004, 014, 014, 014, 014, 014, 014, 014, 014, 094, 104, 134, 071, 158, 175, 195, 216
	.byt 005, 015, 013, 013, 013, 013, 013, 013, 013, 095, 105, 135, 146, 159, 176, 160, 217
	.byt 006, 016, 014, 036, 040, 040, 040, 040, 084, 096, 106, 136, 147, 160, 160, 160, 218
	.byt 006, 017, 013, 037, 041, 057, 057, 057, 085, 013, 013, 056, 148, 161, 160, 160, 219
	.byt 006, 018, 014, 038, 042, 000, 000, 000, 086, 014, 014, 137, 149, 162, 177, 196, 140
	.byt 006, 019, 013, 013, 043, 000, 000, 077, 087, 013, 013, 138, 150, 150, 140, 140, 140
	.byt 006, 020, 014, 014, 044, 000, 000, 078, 088, 014, 107, 139, 140, 140, 140, 140, 140
	.byt 006, 021, 013, 013, 045, 058, 058, 079, 089, 013, 108, 140, 140, 140, 140, 140, 140
	.byt 006, 022, 033, 039, 039, 039, 039, 039, 039, 039, 109, 140, 140, 140, 140, 140, 140
	.byt 006, 006, 034, 013, 013, 013, 013, 013, 013, 013, 110, 140, 140, 140, 140, 140, 140
	.byt 006, 023, 035, 014, 014, 014, 014, 014, 014, 014, 111, 140, 140, 140, 140, 140, 140
	.byt 006, 024, 013, 013, 046, 059, 072, 072, 072, 072, 112, 140, 140, 140, 140, 140, 140
	.byt 006, 025, 014, 014, 047, 060, 073, 080, 090, 074, 113, 140, 140, 140, 140, 140, 140
	.byt 006, 026, 013, 013, 048, 061, 074, 081, 091, 097, 114, 140, 140, 140, 140, 140, 140
	.byt 006, 027, 014, 014, 049, 062, 075, 082, 092, 098, 115, 140, 140, 140, 140, 140, 140
	.byt 006, 028, 013, 013, 049, 062, 073, 083, 093, 099, 116, 140, 140, 140, 140, 140, 140
	.byt 006, 029, 014, 014, 050, 063, 076, 076, 076, 076, 117, 140, 140, 140, 140, 140, 140
	.byt 006, 030, 013, 013, 013, 013, 013, 013, 013, 013, 037, 140, 140, 140, 140, 140, 140
	.byt 006, 031, 014, 014, 014, 014, 014, 014, 014, 014, 038, 141, 140, 163, 178, 140, 140
	.byt 007, 032, 013, 013, 013, 064, 071, 071, 071, 071, 071, 071, 151, 164, 179, 197, 140
	.byt 008, 014, 014, 014, 014, 065, 071, 071, 071, 071, 071, 071, 071, 165, 180, 198, 140
	.byt 009, 013, 013, 013, 013, 066, 071, 071, 071, 071, 071, 071, 071, 166, 181, 199, 140
	.byt 010, 014, 014, 014, 014, 067, 071, 071, 071, 071, 118, 071, 152, 167, 182, 200, 220
	.byt 011, 013, 013, 013, 013, 068, 071, 071, 071, 071, 119, 071, 153, 006, 183, 201, 221
	.byt 012, 014, 014, 014, 014, 069, 071, 071, 071, 071, 120, 071, 154, 006, 184, 202, 222
	.byt 013, 013, 013, 013, 013, 070, 071, 071, 071, 071, 121, 071, 153, 006, 185, 203, 223
	.byt 014, 014, 014, 014, 036, 071, 071, 071, 071, 071, 122, 071, 155, 006, 186, 204, 224
	.byt 013, 013, 013, 013, 051, 071, 071, 071, 071, 071, 123, 071, 071, 168, 006, 205, 200
	.byt 014, 014, 014, 014, 052, 071, 071, 071, 071, 071, 124, 071, 071, 169, 187, 206, 225
	.byt 013, 013, 013, 013, 053, 071, 071, 071, 071, 071, 125, 071, 071, 170, 000, 207, 226
	.byt 014, 014, 014, 014, 054, 071, 071, 071, 071, 100, 126, 142, 071, 171, 188, 208, 227
	.byt 013, 013, 013, 013, 055, 071, 071, 071, 071, 101, 127, 143, 071, 172, 189, 209, 228
	.byt 014, 014, 014, 014, 056, 071, 071, 071, 071, 102, 128, 144, 071, 173, 190, 210, 229
	.byt 013, 013, 013, 013, 056, 071, 071, 071, 071, 103, 129, 145, 156, 173, 191, 211, 230
	.byt 014, 014, 014, 014, 056, 071, 071, 071, 071, 071, 130, 073, 157, 071, 192, 212, 231

; Room tile set
tiles_start
	.byt $C0, $41, $7E, $5D, $7F, $77, $7F, $5D	; tile #1
	.byt $C0, $C0, $40, $77, $7F, $5D, $7F, $77	; tile #2
	.byt $C0, $C0, $C0, $F8, $78, $77, $7F, $5D	; tile #3
	.byt $C0, $C0, $C0, $C0, $E0, $43, $7C, $77	; tile #4
	.byt $C0, $C0, $C0, $C0, $C0, $C0, $E0, $41	; tile #5
	.byt $C0, $C0, $C0, $C0, $C0, $C0, $C0, $C0	; tile #6
	.byt $C0, $C0, $C0, $C0, $C0, $C0, $C0, $C1	; tile #7
	.byt $C0, $C0, $C0, $C0, $C0, $C0, $CF, $47	; tile #8
	.byt $C0, $C0, $C0, $C0, $C7, $47, $7F, $5D	; tile #9
	.byt $C0, $C0, $C0, $60, $5F, $5D, $7F, $77	; tile #10
	.byt $C0, $C3, $43, $5D, $7F, $77, $7F, $5D	; tile #11
	.byt $40, $5D, $7F, $77, $7F, $5D, $7F, $77	; tile #12
	.byt $7F, $77, $7F, $5D, $7F, $77, $7F, $5D	; tile #13
	.byt $7F, $5D, $7F, $77, $7F, $5D, $7F, $77	; tile #14
	.byt $7E, $77, $7F, $5D, $7F, $77, $7F, $5D	; tile #15
	.byt $F0, $50, $7F, $77, $7F, $5D, $7F, $77	; tile #16
	.byt $C0, $C0, $43, $5C, $7F, $77, $7F, $5D	; tile #17
	.byt $C0, $C0, $C0, $E0, $40, $5C, $7F, $77	; tile #18
	.byt $C0, $C0, $C0, $C0, $C0, $43, $7C, $5D	; tile #19
	.byt $C0, $C0, $C0, $C0, $C0, $C0, $40, $77	; tile #20
	.byt $C0, $C0, $C0, $C0, $C0, $C0, $C0, $40	; tile #21
	.byt $C0, $C0, $C0, $C0, $C0, $C0, $C0, $4F	; tile #22
	.byt $C0, $C0, $C0, $C0, $C0, $C0, $C0, $60	; tile #23
	.byt $C0, $C0, $C0, $C0, $C0, $C0, $70, $4D	; tile #24
	.byt $C0, $C0, $C0, $C0, $C0, $C1, $41, $77	; tile #25
	.byt $C0, $C0, $C0, $C0, $C0, $40, $7F, $5D	; tile #26
	.byt $C0, $C0, $C0, $C0, $60, $5D, $7F, $77	; tile #27
	.byt $C0, $C0, $C0, $C7, $47, $77, $7F, $5D	; tile #28
	.byt $C0, $C0, $C1, $41, $7F, $5D, $7F, $77	; tile #29
	.byt $C0, $C0, $40, $5D, $7F, $77, $7F, $5D	; tile #30
	.byt $C0, $60, $5F, $77, $7F, $5D, $7F, $77	; tile #31
	.byt $43, $77, $7F, $5D, $7F, $77, $7F, $5D	; tile #32
	.byt $70, $5D, $7D, $75, $7D, $5D, $7D, $75	; tile #33
	.byt $40, $77, $7F, $5D, $7F, $77, $7F, $5D	; tile #34
	.byt $5F, $5D, $7F, $77, $7F, $5D, $7F, $77	; tile #35
	.byt $7F, $5D, $7F, $77, $7F, $5D, $7F, $76	; tile #36
	.byt $7F, $77, $7F, $5D, $7F, $77, $7F, $40	; tile #37
	.byt $7F, $5D, $7F, $77, $7F, $5D, $7F, $47	; tile #38
	.byt $7D, $5D, $7D, $75, $7D, $5D, $7D, $75	; tile #39
	.byt $7C, $5C, $7C, $74, $7C, $5C, $7C, $74	; tile #40
	.byt $40, $7F, $60, $60, $60, $60, $60, $60	; tile #41
	.byt $40, $7C, $43, $40, $40, $40, $40, $40	; tile #42
	.byt $40, $40, $7F, $40, $40, $40, $40, $40	; tile #43
	.byt $7F, $40, $7F, $40, $40, $40, $40, $40	; tile #44
	.byt $7F, $47, $43, $79, $4B, $4B, $4B, $49	; tile #45
	.byt $7F, $77, $7F, $40, $E0, $5F, $E0, $5F	; tile #46
	.byt $7F, $77, $40, $7E, $C1, $7E, $C1, $7E	; tile #47
	.byt $7F, $76, $41, $C0, $C0, $C0, $C0, $C0	; tile #48
	.byt $7F, $40, $C0, $C0, $C0, $C0, $C0, $C0	; tile #49
	.byt $60, $E1, $C1, $C1, $C1, $C1, $C1, $C1	; tile #50
	.byt $7F, $77, $7F, $5D, $7F, $77, $7C, $41	; tile #51
	.byt $7F, $5D, $7F, $77, $7F, $58, $40, $55	; tile #52
	.byt $7F, $77, $7F, $5C, $60, $55, $40, $55	; tile #53
	.byt $7F, $5D, $78, $45, $40, $55, $40, $55	; tile #54
	.byt $7F, $70, $40, $55, $40, $55, $40, $55	; tile #55
	.byt $7F, $40, $40, $55, $40, $55, $40, $55	; tile #56
	.byt $60, $60, $60, $60, $60, $60, $60, $60	; tile #57
	.byt $4B, $4B, $4B, $49, $4B, $4B, $4B, $49	; tile #58
	.byt $E0, $5F, $E0, $40, $5F, $5F, $5F, $5F	; tile #59
	.byt $C1, $7E, $40, $7F, $7F, $7F, $7F, $7F	; tile #60
	.byt $C0, $C1, $41, $7D, $7F, $7D, $7F, $7D	; tile #61
	.byt $C0, $40, $7F, $7F, $7F, $7F, $7F, $7F	; tile #62
	.byt $60, $5E, $7E, $7E, $7E, $7E, $7E, $7E	; tile #63
	.byt $7F, $77, $7F, $5D, $60, $55, $40, $55	; tile #64
	.byt $7F, $5D, $7F, $70, $40, $55, $40, $55	; tile #65
	.byt $7F, $77, $7F, $40, $40, $55, $40, $55	; tile #66
	.byt $7F, $5D, $40, $55, $40, $55, $40, $55	; tile #67
	.byt $7F, $77, $40, $55, $40, $55, $40, $55	; tile #68
	.byt $7F, $50, $40, $55, $40, $55, $40, $55	; tile #69
	.byt $70, $45, $40, $55, $40, $55, $40, $55	; tile #70
	.byt $40, $55, $40, $55, $40, $55, $40, $55	; tile #71
	.byt $5F, $5F, $5F, $5F, $5F, $5F, $5F, $5F	; tile #72
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F	; tile #73
	.byt $7F, $7D, $7F, $7F, $7F, $7F, $7F, $7F	; tile #74
	.byt $7F, $7F, $7F, $5F, $7F, $77, $7F, $7D	; tile #75
	.byt $7E, $7E, $7E, $7E, $7E, $7E, $7E, $7E	; tile #76
	.byt $40, $40, $40, $40, $40, $40, $40, $41	; tile #77
	.byt $40, $40, $40, $40, $40, $40, $43, $7C	; tile #78
	.byt $4B, $4B, $4B, $49, $4B, $4B, $73, $45	; tile #79
	.byt $7F, $7F, $7F, $7D, $7F, $77, $7F, $76	; tile #80
	.byt $7F, $7D, $7F, $57, $7C, $73, $4F, $7F	; tile #81
	.byt $7F, $55, $7F, $7F, $4F, $73, $7C, $7F	; tile #82
	.byt $7F, $5F, $7F, $7F, $7F, $7F, $7F, $5F	; tile #83
	.byt $7C, $5C, $7C, $74, $7E, $5C, $7F, $77	; tile #84
	.byt $60, $60, $67, $58, $40, $77, $7F, $5D	; tile #85
	.byt $40, $4F, $70, $43, $7F, $5D, $7F, $77	; tile #86
	.byt $5E, $60, $43, $5D, $7F, $77, $7F, $5D	; tile #87
	.byt $40, $45, $7F, $77, $7F, $5D, $7F, $77	; tile #88
	.byt $5F, $77, $7F, $5D, $7F, $77, $7F, $5D	; tile #89
	.byt $7E, $76, $7E, $76, $7E, $77, $7F, $77	; tile #90
	.byt $7F, $7D, $7D, $7F, $7F, $4F, $73, $7C	; tile #91
	.byt $7F, $6F, $6F, $7F, $7F, $7C, $73, $4F	; tile #92
	.byt $5F, $5F, $5F, $5F, $5F, $7F, $7F, $7F	; tile #93
	.byt $7F, $5D, $7F, $77, $7F, $5C, $60, $4F	; tile #94
	.byt $7F, $77, $7F, $5D, $70, $4F, $5F, $6F	; tile #95
	.byt $7F, $5D, $7F, $77, $7F, $5D, $6F, $77	; tile #96
	.byt $7F, $57, $7D, $7F, $7F, $7F, $7F, $7F	; tile #97
	.byt $7F, $7F, $55, $7F, $7D, $7F, $77, $7F	; tile #98
	.byt $7F, $7F, $5F, $7F, $7F, $7F, $7F, $7F	; tile #99
	.byt $40, $54, $41, $51, $42, $52, $45, $45	; tile #100
	.byt $40, $78, $47, $58, $C0, $F7, $EF, $EE	; tile #101
	.byt $40, $45, $40, $78, $F1, $CE, $C3, $F1	; tile #102
	.byt $40, $55, $40, $45, $60, $75, $70, $65	; tile #103
	.byt $5F, $6F, $77, $7B, $7D, $5E, $7F, $77	; tile #104
	.byt $77, $7B, $7D, $7D, $73, $47, $7B, $5B	; tile #105
	.byt $77, $75, $77, $6F, $6F, $6D, $77, $77	; tile #106
	.byt $7F, $5D, $7F, $77, $7F, $5D, $7F, $70	; tile #107
	.byt $7F, $77, $7F, $5D, $7F, $76, $60, $55	; tile #108
	.byt $7D, $5D, $7D, $75, $78, $45, $6A, $55	; tile #109
	.byt $7F, $77, $7F, $5D, $47, $50, $6A, $55	; tile #110
	.byt $7F, $5D, $7F, $77, $7F, $40, $6A, $55	; tile #111
	.byt $5F, $5F, $5F, $5F, $5F, $40, $6A, $55	; tile #112
	.byt $7F, $7F, $7F, $7F, $7F, $4F, $60, $55	; tile #113
	.byt $7F, $7F, $7D, $7F, $7D, $7F, $40, $55	; tile #114
	.byt $5F, $7F, $7F, $7F, $7F, $7F, $40, $55	; tile #115
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $43, $54	; tile #116
	.byt $7E, $7E, $7E, $7E, $7E, $7E, $7E, $40	; tile #117
	.byt $40, $53, $40, $54, $40, $55, $40, $55	; tile #118
	.byt $40, $7F, $40, $40, $40, $55, $40, $55	; tile #119
	.byt $40, $7F, $4F, $40, $40, $55, $40, $55	; tile #120
	.byt $40, $7F, $7F, $41, $40, $54, $40, $55	; tile #121
	.byt $40, $7F, $7F, $7F, $40, $40, $40, $55	; tile #122
	.byt $40, $7F, $7F, $7F, $47, $40, $40, $54	; tile #123
	.byt $40, $7F, $7F, $7F, $7F, $40, $40, $40	; tile #124
	.byt $40, $7F, $7F, $7F, $7F, $7F, $40, $40	; tile #125
	.byt $4B, $49, $4E, $71, $7E, $7F, $5F, $41	; tile #126
	.byt $FC, $FD, $4F, $71, $4E, $71, $7E, $7F	; tile #127
	.byt $F9, $FA, $F2, $F4, $4A, $72, $4C, $70	; tile #128
	.byt $60, $65, $40, $45, $40, $45, $40, $43	; tile #129
	.byt $40, $55, $40, $55, $40, $55, $40, $75	; tile #130
	.byt $7F, $77, $7F, $5D, $7F, $74, $60, $55	; tile #131
	.byt $7F, $5D, $7F, $78, $60, $55, $40, $55	; tile #132
	.byt $7F, $74, $60, $55, $40, $55, $40, $55	; tile #133
	.byt $60, $55, $40, $55, $40, $55, $40, $55	; tile #134
	.byt $41, $55, $40, $54, $40, $54, $40, $55	; tile #135
	.byt $77, $70, $78, $79, $7C, $7D, $58, $41	; tile #136
	.byt $7F, $5D, $42, $51, $40, $54, $40, $55	; tile #137
	.byt $7E, $71, $4A, $55, $6A, $55, $4A, $55	; tile #138
	.byt $42, $55, $6A, $55, $6A, $55, $6A, $55	; tile #139
	.byt $6A, $55, $6A, $55, $6A, $55, $6A, $55	; tile #140
	.byt $68, $55, $6A, $55, $6A, $55, $6A, $55	; tile #141
	.byt $40, $40, $40, $55, $40, $55, $40, $55	; tile #142
	.byt $47, $41, $40, $50, $40, $55, $40, $55	; tile #143
	.byt $7C, $7F, $4F, $43, $41, $50, $40, $55	; tile #144
	.byt $43, $7F, $7F, $7F, $7F, $5F, $47, $43	; tile #145
	.byt $40, $55, $40, $50, $41, $50, $45, $40	; tile #146
	.byt $40, $41, $54, $40, $55, $40, $55, $40	; tile #147
	.byt $40, $55, $40, $55, $40, $45, $50, $40	; tile #148
	.byt $40, $54, $41, $53, $43, $43, $43, $43	; tile #149
	.byt $4A, $55, $4A, $55, $4A, $55, $4A, $55	; tile #150
	.byt $40, $55, $40, $55, $40, $55, $40, $45	; tile #151
	.byt $40, $55, $40, $55, $40, $55, $40, $41	; tile #152
	.byt $40, $55, $40, $55, $40, $55, $40, $C0	; tile #153
	.byt $40, $55, $40, $55, $40, $40, $C0, $C0	; tile #154
	.byt $40, $55, $40, $55, $40, $55, $40, $40	; tile #155
	.byt $40, $54, $40, $55, $40, $55, $40, $55	; tile #156
	.byt $7F, $5F, $4F, $47, $43, $51, $40, $54	; tile #157
	.byt $40, $55, $40, $55, $40, $54, $40, $51	; tile #158
	.byt $45, $40, $45, $40, $45, $40, $45, $50	; tile #159
	.byt $55, $40, $55, $40, $55, $40, $55, $40	; tile #160
	.byt $54, $40, $54, $40, $55, $40, $55, $40	; tile #161
	.byt $43, $43, $43, $43, $43, $43, $43, $42	; tile #162
	.byt $6A, $55, $6A, $55, $6A, $54, $6A, $54	; tile #163
	.byt $68, $55, $68, $41, $C1, $C0, $C0, $F0	; tile #164
	.byt $40, $40, $C0, $C0, $FC, $C3, $C0, $C0	; tile #165
	.byt $40, $C0, $C0, $C0, $C0, $E0, $DE, $C1	; tile #166
	.byt $C0, $C0, $C0, $C0, $C0, $C0, $C0, $F0	; tile #167
	.byt $40, $C0, $C0, $C0, $C0, $C0, $C0, $C0	; tile #168
	.byt $40, $40, $C0, $C0, $C0, $C0, $C0, $C0	; tile #169
	.byt $40, $55, $40, $C0, $C0, $C0, $C1, $C7	; tile #170
	.byt $40, $55, $40, $41, $C7, $60, $40, $40	; tile #171
	.byt $40, $55, $40, $45, $40, $40, $40, $40	; tile #172
	.byt $40, $55, $40, $55, $40, $55, $40, $FF	; tile #173
	.byt $40, $55, $40, $54, $40, $54, $40, $54	; tile #174
	.byt $42, $45, $4A, $55, $6A, $55, $6A, $54	; tile #175
	.byt $65, $50, $65, $40, $55, $40, $55, $40	; tile #176
	.byt $40, $55, $4A, $55, $4A, $55, $4A, $55	; tile #177
	.byt $69, $54, $69, $54, $69, $54, $6A, $54	; tile #178
	.byt $70, $40, $7F, $40, $7F, $40, $7F, $40	; tile #179
	.byt $E0, $47, $78, $40, $7F, $40, $7F, $40	; tile #180
	.byt $C0, $C0, $C0, $43, $7C, $40, $7F, $40	; tile #181
	.byt $CF, $C0, $C0, $C0, $E0, $43, $7C, $40	; tile #182
	.byt $C0, $F8, $C7, $C0, $C0, $C0, $E0, $41	; tile #183
	.byt $C0, $C0, $E0, $DC, $C3, $C0, $C0, $C0	; tile #184
	.byt $C0, $C0, $C0, $C0, $E0, $DF, $C0, $C0	; tile #185
	.byt $C0, $C0, $C0, $C0, $C0, $C0, $F0, $CE	; tile #186
	.byt $C0, $C3, $CF, $60, $40, $40, $40, $40	; tile #187
	.byt $40, $40, $40, $40, $40, $40, $43, $4C	; tile #188
	.byt $40, $41, $43, $44, $58, $DF, $41, $FC	; tile #189
	.byt $60, $FF, $47, $F0, $5F, $C0, $7F, $C0	; tile #190
	.byt $40, $FF, $7F, $C0, $7F, $C0, $7F, $C1	; tile #191
	.byt $40, $FF, $70, $C7, $74, $D3, $5C, $C3	; tile #192
	.byt $40, $55, $40, $55, $40, $55, $40, $54	; tile #193
	.byt $40, $54, $40, $51, $40, $41, $50, $71	; tile #194
	.byt $41, $40, $55, $40, $55, $40, $69, $54	; tile #195
	.byt $4A, $45, $52, $45, $52, $45, $4A, $55	; tile #196
	.byt $7F, $40, $67, $50, $6A, $55, $6A, $55	; tile #197
	.byt $7F, $40, $7F, $40, $47, $50, $6A, $55	; tile #198
	.byt $7F, $40, $7F, $40, $7F, $40, $43, $54	; tile #199
	.byt $7F, $40, $7F, $40, $7F, $40, $7F, $40	; tile #200
	.byt $7E, $40, $7F, $40, $7F, $40, $7F, $40	; tile #201
	.byt $F8, $40, $7F, $40, $7F, $40, $7F, $40	; tile #202
	.byt $C0, $C0, $F8, $40, $7F, $40, $7F, $40	; tile #203
	.byt $C1, $C0, $C0, $E0, $63, $40, $7F, $40	; tile #204
	.byt $F8, $78, $C0, $C0, $C0, $E0, $61, $40	; tile #205
	.byt $40, $40, $60, $7C, $C0, $C0, $C0, $F0	; tile #206
	.byt $41, $43, $41, $41, $73, $C6, $C5, $C6	; tile #207
	.byt $70, $FF, $40, $FF, $40, $FF, $60, $DF	; tile #208
	.byt $44, $FD, $47, $FF, $40, $FE, $43, $FC	; tile #209
	.byt $40, $FF, $7F, $FF, $7F, $C0, $7B, $C2	; tile #210
	.byt $41, $FD, $7D, $FF, $40, $DF, $70, $CF	; tile #211
	.byt $78, $CF, $60, $FF, $40, $FF, $40, $FF	; tile #212
	.byt $40, $55, $40, $55, $40, $54, $41, $53	; tile #213
	.byt $41, $53, $47, $4F, $5D, $79, $73, $76	; tile #214
	.byt $70, $71, $70, $71, $70, $61, $40, $51	; tile #215
	.byt $6A, $55, $6A, $55, $6A, $55, $6A, $54	; tile #216
	.byt $6A, $54, $68, $50, $60, $40, $42, $40	; tile #217
	.byt $4C, $40, $4A, $40, $6A, $40, $6A, $40	; tile #218
	.byt $4A, $55, $4A, $45, $62, $41, $68, $40	; tile #219
	.byt $61, $54, $6A, $55, $6A, $55, $6A, $55	; tile #220
	.byt $7F, $40, $60, $55, $6A, $55, $6A, $55	; tile #221
	.byt $7F, $40, $7F, $40, $68, $55, $6A, $55	; tile #222
	.byt $7F, $40, $7F, $40, $5F, $40, $6A, $55	; tile #223
	.byt $7F, $40, $7F, $40, $7F, $40, $4F, $50	; tile #224
	.byt $71, $40, $7F, $40, $7F, $40, $7F, $40	; tile #225
	.byt $C5, $49, $72, $41, $7A, $41, $7A, $41	; tile #226
	.byt $60, $CF, $50, $D7, $58, $D7, $58, $D7	; tile #227
	.byt $47, $F8, $47, $F8, $47, $FC, $41, $FF	; tile #228
	.byt $7D, $C2, $7D, $C2, $7F, $C0, $7F, $C0	; tile #229
	.byt $78, $C7, $78, $C7, $78, $CF, $60, $FF	; tile #230
	.byt $40, $FF, $40, $FF, $40, $FF, $40, $FF	; tile #231
	
; Walkbox Data
wb_data
	.byt 008, 017, 012, 014, $01
	.byt 007, 019, 015, 016, $01
	.byt 020, 022, 016, 016, $01
	.byt 014, 016, 011, 011, $81
; Walk matrix
wb_matrix
	.byt 0, 1, 1, 3
	.byt 0, 1, 2, 0
	.byt 1, 1, 2, 1
	.byt 0, 0, 0, 3
	
res_end
.)


;;;;;;;;;;;;;;;;;;;;;;;;
; Door object
;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Object resource: Door (left side)
.(
	.byt RESOURCE_OBJECT|$80
	.word (res_end - res_start +4)
	.byt 200
res_start
	.byt 0			; If OBJ_FLAG_PROP skip all costume data
	.byt 6,6		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 14,10		; Pos (col, row)
	.byt ZPLANE_0		; Zplane
	.byt 15,11		; Walk position (col, row)
	.byt FACING_UP		; Facing direction for interaction
	.byt 00			; Color of text

	; tiles and pointers to animatory states are setup in the costume
	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt 202		; costume ($ff for none) and skip the rest
	.byt 0			; entry in costume resource		
	.byt 0			; direction (0 or LOOK_RIGHT for animstate 0)
	.byt 0			; animation speed	
#ifdef ENGLISH
	.asc "Door",0
#endif
#ifdef SPANISH
	.asc "Puerta",0
#endif
#ifdef FRENCH
	.asc "Porte",0
#endif
res_end	
.)

; Object resource: Door  (right side)
.(
	.byt RESOURCE_OBJECT|$80
	.word (res_end - res_start +4)
	.byt 201
res_start
	.byt 0			; If OBJ_FLAG_PROP skip all costume data
	.byt 0,0		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 14+2,10		; Pos (col, row)
	.byt ZPLANE_0		; Zplane
	.byt 15,11		; Walk position (col, row)
	.byt FACING_UP		; Facing direction for interaction
	.byt 00			; Color of text

	; META: TODO
	; tiles and pointers to animatory states are setup in the costume
	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt 202		; costume ($ff for none) and skip the rest
	.byt 0			; entry in costume resource		
	.byt 0			; direction (0 or LOOK_RIGHT for animstate 0)
	.byt 0			; animation speed	
	.asc "",0
res_end	
.)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; COSTUME for Door objects
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.(
	.byt RESOURCE_COSTUME|$80
	.word (res_end - res_start + 4)
	.byt 202
res_start
	; Pointers to tiles
	.byt <(door_tiles-res_start-8), >(door_tiles-res_start-8)
	.byt <(door_masks-res_start-8), >(door_masks-res_start-8)
	; Number of costumes included
	.byt 1
	;Offsets to animatory states for each costume
	.byt <(door_anim_states - res_start), >(door_anim_states - res_start)

door_anim_states
; Null animstate
.dsb 35,0
; Animatory state 0 (open1A.png)
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 0
.byt 5, 6, 7, 7, 0
.byt 8, 9, 10, 7, 0
.byt 7, 7, 7, 7, 0
.byt 11, 12, 13, 7, 0
.byt 14, 15, 16, 16, 0
; Animatory state 1 (open1B.png)
.byt 0, 0, 0, 0, 0
.byt 17, 2, 3, 4, 0
.byt 18, 7, 7, 7, 0
.byt 19, 7, 7, 7, 0
.byt 7, 7, 7, 7, 0
.byt 20, 7, 7, 7, 0
.byt 21, 22, 16, 16, 0
; Animatory state 2 (open1C.png)
.byt 0, 0, 0, 0, 0
.byt 17, 2, 3, 4, 0
.byt 7, 7, 7, 7, 0
.byt 7, 7, 7, 7, 0
.byt 7, 7, 7, 7, 0
.byt 7, 7, 7, 7, 0
.byt 21, 22, 16, 16, 0
; Animatory state 3 (open2A.png)
.byt 0, 0, 0, 0, 0
.byt 3, 4, 23, 24, 0
.byt 7, 7, 25, 26, 0
.byt 7, 27, 28, 29, 0
.byt 7, 30, 31, 32, 0
.byt 7, 33, 34, 35, 0
.byt 16, 16, 36, 37, 0
; Animatory state 4 (open2B.png)
.byt 0, 0, 0, 0, 0
.byt 3, 4, 4, 38, 0
.byt 7, 7, 7, 7, 0
.byt 7, 7, 7, 39, 0
.byt 7, 7, 7, 40, 0
.byt 7, 7, 7, 41, 0
.byt 16, 16, 42, 43, 0
; Animatory state 5 (open2C.png)
.byt 0, 0, 0, 0, 0
.byt 3, 4, 4, 38, 0
.byt 7, 7, 7, 7, 0
.byt 7, 7, 7, 7, 0
.byt 7, 7, 7, 7, 0
.byt 7, 7, 7, 7, 0
.byt 16, 16, 42, 43, 0

door_tiles

; Tile graphic 1
.byt $0, $0, $0, $0, $1e, $1e, $1e, $1e
; Tile graphic 2
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 3
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 4
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 5
.byt $1e, $1e, $1f, $1f, $1f, $1f, $1f, $1f
; Tile graphic 6
.byt $0, $0, $0, $20, $30, $38, $3c, $3e
; Tile graphic 7
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 8
.byt $1f, $1f, $1c, $18, $0, $0, $0, $0
; Tile graphic 9
.byt $3f, $3f, $0, $0, $0, $0, $0, $0
; Tile graphic 10
.byt $0, $20, $0, $0, $0, $0, $0, $0
; Tile graphic 11
.byt $0, $18, $1f, $1f, $1f, $1f, $1f, $1f
; Tile graphic 12
.byt $0, $0, $3f, $3f, $3e, $3c, $38, $30
; Tile graphic 13
.byt $0, $0, $20, $0, $0, $0, $0, $0
; Tile graphic 14
.byt $1f, $1f, $1e, $1c, $18, $0, $0, $0
; Tile graphic 15
.byt $20, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 16
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 17
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 18
.byt $0, $0, $0, $0, $0, $0, $0, $10
; Tile graphic 19
.byt $18, $1c, $0, $0, $0, $0, $0, $0
; Tile graphic 20
.byt $0, $0, $1c, $18, $10, $0, $0, $0
; Tile graphic 21
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 22
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 23
.byt $0, $0, $1, $1, $1, $1, $1, $1
; Tile graphic 24
.byt $0, $1e, $3e, $3e, $3e, $3e, $3e, $3e
; Tile graphic 25
.byt $1, $1, $0, $0, $0, $0, $0, $0
; Tile graphic 26
.byt $3e, $3e, $3e, $1e, $e, $6, $2, $0
; Tile graphic 27
.byt $0, $0, $0, $3, $7, $7, $7, $6
; Tile graphic 28
.byt $0, $0, $7, $3f, $3c, $33, $f, $3f
; Tile graphic 29
.byt $0, $0, $3e, $3e, $e, $32, $3c, $3e
; Tile graphic 30
.byt $6, $6, $6, $6, $6, $7, $7, $7
; Tile graphic 31
.byt $3f, $3d, $3d, $3f, $3f, $f, $33, $3c
; Tile graphic 32
.byt $3e, $2e, $2e, $3e, $3e, $3c, $32, $e
; Tile graphic 33
.byt $3, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 34
.byt $3f, $7, $0, $0, $0, $0, $0, $0
; Tile graphic 35
.byt $3e, $3e, $0, $0, $0, $2, $6, $e
; Tile graphic 36
.byt $0, $0, $1, $1, $1, $1, $1, $0
; Tile graphic 37
.byt $1e, $3e, $3e, $3e, $3e, $3e, $3e, $0
; Tile graphic 38
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 39
.byt $0, $0, $0, $e, $1e, $1e, $1c, $1a
; Tile graphic 40
.byt $1a, $1a, $1a, $1a, $1a, $1c, $1e, $1e
; Tile graphic 41
.byt $e, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 42
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 43
.byt $0, $0, $0, $0, $0, $0, $0, $0


door_masks
; Tile mask 1
.byt $ff, $ff, $ff, $ff, $40, $40, $40, $40
; Tile mask 2
.byt $ff, $ff, $ff, $40, $40, $40, $40, $40
; Tile mask 3
.byt $ff, $ff, $7e, $40, $40, $40, $40, $40
; Tile mask 4
.byt $ff, $ff, $40, $40, $40, $40, $40, $40
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
.byt $40, $40, $40, $40, $40, $ff, $ff, $ff
; Tile mask 15
.byt $40, $40, $40, $40, $40, $70, $ff, $ff
; Tile mask 16
.byt $40, $40, $40, $40, $40, $40, $ff, $ff
; Tile mask 17
.byt $ff, $ff, $ff, $ff, $40, $40, $40, $40
; Tile mask 18
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 19
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 20
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 21
.byt $40, $40, $40, $40, $40, $ff, $ff, $ff
; Tile mask 22
.byt $40, $40, $40, $40, $40, $70, $ff, $ff
; Tile mask 23
.byt $ff, $ff, $40, $40, $40, $40, $40, $40
; Tile mask 24
.byt $ff, $60, $40, $40, $40, $40, $40, $40
; Tile mask 25
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 26
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 27
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 28
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 29
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 30
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 31
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 32
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 33
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 34
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 35
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 36
.byt $40, $40, $40, $40, $40, $40, $7c, $ff
; Tile mask 37
.byt $40, $40, $40, $40, $40, $40, $40, $ff
; Tile mask 38
.byt $ff, $60, $40, $40, $40, $40, $40, $40
; Tile mask 39
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 40
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 41
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 42
.byt $40, $40, $40, $40, $40, $40, $7c, $ff
; Tile mask 43
.byt $40, $40, $40, $40, $40, $40, $40, $ff

res_end
.)


; Object resource 202: Drawer
.(
	.byt RESOURCE_OBJECT|$80
	.word (res_end-res_start+4)
	.byt 202
res_start
	.byt 0|OBJ_FLAG_PROP
	.byt 2,1	;Size (cols, rows)
	.byt 255	;Initial room
	.byt 1,16	;Location (col, row)
	.byt ZPLANE_1	;Zplane
	.byt 7,16	;Walk position (col, row)
	.byt FACING_LEFT
	.byt 0	; Color of text
#ifdef ENGLISH
	.asc "Drawer",0
#endif
#ifdef SPANISH
	.asc "Caj","Z"+4,"n",0
#endif
#ifdef FRENCH
	.asc "Tiroir",0
#endif
res_end
.)

; Object resource 203: Lamp
.(
	.byt RESOURCE_OBJECT|$80
	.word (res_end-res_start+4)
	.byt 203
res_start
	.byt 0|OBJ_FLAG_PROP
	.byt 2,2	;Size (cols, rows)
	.byt 255	;Initial room
	.byt 4,11	;Location (col, row)
	.byt ZPLANE_1	;Zplane
	.byt 8,14	;Walk position (col, row)
	.byt FACING_LEFT
	.byt 0	; Color of text
#ifdef ENGLISH
	.asc "Lamp",0
#endif
#ifdef SPANISH
	.asc "L","Z"+1,"mpara",0
#endif
#ifdef FRENCH
	.asc "Lampe",0
#endif
res_end
.)

; Object resource 204: Book
.(
	.byt RESOURCE_OBJECT|$80
	.word (res_end-res_start+4)
	.byt 204
res_start
	.byt 0|OBJ_FLAG_PROP
	.byt 2,1	;Size (cols, rows)
	.byt 255	;Initial room
	.byt 35,14	;Location (col, row)
	.byt ZPLANE_1	;Zplane
	.byt 24,16	;Walk position (col, row)
	.byt FACING_RIGHT
	.byt 0	; Color of text
#ifdef ENGLISH
	.asc "Book",0
#endif
#ifdef SPANISH
	.asc "Libro",0
#endif
#ifdef FRENCH
	.asc "Livre",0
#endif
res_end
.)

; Object resource 205: Ball
.(
	.byt RESOURCE_OBJECT|$80
	.word (res_end-res_start+4)
	.byt 205
res_start
	.byt 0|OBJ_FLAG_PROP
	.byt 1,1	;Size (cols, rows)
	.byt 255	;Initial room
	.byt 35,16	;Location (col, row)
	.byt ZPLANE_1	;Zplane
	.byt 24,16	;Walk position (col, row)
	.byt FACING_RIGHT
	.byt 0	; Color of text
#ifdef ENGLISH
	.asc "Ball",0
#endif
#ifdef SPANISH
	.asc "Bola",0
#endif
#ifdef FRENCH
	.asc "Boule",0
#endif
res_end
.)

; Object resource 206: Picture
.(
	.byt RESOURCE_OBJECT|$80
	.word (res_end-res_start+4)
	.byt 206
res_start
	.byt 0|OBJ_FLAG_PROP
	.byt 4,2	;Size (cols, rows)
	.byt 255	;Initial room
	.byt 33,10	;Location (col, row)
	.byt ZPLANE_1	;Zplane
	.byt 18,13	;Walk position (col, row)
	.byt FACING_RIGHT
	.byt 0	; Color of text
#ifdef ENGLISH
	.asc "Picture",0
#endif
#ifdef SPANISH
	.asc "Fotograf","Z"+3,"a",0
#endif
#ifdef FRENCH
	.asc "Photo",0
#endif

res_end
.)

; Object resource 207: Screen
.(
	.byt RESOURCE_OBJECT|$80
	.word (res_end-res_start+4)
	.byt 207
res_start
	.byt 0|OBJ_FLAG_PROP
	.byt 5,5	;Size (cols, rows)
	.byt 255	;Initial room
	.byt 6,8	;Location (col, row)
	.byt ZPLANE_1	;Zplane
	.byt 11,11	;Walk position (col, row)
	.byt FACING_LEFT
	.byt 0	; Color of text
#ifdef ENGLISH
	.asc "Screen",0
#endif
#ifdef SPANISH
	.asc "Pantalla",0
#endif
#ifdef FRENCH
	.asc "Ecran",0
#endif

res_end
.)

/*
.(
	.byt RESOURCE_STRING
	.word res_end - res_start + 4
	.byt 200
res_start
	.asc "I have a meeting with Ravella.",0
	.asc "She has some information...",0
res_end
.)

*/


; Sandwich
.(
.byt RESOURCE_COSTUME|$80
.word (res_end - res_start + 4)
.byt 210
res_start
	; Pointers to tiles
	.byt <(costume_tiles-res_start-8), >(costume_tiles-res_start-8)
	.byt <(costume_masks-res_start-8), >(costume_masks-res_start-8)
	; Number of costumes included
	.byt 1
	;Offsets to animatory states for each costume
	.byt <(anim_states - res_start), >(anim_states - res_start)
anim_states
; Animatory state 0 (sandwich.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 0
.byt 5, 6, 7, 8, 0
costume_tiles
; Tile graphic 1
.byt $0, $0, $0, $0, $3, $4, $b, $17
; Tile graphic 2
.byt $7, $8, $17, $2f, $1d, $3f, $36, $1f
; Tile graphic 3
.byt $0, $30, $c, $33, $1c, $3f, $37, $3e
; Tile graphic 4
.byt $0, $0, $0, $0, $30, $8, $14, $24
; Tile graphic 5
.byt $11, $14, $8, $4, $3, $0, $0, $0
; Tile graphic 6
.byt $3b, $1e, $7, $22, $10, $23, $1c, $3
; Tile graphic 7
.byt $2c, $39, $30, $d, $12, $24, $18, $20
; Tile graphic 8
.byt $28, $10, $20, $0, $0, $0, $0, $0
costume_masks
; Tile mask 1
.byt $ff, $ff, $ff, $ff, $7c, $78, $70, $60
; Tile mask 2
.byt $78, $70, $60, $40, $40, $40, $40, $40
; Tile mask 3
.byt $ff, $4f, $43, $40, $40, $40, $40, $40
; Tile mask 4
.byt $ff, $ff, $ff, $ff, $4f, $47, $43, $43
; Tile mask 5
.byt $60, $60, $70, $78, $7c, $ff, $ff, $ff
; Tile mask 6
.byt $40, $40, $40, $40, $40, $40, $60, $7c
; Tile mask 7
.byt $40, $40, $40, $40, $41, $43, $47, $5f
; Tile mask 8
.byt $47, $4f, $5f, $ff, $ff, $ff, $ff, $ff
res_end
.)



; Mug
.(
.byt RESOURCE_COSTUME|$80
.word (res_end - res_start + 4)
.byt 211
res_start
	; Pointers to tiles
	.byt <(costume_tiles-res_start-8), >(costume_tiles-res_start-8)
	.byt <(costume_masks-res_start-8), >(costume_masks-res_start-8)
	; Number of costumes included
	.byt 1
	;Offsets to animatory states for each costume
	.byt <(anim_states - res_start), >(anim_states - res_start)
anim_states
; Animatory state 0 (mug.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 0, 0
.byt 4, 5, 6, 0, 0
costume_tiles
; Tile graphic 1
.byt $3, $4, $b, $9, $a, $b, $b, $a
; Tile graphic 2
.byt $3f, $0, $3f, $3e, $1, $3f, $1b, $3d
; Tile graphic 3
.byt $0, $20, $10, $10, $10, $8, $34, $14
; Tile graphic 4
.byt $a, $a, $a, $b, $5, $2, $1, $0
; Tile graphic 5
.byt $25, $25, $1, $3, $3e, $1, $3e, $0
; Tile graphic 6
.byt $14, $34, $8, $10, $20, $0, $0, $0
costume_masks
; Tile mask 1
.byt $7c, $78, $70, $70, $70, $70, $70, $70
; Tile mask 2
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 3
.byt $ff, $5f, $4f, $4f, $4f, $47, $43, $43
; Tile mask 4
.byt $70, $70, $70, $70, $78, $7c, $7e, $ff
; Tile mask 5
.byt $40, $40, $40, $40, $40, $40, $41, $ff
; Tile mask 6
.byt $43, $43, $47, $4f, $5f, $ff, $ff, $ff
res_end
.)


#include "..\scripts\blakesroom.s"



