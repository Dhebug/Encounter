
_sedoric		; invoke a SEDORIC command using black magic
			; Watch it! I have reasons to believe this is broken
        ldy #$0         ; grab string pointer
        lda (sp),y
        sta tmp
        iny
        lda (sp),y
        sta tmp+1
        dey

sedoricloop1            ; copy the string to #35..#84
        lda (tmp),y
        sta $35,y
        iny
        ora #$0
        bne sedoricloop1

        sta $ea         ; update the line start pointer
        lda #$35;
        sta $e9

        jsr $00e2       ; get next token
        jmp ($02f5)     ; call the ! command handler


;;;;;;;;;;;;;;;; Routines to manage disk...

#ifdef0
_dbug
	lda #0
dbug
	beq dbug
	rts
#endif
diskcntrl .byt $86

_switch_eprom
    lda $0314
    and #%01111101
    sta $0314
	rts

_switch_ovl 
	php
	pha
	sei
	lda diskcntrl
	eor #2
	sta diskcntrl
	sta $0314
	pla
	plp
	rts



_reboot_oric
.(
    lda $0314
    and #%01111101
    sta $0314
    
    ldx #0
    txs

    jmp $eb7e 

.)


