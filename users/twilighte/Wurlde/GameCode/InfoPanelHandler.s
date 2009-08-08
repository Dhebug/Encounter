;InfoPanelHandler.s

ManageTime
	;Delay Sunmoon interval
	lda SunMoonFrac
	clc
	adc #1
	sta SunMoonFrac
.(
	bcc skip1
	;Manage SunMoon
	dec SunMoonIndex
	bpl skip2
	lda #12
	sta SunMoonIndex
skip2	jsr UpdateSunMoon
	;Manage characters moving around here
;	jsr ManageCharacterMovements
	;Check for midnight
	lda SunMoonIndex
	cmp #1
	bne skip1
	;Process new day stuff
	jsr NewDayInitialisation
skip1	rts
.)

;A == Health to add(0-20)
IncreaseHealth
	clc
	adc HeroHealth
	cmp #20
.(
	bcc skip1
	lda #20
skip1	sta HeroHealth
.)
	jmp UpdateHealthBar


;A == Health to take away
DecreaseHealth
	sta temp01
	;On decreasing health, whiten hero momentarily
	lda #1
	sta HeroSpecialAppearance	
	
	lda HeroHealth
	sec
	sbc temp01
.(
	beq skip2
	bcs skip1
skip2	lda #01
skip1	sta HeroHealth
.)

;HeroHealth==Health Level 0-20
UpdateHealthBar
	lda #20
	sec
	sbc HeroHealth
	sta temp01
	ldx #20
.(
loop1	lda HealthScreenLo,x
	sta vector1+1
	lda HealthScreenHi,x
	sta vector1+2
	lda VoidBar,x
	cpx temp01
	bcc vector1
	lda HealthBar,x
vector1	sta $dead
	dex
	bpl loop1
.)
	rts

;HeroMana==Mana Level 0-20
UpdateManaBar
	ldx #20
.(
loop1	lda ManaScreenLo,x
	sta vector1+1
	lda ManaScreenHi,x
	sta vector1+2
	lda VoidBar,x
	cpx HeroMana
	bcc vector1
	lda ManaBar,x
vector1	sta $dead
	dex
	bpl loop1
.)
	rts

;For Hero Infopanel
; Carry set
;For Form
; Carry Clear
; CurrentCharacter holds Character 0-31 or 32 for hero
DisplayPockets
	;Set Info screen table vector flag
	ldy #00
.(
	bcs skip2
	;Set Form screen table vector flag
	iny
	;Default to character items
	lda #LS_HELDBYCREATURE
	ldx CurrentCharacter
	cpx #32
	bcc skip1
skip2     ;Hero Items
	lda #LS_HELDBYHERO
skip1	sta temp01
.)
	sty temp02

	ldx #00
	stx dpItemIndex
	stx dpObjectIndex
.(
loop1	ldx dpObjectIndex
	; Is object held?
	lda Objects_C,x
	bmi skip1	;InactiveItem
	and #15
	cmp temp01
	bne skip1

	; Are we talking Character items?
	lda temp01
	cmp #LS_HELDBYCREATURE
	bne skip2

	; Is object held by current character?
	lda Objects_A,x
	and #31
	cmp CurrentCharacter
	bne skip1

skip2	; Fetch the ObjectID
	lda Objects_B,x
	lsr
	lsr
	lsr

	; Fetch the Object Graphic loc
	tay
	lda ObjectGraphicLo,y
	sta source
	lda ObjectGraphicHi,y
	sta source+1

	; Fetch the screen location
	jsr LocateItemScreenLoc

	; Store to screen
	jsr DisplaySingleItem

	inc dpItemIndex
skip1	inc dpObjectIndex
	bpl loop1
.)
	; Have we any more pockets?
.(
loop2	lda dpItemIndex
	cmp #10
	bcs skip1

	;Empty remaining pockets
	jsr LocateItemScreenLoc

	; Store to screen
	ldx #10
loop1	ldy #00
	lda #64
	sta (screen),y
	iny
	sta (screen),y

	jsr nl_screen
	dex
	bne loop1

	inc dpItemIndex
	jmp loop2
skip1	;If hero pockets then display selected item description
	lda temp01
	cmp #LS_HELDBYHERO
	bne skip2
	jsr DisplayHeroItemText
skip2	rts
.)

DisplaySingleItem
	ldx #10
.(
loop1	ldy #00
	lda (source),y
	sta (screen),y
	iny
	lda (source),y
	sta (screen),y

	lda #2
	jsr add_source
	jsr nl_screen
	dex
	bne loop1
.)
	rts

LocateItemScreenLoc
	ldx dpItemIndex
	ldy temp02
.(
	beq skip1		;Info

	; Fetch Form items screen loc
	lda FormItemScreenAddressLo,x
	sta screen
	lda FormItemScreenAddressHi,x
	sta screen+1
	rts

skip1	; Fetch Info items screen loc
.)
	lda InfoItemScreenAddressLo,x
	sta screen
	lda InfoItemScreenAddressHi,x
	sta screen+1
	rts

FormItemScreenAddressLo
 .byt <$B3DB
 .byt <$B3DB+2*1
 .byt <$B3DB+2*2
 .byt <$B3DB+2*3
 .byt <$B3DB+2*4
 .byt <$B683
 .byt <$B683+2*1
 .byt <$B683+2*2
 .byt <$B683+2*3
 .byt <$B683+2*4
FormItemScreenAddressHi
 .byt >$B3DB
 .byt >$B3DB+2*1
 .byt >$B3DB+2*2
 .byt >$B3DB+2*3
 .byt >$B3DB+2*4
 .byt >$B683
 .byt >$B683+2*1
 .byt >$B683+2*2
 .byt >$B683+2*3
 .byt >$B683+2*4
InfoItemScreenAddressLo
 .byt <$A11C
 .byt <$A11E
 .byt <$A120
 .byt <$A122
 .byt <$A124
 .byt <$A374
 .byt <$A376
 .byt <$A378
 .byt <$A37A
 .byt <$A37C
InfoItemScreenAddressHi
 .byt >$A11C
 .byt >$A11E
 .byt >$A120
 .byt >$A122
 .byt >$A124
 .byt >$A374
 .byt >$A376
 .byt >$A378
 .byt >$A37A
 .byt >$A37C


dpItemIndex	.byt 0
dpObjectIndex	.byt 0

;Time of Day
SunMoonIndex	.byt 12
DayCounter	.byt 3

;A==Time of Day 0-12 (SunMoonIndex)
;	0		04.00
;	1		06.00
;	2		08.00
;	3		10.00
;    	4  Noon		12.00
;	5		13.30
;	6		15.00
;	7		16.30
;	8		18.00
;	9		20.00
;	10		22.00
;    	11 Midnight	00.00
;	12                  02.00
UpdateSunMoon
	ldx SunMoonIndex
	lda SunMoonGraphicLo,x
	sta source
	lda SunMoonGraphicHi,x
	sta source+1
	lda #<$A0E1
	sta screen
	lda #>$A0E1
	sta screen+1
	ldx #21
	clc
.(
loop2	ldy #10
loop1	lda (source),y
	sta (screen),y
	dey
	bpl loop1

	lda #11
	clc
	adc source
	sta source
	lda source+1
	adc #00
	sta source+1

	lda screen
	adc #40
	sta screen
	lda screen+1
	adc #00
	sta screen+1

	dex
	bne loop2
.)
	rts



SunMoonGraphicLo
 .byt <SunMoonGraphicFrame12
 .byt <SunMoonGraphicFrame11
 .byt <SunMoonGraphicFrame10
 .byt <SunMoonGraphicFrame09
 .byt <SunMoonGraphicFrame08
 .byt <SunMoonGraphicFrame07
 .byt <SunMoonGraphicFrame06
 .byt <SunMoonGraphicFrame05
 .byt <SunMoonGraphicFrame04
 .byt <SunMoonGraphicFrame03
 .byt <SunMoonGraphicFrame02
 .byt <SunMoonGraphicFrame01
 .byt <SunMoonGraphicFrame00
SunMoonGraphicHi
 .byt >SunMoonGraphicFrame12
 .byt >SunMoonGraphicFrame11
 .byt >SunMoonGraphicFrame10
 .byt >SunMoonGraphicFrame09
 .byt >SunMoonGraphicFrame08
 .byt >SunMoonGraphicFrame07
 .byt >SunMoonGraphicFrame06
 .byt >SunMoonGraphicFrame05
 .byt >SunMoonGraphicFrame04
 .byt >SunMoonGraphicFrame03
 .byt >SunMoonGraphicFrame02
 .byt >SunMoonGraphicFrame01
 .byt >SunMoonGraphicFrame00
SunMoonGraphicFrame00	;11x21 using Row redundancy (128==EOL)
 .byt $4A,$6A,$68,$5F,$7F,$7F,$63,$7F,$70,$40,$6A
 .byt $40,$40,$40,$40,$40,$07,$48,$40,$40,$40,$40
 .byt $55,$50,$5F,$7F,$7F,$7F,$63,$61,$7F,$70,$41
 .byt $40,$40,$40,$40,$40,$40,$06,$4C,$03,$40,$40
 .byt $4A,$4F,$7F,$7F,$7E,$4F,$7E,$41,$7F,$7F,$60
 .byt $40,$40,$40,$40,$01,$60,$06,$78,$03,$40,$40
 .byt $54,$71,$7F,$7F,$7E,$4F,$7C,$43,$7F,$7F,$78
 .byt $03,$44,$40,$40,$40,$06,$41,$78,$03,$40,$40
 .byt $48,$40,$47,$7F,$7F,$7F,$78,$43,$7F,$7F,$7C
 .byt $03,$5C,$70,$40,$40,$06,$43,$70,$03,$40,$40
 .byt $54,$40,$47,$7F,$7F,$7E,$48,$43,$7E,$4F,$7C
 .byt $03,$7F,$60,$40,$40,$06,$61,$78,$02,$60,$03
 .byt $48,$40,$47,$7F,$7F,$7E,$4C,$43,$7E,$4F,$7C
 .byt $03,$7F,$70,$40,$40,$40,$06,$78,$40,$40,$03
 .byt $54,$40,$41,$7F,$7F,$7F,$7E,$41,$7F,$7F,$78
 .byt $03,$7F,$7C,$40,$40,$40,$06,$4C,$40,$40,$03
 .byt $48,$40,$41,$7F,$7C,$40,$43,$61,$7F,$7F,$78
 .byt $03,$7F,$60,$40,$04,$56,$40,$40,$40,$40,$03
 .byt $54,$40,$47,$7E,$04,$7F,$40,$43,$7F,$7F,$71
 .byt $03,$5C,$70,$04,$45,$5F,$74,$40,$40,$40,$03
 .byt $4A,$40,$47,$04,$6A,$40,$6A,$40,$5F,$7F,$42
SunMoonGraphicFrame01
 .byt $4A,$6A,$68,$5F,$7F,$7F,$7F,$7F,$70,$40,$6A
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$03
 .byt $55,$50,$5F,$7F,$7F,$7F,$7F,$63,$7F,$70,$41
 .byt $40,$40,$40,$40,$40,$40,$07,$48,$40,$40,$03
 .byt $4A,$4F,$71,$7F,$7F,$7F,$7F,$63,$61,$7F,$60
 .byt $03,$40,$44,$40,$40,$40,$40,$06,$4C,$40,$03
 .byt $54,$70,$40,$47,$7F,$7E,$4F,$7E,$41,$7F,$78
 .byt $03,$46,$5C,$70,$40,$01,$60,$06,$78,$40,$03
 .byt $49,$70,$40,$47,$7F,$7E,$4F,$7C,$43,$7F,$7C
 .byt $03,$43,$7F,$60,$40,$40,$06,$41,$78,$40,$03
 .byt $55,$40,$40,$47,$7F,$7F,$7F,$78,$43,$7F,$7C
 .byt $03,$5F,$7F,$70,$40,$40,$06,$43,$70,$40,$03
 .byt $49,$40,$40,$41,$7F,$7F,$7E,$48,$43,$7E,$4C
 .byt $03,$47,$7F,$7C,$40,$40,$06,$61,$78,$02,$60
 .byt $54,$70,$40,$41,$7F,$7F,$7E,$4C,$43,$7E,$48
 .byt $03,$43,$7F,$60,$40,$40,$40,$06,$78,$40,$03
 .byt $48,$70,$40,$47,$7C,$40,$43,$7E,$41,$7F,$78
 .byt $03,$46,$5C,$70,$04,$56,$40,$06,$4C,$40,$03
 .byt $54,$50,$40,$46,$40,$7F,$40,$43,$61,$7F,$71
 .byt $03,$40,$50,$04,$45,$5F,$74,$40,$40,$40,$03
 .byt $4A,$47,$47,$40,$6A,$40,$6A,$40,$5F,$7F,$42
SunMoonGraphicFrame02
 .byt $4A,$6A,$68,$5F,$7F,$7F,$7F,$7F,$70,$40,$6A
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$03
 .byt $55,$50,$5F,$71,$7F,$7F,$7F,$7F,$7F,$70,$41
 .byt $40,$40,$03,$44,$40,$40,$40,$40,$40,$40,$03
 .byt $4A,$4F,$70,$40,$47,$7F,$7F,$7F,$63,$7F,$60
 .byt $40,$03,$46,$5C,$70,$40,$40,$07,$48,$40,$03
 .byt $54,$7F,$70,$40,$47,$7F,$7F,$7F,$63,$61,$78
 .byt $40,$03,$43,$7F,$60,$40,$40,$40,$06,$4C,$03
 .byt $49,$7F,$40,$40,$47,$7F,$7E,$4F,$7E,$41,$7C
 .byt $40,$03,$5F,$7F,$70,$40,$01,$60,$06,$78,$03
 .byt $54,$5F,$40,$40,$41,$7F,$7E,$4F,$7C,$43,$7C
 .byt $40,$03,$47,$7F,$7C,$40,$40,$06,$41,$78,$03
 .byt $48,$5F,$70,$40,$41,$7F,$7F,$7F,$78,$43,$7C
 .byt $40,$03,$43,$7F,$60,$40,$40,$06,$43,$70,$03
 .byt $54,$5F,$70,$40,$47,$7F,$7F,$7E,$48,$43,$78
 .byt $40,$03,$46,$5C,$70,$40,$40,$06,$61,$78,$40
 .byt $48,$7F,$70,$40,$44,$40,$43,$7E,$4C,$43,$78
 .byt $40,$03,$40,$50,$04,$56,$40,$40,$06,$78,$40
 .byt $54,$5F,$7F,$46,$40,$7F,$40,$43,$7E,$41,$71
 .byt $40,$40,$40,$04,$45,$5F,$74,$40,$06,$4C,$40
 .byt $4A,$47,$7F,$40,$6A,$40,$6A,$40,$5F,$61,$42
SunMoonGraphicFrame03
 .byt $4A,$6A,$68,$5F,$71,$7F,$7F,$7F,$70,$40,$6A
 .byt $40,$40,$40,$03,$44,$40,$40,$40,$40,$40,$40
 .byt $55,$50,$5F,$70,$40,$47,$7F,$7F,$7F,$70,$41
 .byt $40,$40,$03,$46,$5C,$70,$40,$40,$40,$40,$40
 .byt $4A,$4F,$7F,$70,$40,$47,$7F,$7F,$7F,$7F,$60
 .byt $40,$40,$03,$43,$7F,$60,$40,$40,$40,$40,$40
 .byt $54,$40,$7F,$40,$40,$47,$7F,$7F,$7F,$63,$78
 .byt $07,$6E,$03,$5F,$7F,$70,$40,$40,$07,$48,$40
 .byt $48,$40,$5F,$40,$40,$41,$7F,$7F,$7F,$63,$60
 .byt $07,$7F,$03,$47,$7F,$7C,$40,$40,$40,$06,$4C
 .byt $54,$40,$5F,$70,$40,$41,$7F,$7E,$4F,$7E,$40
 .byt $07,$7F,$03,$43,$7F,$60,$40,$01,$60,$06,$78
 .byt $48,$40,$5F,$70,$40,$47,$7F,$7E,$4F,$7C,$40
 .byt $07,$7C,$03,$46,$5C,$70,$40,$40,$06,$41,$78
 .byt $54,$41,$7F,$70,$40,$47,$7F,$7F,$7F,$78,$40
 .byt $40,$40,$40,$03,$50,$40,$40,$40,$06,$43,$70
 .byt $48,$7F,$7F,$7F,$44,$40,$43,$7F,$7E,$48,$40
 .byt $40,$40,$40,$04,$40,$56,$40,$40,$06,$61,$70
 .byt $54,$5F,$7F,$7E,$40,$7F,$40,$43,$7E,$4C,$41
 .byt $40,$40,$40,$04,$45,$5F,$74,$40,$40,$06,$60
 .byt $4A,$47,$7F,$40,$6A,$40,$6A,$40,$5F,$7F,$42
SunMoonGraphicFrame04
 .byt $4A,$6A,$68,$5F,$7F,$71,$7F,$7F,$70,$40,$6A
 .byt $40,$40,$40,$40,$03,$44,$40,$40,$40,$40,$40
 .byt $55,$50,$5F,$7F,$70,$40,$47,$7F,$7F,$70,$41
 .byt $40,$40,$40,$03,$46,$5C,$70,$40,$40,$40,$40
 .byt $4A,$4C,$40,$7F,$70,$40,$47,$7F,$7F,$7F,$60
 .byt $07,$41,$6E,$03,$43,$7F,$60,$40,$40,$40,$40
 .byt $54,$70,$40,$5F,$40,$40,$47,$7F,$7F,$7F,$78
 .byt $07,$47,$7F,$03,$5F,$7F,$70,$40,$40,$40,$40
 .byt $49,$70,$40,$5F,$40,$40,$41,$7F,$7F,$7F,$60
 .byt $07,$47,$7F,$03,$47,$7F,$7C,$40,$40,$07,$48
 .byt $55,$70,$40,$5F,$70,$40,$41,$7F,$7F,$7F,$60
 .byt $07,$40,$7C,$03,$43,$7F,$60,$40,$40,$40,$40
 .byt $49,$7E,$41,$7F,$70,$40,$47,$7F,$7E,$4F,$7C
 .byt $40,$40,$40,$03,$46,$5C,$70,$40,$01,$60,$40
 .byt $54,$7F,$7F,$7F,$70,$40,$47,$7F,$7E,$4F,$78
 .byt $40,$40,$40,$03,$40,$50,$40,$40,$40,$40,$40
 .byt $48,$7F,$7F,$7F,$7C,$40,$43,$7F,$7F,$7F,$78
 .byt $40,$40,$40,$04,$40,$56,$40,$40,$40,$40,$40
 .byt $54,$5F,$7F,$7E,$40,$7F,$40,$43,$7F,$7E,$41
 .byt $40,$40,$40,$04,$45,$5F,$74,$40,$40,$06,$60
 .byt $4A,$47,$7F,$40,$6A,$40,$6A,$40,$5F,$7E,$42
SunMoonGraphicFrame05
 .byt $4A,$6A,$68,$5F,$7F,$7F,$71,$7F,$70,$40,$6A
 .byt $40,$40,$40,$40,$03,$40,$44,$40,$40,$40,$40
 .byt $55,$50,$5C,$40,$7F,$70,$40,$47,$7F,$70,$41
 .byt $40,$07,$41,$6E,$03,$46,$5C,$70,$40,$40,$40
 .byt $4A,$4F,$70,$40,$5F,$70,$40,$47,$7F,$7F,$60
 .byt $40,$07,$47,$7F,$03,$43,$7F,$60,$40,$40,$40
 .byt $54,$7F,$70,$40,$5F,$40,$40,$47,$7F,$7F,$78
 .byt $40,$07,$47,$7F,$03,$5F,$7F,$70,$40,$40,$40
 .byt $49,$7F,$70,$40,$5F,$40,$40,$43,$7F,$7F,$7C
 .byt $40,$40,$07,$7C,$03,$47,$7F,$7C,$40,$40,$40
 .byt $55,$7F,$7E,$41,$7F,$70,$40,$43,$7F,$7F,$7C
 .byt $40,$40,$40,$40,$03,$43,$7F,$60,$40,$40,$40
 .byt $48,$4F,$7F,$7F,$7F,$70,$40,$47,$7F,$7F,$7C
 .byt $02,$60,$40,$40,$03,$46,$5C,$70,$40,$40,$40
 .byt $54,$4F,$7F,$7F,$7F,$70,$40,$47,$7F,$7E,$48
 .byt $40,$40,$40,$40,$40,$03,$50,$40,$40,$01,$60
 .byt $48,$7F,$7F,$7F,$7C,$40,$43,$7F,$7F,$7E,$48
 .byt $40,$40,$40,$40,$04,$56,$40,$40,$40,$40,$40
 .byt $54,$5F,$7F,$7E,$40,$7F,$40,$43,$7F,$7F,$71
 .byt $40,$40,$40,$04,$45,$5F,$74,$40,$40,$40,$40
 .byt $4A,$47,$7F,$40,$6A,$40,$6A,$40,$5F,$7F,$42
SunMoonGraphicFrame06
 .byt $4A,$6A,$68,$5F,$7F,$7F,$7F,$71,$70,$40,$6A
 .byt $40,$40,$40,$40,$40,$40,$03,$44,$40,$40,$40
 .byt $55,$50,$5F,$7C,$40,$7F,$70,$40,$47,$70,$41
 .byt $40,$40,$07,$41,$6E,$03,$46,$5C,$70,$40,$40
 .byt $4A,$4F,$7F,$70,$40,$5F,$70,$40,$47,$7F,$60
 .byt $40,$40,$07,$47,$7F,$03,$43,$7F,$60,$40,$40
 .byt $54,$7F,$7F,$70,$40,$5F,$40,$40,$47,$7F,$78
 .byt $40,$40,$07,$47,$7F,$03,$5F,$7F,$70,$40,$40
 .byt $49,$7F,$7F,$70,$40,$5F,$40,$40,$41,$7F,$7C
 .byt $40,$40,$07,$40,$7C,$03,$47,$7F,$7C,$40,$40
 .byt $55,$7E,$4F,$7E,$41,$7F,$70,$40,$41,$7F,$7C
 .byt $40,$02,$60,$40,$40,$03,$43,$7F,$60,$40,$40
 .byt $49,$7E,$4F,$7F,$7F,$7F,$70,$40,$47,$7F,$7C
 .byt $40,$40,$40,$40,$40,$03,$46,$5C,$70,$40,$40
 .byt $54,$7F,$7F,$7F,$7F,$7F,$70,$40,$47,$7F,$78
 .byt $40,$40,$40,$40,$40,$03,$40,$50,$40,$40,$40
 .byt $48,$7F,$7F,$7F,$7C,$40,$43,$47,$7F,$7F,$78
 .byt $40,$40,$40,$40,$04,$56,$40,$40,$40,$40,$40
 .byt $54,$5F,$7F,$7E,$40,$7F,$40,$43,$7F,$7F,$71
 .byt $40,$40,$40,$04,$45,$5F,$74,$40,$40,$40,$40
 .byt $4A,$47,$7F,$40,$6A,$40,$6A,$40,$5F,$7F,$42
SunMoonGraphicFrame07
 .byt $4A,$6A,$68,$5F,$7F,$7F,$7F,$7F,$70,$40,$6A
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
 .byt $55,$50,$5F,$7F,$7F,$7C,$40,$7F,$7F,$70,$41
 .byt $40,$40,$40,$40,$07,$41,$6E,$40,$40,$40,$40
 .byt $4A,$4F,$7F,$7F,$7F,$70,$40,$5F,$7F,$71,$60
 .byt $40,$40,$40,$40,$07,$47,$7F,$40,$03,$44,$40
 .byt $54,$61,$7F,$7F,$7F,$70,$40,$5F,$70,$40,$44
 .byt $06,$4C,$40,$40,$07,$47,$7F,$03,$46,$5C,$70
 .byt $48,$41,$7E,$4F,$7F,$70,$40,$5F,$70,$40,$44
 .byt $06,$78,$02,$60,$07,$40,$7C,$03,$43,$7F,$60
 .byt $54,$43,$7E,$4F,$7F,$7E,$41,$7F,$40,$40,$44
 .byt $06,$78,$40,$40,$40,$40,$40,$03,$5F,$7F,$70
 .byt $48,$43,$7F,$7F,$7F,$7F,$7F,$7F,$40,$40,$40
 .byt $06,$70,$40,$40,$40,$40,$40,$03,$47,$7F,$7C
 .byt $54,$43,$7F,$7F,$7F,$7F,$7F,$7F,$70,$40,$40
 .byt $06,$78,$40,$40,$40,$40,$40,$03,$43,$7F,$60
 .byt $48,$43,$7F,$7F,$7C,$40,$43,$7F,$70,$40,$40
 .byt $06,$58,$40,$40,$04,$56,$40,$03,$46,$5C,$70
 .byt $54,$41,$7F,$7E,$40,$7F,$40,$43,$70,$40,$41
 .byt $06,$44,$40,$04,$45,$5F,$74,$40,$03,$50,$40
 .byt $4A,$41,$7F,$40,$6A,$40,$6A,$40,$5F,$47,$42
SunMoonGraphicFrame08
 .byt $4A,$6A,$68,$5F,$7F,$7F,$7F,$7F,$70,$40,$6A
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
 .byt $55,$50,$5F,$7F,$7F,$7F,$7C,$40,$7F,$70,$41
 .byt $40,$40,$40,$40,$40,$07,$41,$6E,$40,$40,$40
 .byt $4A,$4F,$61,$7F,$7F,$7F,$70,$40,$5F,$7F,$60
 .byt $40,$06,$4C,$40,$40,$07,$47,$7F,$40,$40,$40
 .byt $54,$7E,$41,$7E,$4F,$7F,$70,$40,$5F,$7F,$70
 .byt $40,$06,$78,$02,$60,$07,$47,$7F,$40,$40,$40
 .byt $49,$7C,$43,$7E,$4F,$7F,$70,$40,$5F,$70,$40
 .byt $06,$41,$78,$40,$40,$07,$40,$7C,$03,$46,$5C
 .byt $55,$78,$43,$7F,$7F,$7F,$7E,$41,$7F,$70,$40
 .byt $06,$43,$70,$40,$40,$40,$40,$40,$03,$43,$7C
 .byt $48,$48,$43,$7F,$7F,$7F,$7F,$7F,$7F,$40,$40
 .byt $06,$61,$78,$40,$40,$40,$40,$40,$03,$5F,$7C
 .byt $54,$4C,$43,$7F,$7F,$7F,$7F,$7F,$7F,$40,$40
 .byt $06,$40,$78,$40,$40,$40,$40,$40,$03,$47,$78
 .byt $48,$7E,$41,$7F,$7C,$40,$43,$7F,$7F,$70,$40
 .byt $06,$40,$4C,$04,$40,$56,$40,$40,$03,$43,$78
 .byt $54,$5F,$61,$7E,$40,$7F,$40,$43,$7F,$70,$41
 .byt $06,$40,$40,$04,$45,$5F,$74,$40,$03,$46,$50
 .byt $4A,$47,$7F,$40,$6A,$40,$6A,$40,$5F,$70,$42
SunMoonGraphicFrame09
 .byt $4A,$6A,$68,$5F,$7F,$7F,$7F,$7F,$70,$40,$6A
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
 .byt $55,$50,$5F,$61,$7F,$7F,$7F,$7F,$7F,$70,$41
 .byt $40,$40,$06,$4C,$40,$40,$40,$40,$40,$40,$40
 .byt $4A,$4F,$7E,$41,$7F,$7F,$7F,$7C,$40,$7F,$60
 .byt $40,$40,$06,$78,$40,$40,$07,$41,$6E,$40,$40
 .byt $54,$5F,$7C,$43,$7E,$4F,$7F,$70,$40,$5F,$78
 .byt $40,$06,$41,$78,$02,$60,$07,$47,$7F,$40,$40
 .byt $49,$7F,$78,$43,$7E,$4F,$7F,$70,$40,$5F,$7C
 .byt $40,$06,$43,$70,$40,$40,$07,$47,$7F,$40,$40
 .byt $55,$7E,$48,$43,$7F,$7F,$7F,$70,$40,$5F,$70
 .byt $40,$06,$61,$78,$40,$40,$07,$40,$7C,$03,$44
 .byt $49,$7E,$4C,$43,$7F,$7F,$7F,$7E,$41,$7F,$70
 .byt $40,$06,$40,$78,$40,$40,$40,$40,$40,$40,$40
 .byt $54,$7F,$7E,$41,$7F,$7F,$7F,$7F,$7F,$7F,$40
 .byt $40,$40,$06,$4C,$40,$40,$40,$40,$40,$03,$58
 .byt $48,$7F,$7F,$61,$7C,$40,$43,$7F,$7F,$7F,$40
 .byt $40,$40,$40,$04,$40,$56,$40,$40,$40,$40,$40
 .byt $54,$5F,$7F,$7E,$40,$7F,$40,$43,$7F,$7F,$71
 .byt $40,$40,$40,$04,$45,$5F,$74,$40,$40,$40,$40
 .byt $4A,$47,$7F,$40,$6A,$40,$6A,$40,$5F,$7F,$42
SunMoonGraphicFrame10
 .byt $4A,$6A,$68,$43,$61,$7F,$7F,$7F,$70,$40,$6A
 .byt $40,$40,$40,$06,$4C,$40,$40,$40,$40,$40,$40
 .byt $55,$50,$4F,$7E,$41,$7F,$7F,$7F,$7F,$70,$41
 .byt $40,$01,$60,$06,$78,$40,$40,$40,$40,$40,$40
 .byt $4A,$4E,$4F,$7C,$43,$7F,$7F,$7F,$7F,$7F,$60
 .byt $40,$40,$06,$41,$78,$40,$40,$40,$40,$40,$40
 .byt $54,$5F,$7F,$78,$43,$7F,$7F,$7F,$7C,$40,$78
 .byt $40,$40,$06,$43,$70,$40,$40,$07,$41,$6E,$40
 .byt $49,$7F,$7E,$48,$43,$7E,$4F,$7F,$70,$40,$5C
 .byt $40,$40,$06,$61,$78,$02,$60,$07,$47,$7F,$40
 .byt $55,$7F,$7E,$4C,$43,$7E,$4F,$7F,$70,$40,$5C
 .byt $40,$40,$06,$40,$78,$40,$40,$07,$47,$7F,$40
 .byt $49,$7F,$7F,$7E,$41,$7F,$7F,$7F,$70,$40,$5C
 .byt $40,$40,$40,$06,$4C,$40,$40,$07,$40,$7C,$40
 .byt $54,$7F,$7F,$7F,$61,$7F,$7F,$7F,$7E,$41,$78
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
 .byt $48,$7F,$7F,$7F,$7C,$40,$43,$7F,$7F,$7F,$78
 .byt $40,$40,$40,$04,$40,$56,$40,$40,$40,$40,$40
 .byt $54,$5F,$7F,$7E,$40,$7F,$40,$43,$7F,$7F,$71
 .byt $40,$40,$40,$04,$45,$5F,$74,$40,$40,$40,$40
 .byt $4A,$47,$7F,$40,$6A,$40,$6A,$40,$5F,$7F,$42
SunMoonGraphicFrame11
 .byt $4A,$6A,$68,$5F,$63,$61,$7F,$7F,$70,$40,$6A
 .byt $40,$40,$40,$40,$06,$4C,$40,$40,$40,$40,$40
 .byt $55,$50,$5E,$4F,$7E,$41,$7F,$7F,$7F,$70,$41
 .byt $40,$40,$01,$60,$06,$78,$40,$40,$40,$40,$40
 .byt $4A,$4F,$7E,$4F,$7C,$43,$7F,$7F,$7F,$7F,$60
 .byt $40,$40,$40,$06,$41,$78,$40,$40,$40,$40,$40
 .byt $54,$5F,$7F,$7F,$78,$43,$7F,$7F,$7F,$7F,$78
 .byt $40,$40,$40,$06,$43,$70,$40,$40,$40,$40,$40
 .byt $49,$7F,$7F,$7E,$48,$43,$7E,$4F,$7F,$7C,$40
 .byt $40,$40,$40,$06,$61,$78,$02,$60,$07,$41,$6C
 .byt $55,$7F,$7F,$7E,$4C,$43,$7E,$4F,$7F,$70,$40
 .byt $40,$40,$40,$06,$40,$78,$40,$40,$07,$47,$7C
 .byt $49,$7F,$7F,$7F,$7E,$41,$7F,$7F,$7F,$70,$40
 .byt $40,$40,$40,$06,$40,$4C,$40,$40,$07,$47,$78
 .byt $54,$7F,$7F,$7F,$7F,$61,$7F,$7F,$7F,$70,$40
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$07,$40,$78
 .byt $48,$7F,$7F,$7F,$7C,$40,$43,$7F,$7F,$7E,$40
 .byt $40,$40,$40,$04,$40,$56,$40,$40,$40,$40,$40
 .byt $54,$5F,$7F,$7E,$40,$7F,$40,$43,$7F,$7F,$71
 .byt $40,$40,$40,$04,$45,$5F,$74,$40,$40,$40,$40
 .byt $4A,$47,$7F,$40,$6A,$40,$6A,$40,$5F,$7F,$42
SunMoonGraphicFrame12
 .byt $4A,$6A,$68,$5F,$7F,$63,$61,$7F,$70,$40,$6A
 .byt $40,$40,$40,$40,$40,$06,$4C,$40,$40,$40,$40
 .byt $55,$50,$5F,$7E,$4F,$7E,$41,$7F,$7F,$70,$41
 .byt $40,$40,$40,$01,$60,$06,$78,$40,$40,$40,$40
 .byt $4A,$4F,$7F,$7E,$4F,$7C,$43,$7F,$7F,$7F,$60
 .byt $40,$40,$40,$40,$06,$41,$78,$40,$40,$40,$40
 .byt $54,$5F,$7F,$7F,$7F,$78,$43,$7F,$7F,$7F,$78
 .byt $40,$40,$40,$40,$06,$43,$70,$40,$40,$40,$40
 .byt $48,$47,$7F,$7F,$7E,$48,$43,$7E,$4F,$7F,$7C
 .byt $03,$70,$40,$40,$06,$61,$78,$02,$60,$40,$40
 .byt $54,$47,$7F,$7F,$7E,$4C,$43,$7E,$4F,$7F,$70
 .byt $03,$60,$40,$40,$40,$06,$78,$40,$40,$07,$44
 .byt $48,$47,$7F,$7F,$7F,$7E,$41,$7F,$7F,$7F,$70
 .byt $03,$70,$40,$40,$40,$06,$4C,$40,$40,$40,$40
 .byt $54,$43,$7F,$7F,$7F,$7F,$61,$7F,$7F,$7F,$78
 .byt $03,$7C,$40,$40,$40,$40,$40,$40,$40,$40,$40
 .byt $48,$43,$7F,$7F,$7C,$40,$43,$7F,$7F,$7F,$78
 .byt $03,$60,$40,$40,$04,$56,$40,$40,$40,$40,$40
 .byt $54,$4F,$7F,$7E,$40,$7F,$40,$43,$7F,$7F,$71
 .byt $40,$40,$40,$04,$45,$5F,$74,$40,$40,$40,$40
 .byt $4A,$47,$7F,$40,$6A,$40,$6A,$40,$5F,$7F,$42

DisplayHeroItemText
	; Locate Objects index for selected item
	sec
	jsr LocateObjectForSelectedItem
	cpx #128
.(
	bcc skip1

	; Object does not exist so display space
	lda #128
	jmp skip2

skip1	; Fetch ObjectID
	lda Objects_B,x
	lsr
	lsr
	lsr

skip2	; Locate Object block
.)
	tay
	lda #0
	ldx #0+128
	jmp DisplayBlockField
;A WindowID (+128 to clear to end of window)
;X Field in Text(0 or 1) (+128 for non embedded single word like Grotes or Form Group)
;Y TextID (0-159)


UpdateMapPosition
	; Delete bit
	lda mapScreenLo
.(
	sta vector1+1
	lda mapScreenHi
	sta vector1+2
	lda mapOriginalByte
vector1	sta $dead
.)
	; Fetch new position
	ldx ScreenID
	lda mapNewScreenLo,x
	sta mapScreenLo
	lda mapNewScreenHi,x
	sta mapScreenHi
	lda mapNewByte,x
	sta mapOriginalByte
	lda mapNewBitpos,x
	sta mapBitpos

	rts

AnimateMapPosition
	lda mapFrac
	clc
	adc #64
	sta mapFrac
.(
	bcc skip1
	lda mapScreenLo
	sta screen
	lda mapScreenHi
	sta screen+1
	ldy #00
	lda (screen),y
	eor mapBitpos
	sta (screen),y
skip1	rts
.)

mapFrac		.byt 0
mapScreenLo	.byt <$A3D5
mapScreenHi	.byt >$A3D5
mapOriginalByte	.byt $5A
mapBitpos	.byt 1

mapNewScreenLo	;Indexed by ScreenID
 .byt <$A3D5
 .byt <$A3D6
 .byt <$A3D6
 .byt <$A3D6
 .byt <$A3D6
 .byt <$A386
 .byt <$A386
mapNewScreenHi
 .byt >$A3D5
 .byt >$A3D6
 .byt >$A3D6
 .byt >$A3D6
 .byt >$A3D6
 .byt >$A386
 .byt >$A386
mapNewByte
 .byt $5A
 .byt $7F
 .byt $7F
 .byt $7F
 .byt $7F
 .byt $6F
 .byt $6F
mapNewBitpos
 .byt 1
 .byt 32
 .byt 16
 .byt 8
 .byt 4
 .byt 2
 .byt 1




;Map X == 0-50
;Map Y == 0-12

GremlinFrac		.byt 0
LeftHandAction		.byt 128
RightHandAction		.byt 128
LeftHandIndex		.byt 3
RightHandIndex		.byt 3
HeadAction		.byt 0

UpdateGremlin
	lda GremlinFrac
	clc
	adc #128
	sta GremlinFrac
	bcs Proc_LeftHand
	rts
Proc_LeftHand
	;LeftHandAction
	;0 Exit
	;4 Tapping
	;128 Normal
	ldx #04
	lda LeftHandAction
.(
	bmi skip3
	dec LeftHandIndex
	bpl skip1
	lda #03
	sta LeftHandIndex
skip1   lda LeftHandIndex
	clc
	adc LeftHandAction
	tax
skip3	lda GremlinLeftHandFrameAddressLo,x
	sta vector1+1
	lda GremlinLeftHandFrameAddressHi,x
	sta vector1+2
	;RightHandAction
	;0 Exit
	;4 Tapping
	;128 Normal
	ldx #04
	lda RightHandAction
	bmi skip4
	dec RightHandIndex
	bpl skip5
	lda #03
	sta RightHandIndex
skip5   lda RightHandIndex
	clc
	adc RightHandAction
	tax
skip4	lda GremlinRightHandFrameAddressLo,x
	sta vector2+1
	lda GremlinRightHandFrameAddressHi,x
	sta vector2+2

	;Display hands
	ldx #11
loop1   ldy ScreenOffset3xH,x
vector1	lda $dead,x
	sta $B9D8+40,y
vector2	lda $dead,x
	sta $B9DD+40,y
	dex
	bpl loop1
.)
ProcHead
	;Skull follows hero - Use 40 byte table that contains pointer to Skull Frame
	ldx HeroX
	ldy SkullsHeadFollowHero,x
	lda SkullRotationFrames,y
	sta $B9DC+40*1
	;This row is always the eyes, so modify by glow state
	ldx HeadAction	;0 or 1
	lda EyeColour,x
	sta $BA03+40
	lda SkullRotationFrames+1,y
	cpx #01
.(
	bcc skip1
	ora #128
skip1	sta $B9DC+40*2
.)
	lda SkullRotationFrames+2,y
	sta $B9DC+40*3
	lda SkullRotationFrames+3,y
	sta $B9DC+40*4
	lda SkullRotationFrames+4,y
	sta $B9DC+40*5
	lda SkullRotationFrames+5,y
	sta $B9DC+40*6
	lda SkullRotationFrames+6,y
	sta $B9DC+40*7
	rts
EyeColour
 .byt 1,6
SkullRotationFrames
 .byt %01111110
 .byt %01010111
 .byt %01101110
 .byt %01111000
 .byt %01000011
 .byt %01111000
 .byt %01000001

 .byt %01011110
 .byt %01101011
 .byt %01110111
 .byt %01011100
 .byt %01000001
 .byt %01011100
 .byt %01000001

 .byt %01011110
 .byt %01101011
 .byt %01110111
 .byt %01011110
 .byt %01000000
 .byt %01011110
 .byt %01000000

 .byt %01011110
 .byt %01110101
 .byt %01111011
 .byt %01001110
 .byt %01100000
 .byt %01001110
 .byt %01000000

 .byt %01011111
 .byt %01111010
 .byt %01111101
 .byt %01001111
 .byt %01100000
 .byt %01000111
 .byt %01010000

SkullsHeadFollowHero
 .dsb 10,0
 .dsb 5,7*1
 .dsb 10,7*2
 .dsb 5,7*3
 .dsb 10,7*4


GremlinHead

GremlinLeftHandFrameAddressLo
 .byt <GremlinLeftHandPointing0
 .byt <GremlinLeftHandPointing1
 .byt <GremlinLeftHandPointing2
 .byt <GremlinLeftHandPointing2
 .byt <GremlinLeftHandNormal
 .byt <GremlinLeftHandTapping0
 .byt <GremlinLeftHandTapping1
 .byt <GremlinLeftHandTapping0
GremlinLeftHandFrameAddressHi
 .byt >GremlinLeftHandPointing0
 .byt >GremlinLeftHandPointing1
 .byt >GremlinLeftHandPointing2
 .byt >GremlinLeftHandPointing2
 .byt >GremlinLeftHandNormal
 .byt >GremlinLeftHandTapping0
 .byt >GremlinLeftHandTapping1
 .byt >GremlinLeftHandTapping0
GremlinRightHandFrameAddressLo
 .byt <GremlinRightHandPointing0
 .byt <GremlinRightHandPointing1
 .byt <GremlinRightHandPointing2
 .byt <GremlinRightHandPointing2
 .byt <GremlinRightHandNormal
 .byt <GremlinRightHandTapping0
 .byt <GremlinRightHandTapping1
 .byt <GremlinRightHandTapping0
GremlinRightHandFrameAddressHi
 .byt >GremlinRightHandPointing0
 .byt >GremlinRightHandPointing1
 .byt >GremlinRightHandPointing2
 .byt >GremlinRightHandPointing2
 .byt >GremlinRightHandNormal
 .byt >GremlinRightHandTapping0
 .byt >GremlinRightHandTapping1
 .byt >GremlinRightHandTapping0

ScreenOffset1xH
 .byt 0
 .byt 40
 .byt 80
 .byt 120
 .byt 160
 .byt 200
 .byt 240
ScreenOffset2xH
 .byt 0,1
 .byt 40,41
 .byt 80,81
 .byt 120,121
 .byt 160,161
 .byt 200,201
 .byt 240,241
ScreenOffset3xH
 .byt 0,1,2
 .byt 40,41,42
 .byt 80,81,82
 .byt 120,121,122
 .byt 160,161,162
 .byt 200,201,202
 .byt 240,241,242

GremlinLeftHandPointing0
 .byt %00000101,%01000000,%01000000
 .byt %00000101,%01000011,%01110100
 .byt %00000101,%01000000,%01001010
 .byt %01111101,%01111011,%01100000
GremlinLeftHandPointing1
 .byt %00000101,%01000000,%01000000
 .byt %00000101,%01000111,%01101000
 .byt %00000101,%01000000,%01010100
 .byt %01111101,%01111011,%01000001
GremlinLeftHandPointing2
 .byt %00000101,%01000000,%01000000
 .byt %00000101,%01001111,%01010000
 .byt %00000101,%01000000,%01101000
 .byt %01111101,%01111010,%01000011
GremlinRightHandPointing0
 .byt %00000101,%01000000,%01000000
 .byt %00000101,%01001011,%01110000
 .byt %00000101,%01010100,%01000000
 .byt %10000111,%01000001,%01111011
GremlinRightHandPointing1
 .byt %00000101,%01000000,%01000000
 .byt %00000101,%01000101,%01111000
 .byt %00000101,%01001010,%01000000
 .byt %10000111,%01100000,%01111011
GremlinRightHandPointing2
 .byt %00000101,%01000000,%01000000
 .byt %00000101,%01000010,%01111100
 .byt %00000101,%01000101,%01000000
 .byt %10000111,%01110000,%01011011
GremlinLeftHandNormal
 .byt %00000101,%01000000,%01000100
 .byt %00000101,%01000000,%01010101
 .byt %00000101,%01000000,%01010000
 .byt %01111101,%01111011,%01000111
GremlinLeftHandTapping0
 .byt %00000101,%01000000,%01000000
 .byt %00000101,%01000000,%01010101
 .byt %00000101,%01000000,%01010100
 .byt %01111101,%01111011,%01000001
GremlinLeftHandTapping1
 .byt %00000101,%01000000,%01010000
 .byt %00000101,%01000000,%01010100
 .byt %00000101,%01000000,%01000101
 .byt %01111101,%01111011,%01110000
GremlinRightHandNormal
 .byt %00000101,%01001000,%01000000
 .byt %00000101,%01101010,%01000000
 .byt %00000101,%01000010,%01000000
 .byt %10000111,%01111000,%01111011
GremlinRightHandTapping0
 .byt %00000101,%01000000,%01000000
 .byt %00000101,%01101010,%01000000
 .byt %00000101,%01001010,%01000000
 .byt %10000111,%01100000,%01111011
GremlinRightHandTapping1
 .byt %00000101,%01000010,%01000000
 .byt %00000101,%01001010,%01000000
 .byt %00000101,%01101000,%01000000
 .byt %10000111,%01000011,%01111011


HealthScreenLo
 .byt <$A140
 .byt <$A169
 .byt <$A190
 .byt <$A1B9
 .byt <$A1E0
 .byt <$A209
 .byt <$A230
 .byt <$A259
 .byt <$A280
 .byt <$A2A9
 .byt <$A2D0
 .byt <$A2F9
 .byt <$A320
 .byt <$A349
 .byt <$A370
 .byt <$A399
 .byt <$A3C0
 .byt <$A3E9
 .byt <$A410
 .byt <$A439
 .byt <$A460
 .byt <$A489
HealthScreenHi
 .byt >$A140
 .byt >$A169
 .byt >$A190
 .byt >$A1B9
 .byt >$A1E0
 .byt >$A209
 .byt >$A230
 .byt >$A259
 .byt >$A280
 .byt >$A2A9
 .byt >$A2D0
 .byt >$A2F9
 .byt >$A320
 .byt >$A349
 .byt >$A370
 .byt >$A399
 .byt >$A3C0
 .byt >$A3E9
 .byt >$A410
 .byt >$A439
 .byt >$A460
 .byt >$A489
VoidBar
 .byt 7,7,7,7,7,7,7,7,7,7
 .byt 7,7,7,7,7,7,7,7,7,7
 .byt 7,0
ManaBar
 .byt 3,3,3,3,3,3,3,3,3,3
 .byt 3,3,3,3,3,3,3,3,3,3
 .byt 3,4
HealthBar
 .byt 6,6,6,6,6,6,6,6,6,6
 .byt 6,6,6,6,6,6,6,6,6,6
 .byt 6,1
ManaScreenLo
 .byt <$A164
 .byt <$A18D
 .byt <$A1B4
 .byt <$A1DD
 .byt <$A204
 .byt <$A22D
 .byt <$A254
 .byt <$A27D
 .byt <$A2A4
 .byt <$A2CD
 .byt <$A2F4
 .byt <$A21D
 .byt <$A344
 .byt <$A36D
 .byt <$A394
 .byt <$A3BD
 .byt <$A3E4
 .byt <$A40D
 .byt <$A434
 .byt <$A45D
 .byt <$A484
 .byt <$A4AD
ManaScreenHi
 .byt >$A164
 .byt >$A18D
 .byt >$A1B4
 .byt >$A1DD
 .byt >$A204
 .byt >$A22D
 .byt >$A254
 .byt >$A27D
 .byt >$A2A4
 .byt >$A2CD
 .byt >$A2F4
 .byt >$A21D
 .byt >$A344
 .byt >$A36D
 .byt >$A394
 .byt >$A3BD
 .byt >$A3E4
 .byt >$A40D
 .byt >$A434
 .byt >$A45D
 .byt >$A484
 .byt >$A4AD

ItemList
 .dsb 6,0

UpdateInventoryPointer
	jsr DeleteInventoryPointer
	;Plot Selected pocket Top Arrow
	ldx HeroSelectedPocket
	lda ScreenPocketLo,x
	sta screen
	lda ScreenPocketHi,x
	sta screen+1
	ldy #00
	lda #6
	sta (screen),y
	lda #$E1
	iny
	sta (screen),y
	ldy #80
	lda #1
	sta (screen),y
	lda #$4C
	iny
	sta (screen),y

	;Plot Selected pocket Bottom Arrow
	lda ScreenPocketLo+5,x
	sta screen
	lda ScreenPocketHi+5,x
	sta screen+1
	ldy #00
	lda #1
	sta (screen),y
	lda #$4C
	iny
	sta (screen),y
	ldy #80
	lda #6
	sta (screen),y
	lda #$E1
	iny
	sta (screen),y
	rts

DeleteInventoryPointer
	;Clear all pocket pointers
	ldx #14
.(
loop1	lda ScreenPocketLo,x
	sta screen
	lda ScreenPocketHi,x
	sta screen+1
	ldy #00
	lda #64
	sta (screen),y
	iny
	sta (screen),y
	ldy #80
	sta (screen),y
	iny
	sta (screen),y
	dex
	bpl loop1
.)
	rts
; XXXXX
; XXXXX
; XXXXX
ScreenPocketLo
 .byt <$A0A4
 .byt <$A0A6
 .byt <$A0A8
 .byt <$A0AA
 .byt <$A0AC

 .byt <$A2D4
 .byt <$A2D6
 .byt <$A2D8
 .byt <$A2DA
 .byt <$A2DC

 .byt <$A504
 .byt <$A506
 .byt <$A508
 .byt <$A50A
 .byt <$A50C
ScreenPocketHi
 .byt >$A0A4
 .byt >$A0A6
 .byt >$A0A8
 .byt >$A0AA
 .byt >$A0AC

 .byt >$A2D4
 .byt >$A2D6
 .byt >$A2D8
 .byt >$A2DA
 .byt >$A2DC

 .byt >$A504
 .byt >$A506
 .byt >$A508
 .byt >$A50A
 .byt >$A50C
 ;     0123456789012
TextBoxBuffer
 .dsb 13*5,0
TextboxIndex
 .byt 0
TextBoxBitpos
 .byt 64
 ;     0123456789012
TextBoxTextBuffer
 .byt "             ",128

TextBoxScrollCount	.byt 0

;The problem was that each screen had a name, however within each screen were sometimes
;buildings and places that could be visited and the name needed to be displayed somewhere
;to indicate this. So now the Inlay name (13 characters) is instantly displayed and may
;be overridden by the place name at any time.

;The only remaining problem is that the characters must be shifted right so they do
;not corrupt or mix with the left/right border frame, or the name is further limited to
;11 characters.

PlotPlace
	;X WindowID (+128 to clear to end of window)
	;Y Row in window (+128 for non embedded single word like Grotes or Form Group)
	sta text
	stx text+1
	ldx #1
	ldy #0+128
	jmp DisplayText
