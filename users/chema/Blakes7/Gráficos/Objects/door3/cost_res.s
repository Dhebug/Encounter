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
; Animatory state 0 (door0.png)
.byt 1, 1, 2, 1, 1
.byt 1, 1, 2, 1, 1
.byt 1, 3, 4, 1, 1
.byt 1, 5, 1, 1, 1
.byt 1, 6, 7, 1, 1
.byt 1, 1, 2, 1, 1
.byt 8, 8, 9, 8, 8
; Animatory state 1 (door01.png)
.byt 1, 10, 11, 12, 1
.byt 1, 10, 11, 12, 1
.byt 13, 14, 15, 16, 1
.byt 17, 11, 18, 1, 1
.byt 19, 20, 21, 22, 1
.byt 1, 10, 11, 12, 1
.byt 8, 23, 11, 24, 8
; Animatory state 2 (door02.png)
.byt 1, 25, 11, 11, 1
.byt 1, 25, 11, 11, 1
.byt 26, 27, 28, 29, 1
.byt 11, 11, 30, 1, 1
.byt 31, 32, 33, 34, 1
.byt 1, 25, 11, 11, 1
.byt 8, 35, 11, 11, 8
; Animatory state 3 (door03.png)
.byt 36, 11, 11, 11, 37
.byt 36, 11, 11, 11, 37
.byt 38, 11, 11, 39, 40
.byt 11, 11, 11, 41, 1
.byt 42, 11, 11, 43, 44
.byt 36, 11, 11, 11, 37
.byt 45, 11, 11, 11, 46
; Animatory state 4 (door04.png)
.byt 11, 11, 11, 11, 11
.byt 11, 11, 11, 11, 11
.byt 11, 11, 11, 11, 15
.byt 11, 11, 11, 11, 18
.byt 11, 11, 11, 11, 21
.byt 11, 11, 11, 11, 11
.byt 11, 11, 11, 11, 11
; Animatory state 5 (door05.png)
.byt 11, 11, 11, 11, 11
.byt 11, 11, 11, 11, 11
.byt 11, 11, 11, 11, 11
.byt 11, 11, 11, 11, 11
.byt 11, 11, 11, 11, 11
.byt 11, 11, 11, 11, 11
.byt 11, 11, 11, 11, 11
costume_tiles
; Tile graphic 1
.byt $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f
; Tile graphic 2
.byt $3b, $3b, $3b, $3b, $3b, $3b, $3b, $3b
; Tile graphic 3
.byt $3f, $3f, $3f, $3f, $3e, $3d, $3b, $37
; Tile graphic 4
.byt $3b, $37, $2f, $1f, $3f, $3f, $3f, $3f
; Tile graphic 5
.byt $37, $37, $37, $37, $37, $37, $37, $37
; Tile graphic 6
.byt $37, $3b, $3d, $3e, $3f, $3f, $3f, $3f
; Tile graphic 7
.byt $3f, $3f, $3f, $3f, $1f, $2f, $37, $3b
; Tile graphic 8
.byt $3f, $3f, $3f, $3f, $3f, $3f, $3f, $0
; Tile graphic 9
.byt $3b, $3b, $3b, $3b, $3b, $3b, $3b, $0
; Tile graphic 10
.byt $3e, $3e, $3e, $3e, $3e, $3e, $3e, $3e
; Tile graphic 11
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 12
.byt $f, $f, $f, $f, $f, $f, $f, $f
; Tile graphic 13
.byt $3f, $3f, $3f, $3f, $3f, $3f, $3e, $3c
; Tile graphic 14
.byt $3e, $3c, $38, $30, $20, $0, $0, $0
; Tile graphic 15
.byt $0, $0, $0, $1, $3, $7, $f, $1f
; Tile graphic 16
.byt $f, $1f, $3f, $3f, $3f, $3f, $3f, $3f
; Tile graphic 17
.byt $3c, $3c, $3c, $3c, $3c, $3c, $3c, $3c
; Tile graphic 18
.byt $1f, $1f, $1f, $1f, $1f, $1f, $1f, $1f
; Tile graphic 19
.byt $3c, $3e, $3f, $3f, $3f, $3f, $3f, $3f
; Tile graphic 20
.byt $0, $0, $0, $20, $30, $38, $3c, $3e
; Tile graphic 21
.byt $1f, $f, $7, $3, $1, $0, $0, $0
; Tile graphic 22
.byt $3f, $3f, $3f, $3f, $3f, $3f, $1f, $f
; Tile graphic 23
.byt $3e, $3e, $3e, $3e, $3e, $3e, $3e, $0
; Tile graphic 24
.byt $f, $f, $f, $f, $f, $f, $f, $0
; Tile graphic 25
.byt $20, $20, $20, $20, $20, $20, $20, $20
; Tile graphic 26
.byt $3f, $3f, $3e, $3c, $38, $30, $20, $0
; Tile graphic 27
.byt $20, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 28
.byt $0, $0, $0, $0, $0, $0, $0, $1
; Tile graphic 29
.byt $0, $1, $3, $7, $f, $1f, $3f, $3f
; Tile graphic 30
.byt $1, $1, $1, $1, $1, $1, $1, $1
; Tile graphic 31
.byt $0, $20, $30, $38, $3c, $3e, $3f, $3f
; Tile graphic 32
.byt $0, $0, $0, $0, $0, $0, $0, $20
; Tile graphic 33
.byt $1, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 34
.byt $3f, $3f, $1f, $f, $7, $3, $1, $0
; Tile graphic 35
.byt $20, $20, $20, $20, $20, $20, $20, $0
; Tile graphic 36
.byt $38, $38, $38, $38, $38, $38, $38, $38
; Tile graphic 37
.byt $3, $3, $3, $3, $3, $3, $3, $3
; Tile graphic 38
.byt $38, $30, $20, $0, $0, $0, $0, $0
; Tile graphic 39
.byt $0, $0, $0, $0, $0, $1, $3, $7
; Tile graphic 40
.byt $3, $7, $f, $1f, $3f, $3f, $3f, $3f
; Tile graphic 41
.byt $7, $7, $7, $7, $7, $7, $7, $7
; Tile graphic 42
.byt $0, $0, $0, $0, $0, $20, $30, $38
; Tile graphic 43
.byt $7, $3, $1, $0, $0, $0, $0, $0
; Tile graphic 44
.byt $3f, $3f, $3f, $3f, $1f, $f, $7, $3
; Tile graphic 45
.byt $38, $38, $38, $38, $38, $38, $38, $0
; Tile graphic 46
.byt $3, $3, $3, $3, $3, $3, $3, $0
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
; Tile mask 45
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 46
.byt $40, $40, $40, $40, $40, $40, $40, $40
res_end
.)

