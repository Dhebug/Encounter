
	.zero

_player_a_ptr				.dsb 2 		; Pointer to the next note
_player_a_sustain_delay		.dsb 1 		; How long is the sustain
_player_a_decay_delay		.dsb 1 		; How long is the decay
_player_a_freq				.dsb 2 		; The register values for the tone
_player_a_volume_base		.dsb 1 		; The volume we want (0=silence)


	.text

#define VIA_1				$30f
#define VIA_2				$30c


_Player_Initialize
.(
	; Make the chanel A point to the music
	lda #<_PlayerNotes
	sta _player_a_ptr+0
	lda #>_PlayerNotes
	sta _player_a_ptr+1

	; By default the player will read a note
	lda #<_Player_ReadNextNote
	sta _auto_A_CallBack+1
	lda #>_Player_ReadNextNote
	sta _auto_A_CallBack+2

	; Disable chanels B and C
	ldy #7
	ldx #%11111110
	jsr _Player_SetRegister

	rts
.)

_Player_Silence
.(
	; Disable all chanels
	ldy #7
	ldx #%11111111
	jsr _Player_SetRegister	
	rts
.)


_Player_PlayFrame
  ;jmp _Player_PlayFrame
.(
+_auto_A_CallBack
	jsr _Player_ReadNextNote	
	rts
.)

_Player_DoNothing
.(
	rts
.)


; _player_a_sustain_delay		.dsb 1 		; How long is the sustain
; _player_a_release_delay		.dsb 1 		; How long is the release
_Player_ReadNextNote
.(
	; Set the default duration of notes
	lda #1
	sta _player_a_sustain_delay
	sta _player_a_decay_delay

	lda #0
	sta _player_a_volume_base

	; Read a value
	ldy #0
	lda (_player_a_ptr),y
	bpl short_note
	cmp #255
	bne long_note
loop
	iny 
	lda (_player_a_ptr),y
	tax
	iny 
	lda (_player_a_ptr),y

	stx _player_a_ptr+0
	sta _player_a_ptr+1
	jmp _Player_ReadNextNote

long_note	
    ; Double the lenght of notes
    asl _player_a_sustain_delay
    asl _player_a_decay_delay
short_note	
	inc _player_a_ptr

	; Add the actual music tempo (increase the delay by two for ease of use)
    asl _player_a_sustain_delay
    asl _player_a_decay_delay

    asl _player_a_sustain_delay
    asl _player_a_decay_delay

    ;asl _player_a_sustain_delay
    ;asl _player_a_decay_delay

	; Remove the lenght bit and multiply by two (to access the word table)
    asl
    beq end_volume

	ldx #15
	stx _player_a_volume_base

end_volume

    ; Get the note value
	tay
	lda _YM_FREQUENCIES+0+2*12*2,y
    sta _player_a_freq+0
	lda _YM_FREQUENCIES+1+2*12*2,y
    sta _player_a_freq+1

	; Then we put on the SustainCode
	lda #<_Player_SustainNote
	sta _auto_A_CallBack+1
	lda #>_Player_SustainNote
	sta _auto_A_CallBack+2

	; Set tone on chanel A (will possibly be modulated at some point)
	ldy #0
	ldx _player_a_freq+0
	jsr _Player_SetRegister

	; Set tone on chanel A (will possibly be modulated at some point)
	ldy #1
	ldx _player_a_freq+1
	jsr _Player_SetRegister
	rts
.)

_Player_SustainNote
.(
	dec _player_a_sustain_delay
	beq end_sustain

	; Set volume on chanel A (will possibly be modulated at some point)
	ldy #8
	ldx _player_a_volume_base
	jsr _Player_SetRegister
	rts

end_sustain
	; Then we put on the wait
	lda #<_Player_DecayNote
	sta _auto_A_CallBack+1
	lda #>_Player_DecayNote
	sta _auto_A_CallBack+2

	rts
.)


_Player_DecayNote
.(
	dec _player_a_decay_delay
	beq end_decay

	ldx _player_a_volume_base
	beq skip_volume_glide
	dex
	stx _player_a_volume_base

	; Set volume on chanel A (will possibly be modulated at some point)
	ldy #8
	jsr _Player_SetRegister
skip_volume_glide
	rts

end_decay
	; Then we put on the wait
	lda #<_Player_ReadNextNote
	sta _auto_A_CallBack+1
	lda #>_Player_ReadNextNote
	sta _auto_A_CallBack+2

	rts
.)


; y=register
; x=value
_Player_SetRegister
.(
	sty	VIA_1
	txa

	pha
	lda	VIA_2
	ora	#$EE		; $EE	238	11101110
	sta	VIA_2

	and	#$11		; $11	17	00010001
	ora	#$CC		; $CC	204	11001100
	sta	VIA_2

	tax
	pla
	sta	VIA_1
	txa
	ora	#$EC		; $EC	236	11101100
	sta	VIA_2

	and	#$11		; $11	17	00010001
	ora	#$CC		; $CC	204	11001100
	sta	VIA_2

	rts
.)


;  1 DO
;  2    DO#
;  3 RE
;  4    RE#
;  5 MI
;  6 FA
;  7    FA#
;  8 SOL
;  9    SOL#
; 10 LA
; 11    LA#
; 12 SI

; ré ré mi ré sol faaaaaaaaaaaaaa dièse 
; ré ré mi ré la soooooooooooooool 
; ré ré ré (mais celui du dessus, sur la corde de la avec le 4ème doigt) si sol fa dièse mi miiiii 
; do do si sol la soooooooooooool

_Player_SetMusic_Xnitzy
.(
	sei
	lda #<_Xnitzy
	sta _player_a_ptr+0
	lda #>_Xnitzy
	sta _player_a_ptr+1	
	cli
	rts
.)

_Player_SetMusic_Birthday
.(
	sei
	lda #<_HappyBDay
	sta _player_a_ptr+0
	lda #>_HappyBDay
	sta _player_a_ptr+1	
	cli
	rts
.)

_PlayerNotes

_Xnitzy
 .byt 10,10,13,13
 .byt 10,10,13,13

 .byt 15,15,18,18
 .byt 15,15,18,18


 .byt 10,10,13,13
 .byt 10,10,13,13

 .byt 15,15,18,18
 .byt 15,15,18,18

 .byt 255,<_Xnitzy,>_Xnitzy

_HappyBDay
 .byt 3,3,5|128,3,0,8,0,7|128
 .byt 0
 .byt 3,3,5|128,3,0,10,0,8|128
 .byt 0
 .byt 3,3,3+12|128,12,0,8,0,7,5,5|128
 .byt 0
 .byt 1+12,1+12,12|128,8,0,10,0,8|128
 .byt 0

 .byt 255,<_HappyBDay,>_HappyBDay ; Loop





_YM_FREQUENCIES
  .word 1844
  .word 1740
  .word 1642
  .word 1550
  .word 1463
  .word 1381
  .word 1304
  .word 1230
  .word 1161
  .word 1096
  .word 1035
  .word 977
  .word 922
  .word 870
  .word 821
  .word 775
  .word 732
  .word 691
  .word 652
  .word 615
  .word 581
  .word 548
  .word 517
  .word 488
  .word 461
  .word 435
  .word 411
  .word 388
  .word 366
  .word 345
  .word 326
  .word 308
  .word 290
  .word 274
  .word 259
  .word 244
  .word 230
  .word 218
  .word 205
  .word 194
  .word 183
  .word 173
  .word 163
  .word 154
  .word 145
  .word 137
  .word 129
  .word 122
  .word 115
  .word 109
  .word 103
  .word 97
  .word 91
  .word 86
  .word 81
  .word 77
  .word 73
  .word 69
  .word 65
  .word 61
  .word 58
  .word 54
  .word 51
  .word 48
  .word 46
  .word 43
  .word 41
  .word 38
  .word 36
  .word 34
  .word 32
  .word 31
  .word 29
  .word 27
  .word 26
  .word 24
  .word 23
  .word 22
  .word 20
  .word 19
  .word 18
  .word 17
  .word 16
  .word 15
  .word 14
  .word 14
  .word 13
  .word 12
  .word 11
  .word 11
  .word 10
  .word 10
  .word 9
  .word 9
  .word 8
  .word 8
