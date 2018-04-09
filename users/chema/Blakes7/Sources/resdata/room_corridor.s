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
; Room: Corridor
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.(
	.byt RESOURCE_ROOM
	.word (res_end - res_start + 4)
	.byt 45
res_start
; No. columns, offset to tile map, offset to tiles
	.byt 105, <(column_data-res_start), >(column_data-res_start), <(tiles_start-res_start), >(tiles_start-res_start)
; No. zplanes and offsets to zplanes
	.byt 0
; No. Walkboxes and offsets to wb data and matrix
	.byt 1, <(wb_data-res_start), >(wb_data-res_start), <(wb_matrix-res_start), >(wb_matrix-res_start)
; Offset to palette
	.byt 0, 0	; No palette information
; Entry and exit scripts
	.byt 200, 255
; Number of objects in the room and list of ids
	.byt 10,200,201,202,203,204,205,206,207,208,209
; Room name (null terminated)
	.asc "Corridor", 0
; Room tile map
; Room tile map
column_data
	.byt 001, 001, 001, 015, 015, 025, 037, 037, 073, 089, 089, 089, 089, 132, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 026, 036, 036, 074, 083, 105, 121, 083, 133, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 027, 035, 035, 075, 090, 106, 122, 090, 133, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 026, 036, 036, 074, 083, 107, 123, 083, 133, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 028, 038, 038, 076, 091, 091, 091, 091, 133, 141, 141, 141
	.byt 001, 001, 001, 015, 015, 029, 037, 037, 077, 089, 089, 089, 089, 134, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 026, 036, 036, 074, 083, 083, 083, 083, 133, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 027, 035, 035, 075, 090, 090, 090, 090, 133, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 026, 036, 036, 074, 083, 083, 083, 083, 133, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 027, 035, 035, 075, 090, 090, 090, 090, 133, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 026, 036, 036, 074, 083, 083, 083, 083, 133, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 027, 035, 035, 075, 090, 090, 090, 090, 133, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 026, 036, 036, 074, 083, 083, 083, 083, 133, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 027, 035, 035, 075, 090, 090, 090, 090, 133, 141, 141, 141
	.byt 001, 001, 001, 015, 015, 025, 037, 037, 073, 089, 089, 089, 089, 132, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 026, 036, 036, 074, 083, 083, 083, 083, 133, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 027, 035, 035, 075, 090, 090, 090, 090, 133, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 026, 036, 036, 074, 083, 083, 083, 083, 133, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 027, 035, 035, 075, 090, 090, 090, 090, 133, 141, 141, 141
	.byt 001, 001, 001, 015, 015, 030, 039, 039, 078, 092, 092, 092, 092, 134, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 027, 035, 062, 079, 091, 091, 091, 128, 133, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 026, 040, 016, 016, 016, 016, 016, 016, 135, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 027, 041, 016, 016, 093, 108, 124, 016, 135, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 026, 040, 063, 063, 094, 016, 125, 063, 136, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 027, 041, 016, 016, 016, 016, 016, 016, 135, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 026, 040, 016, 016, 016, 016, 016, 016, 135, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 027, 042, 064, 080, 089, 103, 089, 129, 132, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 026, 043, 065, 074, 095, 109, 074, 083, 133, 141, 141, 141
	.byt 001, 001, 001, 015, 015, 025, 037, 037, 073, 089, 089, 089, 089, 132, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 026, 036, 036, 074, 083, 083, 083, 083, 133, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 027, 035, 035, 075, 096, 110, 090, 090, 133, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 026, 036, 036, 074, 083, 083, 083, 083, 133, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 027, 035, 035, 075, 090, 090, 090, 090, 133, 141, 141, 141
	.byt 001, 001, 001, 015, 015, 029, 037, 037, 077, 089, 089, 089, 089, 134, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 026, 036, 036, 074, 097, 111, 083, 083, 133, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 027, 035, 035, 075, 098, 112, 090, 090, 133, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 026, 036, 036, 074, 099, 113, 083, 083, 133, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 027, 035, 035, 075, 090, 090, 090, 090, 133, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 026, 036, 036, 074, 097, 111, 083, 083, 133, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 027, 035, 035, 075, 098, 112, 090, 090, 133, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 026, 036, 036, 074, 099, 113, 083, 083, 133, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 027, 035, 035, 075, 090, 090, 090, 090, 133, 141, 141, 141
	.byt 001, 001, 001, 015, 015, 025, 037, 037, 073, 089, 089, 089, 089, 132, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 026, 036, 036, 074, 083, 083, 083, 083, 133, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 027, 035, 035, 075, 090, 090, 090, 090, 133, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 026, 036, 036, 074, 083, 083, 083, 083, 133, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 027, 035, 035, 075, 090, 090, 090, 090, 133, 141, 141, 141
	.byt 001, 001, 001, 015, 015, 030, 039, 039, 078, 092, 092, 092, 092, 134, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 027, 044, 062, 079, 091, 091, 091, 128, 133, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 031, 045, 016, 016, 016, 016, 016, 016, 135, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 032, 046, 016, 016, 093, 108, 124, 016, 135, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 031, 047, 063, 063, 094, 016, 125, 063, 136, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 032, 048, 016, 016, 016, 016, 016, 016, 135, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 031, 049, 016, 016, 016, 016, 016, 016, 135, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 027, 050, 066, 080, 089, 103, 089, 129, 132, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 026, 036, 036, 074, 095, 109, 074, 083, 133, 141, 141, 141
	.byt 001, 001, 001, 015, 015, 029, 037, 037, 077, 089, 089, 089, 089, 134, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 026, 036, 036, 074, 097, 111, 083, 083, 133, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 027, 035, 035, 075, 098, 112, 090, 090, 133, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 026, 036, 036, 074, 099, 113, 083, 083, 133, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 027, 035, 035, 075, 090, 090, 090, 090, 133, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 026, 036, 036, 074, 097, 111, 083, 083, 133, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 027, 035, 035, 075, 098, 112, 090, 090, 133, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 026, 036, 036, 074, 099, 113, 083, 083, 133, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 027, 035, 035, 075, 090, 090, 090, 090, 133, 141, 141, 141
	.byt 001, 001, 001, 015, 015, 030, 039, 039, 078, 092, 092, 092, 092, 134, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 027, 044, 062, 079, 091, 091, 091, 128, 133, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 031, 051, 016, 016, 016, 016, 016, 016, 135, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 032, 052, 016, 016, 093, 108, 124, 016, 135, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 031, 053, 063, 063, 094, 016, 125, 063, 136, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 032, 054, 016, 016, 016, 016, 016, 016, 135, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 031, 055, 016, 016, 016, 016, 016, 016, 135, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 027, 050, 066, 080, 089, 103, 089, 129, 132, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 026, 036, 036, 074, 095, 109, 074, 083, 133, 141, 141, 141
	.byt 001, 001, 001, 015, 015, 029, 037, 037, 077, 089, 089, 089, 089, 134, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 026, 036, 036, 074, 083, 083, 083, 083, 133, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 027, 035, 035, 075, 090, 090, 090, 090, 133, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 026, 036, 036, 074, 083, 083, 083, 083, 133, 141, 141, 141
	.byt 001, 001, 009, 008, 008, 028, 038, 038, 076, 091, 091, 091, 091, 133, 142, 141, 141
	.byt 001, 001, 010, 016, 016, 016, 016, 016, 016, 016, 016, 016, 016, 016, 143, 141, 141
	.byt 001, 001, 011, 015, 015, 025, 037, 037, 073, 089, 089, 089, 089, 132, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 026, 036, 036, 074, 100, 114, 083, 083, 133, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 027, 035, 035, 075, 101, 115, 090, 090, 133, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 026, 036, 036, 074, 102, 116, 083, 083, 133, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 027, 044, 062, 079, 091, 091, 091, 128, 133, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 031, 056, 016, 016, 016, 016, 016, 016, 135, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 032, 057, 016, 016, 093, 108, 124, 016, 135, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 031, 058, 063, 063, 094, 016, 125, 063, 136, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 032, 059, 016, 016, 016, 016, 016, 016, 135, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 031, 060, 016, 016, 016, 016, 016, 016, 135, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 027, 050, 066, 080, 089, 103, 089, 129, 132, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 026, 036, 036, 074, 095, 109, 074, 083, 133, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 027, 035, 035, 075, 090, 089, 090, 090, 133, 141, 141, 141
	.byt 001, 001, 001, 008, 008, 026, 036, 036, 074, 083, 083, 083, 083, 133, 141, 141, 141
	.byt 001, 001, 009, 008, 008, 028, 038, 038, 076, 091, 091, 091, 091, 133, 142, 141, 141
	.byt 001, 001, 010, 016, 016, 016, 016, 016, 016, 016, 016, 016, 016, 016, 143, 141, 141
	.byt 001, 001, 011, 015, 015, 033, 061, 061, 081, 103, 103, 103, 103, 132, 141, 141, 141
	.byt 001, 001, 012, 008, 017, 034, 036, 036, 074, 083, 083, 083, 083, 137, 144, 141, 141
	.byt 001, 001, 013, 008, 018, 035, 035, 067, 082, 090, 090, 090, 090, 138, 145, 141, 141
	.byt 001, 005, 014, 008, 019, 036, 036, 040, 083, 083, 083, 083, 083, 139, 146, 142, 141
	.byt 001, 006, 008, 008, 020, 035, 035, 068, 084, 090, 090, 126, 130, 090, 147, 148, 141
	.byt 001, 007, 008, 008, 021, 036, 036, 069, 085, 090, 117, 000, 000, 000, 000, 149, 141
	.byt 002, 008, 008, 008, 022, 035, 035, 070, 086, 083, 118, 127, 131, 140, 127, 150, 152
	.byt 003, 008, 008, 008, 023, 036, 036, 071, 087, 075, 119, 016, 016, 016, 016, 016, 153
	.byt 004, 008, 008, 008, 024, 035, 035, 072, 088, 104, 120, 089, 089, 089, 089, 151, 154

; Room tile set
tiles_start
	.byt $C0, $C0, $C0, $C0, $C0, $C0, $C0, $C0	; tile #1
	.byt $C0, $C0, $C0, $C0, $C0, $C0, $C3, $72	; tile #2
	.byt $C0, $C0, $C0, $C3, $CF, $4A, $40, $6A	; tile #3
	.byt $C3, $CD, $40, $6A, $40, $6A, $40, $6A	; tile #4
	.byt $C0, $C0, $C0, $C0, $C0, $C0, $C0, $C3	; tile #5
	.byt $C0, $C0, $C0, $C0, $C3, $72, $40, $6A	; tile #6
	.byt $C0, $C3, $CF, $4A, $40, $6A, $40, $6A	; tile #7
	.byt $40, $6A, $40, $6A, $40, $6A, $40, $6A	; tile #8
	.byt $C0, $C0, $C0, $C0, $C0, $C0, $C0, $C1	; tile #9
	.byt $C0, $C0, $C0, $C0, $C0, $C0, $40, $7F	; tile #10
	.byt $C0, $C0, $C0, $C0, $C0, $C0, $C0, $E0	; tile #11
	.byt $C0, $C0, $C0, $C0, $C0, $C3, $CF, $4A	; tile #12
	.byt $C0, $C0, $C3, $CD, $40, $6A, $40, $6A	; tile #13
	.byt $CF, $4A, $40, $6A, $40, $6A, $40, $6A	; tile #14
	.byt $40, $4A, $40, $4A, $40, $4A, $40, $4A	; tile #15
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $7F, $7F	; tile #16
	.byt $40, $6A, $40, $6A, $40, $6A, $40, $68	; tile #17
	.byt $40, $6A, $40, $6A, $40, $6A, $40, $47	; tile #18
	.byt $40, $6A, $40, $6A, $40, $60, $47, $7F	; tile #19
	.byt $40, $6A, $40, $6A, $40, $4F, $5D, $7F	; tile #20
	.byt $40, $6A, $40, $40, $5D, $7F, $77, $7F	; tile #21
	.byt $40, $6A, $40, $47, $77, $7F, $5D, $7F	; tile #22
	.byt $40, $40, $77, $7F, $5D, $7F, $77, $7F	; tile #23
	.byt $41, $5F, $5D, $7F, $77, $7F, $5D, $7F	; tile #24
	.byt $40, $5F, $5D, $5F, $57, $5F, $5D, $5F	; tile #25
	.byt $40, $7F, $77, $7F, $5D, $7F, $77, $7F	; tile #26
	.byt $40, $7F, $5D, $7F, $77, $7F, $5D, $7F	; tile #27
	.byt $40, $7E, $5C, $7E, $76, $7E, $5C, $7E	; tile #28
	.byt $60, $5F, $5D, $5F, $57, $5F, $5D, $5F	; tile #29
	.byt $60, $5F, $57, $5F, $5D, $5F, $57, $5F	; tile #30
	.byt $40, $7F, $77, $7F, $5D, $7F, $77, $40	; tile #31
	.byt $40, $7F, $5D, $7F, $77, $7F, $5D, $40	; tile #32
	.byt $40, $5E, $5C, $5E, $56, $5E, $5C, $5E	; tile #33
	.byt $45, $7F, $77, $7F, $5D, $7F, $77, $7F	; tile #34
	.byt $77, $7F, $5D, $7F, $77, $7F, $5D, $7F	; tile #35
	.byt $5D, $7F, $77, $7F, $5D, $7F, $77, $7F	; tile #36
	.byt $57, $5F, $5D, $5F, $57, $5F, $5D, $5F	; tile #37
	.byt $76, $7E, $5C, $7E, $76, $7E, $5C, $7E	; tile #38
	.byt $5D, $5F, $57, $5F, $5D, $5F, $57, $5F	; tile #39
	.byt $5D, $7F, $77, $7F, $5D, $7F, $77, $40	; tile #40
	.byt $77, $7F, $5D, $7F, $77, $7F, $5D, $40	; tile #41
	.byt $CC, $CC, $C0, $DE, $DE, $DE, $CC, $CC	; tile #42
	.byt $CC, $CC, $C0, $CC, $DE, $FF, $CC, $CC	; tile #43
	.byt $76, $7E, $5C, $7E, $76, $7E, $5C, $7F	; tile #44
	.byt $C0, $CD, $D1, $D1, $D1, $CD, $C0, $40	; tile #45
	.byt $C0, $F6, $D5, $D4, $D4, $F4, $C0, $40	; tile #46
	.byt $C0, $F6, $D5, $D4, $D4, $D4, $C0, $40	; tile #47
	.byt $C0, $F7, $D5, $D5, $D5, $D7, $C0, $40	; tile #48
	.byt $C0, $D2, $DA, $DA, $D6, $D2, $C0, $40	; tile #49
	.byt $57, $5F, $5D, $5F, $57, $5F, $5D, $7F	; tile #50
	.byt $C0, $D1, $D2, $D3, $D2, $DA, $C0, $40	; tile #51
	.byt $C0, $CA, $EA, $EA, $EA, $EE, $C0, $40	; tile #52
	.byt $C0, $E5, $F5, $F5, $ED, $E5, $C0, $40	; tile #53
	.byt $C0, $E6, $D5, $D6, $D5, $E5, $C0, $40	; tile #54
	.byt $C0, $D4, $D4, $C8, $C8, $C8, $C0, $40	; tile #55
	.byt $C0, $C3, $C4, $C2, $C1, $C6, $C0, $40	; tile #56
	.byt $C0, $DB, $D2, $DB, $D2, $DA, $C0, $40	; tile #57
	.byt $C0, $CA, $EA, $CA, $EA, $E4, $C0, $40	; tile #58
	.byt $C0, $E6, $E8, $E8, $E8, $E6, $C0, $40	; tile #59
	.byt $C0, $F0, $E0, $F0, $E0, $F0, $C0, $40	; tile #60
	.byt $56, $5E, $5C, $5E, $56, $5E, $5C, $5E	; tile #61
	.byt $76, $7E, $5C, $7E, $76, $7E, $5C, $7C	; tile #62
	.byt $7B, $7B, $7B, $7B, $7B, $7B, $7B, $7B	; tile #63
	.byt $5F, $5F, $5D, $5F, $57, $5F, $5D, $4F	; tile #64
	.byt $7F, $7F, $77, $7F, $5D, $7F, $77, $7F	; tile #65
	.byt $57, $5F, $5D, $5F, $57, $5F, $5D, $4F	; tile #66
	.byt $77, $7F, $5D, $7F, $77, $7F, $5D, $7C	; tile #67
	.byt $77, $7F, $5D, $7E, $75, $7D, $5D, $41	; tile #68
	.byt $5D, $7F, $70, $4F, $C0, $7F, $C0, $7F	; tile #69
	.byt $77, $7F, $40, $7F, $F1, $55, $EA, $55	; tile #70
	.byt $5D, $70, $47, $7F, $C0, $5F, $E0, $5F	; tile #71
	.byt $77, $5F, $6D, $6F, $67, $6F, $60, $67	; tile #72
	.byt $40, $5D, $5F, $57, $5F, $5D, $5F, $57	; tile #73
	.byt $40, $77, $7F, $5D, $7F, $77, $7F, $5D	; tile #74
	.byt $40, $5D, $7F, $77, $7F, $5D, $7F, $77	; tile #75
	.byt $40, $5C, $7E, $76, $7E, $5C, $7E, $76	; tile #76
	.byt $60, $5D, $5F, $57, $5F, $5D, $5F, $57	; tile #77
	.byt $60, $57, $5F, $5D, $5F, $57, $5F, $5D	; tile #78
	.byt $42, $5C, $7E, $76, $7E, $5C, $7E, $76	; tile #79
	.byt $50, $5D, $5F, $57, $5F, $5D, $5F, $57	; tile #80
	.byt $40, $5C, $5E, $56, $5E, $5C, $5E, $56	; tile #81
	.byt $43, $5D, $7F, $77, $7F, $5D, $7F, $77	; tile #82
	.byt $7F, $77, $7F, $5D, $7F, $77, $7F, $5D	; tile #83
	.byt $7D, $5D, $7D, $75, $7D, $5D, $7D, $76	; tile #84
	.byt $C0, $67, $D3, $65, $D2, $65, $C0, $40	; tile #85
	.byt $C1, $7F, $C4, $51, $E4, $5B, $C0, $40	; tile #86
	.byt $C0, $7F, $C0, $4A, $E5, $5D, $E2, $7F	; tile #87
	.byt $6F, $6D, $6F, $67, $6F, $6D, $6F, $67	; tile #88
	.byt $5F, $5D, $5F, $57, $5F, $5D, $5F, $57	; tile #89
	.byt $7F, $5D, $7F, $77, $7F, $5D, $7F, $77	; tile #90
	.byt $7E, $5C, $7E, $76, $7E, $5C, $7E, $76	; tile #91
	.byt $5F, $57, $5F, $5D, $5F, $57, $5F, $5D	; tile #92
	.byt $7F, $7F, $7F, $7F, $7E, $7D, $7B, $77	; tile #93
	.byt $7B, $77, $6F, $5F, $7F, $7F, $7F, $7F	; tile #94
	.byt $7F, $77, $7F, $5D, $7F, $77, $7F, $40	; tile #95
	.byt $40, $5E, $52, $52, $52, $52, $52, $52	; tile #96
	.byt $7F, $60, $FF, $40, $FF, $40, $FF, $40	; tile #97
	.byt $7F, $40, $FF, $40, $FF, $40, $FF, $40	; tile #98
	.byt $7F, $41, $E7, $44, $FB, $44, $FF, $40	; tile #99
	.byt $40, $5F, $50, $57, $57, $57, $57, $54	; tile #100
	.byt $40, $7F, $40, $7F, $F6, $7F, $7F, $CA	; tile #101
	.byt $40, $7E, $42, $7A, $6A, $52, $6A, $7A	; tile #102
	.byt $5E, $5C, $5E, $56, $5E, $5C, $5E, $56	; tile #103
	.byt $4F, $5D, $7F, $77, $7F, $5D, $7F, $77	; tile #104
	.byt $7F, $77, $70, $DD, $61, $D9, $60, $DF	; tile #105
	.byt $7F, $5D, $40, $F7, $52, $C9, $60, $FE	; tile #106
	.byt $7F, $77, $43, $DC, $51, $D6, $41, $FE	; tile #107
	.byt $77, $77, $77, $77, $77, $77, $77, $77	; tile #108
	.byt $C0, $DC, $C0, $C4, $D4, $C4, $C0, $C0	; tile #109
	.byt $52, $52, $52, $52, $52, $52, $5E, $40	; tile #110
	.byt $FF, $40, $FF, $60, $7F, $77, $7F, $5D	; tile #111
	.byt $FF, $40, $FF, $40, $7F, $5D, $7F, $77	; tile #112
	.byt $FF, $40, $FF, $41, $7F, $77, $7F, $5D	; tile #113
	.byt $54, $54, $57, $57, $57, $50, $5F, $40	; tile #114
	.byt $CA, $7F, $CC, $7F, $7F, $40, $7F, $40	; tile #115
	.byt $6A, $52, $6A, $7A, $7A, $42, $7E, $40	; tile #116
	.byt $78, $60, $40, $40, $40, $40, $40, $40	; tile #117
	.byt $40, $7E, $7E, $7E, $7E, $7E, $7E, $7E	; tile #118
	.byt $41, $40, $7C, $7E, $7F, $7F, $7F, $7F	; tile #119
	.byt $7F, $7D, $5F, $57, $5F, $5D, $5F, $57	; tile #120
	.byt $60, $DA, $61, $DD, $70, $77, $7F, $5D	; tile #121
	.byt $42, $DD, $54, $F0, $40, $5D, $7F, $77	; tile #122
	.byt $61, $DE, $51, $CC, $43, $77, $7F, $5D	; tile #123
	.byt $77, $7B, $7D, $7E, $7F, $7F, $7F, $7F	; tile #124
	.byt $7F, $7F, $7F, $7F, $5F, $6F, $77, $7B	; tile #125
	.byt $7F, $5D, $7F, $77, $73, $4D, $5D, $5D	; tile #126
	.byt $7E, $7E, $7E, $7E, $7E, $7E, $7E, $7E	; tile #127
	.byt $7E, $5C, $7E, $76, $7E, $5C, $7E, $74	; tile #128
	.byt $5F, $5D, $5F, $57, $5F, $5D, $5F, $47	; tile #129
	.byt $55, $4D, $55, $55, $5D, $5D, $65, $73	; tile #130
	.byt $7D, $7B, $77, $6F, $6F, $6F, $6F, $6F	; tile #131
	.byt $40, $4A, $40, $4A, $40, $4A, $40, $40	; tile #132
	.byt $40, $6A, $40, $6A, $40, $6A, $40, $40	; tile #133
	.byt $60, $4A, $40, $4A, $40, $4A, $40, $40	; tile #134
	.byt $7F, $7F, $7F, $7F, $7F, $7F, $7F, $40	; tile #135
	.byt $7B, $7B, $7B, $7B, $7B, $7B, $7B, $40	; tile #136
	.byt $7F, $47, $40, $6A, $40, $6A, $40, $6A	; tile #137
	.byt $7F, $5D, $7F, $47, $41, $68, $40, $6A	; tile #138
	.byt $7F, $77, $7F, $5D, $7F, $57, $43, $68	; tile #139
	.byt $6F, $6F, $6F, $6F, $6F, $77, $7B, $7D	; tile #140
	.byt $55, $6A, $55, $6A, $55, $6A, $55, $6A	; tile #141
	.byt $54, $6A, $55, $6A, $55, $6A, $55, $6A	; tile #142
	.byt $7F, $40, $55, $6A, $55, $6A, $55, $6A	; tile #143
	.byt $40, $62, $54, $6A, $55, $6A, $55, $6A	; tile #144
	.byt $40, $6A, $40, $42, $50, $68, $55, $6A	; tile #145
	.byt $40, $6A, $40, $6A, $40, $6A, $40, $60	; tile #146
	.byt $47, $68, $40, $6A, $40, $6A, $40, $6A	; tile #147
	.byt $40, $4A, $50, $68, $55, $6A, $55, $6A	; tile #148
	.byt $40, $40, $40, $40, $40, $60, $54, $6A	; tile #149
	.byt $7E, $7E, $7E, $7E, $7E, $7E, $7E, $4E	; tile #150
	.byt $41, $48, $40, $4A, $40, $4A, $40, $4A	; tile #151
	.byt $52, $68, $55, $6A, $55, $6A, $55, $6A	; tile #152
	.byt $7F, $7F, $4F, $63, $54, $6A, $55, $6A	; tile #153
	.byt $40, $4A, $40, $4A, $40, $4A, $50, $68	; tile #154
; Walkbox Data
wb_data
	.byt 000, 099, 014, 016, $41
; Walk matrix
wb_matrix
	.byt 0


res_end
.)

; Costume for doors
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
; Animatory state 0 (door0.png)
.byt 1, 1, 2, 1, 1
.byt 1, 1, 2, 1, 1
.byt 1, 3, 4, 1, 1
.byt 1, 5, 1, 1, 1
.byt 1, 6, 7, 1, 1
.byt 1, 1, 2, 1, 1
.byt 8, 8, 9, 8, 8
; Animatory state 1 (door01.png)
.byt 1, 10, 11, 12, 1
.byt 1, 10, 11, 12, 1
.byt 13, 14, 15, 16, 1
.byt 17, 11, 18, 1, 1
.byt 19, 20, 21, 22, 1
.byt 1, 10, 11, 12, 1
.byt 8, 23, 11, 24, 8
; Animatory state 2 (door02.png)
.byt 1, 25, 11, 11, 1
.byt 1, 25, 11, 11, 1
.byt 26, 27, 28, 29, 1
.byt 11, 11, 30, 1, 1
.byt 31, 32, 33, 34, 1
.byt 1, 25, 11, 11, 1
.byt 8, 35, 11, 11, 8
; Animatory state 3 (door03.png)
.byt 36, 11, 11, 11, 37
.byt 36, 11, 11, 11, 37
.byt 38, 11, 11, 39, 40
.byt 11, 11, 11, 41, 1
.byt 42, 11, 11, 43, 44
.byt 36, 11, 11, 11, 37
.byt 45, 11, 11, 11, 46
; Animatory state 4 (door04.png)
.byt 11, 11, 11, 11, 11
.byt 11, 11, 11, 11, 11
.byt 11, 11, 11, 11, 15
.byt 11, 11, 11, 11, 18
.byt 11, 11, 11, 11, 21
.byt 11, 11, 11, 11, 11
.byt 11, 11, 11, 11, 11
; Animatory state 5 (door05.png)
.byt 11, 11, 11, 11, 11
.byt 11, 11, 11, 11, 11
.byt 11, 11, 11, 11, 11
.byt 11, 11, 11, 11, 11
.byt 11, 11, 11, 11, 11
.byt 11, 11, 11, 11, 11
.byt 11, 11, 11, 11, 11
costume_tiles
; Tile graphic 1
.byt $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f
; Tile graphic 2
.byt $3b, $3b, $3b, $3b, $3b, $3b, $3b, $3b
; Tile graphic 3
.byt $3f, $3f, $3f, $3f, $3e, $3d, $3b, $37
; Tile graphic 4
.byt $3b, $37, $2f, $1f, $3f, $3f, $3f, $3f
; Tile graphic 5
.byt $37, $37, $37, $37, $37, $37, $37, $37
; Tile graphic 6
.byt $37, $3b, $3d, $3e, $3f, $3f, $3f, $3f
; Tile graphic 7
.byt $3f, $3f, $3f, $3f, $1f, $2f, $37, $3b
; Tile graphic 8
.byt $3f, $3f, $3f, $3f, $3f, $3f, $3f, $0
; Tile graphic 9
.byt $3b, $3b, $3b, $3b, $3b, $3b, $3b, $0
; Tile graphic 10
.byt $3e, $3e, $3e, $3e, $3e, $3e, $3e, $3e
; Tile graphic 11
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 12
.byt $f, $f, $f, $f, $f, $f, $f, $f
; Tile graphic 13
.byt $3f, $3f, $3f, $3f, $3f, $3f, $3e, $3c
; Tile graphic 14
.byt $3e, $3c, $38, $30, $20, $0, $0, $0
; Tile graphic 15
.byt $0, $0, $0, $1, $3, $7, $f, $1f
; Tile graphic 16
.byt $f, $1f, $3f, $3f, $3f, $3f, $3f, $3f
; Tile graphic 17
.byt $3c, $3c, $3c, $3c, $3c, $3c, $3c, $3c
; Tile graphic 18
.byt $1f, $1f, $1f, $1f, $1f, $1f, $1f, $1f
; Tile graphic 19
.byt $3c, $3e, $3f, $3f, $3f, $3f, $3f, $3f
; Tile graphic 20
.byt $0, $0, $0, $20, $30, $38, $3c, $3e
; Tile graphic 21
.byt $1f, $f, $7, $3, $1, $0, $0, $0
; Tile graphic 22
.byt $3f, $3f, $3f, $3f, $3f, $3f, $1f, $f
; Tile graphic 23
.byt $3e, $3e, $3e, $3e, $3e, $3e, $3e, $0
; Tile graphic 24
.byt $f, $f, $f, $f, $f, $f, $f, $0
; Tile graphic 25
.byt $20, $20, $20, $20, $20, $20, $20, $20
; Tile graphic 26
.byt $3f, $3f, $3e, $3c, $38, $30, $20, $0
; Tile graphic 27
.byt $20, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 28
.byt $0, $0, $0, $0, $0, $0, $0, $1
; Tile graphic 29
.byt $0, $1, $3, $7, $f, $1f, $3f, $3f
; Tile graphic 30
.byt $1, $1, $1, $1, $1, $1, $1, $1
; Tile graphic 31
.byt $0, $20, $30, $38, $3c, $3e, $3f, $3f
; Tile graphic 32
.byt $0, $0, $0, $0, $0, $0, $0, $20
; Tile graphic 33
.byt $1, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 34
.byt $3f, $3f, $1f, $f, $7, $3, $1, $0
; Tile graphic 35
.byt $20, $20, $20, $20, $20, $20, $20, $0
; Tile graphic 36
.byt $38, $38, $38, $38, $38, $38, $38, $38
; Tile graphic 37
.byt $3, $3, $3, $3, $3, $3, $3, $3
; Tile graphic 38
.byt $38, $30, $20, $0, $0, $0, $0, $0
; Tile graphic 39
.byt $0, $0, $0, $0, $0, $1, $3, $7
; Tile graphic 40
.byt $3, $7, $f, $1f, $3f, $3f, $3f, $3f
; Tile graphic 41
.byt $7, $7, $7, $7, $7, $7, $7, $7
; Tile graphic 42
.byt $0, $0, $0, $0, $0, $20, $30, $38
; Tile graphic 43
.byt $7, $3, $1, $0, $0, $0, $0, $0
; Tile graphic 44
.byt $3f, $3f, $3f, $3f, $1f, $f, $7, $3
; Tile graphic 45
.byt $38, $38, $38, $38, $38, $38, $38, $0
; Tile graphic 46
.byt $3, $3, $3, $3, $3, $3, $3, $0
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
res_end
.)

/*
; Costume for lateral door
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
; Animatory state 0 (door0.png)
.byt 1, 2, 3, 0, 0
.byt 4, 5, 6, 0, 0
.byt 4, 7, 6, 0, 0
.byt 4, 8, 6, 0, 0
.byt 4, 5, 6, 0, 0
.byt 9, 10, 6, 0, 0
.byt 0, 11, 12, 0, 0
; Animatory state 1 (door1.png)
.byt 1, 13, 14, 0, 0
.byt 4, 15, 16, 0, 0
.byt 4, 17, 18, 0, 0
.byt 4, 19, 20, 0, 0
.byt 4, 21, 16, 0, 0
.byt 9, 22, 16, 0, 0
.byt 0, 11, 23, 0, 0
; Animatory state 2 (door2.png)
.byt 1, 24, 25, 0, 0
.byt 4, 26, 4, 0, 0
.byt 4, 27, 28, 0, 0
.byt 4, 29, 30, 0, 0
.byt 4, 26, 4, 0, 0
.byt 9, 31, 4, 0, 0
.byt 0, 11, 32, 0, 0
; Animatory state 3 (door4.png)
.byt 1, 33, 25, 0, 0
.byt 4, 33, 4, 0, 0
.byt 4, 33, 4, 0, 0
.byt 4, 33, 4, 0, 0
.byt 4, 33, 4, 0, 0
.byt 9, 34, 4, 0, 0
.byt 0, 11, 32, 0, 0
costume_tiles
; Tile graphic 1
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 2
.byt $0, $3e, $3e, $3e, $3e, $3e, $3e, $3e
; Tile graphic 3
.byt $0, $0, $3c, $3e, $3f, $3f, $3f, $3f
; Tile graphic 4
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 5
.byt $3e, $3e, $3e, $3e, $3e, $3e, $3e, $3e
; Tile graphic 6
.byt $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f
; Tile graphic 7
.byt $3d, $3b, $37, $2f, $2f, $2f, $2f, $2f
; Tile graphic 8
.byt $2f, $2f, $2f, $2f, $2f, $37, $3b, $3d
; Tile graphic 9
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 10
.byt $3e, $3e, $3e, $3e, $3e, $e, $6, $0
; Tile graphic 11
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 12
.byt $3f, $f, $7, $1, $0, $0, $0, $0
; Tile graphic 13
.byt $0, $3c, $3c, $3c, $3c, $3c, $3c, $3c
; Tile graphic 14
.byt $0, $0, $4, $6, $7, $7, $7, $7
; Tile graphic 15
.byt $3c, $3c, $3c, $3c, $3c, $3c, $3c, $38
; Tile graphic 16
.byt $7, $7, $7, $7, $7, $7, $7, $7
; Tile graphic 17
.byt $30, $20, $20, $21, $21, $21, $21, $21
; Tile graphic 18
.byt $f, $1f, $3f, $3f, $3f, $3f, $3f, $3f
; Tile graphic 19
.byt $21, $21, $21, $21, $21, $20, $20, $30
; Tile graphic 20
.byt $3f, $3f, $3f, $3f, $3f, $3f, $1f, $f
; Tile graphic 21
.byt $38, $3c, $3c, $3c, $3c, $3c, $3c, $3c
; Tile graphic 22
.byt $3c, $3c, $3c, $3c, $3c, $c, $4, $0
; Tile graphic 23
.byt $7, $7, $7, $1, $0, $0, $0, $0
; Tile graphic 24
.byt $0, $30, $30, $30, $30, $30, $30, $30
; Tile graphic 25
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 26
.byt $30, $30, $30, $30, $30, $30, $30, $30
; Tile graphic 27
.byt $30, $30, $0, $10, $0, $10, $0, $10
; Tile graphic 28
.byt $1, $3, $7, $f, $f, $f, $f, $f
; Tile graphic 29
.byt $0, $10, $0, $10, $0, $10, $20, $30
; Tile graphic 30
.byt $f, $f, $f, $f, $f, $7, $3, $1
; Tile graphic 31
.byt $30, $30, $30, $30, $30, $0, $0, $0
; Tile graphic 32
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 33
.byt $0, $10, $0, $10, $0, $10, $0, $10
; Tile graphic 34
.byt $0, $10, $0, $10, $0, $0, $0, $0
costume_masks
; Tile mask 1
.byt $78, $60, $40, $40, $40, $40, $40, $40
; Tile mask 2
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 3
.byt $47, $40, $40, $40, $40, $40, $40, $40
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
.byt $40, $40, $40, $40, $40, $ff, $ff, $ff
; Tile mask 10
.byt $40, $40, $40, $40, $40, $40, $70, $78
; Tile mask 11
.byt $7e, $ff, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 12
.byt $40, $40, $70, $78, $7e, $ff, $ff, $ff
; Tile mask 13
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 14
.byt $47, $40, $40, $40, $40, $40, $40, $40
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
.byt $40, $40, $40, $40, $40, $40, $70, $78
; Tile mask 23
.byt $40, $40, $70, $78, $7e, $ff, $ff, $ff
; Tile mask 24
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 25
.byt $47, $40, $40, $40, $40, $40, $40, $40
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
.byt $40, $40, $40, $40, $40, $40, $70, $78
; Tile mask 32
.byt $40, $40, $70, $78, $7e, $ff, $ff, $ff
; Tile mask 33
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 34
.byt $40, $40, $40, $40, $40, $40, $70, $78
res_end
.)
*/

;;;;;;;;;;;;;;;;;;;;;;;;
; Door objects
;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Object resource: Door to service
.(
	.byt RESOURCE_OBJECT|$80
	.word (res_end - res_start +4)
	.byt 200
res_start
	.byt 0			; If OBJ_FLAG_PROP skip all costume data
	.byt 5,7		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 85,13		; Pos (col, row)
	.byt ZPLANE_0		; Zplane
	.byt 85,14		; Walk position (col, row)
	.byt FACING_UP		; Facing direction for interaction
	.byt 00			; Color of text

	; META: TODO
	; tiles and pointers to animatory states are setup in the costume
	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt 200		; costume ($ff for none) and skip the rest
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

; Object resource: Door to toilet
.(
	.byt RESOURCE_OBJECT|$80
	.word (res_end - res_start +4)
	.byt 201
res_start
	.byt 0			; If OBJ_FLAG_PROP skip all costume data
	.byt 5,7		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 21,13		; Pos (col, row)
	.byt ZPLANE_0		; Zplane
	.byt 21,14		; Walk position (col, row)
	.byt FACING_UP		; Facing direction for interaction
	.byt 00			; Color of text

	; META: TODO
	; tiles and pointers to animatory states are setup in the costume
	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt 200		; costume ($ff for none) and skip the rest
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


; Object resource: Door to common room
.(
	.byt RESOURCE_OBJECT|$80
	.word (res_end - res_start +4)
	.byt 202
res_start
	.byt 0			; If OBJ_FLAG_PROP skip all costume data
	.byt 5,7		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 49,13		; Pos (col, row)
	.byt ZPLANE_0		; Zplane
	.byt 49,14		; Walk position (col, row)
	.byt FACING_UP		; Facing direction for interaction
	.byt 00			; Color of text

	; META: TODO
	; tiles and pointers to animatory states are setup in the costume
	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt 200		; costume ($ff for none) and skip the rest
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

; Object resource: Door to Laundry
.(
	.byt RESOURCE_OBJECT|$80
	.word (res_end - res_start +4)
	.byt 203
res_start
	.byt 0			; If OBJ_FLAG_PROP skip all costume data
	.byt 5,7		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 67,13		; Pos (col, row)
	.byt ZPLANE_0		; Zplane
	.byt 67,14		; Walk position (col, row)	
	.byt FACING_UP		; Facing direction for interaction
	.byt 00			; Color of text

	; META: TODO
	; tiles and pointers to animatory states are setup in the costume
	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt 200		; costume ($ff for none) and skip the rest
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


; Exit to cells
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 204
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
	.asc "Cells",0
#endif
#ifdef SPANISH
	.asc "Celdas",0
#endif
#ifdef FRENCH
	.asc "Cellules",0
#endif
res_end	
.)


; Object resource: Entry door
.(
	.byt RESOURCE_OBJECT|$80
	.word (res_end - res_start +4)
	.byt 205
res_start
	.byt OBJ_FLAG_PROP 			; If OBJ_FLAG_PROP skip all costume data
	.byt 3,7		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 101,16		; Pos (col, row)
	.byt ZPLANE_0		; Zplane
	.byt 97,15		; Walk position (col, row)
	.byt FACING_RIGHT	; Facing direction for interaction
	.byt 00			; Color of text
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


; Object resource: Screen right
.(
	.byt RESOURCE_OBJECT|$80
	.word (res_end - res_start +4)
	.byt 206
res_start
	.byt 0;OBJ_FLAG_PROP 			; If OBJ_FLAG_PROP skip all costume data
	.byt 4,2		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 61,10		; Pos (col, row)
	.byt ZPLANE_0		; Zplane
	.byt 64,14		; Walk position (col, row)
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

; Object resource: Screen right 2
.(
	.byt RESOURCE_OBJECT|$80
	.word (res_end - res_start +4)
	.byt 207
res_start
	.byt 0;OBJ_FLAG_PROP 			; If OBJ_FLAG_PROP skip all costume data
	.byt 4,2		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 57,10		; Pos (col, row)
	.byt ZPLANE_0		; Zplane
	.byt 64,14		; Walk position (col, row)
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

; Object resource: Screen left
.(
	.byt RESOURCE_OBJECT|$80
	.word (res_end - res_start +4)
	.byt 208
res_start
	.byt 0;OBJ_FLAG_PROP 			; If OBJ_FLAG_PROP skip all costume data
	.byt 4,2		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 38,10		; Pos (col, row)
	.byt ZPLANE_0		; Zplane
	.byt 41,14		; Walk position (col, row)
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

; Object resource: Screen left 2
.(
	.byt RESOURCE_OBJECT|$80
	.word (res_end - res_start +4)
	.byt 209
res_start
	.byt 0;OBJ_FLAG_PROP 			; If OBJ_FLAG_PROP skip all costume data
	.byt 4,2		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 34,10		; Pos (col, row)
	.byt ZPLANE_0		; Zplane
	.byt 41,14		; Walk position (col, row)
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
; Object resource: Entry door
.(
	.byt RESOURCE_OBJECT|$80
	.word (res_end - res_start +4)
	.byt 205
res_start
	.byt 0			; If OBJ_FLAG_PROP skip all costume data
	.byt 3,7		; Size (col, row)
	.byt $ff		; Room ($ff = current)
	.byt 101,16		; Pos (col, row)
	.byt ZPLANE_0		; Zplane
	.byt 97,15		; Walk position (col, row)
	.byt FACING_RIGHT	; Facing direction for interaction
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
#ifdef FRENCH
	.asc "Porte",0
#endif
res_end	
.)
*/



; Costume for screens
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
; Animatory state 0 (0-.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 0, 0
.byt 4, 5, 6, 0, 0
; Animatory state 1 (1-.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 7, 8, 9, 0, 0
.byt 10, 11, 12, 0, 0
; Animatory state 2 (2-.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 13, 14, 15, 0, 0
.byt 16, 17, 18, 0, 0
; Animatory state 3 (3-.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 19, 20, 21, 0, 0
.byt 22, 23, 24, 0, 0
; Animatory state 4 (4-.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 25, 26, 27, 0, 0
.byt 28, 29, 30, 0, 0
; Animatory state 5 (5-.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 25, 31, 32, 0, 0
.byt 28, 33, 34, 0, 0
; Animatory state 6 (6-.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 35, 36, 37, 0, 0
.byt 38, 39, 40, 0, 0
; Animatory state 7 (7-.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 41, 42, 43, 0, 0
.byt 44, 45, 46, 0, 0
; Animatory state 8 (8-.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 47, 48, 49, 0, 0
.byt 50, 51, 52, 0, 0
; Animatory state 9 (9-.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 53, 26, 49, 0, 0
.byt 54, 29, 52, 0, 0
; Animatory state 10 (a-.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 25, 26, 49, 0, 0
.byt 28, 29, 52, 0, 0
; Animatory state 11 (b-.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 55, 56, 49, 0, 0
.byt 57, 58, 52, 0, 0
; Animatory state 12 (c-.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 59, 60, 61, 0, 0
.byt 28, 29, 52, 0, 0
; Animatory state 13 (d-.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 62, 63, 64, 0, 0
.byt 28, 29, 52, 0, 0
; Animatory state 14 (f-.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 65, 66, 67, 0, 0
.byt 28, 29, 52, 0, 0
; Animatory state 15 (g-.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 65, 66, 67, 0, 0
.byt 68, 69, 52, 0, 0
costume_tiles
; Tile graphic 1
.byt $3f, $20, $0, $0, $0, $0, $0, $0
; Tile graphic 2
.byt $3f, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 3
.byt $3f, $1, $0, $0, $0, $0, $0, $0
; Tile graphic 4
.byt $0, $0, $0, $20, $3f, $37, $3f, $1d
; Tile graphic 5
.byt $0, $0, $0, $0, $3f, $1d, $3f, $37
; Tile graphic 6
.byt $0, $0, $0, $1, $3f, $37, $3f, $1d
; Tile graphic 7
.byt $3f, $20, $0, $0, $7, $0, $6, $5
; Tile graphic 8
.byt $3f, $0, $0, $0, $20, $0, $0, $30
; Tile graphic 9
.byt $3f, $1, $18, $24, $24, $34, $18, $14
; Tile graphic 10
.byt $0, $4, $6, $20, $3f, $37, $3f, $1d
; Tile graphic 11
.byt $0, $0, $38, $0, $3f, $1d, $3f, $37
; Tile graphic 12
.byt $34, $2c, $1c, $1, $3f, $37, $3f, $1d
; Tile graphic 13
.byt $3f, $20, $6, $d, $9, $9, $6, $e
; Tile graphic 14
.byt $3f, $0, $0, $0, $3, $0, $3, $2
; Tile graphic 15
.byt $3f, $1, $0, $0, $30, $0, $0, $38
; Tile graphic 16
.byt $b, $f, $f, $20, $3f, $37, $3f, $1d
; Tile graphic 17
.byt $0, $2, $3, $0, $3f, $1d, $3f, $37
; Tile graphic 18
.byt $0, $0, $1c, $1, $3f, $37, $3f, $1d
; Tile graphic 19
.byt $3f, $20, $0, $1, $2, $1, $2, $0
; Tile graphic 20
.byt $3f, $0, $0, $a, $1d, $10, $0, $1e
; Tile graphic 21
.byt $3f, $1, $8, $38, $20, $0, $0, $0
; Tile graphic 22
.byt $7, $18, $0, $20, $3f, $37, $3f, $1d
; Tile graphic 23
.byt $21, $c, $3f, $0, $3f, $1d, $3f, $37
; Tile graphic 24
.byt $38, $6, $0, $1, $3f, $37, $3f, $1d
; Tile graphic 25
.byt $3f, $20, $3, $6, $3, $0, $0, $0
; Tile graphic 26
.byt $3f, $0, $0, $2f, $1f, $0, $0, $0
; Tile graphic 27
.byt $3f, $1, $0, $0, $20, $0, $3, $7
; Tile graphic 28
.byt $0, $0, $0, $20, $3f, $37, $3f, $1d
; Tile graphic 29
.byt $0, $0, $0, $0, $3f, $1d, $3f, $37
; Tile graphic 30
.byt $7, $3, $0, $1, $3f, $37, $3f, $1d
; Tile graphic 31
.byt $3f, $0, $0, $2f, $1f, $0, $1, $3
; Tile graphic 32
.byt $3f, $1, $0, $0, $20, $0, $27, $3f
; Tile graphic 33
.byt $3, $1, $0, $0, $3f, $1d, $3f, $37
; Tile graphic 34
.byt $3f, $27, $0, $1, $3f, $37, $3f, $1d
; Tile graphic 35
.byt $3f, $20, $3, $6, $3, $0, $0, $1
; Tile graphic 36
.byt $3f, $0, $0, $2f, $1f, $0, $33, $3f
; Tile graphic 37
.byt $3f, $1, $0, $0, $20, $0, $23, $3d
; Tile graphic 38
.byt $1, $0, $0, $20, $3f, $37, $3f, $1d
; Tile graphic 39
.byt $3f, $33, $0, $0, $3f, $1d, $3f, $37
; Tile graphic 40
.byt $3e, $23, $0, $1, $3f, $37, $3f, $1d
; Tile graphic 41
.byt $3f, $20, $3, $6, $3, $0, $19, $3f
; Tile graphic 42
.byt $3f, $0, $0, $2f, $1f, $0, $31, $3e
; Tile graphic 43
.byt $3f, $1, $0, $0, $20, $0, $20, $30
; Tile graphic 44
.byt $3f, $19, $0, $20, $3f, $37, $3f, $1d
; Tile graphic 45
.byt $3f, $31, $0, $0, $3f, $1d, $3f, $37
; Tile graphic 46
.byt $10, $20, $0, $1, $3f, $37, $3f, $1d
; Tile graphic 47
.byt $3f, $20, $3, $6, $3, $0, $1c, $3f
; Tile graphic 48
.byt $3f, $0, $0, $2f, $1f, $0, $18, $2c
; Tile graphic 49
.byt $3f, $1, $0, $0, $20, $0, $0, $0
; Tile graphic 50
.byt $3f, $1c, $0, $20, $3f, $37, $3f, $1d
; Tile graphic 51
.byt $34, $18, $0, $0, $3f, $1d, $3f, $37
; Tile graphic 52
.byt $0, $0, $0, $1, $3f, $37, $3f, $1d
; Tile graphic 53
.byt $3f, $20, $3, $6, $3, $0, $c, $36
; Tile graphic 54
.byt $3a, $c, $0, $20, $3f, $37, $3f, $1d
; Tile graphic 55
.byt $3f, $20, $3, $6, $3, $0, $1, $0
; Tile graphic 56
.byt $3f, $0, $0, $2f, $1f, $0, $1e, $0
; Tile graphic 57
.byt $1, $0, $1, $20, $3f, $37, $3f, $1d
; Tile graphic 58
.byt $18, $0, $1e, $0, $3f, $1d, $3f, $37
; Tile graphic 59
.byt $3f, $20, $0, $f, $0, $0, $0, $0
; Tile graphic 60
.byt $3f, $0, $0, $20, $0, $0, $0, $0
; Tile graphic 61
.byt $3f, $1, $0, $0, $0, $0, $0, $0
; Tile graphic 62
.byt $3f, $20, $0, $f, $0, $b, $0, $0
; Tile graphic 63
.byt $3f, $0, $0, $20, $0, $2f, $0, $0
; Tile graphic 64
.byt $3f, $1, $0, $0, $0, $20, $0, $0
; Tile graphic 65
.byt $3f, $20, $0, $f, $0, $b, $0, $f
; Tile graphic 66
.byt $3f, $0, $0, $20, $0, $2f, $0, $1e
; Tile graphic 67
.byt $3f, $1, $0, $0, $0, $20, $0, $38
; Tile graphic 68
.byt $0, $f, $0, $20, $3f, $37, $3f, $1d
; Tile graphic 69
.byt $0, $10, $0, $0, $3f, $1d, $3f, $37
costume_masks
; Tile mask 1
.byt $40, $5f, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 2
.byt $40, $ff, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 3
.byt $40, $7e, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 4
.byt $ff, $ff, $ff, $5f, $40, $40, $40, $40
; Tile mask 5
.byt $ff, $ff, $ff, $ff, $40, $40, $40, $40
; Tile mask 6
.byt $ff, $ff, $ff, $7e, $40, $40, $40, $40
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
res_end
.)



#include "..\scripts\corridor.s"



