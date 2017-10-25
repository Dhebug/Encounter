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
; Animatory state 0 (TalkA.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 0, 0
.byt 4, 5, 6, 0, 0
.byt 7, 8, 9, 0, 0
.byt 10, 11, 12, 0, 0
; Animatory state 1 (TalkB.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 13, 14, 15, 0, 0
.byt 16, 17, 18, 0, 0
.byt 19, 20, 21, 0, 0
.byt 22, 23, 24, 0, 0
; Animatory state 2 (lights1A.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 1, 25, 26, 0, 0
.byt 4, 27, 28, 0, 0
.byt 7, 29, 30, 0, 0
.byt 10, 11, 31, 0, 0
; Animatory state 3 (lights1B.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 32, 14, 15, 0, 0
.byt 33, 34, 18, 0, 0
.byt 35, 36, 21, 0, 0
.byt 22, 23, 24, 0, 0
; Animatory state 4 (lights2A.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 0, 0
.byt 4, 37, 38, 0, 0
.byt 7, 39, 34, 0, 0
.byt 10, 11, 40, 0, 0
; Animatory state 5 (lights2B.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 41, 14, 15, 0, 0
.byt 42, 39, 18, 0, 0
.byt 39, 43, 21, 0, 0
.byt 44, 23, 24, 0, 0
costume_tiles
; Tile graphic 1
.byt $3e, $14, $3c, $14, $3c, $10, $38, $10
; Tile graphic 2
.byt $0, $0, $0, $0, $3, $c, $10, $20
; Tile graphic 3
.byt $0, $0, $f, $30, $0, $0, $0, $0
; Tile graphic 4
.byt $31, $11, $32, $2, $22, $4, $4, $4
; Tile graphic 5
.byt $3, $3, $0, $0, $0, $10, $0, $0
; Tile graphic 6
.byt $0, $0, $0, $0, $0, $1f, $1f, $0
; Tile graphic 7
.byt $4, $4, $24, $4, $22, $12, $31, $11
; Tile graphic 8
.byt $0, $f, $f, $0, $0, $0, $0, $0
; Tile graphic 9
.byt $0, $38, $38, $0, $0, $0, $0, $0
; Tile graphic 10
.byt $18, $10, $18, $14, $1c, $14, $1e, $14
; Tile graphic 11
.byt $20, $10, $c, $3, $0, $0, $0, $0
; Tile graphic 12
.byt $e, $e, $0, $0, $30, $f, $0, $0
; Tile graphic 13
.byt $0, $0, $3c, $3, $0, $0, $0, $38
; Tile graphic 14
.byt $0, $0, $0, $0, $30, $c, $2, $1
; Tile graphic 15
.byt $1f, $15, $f, $5, $f, $5, $7, $5
; Tile graphic 16
.byt $0, $0, $0, $0, $0, $3f, $3f, $0
; Tile graphic 17
.byt $0, $0, $10, $0, $0, $30, $30, $3
; Tile graphic 18
.byt $23, $21, $13, $11, $11, $9, $8, $8
; Tile graphic 19
.byt $0, $0, $0, $3, $0, $0, $0, $0
; Tile graphic 20
.byt $3, $0, $0, $30, $0, $0, $0, $0
; Tile graphic 21
.byt $8, $8, $9, $11, $11, $11, $23, $21
; Tile graphic 22
.byt $0, $0, $0, $0, $3, $3c, $0, $0
; Tile graphic 23
.byt $1, $2, $c, $30, $0, $0, $0, $0
; Tile graphic 24
.byt $6, $4, $6, $4, $e, $4, $1e, $14
; Tile graphic 25
.byt $0, $0, $0, $0, $3, $c, $10, $21
; Tile graphic 26
.byt $0, $0, $f, $30, $0, $0, $0, $20
; Tile graphic 27
.byt $1, $0, $0, $0, $0, $0, $0, $18
; Tile graphic 28
.byt $20, $0, $0, $0, $1, $1, $0, $0
; Tile graphic 29
.byt $18, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 30
.byt $0, $0, $0, $18, $18, $0, $0, $0
; Tile graphic 31
.byt $0, $0, $0, $0, $30, $f, $0, $0
; Tile graphic 32
.byt $0, $0, $3c, $3, $0, $0, $0, $0
; Tile graphic 33
.byt $0, $0, $0, $0, $20, $20, $0, $0
; Tile graphic 34
.byt $0, $0, $18, $18, $0, $0, $0, $0
; Tile graphic 35
.byt $0, $0, $0, $0, $0, $1, $1, $0
; Tile graphic 36
.byt $0, $0, $0, $0, $0, $20, $20, $0
; Tile graphic 37
.byt $1, $1, $0, $0, $0, $0, $0, $0
; Tile graphic 38
.byt $20, $20, $0, $0, $0, $0, $0, $0
; Tile graphic 39
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 40
.byt $1, $1, $0, $0, $30, $f, $0, $0
; Tile graphic 41
.byt $0, $0, $3c, $3, $0, $0, $3, $3
; Tile graphic 42
.byt $0, $0, $0, $0, $0, $0, $c, $c
; Tile graphic 43
.byt $0, $0, $0, $0, $18, $18, $0, $0
; Tile graphic 44
.byt $20, $20, $0, $0, $3, $3c, $0, $0
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
; Tile mask 23
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 24
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 25
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 26
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 27
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 28
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 29
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 30
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 31
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 32
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 33
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 34
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 35
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 36
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 37
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 38
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 39
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 40
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 41
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 42
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 43
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 44
.byt $40, $40, $40, $40, $40, $40, $40, $40
res_end
.)

