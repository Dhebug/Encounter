;
; -------------------------------------------------------------------
; This is a simple display module
; called by the C part of the program
; We define the adress of the TEXT screen.

#define DISPLAY_ADRESS $BB80

; We use a table of bytes to avoid the multiplication 
; by 40. We could have used a multiplication routine
; but introducing table accessing is not a bad thing.
; In order to speed up things, we precompute the real
; adress of each start of line. Each table takes only
; 28 bytes, even if it looks impressive at first glance.
;
; This table contains lower 8 bits of the adress
TextAdressLow
	.byt <(DISPLAY_ADRESS+40*0)
	.byt <(DISPLAY_ADRESS+40*1)
	.byt <(DISPLAY_ADRESS+40*2)
	.byt <(DISPLAY_ADRESS+40*3)
	.byt <(DISPLAY_ADRESS+40*4)
	.byt <(DISPLAY_ADRESS+40*5)
	.byt <(DISPLAY_ADRESS+40*6)
	.byt <(DISPLAY_ADRESS+40*7)
	.byt <(DISPLAY_ADRESS+40*8)
	.byt <(DISPLAY_ADRESS+40*9)
	.byt <(DISPLAY_ADRESS+40*10)
	.byt <(DISPLAY_ADRESS+40*11)
	.byt <(DISPLAY_ADRESS+40*12)
	.byt <(DISPLAY_ADRESS+40*13)
	.byt <(DISPLAY_ADRESS+40*14)
	.byt <(DISPLAY_ADRESS+40*15)
	.byt <(DISPLAY_ADRESS+40*16)
	.byt <(DISPLAY_ADRESS+40*17)
	.byt <(DISPLAY_ADRESS+40*18)
	.byt <(DISPLAY_ADRESS+40*19)
	.byt <(DISPLAY_ADRESS+40*20)
	.byt <(DISPLAY_ADRESS+40*21)
	.byt <(DISPLAY_ADRESS+40*22)
	.byt <(DISPLAY_ADRESS+40*23)
	.byt <(DISPLAY_ADRESS+40*24)
	.byt <(DISPLAY_ADRESS+40*25)
	.byt <(DISPLAY_ADRESS+40*26)
	.byt <(DISPLAY_ADRESS+40*27)

; This table contains hight 8 bits of the adress
TextAdressHigh
	.byt >(DISPLAY_ADRESS+40*0)
	.byt >(DISPLAY_ADRESS+40*1)
	.byt >(DISPLAY_ADRESS+40*2)
	.byt >(DISPLAY_ADRESS+40*3)
	.byt >(DISPLAY_ADRESS+40*4)
	.byt >(DISPLAY_ADRESS+40*5)
	.byt >(DISPLAY_ADRESS+40*6)
	.byt >(DISPLAY_ADRESS+40*7)
	.byt >(DISPLAY_ADRESS+40*8)
	.byt >(DISPLAY_ADRESS+40*9)
	.byt >(DISPLAY_ADRESS+40*10)
	.byt >(DISPLAY_ADRESS+40*11)
	.byt >(DISPLAY_ADRESS+40*12)
	.byt >(DISPLAY_ADRESS+40*13)
	.byt >(DISPLAY_ADRESS+40*14)
	.byt >(DISPLAY_ADRESS+40*15)
	.byt >(DISPLAY_ADRESS+40*16)
	.byt >(DISPLAY_ADRESS+40*17)
	.byt >(DISPLAY_ADRESS+40*18)
	.byt >(DISPLAY_ADRESS+40*19)
	.byt >(DISPLAY_ADRESS+40*20)
	.byt >(DISPLAY_ADRESS+40*21)
	.byt >(DISPLAY_ADRESS+40*22)
	.byt >(DISPLAY_ADRESS+40*23)
	.byt >(DISPLAY_ADRESS+40*24)
	.byt >(DISPLAY_ADRESS+40*25)
	.byt >(DISPLAY_ADRESS+40*26)
	.byt >(DISPLAY_ADRESS+40*27)

;
; The message and display position will be read from the stack.
; sp+0 => X coordinate de 0 à 39
; sp+2 => Y coordinate de 0 à 27
; sp+4 => Adress of the message to display
;
; Initialise display adress
; this uses self-modifying code
; (the $0123 is replaced by display adress)	
; The idea is to get the Y position from the stack,
; and use it as an index in the two adress tables.
; We also need to add the value of the X position,
; also taken from the stack to the resulting value.
; -------------------------------------------------------------------
_TextPlot
.(	
	lda	$21F
	beq	looptxt
loophr
	ldy #2
	lda (sp),y				; Access Y coordinate
	tax
	cmp	#25					; Compare A (Y coordinate) a 25
	bmi looppixel			; Si Y < 25 alors affichage dans la zone Hires
loophrtxt					; Affichage dans la zone de texte (3 lignes 25 a 27)
	lda	HiresTextLow,x
	clc
	ldy	#0
	adc	(sp),y				; ajoute l'abscisse de l'affichage
	sta	textplotwrite+1
	lda	HiresTextHigh,x
	adc	#0
	sta	textplotwrite+2
	ldy	#4
	lda	(sp),y
	sta textplotread+1
	iny
	lda	(sp),y
	sta	textplotread+2
	ldx	#0
	jmp	textplot_loop
	rts
looppixel					; Affichage dans la zone pixel (lignes 0 a 24)
	rts
looptxt
	ldy #2
	lda (sp),y				; Access Y coordinate
	tax
	lda TextAdressLow,x		; Get the LOW part of the screen adress
	clc						; Clear the carry (because we will do an addition after)
	ldy #0
	adc (sp),y				; Add X coordinate
	sta textplotwrite+1
	lda TextAdressHigh,x	; Get the HIGH part of the screen adress
	adc #0					; Eventually add the carry to complete the 16 bits addition
	sta textplotwrite+2				
	; Initialise message adress using the stack parameter
	; this uses self-modifying code
	; (the $0123 is replaced by message adress)
	ldy #4
	lda (sp),y
	sta textplotread+1
	iny
	lda (sp),y
	sta textplotread+2
	; Start at the first character
	ldx #0
textplot_loop
	; Read the character, exit if it's a 0
textplotread
	lda $0123,x
	beq textplot_end
	; Write the character on screen
textplotwrite
	sta $0123,x
	; Next character, and loop
	inx
	jmp textplot_loop  
	; Finished !
textplot_end
	rts
.)

; ----------------------------------------------------------------
; Effacer l'ecran de $BB80 à $BFDF soit 1120 octets
; soit 4*256 + 96 octets
_TextClear
.(
	lda #0
	ldx #0
loop_x	
	sta DISPLAY_ADRESS+256*0,x
	sta DISPLAY_ADRESS+256*1,x
	sta DISPLAY_ADRESS+256*2,x
	sta DISPLAY_ADRESS+256*3,x
	sta DISPLAY_ADRESS+1120-256,x
	dex
	bne loop_x
	rts
.)

; -------------------------------------------------------------------
; Module de traitement des caracteres
; Adresse de la table de caracteres
#define CHAR_HIRES $9800
#define CHAR_TEXT $B400

;
; Copie des caracteres en zone CHAR_TEXT
; -------------------------------------------------------------------
_CharCopyText
.(
	ldx #0
loop_x	
	lda _Origa_Font+256*0,x
	sta CHAR_TEXT+32*8+256*0,x
	lda _Origa_Font+256*1,x
	sta CHAR_TEXT+32*8+256*1,x
	lda _Origa_Font+256*2,x
	sta CHAR_TEXT+32*8+256*2,x
	dex
	bne loop_x
	rts
.)

;
; Routine de recopie de la table de caracteres vers la table graphique CHAR_HIRES
; La table fait 96 caracteres de 8 octets soit 3*256 octets rendus 
; L'espace est ensuite libre
; -------------------------------------------------------------------
_CharCopyHires
.(
	ldx #0
loop_x	
	lda _Origa_Font+256*0,x
	sta CHAR_HIRES+32*8+256*0,x
	lda _Origa_Font+256*1,x
	sta CHAR_HIRES+32*8+256*1,x
	lda _Origa_Font+256*2,x
	sta CHAR_HIRES+32*8+256*2,x
	dex
	bne loop_x
	rts
.)
