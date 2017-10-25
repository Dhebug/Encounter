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
; Room: Lib-Zen
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.(
	.byt RESOURCE_ROOM
	.word (res_end - res_start + 4)
	.byt 23
res_start
; No. columns, offset to tile map, offset to tiles
	.byt 38, <(column_data-res_start), >(column_data-res_start), <(tiles_start-res_start), >(tiles_start-res_start)
; No. zplanes and offsets to zplanes
	.byt 0
; No. Walkboxes and offsets to wb data and matrix
	.byt 3, <(wb_data-res_start), >(wb_data-res_start), <(wb_matrix-res_start), >(wb_matrix-res_start)
; Offset to palette
	.byt 0, 0	; No palette information
; Entry and exit scripts
	.byt 200, 255
; Number of objects in the room and list of ids
	.byt 5,200,201,202,203,204
; Room name (null terminated)
	.asc "Lib-Zen", 0
; Room tile map
column_data
	.byt 001, 007, 007, 007, 007, 024, 030, 080, 094, 007, 007, 007, 165, 148, 148, 148, 189
	.byt 001, 007, 007, 007, 041, 058, 043, 081, 095, 110, 007, 007, 166, 148, 148, 148, 189
	.byt 002, 007, 024, 030, 042, 059, 059, 082, 033, 033, 128, 094, 167, 177, 148, 148, 189
	.byt 003, 007, 025, 031, 043, 043, 043, 083, 033, 033, 033, 146, 168, 178, 148, 148, 189
	.byt 004, 008, 026, 032, 044, 060, 071, 084, 096, 111, 129, 147, 168, 178, 148, 148, 189
	.byt 005, 005, 026, 033, 033, 061, 072, 072, 072, 072, 130, 148, 168, 178, 148, 148, 189
	.byt 005, 009, 026, 033, 033, 061, 072, 072, 072, 072, 131, 148, 168, 178, 148, 148, 189
	.byt 005, 010, 026, 033, 033, 061, 072, 072, 072, 072, 131, 148, 168, 178, 148, 148, 189
	.byt 005, 010, 026, 033, 033, 061, 072, 072, 072, 072, 131, 148, 168, 178, 148, 148, 189
	.byt 005, 011, 026, 033, 033, 061, 072, 072, 072, 072, 131, 148, 168, 178, 148, 148, 189
	.byt 005, 011, 026, 034, 045, 062, 073, 085, 097, 112, 132, 149, 168, 178, 148, 148, 189
	.byt 005, 012, 027, 035, 043, 043, 074, 086, 098, 033, 033, 150, 168, 178, 148, 148, 189
	.byt 005, 013, 028, 036, 046, 059, 059, 087, 033, 033, 133, 151, 169, 178, 148, 148, 189
	.byt 005, 014, 007, 015, 047, 063, 043, 088, 034, 113, 134, 152, 170, 179, 184, 148, 189
	.byt 005, 015, 007, 037, 007, 028, 075, 089, 099, 114, 135, 153, 171, 180, 185, 148, 189
	.byt 005, 016, 007, 017, 007, 007, 005, 007, 100, 115, 136, 153, 171, 180, 185, 148, 189
	.byt 005, 017, 007, 017, 007, 007, 005, 007, 101, 116, 135, 153, 171, 180, 185, 148, 189
	.byt 005, 017, 007, 038, 007, 007, 005, 007, 102, 117, 137, 153, 171, 180, 185, 148, 189
	.byt 005, 018, 007, 019, 007, 007, 076, 007, 103, 118, 138, 154, 172, 180, 185, 148, 189
	.byt 005, 019, 007, 019, 007, 007, 010, 007, 100, 119, 139, 155, 173, 180, 185, 148, 189
	.byt 005, 020, 007, 019, 007, 007, 010, 007, 104, 120, 134, 152, 174, 180, 185, 148, 189
	.byt 005, 021, 007, 021, 007, 007, 010, 007, 105, 121, 136, 153, 171, 180, 185, 148, 189
	.byt 005, 022, 029, 021, 007, 007, 010, 007, 100, 122, 135, 153, 171, 180, 185, 148, 189
	.byt 005, 007, 005, 021, 007, 007, 010, 090, 106, 123, 135, 153, 171, 180, 185, 148, 189
	.byt 005, 007, 005, 039, 008, 064, 077, 091, 107, 124, 140, 153, 171, 180, 185, 148, 189
	.byt 005, 007, 005, 007, 048, 065, 000, 000, 000, 125, 141, 156, 172, 180, 185, 148, 189
	.byt 006, 023, 006, 040, 049, 066, 000, 000, 000, 000, 142, 157, 173, 180, 185, 148, 189
	.byt 005, 007, 005, 021, 050, 000, 000, 000, 000, 000, 056, 158, 000, 181, 186, 148, 189
	.byt 005, 007, 005, 021, 051, 000, 000, 000, 000, 000, 000, 159, 000, 182, 187, 148, 189
	.byt 005, 007, 005, 021, 052, 000, 000, 000, 000, 000, 000, 160, 175, 182, 187, 148, 189
	.byt 005, 007, 005, 021, 053, 000, 000, 000, 000, 000, 000, 161, 176, 182, 187, 148, 189
	.byt 005, 007, 005, 021, 054, 000, 000, 000, 000, 000, 000, 162, 000, 182, 187, 148, 189
	.byt 005, 007, 005, 021, 055, 000, 000, 000, 000, 000, 049, 163, 000, 183, 188, 148, 189
	.byt 005, 007, 005, 021, 056, 067, 000, 000, 000, 000, 143, 157, 173, 180, 185, 148, 189
	.byt 005, 007, 005, 007, 057, 068, 000, 000, 000, 126, 144, 164, 174, 180, 185, 148, 189
	.byt 005, 021, 007, 021, 007, 069, 078, 092, 108, 127, 145, 153, 171, 180, 185, 148, 189
	.byt 005, 021, 007, 021, 007, 070, 079, 093, 109, 007, 135, 153, 171, 180, 185, 148, 189
	.byt 005, 019, 007, 019, 007, 021, 007, 007, 005, 007, 136, 153, 171, 180, 185, 148, 189

; Room tile set
tiles_start
	.byt $40, $7F, $55, $7F, $55, $7F, $40, $7F	; tile #1
	.byt $40, $7F, $55, $7F, $55, $7F, $55, $60	; tile #2
	.byt $40, $7F, $55, $7F, $55, $7F, $55, $40	; tile #3
	.byt $40, $7F, $55, $7F, $55, $7F, $55, $47	; tile #4
	.byt $40, $7F, $55, $7F, $55, $7F, $55, $7F	; tile #5
	.byt $40, $5F, $55, $5F, $55, $5F, $55, $5F	; tile #6
	.byt $55, $7F, $55, $7F, $55, $7F, $55, $7F	; tile #7
	.byt $50, $7F, $55, $7F, $55, $7F, $55, $7F	; tile #8
	.byt $41, $7C, $55, $7F, $55, $7F, $55, $7F	; tile #9
	.byt $55, $40, $55, $7F, $55, $7F, $55, $7F	; tile #10
	.byt $55, $7F, $40, $7F, $55, $7F, $55, $7F	; tile #11
	.byt $55, $7F, $45, $70, $55, $7F, $55, $7F	; tile #12
	.byt $55, $7F, $55, $40, $55, $7F, $55, $7F	; tile #13
	.byt $55, $7F, $55, $47, $50, $7F, $55, $7F	; tile #14
	.byt $55, $7F, $55, $7F, $40, $7F, $55, $7F	; tile #15
	.byt $55, $7F, $55, $7F, $41, $7E, $55, $7F	; tile #16
	.byt $55, $7F, $55, $7F, $55, $40, $55, $7F	; tile #17
	.byt $55, $7F, $55, $7F, $55, $5F, $40, $7F	; tile #18
	.byt $55, $7F, $55, $7F, $55, $7F, $40, $7F	; tile #19
	.byt $55, $7F, $55, $7F, $55, $7F, $45, $70	; tile #20
	.byt $55, $7F, $55, $7F, $55, $7F, $55, $40	; tile #21
	.byt $55, $7F, $55, $7F, $55, $7F, $55, $43	; tile #22
	.byt $55, $5F, $55, $5F, $55, $5F, $55, $5F	; tile #23
	.byt $55, $7F, $55, $7F, $55, $7F, $54, $7E	; tile #24
	.byt $55, $70, $47, $6B, $5B, $5D, $75, $7D	; tile #25
	.byt $55, $40, $7F, $7F, $7F, $7F, $7F, $7F	; tile #26
	.byt $55, $41, $79, $79, $78, $76, $77, $6F	; tile #27
	.byt $55, $7F, $55, $7F, $55, $7F, $55, $5F	; tile #28
	.byt $54, $7F, $55, $7F, $55, $7F, $55, $7F	; tile #29
	.byt $55, $7D, $51, $7B, $57, $77, $4D, $6F	; tile #30
	.byt $5C, $7E, $77, $7F, $5D, $7F, $77, $7F	; tile #31
	.byt $7F, $7F, $5F, $5F, $5F, $6F, $4F, $77	; tile #32
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F	; tile #33
	.byt $7F, $7F, $7F, $7F, $7E, $7E, $7D, $7D	; tile #34
	.byt $6D, $5F, $57, $5F, $5D, $7F, $77, $7F	; tile #35
	.byt $65, $6F, $55, $77, $70, $7B, $5D, $7D	; tile #36
	.byt $55, $7F, $55, $7F, $45, $78, $55, $7F	; tile #37
	.byt $55, $7F, $55, $7F, $55, $41, $54, $7F	; tile #38
	.byt $55, $7F, $55, $7F, $55, $7F, $55, $4F	; tile #39
	.byt $55, $5F, $55, $5F, $55, $5F, $55, $40	; tile #40
	.byt $55, $7F, $54, $7E, $55, $7D, $53, $7B	; tile #41
	.byt $57, $5F, $5D, $7F, $77, $7F, $5D, $7F	; tile #42
	.byt $5D, $7F, $77, $7F, $5D, $7F, $77, $7F	; tile #43
	.byt $77, $77, $7B, $5B, $7B, $75, $7D, $5C	; tile #44
	.byt $7D, $7B, $7B, $79, $77, $77, $77, $6D	; tile #45
	.byt $76, $7E, $5D, $7F, $77, $7F, $5D, $7F	; tile #46
	.byt $55, $7F, $55, $5F, $45, $6F, $75, $77	; tile #47
	.byt $40, $7E, $54, $7C, $54, $78, $50, $70	; tile #48
	.byt $40, $40, $40, $40, $40, $40, $41, $46	; tile #49
	.byt $40, $40, $40, $40, $43, $4C, $70, $40	; tile #50
	.byt $40, $40, $40, $4F, $70, $40, $40, $40	; tile #51
	.byt $40, $40, $5F, $60, $40, $40, $40, $40	; tile #52
	.byt $40, $40, $7E, $41, $40, $40, $40, $40	; tile #53
	.byt $40, $40, $40, $7C, $43, $40, $40, $40	; tile #54
	.byt $40, $40, $40, $40, $70, $4C, $43, $40	; tile #55
	.byt $40, $40, $40, $40, $40, $40, $60, $58	; tile #56
	.byt $40, $5F, $55, $4F, $45, $47, $45, $43	; tile #57
	.byt $55, $77, $47, $6F, $5D, $5F, $77, $7F	; tile #58
	.byt $77, $7F, $5D, $7F, $77, $7F, $5D, $7F	; tile #59
	.byt $7E, $76, $7E, $5C, $7D, $75, $7D, $5B	; tile #60
	.byt $7F, $40, $C0, $C0, $C0, $C0, $C0, $C0	; tile #61
	.byt $6F, $5F, $4D, $5F, $67, $6F, $65, $77	; tile #62
	.byt $59, $7B, $75, $7D, $5C, $7E, $77, $7F	; tile #63
	.byt $55, $7F, $55, $7F, $55, $7E, $54, $7C	; tile #64
	.byt $50, $60, $41, $42, $44, $48, $50, $60	; tile #65
	.byt $48, $70, $40, $40, $40, $40, $40, $40	; tile #66
	.byt $44, $43, $40, $40, $40, $40, $40, $40	; tile #67
	.byt $41, $41, $61, $50, $48, $44, $42, $41	; tile #68
	.byt $55, $7F, $55, $7F, $55, $5F, $55, $4F	; tile #69
	.byt $55, $7F, $55, $7F, $55, $7F, $55, $7E	; tile #70
	.byt $7B, $C4, $E8, $C8, $D0, $D0, $D0, $E0	; tile #71
	.byt $C0, $C0, $C0, $C0, $C0, $C0, $C0, $C0	; tile #72
	.byt $77, $C8, $C4, $C4, $C4, $C2, $C2, $C1	; tile #73
	.byt $5D, $7F, $77, $7F, $7C, $70, $40, $40	; tile #74
	.byt $60, $6F, $55, $77, $71, $7B, $5D, $7D	; tile #75
	.byt $55, $60, $55, $7F, $55, $7F, $55, $7F	; tile #76
	.byt $55, $42, $52, $74, $54, $68, $48, $50	; tile #77
	.byt $60, $57, $55, $4B, $49, $45, $45, $42	; tile #78
	.byt $41, $7F, $55, $7F, $55, $7F, $55, $7F	; tile #79
	.byt $57, $47, $48, $6F, $57, $77, $53, $7B	; tile #80
	.byt $5D, $7F, $43, $7C, $7F, $7F, $7F, $7F	; tile #81
	.byt $77, $7F, $5D, $41, $7E, $7F, $7F, $7F	; tile #82
	.byt $5D, $7F, $76, $7E, $40, $7E, $7E, $7F	; tile #83
	.byt $E0, $E0, $C0, $C0, $C0, $C0, $C0, $E0	; tile #84
	.byt $C1, $C1, $C0, $C0, $C0, $C0, $C0, $C1	; tile #85
	.byt $44, $4C, $5C, $54, $54, $5C, $4C, $44	; tile #86
	.byt $77, $7F, $5E, $40, $7F, $7F, $7F, $7F	; tile #87
	.byt $5D, $7F, $70, $4F, $7F, $7F, $7F, $7F	; tile #88
	.byt $74, $78, $45, $7D, $79, $7B, $75, $77	; tile #89
	.byt $55, $7E, $54, $7C, $54, $78, $50, $70	; tile #90
	.byt $50, $50, $50, $60, $60, $60, $60, $60	; tile #91
	.byt $42, $42, $42, $41, $41, $41, $41, $41	; tile #92
	.byt $55, $5F, $55, $4F, $45, $47, $45, $43	; tile #93
	.byt $55, $7D, $54, $7E, $55, $7F, $55, $7F	; tile #94
	.byt $7F, $7F, $7F, $7F, $5F, $5F, $4F, $6F	; tile #95
	.byt $E0, $E0, $E0, $D0, $D0, $D0, $C8, $C8	; tile #96
	.byt $C1, $C1, $C1, $C1, $C2, $C2, $C4, $C4	; tile #97
	.byt $40, $40, $70, $7C, $7F, $7F, $7F, $7F	; tile #98
	.byt $70, $6F, $54, $5E, $54, $7E, $54, $7E	; tile #99
	.byt $40, $7F, $40, $C0, $C0, $C0, $C0, $C0	; tile #100
	.byt $40, $7F, $40, $C0, $C0, $C0, $C8, $C0	; tile #101
	.byt $40, $7F, $40, $C0, $C0, $C0, $EA, $C0	; tile #102
	.byt $40, $7F, $40, $C0, $C0, $C0, $E8, $C0	; tile #103
	.byt $40, $7F, $40, $C0, $C0, $C0, $CA, $C0	; tile #104
	.byt $40, $7F, $40, $C0, $C0, $C0, $E0, $C0	; tile #105
	.byt $40, $70, $50, $58, $50, $5C, $54, $5E	; tile #106
	.byt $60, $60, $50, $50, $50, $50, $48, $48	; tile #107
	.byt $41, $41, $42, $42, $42, $42, $44, $44	; tile #108
	.byt $40, $43, $41, $47, $45, $4F, $45, $5F	; tile #109
	.byt $57, $77, $53, $7B, $55, $7D, $54, $7E	; tile #110
	.byt $C8, $7B, $C4, $7B, $7D, $7D, $7D, $7E	; tile #111
	.byt $C4, $77, $C8, $77, $6F, $6F, $5F, $5F	; tile #112
	.byt $79, $7B, $75, $77, $65, $6F, $55, $5F	; tile #113
	.byt $54, $7E, $54, $7E, $54, $7E, $54, $7E	; tile #114
	.byt $C0, $C0, $C4, $C0, $C0, $C0, $C0, $40	; tile #115
	.byt $C8, $C0, $E2, $C0, $C0, $C0, $C0, $40	; tile #116
	.byt $C2, $C0, $E8, $C0, $C0, $C0, $C0, $40	; tile #117
	.byt $E8, $C0, $C0, $C0, $C0, $C0, $C0, $40	; tile #118
	.byt $C0, $C0, $C2, $C0, $C0, $C0, $C0, $40	; tile #119
	.byt $C0, $C0, $C0, $C0, $C0, $C0, $C0, $40	; tile #120
	.byt $C0, $C0, $E2, $C0, $C0, $C0, $C0, $40	; tile #121
	.byt $C0, $C0, $E8, $C0, $C0, $C0, $C0, $40	; tile #122
	.byt $54, $5F, $55, $5F, $55, $5F, $55, $5F	; tile #123
	.byt $48, $44, $44, $62, $41, $70, $50, $78	; tile #124
	.byt $40, $40, $40, $40, $40, $60, $60, $50	; tile #125
	.byt $40, $40, $40, $40, $40, $41, $41, $42	; tile #126
	.byt $44, $48, $48, $51, $61, $43, $41, $47	; tile #127
	.byt $5F, $5F, $4F, $6F, $57, $77, $53, $7B	; tile #128
	.byt $7E, $7E, $7E, $7E, $7E, $7C, $79, $72	; tile #129
	.byt $C0, $40, $55, $4A, $55, $6A, $55, $6A	; tile #130
	.byt $C0, $40, $55, $6A, $55, $6A, $55, $6A	; tile #131
	.byt $5F, $5F, $5F, $5F, $4F, $67, $53, $69	; tile #132
	.byt $7E, $7E, $7C, $7D, $79, $7A, $75, $76	; tile #133
	.byt $55, $7F, $40, $7F, $56, $6D, $55, $6B	; tile #134
	.byt $55, $7F, $40, $7F, $40, $EA, $6B, $7F	; tile #135
	.byt $55, $7F, $40, $7F, $40, $7F, $ED, $7F	; tile #136
	.byt $55, $7F, $40, $7F, $43, $7D, $6D, $7E	; tile #137
	.byt $55, $7F, $40, $7F, $55, $6A, $75, $7A	; tile #138
	.byt $55, $7F, $40, $7F, $55, $6A, $55, $6A	; tile #139
	.byt $54, $7C, $42, $7E, $43, $7D, $55, $7E	; tile #140
	.byt $48, $46, $41, $40, $40, $40, $40, $60	; tile #141
	.byt $40, $40, $40, $60, $58, $46, $41, $40	; tile #142
	.byt $40, $40, $40, $43, $46, $58, $60, $40	; tile #143
	.byt $44, $48, $70, $40, $40, $40, $41, $41	; tile #144
	.byt $45, $4F, $50, $5F, $70, $6F, $6A, $5F	; tile #145
	.byt $7F, $7F, $7E, $7C, $59, $52, $45, $62	; tile #146
	.byt $65, $4A, $55, $6A, $55, $6A, $55, $6A	; tile #147
	.byt $55, $6A, $55, $6A, $55, $6A, $55, $6A	; tile #148
	.byt $54, $6A, $55, $6A, $55, $6A, $55, $6A	; tile #149
	.byt $7F, $5F, $4F, $67, $52, $68, $55, $68	; tile #150
	.byt $65, $6F, $40, $40, $7F, $40, $7F, $40	; tile #151
	.byt $58, $7F, $40, $40, $7F, $40, $7F, $40	; tile #152
	.byt $40, $7F, $40, $40, $7F, $40, $7F, $40	; tile #153
	.byt $7D, $7F, $40, $40, $7F, $40, $7F, $40	; tile #154
	.byt $55, $7F, $40, $40, $7F, $40, $7F, $40	; tile #155
	.byt $60, $70, $40, $40, $7F, $40, $7F, $40	; tile #156
	.byt $40, $40, $40, $40, $7F, $40, $7F, $40	; tile #157
	.byt $47, $40, $40, $40, $7F, $40, $7F, $40	; tile #158
	.byt $60, $5F, $40, $40, $7F, $40, $7F, $40	; tile #159
	.byt $40, $40, $7F, $40, $63, $F0, $F0, $E0	; tile #160
	.byt $40, $40, $7F, $40, $71, $C3, $C3, $C1	; tile #161
	.byt $41, $7E, $40, $40, $7F, $40, $5F, $40	; tile #162
	.byt $78, $40, $40, $40, $7F, $40, $7F, $40	; tile #163
	.byt $41, $43, $40, $40, $7F, $40, $7F, $40	; tile #164
	.byt $55, $7F, $55, $40, $55, $6A, $55, $6A	; tile #165
	.byt $55, $7F, $40, $6A, $55, $6A, $55, $6A	; tile #166
	.byt $54, $7B, $43, $6B, $50, $6F, $4F, $6F	; tile #167
	.byt $40, $7F, $7F, $7F, $40, $7F, $7F, $7F	; tile #168
	.byt $40, $7A, $7B, $7B, $41, $7E, $7E, $7E	; tile #169
	.byt $40, $47, $63, $71, $78, $7C, $7C, $7E	; tile #170
	.byt $40, $FF, $6A, $EA, $7F, $40, $40, $7F	; tile #171
	.byt $40, $78, $70, $60, $40, $40, $40, $7F	; tile #172
	.byt $40, $40, $40, $40, $40, $40, $40, $7F	; tile #173
	.byt $40, $47, $43, $41, $40, $40, $40, $7F	; tile #174
	.byt $E0, $E0, $E0, $5F, $47, $40, $40, $40	; tile #175
	.byt $C1, $C1, $C1, $7E, $78, $40, $40, $40	; tile #176
	.byt $40, $5F, $5F, $5F, $5F, $5F, $40, $6A	; tile #177
	.byt $40, $7F, $7F, $7F, $7F, $7F, $40, $6A	; tile #178
	.byt $5E, $6E, $6E, $6E, $6E, $6E, $4E, $6E	; tile #179
	.byt $40, $7F, $7F, $7F, $7F, $7F, $7F, $7F	; tile #180
	.byt $60, $50, $4F, $50, $57, $57, $57, $57	; tile #181
	.byt $40, $40, $7F, $40, $7F, $7F, $7F, $7F	; tile #182
	.byt $41, $42, $7C, $42, $7A, $7A, $7A, $7A	; tile #183
	.byt $56, $6A, $54, $6A, $55, $6A, $55, $6A	; tile #184
	.byt $7F, $7F, $7F, $7F, $40, $6A, $55, $6A	; tile #185
	.byt $57, $57, $57, $57, $57, $40, $55, $6A	; tile #186
	.byt $7F, $7F, $7F, $7F, $7F, $40, $55, $6A	; tile #187
	.byt $7A, $7A, $7A, $7A, $7A, $40, $55, $6A	; tile #188
	.byt $55, $6A, $55, $6A, $55, $6A, $55, $40	; tile #189
; Walkbox Data
wb_data
	.byt 000, 034, 015, 016, $01
	.byt 003, 008, 012, 014, $01
	.byt 005, 005, 011, 011, $01
; Walk matrix
wb_matrix
	.byt 0, 1, 1
	.byt 0, 1, 2
	.byt 1, 1, 2


res_end
.)


; Object resource 200: exit to deck
.(
	.byt RESOURCE_OBJECT|$80
	.word (res_end-res_start+4)
	.byt 200
res_start
	.byt 0|OBJ_FLAG_PROP
	.byt 3,17	;Size (cols, rows)
	.byt 255	;Initial room
	.byt 35,16	;Location (col, row)
	.byt ZPLANE_1	;Zplane
	.byt 34,$fe	;Walk position (col, row)
	.byt FACING_RIGHT
	.byt 0	; Color of text
#ifdef ENGLISH	
	.asc "Bridge",0	;Object's name
#endif
#ifdef SPANISH
	.asc "Puente",0	;Object's name
#endif	
res_end
.)


; Object resource 201: Back Door
.(
	.byt RESOURCE_OBJECT|$80
	.word (res_end-res_start+4)
	.byt 201
res_start
	.byt 0|OBJ_FLAG_PROP
	.byt 5,6	;Size (cols, rows)
	.byt 255	;Initial room
	.byt 5,10	;Location (col, row)
	.byt ZPLANE_1	;Zplane
	.byt 5,11	;Walk position (col, row)
	.byt FACING_UP
	.byt 0	; Color of text
#ifdef ENGLISH	
	.asc "Back corridor",0	;Object's name
#endif
#ifdef SPANISH
	.asc "Corredor",0	;Object's name
#endif	
res_end
.)


; left side of zen 25,10, 5x6 tiles
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 202
res_start
	.byt OBJ_FLAG_ACTOR	; If OBJ_FLAG_PROP skip all costume data
	.byt 10,6		; Size (cols rows)
	.byt $ff		; Room
	.byt 25,10		; Pos (col, row)
	.byt ZPLANE_0		; Zplane
	.byt 20,15		; Walk position (col, row)
	.byt FACING_RIGHT		; Facing direction for interaction
	.byt A_FWWHITE+A_FWCYAN*8+$c0	; Color of text

	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt 200			; costume ($ff for none) and skip the rest
	.byt 0			; entry in costume resource		
	.byt 0		; direction (0 or LOOK_RIGHT for animstate 0)
	.byt 1			; animation speed	
	.asc "Zen",0
res_end	
.)
; right side of zen 30,10, 5x6 tiles
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 203
res_start
	.byt OBJ_FLAG_ACTOR	; If OBJ_FLAG_PROP skip all costume data
	.byt 5,6		; Size (cols rows)
	.byt $ff		; Room
	.byt 30,10		; Pos (col, row)
	.byt ZPLANE_0		; Zplane
	.byt 20,15		; Walk position (col, row)
	.byt FACING_RIGHT		; Facing direction for interaction
	.byt A_FWWHITE+A_FWCYAN*8+$c0	; Color of text

	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt 200			; costume ($ff for none) and skip the rest
	.byt 1			; entry in costume resource		
	.byt 0		; direction (0 or LOOK_RIGHT for animstate 0)
	.byt 1			; animation speed	
	.asc "Zen",0
res_end	
.)
; Costumes for the two parts of zen
.(
.byt RESOURCE_COSTUME
.word (res_end - res_start + 4)
.byt 200
res_start
	; Pointers to tiles
	.byt <(costume_tiles-res_start-8), >(costume_tiles-res_start-8)
	.byt <(costume_masks-res_start-8), >(costume_masks-res_start-8)
	; Number of costumes included
	.byt 2
	;Offsets to animatory states for each costume
	.byt <(anim_states - res_start), >(anim_states - res_start)
	.byt <(anim_states2 - res_start), >(anim_states2 - res_start)
anim_states
; Animatory state 0 (00-silence1A.png)
.byt 0, 0, 0, 0, 0
.byt 0, 1, 2, 2, 2
.byt 0, 2, 2, 2, 2
.byt 0, 2, 2, 2, 2
.byt 0, 2, 2, 2, 2
.byt 0, 2, 2, 2, 3
.byt 0, 4, 5, 2, 2
; Animatory state 1 (01-silence2A.png)
.byt 0, 0, 0, 0, 0
.byt 0, 6, 2, 2, 2
.byt 0, 2, 3, 2, 2
.byt 0, 2, 2, 2, 2
.byt 0, 2, 2, 2, 2
.byt 0, 7, 2, 2, 2
.byt 0, 4, 5, 2, 2
; Animatory state 2 (02-speak1A.png)
.byt 0, 0, 0, 0, 0
.byt 0, 1, 2, 2, 2
.byt 0, 2, 2, 2, 2
.byt 0, 8, 8, 8, 8
.byt 0, 2, 2, 2, 2
.byt 0, 2, 2, 2, 3
.byt 0, 4, 5, 2, 2
; Animatory state 3 (03-speak2A.png)
.byt 0, 0, 0, 0, 0
.byt 0, 6, 2, 2, 2
.byt 0, 2, 3, 2, 2
.byt 0, 8, 8, 8, 8
.byt 0, 2, 2, 2, 2
.byt 0, 7, 2, 2, 2
.byt 0, 4, 5, 2, 2

anim_states2
; Animatory state 4 (04-silence1B.png)
.byt 0, 0, 0, 0, 0
.byt 2, 2, 2, 9, 0
.byt 3, 2, 2, 2, 0
.byt 2, 2, 2, 2, 0
.byt 2, 10, 10, 2, 0
.byt 2, 2, 2, 2, 0
.byt 2, 2, 11, 12, 0
; Animatory state 5 (05-silence2B.png)
.byt 0, 0, 0, 0, 0
.byt 2, 2, 3, 13, 0
.byt 2, 2, 2, 2, 0
.byt 2, 2, 2, 2, 0
.byt 10, 10, 2, 14, 0
.byt 2, 2, 2, 2, 0
.byt 2, 3, 11, 15, 0
; Animatory state 6 (05-speak1B.png)
.byt 0, 0, 0, 0, 0
.byt 2, 2, 2, 9, 0
.byt 3, 2, 2, 2, 0
.byt 8, 8, 8, 8, 0
.byt 2, 10, 10, 2, 0
.byt 2, 2, 2, 2, 0
.byt 2, 2, 11, 12, 0
; Animatory state 7 (06-speak2B.png)
.byt 0, 0, 0, 0, 0
.byt 2, 2, 3, 13, 0
.byt 2, 2, 2, 2, 0
.byt 8, 8, 8, 8, 0
.byt 10, 10, 2, 14, 0
.byt 2, 2, 2, 2, 0
.byt 2, 3, 11, 15, 0
costume_tiles
; Tile graphic 1
.byt $8, $30, $0, $0, $0, $0, $3f, $3f
; Tile graphic 2
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 3
.byt $3f, $3f, $3f, $3f, $3f, $0, $0, $0
; Tile graphic 4
.byt $0, $0, $0, $20, $18, $6, $1, $0
; Tile graphic 5
.byt $0, $0, $0, $0, $0, $0, $20, $18
; Tile graphic 6
.byt $8, $30, $0, $0, $0, $0, $0, $0
; Tile graphic 7
.byt $0, $0, $3f, $3f, $3f, $0, $0, $0
; Tile graphic 8
.byt $0, $0, $0, $0, $3f, $3f, $3f, $3f
; Tile graphic 9
.byt $4, $3, $0, $0, $0, $0, $3f, $3f
; Tile graphic 10
.byt $0, $0, $0, $0, $0, $3f, $3f, $3f
; Tile graphic 11
.byt $0, $0, $0, $0, $0, $0, $1, $6
; Tile graphic 12
.byt $38, $38, $38, $3, $6, $18, $20, $0
; Tile graphic 13
.byt $4, $3, $0, $0, $0, $0, $0, $0
; Tile graphic 14
.byt $0, $0, $0, $0, $0, $3e, $3e, $3e
; Tile graphic 15
.byt $0, $0, $0, $3, $6, $18, $20, $0
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
res_end
.)


; Object resource 204: Zen panels
.(
	.byt RESOURCE_OBJECT|$80
	.word (res_end-res_start+4)
	.byt 204
res_start
	.byt 0|OBJ_FLAG_PROP
	.byt 11,1	;Size (cols, rows)
	.byt 255	;Initial room
	.byt 13,12	;Location (col, row)
	.byt ZPLANE_1	;Zplane
	.byt 16,15	;Walk position (col, row)
	.byt FACING_UP
	.byt 0	; Color of text
#ifdef ENGLISH	
	.asc "Controls",0	;Object's name
#endif
#ifdef SPANISH
	.asc "Controles",0	;Object's name
#endif	
res_end
.)




#include "..\scripts\liberatorzen.s"


