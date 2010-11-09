;TextHandler.s
;All characters are 6x6
;

;Parsed
;A Inverse alt row
;X Xpos (0-39)
;Y Ypos (0-194)
;line loc of text(null terminated)
;Most ascii characters supported
DisplayTextLine
	sta dt_InverseFlag
	txa
	jsr RecalcScreen
	
	lda #00
	sta dt_LineIndex
.(	
loop2	;Fetch character
	ldy dt_LineIndex
	lda (line),y
	
	;Branch if illegal or end
	beq EndOfText
	cmp #96
	bcs skip1
	cmp #32
	bcc skip1
	
	;Calc char address
	sbc #32
	asl
	sta dt_Temp01
	asl
	adc dt_Temp01
	sta vector1+1
	lda #00
	adc #00
	sta vector1+2
	lda vector1+1
	adc #<CharacterSet
	sta vector1+1
	lda vector1+2
	adc #>CharacterSet
	sta vector1+2
	
	;Display Character
	ldx #05
loop1
vector1	lda $dead,x
	ldy dt_InverseFlag
	beq skip2
	ldy dt_AltRowFlag,x
	beq skip2
	eor #63+128
skip2	ldy ScreenOffset,x
	sta (screen),y
	dex
	bpl loop1
	
skip1	;Update position
	inc dt_LineIndex
	inc screen
	bne skip3
	inc screen+1

skip3	;Loop
	jmp loop2
EndOfText	rts
.)	
	
	
dt_AltRowFlag
 .byt 0,1,0,1,0,1
	



CharacterSet	;58x6x6 (32-90)
Character32	;Space
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
Character33	;!
 .byt $50
 .byt $50
 .byt $58
 .byt $58
 .byt $40
 .byt $58
Character34	;Left Arrow
 .byt $48
 .byt $58
 .byt $7E
 .byt $7E
 .byt $58
 .byt $48
Character35	;Right Arrow
 .byt $48
 .byt $4C
 .byt $7E
 .byt $7E
 .byt $4C
 .byt $48
Character36	;Up Arrow
 .byt $4C
 .byt $5E
 .byt $7F
 .byt $4C
 .byt $4C
 .byt $4C
Character37	;Down Arrow
 .byt $4C
 .byt $4C
 .byt $4C
 .byt $7F
 .byt $5E
 .byt $4C
Character38	;x
 .byt %01110011
 .byt %01011110
 .byt %01001100
 .byt %01001100
 .byt %01011110
 .byt %01110011
Character39	;' - normal ink
 .byt 6
 .byt 3
 .byt 6
 .byt 3
 .byt 6
 .byt 3
; .byt $48
; .byt $4C
; .byt $4C
; .byt $40
; .byt $40
; .byt $40

Character40	;Solid Block -
 .byt %01111110
 .byt %01111110
 .byt %01111110
 .byt %01111110
 .byt %01111110
 .byt %01000000
Character41	;/
 .byt %01000000
 .byt %01000110
 .byt %01001100
 .byt %01011000
 .byt %01110000
 .byt %01000000
; .byt $5E
; .byt $6D
; .byt $7F
; .byt $73
; .byt $6D
; .byt $5E
Character42	;* - Security Terminal
 .byt $52
 .byt $4C
 .byt $7F
 .byt $4C
 .byt $52
 .byt $40
Character43	;+ Black ink
 .byt 0
 .byt 0
 .byt 0
 .byt 0
 .byt 0
 .byt 0
; .byt $48
; .byt $48
; .byt $7E
; .byt $48
; .byt $48
; .byt $40
Character44	;,
 .byt $40
 .byt $40
 .byt $40
 .byt $44
 .byt $44
 .byt $48
Character45	;-
 .byt $40
 .byt $40
 .byt $7E
 .byt $40
 .byt $40
 .byt $40
Character46	;.
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $4C
 .byt $4C
Character47	;Tick
 .byt %01000011
 .byt %01000011
 .byt %01000110
 .byt %01110110
 .byt %01011100
 .byt %01001100
Character48	;Numbers - Time,Resets,Security Terminal Number, etc.
 .byt $7E
 .byt $62
 .byt $62
 .byt $66
 .byt $66
 .byt $7E
Character49	;Numbers - Time,Resets,Security Terminal Number, etc.
 .byt $48
 .byt $48
 .byt $48
 .byt $58
 .byt $58
 .byt $58
Character50	;Numbers - Time,Resets,Security Terminal Number, etc.
 .byt $7E
 .byt $62
 .byt $42
 .byt $7E
 .byt $70
 .byt $7E
Character51	;Numbers - Time,Resets,Security Terminal Number, etc.
 .byt $7C
 .byt $64
 .byt $4E
 .byt $46
 .byt $66
 .byt $7E
Character52	;Numbers - Time,Resets,Security Terminal Number, etc.
 .byt $7C
 .byt $64
 .byt $64
 .byt $64
 .byt $7E
 .byt $4C
Character53	;Numbers - Time,Resets,Security Terminal Number, etc.
 .byt $7E
 .byt $60
 .byt $7E
 .byt $46
 .byt $66
 .byt $7E
Character54	;Numbers - Time,Resets,Security Terminal Number, etc.
 .byt $7E
 .byt $60
 .byt $7E
 .byt $66
 .byt $66
 .byt $7E
Character55	;Numbers - Time,Resets,Security Terminal Number, etc.
 .byt $7E
 .byt $42
 .byt $42
 .byt $46
 .byt $46
 .byt $46
Character56	;Numbers - Time,Resets,Security Terminal Number, etc.
 .byt $5C
 .byt $54
 .byt $7E
 .byt $66
 .byt $66
 .byt $7E
Character57	;Numbers - Time,Resets,Security Terminal Number, etc.
 .byt $7E
 .byt $62
 .byt $62
 .byt $7E
 .byt $46
 .byt $46
Character58	;Colon
 .byt $40
 .byt $48
 .byt $40
 .byt $40
 .byt $48
 .byt $40
Character59	;Semicolon FURNITURE E
 .byt $4F
 .byt $48
 .byt $6F
 .byt $6C
 .byt $6C
 .byt $6F

; .byt $40
; .byt $48
; .byt $40
; .byt $40
; .byt $48
; .byt $50
Character60	;< FURNITURE R
 .byt $57
 .byt $55
 .byt $57
 .byt $56
 .byt $56
 .byt $76
; .byt $40                                                   
; .byt $48
; .byt $50
; .byt $60
; .byt $50
; .byt $48
Character61	;= Security Terminal Cursor
 .byt $40
 .byt $40
 .byt $7E
 .byt $40
 .byt $7E
 .byt $40
Character62	;> Security Terminal Cursor
 .byt $40
 .byt $60
 .byt $50
 .byt $48
 .byt $50
 .byt $60
Character63	;?
 .byt $7E
 .byt $42
 .byt $7E
 .byt $70
 .byt $40
 .byt $70
Character64	;%
 .byt $72
 .byt $74
 .byt $48
 .byt $48
 .byt $56
 .byt $66
; .byt $5C
; .byt $62
; .byt $6A
; .byt $6E
; .byt $60
; .byt $5C
Character65	;A
 .byt $5C            ;.byt $5C
 .byt $54            ;.byt $62
 .byt $7E            ;.byt $7E
 .byt $72            ;.byt $62
 .byt $72            ;.byt $62
 .byt $72            ;.byt $62
Character66          ;
 .byt $7C            ;.byt $7C
 .byt $64            ;.byt $62
 .byt $7E            ;.byt $7C
 .byt $72            ;.byt $62
 .byt $72            ;.byt $62
 .byt $7E            ;.byt $7C
Character67          ;
 .byt $7E            ;.byt $5C
 .byt $62            ;.byt $62
 .byt $70            ;.byt $60
 .byt $70            ;.byt $60
 .byt $72            ;.byt $62
 .byt $7E            ;.byt $5C
Character68          ;
 .byt $7E            ;.byt $78
 .byt $62            ;.byt $64
 .byt $72            ;.byt $62
 .byt $72            ;.byt $62
 .byt $72            ;.byt $62
 .byt $7E            ;.byt $7C
Character69          ;
 .byt $7E            ;.byt $7E
 .byt $60            ;.byt $60
 .byt $7E            ;.byt $78
 .byt $70            ;.byt $60
 .byt $70            ;.byt $60
 .byt $7E            ;.byt $7E
Character70          ;
 .byt $7E            ;.byt $7E
 .byt $60            ;.byt $60
 .byt $7E            ;.byt $78
 .byt $70            ;.byt $60
 .byt $70            ;.byt $60
 .byt $70            ;.byt $60
Character71          ;
 .byt $7E            ;.byt $5C
 .byt $62            ;.byt $60
 .byt $70            ;.byt $66
 .byt $76            ;.byt $62
 .byt $72            ;.byt $62
 .byt $7E            ;.byt $5C
Character72          ;
 .byt $62            ;.byt $62
 .byt $62            ;.byt $62
 .byt $7E            ;.byt $7E
 .byt $72            ;.byt $62
 .byt $72            ;.byt $62
 .byt $72            ;.byt $62
Character73          ;
 .byt $50            ;.byt $7E
 .byt $50            ;.byt $48
 .byt $58            ;.byt $48
 .byt $58            ;.byt $48
 .byt $58            ;.byt $48
 .byt $58            ;.byt $7E
Character74          ;
 .byt $44            ;.byt $4E
 .byt $44            ;.byt $42
 .byt $46            ;.byt $42
 .byt $46            ;.byt $42
 .byt $66            ;.byt $62
 .byt $7E            ;.byt $5C
Character75          ;
 .byt $64            ;.byt $64
 .byt $64            ;.byt $68
 .byt $7E            ;.byt $70
 .byt $72            ;.byt $68
 .byt $72            ;.byt $64
 .byt $72            ;.byt $62
Character76          ;
 .byt $60            ;.byt $60
 .byt $60            ;.byt $60
 .byt $70            ;.byt $60
 .byt $70            ;.byt $60
 .byt $70            ;.byt $60
 .byt $7E            ;.byt $7E
Character77          ;
 .byt $7E            ;.byt $62
 .byt $6A            ;.byt $76
 .byt $6A            ;.byt $6A
 .byt $6A            ;.byt $62
 .byt $6A            ;.byt $62
 .byt $6A            ;.byt $62
Character78          ;
 .byt $7E            ;.byt $62
 .byt $62            ;.byt $72
 .byt $72            ;.byt $6A
 .byt $72            ;.byt $66
 .byt $72            ;.byt $62
 .byt $72            ;.byt $62
Character79          ;
 .byt $7E            ;.byt $5C
 .byt $66            ;.byt $62
 .byt $66            ;.byt $62
 .byt $62            ;.byt $62
 .byt $62            ;.byt $62
 .byt $7E            ;.byt $5C
Character80          ;
 .byt $7E            ;.byt $7C
 .byt $62            ;.byt $62
 .byt $7E            ;.byt $7C
 .byt $70            ;.byt $60
 .byt $70            ;.byt $60
 .byt $70            ;.byt $60
Character81          ;
 .byt $7E            ;.byt $5C
 .byt $62            ;.byt $62
 .byt $62            ;.byt $62
 .byt $62            ;.byt $6A
 .byt $6E            ;.byt $66
 .byt $7E            ;.byt $5E
Character82          ;
 .byt $7C            ;.byt $7C
 .byt $64            ;.byt $62
 .byt $7E            ;.byt $7C
 .byt $72            ;.byt $62
 .byt $72            ;.byt $62
 .byt $72            ;.byt $62
Character83          ;
 .byt $7E            ;.byt $5C
 .byt $60            ;.byt $60
 .byt $7E            ;.byt $5C
 .byt $46            ;.byt $42
 .byt $66            ;.byt $62
 .byt $7E            ;.byt $5C
Character84          ;
 .byt $7E            ;.byt $7E
 .byt $48            ;.byt $48
 .byt $4C            ;.byt $48
 .byt $4C            ;.byt $48
 .byt $4C            ;.byt $48
 .byt $4C            ;.byt $48
Character85          ;
 .byt $62            ;.byt $62
 .byt $62            ;.byt $62
 .byt $72            ;.byt $62
 .byt $72            ;.byt $62
 .byt $72            ;.byt $62
 .byt $7E            ;.byt $5C
Character86          ;
 .byt $72            ;.byt $62
 .byt $72            ;.byt $62
 .byt $72            ;.byt $54
 .byt $76            ;.byt $54
 .byt $54            ;.byt $48
 .byt $5C            ;.byt $48
Character87          ;
 .byt $6A            ;.byt $62
 .byt $6A            ;.byt $62
 .byt $6A            ;.byt $62
 .byt $6A            ;.byt $6A
 .byt $6A            ;.byt $76
 .byt $7E            ;.byt $62
Character88          ;
 .byt $62            ;.byt $62
 .byt $62            ;.byt $54
 .byt $5C            ;.byt $48
 .byt $72            ;.byt $48
 .byt $72            ;.byt $54
 .byt $72            ;.byt $62
Character89          ;
 .byt $61            ;.byt $62
 .byt $61            ;.byt $62
 .byt $7F            ;.byt $54
 .byt $4C            ;.byt $48
 .byt $4C            ;.byt $48
 .byt $4C            ;.byt $48
Character90          ;
 .byt $7E            ;.byt $7E
 .byt $42            ;.byt $44
 .byt $7E            ;.byt $48
 .byt $70            ;.byt $50
 .byt $72            ;.byt $60
 .byt $7E            ;.byt $7E
Character91	 ;91 to 95 for FURNITURE F
 .byt $7D
 .byt $61
 .byt $7D
 .byt $71
 .byt $71
 .byt $71
Character92	 ;91 to 95 for FURNITURE UR
 .byt $4B
 .byt $4A
 .byt $4B
 .byt $6B
 .byt $6B
 .byt $7B
Character93	 ;91 to 95 for FURNITURE N
 .byt $67
 .byt $64
 .byt $76
 .byt $56
 .byt $56
 .byt $56
Character94	 ;91 to 95 for FURNITURE I
 .byt $6B
 .byt $68
 .byt $6C
 .byt $6C
 .byt $6C
 .byt $6C
Character95	 ;91 to 95 for FURNITURE TU
 .byt $7A
 .byt $62
 .byt $73
 .byt $73
 .byt $73
 .byt $73
