; HIRES TEXT scrolltext
; scrolls a doubled height text line at the bottom of HIRES screen

	;; char *gText
_gText	.word 0
	;; int gLen
;_gLen	.word 0
;_gPtr	.word 0
;_gPtr2	.word 0
_gOffset	.byt 0
	;; bool gOnce :	if scrolled entirely at least once
_gOnce	.byt 0
	
#define OFFSET_X 0
#define OFFSET_Y 1
#define TEXTVRAM    $bb80
#define SCROLL_BASE_1 TEXTVRAM+40*25+40*OFFSET_Y+OFFSET_X
#define SCROLL_BASE_2 TEXTVRAM+40*25+40*OFFSET_Y+OFFSET_X+40
#define A_STD2H 	10

; _thetext .byt "abcd"
	
	;; hires_scroll_text_set(const chr *str, char color)
_hires_scroll_text_set
	
	;jsr _strlen		; gLen = strlen(str)
	;sta _gLen
	lda #0
	sta _gOffset		; _gOffset = 0;
	sta _gOnce		; _gOnce = 0;
        tay			; _gText = str;
        lda (sp),y
        sta _gText
	sta _hires_scroll_text_slice_ptr1+1
        iny
        lda (sp),y
	sta _gText+1
	sta _hires_scroll_text_slice_ptr1+2
	iny
	lda (sp),y		; X = color
	tax

	

	ldy #0			; gPtr[0] = _STD2H
	lda #A_STD2H
	sta SCROLL_BASE_1,y
	sta SCROLL_BASE_2,y
	
	iny			; gPtr[1] = color
	txa
	sta SCROLL_BASE_1,y
	sta SCROLL_BASE_2,y

; 	ldy #20
; 	lda #"a"
; 	sta SCROLL_BASE_1,y
; 	sta SCROLL_BASE_2,y
; 	iny
; 	lda #"b"
; 	sta SCROLL_BASE_1,y
; 	sta SCROLL_BASE_2,y

	
	rts


	
	;; hires_scroll_text_slice(void)
_hires_scroll_text_slice
	ldy #2
	
	;; save first if attr
	lda SCROLL_BASE_1,y
	and #$60
	bne _hires_scroll_text_slice_not_attr
	lda SCROLL_BASE_1,y
	sta SCROLL_BASE_1-1,y
	sta SCROLL_BASE_2-1,y
_hires_scroll_text_slice_not_attr

	;; loop and scroll existing text
_hires_scroll_text_slice_loop1
	lda SCROLL_BASE_1+1,y
	sta SCROLL_BASE_1,y
	sta SCROLL_BASE_2,y
	iny
	cpy #39
	bne _hires_scroll_text_slice_loop1
	
	
	;; insert new char
	ldx _gOffset
	
_hires_scroll_text_slice_ptr1
	lda $ffff,x
	bne _hires_scroll_text_slice_skip1
	lda #1
	sta _gOnce
	ldx #0
	jmp _hires_scroll_text_slice_ptr1
_hires_scroll_text_slice_skip1
	inx
	stx _gOffset
; 	lda #"c"		; 
	sta SCROLL_BASE_1,y
	sta SCROLL_BASE_2,y
	
	rts




_hires_scroll_text_is_once
; 	lda _gOnce
; 	tax
; 	sta tmp0
; 	lda #0
; 	sta tmp0+1
; 	rts
	;; ??? WTF
	lda _gOnce
	sta tmp0 ;
	lda #0
	ldx tmp0
	; stx tmp0
	bpl *+4
	lda #$FF
	sta tmp0+1
	ldx tmp0
	lda tmp0+1
	rts
