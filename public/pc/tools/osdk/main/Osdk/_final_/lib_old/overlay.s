
_is_overlay_enabled
	;jmp _is_overlay_enabled
.(
	; The overlay test involves writting data, 
	; so we disable interrupts to avoid side
	; effects like a nasty crash.	
	php
	sei
	
	; Read the old value
	lda $ffff

	; Try to write 255
	ldx #$FF
	stx $ffff
	cpx $ffff
	bne not_what_I_wrote
		
	; Try to write 0
	ldx #0
	stx $ffff
	cpx $ffff
	bne not_what_I_wrote

	; Ram is enabled: Restore the old value
	sta $ffff
	ldx #1
	jmp end
		
not_what_I_wrote		
	; Value is not what I wrote, so this must be ROM
	ldx #0
	
end	
	; Restore interrupts
	plp
	lda #0
	rts
.)