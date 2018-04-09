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
; Room: Caentry
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.(
	.byt RESOURCE_ROOM
	.word (res_end - res_start + 4)
	.byt 36
res_start
; No. columns, offset to tile map, offset to tiles
	.byt 71, <(column_data-res_start), >(column_data-res_start), <(tiles_start-res_start), >(tiles_start-res_start)
; No. zplanes and offsets to zplanes
	.byt 0
; No. Walkboxes and offsets to wb data and matrix
	.byt 2, <(wb_data-res_start), >(wb_data-res_start), <(wb_matrix-res_start), >(wb_matrix-res_start)
; Offset to palette
	.byt <(palette-res_start), >(palette-res_start)
; Entry and exit scripts
	.byt 200, 255
; Number of objects in the room and list of ids
	.byt 2,200,201
; Room name (null terminated)
	.asc "Caentry", 0
; Room tile map
column_data
	.byt 000, 003, 007, 010, 013, 010, 013, 011, 009, 010, 013, 011, 009, 010, 013, 172, 179
	.byt 000, 004, 003, 011, 009, 012, 014, 010, 013, 012, 014, 010, 013, 012, 014, 173, 179
	.byt 000, 005, 006, 010, 013, 011, 009, 012, 014, 011, 009, 012, 014, 011, 009, 174, 179
	.byt 000, 005, 006, 012, 014, 010, 013, 011, 009, 010, 013, 011, 009, 010, 013, 173, 179
	.byt 000, 004, 003, 011, 009, 012, 014, 010, 013, 011, 009, 125, 146, 157, 164, 175, 179
	.byt 000, 006, 008, 003, 013, 011, 009, 011, 009, 010, 013, 126, 014, 010, 013, 172, 179
	.byt 000, 003, 006, 006, 007, 010, 013, 010, 013, 011, 009, 127, 009, 011, 009, 173, 179
	.byt 000, 005, 004, 003, 006, 011, 009, 011, 009, 010, 013, 128, 013, 010, 013, 172, 179
	.byt 000, 003, 003, 006, 003, 010, 013, 010, 013, 012, 014, 127, 009, 012, 014, 176, 179
	.byt 000, 007, 000, 006, 008, 011, 009, 012, 014, 011, 009, 128, 013, 011, 009, 173, 179
	.byt 000, 005, 004, 003, 006, 010, 013, 011, 009, 010, 013, 129, 147, 158, 013, 174, 179
	.byt 000, 005, 003, 003, 013, 012, 014, 010, 013, 012, 014, 130, 148, 159, 014, 172, 179
	.byt 000, 005, 003, 006, 003, 011, 009, 012, 014, 011, 009, 131, 146, 157, 164, 175, 179
	.byt 000, 006, 008, 003, 006, 010, 013, 011, 009, 010, 013, 011, 009, 010, 013, 177, 179
	.byt 000, 003, 006, 006, 007, 012, 014, 010, 013, 011, 009, 010, 013, 011, 009, 177, 179
	.byt 000, 005, 004, 003, 003, 011, 009, 011, 009, 010, 013, 011, 009, 010, 013, 172, 179
	.byt 000, 005, 000, 006, 007, 010, 013, 010, 013, 011, 009, 010, 013, 011, 009, 173, 179
	.byt 000, 006, 008, 003, 006, 012, 014, 011, 009, 010, 013, 012, 014, 010, 013, 174, 179
	.byt 000, 003, 006, 008, 003, 011, 009, 010, 013, 012, 014, 011, 009, 012, 014, 173, 179
	.byt 000, 005, 004, 003, 013, 010, 013, 012, 014, 011, 009, 010, 013, 011, 009, 174, 179
	.byt 000, 005, 006, 012, 014, 011, 009, 011, 009, 010, 013, 011, 009, 010, 013, 172, 179
	.byt 000, 004, 003, 011, 009, 010, 013, 010, 013, 011, 009, 010, 013, 012, 014, 173, 179
	.byt 000, 005, 004, 003, 013, 020, 027, 037, 059, 081, 013, 012, 014, 011, 009, 174, 179
	.byt 000, 005, 004, 006, 008, 021, 028, 038, 060, 082, 005, 132, 009, 010, 013, 173, 179
	.byt 000, 005, 000, 010, 015, 022, 029, 039, 039, 000, 106, 133, 149, 011, 009, 174, 179
	.byt 000, 005, 004, 012, 016, 023, 030, 040, 000, 005, 000, 134, 150, 160, 000, 172, 179
	.byt 000, 004, 000, 011, 017, 024, 031, 041, 005, 020, 107, 135, 151, 000, 165, 173, 179
	.byt 000, 003, 003, 006, 005, 000, 032, 042, 061, 083, 108, 136, 084, 161, 166, 174, 179
	.byt 000, 005, 006, 004, 018, 005, 033, 000, 005, 002, 109, 018, 005, 162, 167, 173, 179
	.byt 000, 006, 008, 012, 003, 004, 003, 007, 000, 084, 005, 007, 152, 005, 000, 174, 179
	.byt 000, 003, 006, 011, 009, 011, 034, 039, 062, 000, 110, 137, 034, 000, 013, 172, 179
	.byt 000, 003, 007, 010, 013, 025, 035, 043, 063, 085, 111, 138, 005, 012, 014, 173, 179
	.byt 000, 004, 003, 011, 009, 026, 036, 044, 064, 086, 005, 000, 009, 011, 009, 172, 179
	.byt 000, 005, 006, 010, 013, 012, 014, 045, 065, 087, 112, 139, 139, 139, 139, 176, 179
	.byt 000, 005, 006, 012, 014, 011, 009, 046, 066, 088, 113, 140, 140, 140, 140, 174, 179
	.byt 000, 004, 003, 011, 009, 010, 013, 047, 067, 000, 000, 000, 000, 000, 000, 172, 179
	.byt 000, 005, 004, 003, 013, 012, 014, 048, 000, 000, 000, 000, 000, 000, 168, 177, 179
	.byt 000, 005, 000, 006, 008, 011, 009, 049, 000, 000, 000, 000, 000, 000, 000, 178, 179
	.byt 000, 005, 004, 003, 006, 010, 013, 049, 000, 000, 000, 000, 000, 000, 000, 177, 179
	.byt 000, 004, 000, 008, 005, 012, 014, 050, 068, 089, 114, 141, 141, 114, 141, 177, 179
	.byt 000, 005, 007, 000, 019, 011, 009, 051, 069, 090, 115, 142, 142, 142, 142, 172, 179
	.byt 000, 005, 004, 003, 006, 010, 013, 052, 070, 091, 116, 143, 143, 163, 169, 173, 179
	.byt 000, 004, 000, 003, 019, 003, 006, 010, 013, 092, 117, 117, 153, 010, 013, 174, 179
	.byt 000, 003, 009, 011, 009, 012, 014, 012, 014, 093, 118, 118, 154, 012, 014, 174, 179
	.byt 000, 000, 000, 000, 002, 011, 009, 012, 014, 094, 119, 144, 155, 011, 009, 172, 179
	.byt 000, 000, 002, 000, 000, 000, 000, 011, 009, 095, 120, 145, 156, 010, 013, 172, 179
	.byt 000, 000, 000, 000, 001, 000, 000, 002, 000, 000, 121, 000, 000, 011, 009, 173, 179
	.byt 000, 001, 000, 000, 002, 000, 000, 000, 000, 000, 122, 000, 000, 000, 000, 174, 179
	.byt 000, 002, 000, 000, 000, 000, 000, 000, 000, 000, 123, 000, 000, 000, 000, 172, 179
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 096, 124, 000, 000, 000, 165, 173, 179
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 097, 000, 000, 000, 000, 166, 174, 179
	.byt 000, 000, 000, 000, 001, 000, 000, 000, 000, 098, 000, 000, 000, 000, 096, 173, 179
	.byt 000, 001, 000, 000, 000, 000, 000, 000, 071, 099, 000, 000, 000, 000, 000, 174, 179
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 072, 000, 000, 000, 000, 000, 170, 172, 179
	.byt 000, 000, 000, 000, 000, 000, 000, 053, 073, 000, 000, 000, 000, 000, 000, 173, 179
	.byt 000, 000, 000, 000, 000, 001, 000, 054, 000, 000, 000, 000, 000, 000, 170, 172, 179
	.byt 000, 000, 001, 000, 000, 000, 000, 055, 000, 000, 000, 000, 000, 000, 000, 176, 179
	.byt 000, 000, 000, 000, 000, 000, 000, 056, 000, 000, 000, 000, 000, 000, 168, 174, 179
	.byt 000, 000, 000, 000, 001, 000, 000, 057, 000, 000, 000, 000, 000, 000, 000, 172, 179
	.byt 000, 001, 000, 000, 000, 000, 000, 058, 074, 000, 000, 000, 000, 000, 168, 177, 179
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 075, 000, 000, 000, 000, 000, 000, 178, 179
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 076, 000, 000, 000, 000, 000, 168, 177, 179
	.byt 000, 000, 000, 000, 000, 001, 000, 000, 077, 000, 000, 000, 000, 000, 171, 177, 179
	.byt 000, 000, 001, 000, 000, 000, 000, 000, 078, 000, 000, 000, 000, 000, 170, 172, 179
	.byt 000, 002, 000, 000, 000, 000, 000, 000, 079, 000, 000, 000, 000, 000, 171, 173, 179
	.byt 001, 000, 001, 000, 000, 000, 000, 000, 080, 100, 000, 000, 000, 000, 000, 174, 179
	.byt 002, 000, 000, 000, 001, 000, 000, 000, 000, 101, 000, 000, 000, 000, 000, 174, 179
	.byt 000, 001, 000, 000, 000, 000, 000, 000, 000, 102, 000, 000, 000, 000, 170, 172, 179
	.byt 000, 000, 000, 000, 000, 000, 000, 001, 000, 103, 000, 000, 000, 000, 170, 172, 179
	.byt 000, 000, 000, 000, 000, 000, 000, 000, 000, 104, 000, 000, 000, 000, 171, 173, 179
	.byt 000, 000, 000, 000, 002, 000, 000, 000, 000, 105, 000, 000, 000, 000, 000, 174, 179

; Room tile set
tiles_start
	.byt $40, $48, $40, $40, $40, $40, $40, $40	; tile #1
	.byt $40, $40, $40, $40, $44, $40, $40, $40	; tile #2
	.byt $40, $41, $48, $40, $48, $44, $60, $48	; tile #3
	.byt $64, $61, $40, $40, $4C, $64, $65, $44	; tile #4
	.byt $49, $40, $48, $42, $44, $40, $42, $48	; tile #5
	.byt $40, $40, $48, $60, $40, $40, $40, $40	; tile #6
	.byt $40, $40, $42, $40, $42, $50, $54, $48	; tile #7
	.byt $40, $60, $40, $40, $40, $40, $40, $40	; tile #8
	.byt $6A, $50, $6A, $40, $6A, $44, $68, $40	; tile #9
	.byt $40, $5F, $7F, $75, $7A, $7D, $7F, $75	; tile #10
	.byt $40, $7C, $7A, $56, $6A, $56, $6A, $50	; tile #11
	.byt $40, $7F, $7E, $55, $6E, $55, $6A, $5C	; tile #12
	.byt $7A, $75, $7A, $75, $6B, $74, $5F, $40	; tile #13
	.byt $6A, $50, $6A, $40, $7D, $40, $7A, $40	; tile #14
	.byt $40, $60, $48, $4C, $4D, $4E, $4D, $70	; tile #15
	.byt $40, $40, $40, $40, $40, $44, $41, $42	; tile #16
	.byt $41, $40, $40, $40, $40, $40, $40, $42	; tile #17
	.byt $48, $40, $40, $40, $40, $40, $40, $44	; tile #18
	.byt $40, $64, $61, $40, $40, $4C, $64, $65	; tile #19
	.byt $40, $40, $40, $40, $42, $40, $40, $40	; tile #20
	.byt $41, $40, $44, $50, $64, $46, $43, $4B	; tile #21
	.byt $74, $40, $40, $4C, $4C, $4C, $4C, $6C	; tile #22
	.byt $42, $48, $40, $40, $43, $42, $4A, $42	; tile #23
	.byt $59, $50, $41, $44, $42, $50, $54, $41	; tile #24
	.byt $78, $40, $42, $40, $42, $46, $4C, $5D	; tile #25
	.byt $40, $40, $40, $60, $54, $40, $40, $40	; tile #26
	.byt $42, $44, $40, $40, $40, $41, $40, $41	; tile #27
	.byt $4C, $4F, $59, $68, $6C, $4F, $43, $6D	; tile #28
	.byt $47, $40, $60, $48, $40, $66, $74, $65	; tile #29
	.byt $40, $68, $41, $40, $41, $42, $40, $41	; tile #30
	.byt $40, $40, $41, $40, $40, $40, $50, $40	; tile #31
	.byt $40, $40, $40, $50, $40, $40, $40, $40	; tile #32
	.byt $40, $40, $48, $40, $40, $40, $40, $40	; tile #33
	.byt $4E, $50, $40, $41, $40, $46, $42, $4A	; tile #34
	.byt $43, $4F, $59, $41, $43, $5F, $7C, $5B	; tile #35
	.byt $44, $42, $60, $50, $50, $48, $40, $58	; tile #36
	.byt $43, $41, $42, $48, $52, $4E, $41, $70	; tile #37
	.byt $4F, $5F, $52, $40, $44, $46, $40, $70	; tile #38
	.byt $40, $40, $40, $60, $40, $64, $48, $58	; tile #39
	.byt $60, $50, $54, $40, $44, $40, $42, $41	; tile #40
	.byt $40, $40, $40, $40, $40, $60, $60, $40	; tile #41
	.byt $40, $40, $40, $40, $40, $44, $42, $40	; tile #42
	.byt $7F, $7F, $54, $40, $42, $46, $60, $40	; tile #43
	.byt $4C, $68, $64, $41, $44, $47, $48, $70	; tile #44
	.byt $7F, $7E, $7D, $56, $6C, $54, $69, $52	; tile #45
	.byt $7C, $79, $51, $42, $51, $6D, $52, $76	; tile #46
	.byt $74, $6A, $5F, $7D, $5E, $5D, $7E, $77	; tile #47
	.byt $5E, $61, $4E, $4F, $75, $4A, $44, $40	; tile #48
	.byt $57, $68, $57, $71, $73, $4F, $43, $40	; tile #49
	.byt $68, $54, $7B, $7D, $7E, $4F, $74, $55	; tile #50
	.byt $40, $5F, $4A, $61, $64, $58, $66, $7E	; tile #51
	.byt $40, $7C, $78, $56, $6C, $52, $4C, $42	; tile #52
	.byt $40, $40, $40, $40, $40, $41, $42, $4E	; tile #53
	.byt $40, $40, $47, $5C, $70, $40, $40, $40	; tile #54
	.byt $40, $40, $7F, $40, $40, $40, $40, $40	; tile #55
	.byt $40, $40, $78, $4E, $41, $40, $40, $40	; tile #56
	.byt $40, $40, $40, $40, $70, $4C, $43, $40	; tile #57
	.byt $40, $40, $40, $40, $40, $40, $78, $4E	; tile #58
	.byt $66, $66, $43, $46, $46, $46, $4C, $46	; tile #59
	.byt $40, $40, $46, $58, $5A, $5C, $45, $40	; tile #60
	.byt $42, $54, $40, $40, $40, $40, $40, $40	; tile #61
	.byt $40, $40, $40, $40, $40, $42, $41, $41	; tile #62
	.byt $40, $40, $46, $51, $45, $53, $4A, $60	; tile #63
	.byt $46, $46, $4C, $66, $66, $66, $43, $46	; tile #64
	.byt $75, $46, $48, $52, $5D, $5C, $5F, $5F	; tile #65
	.byt $4E, $75, $76, $4C, $78, $60, $40, $40	; tile #66
	.byt $6A, $44, $40, $40, $40, $40, $40, $40	; tile #67
	.byt $5A, $51, $42, $40, $42, $42, $41, $41	; tile #68
	.byt $7F, $7D, $7D, $76, $58, $6A, $49, $49	; tile #69
	.byt $44, $60, $44, $40, $74, $78, $6C, $6A	; tile #70
	.byt $40, $40, $40, $40, $40, $40, $41, $47	; tile #71
	.byt $40, $41, $41, $43, $4E, $78, $60, $40	; tile #72
	.byt $58, $60, $40, $40, $40, $40, $40, $40	; tile #73
	.byt $43, $40, $40, $40, $40, $40, $40, $40	; tile #74
	.byt $78, $47, $40, $40, $40, $40, $40, $40	; tile #75
	.byt $40, $7F, $40, $40, $40, $40, $40, $40	; tile #76
	.byt $40, $60, $5C, $43, $40, $40, $40, $40	; tile #77
	.byt $40, $40, $40, $70, $5F, $40, $40, $40	; tile #78
	.byt $40, $40, $40, $40, $60, $50, $48, $47	; tile #79
	.byt $40, $40, $40, $40, $40, $40, $40, $60	; tile #80
	.byt $45, $46, $61, $69, $40, $40, $40, $40	; tile #81
	.byt $40, $50, $50, $40, $54, $40, $4C, $40	; tile #82
	.byt $40, $40, $40, $40, $60, $60, $44, $42	; tile #83
	.byt $40, $40, $40, $40, $40, $40, $40, $44	; tile #84
	.byt $40, $40, $40, $40, $42, $40, $43, $40	; tile #85
	.byt $4A, $66, $68, $49, $60, $40, $40, $40	; tile #86
	.byt $5D, $5E, $59, $41, $7E, $41, $5E, $56	; tile #87
	.byt $60, $40, $60, $40, $60, $40, $60, $60	; tile #88
	.byt $41, $42, $40, $41, $43, $41, $41, $43	; tile #89
	.byt $4B, $57, $66, $69, $52, $60, $7A, $79	; tile #90
	.byt $74, $48, $70, $74, $40, $62, $74, $52	; tile #91
	.byt $5F, $5D, $7F, $77, $7F, $7D, $7F, $77	; tile #92
	.byt $7F, $77, $7F, $5A, $7F, $77, $7F, $5D	; tile #93
	.byt $7F, $5D, $55, $76, $75, $5C, $7D, $76	; tile #94
	.byt $60, $68, $52, $46, $4A, $56, $4A, $60	; tile #95
	.byt $40, $40, $40, $40, $40, $40, $40, $41	; tile #96
	.byt $40, $40, $40, $43, $46, $48, $58, $40	; tile #97
	.byt $40, $43, $4E, $50, $40, $40, $40, $40	; tile #98
	.byt $7C, $40, $40, $40, $40, $40, $40, $40	; tile #99
	.byt $5E, $41, $40, $40, $40, $40, $40, $40	; tile #100
	.byt $40, $70, $4C, $43, $40, $40, $40, $40	; tile #101
	.byt $40, $40, $40, $7F, $40, $40, $40, $40	; tile #102
	.byt $40, $40, $40, $7E, $41, $40, $40, $40	; tile #103
	.byt $40, $40, $40, $40, $7F, $40, $40, $40	; tile #104
	.byt $40, $40, $40, $40, $77, $41, $40, $40	; tile #105
	.byt $56, $44, $40, $60, $40, $40, $78, $48	; tile #106
	.byt $42, $40, $40, $40, $40, $40, $40, $40	; tile #107
	.byt $41, $62, $41, $42, $40, $40, $40, $40	; tile #108
	.byt $44, $40, $40, $40, $40, $40, $40, $40	; tile #109
	.byt $46, $42, $40, $40, $40, $40, $41, $41	; tile #110
	.byt $60, $40, $40, $58, $40, $40, $78, $40	; tile #111
	.byt $4B, $49, $51, $5E, $58, $58, $5D, $5F	; tile #112
	.byt $40, $40, $40, $60, $60, $60, $60, $60	; tile #113
	.byt $7D, $6E, $7C, $7D, $43, $43, $42, $42	; tile #114
	.byt $7A, $48, $73, $6A, $7C, $7C, $7B, $7B	; tile #115
	.byt $74, $40, $64, $50, $44, $40, $74, $6A	; tile #116
	.byt $7F, $7D, $7F, $77, $7F, $7D, $7F, $77	; tile #117
	.byt $7F, $77, $7F, $5D, $7F, $77, $7F, $5D	; tile #118
	.byt $7D, $5C, $7D, $76, $7D, $5C, $7F, $76	; tile #119
	.byt $4A, $60, $4A, $60, $4A, $64, $4A, $64	; tile #120
	.byt $40, $40, $40, $40, $40, $46, $50, $40	; tile #121
	.byt $40, $40, $40, $40, $47, $78, $40, $40	; tile #122
	.byt $40, $41, $42, $4C, $50, $40, $40, $40	; tile #123
	.byt $46, $68, $40, $40, $40, $40, $40, $40	; tile #124
	.byt $40, $50, $74, $72, $70, $70, $72, $72	; tile #125
	.byt $40, $7F, $7E, $55, $4E, $40, $71, $5C	; tile #126
	.byt $40, $7C, $7A, $56, $6A, $40, $7F, $50	; tile #127
	.byt $40, $5F, $7F, $75, $7A, $40, $7F, $75	; tile #128
	.byt $40, $7C, $7A, $56, $6A, $4F, $60, $60	; tile #129
	.byt $40, $5F, $7F, $75, $7A, $7C, $41, $41	; tile #130
	.byt $40, $50, $74, $72, $42, $42, $72, $72	; tile #131
	.byt $4E, $4E, $45, $40, $44, $46, $43, $4B	; tile #132
	.byt $44, $40, $70, $60, $78, $4C, $48, $6C	; tile #133
	.byt $40, $40, $44, $40, $44, $40, $42, $41	; tile #134
	.byt $41, $40, $40, $40, $40, $60, $60, $42	; tile #135
	.byt $40, $40, $40, $40, $60, $70, $50, $70	; tile #136
	.byt $42, $40, $40, $40, $41, $43, $41, $43	; tile #137
	.byt $47, $47, $5A, $50, $72, $46, $4C, $5D	; tile #138
	.byt $40, $5F, $4C, $5E, $7E, $7E, $5E, $6E	; tile #139
	.byt $60, $60, $60, $60, $60, $60, $60, $60	; tile #140
	.byt $40, $42, $42, $40, $42, $42, $41, $42	; tile #141
	.byt $59, $7A, $73, $58, $6B, $4B, $5B, $4B	; tile #142
	.byt $7C, $7A, $64, $50, $7C, $70, $6C, $7A	; tile #143
	.byt $7F, $5C, $7D, $76, $7D, $5C, $7F, $77	; tile #144
	.byt $4A, $60, $5A, $60, $5A, $64, $4A, $44	; tile #145
	.byt $72, $72, $72, $72, $62, $72, $52, $42	; tile #146
	.byt $60, $60, $64, $64, $64, $66, $62, $63	; tile #147
	.byt $41, $41, $51, $51, $51, $51, $51, $51	; tile #148
	.byt $47, $40, $40, $48, $40, $46, $44, $45	; tile #149
	.byt $41, $60, $40, $40, $40, $40, $40, $42	; tile #150
	.byt $49, $40, $41, $44, $62, $70, $54, $71	; tile #151
	.byt $48, $40, $40, $40, $50, $70, $60, $74	; tile #152
	.byt $7F, $7D, $7F, $77, $7F, $5D, $5F, $40	; tile #153
	.byt $7F, $77, $7F, $5D, $7F, $77, $5E, $40	; tile #154
	.byt $7F, $5D, $7E, $74, $7D, $50, $7A, $40	; tile #155
	.byt $4A, $40, $6A, $40, $6A, $44, $68, $40	; tile #156
	.byt $42, $72, $72, $52, $62, $52, $62, $52	; tile #157
	.byt $61, $50, $50, $50, $50, $50, $4F, $41	; tile #158
	.byt $51, $51, $51, $53, $42, $46, $44, $7C	; tile #159
	.byt $49, $40, $41, $44, $42, $40, $44, $41	; tile #160
	.byt $42, $40, $42, $42, $44, $40, $40, $40	; tile #161
	.byt $40, $40, $40, $40, $40, $40, $40, $50	; tile #162
	.byt $7C, $78, $60, $56, $7E, $72, $6C, $7E	; tile #163
	.byt $62, $52, $62, $42, $62, $42, $62, $42	; tile #164
	.byt $40, $40, $40, $40, $40, $41, $40, $48	; tile #165
	.byt $40, $40, $40, $40, $40, $40, $70, $70	; tile #166
	.byt $40, $50, $40, $50, $40, $48, $40, $41	; tile #167
	.byt $40, $40, $40, $40, $40, $48, $70, $51	; tile #168
	.byt $7E, $7A, $64, $52, $7C, $72, $6C, $7A	; tile #169
	.byt $40, $40, $40, $40, $40, $40, $40, $48	; tile #170
	.byt $40, $40, $40, $40, $40, $48, $70, $71	; tile #171
	.byt $72, $76, $7F, $7F, $7F, $7F, $7F, $7F	; tile #172
	.byt $76, $76, $7F, $7F, $7F, $7F, $7F, $7F	; tile #173
	.byt $56, $76, $7F, $7F, $7F, $7F, $7F, $7F	; tile #174
	.byt $52, $72, $72, $72, $72, $72, $74, $79	; tile #175
	.byt $72, $72, $7F, $7F, $7F, $7F, $7F, $7F	; tile #176
	.byt $56, $52, $7F, $7F, $7F, $7F, $7F, $7F	; tile #177
	.byt $52, $52, $7F, $7F, $7F, $7F, $7F, $7F	; tile #178
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F	; tile #179
; Walkbox Data
wb_data
	.byt 014, 070, 015, 016, $01
	.byt 000, 013, 016, 016, $01
; Walk matrix
wb_matrix
	.byt 0, 1
	.byt 0, 1
; Palette Information is stored as one column only for now...
; Palette
palette
.byt 6, 2, 6, 2, 6, 2, 6, 2, 6, 2, 6, 2, 6, 2, 6, 2
.byt 6, 2, 6, 2, 6, 2, 6, 2, 6, 2, 6, 2, 6, 2, 6, 2
.byt 6, 2, 6, 2, 6, 2, 6, 2, 6, 2, 6, 2, 6, 2, 6, 2
.byt 6, 2, 6, 2, 6, 2, 6, 2, 6, 2, 6, 2, 6, 2, 6, 2
.byt 6, 2, 6, 2, 6, 2, 6, 2, 6, 2, 6, 2, 6, 2, 6, 2
.byt 6, 2, 6, 2, 6, 2, 6, 2, 6, 2, 6, 2, 6, 2, 6, 2
.byt 6, 2, 6, 2, 6, 2, 6, 2, 6, 2, 6, 2, 6, 2, 6, 2
.byt 6, 2, 6, 2, 6, 2, 6, 2, 6, 2, 6, 2, 6, 2, 6, 2
.byt 6, 2, 6, 2, 6, 2, 6, 2


res_end
.)


; Object resource 200: Exit to path
.(
	.byt RESOURCE_OBJECT|$80
	.word (res_end-res_start+4)
	.byt 200
res_start
	.byt 0|OBJ_FLAG_PROP
	.byt 2,16	;Size (cols, rows)
	.byt 255	;Initial room
	.byt 69,16	;Location (col, row)
	.byt ZPLANE_1	;Zplane
	.byt 68,15	;Walk position (col, row)
	.byt FACING_RIGHT
	.byt 0	; Color of text
#ifdef ENGLISH	
	.asc "Path",0	;Object's name
#endif
#ifdef SPANISH
	.asc "Camino",0	;Object's name
#endif		
#ifdef FRENCH
	.asc "Chemin",0	;Object's name
#endif		
res_end
.)


; Object resource 201: Front door
.(
	.byt RESOURCE_OBJECT|$80
	.word (res_end - res_start +4)
	.byt 201
res_start
	.byt 0			; If OBJ_FLAG_PROP skip all costume data
	.byt 6,7		; Size (cols rows)
	.byt $ff		; Room
	.byt 34,14		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt 30,15		; Walk position (col, row)
	.byt FACING_RIGHT		; Facing direction for interaction
	.byt 0			; Color of text

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
	.asc "Porte",0	;Object's name
#endif		
res_end	
.)


; Object resource 202: Clothes
.(
	.byt RESOURCE_OBJECT|$80
	.word (res_end - res_start +4)
	.byt 202
res_start
	.byt 0			; If OBJ_FLAG_PROP skip all costume data
	.byt 6,2		; Size (cols rows)
	.byt $ff		; Room
	.byt 6,13		; Pos (col, row)
	.byt ZPLANE_0		; Zplane
	.byt 8,16		; Walk position (col, row)
	.byt FACING_LEFT		; Facing direction for interaction
	.byt 0			; Color of text

	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt 201		; costume ($ff for none) and skip the rest
	.byt 0			; entry in costume resource		
	.byt 0			; direction (0 or LOOK_RIGHT for animstate 0)
	.byt 0			; animation speed
#ifdef ENGLISH	
	.asc "Clothes",0	;Object's name
#endif
#ifdef SPANISH
	.asc "Ropas",0	;Object's name
#endif		
#ifdef FRENCH
	.asc "Vetements",0	;Object's name
#endif		
res_end	
.)


; Costume for Door
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
; Animatory state 0 (cadoor.png)
.byt 1, 2, 3, 4, 5
.byt 6, 7, 8, 9, 7
.byt 10, 11, 12, 13, 11
.byt 14, 15, 8, 4, 16
.byt 17, 18, 8, 4, 16
.byt 19, 20, 21, 22, 23
.byt 4, 24, 25, 9, 24
; Animatory state 1 (cadoor1.png)
.byt 1, 26, 27, 27, 27
.byt 6, 27, 27, 27, 27
.byt 28, 27, 27, 27, 27
.byt 4, 27, 27, 27, 27
.byt 4, 27, 27, 27, 27
.byt 4, 27, 27, 27, 27
.byt 4, 27, 29, 27, 27
costume_tiles
; Tile graphic 1
.byt $e, $35, $36, $c, $38, $20, $0, $0
; Tile graphic 2
.byt $2a, $4, $0, $8, $8, $18, $18, $18
; Tile graphic 3
.byt $0, $1, $1, $1, $1, $1, $1, $1
; Tile graphic 4
.byt $20, $20, $20, $20, $20, $20, $20, $20
; Tile graphic 5
.byt $0, $0, $0, $8, $8, $18, $18, $18
; Tile graphic 6
.byt $20, $0, $20, $0, $20, $0, $20, $20
; Tile graphic 7
.byt $18, $18, $18, $18, $18, $18, $18, $10
; Tile graphic 8
.byt $1, $1, $1, $1, $1, $1, $1, $1
; Tile graphic 9
.byt $20, $20, $20, $20, $20, $20, $20, $0
; Tile graphic 10
.byt $1f, $15, $1f, $1f, $20, $20, $0, $0
; Tile graphic 11
.byt $3f, $2d, $3f, $3f, $10, $18, $18, $18
; Tile graphic 12
.byt $3f, $2d, $3f, $3f, $1, $1, $1, $1
; Tile graphic 13
.byt $3f, $2d, $3f, $3f, $0, $20, $20, $20
; Tile graphic 14
.byt $3f, $0, $1f, $3f, $39, $30, $39, $39
; Tile graphic 15
.byt $3c, $14, $2c, $34, $34, $34, $34, $34
; Tile graphic 16
.byt $18, $18, $18, $18, $18, $18, $18, $18
; Tile graphic 17
.byt $1f, $0, $3f, $20, $20, $20, $20, $20
; Tile graphic 18
.byt $2c, $14, $3c, $18, $18, $18, $18, $18
; Tile graphic 19
.byt $1f, $15, $1f, $1f, $20, $20, $20, $20
; Tile graphic 20
.byt $3f, $2d, $3f, $3f, $8, $18, $18, $18
; Tile graphic 21
.byt $3f, $2d, $3f, $3f, $0, $1, $1, $1
; Tile graphic 22
.byt $3f, $2d, $3f, $3f, $20, $20, $20, $20
; Tile graphic 23
.byt $3f, $3d, $3f, $3f, $8, $18, $18, $18
; Tile graphic 24
.byt $18, $18, $18, $18, $18, $8, $8, $0
; Tile graphic 25
.byt $1, $1, $1, $1, $1, $9, $30, $11
; Tile graphic 26
.byt $2a, $4, $0, $0, $0, $0, $0, $0
; Tile graphic 27
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 28
.byt $0, $0, $0, $20, $20, $20, $20, $20
; Tile graphic 29
.byt $0, $0, $0, $0, $0, $8, $30, $11
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
.byt $40, $40, $40, $40, $40, $40, $40, $40
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
res_end
.)

; Costume for robe
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
; Animatory state 0 (robe.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 1, 2, 0, 0, 0
.byt 3, 4, 0, 0, 0
.byt 5, 6, 0, 0, 0
costume_tiles
; Tile graphic 1
.byt $0, $3c, $3a, $16, $2a, $f, $20, $20
; Tile graphic 2
.byt $0, $1f, $3f, $35, $3a, $3c, $1, $1
; Tile graphic 3
.byt $20, $20, $24, $24, $24, $26, $22, $23
; Tile graphic 4
.byt $1, $1, $11, $11, $11, $11, $11, $11
; Tile graphic 5
.byt $21, $10, $10, $10, $10, $10, $f, $1
; Tile graphic 6
.byt $11, $11, $11, $13, $2, $6, $4, $3c
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
res_end
.)




; Costume for the lamp
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
; Animatory state 0 (lantern.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 0, 0
.byt 4, 5, 6, 0, 0
.byt 7, 8, 9, 0, 0
costume_tiles
; Tile graphic 1
.byt $1d, $3f, $37, $3f, $1f, $3f, $3f, $3e
; Tile graphic 2
.byt $37, $3f, $3f, $3f, $31, $20, $0, $0
; Tile graphic 3
.byt $1d, $3f, $37, $3f, $3d, $3f, $1f, $f
; Tile graphic 4
.byt $1e, $3e, $3f, $3f, $1f, $3f, $3f, $3f
; Tile graphic 5
.byt $0, $3b, $1b, $0, $1b, $2a, $2a, $20
; Tile graphic 6
.byt $f, $2f, $1f, $1f, $1f, $3f, $3f, $3f
; Tile graphic 7
.byt $1f, $3f, $3f, $3f, $1f, $3f, $37, $3f
; Tile graphic 8
.byt $31, $3b, $3f, $3f, $3f, $3f, $3f, $3f
; Tile graphic 9
.byt $3f, $3f, $3f, $3f, $3d, $3f, $37, $3f
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
res_end
.)



#include "..\scripts\cabuilding.s"

