.(
.byt RESOURCE_COSTUME
.word (res_end - res_start + 4)
.byt 201
res_start
	; Pointers to tiles
	.byt <(costume_tiles-res_start-8), >(costume_tiles-res_start-8)
	.byt <(costume_masks-res_start-8), >(costume_masks-res_start-8)
	; Number of costumes included
	.byt 1
	;Offsets to animatory states for each costume
	.byt <(anim_states - res_start), >(anim_states - res_start)
anim_states
; Animatory state 0 (openlocker.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 0
.byt 5, 6, 7, 8, 0
.byt 9, 10, 11, 12, 0
.byt 13, 14, 15, 15, 0
.byt 16, 17, 18, 19, 0
costume_tiles
; Tile graphic 1
.byt $3e, $3e, $3e, $22, $2c, $e, $2f, $2f
; Tile graphic 2
.byt $3f, $3f, $3f, $3f, $3f, $0, $20, $10
; Tile graphic 3
.byt $3f, $3f, $3f, $3f, $3f, $0, $0, $0
; Tile graphic 4
.byt $3e, $3e, $3e, $3e, $3e, $0, $0, $0
; Tile graphic 5
.byt $2f, $2f, $2f, $2f, $2f, $2f, $2f, $2f
; Tile graphic 6
.byt $8, $7, $4, $4, $4, $4, $5, $5
; Tile graphic 7
.byt $0, $3f, $0, $0, $0, $0, $3f, $1f
; Tile graphic 8
.byt $0, $3f, $0, $0, $0, $0, $3e, $3a
; Tile graphic 9
.byt $2f, $2f, $2f, $2f, $2f, $27, $2f, $27
; Tile graphic 10
.byt $5, $5, $5, $5, $5, $4, $f, $3f
; Tile graphic 11
.byt $2f, $37, $3b, $3c, $3f, $0, $3f, $3f
; Tile graphic 12
.byt $36, $2e, $1e, $3e, $3e, $0, $3f, $3f
; Tile graphic 13
.byt $27, $27, $27, $2f, $2d, $2b, $2d, $2b
; Tile graphic 14
.byt $4, $4, $4, $4, $4, $4, $4, $4
; Tile graphic 15
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 16
.byt $2d, $2b, $2f, $2f, $f, $c, $23, $37
; Tile graphic 17
.byt $7, $8, $10, $20, $0, $0, $3f, $1d
; Tile graphic 18
.byt $3f, $0, $0, $0, $0, $0, $3c, $37
; Tile graphic 19
.byt $3f, $0, $0, $0, $0, $0, $0, $1d
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
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 6
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 7
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 8
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 9
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 10
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 11
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 12
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 13
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 14
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 15
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 16
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 17
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 18
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 19
.byt $40, $40, $40, $40, $40, $40, $40, $40
res_end
.)

