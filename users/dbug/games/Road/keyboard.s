




;	en $ff y'a la valeur de la touche pressée
;	les valeurs en sortie ...
;	key_left=1,
;	key_left_up=5,
;	key_left_down=9,
;	key_right_up=6,
;	key_right_down=10,
;	key_right=2,
;	key_up=4,
;	key_down=8,
;	key_fire= 16



_ReadKeyboard
	lda #00
	sta $ff
	ldx #$df     ;left
	jsr setup_key
	beq rk_01
	lda $ff
	ora #1
	sta $ff
rk_01
	ldx #$7f	;right
	jsr setup_key
	beq rk_02
	lda $ff
	ora #2
	sta $ff
rk_02
	ldx #$f7	;up
	jsr setup_key
	beq rk_03
	lda $ff
	ora #4
	sta $ff
rk_03
	ldx #$bf	;down
	jsr setup_key
	beq rk_04
	lda $ff
	ora #8
	sta $ff
rk_04
	ldx #$fe	;fire
	jsr setup_key
	beq rk_05
	lda $ff
	ora #16
	sta $ff
rk_05
	lda $ff
	rts

setup_key
	;x=column a=row
	lda #04
	sta $300
	lda #$0e
	sta $30f
	lda #$ff
	sta $30c
	ldy #$dd
	sty $30c
	stx $30f
	lda #$fd
	sta $30c
	sty $30c
	lda $300
	and #08
	rts
