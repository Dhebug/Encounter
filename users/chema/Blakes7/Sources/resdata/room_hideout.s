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
; Room: Hideout-int
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.(
	.byt RESOURCE_ROOM
	.word (res_end - res_start + 4)
	.byt 43
res_start
; No. columns, offset to tile map, offset to tiles
	.byt 76, <(column_data-res_start), >(column_data-res_start), <(tiles_start-res_start), >(tiles_start-res_start)
; No. zplanes and offsets to zplanes
	.byt 0
; No. Walkboxes and offsets to wb data and matrix
	.byt 3, <(wb_data-res_start), >(wb_data-res_start), <(wb_matrix-res_start), >(wb_matrix-res_start)
; Offset to palette
	.byt 0, 0	; No palette information
; Entry and exit scripts
	.byt 200, 201
; Number of objects in the room and list of ids
	.byt 5, 200, 201, 202, 203, 204
; Room name (null terminated)
	.asc "Hideout", 0
; Room tile map
column_data
	.byt 001, 001, 017, 022, 022, 055, 071, 071, 071, 111, 022, 128, 169, 194, 001, 001, 224
	.byt 001, 001, 018, 023, 031, 056, 000, 000, 000, 112, 022, 146, 170, 173, 001, 001, 225
	.byt 001, 001, 019, 024, 032, 057, 000, 000, 000, 113, 022, 147, 171, 195, 209, 218, 226
	.byt 001, 001, 020, 025, 033, 058, 072, 072, 072, 114, 127, 148, 172, 001, 001, 219, 037
	.byt 002, 001, 021, 026, 034, 022, 022, 022, 022, 022, 128, 149, 173, 001, 001, 220, 037
	.byt 003, 001, 001, 027, 035, 022, 073, 073, 073, 022, 129, 150, 174, 001, 210, 037, 037
	.byt 004, 001, 001, 028, 036, 059, 059, 059, 059, 059, 130, 151, 175, 175, 211, 037, 037
	.byt 005, 001, 001, 029, 037, 037, 037, 037, 037, 037, 131, 152, 176, 196, 212, 037, 037
	.byt 006, 011, 011, 030, 038, 038, 038, 038, 038, 038, 132, 153, 011, 197, 037, 037, 037
	.byt 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 177, 037, 037, 037, 037
	.byt 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 178, 037, 037, 037, 037
	.byt 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 177, 037, 037, 037, 037
	.byt 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 178, 037, 037, 037, 037
	.byt 007, 012, 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 177, 037, 037, 037, 037
	.byt 008, 013, 008, 008, 008, 008, 008, 008, 008, 008, 133, 154, 179, 198, 037, 037, 037
	.byt 009, 014, 007, 007, 007, 007, 007, 007, 096, 115, 134, 155, 155, 199, 037, 037, 037
	.byt 008, 015, 008, 008, 008, 008, 074, 085, 097, 116, 135, 156, 180, 200, 037, 037, 037
	.byt 007, 016, 007, 007, 039, 060, 075, 086, 098, 117, 136, 157, 181, 037, 037, 037, 037
	.byt 008, 008, 008, 008, 040, 061, 076, 087, 099, 062, 062, 062, 181, 037, 037, 037, 037
	.byt 007, 007, 007, 007, 041, 062, 062, 062, 062, 062, 062, 062, 181, 037, 037, 037, 037
	.byt 008, 008, 008, 008, 042, 062, 062, 062, 100, 118, 118, 118, 182, 037, 037, 037, 037
	.byt 007, 007, 007, 007, 043, 062, 062, 062, 101, 062, 062, 062, 181, 037, 037, 037, 037
	.byt 008, 008, 008, 008, 042, 062, 062, 088, 102, 062, 062, 062, 181, 037, 037, 037, 037
	.byt 007, 007, 007, 007, 044, 063, 063, 089, 062, 062, 062, 062, 181, 037, 037, 037, 037
	.byt 008, 008, 008, 008, 042, 062, 062, 062, 062, 062, 062, 062, 181, 037, 037, 037, 037
	.byt 007, 012, 007, 007, 045, 062, 062, 062, 062, 062, 062, 062, 181, 037, 037, 037, 037
	.byt 008, 013, 008, 008, 046, 064, 077, 090, 062, 062, 062, 062, 181, 037, 037, 037, 037
	.byt 009, 014, 007, 007, 047, 065, 078, 091, 103, 119, 137, 158, 181, 037, 037, 037, 037
	.byt 008, 015, 008, 008, 008, 008, 079, 092, 104, 116, 138, 159, 183, 201, 037, 037, 037
	.byt 007, 016, 007, 007, 007, 007, 007, 007, 105, 120, 139, 155, 184, 202, 037, 037, 037
	.byt 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 140, 160, 185, 203, 037, 037, 037
	.byt 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 177, 037, 037, 037, 037
	.byt 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 161, 186, 037, 037, 037, 037
	.byt 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 162, 187, 204, 213, 037, 037
	.byt 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 163, 188, 205, 214, 221, 037
	.byt 010, 010, 010, 010, 010, 010, 010, 010, 010, 010, 141, 164, 189, 206, 215, 222, 037
	.byt 008, 008, 008, 008, 008, 008, 008, 008, 008, 121, 142, 165, 190, 207, 216, 223, 037
	.byt 007, 007, 007, 007, 007, 007, 007, 007, 007, 122, 143, 166, 191, 208, 217, 223, 037
	.byt 001, 001, 017, 022, 022, 055, 071, 071, 071, 111, 022, 128, 169, 194, 001, 001, 224
	.byt 001, 001, 018, 023, 031, 056, 000, 000, 000, 112, 022, 146, 170, 173, 001, 001, 225
	.byt 001, 001, 019, 024, 032, 057, 000, 000, 000, 113, 022, 147, 171, 195, 209, 218, 226
	.byt 001, 001, 020, 025, 033, 058, 072, 072, 072, 114, 127, 148, 172, 001, 001, 219, 037
	.byt 002, 001, 021, 026, 034, 022, 022, 022, 022, 022, 128, 149, 173, 001, 001, 220, 037
	.byt 003, 001, 001, 027, 035, 022, 073, 073, 073, 022, 129, 150, 174, 001, 210, 037, 037
	.byt 004, 001, 001, 028, 036, 059, 059, 059, 059, 059, 130, 151, 175, 175, 211, 037, 037
	.byt 005, 001, 001, 029, 037, 037, 037, 037, 037, 037, 131, 152, 176, 196, 212, 037, 037
	.byt 006, 011, 011, 030, 038, 038, 038, 038, 038, 038, 132, 153, 011, 197, 037, 037, 037
	.byt 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 177, 037, 037, 037, 037
	.byt 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 178, 037, 037, 037, 037
	.byt 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 177, 037, 037, 037, 037
	.byt 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 178, 037, 037, 037, 037
	.byt 007, 012, 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 177, 037, 037, 037, 037
	.byt 008, 013, 008, 008, 008, 008, 008, 008, 008, 008, 133, 154, 179, 198, 037, 037, 037
	.byt 009, 014, 007, 007, 007, 007, 007, 007, 096, 115, 134, 155, 155, 199, 037, 037, 037
	.byt 008, 015, 008, 008, 008, 008, 074, 085, 097, 116, 135, 156, 192, 200, 037, 037, 037
	.byt 007, 016, 007, 007, 039, 060, 075, 086, 106, 123, 144, 167, 037, 037, 037, 037, 037
	.byt 008, 008, 008, 008, 040, 066, 080, 093, 107, 124, 037, 037, 037, 037, 037, 037, 037
	.byt 007, 007, 007, 007, 048, 067, 081, 067, 081, 125, 037, 037, 037, 037, 037, 037, 037
	.byt 008, 008, 008, 008, 049, 068, 082, 068, 108, 125, 037, 037, 037, 037, 037, 037, 037
	.byt 007, 007, 007, 007, 050, 069, 083, 069, 109, 125, 037, 037, 037, 037, 037, 037, 037
	.byt 008, 008, 008, 008, 051, 067, 081, 067, 081, 125, 037, 037, 037, 037, 037, 037, 037
	.byt 007, 007, 007, 007, 052, 068, 082, 068, 108, 125, 037, 037, 037, 037, 037, 037, 037
	.byt 008, 008, 008, 008, 053, 069, 083, 069, 109, 125, 037, 037, 037, 037, 037, 037, 037
	.byt 007, 012, 007, 007, 054, 067, 081, 067, 081, 125, 037, 037, 037, 037, 037, 037, 037
	.byt 008, 013, 008, 008, 046, 070, 084, 094, 081, 125, 037, 037, 037, 037, 037, 037, 037
	.byt 009, 014, 007, 007, 047, 065, 078, 095, 110, 126, 145, 168, 037, 037, 037, 037, 037
	.byt 008, 015, 008, 008, 008, 008, 079, 092, 104, 116, 138, 159, 193, 201, 037, 037, 037
	.byt 007, 016, 007, 007, 007, 007, 007, 007, 105, 120, 139, 155, 184, 202, 037, 037, 037
	.byt 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 140, 160, 185, 203, 037, 037, 037
	.byt 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 177, 037, 037, 037, 037
	.byt 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 161, 186, 037, 037, 037, 037
	.byt 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 007, 162, 187, 204, 213, 037, 037
	.byt 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 163, 188, 205, 214, 221, 037
	.byt 010, 010, 010, 010, 010, 010, 010, 010, 010, 010, 141, 164, 189, 206, 215, 222, 037
	.byt 008, 008, 008, 008, 008, 008, 008, 008, 008, 121, 142, 165, 190, 207, 216, 223, 037
	.byt 007, 007, 007, 007, 007, 007, 007, 007, 007, 122, 143, 166, 191, 208, 217, 223, 037

; Room tile set
tiles_start
	.byt $7F, $55, $7F, $55, $7F, $55, $7F, $55	; tile #1
	.byt $78, $55, $7F, $55, $7F, $55, $7F, $55	; tile #2
	.byt $5D, $43, $7C, $55, $7F, $55, $7F, $55	; tile #3
	.byt $77, $7F, $4D, $50, $7F, $55, $7F, $55	; tile #4
	.byt $5D, $7F, $77, $7F, $41, $54, $7F, $55	; tile #5
	.byt $77, $7F, $5D, $7F, $77, $5F, $61, $54	; tile #6
	.byt $5D, $7F, $77, $7F, $5D, $7F, $77, $7F	; tile #7
	.byt $77, $7F, $5D, $7F, $77, $7F, $5D, $7F	; tile #8
	.byt $EF, $50, $EF, $40, $EF, $40, $EF, $40	; tile #9
	.byt $5D, $5F, $57, $5F, $5D, $5F, $57, $5F	; tile #10
	.byt $7E, $54, $7E, $54, $7E, $54, $7E, $54	; tile #11
	.byt $5D, $7F, $77, $7F, $5D, $7C, $CF, $40	; tile #12
	.byt $77, $7F, $5C, $70, $FC, $4C, $FF, $40	; tile #13
	.byt $EF, $40, $FF, $70, $FF, $40, $FF, $40	; tile #14
	.byt $77, $7F, $4D, $43, $FF, $40, $FF, $40	; tile #15
	.byt $5D, $7F, $77, $7F, $5D, $4F, $FE, $40	; tile #16
	.byt $7F, $41, $40, $6A, $40, $6A, $40, $6A	; tile #17
	.byt $7F, $55, $4F, $60, $40, $6A, $40, $6A	; tile #18
	.byt $7F, $55, $7F, $55, $41, $6A, $40, $6A	; tile #19
	.byt $7F, $55, $7F, $55, $7F, $45, $40, $6A	; tile #20
	.byt $7F, $55, $7F, $55, $7F, $55, $5F, $61	; tile #21
	.byt $40, $6A, $40, $6A, $40, $6A, $40, $6A	; tile #22
	.byt $40, $6A, $40, $6A, $40, $60, $5F, $58	; tile #23
	.byt $40, $6A, $40, $6A, $40, $4A, $70, $5F	; tile #24
	.byt $40, $6A, $40, $6A, $40, $6A, $40, $7F	; tile #25
	.byt $40, $6A, $40, $6A, $40, $6A, $40, $40	; tile #26
	.byt $47, $68, $40, $6A, $40, $6A, $40, $42	; tile #27
	.byt $7F, $55, $41, $6A, $41, $6B, $41, $6B	; tile #28
	.byt $7F, $55, $7F, $45, $50, $7F, $55, $7F	; tile #29
	.byt $7E, $54, $7E, $54, $5E, $60, $54, $7E	; tile #30
	.byt $70, $60, $70, $58, $5F, $60, $40, $6A	; tile #31
	.byt $40, $40, $40, $40, $7C, $47, $40, $6A	; tile #32
	.byt $40, $40, $40, $40, $40, $7F, $40, $6A	; tile #33
	.byt $7F, $40, $40, $40, $40, $78, $4F, $60	; tile #34
	.byt $7C, $43, $41, $41, $41, $43, $7C, $42	; tile #35
	.byt $41, $4B, $41, $4B, $41, $4B, $41, $6B	; tile #36
	.byt $55, $7F, $55, $7F, $55, $7F, $55, $7F	; tile #37
	.byt $54, $7E, $54, $7E, $54, $7E, $54, $7E	; tile #38
	.byt $5D, $7E, $76, $7D, $5D, $7D, $73, $79	; tile #39
	.byt $40, $5D, $7F, $77, $7F, $5C, $7E, $76	; tile #40
	.byt $40, $77, $7F, $5D, $40, $5F, $7F, $7F	; tile #41
	.byt $40, $5D, $7F, $77, $40, $7F, $7F, $7F	; tile #42
	.byt $40, $77, $7F, $5D, $40, $7F, $7F, $7F	; tile #43
	.byt $40, $77, $7F, $5D, $40, $7E, $7E, $7E	; tile #44
	.byt $40, $77, $7F, $5D, $40, $7E, $7F, $7F	; tile #45
	.byt $40, $5D, $7F, $77, $7F, $5D, $5F, $57	; tile #46
	.byt $5D, $5F, $57, $5F, $6D, $6F, $67, $57	; tile #47
	.byt $40, $77, $7F, $5D, $40, $4A, $55, $6A	; tile #48
	.byt $40, $5D, $7F, $77, $40, $6A, $54, $6A	; tile #49
	.byt $40, $77, $7F, $5D, $40, $42, $75, $72	; tile #50
	.byt $40, $5D, $7F, $77, $40, $6A, $55, $6A	; tile #51
	.byt $40, $77, $7F, $5D, $40, $6A, $54, $6A	; tile #52
	.byt $40, $5D, $7F, $77, $40, $42, $75, $72	; tile #53
	.byt $40, $77, $7F, $5D, $40, $6A, $55, $6A	; tile #54
	.byt $40, $6A, $40, $6A, $40, $6B, $43, $6A	; tile #55
	.byt $40, $6A, $40, $6A, $40, $7F, $7F, $40	; tile #56
	.byt $40, $6A, $40, $6A, $40, $40, $7F, $4F	; tile #57
	.byt $40, $6A, $40, $6A, $40, $40, $7E, $7E	; tile #58
	.byt $41, $6B, $41, $6B, $41, $6B, $41, $6B	; tile #59
	.byt $5B, $77, $77, $75, $4F, $67, $6F, $5D	; tile #60
	.byt $7E, $5C, $7C, $75, $79, $59, $79, $71	; tile #61
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F	; tile #62
	.byt $7E, $7E, $7E, $7E, $7E, $7E, $7E, $7E	; tile #63
	.byt $5F, $4D, $4F, $67, $67, $65, $67, $77	; tile #64
	.byt $75, $77, $7B, $5B, $79, $75, $7D, $5D	; tile #65
	.byt $7E, $5C, $7C, $74, $79, $59, $79, $70	; tile #66
	.byt $40, $7F, $7F, $7F, $C0, $7F, $7F, $40	; tile #67
	.byt $40, $7E, $7E, $7E, $C1, $7E, $7E, $40	; tile #68
	.byt $70, $73, $73, $73, $CC, $73, $73, $70	; tile #69
	.byt $5F, $4D, $4F, $67, $67, $65, $67, $47	; tile #70
	.byt $42, $6A, $42, $6A, $42, $6A, $42, $6A	; tile #71
	.byt $42, $42, $42, $42, $42, $42, $42, $42	; tile #72
	.byt $40, $6C, $4C, $5A, $5A, $6C, $4C, $62	; tile #73
	.byt $77, $7F, $5C, $7E, $76, $7D, $5D, $7D	; tile #74
	.byt $5F, $57, $7F, $5D, $7F, $77, $7F, $5D	; tile #75
	.byt $73, $53, $73, $73, $6B, $47, $67, $67	; tile #76
	.byt $73, $71, $73, $79, $79, $79, $79, $7A	; tile #77
	.byt $7E, $76, $7E, $5D, $7F, $77, $7F, $5D	; tile #78
	.byt $77, $7F, $5D, $5F, $57, $5F, $6D, $6F	; tile #79
	.byt $71, $52, $71, $72, $61, $42, $65, $62	; tile #80
	.byt $55, $6A, $55, $6A, $55, $6A, $55, $6A	; tile #81
	.byt $54, $6A, $54, $6A, $55, $6A, $54, $6A	; tile #82
	.byt $71, $72, $45, $6A, $55, $42, $75, $72	; tile #83
	.byt $53, $61, $53, $69, $51, $69, $51, $68	; tile #84
	.byt $73, $79, $5B, $77, $77, $75, $4F, $67	; tile #85
	.byt $7F, $77, $7F, $5C, $7E, $76, $7E, $5C	; tile #86
	.byt $57, $4F, $4F, $6F, $6F, $6F, $5F, $5F	; tile #87
	.byt $7F, $7F, $7F, $7F, $7E, $7D, $73, $6F	; tile #88
	.byt $7E, $7C, $7B, $67, $5F, $7F, $7F, $7F	; tile #89
	.byt $7C, $7C, $7C, $7D, $7E, $7E, $7E, $7E	; tile #90
	.byt $7F, $77, $7F, $5D, $5F, $57, $6F, $6D	; tile #91
	.byt $67, $57, $75, $73, $7B, $5B, $7D, $75	; tile #92
	.byt $40, $4F, $5F, $5F, $E0, $5F, $5F, $40	; tile #93
	.byt $40, $7C, $7E, $7E, $C1, $7E, $7F, $40	; tile #94
	.byt $7F, $77, $7F, $5D, $5F, $57, $4F, $4D	; tile #95
	.byt $5D, $7F, $77, $7F, $5C, $7E, $76, $7D	; tile #96
	.byt $6F, $5D, $5F, $57, $7F, $5D, $7F, $77	; tile #97
	.byt $7D, $74, $7D, $5A, $78, $72, $74, $52	; tile #98
	.byt $5F, $5F, $5F, $7F, $7F, $7F, $7F, $7F	; tile #99
	.byt $7F, $7F, $7F, $7F, $7E, $79, $67, $5F	; tile #100
	.byt $7E, $79, $77, $4F, $7F, $7F, $7F, $7F	; tile #101
	.byt $5F, $7F, $7F, $7F, $7F, $7F, $7F, $7F	; tile #102
	.byt $4F, $47, $57, $55, $57, $6B, $63, $69	; tile #103
	.byt $7D, $5C, $7E, $76, $7F, $5D, $7F, $77	; tile #104
	.byt $5D, $7F, $77, $7F, $5D, $5F, $57, $4F	; tile #105
	.byt $7C, $75, $7C, $5A, $78, $72, $74, $52	; tile #106
	.byt $55, $4A, $55, $6A, $55, $6A, $55, $6A	; tile #107
	.byt $54, $6A, $54, $6A, $55, $6A, $55, $6A	; tile #108
	.byt $71, $72, $45, $6A, $55, $6A, $55, $6A	; tile #109
	.byt $4F, $47, $57, $45, $57, $6B, $43, $69	; tile #110
	.byt $42, $6A, $42, $6A, $42, $6A, $43, $6B	; tile #111
	.byt $40, $40, $40, $40, $40, $4F, $7F, $70	; tile #112
	.byt $40, $40, $40, $43, $7F, $78, $40, $6A	; tile #113
	.byt $42, $42, $4E, $7E, $60, $4A, $40, $6A	; tile #114
	.byt $5D, $7D, $73, $79, $5B, $77, $77, $75	; tile #115
	.byt $7F, $5D, $7F, $77, $7F, $5D, $7F, $77	; tile #116
	.byt $75, $71, $65, $49, $65, $6B, $53, $4B	; tile #117
	.byt $5F, $5F, $5F, $5F, $5F, $5F, $5F, $5F	; tile #118
	.byt $63, $71, $75, $71, $74, $7A, $78, $7A	; tile #119
	.byt $6D, $6F, $77, $57, $75, $73, $7B, $5B	; tile #120
	.byt $77, $7F, $5D, $7F, $77, $7F, $5D, $7C	; tile #121
	.byt $5D, $7F, $77, $7F, $5D, $7F, $77, $43	; tile #122
	.byt $75, $70, $64, $48, $64, $6A, $51, $48	; tile #123
	.byt $40, $5F, $C0, $7F, $40, $6A, $55, $40	; tile #124
	.byt $40, $7F, $C0, $7F, $40, $6A, $55, $40	; tile #125
	.byt $43, $41, $65, $61, $44, $6A, $50, $42	; tile #126
	.byt $40, $6A, $40, $6A, $40, $6A, $40, $63	; tile #127
	.byt $40, $6A, $40, $6A, $40, $63, $55, $7F	; tile #128
	.byt $40, $6A, $40, $63, $55, $7F, $5D, $7C	; tile #129
	.byt $41, $61, $54, $7F, $55, $7F, $55, $7F	; tile #130
	.byt $55, $7F, $55, $67, $51, $7E, $55, $7F	; tile #131
	.byt $54, $7E, $54, $7E, $54, $5E, $44, $78	; tile #132
	.byt $77, $7F, $5D, $7F, $77, $7F, $5C, $7E	; tile #133
	.byt $4F, $67, $6F, $5D, $5F, $57, $7F, $5D	; tile #134
	.byt $7F, $5D, $7E, $76, $7E, $5C, $7D, $74	; tile #135
	.byt $53, $47, $57, $67, $57, $67, $4F, $6F	; tile #136
	.byt $79, $7A, $7D, $7C, $7D, $7C, $7E, $7E	; tile #137
	.byt $5F, $5D, $5F, $57, $4F, $6D, $4F, $67	; tile #138
	.byt $7D, $75, $7D, $5C, $7E, $76, $7F, $5D	; tile #139
	.byt $77, $7F, $5D, $7F, $77, $7F, $5D, $5F	; tile #140
	.byt $5D, $5F, $57, $5F, $5C, $5E, $55, $5B	; tile #141
	.byt $71, $77, $45, $5F, $55, $7F, $54, $7C	; tile #142
	.byt $5D, $66, $53, $7C, $55, $7F, $55, $4F	; tile #143
	.byt $51, $47, $55, $67, $55, $67, $45, $6F	; tile #144
	.byt $51, $7A, $55, $7C, $55, $7C, $54, $7E	; tile #145
	.byt $40, $6A, $40, $63, $55, $7F, $55, $7F	; tile #146
	.byt $40, $63, $55, $7F, $55, $7F, $56, $63	; tile #147
	.byt $55, $7F, $55, $7F, $50, $67, $55, $7C	; tile #148
	.byt $55, $7E, $71, $4F, $57, $79, $45, $7F	; tile #149
	.byt $43, $5F, $54, $71, $65, $7F, $55, $7F	; tile #150
	.byt $55, $6F, $55, $7F, $55, $7E, $51, $45	; tile #151
	.byt $55, $7F, $55, $78, $47, $55, $7F, $55	; tile #152
	.byt $54, $70, $4E, $54, $7E, $54, $7E, $54	; tile #153
	.byt $76, $7D, $5D, $7D, $73, $79, $5B, $77	; tile #154
	.byt $7F, $77, $7F, $5D, $7F, $77, $7F, $5D	; tile #155
	.byt $7D, $5A, $79, $72, $79, $52, $75, $72	; tile #156
	.byt $4F, $6F, $4F, $5F, $5F, $5F, $5F, $5F	; tile #157
	.byt $7E, $7E, $7F, $7F, $7F, $7F, $7F, $7F	; tile #158
	.byt $57, $65, $57, $4B, $53, $49, $55, $69	; tile #159
	.byt $57, $4F, $6D, $6F, $77, $57, $79, $73	; tile #160
	.byt $40, $5F, $45, $57, $59, $6D, $56, $7B	; tile #161
	.byt $40, $7F, $55, $7F, $50, $7B, $55, $5E	; tile #162
	.byt $40, $7F, $55, $7F, $40, $7F, $60, $7F	; tile #163
	.byt $45, $73, $51, $7E, $45, $77, $59, $7C	; tile #164
	.byt $50, $7C, $55, $5F, $45, $77, $51, $7E	; tile #165
	.byt $55, $73, $41, $43, $44, $7C, $50, $7C	; tile #166
	.byt $45, $6F, $45, $5F, $55, $5F, $55, $5F	; tile #167
	.byt $54, $7E, $55, $7F, $55, $7F, $55, $7F	; tile #168
	.byt $55, $7F, $55, $7C, $55, $7F, $55, $7F	; tile #169
	.byt $54, $79, $45, $7F, $50, $67, $55, $7F	; tile #170
	.byt $55, $7E, $51, $4F, $75, $7F, $55, $7F	; tile #171
	.byt $5D, $5F, $55, $7F, $55, $7E, $51, $45	; tile #172
	.byt $55, $7F, $54, $79, $47, $55, $7F, $55	; tile #173
	.byt $54, $71, $4F, $55, $7F, $55, $7F, $55	; tile #174
	.byt $7D, $55, $7D, $55, $7D, $55, $7D, $55	; tile #175
	.byt $7F, $55, $6F, $55, $77, $55, $77, $55	; tile #176
	.byt $5D, $7F, $77, $7F, $5D, $7F, $77, $40	; tile #177
	.byt $77, $7F, $5D, $7F, $77, $7F, $5D, $40	; tile #178
	.byt $77, $75, $4F, $67, $6F, $5D, $5F, $57	; tile #179
	.byt $74, $4A, $64, $6A, $55, $49, $55, $48	; tile #180
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $7F, $40	; tile #181
	.byt $5F, $5F, $5F, $5F, $5F, $5F, $5F, $40	; tile #182
	.byt $65, $69, $64, $72, $74, $72, $75, $42	; tile #183
	.byt $7F, $77, $7F, $5D, $7F, $77, $5F, $5D	; tile #184
	.byt $7B, $5D, $7D, $75, $7E, $5C, $7E, $76	; tile #185
	.byt $75, $7E, $5D, $7F, $77, $7F, $5D, $40	; tile #186
	.byt $65, $77, $59, $4D, $56, $4B, $55, $4A	; tile #187
	.byt $58, $6F, $56, $7B, $55, $5E, $65, $77	; tile #188
	.byt $47, $7F, $41, $7F, $60, $7F, $5F, $6F	; tile #189
	.byt $55, $6F, $75, $7B, $4D, $7E, $7F, $7F	; tile #190
	.byt $44, $67, $51, $7D, $54, $7F, $55, $6F	; tile #191
	.byt $74, $4A, $64, $6A, $55, $49, $55, $49	; tile #192
	.byt $45, $69, $44, $72, $54, $72, $55, $72	; tile #193
	.byt $55, $7F, $55, $7F, $55, $7C, $53, $45	; tile #194
	.byt $54, $61, $5F, $55, $5F, $55, $5F, $55	; tile #195
	.byt $77, $55, $6F, $55, $7F, $54, $7D, $53	; tile #196
	.byt $7E, $54, $7E, $51, $65, $5F, $55, $7F	; tile #197
	.byt $5F, $5D, $40, $7F, $55, $7F, $55, $7F	; tile #198
	.byt $7F, $77, $40, $7F, $55, $7F, $55, $7F	; tile #199
	.byt $51, $47, $45, $7F, $55, $7F, $55, $7F	; tile #200
	.byt $51, $7C, $54, $7F, $55, $7F, $55, $7F	; tile #201
	.byt $5F, $57, $40, $7F, $55, $7F, $55, $7F	; tile #202
	.byt $7E, $5C, $40, $7F, $55, $7F, $55, $7F	; tile #203
	.byt $55, $4A, $55, $4A, $55, $4A, $45, $72	; tile #204
	.byt $59, $6D, $56, $6B, $55, $6A, $55, $6A	; tile #205
	.byt $57, $7B, $55, $5E, $65, $77, $59, $6D	; tile #206
	.byt $7F, $7F, $70, $70, $5C, $6C, $57, $78	; tile #207
	.byt $75, $79, $5E, $4F, $47, $47, $7F, $40	; tile #208
	.byt $5B, $55, $5D, $55, $5D, $55, $5D, $55	; tile #209
	.byt $7F, $55, $7F, $55, $7E, $51, $65, $5F	; tile #210
	.byt $7D, $54, $79, $47, $55, $7F, $55, $7F	; tile #211
	.byt $45, $7F, $55, $7F, $55, $7F, $55, $7F	; tile #212
	.byt $51, $7A, $55, $7E, $55, $7F, $55, $7F	; tile #213
	.byt $55, $6A, $55, $6A, $55, $6A, $45, $72	; tile #214
	.byt $56, $6B, $51, $6A, $51, $6A, $51, $6A	; tile #215
	.byt $55, $5F, $65, $70, $57, $60, $55, $6A	; tile #216
	.byt $55, $7F, $55, $40, $7F, $40, $55, $6A	; tile #217
	.byt $5D, $55, $5B, $55, $5F, $55, $5E, $51	; tile #218
	.byt $7F, $55, $7F, $54, $79, $47, $55, $7F	; tile #219
	.byt $7C, $53, $45, $7F, $55, $7F, $55, $7F	; tile #220
	.byt $51, $7C, $54, $7E, $55, $7F, $55, $7F	; tile #221
	.byt $51, $6A, $51, $6A, $51, $6A, $51, $78	; tile #222
	.byt $55, $6A, $55, $6A, $55, $6A, $55, $40	; tile #223
	.byt $7F, $55, $7F, $55, $7F, $54, $79, $47	; tile #224
	.byt $7F, $55, $7C, $53, $65, $5F, $55, $7F	; tile #225
	.byt $55, $4F, $55, $7F, $55, $7F, $55, $7F	; tile #226
; Walkbox Data
wb_data
	.byt 004, 029, 013, 016, $21
	.byt 042, 067, 014, 016, $21
	.byt 056, 060, 011, 013, $01
; Walk matrix
wb_matrix
	.byt 0, 128, 128
	.byt 128, 1, 2
	.byt 128, 1, 2

res_end
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Room: Control levers
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
	.byt 0, 0	; No palette information
; Entry and exit scripts
	.byt 210, 211
; Number of objects in the room and list of ids
	.byt 5,210,211,212,213,214
; Room name (null terminated)
	.asc "Controls", 0
; Room tile map
column_data
	.byt 000, 000, 000, 000, 006, 025, 028, 028, 028, 028, 028, 028, 028, 028, 118, 119, 119
	.byt 000, 000, 000, 001, 007, 026, 029, 030, 030, 030, 086, 107, 030, 029, 118, 119, 119
	.byt 000, 006, 014, 020, 008, 026, 028, 028, 042, 064, 087, 108, 028, 028, 118, 119, 119
	.byt 001, 007, 008, 008, 008, 026, 029, 031, 043, 065, 045, 109, 030, 029, 118, 119, 119
	.byt 002, 008, 008, 008, 008, 026, 028, 032, 044, 044, 044, 108, 028, 028, 118, 119, 119
	.byt 003, 008, 008, 008, 008, 026, 029, 033, 045, 045, 045, 109, 030, 029, 118, 119, 119
	.byt 003, 008, 008, 008, 008, 026, 028, 032, 044, 066, 088, 110, 028, 028, 118, 119, 119
	.byt 003, 008, 008, 008, 008, 026, 029, 034, 046, 067, 089, 111, 030, 029, 118, 119, 119
	.byt 003, 008, 008, 008, 008, 026, 028, 035, 047, 068, 044, 108, 028, 028, 118, 119, 119
	.byt 003, 008, 008, 008, 008, 026, 029, 033, 045, 045, 045, 109, 030, 029, 118, 119, 119
	.byt 003, 008, 008, 008, 008, 026, 028, 032, 044, 044, 090, 108, 028, 028, 118, 119, 119
	.byt 003, 008, 008, 008, 008, 026, 029, 036, 048, 069, 091, 112, 030, 029, 118, 119, 119
	.byt 003, 009, 015, 021, 008, 026, 028, 037, 049, 070, 092, 108, 028, 028, 118, 119, 119
	.byt 003, 010, 016, 022, 008, 026, 029, 033, 045, 045, 045, 109, 030, 029, 118, 119, 119
	.byt 003, 010, 017, 022, 008, 026, 028, 032, 050, 071, 071, 113, 028, 028, 118, 119, 119
	.byt 003, 011, 018, 023, 008, 026, 029, 038, 051, 072, 072, 114, 030, 029, 118, 119, 119
	.byt 003, 009, 015, 021, 008, 026, 028, 032, 044, 044, 044, 108, 028, 028, 118, 119, 119
	.byt 003, 010, 016, 022, 008, 026, 029, 033, 045, 045, 045, 109, 030, 029, 118, 119, 119
	.byt 003, 010, 017, 022, 008, 026, 028, 039, 052, 073, 093, 108, 028, 028, 118, 119, 119
	.byt 003, 011, 018, 023, 008, 026, 029, 038, 053, 074, 094, 115, 030, 029, 118, 119, 119
	.byt 003, 009, 015, 021, 008, 026, 028, 032, 044, 044, 095, 108, 028, 028, 118, 119, 119
	.byt 003, 010, 016, 022, 008, 026, 029, 033, 045, 045, 045, 109, 030, 029, 118, 119, 119
	.byt 003, 010, 017, 022, 008, 026, 028, 032, 044, 044, 044, 108, 028, 028, 118, 119, 119
	.byt 003, 011, 018, 023, 008, 026, 029, 033, 045, 045, 045, 109, 030, 029, 118, 119, 119
	.byt 003, 009, 015, 021, 008, 026, 028, 032, 044, 044, 044, 108, 028, 028, 118, 119, 119
	.byt 003, 010, 016, 022, 008, 026, 029, 033, 054, 075, 096, 109, 030, 029, 118, 119, 119
	.byt 003, 010, 017, 022, 008, 026, 028, 032, 055, 076, 097, 108, 028, 028, 118, 119, 119
	.byt 003, 011, 018, 023, 008, 026, 029, 033, 056, 077, 098, 109, 030, 029, 118, 119, 119
	.byt 003, 008, 008, 008, 008, 026, 028, 032, 057, 078, 099, 108, 028, 028, 118, 119, 119
	.byt 003, 008, 008, 008, 008, 026, 029, 033, 058, 079, 100, 109, 030, 029, 118, 119, 119
	.byt 003, 008, 008, 008, 008, 026, 028, 032, 059, 080, 101, 108, 028, 028, 118, 119, 119
	.byt 003, 008, 008, 008, 008, 026, 029, 033, 060, 081, 102, 109, 030, 029, 118, 119, 119
	.byt 003, 008, 008, 008, 008, 026, 028, 032, 061, 082, 103, 108, 028, 028, 118, 119, 119
	.byt 004, 008, 008, 008, 008, 026, 029, 040, 045, 083, 104, 109, 030, 029, 118, 119, 119
	.byt 005, 012, 008, 008, 008, 026, 028, 041, 062, 084, 044, 108, 028, 028, 118, 119, 119
	.byt 000, 013, 019, 024, 008, 026, 029, 030, 063, 085, 105, 109, 030, 029, 118, 119, 119
	.byt 000, 000, 000, 005, 012, 026, 028, 028, 028, 028, 106, 116, 028, 028, 118, 119, 119
	.byt 000, 000, 000, 000, 013, 027, 029, 030, 030, 030, 030, 117, 030, 029, 118, 119, 119

; Room tile set
tiles_start
	.byt $40, $40, $41, $41, $42, $42, $45, $45	; tile #1
	.byt $7F, $60, $55, $5F, $55, $7F, $55, $7F	; tile #2
	.byt $7F, $40, $55, $7F, $55, $7F, $55, $7F	; tile #3
	.byt $7F, $41, $54, $7E, $55, $7F, $55, $7F	; tile #4
	.byt $40, $40, $60, $60, $50, $50, $48, $68	; tile #5
	.byt $40, $40, $40, $40, $40, $40, $41, $41	; tile #6
	.byt $49, $4B, $55, $57, $65, $6F, $55, $5F	; tile #7
	.byt $55, $7F, $55, $7F, $55, $7F, $55, $7F	; tile #8
	.byt $55, $7F, $55, $7F, $55, $7C, $53, $7B	; tile #9
	.byt $55, $7F, $55, $7F, $55, $40, $7F, $40	; tile #10
	.byt $55, $7F, $55, $7F, $55, $4F, $75, $77	; tile #11
	.byt $54, $74, $52, $7A, $55, $7D, $54, $7E	; tile #12
	.byt $40, $40, $40, $40, $40, $40, $60, $60	; tile #13
	.byt $42, $42, $45, $45, $49, $4B, $55, $57	; tile #14
	.byt $52, $7A, $52, $7A, $52, $7A, $52, $7A	; tile #15
	.byt $FF, $40, $FF, $40, $DF, $60, $E7, $40	; tile #16
	.byt $F9, $41, $FE, $40, $FF, $40, $FF, $40	; tile #17
	.byt $55, $57, $55, $57, $55, $57, $55, $57	; tile #18
	.byt $50, $50, $48, $68, $54, $74, $52, $7A	; tile #19
	.byt $65, $6F, $55, $5F, $55, $7F, $55, $7F	; tile #20
	.byt $53, $7B, $54, $7F, $55, $7F, $55, $7F	; tile #21
	.byt $40, $7F, $40, $7F, $55, $7F, $55, $7F	; tile #22
	.byt $75, $77, $45, $7F, $55, $7F, $55, $7F	; tile #23
	.byt $55, $7D, $54, $7E, $55, $7F, $55, $7F	; tile #24
	.byt $42, $42, $45, $45, $49, $4B, $55, $40	; tile #25
	.byt $55, $7F, $55, $7F, $55, $7F, $55, $40	; tile #26
	.byt $50, $50, $48, $68, $54, $74, $52, $40	; tile #27
	.byt $7F, $5D, $7F, $77, $7F, $5D, $7F, $77	; tile #28
	.byt $7F, $77, $61, $5E, $5E, $40, $61, $5D	; tile #29
	.byt $7F, $77, $7F, $5D, $7F, $77, $7F, $5D	; tile #30
	.byt $7F, $77, $7F, $5C, $7D, $72, $7A, $55	; tile #31
	.byt $7F, $5D, $7F, $40, $7F, $40, $5D, $7F	; tile #32
	.byt $7F, $77, $7F, $40, $7F, $40, $77, $7F	; tile #33
	.byt $7F, $77, $7F, $40, $7F, $40, $77, $7E	; tile #34
	.byt $7F, $5D, $7F, $40, $7F, $40, $5D, $4F	; tile #35
	.byt $7F, $77, $7F, $40, $7F, $40, $77, $78	; tile #36
	.byt $7F, $5D, $7F, $40, $7F, $40, $5D, $5F	; tile #37
	.byt $7F, $77, $7F, $40, $7F, $40, $77, $47	; tile #38
	.byt $7F, $5D, $7F, $40, $7F, $40, $5D, $7E	; tile #39
	.byt $7F, $77, $7F, $40, $7F, $40, $76, $7F	; tile #40
	.byt $7F, $5D, $7F, $47, $6F, $75, $77, $5B	; tile #41
	.byt $7F, $5D, $7F, $77, $7F, $5C, $7E, $75	; tile #42
	.byt $75, $6D, $6B, $5B, $55, $77, $67, $6F	; tile #43
	.byt $77, $7F, $5D, $7F, $77, $7F, $5D, $7F	; tile #44
	.byt $5D, $7F, $77, $7F, $5D, $7F, $77, $7F	; tile #45
	.byt $5D, $7A, $72, $74, $54, $74, $74, $68	; tile #46
	.byt $77, $4B, $49, $57, $57, $57, $6D, $6F	; tile #47
	.byt $57, $68, $68, $68, $48, $68, $51, $51	; tile #48
	.byt $67, $6F, $6D, $6F, $67, $6F, $5D, $5F	; tile #49
	.byt $76, $7D, $5D, $7D, $75, $7D, $5D, $7D	; tile #50
	.byt $79, $45, $45, $45, $45, $45, $45, $45	; tile #51
	.byt $75, $7D, $5D, $7D, $75, $7D, $5C, $7E	; tile #52
	.byt $79, $45, $45, $45, $45, $45, $62, $62	; tile #53
	.byt $5D, $7F, $77, $7E, $5D, $7D, $75, $7D	; tile #54
	.byt $77, $7F, $5D, $40, $7F, $40, $45, $4A	; tile #55
	.byt $5D, $7F, $77, $40, $7F, $40, $54, $6A	; tile #56
	.byt $77, $7F, $5D, $40, $7F, $40, $65, $6A	; tile #57
	.byt $5D, $7F, $77, $40, $7F, $40, $55, $6A	; tile #58
	.byt $77, $7F, $5D, $40, $7F, $40, $55, $6A	; tile #59
	.byt $5D, $7F, $77, $40, $7F, $40, $48, $52	; tile #60
	.byt $77, $7F, $5D, $4F, $77, $57, $55, $6B	; tile #61
	.byt $5B, $6D, $4D, $76, $76, $7B, $5B, $7D	; tile #62
	.byt $7F, $77, $7F, $5D, $7F, $57, $5F, $5D	; tile #63
	.byt $7D, $5D, $7A, $72, $76, $55, $6D, $6B	; tile #64
	.byt $5D, $5F, $77, $7F, $5D, $7F, $77, $7F	; tile #65
	.byt $77, $7F, $5D, $7F, $77, $7E, $5C, $7E	; tile #66
	.byt $48, $69, $51, $51, $51, $62, $62, $62	; tile #67
	.byt $67, $5F, $5D, $5F, $57, $7F, $5D, $7F	; tile #68
	.byt $51, $51, $51, $51, $51, $51, $51, $51	; tile #69
	.byt $57, $5F, $5D, $5F, $57, $5F, $5D, $5F	; tile #70
	.byt $75, $7D, $5D, $7D, $75, $7D, $5D, $7D	; tile #71
	.byt $45, $45, $45, $45, $45, $45, $45, $45	; tile #72
	.byt $76, $7E, $5C, $7E, $76, $7E, $5C, $7E	; tile #73
	.byt $62, $62, $62, $62, $62, $62, $62, $62	; tile #74
	.byt $5A, $7A, $72, $7A, $5A, $7A, $75, $74	; tile #75
	.byt $45, $6A, $45, $6A, $44, $6A, $44, $60	; tile #76
	.byt $54, $60, $4F, $5F, $70, $62, $65, $60	; tile #77
	.byt $65, $60, $53, $5B, $48, $64, $55, $44	; tile #78
	.byt $55, $4A, $41, $78, $5E, $47, $50, $40	; tile #79
	.byt $54, $68, $51, $6B, $40, $7F, $40, $40	; tile #80
	.byt $64, $6A, $54, $40, $7F, $60, $44, $40	; tile #81
	.byt $4B, $65, $55, $42, $7A, $41, $55, $68	; tile #82
	.byt $5D, $7F, $77, $7F, $5D, $5F, $57, $5F	; tile #83
	.byt $75, $7E, $5C, $7F, $77, $7F, $5D, $7F	; tile #84
	.byt $6F, $67, $77, $55, $5B, $6B, $6D, $75	; tile #85
	.byt $7F, $77, $7E, $5C, $7E, $75, $7D, $5B	; tile #86
	.byt $5B, $57, $75, $6F, $67, $5F, $5D, $5F	; tile #87
	.byt $76, $7D, $5D, $7D, $72, $7A, $5A, $7A	; tile #88
	.byt $65, $45, $45, $4B, $49, $4B, $4B, $57	; tile #89
	.byt $77, $7E, $5C, $7E, $76, $7E, $5C, $7E	; tile #90
	.byt $51, $63, $62, $62, $62, $62, $62, $62	; tile #91
	.byt $57, $5F, $5D, $7F, $77, $7F, $5D, $7F	; tile #92
	.byt $76, $7E, $5D, $7F, $77, $7F, $5D, $7F	; tile #93
	.byt $62, $71, $51, $51, $51, $51, $51, $51	; tile #94
	.byt $77, $5F, $5D, $5F, $57, $5F, $5D, $5F	; tile #95
	.byt $55, $74, $75, $76, $5B, $7D, $76, $7F	; tile #96
	.byt $47, $6C, $58, $40, $40, $60, $7F, $40	; tile #97
	.byt $60, $40, $40, $40, $40, $40, $7F, $40	; tile #98
	.byt $44, $44, $4C, $58, $70, $40, $7F, $40	; tile #99
	.byt $40, $40, $40, $43, $46, $40, $7F, $40	; tile #100
	.byt $44, $48, $58, $60, $40, $40, $7F, $40	; tile #101
	.byt $40, $40, $40, $41, $41, $40, $7F, $40	; tile #102
	.byt $50, $4E, $58, $71, $63, $46, $7D, $43	; tile #103
	.byt $6D, $6F, $67, $6F, $5D, $7F, $77, $7F	; tile #104
	.byt $56, $7A, $73, $7D, $5D, $7E, $76, $7F	; tile #105
	.byt $7F, $5D, $5F, $57, $6F, $6D, $77, $57	; tile #106
	.byt $7A, $76, $75, $4D, $69, $58, $5F, $40	; tile #107
	.byt $77, $7F, $5D, $7F, $77, $40, $7F, $40	; tile #108
	.byt $5D, $7F, $77, $7F, $5D, $40, $7F, $40	; tile #109
	.byt $75, $7E, $5D, $7F, $77, $40, $7F, $40	; tile #110
	.byt $75, $4F, $77, $7F, $5D, $40, $7F, $40	; tile #111
	.byt $5D, $63, $77, $7F, $5D, $40, $7F, $40	; tile #112
	.byt $76, $7F, $5D, $7F, $77, $40, $7F, $40	; tile #113
	.byt $79, $47, $77, $7F, $5D, $40, $7F, $40	; tile #114
	.byt $4E, $71, $77, $7F, $5D, $40, $7F, $40	; tile #115
	.byt $5B, $69, $4D, $75, $76, $46, $7F, $40	; tile #116
	.byt $7F, $77, $7F, $5D, $7F, $77, $5F, $5D	; tile #117
	.byt $40, $7F, $7F, $7F, $40, $6A, $40, $6A	; tile #118
	.byt $40, $6A, $40, $6A, $40, $6A, $40, $6A	; tile #119
; Walkbox Data
wb_data
; Walk matrix
wb_matrix


res_end
.)


.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 200
res_start
	.byt OBJ_FLAG_PROP	; If OBJ_FLAG_PROP skip all costume data
	.byt 30,1		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 4,16		; Pos (col, row)
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
	.byt 5,3		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 33,12		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt 28,14		; Walk position (col, row)
	.byt FACING_RIGHT	; Facing direction for interaction
	.byt 00			; Color of text
#ifdef ENGLISH
	.asc "Controls",0
#endif
#ifdef SPANISH
	.asc "Controles",0
#endif
res_end	
.)


.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 202
res_start
	.byt OBJ_FLAG_PROP	; If OBJ_FLAG_PROP skip all costume data
	.byt 11,8		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 17,12		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt 20,14		; Walk position (col, row)
	.byt FACING_RIGHT	; Facing direction for interaction
	.byt 00			; Color of text
#ifdef ENGLISH
	.asc "Door",0
#endif
#ifdef SPANISH
	.asc "Puerta",0
#endif
res_end	
.)


.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 203
res_start
	.byt OBJ_FLAG_PROP	; If OBJ_FLAG_PROP skip all costume data
	.byt 6,10		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 0,12		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt 6,15		; Walk position (col, row)
	.byt FACING_LEFT	; Facing direction for interaction
	.byt 00			; Color of text
#ifdef ENGLISH
	.asc "Console",0
#endif
#ifdef SPANISH
	.asc "Consola",0
#endif
res_end	
.)


.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 204
res_start
	.byt OBJ_FLAG_PROP	; If OBJ_FLAG_PROP skip all costume data
	.byt 11,8		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 55,12		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt 58,14		; Walk position (col, row)
	.byt FACING_UP	; Facing direction for interaction
	.byt 00			; Color of text
#ifdef ENGLISH
	.asc "Door",0
#endif
#ifdef SPANISH
	.asc "Puerta",0
#endif
res_end	
.)



; Levers
; Object resource: Lever 1
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 210
res_start
	.byt OBJ_FLAG_FROMDISTANCE			; If OBJ_FLAG_PROP skip all costume data
	.byt 3,5		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 6,11		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt $ff,$ff		; Walk position (col, row)
	.byt FACING_UP		; Facing direction for interaction
	.byt 00			; Color of text

	; tiles and pointers to animatory states are setup in the costume
	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt 200		; costume ($ff for none) and skip the rest
	.byt 0			; entry in costume resource		
	.byt 0			; direction (0 or LOOK_RIGHT for animstate 0)
	.byt 0			; animation speed	
#ifdef ENGLISH
	.asc "Lever 1",0
#endif
#ifdef SPANISH
	.asc "Palanca 1",0
#endif
res_end	
.)

; Object resource: Lever 2
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 211
res_start
	.byt OBJ_FLAG_FROMDISTANCE			; If OBJ_FLAG_PROP skip all costume data
	.byt 3,5		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 10,11		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt $ff,$ff		; Walk position (col, row)
	.byt FACING_UP		; Facing direction for interaction
	.byt 00			; Color of text

	; tiles and pointers to animatory states are setup in the costume
	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt 200		; costume ($ff for none) and skip the rest
	.byt 0			; entry in costume resource		
	.byt 2			; direction (0 or LOOK_RIGHT for animstate 0)
	.byt 0			; animation speed	
#ifdef ENGLISH
	.asc "Lever 2",0
#endif
#ifdef SPANISH
	.asc "Palanca 2",0
#endif
res_end	
.)

; Object resource: Lever 3
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 212
res_start
	.byt OBJ_FLAG_FROMDISTANCE			; If OBJ_FLAG_PROP skip all costume data
	.byt 3,5		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 14,11		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt $ff,$ff		; Walk position (col, row)
	.byt FACING_UP		; Facing direction for interaction
	.byt 00			; Color of text

	; tiles and pointers to animatory states are setup in the costume
	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt 200		; costume ($ff for none) and skip the rest
	.byt 0			; entry in costume resource		
	.byt 4			; direction (0 or LOOK_RIGHT for animstate 0)
	.byt 0			; animation speed	
#ifdef ENGLISH
	.asc "Lever 3",0
#endif
#ifdef SPANISH
	.asc "Palanca 3",0
#endif
res_end	
.)

; Object resource: Lever 4
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 213
res_start
	.byt OBJ_FLAG_FROMDISTANCE			; If OBJ_FLAG_PROP skip all costume data
	.byt 3,5		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 18,11		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt $ff,$ff		; Walk position (col, row)
	.byt FACING_UP		; Facing direction for interaction
	.byt 00			; Color of text

	; tiles and pointers to animatory states are setup in the costume
	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt 200		; costume ($ff for none) and skip the rest
	.byt 0			; entry in costume resource		
	.byt 6			; direction (0 or LOOK_RIGHT for animstate 0)
	.byt 0			; animation speed	
#ifdef ENGLISH
	.asc "Lever 4",0
#endif
#ifdef SPANISH
	.asc "Palanca 4",0
#endif
res_end	
.)


.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 214
res_start
	.byt OBJ_FLAG_PROP|OBJ_FLAG_FROMDISTANCE	; If OBJ_FLAG_PROP skip all costume data
	.byt 38,1		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 0,16		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt $ff,$ff		; Walk position (col, row)
	.byt FACING_DOWN	; Facing direction for interaction
	.byt 00			; Color of text
#ifdef ENGLISH
	.asc "Exit",0
#endif
#ifdef SPANISH
	.asc "Salir",0
#endif
res_end	
.)

; Object for LEDs
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 220
res_start
	.byt OBJ_FLAG_FROMDISTANCE			; If OBJ_FLAG_PROP skip all costume data
	.byt 2,1		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 13,2		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt $ff,$ff		; Walk position (col, row)
	.byt FACING_UP		; Facing direction for interaction
	.byt 00			; Color of text

	; tiles and pointers to animatory states are setup in the costume
	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt 201		; costume ($ff for none) and skip the rest
	.byt 0			; entry in costume resource		
	.byt 0			; direction (0 or LOOK_RIGHT for animstate 0)
	.byt 0			; animation speed	
#ifdef ENGLISH
	.asc "Light",0
#endif
#ifdef SPANISH
	.asc "Luz",0
#endif
res_end	
.)

.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 221
res_start
	.byt OBJ_FLAG_FROMDISTANCE			; If OBJ_FLAG_PROP skip all costume data
	.byt 2,1		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 17,2		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt $ff,$ff		; Walk position (col, row)
	.byt FACING_UP		; Facing direction for interaction
	.byt 00			; Color of text

	; tiles and pointers to animatory states are setup in the costume
	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt 201		; costume ($ff for none) and skip the rest
	.byt 0			; entry in costume resource		
	.byt 0			; direction (0 or LOOK_RIGHT for animstate 0)
	.byt 0			; animation speed	
#ifdef ENGLISH
	.asc "Light",0
#endif
#ifdef SPANISH
	.asc "Luz",0
#endif
res_end	
.)
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 222
res_start
	.byt OBJ_FLAG_FROMDISTANCE			; If OBJ_FLAG_PROP skip all costume data
	.byt 2,1		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 21,2		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt $ff,$ff		; Walk position (col, row)
	.byt FACING_UP		; Facing direction for interaction
	.byt 00			; Color of text

	; tiles and pointers to animatory states are setup in the costume
	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt 201		; costume ($ff for none) and skip the rest
	.byt 0			; entry in costume resource		
	.byt 0			; direction (0 or LOOK_RIGHT for animstate 0)
	.byt 0			; animation speed	
#ifdef ENGLISH
	.asc "Light",0
#endif
#ifdef SPANISH
	.asc "Luz",0
#endif
res_end	
.)
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 223
res_start
	.byt OBJ_FLAG_FROMDISTANCE			; If OBJ_FLAG_PROP skip all costume data
	.byt 2,1		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 25,2		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt $ff,$ff		; Walk position (col, row)
	.byt FACING_UP		; Facing direction for interaction
	.byt 00			; Color of text

	; tiles and pointers to animatory states are setup in the costume
	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt 201		; costume ($ff for none) and skip the rest
	.byt 0			; entry in costume resource		
	.byt 0			; direction (0 or LOOK_RIGHT for animstate 0)
	.byt 0			; animation speed	
#ifdef ENGLISH
	.asc "Light",0
#endif
#ifdef SPANISH
	.asc "Luz",0
#endif
res_end	
.)

; Célula de energía
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 224
res_start
	.byt OBJ_FLAG_FROMDISTANCE			; If OBJ_FLAG_PROP skip all costume data
	.byt 5,2		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 27,10		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt $ff,$ff		; Walk position (col, row)
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
	.asc "Energy cell",0
#endif
#ifdef SPANISH
	.asc "C","Z"+2,"lula energ","Z"+3,"a",0
#endif
res_end	
.)

; Costumes for levers
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
; Animatory state 0 (palanca0.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 0, 0
.byt 4, 5, 6, 0, 0
.byt 7, 8, 9, 0, 0
.byt 10, 11, 12, 0, 0
.byt 13, 14, 15, 0, 0
; Animatory state 1 (palanca1.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 1, 16, 17, 0, 0
.byt 12, 18, 19, 0, 0
.byt 20, 21, 22, 0, 0
.byt 23, 24, 12, 0, 0
.byt 13, 14, 15, 0, 0
; Animatory state 2 (palanca2.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 25, 26, 27, 0, 0
.byt 28, 29, 30, 0, 0
.byt 31, 32, 33, 0, 0
.byt 34, 35, 36, 0, 0
.byt 37, 38, 37, 0, 0
; Animatory state 3 (palanca3.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 25, 39, 27, 0, 0
.byt 31, 40, 41, 0, 0
.byt 42, 43, 33, 0, 0
.byt 44, 45, 46, 0, 0
.byt 37, 47, 37, 0, 0
; Animatory state 4 (palanca4.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 48, 49, 1, 0, 0
.byt 50, 51, 12, 0, 0
.byt 52, 53, 12, 0, 0
.byt 54, 55, 12, 0, 0
.byt 56, 57, 15, 0, 0
; Animatory state 5 (palanca5.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 1, 58, 1, 0, 0
.byt 59, 60, 12, 0, 0
.byt 61, 62, 12, 0, 0
.byt 63, 64, 12, 0, 0
.byt 56, 57, 15, 0, 0
; Animatory state 6 (palanca6.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 65, 66, 1, 0, 0
.byt 67, 68, 69, 0, 0
.byt 70, 71, 12, 0, 0
.byt 72, 73, 74, 0, 0
.byt 15, 75, 15, 0, 0
; Animatory state 7 (palanca7.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 65, 58, 1, 0, 0
.byt 76, 77, 12, 0, 0
.byt 70, 78, 79, 0, 0
.byt 80, 81, 82, 0, 0
.byt 15, 83, 15, 0, 0
costume_tiles
; Tile graphic 1
.byt $3f, $1d, $3f, $0, $3f, $0, $1d, $3f
; Tile graphic 2
.byt $3f, $37, $3f, $0, $3f, $0, $37, $20
; Tile graphic 3
.byt $3f, $1d, $3f, $0, $3f, $0, $1d, $1f
; Tile graphic 4
.byt $37, $3f, $1c, $3e, $36, $3e, $1d, $3f
; Tile graphic 5
.byt $f, $10, $0, $0, $0, $0, $0, $0
; Tile graphic 6
.byt $7, $2b, $11, $17, $17, $7, $d, $2f
; Tile graphic 7
.byt $37, $3f, $1d, $3f, $37, $3e, $1c, $3e
; Tile graphic 8
.byt $0, $2d, $11, $11, $11, $22, $22, $22
; Tile graphic 9
.byt $7, $1f, $1d, $1f, $17, $3f, $1d, $3f
; Tile graphic 10
.byt $36, $3d, $1d, $3d, $32, $3a, $1a, $3a
; Tile graphic 11
.byt $25, $5, $5, $b, $9, $b, $b, $17
; Tile graphic 12
.byt $37, $3f, $1d, $3f, $37, $3f, $1d, $3f
; Tile graphic 13
.byt $35, $3e, $1d, $3f, $37, $0, $3f, $0
; Tile graphic 14
.byt $35, $f, $37, $3f, $1d, $0, $3f, $0
; Tile graphic 15
.byt $37, $3f, $1d, $3f, $37, $0, $3f, $0
; Tile graphic 16
.byt $3f, $37, $3f, $0, $3f, $0, $37, $3e
; Tile graphic 17
.byt $3f, $1d, $3f, $0, $3f, $0, $1d, $f
; Tile graphic 18
.byt $1d, $3a, $32, $34, $14, $34, $34, $28
; Tile graphic 19
.byt $37, $b, $9, $17, $17, $17, $2d, $2f
; Tile graphic 20
.byt $37, $3f, $1d, $3f, $37, $38, $13, $34
; Tile graphic 21
.byt $8, $29, $11, $11, $11, $2, $32, $a
; Tile graphic 22
.byt $27, $1f, $1d, $1f, $17, $3f, $1d, $3f
; Tile graphic 23
.byt $20, $20, $0, $20, $30, $30, $18, $3a
; Tile graphic 24
.byt $5, $5, $5, $1, $1, $b, $3, $17
; Tile graphic 25
.byt $3f, $2e, $3f, $0, $3f, $0, $2e, $3f
; Tile graphic 26
.byt $3f, $3b, $3f, $0, $3f, $0, $3b, $20
; Tile graphic 27
.byt $3f, $2e, $3f, $0, $3f, $0, $2e, $1f
; Tile graphic 28
.byt $3b, $3f, $2e, $3e, $3a, $3e, $2e, $3f
; Tile graphic 29
.byt $f, $10, $20, $20, $20, $0, $0, $10
; Tile graphic 30
.byt $b, $2f, $6, $7, $3, $7, $e, $f
; Tile graphic 31
.byt $3b, $3f, $2e, $3f, $3b, $3f, $2e, $3f
; Tile graphic 32
.byt $0, $15, $11, $11, $11, $11, $11, $11
; Tile graphic 33
.byt $1b, $1f, $e, $1f, $1b, $1f, $e, $1f
; Tile graphic 34
.byt $3b, $3e, $2e, $3e, $3a, $3e, $2e, $3e
; Tile graphic 35
.byt $11, $23, $22, $22, $22, $22, $22, $22
; Tile graphic 36
.byt $1b, $1f, $2e, $3f, $3b, $3f, $2e, $3f
; Tile graphic 37
.byt $3b, $3f, $2e, $3f, $3b, $0, $3f, $0
; Tile graphic 38
.byt $1c, $23, $3b, $3f, $2e, $0, $3f, $0
; Tile graphic 39
.byt $3f, $3b, $3f, $0, $3f, $0, $3b, $38
; Tile graphic 40
.byt $27, $28, $28, $28, $28, $28, $11, $11
; Tile graphic 41
.byt $2b, $2f, $2e, $2f, $2b, $2f, $e, $1f
; Tile graphic 42
.byt $3b, $3f, $2e, $3f, $3b, $3e, $2c, $3d
; Tile graphic 43
.byt $11, $11, $11, $11, $11, $1, $3c, $2
; Tile graphic 44
.byt $3a, $3a, $2a, $38, $38, $3d, $2c, $3e
; Tile graphic 45
.byt $0, $0, $0, $0, $0, $0, $0, $22
; Tile graphic 46
.byt $1b, $1f, $e, $1f, $3b, $3f, $2e, $3f
; Tile graphic 47
.byt $1c, $21, $3b, $3f, $2e, $0, $3f, $0
; Tile graphic 48
.byt $3f, $1d, $3f, $0, $3f, $0, $1d, $3c
; Tile graphic 49
.byt $3f, $37, $3f, $0, $3f, $0, $37, $3
; Tile graphic 50
.byt $31, $3a, $10, $30, $30, $30, $18, $38
; Tile graphic 51
.byt $39, $5, $2, $2, $2, $0, $1, $5
; Tile graphic 52
.byt $34, $3d, $1d, $3d, $35, $3d, $1d, $3d
; Tile graphic 53
.byt $1, $15, $5, $5, $5, $5, $5, $5
; Tile graphic 54
.byt $35, $3d, $1d, $3d, $35, $3d, $1d, $3d
; Tile graphic 55
.byt $5, $5, $5, $5, $5, $5, $5, $5
; Tile graphic 56
.byt $36, $3f, $1d, $3f, $37, $0, $3f, $0
; Tile graphic 57
.byt $39, $7, $37, $3f, $1d, $0, $3f, $0
; Tile graphic 58
.byt $3f, $37, $3f, $0, $3f, $0, $37, $7
; Tile graphic 59
.byt $36, $3d, $1d, $3d, $35, $3d, $1d, $3d
; Tile graphic 60
.byt $39, $5, $5, $5, $5, $5, $5, $5
; Tile graphic 61
.byt $35, $3d, $1d, $3d, $35, $3c, $19, $3a
; Tile graphic 62
.byt $5, $5, $5, $5, $5, $1, $39, $5
; Tile graphic 63
.byt $30, $30, $10, $30, $30, $38, $1c, $3d
; Tile graphic 64
.byt $2, $2, $2, $0, $1, $5, $1, $15
; Tile graphic 65
.byt $3f, $1d, $3f, $0, $3f, $0, $1d, $3e
; Tile graphic 66
.byt $3f, $37, $3f, $0, $3f, $0, $37, $1
; Tile graphic 67
.byt $34, $3d, $18, $38, $30, $38, $1c, $3c
; Tile graphic 68
.byt $3c, $2, $1, $1, $1, $0, $0, $2
; Tile graphic 69
.byt $37, $3f, $1d, $1f, $17, $1f, $1d, $3f
; Tile graphic 70
.byt $36, $3e, $1c, $3e, $36, $3e, $1c, $3e
; Tile graphic 71
.byt $0, $2a, $22, $22, $22, $22, $22, $22
; Tile graphic 72
.byt $36, $3e, $1d, $3f, $37, $3f, $1d, $3f
; Tile graphic 73
.byt $22, $31, $11, $11, $11, $11, $11, $11
; Tile graphic 74
.byt $37, $1f, $1d, $1f, $17, $1f, $1d, $1f
; Tile graphic 75
.byt $e, $31, $37, $3f, $1d, $0, $3f, $0
; Tile graphic 76
.byt $35, $3d, $1d, $3d, $35, $3d, $1c, $3e
; Tile graphic 77
.byt $39, $5, $5, $5, $5, $5, $22, $22
; Tile graphic 78
.byt $22, $22, $22, $22, $22, $20, $f, $10
; Tile graphic 79
.byt $37, $3f, $1d, $3f, $37, $1f, $d, $2f
; Tile graphic 80
.byt $36, $3e, $1c, $3e, $37, $3f, $1d, $3f
; Tile graphic 81
.byt $0, $0, $0, $0, $0, $0, $0, $11
; Tile graphic 82
.byt $17, $17, $15, $7, $7, $2f, $d, $1f
; Tile graphic 83
.byt $e, $21, $37, $3f, $1d, $0, $3f, $0
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
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 37
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 38
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 39
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 40
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 41
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 42
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 43
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 44
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 45
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 46
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 47
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 48
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 49
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 50
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 51
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 52
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 53
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 54
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 55
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 56
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 57
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 58
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 59
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 60
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 61
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 62
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 63
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 64
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 65
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 66
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 67
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 68
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 69
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 70
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 71
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 72
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 73
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 74
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 75
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 76
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 77
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 78
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 79
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 80
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 81
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 82
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 83
.byt $40, $40, $40, $40, $40, $40, $40, $40
res_end
.)

; Costume for leds when lit with sign OK
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
; Animatory state 0 (oksign.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 1, 2, 0, 0, 0
costume_tiles
; Tile graphic 1
.byt $3f, $33, $2d, $2d, $2d, $33, $3f, $3f
; Tile graphic 2
.byt $3f, $1b, $17, $f, $17, $1b, $3f, $3f
costume_masks
; Tile mask 1
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 2
.byt $40, $40, $40, $40, $40, $40, $40, $40
res_end
.)

; Costume for energy cell placed
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
; Animatory state 0 (cell.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 5
.byt 6, 7, 7, 7, 8
costume_tiles
; Tile graphic 1
.byt $0, $0, $1e, $16, $1e, $16, $16, $1e
; Tile graphic 2
.byt $0, $0, $0, $3f, $0, $1f, $0, $0
; Tile graphic 3
.byt $0, $0, $0, $3f, $0, $37, $0, $0
; Tile graphic 4
.byt $0, $0, $0, $3f, $0, $36, $0, $0
; Tile graphic 5
.byt $0, $0, $1e, $1e, $1a, $1e, $1a, $1e
; Tile graphic 6
.byt $16, $1e, $0, $0, $0, $0, $0, $0
; Tile graphic 7
.byt $3f, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 8
.byt $1a, $1e, $0, $0, $0, $0, $0, $0
costume_masks
; Tile mask 1
.byt $ff, $61, $40, $40, $40, $40, $40, $40
; Tile mask 2
.byt $ff, $ff, $40, $40, $40, $40, $40, $40
; Tile mask 3
.byt $ff, $ff, $40, $40, $40, $40, $40, $40
; Tile mask 4
.byt $ff, $ff, $40, $40, $40, $40, $40, $40
; Tile mask 5
.byt $ff, $61, $40, $40, $40, $40, $40, $40
; Tile mask 6
.byt $40, $40, $61, $ff, $ff, $ff, $ff, $ff
; Tile mask 7
.byt $40, $40, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 8
.byt $40, $40, $61, $ff, $ff, $ff, $ff, $ff
res_end
.)





#include "..\scripts\hideout.s"



