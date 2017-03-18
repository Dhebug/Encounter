;Exomizer 2 Z80 decoder - backwards
; by Metalbrain
;
; compression algorithm by Magnus Lind
;
;simple version:
;		no literal sequences
;		you MUST define exo_mapbasebits aligned to a 256 boundary

;input: 	hl=compressed data start
;		de=uncompressed destination start

deexo:		ld	a,(hl)
		dec	hl
		ld	ixh,a
		ld	b,52
		ld	iy,exo_mapbasebits
		push	de
exo_initbits:	ld	a,b
		sub	4
		and	15
		jr	nz,exo_node1
		ld	de,1		;DE=b2
exo_node1:	ld	c,16
exo_get4bits:	call	exo_getbit
		rl	c
		jr	nc,exo_get4bits
		ld	(iy+0),c	;bits[i]=b1

		push	hl
		inc	c
		ld	hl,0
		scf
exo_setbit:	adc	hl,hl
		dec	c
		jr	nz,exo_setbit
		ld	(iy+52),e
		ld	(iy+104),d	;base[i]=b2
		add	hl,de
		ex	de,hl
		inc	iy

		pop	hl
		djnz	exo_initbits
		pop	de
		jr	exo_mainloop
exo_literalcopy:ldd
exo_mainloop:	call	exo_getbit	;literal?
		jr	c,exo_literalcopy
		ld	c,255
exo_getindex:	inc	c
		call	exo_getbit
		jr	nc,exo_getindex
		ld	a,c		;C=index
		cp	16
		ret	z
		push	de
		call	exo_getpair
		push	bc
		pop	af
		ex	af,af'		;lenght in AF'
		ld	de,512+48	;2 bits, 48 offset
		dec	bc
		ld	a,b
		or	c
		jr	z,exo_goforit   ;1?
		ld	de,1024+32	;4 bits, 32 offset
		dec	bc
		ld	a,b
		or	c
		jr	z,exo_goforit   ;2?
		ld	e,16		;16 offset
exo_goforit:	call	exo_getbits
		ld	a,e
		add	a,c
		ld	c,a
		call	exo_getpair	;bc=offset
		pop	de		;de=destination
		push	hl
		ld	h,d
		ld	l,e
		add	hl,bc		;hl=origin
		ex	af,af'
		push	af
		pop	bc		;bc=lenght
		lddr
		pop	hl		;Keep HL, DE is updated
		jr	exo_mainloop	;Next!

exo_getpair:	ld	iyl,c
		ld	d,[iy+0]
		call	exo_getbits
		ld	a,c
		add	a,[iy+52]
		ld	c,a
		ld	a,b
		adc	a,[iy+104]
		ld	b,a
		ret

exo_getbits:	ld	bc,0
exo_gettingbits:dec	d
		ret	m
		call	exo_getbit
		rl	c
		rl	b
		jr	exo_gettingbits

exo_getbit:	ld	a,ixh
		srl	a
		ld	ixh,a
		ret	nz
		ld	a,(hl)
		dec	hl
		rra
		ld	ixh,a
		ret
