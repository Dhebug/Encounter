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
; Animatory state 0 (missingY.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 1, 2, 0, 0, 0
.byt 3, 4, 0, 0, 0
; Animatory state 1 (scissors.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 5, 6, 0, 0, 0
.byt 7, 8, 0, 0, 0
; Animatory state 2 (spray.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 9, 10, 0, 0, 0
.byt 11, 12, 0, 0, 0
; Animatory state 3 (tweezers.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 13, 14, 0, 0, 0
.byt 15, 16, 0, 0, 0
; Animatory state 4 (wrench.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 17, 18, 0, 0, 0
.byt 19, 20, 0, 0, 0
costume_tiles
; Tile graphic 1
.byt $16, $2a, $38, $3f, $1d, $3f, $37, $3f
; Tile graphic 2
.byt $16, $2a, $38, $3f, $37, $3f, $1d, $3f
; Tile graphic 3
.byt $1d, $3f, $37, $3f, $1d, $3a, $3d, $3f
; Tile graphic 4
.byt $37, $3f, $3d, $7, $17, $37, $15, $7
; Tile graphic 5
.byt $c, $12, $2d, $2d, $10, $c, $5, $4
; Tile graphic 6
.byt $18, $24, $1a, $1a, $1a, $4, $18, $10
; Tile graphic 7
.byt $4, $4, $4, $4, $4, $2, $3, $0
; Tile graphic 8
.byt $10, $10, $10, $20, $20, $20, $20, $0
; Tile graphic 9
.byt $0, $0, $0, $0, $0, $0, $1, $2
; Tile graphic 10
.byt $0, $0, $0, $0, $0, $0, $30, $8
; Tile graphic 11
.byt $2, $4, $b, $b, $0, $b, $b, $4
; Tile graphic 12
.byt $10, $8, $34, $14, $0, $14, $34, $8
; Tile graphic 13
.byt $3, $2, $2, $2, $2, $2, $2, $2
; Tile graphic 14
.byt $38, $28, $28, $28, $28, $28, $8, $8
; Tile graphic 15
.byt $4, $9, $9, $9, $9, $9, $4, $3
; Tile graphic 16
.byt $4, $32, $32, $32, $32, $32, $24, $38
; Tile graphic 17
.byt $3, $4, $8, $e, $17, $13, $10, $8
; Tile graphic 18
.byt $20, $10, $8, $4, $12, $2, $4, $8
; Tile graphic 19
.byt $4, $4, $4, $5, $5, $4, $2, $1
; Tile graphic 20
.byt $10, $10, $10, $10, $10, $10, $20, $0
costume_masks
; Tile mask 1
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 2
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 3
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 4
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 5
.byt $73, $61, $40, $40, $60, $70, $78, $78
; Tile mask 6
.byt $67, $43, $41, $41, $41, $43, $47, $4f
; Tile mask 7
.byt $78, $78, $78, $78, $78, $7c, $7c, $ff
; Tile mask 8
.byt $4f, $4f, $4f, $5f, $5f, $5f, $5f, $ff
; Tile mask 9
.byt $ff, $ff, $ff, $ff, $ff, $ff, $7e, $7c
; Tile mask 10
.byt $ff, $ff, $ff, $ff, $ff, $ff, $4f, $47
; Tile mask 11
.byt $7c, $78, $70, $70, $40, $70, $70, $78
; Tile mask 12
.byt $4f, $47, $43, $43, $40, $43, $43, $47
; Tile mask 13
.byt $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
; Tile mask 14
.byt $47, $47, $47, $47, $47, $47, $47, $47
; Tile mask 15
.byt $78, $70, $70, $70, $70, $70, $78, $7c
; Tile mask 16
.byt $43, $41, $41, $41, $41, $41, $43, $47
; Tile mask 17
.byt $7c, $78, $70, $70, $60, $60, $60, $70
; Tile mask 18
.byt $5f, $4f, $47, $43, $41, $41, $43, $47
; Tile mask 19
.byt $78, $78, $78, $78, $78, $78, $7c, $7e
; Tile mask 20
.byt $4f, $4f, $4f, $4f, $4f, $4f, $5f, $ff
res_end
.)

