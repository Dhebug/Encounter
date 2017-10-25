.(
.byt RESOURCE_COSTUME
.word (res_end - res_start + 4)
.byt 200
res_start
	; Pointers to tiles
	.byt <(costume_tiles-res_start-8), >(costume_tiles-res_start-8)
	.byt <(costume_masks-res_start-8), >(costume_masks-res_start-8)
	; Number of costumes included
	.byt 1
	;Offsets to animatory states for each costume
	.byt <(anim_states - res_start), >(anim_states - res_start)
anim_states
; Animatory state 0 (pulley1.png)
.byt 0, 0, 0, 0, 0
.byt 1, 2, 0, 0, 0
.byt 3, 4, 0, 0, 0
.byt 5, 5, 0, 0, 0
.byt 5, 5, 0, 0, 0
.byt 5, 5, 0, 0, 0
.byt 6, 7, 0, 0, 0
; Animatory state 1 (pulley2.png)
.byt 0, 0, 0, 0, 0
.byt 8, 9, 0, 0, 0
.byt 10, 11, 0, 0, 0
.byt 12, 13, 0, 0, 0
.byt 12, 13, 0, 0, 0
.byt 12, 13, 0, 0, 0
.byt 14, 15, 0, 0, 0
; Animatory state 2 (pulley3.png)
.byt 0, 0, 0, 0, 0
.byt 1, 2, 0, 0, 0
.byt 16, 17, 0, 0, 0
.byt 18, 18, 0, 0, 0
.byt 18, 18, 0, 0, 0
.byt 18, 18, 0, 0, 0
.byt 19, 20, 0, 0, 0
; Animatory state 3 (pulley4.png)
.byt 0, 0, 0, 0, 0
.byt 8, 9, 0, 0, 0
.byt 21, 22, 0, 0, 0
.byt 13, 12, 0, 0, 0
.byt 13, 12, 0, 0, 0
.byt 13, 12, 0, 0, 0
.byt 23, 24, 0, 0, 0
; Animatory state 4 (pulley5stopped.png)
.byt 0, 0, 0, 0, 0
.byt 8, 9, 0, 0, 0
.byt 25, 26, 0, 0, 0
.byt 27, 13, 0, 0, 0
.byt 12, 13, 0, 0, 0
.byt 12, 13, 0, 0, 0
.byt 14, 15, 0, 0, 0
costume_tiles
; Tile graphic 1
.byt $0, $0, $0, $3, $7, $f, $3e, $e
; Tile graphic 2
.byt $0, $20, $20, $30, $38, $3c, $1f, $1c
; Tile graphic 3
.byt $f, $7, $3, $8, $4, $4, $a, $a
; Tile graphic 4
.byt $3c, $38, $32, $22, $24, $4, $a, $a
; Tile graphic 5
.byt $4, $4, $a, $a, $4, $4, $a, $a
; Tile graphic 6
.byt $4, $4, $0, $0, $0, $0, $0, $0
; Tile graphic 7
.byt $4, $4, $0, $0, $0, $0, $0, $0
; Tile graphic 8
.byt $0, $0, $10, $b, $7, $f, $e, $e
; Tile graphic 9
.byt $0, $0, $2, $34, $38, $3c, $1c, $1c
; Tile graphic 10
.byt $f, $7, $b, $10, $4, $a, $a, $4
; Tile graphic 11
.byt $3c, $38, $34, $2, $8, $4, $4, $a
; Tile graphic 12
.byt $4, $a, $a, $4, $4, $a, $a, $4
; Tile graphic 13
.byt $a, $4, $4, $a, $a, $4, $4, $a
; Tile graphic 14
.byt $4, $a, $0, $0, $0, $0, $0, $0
; Tile graphic 15
.byt $a, $4, $0, $0, $0, $0, $0, $0
; Tile graphic 16
.byt $f, $7, $3, $4, $a, $a, $4, $4
; Tile graphic 17
.byt $3c, $38, $34, $24, $2a, $a, $4, $4
; Tile graphic 18
.byt $a, $a, $4, $4, $a, $a, $4, $4
; Tile graphic 19
.byt $a, $a, $0, $0, $0, $0, $0, $0
; Tile graphic 20
.byt $a, $a, $0, $0, $0, $0, $0, $0
; Tile graphic 21
.byt $f, $7, $b, $10, $a, $4, $4, $a
; Tile graphic 22
.byt $3c, $38, $34, $2, $4, $a, $a, $4
; Tile graphic 23
.byt $a, $4, $0, $0, $0, $0, $0, $0
; Tile graphic 24
.byt $4, $a, $0, $0, $0, $0, $0, $0
; Tile graphic 25
.byt $f, $7, $b, $14, $e, $1b, $e, $4
; Tile graphic 26
.byt $3c, $38, $34, $2, $8, $4, $4, $a
; Tile graphic 27
.byt $0, $a, $a, $4, $4, $a, $a, $4
costume_masks
; Tile mask 1
.byt $7e, $7c, $78, $70, $40, $40, $40, $40
; Tile mask 2
.byt $4f, $47, $47, $43, $40, $40, $40, $40
; Tile mask 3
.byt $40, $60, $60, $60, $60, $60, $60, $60
; Tile mask 4
.byt $40, $41, $40, $40, $40, $40, $60, $60
; Tile mask 5
.byt $60, $60, $60, $60, $60, $60, $60, $60
; Tile mask 6
.byt $40, $40, $40, $60, $ff, $ff, $ff, $ff
; Tile mask 7
.byt $40, $40, $40, $40, $ff, $ff, $ff, $ff
; Tile mask 8
.byt $ff, $47, $40, $40, $60, $60, $60, $60
; Tile mask 9
.byt $ff, $78, $40, $40, $41, $41, $41, $41
; Tile mask 10
.byt $60, $60, $40, $40, $40, $60, $60, $60
; Tile mask 11
.byt $41, $41, $40, $40, $60, $60, $60, $60
; Tile mask 12
.byt $60, $60, $60, $60, $60, $60, $60, $60
; Tile mask 13
.byt $60, $60, $60, $60, $60, $60, $60, $60
; Tile mask 14
.byt $40, $40, $40, $60, $ff, $ff, $ff, $ff
; Tile mask 15
.byt $40, $40, $40, $40, $ff, $ff, $ff, $ff
; Tile mask 16
.byt $40, $60, $60, $60, $60, $60, $60, $60
; Tile mask 17
.byt $40, $41, $41, $40, $40, $40, $60, $60
; Tile mask 18
.byt $60, $60, $60, $60, $60, $60, $60, $60
; Tile mask 19
.byt $40, $40, $40, $60, $ff, $ff, $ff, $ff
; Tile mask 20
.byt $40, $40, $40, $40, $ff, $ff, $ff, $ff
; Tile mask 21
.byt $60, $60, $40, $40, $40, $60, $60, $60
; Tile mask 22
.byt $41, $41, $40, $40, $60, $60, $60, $60
; Tile mask 23
.byt $40, $40, $40, $60, $ff, $ff, $ff, $ff
; Tile mask 24
.byt $40, $40, $40, $40, $ff, $ff, $ff, $ff
; Tile mask 25
.byt $60, $60, $40, $40, $40, $40, $40, $60
; Tile mask 26
.byt $41, $41, $40, $40, $40, $40, $40, $60
; Tile mask 27
.byt $60, $60, $60, $60, $60, $60, $60, $60
res_end
.)

