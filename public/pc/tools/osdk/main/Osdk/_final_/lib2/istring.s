; String routines #1

;
; isalpha(c)
;
_isalpha
	ldy #0
	lda (sp),y	;low byte of c
	tax
	lda ctype,x
	and #$03	;_U | _L
	beq isalpha1
	jmp true
isalpha1
	jmp false

;
; isupper(c)
;
_isupper
	ldy #0
	lda (sp),y	;low byte of c
	tax
	lda ctype,x
	and #$01	;_U
	beq isupper1
	jmp true
isupper1
	jmp false



;
; islower(c)
;
_islower
	ldy #0
	lda (sp),y	;low byte of c
	tax
	lda ctype,x
	and #$02	;_L
	beq islower1
	jmp true
islower1
	jmp false
;
; isdigit(c)
;
_isdigit
	ldy #0
	lda (sp),y	;low byte of c
	tax
	lda ctype,x
	and #$04	;_N
	beq isdigit1
	jmp true
isdigit1
	jmp false
;
; isxdigit(c)
;
_isxdigi
	ldy #0
	lda (sp),y	;low byte of c
	tax
	lda ctype,x
	and #$44	;_N | _X
	beq isxdigit1
	jmp true
isxdigit1
	jmp false
;
; isspace(c)
;
_isspace
	ldy #0
	lda (sp),y	;low byte of c
	tax
	lda ctype,x
	and #$08	;_S
	beq isspace1
	jmp true
isspace1
	jmp false
;
; ispunct(c)
;
_ispunct
	ldy #0
	lda (sp),y	;low byte of c
	tax
	lda ctype,x
	and #$10	;_P
	beq ispunct1
	jmp true
ispunct1
	jmp false
;
; isalnum(c)
;
_isalnum
	ldy #0
	lda (sp),y	;low byte of c
	tax
	lda ctype,x
	and #$07	;_U | _L | _N
	beq isalnum1
	jmp true
isalnum1
	jmp false
;
; isprint(c)
;
_isprint
	ldy #0
	lda (sp),y	;low byte of c
	tax
	lda ctype,x
	and #$17	;_P | _U | _L | _N
	beq isprint1
	jmp true
isprint1
	jmp false
;
; iscntrl(c)
;
_iscntrl
	ldy #0
	lda (sp),y	;low byte of c
	tax
	lda ctype,x
	and #$20	;_C
	beq iscntrl1
	jmp true
iscntrl1
	jmp false
;
; isascii(c)
;
_isascii
	ldy #0
	lda (sp),y	;low byte of c
	and #$80	;0 if <= 127
	eor #$80	;invert
	beq isascii1
	jmp true
isascii1
	jmp false
