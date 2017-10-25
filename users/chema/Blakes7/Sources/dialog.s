/*;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ------------------------------------------
;;                 OASIS
;; Oric Adventure Script Interpreting System
;; ------------------------------------------
;;	       (c) Chema 2015
;;            enguita@gmail.com
;; ------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;*/

;; Managing dialog puzzles

#include "verbs.h"
#include "inventory.h"
#include "script.h"

#define MAX_DLG_OPTIONS	6	; Maximum dlg options shown at the same time

; NOTE: A dialog is defined by a set of data (data.s):
; DlgStringRes is the stringpack resource with strings to print as options
; DlgActiveOptions 16 entries indicating which sttings are active?. Entry is string ID. Ends with $ff
; DlgScript Script ID with responses
; DlgOffsetsLo/hi 16 byte each with offsets for each possible option

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Loads a dialog resource
; and updates internal structures
; so it can be used with StartDialog, etc.
; It is called with A=dialog resource ID
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
LoadAndInstallDialog
.(
	pha
	tax
	jsr LoadDialog
	sta tmp0
	sty tmp0+1
	
	ldy #0
	lda (tmp0),y ; String ID
	sta DlgStringRes
	iny
	lda (tmp0),y ; Sctipt for responses
	sta DlgScript
	
	; Active options
	; Should copy the final $ff too!
.(
	ldx #0
	iny
loop
	lda (tmp0),y
	sta DlgActiveOptions,x
	bmi end
	iny
	inx
	bne loop	; In practice jumps always
end
.)
	; Store number of options
	stx tmp
	; Responses are in offsets inside the
	; corresponding script.
	; Store offsets 
	iny
	ldx #0
.(
loop
	lda (tmp0),y
	sta DlgOffsetsLo,x
	iny
	lda (tmp0),y
	sta DlgOffsetsHi,x
	iny
	inx
	dec tmp
	bpl loop
.)
	; Nuke resource, it is no more needed
	pla
	tax
	jmp NukeDialog
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Starts a loaded dialog
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
StartDialog
	lda #1
	sta InDialogMode
PrintDialogOptions
.(
	; Remove mouse and clear all the area
	jsr SetMouseOff
	jsr ClearVerbArea
	jsr ClearInventoryArea	
	jsr ClearCommandArea

	; Check if there is only one option
	; and automatically run it if that
	; is the case
	ldx #0
	ldy #2
loop1op
	lda DlgActiveOptions,x
	bpl nextop
	; The first iteration this can't be true: de dialog must have at least one option
	; The second time the justoneoptionentry+1 set up correctly
	; There are no more iterations here.
	; META: This should be cleaned and tidied up!
	jmp justoneoption
nextop		
	beq skip1op
	stx justoneoptionentry+1	
	dey
	beq notone
skip1op
	inx
	bne loop1op ; branches always.
notone	
	; More than one option, so let's
	; iterate printing them all (all that can be displayed)
	lda #MAX_DLG_OPTIONS
	sta dlg_count2
	lda #144
	sta dlg_row
	ldx #0
	stx dlg_count
loop
	lda DlgActiveOptions,x
	bmi end
	beq next
	; A string has to be printed
	ldx #0
	lda dlg_row
	tay
	clc
	adc #8
	sta dlg_row
	jsr gotoXY

	lda #UNSEL_VERB_COLOR
	jsr put_code
	ldx DlgStringRes
	lda dlg_count
	jsr LoadAndPrintString
	
	dec dlg_count2
	beq end
next
	inc dlg_count
	ldx dlg_count
	bne loop	; In practice jumps always
end	
	jmp SetMouseOn
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Terminates the dialog
; and gets back to normal menu
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
EndDialog
	lda #0
	sta InDialogMode
	jsr SetMouseOff	
	jsr InitVerbs
	jsr DrawInventoryEx
	jmp SetMouseOn
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Handles Mouse Moves in Dialog mode
; This is quite straightforward, 
; just highlight the option when
; the mouse is over.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
MMDialogMode
.(
	lda #5
	sta dlg_count
	lda #144+40
	sta dlg_row
loop
	ldx #0
	ldy dlg_row
	jsr gotoXY
	lda plotY
	sec
	sbc #144
	lsr
	lsr
	lsr
	cmp dlg_count
	beq sel
	lda #UNSEL_VERB_COLOR
	.byt $2c
sel
	lda #SEL_VERB_COLOR
	jsr put_code

	lda dlg_row
	sec
	sbc #8
	sta dlg_row
	
	dec dlg_count
	bpl loop
	
end	
	rts
.)	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Handles mouse clicks when
; in dialog mode.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MCDialogMode
.(
	; Look if clicked over
	; a dialog option and which
	; one, based on the Y position.
	lda clickY
	sec
	sbc #144-8
	lsr
	lsr
	lsr
	sta dlg_count
	; Find option number
	ldx #0
loop
	lda DlgActiveOptions,x
	bmi end
	beq next
	dec dlg_count
	beq found
next
	inx
	bne loop	; In practice jumps always
end
	; Nothing found, just return
	rts
	
found
	; The user clicked on a dialog option
	; reg X contains which one.
	stx savx+1
	
	; This entry point is used when there is only one option
	; in the dialog, so it is automatically selected
	; The option is stored by modifying the address
	; justoneoptionentry below
+justoneoption	
	; Make a sound
	lda #SFX_UIB
	jsr _PlaySfx	
	
	; Okay, we have all we need to make
	; the ego say the sentence.
	; Remove all options
	jsr SetMouseOff
	jsr ClearVerbArea
	jsr ClearInventoryArea
	
	; Make the ego say the option
	lda _CurrentEgo
	jsr getObjectEntry	
	lda DlgStringRes
+justoneoptionentry
savx
	ldy #0
	jsr Say
	
	; Run the associated script code

	ldx DlgScript
	ldy #$ff
	jsr LoadAndInstallScript

	ldy savx+1
	lda DlgOffsetsLo,y
	sta param_blk+5
	lda DlgOffsetsHi,y
	sta param_blk+6
	jmp SetScriptOffsetFromParam ; jsr/rts
	
	; Just return here and rely on the
	; script to decide to set more
	; dialog, print verbs,...
	;rts
.)

