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
; Animatory state 0 (0-.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 0, 0
.byt 4, 5, 6, 0, 0
; Animatory state 1 (1-.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 7, 8, 9, 0, 0
.byt 10, 11, 12, 0, 0
; Animatory state 2 (2-.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 13, 14, 15, 0, 0
.byt 16, 17, 18, 0, 0
; Animatory state 3 (3-.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 19, 20, 21, 0, 0
.byt 22, 23, 24, 0, 0
; Animatory state 4 (4-.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 25, 26, 27, 0, 0
.byt 28, 29, 30, 0, 0
; Animatory state 5 (5-.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 25, 31, 32, 0, 0
.byt 28, 33, 34, 0, 0
; Animatory state 6 (6-.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 35, 36, 37, 0, 0
.byt 38, 39, 40, 0, 0
; Animatory state 7 (7-.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 41, 42, 43, 0, 0
.byt 44, 45, 46, 0, 0
; Animatory state 8 (8-.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 47, 48, 49, 0, 0
.byt 50, 51, 52, 0, 0
; Animatory state 9 (9-.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 53, 26, 49, 0, 0
.byt 54, 29, 52, 0, 0
; Animatory state 10 (a-.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 25, 26, 49, 0, 0
.byt 28, 29, 52, 0, 0
; Animatory state 11 (b-.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 55, 56, 49, 0, 0
.byt 57, 58, 52, 0, 0
; Animatory state 12 (c-.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 59, 60, 61, 0, 0
.byt 28, 29, 52, 0, 0
; Animatory state 13 (d-.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 62, 63, 64, 0, 0
.byt 28, 29, 52, 0, 0
; Animatory state 14 (f-.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 65, 66, 67, 0, 0
.byt 28, 29, 52, 0, 0
; Animatory state 15 (g-.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 65, 66, 67, 0, 0
.byt 68, 69, 52, 0, 0
costume_tiles
; Tile graphic 1
.byt $3f, $20, $0, $0, $0, $0, $0, $0
; Tile graphic 2
.byt $3f, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 3
.byt $3f, $1, $0, $0, $0, $0, $0, $0
; Tile graphic 4
.byt $0, $0, $0, $20, $3f, $37, $3f, $1d
; Tile graphic 5
.byt $0, $0, $0, $0, $3f, $1d, $3f, $37
; Tile graphic 6
.byt $0, $0, $0, $1, $3f, $37, $3f, $1d
; Tile graphic 7
.byt $3f, $20, $0, $0, $7, $0, $6, $5
; Tile graphic 8
.byt $3f, $0, $0, $0, $20, $0, $0, $30
; Tile graphic 9
.byt $3f, $1, $18, $24, $24, $34, $18, $14
; Tile graphic 10
.byt $0, $4, $6, $20, $3f, $37, $3f, $1d
; Tile graphic 11
.byt $0, $0, $38, $0, $3f, $1d, $3f, $37
; Tile graphic 12
.byt $34, $2c, $1c, $1, $3f, $37, $3f, $1d
; Tile graphic 13
.byt $3f, $20, $6, $d, $9, $9, $6, $e
; Tile graphic 14
.byt $3f, $0, $0, $0, $3, $0, $3, $2
; Tile graphic 15
.byt $3f, $1, $0, $0, $30, $0, $0, $38
; Tile graphic 16
.byt $b, $f, $f, $20, $3f, $37, $3f, $1d
; Tile graphic 17
.byt $0, $2, $3, $0, $3f, $1d, $3f, $37
; Tile graphic 18
.byt $0, $0, $1c, $1, $3f, $37, $3f, $1d
; Tile graphic 19
.byt $3f, $20, $0, $1, $2, $1, $2, $0
; Tile graphic 20
.byt $3f, $0, $0, $a, $1d, $10, $0, $1e
; Tile graphic 21
.byt $3f, $1, $8, $38, $20, $0, $0, $0
; Tile graphic 22
.byt $7, $18, $0, $20, $3f, $37, $3f, $1d
; Tile graphic 23
.byt $21, $c, $3f, $0, $3f, $1d, $3f, $37
; Tile graphic 24
.byt $38, $6, $0, $1, $3f, $37, $3f, $1d
; Tile graphic 25
.byt $3f, $20, $3, $6, $3, $0, $0, $0
; Tile graphic 26
.byt $3f, $0, $0, $2f, $1f, $0, $0, $0
; Tile graphic 27
.byt $3f, $1, $0, $0, $20, $0, $3, $7
; Tile graphic 28
.byt $0, $0, $0, $20, $3f, $37, $3f, $1d
; Tile graphic 29
.byt $0, $0, $0, $0, $3f, $1d, $3f, $37
; Tile graphic 30
.byt $7, $3, $0, $1, $3f, $37, $3f, $1d
; Tile graphic 31
.byt $3f, $0, $0, $2f, $1f, $0, $1, $3
; Tile graphic 32
.byt $3f, $1, $0, $0, $20, $0, $27, $3f
; Tile graphic 33
.byt $3, $1, $0, $0, $3f, $1d, $3f, $37
; Tile graphic 34
.byt $3f, $27, $0, $1, $3f, $37, $3f, $1d
; Tile graphic 35
.byt $3f, $20, $3, $6, $3, $0, $0, $1
; Tile graphic 36
.byt $3f, $0, $0, $2f, $1f, $0, $33, $3f
; Tile graphic 37
.byt $3f, $1, $0, $0, $20, $0, $23, $3d
; Tile graphic 38
.byt $1, $0, $0, $20, $3f, $37, $3f, $1d
; Tile graphic 39
.byt $3f, $33, $0, $0, $3f, $1d, $3f, $37
; Tile graphic 40
.byt $3e, $23, $0, $1, $3f, $37, $3f, $1d
; Tile graphic 41
.byt $3f, $20, $3, $6, $3, $0, $19, $3f
; Tile graphic 42
.byt $3f, $0, $0, $2f, $1f, $0, $31, $3e
; Tile graphic 43
.byt $3f, $1, $0, $0, $20, $0, $20, $30
; Tile graphic 44
.byt $3f, $19, $0, $20, $3f, $37, $3f, $1d
; Tile graphic 45
.byt $3f, $31, $0, $0, $3f, $1d, $3f, $37
; Tile graphic 46
.byt $10, $20, $0, $1, $3f, $37, $3f, $1d
; Tile graphic 47
.byt $3f, $20, $3, $6, $3, $0, $1c, $3f
; Tile graphic 48
.byt $3f, $0, $0, $2f, $1f, $0, $18, $2c
; Tile graphic 49
.byt $3f, $1, $0, $0, $20, $0, $0, $0
; Tile graphic 50
.byt $3f, $1c, $0, $20, $3f, $37, $3f, $1d
; Tile graphic 51
.byt $34, $18, $0, $0, $3f, $1d, $3f, $37
; Tile graphic 52
.byt $0, $0, $0, $1, $3f, $37, $3f, $1d
; Tile graphic 53
.byt $3f, $20, $3, $6, $3, $0, $c, $36
; Tile graphic 54
.byt $3a, $c, $0, $20, $3f, $37, $3f, $1d
; Tile graphic 55
.byt $3f, $20, $3, $6, $3, $0, $1, $0
; Tile graphic 56
.byt $3f, $0, $0, $2f, $1f, $0, $1e, $0
; Tile graphic 57
.byt $1, $0, $1, $20, $3f, $37, $3f, $1d
; Tile graphic 58
.byt $18, $0, $1e, $0, $3f, $1d, $3f, $37
; Tile graphic 59
.byt $3f, $20, $0, $f, $0, $0, $0, $0
; Tile graphic 60
.byt $3f, $0, $0, $20, $0, $0, $0, $0
; Tile graphic 61
.byt $3f, $1, $0, $0, $0, $0, $0, $0
; Tile graphic 62
.byt $3f, $20, $0, $f, $0, $b, $0, $0
; Tile graphic 63
.byt $3f, $0, $0, $20, $0, $2f, $0, $0
; Tile graphic 64
.byt $3f, $1, $0, $0, $0, $20, $0, $0
; Tile graphic 65
.byt $3f, $20, $0, $f, $0, $b, $0, $f
; Tile graphic 66
.byt $3f, $0, $0, $20, $0, $2f, $0, $1e
; Tile graphic 67
.byt $3f, $1, $0, $0, $0, $20, $0, $38
; Tile graphic 68
.byt $0, $f, $0, $20, $3f, $37, $3f, $1d
; Tile graphic 69
.byt $0, $10, $0, $0, $3f, $1d, $3f, $37
costume_masks
; Tile mask 1
.byt $40, $5f, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 2
.byt $40, $ff, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 3
.byt $40, $7e, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 4
.byt $ff, $ff, $ff, $5f, $40, $40, $40, $40
; Tile mask 5
.byt $ff, $ff, $ff, $ff, $40, $40, $40, $40
; Tile mask 6
.byt $ff, $ff, $ff, $7e, $40, $40, $40, $40
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
; Tile mask 47
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 48
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 49
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 50
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 51
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 52
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 53
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 54
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 55
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 56
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 57
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 58
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 59
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 60
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 61
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 62
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 63
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 64
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 65
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 66
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 67
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 68
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 69
.byt $40, $40, $40, $40, $40, $40, $40, $40
res_end
.)

