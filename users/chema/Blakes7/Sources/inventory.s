/*;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ------------------------------------------
;;                 OASIS
;; Oric Adventure Script Interpreting System
;; ------------------------------------------
;;	       (c) Chema 2015
;;            enguita@gmail.com
;; ------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;*/

#include "inventory.h"
#include "gameids.h"
; Managing inventory
	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Initializes the inventory
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
InitInventory
.(
	lda #0
	sta nObjectsInventory
	sta first_item_shown
+near_rts		
	rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Print inventory in inventory area
; DrawInventoryEx entry point does not 
; clear the area first
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
UpdateInventory
.(
#define count op1
#define row op1+1
	; If in dialog mode, inventory is not shown... skip all
	lda InDialogMode
	bne near_rts	
	; If Verbs not shown, skip too...
	lda VerbsShown
	beq near_rts

	jsr ClearInventoryArea
+DrawInventoryEx	
	jsr HideMouse
	lda nObjectsInventory
	beq end

	; Should draw an arrow in the first row if can be scrolled
	lda first_item_shown
	;clc
	;adc #VISIBLE_INV_ITEMS
	;cmp nObjectsInventory
	;bcs noarrowup
	beq noarrowup
	
	ldy #INVENTORY_AREA_FIRSTLINE-8
	ldx #INVENTORY_AREA_START
	jsr gotoXY
	lda #A_FWMAGENTA ;+A_FWCYAN*8+128+64
	jsr put_code
	lda #123
	jsr put_code
noarrowup
	lda first_item_shown
	;beq noarrowdown
	clc
	adc #VISIBLE_INV_ITEMS
	cmp nObjectsInventory
	bcs noarrowdown

	ldy #INVENTORY_AREA_FIRSTLINE+(8*(VISIBLE_INV_ITEMS))
	ldx #INVENTORY_AREA_START
	jsr gotoXY
	lda #A_FWMAGENTA ;+A_FWCYAN*8+128+64
	jsr put_code	
	lda #124
	jsr put_code	
noarrowdown	

	lda #0
	sta count
	ldy #INVENTORY_AREA_FIRSTLINE
	sty row
loop
	ldy row
	ldx #INVENTORY_AREA_START
	jsr gotoXY
	lda #7
	jsr put_code
	lda #<inventory_names
	sta tmp0
	lda #>inventory_names
	sta tmp0+1	
	
	lda count
	clc
	adc first_item_shown
	tax
	
	;jsr SearchStringAndPrint
	jsr PrintObjName
	
	lda row
	clc
	adc #8 ;#CHARSET_HEIGHT+1 META: IGNORING CHARSET HEIGTH!!!
	sta row
	
	inc count
	lda count
	cmp #VISIBLE_INV_ITEMS
	bcs end
	cmp nObjectsInventory
	bcc loop
end	
	jsr ShowMouse
	rts
;count .byt 0	
;row   .byt 0

#undef count
#undef row
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Clears the inventory area
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ClearInventoryArea
.(
	jsr HideMouse
	ldx #INVENTORY_AREA_START
	ldy #INVENTORY_AREA_FIRSTLINE-8
	jsr auxPixelAddress
	
	ldx #(200-INVENTORY_AREA_FIRSTLINE)
looprow	
	ldy #(39-(INVENTORY_AREA_START/6))
	lda #$40
loop	
	sta (tmp),y
	dey
	bpl loop
	
	dex
	beq end
	
	jsr add40tmp
	jmp looprow
end	
	jmp ShowMouse

.)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Scrolls the inventory list 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ScrollInventoryDown
.(
	lda first_item_shown
	bne doit
	rts
doit	
	dec first_item_shown
	jmp UpdateInventory
.)	
ScrollInventoryUp
.(
	lda first_item_shown
	clc
	adc #VISIBLE_INV_ITEMS
	cmp nObjectsInventory
	bcc doit
	rts
doit
	inc first_item_shown
	jmp UpdateInventory	
.)
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Insert an object in the inventory
; Params: regA is object's ID
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ObjectToInventory
.(
	; Add ID to the inventory list and increment
	; number of objects in inventory
	ldx nObjectsInventory
	sta inventory_id,x
	
	
	;; META: ONE INVENTORY FOR NOW
	; If the object is in the array of actors
	; 	copy object flags from there
	; 	copy name from there
	;	Nuke Costume ?
	;	remove array entry
	; else
	; 	LoadObjectData resource
	; 	Add object flags
	; 	Add name	
	
	jsr getObjectEntry
	cpx #$ff
	beq object_not_loaded	; The object is not in the array
	
	; The object is in the array
	; Remove object from main array
	lda #OBJ_EMPTY_ENTRY
	sta obj_id,x
	
	; Mark it for redraw (in case it is in this room)
	; to make sure it disappears and nuke costume
	lda room,x
	cmp _CurrentRoom
	bne skip
	lda costume_id,x
	cmp #$ff
	beq nonuke
	stx savx+1
	tax
	jsr NukeCostume
savx
	ldx #0
nonuke	
	jsr UpdateSRBsp
skip	
	; Copy flags
	ldy nObjectsInventory
	lda flags,x
	sta inventory_flags,y
	
	; Copy object name
	
	jsr getObjNameEntry
	lda tmp0
	sta tmp1
	lda tmp0+1
	sta tmp1+1
	
	ldx nObjectsInventory
	lda #<inventory_names
	sta tmp0
	lda #>inventory_names
	sta tmp0+1
	jsr getObjNameEntryEx
	
	ldy #$ff
loop
	iny
	lda (tmp1),y
	sta (tmp0),y
	bne loop

	jsr postRemovingObjects 

end	
	lda #SFX_PICK
	jsr _PlaySfx
	inc nObjectsInventory
	lda nObjectsInventory
	sec
	sbc #VISIBLE_INV_ITEMS
	bmi skips
	sta first_item_shown
skips	
	jmp UpdateInventory
		
	
object_not_loaded
	; Load object resource to get some data
	pha
	tax
	jsr LoadObject
	sty tmp0+1
	sta tmp0

	; Copy flags
	ldx nObjectsInventory
	ldy #0
	lda (tmp0),y
	sta inventory_flags,x
	
	; Copy object name
	and #OBJ_FLAG_PROP
	bne skipc
	lda #15
	.byt $2c
skipc
	lda #15-4
	clc
	adc tmp0
	sta tmp1
	lda tmp0+1
	adc #0
	sta tmp1+1
		
	ldx nObjectsInventory
	lda #<inventory_names
	sta tmp0
	lda #>inventory_names
	sta tmp0+1
	jsr getObjNameEntryEx
	
	ldy #$ff
loopn
	iny
	lda (tmp1),y
	sta (tmp0),y
	bne loopn
	
	; Mark resource for deletion
	pla
	tax
	jsr NukeObject	
	jmp end
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Get the entry in the inventory
; for a given object id passed in A
; returns entry in X, $ff if not found
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
getInventoryEntry
.(
	cmp $ff
	beq notfound
	ldx nObjectsInventory
	beq notfound
	dex
loop	
	cmp inventory_id,x
	beq found
	dex
	bpl loop
notfound	
	ldx #$ff
found
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Remove object from inventory
; ID is passed in reg AS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ObjectOutOfInventory
.(
	jsr getInventoryEntry
	cpx #$ff
	bne doit
	rts
doit
	; Copy rest of list over this position	
loop
	cpx nObjectsInventory
	beq endl
	lda inventory_id+1,x
	sta inventory_id,x
	lda inventory_flags+1,x
	sta inventory_flags,x
	stx savx+1
	
	lda #<inventory_names
	sta tmp0
	lda #>inventory_names
	sta tmp0+1	
	jsr getObjNameEntryEx
	
	lda tmp0
	clc
	adc #OBJ_NAME_LEN
	sta tmp1	
	lda tmp0+1
	adc #0
	sta tmp1+1
	
	ldy #OBJ_NAME_LEN-1
loopn
	lda (tmp1),y
	sta (tmp0),y
	dey
	bpl loopn

savx
	ldx #0
	inx
	bne loop	; Always jumps
endl
	lda #SFX_DROP
	jsr _PlaySfx
	dec nObjectsInventory
	lda #0
	sta first_item_shown
	jmp UpdateInventory
.)
