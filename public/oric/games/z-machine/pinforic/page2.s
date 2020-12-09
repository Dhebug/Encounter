PG_COUNT = 19
pg_table = $ff00
pg_start = $d900
NEXT	= 2
PREV	= 3

_cur_page .byte 0
MRU	.byte 0

; pg_table is a table of PG_COUNT structures, each one consisting of 4 bytes :
; a page number (1 byte, plus a second byte in case we switch to >128K games
; one day), a byte offset pointing to the next structure, and a byte offset
; to the previous structure.
; A circular list is handled in the same way as in the C version, MRU is the
; byte offset pointing to the structure designating the most recently used page.

_pg_init
	lda #PG_COUNT
	asl
	asl
	sta tmp

	lda #0
	tax
	ldy #256-4
pg_init2
	lda #0
	sta pg_table,x
	tya
	sta pg_table+NEXT,x
	txa
	tay
	inx
	inx
	inx
	inx
	txa
	sta pg_table+PREV,y

	cpx tmp
	bne pg_init2

	sty MRU
	sty pg_table+NEXT
	lda #0
	sta pg_table+PREV,y
	rts
	

wanted	.byte 0
current	.byte 0
next	.byte 0
prev	.byte 0

_fetch_page
	ldy #0 
	lda (sp),y 
fetch_page
	sta wanted 

	ldy MRU 
	sty current 

	lda pg_table,y 
	cmp wanted
	beq found

	ldx #4		; don't take time to insert the page in MRU position if
			; it is already among the 5 first in the list
fast_search

	lda pg_table+NEXT,y
	sta current 
	tay

	lda pg_table,y 
	cmp wanted
	beq found

	dex
	bne fast_search

	lda #PG_COUNT
	asl
	asl
	tay
browse
	dey
	dey
	dey
	dey
	bmi not_found
	lda pg_table,y
	cmp wanted
	bne browse

	sty current
	lda pg_table+NEXT,y
	sta next
	lda pg_table+PREV,y
	sta prev
			; extract current from the list : chain prev and next
			; prev.next = next
			; next.prev = prev
	lda next
	ldy prev
	sta pg_table+NEXT,y

	lda prev
	ldy next
	sta pg_table+PREV,y
			; insert current between MRU and its prev (circular list)
			; current.next = MRU
	lda MRU
	ldy current
	sta pg_table+NEXT,y
			; prev = current.prev = MRU.prev 
			; MRU.prev = current
	tay
	lda pg_table+PREV,y
	sta prev
	lda current
	sta pg_table+PREV,y
	tay
	lda prev
	sta pg_table+PREV,y
			; current.prev.next = current
	tay
	lda current
	sta pg_table+NEXT,y
			; MRU = current
	sta MRU

found
	lda current
	lsr
	adc #>(pg_start)
	ldx #<(pg_start)
	rts
	
not_found
	ldy MRU
	lda pg_table+PREV,y
	sta current

	tay
	lda pg_table,y
	cmp _cur_page
	bne fetch_from_disk

	lda pg_table+PREV,y
	sta current
	tay

fetch_from_disk
	lda wanted
	sta pg_table,y
	sty MRU

	ldy #0
	sta (sp),y
	tya
	iny
	sta (sp),y
	iny
	lda #1
	sta (sp),y
	iny
	lda #0
	sta (sp),y
	iny
	lda #<(pg_start)
	sta (sp),y
	iny
	lda current
	lsr
	adc #>(pg_start)
	sta (sp),y
	iny
	jsr _load_page

	jmp found
