;SafePositions.s

RestoreHero2SafeZone
	ldx #00
.(
loop1	lda LevelID_SafePosition,x
	bmi skip3
	cmp LevelID
	bne skip2
	lda MapX_SafePosition,x
	cmp MapX
	beq skip1
skip2	inx
	jmp loop1
skip1	lda HeroX_SafePosition,x

	sta HeroX
	lda HeroY_SafePosition,x
	sta HeroY
	rts

skip3	;Couldn't find safe zone
;	lda #21
;	sta $A000
loop2	nop
	jmp loop2
.)
	
LevelID_SafePosition
 .byt 0		;00
 .byt 0             ;01
 .byt 0             ;02
 .byt 0             ;03
 .byt 0             ;04
 .byt 0             ;05
 .byt 0             ;06
 .byt 0             ;07
 .byt 0             ;08
 .byt 0             ;09
 .byt 0             ;10
 .byt 0             ;11
 .byt 0             ;12
 .byt 0             ;13
                       
 .byt 1             ;14
 .byt 1             ;15
 .byt 1             ;16
 .byt 1             ;17
 .byt 1             ;18
 .byt 1             ;19
 .byt 1             ;20
 .byt 1             ;21
 .byt 1             ;22
 .byt 1             ;23
 .byt 1             ;24
 .byt 1             ;25
 .byt 1             ;26
 
 .byt 2		;27
 .byt 2		;28
 .byt 2		;29
 .byt 2		;30
 .byt 2		;31
 .byt 2		;32
 .byt 2		;33
 .byt 2		;34
 .byt 2		;35
 .byt 2		;36
 .byt 2		;37
 .byt 2		;38
 .byt 2		;39
 .byt 2		;40
 .byt 2		;41
 .byt 2		;42
 .byt 2		;43
 .byt 2		;44
 .byt 255

MapX_SafePosition
 .byt $2A		;00
 .byt $1C 	;01
 .byt $0E 	;02
 .byt $00 	;03
 .byt $38 	;04
 .byt $46		;05
 .byt $7E 	;06
 .byt $70 	;07
 .byt $62 	;08
 .byt $54 	;09
 .byt $8C 	;10
 .byt $9A 	;11
 .byt $C4 	;12
 .byt $A8 	;13

 .byt $00           ;14
 .byt $1C           ;15
 .byt $46           ;16
 .byt $54           ;17
 .byt $62           ;18
 .byt $70           ;19
 .byt $7E           ;20
 .byt $8C           ;21
 .byt $9A           ;22
 .byt $A8           ;23
 .byt $B6           ;24
 .byt $C4           ;25
 .byt $D2           ;26

 .byt $0E		;27
 .byt $1C		;28
 .byt $2A		;29
 .byt $38		;30
 .byt $46		;31
 .byt $54		;32
 .byt $62		;33
 .byt $70		;34
 .byt $7E		;35
 .byt $8C		;36
 .byt $00		;37
 .byt $9A		;38
 .byt $A8		;39
 .byt $B6		;40
 .byt $C4		;41
 .byt $D2		;42
 .byt $E0		;43
 .byt $ED		;44
HeroX_SafePosition
 .byt $14           ;00
 .byt $1A           ;01
 .byt $18           ;02
 .byt $1A           ;03
 .byt $15           ;04
 .byt $0B		;05
 .byt $11           ;06
 .byt $1B           ;07
 .byt $16           ;08
 .byt $17           ;09
 .byt $08           ;10
 .byt $1B           ;11
 .byt $13           ;12
 .byt $09           ;13
                       
 .byt $1B           ;14
 .byt $03           ;15
 .byt $15           ;16
 .byt $08           ;17
 .byt $04           ;18
 .byt $08           ;19
 .byt $12           ;20
 .byt $21           ;21
 .byt $0A           ;22
 .byt $0A           ;23
 .byt $17           ;24
 .byt $14           ;25
 .byt $15           ;26

 .byt $1A		;27
 .byt $05		;28
 .byt $0C		;29
 .byt $10		;30
 .byt $08		;31
 .byt $08		;32
 .byt $03		;33
 .byt $09		;34
 .byt $05		;35
 .byt $03		;36
 .byt $07		;37
 .byt $06		;38
 .byt $05		;39
 .byt $07		;40
 .byt $0A		;41
 .byt $03		;42
 .byt $07		;43
 .byt $06		;44
HeroY_SafePosition
 .byt $5B           ;00
 .byt $37           ;01
 .byt $67           ;02
 .byt $67           ;03
 .byt $37           ;04
 .byt $67		;05
 .byt $67           ;06
 .byt $37           ;07
 .byt $1F           ;08
 .byt $67           ;09
 .byt $67           ;10
 .byt $67           ;11
 .byt $67           ;12
 .byt $67           ;13
                       
 .byt $67           ;14
 .byt $43           ;15
 .byt $2B           ;16
 .byt $43           ;17
 .byt $67           ;18
 .byt $67           ;19
 .byt $43           ;20
 .byt $43           ;21
 .byt $67           ;22
 .byt $43           ;23 <?
 .byt $67           ;24
 .byt $67           ;25
 .byt $67           ;26

 .byt $2B		;27
 .byt $2B		;28
 .byt $67		;29
 .byt $4F		;30
 .byt $4F		;31
 .byt $4F		;32
 .byt $43		;33
 .byt $43		;34
 .byt $1F		;35
 .byt $67		;36
 .byt $2B		;37
 .byt $67		;38
 .byt $67		;39
 .byt $1F		;40
 .byt $67		;41
 .byt $5B		;42
 .byt $43		;43
 .byt $67		;44
