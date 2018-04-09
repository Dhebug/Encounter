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
; Room: Entry to detention area
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.(
	.byt RESOURCE_ROOM
	.word (res_end - res_start + 4)
	.byt 47
res_start
; No. columns, offset to tile map, offset to tiles
	.byt 69, <(column_data-res_start), >(column_data-res_start), <(tiles_start-res_start), >(tiles_start-res_start)
; No. zplanes and offsets to zplanes
	.byt 0
; No. Walkboxes and offsets to wb data and matrix
	.byt 3, <(wb_data-res_start), >(wb_data-res_start), <(wb_matrix-res_start), >(wb_matrix-res_start)
; Offset to palette
	.byt 0, 0	; No palette information
; Entry and exit scripts
	.byt 200, 201
; Number of objects in the room and list of ids
	.byt 5,200,201,202,203,204
; Room name (null terminated)
	.asc "Det-entry", 0
; Room tile map
column_data
	.byt 001, 002, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 084, 097, 097, 097
	.byt 001, 002, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 085, 098, 098, 098
	.byt 001, 002, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 084, 097, 097, 097
	.byt 001, 002, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 085, 098, 098, 098
	.byt 001, 002, 008, 008, 008, 010, 023, 061, 055, 008, 008, 008, 008, 084, 097, 097, 097
	.byt 001, 002, 009, 008, 038, 050, 024, 062, 072, 080, 008, 008, 008, 085, 098, 098, 098
	.byt 001, 002, 010, 023, 039, 051, 008, 008, 018, 081, 061, 055, 008, 084, 097, 097, 097
	.byt 001, 003, 011, 024, 008, 052, 057, 063, 073, 008, 094, 072, 080, 085, 098, 098, 098
	.byt 001, 004, 012, 025, 040, 053, 058, 064, 074, 082, 095, 107, 114, 117, 097, 097, 097
	.byt 001, 005, 013, 026, 041, 042, 042, 042, 042, 083, 096, 098, 098, 098, 098, 098, 098
	.byt 001, 005, 014, 027, 042, 042, 042, 042, 042, 084, 097, 097, 097, 097, 097, 097, 097
	.byt 001, 005, 014, 027, 042, 042, 042, 042, 042, 085, 098, 098, 098, 098, 098, 098, 098
	.byt 001, 005, 014, 027, 042, 042, 042, 042, 042, 084, 097, 097, 097, 097, 097, 097, 097
	.byt 001, 005, 015, 028, 043, 042, 042, 042, 042, 086, 099, 098, 098, 098, 098, 098, 098
	.byt 001, 006, 016, 029, 044, 054, 059, 065, 075, 087, 100, 108, 115, 118, 097, 097, 097
	.byt 001, 007, 017, 030, 008, 029, 060, 066, 076, 008, 101, 109, 089, 085, 098, 098, 098
	.byt 001, 002, 018, 031, 045, 055, 008, 008, 010, 088, 068, 051, 008, 084, 097, 097, 097
	.byt 001, 002, 008, 008, 046, 056, 030, 067, 077, 089, 008, 008, 008, 085, 098, 098, 098
	.byt 001, 002, 008, 008, 008, 018, 031, 068, 051, 008, 008, 008, 008, 084, 097, 097, 097
	.byt 001, 002, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 085, 098, 098, 098
	.byt 001, 002, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 084, 097, 097, 097
	.byt 001, 002, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 085, 098, 098, 098
	.byt 001, 002, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 084, 097, 097, 097
	.byt 001, 002, 019, 032, 047, 008, 008, 008, 008, 008, 008, 008, 008, 085, 098, 098, 098
	.byt 001, 002, 020, 033, 048, 008, 008, 008, 008, 008, 008, 008, 008, 084, 097, 097, 097
	.byt 001, 002, 020, 034, 048, 008, 008, 008, 008, 008, 008, 008, 008, 085, 098, 098, 098
	.byt 001, 002, 020, 035, 048, 008, 008, 008, 008, 008, 008, 008, 008, 084, 097, 097, 097
	.byt 001, 002, 020, 033, 048, 008, 008, 008, 008, 008, 008, 008, 008, 085, 098, 098, 098
	.byt 001, 002, 020, 036, 048, 008, 008, 008, 008, 008, 008, 008, 008, 084, 097, 097, 097
	.byt 001, 002, 021, 037, 049, 008, 008, 008, 008, 008, 008, 008, 008, 085, 098, 098, 098
	.byt 001, 002, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 084, 097, 097, 097
	.byt 001, 002, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 085, 098, 098, 098
	.byt 001, 002, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 084, 097, 097, 097
	.byt 001, 002, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 085, 098, 098, 098
	.byt 001, 002, 008, 008, 008, 008, 008, 069, 078, 090, 102, 110, 110, 119, 097, 097, 097
	.byt 001, 002, 008, 008, 008, 008, 008, 020, 048, 091, 103, 111, 111, 120, 098, 098, 098
	.byt 001, 002, 008, 008, 008, 008, 008, 070, 048, 092, 104, 112, 112, 121, 097, 097, 097
	.byt 001, 002, 008, 008, 008, 008, 008, 071, 079, 093, 105, 113, 113, 122, 098, 098, 098
	.byt 001, 002, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 084, 097, 097, 097
	.byt 001, 002, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 085, 098, 098, 098
	.byt 001, 002, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 084, 097, 097, 097
	.byt 001, 002, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 085, 098, 098, 098
	.byt 001, 002, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 084, 097, 097, 097
	.byt 001, 002, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 085, 098, 098, 098
	.byt 001, 002, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 084, 097, 097, 097
	.byt 001, 002, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 085, 098, 098, 098
	.byt 001, 002, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 084, 097, 097, 097
	.byt 001, 002, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 085, 098, 098, 098
	.byt 001, 002, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 084, 097, 097, 097
	.byt 001, 002, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 085, 098, 098, 098
	.byt 001, 002, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 084, 097, 097, 097
	.byt 001, 002, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 085, 098, 098, 098
	.byt 001, 002, 008, 008, 008, 010, 023, 045, 055, 008, 008, 008, 008, 084, 097, 097, 097
	.byt 001, 002, 022, 008, 038, 050, 024, 046, 056, 030, 008, 008, 008, 085, 098, 098, 098
	.byt 001, 002, 010, 023, 039, 051, 008, 008, 018, 031, 045, 055, 008, 084, 097, 097, 097
	.byt 001, 003, 011, 024, 008, 052, 057, 063, 073, 008, 106, 056, 030, 085, 098, 098, 098
	.byt 001, 004, 012, 025, 040, 053, 058, 064, 074, 082, 095, 107, 116, 117, 097, 097, 097
	.byt 001, 005, 013, 026, 041, 042, 042, 042, 042, 083, 096, 098, 098, 098, 098, 098, 098
	.byt 001, 005, 014, 027, 042, 042, 042, 042, 042, 084, 097, 097, 097, 097, 097, 097, 097
	.byt 001, 005, 014, 027, 042, 042, 042, 042, 042, 085, 098, 098, 098, 098, 098, 098, 098
	.byt 001, 005, 014, 027, 042, 042, 042, 042, 042, 084, 097, 097, 097, 097, 097, 097, 097
	.byt 001, 005, 015, 028, 043, 042, 042, 042, 042, 086, 099, 098, 098, 098, 098, 098, 098
	.byt 001, 006, 016, 029, 044, 054, 059, 065, 075, 087, 100, 108, 115, 118, 097, 097, 097
	.byt 001, 007, 017, 030, 008, 029, 060, 066, 076, 008, 101, 109, 089, 085, 098, 098, 098
	.byt 001, 002, 018, 031, 045, 055, 008, 008, 010, 088, 068, 051, 008, 084, 097, 097, 097
	.byt 001, 002, 008, 008, 046, 056, 030, 067, 077, 089, 008, 008, 008, 085, 098, 098, 098
	.byt 001, 002, 008, 008, 008, 018, 031, 068, 051, 008, 008, 008, 008, 084, 097, 097, 097
	.byt 001, 002, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 085, 098, 098, 098
	.byt 001, 002, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 008, 084, 097, 097, 097

; Room tile set
tiles_start
	.byt $C0, $C0, $C0, $C0, $C0, $C0, $C0, $C0	; tile #1
	.byt $40, $7F, $55, $7F, $55, $7F, $55, $7F	; tile #2
	.byt $40, $7E, $55, $7D, $53, $7B, $56, $76	; tile #3
	.byt $E0, $F0, $D0, $D8, $53, $5B, $77, $70	; tile #4
	.byt $C0, $C0, $C0, $C0, $C0, $C0, $C0, $40	; tile #5
	.byt $C1, $C3, $C2, $C4, $72, $76, $7B, $43	; tile #6
	.byt $40, $5F, $65, $6F, $75, $77, $59, $5B	; tile #7
	.byt $55, $7F, $55, $7F, $55, $7F, $55, $7F	; tile #8
	.byt $41, $5E, $52, $5E, $52, $52, $52, $40	; tile #9
	.byt $55, $7F, $55, $7F, $54, $7E, $55, $7D	; tile #10
	.byt $4D, $6D, $5B, $5B, $76, $76, $6D, $6C	; tile #11
	.byt $60, $D0, $E0, $E0, $C0, $C0, $C0, $40	; tile #12
	.byt $40, $C0, $C0, $C0, $C0, $C0, $C0, $41	; tile #13
	.byt $40, $C0, $C0, $C0, $C0, $C0, $C0, $C0	; tile #14
	.byt $40, $C0, $C0, $C0, $C0, $C0, $C0, $60	; tile #15
	.byt $FE, $C2, $C1, $C1, $C0, $C0, $C0, $40	; tile #16
	.byt $6D, $6D, $76, $76, $5B, $5B, $6D, $4D	; tile #17
	.byt $55, $7F, $55, $7F, $55, $5F, $65, $6F	; tile #18
	.byt $40, $5F, $50, $50, $50, $50, $50, $50	; tile #19
	.byt $40, $7F, $40, $40, $40, $40, $40, $40	; tile #20
	.byt $40, $7E, $42, $42, $42, $42, $42, $42	; tile #21
	.byt $41, $5C, $52, $5C, $52, $52, $5C, $41	; tile #22
	.byt $53, $7B, $56, $76, $4D, $6D, $5B, $5B	; tile #23
	.byt $59, $5B, $75, $77, $65, $6F, $55, $5F	; tile #24
	.byt $55, $7F, $55, $7F, $55, $7F, $55, $7E	; tile #25
	.byt $56, $76, $4D, $6C, $5D, $5A, $59, $72	; tile #26
	.byt $C0, $C0, $C0, $40, $55, $6A, $55, $6A	; tile #27
	.byt $59, $5B, $6D, $4D, $4E, $66, $56, $6B	; tile #28
	.byt $55, $7F, $55, $7F, $55, $7F, $55, $5F	; tile #29
	.byt $56, $76, $53, $7B, $55, $7D, $54, $7E	; tile #30
	.byt $75, $77, $59, $5B, $6D, $6D, $76, $76	; tile #31
	.byt $50, $50, $50, $50, $50, $50, $50, $50	; tile #32
	.byt $5E, $71, $71, $69, $65, $65, $63, $5E	; tile #33
	.byt $5F, $41, $42, $44, $48, $48, $48, $48	; tile #34
	.byt $40, $4C, $4C, $40, $40, $4C, $4C, $40	; tile #35
	.byt $5E, $42, $42, $4C, $50, $50, $50, $5E	; tile #36
	.byt $42, $42, $42, $42, $42, $42, $42, $42	; tile #37
	.byt $54, $7E, $55, $7D, $53, $7B, $56, $76	; tile #38
	.byt $76, $76, $6D, $6D, $59, $5B, $75, $77	; tile #39
	.byt $54, $7D, $55, $7D, $53, $7B, $57, $76	; tile #40
	.byt $75, $72, $65, $6A, $55, $4A, $55, $6A	; tile #41
	.byt $55, $6A, $55, $6A, $55, $6A, $55, $6A	; tile #42
	.byt $53, $6B, $55, $69, $54, $6A, $54, $6A	; tile #43
	.byt $55, $6F, $65, $6F, $75, $77, $79, $5B	; tile #44
	.byt $5B, $5B, $4D, $6D, $56, $76, $53, $7B	; tile #45
	.byt $55, $5F, $65, $6F, $75, $77, $59, $5B	; tile #46
	.byt $50, $50, $50, $50, $50, $50, $5F, $40	; tile #47
	.byt $40, $40, $40, $40, $40, $40, $7F, $40	; tile #48
	.byt $42, $42, $42, $42, $42, $42, $7E, $40	; tile #49
	.byt $4D, $6D, $5B, $5B, $76, $76, $6D, $6D	; tile #50
	.byt $65, $6F, $55, $5F, $55, $7F, $55, $7F	; tile #51
	.byt $55, $7F, $55, $7F, $55, $7F, $54, $7E	; tile #52
	.byt $56, $6C, $4D, $5C, $59, $5A, $79, $72	; tile #53
	.byt $59, $6D, $4D, $6E, $56, $66, $57, $6B	; tile #54
	.byt $55, $7D, $54, $7E, $55, $7F, $55, $7F	; tile #55
	.byt $6D, $6D, $76, $76, $5B, $5B, $4D, $6D	; tile #56
	.byt $54, $7D, $55, $7B, $53, $7B, $56, $76	; tile #57
	.byt $75, $6A, $65, $6A, $55, $4A, $55, $6A	; tile #58
	.byt $53, $69, $55, $69, $54, $6A, $55, $6A	; tile #59
	.byt $55, $6F, $65, $77, $75, $77, $59, $5B	; tile #60
	.byt $5B, $5D, $4D, $6E, $56, $77, $53, $7B	; tile #61
	.byt $55, $5F, $65, $6F, $75, $57, $59, $6B	; tile #62
	.byt $4E, $76, $57, $7B, $53, $7B, $55, $7D	; tile #63
	.byt $55, $6A, $55, $4A, $55, $6A, $65, $72	; tile #64
	.byt $55, $6A, $54, $6A, $54, $69, $55, $6B	; tile #65
	.byt $5D, $5B, $79, $77, $75, $77, $65, $6F	; tile #66
	.byt $54, $7E, $55, $7D, $53, $7A, $56, $75	; tile #67
	.byt $76, $6E, $6D, $5D, $59, $7B, $75, $77	; tile #68
	.byt $50, $77, $54, $74, $54, $74, $54, $74	; tile #69
	.byt $40, $7F, $40, $41, $40, $40, $40, $40	; tile #70
	.byt $45, $7B, $49, $6B, $69, $6B, $49, $4B	; tile #71
	.byt $6D, $75, $76, $7A, $5B, $5D, $4D, $6E	; tile #72
	.byt $54, $7E, $54, $7F, $55, $7F, $55, $7F	; tile #73
	.byt $75, $72, $79, $5A, $59, $6C, $4D, $6E	; tile #74
	.byt $53, $6B, $57, $66, $56, $6D, $4D, $5D	; tile #75
	.byt $55, $5F, $55, $7F, $55, $7F, $55, $7F	; tile #76
	.byt $4D, $6B, $5B, $57, $76, $6E, $6D, $5D	; tile #77
	.byt $54, $74, $54, $74, $54, $74, $57, $78	; tile #78
	.byt $49, $4B, $49, $4B, $49, $4B, $79, $47	; tile #79
	.byt $56, $77, $53, $7B, $55, $7D, $54, $7E	; tile #80
	.byt $75, $57, $59, $6B, $6D, $75, $76, $7A	; tile #81
	.byt $56, $76, $53, $7B, $53, $7D, $55, $7E	; tile #82
	.byt $40, $77, $5F, $5D, $5F, $67, $6F, $75	; tile #83
	.byt $40, $5D, $7F, $77, $7F, $5D, $7F, $77	; tile #84
	.byt $40, $77, $7F, $5D, $7F, $77, $7F, $5D	; tile #85
	.byt $40, $77, $7E, $5C, $7E, $75, $7D, $5B	; tile #86
	.byt $59, $5B, $75, $77, $75, $6F, $65, $5F	; tile #87
	.byt $53, $7A, $56, $75, $4D, $6B, $5B, $57	; tile #88
	.byt $59, $7B, $75, $77, $65, $6F, $55, $5F	; tile #89
	.byt $55, $7F, $50, $77, $4F, $6E, $5F, $5F	; tile #90
	.byt $55, $7F, $40, $7F, $5F, $6D, $5D, $7F	; tile #91
	.byt $55, $7F, $40, $7F, $7F, $EA, $D5, $7F	; tile #92
	.byt $55, $7F, $45, $7B, $7D, $7D, $7E, $7E	; tile #93
	.byt $55, $5F, $65, $6F, $75, $57, $59, $68	; tile #94
	.byt $54, $7E, $55, $7F, $55, $7F, $55, $40	; tile #95
	.byt $77, $77, $5B, $59, $4B, $67, $47, $4D	; tile #96
	.byt $7F, $5D, $7F, $77, $7F, $5D, $7F, $77	; tile #97
	.byt $7F, $77, $7F, $5D, $7F, $77, $7F, $5D	; tile #98
	.byt $7B, $73, $76, $56, $75, $71, $79, $5C	; tile #99
	.byt $55, $5F, $55, $7F, $55, $7F, $55, $40	; tile #100
	.byt $54, $7E, $55, $7D, $53, $7A, $56, $45	; tile #101
	.byt $5F, $4E, $57, $57, $58, $5B, $5B, $5B	; tile #102
	.byt $5D, $6D, $5F, $7F, $40, $7F, $7F, $7F	; tile #103
	.byt $F3, $DB, $EB, $7F, $40, $7F, $7F, $7F	; tile #104
	.byt $7C, $7C, $7A, $7A, $46, $76, $76, $76	; tile #105
	.byt $55, $5F, $65, $6F, $75, $77, $59, $58	; tile #106
	.byt $7F, $5D, $7F, $77, $5F, $5D, $6F, $67	; tile #107
	.byt $7F, $5D, $7F, $77, $7E, $5C, $7D, $75	; tile #108
	.byt $6D, $6B, $5B, $57, $76, $6E, $6D, $5D	; tile #109
	.byt $5B, $5B, $5B, $5B, $5B, $5B, $5B, $5B	; tile #110
	.byt $40, $5F, $40, $5F, $40, $5F, $40, $5F	; tile #111
	.byt $40, $7E, $40, $7E, $40, $7E, $40, $7E	; tile #112
	.byt $76, $76, $76, $76, $76, $76, $76, $76	; tile #113
	.byt $77, $59, $5B, $67, $67, $6D, $6F, $57	; tile #114
	.byt $7B, $56, $76, $71, $79, $5D, $7D, $76	; tile #115
	.byt $77, $79, $5B, $57, $67, $6D, $6F, $57	; tile #116
	.byt $5F, $5D, $7F, $77, $7F, $5D, $7F, $77	; tile #117
	.byt $7E, $5D, $7F, $77, $7F, $5D, $7F, $77	; tile #118
	.byt $5B, $5B, $5B, $5B, $5B, $5B, $6B, $70	; tile #119
	.byt $40, $5F, $40, $5F, $40, $40, $7F, $40	; tile #120
	.byt $40, $7E, $40, $7E, $40, $40, $7F, $40	; tile #121
	.byt $76, $76, $76, $76, $76, $76, $75, $41	; tile #122
; Walkbox Data
wb_data
	.byt 000, 029, 013, 016, $00
	.byt 038, 064, 013, 016, $00
	.byt 030, 037, 014, 016, $00
; Walk matrix
wb_matrix
	.byt 0, 2, 2
	.byt 2, 1, 2
	.byt 0, 1, 2


res_end
.)

; Exit to corridor
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 200
res_start
	.byt OBJ_FLAG_PROP	; If OBJ_FLAG_PROP skip all costume data
	.byt 1,16		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 0,16		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt 0,14		; Walk position (col, row)
	.byt FACING_LEFT	; Facing direction for interaction
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


;Wall clock

.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 201
res_start
	.byt OBJ_FLAG_FROMDISTANCE	; If OBJ_FLAG_PROP skip all costume data
	.byt 2,1		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 25,3		; Pos (col, row)
	.byt ZPLANE_0		; Zplane
	.byt 24,15		; Walk position (col, row)
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
	.asc "Clock",0
#endif
#ifdef SPANISH
	.asc "Reloj",0
#endif
#ifdef FRENCH
	.asc "Horloge",0
#endif
res_end	
.)


; Block A
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 202
res_start
	.byt OBJ_FLAG_PROP	; If OBJ_FLAG_PROP skip all costume data
	.byt 12,12		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 6,12		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt 9,13		; Walk position (col, row)
	.byt FACING_UP	; Facing direction for interaction
	.byt 00			; Color of text
#ifdef ENGLISH
	.asc "Block A",0
#endif
#ifdef SPANISH
	.asc "Bloque A",0
#endif
#ifdef FRENCH
	.asc "Bloc A",0
#endif
res_end	
.)


; Block B
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 203
res_start
	.byt OBJ_FLAG_PROP	; If OBJ_FLAG_PROP skip all costume data
	.byt 12,12		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 54,12		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt 57,13		; Walk position (col, row)
	.byt FACING_UP	; Facing direction for interaction
	.byt 00			; Color of text
#ifdef ENGLISH
	.asc "Block B",0
#endif
#ifdef SPANISH
	.asc "Bloque B",0
#endif
#ifdef FRENCH
	.asc "Bloc B",0
#endif
res_end	
.)

; Terminal
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 204
res_start
	.byt OBJ_FLAG_PROP	; If OBJ_FLAG_PROP skip all costume data
	.byt 4,5		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 34,13		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt 34,14		; Walk position (col, row)
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

; Costume for wall clock
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
; Animatory state 0 (clock7a.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 1, 2, 0, 0, 0
; Animatory state 1 (clock7b.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 1, 3, 0, 0, 0
; Animatory state 2 (clock8a.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 4, 2, 0, 0, 0
; Animatory state 3 (clock8b.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 4, 3, 0, 0, 0
costume_tiles
; Tile graphic 1
.byt $1f, $1, $2, $4, $8, $8, $8, $8
; Tile graphic 2
.byt $0, $c, $c, $0, $0, $c, $c, $0
; Tile graphic 3
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 4
.byt $e, $11, $11, $e, $11, $11, $11, $e
costume_masks
; Tile mask 1
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 2
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 3
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 4
.byt $40, $40, $40, $40, $40, $40, $40, $40
res_end
.)



#include "..\scripts\cellcorridor.s"


