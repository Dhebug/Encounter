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
; Animatory state 0 (palanca0.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 0, 0
.byt 4, 5, 6, 0, 0
.byt 7, 8, 9, 0, 0
.byt 10, 11, 12, 0, 0
.byt 13, 14, 15, 0, 0
; Animatory state 1 (palanca1.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 1, 16, 17, 0, 0
.byt 12, 18, 19, 0, 0
.byt 20, 21, 22, 0, 0
.byt 23, 24, 12, 0, 0
.byt 13, 14, 15, 0, 0
; Animatory state 2 (palanca2.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 25, 26, 27, 0, 0
.byt 28, 29, 30, 0, 0
.byt 31, 32, 33, 0, 0
.byt 34, 35, 36, 0, 0
.byt 37, 38, 37, 0, 0
; Animatory state 3 (palanca3.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 25, 39, 27, 0, 0
.byt 31, 40, 41, 0, 0
.byt 42, 43, 33, 0, 0
.byt 44, 45, 46, 0, 0
.byt 37, 47, 37, 0, 0
; Animatory state 4 (palanca4.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 48, 49, 1, 0, 0
.byt 50, 51, 12, 0, 0
.byt 52, 53, 12, 0, 0
.byt 54, 55, 12, 0, 0
.byt 56, 57, 15, 0, 0
; Animatory state 5 (palanca5.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 1, 58, 1, 0, 0
.byt 59, 60, 12, 0, 0
.byt 61, 62, 12, 0, 0
.byt 63, 64, 12, 0, 0
.byt 56, 57, 15, 0, 0
; Animatory state 6 (palanca6.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 65, 66, 1, 0, 0
.byt 67, 68, 69, 0, 0
.byt 70, 71, 12, 0, 0
.byt 72, 73, 74, 0, 0
.byt 15, 75, 15, 0, 0
; Animatory state 7 (palanca7.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 65, 58, 1, 0, 0
.byt 76, 77, 12, 0, 0
.byt 70, 78, 79, 0, 0
.byt 80, 81, 82, 0, 0
.byt 15, 83, 15, 0, 0
costume_tiles
; Tile graphic 1
.byt $3f, $1d, $3f, $0, $3f, $0, $1d, $3f
; Tile graphic 2
.byt $3f, $37, $3f, $0, $3f, $0, $37, $20
; Tile graphic 3
.byt $3f, $1d, $3f, $0, $3f, $0, $1d, $1f
; Tile graphic 4
.byt $37, $3f, $1c, $3e, $36, $3e, $1d, $3f
; Tile graphic 5
.byt $f, $10, $0, $0, $0, $0, $0, $0
; Tile graphic 6
.byt $7, $2b, $11, $17, $17, $7, $d, $2f
; Tile graphic 7
.byt $37, $3f, $1d, $3f, $37, $3e, $1c, $3e
; Tile graphic 8
.byt $0, $2d, $11, $11, $11, $22, $22, $22
; Tile graphic 9
.byt $7, $1f, $1d, $1f, $17, $3f, $1d, $3f
; Tile graphic 10
.byt $36, $3d, $1d, $3d, $32, $3a, $1a, $3a
; Tile graphic 11
.byt $25, $5, $5, $b, $9, $b, $b, $17
; Tile graphic 12
.byt $37, $3f, $1d, $3f, $37, $3f, $1d, $3f
; Tile graphic 13
.byt $35, $3e, $1d, $3f, $37, $0, $3f, $0
; Tile graphic 14
.byt $35, $f, $37, $3f, $1d, $0, $3f, $0
; Tile graphic 15
.byt $37, $3f, $1d, $3f, $37, $0, $3f, $0
; Tile graphic 16
.byt $3f, $37, $3f, $0, $3f, $0, $37, $3e
; Tile graphic 17
.byt $3f, $1d, $3f, $0, $3f, $0, $1d, $f
; Tile graphic 18
.byt $1d, $3a, $32, $34, $14, $34, $34, $28
; Tile graphic 19
.byt $37, $b, $9, $17, $17, $17, $2d, $2f
; Tile graphic 20
.byt $37, $3f, $1d, $3f, $37, $38, $13, $34
; Tile graphic 21
.byt $8, $29, $11, $11, $11, $2, $32, $a
; Tile graphic 22
.byt $27, $1f, $1d, $1f, $17, $3f, $1d, $3f
; Tile graphic 23
.byt $20, $20, $0, $20, $30, $30, $18, $3a
; Tile graphic 24
.byt $5, $5, $5, $1, $1, $b, $3, $17
; Tile graphic 25
.byt $3f, $2e, $3f, $0, $3f, $0, $2e, $3f
; Tile graphic 26
.byt $3f, $3b, $3f, $0, $3f, $0, $3b, $20
; Tile graphic 27
.byt $3f, $2e, $3f, $0, $3f, $0, $2e, $1f
; Tile graphic 28
.byt $3b, $3f, $2e, $3e, $3a, $3e, $2e, $3f
; Tile graphic 29
.byt $f, $10, $20, $20, $20, $0, $0, $10
; Tile graphic 30
.byt $b, $2f, $6, $7, $3, $7, $e, $f
; Tile graphic 31
.byt $3b, $3f, $2e, $3f, $3b, $3f, $2e, $3f
; Tile graphic 32
.byt $0, $15, $11, $11, $11, $11, $11, $11
; Tile graphic 33
.byt $1b, $1f, $e, $1f, $1b, $1f, $e, $1f
; Tile graphic 34
.byt $3b, $3e, $2e, $3e, $3a, $3e, $2e, $3e
; Tile graphic 35
.byt $11, $23, $22, $22, $22, $22, $22, $22
; Tile graphic 36
.byt $1b, $1f, $2e, $3f, $3b, $3f, $2e, $3f
; Tile graphic 37
.byt $3b, $3f, $2e, $3f, $3b, $0, $3f, $0
; Tile graphic 38
.byt $1c, $23, $3b, $3f, $2e, $0, $3f, $0
; Tile graphic 39
.byt $3f, $3b, $3f, $0, $3f, $0, $3b, $38
; Tile graphic 40
.byt $27, $28, $28, $28, $28, $28, $11, $11
; Tile graphic 41
.byt $2b, $2f, $2e, $2f, $2b, $2f, $e, $1f
; Tile graphic 42
.byt $3b, $3f, $2e, $3f, $3b, $3e, $2c, $3d
; Tile graphic 43
.byt $11, $11, $11, $11, $11, $1, $3c, $2
; Tile graphic 44
.byt $3a, $3a, $2a, $38, $38, $3d, $2c, $3e
; Tile graphic 45
.byt $0, $0, $0, $0, $0, $0, $0, $22
; Tile graphic 46
.byt $1b, $1f, $e, $1f, $3b, $3f, $2e, $3f
; Tile graphic 47
.byt $1c, $21, $3b, $3f, $2e, $0, $3f, $0
; Tile graphic 48
.byt $3f, $1d, $3f, $0, $3f, $0, $1d, $3c
; Tile graphic 49
.byt $3f, $37, $3f, $0, $3f, $0, $37, $3
; Tile graphic 50
.byt $31, $3a, $10, $30, $30, $30, $18, $38
; Tile graphic 51
.byt $39, $5, $2, $2, $2, $0, $1, $5
; Tile graphic 52
.byt $34, $3d, $1d, $3d, $35, $3d, $1d, $3d
; Tile graphic 53
.byt $1, $15, $5, $5, $5, $5, $5, $5
; Tile graphic 54
.byt $35, $3d, $1d, $3d, $35, $3d, $1d, $3d
; Tile graphic 55
.byt $5, $5, $5, $5, $5, $5, $5, $5
; Tile graphic 56
.byt $36, $3f, $1d, $3f, $37, $0, $3f, $0
; Tile graphic 57
.byt $39, $7, $37, $3f, $1d, $0, $3f, $0
; Tile graphic 58
.byt $3f, $37, $3f, $0, $3f, $0, $37, $7
; Tile graphic 59
.byt $36, $3d, $1d, $3d, $35, $3d, $1d, $3d
; Tile graphic 60
.byt $39, $5, $5, $5, $5, $5, $5, $5
; Tile graphic 61
.byt $35, $3d, $1d, $3d, $35, $3c, $19, $3a
; Tile graphic 62
.byt $5, $5, $5, $5, $5, $1, $39, $5
; Tile graphic 63
.byt $30, $30, $10, $30, $30, $38, $1c, $3d
; Tile graphic 64
.byt $2, $2, $2, $0, $1, $5, $1, $15
; Tile graphic 65
.byt $3f, $1d, $3f, $0, $3f, $0, $1d, $3e
; Tile graphic 66
.byt $3f, $37, $3f, $0, $3f, $0, $37, $1
; Tile graphic 67
.byt $34, $3d, $18, $38, $30, $38, $1c, $3c
; Tile graphic 68
.byt $3c, $2, $1, $1, $1, $0, $0, $2
; Tile graphic 69
.byt $37, $3f, $1d, $1f, $17, $1f, $1d, $3f
; Tile graphic 70
.byt $36, $3e, $1c, $3e, $36, $3e, $1c, $3e
; Tile graphic 71
.byt $0, $2a, $22, $22, $22, $22, $22, $22
; Tile graphic 72
.byt $36, $3e, $1d, $3f, $37, $3f, $1d, $3f
; Tile graphic 73
.byt $22, $31, $11, $11, $11, $11, $11, $11
; Tile graphic 74
.byt $37, $1f, $1d, $1f, $17, $1f, $1d, $1f
; Tile graphic 75
.byt $e, $31, $37, $3f, $1d, $0, $3f, $0
; Tile graphic 76
.byt $35, $3d, $1d, $3d, $35, $3d, $1c, $3e
; Tile graphic 77
.byt $39, $5, $5, $5, $5, $5, $22, $22
; Tile graphic 78
.byt $22, $22, $22, $22, $22, $20, $f, $10
; Tile graphic 79
.byt $37, $3f, $1d, $3f, $37, $1f, $d, $2f
; Tile graphic 80
.byt $36, $3e, $1c, $3e, $37, $3f, $1d, $3f
; Tile graphic 81
.byt $0, $0, $0, $0, $0, $0, $0, $11
; Tile graphic 82
.byt $17, $17, $15, $7, $7, $2f, $d, $1f
; Tile graphic 83
.byt $e, $21, $37, $3f, $1d, $0, $3f, $0
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
; Tile mask 70
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 71
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 72
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 73
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 74
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 75
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 76
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 77
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 78
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 79
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 80
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 81
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 82
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 83
.byt $40, $40, $40, $40, $40, $40, $40, $40
res_end
.)

