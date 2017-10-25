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
; Animatory state 0 (1-faceA.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 0, 0
.byt 4, 5, 6, 0, 0
; Animatory state 1 (2-faceB.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 0, 0
.byt 7, 8, 9, 0, 0
; Animatory state 2 (3-faceB.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 0, 0
.byt 7, 10, 9, 0, 0
costume_tiles
; Tile graphic 1
.byt $3, $4, $b, $b, $a, $b, $13, $17
; Tile graphic 2
.byt $3f, $f, $30, $3f, $c, $1e, $3f, $2d
; Tile graphic 3
.byt $30, $38, $c, $34, $14, $34, $32, $3a
; Tile graphic 4
.byt $17, $b, $5, $5, $2, $1, $f, $1f
; Tile graphic 5
.byt $33, $3f, $21, $3f, $33, $1e, $21, $3f
; Tile graphic 6
.byt $3a, $34, $28, $28, $10, $20, $3c, $3e
; Tile graphic 7
.byt $17, $b, $5, $5, $2, $0, $f, $1f
; Tile graphic 8
.byt $33, $3f, $21, $21, $3f, $33, $1e, $21
; Tile graphic 9
.byt $3a, $34, $28, $28, $10, $0, $3c, $3e
; Tile graphic 10
.byt $33, $3f, $33, $33, $3f, $33, $1e, $21
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
res_end
.)

