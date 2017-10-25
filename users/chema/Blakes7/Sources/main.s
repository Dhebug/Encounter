#include "params.h"
#include "resource.h"
#include "script.h"
#include "verbs.h"
#include "inventory.h"

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


; Column and row of tile in visible area coordinates
vis_col .byt 00
tile_row
vis_row .byt 00

; Same but in room coordinates
tile_col .byt 00

; Signal if an interrupt occured
irq_detected	.byt 0

; For handling mouse cursor and clicks 
plotX 			.byt 00
plotY			.byt 00

newPlotX 		.byt 00
newPlotY 		.byt 00

MouseShown 		.byt 00
MouseInvalid 		.byt 00

; This one has been moved below as it shall be saved
;MouseOff		.byt 00

clickX			.byt 00
clickY			.byt 00
MouseClicked		.byt 00


; Frame counter, for character speed, for instance
; This was moved outside zero page to open space
; for the SRB. Not much gain anyway.
;nFrameCount	.byt 0

#ifdef SRB_IN_ZEROPAGE
; Screen refresh buffer
SRB .dsb ROOM_ROWS*5,0
#endif

; Backbuffer, just one tile..	
backbuffer .dsb 8

; META: Should this be in lower memory? At least saved!
first_col .byt $00 ; Leftmost visible column... set in InitEngine!!

_LoaderUsedZP =$F2

.text 

; Main procedure.

#define LoadFileAt(fileIndex,address)          lda #fileIndex:sta _LoaderApiEntryIndex:lda #<address:sta _LoaderApiAddressLow:lda #>address:sta _LoaderApiAddressHigh:jsr _LoadApiLoadFileFromDirectory
#define SaveFileAt(fileIndex,address)          lda #fileIndex:sta _LoaderApiEntryIndex:lda #<address:sta _LoaderApiAddressLow:lda #>address:sta _LoaderApiAddressHigh:jsr _LoadApiSaveFileFromDirectory



#undef LOADER
#include "floppycode\floppy_description.h"

; Trying to save some bytes... I'll use this part, which is not run anymore, as buffer for 40 chars (strings)
; There are >80 bytes here...
str_buffer
_main
.(
	; Load tables
	LoadFileAt(LOADER_TABLES,OBJ_DATA_LOCATION)
	
	; Load auxiliar code
	LoadFileAt(LOADER_AUXILIAR,$2000)
	
	sei
	lda #0
	; Set some vars to 0
	sta MusicPlaying	; No music playing
	sta MenuShown		; Menu has not been shown yet
	sta LastFrameTime	; Last frame time is zero	
	sta vol_sel
	sta ttalk_sel 
	inc ttalk_sel		

	jsr UpdateVolumeSetting
#ifndef SPEECHSOUND
	jsr UpdateTalkTime		
#else
	jsr UpdateTalkSound
#endif	
	jsr _init_print
	
	jsr _StartPlayer
	jsr ClearHires
	;jsr SetHires
	jsr SetInk2

	; Run auxiliar code
	jsr $2000

	jsr InitEngine
	jsr InitMouse
	jsr FullInitVars	; For verbs and actions	
	jsr ClearSpeechArea	; Clears top line and shows mouse
	
	
#ifdef LOADING_MSG
	; Print Loading message
	ldy #100
	ldx #1*6
	jsr gotoXY
	lda $101 ;#<loading_msg
	ldx $102 ;#>loading_msg
	jsr print	
#ifdef IJK_SUPPORT
	; Print IJK detected if true
	lda $100
	beq skipj
	ldy #100+16
	ldx #8*6
	jsr gotoXY
	ldx $101 ;#<loading_msg
	ldy $102; #>loading_msg	
	lda #1
	jsr PrintStringWithXY
skipj	
#endif

#endif	
	jsr _InitISR
+_restart_game			
	jsr InitInventory
	jsr SetMouseOff
	
	ldy #$ff ; Parent script
	ldx #SCRIPT_GAME_ENTRY_POINT
	jsr LoadAndInstallScript	
	
	cli
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This is the main game loop. The above code
; can even be rewritten or reused.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_main_loop
.(
	; Increment frame counter
	inc nFrameCount
	
	; Execute threads
	jsr doThreadLoop
	
	; If room changed due to any script, perform the fade effect
	; and show mouse back.
	lda RoomChanged
	beq skip5
	jsr PerformFadeEffect
	jsr ShowMouse
skip5		
	; Animate characters (talking, walking, etc.)
	jsr AnimateCharacters
	
	; Sort them (some may have changed position or zplane)
	jsr SortObjects
	
	; Wait for IRQ before doing anything else
	; Hopefully, if there is not a lot of work to do
	; we can do it in the blank time
	jsr WaitIRQ	
	
	; Use a flag to keep mouse cursor state
	; because it would need to be hidden before rendering
	; and put back afterwards if it is valid and shown
	lda #0
	sta flagcursor+1
	jsr IsCursorInvalid
	beq skip
	inc flagcursor+1
	jsr HideMouse
skip
	; Render the screen, updating tiles marked as dirty
	jsr RenderScreen
	
	; Show mouse cursor again, if needed
flagcursor	
	lda #0
	beq skip2
	jsr ShowMouse
skip2	
	; Run the camera control code (for pans and other movements)
	jsr CameraControl

	; Process user input
	jsr ProcessMouseClicks
	jsr UpdateMouse
	
	; If user action sentence has changed, print it
	lda SentenceChanged
	beq skip3
	jsr PrintCommandSentence
skip3
	; If there is a command running, perform next step
	lda CommandRunning
	beq skip4
	jsr ContinuousExecCommand
skip4
	; Check ESC and other keypresses
	jsr ReadKeyNoBounce
	beq skip7
	cpx #10	; ESC
	bne skip6
	jsr escape
	jmp skip7
skip6	
	; Deal with shortcuts. Not active if in dialog mode or
	; cursor is disabled
	lda InDialogMode
	ora MouseOff
	bne skip7	
	; This is an ugly hack to implement the shortcut system 
	; If it is a number, and corresponds to an active verb
	jsr isnum
	and verb_active-"1",x
	beq skip7
	txa
	sec
	sbc #"1"
	; Save action code and get the item over which the cursor hovers...
	pha
	jsr ProcessMouseMoves
	pla
	; If in inventory, prevent another pickup action (bug in version 1.0)
	ldx plotY
	cpx #INVENTORY_AREA_FIRSTLINE
	bcc normal
	ldx plotX
	cpx #INVENTORY_AREA_START
	bcc normal
	cmp #VERB_PICKUP
	bne normal
	lda #VERB_LOOKAT
normal	
	jsr shortcutentry
	jmp skip7
	; Done with the shortcut code
skip7	
	; This is to patch the # of irqs
	; when the room was rendered completely
	; as timings would be wrong
	lda RoomChanged
	beq nochange
	ldx #0
	stx RoomChanged
	inx
	stx irq_detected
nochange
	; Store the number of IRQs detected in the meantime
	; and reset flag.
	lda irq_detected
	sta LastFrameTime
	lda #0
	sta irq_detected
	
	;Back to loop
	jmp _main_loop
.)


; META: Should we move this somewhere so the space is used in a buffer?
; It is about 55 bytes!
/*
GenerateTables
.(
	; Generate screen offset data
	lda #<DUMP_ADDRESS
	sta tmp0+0
	lda #>DUMP_ADDRESS
	sta tmp0+1

	ldx #0
loop
	; generate two bytes screen adress
	clc
	lda tmp0+0
	sta _HiresAddrLow,x
	adc #40
	sta tmp0+0
	lda tmp0+1
	sta _HiresAddrHigh,x
	adc #0
	sta tmp0+1

	inx
	cpx #240
	bne loop
	rts
.)
*/	
/*
	; Generate multiple of 6 data table
.(
    lda #0      ; cur div
    tay         ; cur mod
    tax
loop
    sta _TableDiv6,x
    iny
    cpy #6
    bne skip_mod
    ldy #0
    adc #0      ; carry = 1!
skip_mod

    inx
    cpx #240
    bne loop
.)
    rts
.)
*/

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ClearHires
; Clears text area
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ClearHires
.(
	ldy #<($a000)
	sty tmp
	ldy #>($a000)
	sty tmp+1
	ldx #200
loop2
	ldy #39
	lda #$40
loop
	sta (tmp),y
	dey
	bpl loop

	jsr add40tmp
	dex
	bne loop2
end
	rts	
.)

; Adds 40 to tmp
add40tmp
	lda #40
; Adds A to tmp
addAtmp	
.(
	clc
	adc tmp
	sta tmp
	bcc nocarry
	inc tmp+1
nocarry
	rts
.)


/*
SetHires
.(
	;lda $21f
	;bne end

	lda #30
	;lda $f934
	sta $bfdf
	
	lda #A_BGBLACK 
	sta $bf68
	sta $bf68+40
	sta $bf68+40*2
end
	rts
.)
*/
SetInk2
#if (FIRST_VIS_COL=1)
.(
	ldy #<(DUMP_ADDRESS)
	sty tmp
	ldy #>(DUMP_ADDRESS)
	sty tmp+1

	ldx #(ROOM_ROWS*8/2)
loop
	ldy #0
+smc_ink_1
	lda #A_FWYELLOW 
	sta (tmp),y
	
	ldy #40
+smc_ink_2
	lda #A_FWCYAN
	sta (tmp),y
	
	lda #80
	jsr addAtmp
	dex
	bne loop
end
	rts	

.)
#else
.(
	ldy #<(DUMP_ADDRESS)
	sty tmp
	ldy #>(DUMP_ADDRESS)
	sty tmp+1

	ldx #(ROOM_ROWS*8/2)
loop
	ldy #0
+smc_paper_1
	lda #A_BGBLACK
	sta (tmp),y
	iny
+smc_ink_1
	lda #A_FWYELLOW 
	sta (tmp),y
	
	ldy #40
+smc_paper_2
	lda #A_BGBLACK
	sta (tmp),y
	iny
+smc_ink_2
	lda #A_FWCYAN
	sta (tmp),y
	
	lda #80
	jsr addAtmp
	dex
	bne loop
end
	rts	
.)
#endif

