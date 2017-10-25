.(
.byt RESOURCE_COSTUME
.word (res_end - res_start + 4)
.byt 204
res_start
	; Pointers to tiles
	.byt <(costume_tiles-res_start-8), >(costume_tiles-res_start-8)
	.byt <(costume_masks-res_start-8), >(costume_masks-res_start-8)
	; Number of costumes included
	.byt 1
	;Offsets to animatory states for each costume
	.byt <(anim_states - res_start), >(anim_states - res_start)
anim_states
; Animatory state 0 (00-lookRight.png)
.byt 0, 1, 2, 3, 0
.byt 4, 5, 6, 7, 8
.byt 9, 10, 11, 12, 13
.byt 14, 15, 16, 17, 18
.byt 19, 20, 21, 22, 23
.byt 24, 25, 26, 27, 28
.byt 29, 30, 31, 32, 33
; Animatory state 1 (01-step1.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
; Animatory state 2 (02-step2.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
; Animatory state 3 (03-step3.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
; Animatory state 4 (04-front.png)
.byt 0, 1, 2, 3, 0
.byt 4, 5, 6, 7, 8
.byt 9, 10, 11, 12, 13
.byt 14, 15, 16, 17, 34
.byt 19, 20, 21, 35, 36
.byt 24, 25, 26, 37, 38
.byt 29, 30, 31, 32, 33
; Animatory state 5 (05-stepd1.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
; Animatory state 6 (06-stepd2.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
; Animatory state 7 (07-back.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
; Animatory state 8 (08-stepdb1.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
; Animatory state 9 (09-stepdb2.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
; Animatory state 10 (10-frontTalk.png)
.byt 0, 1, 2, 3, 0
.byt 4, 5, 6, 7, 8
.byt 9, 10, 11, 12, 13
.byt 14, 15, 39, 17, 34
.byt 19, 20, 21, 35, 36
.byt 24, 25, 26, 37, 38
.byt 29, 30, 31, 32, 33
; Animatory state 11 (11-rightTalk.png)
.byt 0, 1, 2, 3, 0
.byt 4, 5, 6, 7, 8
.byt 9, 10, 11, 12, 13
.byt 14, 15, 39, 17, 18
.byt 19, 20, 21, 22, 23
.byt 24, 25, 26, 27, 28
.byt 29, 30, 31, 32, 33
costume_tiles
; Tile graphic 1
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 2
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 3
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 4
.byt $0, $0, $0, $0, $0, $5, $a, $5
; Tile graphic 5
.byt $f, $f, $f, $f, $27, $17, $27, $10
; Tile graphic 6
.byt $3f, $37, $37, $1, $37, $37, $3f, $0
; Tile graphic 7
.byt $38, $38, $38, $30, $32, $35, $32, $5
; Tile graphic 8
.byt $0, $0, $0, $0, $0, $0, $20, $10
; Tile graphic 9
.byt $a, $15, $a, $15, $a, $4, $9, $5
; Tile graphic 10
.byt $2a, $11, $2f, $1f, $38, $30, $7, $17
; Tile graphic 11
.byt $1c, $3f, $3f, $3f, $3f, $c, $21, $2d
; Tile graphic 12
.byt $2a, $5, $38, $3c, $6, $2, $38, $3a
; Tile graphic 13
.byt $28, $10, $28, $10, $28, $10, $28, $20
; Tile graphic 14
.byt $1, $4, $2, $0, $1, $0, $0, $0
; Tile graphic 15
.byt $38, $3f, $1f, $1f, $1f, $f, $7, $3
; Tile graphic 16
.byt $1e, $3f, $3f, $2d, $33, $3f, $9, $3f
; Tile graphic 17
.byt $7, $3e, $3e, $3e, $3d, $3c, $38, $30
; Tile graphic 18
.byt $0, $10, $20, $0, $0, $0, $0, $0
; Tile graphic 19
.byt $0, $0, $0, $1, $1, $3, $3, $3
; Tile graphic 20
.byt $1, $6, $39, $2e, $3f, $2f, $2f, $27
; Tile graphic 21
.byt $3f, $3e, $1, $36, $9, $3f, $3f, $2d
; Tile graphic 22
.byt $20, $10, $2e, $1a, $3d, $3a, $3a, $32
; Tile graphic 23
.byt $0, $0, $8, $10, $0, $20, $20, $0
; Tile graphic 24
.byt $7, $7, $0, $7, $6, $6, $7, $0
; Tile graphic 25
.byt $b, $7, $7, $7, $22, $7, $2f, $f
; Tile graphic 26
.byt $1e, $3f, $3f, $3f, $2a, $3f, $3f, $3f
; Tile graphic 27
.byt $2a, $30, $30, $30, $20, $30, $38, $38
; Tile graphic 28
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 29
.byt $0, $0, $0, $0, $1, $0, $3, $0
; Tile graphic 30
.byt $f, $f, $1f, $0, $3f, $3, $3f, $0
; Tile graphic 31
.byt $3f, $3f, $3f, $0, $23, $23, $1, $0
; Tile graphic 32
.byt $38, $3c, $3c, $0, $3f, $20, $3f, $0
; Tile graphic 33
.byt $0, $0, $0, $0, $0, $0, $20, $0
; Tile graphic 34
.byt $0, $10, $20, $0, $0, $0, $0, $0
; Tile graphic 35
.byt $20, $10, $2e, $1b, $3f, $3b, $3b, $33
; Tile graphic 36
.byt $0, $0, $0, $0, $0, $20, $20, $20
; Tile graphic 37
.byt $29, $31, $30, $31, $22, $30, $3b, $38
; Tile graphic 38
.byt $30, $30, $0, $30, $30, $30, $30, $0
; Tile graphic 39
.byt $1e, $3f, $3f, $2d, $33, $3f, $1, $21
costume_masks
; Tile mask 1
.byt $ff, $ff, $ff, $ff, $ff, $ff, $ff, $60
; Tile mask 2
.byt $ff, $ff, $ff, $ff, $ff, $ff, $ff, $40
; Tile mask 3
.byt $ff, $ff, $ff, $ff, $ff, $ff, $ff, $43
; Tile mask 4
.byt $ff, $ff, $ff, $7e, $78, $70, $60, $60
; Tile mask 5
.byt $60, $60, $60, $40, $40, $40, $40, $40
; Tile mask 6
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 7
.byt $43, $43, $43, $41, $40, $40, $40, $40
; Tile mask 8
.byt $ff, $ff, $ff, $ff, $5f, $4f, $47, $47
; Tile mask 9
.byt $40, $40, $40, $40, $60, $60, $60, $60
; Tile mask 10
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 11
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 12
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 13
.byt $43, $43, $43, $43, $43, $43, $43, $43
; Tile mask 14
.byt $70, $70, $78, $78, $7c, $7e, $ff, $ff
; Tile mask 15
.byt $40, $40, $40, $40, $40, $40, $60, $70
; Tile mask 16
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 17
.byt $40, $40, $40, $40, $40, $40, $43, $47
; Tile mask 18
.byt $47, $47, $4f, $5f, $5f, $ff, $ff, $7e
; Tile mask 19
.byt $ff, $ff, $7e, $7c, $7c, $78, $78, $78
; Tile mask 20
.byt $70, $40, $40, $40, $40, $40, $40, $40
; Tile mask 21
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 22
.byt $47, $41, $40, $40, $40, $40, $40, $40
; Tile mask 23
.byt $7d, $73, $63, $47, $4f, $4f, $4f, $4f
; Tile mask 24
.byt $70, $70, $70, $70, $70, $70, $70, $78
; Tile mask 25
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 26
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 27
.byt $40, $41, $43, $43, $43, $43, $43, $43
; Tile mask 28
.byt $5f, $ff, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 29
.byt $ff, $ff, $ff, $7e, $7c, $78, $78, $78
; Tile mask 30
.byt $60, $60, $40, $40, $40, $40, $40, $40
; Tile mask 31
.byt $40, $40, $40, $40, $48, $48, $48, $7e
; Tile mask 32
.byt $43, $41, $41, $40, $40, $40, $40, $40
; Tile mask 33
.byt $ff, $ff, $ff, $ff, $5f, $4f, $4f, $4f
; Tile mask 34
.byt $47, $47, $4f, $5f, $5f, $ff, $ff, $ff
; Tile mask 35
.byt $47, $41, $40, $40, $40, $40, $40, $40
; Tile mask 36
.byt $ff, $ff, $ff, $5f, $5f, $4f, $4f, $4f
; Tile mask 37
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 38
.byt $47, $47, $47, $47, $47, $47, $47, $4f
; Tile mask 39
.byt $40, $40, $40, $40, $40, $40, $40, $40
res_end
.)

