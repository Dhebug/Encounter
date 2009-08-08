;HelpPlot.s - Generate Help screen

;0123456789012345678901234567890123456789
;XXXXXXXXXXXXXYYYYYYYYYYYYYZZZZZZZZZZZZZ
;9TWILIGHTE 23/11/08 - PATTERN EDITOR --
;9 CL Tr-Left  L Left       R Right
;9 CL Tr-Left  L Left       R Right
;9 CL Tr-Left  L Left       R Right
;9 CL Tr-Left  L Left       R Right
;9 CL Tr-Left  L Left       R Right
;9 CL Tr-Left  L Left       R Right
;9 CL Tr-Left  L Left       R Right
;9 CL Tr-Left  L Left       R Right
;9 CL Tr-Left  L Left       R Right
;9 CL Tr-Left  L Left       R Right
;9 CL Tr-Left  L Left       R Right
;9 CL Tr-Left  L Left       R Right
;9 CL Tr-Left  L Left       R Right
;9 CL Tr-Left  L Left       R Right
;9 CL Tr-Left  L Left       R Right
;9 CL Tr-Left  L Left       R Right
;9 CL Tr-Left  L Left       R Right
;9PRESS A KEY TO RETURN TO EDITOR

;Allows for 26x3 keys (78)

HelpPlot
	lda #00
	sta hpCursorIndex
	jsr ClearScreen
	
	;Display Correct Editor in VersionHeaderText
	lda CurrentEditor
	asl
	asl
	asl
	tax
	ldy #00
.(
loop1	lda hpEditorText,x
	ora #128
	sta hpVersionLoc,y
	inx
	iny
	cpy #8
	bcc loop1
.)
	; Plot Header
	ldx #39
.(
loop1	lda VersionHeaderText,x
	ora #128
	sta $BB80,x
	dex
	bpl loop1
.)
	; Plot Footer
	ldx #39
.(
loop1	lda HelpPlotFooterText,x
	ora #128
	sta $BB80+40*27,x
	dex
	bpl loop1
.)
	; Plot Keys
	ldx CurrentEditor
	lda EditorKeyDescriptionPointerTableLo,x
	sta source
	lda EditorKeyDescriptionPointerTableHi,x
	sta source+1
	lda EditorSoftKeyTableLo,x
	sta source2
	lda EditorSoftKeyTableHi,x
	sta source2+1
	lda EditorHardKeyTableLo,x
	sta source3
	lda EditorHardKeyTableHi,x
	sta source3+1
	ldy EditorsUltimateKey,x
	iny
	sty hpLastKey
	ldy #00
	sty hpKeyIndex
.(	
loop2	ldy hpKeyIndex
	jsr hpFetchScreenLoc
	
	;Plot Switch to Character charset
	lda #9
	ldy #00
	sta (screen),y
	
	; Fetch and display soft key
	ldy hpKeyIndex
	lda (source2),y
	bpl skip4
DisplayPartition
	;Fetch Partition name address
	and #127
	;x12
	asl
	asl
	sta hpTemp02
	asl
	adc hpTemp02
	tax
	;Display Partition Name
	ldy #1
loop3	lda PartitionText,x
	sta (screen),y
	inx
	iny
	cpy #13
	bcc loop3
	jmp skip3

skip4	tax
	lda hpSoftKeyCharacter,x
	ldy #1
	sta (screen),y
	
	; Fetch and display hard key
	ldy hpKeyIndex
	lda (source3),y
	ldx #7
loop1	cmp SpecialCharacterKey,x
	beq skip2
	dex
	bpl loop1
	jmp skip1
skip2	lda SpecialCharacterChar,x
skip1	ldy #2
	sta (screen),y

	; Display Key Description
	ldy hpKeyIndex
	lda (source),y
	ldy #4
	jsr DisplayMessage
	
skip3	; Progress to next key
	inc hpKeyIndex
	lda hpKeyIndex
	cmp hpLastKey
	bcc loop2
.)
	;Wait on key
	dec hpLastKey
hpBigLoop
.(
loop1	jsr ClearInputBuffer
	jsr hpPlotCursor
loop2	lda HardKeyRegister
	beq loop2
	jsr hpDeleteCursor
	lda HardKeyRegister
	;Permit selection of Key(Cursors),Changing of key(Return) or Quit(Escape)
	cmp #"X"
	beq TryQuit
	cmp #13
	bcc hpNavigate
	beq hpChange
	cmp #27
	bne loop1
	;Back
	rts

TryQuit	jsr CLS
	ldx #8
loop3	lda SureText,x
	ora #128
	sta $BB80+16+40*14,x
	dex
	bpl loop3
	jsr ClearInputBuffer
loop4	lda HardKeyRegister
	beq loop4
	cmp #"Y"
	bne skip2
	jmp QuitAYT
skip2	jmp HelpPlot

hpNavigate
	ldy hpCursorIndex
	cmp #9
	bcc hpLeft
	beq hpRight
	cmp #11
	bcc hpDown
hpUp	tya
	beq loop1
	dec hpCursorIndex
	jmp loop1
hpDown	cpy hpLastKey
	bcs loop1
	inc hpCursorIndex
	jmp loop1
hpLeft	tya
	sbc #25
	bcc loop1
	sta hpCursorIndex
	jmp loop1
hpRight	tya
	adc #25
	cmp hpLastKey
	beq skip1
	bcs loop1
skip1	sta hpCursorIndex
	jmp loop1
hpChange
.)
	;Prevent mod of partition
	ldy hpCursorIndex
	lda (source2),y
	bmi hpBigLoop
	
	jsr ClearInputBuffer
	;"PRESS KEY COMBO NOW"
	ldx #1
	ldy #27
	lda #128+4
	jsr DisplaySimpleMessage
.(
loop1	lda HardKeyRegister
	beq loop1
.)
	sta hpNewHardKey
	lda SoftKeyRegister
	sta hpNewSoftKey
	;is key already assigned?
	ldy hpLastKey
	dey
.(
loop1	lda hpNewSoftKey
	cmp (source2),y
	bne skip2
	lda hpNewHardKey
	cmp (source3),y
	bne skip2
	cpy hpCursorIndex
	bne skip1
skip2	dey
	bpl loop1
	;New Key ok
	ldy hpCursorIndex
	lda hpNewHardKey
	sta (source3),y
	lda hpNewSoftKey
	sta (source2),y
	jmp HelpPlot
skip1
.)
	ldx #1
	ldy #27
	lda #128+5
	jsr DisplaySimpleMessage
	jmp hpBigLoop
	
	
hpPlotCursor
	ldy hpCursorIndex
	jsr hpFetchScreenLoc
	ldy #12
.(
loop1	lda (screen),y
	sta hpoldtext,y
	ora #128
	sta (screen),y
	dey
	bne loop1
.)
	rts

hpDeleteCursor
	ldy hpCursorIndex
	jsr hpFetchScreenLoc
	ldy #12
.(
loop1	lda hpoldtext,y
	sta (screen),y
	dey
	bne loop1
.)

	rts

hpFetchScreenLoc
	lda HelpPlotScreenLo,y
	sta screen
	lda HelpPlotScreenHi,y
	sta screen+1
	rts

ClearInputBuffer
.(
loop1	lda HardKeyRegister
	bne loop1
.)
	rts
	
QuitAYT	;Disable Interrupts
	sei
	
	;Restore VIA Timers
	lda #<20000
	sta VIA_T1LL
	lda #>20000
	sta VIA_T1LH
	
	;Restore Original IRQ(0488)
	lda #$88
	sta SYS_IRQVECTOR
	lda #$04
	sta SYS_IRQVECTOR+1
	
	;Clear Screen
	jsr CLS
	
	;Restore Stack(Reaching this point will have accumulated many jsr's)
	ldx OriginalStackPointer
	txs

	;Return to Basic
	cli
	jmp $F88F
	
	