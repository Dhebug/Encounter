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
; Animatory state 0 (0-closing.png)
.byt 1, 2, 0, 0, 0
.byt 1, 3, 0, 0, 0
.byt 1, 4, 0, 0, 0
.byt 5, 6, 0, 0, 0
.byt 7, 6, 0, 0, 0
.byt 8, 9, 0, 0, 0
.byt 10, 11, 0, 0, 0
; Animatory state 1 (1-closed.png)
.byt 1, 12, 0, 0, 0
.byt 1, 13, 0, 0, 0
.byt 1, 14, 0, 0, 0
.byt 15, 16, 0, 0, 0
.byt 17, 18, 0, 0, 0
.byt 19, 20, 0, 0, 0
.byt 21, 22, 0, 0, 0
costume_tiles
; Tile graphic 1
.byt $2a, $15, $2a, $15, $2a, $15, $2a, $15
; Tile graphic 2
.byt $2a, $14, $28, $14, $28, $14, $28, $10
; Tile graphic 3
.byt $28, $10, $28, $10, $20, $10, $20, $10
; Tile graphic 4
.byt $20, $10, $20, $20, $20, $20, $20, $20
; Tile graphic 5
.byt $2a, $14, $2a, $15, $2b, $16, $28, $14
; Tile graphic 6
.byt $20, $20, $20, $20, $20, $20, $20, $20
; Tile graphic 7
.byt $29, $17, $2a, $14, $2a, $16, $2e, $16
; Tile graphic 8
.byt $2e, $1e, $2e, $1e, $2e, $1e, $2e, $1e
; Tile graphic 9
.byt $20, $20, $20, $20, $2a, $35, $2a, $35
; Tile graphic 10
.byt $2e, $1e, $3e, $1f, $2e, $1d, $2a, $d
; Tile graphic 11
.byt $2a, $35, $2a, $15, $2a, $15, $2a, $15
; Tile graphic 12
.byt $29, $17, $2d, $15, $2d, $15, $2d, $1d
; Tile graphic 13
.byt $2d, $1d, $2d, $1d, $3d, $1d, $3d, $1d
; Tile graphic 14
.byt $3d, $1d, $3d, $3d, $3d, $3d, $3b, $37
; Tile graphic 15
.byt $2b, $15, $2b, $15, $2b, $15, $2b, $17
; Tile graphic 16
.byt $2d, $29, $29, $2b, $2f, $2d, $29, $25
; Tile graphic 17
.byt $2b, $17, $2b, $17, $2f, $17, $2f, $17
; Tile graphic 18
.byt $3d, $3d, $3d, $3d, $3d, $3d, $3d, $3d
; Tile graphic 19
.byt $2f, $1f, $2f, $1f, $2f, $1f, $2f, $1f
; Tile graphic 20
.byt $3d, $3d, $3d, $3d, $3d, $3d, $3e, $3d
; Tile graphic 21
.byt $2f, $1f, $3f, $1f, $2e, $1d, $2a, $d
; Tile graphic 22
.byt $3a, $35, $2a, $15, $2a, $15, $2a, $15
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
; Tile mask 20
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 21
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 22
.byt $40, $40, $40, $40, $40, $40, $40, $40
res_end
.)

