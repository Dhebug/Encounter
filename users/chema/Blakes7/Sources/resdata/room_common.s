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
; Room: Common
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.(
	.byt RESOURCE_ROOM
	.word (res_end - res_start + 4)
	.byt 51
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
	.byt 5,200,202,203,204,205 /*,201*/
; Room name (null terminated)
	.asc "Common", 0
; Room tile map
column_data
	.byt 001, 010, 010, 010, 010, 010, 010, 010, 010, 010, 010, 010, 010, 010, 010, 010, 181
	.byt 002, 010, 010, 010, 010, 010, 010, 010, 010, 010, 010, 010, 103, 116, 012, 166, 182
	.byt 003, 010, 010, 010, 010, 010, 010, 010, 010, 010, 010, 086, 104, 117, 144, 167, 155
	.byt 004, 010, 010, 010, 010, 010, 010, 010, 010, 010, 010, 087, 105, 118, 144, 168, 155
	.byt 005, 011, 011, 011, 011, 011, 011, 011, 011, 011, 011, 088, 106, 119, 145, 169, 155
	.byt 005, 010, 010, 010, 010, 010, 010, 010, 010, 010, 010, 010, 107, 120, 146, 170, 155
	.byt 005, 010, 013, 016, 016, 016, 053, 010, 010, 010, 010, 010, 010, 121, 147, 171, 155
	.byt 005, 010, 014, 017, 029, 041, 054, 010, 010, 010, 010, 010, 010, 122, 148, 172, 155
	.byt 005, 010, 014, 018, 030, 042, 054, 010, 010, 010, 010, 010, 010, 123, 149, 173, 155
	.byt 005, 010, 014, 019, 031, 043, 054, 010, 010, 010, 010, 010, 010, 124, 150, 173, 155
	.byt 005, 010, 014, 020, 032, 044, 054, 010, 010, 010, 010, 010, 010, 125, 151, 174, 155
	.byt 005, 010, 014, 000, 033, 045, 054, 010, 010, 010, 010, 010, 012, 126, 152, 155, 155
	.byt 005, 010, 014, 000, 034, 046, 054, 010, 010, 010, 010, 089, 108, 127, 153, 155, 155
	.byt 005, 010, 014, 000, 028, 028, 054, 010, 010, 010, 080, 090, 109, 128, 154, 155, 155
	.byt 005, 010, 015, 021, 021, 021, 055, 010, 010, 010, 081, 091, 110, 129, 155, 155, 155
	.byt 005, 010, 013, 016, 016, 016, 053, 010, 010, 010, 082, 092, 111, 130, 155, 155, 155
	.byt 005, 010, 014, 022, 035, 047, 054, 010, 010, 010, 010, 093, 111, 131, 155, 155, 155
	.byt 005, 010, 014, 023, 036, 048, 054, 010, 010, 010, 010, 094, 111, 130, 155, 155, 155
	.byt 005, 010, 014, 024, 037, 049, 054, 010, 010, 010, 010, 095, 111, 131, 155, 155, 155
	.byt 005, 010, 014, 025, 038, 050, 054, 010, 010, 010, 010, 091, 111, 130, 155, 155, 155
	.byt 005, 010, 014, 026, 039, 051, 054, 010, 010, 069, 083, 096, 111, 131, 155, 155, 155
	.byt 005, 010, 014, 027, 040, 052, 054, 010, 010, 070, 084, 097, 111, 132, 156, 155, 155
	.byt 005, 010, 014, 028, 028, 028, 054, 010, 010, 071, 085, 098, 108, 127, 157, 155, 155
	.byt 005, 010, 015, 021, 021, 021, 055, 010, 010, 010, 010, 099, 109, 128, 153, 155, 155
	.byt 005, 010, 010, 010, 010, 010, 010, 056, 012, 072, 010, 010, 011, 133, 158, 155, 155
	.byt 005, 010, 010, 010, 010, 010, 010, 057, 063, 073, 010, 010, 010, 134, 155, 155, 155
	.byt 005, 010, 010, 010, 010, 010, 010, 058, 064, 074, 010, 010, 010, 134, 155, 155, 155
	.byt 005, 010, 010, 010, 010, 010, 010, 059, 065, 075, 010, 010, 010, 135, 159, 175, 155
	.byt 005, 010, 010, 010, 010, 010, 010, 060, 066, 076, 010, 010, 010, 014, 160, 173, 155
	.byt 005, 010, 010, 010, 010, 010, 010, 061, 067, 077, 010, 010, 010, 136, 160, 173, 155
	.byt 005, 010, 010, 010, 010, 010, 010, 062, 068, 078, 010, 010, 010, 137, 161, 172, 155
	.byt 005, 010, 010, 010, 010, 010, 010, 058, 011, 079, 010, 010, 010, 138, 162, 176, 155
	.byt 005, 010, 010, 010, 010, 010, 010, 010, 010, 010, 010, 010, 112, 139, 163, 177, 155
	.byt 005, 012, 012, 012, 012, 012, 012, 012, 012, 012, 012, 100, 000, 140, 164, 178, 155
	.byt 006, 010, 010, 010, 010, 010, 010, 010, 010, 010, 010, 101, 113, 141, 165, 168, 155
	.byt 007, 010, 010, 010, 010, 010, 010, 010, 010, 010, 010, 102, 114, 142, 165, 179, 155
	.byt 008, 010, 010, 010, 010, 010, 010, 010, 010, 010, 010, 010, 115, 143, 011, 180, 155
	.byt 009, 010, 010, 010, 010, 010, 010, 010, 010, 010, 010, 010, 010, 010, 010, 010, 183

; Room tile set
tiles_start
	.byt $47, $78, $55, $7F, $55, $7F, $55, $7F	; tile #1
	.byt $7F, $7F, $47, $78, $55, $7F, $55, $7F	; tile #2
	.byt $7F, $7F, $7F, $7F, $47, $78, $55, $7F	; tile #3
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $47, $78	; tile #4
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $7F, $40	; tile #5
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $78, $47	; tile #6
	.byt $7F, $7F, $7F, $7F, $78, $47, $55, $7F	; tile #7
	.byt $7F, $7F, $78, $47, $55, $7F, $55, $7F	; tile #8
	.byt $78, $47, $55, $7F, $55, $7F, $55, $7F	; tile #9
	.byt $55, $7F, $55, $7F, $55, $7F, $55, $7F	; tile #10
	.byt $55, $5F, $55, $5F, $55, $5F, $55, $5F	; tile #11
	.byt $54, $7E, $54, $7E, $54, $7E, $54, $7E	; tile #12
	.byt $55, $7F, $55, $7F, $55, $7F, $54, $7D	; tile #13
	.byt $55, $7F, $55, $7F, $55, $7F, $40, $7F	; tile #14
	.byt $55, $7F, $55, $7F, $55, $7F, $45, $6F	; tile #15
	.byt $55, $7D, $55, $7D, $55, $7D, $55, $7D	; tile #16
	.byt $40, $50, $4C, $42, $4C, $50, $40, $40	; tile #17
	.byt $40, $40, $40, $40, $4C, $41, $40, $40	; tile #18
	.byt $40, $40, $40, $40, $47, $78, $40, $40	; tile #19
	.byt $40, $40, $40, $40, $40, $78, $40, $40	; tile #20
	.byt $65, $6F, $65, $6F, $65, $6F, $65, $6F	; tile #21
	.byt $40, $40, $40, $01, $05, $03, $07, $40	; tile #22
	.byt $40, $40, $40, $4F, $43, $40, $5D, $40	; tile #23
	.byt $40, $40, $40, $4F, $60, $5F, $4E, $40	; tile #24
	.byt $40, $40, $40, $4E, $4F, $70, $76, $40	; tile #25
	.byt $40, $40, $40, $5C, $6E, $40, $4B, $40	; tile #26
	.byt $40, $40, $40, $58, $40, $7C, $5E, $40	; tile #27
	.byt $03, $06, $03, $06, $03, $06, $03, $06	; tile #28
	.byt $40, $40, $40, $01, $05, $02, $01, $07	; tile #29
	.byt $44, $44, $44, $44, $44, $47, $44, $44	; tile #30
	.byt $40, $40, $40, $4F, $40, $60, $40, $40	; tile #31
	.byt $40, $40, $40, $68, $40, $47, $40, $40	; tile #32
	.byt $40, $40, $40, $4F, $40, $7E, $40, $40	; tile #33
	.byt $40, $40, $40, $7C, $40, $40, $40, $40	; tile #34
	.byt $40, $40, $40, $40, $40, $01, $40, $02	; tile #35
	.byt $40, $40, $40, $40, $40, $50, $50, $50	; tile #36
	.byt $40, $40, $40, $40, $40, $40, $50, $50	; tile #37
	.byt $40, $40, $40, $40, $40, $40, $40, $44	; tile #38
	.byt $40, $40, $40, $40, $40, $42, $42, $52	; tile #39
	.byt $40, $40, $40, $40, $40, $40, $40, $48	; tile #40
	.byt $06, $02, $05, $07, $40, $40, $40, $40	; tile #41
	.byt $44, $44, $44, $47, $40, $40, $40, $40	; tile #42
	.byt $40, $40, $41, $72, $40, $40, $40, $40	; tile #43
	.byt $40, $40, $78, $4B, $40, $40, $40, $40	; tile #44
	.byt $40, $40, $40, $67, $70, $40, $40, $40	; tile #45
	.byt $40, $50, $40, $70, $42, $40, $40, $40	; tile #46
	.byt $02, $40, $06, $40, $05, $40, $40, $40	; tile #47
	.byt $50, $54, $54, $54, $54, $40, $40, $40	; tile #48
	.byt $50, $52, $52, $52, $52, $40, $40, $40	; tile #49
	.byt $44, $54, $54, $54, $54, $40, $40, $40	; tile #50
	.byt $52, $52, $52, $52, $52, $40, $40, $40	; tile #51
	.byt $68, $68, $68, $68, $68, $40, $40, $40	; tile #52
	.byt $55, $7C, $55, $7F, $55, $7F, $55, $7F	; tile #53
	.byt $7F, $40, $55, $7F, $55, $7F, $55, $7F	; tile #54
	.byt $65, $4F, $55, $7F, $55, $7F, $55, $7F	; tile #55
	.byt $55, $7F, $55, $7E, $54, $7E, $54, $7E	; tile #56
	.byt $55, $7F, $55, $40, $73, $73, $73, $70	; tile #57
	.byt $55, $7F, $55, $5F, $55, $5F, $55, $5F	; tile #58
	.byt $55, $7F, $55, $78, $53, $7B, $53, $78	; tile #59
	.byt $55, $7F, $55, $40, $4E, $4E, $40, $FF	; tile #60
	.byt $55, $7F, $55, $40, $5F, $40, $5F, $40	; tile #61
	.byt $55, $7F, $55, $40, $F0, $4F, $F0, $FF	; tile #62
	.byt $FC, $73, $CC, $73, $CC, $73, $CC, $73	; tile #63
	.byt $55, $5F, $54, $40, $F3, $4C, $F3, $40	; tile #64
	.byt $53, $7B, $43, $73, $43, $73, $73, $73	; tile #65
	.byt $FF, $FF, $FF, $F1, $F1, $F1, $F1, $F1	; tile #66
	.byt $E0, $40, $E0, $5F, $E0, $5F, $E0, $40	; tile #67
	.byt $4F, $F0, $4F, $F0, $4F, $F0, $4F, $40	; tile #68
	.byt $55, $7C, $50, $6F, $5F, $5D, $5F, $50	; tile #69
	.byt $55, $40, $40, $7F, $7F, $54, $7F, $40	; tile #70
	.byt $55, $4F, $41, $7D, $7E, $5E, $7E, $42	; tile #71
	.byt $54, $7E, $54, $7E, $54, $7F, $55, $7F	; tile #72
	.byt $40, $73, $73, $40, $C0, $FF, $40, $79	; tile #73
	.byt $4C, $4C, $4C, $40, $C0, $FF, $40, $7F	; tile #74
	.byt $CC, $73, $CC, $40, $C0, $FF, $40, $7F	; tile #75
	.byt $F1, $4E, $F1, $40, $C0, $FF, $40, $7F	; tile #76
	.byt $5F, $40, $5F, $40, $C0, $FF, $40, $7F	; tile #77
	.byt $F0, $4F, $F0, $40, $C1, $FF, $41, $67	; tile #78
	.byt $55, $5F, $55, $5F, $55, $7F, $55, $7F	; tile #79
	.byt $55, $7F, $55, $7F, $55, $7C, $50, $79	; tile #80
	.byt $55, $7F, $54, $73, $40, $4F, $55, $7F	; tile #81
	.byt $55, $7F, $45, $73, $45, $7F, $55, $7F	; tile #82
	.byt $56, $56, $57, $57, $57, $57, $57, $57	; tile #83
	.byt $D0, $77, $E1, $61, $70, $7F, $7F, $7F	; tile #84
	.byt $5A, $5A, $7A, $7A, $5A, $7A, $7A, $7A	; tile #85
	.byt $55, $7F, $55, $7F, $55, $7F, $50, $40	; tile #86
	.byt $55, $7F, $55, $7F, $55, $70, $40, $47	; tile #87
	.byt $55, $5F, $55, $5F, $55, $4F, $51, $7D	; tile #88
	.byt $55, $7F, $55, $7F, $55, $70, $40, $40	; tile #89
	.byt $51, $79, $51, $71, $51, $40, $40, $40	; tile #90
	.byt $55, $7F, $55, $7F, $55, $40, $40, $40	; tile #91
	.byt $54, $7E, $54, $7E, $54, $42, $40, $41	; tile #92
	.byt $40, $7F, $D3, $7C, $D3, $7F, $40, $7F	; tile #93
	.byt $40, $7F, $FA, $55, $F8, $7D, $40, $7F	; tile #94
	.byt $55, $5F, $55, $5F, $55, $50, $50, $60	; tile #95
	.byt $57, $57, $57, $50, $5F, $5F, $40, $40	; tile #96
	.byt $7F, $7F, $7F, $40, $7F, $7F, $40, $40	; tile #97
	.byt $7A, $7A, $7A, $42, $7E, $7E, $40, $40	; tile #98
	.byt $55, $7F, $55, $7F, $55, $43, $41, $40	; tile #99
	.byt $54, $7E, $54, $7E, $55, $7C, $52, $6F	; tile #100
	.byt $55, $7F, $55, $7F, $55, $43, $40, $78	; tile #101
	.byt $55, $7F, $55, $7F, $55, $7F, $45, $40	; tile #102
	.byt $54, $7C, $54, $7C, $54, $7E, $54, $7E	; tile #103
	.byt $41, $47, $44, $44, $46, $42, $42, $41	; tile #104
	.byt $7E, $60, $40, $40, $40, $40, $40, $40	; tile #105
	.byt $41, $40, $40, $40, $40, $40, $40, $40	; tile #106
	.byt $55, $7F, $55, $7F, $55, $5F, $55, $4F	; tile #107
	.byt $40, $FF, $40, $FF, $40, $E0, $50, $EE	; tile #108
	.byt $40, $FF, $40, $FF, $40, $C1, $42, $DD	; tile #109
	.byt $40, $FF, $40, $FF, $40, $40, $40, $4A	; tile #110
	.byt $40, $FF, $40, $FF, $40, $40, $40, $6A	; tile #111
	.byt $55, $7F, $55, $7F, $54, $7E, $54, $7C	; tile #112
	.byt $5F, $41, $40, $40, $40, $40, $40, $40	; tile #113
	.byt $60, $78, $48, $48, $58, $50, $50, $60	; tile #114
	.byt $45, $4F, $45, $4F, $45, $5F, $55, $5F	; tile #115
	.byt $54, $7F, $55, $7C, $51, $78, $50, $78	; tile #116
	.byt $41, $41, $40, $60, $7F, $40, $40, $40	; tile #117
	.byt $40, $60, $60, $60, $7F, $40, $40, $40	; tile #118
	.byt $40, $40, $40, $40, $7F, $50, $50, $58	; tile #119
	.byt $45, $48, $48, $4C, $64, $54, $53, $48	; tile #120
	.byt $55, $40, $40, $40, $40, $40, $7F, $4E	; tile #121
	.byt $50, $44, $48, $48, $50, $50, $70, $50	; tile #122
	.byt $55, $4F, $55, $5F, $50, $7B, $42, $5B	; tile #123
	.byt $55, $7F, $55, $7F, $43, $71, $58, $71	; tile #124
	.byt $55, $7F, $55, $7F, $55, $7F, $47, $70	; tile #125
	.byt $54, $7E, $54, $7E, $54, $7E, $54, $40	; tile #126
	.byt $50, $EF, $50, $EF, $50, $EF, $5F, $FF	; tile #127
	.byt $42, $FD, $42, $FD, $42, $FD, $7E, $FF	; tile #128
	.byt $40, $4A, $40, $4A, $40, $5F, $5D, $40	; tile #129
	.byt $40, $6A, $40, $6A, $40, $7F, $77, $40	; tile #130
	.byt $40, $6A, $40, $6A, $40, $7F, $5D, $40	; tile #131
	.byt $40, $6A, $40, $6A, $40, $7E, $76, $40	; tile #132
	.byt $55, $5F, $55, $5F, $55, $5F, $55, $40	; tile #133
	.byt $55, $7F, $55, $7F, $55, $7F, $55, $40	; tile #134
	.byt $55, $7F, $55, $7F, $55, $7F, $54, $41	; tile #135
	.byt $54, $7C, $54, $7E, $55, $7F, $40, $7F	; tile #136
	.byt $45, $48, $44, $44, $42, $42, $43, $42	; tile #137
	.byt $55, $40, $40, $40, $40, $40, $7F, $5C	; tile #138
	.byt $50, $44, $44, $4C, $49, $4A, $72, $44	; tile #139
	.byt $40, $40, $40, $40, $7F, $42, $42, $46	; tile #140
	.byt $40, $41, $41, $41, $7F, $40, $40, $40	; tile #141
	.byt $60, $60, $40, $41, $7F, $40, $40, $40	; tile #142
	.byt $55, $7F, $55, $4F, $65, $47, $45, $47	; tile #143
	.byt $6A, $40, $40, $40, $40, $40, $40, $40	; tile #144
	.byt $6C, $44, $44, $44, $44, $44, $44, $44	; tile #145
	.byt $49, $4E, $48, $4B, $4C, $40, $40, $40	; tile #146
	.byt $70, $43, $5C, $60, $40, $40, $40, $40	; tile #147
	.byt $50, $60, $40, $40, $40, $40, $40, $40	; tile #148
	.byt $50, $7F, $40, $40, $7F, $7F, $7F, $7F	; tile #149
	.byt $43, $7F, $40, $40, $7F, $7F, $7F, $7F	; tile #150
	.byt $79, $7C, $41, $72, $75, $72, $75, $72	; tile #151
	.byt $54, $6A, $54, $6A, $55, $6A, $55, $6A	; tile #152
	.byt $40, $FF, $40, $FF, $40, $6A, $55, $6A	; tile #153
	.byt $40, $40, $50, $40, $55, $6A, $55, $6A	; tile #154
	.byt $55, $6A, $55, $6A, $55, $6A, $55, $6A	; tile #155
	.byt $54, $6A, $55, $6A, $55, $6A, $55, $6A	; tile #156
	.byt $40, $62, $40, $6A, $54, $6A, $55, $6A	; tile #157
	.byt $55, $4A, $55, $4A, $55, $6A, $55, $6A	; tile #158
	.byt $53, $67, $50, $6B, $53, $6B, $53, $6B	; tile #159
	.byt $7F, $7F, $40, $40, $7F, $7F, $7F, $7F	; tile #160
	.byt $42, $41, $40, $40, $40, $40, $40, $40	; tile #161
	.byt $43, $70, $4E, $41, $40, $40, $40, $40	; tile #162
	.byt $64, $5C, $44, $74, $4C, $40, $40, $40	; tile #163
	.byt $4D, $48, $48, $48, $48, $48, $48, $48	; tile #164
	.byt $55, $40, $40, $40, $40, $40, $40, $40	; tile #165
	.byt $54, $7E, $54, $7E, $54, $7C, $50, $72	; tile #166
	.byt $40, $40, $40, $40, $40, $40, $45, $6A	; tile #167
	.byt $40, $40, $40, $40, $40, $40, $55, $6A	; tile #168
	.byt $44, $44, $44, $44, $44, $44, $44, $60	; tile #169
	.byt $40, $40, $40, $40, $41, $4A, $55, $6A	; tile #170
	.byt $40, $40, $41, $4A, $55, $6A, $55, $6A	; tile #171
	.byt $40, $40, $55, $6A, $55, $6A, $55, $6A	; tile #172
	.byt $40, $6A, $55, $6A, $55, $6A, $55, $6A	; tile #173
	.byt $45, $6A, $55, $6A, $55, $6A, $55, $6A	; tile #174
	.byt $50, $6A, $55, $6A, $55, $6A, $55, $6A	; tile #175
	.byt $40, $40, $50, $6A, $55, $6A, $55, $6A	; tile #176
	.byt $40, $40, $40, $40, $50, $6A, $54, $6A	; tile #177
	.byt $48, $48, $48, $48, $48, $48, $49, $42	; tile #178
	.byt $40, $40, $40, $40, $40, $40, $54, $6A	; tile #179
	.byt $55, $5F, $55, $5F, $55, $4F, $55, $6B	; tile #180
	.byt $55, $7F, $54, $7C, $51, $72, $45, $4A	; tile #181
	.byt $45, $4A, $55, $6A, $55, $6A, $55, $6A	; tile #182
	.byt $55, $7F, $55, $6F, $55, $6B, $55, $6A	; tile #183
; Walkbox Data
wb_data
	.byt 007, 025, 015, 015, $01
	.byt 001, 032, 016, 016, $01
	.byt 014, 023, 014, 014, $01
; Walk matrix
wb_matrix
	.byt 0, 1, 2
	.byt 0, 1, 0
	.byt 0, 0, 2


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
#ifdef FRENCH
	.asc "Sortie",0
#endif
res_end	
.)


; Costume for cup
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
; Animatory state 0 (cup0.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 0, 0
.byt 4, 5, 6, 0, 0
costume_tiles
; Tile graphic 1
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 2
.byt $0, $0, $0, $0, $0, $0, $0, $3f
; Tile graphic 3
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 4
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 5
.byt $2f, $1e, $0, $0, $0, $0, $0, $0
; Tile graphic 6
.byt $0, $0, $0, $0, $0, $0, $0, $0
costume_masks
; Tile mask 1
.byt $ff, $ff, $ff, $ff, $ff, $ff, $7e, $7e
; Tile mask 2
.byt $ff, $ff, $ff, $ff, $ff, $ff, $40, $40
; Tile mask 3
.byt $ff, $ff, $ff, $ff, $ff, $ff, $4f, $4f
; Tile mask 4
.byt $7e, $ff, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 5
.byt $40, $40, $61, $ff, $ff, $ff, $ff, $ff
; Tile mask 6
.byt $5f, $ff, $ff, $ff, $ff, $ff, $ff, $ff
res_end
.)

; Cup
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 201
res_start
	.byt 0			; If OBJ_FLAG_PROP skip all costume data
	.byt 3,1		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 20,11		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt 23,14		; Walk position (col, row)
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
	.asc "Cup",0
#endif
#ifdef SPANISH
	.asc "Taza",0
#endif
#ifdef FRENCH
	.asc "Gobelet",0
#endif
res_end	
.)

; Coffe machine
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 202
res_start
	.byt OBJ_FLAG_PROP	; If OBJ_FLAG_PROP skip all costume data
	.byt 3,3		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 20,11		; Pos (col, row)
	.byt ZPLANE_0		; Zplane
	.byt 23,14		; Walk position (col, row)
	.byt FACING_LEFT	; Facing direction for interaction
	.byt 00			; Color of text
#ifdef ENGLISH
	.asc "Coffee machine",0
#endif
#ifdef SPANISH
	.asc "Cafetera",0
#endif
#ifdef FRENCH
	.asc "Machine ","A"-1," caf","Z"+2,0	; "Machine à café"
#endif
res_end	
.)

; Computer
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 203
res_start
	.byt OBJ_FLAG_PROP	; If OBJ_FLAG_PROP skip all costume data
	.byt 2,1		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 16,11		; Pos (col, row)
	.byt ZPLANE_0		; Zplane
	.byt 15,14		; Walk position (col, row)
	.byt FACING_UP	; Facing direction for interaction
	.byt 00			; Color of text
#ifdef ENGLISH
	.asc "Terminal",0
#endif
#ifdef SPANISH
	.asc "Terminal",0
#endif
#ifdef FRENCH
	.asc "Terminal",0
#endif
res_end	
.)


; Books in shelf
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 204
res_start
	.byt OBJ_FLAG_PROP	; If OBJ_FLAG_PROP skip all costume data
	.byt 6,3		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 25,9		; Pos (col, row)
	.byt ZPLANE_0		; Zplane
	.byt 25,14		; Walk position (col, row)
	.byt FACING_UP		; Facing direction for interaction
	.byt 00			; Color of text
#ifdef ENGLISH
	.asc "Books",0
#endif
#ifdef SPANISH
	.asc "Libros",0
#endif
#ifdef FRENCH
	.asc "Livres",0
#endif
res_end	
.)

; Book in table
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 205
res_start
	.byt OBJ_FLAG_PROP	; If OBJ_FLAG_PROP skip all costume data
	.byt 2,2		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 8,14		; Pos (col, row)
	.byt ZPLANE_0		; Zplane
	.byt 10,15		; Walk position (col, row)
	.byt FACING_LEFT	; Facing direction for interaction
	.byt 00			; Color of text
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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Room: Computer screen
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.(
	.byt RESOURCE_ROOM
	.word (res_end - res_start + 4)
	.byt 200
res_start
; No. columns, offset to tile map, offset to tiles
	.byt 38, <(column_data-res_start), >(column_data-res_start), <(tiles_start-res_start), >(tiles_start-res_start)
; No. zplanes and offsets to zplanes
	.byt 0
; No. Walkboxes and offsets to wb data and matrix
	.byt 0, <(wb_data-res_start), >(wb_data-res_start), <(wb_matrix-res_start), >(wb_matrix-res_start)
; Offset to palette
	.byt <(palette-res_start), >(palette-res_start)
; Entry and exit scripts
	.byt 255, 255
; Number of objects in the room and list of ids
	.byt 0
; Room name (null terminated)
	.asc "No name", 0
; Room tile map
column_data
	.byt 001, 026, 050, 050, 050, 050, 050, 050, 050, 050, 050, 050, 050, 050, 050, 050, 197
	.byt 002, 027, 050, 051, 065, 079, 090, 090, 090, 090, 090, 090, 090, 183, 050, 050, 050
	.byt 003, 028, 050, 052, 066, 080, 091, 117, 125, 140, 150, 168, 172, 028, 050, 050, 050
	.byt 004, 029, 050, 053, 067, 081, 003, 003, 095, 003, 095, 003, 173, 028, 050, 050, 050
	.byt 005, 030, 050, 054, 068, 082, 092, 003, 126, 003, 151, 003, 174, 028, 050, 050, 050
	.byt 006, 031, 050, 054, 068, 083, 093, 003, 127, 123, 137, 003, 111, 028, 050, 050, 050
	.byt 007, 032, 050, 054, 068, 081, 094, 003, 128, 003, 105, 003, 133, 028, 050, 050, 050
	.byt 003, 028, 050, 054, 068, 081, 095, 003, 003, 003, 152, 123, 175, 028, 050, 050, 050
	.byt 003, 028, 050, 054, 068, 081, 096, 003, 129, 003, 153, 003, 176, 028, 050, 050, 050
	.byt 004, 033, 050, 054, 068, 081, 097, 003, 097, 003, 003, 003, 003, 028, 050, 050, 050
	.byt 008, 034, 050, 054, 068, 081, 098, 003, 128, 140, 154, 118, 177, 028, 050, 050, 050
	.byt 009, 035, 050, 054, 068, 084, 099, 003, 095, 141, 155, 003, 135, 028, 050, 050, 050
	.byt 010, 036, 050, 054, 068, 081, 100, 118, 130, 142, 156, 003, 178, 028, 050, 050, 050
	.byt 003, 028, 050, 054, 068, 081, 101, 003, 111, 003, 157, 003, 127, 028, 050, 050, 050
	.byt 003, 028, 050, 055, 003, 081, 102, 119, 128, 143, 158, 003, 094, 028, 050, 050, 050
	.byt 011, 037, 050, 056, 069, 081, 003, 003, 003, 144, 159, 003, 095, 028, 050, 050, 050
	.byt 012, 038, 050, 057, 070, 081, 103, 003, 131, 145, 160, 118, 179, 028, 050, 050, 050
	.byt 013, 039, 050, 058, 071, 081, 104, 120, 132, 146, 161, 003, 134, 184, 050, 050, 050
	.byt 014, 040, 050, 059, 072, 081, 105, 003, 133, 140, 162, 003, 138, 044, 050, 050, 050
	.byt 015, 041, 050, 060, 073, 081, 106, 003, 003, 003, 163, 003, 139, 028, 050, 050, 050
	.byt 016, 042, 050, 055, 074, 081, 107, 003, 103, 147, 164, 003, 003, 028, 050, 050, 050
	.byt 003, 028, 050, 055, 003, 081, 108, 003, 134, 146, 165, 003, 003, 028, 050, 050, 050
	.byt 017, 043, 050, 054, 068, 081, 109, 003, 105, 117, 166, 003, 003, 028, 050, 050, 050
	.byt 018, 044, 050, 054, 068, 081, 095, 121, 135, 003, 139, 003, 003, 028, 050, 050, 050
	.byt 019, 045, 050, 054, 068, 081, 110, 122, 136, 003, 003, 003, 003, 028, 050, 050, 050
	.byt 013, 039, 050, 054, 068, 081, 111, 123, 137, 148, 003, 003, 003, 028, 050, 050, 050
	.byt 020, 046, 050, 054, 068, 081, 112, 003, 138, 149, 003, 003, 003, 028, 050, 050, 050
	.byt 021, 047, 050, 054, 068, 081, 003, 003, 139, 003, 003, 003, 003, 028, 050, 050, 050
	.byt 022, 031, 050, 054, 068, 081, 003, 003, 003, 003, 003, 003, 003, 028, 050, 050, 050
	.byt 023, 048, 050, 054, 068, 081, 003, 003, 003, 003, 003, 003, 003, 028, 050, 050, 050
	.byt 024, 049, 050, 054, 068, 081, 003, 003, 003, 003, 003, 003, 003, 028, 050, 050, 050
	.byt 003, 028, 050, 054, 068, 081, 003, 003, 003, 003, 003, 003, 003, 028, 050, 050, 050
	.byt 003, 028, 050, 054, 068, 081, 003, 003, 003, 003, 003, 003, 003, 028, 186, 192, 198
	.byt 003, 028, 050, 061, 075, 085, 113, 113, 113, 113, 113, 113, 113, 185, 187, 193, 199
	.byt 003, 028, 050, 062, 076, 086, 114, 124, 124, 124, 167, 169, 180, 180, 188, 194, 200
	.byt 003, 028, 050, 063, 077, 087, 115, 050, 050, 050, 050, 170, 181, 181, 189, 195, 201
	.byt 003, 028, 050, 063, 077, 088, 115, 050, 050, 050, 050, 171, 182, 182, 190, 196, 202
	.byt 025, 028, 050, 064, 078, 089, 116, 050, 050, 050, 050, 050, 050, 050, 191, 089, 203

; Room tile set
tiles_start
	.byt $4F, $5F, $78, $70, $70, $70, $70, $70	; tile #1
	.byt $4F, $5F, $63, $41, $47, $47, $41, $41	; tile #2
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F	; tile #3
	.byt $7F, $41, $4F, $4F, $4F, $43, $4F, $4F	; tile #4
	.byt $7F, $66, $7E, $66, $66, $66, $66, $66	; tile #5
	.byt $7F, $5F, $5F, $5C, $59, $59, $58, $59	; tile #6
	.byt $7F, $7F, $7F, $4F, $67, $67, $47, $7F	; tile #7
	.byt $7F, $7E, $7E, $70, $66, $66, $66, $66	; tile #8
	.byt $7F, $59, $5F, $59, $59, $59, $59, $59	; tile #9
	.byt $7F, $73, $73, $61, $73, $73, $73, $73	; tile #10
	.byt $7F, $73, $73, $73, $73, $73, $73, $73	; tile #11
	.byt $7F, $4C, $4F, $4C, $4C, $4C, $4C, $4C	; tile #12
	.byt $7F, $7F, $7F, $78, $73, $73, $70, $73	; tile #13
	.byt $7F, $7F, $7F, $5C, $4C, $4C, $4C, $7C	; tile #14
	.byt $7F, $7F, $7F, $73, $73, $73, $73, $73	; tile #15
	.byt $7F, $7F, $7F, $4F, $4F, $4F, $4F, $4F	; tile #16
	.byt $7F, $7F, $7E, $7E, $7E, $7F, $7F, $7F	; tile #17
	.byt $7F, $47, $5B, $5F, $4F, $47, $63, $73	; tile #18
	.byt $7F, $7F, $7F, $41, $4C, $4C, $4C, $4C	; tile #19
	.byt $7F, $7F, $7F, $5E, $4C, $4C, $4C, $7C	; tile #20
	.byt $7F, $7E, $7F, $4E, $76, $7E, $7E, $7E	; tile #21
	.byt $7F, $5F, $7F, $5C, $5B, $5C, $59, $59	; tile #22
	.byt $7F, $7E, $7E, $4E, $66, $46, $66, $66	; tile #23
	.byt $7F, $5F, $5F, $5F, $5F, $5F, $5F, $5F	; tile #24
	.byt $7C, $7E, $7F, $7F, $7F, $7F, $7F, $7F	; tile #25
	.byt $78, $7C, $7F, $7F, $7F, $7F, $7F, $40	; tile #26
	.byt $43, $67, $7F, $7F, $7F, $7F, $7F, $40	; tile #27
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $7F, $40	; tile #28
	.byt $4F, $4F, $7F, $7F, $7F, $7F, $7F, $40	; tile #29
	.byt $66, $66, $7F, $7F, $7F, $7F, $7F, $40	; tile #30
	.byt $59, $5C, $7F, $7F, $7F, $7F, $7F, $40	; tile #31
	.byt $77, $4F, $7F, $7F, $7F, $7F, $7F, $40	; tile #32
	.byt $4F, $41, $7F, $7F, $7F, $7F, $7F, $40	; tile #33
	.byt $66, $70, $7F, $7F, $7F, $7F, $7F, $40	; tile #34
	.byt $59, $59, $7F, $7F, $7F, $7F, $7F, $40	; tile #35
	.byt $73, $79, $7F, $7F, $7F, $7F, $7F, $40	; tile #36
	.byt $73, $70, $7F, $7F, $7F, $7F, $7F, $40	; tile #37
	.byt $5C, $7C, $7F, $7F, $7F, $7F, $7F, $40	; tile #38
	.byt $73, $78, $7F, $7F, $7F, $7F, $7F, $40	; tile #39
	.byt $6C, $5C, $7F, $7F, $7F, $7F, $7F, $40	; tile #40
	.byt $73, $40, $7F, $7F, $7F, $7F, $7F, $40	; tile #41
	.byt $5F, $7F, $7F, $7F, $7F, $7F, $7F, $40	; tile #42
	.byt $7E, $7F, $7F, $7F, $7F, $7F, $7F, $40	; tile #43
	.byt $73, $47, $7F, $7F, $7F, $7F, $7F, $40	; tile #44
	.byt $4C, $41, $4F, $4F, $7F, $7F, $7F, $40	; tile #45
	.byt $6C, $5E, $7F, $7F, $7F, $7F, $7F, $40	; tile #46
	.byt $76, $4E, $7F, $7F, $7F, $7F, $7F, $40	; tile #47
	.byt $66, $46, $7F, $7F, $7F, $7F, $7F, $40	; tile #48
	.byt $5F, $5F, $7F, $7F, $7F, $7F, $7F, $40	; tile #49
	.byt $6A, $55, $6A, $55, $6A, $55, $6A, $55	; tile #50
	.byt $40, $5F, $5F, $5F, $51, $5F, $51, $5F	; tile #51
	.byt $40, $7F, $7F, $7F, $40, $5F, $5F, $5F	; tile #52
	.byt $40, $7F, $7F, $7F, $41, $7D, $7D, $7D	; tile #53
	.byt $40, $7F, $7F, $7F, $40, $7F, $40, $7F	; tile #54
	.byt $40, $7F, $7F, $7F, $7F, $7F, $7F, $7F	; tile #55
	.byt $40, $7F, $7F, $7F, $7F, $40, $73, $73	; tile #56
	.byt $40, $7F, $7F, $7F, $7F, $7F, $7F, $61	; tile #57
	.byt $40, $7F, $7F, $7F, $7F, $7F, $7F, $76	; tile #58
	.byt $40, $7F, $7F, $7F, $7F, $7F, $7F, $48	; tile #59
	.byt $40, $7F, $7F, $7F, $7F, $7F, $7F, $40	; tile #60
	.byt $40, $7E, $7E, $7E, $42, $7E, $42, $7E	; tile #61
	.byt $6A, $40, $5F, $5F, $5F, $5F, $5F, $5F	; tile #62
	.byt $6A, $40, $7F, $7F, $7F, $7F, $7F, $7F	; tile #63
	.byt $6A, $45, $72, $75, $72, $75, $72, $75	; tile #64
	.byt $51, $5F, $51, $5F, $51, $5F, $51, $5F	; tile #65
	.byt $5F, $5F, $5F, $5F, $5F, $5F, $40, $7F	; tile #66
	.byt $7D, $7D, $7D, $7D, $7D, $7D, $41, $7F	; tile #67
	.byt $40, $7F, $40, $7F, $40, $7F, $40, $7F	; tile #68
	.byt $73, $73, $73, $73, $73, $73, $7F, $7F	; tile #69
	.byt $4C, $4C, $40, $4F, $4E, $61, $7F, $7F	; tile #70
	.byt $71, $73, $73, $73, $73, $73, $7F, $7F	; tile #71
	.byt $79, $79, $79, $79, $79, $79, $7F, $7F	; tile #72
	.byt $66, $66, $66, $66, $66, $66, $7F, $7F	; tile #73
	.byt $5F, $5F, $5F, $5F, $5F, $5F, $7F, $7F	; tile #74
	.byt $42, $7E, $42, $7E, $42, $7E, $42, $7E	; tile #75
	.byt $5F, $5F, $5F, $40, $4A, $55, $5F, $5F	; tile #76
	.byt $7F, $7F, $7F, $40, $6A, $55, $7F, $7F	; tile #77
	.byt $72, $75, $72, $45, $6A, $55, $7A, $75	; tile #78
	.byt $5F, $5F, $5F, $40, $5F, $5F, $5F, $5F	; tile #79
	.byt $7F, $7F, $7F, $40, $7F, $7F, $4F, $67	; tile #80
	.byt $7F, $7F, $7F, $40, $7F, $7F, $7F, $7F	; tile #81
	.byt $7F, $7F, $7F, $40, $7F, $7F, $7E, $7F	; tile #82
	.byt $7F, $7F, $7F, $40, $7F, $7F, $47, $4F	; tile #83
	.byt $7F, $7F, $7F, $40, $7F, $7C, $7C, $7F	; tile #84
	.byt $7E, $7E, $7E, $40, $7E, $7E, $7E, $7E	; tile #85
	.byt $5F, $5F, $5F, $4F, $4F, $4F, $5F, $5F	; tile #86
	.byt $7F, $63, $5D, $7D, $7B, $77, $6F, $41	; tile #87
	.byt $7F, $63, $5D, $5D, $5D, $5D, $5D, $63	; tile #88
	.byt $7A, $75, $7A, $75, $7A, $75, $7A, $75	; tile #89
	.byt $5F, $5F, $5F, $5F, $5F, $5F, $5F, $5F	; tile #90
	.byt $73, $79, $7C, $79, $73, $67, $4F, $7F	; tile #91
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $7E, $7F	; tile #92
	.byt $4F, $4F, $4F, $4F, $4F, $4F, $47, $7F	; tile #93
	.byt $41, $4C, $4C, $4C, $4C, $4C, $4C, $7F	; tile #94
	.byt $78, $73, $73, $73, $73, $73, $78, $7F	; tile #95
	.byt $5E, $4C, $7C, $7C, $7C, $4C, $5E, $7F	; tile #96
	.byt $47, $73, $73, $73, $73, $73, $47, $7F	; tile #97
	.byt $40, $4A, $4A, $4A, $4A, $4A, $4E, $7F	; tile #98
	.byt $70, $5C, $5C, $5C, $5C, $5C, $50, $7F	; tile #99
	.byt $7C, $7C, $7C, $7C, $7C, $7C, $4C, $7F	; tile #100
	.byt $47, $73, $73, $73, $73, $73, $73, $7F	; tile #101
	.byt $60, $4C, $4C, $4C, $4C, $4C, $60, $7C	; tile #102
	.byt $7C, $7C, $7C, $7C, $7C, $7C, $7C, $7F	; tile #103
	.byt $43, $69, $69, $69, $69, $69, $79, $7F	; tile #104
	.byt $61, $4C, $4C, $40, $4F, $4F, $61, $7F	; tile #105
	.byt $78, $73, $73, $78, $7F, $7F, $70, $7F	; tile #106
	.byt $4E, $7C, $7C, $5E, $4F, $4F, $5C, $7F	; tile #107
	.byt $43, $7F, $7F, $47, $73, $73, $47, $7F	; tile #108
	.byt $61, $7C, $7C, $60, $4C, $4C, $60, $7F	; tile #109
	.byt $4E, $4C, $4C, $4C, $4C, $4C, $4E, $4F	; tile #110
	.byt $47, $73, $73, $43, $7F, $7F, $47, $7F	; tile #111
	.byt $71, $71, $7F, $7F, $7F, $71, $71, $7F	; tile #112
	.byt $7E, $7E, $7E, $7E, $7E, $7E, $7E, $7E	; tile #113
	.byt $5F, $5F, $4A, $55, $4A, $55, $4A, $55	; tile #114
	.byt $7F, $7F, $6A, $55, $6A, $55, $6A, $55	; tile #115
	.byt $7A, $75, $6A, $55, $6A, $55, $6A, $55	; tile #116
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $4C, $4C	; tile #117
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $4F, $4F	; tile #118
	.byt $7C, $41, $7F, $7F, $7F, $7F, $7F, $7F	; tile #119
	.byt $7F, $7F, $7F, $7F, $7F, $4F, $4F, $7F	; tile #120
	.byt $7F, $70, $7F, $7F, $7F, $7F, $7F, $7F	; tile #121
	.byt $4F, $5F, $7F, $7F, $7F, $7F, $7F, $7F	; tile #122
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $73, $73	; tile #123
	.byt $4A, $55, $4A, $55, $4A, $55, $4A, $55	; tile #124
	.byt $4C, $4C, $61, $73, $73, $73, $73, $7F	; tile #125
	.byt $5C, $4C, $4C, $4C, $4C, $4C, $5E, $7F	; tile #126
	.byt $73, $73, $73, $73, $73, $73, $43, $7F	; tile #127
	.byt $4C, $48, $47, $4F, $4F, $4F, $4F, $7F	; tile #128
	.byt $7E, $7C, $7C, $7C, $7C, $7C, $7E, $7F	; tile #129
	.byt $4E, $4C, $4C, $4C, $4C, $4C, $4E, $7F	; tile #130
	.byt $7C, $7F, $7F, $7F, $7F, $7F, $7C, $7F	; tile #131
	.byt $4F, $4F, $4F, $4F, $4F, $4F, $43, $7F	; tile #132
	.byt $60, $4F, $4F, $61, $7C, $7C, $41, $7F	; tile #133
	.byt $73, $63, $5F, $7F, $7F, $7F, $7F, $7F	; tile #134
	.byt $78, $7F, $7F, $78, $73, $73, $78, $7F	; tile #135
	.byt $5E, $4C, $4C, $4C, $4C, $4C, $4E, $7F	; tile #136
	.byt $43, $73, $73, $73, $73, $73, $43, $7F	; tile #137
	.byt $4C, $4C, $4C, $4C, $4C, $4C, $61, $79	; tile #138
	.byt $7F, $7F, $7F, $7F, $7F, $78, $78, $7F	; tile #139
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $61, $4C	; tile #140
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $70, $73	; tile #141
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $5F, $4F	; tile #142
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $79, $71	; tile #143
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $78, $73	; tile #144
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $5E, $4C	; tile #145
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $47, $73	; tile #146
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $7E, $7C	; tile #147
	.byt $7F, $7E, $7F, $7F, $7F, $7F, $7F, $7F	; tile #148
	.byt $73, $47, $7F, $7F, $7F, $7F, $7F, $7F	; tile #149
	.byt $4C, $4F, $4F, $4F, $4C, $4C, $61, $7F	; tile #150
	.byt $5E, $4C, $4C, $4C, $4C, $4C, $5E, $7F	; tile #151
	.byt $7C, $7C, $7F, $7F, $7F, $7C, $7C, $7F	; tile #152
	.byt $5F, $5F, $7F, $7F, $7F, $5F, $5F, $7F	; tile #153
	.byt $4F, $67, $73, $79, $7C, $4C, $61, $7F	; tile #154
	.byt $73, $73, $70, $73, $73, $73, $73, $7F	; tile #155
	.byt $4F, $4F, $5C, $7F, $7F, $7F, $7F, $7F	; tile #156
	.byt $7F, $7F, $43, $7F, $7F, $7F, $7F, $7F	; tile #157
	.byt $41, $79, $79, $79, $79, $79, $79, $7F	; tile #158
	.byt $73, $73, $73, $78, $7E, $7C, $78, $7F	; tile #159
	.byt $4C, $4C, $4C, $4E, $5F, $7F, $7E, $7F	; tile #160
	.byt $73, $73, $73, $43, $67, $4F, $4F, $7F	; tile #161
	.byt $4C, $4C, $4C, $60, $79, $73, $63, $7F	; tile #162
	.byt $7F, $7F, $70, $7F, $7F, $7F, $7F, $7F	; tile #163
	.byt $7C, $7C, $4C, $7C, $7C, $7C, $7E, $7F	; tile #164
	.byt $73, $7F, $7F, $7F, $73, $73, $47, $7F	; tile #165
	.byt $4C, $4C, $40, $4C, $4C, $4C, $4C, $7F	; tile #166
	.byt $4A, $55, $4A, $55, $4A, $55, $4A, $40	; tile #167
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $40, $4F	; tile #168
	.byt $5F, $40, $5F, $40, $5F, $5F, $4E, $57	; tile #169
	.byt $6A, $40, $7F, $40, $7F, $7F, $7B, $5D	; tile #170
	.byt $6A, $45, $72, $45, $6A, $65, $6A, $65	; tile #171
	.byt $4F, $4F, $41, $4F, $4F, $4F, $4F, $7F	; tile #172
	.byt $73, $72, $71, $73, $73, $73, $73, $7F	; tile #173
	.byt $4E, $4C, $7C, $7C, $7C, $7C, $7E, $7F	; tile #174
	.byt $70, $73, $73, $73, $73, $73, $73, $7F	; tile #175
	.byt $5F, $4F, $4F, $4F, $4F, $4F, $4F, $7F	; tile #176
	.byt $4F, $4F, $4F, $4F, $4F, $4F, $40, $7F	; tile #177
	.byt $5C, $4C, $4C, $4C, $4C, $4C, $4E, $7F	; tile #178
	.byt $4C, $4C, $4C, $4C, $4C, $4C, $4C, $7F	; tile #179
	.byt $57, $57, $57, $57, $57, $57, $57, $57	; tile #180
	.byt $5D, $5D, $5D, $5D, $5D, $5D, $5D, $5D	; tile #181
	.byt $6A, $65, $6A, $65, $6A, $65, $6A, $65	; tile #182
	.byt $5F, $5F, $5F, $5F, $5F, $5F, $5F, $40	; tile #183
	.byt $7F, $7E, $7F, $7F, $7F, $7F, $7F, $40	; tile #184
	.byt $7E, $7E, $7E, $7E, $7E, $7E, $7E, $40	; tile #185
	.byt $6A, $55, $6A, $55, $6A, $55, $6A, $5F	; tile #186
	.byt $5D, $5D, $5D, $5B, $5F, $5F, $60, $7F	; tile #187
	.byt $77, $77, $77, $6E, $7F, $7F, $40, $7F	; tile #188
	.byt $5D, $5D, $5D, $7B, $7F, $7F, $40, $7F	; tile #189
	.byt $6A, $65, $6A, $65, $6A, $65, $4A, $7F	; tile #190
	.byt $6A, $55, $6A, $55, $6A, $55, $6A, $75	; tile #191
	.byt $6F, $5F, $6C, $5F, $6F, $5F, $6F, $5F	; tile #192
	.byt $7F, $7F, $47, $5F, $5D, $5C, $5D, $5D	; tile #193
	.byt $7F, $7F, $7F, $7F, $4C, $7F, $7C, $7B	; tile #194
	.byt $7F, $7F, $7F, $7F, $78, $57, $59, $5E	; tile #195
	.byt $7F, $7F, $6F, $6F, $63, $6D, $6D, $6D	; tile #196
	.byt $6A, $55, $6A, $55, $6A, $55, $4A, $45	; tile #197
	.byt $6F, $5F, $6F, $55, $6A, $55, $6A, $55	; tile #198
	.byt $5D, $7F, $7F, $55, $6A, $55, $6A, $55	; tile #199
	.byt $7C, $7F, $7F, $55, $6A, $55, $6A, $55	; tile #200
	.byt $51, $7F, $7F, $55, $6A, $55, $6A, $55	; tile #201
	.byt $6D, $7F, $7F, $55, $6A, $55, $6A, $55	; tile #202
	.byt $7A, $75, $7A, $55, $6A, $55, $6A, $54	; tile #203
; Walkbox Data
wb_data
; Walk matrix
wb_matrix
; Palette Information is stored as one column only for now...
; Palette
palette
.byt 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2
.byt 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2
.byt 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2
.byt 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2
.byt 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2
.byt 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2
.byt 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2
.byt 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2
.byt 2, 2, 2, 2, 2, 2, 2, 2


res_end
.)



#include "..\scripts\common.s"


