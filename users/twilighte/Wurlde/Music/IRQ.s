;IRQ.s
;To use Digidrums it is neccesary to allocate memory so reducing Patterns from 128 to either
;96(4K Digidrums) or 64(8K Digidrums).

;Timer1 - 200Hz to 5Khz Variable(Disabled atm)
;Timer2 - 200Hz constant

;Resolution Processing 	- 25-200Hz(Highest speed)
;SFX Processing		- 25,50,100 or 200Hz(Resolution Normal)
;Timeslot Processing	- 25-200Hz
;Note Processing		- 25Hz + DelayFrac
;Keyboard&Counters		- 25Hz

IRQSetup
	sei
	; Load with initial 200Hz period
	lda #<5000
	sta VIA_T1LL
	lda #>5000
	sta VIA_T1LH
	;Redirect IRQ Vector
	lda #<IRQDriver
	sta SYS_IRQVECTOR
	lda #>IRQDriver
	sta SYS_IRQVECTOR+1
	;Set Low Frequency Defaults
	lda #7	;25Hz
	sta prMusicFrequency
	lda #3	;50Hz
	sta prSFXFrequency
	sta prTransferFrequency
	lda #0	;200Hz
	sta prResolutionFrequency
	cli
	rts
	
IRQDriver
prPlayMusic
	;Backup Registers
	sta irqBackupA
	stx irqBackupX
	sty irqBackupY
	
	;Reset IRQ
	lda VIA_T1CL
	
	;run at 200hz
	inc IRQCounter	;0-255

	; Process Music(Pattern and List)	
	lda prMusicFrequency
.(
	beq skip1
	and IRQCounter
	cmp prMusicFrequency
	bne skip2
skip1	jsr ProcMusic
skip2
.)
	; Process SFX(Updates Track Elements)
	lda prSFXFrequency
.(
	beq skip1
	and IRQCounter
	cmp prSFXFrequency
	bne skip2
skip1	jsr ProcSFX
skip2
.)
	; Process Tracks to Resources(Processes Timeslots)
	lda prTransferFrequency
.(
	beq skip1
	and IRQCounter
	cmp prTransferFrequency
	bne skip2
skip1	jsr TransferTrack2Resource
skip2
.)
	; Process Resolutions(Volume and Noise)
	lda prResolutionFrequency
.(
	beq skip1
	and IRQCounter
	cmp prResolutionFrequency
	bne skip2
skip1	jsr ProcResolutions
	; Send to Sound Chip
	jsr prSendAY
skip2
.)

	; Process Auxilliaries(Keyboard,Counters)
	lda IRQCounter
	;Always at 25Hz
	and #7
	cmp #7
.(
	bne skip1
	jsr ScanKeyboard
	jsr ProcessKeyboard
	jsr ControlCounter
skip1
.)
	;Capture IRQ Timer2 Counter
;	lda VIA_T2CL
;	sta irqCycles
;	lda VIA_T2CH
;	sta irqCycles+1
	
	ldx irqBackupX
	ldy irqBackupY
	lda irqBackupA
	rti
	
;Whilst there are 59 keys to detect we can optimise by scanning Soft keys separate to Hard Keys
;Soft Keys are Shift, Control and Function Keys.
; Fortunately Oric designers decided (in their wisdom) to organise all Soft keys on a separate column
; and since column sending is by far the slowest process, we can set up the soft column first then just
; scan each row to get the Soft key code.
;Hard Keys are the rest.
; Hard Keys fill the other columns but because of the hardwares ability to detect multiple key presses
; by multiple bits off, we send the column register the code to group all keys on a single row then
; scan each row. This vastly increases speed when no hard key is being pressed. Once a hard key is
; pressed we will know the row, and will then scan just 6 columns to locate the exact key.
;Ultimate Optimisation
; One final technique that has NOT been implemented is a further optimisation whilst a key is being held
; Down. As the key is held down the scan routine currently scans all rows but should monitor the known
; key down for an up List so focusing on just one key scan.
ScanKeyboard
	; Reset CB2 incase Digidrum has it set
	lda #PCR_SETINACTIVE
	sta VIA_PCR
	; Set up Key Column Register
	lda #$0E
	sta VIA_PORTA
	lda #PCR_SETREGISTER
	sta VIA_PCR
	lda #PCR_SETINACTIVE
	sta VIA_PCR
	
 	; Detect Single Soft Key
	lda #%11101111
	jsr SendKeyColumn
	ldx #4
.(
loop1	lda keySoftRow,x
	sta VIA_PORTB
	jsr KeyDelay
	lda VIA_PORTB
	and #PORTB_KEYBIT
	bne skip1
	dex
	bpl loop1
	jmp skip2
skip1	lda keySoftCode,x
skip2	sta SoftKeyRegister
.)
	; Reset Hard Key
	lda #00
	sta HardKeyRegister
	
	; Detect Hard Row
	lda #%00010000
	jsr SendKeyColumn
	ldx #7
.(
loop1	stx VIA_PORTB
	jsr KeyDelay
	lda VIA_PORTB
	and #PORTB_KEYBIT
	bne skip1
	dex
	bpl loop1
	jmp skip2
skip1	; Hard Row Detected - Locate Column
	ldy #6
loop2	lda keyHardColumn,y
	jsr SendKeyColumn
	jsr KeyDelay
	lda VIA_PORTB
	and #PORTB_KEYBIT
	bne skip3
	dey
	bpl loop2
	jmp skip2
skip3	; Found Hard Key (X==Row(0-7) Y==Column(0-6)) - Combine to form index
	tya
	asl
	asl
	asl
	stx vector1+1
vector1	ora #00
	; Index Hard Key
	tax
	lda HardKeyCode,x
	sta HardKeyRegister
skip2	rts
.)


keySoftRow
 .byt 7,5,4,2,0
keySoftCode
 .byt SOFT_SHFT
 .byt SOFT_FUNC
 .byt SOFT_SHFT
 .byt SOFT_CTRL
 .byt SOFT_CTRL
keyHardColumn
 .byt $FE,$FD,$FB,$F7,$DF,$BF,$7F
HardKeyCode
 .byt "7","J","M","K"," ","U","Y","8"	;Column 0
 .byt "N","T","6","9",",","I","H","L"
 .byt "5","R","B",";",".","O","G","0"
 .byt "V","F","4","-",11,"P","E","/"
 .byt "1",27,"Z","\",8,127,"A",13
 .byt "X","Q","2",0,10,"]","S",0
 .byt "3","D","C","'",9,"[","W","="

SendKeyColumn
	sta VIA_PORTA
	lda #PCR_WRITEVALUE
	sta VIA_PCR
	lda #PCR_SETINACTIVE
	sta VIA_PCR
	rts

KeyDelay
	nop
	nop
	nop
	nop
	nop
	rts

;Control Key Delay and Key Repeat
ProcessKeyboard
	lda HardKeyRegister
.(
	beq skip4
	lda kbdRepeatFlag
	bne skip3
	lda kbdCountingFlag
	bne skip1
	lda #10
	sta irqkbdCountdown
	lda #1
	sta kbdCountingFlag
	rts

skip1	;Currently counting
	lda irqkbdCountdown
	beq skip2
	dec irqkbdCountdown
	lda #00
	sta HardKeyRegister
	rts
skip2	;Counting timed out - Set repeat flag
	lda #1
	sta kbdRepeatFlag
	lda #00
	sta kbdCountingFlag
skip3	rts
	
	
skip4	;when no key being pressing, reset counting and repeat flag
.)
	lda #00
	sta kbdCountingFlag
	sta kbdRepeatFlag
	rts


kbdRepeatFlag	.byt 0
kbdCountingFlag	.byt 0
irqkbdCountdown	.byt 0
SoftwareCounter	.byt 0

ControlCounter
	lda SoftwareCounter
.(
	beq skip1
	dec SoftwareCounter
skip1	rts
.)	
