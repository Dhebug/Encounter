#include "asm2k2.h"



#define FDC_command	$0310
#define FDC_status	$0310
#define FDC_track	$0311
#define FDC_sector	$0312
#define FDC_data	$0313
#define MICRODISC	$0314






*=location_loader



Initialize
	SEI ; Stop IRQ CPU
	lda #$7F ; Stop VIA interrupt
	sta $030D

/*ASM2K2 Loader !*/



/**********************************************************************************************************************/
/*                                                                       MAIN                                                                                                                          */
/**********************************************************************************************************************/
/*
Memory: C000-C72A (1834 Bytes)
Init Call: C010 (Will not set IRQ vector)
IRQ Address: C035
*/

	; Prevents reset !
	lda #<irq_reset
	sta $fffa
	sta $fffc
	lda #>irq_reset
	sta $fffb
	sta $fffd
	jsr SOFT_HIRES

	SEI
	ldx #1 ; First picture
	jsr begin_loading
	jsr execute
;	jsr wait
	;jsr wait

	ldx #0 ; load the Music
	jsr begin_loading


	;jsr wait
	;jsr wait
	ldx #2
	jsr begin_loading

	lda #$60
	sta $400

	SEI

	jsr start_6522 ;this will setup the 6522 (Not the music, as u said!)
	LDA #<new_irq ;Redirect (Low) IRQ vector to the address of new_irq
	sta $fffe
	lda #>new_irq ;Redirect (High) IRQ vector to the address of new_irq
	sta $ffff
	jsr $c010 ;This will setup for Music Pattern 1, and CLI!!






	jsr $600
loop

	jmp loop

new_irq
	PHA
	TXA
	PHA
	TYA
	PHA
	JSR $400 ;No need to worry about restoring registers!
	LDA $0304
	pla
	tay
	pla
	tax
	pla
	jmp $c035 ;This will process music then finish the irq (RTI)



	;


start_6522
lda #247
sta $302
LDA #255
STA $0303 ;SET DDRA TO ALL OUT
LDA #$7F ;DISABLE ALL IRQ'S
STA $030E
LDA #$C0 ;ENABLE JUST T1 IRQ
STA $030E
LDA #$40 ;SET T1 MODE TO CONTINUOUS IRQ'S
STA $030B
LDA #$10 ;SET T1 LATCH TO 10,000
STA $0306
LDA #$27
STA $0307
LDA #$DD
STA $030C
rts

irq_reset
	.byt $40 ; RTI opcode


/*Execute first effect*/







/**********************************************************************************************************************/
/*                                                                       FIN_MAIN                                                                                                                  */
/**********************************************************************************************************************/







stop_music
	LDA #>opcode_rti
	STA $FFFE
	LDA #<opcode_rti
	STA $FFFF



SILENCE_SOUND
	LDY #$DD
	STY $030C
	LDX #$0A
SS_01
	STX $030F
	LDA #$FF
	STA $030C
	STY $030C
	LDA AY_TABLE,X
	STA $030F
	LDA #$FD
	STA $030C
	STY $030C
	DEX
	BPL SS_01
	rts
AY_TABLE
.byt 00,00,00,00,00,00,00,$7F,00,00,00





/**********************************************************************************************************************/
/*                                                                       LECTURE                                                                                                                    */
/**********************************************************************************************************************/




/*Lecture************************************************************/

readlinsect

	lda current_sector

	cmp #18 ; On a dépassé une piste
	bne s_set_sector

	inc current_track ; oui on augmente la track


	lda #1 ; on remet à zéro le secteur à un ?
	sta current_sector
	;lda #21
	;sta 49000+40


s_set_sector

	lda current_track

	sec
	sbc #128 ; On change de face ?
	bmi stay_on_the_good_side
	lda #%00010000
	sta current_side ; We change the side  to 1 !
	lda #0
	sta current_track ; now we are in track 0 side 2 !
	lda #1
	sta current_sector
	;lda #20
	;sta $bb80
stay_on_the_good_side
	lda current_sector
	sta FDC_sector
	inc current_sector



	lda current_track
	cmp  FDC_track ; On regarde si on est bien sur la bonne piste

	beq stay_on_the_track


	sta	FDC_data ;on set la piste


	lda #$1F ; ordre de chgt de track
	sta FDC_command

	jsr wait_completion

	lda #%10000101 ; on force les le Microdisk en side0, drive A ... Set le bit de données !!!
	ora current_side
	sta MICRODISC

stay_on_the_track
	lda #$80
command
	sta FDC_command


waitcommand_again
	ldy #wait_status_floppy
waitcommand
	nop
	nop
 dey

	bne waitcommand



readbyte
	;cli

	ldy #0
microdisc_read_data
	lda $0318
        bmi microdisc_read_data

	lda $313
page_to_load
	sta $c000,y
	iny


 ;jmp microdisc_read_data

 	;lda FDC_status
	;and #3
	;lsr

	bne microdisc_read_data

	lda FDC_status
	and #$1C

	rts





/*On inite !*/


irq_handler
	pla		; get rid of IRQ context
	pla
	pla
	lda #%10000101
	ora current_side
	sta $0314	; disables disk irq
	lda $0310	; gets status and resets irq

	rts







/*Lecture du secteur !*/

start_read



sectreadloop
	lda #4
	sta retry

readretryloop
	;jsr stop_music
	jsr readlinsect
	;lda music_during_loading
	;beq encore_incremente
	;jsr start_music
	;jsr wait

;	beq sectreadok
;	dec retry
;	bne readretryloop

/*Ptet mettre un wait au cas ou ICI ?!*/
;	sec
;	rts

sectreadok
;	lda #<txt_sector
;	ldx #>txt_sector
;	jsr display_string



encore_incremente
	inc page_to_load+2
	dec pages
	bne sectreadloop

	;sei
/*
	lda #%10000101
	sta $0314

*/
	rts

begin_loading

	sei
	lda #$7F
	sta $030D

	ldy #<irq_handler
	lda #>irq_handler
        sty $fffe
	sta $ffff

	;X contains the program to load !
	lda adresse_chargement_high,x
	sta execute+2 ; set high adress (Execute)
	sta page_to_load+2 ; on inite l'adresse de chargement


	lda adresse_chargement_low,x
	sta execute+1
	sta page_to_load+1 ; on inite l'adresse de chargement


	lda #0 ; We go to side 0
	sta current_side

	lda datas_piste,x
	sta temp

	sec
	sbc #128 ; Is it the 2nd side ?
	bmi  good_side ; No we are in side 1
	sta temp

	lda #%00010000 ; We set the second side b4==16
	sta current_side
	;lda #20
	;sta 49000

good_side
	lda temp
	sta current_track

	lda datas_secteur,x
	sta current_sector

	lda nombre_secteur,x ; nb of page à charger
	sta pages
	jsr start_read

	;sei
	lda #$84
 	ora current_side
	sta $0314

	rts
execute
	jsr $a000
	;jsr attente_touche
	rts



/**********************************************************************************************************************/
/*                                                                       FIN_LECTURE                                                                                                            */
/**********************************************************************************************************************/





/**********************************************************************************************************************/
/*                                                                      UN pack                                                                                                                       */
/**********************************************************************************************************************/

;#include "unpack.asm"
/**********************************************************************************************************************/
/*                                                                       FIN_Un pack                                                                                                               */
/**********************************************************************************************************************/

/**************************************************/

wait_completion
	ldy #4
r_wait_completion
	dey
	bne r_wait_completion
r2_wait_completion
	lda $0310
	lsr
	bcs r2_wait_completion
	asl
	rts




SOFT_HIRES
	LDY #$00		;COPY CHARSET
HM_03
	LDA $B500,Y
	STA $9900,Y
	LDA $B600,Y
	STA $9A00,Y
	LDA $B700,Y
	STA $9B00,Y
	LDA $B900,Y
	STA $9D00,Y
	LDA $BA00,Y
	STA $9E00,Y
	LDA $BB00,Y
	STA $9F00,Y
	DEY
	BNE HM_03
	LDA #$A0             ;CLEAR DOWN ALL MEMORY AREA WITH ZERO
STA $01
	LDA #$00
STA $00
	LDX #$20
HM_01 STA ($00),Y
	INY
	BNE HM_01
	INC $01
	DEX
	BNE HM_01
	LDA #30		;WRITE HIRES SWITCH
	STA $BF40
	LDA #$A0		;CLEAR HIRES WITH #$40
	STA $01
	LDX #$20
	LDX #64
HM_04
	LDY #124
HM_05
	LDA #$40
	STA ($00),Y
	DEY
	BPL HM_05
	LDA $00
	ADC #125
	STA $00
	BCC HM_02
	INC $01
HM_02	DEX
	BNE HM_04
	RTS

wait
        .(
        /*empile les registres*/

        pha
        txa
        pha
        tya
        pha
incrementation2
        ldy #$0
incrementation22
ry2
        ldx #$0
rx2
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	dex

        bne rx2
        dey
        bne ry2

        pla
        tay
        pla
        tax
        pla

        rts

        .)





prgm_en_cours
	.byt 0


#include<loader.cod>
opcode_rti
	.byt $40

sect_low
	.byt  0
sect_hi
	.byt  0
pages
	.byt  0
retry
	.byt  0
temp
	.byt 0
current_track
	.byt 0
current_sector
	.byt 0
current_side
	.byt 0
music_during_loading
	.byt 0
