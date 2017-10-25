

#define        	via_portb               $0300 
#define        	via_porta               $0300 
#define		via_ddrb		$0302	
#define		via_ddra		$0303
#define        	via_t1cl                $0304 
#define        	via_t1ch                $0305 
#define        	via_t1ll                $0306 
#define        	via_t1lh                $0307 
#define        	via_t2ll                $0308 
#define        	via_t2lh                $0309 
#define        	via_sr                  $030A 
#define        	via_acr                 $030b 
#define        	via_pcr                 $030c 
#define        	via_ifr                 $030D 
#define        	via_ier                 $030E 
#define        	via_porta               $030f 

#define via_bit_t1    6
#define via_irq_t1    (1<<via_bit_t1)
#define via_mask_t1   ($7f ^ via_irq_t1)


//#define USE_VSYNC_AUTO_TEXT

#define A_TEXT60     24
#define A_TEXT50     26
#define A_HIRES60    28
#define A_HIRES50    30


#ifdef USE_VSYNC_AUTO_TEXT
#define A_50HZ      A_TEXT50
#define A_60HZ      A_TEXT60
#define line_adr(x) $bb80+(5*x)
#else
#define A_50HZ      A_HIRES50
#define A_60HZ      A_HIRES60
#define line_adr(x) $a000+(40*x)
#endif

#include "params.h"
#include "language.h"

*=$2000
	
	jsr _GenerateExtraTables
	jsr _SequenceDefenceForceLogo
DetectIJK
        php
        sei
        ;ensure printer strobe is set to output
        lda #%10110111
        sta via_ddrb

        ;set strobe low
        lda #%00000000
        sta via_portb

        ;set top two bits of porta to output and rest as input
        lda #%11000000
        sta via_ddra
        ;lda #%11000000
        sta via_porta

        lda via_porta
        and #%00100000
	beq ijkPresent
	; IJK Joystick is not present
	lda #0
	beq storeijkflag
ijkPresent	
	; Copy bit table to $bfe0 (32 bytes)
.(	
	ldx #31 
loop
	lda GenericIJKBits,x
	sta $bfe0,x
	dex
	bpl loop
.)
	; Store flag indicating IJK is present
	lda #1	
storeijkflag	
	sta $0100

        ;restore via porta state
        lda #%11111111
        sta via_ddra
	plp
	cli
	
#ifdef LOADING_MSG	
	lda #<loading_msg
	sta $0101
	lda #>loading_msg
	sta $0102
#endif	
	
	
_vsync_auto
	php
	sei
	tya
	pha
    
    	; Setup DDRA, DDRB and ACR
	lda #%11111111
	sta via_ddra
	lda #%11110111 ; PB0-2 outputs, PB3 input.
	sta via_ddrb
	lda #%1000000
	sta via_acr


	; start T1 with 50Hz period
	lda _isr_period
	sta via_t1cl
	lda _isr_period+1
	sta via_t1ch

	; establish 50Hz graphics mode
	lda #A_50HZ
	sta line_adr(0)

	; wait at least a frame
.(
	ldx #4
	lda #via_irq_t1
wait
	bit via_ifr
	beq wait
	bit via_t1cl
	dex
	bne wait
.)

	; write 60Hz to line address 0, wait 7168 cycles (112 lines)
__1
.(
	lda #A_60HZ
	sta line_adr(0)

	ldy #5
wait_y
	ldx #0
wait_x
	dex
	bne wait_x
	dey
	bne wait_y

	ldx #146
wait_xx
	dex
	bne wait_xx
.)
__11


    ; write 50Hz to line address 0, wait 16896 cycles (264 lines)
__2
.(
	lda #A_50HZ
	sta line_adr(0)

	ldy #13
wait_y
	ldx #0
wait_x
	dex
	bne wait_x
	dey
	bne wait_y

	ldx #34
wait_xx
	dex
	bne wait_xx
.)
__21


    ; write 60Hz to line address 0, wait 7168 cycles (112 lines)
__3
.(
	lda #A_60HZ
	sta line_adr(0)

	ldy #5
wait_y
	ldx #0
wait_x
	dex
	bne wait_x
	dey
	bne wait_y

	ldx #146
wait_xx
	dex
	bne wait_xx
.)
__31


    ; write 50Hz to line address 0, wait 16896 cycles (264 lines)
__4
.(
	lda #A_50HZ
	sta line_adr(0)

	ldy #13
wait_y
	ldx #0
wait_x
	dex
	bne wait_x
	dey
	bne wait_y

	ldx #34
wait_xx
	dex
	bne wait_xx
.)
__41

	; (you have now eliminated lines 200..311 as possibilities, pushing anyone that was there into 0..111)

	; write 60Hz to line address 48, wait 3072 cycles (48 lines)
__5
.(
	lda #A_60HZ
	sta line_adr(48)

	ldy #2
wait_y
	ldx #0
wait_x
	dex
	bne wait_x
	dey
	bne wait_y

	ldx #98
wait_xx
	dex
	bne wait_xx
	nop
.)
__51


	; write 50Hz to line address 48, wait 16896 cycles (264 lines)
__6
.(
	lda #A_50HZ
	sta line_adr(48)

	ldy #13
wait_y
	ldx #0
wait_x
	dex
	bne wait_x
	dey
	bne wait_y

	ldx #34
wait_xx
	dex
	bne wait_xx
.)
__61

	; (you have now also eliminated lines 0..47 as possibilities)

	; write 60Hz to line address 96, wait 3072 cycles (48 lines)
__7
.(
	lda #A_60HZ
	sta line_adr(96)

	ldy #2
wait_y
	ldx #0
wait_x
	dex
	bne wait_x
	dey
	bne wait_y

	ldx #98
wait_xx
	dex
	bne wait_xx
	nop
.)
__71

	; write 50Hz to line address 96, wait 16896 cycles (264 lines)
__8
.(
	lda #A_50HZ
	sta line_adr(96)

	ldy #13
wait_y
	ldx #0
wait_x
	dex
	bne wait_x
	dey
	bne wait_y

	ldx #34
wait_xx
	dex
	bne wait_xx
.)
__81


    ; (you have now also eliminated lines 48..95 as possibilities)

    ; write 60Hz to line address 144, wait 3072 cycles (48 lines)
__9
.(	
	lda #A_60HZ
	sta line_adr(144)

	ldy #2
wait_y
	ldx #0
wait_x
	dex
	bne wait_x
	dey
	bne wait_y

	ldx #98
wait_xx
	dex
	bne wait_xx
	nop
.)
__91


	; write 50Hz to line address 144, wait 16896 cycles (264 lines)
__A
.(
	lda #A_50HZ
	sta line_adr(144)

	ldy #13
wait_y
	ldx #0
wait_x
	dex
	bne wait_x
	dey
	bne wait_y

	ldx #34
wait_xx
	dex
	bne wait_xx
.)
__A1


	; (you have now also eliminated lines 96..143 as possibilities, put potentially repopulated the range 200..207 (?))

	; write 60Hz to line address 200, wait 3072 cycles (48 lines)
__B
.(
	lda #A_60HZ
	sta line_adr(200)

	ldy #2
wait_y
	ldx #0
wait_x
	dex
	bne wait_x
	dey
	bne wait_y

	ldx #98
wait_xx
	dex
	bne wait_xx
	nop
.)
__B1


    ; write 50Hz to line address 200, wait 16896 cycles (264 lines)
__C
.(
	lda #A_50HZ
	sta line_adr(200)

	ldy #13
wait_y
	ldx #0
wait_x
	dex
	bne wait_x
	dey
	bne wait_y

	ldx #34
wait_xx
	dex
	bne wait_xx
.)
__C1

	; (you have now eliminated [pixel parts of] lines 144..199 as possibilities, but repopulated 208..251 (?))
	; start a 19968 cycle period interrupt timer.
	lda _isr_period
	sta via_t1cl
	lda _isr_period+1
	sta via_t1ch

	pla
	tay
	plp

	rts

_isr_period .word 19966

GenericIJKBits
      .byt 0,2,1,3,32,34,33,0,8,10,9,0,40,42,41,0
      .byt 16,18,17,0,48,50,49,0,0,0,0,0,0,0,0,0


#ifdef LOADING_MSG 
; Loading strings

loading_msg
#ifdef ENGLISH
.asc  A_FWMAGENTA+A_FWCYAN*8+128,"V1.1- Loading game data.. please wait",0
#endif

#ifdef SPANISH
.asc  A_FWMAGENTA+A_FWCYAN*8+128,"V1.1- Cargando el juego... un segundo",0
#endif

#ifdef IJK_SUPPORT
Joy_msg
#ifdef ENGLISH
.asc  A_FWMAGENTA+A_FWCYAN*8+128,"IJK Joystick detected.",0
#endif

#ifdef SPANISH
.asc  A_FWMAGENTA+A_FWCYAN*8+128,"Detectado joystick IJK",0
#endif
#endif

#endif


/***********************************************/


_TableMod6	 .dsb 256
_TableDiv6b	 .dsb 256

.zero
*=0
tmp0		.dsb 2
tmp1		.dsb 2
tmp2		.dsb 2
tmp3		.dsb 2
tmp4		.dsb 2
tmp5		.dsb 2
tmp6		.dsb 2
tmp7		.dsb 2
op1		.dsb 2
op2		.dsb 2
tmp		.dsb 2
reg0 		.dsb 2
reg1 		.dsb 2
reg2 		.dsb 2

.text

; Packed source data adress
#define	ptr_source			tmp0	

; Destination adress where we depack
#define	ptr_destination		tmp1	

; Point on the end of the depacked stuff
#define	ptr_destination_end	tmp2	

; Temporary used to hold a pointer on depacked stuff
#define ptr_source_back		tmp3	

; Temporary
#define offset				tmp4	

#define mask_value			reg0
#define nb_src				reg1
#define nb_dst				reg2


_SequenceDefenceForceLogo
.(
	;jsr _clr_all

	lda #<_BufferUnpack
	sta ptr_destination
	lda #>_BufferUnpack
	sta ptr_destination+1
	lda #<_LabelPictureDefenceForce
	sta ptr_source
	lda #>_LabelPictureDefenceForce
	sta ptr_source+1
 
	jsr _FileUnpack
	
	
	jsr _DisplayPaperSet
	jsr _DisplayMakeShiftedLogos
	jsr _DisplayDefenceForceFrame

	lda #150
	sta tmp5
loop	
	jsr _DisplayScrappIt
	dec tmp5
	bne loop

	;jmp _clr_all
	;rts
.)

_clr_all
.(
	lda #<$a000
	sta tmp
	lda #>$a000
	sta tmp+1

	lda #200
	sta tmp0
loop2
	ldy #39
	lda #$40
loop
	sta (tmp),y
	dey
	bpl loop

	lda tmp
	clc
	adc #40
	sta tmp
	bcc nocarry
	inc tmp+1
nocarry
	dec tmp0
	bne loop2

	rts
.)





#define ADDR_LOGO		$a000+40*60
#define ADDR_LOGO_LETTERS	$a000+40*71+5

#define _BufferUnpackTemp _BufferUnpack

_LabelPicture1		= _BufferUnpackTemp+2010*1
_LabelPicture2		= _BufferUnpackTemp+2010*2
_LabelPicture3		= _BufferUnpackTemp+2010*3
_LabelPicture4		= _BufferUnpackTemp+2010*4
_LabelPicture5		= _BufferUnpackTemp+2010*5

						   
TempX		.byt 0
TempY		.byt 0
TempOffset	.byt 0
TempColor	.byt 0

DiplayAngle1		.byt 0
DiplayAngle2		.byt 0
DisplayPosX		.byt 0
DisplayMemoX		.byt 0

OldByte		.byt 0
blablabla 	.byt 0

; Non signed values, from 0 to 255
_CosTable	; Used by the DF logo
	.byt	254
	.byt	253
	.byt	253
	.byt	253
	.byt	253
	.byt	253
	.byt	252
	.byt	252
	.byt	251
	.byt	250
	.byt	250
	.byt	249
	.byt	248
	.byt	247
	.byt	246
	.byt	245
	.byt	244
	.byt	243
	.byt	241
	.byt	240
	.byt	239
	.byt	237
	.byt	235
	.byt	234
	.byt	232
	.byt	230
	.byt	229
	.byt	227
	.byt	225
	.byt	223
	.byt	221
	.byt	218
	.byt	216
	.byt	214
	.byt	212
	.byt	209
	.byt	207
	.byt	205
	.byt	202
	.byt	200
	.byt	197
	.byt	194
	.byt	192
	.byt	189
	.byt	186
	.byt	184
	.byt	181
	.byt	178
	.byt	175
	.byt	172
	.byt	169
	.byt	166
	.byt	163
	.byt	160
	.byt	157
	.byt	154
	.byt	151
	.byt	148
	.byt	145
	.byt	142
	.byt	139
	.byt	136
	.byt	133
	.byt	130
	.byt	127
	.byt	124
	.byt	121
	.byt	118
	.byt	115
	.byt	112
	.byt	109
	.byt	106
	.byt	103
	.byt	100
	.byt	97
	.byt	94
	.byt	91
	.byt	88
	.byt	85
	.byt	82
	.byt	79
	.byt	76
	.byt	73
	.byt	70
	.byt	68
	.byt	65
	.byt	62
	.byt	60
	.byt	57
	.byt	54
	.byt	52
	.byt	49
	.byt	47
	.byt	45
	.byt	42
	.byt	40
	.byt	38
	.byt	36
	.byt	33
	.byt	31
	.byt	29
	.byt	27
	.byt	25
	.byt	24
	.byt	22
	.byt	20
	.byt	19
	.byt	17
	.byt	15
	.byt	14
	.byt	13
	.byt	11
	.byt	10
	.byt	9
	.byt	8
	.byt	7
	.byt	6
	.byt	5
	.byt	4
	.byt	4
	.byt	3
	.byt	2
	.byt	2
	.byt	1
	.byt	1
	.byt	1
	.byt	1
	.byt	1
	.byt	0
	.byt	1
	.byt	1
	.byt	1
	.byt	1
	.byt	1
	.byt	2
	.byt	2
	.byt	3
	.byt	4
	.byt	4
	.byt	5
	.byt	6
	.byt	7
	.byt	8
	.byt	9
	.byt	10
	.byt	11
	.byt	13
	.byt	14
	.byt	15
	.byt	17
	.byt	19
	.byt	20
	.byt	22
	.byt	24
	.byt	25
	.byt	27
	.byt	29
	.byt	31
	.byt	33
	.byt	36
	.byt	38
	.byt	40
	.byt	42
	.byt	45
	.byt	47
	.byt	49
	.byt	52
	.byt	54
	.byt	57
	.byt	60
	.byt	62
	.byt	65
	.byt	68
	.byt	70
	.byt	73
	.byt	76
	.byt	79
	.byt	82
	.byt	85
	.byt	88
	.byt	91
	.byt	94
	.byt	97
	.byt	100
	.byt	103
	.byt	106
	.byt	109
	.byt	112
	.byt	115
	.byt	118
	.byt	121
	.byt	124
	.byt	127
	.byt	130
	.byt	133
	.byt	136
	.byt	139
	.byt	142
	.byt	145
	.byt	148
	.byt	151
	.byt	154
	.byt	157
	.byt	160
	.byt	163
	.byt	166
	.byt	169
	.byt	172
	.byt	175
	.byt	178
	.byt	181
	.byt	184
	.byt	186
	.byt	189
	.byt	192
	.byt	194
	.byt	197
	.byt	200
	.byt	202
	.byt	205
	.byt	207
	.byt	209
	.byt	212
	.byt	214
	.byt	216
	.byt	218
	.byt	221
	.byt	223
	.byt	225
	.byt	227
	.byt	229
	.byt	230
	.byt	232
	.byt	234
	.byt	235
	.byt	237
	.byt	239
	.byt	240
	.byt	241
	.byt	243
	.byt	244
	.byt	245
	.byt	246
	.byt	247
	.byt	248
	.byt	249
	.byt	250
	.byt	250
	.byt	251
	.byt	252
	.byt	252
	.byt	253
	.byt	253
	.byt	253
	.byt	253
	.byt	253

DisplayParamBlackFrameTop
	.byt 10				; Count
	.byt 2   ,64+1+2	; Black pixels
	.byt 2+40,64+1+2	; Black pixels
	.byt 3   ,16+0		; Black paper
	.byt 3+40,16+0		; Black paper
	.byt 36    ,0		; Black ink
	.byt 36+40 ,0		; Black ink
	.byt 37   ,64+1+2	; Black pixels
	.byt 37+40,64+1+2	; Black pixels
	.byt 38   ,16+7		; White paper
	.byt 38+40,16+7		; White paper

DisplayParamBlueFrame
	.byt 12
	.byt 2    ,64+1+2	; Black pixels
	.byt 2+40 ,64+1+2	; Black pixels
	.byt 3    ,16+4		; Blue paper
	.byt 3+40 ,16+6		; Cyan paper
	.byt 4    ,3		; Yellow ink
	.byt 4+40 ,1		; Red ink
	.byt 36    ,0		; Black ink
	.byt 36+40 ,0		; Black ink
	.byt 37   ,64+1+2	; Black pixels
	.byt 37+40,64+1+2	; Black pixels
	.byt 38   ,16+7		; White paper
	.byt 38+40,16+7		; White paper

DisplayParamBlueFrameShadow
	.byt 14
	.byt 2    ,64+1+2	; Black pixels
	.byt 2+40 ,64+1+2	; Black pixels
	.byt 3    ,16+4		; Blue paper
	.byt 3+40 ,16+6		; Cyan paper
	.byt 4    ,3		; Yellow ink
	.byt 4+40 ,1		; Red ink
	.byt 36    ,0		; Black ink
	.byt 36+40 ,0		; Black ink
	.byt 37   ,64+1+2	; Black pixels
	.byt 37+40,64+1+2	; Black pixels
	.byt 38   ,16+0		; Black paper
	.byt 38+40,16+0		; Black paper
	.byt 39   ,16+7		; White paper
	.byt 39+40,16+7		; White paper

DisplayParamBlackFrameBottom
	.byt 12				; Count
	.byt 2   ,64+1+2	; Black pixels
	.byt 2+40,64+1+2	; Black pixels
	.byt 3   ,16+0		; Black paper
	.byt 3+40,16+0		; Black paper
	.byt 36    ,0		; Black ink
	.byt 36+40 ,0		; Black ink
	.byt 37   ,64+1+2	; Black pixels
	.byt 37+40,64+1+2	; Black pixels
	.byt 38   ,16+0		; Black paper
	.byt 38+40,16+0		; Black paper
	.byt 39   ,16+7		; White paper
	.byt 39+40,16+7		; White paper

DisplayParamBlackFrameBottomShadow
	.byt 6				; Count
	.byt 4   ,16+0		; Black paper
	.byt 4+40,16+0		; Black paper
	.byt 38   ,16+0		; Black paper
	.byt 38+40,16+0		; Black paper
	.byt 39   ,16+7		; White paper
	.byt 39+40,16+7		; White paper



DisplayNextLine
	clc
	lda tmp1
	adc #80
	sta tmp1
	bcc skip_display_rasters
	inc tmp1+1
skip_display_rasters
	rts



DisplayScanLine
	stx TempX

LoopDisplayScanLineOuter
	ldy #0
	lda (tmp0),y
	iny
	tax

LoopDisplayScanLine
	lda (tmp0),y	// Get offset
	sta TempOffset
	iny
	lda (tmp0),y	// Get color
	sta TempColor
	iny
	sty TempY

	ldy TempOffset
	lda TempColor
	sta (tmp1),y

	ldy TempY

	dex
	bne LoopDisplayScanLine

	jsr DisplayNextLine

	dec	TempX
	bne	LoopDisplayScanLineOuter

	rts



_DisplayDefenceForceFrame
	lda #<ADDR_LOGO
	sta tmp1+0
	lda #>ADDR_LOGO
	sta tmp1+1

	;
	lda #<DisplayParamBlackFrameTop
	sta tmp0+0
	lda #>DisplayParamBlackFrameTop
	sta tmp0+1

	ldx #1
	jsr DisplayScanLine

	;
	lda #<DisplayParamBlueFrame
	sta tmp0+0
	lda #>DisplayParamBlueFrame
	sta tmp0+1

	ldx #3
	jsr DisplayScanLine

	;
	lda #<DisplayParamBlueFrameShadow
	sta tmp0+0
	lda #>DisplayParamBlueFrameShadow
	sta tmp0+1

	ldx #40
	jsr DisplayScanLine

	;
	lda #<DisplayParamBlackFrameBottom
	sta tmp0+0
	lda #>DisplayParamBlackFrameBottom
	sta tmp0+1

	ldx #1
	jsr DisplayScanLine

	;
	lda #<DisplayParamBlackFrameBottomShadow
	sta tmp0+0
	lda #>DisplayParamBlackFrameBottomShadow
	sta tmp0+1

	ldx #3
	jsr DisplayScanLine

	rts






DisplayMakeShiftedLogo
	ldx #67
LoopDisplayMakeShiftedLogo_Y

	lda #0
	sta OldByte
	ldy #0
LoopDisplayMakeShiftedLogo_X
	lda (tmp0),y
	sta blablabla
	;pha
	and #63
	lsr 
	ora	OldByte
	ora #64
	sta (tmp1),y

	lda blablabla
	;pla
	and #1
	asl
	asl
	asl
	asl
	asl
	sta OldByte

	iny 
	cpy #30
	bne LoopDisplayMakeShiftedLogo_X

	clc
	lda tmp0
	adc #30
	sta tmp0
	bcc skip_src
	inc tmp0+1
	clc
skip_src

	lda tmp1
	adc #30
	sta tmp1
	bcc skip_dst
	inc tmp1+1
skip_dst

	dex
	bne LoopDisplayMakeShiftedLogo_Y
	rts


_DisplayMakeShiftedLogos
	; 0
	lda #<_BufferUnpackTemp
	sta tmp0
	lda #>_BufferUnpackTemp
	sta tmp0+1
	lda #<_LabelPicture1
	sta tmp1
	lda #>_LabelPicture1
	sta tmp1+1
	jsr DisplayMakeShiftedLogo

	; 1
	lda #<_LabelPicture1
	sta tmp0
	lda #>_LabelPicture1
	sta tmp0+1
	lda #<_LabelPicture2
	sta tmp1
	lda #>_LabelPicture2
	sta tmp1+1
	jsr DisplayMakeShiftedLogo

	; 2
	lda #<_LabelPicture2
	sta tmp0
	lda #>_LabelPicture2
	sta tmp0+1
	lda #<_LabelPicture3
	sta tmp1
	lda #>_LabelPicture3
	sta tmp1+1
	jsr DisplayMakeShiftedLogo

	; 3
	lda #<_LabelPicture3
	sta tmp0
	lda #>_LabelPicture3
	sta tmp0+1
	lda #<_LabelPicture4
	sta tmp1
	lda #>_LabelPicture4
	sta tmp1+1
	jsr DisplayMakeShiftedLogo

	; 4
	lda #<_LabelPicture4
	sta tmp0
	lda #>_LabelPicture4
	sta tmp0+1
	lda #<_LabelPicture5
	sta tmp1
	lda #>_LabelPicture5
	sta tmp1+1
	jsr DisplayMakeShiftedLogo
	rts


DisplayTableLogoLow
	.byt <_BufferUnpackTemp 
	.byt <_LabelPicture1
	.byt <_LabelPicture2
	.byt <_LabelPicture3
	.byt <_LabelPicture4
	.byt <_LabelPicture5

DisplayTableLogoHigh
	.byt >_BufferUnpackTemp 
	.byt >_LabelPicture1
	.byt >_LabelPicture2
	.byt >_LabelPicture3
	.byt >_LabelPicture4
	.byt >_LabelPicture5



_DisplayScrappIt
	clc
	lda DiplayAngle1
	sta tmp4
	adc #2
	sta DiplayAngle1

	clc
	lda DiplayAngle2
	sta reg1
	adc #5
	sta DiplayAngle2

	; Offset source
	lda #<0
	sta tmp0
	lda #>0
	sta tmp0+1

	; Screen address
	lda #<ADDR_LOGO_LETTERS
	sta tmp1
	lda #>ADDR_LOGO_LETTERS
	sta tmp1+1

	ldx #67
LoopDisplayScrappItY
	stx DisplayMemoX

	;	pos_x=(int)CosTable[angle_1];
	;	pos_x+=(int)CosTable[angle_2];
	;	pos_x=(pos_x*12)/(256*2);
	clc
	ldx tmp4
	lda _CosTable,x
	ldx reg1
	adc _CosTable,x
	tax

	; Increment angles
	inc tmp4

	clc
	lda reg1
	adc #5
	sta reg1

	; Compute src adress
	lda _TableMod6,x
	tay
	clc
	lda DisplayTableLogoLow,y
	adc tmp0
	sta tmp2
	lda DisplayTableLogoHigh,y
	adc tmp0+1
	sta tmp2+1


	; Compute dst adress
	clc
	lda _TableDiv6b,x
	adc tmp1
	sta tmp3
	lda tmp1+1
	adc #0
	sta tmp3+1

	ldy #0
LoopDisplayScrappItX
	lda (tmp2),y
	sta (tmp3),y
	iny

	lda (tmp2),y
	sta (tmp3),y
	iny

	lda (tmp2),y
	sta (tmp3),y
	iny

	lda (tmp2),y
	sta (tmp3),y
	iny

	lda (tmp2),y
	sta (tmp3),y
	iny

	lda (tmp2),y
	sta (tmp3),y
	iny

	lda (tmp2),y
	sta (tmp3),y
	iny

	lda (tmp2),y
	sta (tmp3),y
	iny

	lda (tmp2),y
	sta (tmp3),y
	iny

	lda (tmp2),y
	sta (tmp3),y
	iny

	cpy #30
	bne LoopDisplayScrappItX

	clc
	lda tmp0
	adc #30
	sta tmp0
	bcc display_skip_src
	inc tmp0+1
	clc
display_skip_src

	lda tmp1
	adc #40
	sta tmp1
	bcc display_skip_dst
	inc tmp1+1
display_skip_dst

	ldx DisplayMemoX

	dex
	beq DisplayScrappItYEnd
	jmp LoopDisplayScrappItY

DisplayScrappItYEnd
	rts


_DisplayPaperSet
	lda #$00
	sta tmp0
	lda #$a0
	sta tmp0+1

	ldx #200
LoopDisplayPaperSet
	ldy #0
	lda #16+7
	sta (tmp0),y
	iny
	lda #0
	sta (tmp0),y

	lda tmp0
	clc
	adc #40
	sta tmp0
	bcc skipbla
	inc tmp0+1
skipbla

	dex
	bne LoopDisplayPaperSet
	rts


_GenerateExtraTables
.(

.(
	; Cosine table
	ldx #0
loop
	clc
	lda _CosTable,x	
	adc _CosTable,x	
	sta reg0+0			; x2
	lda #0
	adc #0				; Just to get the carry	
	sta reg0+1
	
	clc
	lda reg0+0
	adc reg0+0
	sta reg1+0			; x4
	lda reg0+1
	adc reg0+1
	sta reg1+1			; x4
	
	clc
	lda reg0+0
	adc reg1+0
	sta reg1+0			; x6
	lda reg0+1
	adc reg1+1
	sta reg1+1			; x6
		
	lda reg1+1
	sta _CosTable,x
	inx
	bne loop	

.)

   ; Generate multiple of 6 data table
.(
    lda #0      ; cur div
    tay         ; cur mod
    tax
loop
    sta _TableDiv6b,x
	pha
	tya
	sta _TableMod6,x
	pla
    iny
    cpy #6
    bne skip_mod
    ldy #0
    adc #0      ; carry = 1!
skip_mod

    inx
    bne loop
.)

	rts
.)

_FileUnpack
.(

	; Get the unpacked size, and add it to the destination
	; adress in order to get the end adress.
	ldy #4
	clc
	lda ptr_destination
	adc (ptr_source),y
	sta ptr_destination_end+0
	iny
	lda ptr_destination+1
	adc (ptr_source),y
	sta ptr_destination_end+1


	; Move the source pointer ahead to point on packed data (+0)
	clc
	lda ptr_source
	adc #8
	sta ptr_source
	lda ptr_source+1
	adc #0
	sta ptr_source+1


	; Initialise variables
	; We try to keep "y" null during all the code,
	; so the block copy routine has to be sure that
	; y is null on exit
	ldy #0
	lda #1
	sta mask_value
	 
unpack_loop
	; Handle bit mask
	lsr mask_value
	bne end_reload_mask

	; Read from source stream
	lda (ptr_source),y 		

	.(
	; Move stream pointer (one byte)
	inc ptr_source  		
	bne skip
	inc ptr_source+1
skip
	.)
	ror 
	sta mask_value   
end_reload_mask
	bcc back_copy

write_byte
	; Copy one byte from the source stream
	lda (ptr_source),y
	sta (ptr_destination),y

	.(
	; Move stream pointer (one byte)
	inc ptr_source
	bne skip
	inc ptr_source+1
skip
	.)

	lda #1
	sta nb_dst



_UnpackEndLoop
	;// We increase the current destination pointer,
	;// by a given value, white checking if we reach
	;// the end of the buffer.
	clc
	lda ptr_destination
	adc nb_dst
	sta ptr_destination

	.(
	bcc skip
	inc ptr_destination+1
skip
	.)
	cmp ptr_destination_end
	lda ptr_destination+1
	sbc ptr_destination_end+1
	bcc unpack_loop  
	rts
	

back_copy
	;BreakPoint jmp BreakPoint	
	; Copy a number of bytes from the already unpacked stream
	; Here we know that y is null. So no need for clearing it.
	; Just be sure it's still null at the end.
	; At this point, the source pointer points to a two byte
	; value that actually contains a 4 bits counter, and a 
	; 12 bit offset to point back into the depacked stream.
	; The counter is in the 4 high order bits.
	;clc  <== No need, since we access this routie from a BCC
	lda (ptr_source),y
	adc #1
	sta offset
	iny
	lda (ptr_source),y
	tax
	and #$0f
	adc #0
	sta offset+1

	txa
	lsr
	lsr
	lsr
	lsr
	clc
	adc #3
	sta nb_dst

	sec
	lda ptr_destination
	sbc offset
	sta ptr_source_back
	lda ptr_destination+1
	sbc offset+1
	sta ptr_source_back+1

	; Beware, in that loop, the direction is important
	; since RLE like depacking is done by recopying the
	; very same byte just copied... Do not make it a 
	; reverse loop to achieve some speed gain...
	; Y was equal to 1 after the offset computation,
	; a simple decrement is ok to make it null again.
	dey
	.(
copy_loop
	lda (ptr_source_back),y	; Read from already unpacked stream
	sta (ptr_destination),y	; Write to destination buffer
	iny
	cpy nb_dst
	bne copy_loop
	.)
	ldy #0

	;// C=1 here
	lda ptr_source
	adc #1
	sta ptr_source
	bcc _UnpackEndLoop
	inc ptr_source+1
	bne _UnpackEndLoop
	rts
.)





_LabelPictureDefenceForce
	.byt $4c,$5a,$37,$37,$da,$07,$4b,$03,$d9,$40,$00,$f0,$0e,$00,$41,$78
	.byt $13,$30,$4f,$7f,$ff,$7c,$40,$41,$7f,$7f,$7e,$47,$7f,$ff,$7f,$78
	.byt $5f,$7f,$7f,$61,$7e,$40,$7f,$43,$7e,$40,$40,$5f,$7f,$60,$10,$10
	.byt $fd,$40,$15,$00,$40,$40,$7f,$7f,$7f,$43,$ff,$7f,$7f,$7c,$4f,$7f
	.byt $7f,$70,$7f,$97,$70,$43,$7f,$2e,$10,$78,$10,$10,$3b,$00,$7f,$79
	.byt $70,$0c,$10,$3b,$00,$60,$5f,$7f,$7e,$52,$00,$a9,$43,$02,$00,$4c
	.byt $30,$60,$3b,$10,$78,$3b,$a0,$7c,$90,$3b,$00,$66,$00,$4c,$20,$3b
	.byt $10,$7c,$3b,$90,$77,$00,$78,$4f,$40,$4f,$7c,$43,$77,$10,$3b,$20
	.byt $7f,$77,$a0,$e1,$7e,$77,$00,$9e,$00,$42,$00,$77,$10,$60,$41,$7e
	.byt $3f,$41,$7c,$40,$40,$47,$70,$a9,$00,$ca,$00,$43,$7f,$60,$77,$00
	.byt $a8,$00,$10,$20,$62,$20,$60,$b3,$90,$63,$7f,$63,$4b,$20,$ba,$00
	.byt $3b,$20,$40,$7c,$3b,$a0,$47,$70,$43,$78,$4b,$10,$3b,$40,$a3,$00
	.byt $70,$bb,$00,$7a,$03,$11,$4f,$21,$01,$7f,$7f,$73,$7f,$22,$00,$79
	.byt $40,$14,$21,$77,$e0,$7d,$78,$4b,$78,$f1,$00,$ae,$3b,$60,$41,$7f
	.byt $78,$2b,$31,$78,$77,$30,$7f,$f2,$3b,$00,$60,$3b,$00,$77,$40,$7e
	.byt $41,$7d,$7f,$f7,$7c,$47,$77,$2b,$01,$5f,$7f,$41,$7c,$af,$7e,$47
	.byt $78,$43,$ae,$20,$77,$5f,$00,$47,$03,$7c,$40,$3b,$e0,$69,$01,$3b
	.byt $70,$85,$00,$67,$21,$99,$01,$0e,$fa,$00,$7f,$43,$78,$ea,$50,$67
	.byt $01,$3b,$f0,$3b,$d0,$8e,$2b,$81,$7c,$5f,$73,$3b,$40,$ef,$30,$3b
	.byt $f0,$41,$9c,$77,$90,$67,$a1,$7c,$4f,$79,$ef,$c0,$2b,$a1,$67,$f4
	.byt $ef,$50,$2b,$31,$43,$67,$a1,$7c,$43,$7e,$78,$d5,$43,$67,$81,$47
	.byt $67,$b1,$61,$ef,$11,$78,$41,$95,$60,$67,$31,$63,$0a,$00,$7c,$93
	.byt $02,$df,$11,$4f,$fb,$7f,$61,$58,$11,$40,$7e,$5e,$47,$40,$03,$47
	.byt $73,$93,$32,$1b,$32,$a3,$11,$93,$12,$ec,$01,$1b,$12,$8e,$93,$42
	.byt $6f,$7f,$60,$93,$22,$1b,$12,$2b,$11,$40,$43,$5f,$78,$39,$12,$2b
	.byt $41,$e9,$02,$3b,$b0,$4f,$93,$22,$50,$5e,$02,$cf,$22,$0b,$23,$3b
	.byt $80,$47,$25,$03,$5f,$3b,$70,$94,$cf,$32,$77,$60,$47,$3b,$80,$48
	.byt $53,$13,$66,$03,$44,$0a,$6a,$03,$50,$0a,$20,$43,$74,$33,$10,$10
	.byt $29,$13,$65,$13,$9b,$7f,$47,$5b,$23,$7f,$71,$a3,$10,$58,$13,$70
	.byt $00,$76,$03,$7c,$12,$00,$f0,$00,$f0,$00,$f0,$00,$f0,$00,$f0,$00
	.byt $f0,$00,$00,$f0,$00,$f0,$00,$f0,$00,$f0,$d0,$20,$19,$03,$84,$03
	.byt $ee,$13,$00,$f8,$03,$0c,$14,$27,$13,$2a,$30,$1d,$20,$3c,$01,$4c
	.byt $04,$6b,$04,$21,$47,$67,$04,$2f,$20,$3b,$60,$2a,$24,$70,$5d,$04
	.byt $c9,$03,$00,$2a,$23,$26,$10,$3b,$80,$47,$13,$b9,$21,$80,$14,$d0
	.byt $13,$3b,$a0,$36,$0c,$14,$40,$7e,$6f,$24,$67,$78,$3b,$e0,$c9,$04
	.byt $05,$7e,$2f,$14,$60,$b8,$04,$48,$24,$f6,$64,$36,$04,$e0,$02,$3e
	.byt $a7,$04,$7e,$40,$5c,$40,$4f,$40,$04,$fc,$23,$18,$b3,$90,$b7,$13
	.byt $ce,$04,$7f,$70,$a2,$14,$3b,$d0,$c2,$12,$a1,$5c,$3b,$00,$5d,$00
	.byt $4d,$40,$ef,$70,$60,$4d,$24,$7f,$17,$70,$5f,$71,$4a,$05,$7c,$05
	.byt $02,$fc,$13,$77,$80,$00,$ae,$04,$e6,$04,$ea,$14,$4c,$14,$77,$c0
	.byt $e0,$14,$8b,$03,$c7,$12,$e4,$07,$21,$2b,$91,$7d,$62,$05,$47,$04
	.byt $5f,$40,$7e,$41,$5f,$bb,$24,$11,$10,$35,$72,$bc,$15,$ae,$14,$7c
	.byt $b3,$10,$34,$ab,$14,$67,$c1,$70,$f2,$04,$40,$5f,$11,$05,$e7,$34
	.byt $44,$67,$c1,$3b,$70,$60,$ae,$20,$2b,$c1,$3b,$10,$4f,$60,$13,$80
	.byt $77,$30,$b3,$c0,$77,$50,$53,$03,$77,$d0,$3b,$40,$b3,$00,$4e,$00
	.byt $3b,$f0,$2b,$11,$62,$25,$b3,$00,$a0,$23,$3d,$21,$2b,$c1,$d1,$05
	.byt $81,$7e,$f6,$00,$2b,$f1,$9e,$05,$5e,$06,$ae,$16,$e3,$01,$7e,$3b
	.byt $40,$58,$3b,$d0,$43,$78,$50,$c3,$06,$3d,$14,$8f,$5f,$67,$41,$60
	.byt $48,$14,$3b,$b0,$7b,$14,$5f,$03,$77,$7f,$be,$16,$0c,$24,$1b,$b2
	.byt $f6,$16,$57,$12,$dc,$56,$40,$df,$b1,$1b,$22,$be,$03,$57,$12,$93
	.byt $a2,$42,$16,$7b,$f6,$16,$06,$99,$16,$42,$4f,$cb,$04,$3b,$c0,$93
	.byt $42,$42,$07,$08,$14,$08,$cf,$a2,$5a,$23,$6a,$14,$70,$cc,$00,$11
	.byt $70,$65,$53,$42,$06,$04,$9d,$07,$29,$03,$70,$55,$02,$af,$07,$77
	.byt $33,$8f,$03


_BufferUnpack






