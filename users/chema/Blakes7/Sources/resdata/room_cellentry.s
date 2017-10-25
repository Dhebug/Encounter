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
; Room: Cell zone
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.(
	.byt RESOURCE_ROOM
	.word (res_end - res_start + 4)
	.byt 53
res_start
; No. columns, offset to tile map, offset to tiles
	.byt 38, <(column_data-res_start), >(column_data-res_start), <(tiles_start-res_start), >(tiles_start-res_start)
; No. zplanes and offsets to zplanes
	.byt 1
	.byt <(zplane0_data-res_start), >(zplane0_data-res_start), <(zplane0_tiles-res_start), >(zplane0_tiles-res_start)	
; No. Walkboxes and offsets to wb data and matrix
	.byt 6, <(wb_data-res_start), >(wb_data-res_start), <(wb_matrix-res_start), >(wb_matrix-res_start)
; Offset to palette
	.byt 0, 0	; No palette information
; Entry and exit scripts
	.byt 200, 201
; Number of objects in the room and list of ids
	.byt 3,200,201,202
; Room name (null terminated)
	.asc "Cells", 0
; Room tile map
column_data
	.byt 001, 001, 001, 001, 001, 059, 085, 079, 079, 140, 149, 149, 194, 137, 137, 137, 137
	.byt 002, 002, 002, 002, 038, 060, 071, 079, 079, 141, 148, 148, 195, 137, 137, 137, 137
	.byt 001, 001, 001, 001, 039, 061, 086, 079, 079, 142, 149, 149, 196, 137, 137, 137, 137
	.byt 002, 002, 002, 002, 002, 062, 087, 079, 079, 143, 161, 148, 197, 137, 137, 137, 137
	.byt 001, 001, 001, 001, 001, 063, 072, 090, 090, 090, 090, 090, 198, 137, 137, 137, 137
	.byt 002, 002, 002, 002, 002, 002, 002, 002, 002, 144, 162, 002, 199, 137, 137, 137, 137
	.byt 001, 001, 001, 001, 040, 064, 064, 064, 010, 145, 113, 183, 200, 137, 137, 137, 137
	.byt 002, 002, 002, 002, 041, 065, 065, 103, 122, 146, 163, 184, 137, 137, 137, 137, 137
	.byt 001, 001, 001, 001, 042, 066, 066, 066, 123, 079, 164, 185, 137, 137, 137, 137, 137
	.byt 002, 002, 002, 002, 002, 067, 088, 088, 088, 147, 165, 186, 137, 137, 137, 137, 137
	.byt 001, 001, 001, 001, 001, 068, 089, 089, 124, 089, 089, 187, 137, 137, 137, 137, 137
	.byt 002, 002, 002, 002, 043, 069, 079, 079, 125, 148, 148, 188, 137, 137, 137, 137, 137
	.byt 001, 001, 001, 026, 044, 070, 079, 079, 126, 149, 166, 189, 137, 137, 137, 137, 137
	.byt 002, 002, 002, 002, 045, 071, 079, 079, 127, 148, 167, 137, 137, 137, 137, 137, 137
	.byt 001, 001, 001, 001, 046, 072, 090, 090, 090, 090, 168, 190, 137, 137, 137, 137, 137
	.byt 002, 002, 002, 002, 002, 002, 002, 104, 088, 150, 169, 137, 137, 137, 137, 137, 137
	.byt 001, 001, 001, 001, 001, 001, 001, 105, 079, 151, 170, 137, 137, 137, 137, 137, 137
	.byt 002, 002, 002, 002, 002, 002, 002, 106, 079, 152, 171, 137, 137, 137, 137, 137, 137
	.byt 001, 001, 001, 001, 001, 001, 001, 107, 079, 153, 172, 137, 137, 137, 137, 137, 137
	.byt 003, 003, 003, 003, 003, 003, 003, 108, 128, 154, 137, 137, 137, 137, 137, 137, 137
	.byt 004, 004, 004, 004, 004, 004, 004, 004, 004, 004, 173, 137, 137, 137, 137, 137, 137
	.byt 004, 004, 018, 027, 047, 004, 004, 004, 004, 004, 174, 137, 137, 137, 137, 137, 137
	.byt 005, 012, 019, 028, 048, 073, 091, 004, 004, 004, 175, 137, 137, 137, 137, 137, 137
	.byt 006, 013, 007, 029, 049, 074, 048, 109, 129, 004, 176, 137, 137, 137, 137, 137, 137
	.byt 007, 014, 020, 030, 050, 075, 092, 074, 130, 155, 177, 191, 137, 137, 137, 137, 137
	.byt 008, 015, 021, 031, 051, 076, 093, 110, 131, 156, 178, 192, 137, 137, 137, 137, 137
	.byt 009, 016, 001, 001, 001, 077, 094, 111, 132, 157, 179, 137, 137, 137, 137, 137, 137
	.byt 002, 002, 002, 002, 002, 002, 095, 112, 133, 158, 180, 137, 137, 137, 137, 137, 137
	.byt 001, 001, 001, 001, 001, 001, 096, 113, 134, 159, 181, 137, 137, 137, 137, 137, 137
	.byt 002, 002, 002, 002, 002, 002, 097, 114, 119, 137, 137, 137, 137, 137, 137, 137, 137
	.byt 001, 001, 001, 032, 052, 052, 052, 052, 135, 137, 137, 137, 137, 137, 137, 137, 137
	.byt 002, 002, 002, 033, 053, 078, 078, 115, 136, 137, 137, 137, 137, 137, 137, 137, 137
	.byt 001, 001, 022, 034, 054, 079, 098, 116, 137, 137, 137, 137, 137, 137, 137, 137, 137
	.byt 002, 002, 023, 035, 055, 080, 099, 117, 137, 137, 137, 193, 201, 137, 137, 137, 137
	.byt 010, 001, 001, 036, 056, 081, 056, 118, 137, 137, 182, 121, 202, 137, 137, 137, 137
	.byt 011, 017, 024, 003, 003, 082, 100, 119, 138, 160, 004, 004, 203, 137, 137, 137, 137
	.byt 004, 004, 025, 037, 057, 083, 101, 120, 139, 004, 004, 004, 204, 191, 137, 137, 137
	.byt 004, 004, 004, 004, 058, 084, 102, 121, 004, 004, 004, 004, 004, 173, 137, 137, 137

; Room tile set
tiles_start
	.byt $77, $7F, $5D, $7F, $77, $7F, $5D, $7F	; tile #1
	.byt $5D, $7F, $77, $7F, $5D, $7F, $77, $7F	; tile #2
	.byt $5C, $7E, $76, $7E, $5C, $7E, $76, $7E	; tile #3
	.byt $40, $6A, $40, $6A, $40, $6A, $40, $6A	; tile #4
	.byt $40, $6A, $40, $6A, $40, $69, $41, $69	; tile #5
	.byt $5F, $55, $7F, $55, $7F, $55, $7F, $55	; tile #6
	.byt $7C, $54, $7C, $50, $78, $50, $70, $50	; tile #7
	.byt $47, $45, $47, $45, $4F, $45, $5F, $55	; tile #8
	.byt $7F, $54, $7E, $55, $7D, $53, $79, $53	; tile #9
	.byt $76, $7F, $5D, $7F, $77, $7F, $5D, $7F	; tile #10
	.byt $40, $4A, $40, $6A, $40, $6A, $70, $72	; tile #11
	.byt $43, $69, $43, $65, $47, $65, $4F, $65	; tile #12
	.byt $7F, $55, $7F, $55, $7F, $55, $7E, $54	; tile #13
	.byt $70, $40, $60, $41, $41, $41, $43, $41	; tile #14
	.byt $5F, $55, $7F, $55, $7F, $55, $7F, $54	; tile #15
	.byt $77, $57, $6D, $4F, $57, $5F, $5D, $7F	; tile #16
	.byt $58, $7A, $70, $7C, $5C, $7C, $76, $7E	; tile #17
	.byt $40, $6A, $40, $6A, $40, $6A, $41, $69	; tile #18
	.byt $5F, $55, $5F, $55, $7F, $55, $7F, $55	; tile #19
	.byt $43, $45, $47, $45, $4F, $45, $5F, $55	; tile #20
	.byt $7E, $55, $7D, $55, $79, $53, $77, $57	; tile #21
	.byt $77, $7F, $5E, $7F, $7B, $7F, $5E, $7F	; tile #22
	.byt $7D, $5F, $57, $5F, $5D, $5F, $4F, $7F	; tile #23
	.byt $5D, $7F, $77, $7E, $5C, $7E, $76, $7E	; tile #24
	.byt $40, $6A, $40, $4A, $60, $6A, $70, $72	; tile #25
	.byt $77, $7F, $5D, $7F, $63, $5D, $7D, $63	; tile #26
	.byt $41, $69, $43, $69, $47, $65, $4F, $60	; tile #27
	.byt $7F, $55, $7F, $55, $7F, $55, $60, $55	; tile #28
	.byt $60, $40, $60, $41, $41, $41, $40, $41	; tile #29
	.byt $5F, $55, $7F, $55, $7F, $40, $7F, $55	; tile #30
	.byt $6D, $4F, $67, $5F, $5D, $5F, $57, $5F	; tile #31
	.byt $77, $7F, $5D, $7F, $77, $7E, $5D, $7D	; tile #32
	.byt $5D, $7F, $77, $60, $5F, $5F, $5C, $59	; tile #33
	.byt $77, $7F, $5C, $41, $7F, $7F, $40, $7F	; tile #34
	.byt $5D, $7F, $40, $7F, $7F, $40, $7F, $7F	; tile #35
	.byt $77, $7F, $41, $7E, $7E, $46, $72, $72	; tile #36
	.byt $78, $7D, $7C, $7D, $7C, $7C, $7C, $7C	; tile #37
	.byt $58, $7F, $7F, $7C, $5F, $7B, $7C, $7F	; tile #38
	.byt $4F, $6F, $5D, $5F, $6F, $6F, $5D, $7F	; tile #39
	.byt $77, $7F, $5D, $7F, $77, $7F, $5D, $7E	; tile #40
	.byt $5D, $7F, $77, $7F, $5D, $7F, $40, $C2	; tile #41
	.byt $77, $7F, $5D, $7F, $77, $7F, $7D, $5F	; tile #42
	.byt $5D, $7F, $77, $7F, $5D, $7F, $77, $78	; tile #43
	.byt $5F, $41, $7F, $7F, $77, $7F, $5D, $40	; tile #44
	.byt $5D, $7F, $77, $7F, $5D, $7F, $60, $5F	; tile #45
	.byt $77, $7F, $5D, $7F, $77, $7F, $41, $7E	; tile #46
	.byt $47, $65, $43, $69, $41, $69, $41, $6A	; tile #47
	.byt $7F, $55, $7F, $55, $7F, $55, $7F, $55	; tile #48
	.byt $60, $40, $70, $50, $78, $50, $78, $54	; tile #49
	.byt $7F, $55, $7F, $55, $5F, $45, $4F, $45	; tile #50
	.byt $5D, $4F, $67, $57, $75, $53, $7B, $53	; tile #51
	.byt $75, $7D, $5D, $7D, $75, $7D, $5D, $7D	; tile #52
	.byt $5A, $5B, $5B, $5B, $5B, $5B, $5B, $5B	; tile #53
	.byt $7F, $5F, $6F, $73, $7D, $7E, $7F, $7F	; tile #54
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $4F, $77	; tile #55
	.byt $72, $72, $72, $72, $72, $72, $72, $72	; tile #56
	.byt $7C, $7C, $7C, $7C, $7C, $7C, $7C, $42	; tile #57
	.byt $40, $4A, $60, $6A, $50, $52, $60, $5A	; tile #58
	.byt $77, $7F, $5D, $7F, $77, $7F, $40, $7F	; tile #59
	.byt $5D, $7F, $77, $7F, $5D, $7C, $43, $7F	; tile #60
	.byt $77, $7F, $5D, $7F, $77, $40, $7F, $7F	; tile #61
	.byt $5D, $7F, $77, $7F, $50, $4F, $7F, $7F	; tile #62
	.byt $77, $7F, $5D, $7F, $41, $7E, $7E, $7E	; tile #63
	.byt $76, $7E, $5C, $7E, $76, $7E, $5C, $7E	; tile #64
	.byt $C3, $C2, $C3, $C2, $C3, $C2, $C3, $C2	; tile #65
	.byt $57, $5F, $5D, $5F, $57, $5F, $5D, $5F	; tile #66
	.byt $5D, $7E, $75, $7D, $5D, $7D, $75, $7D	; tile #67
	.byt $60, $5F, $5F, $5F, $5F, $5E, $5D, $5D	; tile #68
	.byt $47, $7F, $7F, $7F, $70, $4F, $7F, $7F	; tile #69
	.byt $7F, $7F, $7F, $7F, $40, $7F, $7F, $7F	; tile #70
	.byt $7F, $7F, $7F, $40, $7F, $7F, $7F, $7F	; tile #71
	.byt $7E, $7E, $7E, $4E, $56, $56, $56, $56	; tile #72
	.byt $7F, $55, $5F, $65, $4F, $65, $47, $65	; tile #73
	.byt $7C, $54, $7E, $54, $7F, $55, $7F, $55	; tile #74
	.byt $47, $45, $43, $41, $43, $41, $41, $40	; tile #75
	.byt $7D, $55, $7E, $54, $7F, $55, $7F, $55	; tile #76
	.byt $77, $7F, $5D, $7F, $57, $5F, $5D, $4F	; tile #77
	.byt $5B, $5B, $5B, $5B, $5B, $5B, $5B, $5B	; tile #78
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F	; tile #79
	.byt $7B, $7D, $7E, $7F, $7F, $7F, $7E, $7E	; tile #80
	.byt $72, $72, $52, $62, $62, $52, $72, $72	; tile #81
	.byt $5C, $7F, $77, $7F, $5D, $7C, $73, $7B	; tile #82
	.byt $7C, $43, $5D, $7F, $60, $5F, $7F, $7F	; tile #83
	.byt $50, $70, $70, $42, $7C, $7E, $7E, $7E	; tile #84
	.byt $7F, $7F, $7F, $7C, $43, $7F, $7F, $7F	; tile #85
	.byt $7F, $7F, $7E, $41, $7F, $7F, $7F, $7F	; tile #86
	.byt $7F, $7F, $40, $7F, $7F, $7F, $7F, $7F	; tile #87
	.byt $5D, $7D, $75, $7D, $5D, $7D, $75, $7D	; tile #88
	.byt $5D, $5D, $5D, $5D, $5D, $5D, $5D, $5D	; tile #89
	.byt $56, $56, $56, $56, $56, $56, $56, $56	; tile #90
	.byt $43, $69, $43, $69, $41, $6A, $40, $6A	; tile #91
	.byt $60, $50, $70, $50, $78, $50, $78, $54	; tile #92
	.byt $7F, $55, $5F, $55, $5F, $45, $4F, $45	; tile #93
	.byt $67, $57, $75, $57, $78, $53, $7D, $55	; tile #94
	.byt $5D, $7F, $76, $41, $7F, $7F, $7F, $7F	; tile #95
	.byt $77, $7E, $41, $7F, $7F, $7F, $7F, $7F	; tile #96
	.byt $5D, $43, $7D, $7D, $7D, $7D, $7D, $7D	; tile #97
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $7E, $7D	; tile #98
	.byt $7D, $7B, $77, $6F, $5F, $5F, $7F, $7F	; tile #99
	.byt $5B, $7B, $73, $7B, $5B, $7B, $74, $7F	; tile #100
	.byt $7F, $7F, $7F, $7F, $7E, $61, $5D, $7F	; tile #101
	.byt $7E, $7E, $7E, $7C, $40, $7A, $70, $72	; tile #102
	.byt $C3, $C2, $C3, $C2, $C3, $C2, $C3, $41	; tile #103
	.byt $5D, $7F, $77, $7F, $5D, $7F, $76, $7D	; tile #104
	.byt $77, $7F, $5D, $7F, $77, $7C, $43, $7F	; tile #105
	.byt $5D, $7F, $77, $7F, $5D, $40, $7F, $7F	; tile #106
	.byt $77, $7F, $5D, $7F, $40, $7F, $7F, $7F	; tile #107
	.byt $5C, $7E, $76, $7E, $5C, $6E, $66, $6E	; tile #108
	.byt $5F, $55, $4F, $65, $47, $65, $47, $69	; tile #109
	.byt $47, $45, $43, $41, $41, $41, $61, $40	; tile #110
	.byt $7E, $54, $7E, $55, $7F, $55, $7F, $55	; tile #111
	.byt $7F, $7F, $7F, $5F, $5F, $4F, $6F, $4F	; tile #112
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $7E, $41	; tile #113
	.byt $7D, $7D, $7D, $7D, $7D, $7D, $43, $7F	; tile #114
	.byt $5B, $5B, $5B, $5B, $5B, $5A, $59, $58	; tile #115
	.byt $7B, $77, $6F, $6F, $5F, $7F, $60, $5F	; tile #116
	.byt $7F, $7F, $7F, $7F, $7C, $43, $55, $7F	; tile #117
	.byt $72, $72, $72, $72, $42, $72, $51, $7F	; tile #118
	.byt $5D, $7F, $70, $4F, $55, $7F, $55, $7F	; tile #119
	.byt $76, $41, $55, $7E, $54, $7C, $54, $7A	; tile #120
	.byt $40, $4A, $40, $6A, $40, $6A, $40, $6A	; tile #121
	.byt $7C, $43, $77, $7F, $5D, $7F, $77, $7C	; tile #122
	.byt $77, $7F, $5D, $7F, $77, $7F, $5D, $40	; tile #123
	.byt $5C, $5D, $5D, $5D, $5D, $5D, $5D, $5D	; tile #124
	.byt $43, $74, $7F, $5D, $7F, $77, $7F, $5D	; tile #125
	.byt $7F, $47, $78, $77, $7F, $5D, $7F, $77	; tile #126
	.byt $7F, $7F, $47, $58, $7F, $77, $7F, $5D	; tile #127
	.byt $6C, $6E, $66, $6E, $6C, $6E, $66, $6E	; tile #128
	.byt $43, $69, $41, $6A, $40, $6A, $40, $6A	; tile #129
	.byt $7F, $55, $7F, $55, $7F, $55, $5F, $55	; tile #130
	.byt $60, $50, $70, $50, $78, $50, $7C, $54	; tile #131
	.byt $7F, $55, $5F, $55, $4F, $45, $4F, $45	; tile #132
	.byt $70, $57, $7B, $53, $7D, $54, $7D, $54	; tile #133
	.byt $77, $7F, $5D, $7C, $41, $7F, $55, $7F	; tile #134
	.byt $75, $42, $55, $7F, $55, $7F, $55, $7F	; tile #135
	.byt $59, $5B, $45, $7F, $55, $7F, $55, $7F	; tile #136
	.byt $55, $7F, $55, $7F, $55, $7F, $55, $7F	; tile #137
	.byt $55, $7F, $55, $7F, $55, $7E, $54, $7C	; tile #138
	.byt $50, $72, $40, $6A, $40, $6A, $40, $6A	; tile #139
	.byt $7F, $7F, $7F, $4F, $70, $5D, $7F, $77	; tile #140
	.byt $7F, $7F, $7F, $7F, $5F, $61, $7E, $5D	; tile #141
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $43, $74	; tile #142
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $7F, $4F	; tile #143
	.byt $5D, $7C, $73, $7B, $5B, $7B, $73, $7B	; tile #144
	.byt $74, $43, $7F, $7F, $7F, $7F, $7F, $7F	; tile #145
	.byt $43, $7F, $7F, $7F, $7F, $7F, $7F, $7F	; tile #146
	.byt $5D, $5D, $55, $5D, $5D, $5D, $55, $5D	; tile #147
	.byt $7F, $77, $7F, $5D, $7F, $77, $7F, $5D	; tile #148
	.byt $7F, $5D, $7F, $77, $7F, $5D, $7F, $77	; tile #149
	.byt $5D, $7D, $75, $7D, $5E, $7F, $77, $7F	; tile #150
	.byt $7F, $7F, $7F, $7F, $40, $7F, $5D, $7F	; tile #151
	.byt $7F, $7F, $7E, $41, $7D, $7F, $77, $7F	; tile #152
	.byt $7F, $7E, $41, $7F, $77, $7F, $5D, $7F	; tile #153
	.byt $6C, $5E, $76, $7E, $5C, $7E, $76, $40	; tile #154
	.byt $4F, $65, $4F, $65, $47, $69, $43, $69	; tile #155
	.byt $7C, $54, $7E, $55, $7F, $55, $7F, $55	; tile #156
	.byt $47, $41, $43, $41, $41, $41, $60, $40	; tile #157
	.byt $7E, $55, $7F, $55, $7F, $55, $7F, $55	; tile #158
	.byt $55, $5F, $55, $4F, $65, $4F, $75, $57	; tile #159
	.byt $54, $7A, $50, $72, $40, $6A, $40, $4A	; tile #160
	.byt $70, $77, $7F, $5D, $7F, $77, $7F, $5D	; tile #161
	.byt $5B, $7B, $73, $7B, $5B, $7B, $73, $7C	; tile #162
	.byt $7F, $7F, $7F, $7F, $7F, $7C, $43, $7F	; tile #163
	.byt $7F, $7F, $7F, $7F, $7C, $43, $5D, $7F	; tile #164
	.byt $5D, $5D, $55, $5D, $5D, $7D, $75, $7D	; tile #165
	.byt $7F, $5D, $7F, $77, $7F, $5D, $7F, $74	; tile #166
	.byt $7F, $77, $7F, $5D, $7F, $77, $70, $4F	; tile #167
	.byt $56, $56, $56, $56, $56, $56, $56, $66	; tile #168
	.byt $5D, $7F, $77, $7C, $41, $7F, $55, $7F	; tile #169
	.byt $77, $7F, $58, $47, $55, $7F, $55, $7F	; tile #170
	.byt $5D, $70, $45, $7F, $55, $7F, $55, $7F	; tile #171
	.byt $60, $5F, $55, $7F, $55, $7F, $55, $7F	; tile #172
	.byt $40, $7C, $55, $7F, $55, $7F, $55, $7F	; tile #173
	.byt $40, $4A, $40, $7E, $55, $7F, $55, $7F	; tile #174
	.byt $40, $6A, $40, $4A, $40, $7F, $55, $7F	; tile #175
	.byt $40, $6A, $40, $6A, $40, $42, $54, $7F	; tile #176
	.byt $41, $69, $40, $6A, $40, $6A, $41, $70	; tile #177
	.byt $7F, $55, $7F, $55, $5F, $55, $4F, $65	; tile #178
	.byt $60, $50, $70, $50, $78, $50, $7C, $43	; tile #179
	.byt $7F, $55, $5F, $55, $4F, $40, $45, $7F	; tile #180
	.byt $79, $53, $7D, $55, $41, $7F, $55, $7F	; tile #181
	.byt $54, $7C, $54, $7A, $50, $72, $50, $6A	; tile #182
	.byt $77, $7F, $5D, $7F, $77, $7F, $5D, $70	; tile #183
	.byt $5D, $7F, $77, $7F, $5D, $7E, $61, $5F	; tile #184
	.byt $77, $7F, $5D, $7F, $74, $43, $55, $7F	; tile #185
	.byt $5D, $7D, $75, $79, $44, $7F, $55, $7F	; tile #186
	.byt $5D, $5D, $5C, $5D, $5D, $43, $55, $7F	; tile #187
	.byt $7E, $41, $55, $7F, $55, $7F, $55, $7F	; tile #188
	.byt $41, $7F, $55, $7F, $55, $7F, $55, $7F	; tile #189
	.byt $51, $7F, $55, $7F, $55, $7F, $55, $7F	; tile #190
	.byt $54, $7F, $55, $7F, $55, $7F, $55, $7F	; tile #191
	.byt $40, $7F, $55, $7F, $55, $7F, $55, $7F	; tile #192
	.byt $55, $7F, $54, $7E, $54, $7A, $50, $72	; tile #193
	.byt $7F, $5D, $7F, $77, $7F, $5D, $7E, $41	; tile #194
	.byt $7F, $77, $7F, $5D, $7F, $74, $41, $7F	; tile #195
	.byt $7F, $5D, $7F, $77, $78, $47, $55, $7F	; tile #196
	.byt $7F, $77, $7F, $40, $55, $7F, $55, $7F	; tile #197
	.byt $56, $56, $56, $56, $56, $66, $51, $7F	; tile #198
	.byt $58, $47, $55, $7F, $55, $7F, $55, $7F	; tile #199
	.byt $45, $7F, $55, $7F, $55, $7F, $55, $7F	; tile #200
	.byt $50, $6A, $40, $60, $54, $7F, $55, $7F	; tile #201
	.byt $40, $6A, $40, $6A, $40, $78, $55, $7F	; tile #202
	.byt $40, $6A, $40, $6A, $40, $4A, $50, $7F	; tile #203
	.byt $40, $6A, $40, $6A, $40, $6A, $40, $62	; tile #204
; Walkbox Data
wb_data
	.byt 000, 037, 013, 016, $02
	.byt 006, 031, 012, 012, $02
	.byt 012, 029, 011, 011, $02
	.byt 029, 029, 010, 010, $02
	.byt 027, 033, 009, 009, $01
	.byt 028, 033, 008, 008, $01
; Walk matrix
wb_matrix
	.byt 0, 1, 1, 1, 1, 1
	.byt 0, 1, 2, 2, 2, 2
	.byt 1, 1, 2, 3, 3, 3
	.byt 2, 2, 2, 3, 4, 4
	.byt 3, 3, 3, 3, 4, 5
	.byt 4, 4, 4, 4, 4, 5
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
	.byt 001, 001, 008, 010, 012, 014, 001, 001, 001, 001, 001, 000, 000, 000, 000, 000, 000
	.byt 002, 006, 000, 000, 000, 015, 017, 001, 001, 001, 027, 000, 000, 000, 000, 000, 000
	.byt 003, 000, 000, 000, 000, 000, 000, 019, 022, 001, 028, 000, 000, 000, 000, 000, 000
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 025, 029, 000, 000, 000, 000, 000, 000
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 031, 032, 000, 000, 000, 000
	.byt 004, 000, 000, 000, 000, 000, 000, 000, 000, 000, 030, 001, 033, 000, 000, 000, 000
	.byt 005, 007, 000, 000, 000, 000, 000, 000, 023, 026, 001, 001, 034, 000, 000, 000, 000
	.byt 001, 001, 009, 011, 004, 000, 000, 020, 024, 001, 001, 001, 035, 000, 000, 000, 000
	.byt 001, 001, 001, 001, 013, 016, 018, 021, 001, 001, 001, 001, 001, 036, 000, 000, 000
zplane0_tiles
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F	; tile #1
	.byt $7F, $7F, $7F, $7E, $7E, $7C, $7C, $7C	; tile #2
	.byt $60, $40, $40, $40, $40, $40, $40, $40	; tile #3
	.byt $41, $40, $40, $40, $40, $40, $40, $40	; tile #4
	.byt $7F, $7F, $7F, $5F, $5F, $5F, $4F, $4F	; tile #5
	.byt $78, $78, $70, $70, $60, $60, $60, $40	; tile #6
	.byt $47, $47, $47, $43, $43, $43, $41, $41	; tile #7
	.byt $7F, $7E, $7E, $7E, $7C, $7C, $78, $78	; tile #8
	.byt $7F, $7F, $5F, $5F, $5F, $5F, $4F, $4F	; tile #9
	.byt $70, $70, $70, $60, $60, $60, $60, $60	; tile #10
	.byt $47, $47, $47, $43, $43, $43, $43, $41	; tile #11
	.byt $60, $70, $70, $78, $78, $7C, $7C, $7C	; tile #12
	.byt $7F, $7F, $7F, $5F, $5F, $4F, $4F, $4F	; tile #13
	.byt $7E, $7E, $7F, $7F, $7F, $7F, $7F, $7F	; tile #14
	.byt $40, $40, $40, $40, $60, $60, $60, $70	; tile #15
	.byt $47, $47, $47, $47, $43, $41, $41, $41	; tile #16
	.byt $70, $78, $78, $78, $7C, $7C, $7E, $7E	; tile #17
	.byt $41, $41, $41, $43, $47, $47, $4F, $4F	; tile #18
	.byt $40, $40, $40, $60, $60, $70, $70, $70	; tile #19
	.byt $40, $40, $40, $41, $41, $43, $43, $47	; tile #20
	.byt $5F, $7F, $7F, $7F, $7F, $7F, $7F, $7F	; tile #21
	.byt $78, $78, $7C, $7C, $7E, $7E, $7E, $7F	; tile #22
	.byt $40, $40, $40, $40, $40, $41, $41, $43	; tile #23
	.byt $4F, $4F, $5F, $5F, $7F, $7F, $7F, $7F	; tile #24
	.byt $40, $60, $60, $70, $70, $70, $78, $78	; tile #25
	.byt $43, $47, $47, $4F, $5F, $5F, $7F, $7F	; tile #26
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $7C, $40	; tile #27
	.byt $7F, $7F, $7F, $7F, $7F, $60, $40, $40	; tile #28
	.byt $7C, $7C, $7E, $7E, $40, $40, $40, $40	; tile #29
	.byt $41, $43, $43, $47, $47, $4F, $4F, $5F	; tile #30
	.byt $40, $40, $41, $41, $43, $47, $47, $47	; tile #31
	.byt $47, $4F, $4F, $41, $40, $40, $40, $40	; tile #32
	.byt $7F, $7F, $7F, $7F, $47, $40, $40, $40	; tile #33
	.byt $7F, $7F, $7F, $7F, $7F, $4F, $40, $40	; tile #34
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $5F, $41	; tile #35
	.byt $43, $40, $40, $40, $40, $40, $40, $40	; tile #36
res_end
.)


; Costume for cell doors. Number 3.
.(
.byt RESOURCE_COSTUME
.word (res_end - res_start + 4)
.byt 202
res_start
	; Pointers to tiles
	.byt <(costume_tiles-res_start-8), >(costume_tiles-res_start-8)
	.byt <(costume_masks-res_start-8), >(costume_masks-res_start-8)
	; Number of costumes included
	.byt 1
	;Offsets to animatory states for each costume
	.byt <(anim_states - res_start), >(anim_states - res_start)
anim_states
; Animatory state 0 (celldoor1-0.png)
.byt 1, 2, 3, 4, 5
.byt 6, 7, 8, 8, 9
.byt 8, 10, 11, 8, 9
.byt 8, 8, 8, 12, 9
.byt 8, 8, 13, 14, 9
.byt 15, 16, 17, 8, 9
.byt 18, 19, 20, 21, 22
; Animatory state 1 (celldoor1-1.png)
.byt 23, 24, 25, 4, 5
.byt 0, 0, 26, 27, 9
.byt 28, 29, 0, 30, 9
.byt 8, 31, 32, 0, 9
.byt 33, 34, 0, 0, 9
.byt 35, 0, 36, 37, 9
.byt 38, 39, 40, 21, 22
; Animatory state 2 (celldoor1-2.png)
.byt 23, 41, 42, 43, 5
.byt 0, 0, 0, 0, 9
.byt 0, 0, 0, 0, 9
.byt 44, 0, 0, 0, 9
.byt 45, 0, 0, 0, 9
.byt 0, 0, 0, 36, 9
.byt 38, 46, 47, 48, 22
; Animatory state 3 (celldoor1-3.png)
.byt 23, 41, 42, 49, 5
.byt 0, 0, 0, 0, 9
.byt 0, 0, 0, 0, 9
.byt 0, 0, 0, 0, 9
.byt 0, 0, 0, 0, 9
.byt 0, 0, 0, 0, 9
.byt 38, 46, 47, 50, 22
costume_tiles
; Tile graphic 1
.byt $3f, $3f, $3f, $3c, $3, $3f, $1f, $2f
; Tile graphic 2
.byt $3f, $3f, $3f, $0, $3f, $3f, $3f, $3f
; Tile graphic 3
.byt $3f, $3f, $3e, $1, $3f, $3f, $3f, $3f
; Tile graphic 4
.byt $3f, $3f, $0, $3f, $3f, $3f, $3f, $3f
; Tile graphic 5
.byt $3e, $3e, $3e, $e, $16, $16, $16, $16
; Tile graphic 6
.byt $37, $3b, $3d, $3e, $3f, $3f, $3f, $3f
; Tile graphic 7
.byt $3f, $3f, $3f, $3f, $1f, $2f, $37, $3b
; Tile graphic 8
.byt $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f
; Tile graphic 9
.byt $16, $16, $16, $16, $16, $16, $16, $16
; Tile graphic 10
.byt $3d, $3e, $3f, $3f, $3f, $3f, $3f, $3f
; Tile graphic 11
.byt $3f, $3f, $1f, $2f, $37, $3b, $3d, $3e
; Tile graphic 12
.byt $1f, $2f, $37, $3b, $3d, $3e, $3d, $3b
; Tile graphic 13
.byt $3f, $3f, $3f, $3e, $3d, $3b, $37, $2f
; Tile graphic 14
.byt $37, $2f, $1f, $3f, $3f, $3f, $3f, $3f
; Tile graphic 15
.byt $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3e
; Tile graphic 16
.byt $3f, $3e, $3d, $3b, $37, $2f, $1f, $3f
; Tile graphic 17
.byt $1f, $3f, $3f, $3f, $3f, $3f, $3f, $3f
; Tile graphic 18
.byt $3d, $3b, $37, $2f, $1f, $3f, $3e, $1
; Tile graphic 19
.byt $3f, $3f, $3f, $3f, $3f, $3c, $1, $3f
; Tile graphic 20
.byt $3f, $3f, $3f, $3f, $38, $7, $15, $3f
; Tile graphic 21
.byt $3f, $3f, $3f, $0, $15, $3f, $15, $3f
; Tile graphic 22
.byt $16, $16, $16, $16, $16, $26, $11, $3f
; Tile graphic 23
.byt $3f, $3f, $3f, $3c, $0, $0, $0, $0
; Tile graphic 24
.byt $3f, $3f, $3f, $0, $1, $0, $0, $0
; Tile graphic 25
.byt $3f, $3f, $3e, $1, $3f, $3f, $1f, $f
; Tile graphic 26
.byt $7, $3, $1, $0, $0, $0, $0, $0
; Tile graphic 27
.byt $3f, $3f, $3f, $3f, $1f, $f, $7, $3
; Tile graphic 28
.byt $0, $20, $30, $38, $3c, $3e, $3f, $3f
; Tile graphic 29
.byt $0, $0, $0, $0, $0, $0, $0, $20
; Tile graphic 30
.byt $1, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 31
.byt $30, $38, $3c, $3e, $3f, $3f, $3f, $3e
; Tile graphic 32
.byt $0, $0, $0, $0, $0, $20, $0, $0
; Tile graphic 33
.byt $3f, $3f, $3f, $3f, $3f, $3e, $3c, $38
; Tile graphic 34
.byt $3c, $38, $30, $20, $0, $0, $0, $0
; Tile graphic 35
.byt $30, $20, $0, $0, $0, $0, $0, $0
; Tile graphic 36
.byt $0, $0, $0, $0, $0, $0, $0, $1
; Tile graphic 37
.byt $0, $1, $3, $7, $f, $1f, $3f, $3f
; Tile graphic 38
.byt $0, $0, $0, $0, $0, $0, $0, $1
; Tile graphic 39
.byt $0, $0, $0, $0, $0, $0, $1, $3f
; Tile graphic 40
.byt $3, $7, $f, $1f, $38, $7, $15, $3f
; Tile graphic 41
.byt $3f, $3f, $3f, $0, $0, $0, $0, $0
; Tile graphic 42
.byt $3f, $3f, $3e, $0, $0, $0, $0, $0
; Tile graphic 43
.byt $3f, $3f, $0, $f, $7, $3, $1, $0
; Tile graphic 44
.byt $0, $0, $20, $30, $38, $3c, $38, $30
; Tile graphic 45
.byt $20, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 46
.byt $0, $0, $0, $0, $0, $0, $1, $3f
; Tile graphic 47
.byt $0, $0, $0, $0, $0, $7, $15, $3f
; Tile graphic 48
.byt $3, $7, $f, $0, $15, $3f, $15, $3f
; Tile graphic 49
.byt $3f, $3f, $0, $0, $0, $0, $0, $0
; Tile graphic 50
.byt $0, $0, $0, $0, $15, $3f, $15, $3f
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
; Tile mask 23
.byt $40, $40, $40, $40, $43, $ff, $ff, $ff
; Tile mask 24
.byt $40, $40, $40, $40, $7c, $7e, $ff, $ff
; Tile mask 25
.byt $40, $40, $40, $40, $40, $40, $40, $60
; Tile mask 26
.byt $70, $78, $7c, $7e, $ff, $ff, $ff, $ff
; Tile mask 27
.byt $40, $40, $40, $40, $40, $60, $70, $78
; Tile mask 28
.byt $5f, $4f, $47, $43, $41, $40, $40, $40
; Tile mask 29
.byt $ff, $ff, $ff, $ff, $ff, $ff, $5f, $4f
; Tile mask 30
.byt $7c, $7e, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 31
.byt $47, $43, $41, $40, $40, $40, $40, $40
; Tile mask 32
.byt $ff, $ff, $ff, $ff, $5f, $4f, $5f, $ff
; Tile mask 33
.byt $40, $40, $40, $40, $40, $40, $41, $43
; Tile mask 34
.byt $41, $43, $47, $4f, $5f, $ff, $ff, $ff
; Tile mask 35
.byt $47, $4f, $5f, $ff, $ff, $ff, $ff, $ff
; Tile mask 36
.byt $ff, $ff, $ff, $ff, $ff, $ff, $7e, $7c
; Tile mask 37
.byt $7e, $7c, $78, $70, $60, $40, $40, $40
; Tile mask 38
.byt $ff, $ff, $ff, $ff, $ff, $ff, $7e, $40
; Tile mask 39
.byt $ff, $ff, $ff, $ff, $7e, $7c, $40, $40
; Tile mask 40
.byt $78, $70, $60, $40, $40, $40, $40, $40
; Tile mask 41
.byt $40, $40, $40, $40, $ff, $ff, $ff, $ff
; Tile mask 42
.byt $40, $40, $40, $41, $ff, $ff, $ff, $ff
; Tile mask 43
.byt $40, $40, $40, $60, $70, $78, $7c, $7e
; Tile mask 44
.byt $ff, $5f, $4f, $47, $43, $41, $43, $47
; Tile mask 45
.byt $4f, $5f, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 46
.byt $ff, $ff, $ff, $ff, $ff, $7c, $40, $40
; Tile mask 47
.byt $ff, $ff, $ff, $ff, $78, $40, $40, $40
; Tile mask 48
.byt $78, $70, $60, $40, $40, $40, $40, $40
; Tile mask 49
.byt $40, $40, $40, $ff, $ff, $ff, $ff, $ff
; Tile mask 50
.byt $ff, $ff, $ff, $40, $40, $40, $40, $40
res_end
.)

; And number 2
.(
.byt RESOURCE_COSTUME
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
; Animatory state 0 (celldoor2-0.png)
.byt 1, 2, 3, 4, 5
.byt 6, 7, 8, 9, 10
.byt 6, 9, 11, 12, 10
.byt 6, 9, 9, 13, 10
.byt 6, 9, 14, 9, 10
.byt 6, 15, 16, 17, 18
.byt 19, 20, 21, 22, 23
; Animatory state 1 (celldoor2-1.png)
.byt 24, 25, 26, 4, 5
.byt 27, 0, 0, 28, 10
.byt 6, 29, 30, 0, 10
.byt 6, 31, 32, 0, 10
.byt 33, 34, 0, 35, 10
.byt 36, 0, 37, 38, 18
.byt 39, 40, 21, 22, 23
; Animatory state 2 (celldoor2-2.png)
.byt 24, 25, 41, 42, 5
.byt 36, 0, 0, 0, 10
.byt 43, 44, 0, 0, 10
.byt 45, 46, 0, 0, 10
.byt 36, 0, 0, 0, 10
.byt 36, 0, 47, 48, 18
.byt 39, 40, 21, 22, 23
; Animatory state 3 (celldoor2-3.png)
.byt 24, 25, 41, 49, 5
.byt 36, 0, 0, 0, 10
.byt 36, 0, 0, 0, 10
.byt 36, 0, 0, 0, 10
.byt 36, 0, 0, 0, 10
.byt 36, 0, 47, 50, 18
.byt 39, 40, 21, 22, 23
costume_tiles
; Tile graphic 1
.byt $20, $1f, $1f, $1f, $1f, $1e, $1c, $1d
; Tile graphic 2
.byt $7, $3f, $3f, $3f, $30, $f, $3f, $1f
; Tile graphic 3
.byt $3f, $3f, $3f, $3f, $0, $3f, $3f, $3f
; Tile graphic 4
.byt $3f, $3f, $3f, $0, $3f, $3f, $3f, $3f
; Tile graphic 5
.byt $3e, $3e, $3e, $e, $16, $16, $16, $16
; Tile graphic 6
.byt $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d
; Tile graphic 7
.byt $2f, $37, $3b, $3d, $3e, $3f, $3f, $3f
; Tile graphic 8
.byt $3f, $3f, $3f, $3f, $3f, $1f, $2f, $37
; Tile graphic 9
.byt $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f
; Tile graphic 10
.byt $16, $16, $16, $16, $16, $16, $16, $16
; Tile graphic 11
.byt $3b, $3d, $3e, $3f, $3f, $3f, $3f, $3f
; Tile graphic 12
.byt $3f, $3f, $3f, $1f, $2f, $37, $3b, $3d
; Tile graphic 13
.byt $3e, $3d, $3d, $3b, $37, $2f, $2f, $1f
; Tile graphic 14
.byt $3e, $3d, $3d, $3b, $37, $37, $2f, $1f
; Tile graphic 15
.byt $3e, $3e, $3d, $3b, $37, $37, $2f, $1f
; Tile graphic 16
.byt $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3c
; Tile graphic 17
.byt $3f, $3f, $3f, $3f, $3f, $3f, $30, $f
; Tile graphic 18
.byt $16, $16, $16, $16, $16, $16, $16, $26
; Tile graphic 19
.byt $1c, $1c, $1c, $1d, $1d, $3, $15, $3f
; Tile graphic 20
.byt $3e, $1, $15, $3f, $15, $3f, $15, $3f
; Tile graphic 21
.byt $1, $3f, $15, $3f, $15, $3f, $15, $3f
; Tile graphic 22
.byt $15, $3f, $15, $3f, $15, $3f, $15, $3f
; Tile graphic 23
.byt $11, $3f, $15, $3f, $15, $3f, $15, $3f
; Tile graphic 24
.byt $20, $1f, $1f, $1f, $1f, $1e, $1c, $1c
; Tile graphic 25
.byt $7, $3f, $3f, $3f, $30, $0, $0, $0
; Tile graphic 26
.byt $3f, $3f, $3f, $3f, $0, $3, $1, $0
; Tile graphic 27
.byt $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c
; Tile graphic 28
.byt $1f, $f, $7, $3, $1, $0, $0, $0
; Tile graphic 29
.byt $0, $20, $30, $38, $3c, $3e, $3f, $3f
; Tile graphic 30
.byt $0, $0, $0, $0, $0, $0, $0, $20
; Tile graphic 31
.byt $3f, $3f, $3f, $3f, $3f, $3f, $3e, $3e
; Tile graphic 32
.byt $30, $38, $30, $30, $20, $0, $0, $0
; Tile graphic 33
.byt $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1c
; Tile graphic 34
.byt $3c, $38, $38, $30, $20, $0, $0, $0
; Tile graphic 35
.byt $0, $0, $0, $0, $1, $3, $7, $7
; Tile graphic 36
.byt $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c
; Tile graphic 37
.byt $0, $0, $0, $0, $1, $3, $7, $4
; Tile graphic 38
.byt $f, $1f, $3f, $3f, $3f, $3f, $30, $f
; Tile graphic 39
.byt $1c, $1c, $1c, $1d, $1d, $3, $15, $3f
; Tile graphic 40
.byt $0, $1, $15, $3f, $15, $3f, $15, $3f
; Tile graphic 41
.byt $3f, $3f, $3f, $3f, $0, $0, $0, $0
; Tile graphic 42
.byt $3f, $3f, $3f, $0, $3, $1, $0, $0
; Tile graphic 43
.byt $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1d
; Tile graphic 44
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 45
.byt $1d, $1d, $1d, $1d, $1d, $1c, $1c, $1c
; Tile graphic 46
.byt $20, $30, $30, $20, $0, $0, $0, $0
; Tile graphic 47
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 48
.byt $0, $0, $0, $1, $1, $3, $0, $f
; Tile graphic 49
.byt $3f, $3f, $3f, $0, $0, $0, $0, $0
; Tile graphic 50
.byt $0, $0, $0, $0, $0, $0, $0, $f
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
; Tile mask 23
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 24
.byt $40, $40, $40, $40, $40, $40, $41, $41
; Tile mask 25
.byt $40, $40, $40, $40, $40, $4f, $ff, $ff
; Tile mask 26
.byt $40, $40, $40, $40, $40, $78, $7c, $7e
; Tile mask 27
.byt $41, $41, $41, $41, $41, $41, $41, $40
; Tile mask 28
.byt $40, $60, $70, $78, $7c, $7e, $ff, $ff
; Tile mask 29
.byt $5f, $4f, $47, $43, $41, $40, $40, $40
; Tile mask 30
.byt $ff, $ff, $ff, $ff, $ff, $ff, $5f, $4f
; Tile mask 31
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 32
.byt $47, $43, $47, $47, $4f, $5f, $ff, $ff
; Tile mask 33
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 34
.byt $41, $43, $43, $47, $4f, $5f, $5f, $ff
; Tile mask 35
.byt $ff, $ff, $7e, $7e, $7c, $78, $70, $70
; Tile mask 36
.byt $41, $41, $41, $41, $41, $41, $41, $41
; Tile mask 37
.byt $ff, $ff, $7e, $7e, $7c, $78, $70, $70
; Tile mask 38
.byt $60, $40, $40, $40, $40, $40, $40, $40
; Tile mask 39
.byt $41, $41, $40, $40, $40, $40, $40, $40
; Tile mask 40
.byt $7e, $40, $40, $40, $40, $40, $40, $40
; Tile mask 41
.byt $40, $40, $40, $40, $40, $ff, $ff, $ff
; Tile mask 42
.byt $40, $40, $40, $40, $78, $7c, $7e, $ff
; Tile mask 43
.byt $41, $41, $41, $41, $41, $41, $40, $40
; Tile mask 44
.byt $ff, $ff, $ff, $ff, $ff, $ff, $ff, $5f
; Tile mask 45
.byt $40, $40, $40, $40, $40, $40, $41, $41
; Tile mask 46
.byt $4f, $47, $47, $4f, $5f, $ff, $ff, $ff
; Tile mask 47
.byt $ff, $ff, $ff, $ff, $ff, $ff, $ff, $7c
; Tile mask 48
.byt $ff, $ff, $7e, $7c, $7c, $78, $70, $40
; Tile mask 49
.byt $40, $40, $40, $40, $ff, $ff, $ff, $ff
; Tile mask 50
.byt $ff, $ff, $ff, $ff, $ff, $ff, $70, $40
res_end
.)

; Exit to cell corridor
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 200
res_start
	.byt OBJ_FLAG_PROP	; If OBJ_FLAG_PROP skip all costume data
	.byt 3,6		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 34,7		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt 33,8		; Walk position (col, row)
	.byt FACING_RIGHT	; Facing direction for interaction
	.byt 00			; Color of text
#ifdef ENGLISH
	.asc "Exit",0
#endif
#ifdef SPANISH
	.asc "Salida",0
#endif
res_end	
.)

; Object resource: Door to cell 3
.(
	.byt RESOURCE_OBJECT|$80
	.word (res_end - res_start +4)
	.byt 201
res_start
	.byt 0			; If OBJ_FLAG_PROP skip all costume data
	.byt 5,7		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 0,12		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt 7,12		; Walk position (col, row)	
	.byt FACING_LEFT	; Facing direction for interaction
	.byt 00			; Color of text

	; META: TODO
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
res_end	
.)

; Object resource: Door to cell 2
.(
	.byt RESOURCE_OBJECT|$80
	.word (res_end - res_start +4)
	.byt 202
res_start
	.byt 0			; If OBJ_FLAG_PROP skip all costume data
	.byt 5,7		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 10,11		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt 15,11		; Walk position (col, row)	
	.byt FACING_LEFT	; Facing direction for interaction
	.byt 00			; Color of text

	; META: TODO
	; tiles and pointers to animatory states are setup in the costume
	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt 201		; costume ($ff for none) and skip the rest
	.byt 0			; entry in costume resource		
	.byt 0			; direction (0 or LOOK_RIGHT for animstate 0)
	.byt 0			; animation speed	
#ifdef ENGLISH
	.asc "Door",0
#endif
#ifdef SPANISH
	.asc "Puerta",0
#endif
res_end	
.)


; Object resource: Ravella
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 250
res_start
	.byt 0;OBJ_FLAG_FROMDISTANCE		; If OBJ_FLAG_PROP skip all costume data
	.byt 5,7		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 63,16		; Pos (col, row)
	.byt ZPLANE_2		; Zplane
	.byt 56,16		; Walk position (col, row)
	.byt FACING_RIGHT	; Facing direction for interaction
	.byt A_FWCYAN			; Color of text

	; META: TODO
	; tiles and pointers to animatory states are setup in the costume
	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt 200		; costume ($ff for none) and skip the rest
	.byt 0			; entry in costume resource		
	.byt LOOK_RIGHT		; direction (0 or LOOK_RIGHT for animstate 0)
	.byt 1			; animation speed	
	.asc "Ravella",0
res_end	
.)


#include "..\characters\RavellaRobot\cost_res.s"
#include "..\characters\Extras\cost_res.s"


#include "..\scripts\cellentry.s"

