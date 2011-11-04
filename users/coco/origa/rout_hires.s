
; -------------------------------------------------------------------
; This is a hires display module
; called by the C part of the program
; We define the adress of the HIRES screen.
;
#define HIRES_ADRESS $A000
#define HIRES_ADRESS_TXT $BF40

; Routine d'effacement de l'écran HIRES
; Effacer l'ecran de $A000 à $BF3F inclus soit 8000 octets
; soit 31*256 + 64 octets
; -------------------------------------------------------------------
_HiresClear
.(
	lda #$40	; pixel eteint
	ldx #0		; compteur de boucle a 256
loop_x	
	sta HIRES_ADRESS+256*0,x
	sta HIRES_ADRESS+256*1,x
	sta HIRES_ADRESS+256*2,x
	sta HIRES_ADRESS+256*3,x
	sta HIRES_ADRESS+256*4,x
	sta HIRES_ADRESS+256*5,x
	sta HIRES_ADRESS+256*6,x
	sta HIRES_ADRESS+256*7,x
	sta HIRES_ADRESS+256*8,x
	sta HIRES_ADRESS+256*9,x
	sta HIRES_ADRESS+256*10,x
	sta HIRES_ADRESS+256*11,x
	sta HIRES_ADRESS+256*12,x
	sta HIRES_ADRESS+256*13,x
	sta HIRES_ADRESS+256*14,x
	sta HIRES_ADRESS+256*15,x
	sta HIRES_ADRESS+256*16,x
	sta HIRES_ADRESS+256*17,x
	sta HIRES_ADRESS+256*18,x
	sta HIRES_ADRESS+256*19,x
	sta HIRES_ADRESS+256*20,x
	sta HIRES_ADRESS+256*21,x
	sta HIRES_ADRESS+256*22,x
	sta HIRES_ADRESS+256*23,x
	sta HIRES_ADRESS+256*24,x
	sta HIRES_ADRESS+256*25,x
	sta HIRES_ADRESS+256*26,x
	sta HIRES_ADRESS+256*27,x
	sta HIRES_ADRESS+256*28,x
	sta HIRES_ADRESS+256*29,x
	sta HIRES_ADRESS+256*30,x
	sta HIRES_ADRESS+8000-256,x
	dex
	bne loop_x
	rts
.)

;
; Effacement des 3 lignes de texte en bas de la zone HIRES soit de $BF40 à $BFDF 
; -------------------------------------------------------
_HiresClearText
.(
	lda #$0		; caractere noir
	ldx #120	; compteur de boucle a 120
loop_x	
	sta HIRES_ADRESS+8000-1,x
	dex
	bne loop_x
	rts
.)

; -------------------------------------------------------
; Copie d'une image écran vers l'ecran HIRES
; 8000/256=31.25
; Routine originale issue de l'intro de SPACE 1999, modifiée en Aout 2010
; par Didier (coco.oric) pour faire une copie d'écran complète du buffer vers l'écran HIRES
;
_ScreenCopyHires
.(
	ldx #0
loop_x	
	lda _Origa_Titre+256*0,x
	sta $a000+256*0,x
	lda _Origa_Titre+256*1,x
	sta $a000+256*1,x
	lda _Origa_Titre+256*2,x
	sta $a000+256*2,x
	lda _Origa_Titre+256*3,x
	sta $a000+256*3,x
	lda _Origa_Titre+256*4,x
	sta $a000+256*4,x
	lda _Origa_Titre+256*5,x
	sta $a000+256*5,x
	lda _Origa_Titre+256*6,x
	sta $a000+256*6,x
	lda _Origa_Titre+256*7,x
	sta $a000+256*7,x
	lda _Origa_Titre+256*8,x
	sta $a000+256*8,x
	lda _Origa_Titre+256*9,x
	sta $a000+256*9,x
	
	lda _Origa_Titre+256*10,x
	sta $a000+256*10,x
	lda _Origa_Titre+256*11,x
	sta $a000+256*11,x
	lda _Origa_Titre+256*12,x
	sta $a000+256*12,x
	lda _Origa_Titre+256*13,x
	sta $a000+256*13,x
	lda _Origa_Titre+256*14,x
	sta $a000+256*14,x
	lda _Origa_Titre+256*15,x
	sta $a000+256*15,x
	lda _Origa_Titre+256*16,x
	sta $a000+256*16,x
	lda _Origa_Titre+256*17,x
	sta $a000+256*17,x
	lda _Origa_Titre+256*18,x
	sta $a000+256*18,x
	lda _Origa_Titre+256*19,x
	sta $a000+256*19,x
	
	lda _Origa_Titre+256*20,x
	sta $a000+256*20,x
	lda _Origa_Titre+256*21,x
	sta $a000+256*21,x
	lda _Origa_Titre+256*22,x
	sta $a000+256*22,x
	lda _Origa_Titre+256*23,x
	sta $a000+256*23,x
	lda _Origa_Titre+256*24,x
	sta $a000+256*24,x
	lda _Origa_Titre+256*25,x
	sta $a000+256*25,x
	lda _Origa_Titre+256*26,x
	sta $a000+256*26,x
	lda _Origa_Titre+256*27,x
	sta $a000+256*27,x
	lda _Origa_Titre+256*28,x
	sta $a000+256*28,x
	lda _Origa_Titre+256*29,x
	sta $a000+256*29,x
	lda _Origa_Titre+256*30,x
	sta $a000+256*30,x
	dex
	beq end
	jmp loop_x
end
	ldx	#64
loop_x31
	lda _Origa_Titre-1+256*31,x
	sta $a000-1+256*31,x
	dex
	beq end_x31
	jmp	loop_x31
end_x31
	rts
.)

; Routine de passage en Hires mode sans ROM
; -------------------------------------------------------------------
_HiresLocal
.(
	lda	#$1E
	sta	$BFDF
	lda	#$1
	sta $21F					; ATMOS
	rts
.)

; Routine de passage en Text mode sans ROM
; -------------------------------------------------------------------
_TextLocal
.(
	lda	#$1A
	sta	$BFDF
	lda	#$0
	sta $21F					; ATMOS
	rts
.)


; -------------------------------------------------------------------	
; We use a table of bytes to avoid the multiplication 
; by x. We could have used a multiplication routine
; but introducing table accessing is not a bad thing.
; In order to speed up things, we precompute the real
; adress of each start of line. 
;
#define DISPLAY_HIRES $A000

; This table contains lower 8 bits of the adress
HiresTextLow
	.byt <(DISPLAY_HIRES+320*0)				; ligne 0
	.byt <(DISPLAY_HIRES+320*1)
	.byt <(DISPLAY_HIRES+320*2)
	.byt <(DISPLAY_HIRES+320*3)
	.byt <(DISPLAY_HIRES+320*4)
	.byt <(DISPLAY_HIRES+320*5)
	.byt <(DISPLAY_HIRES+320*6)
	.byt <(DISPLAY_HIRES+320*7)
	.byt <(DISPLAY_HIRES+320*8)
	.byt <(DISPLAY_HIRES+320*9)
	.byt <(DISPLAY_HIRES+320*10)
	.byt <(DISPLAY_HIRES+320*11)
	.byt <(DISPLAY_HIRES+320*12)
	.byt <(DISPLAY_HIRES+320*13)
	.byt <(DISPLAY_HIRES+320*14)
	.byt <(DISPLAY_HIRES+320*15)
	.byt <(DISPLAY_HIRES+320*16)
	.byt <(DISPLAY_HIRES+320*17)
	.byt <(DISPLAY_HIRES+320*18)
	.byt <(DISPLAY_HIRES+320*19)
	.byt <(DISPLAY_HIRES+320*20)
	.byt <(DISPLAY_HIRES+320*21)
	.byt <(DISPLAY_HIRES+320*22)
	.byt <(DISPLAY_HIRES+320*23)
	.byt <(DISPLAY_HIRES+320*24)
	.byt <(DISPLAY_HIRES+8000+40)			; ligne 25 (1ere ligne de texte réelle) à $A000 + 8000 + 40
	.byt <(DISPLAY_HIRES+8000+80)
	.byt <(DISPLAY_HIRES+8000+120)

; This table contains hight 8 bits of the adress
HiresTextHigh
	.byt >(DISPLAY_HIRES+320*0)
	.byt >(DISPLAY_HIRES+320*1)
	.byt >(DISPLAY_HIRES+320*2)
	.byt >(DISPLAY_HIRES+320*3)
	.byt >(DISPLAY_HIRES+320*4)
	.byt >(DISPLAY_HIRES+320*5)
	.byt >(DISPLAY_HIRES+320*6)
	.byt >(DISPLAY_HIRES+320*7)
	.byt >(DISPLAY_HIRES+320*8)
	.byt >(DISPLAY_HIRES+320*9)
	.byt >(DISPLAY_HIRES+320*10)
	.byt >(DISPLAY_HIRES+320*11)
	.byt >(DISPLAY_HIRES+320*12)
	.byt >(DISPLAY_HIRES+320*13)
	.byt >(DISPLAY_HIRES+320*14)
	.byt >(DISPLAY_HIRES+320*15)
	.byt >(DISPLAY_HIRES+320*16)
	.byt >(DISPLAY_HIRES+320*17)
	.byt >(DISPLAY_HIRES+320*18)
	.byt >(DISPLAY_HIRES+320*19)
	.byt >(DISPLAY_HIRES+320*20)
	.byt >(DISPLAY_HIRES+320*21)
	.byt >(DISPLAY_HIRES+320*22)
	.byt >(DISPLAY_HIRES+320*23)
	.byt >(DISPLAY_HIRES+320*24)
	.byt >(DISPLAY_HIRES+320*25+40)
	.byt >(DISPLAY_HIRES+320*25+80)
	.byt >(DISPLAY_HIRES+320*25+80)

_SetMurTop
.(
loop_x	
	lda _mur_top_24x7
	sta HIRES_ADRESS+256*0+0
	sta HIRES_ADRESS+256*0+4
	sta HIRES_ADRESS+256*0+8
	sta HIRES_ADRESS+256*0+12
	sta HIRES_ADRESS+256*0+16
	sta HIRES_ADRESS+256*0+20
	sta HIRES_ADRESS+256*0+24
	sta HIRES_ADRESS+256*0+28
	sta HIRES_ADRESS+256*0+32
	sta HIRES_ADRESS+256*0+36
	rts
.)
	
_SetMurBas
.(
	rts
.)