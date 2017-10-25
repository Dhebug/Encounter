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
; Animatory state 0 (00-silence1A.png)
.byt 0, 0, 0, 0, 0
.byt 0, 1, 2, 2, 0
.byt 0, 2, 2, 2, 0
.byt 0, 2, 2, 2, 0
.byt 0, 2, 2, 2, 0
.byt 0, 2, 2, 2, 0
.byt 0, 4, 5, 2, 0
; Animatory state 1 (01-silence2A.png)
.byt 0, 0, 0, 0, 0
.byt 0, 6, 2, 2, 0
.byt 0, 2, 3, 2, 0
.byt 0, 2, 2, 2, 0
.byt 0, 2, 2, 2, 0
.byt 0, 7, 2, 2, 0
.byt 0, 4, 5, 2, 0
; Animatory state 2 (02-speak1A.png)
.byt 0, 0, 0, 0, 0
.byt 0, 1, 2, 2, 0
.byt 0, 2, 2, 2, 0
.byt 0, 8, 8, 8, 0
.byt 0, 2, 2, 2, 0
.byt 0, 2, 2, 2, 0
.byt 0, 4, 5, 2, 0
; Animatory state 3 (03-speak2A.png)
.byt 0, 0, 0, 0, 0
.byt 0, 6, 2, 2, 0
.byt 0, 2, 3, 2, 0
.byt 0, 8, 8, 8, 0
.byt 0, 2, 2, 2, 0
.byt 0, 7, 2, 2, 0
.byt 0, 4, 5, 2, 0
; Animatory state 4 (04-silence1B.png)
.byt 0, 0, 0, 0, 0
.byt 2, 2, 2, 9, 0
.byt 3, 2, 2, 2, 0
.byt 2, 2, 2, 2, 0
.byt 2, 10, 10, 2, 0
.byt 2, 2, 2, 2, 0
.byt 2, 2, 11, 12, 0
; Animatory state 5 (05-silence2B.png)
.byt 0, 0, 0, 0, 0
.byt 2, 2, 3, 13, 0
.byt 2, 2, 2, 2, 0
.byt 2, 2, 2, 2, 0
.byt 10, 10, 2, 14, 0
.byt 2, 2, 2, 2, 0
.byt 2, 3, 11, 15, 0
; Animatory state 6 (05-speak1B.png)
.byt 0, 0, 0, 0, 0
.byt 2, 2, 2, 9, 0
.byt 3, 2, 2, 2, 0
.byt 8, 8, 8, 8, 0
.byt 2, 10, 10, 2, 0
.byt 2, 2, 2, 2, 0
.byt 2, 2, 11, 12, 0
; Animatory state 7 (06-speak2B.png)
.byt 0, 0, 0, 0, 0
.byt 2, 2, 3, 13, 0
.byt 2, 2, 2, 2, 0
.byt 8, 8, 8, 8, 0
.byt 10, 10, 2, 14, 0
.byt 2, 2, 2, 2, 0
.byt 2, 3, 11, 15, 0
costume_tiles
; Tile graphic 1
.byt $8, $30, $0, $0, $0, $0, $3f, $3f
; Tile graphic 2
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 3
.byt $3f, $3f, $3f, $3f, $3f, $0, $0, $0
; Tile graphic 4
.byt $0, $0, $0, $20, $18, $6, $1, $0
; Tile graphic 5
.byt $0, $0, $0, $0, $0, $0, $20, $18
; Tile graphic 6
.byt $8, $30, $0, $0, $0, $0, $0, $0
; Tile graphic 7
.byt $0, $0, $3f, $3f, $3f, $0, $0, $0
; Tile graphic 8
.byt $0, $0, $0, $0, $3f, $3f, $3f, $3f
; Tile graphic 9
.byt $4, $3, $0, $0, $0, $0, $3f, $3f
; Tile graphic 10
.byt $0, $0, $0, $0, $0, $3f, $3f, $3f
; Tile graphic 11
.byt $0, $0, $0, $0, $0, $0, $1, $6
; Tile graphic 12
.byt $38, $38, $38, $3, $6, $18, $20, $0
; Tile graphic 13
.byt $4, $3, $0, $0, $0, $0, $0, $0
; Tile graphic 14
.byt $0, $0, $0, $0, $0, $3e, $3e, $3e
; Tile graphic 15
.byt $0, $0, $0, $3, $6, $18, $20, $0
costume_masks
; Tile mask 1
.byt $70, $40, $40, $40, $40, $40, $40, $40
; Tile mask 2
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 3
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 4
.byt $40, $40, $40, $40, $60, $78, $7e, $ff
; Tile mask 5
.byt $40, $40, $40, $40, $40, $40, $40, $60
; Tile mask 6
.byt $70, $40, $40, $40, $40, $40, $40, $40
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
res_end
.)

