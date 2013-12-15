;
; This bootsector is for the Jasmin familly.
;
; All it does is to display a warning message saying that this floppy cannot run on a Jasmin.
;
; Anyway, as I said it's a proof of concept, the disc stopped booting on microdisc when I tried filling a bit the sectors,
; so I guess there is a lot of values not to modify, 
; like in offsets $1ae and $1af that better have to keep the values 3 and 0...  (else we got error messages at boot).;
;
; Here is the structure of a typical Sedoric floppy:
; Dump du premier secteur de disquette Master ou Slave (VERSION)
;       0 1 2 3 4 5 6 7 8 9 A B C D E F 0123456789ABCDEF
; 0000- 01 00 00 00 00 00 00 00 20 20 20 20 20 20 20 20
; 0010- 00 00 03 00 00 00 01 00 53 45 44 4F 52 49 43 20
; 0020- 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20
; 0030- 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20
; 0040- 53 45 44 4F 52 49 43 20 56 33 2E 30 30 36 20 30 SEDORIC V3.006 0
; 0050- 31 2F 30 31 2F 39 36 0D 0A 55 70 67 72 61 64 65 1/01/96..Upgrade
; 0060- 64 20 62 79 20 52 61 79 20 4D 63 4C 61 75 67 68 d by Ray McLaugh
; 0070- 6C 69 6E 20 20 20 20 20 20 20 20 20 0D 0A 61 6E lin ..an
; 0080- 64 20 41 6E 64 72 7B 20 43 68 7B 72 61 6D 79 20 d André Chéramy
; 0090- 20 20 20 20 20 20 20 20 20 20 20 20 0D 0A 0D 0A ....
; 00A0- 53 65 65 20 53 45 44 4F 52 49 43 33 2E 46 49 58 See SEDORIC3.FIX
; 00B0- 20 66 69 6C 65 20 66 6F 72 20 69 6E 66 6F 72 6D file for inform
; 00C0- 61 74 69 6F 6E 20 0D 0A 20 20 20 20 20 20 20 20 ation ..
; 00D0- 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20
; 00E0- 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20
; 00F0- 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 2
;
; Possibly we can copy this and then patch what we want over

	.zero
	
	*=$00
	

	.text

	*=$400
    jmp $440 ;.byt $01,$00,$00
	.byt $00,$00,$00,$00,$00,$20,$20,$20,$20,$20,$20,$20,$20
	.byt $00,$00,$03,$00,$00,$00,$01,$00,$53,$45,$44,$4F,$52,$49,$43,$20
	.byt $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
	.byt $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20

	; From there we have 256-$40 bytes to express our creativity
jasmin_main
    ;jmp jasmin_main
	; Clear the screen
	lda #32
	ldx #0
loop_clear
	sta $bb80+256*0,x
	sta $bb80+256*1,x
	sta $bb80+256*2,x
	sta $bb80+256*3,x
	sta $bfe0-256,x
	dex
	bne loop_clear
   
    ; Print the message on the screen
    ldx #<$bb80+6
    ldy #>$bb80+6
    lda #Message1-MessageStart
    jsr PrintText

    ldx #<$bb80+40+6
    ldy #>$bb80+40+6
    lda #Message1-MessageStart
    jsr PrintText

    ldx #<$bb80+40*3
    ldy #>$bb80+40*3
    lda #Message2-MessageStart
    jsr PrintText

    ; And I guess we can't do anything anymore, at some point we can try to get a real loader working.
loop_forever
	jmp loop_forever

PrintText
	stx 0
	sty 1

	tax
	ldy #0
loop_text
	lda MessageStart,x
	beq done
	sta (0),y
	inx
	iny
    jmp loop_text

done	
	rts	

MessageStart
Message1
	.byt 14,3,"Unsupported Disk system",0
Message2	
	.byt "This software is unfortunately only compatible with Microdisc compatible systems",0

