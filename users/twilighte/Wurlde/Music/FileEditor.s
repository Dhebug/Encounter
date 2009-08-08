;FileEditor.s
;Display the directory as two columns of 25 Rows..
;FILE LIST PATTERN SFX >ho S00 ________
; PRINTSONG UTILITY   FILENAME1 MUSIC
; COMPILER1 UTILITY   FILENAME1 MUSIC
; FILENAME1 MUSIC     FILENAME1 MUSIC
; FILENAME1 MUSIC     FILENAME1 MUSIC
; FILENAME1 MUSIC     FILENAME1 MUSIC
; FILENAME1 MUSIC     FILENAME1 MUSIC
; FILENAME1 MUSIC     FILENAME1 MUSIC
; FILENAME1 MUSIC     FILENAME1 MUSIC
; FILENAME1 MUSIC     FILENAME1 MUSIC
; FILENAME1 MUSIC     FILENAME1 MUSIC
; FILENAME1 MUSIC     FILENAME1 MUSIC
; FILENAME1 MUSIC     FILENAME1 MUSIC
; FILENAME1 MUSIC     FILENAME1 MUSIC
; FILENAME1 MUSIC     FILENAME1 MUSIC
; FILENAME1 MUSIC     FILENAME1 MUSIC
; FILENAME1 MUSIC     FILENAME1 MUSIC
; FILENAME1 MUSIC     FILENAME1 MUSIC
; FILENAME1 MUSIC     FILENAME1 MUSIC
; FILENAME1 MUSIC     FILENAME1 MUSIC
; FILENAME1 MUSIC     FILENAME1 MUSIC
; FILENAME1 MUSIC     FILENAME1 MUSIC
; FILENAME1 MUSIC     FILENAME1 MUSIC
; FILENAME1 MUSIC     FILENAME1 MUSIC
; FILENAME1 MUSIC     FILENAME1 MUSIC
; FILENAME1 MUSIC     FILENAME1 MUSIC
; FILENAME1 MUSIC     FILENAME1 MUSIC
;ERR;--    "A-MYMUSIC01"   SHOW PATTERNS
;
;12x50 == 600 Bytes

fnNavLeft
	;00 26
	;.. ..
	;25 51
	;
	lda fnCursorIndex
	cmp #26
.(
	bcc skip1
	sbc #26
	sta fnCursorIndex
skip1	rts
.)

fnNavRight
	;Is cursor in right column already?
	lda fnCursorIndex
	cmp #26
.(
	bcs skip1
	
	; Are their files to the right?
	adc #26
	cmp fnScreenIndex
	bcs skip1
	
	sta fnCursorIndex
skip1	rts
.)
	
fnNavDown
	;Is Cursor at bottom of screen?
	lda fnCursorIndex
	cmp #25
.(
	beq skip1
	cmp #51
	bcs skip1
	
	; Are their more files below?
	adc #1
	cmp fnScreenIndex
	beq skip2
	bcs skip1
	
skip2	sta fnCursorIndex
skip1	rts
.)

fnNavUp
	;Is Cursor on Entry 0?
	lda fnCursorIndex
.(
	beq skip1
	cmp #26
	beq skip1
	
	sec
	sbc #1
	sta fnCursorIndex
skip1	rts
.)
	
fnHome
	lda #00
	sta fnCursorIndex
	rts
fnEnd
	lda fnScreenIndex
	sec
	sbc #1
	sta fnCursorIndex
	rts

fnKeyFilter
	;Type	Name		Area					Sectors
	;AY0	"MODULE  "	List,Patterns,SFX,SFX Names,Key Preferences	93
	;AY1	"MUSIC   "	List,Patterns,SFX,SFX Names
	;AY2	"LIST    "	List
	;AY3	"PATTERNS"	Patterns
	;AY4	"SFX     "	SFX,SFX Names
	;AY5	"KEYS    "	Key Preferences
	;AY6	"SPARE1  "	Not Used (Eventually Digidrum)
	;AY7	"SPARE2  "	Not Used
	ldx fnFilter
	inx
	txa
 	and #7
 	sta fnFilter
	jsr RefreshFilter
	jsr fnRefreshDirectory
	
	;Reset fnCursorIndex to end of directory
	lda fnScreenIndex
.(
	beq skip1
	sec
	sbc #01
skip1	sta fnCursorIndex
.)
	rts

RefreshFilter
	;Store Type in Parsed Directory filter
	ldx fnFilter
	lda FilterCharacter,x
	sta fnFilterPoint
	
	;Now display Type in status bar
	txa
	asl
	asl
	asl
	tax
	ldy #7
.(
loop1	lda fnExtensionText,x
	sta fnStatusBar_ShowAreaName,y
	inx
	dey
	bpl loop1
.)
	rts

fnDrive
	;Cycle Drive letter (A-D) but don't refresh DIR(They can press REFRESH)
	;Store letter in Fn & Status then Display
	lda fnDeviceType
	adc #1
	and #3
	sta fnDeviceType
	adc #65
	sta fnStatusBar_Filename
	jmp fnDisplayStatusBar


fnRefresh
	jsr RefreshFilter
	jmp fnRefreshDirectory

fnPlay
fnPrint
	rts	
	
fnDisplayCursor
	ldx fnCursorIndex	;0-51
	lda fnFilenameScreenLocLo,x
	sta screen
	lda fnFilenameScreenLocHi,x
	sta screen+1
	ldy #18
.(
loop1	lda (screen),y
	ora #128
	sta (screen),y
	dey
	bpl loop1
.)
	rts
	
fnDeleteCursor
	ldx fnCursorIndex	;0-51
	lda fnFilenameScreenLocLo,x
	sta screen
	lda fnFilenameScreenLocHi,x
	sta screen+1
	ldy #18
.(
loop1	lda (screen),y
	and #127
	sta (screen),y
	dey
	bpl loop1
.)
	rts
	
fnUpdateStatusBar
	; Show Disc Error Number
	lda #<fnStatusBar_ErrorNumber
	sta screen
	lda #>fnStatusBar_ErrorNumber
	sta screen+1
	ldy #00
	lda DiscErrorNumber
	jsr AltPlotInversed2DD

	; feed ParsedFilename up to "."
	ldy #4
.(
loop1	lda ParsedFilename-4,y
	beq skip1
	cmp #"."
	beq skip1
	sta (screen),y
	iny
	jmp loop1
skip1	; Drop quote at end
.)
	lda #34
.(
loop1	sta (screen),y
	; Clear up to 16
	lda #9
	iny
	cpy #16
	bcc loop1
.)
	;Show Sectors Free
	jsr DisplayAlt4DD_SectorsFree

	; Show Filter Type
	jsr RefreshFilter
	
fnDisplayStatusBar	
	; Restore Status Bar
	ldx #39
.(
loop1	lda fnStatusBar,x
	ora #128
	sta $bb80+40*27,x
	dex
	bpl loop1
.)
	rts

fnRefreshDirectory	;A is loaded with List number
;	nop
;	jmp fnRefreshDirectory
	;Clear Screen Directory
	lda #<$bb80+40*2
	sta screen
	lda #>$bb80+40*2
	sta screen+1
	ldx #25
.(
loop2	lda #9
	ldy #39
loop1	sta (screen),y
	dey
	bpl loop1
	jsr nl_screen
	dex
	bne loop2
.)
	;Display Refreshing Directory...
	ldx #39
.(
loop1	lda fnDirectoryRefreshText,x
	ora #128
	sta $bb80+40*27,x
	dex
	bpl loop1
.)	
	;Backup Zero Page
	jsr BackupZeroPage
	;Store Current disk id
	;Device Type
	;0 Drive A
	;1 Drive B
	;2 Drive C
	;x3 Tape
 	lda fnDeviceType
	clc
	adc #97
	sta fnDiscDirText+1
	

	lda #$00
	sta fnScreenIndex
.(
	sta dskr_05+1
	
	lda #<fnDiscDirText
	sta $e9
	lda #>fnDiscDirText
	sta $ea
	jsr $04f2
	jsr $d451
	jsr $db30
	bne dskr_05
dskr_03	jmp dskr_01
dskr_02	jsr $db41
	beq dskr_03
dskr_05	ldx #$00
	lda $c027
	sta $36
	lda #$c3
	sta $37
	
	;Set up screen (based on screen index)
	ldx fnScreenIndex
	lda fnFilenameScreenLocLo,x
	sta $34
	lda fnFilenameScreenLocHi,x
	sta $35

	;Fetch Type -
	;The filename received is 12 characters long in the format
	;NNNNNNNNNEEE where N is the name and E is the extension.

        	; Don't display if extensions last character is not 0,1,2,3,4,5
	ldy #11
	lda ($36),y
	
	; Type ranges SAEP
        	cmp #"6"
	bcs skip1
        	cmp #"0"
	bcc skip1
	
	; Reduce last numeral to 00-05
	sbc #48
	
	; Multiply by 8
	asl
	asl
	asl
	tax
	
	; Display Filename
	ldy #$08
dskr_04	lda ($36),y
	sta ($34),y
	dey
	bpl dskr_04
	
	; Display Extension description
	ldy #17
loop1	lda fnExtensionText,x
	sta ($34),y
	dey
	inx
	cpy #10
	bcs loop1

	inc dskr_05+1
	
	;Update screen
	inc fnScreenIndex
	
	;Progress to end of screen index (if neccesary)
skip1	ldx dskr_05+1
	lda fnScreenIndex
	cmp #50
	bcc dskr_02
dskr_01	;Capture Sectors Free before switching back ROM
	lda $C202
	sta fnSectorsFreeLo
	lda $C203
	sta fnSectorsFreeHi
	
	jsr $04F2
.)
	;Restore Zero Page
	jsr RestoreZeroPage
	jsr fnDisplayStatusBar
	
	;Are we displaying maximum files?
	ldx fnScreenIndex
	cpx #52
.(
	bcc skip1
	jmp DirEnd
skip1
.)
	;Add New filename to end of list
	ldx fnScreenIndex
	lda fnFilenameScreenLocLo,x
	sta screen	;$34
	lda fnFilenameScreenLocHi,x
	sta screen+1	;$35
	ldy #8
	lda #"?"
.(
loop1	sta (screen),y
	dey
	bpl loop1
.)
	;And display current type after
	lda fnFilter
	asl
	asl
	asl
	tax
	ldy #17
.(
loop1	lda fnExtensionText,x
	sta (screen),y
	inx
	dey
	cpy #10
	bcs loop1
.)	
DirEnd	;If the current cursor lyes after the last filename then reset cursor to last
	lda fnScreenIndex
	cmp fnCursorIndex
.(
	bcs skip1
	sta fnCursorIndex
skip1	rts
.)	
	

BackupZeroPage
	ldx #00
.(
loop1	lda $00,x
	sta $B800,x
	dex
	bne loop1
.)
	rts

RestoreZeroPage
	ldx #00
.(
loop1	lda $B800,x
	sta $00,x
	dex
	bne loop1
.)
	rts

fnLoad
	;Display Loading..
	ldx #1
	ldy #27
	lda #128+2
	jsr DisplaySimpleMessage
	;
	jsr fnSetupScreen
	;Check if on New filename
	lda (screen),y
	cmp #"?"
.(
	beq skip1	;Not permitted
	;Capture Name
	jsr fnConstructFilename
	jsr SwitchOutROM
	jsr BackupZeroPage
	jsr fnParseFilename

	lda #00
	jsr $dff9
	jsr SwitchInROM
	cli
	jsr RestoreZeroPage
skip1	jmp ManageDiscError
	rts
.)	
	
fnSave	;Cannot save if ANY TYPE(7) or SPARE(6)
	lda fnFilter
	cmp #6
.(
	bcs abort

	; Capture screen loc of Filename
	jsr fnSetupScreen
	lda (screen),y
	
	;Check if on New filename
	cmp #"?"
	bne skip1
	
	;Clear 9 characters
	ldy #8
	lda #32
loop1	sta (screen),y
	dey
	bpl loop1
	;Input new filename
	lda #%00000100
	ldx #9
	ldy #00
	jsr GenericInput
	bcs skip2

skip1	jsr fnConstructFilename
	jsr fnParseFilename
	;Display Saving..
	ldx #1
	ldy #27
	lda #128+3
	jsr DisplaySimpleMessage
	;
	jsr SwitchOutROM
	jsr BackupZeroPage
	lda #1
	sta $0b
	lda #$00
	jsr $d454
	;Setup Areas
	ldx fnExtensionType
	lda fnFileTypeStartVectorLo,x
	sta $c052
	lda fnFileTypeStartVectorHi,x
	sta $c053
	lda fnFileTypeEndVectorLo,x
	sta $c054
	lda fnFileTypeEndVectorHi,x
	sta $c055

	lda #$00
	sta $c04d
	sta $c04e
	lda #$40
	sta $c051
	jsr $de0b
	jsr SwitchInROM

	cli
	jsr RestoreZeroPage
skip2	jsr fnRefreshDirectory
	jmp ManageDiscError
abort	rts
.)	
	
;Parsed..
;X Extension type	
fnConstructFilename
	;Fetch Type Letter (O U I A F E P N)
	ldy #11
	lda (screen),y
	;Breakdown type
	ldx #5
.(
loop1	cmp fnTypeLetter,x
	beq skip1
	dex
	bpl loop1
	ldx #0

skip1	stx fnExtensionType
.)
	;Clear Filename block
	ldy #14
	lda #00
.(
loop1	sta ParsedFilename,y
	dey
	bpl loop1
.)
	; Construct Drive Letter
	lda fnDeviceType
	clc
	adc #65
	sta ParsedFilename
	; Construct hyphen
	lda #"-"
	sta ParsedFilename+1
	
	; Construct Filename
	ldy #00
.(
loop1	lda (screen),y
	cmp #33
	bcc skip1
	sta ParsedFilename+2,y
	iny
	jmp loop1

skip1	; Construct separator
.)
	lda #"."
	sta ParsedFilename+2,y
	
	; Construct Extension
	lda #"A"
	sta ParsedFilename+3,y
	lda #"Y"
	sta ParsedFilename+4,y
	lda fnExtensionCharacter3,x
	sta ParsedFilename+5,y
	rts
	
fnSetupScreen
	ldx fnCursorIndex
	lda fnFilenameScreenLocLo,x
	sta screen
	lda fnFilenameScreenLocHi,x
	sta screen+1
	ldy #00
	rts

fnParseFilename
	lda #<ParsedFilename
	sta $e9
	lda #>ParsedFilename
	sta $ea
	rts

ManageDiscError
	jsr fnUpdateStatusBar
	jsr fnDisplayStatusBar
	rts
	
	

	
	
	