;Jasmin Eprom

#define jsm_Command     $03F4
#define jsm_Status      $03F4
#define jsm_Track       $03F5
#define jsm_Sector      $03F6
#define jsm_Data        $03F7
#define jsm_SideSelect  $03F8   ;B0 Side 0(0) or 1(1)
#define jsm_FDCReset    $03F9   ;Write any value
#define jsm_Overlay     $03FA   ;B0 Overlay(1)
#define jsm_ROMDIS      $03FB   ;B0 Disable ROM(1)
#define jsm_DriveA      $03FC   ;Write any Value
#define jsm_DriveB      $03FD   ;Write any Value
#define jsm_DriveC      $03FE   ;Write any Value
#define jsm_DriveD      $03FF   ;Write any Value
#define via_ier         $030E

;The process may appear quite complex and the code is rather OTT but this
;may be due to the slow behaviour of the EPROM and Overlay Switches and
;the behaviour of the JASMIN FDC.

;F800   $500 bytes are not used
;Press Oric Reset
;FD00   Disable Overlay
;       Disable 6522 IRQ's
;       Copy Bootstrap from EPROM to $400
;       Jump to $400
;401    Reset Jasmin Registers (Not FDC)
;       Disable ROM
;       Set CPU Interrupt Mask
;       Jump back to EPROM and $FE00
;FE00   Disable 6522 IRQ's (For the 3rd time!)
;       Wait 10 Cycles
;       Copy Jasmin Reset Code to $400
;       Select Drive A (Master)
;       Reset Jasmin Hardware
;       Restore Track Zero
;       Long Delay (About ?)
;       If FDC Head Loaded
;               Print "Booting.. TDOS" to status line
;               Wait for Drive Ready
;               Read Track 0, Sector 1 (Page 4) IRQ Driven
;               Wait for Command End
;               Jump to $400
;       else
;               Print "Booting Failed!" to status line
;               Jump to $0400 (Reset code previously copied)
;       end if
;$FF18  Not used
;$FFFC  Reset Vector patched to $FD00
;$FFFE  IRQ vector patched to 28 cycle routine at $FEC7

;F800
.dsb $500,$FF
OricResetPressed        ;Hard vectored in FFFC-FFFD by Jasmin EPROM
;FD00 (File Offset 0500)
        sei

        ;Switch
        lda #00
        sta jsm_Overlay

        ;Disable 6522 Interrupts
        lda #$7F
        sta via_ier
        nop
        nop
        nop
        nop
        nop
        lda #$7F
        sta via_ier

        lda #00
        sta jsm_Overlay

        ;Copy FunnyCode (32 bytes) to Page 4 (Note $0400 is NOP)
        ldy #$20
loop3   dey
        beq skip1
loop2   lda $FD50,y
        sta $0400,y
        ;I think this checks that ROM/EPROM HAS been disabled
        lda $0400,y
        cmp $FD50,y
        bne loop2       ;F2
        beq loop3       ;ED
        ;Then jump to it
skip1   jmp $401

 .dsb 30,$EA

FunnyCode
        nop
        ;Disable 6522 IRQ's
        lda #$7F
        sta via_ier

        ;Reset all Jasmin specific Registers (incidentally selecting Drive 0)
        lda #00
        ldy #08
loop1   sta $03F7,y
        dey
        bne loop1
        ;Switch out ROM
        lda #01
        sta jsm_ROMDIS
        ;Not sure, but SEI may signify about to load something
        sei
        jmp $FE00

 .dsb 152,$EA   ;NOP

;FE00 (File Offset 0600)
        sei
        ;Disable Via (again) :/
        lda #$7f
        sta via_ier
        nop
        nop
        nop
        nop
        nop
        ;Copy 15 Bytes to Page 4
        ldy #$0E
.(
loop1   dey
        cpy #$FF
        beq skip1       ;09
        lda $FE63,y
        sta $0400,y
        clc
        bcc loop1       ;F2

        ; Select Drive A
skip1   lda #01
.)
        sta jsm_DriveA

        ;Reset Jasmin Drive
        sta jsm_FDCReset

        ;Seek Track 0
        lda #00
        sta jsm_Command

LongDelay
        lda #$FF
        sta $BFE0
        sta $BFE1
        lda #02
        sta $BFE2
.(
loop1   dec $BFE0
        bne skip1       ;0A
        dec $BFE1
        bne skip1       ;05
        dec $BFE2
        beq skip2       ;05
skip1   nop
        nop
        nop
        bne loop1       ;EC

        ;Check on Head Loaded flag
skip2   lda jsm_Status
.)
        and #$20
.(
        bne skip1       ;08

        ;Display "BOOTING FAILED!" Message in status line
        ldx #$D2
        jsr DisplayStatusText
        jmp $0400

        ;Display "BOOTING.. TDOS" Message in status line
skip1   ldx #$E1
.)
        jsr DisplayStatusText

        ;
        jsr $FEF0
        jmp $0400

FE63    lda #00
        sta jsm_ROMDIS
        sta jsm_FDCReset
        sta jsm_DriveA
        jmp (FFFC)

DisplayStatusText       ;$FE71 (File Offset 0671)
        ldy #$FF
.(
loop1   inx
        iny
        lda $FE00,x
        bmi skip1       ;05
        sta $BB82,y
        bpl loop1       ;F4
skip1   and #$7F
.)
        sta $BB82,y
        rts

FE85
.(
loop1   lda jsm_Status
        lsr
        bcs loop1       ;FA
.)
        lda #$01
        sta jsm_Sector
        lda #$8C        ;Read Sector Command
        sta jsm_Command
        ldy #00
        cli
        nop
        nop
        nop
        nop
        nop
        cli
.(
loop1   lda jsm_Status
        and #01
        bne loop1       ;F9
.)
        rts
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop

data
 .byt $00,$05,$04
 .byt 0B 02 0C 08 0E 40 00 D0
 .byt C0 FF 10 F4 7F
FEC5    nop
        nop
;Hard vectored in FFFE-FFFF(IRQ) by Jasmin EPROM
;Fabrice: Strict 31.25mS here so 28 Cycles
FEC7    tax
        lda jsm_Data
        sta $0400,y
        iny
        txa
        rti
 .byt AD F7 03 99 00 04 C8 8A   ;Code?
 .byt 40 55
BootFaultText
 .byt "BOOTING FAILED","!"+128
BootInProgressText
 .byt "BOOTING.. TDO","S"+128

FEF0    lda #$20
        sta $BFE0
.(
loop1   dec $BFE0
        beq skip1       ;0A
        jsr $FE85
        lda #00
        and jsm_Status  ;$03F4
        beq skip2       ;03
skip1   jmp $FE50

skip2   lda #$1C
        and jsm_Status  ;$03F4
        bne loop1       ;E7
.)
        rts

 .byt $FF

        lda #"5"
        sta $BB83
        jmp $0400
        nop

00000710 | A9 35 8D 83 BB 4C 00 04 | ©5çÉªL.. | ????
00000718 | EA                      | Í        | O

