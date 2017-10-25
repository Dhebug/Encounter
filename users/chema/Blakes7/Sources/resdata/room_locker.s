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
; Room: Locker
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.(
	.byt RESOURCE_ROOM
	.word (res_end - res_start + 4)
	.byt ROOM_LOCKER
res_start
; No. columns, offset to tile map, offset to tiles
	.byt 38, <(column_data-res_start), >(column_data-res_start), <(tiles_start-res_start), >(tiles_start-res_start)
; No. zplanes and offsets to zplanes
	.byt 0
; No. Walkboxes and offsets to wb data and matrix
	.byt 2, <(wb_data-res_start), >(wb_data-res_start), <(wb_matrix-res_start), >(wb_matrix-res_start)
; Offset to palette
	.byt 0, 0	; No palette information
; Entry and exit scripts
	.byt 200, 255
; Number of objects in the room and list of ids
	.byt 14, 200,201,202,203,204,205,206,207,208,209,210,211,212,213
; Room name (null terminated)
	.asc "Locker", 0
; Room tile map
column_data
	.byt 001, 013, 013, 013, 013, 013, 013, 013, 013, 013, 013, 013, 013, 013, 173, 000, 000
	.byt 002, 013, 013, 013, 013, 013, 013, 013, 013, 013, 013, 013, 013, 013, 174, 000, 000
	.byt 003, 013, 013, 013, 013, 013, 013, 013, 013, 013, 013, 013, 013, 148, 000, 000, 000
	.byt 004, 014, 013, 013, 013, 013, 013, 013, 013, 013, 013, 013, 013, 149, 000, 000, 000
	.byt 004, 002, 013, 013, 013, 013, 013, 013, 013, 013, 108, 118, 129, 150, 000, 000, 000
	.byt 004, 015, 032, 032, 032, 032, 032, 032, 032, 032, 109, 119, 130, 000, 000, 000, 000
	.byt 004, 005, 013, 013, 013, 013, 013, 013, 013, 013, 110, 120, 131, 151, 000, 000, 000
	.byt 004, 016, 013, 013, 013, 013, 013, 013, 013, 013, 013, 121, 132, 000, 000, 000, 000
	.byt 004, 017, 013, 013, 013, 054, 071, 071, 071, 071, 071, 071, 071, 152, 000, 000, 000
	.byt 004, 017, 013, 013, 013, 055, 072, 081, 081, 096, 081, 081, 081, 153, 000, 000, 000
	.byt 004, 018, 013, 013, 013, 056, 073, 082, 089, 097, 111, 122, 133, 154, 000, 000, 000
	.byt 004, 019, 033, 036, 041, 057, 074, 074, 090, 098, 074, 123, 134, 155, 000, 000, 000
	.byt 004, 019, 034, 037, 042, 058, 075, 083, 004, 099, 112, 085, 004, 156, 175, 000, 000
	.byt 004, 020, 013, 038, 043, 059, 076, 084, 089, 100, 113, 124, 089, 157, 176, 000, 000
	.byt 004, 021, 035, 039, 044, 060, 074, 074, 090, 101, 074, 123, 135, 158, 177, 000, 000
	.byt 004, 022, 013, 040, 045, 061, 077, 085, 004, 102, 075, 125, 004, 159, 178, 000, 000
	.byt 004, 023, 013, 013, 046, 062, 078, 086, 089, 102, 114, 126, 136, 160, 179, 000, 000
	.byt 004, 023, 013, 013, 047, 063, 074, 074, 090, 101, 074, 074, 090, 161, 180, 000, 000
	.byt 004, 024, 013, 013, 048, 064, 079, 087, 004, 102, 115, 127, 004, 162, 181, 000, 000
	.byt 004, 025, 013, 013, 049, 065, 078, 086, 089, 103, 114, 126, 137, 163, 182, 000, 000
	.byt 004, 025, 013, 013, 050, 066, 074, 074, 090, 104, 074, 074, 138, 164, 183, 000, 000
	.byt 004, 026, 013, 013, 051, 067, 067, 067, 067, 067, 067, 067, 067, 067, 184, 000, 000
	.byt 004, 027, 013, 013, 052, 068, 068, 068, 068, 068, 068, 068, 068, 068, 185, 000, 000
	.byt 004, 027, 013, 013, 053, 069, 067, 067, 067, 067, 067, 067, 139, 067, 186, 000, 000
	.byt 004, 028, 013, 013, 013, 070, 080, 080, 080, 080, 080, 080, 140, 165, 187, 000, 000
	.byt 004, 029, 013, 013, 013, 013, 013, 013, 013, 013, 013, 088, 141, 166, 188, 000, 000
	.byt 004, 029, 013, 013, 013, 013, 013, 088, 091, 105, 105, 128, 142, 167, 189, 000, 000
	.byt 005, 013, 013, 013, 013, 013, 013, 013, 092, 092, 092, 092, 143, 168, 190, 197, 000
	.byt 006, 030, 030, 030, 030, 030, 030, 030, 030, 030, 030, 030, 144, 169, 191, 198, 000
	.byt 007, 012, 012, 012, 012, 012, 012, 012, 012, 012, 012, 012, 145, 093, 192, 199, 000
	.byt 007, 012, 012, 012, 012, 012, 012, 012, 012, 012, 012, 012, 146, 170, 193, 000, 000
	.byt 007, 012, 012, 012, 012, 012, 012, 012, 012, 012, 012, 012, 147, 171, 194, 000, 000
	.byt 008, 031, 031, 031, 031, 031, 031, 031, 031, 031, 031, 031, 031, 172, 195, 000, 000
	.byt 009, 012, 012, 012, 012, 012, 012, 012, 093, 031, 031, 031, 031, 031, 196, 200, 201
	.byt 010, 012, 012, 012, 012, 012, 012, 012, 094, 106, 116, 116, 116, 116, 116, 116, 202
	.byt 011, 012, 012, 012, 012, 012, 012, 012, 095, 107, 117, 117, 117, 117, 117, 117, 203
	.byt 012, 012, 012, 012, 012, 012, 012, 012, 012, 030, 030, 030, 030, 030, 030, 030, 204
	.byt 012, 012, 012, 012, 012, 012, 012, 012, 012, 012, 012, 012, 012, 012, 012, 012, 012

; Room tile set
tiles_start
	.byt $4F, $61, $54, $6A, $55, $6A, $55, $6A	; tile #1
	.byt $7F, $7F, $5F, $67, $51, $6A, $55, $6A	; tile #2
	.byt $7F, $7F, $7F, $7F, $7F, $5F, $43, $68	; tile #3
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F	; tile #4
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $7F, $40	; tile #5
	.byt $7F, $7F, $7F, $40, $55, $5F, $55, $5F	; tile #6
	.byt $7F, $7F, $7F, $40, $55, $7F, $55, $7F	; tile #7
	.byt $7F, $7F, $7F, $40, $54, $7E, $54, $7E	; tile #8
	.byt $7F, $7F, $70, $4F, $55, $7F, $55, $7F	; tile #9
	.byt $7E, $61, $55, $7F, $55, $7F, $55, $7F	; tile #10
	.byt $45, $7F, $55, $7F, $55, $7F, $55, $7F	; tile #11
	.byt $55, $7F, $55, $7F, $55, $7F, $55, $7F	; tile #12
	.byt $55, $6A, $55, $6A, $55, $6A, $55, $6A	; tile #13
	.byt $4F, $63, $54, $6A, $55, $6A, $55, $6A	; tile #14
	.byt $7F, $7F, $7F, $7F, $7F, $5F, $47, $68	; tile #15
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $7C, $42	; tile #16
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $40, $6A	; tile #17
	.byt $7F, $7F, $7F, $7F, $7F, $70, $45, $6A	; tile #18
	.byt $7F, $7F, $7F, $7F, $7F, $40, $55, $6A	; tile #19
	.byt $7F, $7F, $7F, $7F, $60, $4A, $55, $6A	; tile #20
	.byt $7F, $7F, $7F, $7F, $40, $6A, $55, $6A	; tile #21
	.byt $7F, $7F, $7F, $7E, $41, $6A, $55, $6A	; tile #22
	.byt $7F, $7F, $7F, $40, $55, $6A, $55, $6A	; tile #23
	.byt $7F, $7F, $7C, $42, $55, $6A, $55, $6A	; tile #24
	.byt $7F, $7F, $40, $6A, $55, $6A, $55, $6A	; tile #25
	.byt $7F, $78, $45, $6A, $55, $6A, $55, $6A	; tile #26
	.byt $7F, $40, $55, $6A, $55, $6A, $55, $6A	; tile #27
	.byt $60, $4A, $55, $6A, $55, $6A, $55, $6A	; tile #28
	.byt $40, $6A, $55, $6A, $55, $6A, $55, $6A	; tile #29
	.byt $55, $5F, $55, $5F, $55, $5F, $55, $5F	; tile #30
	.byt $54, $7E, $54, $7E, $54, $7E, $54, $7E	; tile #31
	.byt $54, $6A, $54, $6A, $54, $6A, $54, $6A	; tile #32
	.byt $54, $6B, $50, $DF, $40, $E0, $E1, $E1	; tile #33
	.byt $55, $6A, $45, $42, $41, $79, $FB, $FD	; tile #34
	.byt $55, $6A, $55, $6A, $55, $6A, $55, $42	; tile #35
	.byt $E1, $E0, $E0, $E0, $E0, $E0, $FF, $E0	; tile #36
	.byt $FD, $42, $FD, $42, $DD, $7E, $FF, $C1	; tile #37
	.byt $55, $6A, $54, $69, $55, $69, $54, $68	; tile #38
	.byt $45, $40, $60, $64, $46, $46, $40, $4F	; tile #39
	.byt $55, $6A, $55, $4A, $55, $4A, $55, $4A	; tile #40
	.byt $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0	; tile #41
	.byt $C1, $C1, $C1, $C1, $C1, $C1, $C1, $C1	; tile #42
	.byt $54, $68, $54, $68, $54, $68, $54, $60	; tile #43
	.byt $E7, $FF, $E7, $FF, $E7, $FF, $C0, $40	; tile #44
	.byt $55, $4A, $55, $4A, $55, $4A, $54, $41	; tile #45
	.byt $55, $6A, $55, $6A, $55, $6A, $40, $77	; tile #46
	.byt $55, $6A, $55, $6A, $55, $6A, $40, $5D	; tile #47
	.byt $55, $6A, $55, $6A, $55, $68, $43, $77	; tile #48
	.byt $55, $6A, $55, $6A, $55, $40, $7F, $5D	; tile #49
	.byt $55, $6A, $55, $6A, $55, $40, $7F, $77	; tile #50
	.byt $55, $6A, $55, $6A, $50, $47, $7F, $5D	; tile #51
	.byt $55, $6A, $55, $6A, $40, $5C, $7E, $76	; tile #52
	.byt $55, $6A, $55, $6A, $55, $6A, $75, $5A	; tile #53
	.byt $55, $40, $5F, $57, $5F, $5D, $5F, $57	; tile #54
	.byt $55, $40, $7F, $5D, $7F, $77, $7F, $5D	; tile #55
	.byt $50, $4D, $7F, $77, $7F, $5D, $7F, $70	; tile #56
	.byt $40, $77, $7F, $5D, $7F, $77, $7F, $40	; tile #57
	.byt $40, $5D, $7F, $77, $7F, $5D, $7F, $40	; tile #58
	.byt $5F, $77, $7F, $5D, $7F, $77, $60, $5F	; tile #59
	.byt $7F, $5D, $7F, $77, $7F, $5D, $40, $7E	; tile #60
	.byt $7F, $77, $7F, $5D, $7F, $76, $41, $7F	; tile #61
	.byt $7F, $5D, $7F, $77, $7F, $40, $7F, $7F	; tile #62
	.byt $7F, $77, $7F, $5D, $7F, $40, $7E, $7E	; tile #63
	.byt $7F, $5D, $7F, $77, $7C, $43, $7F, $7F	; tile #64
	.byt $7F, $77, $7F, $5D, $40, $7F, $7F, $7F	; tile #65
	.byt $7F, $5D, $7F, $77, $40, $7E, $7E, $7E	; tile #66
	.byt $7F, $77, $7F, $5D, $7F, $77, $7F, $5D	; tile #67
	.byt $7E, $5C, $7E, $76, $7E, $5C, $7E, $76	; tile #68
	.byt $7D, $76, $7F, $5D, $7F, $77, $7F, $5D	; tile #69
	.byt $55, $6A, $55, $6A, $75, $52, $75, $72	; tile #70
	.byt $5F, $5D, $5F, $57, $5F, $5D, $5F, $57	; tile #71
	.byt $70, $77, $77, $57, $77, $77, $77, $57	; tile #72
	.byt $4F, $7F, $7F, $7F, $7F, $6D, $4A, $68	; tile #73
	.byt $7E, $7E, $7E, $7E, $7E, $7E, $7E, $7E	; tile #74
	.byt $7F, $7F, $7F, $7F, $7F, $79, $7D, $79	; tile #75
	.byt $7F, $7F, $7F, $7F, $7F, $6F, $57, $47	; tile #76
	.byt $7F, $7F, $7F, $7F, $79, $7D, $79, $7D	; tile #77
	.byt $7F, $7F, $7F, $7F, $6F, $57, $47, $57	; tile #78
	.byt $7F, $7F, $7F, $7F, $77, $75, $71, $7D	; tile #79
	.byt $75, $52, $75, $72, $75, $52, $75, $72	; tile #80
	.byt $77, $77, $77, $57, $77, $77, $77, $57	; tile #81
	.byt $6A, $6A, $7F, $7F, $7F, $7F, $7F, $7F	; tile #82
	.byt $7B, $79, $7F, $7F, $7F, $7F, $7F, $7F	; tile #83
	.byt $57, $57, $7F, $7F, $7F, $7F, $7F, $7F	; tile #84
	.byt $79, $7F, $7F, $7F, $7F, $7F, $7F, $7F	; tile #85
	.byt $57, $7F, $7F, $7F, $7F, $7F, $7F, $7F	; tile #86
	.byt $7D, $7F, $7F, $7F, $7F, $7F, $7F, $7F	; tile #87
	.byt $55, $6A, $55, $6A, $55, $6A, $55, $68	; tile #88
	.byt $61, $5E, $7F, $61, $5E, $7F, $61, $5E	; tile #89
	.byt $76, $76, $76, $76, $7E, $7E, $7E, $7E	; tile #90
	.byt $50, $DF, $53, $DF, $53, $DF, $53, $DF	; tile #91
	.byt $55, $4A, $55, $4A, $55, $4A, $55, $4A	; tile #92
	.byt $55, $7F, $55, $7F, $55, $7E, $54, $7E	; tile #93
	.byt $55, $7F, $55, $7F, $60, $40, $49, $4B	; tile #94
	.byt $55, $7F, $55, $7F, $45, $73, $5D, $6E	; tile #95
	.byt $77, $77, $77, $50, $77, $77, $77, $57	; tile #96
	.byt $7F, $7F, $7F, $4F, $70, $7F, $7F, $7F	; tile #97
	.byt $7E, $7E, $7E, $7E, $40, $7E, $7E, $7E	; tile #98
	.byt $7F, $7F, $7F, $7F, $40, $7F, $7F, $7F	; tile #99
	.byt $7F, $7F, $7F, $7F, $41, $7E, $7F, $7F	; tile #100
	.byt $7E, $7E, $7E, $7E, $7E, $40, $7E, $7E	; tile #101
	.byt $7F, $7F, $7F, $7F, $7F, $40, $7F, $7F	; tile #102
	.byt $7F, $7F, $7F, $7F, $7F, $47, $78, $7F	; tile #103
	.byt $7E, $7E, $7E, $7E, $7E, $7E, $40, $7E	; tile #104
	.byt $53, $DF, $53, $DF, $53, $DF, $53, $DF	; tile #105
	.byt $49, $4B, $49, $4B, $49, $4B, $49, $43	; tile #106
	.byt $56, $72, $52, $72, $52, $72, $52, $72	; tile #107
	.byt $55, $6A, $54, $69, $57, $60, $57, $67	; tile #108
	.byt $54, $6A, $40, $7F, $7F, $40, $7F, $7F	; tile #109
	.byt $55, $6A, $55, $62, $79, $42, $79, $78	; tile #110
	.byt $7F, $7F, $7F, $7F, $69, $4A, $69, $6A	; tile #111
	.byt $7F, $7F, $7F, $7F, $79, $7D, $79, $7B	; tile #112
	.byt $7F, $7F, $7F, $7F, $4F, $57, $4F, $57	; tile #113
	.byt $7F, $7F, $7F, $7F, $7F, $4F, $57, $4F	; tile #114
	.byt $7F, $7F, $7F, $7F, $7F, $77, $75, $71	; tile #115
	.byt $43, $FF, $40, $FF, $40, $FF, $48, $4B	; tile #116
	.byt $72, $72, $42, $FD, $42, $FD, $42, $FD	; tile #117
	.byt $57, $67, $57, $67, $57, $67, $57, $67	; tile #118
	.byt $7F, $7F, $7F, $7F, $73, $61, $40, $E1	; tile #119
	.byt $79, $7A, $7A, $7A, $7A, $7A, $7B, $7B	; tile #120
	.byt $55, $6A, $55, $6A, $55, $6A, $55, $4A	; tile #121
	.byt $69, $7F, $7F, $7F, $7F, $7F, $7F, $61	; tile #122
	.byt $7E, $7E, $7E, $7E, $7E, $7E, $7E, $76	; tile #123
	.byt $4F, $7F, $7F, $7F, $7F, $7F, $7F, $7F	; tile #124
	.byt $7D, $79, $7F, $7F, $7F, $7F, $7F, $7F	; tile #125
	.byt $57, $4F, $7F, $7F, $7F, $7F, $7F, $7F	; tile #126
	.byt $7D, $7D, $7F, $7F, $7F, $7F, $7F, $7F	; tile #127
	.byt $53, $DF, $53, $DF, $53, $DF, $53, $41	; tile #128
	.byt $56, $66, $56, $67, $57, $67, $57, $66	; tile #129
	.byt $C0, $C0, $40, $7F, $7F, $7F, $73, $40	; tile #130
	.byt $5B, $5B, $5B, $7B, $7B, $79, $79, $58	; tile #131
	.byt $55, $4A, $55, $6A, $60, $60, $60, $60	; tile #132
	.byt $5E, $7F, $61, $5E, $7F, $61, $5E, $7F	; tile #133
	.byt $76, $76, $7E, $7E, $7E, $7E, $7E, $7E	; tile #134
	.byt $76, $76, $76, $7E, $7E, $7E, $7E, $7E	; tile #135
	.byt $7F, $61, $5E, $7F, $61, $5E, $7F, $61	; tile #136
	.byt $7F, $7F, $61, $5E, $7F, $61, $5E, $7F	; tile #137
	.byt $7E, $76, $76, $76, $76, $7E, $7E, $7E	; tile #138
	.byt $7F, $77, $7F, $5C, $7E, $76, $7E, $5D	; tile #139
	.byt $75, $50, $47, $5F, $7F, $70, $FF, $4F	; tile #140
	.byt $57, $4F, $4E, $7D, $7F, $40, $FF, $7F	; tile #141
	.byt $79, $7C, $46, $7B, $7F, $40, $FF, $7F	; tile #142
	.byt $55, $4A, $45, $72, $79, $7A, $59, $4C	; tile #143
	.byt $55, $5F, $55, $5F, $54, $5E, $54, $5C	; tile #144
	.byt $55, $70, $41, $4F, $55, $5F, $55, $7F	; tile #145
	.byt $55, $47, $51, $7C, $54, $7E, $55, $7F	; tile #146
	.byt $55, $7F, $55, $7F, $55, $5F, $55, $4F	; tile #147
	.byt $55, $6A, $55, $6A, $55, $6A, $50, $60	; tile #148
	.byt $55, $6A, $54, $68, $40, $40, $40, $40	; tile #149
	.byt $56, $46, $40, $40, $40, $40, $40, $40	; tile #150
	.byt $58, $58, $40, $40, $40, $40, $40, $40	; tile #151
	.byt $5F, $5D, $5F, $57, $5F, $5D, $40, $40	; tile #152
	.byt $77, $77, $70, $5D, $7F, $77, $7F, $40	; tile #153
	.byt $7F, $7F, $40, $77, $7F, $5D, $7F, $40	; tile #154
	.byt $7E, $7E, $5E, $40, $7F, $77, $7F, $5D	; tile #155
	.byt $7F, $7F, $7F, $40, $7F, $5D, $7F, $77	; tile #156
	.byt $7F, $7F, $7F, $7F, $40, $77, $7F, $5D	; tile #157
	.byt $7E, $7E, $7E, $7E, $40, $5C, $7F, $77	; tile #158
	.byt $7F, $7F, $7F, $7F, $7F, $40, $7F, $5D	; tile #159
	.byt $5E, $7F, $7F, $7F, $7F, $43, $7C, $77	; tile #160
	.byt $7E, $7E, $7E, $7E, $7E, $7E, $40, $5D	; tile #161
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $47, $70	; tile #162
	.byt $61, $5E, $7F, $7F, $7F, $7F, $7F, $40	; tile #163
	.byt $7E, $7E, $7E, $7E, $7E, $7E, $7E, $4E	; tile #164
	.byt $67, $56, $77, $77, $77, $57, $73, $63	; tile #165
	.byt $7F, $5F, $4F, $67, $73, $79, $7E, $7F	; tile #166
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $5F, $47	; tile #167
	.byt $6D, $74, $71, $62, $65, $62, $65, $62	; tile #168
	.byt $54, $5C, $54, $5C, $54, $5C, $54, $5C	; tile #169
	.byt $54, $79, $58, $60, $60, $40, $C0, $FF	; tile #170
	.byt $40, $5C, $FF, $46, $FF, $EF, $E0, $FF	; tile #171
	.byt $74, $5E, $54, $4E, $44, $4E, $44, $4E	; tile #172
	.byt $55, $6A, $55, $6A, $54, $68, $40, $40	; tile #173
	.byt $55, $68, $50, $40, $40, $40, $40, $40	; tile #174
	.byt $41, $40, $40, $40, $40, $40, $40, $40	; tile #175
	.byt $7F, $40, $40, $40, $40, $40, $40, $40	; tile #176
	.byt $7F, $41, $40, $40, $40, $40, $40, $40	; tile #177
	.byt $7F, $77, $40, $40, $40, $40, $40, $40	; tile #178
	.byt $7F, $5D, $47, $40, $40, $40, $40, $40	; tile #179
	.byt $7F, $77, $7F, $40, $40, $40, $40, $40	; tile #180
	.byt $7F, $5D, $7F, $47, $40, $40, $40, $40	; tile #181
	.byt $7F, $77, $7F, $5D, $40, $40, $40, $40	; tile #182
	.byt $70, $5D, $7F, $77, $4F, $40, $40, $40	; tile #183
	.byt $7F, $77, $7F, $5D, $7F, $40, $40, $40	; tile #184
	.byt $7E, $5C, $7E, $76, $7E, $5C, $40, $40	; tile #185
	.byt $7F, $76, $7C, $58, $70, $60, $40, $40	; tile #186
	.byt $43, $43, $43, $43, $41, $41, $40, $40	; tile #187
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $40, $40	; tile #188
	.byt $71, $7E, $7F, $7F, $7F, $7F, $40, $40	; tile #189
	.byt $60, $40, $40, $40, $40, $40, $40, $40	; tile #190
	.byt $54, $5C, $54, $5C, $54, $5C, $44, $78	; tile #191
	.byt $54, $7E, $54, $7E, $54, $7E, $40, $5E	; tile #192
	.byt $C0, $7F, $C0, $7F, $C0, $7F, $E0, $40	; tile #193
	.byt $C2, $7F, $C2, $7D, $C2, $7F, $C1, $40	; tile #194
	.byt $44, $4E, $44, $4E, $44, $4E, $44, $40	; tile #195
	.byt $54, $7E, $54, $7E, $54, $7E, $54, $5E	; tile #196
	.byt $41, $41, $40, $40, $40, $40, $40, $40	; tile #197
	.byt $40, $40, $7F, $40, $40, $40, $40, $40	; tile #198
	.byt $42, $42, $7C, $40, $40, $40, $40, $40	; tile #199
	.byt $44, $46, $42, $42, $42, $42, $42, $42	; tile #200
	.byt $42, $42, $41, $40, $40, $40, $40, $40	; tile #201
	.byt $4B, $49, $48, $70, $40, $40, $40, $40	; tile #202
	.byt $72, $72, $72, $52, $52, $52, $52, $48	; tile #203
	.byt $55, $5F, $55, $5F, $55, $5F, $55, $7F	; tile #204
; Walkbox Data
wb_data
	.byt 001, 015, 014, 016, $01
	.byt 016, 032, 015, 016, $01
; Walk matrix
wb_matrix
	.byt 0, 1
	.byt 0, 1


res_end
.)

.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 200
res_start
	.byt OBJ_FLAG_PROP	; If OBJ_FLAG_PROP skip all costume data
	.byt 18,1		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 11,16		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt 11,16		; Walk position (col, row)
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


.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 201
res_start
	.byt OBJ_FLAG_PROP	; If OBJ_FLAG_PROP skip all costume data
	.byt 4,3		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 24,14		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt 23,15		; Walk position (col, row)
	.byt FACING_UP	; Facing direction for interaction
	.byt 00			; Color of text
#ifdef ENGLISH
	.asc "Bucket",0
#endif
#ifdef SPANISH
	.asc "Cubo",0
#endif
res_end	
.)


.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 202
res_start
	.byt OBJ_FLAG_PROP	; If OBJ_FLAG_PROP skip all costume data
	.byt 2,3		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 30,14		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt 23,15		; Walk position (col, row)
	.byt FACING_RIGHT	; Facing direction for interaction
	.byt 00			; Color of text
#ifdef ENGLISH
	.asc "Vacuum cleaner",0
#endif
#ifdef SPANISH
	.asc "Aspiradora",0
#endif
	
res_end	
.)

.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 203
res_start
	.byt OBJ_FLAG_PROP	; If OBJ_FLAG_PROP skip all costume data
	.byt 2,8		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 34,16		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt 29,16		; Walk position (col, row)
	.byt FACING_RIGHT	; Facing direction for interaction
	.byt 00			; Color of text
#ifdef ENGLISH
	.asc "Ladder",0
#endif
#ifdef SPANISH
	.asc "Escalera",0
#endif
	
res_end	
.)

.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 204
res_start
	.byt OBJ_FLAG_PROP	; If OBJ_FLAG_PROP skip all costume data
	.byt 4,3		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 11,4		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt 11,15		; Walk position (col, row)
	.byt FACING_UP		; Facing direction for interaction
	.byt 00			; Color of text
#ifdef ENGLISH
	.asc "Bottles",0
#endif
#ifdef SPANISH
	.asc "Botellas",0
#endif

res_end	
.)

.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 205
res_start
	.byt OBJ_FLAG_PROP	; If OBJ_FLAG_PROP skip all costume data
	.byt 2,3		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 4,12		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt 7,14		; Walk position (col, row)
	.byt FACING_LEFT	; Facing direction for interaction
	.byt 00			; Color of text
#ifdef ENGLISH
	.asc "Sign",0
#endif
#ifdef SPANISH
	.asc "Cartel",0
#endif

res_end	
.)


; Lockers. B line

.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 206
res_start
	.byt OBJ_FLAG_PROP	; If OBJ_FLAG_PROP skip all costume data
	.byt 3,4		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 9,13		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt 12,14		; Walk position (col, row)
	.byt FACING_LEFT		; Facing direction for interaction
	.byt 00			; Color of text
#ifdef ENGLISH
	.asc "Locker",0
#endif
#ifdef SPANISH
	.asc "Taquilla",0
#endif
	
res_end	
.)

.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 207
res_start
	.byt OBJ_FLAG_PROP	; If OBJ_FLAG_PROP skip all costume data
	.byt 3,4		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 12,13		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt 12,14		; Walk position (col, row)
	.byt FACING_UP		; Facing direction for interaction
	.byt 00			; Color of text
#ifdef ENGLISH
	.asc "Locker",0
#endif
#ifdef SPANISH
	.asc "Taquilla",0
#endif
res_end	
.)

; This one is 3B which can be open
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 208
res_start
	.byt 0			; If OBJ_FLAG_PROP skip all costume data
	.byt 3,4		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 15-1,13		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt 18,15		; Walk position (col, row)
	.byt FACING_LEFT		; Facing direction for interaction
	.byt 00			; Color of text
	; tiles and pointers to animatory states are setup in the costume
	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt 201		; costume ($ff for none) and skip the rest
	.byt 0			; entry in costume resource		
	.byt 0			; direction (0 or LOOK_RIGHT for animstate 0)
	.byt 0			; animation speed	
#ifdef ENGLISH
	.asc "Locker",0
#endif
#ifdef SPANISH
	.asc "Taquilla",0
#endif
res_end	
.)


.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 209
res_start
	.byt OBJ_FLAG_PROP	; If OBJ_FLAG_PROP skip all costume data
	.byt 3,4		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 18,13		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt 18,15		; Walk position (col, row)
	.byt FACING_UP		; Facing direction for interaction
	.byt 00			; Color of text
#ifdef ENGLISH
	.asc "Locker",0
#endif
#ifdef SPANISH
	.asc "Taquilla",0
#endif
res_end	
.)

; Lockers A line
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 210
res_start
	.byt OBJ_FLAG_PROP	; If OBJ_FLAG_PROP skip all costume data
	.byt 3,4		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 9,9		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt 12,14		; Walk position (col, row)
	.byt FACING_LEFT		; Facing direction for interaction
	.byt 00			; Color of text
#ifdef ENGLISH
	.asc "Locker",0
#endif
#ifdef SPANISH
	.asc "Taquilla",0
#endif
res_end	
.)

.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 211
res_start
	.byt OBJ_FLAG_PROP	; If OBJ_FLAG_PROP skip all costume data
	.byt 3,4		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 12,9		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt 12,14		; Walk position (col, row)
	.byt FACING_UP		; Facing direction for interaction
	.byt 00			; Color of text
#ifdef ENGLISH
	.asc "Locker",0
#endif
#ifdef SPANISH
	.asc "Taquilla",0
#endif
res_end	
.)

.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 212
res_start
	.byt OBJ_FLAG_PROP	; If OBJ_FLAG_PROP skip all costume data
	.byt 3,4		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 15,9		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt 18,15		; Walk position (col, row)
	.byt FACING_LEFT		; Facing direction for interaction
	.byt 00			; Color of text
#ifdef ENGLISH
	.asc "Locker",0
#endif
#ifdef SPANISH
	.asc "Taquilla",0
#endif
res_end	
.)

.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 213
res_start
	.byt OBJ_FLAG_PROP	; If OBJ_FLAG_PROP skip all costume data
	.byt 3,4		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 18,9		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt 18,15		; Walk position (col, row)
	.byt FACING_UP		; Facing direction for interaction
	.byt 00			; Color of text
#ifdef ENGLISH
	.asc "Locker",0
#endif
#ifdef SPANISH
	.asc "Taquilla",0
#endif
res_end	
.)


; This object is the envelope, which appears only when the locker 3B is open
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 214
res_start
	.byt OBJ_FLAG_PROP	; If OBJ_FLAG_PROP skip all costume data
	.byt 2,2		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 16,11		; Pos (col, row)
	.byt ZPLANE_2		; Zplane
	.byt 18,15		; Walk position (col, row)
	.byt FACING_LEFT	; Facing direction for interaction
	.byt 00			; Color of text
#ifdef ENGLISH
	.asc "Envelope",0
#endif
#ifdef SPANISH
	.asc "Sobre",0
#endif
res_end	
.)

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
; Animatory state 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0


; Animatory state 1 (openlocker.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 0
.byt 5, 6, 7, 8, 0
.byt 9, 10, 11, 12, 0
.byt 13, 14, 15, 15, 0
.byt 16, 17, 18, 19, 0
costume_tiles
; Tile graphic 1
.byt $3e, $3e, $3e, $22, $2c, $e, $2f, $2f
; Tile graphic 2
.byt $3f, $3f, $3f, $3f, $3f, $0, $20, $10
; Tile graphic 3
.byt $3f, $3f, $3f, $3f, $3f, $0, $0, $0
; Tile graphic 4
.byt $3e, $3e, $3e, $3e, $3e, $0, $0, $0
; Tile graphic 5
.byt $2f, $2f, $2f, $2f, $2f, $2f, $2f, $2f
; Tile graphic 6
.byt $8, $7, $4, $4, $4, $4, $5, $5
; Tile graphic 7
.byt $0, $3f, $0, $0, $0, $0, $3f, $1f
; Tile graphic 8
.byt $0, $3f, $0, $0, $0, $0, $3e, $3a
; Tile graphic 9
.byt $2f, $2f, $2f, $2f, $2f, $27, $2f, $27
; Tile graphic 10
.byt $5, $5, $5, $5, $5, $4, $f, $3f
; Tile graphic 11
.byt $2f, $37, $3b, $3c, $3f, $0, $3f, $3f
; Tile graphic 12
.byt $36, $2e, $1e, $3e, $3e, $0, $3f, $3f
; Tile graphic 13
.byt $27, $27, $27, $2f, $2d, $2b, $2d, $2b
; Tile graphic 14
.byt $4, $4, $4, $4, $4, $4, $4, $4
; Tile graphic 15
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 16
.byt $2d, $2b, $2f, $2f, $f, $c, $23, $37
; Tile graphic 17
.byt $7, $8, $10, $20, $0, $0, $3f, $1d
; Tile graphic 18
.byt $3f, $0, $0, $0, $0, $0, $3c, $37
; Tile graphic 19
.byt $3f, $0, $0, $0, $0, $0, $0, $1d
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Room: No name
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
	.asc "", 0
; Room tile map
column_data
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000
	.byt 000, 000, 001, 005, 019, 031, 045, 061, 061, 061, 061, 142, 168, 186, 000, 000, 000
	.byt 000, 000, 002, 006, 020, 000, 046, 025, 025, 025, 119, 143, 169, 187, 000, 000, 000
	.byt 000, 000, 003, 007, 021, 032, 025, 025, 025, 096, 120, 144, 170, 025, 000, 000, 000
	.byt 000, 000, 004, 000, 008, 033, 025, 025, 080, 097, 121, 145, 171, 025, 000, 000, 000
	.byt 000, 000, 000, 000, 022, 025, 025, 062, 081, 098, 122, 146, 172, 188, 000, 000, 000
	.byt 000, 000, 000, 000, 023, 025, 025, 063, 082, 099, 123, 147, 173, 189, 000, 000, 000
	.byt 000, 000, 000, 008, 024, 025, 047, 064, 083, 100, 124, 148, 174, 190, 000, 000, 000
	.byt 000, 000, 000, 009, 025, 025, 048, 065, 084, 000, 125, 149, 175, 191, 000, 000, 000
	.byt 000, 000, 000, 010, 025, 034, 049, 066, 085, 101, 126, 150, 176, 025, 000, 000, 000
	.byt 000, 000, 000, 011, 025, 035, 050, 067, 000, 102, 127, 151, 177, 025, 000, 000, 000
	.byt 000, 000, 000, 012, 025, 036, 051, 068, 086, 103, 128, 152, 025, 025, 000, 000, 000
	.byt 000, 000, 000, 013, 025, 037, 052, 000, 087, 104, 129, 153, 025, 025, 000, 000, 000
	.byt 000, 000, 000, 013, 025, 038, 053, 000, 000, 105, 130, 154, 025, 025, 000, 000, 000
	.byt 000, 000, 000, 014, 025, 039, 054, 000, 000, 106, 130, 155, 025, 025, 000, 000, 000
	.byt 000, 000, 000, 015, 026, 040, 055, 000, 000, 107, 130, 156, 025, 025, 000, 000, 000
	.byt 000, 000, 000, 016, 027, 041, 056, 069, 000, 108, 131, 157, 025, 192, 000, 000, 000
	.byt 000, 000, 000, 017, 028, 042, 057, 070, 088, 109, 132, 158, 025, 193, 000, 000, 000
	.byt 000, 000, 000, 018, 029, 043, 058, 071, 018, 110, 133, 159, 025, 194, 000, 000, 000
	.byt 000, 000, 000, 000, 030, 044, 059, 072, 089, 111, 134, 160, 178, 195, 000, 000, 000
	.byt 000, 000, 000, 000, 000, 000, 060, 073, 090, 112, 135, 161, 179, 196, 000, 000, 000
	.byt 000, 000, 000, 000, 000, 000, 000, 074, 091, 113, 136, 162, 180, 197, 000, 000, 000
	.byt 000, 000, 000, 000, 000, 000, 000, 075, 025, 114, 137, 163, 181, 198, 000, 000, 000
	.byt 000, 000, 000, 000, 000, 000, 000, 076, 092, 115, 138, 164, 182, 025, 000, 000, 000
	.byt 000, 000, 000, 000, 000, 000, 000, 077, 093, 116, 139, 165, 183, 199, 000, 000, 000
	.byt 000, 000, 000, 000, 000, 000, 000, 078, 094, 117, 140, 166, 184, 200, 000, 000, 000
	.byt 000, 000, 000, 000, 000, 000, 000, 079, 095, 118, 141, 167, 185, 000, 000, 000, 000
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000, 000

; Room tile set
tiles_start
	.byt $40, $40, $40, $41, $41, $43, $47, $47	; tile #1
	.byt $40, $47, $5F, $7F, $7F, $7F, $7F, $7F	; tile #2
	.byt $40, $7E, $7D, $7C, $72, $79, $64, $64	; tile #3
	.byt $40, $61, $48, $64, $50, $40, $60, $40	; tile #4
	.byt $4F, $4F, $5F, $5F, $5F, $5F, $5F, $5F	; tile #5
	.byt $7F, $7F, $7F, $7F, $7E, $7D, $7A, $74	; tile #6
	.byt $48, $68, $40, $60, $60, $40, $60, $60	; tile #7
	.byt $40, $40, $40, $40, $40, $40, $40, $43	; tile #8
	.byt $40, $40, $40, $40, $40, $40, $7F, $7F	; tile #9
	.byt $40, $40, $40, $40, $6D, $7F, $7F, $7F	; tile #10
	.byt $40, $40, $40, $40, $6F, $7F, $7F, $7F	; tile #11
	.byt $40, $40, $40, $5F, $5F, $7F, $7F, $7F	; tile #12
	.byt $40, $40, $40, $7F, $7F, $7F, $7F, $7F	; tile #13
	.byt $40, $40, $40, $7E, $7F, $7F, $7F, $7F	; tile #14
	.byt $40, $40, $40, $40, $7E, $7F, $7F, $7F	; tile #15
	.byt $40, $40, $40, $40, $40, $54, $7F, $7F	; tile #16
	.byt $40, $40, $40, $40, $40, $40, $78, $7A	; tile #17
	.byt $40, $40, $40, $40, $40, $40, $40, $60	; tile #18
	.byt $5F, $5F, $5E, $5E, $5D, $5E, $5D, $5C	; tile #19
	.byt $69, $64, $52, $48, $50, $48, $40, $60	; tile #20
	.byt $40, $60, $40, $40, $40, $40, $40, $40	; tile #21
	.byt $40, $40, $40, $40, $40, $4F, $5F, $7F	; tile #22
	.byt $40, $43, $4F, $5F, $7F, $7F, $7F, $7F	; tile #23
	.byt $4F, $7F, $7F, $7F, $7F, $7F, $7F, $7F	; tile #24
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F	; tile #25
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $77, $68	; tile #26
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $76, $52	; tile #27
	.byt $7D, $7E, $7B, $7F, $7E, $7E, $75, $55	; tile #28
	.byt $50, $6A, $54, $6A, $55, $6A, $55, $55	; tile #29
	.byt $40, $40, $60, $60, $50, $50, $50, $54	; tile #30
	.byt $58, $5C, $40, $50, $40, $40, $40, $40	; tile #31
	.byt $40, $40, $40, $40, $42, $47, $7F, $7F	; tile #32
	.byt $47, $47, $5F, $5F, $7F, $7F, $7F, $7F	; tile #33
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $78, $5B	; tile #34
	.byt $7F, $7F, $7F, $7F, $75, $75, $54, $50	; tile #35
	.byt $7F, $7F, $7E, $73, $54, $42, $40, $40	; tile #36
	.byt $7F, $7B, $4A, $55, $40, $40, $40, $7F	; tile #37
	.byt $7F, $5E, $61, $5E, $40, $40, $40, $40	; tile #38
	.byt $54, $6A, $55, $6A, $40, $40, $40, $40	; tile #39
	.byt $6B, $69, $55, $6A, $40, $40, $40, $43	; tile #40
	.byt $55, $55, $55, $6A, $40, $40, $40, $7F	; tile #41
	.byt $55, $55, $55, $6A, $6A, $41, $40, $70	; tile #42
	.byt $55, $55, $54, $6A, $6A, $40, $40, $40	; tile #43
	.byt $50, $50, $60, $60, $60, $40, $40, $40	; tile #44
	.byt $40, $40, $40, $40, $41, $43, $47, $4F	; tile #45
	.byt $43, $4F, $5F, $7F, $7F, $7F, $7F, $7F	; tile #46
	.byt $7F, $7F, $7F, $7F, $7D, $7A, $74, $74	; tile #47
	.byt $7C, $7D, $55, $54, $48, $60, $45, $47	; tile #48
	.byt $64, $54, $40, $42, $47, $7F, $7F, $7F	; tile #49
	.byt $60, $40, $47, $6F, $7F, $7F, $7F, $7F	; tile #50
	.byt $61, $7F, $7F, $7F, $7F, $7E, $7A, $4A	; tile #51
	.byt $7E, $7F, $7F, $7F, $7F, $6A, $6A, $6A	; tile #52
	.byt $60, $7F, $70, $76, $49, $6A, $6A, $6A	; tile #53
	.byt $40, $60, $6D, $64, $55, $6A, $60, $60	; tile #54
	.byt $57, $5F, $7F, $6F, $5F, $64, $42, $40	; tile #55
	.byt $7F, $7F, $7F, $7F, $7F, $6F, $6D, $62	; tile #56
	.byt $7D, $7F, $7F, $7F, $7F, $7F, $5F, $67	; tile #57
	.byt $54, $7C, $7F, $7F, $7F, $7F, $7F, $7F	; tile #58
	.byt $40, $40, $60, $76, $7F, $7F, $7F, $7F	; tile #59
	.byt $40, $40, $40, $40, $40, $60, $7E, $7F	; tile #60
	.byt $5F, $5F, $5F, $5F, $5F, $5F, $5F, $5F	; tile #61
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $7E, $7C	; tile #62
	.byt $7F, $7A, $7A, $7A, $68, $54, $60, $61	; tile #63
	.byt $50, $61, $63, $47, $5F, $5F, $7F, $7F	; tile #64
	.byt $5F, $5F, $7F, $7F, $7F, $7F, $7F, $7D	; tile #65
	.byt $7F, $7F, $7E, $7F, $68, $77, $48, $56	; tile #66
	.byt $79, $7D, $42, $74, $54, $50, $60, $40	; tile #67
	.byt $50, $40, $40, $40, $40, $40, $40, $40	; tile #68
	.byt $41, $40, $40, $40, $40, $40, $40, $40	; tile #69
	.byt $57, $69, $55, $4A, $40, $40, $40, $40	; tile #70
	.byt $7F, $5F, $5F, $64, $6A, $41, $42, $40	; tile #71
	.byt $7F, $7F, $7F, $5F, $6F, $57, $69, $44	; tile #72
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $7F, $5F	; tile #73
	.byt $78, $7C, $7C, $7F, $7F, $7F, $7F, $7F	; tile #74
	.byt $40, $40, $60, $60, $7C, $7C, $7E, $7F	; tile #75
	.byt $40, $40, $40, $40, $44, $42, $42, $41	; tile #76
	.byt $40, $40, $40, $40, $6A, $6A, $52, $55	; tile #77
	.byt $40, $40, $40, $40, $6A, $6A, $55, $52	; tile #78
	.byt $40, $40, $40, $40, $60, $68, $54, $50	; tile #79
	.byt $7F, $7F, $7F, $7F, $7E, $7F, $7C, $7E	; tile #80
	.byt $79, $75, $48, $64, $50, $49, $63, $67	; tile #81
	.byt $43, $47, $4F, $5F, $7F, $7F, $7F, $7F	; tile #82
	.byt $7F, $7F, $7E, $7E, $79, $75, $6A, $6A	; tile #83
	.byt $75, $4A, $75, $4A, $6A, $54, $60, $60	; tile #84
	.byt $50, $68, $40, $60, $40, $40, $40, $40	; tile #85
	.byt $40, $40, $40, $40, $40, $42, $4A, $6A	; tile #86
	.byt $40, $40, $45, $45, $74, $60, $40, $40	; tile #87
	.byt $40, $40, $40, $40, $40, $40, $40, $61	; tile #88
	.byt $45, $40, $42, $41, $41, $40, $40, $40	; tile #89
	.byt $6B, $54, $4B, $48, $55, $45, $49, $45	; tile #90
	.byt $7F, $7F, $4F, $67, $5F, $43, $5B, $48	; tile #91
	.byt $50, $54, $74, $7A, $7A, $7A, $79, $7C	; tile #92
	.byt $6A, $64, $6A, $65, $6A, $6A, $54, $65	; tile #93
	.byt $6A, $6A, $65, $52, $69, $6A, $69, $4A	; tile #94
	.byt $54, $54, $64, $68, $49, $6A, $68, $4A	; tile #95
	.byt $7F, $7F, $7F, $7E, $7E, $7F, $78, $7E	; tile #96
	.byt $61, $78, $44, $64, $51, $49, $69, $41	; tile #97
	.byt $4F, $4F, $5F, $7F, $7F, $7F, $78, $6A	; tile #98
	.byt $7C, $7E, $79, $7D, $52, $64, $55, $65	; tile #99
	.byt $64, $6A, $54, $54, $68, $60, $40, $40	; tile #100
	.byt $40, $40, $40, $40, $43, $43, $4F, $47	; tile #101
	.byt $42, $42, $44, $54, $7C, $7E, $7F, $7F	; tile #102
	.byt $60, $40, $40, $40, $41, $41, $55, $6A	; tile #103
	.byt $40, $40, $40, $40, $40, $60, $55, $6A	; tile #104
	.byt $40, $40, $40, $40, $55, $6A, $55, $6A	; tile #105
	.byt $40, $40, $40, $40, $52, $6A, $55, $6A	; tile #106
	.byt $40, $40, $60, $6A, $6A, $6A, $55, $6A	; tile #107
	.byt $40, $40, $45, $6A, $6A, $6A, $55, $6A	; tile #108
	.byt $62, $62, $42, $67, $6F, $6F, $5F, $7F	; tile #109
	.byt $50, $68, $6A, $6A, $75, $76, $7D, $7F	; tile #110
	.byt $40, $40, $40, $60, $50, $68, $56, $7A	; tile #111
	.byt $44, $41, $40, $40, $40, $40, $40, $60	; tile #112
	.byt $6A, $4A, $64, $6A, $49, $40, $41, $40	; tile #113
	.byt $6F, $65, $6A, $69, $4A, $64, $55, $52	; tile #114
	.byt $75, $55, $69, $4A, $69, $6A, $49, $65	; tile #115
	.byt $54, $52, $4A, $6A, $49, $6A, $49, $55	; tile #116
	.byt $69, $6A, $55, $64, $55, $52, $55, $54	; tile #117
	.byt $68, $6A, $65, $54, $52, $68, $54, $50	; tile #118
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $7C, $7E	; tile #119
	.byt $79, $78, $42, $69, $44, $64, $4A, $61	; tile #120
	.byt $43, $61, $44, $42, $69, $64, $52, $4A	; tile #121
	.byt $54, $42, $74, $52, $49, $69, $40, $6A	; tile #122
	.byt $68, $64, $68, $40, $40, $40, $6A, $6A	; tile #123
	.byt $40, $40, $40, $40, $48, $68, $65, $54	; tile #124
	.byt $40, $42, $45, $47, $6F, $65, $55, $6A	; tile #125
	.byt $7F, $7F, $7F, $7F, $7F, $56, $52, $6A	; tile #126
	.byt $7F, $7F, $7F, $7F, $7F, $6F, $6F, $64	; tile #127
	.byt $55, $7A, $75, $7D, $7F, $7F, $7F, $64	; tile #128
	.byt $55, $6A, $55, $55, $55, $7D, $75, $6A	; tile #129
	.byt $55, $6A, $55, $55, $55, $55, $55, $6A	; tile #130
	.byt $55, $6A, $53, $5B, $5F, $55, $55, $6A	; tile #131
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $7F, $40	; tile #132
	.byt $7F, $7F, $7F, $7F, $7F, $7D, $72, $6A	; tile #133
	.byt $7D, $7F, $7F, $7F, $7F, $55, $6A, $6A	; tile #134
	.byt $40, $70, $48, $7A, $7A, $55, $6A, $55	; tile #135
	.byt $40, $40, $40, $40, $40, $50, $60, $5B	; tile #136
	.byt $4A, $48, $40, $40, $40, $40, $40, $70	; tile #137
	.byt $69, $55, $64, $40, $41, $40, $40, $40	; tile #138
	.byt $49, $54, $6A, $62, $55, $49, $44, $42	; tile #139
	.byt $4A, $6A, $65, $52, $55, $52, $69, $55	; tile #140
	.byt $68, $50, $48, $68, $64, $50, $6A, $54	; tile #141
	.byt $5F, $5F, $5F, $5F, $5D, $5C, $40, $50	; tile #142
	.byt $7A, $7C, $7A, $4A, $51, $44, $52, $48	; tile #143
	.byt $50, $48, $61, $48, $52, $48, $64, $65	; tile #144
	.byt $65, $50, $55, $74, $62, $79, $64, $75	; tile #145
	.byt $41, $65, $4B, $69, $54, $45, $69, $4A	; tile #146
	.byt $5F, $7F, $7F, $5F, $5F, $47, $54, $52	; tile #147
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $4F, $6B	; tile #148
	.byt $75, $7D, $7A, $7E, $7F, $7F, $7F, $7F	; tile #149
	.byt $55, $55, $69, $5F, $5F, $7F, $7F, $7F	; tile #150
	.byt $55, $55, $55, $75, $77, $7F, $7F, $7F	; tile #151
	.byt $52, $5A, $7F, $7F, $7F, $7F, $7F, $7F	; tile #152
	.byt $6A, $6A, $75, $7F, $7F, $7F, $7F, $7F	; tile #153
	.byt $6A, $6A, $55, $77, $7F, $7F, $7F, $7F	; tile #154
	.byt $6A, $6B, $5F, $7F, $7F, $7F, $7F, $7F	; tile #155
	.byt $65, $7D, $7F, $7F, $7F, $7F, $7F, $7F	; tile #156
	.byt $55, $6C, $7E, $7F, $7F, $7F, $7F, $7F	; tile #157
	.byt $6D, $65, $6A, $7F, $7F, $7F, $7F, $7F	; tile #158
	.byt $55, $57, $7F, $7F, $7F, $7F, $7F, $7F	; tile #159
	.byt $55, $6A, $75, $7F, $7F, $7F, $7F, $7F	; tile #160
	.byt $52, $6A, $55, $55, $7F, $7F, $7F, $7F	; tile #161
	.byt $64, $6A, $55, $57, $7F, $7F, $7F, $7F	; tile #162
	.byt $4A, $6A, $55, $7F, $7F, $7F, $7F, $7F	; tile #163
	.byt $60, $68, $54, $6A, $7D, $7F, $7B, $7F	; tile #164
	.byt $45, $41, $40, $6A, $55, $49, $54, $65	; tile #165
	.byt $49, $55, $49, $4A, $52, $49, $6B, $49	; tile #166
	.byt $48, $54, $48, $40, $68, $68, $48, $60	; tile #167
	.byt $40, $50, $40, $50, $40, $50, $41, $50	; tile #168
	.byt $44, $42, $48, $48, $44, $44, $52, $4B	; tile #169
	.byt $53, $51, $4F, $47, $5F, $6F, $7F, $7F	; tile #170
	.byt $78, $7E, $79, $7C, $7F, $7F, $7F, $7F	; tile #171
	.byt $65, $54, $42, $69, $64, $72, $74, $7A	; tile #172
	.byt $4A, $6A, $51, $55, $69, $64, $69, $64	; tile #173
	.byt $64, $6A, $4A, $56, $7F, $7F, $6F, $6F	; tile #174
	.byt $4F, $62, $55, $6B, $7F, $7F, $7F, $7F	; tile #175
	.byt $7F, $6A, $55, $7F, $7F, $7F, $7F, $7F	; tile #176
	.byt $7F, $6F, $7F, $7F, $7F, $7F, $7F, $7F	; tile #177
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7A	; tile #178
	.byt $7F, $7F, $7F, $7F, $7D, $7A, $65, $75	; tile #179
	.byt $7F, $7F, $7A, $6A, $52, $6A, $55, $52	; tile #180
	.byt $7F, $7F, $6B, $6B, $50, $6A, $54, $52	; tile #181
	.byt $7F, $7F, $54, $65, $52, $69, $6A, $6F	; tile #182
	.byt $55, $69, $54, $52, $55, $52, $6C, $7E	; tile #183
	.byt $53, $49, $6A, $52, $49, $64, $6A, $52	; tile #184
	.byt $68, $50, $48, $68, $40, $60, $60, $40	; tile #185
	.byt $40, $51, $47, $4B, $47, $43, $43, $41	; tile #186
	.byt $57, $4F, $7F, $7F, $7F, $7F, $7F, $7F	; tile #187
	.byt $79, $7A, $7C, $7F, $7F, $7F, $7F, $7F	; tile #188
	.byt $55, $52, $6A, $48, $55, $7C, $7A, $7F	; tile #189
	.byt $5F, $5F, $65, $69, $55, $64, $6B, $69	; tile #190
	.byt $7F, $7F, $5F, $5F, $7F, $7F, $7F, $7F	; tile #191
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $5F, $40	; tile #192
	.byt $7F, $7F, $7F, $7F, $7F, $7A, $75, $52	; tile #193
	.byt $7F, $7C, $7A, $7A, $45, $69, $54, $52	; tile #194
	.byt $75, $4A, $69, $6A, $55, $49, $64, $6B	; tile #195
	.byt $4A, $69, $55, $54, $4A, $52, $5D, $5F	; tile #196
	.byt $6A, $48, $55, $65, $6B, $7F, $7F, $7F	; tile #197
	.byt $69, $66, $5F, $7F, $7F, $7F, $7F, $7F	; tile #198
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $7C, $7A	; tile #199
	.byt $69, $64, $52, $6A, $51, $54, $42, $50	; tile #200
; Walkbox Data
wb_data
; Walk matrix
wb_matrix
; Palette Information is stored as one column only for now...
; Palette
palette
.byt 2, 7, 2, 7, 2, 7, 2, 7, 2, 7, 2, 7, 2, 7, 2, 7
.byt 2, 7, 2, 7, 2, 7, 2, 7, 2, 7, 2, 7, 2, 7, 2, 7
.byt 2, 7, 2, 7, 2, 7, 2, 7, 2, 7, 2, 7, 2, 7, 2, 7
.byt 2, 7, 2, 7, 2, 7, 2, 7, 2, 7, 2, 7, 2, 7, 2, 7
.byt 2, 7, 2, 7, 2, 7, 2, 7, 2, 7, 2, 7, 2, 7, 2, 7
.byt 2, 7, 2, 7, 2, 7, 2, 7, 2, 7, 2, 7, 2, 7, 2, 7
.byt 2, 7, 2, 7, 2, 7, 2, 7, 2, 7, 2, 7, 2, 7, 2, 7
.byt 2, 7, 2, 7, 2, 7, 2, 7, 2, 7, 2, 7, 2, 7, 2, 7
.byt 2, 7, 2, 7, 2, 7, 2, 7


res_end
.)



#include "..\scripts\locker.s"


