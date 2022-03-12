;
; This intro is still heavy work in progress, with bits of code ripped out from "MymPlayer" and "Pushing The Enveloppe"
;
#include "common.h"

	.zero

	*= $50

tmp0				.dsb 2
tmp1				.dsb 2
tmp2				.dsb 2
tmp3				.dsb 2
tmp4				.dsb 2
tmp5				.dsb 2
tmp6				.dsb 2
tmp7				.dsb 2

should_quit         .dsb 1

_DecodedByte		.dsb 1		; Byte being currently decoded from the MYM stream
_DecodeBitCounter	.dsb 1		; Number of bits we can read in the current byte
_DecodedResult		.dsb 1		; What is returned by the 'read bits' function

_CurrentAYRegister	.dsb 1		; Contains the number of the register being decoded	

_RegisterBufferHigh	.dsb 1		; Points to the high byte of the decoded register buffer, increment to move to the next register	
_BufferFrameOffset	.dsb 1		; From 0 to 127, used when filling the decoded register buffer

_MusicResetCounter	.dsb 2		; Contains the number of rows to play before reseting

_CurrentFrame		.dsb 1		; From 0 to 255 and then cycles... the index of the frame to play this vbl

_PlayerVbl			.dsb 1
_MusicLooped		.dsb 1

_FrameLoadBalancer	.dsb 1		; We depack a new frame every 9 VBLs, this way the 14 registers are evenly depacked over 128 frames

	.text

	*= $600

_Main
.(
	lda #0
	sta should_quit

#ifdef PLAY_MUSIC
	lda #MessageON-MessageOFF
#else
	lda 0
#endif	
	sta FlagPlayMusic

	lda #MessageImproved-MessageOriginal
	sta FlagPlayImproved

	jsr StartMusic
	jsr SwitchToHires

	jsr PrintMessages

loop_attract_mode
	; Show the title picture with Smaug the dragon
	lda #<_TitlePicture-1
	ldx #>_TitlePicture-1
	jsr _InitTransitionData

	jsr StartPictureUnroll
loop_show_title
	jsr PictureUnrollFrame
	jsr DelayBetweenFrames
	bne end_attract_mode

	lda _TransitionDone
	beq loop_show_title

	; Wait a bit
	jsr DelayBetweenPictures
	bne end_attract_mode

	; Show Thror's map picture
	lda #<_MapPicture-1
	ldx #>_MapPicture-1
	jsr _InitTransitionData

	jsr StartPictureFromTopAndBottom
loop_show_map
	jsr PictureFromTopAndBottomFrame
	jsr DelayBetweenFrames
	bne end_attract_mode

	lda _TransitionDone
	beq loop_show_map

	; Wait a bit
	jsr DelayBetweenPictures
	bne end_attract_mode

	; Show credits's scroll picture
	lda #<_CreditsPicture-1
	ldx #>_CreditsPicture-1
	jsr _InitTransitionData

	jsr StartPictureVenicianStore
loop_show_credits
	jsr PictureVenicianStoreFrame
	jsr DelayBetweenFrames
	bne end_attract_mode

	lda _TransitionDone
	beq loop_show_credits

	; Wait a bit
	jsr DelayBetweenPictures
	bne end_attract_mode

	jmp loop_attract_mode

end_attract_mode
	jsr SwitchToText
	jsr EndMusic
	rts	
.)	


PrintMessages
.(
	.(
	; Patch the message to indicate the proper status for the sound
	ldy FlagPlayMusic
	ldx #0
loop	
	lda MessageOFF,y
	sta MessageSoundOnOff,x
	iny
	inx
	cpx #MessageON-MessageOFF
	bne loop
	.)

	.(
	; Patch the message to indicate the proper status for the version to play
	ldy FlagPlayImproved
	ldx #0
loop	
	lda MessageOriginal,y
	sta MessageVersionImprovedOriginal,x
	iny
	inx
	cpx #MessageImproved-MessageOriginal
	bne loop
	.)

	.(
	; Display the options text
	ldx #MessageOptionsEnd-MessageOptions
loop	
	lda MessageOptions-1,x
	sta $bb80+40*26+0-1,x
	dex
	bne loop
	.)

	.(
	; Display the blinking "press space to play"
	ldx #MessagePressEnd-MessagePressPlay
loop	
	lda MessagePressPlay-1,x
	sta $bb80+40*27+8-1,x
	dex
	bne loop
	.)
	rts
.)

MessageOptions
	.byt 3,"[S] Sound"
MessageSoundOnOff	
	.byt " ON  [V] Play"
MessageVersionImprovedOriginal
	.byt " Improved Version"
MessageOptionsEnd

MessageOFF .byt 1,"OFF",3
MessageON  .byt 2,"ON ",3

MessageOriginal  .byt 1,"Original",3
MessageImproved  .byt 2,"Improved",3

MessagePressPlay
	.byt 12,4,"Press [SPACE] to play"   ; Blue blinking text
MessagePressEnd


CheckKeyboard
.(
	lda BASIC_KEY                  ; Latest key from keyboard, bit 7 set if valid
	bmi key_pressed

continue
	jsr PrintMessages

	lda #0
	sta BASIC_KEY
	rts

key_pressed ;jmp quit    	
	cmp #" "+128                ; "SPACE" to quit
	beq quit

	cmp #"S"+128                ; "S" to toggle sound off and on
	bne skip_sound_toggle
	lda FlagPlayMusic
	eor #MessageON-MessageOFF	; Lenght of the ON/OFF message
	sta FlagPlayMusic
	bne continue
	jsr StopSound            	; Make sure to stop the YM to avoid sounnnnnnnnnnnnnnnnnnnnnddddddddd
	jmp continue
skip_sound_toggle	

	cmp #"V"+128                ; "V" to toggle between original and improved version
	bne skip_version_toggle
	lda FlagPlayImproved
	eor #MessageImproved-MessageOriginal	; Lenght of the Improved/Original message
	sta FlagPlayImproved
	jmp continue
skip_version_toggle

	; Entual other options
	jmp continue

quit	
	lda #1
	sta should_quit
	rts
.)


DelayBetweenFrames
.(
	jsr _VSync
	jsr _VSync
	jmp CheckKeyboard
.)

DelayBetweenPictures
.(
	ldx #50*3                        ; We wait three seconds
	stx counter
loop	
	jsr DelayBetweenFrames
	bne quit
	dec counter
	bne loop
	lda #0
quit
	rts
.)


CopyTextFontToHires
.(
    ; ROM Font is stored from $FC78 to $FF77 = 768 bytes = 3*256
    ; We recopy whatever is in the original RAM version of from (from $B400 to $B7FF) to the ROM area.
    ; The first 32 characters are skipped because they are not actually displayable.
    ldx #0
loop_copy_font
    lda $B400+8*32+256*0,x
    sta $9800+8*32+256*0,x
    lda $B400+8*32+256*1,x
    sta $9800+8*32+256*1,x
    lda $B400+8*32+256*2,x
    sta $9800+8*32+256*2,x
    dex
    bne loop_copy_font
	rts
.)

CopyHiresFontToText
.(
    ; ROM Font is stored from $FC78 to $FF77 = 768 bytes = 3*256
    ; We recopy whatever is in the original RAM version of from (from $B400 to $B7FF) to the ROM area.
    ; The first 32 characters are skipped because they are not actually displayable.
    ldx #0
loop_copy_font        
    lda $9800+8*32+256*0,x
    sta $B400+8*32+256*0,x
    lda $9800+8*32+256*1,x
    sta $B400+8*32+256*1,x
    lda $9800+8*32+256*2,x
    sta $B400+8*32+256*2,x
    dex
    bne loop_copy_font
	rts
.)


ClearVideo
.(
	; Clean the entire screen area from $A000 to $BFFF with zeroes (BLACK INK attribute)
	sei

	lda FlagPlayImproved
	pha
	lda FlagPlayMusic		; Temporarily save the flags at the end of the memory because they are going to be wiped out
	pha 

	lda #<$a000
	sta tmp0+0
	lda #>$a000
	sta tmp0+1

	lda #0
	ldx #32
next_page
	tay
clear_page
	sta (tmp0),y
	dey
	bne clear_page

	inc tmp0+1
	dex
	bne next_page

	pla 
	sta FlagPlayMusic
	pla
	sta FlagPlayImproved

	cli
	rts
.)


SwitchToHires
.(	
	; Move the font so we can still display stuff
	jsr CopyTextFontToHires

	; Clean the entire screen area from $A000 to $BFFF with zeroes (BLACK INK attribute)
	jsr ClearVideo

	; Put the HIRES attribute at the bottom, and wait one frame
	lda #30
	sta $bfdf

	jmp _VSync
.)

SwitchToText
.(	
	; Clean the entire screen area from $A000 to $BFFF with zeroes (BLACK INK attribute)
	jsr ClearVideo

	; Put the HIRES attribute at the bottom, and wait one frame
	lda #26
	sta $bfdf

	jsr _VSync
	jsr _VSync
	jsr _VSync
	jsr _VSync

	; Move back the font
	jmp CopyHiresFontToText	
.)


; 16 entries
MiniTableUnroll
	.byt 0         ; The normal line of the picture
	.byt 255       ; A black line for special effect
	.byt 32
	.byt 29
	.byt 27
	.byt 26
	.byt 25
	.byt 24
	.byt 23
	.byt 22
	.byt 21
	.byt 20
	.byt 19
	.byt 17
	.byt 14
	.byt 10
	.byt 255       ; A black line for special effect

StartPictureUnroll
.(
	ldy #238
	sty pos_y
	rts
.)

PictureUnrollFrame
.(
	ldy pos_y
	cpy #216
	bne do_frame

	lda #1
	sta _TransitionDone
	rts

do_frame
	ldx #0
loop_roll
	lda MiniTableUnroll,x
	bmi no_wrap
	clc
	adc pos_y
no_wrap	
	tay

	lda _PictureLoadBufferAddrLow,y
	sta tmp0+0
	lda _PictureLoadBufferAddrHigh,y
	sta tmp0+1

	clc
	txa
	adc pos_y
	tay

	lda _ScreenAddrLow,y
	sta tmp1+0
	lda _ScreenAddrHigh,y
	sta tmp1+1

	; Copy from right to left to limit the attribute corruption effects
	ldy #40
loop
	lda (tmp0),y
	sta (tmp1),y
	dey
	bne loop

	inx
	cpx #16
	bne loop_roll

	inc pos_y
	rts
.)


StartPictureVenicianStore
.(
	ldy #0
	sty pos_y
	rts
.)

; A simple copy with multiple simultaneous displayed bands
; tmp0 -> tmp1 
; tmp2 -> tmp3 
; tmp4 -> tmp5
; tmp6 -> tmp7 
PictureVenicianStoreFrame
.(
	ldx pos_y
	cpx #50
	bne do_frame

	lda #1
	sta _TransitionDone
	rts

do_frame
	lda _PictureLoadBufferAddrLow,x
	sta tmp0+0
	lda _PictureLoadBufferAddrHigh,x
	sta tmp0+1

	lda _ScreenAddrLow,x
	sta tmp1+0
	lda _ScreenAddrHigh,x
	sta tmp1+1


	lda _PictureLoadBufferAddrLow+50,x
	sta tmp2+0
	lda _PictureLoadBufferAddrHigh+50,x
	sta tmp2+1

	lda _ScreenAddrLow+50,x
	sta tmp3+0
	lda _ScreenAddrHigh+50,x
	sta tmp3+1

	lda _PictureLoadBufferAddrLow+100,x
	sta tmp4+0
	lda _PictureLoadBufferAddrHigh+100,x
	sta tmp4+1

	lda _ScreenAddrLow+100,x
	sta tmp5+0
	lda _ScreenAddrHigh+100,x
	sta tmp5+1


	lda _PictureLoadBufferAddrLow+150,x
	sta tmp6+0
	lda _PictureLoadBufferAddrHigh+150,x
	sta tmp6+1

	lda _ScreenAddrLow+150,x
	sta tmp7+0
	lda _ScreenAddrHigh+150,x
	sta tmp7+1

	; Copy from right to left to limit the attribute corruption effects
	ldy #40
loop
	lda (tmp0),y
	sta (tmp1),y

	lda (tmp2),y
	sta (tmp3),y

	lda (tmp4),y
	sta (tmp5),y

	lda (tmp6),y
	sta (tmp7),y

	dey
	bne loop

	inc pos_y
	rts
.)



StartPictureFromTopAndBottom
.(
	ldy #0
	sty pos_y
	ldy #199
	sty pos_y2
	rts
.)

; A simple copy from the top and bottom at the same time
; tmp0 -> tmp1 
; tmp2 -> tmp3 
PictureFromTopAndBottomFrame
.(
	ldx pos_y
	cpx #100
	bne do_frame

	lda #1
	sta _TransitionDone
	rts

do_frame
	ldy pos_y2

	lda _PictureLoadBufferAddrLow,x
	sta tmp0+0
	lda _PictureLoadBufferAddrHigh,x
	sta tmp0+1

	lda _ScreenAddrLow,x
	sta tmp1+0
	lda _ScreenAddrHigh,x
	sta tmp1+1

	lda _PictureLoadBufferAddrLow,y
	sta tmp2+0
	lda _PictureLoadBufferAddrHigh,y
	sta tmp2+1

	lda _ScreenAddrLow,y
	sta tmp3+0
	lda _ScreenAddrHigh,y
	sta tmp3+1

	; Copy from right to left to limit the attribute corruption effects
	ldy #40
loop
	lda (tmp0),y
	sta (tmp1),y
	lda (tmp2),y
	sta (tmp3),y
	dey
	bne loop

	inc pos_y
	dec pos_y2
	rts
.)



; Call with A:X containing the picture location
_InitTransitionData
.(
	sta tmp0+0
	stx tmp0+1

	lda #<$a000-1
	sta tmp1+0
	lda #>$a000-1
	sta tmp1+1

	.(
	ldx #0
loop
	clc
	lda tmp0+0
	sta _PictureLoadBufferAddrLow,x
	adc #40
	sta tmp0+0
	lda tmp0+1
	sta _PictureLoadBufferAddrHigh,x
	adc #0
	sta tmp0+1

	clc
	lda tmp1+0
	sta _ScreenAddrLow,x
	adc #40
	sta tmp1+0
	lda tmp1+1
	sta _ScreenAddrHigh,x
	adc #0
	sta tmp1+1

	inx
	cpx #200
	bne loop	
	.)

	.(
loop
	lda #<_EmptySourceScanLine
	sta _PictureLoadBufferAddrLow,x
	lda #>_EmptySourceScanLine
	sta _PictureLoadBufferAddrHigh,x

	lda #<_EmptyDestinationScanLine
	sta _ScreenAddrLow,x
	lda #>_EmptyDestinationScanLine
	sta _ScreenAddrHigh,x

	inx
	bne loop	
	.)

	lda #0
	sta _TransitionDone
	rts
.)


DisplayPicture
.(
	lda #<_TitlePicture
	sta tmp0+0
	lda #>_TitlePicture
	sta tmp0+1

	lda #<$a000
	sta tmp1+0
	lda #>$a000
	sta tmp1+1

	ldx #200
loop_y
	ldy #39
loop_x
	lda (tmp0),y
	sta (tmp1),y
	dey
	bpl loop_x

	clc
	lda tmp0+0
	adc #40
	sta tmp0+0
	lda tmp0+1
	adc #0
	sta tmp0+1

	clc
	lda tmp1+0
	adc #40
	sta tmp1+0
	lda tmp1+1
	adc #0
	sta tmp1+1

	dex
	bne loop_y

	rts
.)



StartMusic
	php
	pha
	sei

    clc
	lda $fffe
	adc #1
	sta __auto_1+1
	sta __auto_3+1
	sta __auto_5+1
	lda $ffff
	adc #0
	sta __auto_1+2
	sta __auto_3+2
	sta __auto_5+2

    clc
	lda $fffe
	adc #2
	sta __auto_2+1
	sta __auto_4+1
	sta __auto_6+1
	lda $ffff
	adc #0
	sta __auto_2+2
	sta __auto_4+2
	sta __auto_6+2

	; Save the old handler value
__auto_1
	lda $245
	sta jmp_old_handler+1
__auto_2
	lda $246
	sta jmp_old_handler+2

	; Install our own handler
	lda #<irq_handler
__auto_3
	sta $245
	lda #>irq_handler
__auto_4
	sta $246

	jsr _Mym_Initialize

	pla
	plp
	rts


EndMusic
	php
	pha
	sei

	; Restore the old handler value
	lda jmp_old_handler+1
__auto_5
	sta $245
	lda jmp_old_handler+2
__auto_6
	sta $246

	; Stop the sound
	jsr StopSound

	pla
	plp
	rts	

StopSound
.(
	lda #8
	ldx #0
	jsr WriteRegister

	lda #9
	ldx #0
	jsr WriteRegister

	lda #10
	ldx #0
	jsr WriteRegister
	rts
.)


_50hzFlipFlop			.byt 0
_VblCounter				.byt 0

irq_handler
	pha
	txa
	pha
	tya
	pha

	; This handler runs at 100hz if comming from the BASIC, 
	; but the music should play at 50hz, so we need to call the playing code
	; only every second frame
	lda _50hzFlipFlop
	eor #1
	sta _50hzFlipFlop
	beq skipFrame

	lda FlagPlayMusic
	beq end_music
	jsr _Mym_PlayFrame
end_music
	inc _VblCounter

skipFrame

	pla
	tay
	pla
	tax
	pla

jmp_old_handler
	jmp 0000


_VSync
	lda _VblCounter
	beq _VSync
	lda #0
	sta _VblCounter
_DoNothing
	rts

; http://www.defence-force.org/ftp/oric/documentation/v1.1_rom_disassembly.pdf
;
; Oric Atmos ROM function W8912
; Originally called with JSR F590
; F590  08  PHP  WRITE X TO REGISTER A 0F 8912.
; F591  78  SEI
; F592  8D 0F 03  STA $030F  Send A to port A of 6522.
; F595  A8  TAY
; F596  8A  TXA
; F597  C0 07  CPY #$07  If writing to register 7, set
; F599  D0 02  BNE $F59D  1/0 port to output.
; F59B  09 40  ORA #$40
; F59D  48  PHA
; F59E  AD 0C 03  LDA $030C  Set CA2 (BC1 of 8912) to 1,
; F5A1  09 EE  ORA #$EE  set CB2 (BDIR of 8912) to 1.
; F5A3  8D 0C 03  STA $030C  8912 latches the address.
; F5A6  29 11  AND #$11  Set CA2 and CB2 to 0, BC1 and
; F5A8  09 CC  ORA #$CC  BDIR in inactive state.
; F5AA  8D 0C 03  STA $030C
; F5AD  AA  TAX
; F5AE  68  PLA
; F5AF  8D 0F 03  STA $030F  Send data to 8912 register.
; F5B2  8A  TXA
; F5B3  09 EC  ORA #$EC  Set CA2 to 0 and CB2 to 1,
; F5B5  8D 0C 03  STA $030C  8912 latches data.
; F5B8  29 11  AND #$11  Set CA2 and CB2 to 0, BC1 and
; F5BA  09 CC  ORA #$CC  BDIR in inactive state.
; F5BC  8D 0C 03  STA $030C
; F5BF  28  PLP
; F5C0  60  RTS

WriteRegister
.(
	PHP  			; WRITE X TO REGISTER A 0F 8912.
	SEI
	STA $030F  		; Send A to port A of 6522.
	TAY
	TXA
	CPY #$07  		; If writing to register 7, set
	BNE skip  		; 1/0 port to output.
	ORA #$40
skip	
	PHA
	LDA $030C  		; Set CA2 (BC1 of 8912) to 1,
	ORA #$EE  		; set CB2 (BDIR of 8912) to 1.
	STA $030C  		; 8912 latches the address.
	AND #$11  		; Set CA2 and CB2 to 0, BC1 and
	ORA #$CC  		; BDIR in inactive state.
	STA $030C
	TAX
	PLA
	STA $030F  		; Send data to 8912 register.
	TXA
	ORA #$EC  		; Set CA2 to 0 and CB2 to 1,
	STA $030C  		; 8912 latches data.
	AND #$11  		; Set CA2 and CB2 to 0, BC1 and
	ORA #$CC 		; BDIR in inactive state.
	STA $030C
	PLP
	RTS
.)



_PlayerCount		.byt 0


;
; Current PSG values during unpacking
;
_PlayerRegValues		
_RegisterChanAFrequency
	; Chanel A Frequency
	.byt 8
	.byt 4

_RegisterChanBFrequency
	; Chanel B Frequency
	.byt 8
	.byt 4 

_RegisterChanCFrequency
	; Chanel C Frequency
	.byt 8
	.byt 4

_RegisterChanNoiseFrequency
	; Chanel sound generator
	.byt 5

	; select
	.byt 8 

	; Volume A,B,C
_RegisterChanAVolume
	.byt 5
_RegisterChanBVolume
	.byt 5
_RegisterChanCVolume
	.byt 5

	; Wave period
	.byt 8 
	.byt 8

	; Wave form
	.byt 8

_PlayerRegCurrentValue	.byt 0


_Mym_ReInitialize
.(
	sei
	lda #0
	sta _MusicLooped
	jsr _Mym_Initialize
	cli 
	rts
.)

_Mym_Initialize
.(
	; The two first bytes of the MYM music is the number of rows in the music
	; We decrement that at each frame, and when we reach zero, time to start again.
	ldx _MusicData+0
	stx _MusicResetCounter+0
	ldx _MusicData+1
	inx
	stx _MusicResetCounter+1
		
	.(
	; Initialize the read bit counter
	lda #<(_MusicData+2)
	sta __auto_music_ptr+1
	lda #>(_MusicData+2)
	sta __auto_music_ptr+2

	lda #1
	sta _DecodeBitCounter

	; Clear all data
	lda #0
	sta _DecodedResult
	sta _DecodedByte
	sta _PlayerVbl
	sta _PlayerRegCurrentValue
	sta _BufferFrameOffset
	sta _PlayerCount
	sta _CurrentAYRegister
	sta _CurrentFrame

	ldx #14
loop_init
	dex
	sta _PlayerRegValues,x
	bne loop_init
	.)

	;
	; Unpack the 128 first register frames
	;
	.(
	lda #>_PlayerBuffer
	sta _RegisterBufferHigh

	ldx #0
unpack_block_loop
	stx _CurrentAYRegister
	
	; Unpack that register
	jsr _PlayerUnpackRegister2

	; Next register
	ldx _CurrentAYRegister
	inx
	cpx #14
	bne unpack_block_loop
	.)

	lda #128
	sta _PlayerVbl+0

	lda #0
	sta _PlayerCount
	sta _CurrentAYRegister
	sta _CurrentFrame

	lda #9
	sta _FrameLoadBalancer
	rts
.)



_Mym_PlayFrame
.(
	;
	; Check for end of music
	; CountZero: $81,$0d
	dec _MusicResetCounter+0
	bne music_contines
	dec _MusicResetCounter+1
	bne music_contines
music_resets
	lda #1
	sta _MusicLooped
	jsr _Mym_Initialize
	
music_contines	

	;
	; Play a frame of 14 registers
	;
	.(
	lda _CurrentFrame
	sta _auto_psg_play_read+1
	lda #>_PlayerBuffer
	sta _auto_psg_play_read+2

	ldy #0
register_loop

_auto_psg_play_read
	ldx	_PlayerBuffer

	; W8912
	; jsr $f590
	; a=register
	; x=value
	pha
	tya
	pha
	jsr WriteRegister
	pla
	tay
	pla

	inc _auto_psg_play_read+2 
	iny
	cpy #14
	bne register_loop
	.)


	inc _CurrentFrame
	inc _PlayerCount

	lda _CurrentAYRegister
	cmp #14
	bcs end_reg

	.(
	dec _FrameLoadBalancer
	bne end

	jsr _PlayerUnpackRegister
	inc _CurrentAYRegister
	lda #9
	sta _FrameLoadBalancer
end	
	rts
	.)

end_reg
	.(
	lda _PlayerCount
	cmp #128
	bcc skip

	lda #0
	sta _CurrentAYRegister
	sta _PlayerCount
	lda #9
	sta _FrameLoadBalancer
	
	clc
	lda _PlayerVbl+0
	adc #128
	sta _PlayerVbl+0
skip
	.)

	rts
.)




;
; Initialise X with the number of bits to read
; Y is not modifier
; A is saved and restored..
;
_ReadBits
	pha

	lda #0
	sta _DecodedResult

	; Will iterate X times (number of bits to read)
loop_read_bits

	dec _DecodeBitCounter
	bne end_reload

	; reset mask
	lda #8
	sta _DecodeBitCounter

	; fetch a new byte, and increment the adress.
__auto_music_ptr
	lda _MusicData+2
	sta _DecodedByte

	inc __auto_music_ptr+1
	bne end_reload
	inc __auto_music_ptr+2
end_reload

	asl _DecodedByte
	rol _DecodedResult

	dex
	bne loop_read_bits
	
	pla
	rts





_PlayerUnpackRegister
	lda #>_PlayerBuffer
	clc
	adc _CurrentAYRegister
	sta _RegisterBufferHigh
_PlayerUnpackRegister2
	;
	; Init register bit count and current value
	;	 
	ldx _CurrentAYRegister
	lda _PlayerRegValues,x
	sta _PlayerRegCurrentValue  
	

	;
	; Check if it's packed or not
	; and call adequate routine...
	;
	ldx #1
	jsr _ReadBits
	ldx _DecodedResult
	bne DecompressFragment

	
UnchangedFragment	
.(
	;
	; No change at all, just repeat '_PlayerRegCurrentValue' 128 times 
	;
	lda _RegisterBufferHigh				; highpart of buffer adress + register number
	sta __auto_copy_unchanged_write+2

	ldx #128							; 128 iterations
	lda _PlayerRegCurrentValue			; Value to write

	ldy _PlayerVbl
	
repeat_loop
__auto_copy_unchanged_write
	sta _PlayerBuffer,y
	iny	
	dex
	bne repeat_loop
.)

	jmp player_main_return

	
player_main_return
	; Write back register current value
	ldx _CurrentAYRegister
	lda _PlayerRegCurrentValue  
	sta _PlayerRegValues,x

	; Move to the next register buffer
	inc _RegisterBufferHigh
	rts




DecompressFragment
	lda _PlayerVbl						; Either 0 or 128 at this point else we have a problem...
	sta _BufferFrameOffset

decompressFragmentLoop	
	
player_copy_packed_loop
	; Check packing method
	ldx #1
	jsr _ReadBits

	ldx _DecodedResult
	bne PlayerNotCopyLast

UnchangedRegister
.(	
	; We just copy the current value 128 times
	lda _RegisterBufferHigh				; highpart of buffer adress + register number
	sta player_copy_last+2

	ldx _BufferFrameOffset				; Value between 00 and 7f
	lda _PlayerRegCurrentValue			; Value to copy
player_copy_last
	sta _PlayerBuffer,x

	inc _BufferFrameOffset
.)


player_return

	; Check end of loop
	lda _BufferFrameOffset
	and #127
	bne decompressFragmentLoop

	jmp player_main_return


PlayerNotCopyLast
	; Check packing method
	ldx #1
	jsr _ReadBits

	ldx _DecodedResult
	beq DecompressWithOffset

ReadNewRegisterValue
	; Read new register value (variable bit count)
	ldx _CurrentAYRegister
	lda _PlayerRegBits,x
	tax
	jsr _ReadBits
	ldx _DecodedResult
	stx _PlayerRegCurrentValue

	; Copy to stream
	lda _RegisterBufferHigh				; highpart of buffer adress + register number
	sta player_read_new+2

	ldx _BufferFrameOffset					; Value between 00 and 7f
	lda _PlayerRegCurrentValue			; New value to write
player_read_new
	sta _PlayerBuffer,x

	inc _BufferFrameOffset
	jmp player_return




DecompressWithOffset
.(
	; Read Offset (0 to 127)
	ldx #7
	jsr _ReadBits					

	lda _RegisterBufferHigh			; highpart of buffer adress + register number
	sta __auto_write+2				; Write adress
	sta __auto_read+2				; Read adress

	; Compute wrap around offset...
	lda _BufferFrameOffset					; between 0 and 255
	clc
	adc _DecodedResult					; + Offset Between 00 and 7f
	sec
	sbc #128							; -128
	tay

	; Read count (7 bits)
	ldx #7
	jsr _ReadBits
	
	inc	_DecodedResult					; 1 to 129


	ldx _BufferFrameOffset
	
player_copy_offset_loop

__auto_read
	lda _PlayerBuffer,y				; Y for reading
	iny

__auto_write
	sta _PlayerBuffer,x				; X for writing

	inc _BufferFrameOffset

	inx
	dec _DecodedResult
	bne player_copy_offset_loop 

	sta _PlayerRegCurrentValue

	jmp player_return
.)



;
; Size in bits of each PSG register
;
_PlayerRegBits
	; Chanel A Frequency
	.byt 8
	.byt 4

	; Chanel B Frequency
	.byt 8
	.byt 4 

	; Chanel C Frequency
	.byt 8
	.byt 4

	; Chanel sound generator
	.byt 5

	; select
	.byt 8 

	; Volume A,B,C
	.byt 5
	.byt 5
	.byt 5

	; Wave period
	.byt 8 
	.byt 8

	; Wave form
	.byt 8

_TransitionDone				.byt 0	

pos_y						.byt 0
pos_y2						.byt 0
counter                		.byt 0


_MusicData
#include "build\music.s"             ; Generated by ym2mym + bin2txt
MusicEnd

_TitlePicture
#include "build\title_picture.s"     ; Generated by pictconv

_CreditsPicture
#include "build\credits_picture.s"   ; Generated by pictconv

_MapPicture
#include "build\map_picture.s"       ; Generated by pictconv

	.dsb 256-(*&255)

 _PlayerBuffer				.dsb 256*14    ; $6800		; .dsb 256*14 (About 3.5 kilobytes)
 _PlayerBufferEnd

_ScreenAddrLow				.dsb 256
_ScreenAddrHigh  			.dsb 256
	
_PictureLoadBufferAddrLow	.dsb 256
_PictureLoadBufferAddrHigh  .dsb 256

_EmptySourceScanLine 		.dsb 256			; Only zeroes, can be used for special effects
_EmptyDestinationScanLine 	.dsb 256			; Only zeroes, can be used for special effects

; Just so log code to check how large this patch data has become
_End
#echo Intro size:
#print (_End - _Main) 

