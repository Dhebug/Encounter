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
; Room: Toilet
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.(
	.byt RESOURCE_ROOM
	.word (res_end - res_start + 4)
	.byt 50
res_start
; No. columns, offset to tile map, offset to tiles
	.byt 38, <(column_data-res_start), >(column_data-res_start), <(tiles_start-res_start), >(tiles_start-res_start)
; No. zplanes and offsets to zplanes
	.byt 0
; No. Walkboxes and offsets to wb data and matrix
	.byt 4, <(wb_data-res_start), >(wb_data-res_start), <(wb_matrix-res_start), >(wb_matrix-res_start)
; Offset to palette
	.byt <(palette-res_start), >(palette-res_start)
; Entry and exit scripts
	.byt 200, 255
; Number of objects in the room and list of ids
	.byt 10,200,201,202,203,204,205,206,207,208,209
; Room name (null terminated)
	.asc "Toilet", 0
; Room tile map
column_data
	.byt 001, 001, 010, 011, 011, 011, 011, 011, 011, 011, 011, 011, 120, 144, 144, 144, 144
	.byt 001, 001, 010, 011, 011, 011, 011, 011, 011, 011, 011, 011, 120, 145, 145, 145, 145
	.byt 001, 001, 010, 011, 011, 011, 011, 011, 011, 011, 011, 011, 120, 144, 144, 144, 144
	.byt 001, 001, 010, 011, 011, 011, 011, 011, 011, 011, 011, 011, 120, 145, 145, 145, 145
	.byt 001, 001, 010, 011, 011, 011, 011, 011, 011, 011, 011, 011, 120, 144, 144, 144, 144
	.byt 001, 001, 010, 013, 017, 017, 017, 017, 017, 017, 017, 017, 017, 146, 145, 145, 145
	.byt 001, 001, 010, 014, 018, 032, 054, 054, 054, 083, 054, 054, 121, 144, 144, 144, 144
	.byt 001, 001, 010, 014, 019, 033, 055, 064, 075, 084, 093, 055, 122, 147, 145, 145, 145
	.byt 001, 001, 010, 014, 018, 032, 055, 065, 076, 085, 094, 055, 122, 148, 144, 144, 144
	.byt 001, 001, 010, 014, 019, 033, 055, 066, 077, 085, 055, 055, 122, 149, 145, 145, 145
	.byt 001, 001, 010, 014, 018, 032, 055, 067, 078, 086, 055, 108, 122, 150, 144, 144, 144
	.byt 001, 001, 010, 014, 019, 033, 055, 055, 055, 055, 055, 109, 122, 145, 145, 145, 145
	.byt 001, 001, 010, 014, 020, 034, 056, 068, 056, 056, 056, 068, 123, 151, 144, 144, 144
	.byt 001, 001, 010, 014, 021, 021, 021, 069, 021, 021, 021, 069, 021, 038, 145, 145, 145
	.byt 001, 001, 010, 014, 018, 035, 035, 035, 035, 035, 035, 035, 124, 144, 144, 144, 144
	.byt 001, 001, 010, 014, 019, 036, 036, 070, 079, 087, 095, 110, 125, 147, 145, 145, 145
	.byt 001, 001, 010, 014, 018, 035, 035, 032, 080, 088, 096, 111, 126, 148, 144, 144, 144
	.byt 001, 001, 010, 014, 019, 036, 036, 033, 081, 089, 097, 112, 127, 149, 145, 145, 145
	.byt 001, 001, 010, 014, 018, 035, 035, 071, 082, 090, 098, 113, 128, 150, 144, 144, 144
	.byt 001, 001, 010, 014, 019, 036, 036, 036, 036, 036, 099, 036, 129, 145, 145, 145, 145
	.byt 001, 001, 010, 014, 020, 037, 037, 037, 037, 037, 100, 037, 130, 152, 144, 144, 144
	.byt 001, 001, 010, 015, 021, 038, 054, 054, 054, 054, 101, 054, 054, 153, 145, 145, 145
	.byt 001, 001, 010, 011, 011, 039, 055, 072, 055, 055, 102, 055, 055, 154, 144, 144, 144
	.byt 001, 001, 012, 016, 016, 040, 055, 073, 055, 055, 055, 055, 131, 155, 145, 145, 145
	.byt 001, 002, 011, 011, 011, 041, 055, 055, 055, 091, 103, 055, 055, 156, 170, 144, 144
	.byt 001, 003, 011, 011, 011, 042, 057, 057, 057, 092, 057, 057, 057, 157, 171, 145, 145
	.byt 001, 004, 011, 011, 011, 011, 011, 011, 011, 011, 011, 011, 132, 158, 144, 144, 144
	.byt 001, 005, 011, 011, 011, 043, 011, 011, 011, 011, 011, 011, 133, 159, 145, 145, 145
	.byt 001, 006, 011, 011, 022, 044, 011, 011, 011, 011, 011, 011, 134, 160, 172, 144, 144
	.byt 001, 008, 011, 011, 023, 045, 011, 011, 011, 011, 011, 011, 135, 161, 173, 145, 145
	.byt 001, 009, 011, 011, 024, 046, 058, 074, 074, 074, 104, 114, 136, 162, 174, 144, 144
	.byt 001, 010, 011, 011, 025, 047, 059, 001, 001, 001, 105, 115, 137, 163, 175, 145, 145
	.byt 002, 011, 011, 011, 026, 048, 060, 001, 001, 001, 003, 116, 138, 164, 176, 144, 144
	.byt 003, 011, 011, 011, 027, 049, 061, 001, 001, 001, 106, 011, 139, 165, 177, 182, 145
	.byt 004, 011, 011, 011, 028, 050, 061, 001, 001, 001, 107, 117, 140, 166, 178, 183, 144
	.byt 005, 011, 011, 011, 029, 051, 062, 001, 001, 001, 001, 118, 141, 167, 179, 184, 145
	.byt 006, 011, 011, 011, 030, 052, 063, 001, 001, 001, 001, 119, 142, 168, 180, 185, 144
	.byt 007, 011, 011, 011, 031, 053, 063, 001, 001, 001, 001, 009, 143, 169, 181, 186, 145

; Room tile set
tiles_start
	.byt $C0, $C0, $C0, $C0, $C0, $C0, $C0, $C0	; tile #1
	.byt $C0, $C0, $C0, $C0, $C0, $C0, $C0, $40	; tile #2
	.byt $C0, $C0, $C0, $C0, $C0, $C0, $40, $7F	; tile #3
	.byt $C0, $C0, $C0, $C0, $C0, $40, $55, $7F	; tile #4
	.byt $C0, $C0, $C0, $C0, $40, $7F, $55, $7F	; tile #5
	.byt $C0, $C0, $C0, $40, $55, $7F, $55, $7F	; tile #6
	.byt $C0, $C1, $41, $7F, $55, $7F, $55, $7F	; tile #7
	.byt $C0, $C0, $40, $7F, $55, $7F, $55, $7F	; tile #8
	.byt $C0, $40, $55, $7F, $55, $7F, $55, $7F	; tile #9
	.byt $40, $7F, $55, $7F, $55, $7F, $55, $7F	; tile #10
	.byt $55, $7F, $55, $7F, $55, $7F, $55, $7F	; tile #11
	.byt $40, $77, $55, $77, $55, $77, $55, $77	; tile #12
	.byt $55, $7F, $55, $7F, $40, $4A, $55, $4A	; tile #13
	.byt $55, $7F, $55, $7F, $40, $6A, $55, $6A	; tile #14
	.byt $55, $7F, $55, $7F, $40, $6A, $54, $6A	; tile #15
	.byt $55, $77, $55, $77, $55, $77, $55, $77	; tile #16
	.byt $54, $4A, $54, $4A, $54, $4A, $54, $4A	; tile #17
	.byt $40, $7F, $7F, $40, $5D, $7F, $77, $7F	; tile #18
	.byt $40, $7F, $7F, $40, $77, $7F, $5D, $7F	; tile #19
	.byt $40, $7C, $72, $4E, $4E, $6E, $6E, $6E	; tile #20
	.byt $54, $6A, $54, $6A, $54, $6A, $54, $6A	; tile #21
	.byt $55, $7F, $55, $7F, $55, $7F, $55, $78	; tile #22
	.byt $55, $7F, $55, $7F, $55, $7F, $54, $40	; tile #23
	.byt $55, $7F, $55, $7F, $55, $7F, $40, $6A	; tile #24
	.byt $55, $7F, $55, $7F, $55, $60, $55, $6A	; tile #25
	.byt $55, $7F, $55, $7F, $50, $42, $55, $6A	; tile #26
	.byt $55, $7F, $55, $7E, $41, $6A, $55, $6A	; tile #27
	.byt $55, $7F, $55, $40, $55, $6A, $55, $6A	; tile #28
	.byt $55, $7F, $40, $4A, $55, $6A, $55, $6A	; tile #29
	.byt $55, $78, $45, $6A, $55, $6A, $55, $68	; tile #30
	.byt $54, $40, $55, $6A, $55, $6A, $55, $40	; tile #31
	.byt $5D, $7F, $77, $7F, $5D, $7F, $77, $40	; tile #32
	.byt $77, $7F, $5D, $7F, $77, $7F, $5D, $40	; tile #33
	.byt $4E, $6E, $6E, $6E, $4E, $6E, $6E, $40	; tile #34
	.byt $5D, $7F, $77, $7F, $5D, $7F, $77, $7F	; tile #35
	.byt $77, $7F, $5D, $7F, $77, $7F, $5D, $7F	; tile #36
	.byt $4E, $6E, $6E, $6E, $4E, $6E, $6E, $6E	; tile #37
	.byt $54, $6A, $54, $6A, $54, $6A, $54, $40	; tile #38
	.byt $55, $7F, $55, $7F, $55, $7F, $50, $4F	; tile #39
	.byt $55, $77, $55, $77, $55, $77, $40, $7F	; tile #40
	.byt $55, $7F, $55, $7F, $55, $70, $4F, $7F	; tile #41
	.byt $55, $7F, $55, $7F, $55, $43, $69, $6B	; tile #42
	.byt $54, $7E, $54, $7E, $54, $7F, $55, $7F	; tile #43
	.byt $45, $6A, $55, $6A, $40, $7F, $55, $7F	; tile #44
	.byt $55, $6A, $55, $40, $40, $7F, $55, $7F	; tile #45
	.byt $55, $6A, $54, $41, $40, $7F, $55, $7F	; tile #46
	.byt $55, $6A, $40, $7F, $40, $7F, $55, $7F	; tile #47
	.byt $55, $68, $FC, $7F, $40, $7F, $55, $7F	; tile #48
	.byt $55, $40, $C0, $78, $45, $7F, $55, $7F	; tile #49
	.byt $50, $47, $C0, $40, $55, $7F, $55, $7F	; tile #50
	.byt $40, $7F, $C1, $41, $55, $7F, $55, $7F	; tile #51
	.byt $F8, $7F, $40, $7F, $55, $7F, $55, $7F	; tile #52
	.byt $C0, $7F, $40, $7F, $55, $7F, $55, $7F	; tile #53
	.byt $5F, $5F, $5F, $5F, $5F, $5F, $5F, $5F	; tile #54
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F	; tile #55
	.byt $7C, $7C, $7C, $7C, $7C, $7C, $7C, $7C	; tile #56
	.byt $69, $6B, $69, $6B, $69, $6B, $69, $6B	; tile #57
	.byt $55, $7F, $55, $7F, $55, $7F, $54, $7E	; tile #58
	.byt $55, $7F, $55, $7F, $55, $7F, $40, $C0	; tile #59
	.byt $55, $7F, $55, $7F, $55, $7C, $43, $C0	; tile #60
	.byt $55, $7F, $55, $7F, $55, $40, $C0, $C0	; tile #61
	.byt $55, $7F, $55, $7F, $50, $F0, $C0, $C0	; tile #62
	.byt $55, $7F, $55, $7F, $40, $C0, $C0, $C0	; tile #63
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7E	; tile #64
	.byt $7F, $7E, $7F, $79, $7F, $67, $7F, $40	; tile #65
	.byt $7F, $5F, $7F, $67, $7F, $79, $7F, $40	; tile #66
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $7F, $5F	; tile #67
	.byt $7C, $7E, $70, $60, $60, $70, $7E, $7C	; tile #68
	.byt $54, $6A, $54, $4A, $44, $4A, $54, $6A	; tile #69
	.byt $77, $7F, $5D, $7F, $77, $7F, $5D, $78	; tile #70
	.byt $5D, $7F, $77, $7F, $5D, $7F, $77, $4F	; tile #71
	.byt $7F, $7F, $72, $65, $7F, $7E, $65, $7F	; tile #72
	.byt $7F, $7F, $67, $7F, $7F, $57, $7F, $7F	; tile #73
	.byt $54, $7E, $54, $7E, $54, $7E, $54, $7E	; tile #74
	.byt $7E, $7E, $7E, $7E, $7E, $7E, $7E, $7E	; tile #75
	.byt $C0, $C3, $C0, $C1, $C0, $CF, $C0, $C0	; tile #76
	.byt $C0, $F0, $C0, $E0, $C0, $FC, $C0, $C0	; tile #77
	.byt $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F	; tile #78
	.byt $77, $68, $F0, $E0, $E0, $E0, $E0, $E0	; tile #79
	.byt $C0, $40, $C0, $C0, $C0, $C1, $C6, $D8	; tile #80
	.byt $C0, $40, $C0, $C0, $C0, $C0, $C0, $D8	; tile #81
	.byt $75, $4B, $C4, $C2, $C2, $C2, $C2, $C2	; tile #82
	.byt $5F, $5D, $5A, $5D, $5F, $58, $5F, $5F	; tile #83
	.byt $7E, $7F, $7F, $7F, $7F, $5F, $6F, $7F	; tile #84
	.byt $40, $7F, $7F, $7F, $7F, $7F, $7F, $7F	; tile #85
	.byt $4F, $7F, $7F, $7F, $7F, $7F, $7F, $7F	; tile #86
	.byt $E0, $E0, $F0, $D0, $D0, $D0, $F0, $D0	; tile #87
	.byt $C0, $C6, $C8, $C0, $C0, $C0, $C0, $C0	; tile #88
	.byt $E0, $C0, $C0, $C0, $C0, $C0, $C0, $C0	; tile #89
	.byt $C2, $C2, $C4, $C4, $C6, $C4, $C4, $C4	; tile #90
	.byt $7F, $7F, $7F, $7D, $7A, $7D, $7F, $67	; tile #91
	.byt $69, $6B, $69, $6B, $69, $63, $61, $63	; tile #92
	.byt $7F, $7F, $7F, $7E, $7B, $7F, $7E, $7D	; tile #93
	.byt $7F, $7F, $6B, $5F, $7B, $67, $5F, $7F	; tile #94
	.byt $C8, $78, $5D, $7F, $74, $73, $4E, $5D	; tile #95
	.byt $C0, $E0, $D0, $40, $7F, $60, $E0, $C0	; tile #96
	.byt $C0, $C1, $C2, $40, $7F, $41, $C1, $C0	; tile #97
	.byt $74, $4E, $76, $7F, $4D, $73, $5D, $6E	; tile #98
	.byt $40, $7F, $40, $E1, $E1, $E1, $E1, $61	; tile #99
	.byt $4E, $4E, $4E, $6E, $4E, $6E, $6E, $6E	; tile #100
	.byt $5F, $5F, $59, $5F, $5B, $54, $5F, $5F	; tile #101
	.byt $7F, $7F, $7F, $4F, $77, $6F, $57, $7F	; tile #102
	.byt $59, $7F, $7F, $7F, $7F, $7F, $7F, $7F	; tile #103
	.byt $54, $7E, $54, $7E, $54, $7E, $55, $7F	; tile #104
	.byt $C0, $C0, $C0, $C0, $C0, $F0, $50, $7F	; tile #105
	.byt $C0, $C0, $C0, $C0, $C0, $C0, $E0, $60	; tile #106
	.byt $C0, $C0, $C0, $C0, $C0, $C0, $C0, $41	; tile #107
	.byt $7F, $7F, $7F, $69, $7F, $71, $7F, $7F	; tile #108
	.byt $7F, $7F, $7F, $5F, $7F, $5F, $7F, $7F	; tile #109
	.byt $5D, $5E, $4F, $57, $68, $D0, $51, $7A	; tile #110
	.byt $C0, $E0, $60, $7F, $7F, $40, $C0, $40	; tile #111
	.byt $C0, $C1, $41, $7F, $7F, $40, $C0, $40	; tile #112
	.byt $6E, $5E, $7C, $7A, $45, $7D, $63, $57	; tile #113
	.byt $55, $7B, $40, $E0, $E0, $40, $51, $7F	; tile #114
	.byt $55, $7F, $40, $C0, $C0, $40, $55, $7F	; tile #115
	.byt $55, $7F, $55, $6F, $65, $5F, $55, $7F	; tile #116
	.byt $54, $7F, $55, $7F, $55, $7F, $54, $7B	; tile #117
	.byt $40, $7F, $55, $7F, $55, $5F, $40, $C0	; tile #118
	.byt $43, $7C, $55, $7F, $55, $7F, $41, $C2	; tile #119
	.byt $55, $7F, $55, $7F, $55, $7F, $55, $40	; tile #120
	.byt $5F, $5F, $5F, $5F, $5F, $5F, $5F, $40	; tile #121
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $7F, $40	; tile #122
	.byt $7C, $7C, $7C, $7C, $7C, $7C, $7C, $40	; tile #123
	.byt $5D, $7F, $77, $7F, $5D, $7F, $40, $5D	; tile #124
	.byt $75, $7E, $5D, $7F, $77, $7F, $40, $76	; tile #125
	.byt $C0, $C0, $E8, $E4, $E2, $E2, $C2, $C2	; tile #126
	.byt $C0, $C0, $C1, $C1, $C1, $C1, $C0, $C0	; tile #127
	.byt $6D, $5F, $77, $7F, $5D, $7F, $40, $5D	; tile #128
	.byt $77, $7F, $5D, $7F, $77, $7F, $40, $77	; tile #129
	.byt $4E, $6E, $6E, $6E, $4E, $6E, $4E, $4E	; tile #130
	.byt $77, $7F, $41, $77, $6B, $5D, $7F, $7F	; tile #131
	.byt $50, $73, $54, $72, $55, $72, $55, $72	; tile #132
	.byt $40, $7F, $47, $68, $55, $6A, $55, $6A	; tile #133
	.byt $40, $7F, $7F, $4F, $50, $6A, $55, $6A	; tile #134
	.byt $40, $7F, $70, $60, $5F, $60, $55, $6A	; tile #135
	.byt $45, $78, $47, $40, $40, $7F, $40, $6A	; tile #136
	.byt $55, $47, $78, $47, $41, $43, $7F, $41	; tile #137
	.byt $55, $7F, $41, $7C, $7F, $7F, $7F, $7F	; tile #138
	.byt $55, $7F, $55, $43, $7C, $7F, $78, $70	; tile #139
	.byt $53, $78, $54, $7F, $41, $7C, $43, $40	; tile #140
	.byt $C0, $40, $45, $7F, $55, $41, $7E, $41	; tile #141
	.byt $C2, $43, $55, $7F, $55, $7F, $41, $7E	; tile #142
	.byt $55, $7F, $55, $7F, $55, $7F, $55, $41	; tile #143
	.byt $7F, $77, $7F, $5D, $7F, $77, $7F, $5D	; tile #144
	.byt $7F, $5D, $7F, $77, $7F, $5D, $7F, $77	; tile #145
	.byt $54, $4A, $54, $4A, $54, $4A, $54, $40	; tile #146
	.byt $7E, $5C, $7E, $77, $7F, $5D, $7F, $77	; tile #147
	.byt $C2, $C2, $C0, $F0, $70, $77, $7F, $5D	; tile #148
	.byt $C0, $C0, $C0, $C3, $43, $5D, $7F, $77	; tile #149
	.byt $5F, $57, $5F, $5D, $7F, $77, $7F, $5D	; tile #150
	.byt $6C, $74, $74, $58, $78, $74, $7C, $5C	; tile #151
	.byt $6E, $76, $76, $5A, $7A, $74, $7C, $5C	; tile #152
	.byt $4F, $71, $7E, $7E, $7E, $7E, $7E, $40	; tile #153
	.byt $7F, $7F, $4F, $51, $7E, $77, $7F, $5D	; tile #154
	.byt $7F, $7F, $7F, $7F, $4F, $51, $7E, $77	; tile #155
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $4F, $51	; tile #156
	.byt $69, $6B, $69, $6B, $68, $69, $6B, $6B	; tile #157
	.byt $55, $78, $55, $7F, $45, $70, $7F, $5D	; tile #158
	.byt $55, $4A, $50, $7F, $55, $7F, $41, $74	; tile #159
	.byt $55, $6A, $55, $42, $54, $7F, $55, $4F	; tile #160
	.byt $55, $6A, $55, $6A, $45, $70, $55, $7F	; tile #161
	.byt $55, $6A, $55, $6A, $55, $4A, $41, $7E	; tile #162
	.byt $54, $6A, $55, $6A, $55, $6A, $55, $42	; tile #163
	.byt $43, $68, $55, $6A, $55, $6A, $55, $6A	; tile #164
	.byt $7C, $47, $50, $6A, $55, $6A, $55, $6A	; tile #165
	.byt $40, $78, $4F, $60, $55, $6A, $55, $6A	; tile #166
	.byt $40, $40, $78, $4F, $50, $6A, $55, $6A	; tile #167
	.byt $5F, $4F, $5F, $7F, $5F, $60, $55, $6A	; tile #168
	.byt $7E, $7F, $7E, $7C, $7E, $7F, $41, $6A	; tile #169
	.byt $7E, $77, $7F, $5D, $7F, $77, $7F, $5D	; tile #170
	.byt $4B, $51, $7F, $77, $7F, $5D, $7F, $77	; tile #171
	.byt $70, $77, $7F, $5D, $7F, $77, $7F, $5D	; tile #172
	.byt $55, $43, $7C, $77, $7F, $5D, $7F, $77	; tile #173
	.byt $55, $7F, $45, $50, $7F, $77, $7F, $5D	; tile #174
	.byt $50, $7F, $55, $7F, $41, $5C, $7F, $77	; tile #175
	.byt $45, $70, $55, $7F, $55, $4F, $70, $5D	; tile #176
	.byt $55, $6A, $41, $7C, $55, $7F, $55, $43	; tile #177
	.byt $55, $6A, $55, $42, $50, $7F, $55, $7F	; tile #178
	.byt $55, $6A, $55, $6A, $55, $60, $54, $7F	; tile #179
	.byt $55, $6A, $55, $6A, $55, $6A, $41, $7C	; tile #180
	.byt $55, $6A, $55, $6A, $55, $6A, $55, $4A	; tile #181
	.byt $7C, $5D, $7F, $77, $7F, $5D, $7F, $77	; tile #182
	.byt $45, $70, $7F, $5D, $7F, $77, $7F, $5D	; tile #183
	.byt $55, $7F, $41, $74, $7F, $5D, $7F, $77	; tile #184
	.byt $55, $7F, $55, $4F, $70, $77, $7F, $5D	; tile #185
	.byt $50, $7F, $55, $7F, $55, $43, $7C, $77	; tile #186
; Walkbox Data
wb_data
	.byt 000, 017, 014, 016, $01
	.byt 018, 027, 015, 016, $01
	.byt 028, 031, 016, 016, $01
	.byt 000, 000, 013, 013, $01
; Walk matrix
wb_matrix
	.byt 0, 1, 1, 3
	.byt 0, 1, 2, 0
	.byt 1, 1, 2, 1
	.byt 0, 0, 0, 3
; Palette Information is stored as one column only for now...
; Palette
palette
.byt 2, 6, 2, 6, 2, 6, 2, 6, 2, 6, 2, 6, 2, 6, 2, 6
.byt 2, 6, 2, 6, 2, 6, 2, 6, 2, 6, 2, 6, 2, 6, 2, 6
.byt 2, 6, 2, 6, 2, 6, 2, 6, 2, 6, 2, 6, 2, 6, 2, 6
.byt 2, 6, 2, 6, 2, 6, 2, 6, 2, 6, 2, 6, 2, 6, 2, 6
.byt 2, 6, 2, 6, 2, 6, 2, 6, 2, 6, 2, 6, 2, 6, 2, 6
.byt 2, 6, 2, 6, 2, 6, 2, 6, 2, 6, 2, 6, 2, 6, 2, 6
.byt 2, 6, 2, 6, 2, 6, 2, 6, 2, 6, 2, 6, 2, 6, 2, 6
.byt 2, 6, 2, 6, 2, 6, 2, 6, 2, 6, 2, 6, 2, 6, 2, 6
.byt 2, 6, 2, 6, 2, 6, 2, 6


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

; Writings and drawings
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 201
res_start
	.byt OBJ_FLAG_PROP	; If OBJ_FLAG_PROP skip all costume data
	.byt 2,1		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 7,10		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt 12,15		; Walk position (col, row)
	.byt FACING_LEFT	; Facing direction for interaction
	.byt 00			; Color of text
#ifdef ENGLISH
	.asc "Scribbles",0
#endif
#ifdef SPANISH
	.asc "Garabatos",0
#endif
res_end	
.)


.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 202
res_start
	.byt OBJ_FLAG_PROP	; If OBJ_FLAG_PROP skip all costume data
	.byt 1,1		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 10,11		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt 12,15		; Walk position (col, row)
	.byt FACING_LEFT	; Facing direction for interaction
	.byt 00			; Color of text
#ifdef ENGLISH
	.asc "Scribbles",0
#endif
#ifdef SPANISH
	.asc "Garabatos",0
#endif
res_end	
.)


.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 203
res_start
	.byt OBJ_FLAG_PROP	; If OBJ_FLAG_PROP skip all costume data
	.byt 2,2		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 16,9		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt 12,14		; Walk position (col, row)
	.byt FACING_RIGHT	; Facing direction for interaction
	.byt 00			; Color of text
#ifdef ENGLISH
	.asc "Scribbles",0
#endif
#ifdef SPANISH
	.asc "Garabatos",0
#endif
res_end	
.)


.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 204
res_start
	.byt OBJ_FLAG_PROP	; If OBJ_FLAG_PROP skip all costume data
	.byt 2,1		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 22,7		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt 17,15		; Walk position (col, row)
	.byt FACING_RIGHT	; Facing direction for interaction
	.byt 00			; Color of text
#ifdef ENGLISH
	.asc "Scribbles",0
#endif
#ifdef SPANISH
	.asc "Garabatos",0
#endif
res_end	
.)

.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 205
res_start
	.byt OBJ_FLAG_PROP	; If OBJ_FLAG_PROP skip all costume data
	.byt 2,1		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 21,10		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt 17,15		; Walk position (col, row)
	.byt FACING_RIGHT	; Facing direction for interaction
	.byt 00			; Color of text
#ifdef ENGLISH
	.asc "Scribbles",0
#endif
#ifdef SPANISH
	.asc "Garabatos",0
#endif
res_end	
.)

; Man
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 206
res_start
	.byt OBJ_FLAG_PROP	; If OBJ_FLAG_PROP skip all costume data
	.byt 1,1		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 23,12		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt 17,15		; Walk position (col, row)
	.byt FACING_RIGHT	; Facing direction for interaction
	.byt 00			; Color of text
#ifdef ENGLISH
	.asc "Scribbles",0
#endif
#ifdef SPANISH
	.asc "Garabatos",0
#endif
res_end	
.)

; Out of order sign
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 207
res_start
	.byt OBJ_FLAG_PROP	; If OBJ_FLAG_PROP skip all costume data
	.byt 2,1		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 8,8		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt 3,14		; Walk position (col, row)
	.byt FACING_RIGHT	; Facing direction for interaction
	.byt 00			; Color of text
#ifdef ENGLISH
	.asc "Sign",0
#endif
#ifdef SPANISH
	.asc "Cartel",0
#endif
res_end	
.)

; Toilet
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 208
res_start
	.byt OBJ_FLAG_PROP	; If OBJ_FLAG_PROP skip all costume data
	.byt 4,4		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 15,13		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt 12,14		; Walk position (col, row)
	.byt FACING_RIGHT	; Facing direction for interaction
	.byt 00			; Color of text
#ifdef ENGLISH
	.asc "Toilet",0
#endif
#ifdef SPANISH
	.asc "Retrete",0
#endif
res_end	
.)

; Basin
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 209
res_start
	.byt OBJ_FLAG_PROP	; If OBJ_FLAG_PROP skip all costume data
	.byt 2,2		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 34,13		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt 27,15		; Walk position (col, row)
	.byt FACING_RIGHT	; Facing direction for interaction
	.byt 00			; Color of text
#ifdef ENGLISH
	.asc "Washbasin",0
#endif
#ifdef SPANISH
	.asc "Lavabo",0
#endif
res_end	
.)


#include "..\scripts\toilet.s"


