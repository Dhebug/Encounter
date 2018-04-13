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
; Room: Map room
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.(
	.byt RESOURCE_ROOM
	.word (res_end - res_start + 4)
	.byt 5
res_start
; No. columns, offset to tile map, offset to tiles
	.byt 38, <(column_data-res_start), >(column_data-res_start), <(tiles_start-res_start), >(tiles_start-res_start)
; No. zplanes and offsets to zplanes
	.byt 1
	.byt <(zplane0_data-res_start), >(zplane0_data-res_start), <(zplane0_tiles-res_start), >(zplane0_tiles-res_start)
; No. Walkboxes and offsets to wb data and matrix
	.byt 1, <(wb_data-res_start), >(wb_data-res_start), <(wb_matrix-res_start), >(wb_matrix-res_start)
; Offset to palette
	.byt 0, 0	; No palette information
; Entry and exit scripts
	.byt 255, 255
; Number of objects in the room and list of ids
	.byt 7, 200, 201, 202, 203, 204, 205, 206
; Room name (null terminated)
	.asc "Map Room", 0
; Room tile map
column_data
	.byt 001, 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 211
	.byt 002, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 205, 203
	.byt 003, 009, 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 201, 206, 203
	.byt 004, 010, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 202, 203, 203
	.byt 004, 011, 007, 007, 007, 007, 007, 007, 007, 007, 130, 156, 094, 186, 203, 203, 203
	.byt 004, 012, 019, 031, 031, 031, 031, 031, 098, 114, 131, 157, 170, 187, 203, 203, 203
	.byt 004, 004, 020, 007, 007, 007, 007, 007, 099, 115, 132, 158, 171, 188, 203, 203, 203
	.byt 004, 004, 021, 008, 008, 008, 008, 008, 100, 116, 133, 159, 172, 189, 203, 203, 203
	.byt 004, 004, 020, 007, 007, 007, 007, 007, 101, 117, 134, 160, 173, 189, 203, 203, 203
	.byt 004, 004, 021, 008, 008, 008, 008, 080, 031, 118, 135, 161, 174, 189, 203, 203, 203
	.byt 004, 004, 020, 007, 007, 007, 007, 081, 102, 119, 136, 162, 175, 190, 203, 203, 203
	.byt 004, 004, 021, 008, 008, 008, 008, 082, 103, 120, 137, 157, 170, 187, 203, 203, 203
	.byt 004, 004, 020, 007, 007, 007, 007, 081, 104, 121, 138, 158, 176, 191, 203, 203, 203
	.byt 004, 004, 021, 008, 008, 008, 008, 082, 105, 122, 139, 159, 177, 189, 203, 203, 203
	.byt 004, 004, 022, 032, 032, 032, 032, 083, 038, 038, 140, 160, 178, 189, 203, 203, 203
	.byt 004, 004, 023, 033, 045, 055, 066, 084, 008, 008, 141, 161, 177, 189, 203, 203, 203
	.byt 004, 004, 024, 034, 046, 056, 067, 085, 007, 007, 142, 162, 179, 192, 203, 203, 203
	.byt 004, 004, 023, 035, 047, 057, 068, 084, 008, 008, 143, 157, 170, 187, 203, 203, 203
	.byt 004, 004, 024, 036, 048, 058, 069, 085, 007, 007, 144, 163, 180, 193, 203, 203, 203
	.byt 004, 004, 023, 037, 049, 059, 070, 084, 008, 082, 145, 160, 173, 189, 203, 203, 203
	.byt 004, 004, 025, 038, 038, 038, 038, 086, 007, 081, 146, 164, 181, 190, 203, 203, 203
	.byt 004, 004, 021, 008, 008, 008, 008, 008, 008, 123, 147, 157, 170, 187, 203, 203, 203
	.byt 004, 004, 020, 007, 007, 007, 007, 007, 007, 007, 148, 165, 038, 191, 203, 203, 203
	.byt 004, 013, 026, 039, 039, 039, 039, 039, 039, 039, 039, 039, 039, 194, 203, 203, 203
	.byt 004, 014, 027, 027, 027, 027, 027, 027, 027, 027, 027, 027, 027, 195, 203, 203, 203
	.byt 004, 004, 028, 040, 050, 060, 071, 087, 106, 124, 149, 166, 182, 189, 203, 203, 203
	.byt 004, 004, 028, 041, 051, 061, 072, 088, 107, 125, 150, 166, 182, 189, 203, 203, 203
	.byt 004, 004, 028, 042, 052, 044, 073, 089, 108, 093, 151, 166, 182, 189, 203, 203, 203
	.byt 004, 004, 028, 043, 053, 062, 071, 090, 109, 126, 152, 167, 183, 189, 203, 203, 203
	.byt 004, 004, 028, 041, 051, 063, 074, 091, 110, 127, 153, 168, 182, 189, 203, 203, 212
	.byt 004, 004, 028, 040, 050, 064, 075, 092, 111, 128, 154, 166, 182, 189, 203, 203, 213
	.byt 004, 004, 028, 044, 054, 065, 073, 093, 112, 129, 155, 166, 182, 189, 203, 207, 000
	.byt 004, 015, 029, 000, 029, 000, 029, 000, 029, 000, 029, 169, 184, 196, 203, 208, 000
	.byt 004, 016, 030, 030, 030, 030, 030, 030, 030, 030, 030, 030, 030, 197, 203, 209, 000
	.byt 004, 017, 007, 007, 007, 007, 076, 094, 094, 094, 094, 094, 094, 198, 204, 210, 000
	.byt 004, 018, 008, 008, 008, 008, 077, 095, 113, 113, 113, 113, 113, 199, 000, 000, 000
	.byt 005, 007, 007, 007, 007, 007, 078, 096, 093, 093, 093, 093, 093, 200, 000, 000, 000
	.byt 006, 008, 008, 008, 008, 008, 079, 097, 093, 093, 093, 093, 185, 000, 000, 000, 000

; Room tile set
tiles_start
	.byt $E0, $F8, $78, $77, $7F, $5D, $7F, $77	; tile #1
	.byt $C0, $C0, $C0, $F0, $CC, $74, $7F, $5D	; tile #2
	.byt $C0, $C0, $C0, $C0, $C0, $C0, $F0, $71	; tile #3
	.byt $C0, $C0, $C0, $C0, $C0, $C0, $C0, $C0	; tile #4
	.byt $C0, $C0, $C0, $C0, $C0, $C1, $C6, $47	; tile #5
	.byt $C0, $C0, $C1, $C6, $67, $57, $7F, $5D	; tile #6
	.byt $7F, $5D, $7F, $77, $7F, $5D, $7F, $77	; tile #7
	.byt $7F, $77, $7F, $5D, $7F, $77, $7F, $5D	; tile #8
	.byt $7E, $5D, $7F, $77, $7F, $5D, $7F, $77	; tile #9
	.byt $E0, $D8, $79, $5C, $7F, $77, $7F, $5D	; tile #10
	.byt $C0, $C0, $C0, $F0, $CC, $5C, $7F, $77	; tile #11
	.byt $C0, $C0, $C0, $C0, $C0, $C0, $F0, $EC	; tile #12
	.byt $C0, $C0, $C0, $C0, $C3, $73, $73, $73	; tile #13
	.byt $C0, $C0, $C0, $C0, $40, $4C, $4C, $4C	; tile #14
	.byt $C0, $C0, $C0, $C0, $C7, $70, $60, $40	; tile #15
	.byt $C0, $C0, $C0, $C0, $43, $73, $70, $71	; tile #16
	.byt $C0, $C0, $C0, $C3, $CC, $4D, $7F, $77	; tile #17
	.byt $C3, $73, $4F, $5D, $7F, $77, $7F, $5D	; tile #18
	.byt $7C, $76, $7E, $5C, $7E, $76, $7E, $5C	; tile #19
	.byt $40, $5D, $7F, $77, $7F, $5D, $7F, $77	; tile #20
	.byt $40, $77, $7F, $5D, $7F, $77, $7F, $5D	; tile #21
	.byt $40, $5D, $7F, $77, $7F, $5C, $7C, $75	; tile #22
	.byt $40, $77, $7F, $5D, $7F, $40, $40, $C0	; tile #23
	.byt $40, $5D, $7F, $77, $7F, $40, $40, $C0	; tile #24
	.byt $40, $5D, $7F, $77, $7F, $5D, $5F, $57	; tile #25
	.byt $43, $73, $73, $53, $73, $73, $73, $53	; tile #26
	.byt $4C, $4C, $4C, $4C, $4C, $4C, $4C, $4C	; tile #27
	.byt $40, $7F, $7F, $7F, $40, $7F, $7F, $40	; tile #28
	.byt $40, $40, $40, $40, $40, $7C, $7C, $40	; tile #29
	.byt $73, $73, $73, $71, $73, $73, $73, $71	; tile #30
	.byt $7E, $76, $7E, $5C, $7E, $76, $7E, $5C	; tile #31
	.byt $7D, $5D, $7D, $75, $7D, $5D, $7D, $75	; tile #32
	.byt $C0, $C0, $C0, $C2, $C5, $C5, $C0, $C0	; tile #33
	.byt $D0, $47, $F8, $6D, $ED, $7A, $F8, $E8	; tile #34
	.byt $C0, $C0, $75, $CC, $75, $C0, $C8, $D4	; tile #35
	.byt $C0, $C0, $64, $EA, $45, $C0, $C0, $C0	; tile #36
	.byt $C0, $C0, $79, $EA, $51, $C2, $7B, $C0	; tile #37
	.byt $5F, $5D, $5F, $57, $5F, $5D, $5F, $57	; tile #38
	.byt $73, $73, $73, $53, $73, $73, $73, $53	; tile #39
	.byt $40, $7F, $7F, $7F, $7C, $7D, $CE, $45	; tile #40
	.byt $40, $7F, $43, $5B, $FF, $58, $FD, $40	; tile #41
	.byt $40, $7F, $7F, $7C, $4D, $F3, $41, $F3	; tile #42
	.byt $40, $70, $70, $50, $50, $40, $58, $58	; tile #43
	.byt $40, $7F, $7F, $7F, $5F, $5F, $5F, $5F	; tile #44
	.byt $C0, $C3, $FF, $C0, $C0, $C0, $C0, $FF	; tile #45
	.byt $E8, $C6, $FF, $C0, $C0, $C0, $C0, $FF	; tile #46
	.byt $C8, $C0, $FF, $C1, $C1, $C1, $C1, $FF	; tile #47
	.byt $C0, $C0, $FF, $C0, $C0, $C0, $C0, $FF	; tile #48
	.byt $C0, $C0, $FE, $C0, $D0, $E8, $D0, $FE	; tile #49
	.byt $EB, $54, $EB, $54, $40, $7F, $7F, $40	; tile #50
	.byt $FD, $42, $FD, $42, $40, $7F, $7F, $40	; tile #51
	.byt $4C, $F3, $4C, $F3, $40, $7F, $7F, $40	; tile #52
	.byt $40, $58, $58, $58, $40, $7F, $7F, $40	; tile #53
	.byt $5F, $5F, $5F, $5F, $40, $7F, $7F, $40	; tile #54
	.byt $C0, $C0, $C0, $C0, $FF, $C4, $C4, $C4	; tile #55
	.byt $C4, $C4, $C4, $C4, $FF, $C0, $C0, $C0	; tile #56
	.byt $C0, $C0, $C0, $C0, $FF, $C0, $D0, $E8	; tile #57
	.byt $C1, $C1, $C1, $C1, $FF, $D0, $D0, $D0	; tile #58
	.byt $C0, $C0, $C0, $C0, $FE, $C0, $C0, $C0	; tile #59
	.byt $40, $7F, $7F, $7F, $7C, $7C, $7C, $7C	; tile #60
	.byt $40, $7F, $7F, $7F, $40, $FF, $40, $FF	; tile #61
	.byt $40, $7F, $7F, $7C, $7C, $7C, $7C, $7C	; tile #62
	.byt $40, $7F, $7F, $40, $FF, $40, $FF, $40	; tile #63
	.byt $40, $7F, $7F, $5F, $5F, $5F, $40, $4F	; tile #64
	.byt $40, $7F, $7F, $7F, $7F, $7F, $5F, $5F	; tile #65
	.byt $C4, $FF, $C0, $C0, $C0, $C0, $40, $7F	; tile #66
	.byt $C0, $FF, $C4, $C4, $C4, $C4, $40, $7F	; tile #67
	.byt $D0, $FF, $7A, $71, $6B, $75, $40, $7F	; tile #68
	.byt $D0, $FF, $C1, $C1, $C1, $C1, $40, $7F	; tile #69
	.byt $C0, $FE, $C0, $C0, $C0, $C0, $41, $7F	; tile #70
	.byt $7C, $7C, $40, $40, $40, $7F, $7F, $40	; tile #71
	.byt $40, $7F, $7F, $40, $40, $7F, $7F, $40	; tile #72
	.byt $5F, $5F, $40, $40, $40, $7F, $7F, $40	; tile #73
	.byt $7F, $FF, $7F, $40, $40, $7F, $7F, $40	; tile #74
	.byt $40, $4F, $F0, $40, $40, $7F, $7F, $40	; tile #75
	.byt $7F, $5D, $7F, $77, $7F, $5D, $7F, $76	; tile #76
	.byt $7F, $77, $7F, $5D, $7F, $77, $70, $45	; tile #77
	.byt $7F, $5D, $7F, $77, $7F, $40, $5F, $55	; tile #78
	.byt $7F, $77, $7F, $5C, $43, $55, $7F, $55	; tile #79
	.byt $7F, $77, $7F, $5D, $7F, $77, $7F, $5C	; tile #80
	.byt $7F, $5D, $7F, $77, $7F, $5D, $7F, $40	; tile #81
	.byt $7F, $77, $7F, $5D, $7F, $77, $7F, $40	; tile #82
	.byt $7C, $5C, $7F, $77, $7F, $5D, $7F, $57	; tile #83
	.byt $40, $40, $7F, $5D, $7F, $77, $7F, $5D	; tile #84
	.byt $40, $40, $7F, $77, $7F, $5D, $7F, $77	; tile #85
	.byt $5F, $5D, $7F, $77, $7F, $5D, $7F, $77	; tile #86
	.byt $70, $D0, $67, $D7, $6F, $D3, $6F, $D1	; tile #87
	.byt $47, $C4, $73, $F4, $79, $E1, $5A, $C5	; tile #88
	.byt $7F, $7F, $7F, $70, $6F, $67, $68, $6F	; tile #89
	.byt $7F, $7F, $7F, $47, $79, $76, $4A, $7A	; tile #90
	.byt $7F, $70, $D0, $67, $D7, $6F, $D4, $6D	; tile #91
	.byt $7F, $47, $C4, $73, $F4, $79, $D1, $5A	; tile #92
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F	; tile #93
	.byt $7E, $5C, $7E, $76, $7E, $5C, $7E, $76	; tile #94
	.byt $7F, $55, $7F, $55, $78, $50, $70, $50	; tile #95
	.byt $7F, $55, $7E, $41, $5F, $7F, $7F, $7F	; tile #96
	.byt $7F, $50, $47, $7F, $7F, $7F, $7F, $7F	; tile #97
	.byt $7E, $76, $7E, $5C, $7E, $76, $7E, $5A	; tile #98
	.byt $7F, $5D, $7F, $77, $7F, $7D, $60, $E1	; tile #99
	.byt $7F, $77, $7F, $5D, $7F, $77, $40, $C0	; tile #100
	.byt $7F, $5D, $7F, $77, $7F, $5D, $40, $C0	; tile #101
	.byt $40, $E0, $E4, $EC, $E0, $EC, $EC, $E0	; tile #102
	.byt $40, $C0, $C0, $C0, $DF, $DF, $D0, $D0	; tile #103
	.byt $40, $C0, $C0, $C0, $FF, $FF, $C1, $C1	; tile #104
	.byt $40, $C1, $C1, $C1, $C1, $C1, $C1, $C1	; tile #105
	.byt $6D, $D3, $4F, $F8, $40, $7F, $7F, $40	; tile #106
	.byt $7E, $E6, $78, $CF, $40, $7F, $7F, $40	; tile #107
	.byt $6E, $6D, $4C, $47, $40, $7F, $7F, $40	; tile #108
	.byt $7E, $59, $58, $70, $40, $7F, $7F, $40	; tile #109
	.byt $D5, $6B, $F0, $47, $40, $7F, $7F, $40	; tile #110
	.byt $D1, $68, $C7, $70, $40, $7F, $7F, $40	; tile #111
	.byt $7F, $7F, $40, $40, $40, $7F, $7F, $40	; tile #112
	.byt $70, $50, $70, $50, $70, $50, $70, $50	; tile #113
	.byt $78, $76, $7E, $5C, $7E, $76, $7E, $5C	; tile #114
	.byt $F9, $C1, $E1, $60, $7F, $5D, $7F, $77	; tile #115
	.byt $C0, $C0, $C0, $40, $67, $67, $67, $45	; tile #116
	.byt $C0, $C0, $C0, $40, $77, $55, $77, $77	; tile #117
	.byt $5E, $56, $5E, $5C, $7E, $76, $7E, $5C	; tile #118
	.byt $E4, $E4, $E8, $E0, $E0, $E3, $E0, $40	; tile #119
	.byt $D0, $D0, $D0, $DF, $C0, $E6, $C0, $40	; tile #120
	.byt $C1, $C1, $C1, $FF, $C0, $C0, $C0, $40	; tile #121
	.byt $C1, $C1, $C1, $C1, $CD, $CD, $C1, $40	; tile #122
	.byt $7F, $77, $7F, $5D, $7F, $77, $7F, $7D	; tile #123
	.byt $70, $6F, $67, $68, $6F, $68, $6E, $6F	; tile #124
	.byt $47, $7B, $73, $4B, $7B, $79, $4E, $4A	; tile #125
	.byt $7F, $7F, $7F, $70, $D0, $67, $D7, $6F	; tile #126
	.byt $7F, $7F, $7F, $47, $C6, $76, $F5, $7A	; tile #127
	.byt $7F, $CF, $6F, $D8, $68, $D0, $6B, $D2	; tile #128
	.byt $7F, $F8, $7B, $CC, $4B, $C6, $6E, $5A	; tile #129
	.byt $7F, $5D, $7F, $77, $7F, $5C, $7C, $74	; tile #130
	.byt $7E, $76, $7E, $5C, $60, $5F, $C0, $FF	; tile #131
	.byt $7F, $5C, $79, $67, $4F, $70, $C0, $FF	; tile #132
	.byt $67, $41, $7E, $7F, $7F, $40, $C0, $FF	; tile #133
	.byt $7F, $5D, $5F, $67, $70, $4F, $C0, $FF	; tile #134
	.byt $7E, $77, $7F, $5D, $40, $7F, $C0, $FF	; tile #135
	.byt $40, $5D, $7F, $77, $40, $7F, $C0, $FF	; tile #136
	.byt $40, $72, $64, $44, $48, $40, $C0, $FF	; tile #137
	.byt $40, $41, $47, $48, $50, $50, $C0, $FF	; tile #138
	.byt $40, $77, $7F, $40, $40, $40, $C0, $FF	; tile #139
	.byt $5F, $5D, $7F, $40, $40, $40, $C0, $FF	; tile #140
	.byt $7F, $77, $7F, $41, $40, $40, $C0, $FF	; tile #141
	.byt $7F, $5D, $7F, $77, $40, $7F, $C0, $FF	; tile #142
	.byt $7F, $77, $7F, $5D, $40, $7F, $C0, $FF	; tile #143
	.byt $7E, $5E, $7E, $76, $40, $7E, $C0, $FF	; tile #144
	.byt $D8, $40, $4F, $40, $40, $40, $C0, $FF	; tile #145
	.byt $C0, $40, $6A, $40, $40, $40, $C0, $FF	; tile #146
	.byt $5F, $57, $5F, $5D, $41, $5E, $C0, $FF	; tile #147
	.byt $7F, $5D, $7F, $77, $7F, $4D, $4F, $4F	; tile #148
	.byt $6E, $68, $6F, $47, $40, $7F, $7F, $40	; tile #149
	.byt $4E, $79, $7B, $70, $40, $7F, $7F, $40	; tile #150
	.byt $7F, $7F, $7F, $40, $40, $7F, $7F, $40	; tile #151
	.byt $D2, $6E, $D7, $47, $40, $7F, $7F, $40	; tile #152
	.byt $E1, $79, $F4, $70, $40, $7F, $7F, $40	; tile #153
	.byt $6E, $D3, $6B, $F8, $40, $7F, $7F, $40	; tile #154
	.byt $7E, $E7, $6B, $CF, $40, $7F, $7F, $40	; tile #155
	.byt $7C, $5C, $7E, $76, $7E, $5C, $7E, $76	; tile #156
	.byt $C0, $FF, $FF, $FF, $40, $FF, $40, $FF	; tile #157
	.byt $C0, $FF, $FF, $FF, $40, $C0, $60, $DF	; tile #158
	.byt $C0, $FF, $FF, $FF, $40, $C0, $FC, $FC	; tile #159
	.byt $C0, $FF, $FF, $FF, $40, $C0, $40, $C0	; tile #160
	.byt $C0, $FF, $FF, $FF, $40, $C0, $CF, $CF	; tile #161
	.byt $C0, $FF, $FF, $FF, $40, $C0, $41, $FE	; tile #162
	.byt $C0, $FF, $FF, $FF, $40, $C0, $DC, $DC	; tile #163
	.byt $C0, $FF, $FF, $FF, $40, $C0, $CE, $CE	; tile #164
	.byt $4F, $5D, $5F, $57, $5F, $5D, $5F, $57	; tile #165
	.byt $40, $7F, $C0, $7F, $C0, $7F, $C0, $7F	; tile #166
	.byt $40, $7E, $C1, $7E, $C1, $72, $C5, $7A	; tile #167
	.byt $40, $7F, $C0, $7F, $C0, $67, $D0, $6F	; tile #168
	.byt $40, $7C, $C3, $7C, $C3, $7C, $C3, $7C	; tile #169
	.byt $40, $FF, $40, $FF, $40, $FF, $40, $FF	; tile #170
	.byt $60, $DF, $60, $C0, $60, $DF, $60, $DF	; tile #171
	.byt $40, $FF, $40, $C0, $FC, $FC, $40, $FF	; tile #172
	.byt $40, $FF, $40, $C0, $40, $C0, $40, $FF	; tile #173
	.byt $40, $FF, $40, $C0, $CF, $CF, $40, $FF	; tile #174
	.byt $41, $FE, $41, $C0, $41, $FE, $41, $FE	; tile #175
	.byt $60, $DF, $60, $57, $5F, $5D, $5F, $57	; tile #176
	.byt $40, $FF, $40, $5D, $7F, $77, $7F, $5D	; tile #177
	.byt $40, $FF, $40, $77, $7F, $5D, $7F, $77	; tile #178
	.byt $41, $FE, $41, $76, $7E, $5C, $7E, $76	; tile #179
	.byt $60, $DF, $60, $C0, $DC, $DC, $60, $DF	; tile #180
	.byt $41, $FE, $41, $C0, $CE, $CE, $41, $FE	; tile #181
	.byt $C0, $7F, $C0, $7F, $C0, $7F, $40, $40	; tile #182
	.byt $C1, $7E, $C1, $7E, $C1, $7E, $40, $40	; tile #183
	.byt $C3, $7C, $C3, $7C, $C3, $7C, $40, $40	; tile #184
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $7C, $40	; tile #185
	.byt $7E, $5C, $7E, $76, $7C, $51, $6A, $55	; tile #186
	.byt $40, $FF, $40, $FF, $40, $61, $6A, $55	; tile #187
	.byt $60, $55, $4A, $55, $4A, $55, $6A, $55	; tile #188
	.byt $40, $55, $6A, $55, $6A, $55, $6A, $55	; tile #189
	.byt $41, $54, $6A, $54, $6A, $55, $6A, $55	; tile #190
	.byt $40, $55, $4A, $55, $6A, $55, $6A, $55	; tile #191
	.byt $40, $54, $6A, $54, $6A, $55, $6A, $55	; tile #192
	.byt $60, $55, $4A, $55, $6A, $55, $6A, $55	; tile #193
	.byt $43, $53, $68, $55, $6A, $55, $6A, $55	; tile #194
	.byt $4C, $4C, $4C, $40, $6A, $55, $6A, $55	; tile #195
	.byt $40, $40, $60, $54, $6A, $55, $6A, $55	; tile #196
	.byt $70, $71, $72, $41, $6A, $55, $6A, $55	; tile #197
	.byt $7E, $5C, $66, $56, $6A, $54, $68, $54	; tile #198
	.byt $60, $40, $40, $40, $40, $40, $40, $40	; tile #199
	.byt $58, $40, $40, $40, $40, $40, $40, $40	; tile #200
	.byt $7F, $5D, $7F, $77, $7F, $5D, $7E, $75	; tile #201
	.byt $7E, $75, $7A, $55, $6A, $55, $6A, $55	; tile #202
	.byt $6A, $55, $6A, $55, $6A, $55, $6A, $55	; tile #203
	.byt $68, $54, $68, $54, $68, $54, $68, $54	; tile #204
	.byt $7F, $77, $7F, $5D, $7E, $75, $7A, $55	; tile #205
	.byt $7A, $55, $6A, $55, $6A, $55, $6A, $55	; tile #206
	.byt $6A, $55, $6A, $55, $6A, $55, $6A, $50	; tile #207
	.byt $6A, $55, $6A, $55, $6A, $54, $40, $40	; tile #208
	.byt $6A, $55, $6A, $55, $6A, $40, $40, $40	; tile #209
	.byt $68, $54, $68, $54, $68, $40, $40, $40	; tile #210
	.byt $7F, $5D, $7E, $75, $7A, $55, $6A, $55	; tile #211
	.byt $6A, $55, $68, $50, $60, $50, $60, $50	; tile #212
	.byt $6A, $50, $40, $40, $40, $40, $40, $40	; tile #213
zplane0_data
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 012
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 013
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 008, 006
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 009, 006
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 010, 006
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 003, 007, 011, 006
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 001, 004, 006, 006, 006
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 005, 006, 006, 006
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 002, 006, 006, 006, 006
zplane0_tiles
	.byt $40, $40, $40, $40, $40, $40, $4F, $4F	; tile #1
	.byt $40, $40, $40, $40, $40, $40, $43, $7F	; tile #2
	.byt $40, $41, $41, $41, $41, $43, $43, $43	; tile #3
	.byt $5F, $7F, $7F, $7F, $7F, $7F, $7F, $7F	; tile #4
	.byt $67, $7F, $7F, $7F, $7F, $7F, $7F, $7F	; tile #5
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F	; tile #6
	.byt $43, $43, $43, $43, $43, $43, $43, $43	; tile #7
	.byt $40, $40, $40, $40, $40, $40, $41, $4F	; tile #8
	.byt $40, $40, $40, $40, $40, $43, $7F, $7F	; tile #9
	.byt $40, $40, $40, $40, $40, $7F, $7F, $7F	; tile #10
	.byt $43, $43, $43, $43, $43, $7F, $7F, $7F	; tile #11
	.byt $40, $40, $47, $4F, $4F, $4F, $4F, $4F	; tile #12
	.byt $41, $4F, $7F, $7F, $7F, $7F, $7F, $7F	; tile #13	
; Walkbox Data
wb_data
	.byt 001, 030, 014, 016, $21
; Walk matrix
wb_matrix
	.byt 0


res_end
.)

; Object resource: Exit door
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 200
res_start
	.byt OBJ_FLAG_PROP	; If OBJ_FLAG_PROP skip all costume data
	.byt 38,1		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 1,16		; Pos (col, row)
	.byt ZPLANE_0		; Zplane
	.byt 12,16		; Walk position (col, row)
	.byt FACING_DOWN	; Facing direction for interaction
	.byt 00			; Color of text

	; tiles and pointers to animatory states are setup in the costume
	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	;.byt 0		; costume ($ff for none) and skip the rest
	;.byt 0			; entry in costume resource		
	;.byt 0			; direction (0 or LOOK_RIGHT for animstate 0)
	;.byt 0			; animation speed	
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

; Object resource: Donkey Kong poster
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 201
res_start
	.byt OBJ_FLAG_PROP	; If OBJ_FLAG_PROP skip all costume data
	.byt 4,4		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 15,6		; Pos (col, row)
	.byt ZPLANE_0		; Zplane
	.byt 15,15		; Walk position (col, row)
	.byt FACING_RIGHT	; Facing direction for interaction
	.byt 00			; Color of text

	; tiles and pointers to animatory states are setup in the costume
	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	;.byt 0		; costume ($ff for none) and skip the rest
	;.byt 0			; entry in costume resource		
	;.byt 0			; direction (0 or LOOK_RIGHT for animstate 0)
	;.byt 0			; animation speed	
#ifdef ENGLISH
	.asc "Poster",0
#endif
#ifdef SPANISH
	.asc "P","Z"+4,"ster",0
#endif
#ifdef FRENCH
	.asc "Affiche",0
#endif
res_end	
.)

; Object resource: Computer
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 202
res_start
	.byt OBJ_FLAG_PROP	; If OBJ_FLAG_PROP skip all costume data
	.byt 6,3		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 10,10		; Pos (col, row)
	.byt ZPLANE_0		; Zplane
	.byt 10,15		; Walk position (col, row)
	.byt FACING_UP		; Facing direction for interaction
	.byt 00			; Color of text

	; tiles and pointers to animatory states are setup in the costume
	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	;.byt 0		; costume ($ff for none) and skip the rest
	;.byt 0			; entry in costume resource		
	;.byt 0			; direction (0 or LOOK_RIGHT for animstate 0)
	;.byt 0			; animation speed	
#ifdef ENGLISH
	.asc "Computer",0
#endif
#ifdef SPANISH
	.asc "Computadora",0
#endif
#ifdef FRENCH
	.asc "Ordinateur",0
#endif
res_end	
.)


; Object resource: Printer
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 203
res_start
	.byt 0;OBJ_FLAG_PROP	; If OBJ_FLAG_PROP skip all costume data
	.byt 2,1		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 19,10		; Pos (col, row)
	.byt ZPLANE_0		; Zplane
	.byt 21,15		; Walk position (col, row)
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
	.asc "Printer",0
#endif
#ifdef SPANISH
	.asc "Impresora",0
#endif
#ifdef FRENCH
	.asc "Imprimante",0
#endif
res_end	
.)

; Object resource: Books
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 204
res_start
	.byt OBJ_FLAG_PROP	; If OBJ_FLAG_PROP skip all costume data
	.byt 7,2		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 25,4		; Pos (col, row)
	.byt ZPLANE_0		; Zplane
	.byt 26,15		; Walk position (col, row)
	.byt FACING_UP		; Facing direction for interaction
	.byt 00			; Color of text

	; tiles and pointers to animatory states are setup in the costume
	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	;.byt 0		; costume ($ff for none) and skip the rest
	;.byt 0			; entry in costume resource		
	;.byt 0			; direction (0 or LOOK_RIGHT for animstate 0)
	;.byt 0			; animation speed	
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



; Object resource: Boxes
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 205
res_start
	.byt OBJ_FLAG_PROP	; If OBJ_FLAG_PROP skip all costume data
	.byt 7,2		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 25,6		; Pos (col, row)
	.byt ZPLANE_0		; Zplane
	.byt 26,15		; Walk position (col, row)
	.byt FACING_UP		; Facing direction for interaction
	.byt 00			; Color of text

	; tiles and pointers to animatory states are setup in the costume
	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	;.byt 0		; costume ($ff for none) and skip the rest
	;.byt 0			; entry in costume resource		
	;.byt 0			; direction (0 or LOOK_RIGHT for animstate 0)
	;.byt 0			; animation speed	
#ifdef ENGLISH
	.asc "Boxes",0
#endif
#ifdef SPANISH
	.asc "Cajas",0
#endif
#ifdef FRENCH
	.asc "Bo","Z"+4,"tes",0 ; "Boîtes" -  NB: des boites, et non pas des caisses
#endif
res_end	
.)

; Object resource: Mugs
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 206
res_start
	.byt OBJ_FLAG_PROP	; If OBJ_FLAG_PROP skip all costume data
	.byt 7,4		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 25,10		; Pos (col, row)
	.byt ZPLANE_0		; Zplane
	.byt 26,15		; Walk position (col, row)
	.byt FACING_UP		; Facing direction for interaction
	.byt 00			; Color of text

	; tiles and pointers to animatory states are setup in the costume
	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	;.byt 0		; costume ($ff for none) and skip the rest
	;.byt 0			; entry in costume resource		
	;.byt 0			; direction (0 or LOOK_RIGHT for animstate 0)
	;.byt 0			; animation speed	
#ifdef ENGLISH
	.asc "Mugs",0
#endif
#ifdef SPANISH
	.asc "Tazas",0
#endif
#ifdef FRENCH
	.asc "Mugs",0
#endif
res_end	
.)

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
; Animatory state 0 (0-off.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 1, 2, 0, 0, 0
; Animatory state 1 (1-on.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 3, 2, 0, 0, 0
costume_tiles
; Tile graphic 1
.byt $0, $0, $f, $0, $0, $0, $0, $0
; Tile graphic 2
.byt $0, $0, $2a, $0, $0, $0, $0, $0
; Tile graphic 3
.byt $0, $0, $f, $0, $0, $c, $0, $0
costume_masks
; Tile mask 1
.byt $ff, $40, $40, $40, $40, $40, $40, $ff
; Tile mask 2
.byt $ff, $40, $40, $40, $40, $40, $40, $ff
; Tile mask 3
.byt $ff, $40, $40, $40, $40, $40, $40, $ff
res_end
.)




#include "..\scripts\maproom.s"


