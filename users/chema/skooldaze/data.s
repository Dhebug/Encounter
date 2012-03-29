
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; -----------------------------------
;;            Skool Daze
;;         The Oric Version
;; -----------------------------------
;;			(c) Chema 2011
;;         enguita@gmail.com
;; -----------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Data file
;; --------------------



#include "params.h"
#include "script.h"
#include "sound.h"



.zero

; Column and row of tile in visible area coordinates
vis_col .byt 00
tile_row
vis_row .byt 00

; Same but in skool coordinates
tile_col .byt 00

; Backbuffer, just one tile..
backbuffer .dsb 8

; Some game variables


first_col				.byt 0			; Leftmost visible column
lesson_clock			.word 5376		; Lesson clock
current_lesson_index	.byt 0			; Index of the current lesson in the main timetable
current_lesson			.byt PLAYTIME1	; Current lesson from the main timetable
last_char_moved			.byt 0			; Last character we have moved

; Keep the next 6 contiguous!
lesson_status			.byt 0			; Lesson status flags
lesson_signals			.byt 0			; Lesson signal flags
stampede_signals		.byt 0			; Stampede control signals
special_playtime		.byt 0			; Special playtime flags
game_status				.byt 0			; Game status flags
birthyear_ind			.byt 0			; Creak's birth year question indicator

game_mode				.byt 0			; Game mode indicator (0 demo, 1 shields need to be flashed, 2 combination, 3 shields need to be unflashed)
lesson_descriptor		.byt 0			; Indicates who is teaching Eric and where
lines_delay				.byt 0			; Delay between punishments by teachers (used by some routines like teacher_gives_lines).

; Eric's status flags
; 0 ERIC is firing the catapult
; 1 ERIC is hitting 
; 2 ERIC is jumping
; 3 ERIC is being spoken to by little boy no. 10
; 4 ERIC has just been knocked down or unseated
; 5 ERIC is writing on a blackboard 
; 6 Unused (always reset)
; 7 ERIC is sitting or lying down

Eric_flags				.byt 0
Eric_timer				.byt 0
Eric_mid_timer			.byt 0
Eric_knockout			.byt 0

; For the speech bubble
bubble_on				.byt 0		; There is a bubble onscreen
bubble_lip_col			.byt 0		; Column of the bubble lip
bubble_lip_row			.byt 0		; Row of the bubble lip
bubble_col				.byt 0		; Col of the start (upper left corner) of the bubble
bubble_row				.byt 0		; Row of the start (upper left corner) of the bubble
bubble_loc_p			.word 000	; Pointer to the bubble screen position (upper left corner)

cur_speaking_char		.byt 0		; Current speaking character

; Bitmasks for the bubble in the SRB
; This is to protect against corruption
srb_bitmask				.byt 0		; Bitmask for first byte
srb_bitmask2			.byt 0		; Idem for second byte
srb_offset				.byt 0		; Offset of the first byte in the SRB
srb_offset_lip			.byt 0		; Offset of the lip's byte
srb_bitmask_lip			.byt 0		; Bitmask for the lip

#ifndef EINSTEIN_LIES
Einstein_was_hit		.byt 0		; Flag to state if Eric hit Einstein
#endif


; Screen refresh buffer
SRB 
	.byt $3f,$ff,$ff,$ff,$fc
	.byt $3f,$ff,$ff,$ff,$fc
	.byt $3f,$ff,$ff,$ff,$fc
	.byt $3f,$ff,$ff,$ff,$fc
	.byt $3f,$ff,$ff,$ff,$fc
	.byt $3f,$ff,$ff,$ff,$fc
	.byt $3f,$ff,$ff,$ff,$fc
	.byt $3f,$ff,$ff,$ff,$fc
	.byt $3f,$ff,$ff,$ff,$fc
	.byt $3f,$ff,$ff,$ff,$fc
	.byt $3f,$ff,$ff,$ff,$fc
	.byt $3f,$ff,$ff,$ff,$fc
	.byt $3f,$ff,$ff,$ff,$fc
	.byt $3f,$ff,$ff,$ff,$fc
	.byt $3f,$ff,$ff,$ff,$fc
	.byt $3f,$ff,$ff,$ff,$fc
	.byt $3f,$ff,$ff,$ff,$fc
	.byt $3f,$ff,$ff,$ff,$fc
	.byt $3f,$ff,$ff,$ff,$fc
	.byt $3f,$ff,$ff,$ff,$fc
	.byt $3f,$ff,$ff,$ff,$fc


.text

; For the catwalk
table_teacher_order
	.byt 3,0,1,2

; Keymap table
user_keys 
	.byt	 1, 2, 3, 4
	.byt	"A","C","S", "H", "F", "W", "J"
key_routh
    .byt >(up_Eric), >(left_Eric), >(down_Eric), >(right_Eric)
	.byt >(audio_onof),>(change_colors),>(sit_Eric), >(hit_Eric), >(fire_Eric), >(write_Eric)
	.byt >(jump_Eric)
key_routl
	.byt <(up_Eric), <(left_Eric), <(down_Eric), <(right_Eric)
    .byt <(audio_onof),<(change_colors),<(sit_Eric), <(hit_Eric), <(fire_Eric), <(write_Eric)
	.byt <(jump_Eric)

; Used in special playtimes to patch the command list (see change_lesson)
tab_patchcomm
	.byt SC_TELLANGELFACE, SC_TELLEINSTEIN, SC_TELLBOYWANDER

#define LAST_TILE 107

;free_before_rows
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;.dsb 256-(*&255)
; Tile map for background: row 0
skool_r00 ;.dsb SKOOL_COLS,1
	.byt $1,$2,$3,$4,$4,$4,$4,$4,$4,$4,$5,$6,$7,$8,$4,$4,$4,$4,$4,$4,$4,$9,$a,$b,$4,$4,$4,$4,$4,$4,$4,$4,$4,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$2,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$2,$3,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$4,$5,$6,$1,$1,$1,$1,$1,$1,$1,$7,$8,$9,$a,$b,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0


base_as_pointer_high
	.byt >Eric_anim_states,>Einstein_anim_states,>Angelface_anim_states,>BoyWander_anim_states
	.byt >Boy_anim_states,>Boy_anim_states,>Boy_anim_states,>Boy_anim_states,>Boy_anim_states
	.byt >Boy_anim_states,>Boy_anim_states,>Boy_anim_states,>Boy_anim_states,>Boy_anim_states
	.byt >Boy_anim_states,>Creak_anim_states,>Rockitt_anim_states,>Wacker_anim_states,>Withit_anim_states
	.byt >Pellet_anim_states,>Pellet_anim_states
base_as_pointer_low
	.byt <Eric_anim_states,<Einstein_anim_states,<Angelface_anim_states,<BoyWander_anim_states
	.byt <Boy_anim_states,<Boy_anim_states,<Boy_anim_states,<Boy_anim_states,<Boy_anim_states
	.byt <Boy_anim_states,<Boy_anim_states,<Boy_anim_states,<Boy_anim_states,<Boy_anim_states
	.byt <Boy_anim_states,<Creak_anim_states,<Rockitt_anim_states,<Wacker_anim_states,<Withit_anim_states
	.byt <Pellet_anim_states,<Pellet_anim_states

as_pointer_high 
	.byt >Eric_anim_states,>Einstein_anim_states,>Angelface_anim_states,>BoyWander_anim_states
	.byt >Boy_anim_states,>Boy_anim_states,>Boy_anim_states,>Boy_anim_states,>Boy_anim_states
	.byt >Boy_anim_states,>Boy_anim_states,>Boy_anim_states,>Boy_anim_states,>Boy_anim_states
	.byt >Boy_anim_states,>Creak_anim_states,>Rockitt_anim_states,>Wacker_anim_states,>Withit_anim_states
	.byt >Pellet_anim_states,>Pellet_anim_states
as_pointer_low
	.byt <Eric_anim_states,<Einstein_anim_states,<Angelface_anim_states,<BoyWander_anim_states
	.byt <Boy_anim_states,<Boy_anim_states,<Boy_anim_states,<Boy_anim_states,<Boy_anim_states
	.byt <Boy_anim_states,<Boy_anim_states,<Boy_anim_states,<Boy_anim_states,<Boy_anim_states
	.byt <Boy_anim_states,<Creak_anim_states,<Rockitt_anim_states,<Wacker_anim_states,<Withit_anim_states
	.byt <Pellet_anim_states,<Pellet_anim_states

; Table with base pitchs for notes
base_pitch_hi
   .byt $0e,$0e,$0d,$0c,$0b,$0b,$0a,$09,$09,$08,$08,$07

;free_r0
;.dsb (256)-(*&255)-32
; Personal timetable for Eric (same as little boy 11)
per_timet_eric
	.byt 170,170,154,154,176,176,176,136,146,146,146,162,162,162,162,136,136,162,146,196,196,196,176,202,196,196,176,196,196,196,176,196

	;.byt 170,170,160,160,176,176,176,144,152,152,152,168,168,168,168,144,144,168,152,196,212,196,196,196,196,196,196,196,196,196,196,196
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
;.dsb 256-(*&255)
; Tile map for background: row 1
skool_r01 ;.dsb SKOOL_COLS,1
	.byt $c,$c,$c,$c,$1,$2,$3,$4,$4,$4,$d,$e,$f,$10,$11,$a,$12,$4,$4,$4,$4,$13,$14,$f,$15,$16,$4,$4,$4,$4,$4,$4,$4,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$3,$4,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$c,$d,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$e,$f,$10,$11,$12,$1,$1,$1,$1,$1,$13,$14,$15,$16,$16,$17,220,$19,$1a,$1b,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0


anim_state 
	.dsb MAX_CHARACTERS,0
flags
	.dsb MAX_CHARACTERS,0
speed_counter 
	.dsb MAX_CHARACTERS, 4
uni_subcom_low
	.dsb MAX_CHARACTERS,0

; Table with base pitchs for notes
base_pitch_lo
   .byt $ee,$16,$4c,$8e,$d8,$2e,$8e,$f6,$66,$e0,$60,$e8

;free_r1
;.dsb (256-32)-(*&255)
; Personal timetable for Einstein
per_timet_einstein
	.byt 170,170,160,160,176,176,176,144,152,152,152,168,168,168,168,144,144,168,152,196,212,196,196,196,196,196,196,196,196,196,196,196

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;.dsb 256-(*&255)
; Tile map for background: row 2
skool_r02 ;.dsb SKOOL_COLS,1
	.byt $c,$c,$17,$18,$c,$c,$c,$c,$19,$1a,$1b,$1a,$1c,$10,$10,$10,$10,$0,$0,$0,$0,$0,$0,$1c,$10,$10,$1d,$1d,$1e,$1f,$20,$1d,$1e,$5,$6,$7,$8,$5,$6,$7,$8,$5,$6,$7,$8,$5,$6,$7,$8,$5,$6,$7,$8,$5,$9,$a,$8,$5,$6,$0,$8,$5,$6,$b,$8,$5,$6,$c,$8,$5,$6,$0,$8,$5,$1c,$0,$1d,$d,$1e,$1c,$0,$1f,$1e,$1c,$0,$1f,$1e,$1c,$0,$1f,$1e,$1c,$0,$1f,$1e,$1c,$1d,$0,$0,$d,$0,$0,$0,$0,$20,$0,$21,$16,$16,$16,$22,$0,$0,$0,$0,$1d,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0

uni_subcom_high
	.dsb MAX_CHARACTERS,0
i_subcom_low
	.dsb MAX_CHARACTERS,0

i_subcom_high
	.dsb MAX_CHARACTERS,0
cont_subcom_low
	.dsb MAX_CHARACTERS,0

creak_year		; Year of the birth of Mr Creak
	.asc "0000"
	.byt 0
birthyear_id	; Identifier to the question of the year
	.byt 0

free_r2
.dsb (256-32)-(*&255)
; Personal timetable for Angelface
per_timet_angelface
	.byt 174,174,158,158,166,180,180,142,166,150,150,166,166,180,180,142,142,166,150,220,196,196,182,182,182,182,182,182,182,182,182,182

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;.dsb 256-(*&255)
; Tile map for background: row 3
skool_r03 ;.dsb SKOOL_COLS,1
	.byt $c,$c,$21,$22,$23,$24,$c,$25,$26,$27,$28,$29,$1c,$10,$10,$10,$10,$0,$0,$0,$1e,$20,$1f,$1c,$10,$2a,$2b,$2c,$2d,$2e,$2f,$30,$31,$d,$e,$f,$10,$11,$12,$13,$14,$15,$16,$7,$7,$7,$7,$17,$18,$19,$1a,$1b,$e,$1c,$1d,$1e
	;$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1
	.byt LAST_TILE+1,LAST_TILE+2,LAST_TILE+3,LAST_TILE+4,LAST_TILE+5,LAST_TILE+6,LAST_TILE+7,LAST_TILE+8,LAST_TILE+9,LAST_TILE+10,LAST_TILE+11
	.byt $0,$0,$0,$0,$0,$0,$0,$0,$0,$1d,$d,$23,$24,$25,$26,$27,$28,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$1d,$0,$0,$d,$1c,$1e,$1c,$0,$0,$0,$21,$16,$16,$16,$22,$29,$29,$29,$0,$1d,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0

cont_subcom_high
	.dsb MAX_CHARACTERS,0
command_list_high
	.byt >command_list200
	.byt >command_list212
	.byt >command_list220
	.byt >command_list216
	.dsb 11,0
	.byt >command_list214
	.byt >command_list222
	.byt >command_list218
	.dsb 3,0
command_list_low
	.byt <command_list200
	.byt <command_list212
	.byt <command_list220
	.byt <command_list216
	.dsb 11,0
	.byt <command_list214
	.byt <command_list222
	.byt <command_list218
	.dsb 3,0

dest_x
	.dsb MAX_CHARACTERS,0

	; Table for deal_with_Eric, routines
tab_dE_routh
	.byt >listen_Eric, >knock_Eric, >fire_Eric2, >hit_Eric2, >jump_Eric2
tab_dE_routl
	.byt <listen_Eric, <knock_Eric, <fire_Eric2, <hit_Eric2, <jump_Eric2


; For the random routine
randseed 
  .word $dead       ; will it be $dead again? 

;free_r3
;.dsb (256-32)-(*&255)
; Personal timetable for Boy Wander
per_timet_bwander
	.byt 172,172,156,156,178,140,178,156,148,148,148,164,178,178,164,156,140,164,148,196,196,216,192,194,192,192,192,194,194,194,192,194

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;.dsb 256-(*&255)
; Tile map for background: row 4
skool_r04 ;.dsb SKOOL_COLS,1
	.byt $c,$c,$32,$33,$34,$35,$c,$36,$37,$38,$39,$29,$1c,$10,$10,$10,$10,$0,$0,$0,$1e,$20,$1f,$1c,$10,$3a,$26,$3b,$3c,$3d,$3e,$38,$36,$10,$1f,$1f,$20,$21,$22,$23,$23,$23,$24,$7,$7,$7,$7,$25,$26,$27,$1a,$d,$28,$29,$1d,$1e
	;$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1
	.byt LAST_TILE+12,LAST_TILE+13,LAST_TILE+14,LAST_TILE+15,LAST_TILE+16,LAST_TILE+17,LAST_TILE+18,LAST_TILE+19,LAST_TILE+20,LAST_TILE+21,LAST_TILE+22
	.byt $0,$0,$0,$0,$0,$0,$0,$0,$0,$1d,$d,$2a,$2b,$0,$2c,$2d,$2e,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$1d,$0,$0,$d,$1c,$1e,$1c,$0,$0,$0,$21,$16,$16,$16,$22,$29,$29,$29,$0,$1d,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0

dest_y	
	.dsb MAX_CHARACTERS,0
var1		; Byte 103
	.dsb MAX_CHARACTERS,0
var2		; Byte 104
	.dsb MAX_CHARACTERS,0
var3		; Byte 107
	.dsb MAX_CHARACTERS,0

	; Table for deal_with_Eric, flagvalues
tab_dE_flags
	.byt ERIC_SPOKEN, ERIC_DOWN, ERIC_FIRING, ERIC_HITTING, ERIC_JUMPING
	
	; Table for updating the score panel
tab_spanel_add
	.word ($a000+(177*40+34))
	.word ($a000+(185*40+34))
	.word ($a000+(193*40+34))
	
	; To keep count of flashed/unflashed shields
flashed_shields
	.byt 0

;free_r4
;.dsb (256-32)-(*&255)
; Personal timetable for Little boy 1
per_timet_lb1
	.byt 170,170,146,154,176,136,154,146,162,154,146,146,136,146,136,154,146,154,162,196,196,196,198,176,176,202,196,196,204,204,176,196  

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;.dsb 256-(*&255)
; Tile map for background: row 5
skool_r05 ;.dsb SKOOL_COLS,1
	.byt $c,$c,$c,$3f,$40,$c,$41,$42,$43,$44,$45,$45,$1c,$10,$10,$10,$10,$0,$0,$0,$0,$0,$0,$1c,$10,$46,$36,$47,$2e,$48,$29,$36,$36,$d,$2a,$2b,$1d,$2c,$2d,$19,$1a,$2e,$2f,$7,$7,$7,$7,$30,$1f,$f,$31,$1b,$e,$32,$33,$1e,$1,$1,$1,$1,$1,$1,$34,$35,$36,$37,$35,$36,$37,$35,$36,$37,$35,$36,$2f,$30,$31,$32,$33,$34,$0,$0,$35,$36,$37,$30,$31,$37,$30,$31,$37,$30,$31,$37,$30,$31,$37,$30,$38,$39,$0,$0,$0,$0,$0,$0,$21,$16,$16,$16,$22,$3a,$3a,$3a,$3a,$3a,$3a,$3a,$3a,$3a,$3a,$3a,$3a,$3a,$3a,$3b,$3c,$0

var4		; Byte 108
	.dsb MAX_CHARACTERS,0
var5		; Byte 109
	.dsb MAX_CHARACTERS,0
var6		; Byte 110
	.dsb MAX_CHARACTERS,0
var7		; Byte 113
	.dsb MAX_CHARACTERS,0

tab_bboards_low
	.byt <bread_desc, <bwhite_desc, <bexam_desc

tab_bboards_high
	.byt >bread_desc, >bwhite_desc, >bexam_desc

; For utoa
bufconv
	.byt 0,0,0,0,0,0

;free_r5
;.dsb (256-32)-(*&255)
; Personal timetable for little boy 2
per_timet_lb2
	.byt 170,170,146,154,146,136,162,162,146,154,136,136,146,162,154,162,146,154,136,196,196,196,198,198,176,202,196,196,206,206,198,176

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;.dsb 256-(*&255)
; Tile map for background: row 6
skool_r06 ;.dsb SKOOL_COLS,1
	.byt $c,$c,$c,$49,$4a,$4b,$4c,$0,$4d,$4e,$1a,$1a,$1c,$10,$10,$10,$10,$0,$0,$0,$0,$0,$0,$1c,$10,$4f,$50,$50,$50,$50,$50,$50,$50,$38,$38,$38,$38,$38,$38,$38,$38,$38,$39,$7,$7,$7,$7,$3a,$38,$38,$38,$38,$38,$38,$38,$1e,$0,$0,$0,$0,$0,$3b,$3c,$3d,$3e,$3f,$3d,$3e,$3f,$3d,$3e,$3f,$3d,$3e,$3d,$0,$3e,$3f,$0,$0,$0,$0,$0,$0,$40,$18,$41,$40,$18,$41,$40,$18,$41,$40,$18,$41,$42,$0,$43,$44,$0,$0,$0,$0,$0,$0,$21,$16,$16,$16,$22,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$46

var8		; Byte 114
	.dsb MAX_CHARACTERS,0

cur_command_high
	.dsb MAX_CHARACTERS,0
cur_command_low
	.dsb MAX_CHARACTERS,0
pcommand
	.dsb MAX_CHARACTERS,0

bexam_desc
	.word board_exam	; Pointer to board UDGs
	.byt 0				; Column inside tile which is the first one clean
	.byt 0				; Current tile being written
	.byt $ff			; Who last wrote here? $ff=empty
	.byt 55,9			; Tile coordinates of this board
	.byt 0,0,0,0		; Message written
	.byt 0				; Message code

;free_r6
;.dsb (256-32)-(*&255)
; Personal timetable for little boy 3
per_timet_lb3
	.byt 170,170,146,154,146,136,154,146,136,154,162,154,136,154,136,154,136,154,162,196,196,196,198,200,198,202,196,196,206,206,200,196

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;.dsb 256-(*&255)
; Tile map for background: row 7
skool_r07 ;.dsb SKOOL_COLS,1
	.byt $51,$52,$53,$54,$55,$56,$56,$4,$4,$4,$4,$4,$4,$4,$5,$6,$a,$57,$58,$59,$5a,$5a,$5a,$5b,$5c,$5d,$5e,$4,$4,$5f,$6,$60,$61,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$40,$41,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$47,$48,$49,$4a,$1,$1,$4b,$4c,$4d,$4e,$4e,$4e,$4e,$4f,$50,$51,$52,$4a,$53,$54,$54,$54,$55,$55,$55,$55,$55,$55,$55,$55,$56,$56,$56,$57,$58,$59,$5a,$5b

pos_row
	.byt 10,3,3,3,3,3,3,10,10,10,10,10,10,10,17,17,17,17,17,10,17

pos_col
	.byt 4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,38,42,46,255,255

; Tables with base pointers to tiles for characters
tab_tiles
	.dsb 15, >(children_tiles-8)
	.dsb 3,  >(teacher_tiles-8)
	.dsb 1,  >(teacher2_tiles-8)
	.dsb 2,  >(children_tiles-8)
tab_masks
	.dsb 15, >(children_masks-8)
	.dsb 3,  >(teacher_masks-8)
	.dsb 1,  >(teacher2_masks-8)
	.dsb 2,  >(children_masks-8)

bwhite_desc
	.word board_white	; Pointer to board UDGs
	.byt 0				; Column inside tile which is the first one clean
	.byt 0				; Current tile being written
	.byt $ff			; Who last wrote here? $ff=empty
	.byt 34,9			; Tile coordinates of this board
	.byt 0,0,0,0		; Message written
	.byt 0				; Message code

;free_r7
;.dsb (256-32)-(*&255)
; Personal timetable for little boy 4
per_timet_lb4
	.byt 170,170,146,162,146,146,154,162,154,162,154,146,146,136,136,162,146,154,136,196,196,196,200,176,198,198,200,196,206,206,202,198

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;.dsb 256-(*&255)
; Tile map for background: row 8
skool_r08 ;.dsb SKOOL_COLS,1
	.byt $62,$63,$64,$64,$65,$65,$65,$65,$1d,$1d,$1d,$1d,$1d,$1d,$66,$10,$10,$10,$10,$67,$68,$69,$0,$0,$0,$0,$0,$0,$0,$6a,$6b,$6c,$10,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,106,107,$0,$0,$0,$42,$43,$0,$0,$0,$0,$0,$0,$44,$0,$0,$0,$0,$0,$65,$0,$0,$0,$0,$0,$69,$0,$0,$0,$0,$0,218,$0,$0,$0,$0,$0,$5c,$0,$0,$0,$0,$1d,$0,$0,$5d,$0,$0,$0,$0,$0,$0,$0,$0,$5e,$5f,$60,$0,$0,$61,$62,$1e,$1e,$1e,$1e,$1e,$1e,$1e,$1e,$1e,$60,$d,$63,$63,$63,$63,$0,$0,$0,$61

; Tables with offsets for animatory states when moving left to right or viceversa
tab_offset_invl
	.dsb 15, <(Inverted_anim_states-Eric_anim_states)
	.dsb 3,  <(t1_inverted_anim_states-Creak_anim_states)
	.dsb 1,  <(t2_inverted_anim_states-Withit_anim_states)
	.dsb 2,  <(Inverted_anim_states-Eric_anim_states)
tab_offset_invh
	.dsb 15, >(Inverted_anim_states-Eric_anim_states)
	.dsb 3,  >(t1_inverted_anim_states-Creak_anim_states)
	.dsb 1,  >(t2_inverted_anim_states-Withit_anim_states)
	.dsb 2,  >(Inverted_anim_states-Eric_anim_states)

ini_pos_col
	.byt 64,94,94,34,57,58,59,60,61,62,63,64,65,66,67,13,13,13,13,OFFSCREEN_POS,OFFSCREEN_POS
ini_flags
	.byt IS_FACING_RIGHT,IS_FACING_RIGHT,IS_FACING_RIGHT,IS_FACING_RIGHT
	.byt 0,IS_FACING_RIGHT,0,IS_FACING_RIGHT,0,IS_FACING_RIGHT,0,IS_FACING_RIGHT,0,IS_FACING_RIGHT,0
	.byt IS_TEACHER|IS_SLOW_WALK,IS_TEACHER|IS_SLOW_WALK,IS_TEACHER|IS_SLOW_WALK,IS_TEACHER|IS_SLOW_WALK
	.byt IS_FAST_WALK,IS_FAST_WALK

bread_desc
	.word board_read	; Pointer to board UDGs
	.byt 0				; Column inside tile which is the first one clean
	.byt 0				; Current tile being written
	.byt $ff			; Who last wrote here? $ff=empty
	.byt 56,3			; Tile coordinates of this board
	.byt 0,0,0,0		; Message written
	.byt 0				; Message code
;free_r8
;.dsb (256-32)-(*&255)
; Personal timetable for little boy 5
per_timet_lb5
	.byt 170,170,146,162,162,176,162,146,136,146,162,136,154,146,162,154,162,154,162,196,196,196,200,198,202,200,200,196,206,206,176,200
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;.dsb 256-(*&255)
; Tile map for background: row 9
skool_r09 ;.dsb SKOOL_COLS,1
	.byt $62,$6d,$6e,$6f,$1e,$1f,$62,$65,$1d,$1e,$20,$1f,$20,$70,$71,$1e,$1c,$10,$10,$10,$72,$68,$73,$0,$0,$0,$1e,$20,$1f,$20,$0,$1c,$10,$0
	;$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1
	.byt LAST_TILE+23,LAST_TILE+24,LAST_TILE+25,LAST_TILE+26,LAST_TILE+27,LAST_TILE+28,LAST_TILE+29,LAST_TILE+30,LAST_TILE+31,LAST_TILE+32,LAST_TILE+33
	.byt $0,$0,$0,$0,$0,$0,$0,$0,$42,$43
	;$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1
	.byt LAST_TILE+45,LAST_TILE+46,LAST_TILE+47,LAST_TILE+48,LAST_TILE+49,LAST_TILE+50,LAST_TILE+51,LAST_TILE+52,LAST_TILE+53,LAST_TILE+54,LAST_TILE+55
	.byt $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$1d,$0,$64,$0,$1f,$1e,$1f,$1e,$1d,$0,$0,$65,$5f,$60,$0,$0,$0,$61,$66,$66,$66,$66,$66,$66,$1d,$0,$0,$0,$67,$d,$63,$63,$63,$63,$0,$0,$0,$61

compp 
	.dsb MAX_CHARACTERS,0
_Tune2DataA
;	.byt 3*12+C_, 3*12+C_, 3*12+C_, 3*12+D_, 3*12+E_, 3*12+D_, 3*12+C_, 3*12+E_, 3*12+D_, 3*12+D_, 3*12+C_, RST, $80 
	.byt 4*12+G_, 4*12+G_, 4*12+G_, 4*12+A_, 4*12+B_, 4*12+B_, 4*12+A_, 4*12+A_ 
	.byt 4*12+G_, 4*12+B_, 4*12+A_, 4*12+A_, 4*12+G_, 4*12+G_, 4*12+G_, RST, $80
_Tune2DataB
	;.byt 5*12+F_, 5*12+F_, 5*12+F_, 5*12+G_, 5*12+A_, 5*12+G_, 5*12+F_, 5*12+A_, 5*12+G_, 5*12+G_, 5*12+F_, RST
	.byt 3*12+G_, 3*12+D_, 3*12+B_, 3*12+D_, 3*12+G_, 3*12+D_, 3*12+C_, 3*12+D_
	.byt 3*12+B_, 3*12+D_, 3*12+C_, 3*12+D_, 3*12+G_, 3*12+D_, 3*12+G_, RST

zeros
	.byt 0,0,0,0,0,0,0,%01111000,0,0,0,0,0,0
/*
Bell1
	.byt $35,0,$2e,0,0,0,0,%1111100,$10,$10,0,$70,$01,$8*/
Bell2
	.byt $35,0,$2e,0,0,0,0,%1111100,$10,$10,0,0,$04+2,0
_safeletter
	.byt 0,4,0,0,0,0,$ff,$78,10,0,0,2,0,$e

free_r9
.dsb (256-32)-(*&255)
; Personal timetable for little boy 6
per_timet_lb6
	.byt 170,170,154,162,162,146,162,162,154,162,154,154,136,162,146,154,162,154,136,196,196,196,200,202,200,198,202,196,206,206,198,202

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;.dsb 256-(*&255)
; Tile map for background: row 10
skool_r10 ;.dsb SKOOL_COLS,1
	.byt $62,$74,$50,$75,$1e,$1f,$62,$65,$1d,$1e,$20,$1f,$20,$1d,$1d,$1e,$1c,$10,$10,$10,$76,$77,$68,$78,$79,$0,$1e,$20,$1f,$20,$0,$1c,$10,$0
	;$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1
	.byt LAST_TILE+34,LAST_TILE+35,LAST_TILE+36,LAST_TILE+37,LAST_TILE+38,LAST_TILE+39,LAST_TILE+40,LAST_TILE+41,LAST_TILE+42,LAST_TILE+43,LAST_TILE+44
	.byt $0,$0,$0,$0,0,0,$0,$0,$42,$43
	;$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1
	.byt LAST_TILE+56,LAST_TILE+57,LAST_TILE+58,LAST_TILE+59,LAST_TILE+60,LAST_TILE+61,LAST_TILE+62,LAST_TILE+63,LAST_TILE+64,LAST_TILE+65,LAST_TILE+66
	.byt $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$1d,$0,$1d,$0,$1f,$1e,$1f,$1e,$1d,$68,$69,$5f,$60,$1d,$0,$0,$0,$61,$0,$6a,$0,$0,$0,$6a,$1d,$0,$0,$0,$63,$d,$63,$63,$63,$63,$0,$0,$0,$61

; Music tune data

_TuneDataA
	.byt 5*12+E_,RST,5*12+C_,5*12+D_,5*12+D_,4*12+B_
	.byt 5*12+E_,RST,5*12+C_,4*12+A_,RST
	.byt 4*12+A_,4*12+B_,4*12+B_,5*12+C_,5*12+D_,5*12+C_
	.byt 4*12+B_,5*12+E_,RST
	.byt 5*12+C_,4*12+A_,RST,RST,4*12+B_,4*12+B_,4*12+G_,4*12+A_,4*12+A_,4*12+F_,4*12+B_,4*12+B_,4*12+G_,4*12+E_,0,4*12+E_,4*12+F_,4*12+F_,4*12+G_,4*12+A_
	.byt 4*12+G_,4*12+F_,4*12+B_,RST,4*12+G_,4*12+E_,RST,$80	;,RST,RST
_TuneDataAEnd
_TuneDataB
	.byt 3*12+A_,3*12+C_,3*12+E_,3*12+G_,3*12+B_
	.byt 3*12+E_,3*12+A_,3*12+C_,3*12+E_,3*12+A_,3*12+C_
	.byt 3*12+E_,3*12+G_,3*12+B_,3*12+E_,3*12+G_,3*12+B_
	.byt 3*12+E_,3*12+A_,3*12+C_,3*12+E_,3*12+A_,3*12+C_
	.byt 3*12+E_,3*12+E_,3*12+G_,3*12+B_,3*12+F_,3*12+A_,3*12+B_
	.byt 3*12+E_,3*12+G_,3*12+B_, 3*12+E_,3*12+G_,3*12+C_
	.byt 3*12+F_,3*12+A_,3*12+B_,3*12+F_,3*12+A_,3*12+B_
	.byt 3*12+E_,3*12+G_,3*12+B_,3*12+E_,RST		;,3*12+G_,3*12+B_
_TuneDataBEnd

#ifdef 0
_TuneData
	.byt 5*12+E_,3*12+A_,RST,3*12+C_,5*12+C_,3*12+E_,5*12+D_,3*12+G_,5*12+D_,3*12+B_
    .byt 4*12+B_,3*12+E_,5*12+E_,3*12+A_,RST,3*12+C_,5*12+C_,3*12+E_,4*12+A_,3*12+A_
	.byt RST,3*12+C_,4*12+A_,3*12+E_,4*12+B_,3*12+G_,4*12+B_,3*12+B_,5*12+C_,3*12+E_
	.byt 5*12+D_,3*12+G_,5*12+C_,3*12+B_,4*12+B_,3*12+E_,5*12+E_,3*12+A_,RST,3*12+C_
	.byt 5*12+C_,3*12+E_,4*12+A_,3*12+A_,RST,3*12+C_,RST,3*12+E_,4*12+B_,3*12+E_,4*12+B_,3*12+G_
	.byt 4*12+G_,3*12+B_,4*12+A_,3*12+F_,4*12+A_,3*12+A_,4*12+F_,3*12+B_,4*12+B_,3*12+E_,4*12+B_,3*12+G_
	.byt 4*12+G_,3*12+B_,4*12+E_,3*12+E_,RST,3*12+G_,4*12+E_,3*12+C_,4*12+F_,3*12+F_,4*12+F_,3*12+A_,4*12+G_,3*12+B_
	.byt 4*12+A_,3*12+F_,4*12+G_,3*12+A_,4*12+F_,3*12+B_,4*12+B_,3*12+E_,RST,3*12+G_,4*12+G_,3*12+B_,4*12+E_,3*12+E_
	.byt RST,RST,$80
_TuneDataEnd
#endif

free_r10
.dsb (256-32)-(*&255)
; Personal timetable for little boy 7
per_timet_lb7
	.byt 170,170,154,162,154,146,154,154,146,162,136,146,162,154,136,146,162,154,162,196,196,196,202,176,200,200,202,196,206,206,200,176


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;.dsb 256-(*&255)
; Tile map for background: row 11
skool_r11 ;.dsb SKOOL_COLS,1
	.byt $7a,$7b,$7c,$7d,$7e,$7f,$80,$81,$1d,$82,$50,$50,$50,$83,$84,$1d,$1c,$10,$10,$10,$76,$0,$77,$68,$85,$86,$0,$0,$0,$0,$0,$1c,$10,$0,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$45,$0,$46,$45,$0,$46,$45,$0,$42,$43,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$0,$46,$45,$0,$46,$45,$0,$0,$0,$6b,$6c,$0,$6b,$6c,$0,$6b,$6c,$0,$6b,$6c,$0,$6b,$6c,$0,$1d,$0,$1d,$0,$0,$0,$0,$0,$6d,$6e,$5f,$60,$0,$1d,$0,$0,$0,$61,$6f,$70,$6f,$6f,$6f,$71,$1d,$0,$0,$0,$63,$d,$63,$63,$63,$63,$0,$0,$0,$61
; Tables with information of shields

tab_ptablesidx
	.byt 2-1
	.byt 8-1
	.byt 14-1
tab_ptablesh
	.byt >tab_sh_info_r2
	.byt >tab_sh_info_r8
	.byt >tab_sh_info_r14
tab_ptablesl
	.byt <tab_sh_info_r2
	.byt <tab_sh_info_r8
	.byt <tab_sh_info_r14


; First byte is column, second is ID (index in the following tables)
tab_sh_info_r2
	.byt 8-1,0
	.byt 10-1,1
	.byt 63-1,2
	.byt 67-1,3
	.byt 104-1,4
tab_sh_info_r8
	.byt 61-1,5
	.byt 67-1,6
	.byt 73-1,7
	.byt 79-1,8
	.byt 85-1,9
tab_sh_info_r14
	.byt 35-1,10
	.byt 38-1,11
	.byt 41-1,12
	.byt 87-1,13
	.byt 90-1,14

; Table with shield status 0=not inverted, $ff=inverted
tab_sh_status
	.dsb 15,0
; Tables with pointers to UDGs
tab_sh_udgh
	.byt >(udg_skool+24*8), >(udg_skool+26*8), >(udg_skool2+10*8), > (udg_skool2+11*8)
	.byt >(udg_skool3+31*8), >(udg_skool2+67*8), >(udg_skool2+100*8), >(udg_skool2+104*8)
	.byt >(udg_skool3+217*8), >(udg_skool3+91*8), >(udg_skool2+101*8), >(udg_skool2+102*8)
	.byt >(udg_skool2+103*8), >(udg_skool3+134*8), >(udg_skool3+218*8)
	
tab_sh_udgl
	.byt <(udg_skool+24*8), <(udg_skool+26*8), <(udg_skool2+10*8), < (udg_skool2+11*8)
	.byt <(udg_skool3+31*8), <(udg_skool2+67*8), <(udg_skool2+100*8), <(udg_skool2+104*8)
	.byt <(udg_skool3+217*8), <(udg_skool3+91*8), <(udg_skool2+101*8), <(udg_skool2+102*8)
	.byt <(udg_skool2+103*8), <(udg_skool3+134*8), <(udg_skool3+218*8)

; Tables for color combinations
color_combination1
	.byt A_BGCYAN, A_BGCYAN, A_BGWHITE
color_combination2
	.byt A_BGYELLOW, A_BGGREEN, A_BGWHITE
cur_comb .byt 0

free_r11
.dsb (256-32)-(*&255)
; Personal timetable for little boy 8
per_timet_lb8
	.byt 170,170,154,162,154,146,162,146,154,136,154,136,146,136,146,154,146,154,136,196,196,196,202,198,202,176,198,196,206,206,202,198

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;.dsb 256-(*&255)
; Tile map for background: row 12
skool_r12 ;.dsb SKOOL_COLS,1
	.byt $87,$88,$89,$8a,$8b,$8c,$8d,$8e,$8f,$90,$91,$91,$91,$92,$93,$94,$1c,$10,$10,$10,$76,$0,$0,$77,$68,$95,$0,$0,$0,$0,$0,$1c,$10,$0,$0,$0,$0,$0,$47,$48,$49,$47,$48,$49,$47,$48,$49,$47,$48,$49,$47,$48,$49,$42,$43,$0,$0,$0,$47,$48,$49,$47,$48,$49,$47,$48,$49,$47,$48,$49,$47,$48,$49,$4a,$0,$72,$73,$74,$72,$73,$74,$72,$73,$74,$72,$73,$74,$72,$73,$74,$75,$0,$1d,$0,$0,$0,$0,$0,$76,$5f,$60,$0,$0,$1d,$0,$0,$0,$61,$6f,$70,$6f,$6f,$6f,$71,$1d,$0,$0,$0,$63,$d,$63,$77,$77,$63,$0,$0,$0,$61

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Tables for questions and answers...
; see script.s s_prepare_question
; the first 4 tables (16 bytes)
; must be contiguous.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
creak_table
	.byt 5,2
	.byt 6,3
rockitt_table
	.byt 1,1
	.byt 2,1
p_question
	.dsb 2
p_answer
	.dsb 2
withit_table
	.byt 3,1
	.byt 4,1

; This table is also 16 bytes...
qa_tables
	.byt <st_battles
	.byt >st_battles
	.byt <st_years
	.byt >st_years
	.byt <st_chemical_sym
	.byt >st_chemical_sym
	.byt <st_chemical_name
	.byt >st_chemical_name
	.byt 0,0,0,0
	.byt <st_countries
	.byt >st_countries
	.byt <st_capitals
	.byt >st_capitals


; Table for calculating the number of lines
; to give.
tab_lines
	.byt 10,20,30,40,50,60,70,80,90

; Table with the identifiers of messages to
; tell the children to sit down
tab_sit_msg
	.byt SIT_NASTY, SIT_CHERUBS, SIT_CANE, SIT_CHAPS


; Table to relate teacher codes and identifiers. Used in s_do_class and teacher_gives_lines
table_teacher_codes
	.byt CHAR_ROCKITT, CHAR_WACKER, CHAR_WITHIT, CHAR_CREAK, 0


; Skool region data tables
rgn_topfloor_walls
	.byt 11
	.byt 22
	.byt 54
	.byt 76
	.byt 99
	.byt 130
rgn_topfloor_ids
	.byt 0	; Head's study
	.byt 7	; Between the study and the Revision Library
	.byt 5	; Revision library
	.byt 1	; Reading room
	.byt 2	; Map room
	.byt 7	; Map room door to the fire escape

rgn_midfloor_walls
	.byt 14
	.byt 30
	.byt 51
	.byt 94-3
	.byt 130
rgn_midfloor_ids
	.byt 0	; Forbidden region
	.byt 7	; Between the staff room and the white room
	.byt 3	; White room
	.byt 4	; Exam room
	.byt 7	; Outside the Exam room door
rgn_botfloor_walls
	.byt 46
	.byt 68
	.byt 130
rgn_botfloor_ids
	.byt 7	; Left of the dinner hall
	.byt 6	; Dinner hall
	.byt 7	; Right of the dinner hall
tab_regionshi
	.byt >rgn_topfloor_walls, >rgn_midfloor_walls, >rgn_botfloor_walls
tab_regionslo
	.byt <rgn_topfloor_walls, <rgn_midfloor_walls, <rgn_botfloor_walls
tab_ridshi
	.byt >rgn_topfloor_ids, >rgn_midfloor_ids, >rgn_botfloor_ids
tab_ridslo
	.byt <rgn_topfloor_ids, <rgn_midfloor_ids, <rgn_botfloor_ids

score					.word 0			; Current score
lines					.word 0			; Number of lines
hiscore					.word 0			; Highest score

;free_r12
;.dsb (256-32)-(*&255)

; Personal timetable for little boy 9
per_timet_lb9
	.byt 170,170,154,154,154,136,162,154,136,136,162,154,154,146,154,146,146,154,136,196,196,196,202,200,196,176,198,196,206,206,176,200


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;.dsb 256-(*&255)
; Tile map for background: row 13
skool_r13 ;.dsb SKOOL_COLS,1
	.byt $96,$97,$98,$99,$9a,$9b,$9c,$9d,$9e,$4,$4,$4,$4,$9f,$a0,$a1,$a2,$a3,$a4,$a5,$a6,$a7,$a8,$a9,$aa,$4,$4,$4,$4,$4,$4,$ab,$ac,$1,$1,$1,$1,$1,$4b,$4c,$4d,$4b,$4c,$4d,$4b,$4c,$4d,$4b,$4c,$4d,$4b,$4c,$4d,$4e,$4f,$1,$1,$1,$4b,$4c,$4d,$4b,$4c,$4d,$4b,$4c,$4d,$4b,$4c,$4d,$4b,$4c,$4d,$50,$1,$78,$79,$7a,$78,$79,$7a,$78,$79,$7a,$78,$79,$7a,$78,$79,$7a,$7b,$7c,$1,$1,$1,$1,$1,$1,$1,$7d,$7e,$7f,$80,$81,$82,$83,$84,$5d,$6f,$70,$6f,$6f,$6f,$71,$1d,$0,$0,$0,$63,$d,$85,$77,$77,$86,$0,$0,$0,$61
charset_col1
	.byt 000,250,192,040,018,078,108,064,124,130,016,008,001,008,003,007  
	.byt 124,066,070,130,056,242,124,128,108,098,054,049,008,020,034,064  
	.byt 076,126,254,124,254,254,254,126,254,130,004,254,254,254,254,124  
	.byt 254,124,254,098,128,252,224,252,198,192,134,255,192,129,032,001  
	.byt 002,028,254,028,028,028,016,024,254,094,001,254,254,062,062,028  
	.byt 063,024,062,018,016,060,056,056,034,056,038,024,255,129,008,124 
free_r13
.dsb (256-32)-(*&255)
; Personal timetable for little boy 10
per_timet_lb10
	.byt 170,170,154,154,154,136,176,154,162,136,136,146,154,154,146,154,162,154,162,210,208,208,176,200,196,196,176,196,206,206,176,202

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;.dsb 256-(*&255)
; Tile map for background: row 14
skool_r14 ;.dsb SKOOL_COLS,1
	.byt $ad,$0,$ae,$ad,$0,$ae,$ad,$af,$0,$0,$0,$0,$0,$0,$0,$0,$ad,$0
	;;.byt $77,$68,
	.byt 211,212,$b0,$b1,$b2,$b3,$0,$0,$0,$0,$0,$1c,$10,$10,$10,$0,$0,$66,$0,$0,$67,$0,$0,$68,$0,$1e,$51,$51,$51,$52,$52,$53,$54,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$1d,$0,$0,$0,$1d,$0,$87,$0,$0,219,$0,$1d,$0,$0,$0,$1d,$0,$0,$0,$88,$89,$8a,$8b
	;.byt $8c,$60,
	.byt $8c,222,$0,$61,$6f,$70,$6f,$6f,$6f,$71,$1d,$0,$0,$0,$63,$d,$8d,$8e,$8f,$77,$0,$0,$0,$61
charset_col2
	.byt 000,000,000,254,042,016,146,128,130,124,124,008,002,008,003,056  
	.byt 138,254,138,146,072,146,146,134,146,146,054,050,020,020,020,138  
	.byt 082,144,146,130,130,146,144,130,016,254,002,016,002,064,096,130  
	.byt 144,130,144,146,128,002,028,002,040,032,138,129,056,255,064,001  
	.byt 126,034,034,034,034,042,126,037,032,000,001,016,000,032,016,034  
	.byt 036,036,016,042,126,002,006,006,020,005,042,102,000,102,016,146 
free_r14
.dsb (256-32)-(*&255)
; Personal timetable for little boy 11
per_timet_lb11
	.byt 170,170,154,154,176,176,176,136,146,146,146,162,162,162,162,136,136,162,146,196,196,196,176,202,196,196,176,196,206,206,176,196

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;.dsb 256-(*&255)
; Tile map for background: row 15
skool_r15 ;.dsb SKOOL_COLS,1
	.byt $ad,$0,$b4,$b5,$b6,$b7,$b8,$b9,$0,$0,$0,$0,$0,$0,$0,$0,$ad,$0,$0
	;.byt $77,$68,
	.byt 211,212,$b0,$b1,$b2,$b3,$0,$0,$0,$0,$ba,$bb,$1c,$10,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$1e,$51,$51,$51,$52,$55,$56,$1,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$1d,$0,$0,$0,$1d,$0,$0,$0,$0,$0,$0,$1d,$0,$90,$0,$1d,$0,$0,$88,$91,$92,$93
	;.byt $5f,$60,
	.byt 221,222,$0,$0,$61,$6f,$70,$6f,$6f,$6f,$71,$1d,$0,$0,$0,$63,$d,$94,$95,$96,$77,$0,$0,$0,$61
charset_col3
	.byt 000,000,192,040,127,228,146,000,000,000,056,062,000,008,000,192  
	.byt 146,002,146,178,254,146,146,152,146,146,000,000,020,020,020,144  
	.byt 094,144,146,130,130,146,144,138,016,130,002,040,002,048,024,130  
	.byt 144,134,152,146,254,002,002,028,016,030,146,000,003,000,191,001  
	.byt 146,034,034,034,034,042,144,037,032,000,094,040,000,030,032,034  
	.byt 036,036,032,042,016,002,056,056,008,005,050,129,000,024,008,170 
free_r15
.dsb (256-32)-(*&255)
; Personal timetable for Mr Creak
per_timet_creak
	.byt 188,188,188,134,134,130,188,130,134,134,130,134,130,130,130,134,134,188,130,190,190,190,188,188,188,188,188,188,196,196,188,188

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;.dsb 256-(*&255)
; Tile map for background: row 16
skool_r16 ;.dsb SKOOL_COLS,1
	.byt $bc,$bd,$be,$ad,$0,$ae,$ad,$af,$0,$0,$0,$0,$0,$0,$0,$0,$ad,$0,$0,$0
	;.byt $77,$68,
	.byt 211,212,$b0,$b1,$b2,$b3,$0,$0,$0,$0,$0,$1c,$10,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$1e,$51,$51,$57,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$97,$59,$59,$98,$1,$99,$1,$9a,$9b,$0,$0,$1d,$0,$0,$0,$0,$0,$0,$1d,$0,$9c,$9d,$9e,$0,$88,$91,$92,$93
	;.byt $5f,$60,
	.byt 221,222,$0,$0,$0,$61,$6f,$70,$6f,$6f,$6f,$71,$9f,$a0,$a1,$0,$63,$d,$a2,$a3,$a4,$a5,$0,$0,$0,$61

charset_col4
	.byt 000,000,000,254,042,000,109,000,000,000,124,008,000,008,000,000  
	.byt 124,000,098,204,008,140,140,224,108,124,000,000,034,020,008,096  
	.byt 066,126,108,130,124,130,128,078,254,000,252,198,002,064,254,124  
	.byt 096,124,102,140,128,252,028,002,040,032,162,000,000,000,064,001  
	.byt 130,062,028,034,254,024,064,062,030,000,000,006,000,032,030,028  
	.byt 024,063,016,036,000,062,000,006,020,062,034,000,000,000,016,130 


free_r16
.dsb (256-32)-(*&255)
; Personal timetable for Mr Rockitt
per_timet_rockitt
	.byt 188,188,196,132,132,188,134,134,132,130,132,132,132,132,134,130,130,134,134,222,190,190,190,188,196,188,196,196,196,196,188,196

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;.dsb 256-(*&255)
; Tile map for background: row 17
skool_r17 ;.dsb SKOOL_COLS,1
	.byt $ad,$0,$ae,$ad,$0,$bf,$c0,$c1,$0,$0,$0,$0,$0,$0,$0,$0,$ad,$0,$0,$0,$0
	;.byt $77,$68,
	.byt 211,212,$b0,$b1,$b2,$b3,$0,$0,$0,$0,$1c,$10,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$1e,$58,$59,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$a6,$0,$0,$a7,$a8,$a9,$aa,$1,$ab,$ac,$0,$1d,$0,$0,$0,$0,$0,$0,$1d,$0,$1d,$0,$0,$88,$91,$92,$93
	;.byt $5f,$60,
	.byt 221,222,$0,$0,$0,$0,$61,$ad,$ae,$ad,$ad,$ad,$af,$b0,$b1,$b2,$0,$63,$d,$1d,$b3,$b4,$b5,$b6,$0,$0,$61

charset_col5
	.byt 000,000,000,040,036,000,002,000,000,000,016,008,000,000,000,000  
	.byt 000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000  
	.byt 060,000,000,000,000,000,000,000,000,000,000,000,000,254,000,000  
	.byt 000,002,000,000,128,000,224,252,198,192,194,000,000,000,032,001  
	.byt 000,000,000,000,000,000,000,000,000,000,000,000,000,030,000,000  
	.byt 000,000,000,000,000,000,000,056,034,000,000,000,000,000,000,124 

free_r17
.dsb (256-32)-(*&255)
; Personal timetable for Mr Wacker
per_timet_wacker
	.byt 186,184,132,190,130,190,190,132,130,132,134,130,134,128,132,128,190,132,190,190,214,218,190,186,190,190,190,190,190,196,188,190

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;.dsb 256-(*&255)
; Tile map for background: row 18
skool_r18 ;.dsb SKOOL_COLS,1
	.byt $c2,$c3,$c4,$c5,$c6,$c7,$ad,$af,$0,$0,$0,$0,$0,$0,$0,$0,$ad,$0,$0,$0,$0,$0
	;.byt $77,$68,
	.byt 211,212,$b0,$b1,$b2,$b3,$0,$0,$0,$1c,$10,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$5a,$5b,$1,$1,$1,$5c,$5d,$5d,$5d,$5d,$5d,$5d,$5d,$5d,$5d,$5d,$5d,$5d,$5d,$5d,$5d,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$b7,$b8,$18,$18,$b9,$0,$ba,$1,$1,$bb,$bc,$1d,$0,$0,$0,$0,$0,$0,$1d,$0,$1d,$0,$88,$91,$92,$93
	;.byt $5f,$60,
	.byt 221,222,$0,$0,$0,$0,$0,$61,$1,$bd,$1,$1,$1,$be,$bf,$c0,$c1,$c2,$c3,$d,$1d,$0,$0,$c4,$0,$0,$0,$61

;;;;;;;;; Character widths
char_widths
	.byt 003,001,003,005,005,003,005,002,002,002,005,005,002,004,002,003  
	.byt 004,003,004,004,004,004,004,004,004,004,002,002,004,004,004,004  
	.byt 005,004,004,004,004,004,004,004,004,003,004,004,004,005,004,004  
	.byt 004,005,004,004,005,004,005,005,005,005,005,002,003,002,005,005  
	.byt 004,004,004,004,004,004,004,004,004,001,003,004,001,005,004,004  
	.byt 004,004,004,004,003,004,003,005,005,004,004,003,001,003,004,005  

free_r18
.dsb (256-32)-(*&255)
; Personal timetable for Mr Withit
per_timet_withit
	.byt 184,198,130,190,202,128,132,128,128,128,128,128,128,134,128,132,128,196,128,190,190,190,190,188,188,196,188,188,196,196,188,188

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;.dsb 256-(*&255)
; Tile map for background: row 19
skool_r19 ;.dsb SKOOL_COLS,1
	.byt $ad,$0,$ae,$ad,$c8,$c9,$ca,$cb,$4,$4,$4,$4,$4,$4,$4,$4,$ad,$0,$0,$0,$0,$0,$0
	;.byt $77,$68,
	.byt 211,212,$cc,$cd,$ce,$4,$4,$4,$ab,$ac,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$5e,$5f,$5f,$5f,$5f,$60,$5f,$5f,$5f,$5f,$60,$5f,$5f,$5f,$61,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$c5,$c6,$c6,$c7,$c8,$c9,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$ca,$cb,$1,$1,$cc,$cd,$ce
	;.byt $5f,$60,
	.byt 221,222,$0,$0,$0,$0,$0,$0,$61,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$cf,$d0,$d1,$d2,$0,$0,$0,$61


;;;;;;;;;; Command token table (see script.h)
command_high
	.byt >s_end					; SC_END
	.byt >s_goto				; SC_GOTO
	.byt >s_restart_nolesson    ; SC_RESTIFNOLESSON
	.byt >s_flag_event		 	; SC_FLAGEVENT
	.byt >s_msg_sitdown			; SC_MSGSITDOWN
	.byt >s_do_class			; SC_DOCLASS
	.byt >s_move_until			; SC_MOVEUNTIL
	.byt >s_find_seat			; SC_FINDSEAT
	.byt >s_set_csubcom			; SC_SETCONTSUB
	.byt >s_ctrl_einstein1		; SC_CTRLEINSTEINCL1
	.byt >s_ctrl_einstein2		; SC_CTRLEINSTEINCL2
	.byt >s_write_bl			; SC_WRITEBLCKBOARD
	.byt >s_write_bl_c			; SC_WRITEBLCKBOARDC
	.byt >s_walk_updown			; SC_WALKUPDOWN
	.byt >s_restart				; SC_RESTARTLIST
	.byt >s_restart_nodinner	; SC_RESTIFNODINNER
	.byt >s_dinner_duty			; SC_DINNERDUTY
	.byt >s_unflag_event		; SC_UNFLAGEVENT
	.byt >s_goto_random			; SC_GOTORANDOM
	.byt >s_goto_random_trip	; SC_GOTORANDOMTRIP	
	.byt >s_follow_boy1			; SC_FOLLOWBOY1TRIP
	.byt >s_find_eric			; SC_FINDERIC			
	.byt >s_tell_einstein		; SC_TELLEINSTEIN
	.byt >s_tell_angelface		; SC_TELLANGELFACE
	.byt >s_tell_boywander		; SC_TELLBOYWANDER
	.byt >s_2000lines_eric		; SC_2000LINESERIC
	.byt >s_end_game			; SC_ENDGAME

command_low
	.byt <s_end					; SC_NOP
	.byt <s_goto				; SC_GOTO
	.byt <s_restart_nolesson    ; SC_RESTIFNOLESSON
	.byt <s_flag_event			; SC_FLAGEVENT
	.byt <s_msg_sitdown			; SC_MSGSITDOWN
	.byt <s_do_class			; SC_DOCLASS
	.byt <s_move_until			; SC_MOVEUNTIL
	.byt <s_find_seat			; SC_FINDSEAT
	.byt <s_set_csubcom			; SC_SETCONTSUB
	.byt <s_ctrl_einstein1		; SC_CTRLEINSTEINCL1
	.byt <s_ctrl_einstein2		; SC_CTRLEINSTEINCL2
	.byt <s_write_bl			; SC_WRITEBLCKBOARD
	.byt <s_write_bl_c			; SC_WRITEBLCKBOARDC
	.byt <s_walk_updown			; SC_WALKUPDOWN
	.byt <s_restart				; SC_RESTARTLIST
	.byt <s_restart_nodinner	; SC_RESTIFNODINNER
	.byt <s_dinner_duty			; SC_DINNERDUTY
	.byt <s_unflag_event		; SC_UNFLAGEVENT
	.byt <s_goto_random			; SC_GOTORANDOM
	.byt <s_goto_random_trip	; SC_GOTORANDOMTRIP	
	.byt <s_follow_boy1			; SC_FOLLOWBOY1TRIP
	.byt <s_find_eric			; SC_FINDERIC			
	.byt <s_tell_einstein		; SC_TELLEINSTEIN
	.byt <s_tell_angelface		; SC_TELLANGELFACE
	.byt <s_tell_boywander		; SC_TELLBOYWANDER
	.byt <s_2000lines_eric		; SC_2000LINESERIC
	.byt <s_end_game			; SC_ENDGAME


/* Usually it is a good idea to keep 0 all the entries
   possible, as it speeds up things. Z=1 means no key
   pressed and there is no need to look in tables */

#define KEY_UP			1
#define KEY_LEFT		2
#define KEY_DOWN		3
#define KEY_RIGHT		4

#define KEY_LCTRL		0
#define KET_RCTRL		0
#define KEY_LSHIFT		0
#define KEY_RSHIFT		0
#define KEY_FUNCT		0

#define KEY_RETURN		$0d
#define KEY_ESC			$1b
#define KEY_DEL			$08

//#define COMPLETE_ASCII_TABLE

tab_ascii
#ifdef COMPLETE_ASCII_TABLE
    .asc "7","N","5","V",KET_RCTRL,"1","X","3"
    .asc "J","T","R","F",0,KEY_ESC,"Q","D"
    .asc "M","6","B","4",KEY_LCTRL,"Z","2","C"
    .asc "K","9",59,"-",0,0,92,39
    .asc " ",",",".",KEY_UP,KEY_LSHIFT,KEY_LEFT,KEY_DOWN,KEY_RIGHT
    .asc "U","I","O","P",KEY_FUNCT,KEY_DEL,"]","["
    .asc "Y","H","G","E",0,"A","S","W"
    .asc "8","L","0","/",KEY_RSHIFT,KEY_RETURN,0,"="
#else
    .asc "7","N","5","V",0,"1","X","3"
    .asc "J","T","R","F",0,0,"Q","D"
    .asc "M","6","B","4",0,"Z","2","C"
	.asc "K","9",0,0,0,0,0,0
    .asc " ",0,0,KEY_UP,0,KEY_LEFT,KEY_DOWN,KEY_RIGHT
    .asc "U","I","O","P",0,KEY_DEL,0,0
    .asc "Y","H","G","E",0,"A","S","W"
    .asc "8","L","0",0,0,KEY_RETURN,0,0
#endif

	
free_r19

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.dsb 256-(*&255)
; Tile map for background: row 20
skool_r20 ;.dsb SKOOL_COLS,1
	.byt $cf,$d0,$d1,$d2,$4,$4,$4,$4,$4,$4,$4,$4,$4,$4,$4,$4,$4,$4,$4,$4,$4,$4,$4,$4,$4,$4,$4,$4,$4,$4,$4,$4,$4,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$62,$63,$63,$63,$63,$63,$63,$63,$63,$63,$63,$63,$63,$63,$64,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$d3,$1,$1,$d4,$d4,$d5,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$d6,$d7,$d8,$d9

;;;;;;;;;;;;;;;;;;;;;;;
;; Command list table
;;;;;;;;;;;;;;;;;;;;;;;;
command_list_table
	.word command_list128
	.word command_list130
	.word command_list132
	.word command_list134
	.word command_list136
	.word command_list138
	.word command_list140
	.word command_list142
	.word command_list144
	.word command_list146
	.word command_list148
	.word command_list150
	.word command_list152
	.word command_list154
	.word command_list156
	.word command_list158
	.word command_list160
	.word command_list162
	.word command_list164
	.word command_list166
	.word command_list168
	.word command_list170
	.word command_list172
	.word command_list174
	.word command_list176
	.word command_list178
	.word command_list180
	.word command_list182
	.word command_list184
	.word command_list186
	.word command_list188
	.word command_list190
	.word command_list192
	.word command_list194
	.word command_list196
	.word command_list198
	.word command_list200
	.word command_list202
	.word command_list204
	.word command_list206
	.word command_list208
	.word command_list210
	.word command_list212
	.word command_list214
	.word command_list216
	.word command_list218
	.word command_list220
	.word command_list222

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Lesson descriptors
;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Each entry in this table defines the teacher for the period 
; (if any), and the room. The teacher is identified by bits 4-6
; See params.h


lesson_descriptors
	.byt (DES_DINNER|DES_WITHIT*16), (DES_DINNER|DES_WACKER*16), (DES_EXAM|DES_WACKER*16)
	.byt (DES_EXAM|DES_ROCKITT*16), (DES_LIBRARY|DES_NONE*16), (DES_LIBRARY|DES_NONE*16)
	.byt (DES_LIBRARY|DES_NONE*16), (DES_MAP|DES_WITHIT*16), (DES_READING|DES_WACKER*16)
	.byt (DES_READING|DES_ROCKITT*16), (DES_READING|DES_CREAK*16), (DES_WHITE|DES_CREAK*16)
	.byt (DES_WHITE|DES_WACKER*16), (DES_WHITE|DES_WITHIT*16), (DES_WHITE|DES_ROCKITT*16)
	.byt (DES_MAP|DES_WACKER*16), (DES_MAP|DES_WITHIT*16), (DES_WHITE|DES_ROCKITT*16)
	.byt (DES_READING|DES_CREAK*16), (DES_PLAY|DES_NONE*16),(DES_PLAY|DES_NONE*16)
	.byt (DES_PLAY|DES_NONE*16),(DES_PLAY|DES_NONE*16),(DES_PLAY|DES_NONE*16)
	.byt (DES_PLAY|DES_NONE*16),(DES_PLAY|DES_NONE*16),(DES_PLAY|DES_NONE*16)
	.byt (DES_PLAY|DES_NONE*16),(DES_PLAY|DES_NONE*16),(DES_PLAY|DES_NONE*16)
	.byt (DES_PLAY|DES_NONE*16),(DES_PLAY|DES_NONE*16)


; Character information
;.dsb 256-(*&255)

; Animatory states for children
Eric_anim_states
; Animatory state 0 (1-Eric00.png)
.byt 0, 0, 0, 0
.byt 0, 1, 2, 0
.byt 3, 4, 5, 0
.byt 0, 6, 7, 0
; Animatory state 1 (1-Eric01.png)
.byt 0, 0, 0, 0
.byt 15, 16, 17, 0
.byt 18, 19, 20, 0
.byt 21, 22, 23, 0
; Animatory state 2 (1-Eric02.png)
.byt 0, 0, 0, 0
.byt 0, 1, 2, 0
.byt 3, 4, 5, 0
.byt 0, 33, 7, 0
; Animatory state 3 (1-Eric03.png)
.byt 0, 0, 0, 0
.byt 15, 16, 17, 0
.byt 18, 19, 20, 0
.byt 35, 36, 37, 0
; Animatory state 4 (1-Eric04.png)
.byt 0, 0, 0, 0
.byt 0, 1, 2, 0
.byt 41, 42, 43, 0
.byt 44, 45, 0, 0
; Animatory state 5 (1-Eric05.png)
.byt 0, 0, 0, 0
.byt 0, 0, 0, 0
.byt 0, 51, 52, 53
.byt 54, 55, 56, 57
; Animatory state 6 (1-Eric06.png)
.byt 0, 0, 0, 0
.byt 0, 0, 0, 0
.byt 0, 0, 0, 0
.byt 65, 66, 67, 68
; Animatory state 7 (1-Eric07.png)
.byt 0, 0, 0, 0
.byt 0, 1, 2, 0
.byt 73, 74, 75, 0
.byt 0, 76, 77, 0
; Animatory state 8 (1-Eric08.png)
.byt 0, 0, 0, 0
.byt 83, 84, 2, 0
.byt 85, 86, 75, 0
.byt 0, 76, 77, 0
; Animatory state 9 (1-Eric09.png)
.byt 0, 0, 0, 0
.byt 91, 92, 2, 0
.byt 93, 94, 5, 0
.byt 0, 95, 7, 0
; Animatory state 10 (1-Eric10.png)
.byt 101, 102, 0, 0
.byt 103, 104, 2, 0
.byt 93, 94, 5, 0
.byt 0, 95, 7, 0
; Animatory state 11 (1-Eric11.png)
.byt 0, 0, 0, 0
.byt 0, 1, 2, 0
.byt 109, 110, 111, 112
.byt 0, 95, 113, 0
; Animatory state 12 (1-Eric12.png)
.byt 0, 0, 0, 0
.byt 119, 120, 121, 0
.byt 122, 123, 124, 125
.byt 0, 95, 113, 0

Einstein_anim_states
; Animatory state 13 (2-Einstein00.png)
.byt 0, 0, 0, 0
.byt 0, 133, 134, 0
.byt 3, 4, 135, 0
.byt 0, 6, 7, 0
; Animatory state 14 (2-Einstein1.png)
.byt 0, 0, 0, 0
.byt 139, 140, 141, 0
.byt 18, 142, 20, 0
.byt 21, 22, 23, 0
; Animatory state 15 (2-Einstein2.png)
.byt 0, 0, 0, 0
.byt 0, 133, 134, 0
.byt 3, 4, 135, 0
.byt 0, 33, 7, 0
; Animatory state 16 (2-Einstein3.png)
.byt 0, 0, 0, 0
.byt 139, 140, 141, 0
.byt 18, 142, 20, 0
.byt 35, 36, 37, 0
; Animatory state 17 (2-Einstein4.png)
.byt 0, 0, 0, 0
.byt 0, 133, 134, 0
.byt 41, 42, 43, 0
.byt 44, 45, 0, 0
; Animatory state 18 (2-Einstein5.png)
.byt 0, 0, 0, 0
.byt 0, 0, 0, 0
.byt 0, 51, 147, 148
.byt 54, 55, 56, 57
; Animatory state 19 (2-Einstein6.png)
.byt 0, 0, 0, 0
.byt 0, 0, 0, 0
.byt 0, 0, 0, 0
.byt 65, 66, 151, 152

Angelface_anim_states
; Animatory state 20 (3-Angelface00.png)
.byt 0, 0, 0, 0
.byt 0, 155, 156, 0
.byt 3, 4, 5, 0
.byt 0, 6, 7, 0
; Animatory state 21 (3-Angelface01.png)
.byt 0, 0, 0, 0
.byt 159, 160, 17, 0
.byt 18, 19, 20, 0
.byt 161, 22, 23, 0
; Animatory state 22 (3-Angelface02.png)
.byt 0, 0, 0, 0
.byt 0, 155, 156, 0
.byt 3, 4, 5, 0
.byt 0, 33, 7, 0
; Animatory state 23 (3-Angelface03.png)
.byt 0, 0, 0, 0
.byt 159, 160, 17, 0
.byt 18, 19, 20, 0
.byt 35, 36, 37, 0
; Animatory state 24 (3-Angelface04.png)
.byt 0, 0, 0, 0
.byt 0, 155, 156, 0
.byt 41, 42, 43, 0
.byt 44, 45, 0, 0
; Animatory state 25 (3-Angelface05.png)
.byt 0, 0, 0, 0
.byt 0, 0, 0, 0
.byt 0, 51, 165, 166
.byt 54, 55, 56, 57
; Animatory state 26 (3-Angelface06.png)
.byt 0, 0, 0, 0
.byt 0, 0, 0, 0
.byt 0, 0, 0, 0
.byt 65, 66, 169, 170
; Animatory state 27 (3-Angelface07.png)
.byt 0, 0, 0, 0
.byt 0, 155, 156, 0
.byt 73, 74, 75, 0
.byt 0, 76, 77, 0
; Animatory state 28 (3-Angelface08.png)
.byt 0, 0, 0, 0
.byt 83, 173, 156, 0
.byt 85, 86, 75, 0
.byt 0, 76, 77, 0
; Animatory state 29 (3-Angelface09.png)
.byt 0, 0, 0, 0
.byt 91, 175, 156, 0
.byt 93, 94, 5, 0
.byt 0, 95, 7, 0
; Animatory state 30 (3-Angelface10.png)
.byt 101, 102, 0, 0
.byt 103, 177, 156, 0
.byt 93, 94, 5, 0
.byt 0, 95, 7, 0


BoyWander_anim_states
; Animatory state 31 (4-bwander00.png)
.byt 0, 0, 0, 0
.byt 0, 179, 180, 0
.byt 3, 4, 5, 0
.byt 0, 6, 7, 0
; Animatory state 32 (4-bwander01.png)
.byt 0, 0, 0, 0
.byt 183, 184, 17, 0
.byt 18, 19, 20, 0
.byt 161, 22, 23, 0
; Animatory state 33 (4-bwander02.png)
.byt 0, 0, 0, 0
.byt 0, 179, 180, 0
.byt 3, 4, 5, 0
.byt 0, 33, 7, 0
; Animatory state 34 (4-bwander03.png)
.byt 0, 0, 0, 0
.byt 183, 184, 17, 0
.byt 18, 19, 20, 0
.byt 35, 36, 37, 0
; Animatory state 35 (4-bwander04.png)
.byt 0, 0, 0, 0
.byt 0, 179, 180, 0
.byt 41, 42, 43, 0
.byt 44, 45, 0, 0
; Animatory state 36 (4-bwander05.png)
.byt 0, 0, 0, 0
.byt 0, 0, 0, 0
.byt 0, 51, 187, 188
.byt 54, 55, 56, 57
; Animatory state 37 (4-bwander06.png)
.byt 0, 0, 0, 0
.byt 0, 0, 0, 0
.byt 0, 0, 0, 0
.byt 65, 66, 191, 192

; 07 and 08 are unused with Boy Wander
.byt 0,0,0,0
.byt 0,0,0,0
.byt 0,0,0,0
.byt 0,0,0,0

.byt 0,0,0,0
.byt 0,0,0,0
.byt 0,0,0,0
.byt 0,0,0,0


; Animatory state 38 (4-bwander09.png)
.byt 0, 0, 0, 0
.byt 91, 195, 180, 0
.byt 93, 94, 5, 0
.byt 0, 95, 7, 0
; Animatory state 39 (4-bwander10.png)
.byt 101, 102, 0, 0
.byt 103, 197, 180, 0
.byt 93, 94, 5, 0
.byt 0, 95, 7, 0
; Animatory state 40 (4-bwander11.png)
.byt 0, 0, 0, 0
.byt 0, 179, 180, 0
.byt 109, 110, 111, 112
.byt 0, 95, 113, 0
; Animatory state 41 (4-bwander12.png)
.byt 0, 0, 0, 0
.byt 119, 199, 200, 0
.byt 122, 123, 124, 125
.byt 0, 95, 113, 0


Boy_anim_states
; Animatory state 42 (5-boy0.png)
.byt 0, 0, 0, 0
.byt 0, 203, 204, 0
.byt 0, 205, 206, 0
.byt 0, 95, 7, 0
; Animatory state 43 (5-boy1.png)
.byt 0, 0, 0, 0
.byt 211, 212, 0, 0
.byt 213, 214, 215, 0
.byt 216, 22, 23, 0
; Animatory state 44 (5-boy2.png)
.byt 0, 0, 0, 0
.byt 0, 203, 204, 0
.byt 0, 205, 206, 0
.byt 0, 223, 7, 0
; Animatory state 45 (5-boy3.png)
.byt 0, 0, 0, 0
.byt 211, 212, 0, 0
.byt 213, 214, 215, 0
.byt 35, 36, 37, 0
; Animatory state 46 (5-boy4.png)
.byt 0, 0, 0, 0
.byt 0, 203, 225, 0
.byt 0, 226, 227, 0
.byt 228, 229, 0, 0
; Animatory state 47 (5-boy5.png)
.byt 0, 0, 0, 0
.byt 0, 0, 0, 0
.byt 24, 235, 236, 0
.byt 237, 238, 239, 0
; Animatory state 48 (5-boy6.png)
.byt 0, 0, 0, 0
.byt 0, 0, 0, 0
.byt 0, 0, 0, 0
.byt 245, 246, 247, 248

Pellet_anim_states
; Animatory state 49 (6-pellet.png)
.byt 0, 0, 0, 0
.byt 0, 253, 0, 0
.byt 0, 0, 0, 0
.byt 0, 0, 0, 0




Inverted_anim_states

; Animatory states for children (invert)
; Animatory state 0 (1-Eric00.png)
.byt 0, 0, 0, 0
.byt 0, 8, 9, 0
.byt 0, 10, 11, 12
.byt 0, 13, 14, 0
; Animatory state 1 (1-Eric01.png)
.byt 0, 0, 0, 0
.byt 0, 24, 25, 26
.byt 0, 27, 28, 29
.byt 0, 30, 31, 32
; Animatory state 2 (1-Eric02.png)
.byt 0, 0, 0, 0
.byt 0, 8, 9, 0
.byt 0, 10, 11, 12
.byt 0, 13, 34, 0
; Animatory state 3 (1-Eric03.png)
.byt 0, 0, 0, 0
.byt 0, 24, 25, 26
.byt 0, 27, 28, 29
.byt 0, 38, 39, 40
; Animatory state 4 (1-Eric04.png)
.byt 0, 0, 0, 0
.byt 0, 8, 9, 0
.byt 0, 46, 47, 48
.byt 0, 0, 49, 50
; Animatory state 5 (1-Eric05.png)
.byt 0, 0, 0, 0
.byt 0, 0, 0, 0
.byt 58, 59, 60, 0
.byt 61, 62, 63, 64
; Animatory state 6 (1-Eric06.png)
.byt 0, 0, 0, 0
.byt 0, 0, 0, 0
.byt 0, 0, 0, 0
.byt 69, 70, 71, 72
; Animatory state 7 (1-Eric07.png)
.byt 0, 0, 0, 0
.byt 0, 8, 9, 0
.byt 0, 78, 79, 80
.byt 0, 81, 82, 0
; Animatory state 8 (1-Eric08.png)
.byt 0, 0, 0, 0
.byt 0, 8, 87, 88
.byt 0, 78, 89, 90
.byt 0, 81, 82, 0
; Animatory state 9 (1-Eric09.png)
.byt 0, 0, 0, 0
.byt 0, 8, 96, 97
.byt 0, 10, 98, 99
.byt 0, 13, 100, 0
; Animatory state 10 (1-Eric10.png)
.byt 0, 0, 105, 106
.byt 0, 8, 107, 108
.byt 0, 10, 98, 99
.byt 0, 13, 100, 0
; Animatory state 11 (1-Eric11.png)
.byt 0, 0, 0, 0
.byt 0, 8, 9, 0
.byt 114, 115, 116, 117
.byt 0, 118, 100, 0
; Animatory state 12 (1-Eric12.png)
.byt 0, 0, 0, 0
.byt 0, 126, 127, 128
.byt 129, 130, 131, 132
.byt 0, 118, 100, 0
; Animatory state 13 (2-Einstein00.png)
.byt 0, 0, 0, 0
.byt 0, 136, 137, 0
.byt 0, 138, 11, 12
.byt 0, 13, 14, 0
; Animatory state 14 (2-Einstein1.png)
.byt 0, 0, 0, 0
.byt 0, 143, 144, 145
.byt 0, 27, 146, 29
.byt 0, 30, 31, 32
; Animatory state 15 (2-Einstein2.png)
.byt 0, 0, 0, 0
.byt 0, 136, 137, 0
.byt 0, 138, 11, 12
.byt 0, 13, 34, 0
; Animatory state 16 (2-Einstein3.png)
.byt 0, 0, 0, 0
.byt 0, 143, 144, 145
.byt 0, 27, 146, 29
.byt 0, 38, 39, 40
; Animatory state 17 (2-Einstein4.png)
.byt 0, 0, 0, 0
.byt 0, 136, 137, 0
.byt 0, 46, 47, 48
.byt 0, 0, 49, 50
; Animatory state 18 (2-Einstein5.png)
.byt 0, 0, 0, 0
.byt 0, 0, 0, 0
.byt 149, 150, 60, 0
.byt 61, 62, 63, 64
; Animatory state 19 (2-Einstein6.png)
.byt 0, 0, 0, 0
.byt 0, 0, 0, 0
.byt 0, 0, 0, 0
.byt 153, 154, 71, 72
; Animatory state 20 (3-Angelface00.png)
.byt 0, 0, 0, 0
.byt 0, 157, 158, 0
.byt 0, 10, 11, 12
.byt 0, 13, 14, 0
; Animatory state 21 (3-Angelface01.png)
.byt 0, 0, 0, 0
.byt 0, 24, 162, 163
.byt 0, 27, 28, 29
.byt 0, 30, 31, 164
; Animatory state 22 (3-Angelface02.png)
.byt 0, 0, 0, 0
.byt 0, 157, 158, 0
.byt 0, 10, 11, 12
.byt 0, 13, 34, 0
; Animatory state 23 (3-Angelface03.png)
.byt 0, 0, 0, 0
.byt 0, 24, 162, 163
.byt 0, 27, 28, 29
.byt 0, 38, 39, 40
; Animatory state 24 (3-Angelface04.png)
.byt 0, 0, 0, 0
.byt 0, 157, 158, 0
.byt 0, 46, 47, 48
.byt 0, 0, 49, 50
; Animatory state 25 (3-Angelface05.png)
.byt 0, 0, 0, 0
.byt 0, 0, 0, 0
.byt 167, 168, 60, 0
.byt 61, 62, 63, 64
; Animatory state 26 (3-Angelface06.png)
.byt 0, 0, 0, 0
.byt 0, 0, 0, 0
.byt 0, 0, 0, 0
.byt 171, 172, 71, 72
; Animatory state 27 (3-Angelface07.png)
.byt 0, 0, 0, 0
.byt 0, 157, 158, 0
.byt 0, 78, 79, 80
.byt 0, 81, 82, 0
; Animatory state 28 (3-Angelface08.png)
.byt 0, 0, 0, 0
.byt 0, 157, 174, 88
.byt 0, 78, 89, 90
.byt 0, 81, 82, 0
; Animatory state 29 (3-Angelface09.png)
.byt 0, 0, 0, 0
.byt 0, 157, 176, 97
.byt 0, 10, 98, 99
.byt 0, 13, 100, 0
; Animatory state 30 (3-Angelface10.png)
.byt 0, 0, 105, 106
.byt 0, 157, 178, 108
.byt 0, 10, 98, 99
.byt 0, 13, 100, 0
; Animatory state 31 (4-bwander00.png)
.byt 0, 0, 0, 0
.byt 0, 181, 182, 0
.byt 0, 10, 11, 12
.byt 0, 13, 14, 0
; Animatory state 32 (4-bwander01.png)
.byt 0, 0, 0, 0
.byt 0, 24, 185, 186
.byt 0, 27, 28, 29
.byt 0, 30, 31, 164
; Animatory state 33 (4-bwander02.png)
.byt 0, 0, 0, 0
.byt 0, 181, 182, 0
.byt 0, 10, 11, 12
.byt 0, 13, 34, 0
; Animatory state 34 (4-bwander03.png)
.byt 0, 0, 0, 0
.byt 0, 24, 185, 186
.byt 0, 27, 28, 29
.byt 0, 38, 39, 40
; Animatory state 35 (4-bwander04.png)
.byt 0, 0, 0, 0
.byt 0, 181, 182, 0
.byt 0, 46, 47, 48
.byt 0, 0, 49, 50
; Animatory state 36 (4-bwander05.png)
.byt 0, 0, 0, 0
.byt 0, 0, 0, 0
.byt 189, 190, 60, 0
.byt 61, 62, 63, 64
; Animatory state 37 (4-bwander06.png)
.byt 0, 0, 0, 0
.byt 0, 0, 0, 0
.byt 0, 0, 0, 0
.byt 193, 194, 71, 72
; 07 and 08 are unused with Boy Wander
.byt 0,0,0,0
.byt 0,0,0,0
.byt 0,0,0,0
.byt 0,0,0,0

.byt 0,0,0,0
.byt 0,0,0,0
.byt 0,0,0,0
.byt 0,0,0,0

; Animatory state 38 (4-bwander09.png)
.byt 0, 0, 0, 0
.byt 0, 181, 196, 97
.byt 0, 10, 98, 99
.byt 0, 13, 100, 0
; Animatory state 39 (4-bwander10.png)
.byt 0, 0, 105, 106
.byt 0, 181, 198, 108
.byt 0, 10, 98, 99
.byt 0, 13, 100, 0
; Animatory state 40 (4-bwander11.png)
.byt 0, 0, 0, 0
.byt 0, 181, 182, 0
.byt 114, 115, 116, 117
.byt 0, 118, 100, 0
; Animatory state 41 (4-bwander12.png)
.byt 0, 0, 0, 0
.byt 0, 201, 202, 128
.byt 129, 130, 131, 132
.byt 0, 118, 100, 0
; Animatory state 42 (5-boy0.png)
.byt 0, 0, 0, 0
.byt 0, 207, 208, 0
.byt 0, 209, 210, 0
.byt 0, 13, 100, 0
; Animatory state 43 (5-boy1.png)
.byt 0, 0, 0, 0
.byt 0, 0, 217, 218
.byt 0, 219, 220, 221
.byt 0, 30, 31, 222
; Animatory state 44 (5-boy2.png)
.byt 0, 0, 0, 0
.byt 0, 207, 208, 0
.byt 0, 209, 210, 0
.byt 0, 13, 224, 0
; Animatory state 45 (5-boy3.png)
.byt 0, 0, 0, 0
.byt 0, 0, 217, 218
.byt 0, 219, 220, 221
.byt 0, 38, 39, 40
; Animatory state 46 (5-boy4.png)
.byt 0, 0, 0, 0
.byt 0, 230, 208, 0
.byt 0, 231, 232, 0
.byt 0, 0, 233, 234
; Animatory state 47 (5-boy5.png)
.byt 0, 0, 0, 0
.byt 0, 0, 0, 0
.byt 0, 240, 241, 17
.byt 0, 242, 243, 244
; Animatory state 48 (5-boy6.png)
.byt 0, 0, 0, 0
.byt 0, 0, 0, 0
.byt 0, 0, 0, 0
.byt 249, 250, 251, 252

; Animatory state 49 (6-pellet.png)
.byt 0, 0, 0, 0
.byt 0, 0, 254, 0
.byt 0, 0, 0, 0
.byt 0, 0, 0, 0



;Animatory states for teachers

Creak_anim_states
; Animatory state 0 (Creak0.png)
.byt 0, 1, 2, 3
.byt 0, 4, 5, 6
.byt 0, 7, 8, 9
.byt 0, 10, 11, 12
; Animatory state 1 (Creak1.png)
.byt 25, 26, 27, 0
.byt 28, 29, 30, 31
.byt 32, 33, 34, 35
.byt 36, 37, 38, 39
; Animatory state 2 (Creak2.png)
.byt 0, 1, 2, 3
.byt 0, 4, 5, 6
.byt 0, 7, 8, 9
.byt 0, 55, 56, 57
; Animatory state 3 (Creak3.png)
.byt 25, 26, 27, 0
.byt 28, 29, 30, 31
.byt 32, 33, 34, 35
.byt 36, 37, 38, 39
; Animatory state 4 (Creak4.png)
.byt 61, 62, 2, 3
.byt 32, 63, 5, 6
.byt 0, 64, 8, 9
.byt 0, 10, 11, 12
; Animatory state 5 (Creak5.png)
.byt 0, 0, 0, 0
.byt 69, 70, 71, 72
.byt 73, 74, 75, 76
.byt 77, 78, 79, 80

Rockitt_anim_states
; Animatory state 8 (Rockitt2.png)
.byt 0, 93, 94, 0
.byt 0, 95, 96, 97
.byt 0, 98, 99, 100
.byt 0, 139, 140, 141
; Animatory state 7 (Rockitt1.png)
.byt 113, 114, 115, 0
.byt 116, 117, 118, 0
.byt 119, 120, 121, 0
.byt 122, 123, 124, 125
; Animatory state 6 (Rockitt0.png)
.byt 0, 93, 94, 0
.byt 0, 95, 96, 97
.byt 0, 98, 99, 100
.byt 0, 101, 102, 35
; Animatory state 9 (Rockitt3.png)
.byt 113, 114, 115, 0
.byt 116, 117, 118, 0
.byt 119, 120, 121, 0
.byt 36, 145, 146, 0
; Animatory state 10 (Rockitt4.png)
.byt 0, 93, 94, 0
.byt 149, 150, 96, 97
.byt 0, 151, 99, 100
.byt 0, 139, 140, 141
; Animatory state 11 (Rockitt5.png)
.byt 0, 0, 0, 0
.byt 0, 155, 156, 157
.byt 0, 158, 159, 160
.byt 77, 78, 79, 80

Wacker_anim_states
; Animatory state 12 (Wacker0.png)
.byt 0, 167, 168, 0
.byt 0, 169, 170, 171
.byt 172, 173, 174, 175
.byt 0, 176, 177, 178
; Animatory state 13 (Wacker1.png)
.byt 116, 191, 192, 0
.byt 193, 194, 195, 0
.byt 196, 197, 198, 199
.byt 200, 201, 202, 0
; Animatory state 14 (Wacker2.png)
.byt 0, 167, 168, 0
.byt 0, 169, 170, 171
.byt 172, 173, 174, 175
.byt 0, 215, 216, 178
; Animatory state 15 (Wacker3.png)
.byt 116, 191, 192, 0
.byt 193, 194, 195, 0
.byt 196, 197, 198, 199
.byt 219, 220, 221, 0
; Animatory state 16 (Wacker4.png)
.byt 225, 167, 168, 0
.byt 226, 227, 170, 171
.byt 172, 173, 174, 175
.byt 0, 176, 177, 178
; Animatory state 17 (Wacker5.png)
.byt 0, 0, 0, 0
.byt 0, 231, 232, 233
.byt 0, 234, 235, 236
.byt 77, 78, 79, 80


; Animatory states for teachers (group1) inverted

t1_inverted_anim_states
; Animatory state 0 (Creak0.png)
.byt 13, 14, 15, 0
.byt 16, 17, 18, 0
.byt 19, 20, 21, 0
.byt 22, 23, 24, 0
; Animatory state 1 (Creak1.png)
.byt 0, 40, 41, 42
.byt 43, 44, 45, 46
.byt 47, 48, 49, 50
.byt 51, 52, 53, 54
; Animatory state 2 (Creak2.png)
.byt 13, 14, 15, 0
.byt 16, 17, 18, 0
.byt 19, 20, 21, 0
.byt 58, 59, 60, 0
; Animatory state 3 (Creak3.png)
.byt 0, 40, 41, 42
.byt 43, 44, 45, 46
.byt 47, 48, 49, 50
.byt 51, 52, 53, 54
; Animatory state 4 (Creak4.png)
.byt 13, 14, 65, 66
.byt 16, 17, 67, 50
.byt 19, 20, 68, 0
.byt 22, 23, 24, 0
; Animatory state 5 (Creak5.png)
.byt 0, 0, 0, 0
.byt 81, 82, 83, 84
.byt 85, 86, 87, 88
.byt 89, 90, 91, 92
; Animatory state 8 (Rockitt2.png)
.byt 0, 103, 104, 0
.byt 105, 106, 107, 0
.byt 108, 109, 110, 0
.byt 142, 143, 144, 0
; Animatory state 7 (Rockitt1.png)
.byt 0, 126, 127, 128
.byt 0, 129, 130, 131
.byt 0, 132, 133, 134
.byt 135, 136, 137, 138
; Animatory state 6 (Rockitt0.png)
.byt 0, 103, 104, 0
.byt 105, 106, 107, 0
.byt 108, 109, 110, 0
.byt 47, 111, 112, 0
; Animatory state 9 (Rockitt3.png)
.byt 0, 126, 127, 128
.byt 0, 129, 130, 131
.byt 0, 132, 133, 134
.byt 0, 147, 148, 54
; Animatory state 10 (Rockitt4.png)
.byt 0, 103, 104, 0
.byt 105, 106, 152, 153
.byt 108, 109, 154, 0
.byt 142, 143, 144, 0
; Animatory state 11 (Rockitt5.png)
.byt 0, 0, 0, 0
.byt 161, 162, 163, 0
.byt 164, 165, 166, 0
.byt 89, 90, 91, 92
; Animatory state 12 (Wacker0.png)
.byt 0, 179, 180, 0
.byt 181, 182, 183, 0
.byt 184, 185, 186, 187
.byt 188, 189, 190, 0
; Animatory state 13 (Wacker1.png)
.byt 0, 203, 204, 131
.byt 0, 205, 206, 207
.byt 208, 209, 210, 211
.byt 0, 212, 213, 214
; Animatory state 14 (Wacker2.png)
.byt 0, 179, 180, 0
.byt 181, 182, 183, 0
.byt 184, 185, 186, 187
.byt 188, 217, 218, 0
; Animatory state 15 (Wacker3.png)
.byt 0, 203, 204, 131
.byt 0, 205, 206, 207
.byt 208, 209, 210, 211
.byt 0, 222, 223, 224
; Animatory state 16 (Wacker4.png)
.byt 0, 179, 180, 228
.byt 181, 182, 229, 230
.byt 184, 185, 186, 187
.byt 188, 189, 190, 0
; Animatory state 17 (Wacker5.png)
.byt 0, 0, 0, 0
.byt 237, 238, 239, 0
.byt 240, 241, 242, 0
.byt 89, 90, 91, 92


Withit_anim_states
; Animatory state 0 (Withit0.png)
.byt 0, 1, 2, 3
.byt 0, 4, 5, 6
.byt 0, 7, 8, 9
.byt 0, 10, 11, 12
; Animatory state 1 (Withit1.png)
.byt 0, 25, 26, 0
.byt 27, 28, 29, 30
.byt 31, 32, 33, 34
.byt 35, 36, 37, 38
; Animatory state 2 (Withit2.png)
.byt 0, 1, 2, 3
.byt 0, 4, 5, 6
.byt 0, 7, 8, 9
.byt 0, 53, 54, 12
; Animatory state 3 (Withit3.png)
.byt 0, 25, 26, 0
.byt 27, 28, 29, 30
.byt 31, 32, 33, 34
.byt 57, 58, 59, 0
; Animatory state 4 (Withit4.png)
.byt 0, 1, 2, 3
.byt 63, 64, 5, 6
.byt 0, 65, 66, 9
.byt 0, 10, 11, 12
; Animatory state 5 (Withit5.png)
.byt 0, 0, 0, 0
.byt 0, 71, 72, 73
.byt 0, 74, 75, 76
.byt 77, 78, 79, 80


; Animatory states for teachers (group 2) (invert)
t2_inverted_anim_states
; Animatory state 0 (Withit0.png)
.byt 13, 14, 15, 0
.byt 16, 17, 18, 0
.byt 19, 20, 21, 0
.byt 22, 23, 24, 0
; Animatory state 1 (Withit1.png)
.byt 0, 39, 40, 0
.byt 41, 42, 43, 44
.byt 45, 46, 47, 48
.byt 49, 50, 51, 52
; Animatory state 2 (Withit2.png)
.byt 13, 14, 15, 0
.byt 16, 17, 18, 0
.byt 19, 20, 21, 0
.byt 22, 55, 56, 0
; Animatory state 3 (Withit3.png)
.byt 0, 39, 40, 0
.byt 41, 42, 43, 44
.byt 45, 46, 47, 48
.byt 0, 60, 61, 62
; Animatory state 4 (Withit4.png)
.byt 13, 14, 15, 0
.byt 16, 17, 67, 68
.byt 19, 69, 70, 0
.byt 22, 23, 24, 0
; Animatory state 5 (Withit5.png)
.byt 0, 0, 0, 0
.byt 81, 82, 83, 0
.byt 84, 85, 86, 0
.byt 87, 88, 89, 90
end_anim_states

;;;;;;;;;;;;;;;;;;;;;;;;;
; Tables
;;;;;;;;;;;;;;;;;;;;;;;;;

tab_div5
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 8
	.byt 8
	.byt 8
	.byt 8
	.byt 8
	.byt 9
	.byt 9
	.byt 9
	.byt 9
	.byt 9
	.byt 10
	.byt 10
	.byt 10
	.byt 10
	.byt 10
	.byt 11
	.byt 11
	.byt 11
	.byt 11
	.byt 11
	.byt 12
	.byt 12
	.byt 12
	.byt 12
	.byt 12
	.byt 13
	.byt 13
	.byt 13
	.byt 13
	.byt 13
	.byt 14
	.byt 14
	.byt 14
	.byt 14
	.byt 14
	.byt 15
	.byt 15
	.byt 15
	.byt 15
	.byt 15
	.byt 16
	.byt 16
	.byt 16
	.byt 16
	.byt 16
	.byt 17
	.byt 17
	.byt 17
	.byt 17
	.byt 17
	.byt 18
	.byt 18
	.byt 18
	.byt 18
	.byt 18
	.byt 19
	.byt 19
	.byt 19
	.byt 19
	.byt 19
	.byt 20
	.byt 20
	.byt 20
	.byt 20
	.byt 20

tab_mod5
	.byt 0
	.byt 8
	.byt 16
	.byt 24
	.byt 32
	.byt 0
	.byt 8
	.byt 16
	.byt 24
	.byt 32
	.byt 0
	.byt 8
	.byt 16
	.byt 24
	.byt 32
	.byt 0
	.byt 8
	.byt 16
	.byt 24
	.byt 32
	.byt 0
	.byt 8
	.byt 16
	.byt 24
	.byt 32
	.byt 0
	.byt 8
	.byt 16
	.byt 24
	.byt 32
	.byt 0
	.byt 8
	.byt 16
	.byt 24
	.byt 32
	.byt 0
	.byt 8
	.byt 16
	.byt 24
	.byt 32
	.byt 0
	.byt 8
	.byt 16
	.byt 24
	.byt 32
	.byt 0
	.byt 8
	.byt 16
	.byt 24
	.byt 32
	.byt 0
	.byt 8
	.byt 16
	.byt 24
	.byt 32
	.byt 0
	.byt 8
	.byt 16
	.byt 24
	.byt 32
	.byt 0
	.byt 8
	.byt 16
	.byt 24
	.byt 32
	.byt 0
	.byt 8
	.byt 16
	.byt 24
	.byt 32
	.byt 0
	.byt 8
	.byt 16
	.byt 24
	.byt 32
	.byt 0
	.byt 8
	.byt 16
	.byt 24
	.byt 32
	.byt 0
	.byt 8
	.byt 16
	.byt 24
	.byt 32
	.byt 0
	.byt 8
	.byt 16
	.byt 24
	.byt 32
	.byt 0
	.byt 8
	.byt 16
	.byt 24
	.byt 32
	.byt 0
	.byt 8
	.byt 16
	.byt 24
	.byt 32
	.byt 0
	.byt 8
	.byt 16
	.byt 24
	.byt 32
	

;.dsb 256-(*&255)
.bss
*=$400
_HiresAddrLow           .dsb 240

.text
;;;;;; Main timetable (see script.h)
main_timetable
	.byt PLAYTIME1, WACKER_EXAMROOM, WITHIT_MAPROOM 
	.byt PLAYTIME2, ROCKITT_WHITEROOM, CREAK_READINGROOM
	.byt PLAYTIME3, DINNER_WITHIT, PLAYTIME7S, PLAYTIME9
	.byt WITHIT_WHITEROOM, REV_LIBRARY1, PLAYTIME4, ROCKITT_WHITEROOM
	.byt PLAYTIME5, WACKER_WHITEROOM, PLAYTIME6, WACKER_READINGROOM
	.byt CREAK_WHITEROOM, PLAYTIME3, PLAYTIME10, ROCKITT_READINGROOM
	.byt WACKER_MAPROOM, PLAYTIME5, DINNER_WACKER, PLAYTIME8S

;	.byt CREAK_READINGROOM, ROCKITT_EXAMROOM, REV_LIBRARY2, PLAYTIME1
;	.byt WITHIT_WHITEROOM, ROCKITT_READINGROOM, PLAYTIME4, WITHIT_WHITEROOM
	
	.byt CREAK_READINGROOM, ROCKITT_EXAMROOM, REV_LIBRARY2, PLAYTIME4, WITHIT_WHITEROOM
	.byt ROCKITT_EXAMROOM, PLAYTIME4, WITHIT_MAPROOM, REV_LIBRARY3
	.byt CREAK_WHITEROOM, PLAYTIME6, CREAK_READINGROOM, ROCKITT_WHITEROOM
	.byt PLAYTIME2, DINNER_WITHIT, PLAYTIME1, PLAYTIME10, ROCKITT_WHITEROOM
	.byt WACKER_EXAMROOM, PLAYTIME5, REV_LIBRARY1, WITHIT_MAPROOM
	.byt PLAYTIME3, WITHIT_MAPROOM, WACKER_READINGROOM, PLAYTIME5, PLAYTIME9
	.byt ROCKITT_WHITEROOM, CREAK_READINGROOM2, PLAYTIME2, DINNER_WACKER
	.byt PLAYTIME7S,PLAYTIME9, WACKER_EXAMROOM, REV_LIBRARY2
	.byt PLAYTIME4, WITHIT_WHITEROOM, WACKER_MAPROOM


;.dsb 256-(*&255)
_HiresAddrHigh          .dsb 200


;.dsb 256-(*&255)
#ifdef FULLTABLEMUL8
tab_mul8hi
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 0
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 6
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
#endif
tab_mul8
	.byt 0
	.byt 8
	.byt 16
	.byt 24
	.byt 32
	.byt 40
	.byt 48
	.byt 56
	.byt 64
	.byt 72
	.byt 80
	.byt 88
	.byt 96
	.byt 104
	.byt 112
	.byt 120
	.byt 128
	.byt 136
	.byt 144
	.byt 152
	.byt 160
	.byt 168
	.byt 176
	.byt 184
	.byt 192
	.byt 200
	.byt 208
	.byt 216
	.byt 224
	.byt 232
	.byt 240
	.byt 248
#ifdef FULLTABLEMUL8
	.byt 0
	.byt 8
	.byt 16
	.byt 24
	.byt 32
	.byt 40
	.byt 48
	.byt 56
	.byt 64
	.byt 72
	.byt 80
	.byt 88
	.byt 96
	.byt 104
	.byt 112
	.byt 120
	.byt 128
	.byt 136
	.byt 144
	.byt 152
	.byt 160
	.byt 168
	.byt 176
	.byt 184
	.byt 192
	.byt 200
	.byt 208
	.byt 216
	.byt 224
	.byt 232
	.byt 240
	.byt 248
	.byt 0
	.byt 8
	.byt 16
	.byt 24
	.byt 32
	.byt 40
	.byt 48
	.byt 56
	.byt 64
	.byt 72
	.byt 80
	.byt 88
	.byt 96
	.byt 104
	.byt 112
	.byt 120
	.byt 128
	.byt 136
	.byt 144
	.byt 152
	.byt 160
	.byt 168
	.byt 176
	.byt 184
	.byt 192
	.byt 200
	.byt 208
	.byt 216
	.byt 224
	.byt 232
	.byt 240
	.byt 248
	.byt 0
	.byt 8
	.byt 16
	.byt 24
	.byt 32
	.byt 40
	.byt 48
	.byt 56
	.byt 64
	.byt 72
	.byt 80
	.byt 88
	.byt 96
	.byt 104
	.byt 112
	.byt 120
	.byt 128
	.byt 136
	.byt 144
	.byt 152
	.byt 160
	.byt 168
	.byt 176
	.byt 184
	.byt 192
	.byt 200
	.byt 208
	.byt 216
	.byt 224
	.byt 232
	.byt 240
	.byt 248
	.byt 0
	.byt 8
	.byt 16
	.byt 24
	.byt 32
	.byt 40
	.byt 48
	.byt 56
	.byt 64
	.byt 72
	.byt 80
	.byt 88
	.byt 96
	.byt 104
	.byt 112
	.byt 120
	.byt 128
	.byt 136
	.byt 144
	.byt 152
	.byt 160
	.byt 168
	.byt 176
	.byt 184
	.byt 192
	.byt 200
	.byt 208
	.byt 216
	.byt 224
	.byt 232
	.byt 240
	.byt 248
	.byt 0
	.byt 8
	.byt 16
	.byt 24
	.byt 32
	.byt 40
	.byt 48
	.byt 56
	.byt 64
	.byt 72
	.byt 80
	.byt 88
	.byt 96
	.byt 104
	.byt 112
	.byt 120
	.byt 128
	.byt 136
	.byt 144
	.byt 152
	.byt 160
	.byt 168
	.byt 176
	.byt 184
	.byt 192
	.byt 200
	.byt 208
	.byt 216
	.byt 224
	.byt 232
	.byt 240
	.byt 248
	.byt 0
	.byt 8
	.byt 16
	.byt 24
	.byt 32
	.byt 40
	.byt 48
	.byt 56
	.byt 64
	.byt 72
	.byt 80
	.byt 88
	.byt 96
	.byt 104
	.byt 112
	.byt 120
	.byt 128
	.byt 136
	.byt 144
	.byt 152
	.byt 160
	.byt 168
	.byt 176
	.byt 184
	.byt 192
	.byt 200
	.byt 208
	.byt 216
	.byt 224
	.byt 232
	.byt 240
	.byt 248
	.byt 0
	.byt 8
	.byt 16
	.byt 24
	.byt 32
	.byt 40
	.byt 48
	.byt 56
	.byt 64
	.byt 72
	.byt 80
	.byt 88
	.byt 96
	.byt 104
	.byt 112
	.byt 120
	.byt 128
	.byt 136
	.byt 144
	.byt 152
	.byt 160
	.byt 168
	.byt 176
	.byt 184
	.byt 192
	.byt 200
	.byt 208
	.byt 216
	.byt 224
	.byt 232
	.byt 240
	.byt 248
#endif

	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; COMMAND LISTS... WILL END UP SOMEWHERE ELSE?
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
command_list128		; Map Room - teacher
	.byt SC_GOTO, D_FIRE_ESCAPE				; Go to the fire escape
	.byt SC_GOTO, D_MAP_DOORWAY				; Go to the entrance of the room
	.byt SC_RESTIFNOLESSON					; Restart until it is time to start the lesson
	.byt SC_FLAGEVENT, E_TEACHER_MAP		; Signal that the teacher has arrived
	.byt SC_MSGSITDOWN						; Tell the kids to sit down
	.byt SC_GOTO, D_MAP_MAP					; Go to the teacher position
	.byt SC_GOTO, D_POS_MAP					; Go to the teacher position
	.byt SC_DOCLASS							; Wipe the board & conduct the class


command_list130		; Reading Room - teacher
	.byt SC_GOTO, D_LIBRARY_INT				; Go to the library
	.byt SC_GOTO, D_READING_DOORWAY			; Go to the entrance of the room
	.byt SC_RESTIFNOLESSON					; Restart until it is time to start the lesson
	.byt SC_FLAGEVENT, E_TEACHER_READING	; Signal that the teacher has arrived
	.byt SC_MSGSITDOWN						; Tell the kids to sit down
	.byt SC_GOTO, D_POS_READING1			; Go to the teacher position
	.byt SC_GOTO, D_POS_READING2			; Go to the teacher position
	.byt SC_DOCLASS							; Wipe the board & conduct the class

command_list132		; Exam Room - teacher
	.byt SC_GOTO, D_FIRE_ESCAPE				; Go to the fire escape
	.byt SC_GOTO, D_EXAM_DOORWAY			; Go to the entrance of the room
	.byt SC_RESTIFNOLESSON					; Restart until it is time to start the lesson
	.byt SC_FLAGEVENT, E_TEACHER_EXAM		; Signal that the teacher has arrived
	.byt SC_MSGSITDOWN						; Tell the kids to sit down
	.byt SC_GOTO, D_POS_EXAM				; Go to the teacher position
	.byt SC_DOCLASS							; Wipe the board & conduct the class


command_list134		; White Room - teacher
	.byt SC_GOTO, D_STAFF_ROOM				; Go to the staff room
	.byt SC_GOTO, D_WHITE_DOORWAY			; Go to the entrance of the room
	.byt SC_RESTIFNOLESSON					; Restart until it is time to start the lesson
	.byt SC_FLAGEVENT, E_TEACHER_WHITE		; Signal that the teacher has arrived
	.byt SC_MSGSITDOWN						; Tell the kids to sit down
	.byt SC_GOTO, D_ABOARD_WHITE			; Go to the spot right after the board
	.byt SC_GOTO, D_ABOARD1_WHITE			; Go to the spot just before
	.byt SC_DOCLASS							; Wipe the board & conduct the class

command_list136		; Map Room - Little boy
	.byt SC_GOTO, D_MAP_ROOM				; Go to the map room
	.byt SC_MOVEUNTIL, E_TEACHER_MAP		; Wait until teacher arrives
	.byt SC_FINDSEAT						; Find a seat and sit down
	; This continues in 136

command_list138		; Do nothing
	.byt SC_END								; Sit still

command_list140		; Map Room - BOY WANDER
	.byt SC_SETCONTSUB, CS_FIRECATAPULT		; Put a command making Boy Wander fire the catapult now and then
	.byt SC_GOTO, D_MAP_ROOM				; Go to the map room
	.byt SC_SETCONTSUB, CS_FIRECATAPULT		; Put a command making Boy Wander fire the catapult now and then
	.byt SC_MOVEUNTIL, E_TEACHER_MAP		; Move about until the teacher arrives
	.byt SC_FINDSEAT						; Find a seat and sit down
	.byt SC_END								; Sit still

command_list142		; Map Room - Angelface
	.byt SC_SETCONTSUB, CS_HITNOWTHEN		; Put a command making Angelface hit now & then
	.byt SC_GOTO, D_MAP_ROOM				; Go to the reading room
	.byt SC_SETCONTSUB, CS_HITNOWTHEN		; Put a command making Angelface hit now & then
	.byt SC_MOVEUNTIL, E_TEACHER_MAP		; Move about until the the teacher arrives
	.byt SC_FINDSEAT						; Find a seat and sit down
	.byt SC_END								; Sit still

command_list144		; Map room - EINSTEIN
	.byt SC_GOTO, D_MAP_ROOM				; Go to the end of the blackboard in the map room
	.byt SC_MOVEUNTIL, E_TEACHER_MAP		; Wait until teacher arrives
	.byt SC_FINDSEAT						; Find a seat and sit down
	.byt SC_CTRLEINSTEINCL1					; Grass & answer questions

command_list146		; Reading Room - Little boy
	.byt SC_GOTO, D_READING_ROOM			; Go to the reading room
	.byt SC_MOVEUNTIL, E_TEACHER_READING	; Wait until teacher arrives
	.byt SC_FINDSEAT						; Find a seat and sit down
	.byt SC_END								; Sit still

command_list148		; Reading Room - BOY WANDER
	.byt SC_SETCONTSUB, CS_FIRECATAPULT		; Put a command making Boy Wander fire the catapult now and then
	.byt SC_GOTO, D_READING_BOARD			; Go to the blackboard of the reading room
	.byt SC_WRITEBLCKBOARDC, E_TEACHER_READING	; Write there until the teacher arrives
	.byt SC_GOTO, D_READING_ROOM			; Go to the reading room
	.byt SC_SETCONTSUB, CS_FIRECATAPULT		; Put a command making Boy Wander fire the catapult now and then
	.byt SC_MOVEUNTIL, E_TEACHER_READING	; Move about until the teacher arrives
	.byt SC_FINDSEAT						; Find a seat and sit down
	.byt SC_END								; Sit still

command_list150		; Reading Room - Angelface
	.byt SC_SETCONTSUB, CS_HITNOWTHEN		; Put a command making Angelface hit now & then
	.byt SC_GOTO, D_READING_ROOM			; Go to the reading room
	.byt SC_SETCONTSUB, CS_HITNOWTHEN		; Put a command making Angelface hit now & then
	.byt SC_MOVEUNTIL, E_TEACHER_READING	; Move about until the the teacher arrives
	.byt SC_FINDSEAT						; Find a seat and sit down
	.byt SC_END								; Sit still


command_list152		; Reading room - EINSTEIN
	.byt SC_GOTO, D_READING_ROOM			; Go to the reading room
	.byt SC_MOVEUNTIL, E_TEACHER_READING	; Wait until teacher arrives
	.byt SC_FINDSEAT						; Find a seat and sit down
	.byt SC_CTRLEINSTEINCL1					; Grass & answer questions


command_list154		; Exam Room - Little boy
	.byt SC_GOTO, D_EXAM_ROOM				; Go to the exam room
	.byt SC_MOVEUNTIL, E_TEACHER_EXAM		; Wait until teacher arrives
	.byt SC_FINDSEAT						; Find a seat and sit down
	.byt SC_END								; Sit still

command_list156		; Exam Room - BOY WANDER
	.byt SC_SETCONTSUB, CS_FIRECATAPULT		; Put a command making Boy Wander fire the catapult now and then
	.byt SC_GOTO, D_EXAM_BOARD				; Go to the blackboard of the exam room
	.byt SC_WRITEBLCKBOARDC, E_TEACHER_EXAM	; Write there until the teacher arrives
	.byt SC_GOTO, D_EXAM_ROOM				; Go to the exam room
	.byt SC_SETCONTSUB, CS_FIRECATAPULT		; Put a command making Boy Wander fire the catapult now and then
	.byt SC_MOVEUNTIL, E_TEACHER_EXAM		; Move about until the teacher arrives
	.byt SC_FINDSEAT						; Find a seat and sit down
	.byt SC_END								; Sit still

command_list158		; Exam Room - Angelface
	.byt SC_SETCONTSUB, CS_HITNOWTHEN		; Put a command making Angelface hit now & then
	.byt SC_GOTO, D_EXAM_ROOM				; Go to the exam room
	.byt SC_SETCONTSUB, CS_HITNOWTHEN		; Put a command making Angelface hit now & then
	.byt SC_MOVEUNTIL, E_TEACHER_EXAM		; Move about until the the teacher arrives
	.byt SC_FINDSEAT						; Find a seat and sit down
	.byt SC_END								; Sit still


command_list160		; Exam room - EINSTEIN
	.byt SC_GOTO, D_EXAM_ROOM				; Go to the end of the blackboard in the exam room
	.byt SC_MOVEUNTIL, E_TEACHER_EXAM		; Wait until teacher arrives
	.byt SC_FINDSEAT						; Find a seat and sit down
	.byt SC_CTRLEINSTEINCL1					; Grass & answer questions


command_list162		; White Room - Little boy
	.byt SC_GOTO, D_WHITE_ROOM				; Go to the white room
	.byt SC_MOVEUNTIL, E_TEACHER_WHITE		; Wait until teacher arrives
	.byt SC_FINDSEAT						; Find a seat and sit down
	.byt SC_END								; Sit still

command_list164		; White Room - BOY WANDER
	.byt SC_SETCONTSUB, CS_FIRECATAPULT		; Put a command making Boy Wander fire the catapult now and then
	.byt SC_GOTO, D_WHITE_BOARD				; Go to the blackboard of the white room
	.byt SC_WRITEBLCKBOARDC, E_TEACHER_WHITE	; Write there until the teacher arrives
	.byt SC_GOTO, D_WHITE_ROOM				; Go to the white room
	.byt SC_SETCONTSUB, CS_FIRECATAPULT		; Put a command making Boy Wander fire the catapult now and then
	.byt SC_MOVEUNTIL, E_TEACHER_WHITE		; Move about until the teacher arrives
	.byt SC_FINDSEAT						; Find a seat and sit down
	.byt SC_END								; Sit still


command_list166		; White Room - Angelface
	.byt SC_SETCONTSUB, CS_HITNOWTHEN		; Put a command making Angelface hit now & then
	.byt SC_GOTO, D_WHITE_ROOM				; Go to the white room
	.byt SC_SETCONTSUB, CS_HITNOWTHEN		; Put a command making Angelface hit now & then
	.byt SC_MOVEUNTIL, E_TEACHER_WHITE		; Move about until the the teacher arrives
	.byt SC_FINDSEAT						; Find a seat and sit down
	.byt SC_END								; Sit still


command_list168		; White Room - EINSTEIN
	.byt SC_GOTO, D_WHITE_ROOM				; Go to the end of the blackboard in the white room
	.byt SC_MOVEUNTIL, E_TEACHER_WHITE	; Wait until teacher arrives
	.byt SC_FINDSEAT						; Find a seat and sit down
	.byt SC_CTRLEINSTEINCL1					; Grass & answer questions
	

command_list170		; Dinner Library - Einstein & little boys
	.byt SC_GOTO, D_DINNER_HALL				; Go to the dinner hall
	.byt SC_MOVEUNTIL, E_EMPTY				; Move about until the bell rings

command_list172		; Dinner - BOY WANDER
	.byt SC_SETCONTSUB, CS_FIRECATAPULT		; Put a command making Boy Wander fire the catapult now and then
	.byt SC_GOTO, D_DINNER_HALL				; Go to the dinner hall
	.byt SC_SETCONTSUB, CS_FIRECATAPULT		; Put a command making Boy Wander fire the catapult now and then
	.byt SC_MOVEUNTIL, E_EMPTY				; Move about until the bell rings

command_list174		; Dinner - ANGELFACE
	.byt SC_SETCONTSUB, CS_HITNOWTHEN		; Put a command making Angelface hit now & then
	.byt SC_GOTO, D_DINNER_HALL				; Go to the dinner hall
	.byt SC_SETCONTSUB, CS_HITNOWTHEN		; Put a command making Angelface hit now & then
	.byt SC_MOVEUNTIL, E_EMPTY				; Move about until the bell rings

command_list176		; Revision Library - Einstein & little boys
	.byt SC_GOTO, D_LIBRARY					; Go to the library
	.byt SC_MOVEUNTIL, E_EMPTY				; Move about until the bell rings

command_list178		; Revision Library - BOY WANDER
	.byt SC_SETCONTSUB, CS_FIRECATAPULT		; Put a command making Boy Wander fire the catapult now and then
	.byt SC_GOTO, D_LIBRARY					; Go to the library
	.byt SC_SETCONTSUB, CS_FIRECATAPULT		; Put a command making Boy Wander fire the catapult now and then
	.byt SC_MOVEUNTIL, E_EMPTY				; Move about until the bell rings

command_list180		; Revision Library - ANGELFACE
	.byt SC_SETCONTSUB, CS_HITNOWTHEN		; Put a command making Angelface hit now & then
	.byt SC_GOTO, D_LIBRARY					; Go to the library
	.byt SC_SETCONTSUB, CS_HITNOWTHEN		; Put a command making Angelface hit now & then
	.byt SC_MOVEUNTIL, E_EMPTY				; Move about until the bell rings

command_list182		; Walkabout - ANGELFACE
	.byt SC_SETCONTSUB, CS_HITNOWTHEN		; Put a command making Angelface hit now & then
	.byt SC_GOTORANDOM						; Go to a random location
	.byt SC_SETCONTSUB, CS_HITNOWTHEN		; Put a command making Angelface hit now & then
	.byt SC_WALKUPDOWN, 10,E_EMPTY			; Move about ten times
	.byt SC_RESTARTLIST						; Restart the command list

command_list184		; Dinner duty
	.byt SC_GOTO, D_DINNER_TABLE			; Go to the table in the dinner hall
	.byt SC_GOTO, D_DINNER_BENCH			; Go to the middle of the bench in the dinner hall
	.byt SC_RESTIFNODINNER					; Restart until dinner has started
	.byt SC_DINNERDUTY						; Perform dinner duty

command_list186		; Head's study - Mr. Wacker
	.byt SC_GOTO, D_HEAD_DOORWAY			; Go to the doorway of the head's study 
	.byt SC_MOVEUNTIL, E_EMPTY				; Move about until the bell rings

command_list188		; Staff-room - teacher
	.byt SC_GOTO, D_STAFF_ROOM				; Go to the staff room
	.byt SC_MOVEUNTIL, E_EMPTY				; Move about until the bell rings

command_list190		; Walkabout - teacher
	.byt SC_GOTO, D_HEAD_STUDY				; Go to the head's study (?)
	.byt SC_GOTORANDOM						; Then to a random location
	.byt SC_RESTARTLIST						; and repeat...

command_list192		; Write on the boards - BOY WANDER
	.byt SC_GOTO, D_EXAM_BOARD				; Go to the exam room board...
	.byt SC_WRITEBLCKBOARD					; ...  and write there
	.byt SC_GOTO, D_WHITE_BOARD				; Go to the exam room board...
	.byt SC_WRITEBLCKBOARD					; ...  and write there
	.byt SC_GOTO, D_READING_BOARD			; Go to the exam room board...
	.byt SC_WRITEBLCKBOARD					; ...  and write there
	; This continues in 194. The speccy version makes this continue on 192... (?)

command_list194			; Walkabout Boy Wander
	.byt SC_SETCONTSUB, CS_FIRECATAPULT		; Put a command making Boy Wander fire the catapult now and then
	.byt SC_GOTORANDOM						; Go to a random location
	.byt SC_SETCONTSUB, CS_FIRECATAPULT		; Put a command making Boy Wander fire the catapult now and then
	.byt SC_WALKUPDOWN, 10,E_EMPTY			; Move about ten times
	.byt SC_RESTARTLIST						; Restart the command list

command_list196			; Walkabout
	.byt SC_GOTORANDOM						; Go to a random location
	.byt SC_WALKUPDOWN, 10,E_EMPTY			; Move about ten times
	.byt SC_RESTARTLIST						; Restart the command list

command_list198			; Walk around the fire escape
	.byt SC_GOTO, D_FIRE_ESCAPE				; Go to the vincinity of the fire escape
	.byt SC_MOVEUNTIL, E_EMPTY				; Move about until the bell rings

command_list200			; Walk around the gym
	.byt SC_GOTO, D_GYM						; Go to the vincinity of the gym
	.byt SC_MOVEUNTIL, E_EMPTY				; Move about until the bell rings

command_list202			; Walk around the big window
	.byt SC_GOTO, D_BIG_WINDOW				; Go to the vincinity of the big window
	.byt SC_MOVEUNTIL, E_EMPTY				; Move about until the bell rings

command_list204			; Stampede - leader
	.byt SC_WALKUPDOWN,	40,E_EMPTY			; Move up&down 40 times
	.byt SC_FLAGEVENT, E_LITTLEBOY1_READY	; Flag little boy 1 is ready
	.byt SC_GOTORANDOMTRIP					; Go somewhere tripping people up on the way
	.byt SC_UNFLAGEVENT, E_LITTLEBOY1_READY	; Unflag little boy 1 is ready.
	.byt SC_WALKUPDOWN,	40,E_EMPTY			; Move up&down 40 times
	.byt SC_FLAGEVENT, E_LITTLEBOY1_READY2	; Flag little boy 1 is ready
	.byt SC_GOTORANDOMTRIP					; Go somewhere tripping people up on the way
	.byt SC_UNFLAGEVENT, E_LITTLEBOY1_READY2	; Unflag little boy 1 is ready.
	.byt SC_RESTARTLIST						; Restart the command list



command_list206			; Stampede - follower
	.byt SC_MOVEUNTIL, E_LITTLEBOY1_READY	; Move about until little boy 1 is ready
	.byt SC_FOLLOWBOY1TRIP					; Find and follow little boy 1
	.byt SC_MOVEUNTIL, E_LITTLEBOY1_READY2	; Move about until little boy 1 is ready
	.byt SC_FOLLOWBOY1TRIP					; Find and follow little boy 1
	.byt SC_RESTARTLIST						; Restart the command list

command_list208			; Tell ERIC about EINSTEIN or BOY WANDER (continues in 210)
	.byt SC_GOTO, D_GYM						; Go to the gym
	.byt SC_MOVEUNTIL, E_EINSTEIN_READY		; Move about until Einstein (or Boy Wander) ready
	.byt SC_MOVEUNTIL, E_WACKER_READY		; Move about until Mr Wacker is ready
	;;; This one does not end here, and continues into 210

command_list210			; Tell ERIC about ANGELFACE (also for Einstein and Boy Wander, beware)
	.byt SC_FINDERIC						; Find Eric
	.byt SC_TELLANGELFACE					; Tell him about Angelface's mumps
	.byt SC_FLAGEVENT, E_BEENTOLD_ANGELF	; Signal that he has been told
	.byt SC_GOTORANDOM						; Go to a random location
	.byt SC_MOVEUNTIL, E_EMPTY				; Move about until playtime is over

command_list212			; Grass on Eric
	.byt SC_GOTO,D_FIRE_ESCAPE				; Go to the far end of the fire escape
	.byt SC_FLAGEVENT, E_EINSTEIN_READY 	; Signal that Einstein is ready
	.byt SC_MOVEUNTIL, E_BEENTOLD_EINSTEIN	; Move about until Eric has been told about Einstein
	.byt SC_GOTO, D_HEAD_STUDY				; Go to inside the Head's study
	.byt SC_FLAGEVENT, E_EINSTEIN_GRASSED 	; Signal that Einstein grassed on Eric
	.byt SC_GOTORANDOM						; Go to a random location
	.byt SC_MOVEUNTIL, E_EMPTY				; Move about until playtime is over

command_list214			; Wait for Einstein to grass on Eric
	.byt SC_GOTO, D_HEAD_DOORWAY			; Go to the doorway of the Head's study
	.byt SC_FLAGEVENT, E_WACKER_READY		; Signal that Mr Wacker is ready
	.byt SC_MOVEUNTIL, E_EINSTEIN_GRASSED	; Move about until Einstein grassed on Eric
	.byt SC_SETCONTSUB, CS_WALKFAST			; Put a command making him walk fast
	.byt SC_FINDERIC						; Find Eric
	.byt SC_2000LINESERIC					; Give Eric 2000 lines
	.byt SC_MOVEUNTIL, E_EMPTY				; Move about until playtime is over


command_list216				; Collect the pea-shooter
	.byt SC_GOTO, D_LIBRARY_LEFT			; Go to the left end of the Revision Library
	.byt SC_FLAGEVENT, E_BOYW_READY			; Signal that Boy Wander is ready
	.byt SC_MOVEUNTIL, E_BEENTOLD_BOYW		; Move about until Eric has been told about Boy Wander
	.byt SC_SETCONTSUB, CS_FIRECATAPULT		; Put a command making Boy Wander fire the catapult now and then
	.byt SC_GOTO, D_FIRE_ESCAPE				; Go to the far end of the fire escape
	.byt SC_UNFLAGEVENT, E_BOYW_GOTPEA		; Signal that Boy wander has collected the pea-shooter
	.byt SC_GOTORANDOM						; Go to a random location
	.byt SC_MOVEUNTIL, E_EMPTY				; Move about until playtime is over

command_list218			; Look for the pea-shooter
	.byt SC_GOTO, D_READING_ENTRANCE		; Go to just inside the reading room
	.byt SC_FLAGEVENT, E_WACKER_READY		; Signal that Mr. Wacker is ready
	.byt SC_MOVEUNTIL, E_BEENTOLD_BOYW		; Move about until Eric has been told about Boy Wander
	.byt SC_SETCONTSUB, CS_WALKFAST			; Put the next command making Mr Wacker walk fast
	.byt SC_GOTO, D_FIRE_ESCAPE				; Go to the far end of the fire escape
	.byt SC_MOVEUNTIL, E_BOYW_GOTPEA		; Move about until Boy Wander collected the pea-shooter
	.byt SC_SETCONTSUB, CS_WALKFAST			; Put the next command making Mr Wacker walk fast
	.byt SC_FINDERIC						; Find Eric
	.byt SC_2000LINESERIC					; Give him 2000 lines
	.byt SC_GOTO, D_HEAD_DOORWAY			; Go to the doorway of the Head's study
	.byt SC_MOVEUNTIL, E_EMPTY				; Move about until playtime is over

command_list220			; Mumps walkabout
	.byt SC_SETCONTSUB, CS_CHECKTOUCH		; Put next command in Angelface's buffer which checks whether he is touching Eric
	.byt SC_GOTORANDOM						; Go to a random location
	.byt SC_RESTARTLIST						; Restart the command list

command_list222			; Mumps duty
	.byt SC_GOTO, D_STAFF_ROOM				; Go to the staff room
	.byt SC_MOVEUNTIL, E_ERIC_MUMPS			; Move about until Eric has mumps
endgame_command_list
	.byt SC_FINDERIC						; Find Eric
	.byt SC_ENDGAME							; Tell him to go home and end the game



; Buffer for lesson box
buffer_text
	.dsb BUFFER_TEXT_WIDTH*8,$40
	.dsb BUFFER_TEXT_WIDTH*8,$40
	.dsb BUFFER_TEXT_WIDTH*8,$40

; Temporary buffer for screen contents.
; Used when giving lines
temp_buffer
	.dsb BUFFER_TEXT_WIDTH*8,$40
	.dsb BUFFER_TEXT_WIDTH*8,$40
	.dsb BUFFER_TEXT_WIDTH*8,$40






