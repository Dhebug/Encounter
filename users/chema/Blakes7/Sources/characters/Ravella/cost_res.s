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
; Animatory state 0 (00-lookRight.png)
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 5
.byt 6, 7, 8, 9, 10
.byt 11, 12, 13, 14, 15
.byt 16, 17, 18, 19, 20
.byt 21, 22, 23, 24, 25
.byt 26, 27, 28, 29, 30
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
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
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
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
; Animatory state 11 (11-rightTalk.png)
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 5
.byt 6, 7, 8, 9, 10
.byt 11, 12, 31, 14, 15
.byt 16, 17, 32, 33, 20
.byt 21, 22, 23, 24, 25
.byt 26, 27, 28, 29, 30
costume_tiles
; Tile graphic 1
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 2
.byt $0, $0, $0, $0, $0, $0, $0, $1
; Tile graphic 3
.byt $0, $0, $0, $0, $0, $0, $0, $14
; Tile graphic 4
.byt $0, $0, $0, $0, $0, $4, $2, $4
; Tile graphic 5
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 6
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 7
.byt $2, $4, $9, $3, $7, $4, $b, $e
; Tile graphic 8
.byt $20, $1f, $3f, $3f, $3f, $f, $3f, $f
; Tile graphic 9
.byt $8, $30, $3c, $3e, $3e, $2, $3d, $7
; Tile graphic 10
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 11
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 12
.byt $d, $f, $f, $7, $7, $7, $7, $b
; Tile graphic 13
.byt $16, $3f, $3f, $3b, $39, $3f, $32, $3d
; Tile graphic 14
.byt $2b, $3f, $3f, $3f, $3e, $3c, $1e, $3c
; Tile graphic 15
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 16
.byt $0, $0, $0, $1, $1, $3, $3, $3
; Tile graphic 17
.byt $3, $9, $2c, $35, $36, $f, $2f, $27
; Tile graphic 18
.byt $3f, $3f, $1f, $0, $2d, $12, $2d, $2d
; Tile graphic 19
.byt $38, $30, $a, $1a, $16, $37, $3b, $33
; Tile graphic 20
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 21
.byt $7, $7, $6, $f, $e, $e, $f, $0
; Tile graphic 22
.byt $10, $17, $17, $2f, $2a, $7, $27, $0
; Tile graphic 23
.byt $33, $3f, $3f, $3f, $2a, $3f, $3f, $0
; Tile graphic 24
.byt $b, $33, $37, $3b, $2b, $31, $33, $0
; Tile graphic 25
.byt $0, $0, $0, $20, $20, $20, $20, $0
; Tile graphic 26
.byt $0, $0, $0, $0, $1, $0, $3, $0
; Tile graphic 27
.byt $f, $f, $1f, $0, $3f, $2f, $3f, $0
; Tile graphic 28
.byt $37, $23, $1, $0, $23, $23, $1, $0
; Tile graphic 29
.byt $38, $3c, $3c, $0, $3f, $34, $3f, $0
; Tile graphic 30
.byt $0, $0, $0, $0, $0, $0, $20, $0
; Tile graphic 31
.byt $16, $3f, $3f, $3b, $39, $3f, $30, $38
; Tile graphic 32
.byt $3f, $3f, $3f, $1f, $20, $12, $2d, $2d
; Tile graphic 33
.byt $38, $38, $32, $a, $16, $37, $3b, $33
costume_masks
; Tile mask 1
.byt $ff, $ff, $ff, $ff, $ff, $ff, $ff, $7e
; Tile mask 2
.byt $ff, $ff, $ff, $7c, $78, $60, $40, $40
; Tile mask 3
.byt $ff, $ff, $40, $40, $40, $40, $40, $40
; Tile mask 4
.byt $ff, $ff, $5f, $43, $41, $40, $40, $40
; Tile mask 5
.byt $ff, $ff, $ff, $ff, $ff, $ff, $5f, $4f
; Tile mask 6
.byt $7e, $7e, $7c, $7c, $7c, $7c, $7c, $7c
; Tile mask 7
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 8
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 9
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 10
.byt $4f, $47, $47, $43, $43, $43, $43, $43
; Tile mask 11
.byt $78, $78, $78, $78, $7c, $7e, $ff, $ff
; Tile mask 12
.byt $40, $40, $40, $40, $40, $40, $60, $60
; Tile mask 13
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 14
.byt $40, $40, $40, $40, $40, $40, $40, $41
; Tile mask 15
.byt $43, $43, $43, $43, $47, $47, $4f, $ff
; Tile mask 16
.byt $ff, $ff, $7e, $7c, $7c, $78, $78, $78
; Tile mask 17
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 18
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 19
.byt $43, $41, $40, $40, $40, $40, $40, $40
; Tile mask 20
.byt $ff, $ff, $ff, $ff, $ff, $5f, $5f, $5f
; Tile mask 21
.byt $70, $70, $70, $60, $60, $60, $60, $70
; Tile mask 22
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 23
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 24
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 25
.byt $5f, $5f, $5f, $4f, $4f, $4f, $4f, $5f
; Tile mask 26
.byt $ff, $ff, $ff, $7e, $7c, $78, $78, $78
; Tile mask 27
.byt $60, $60, $40, $40, $40, $40, $40, $40
; Tile mask 28
.byt $40, $48, $5c, $5c, $48, $48, $48, $7e
; Tile mask 29
.byt $43, $41, $41, $40, $40, $40, $40, $40
; Tile mask 30
.byt $ff, $ff, $ff, $ff, $5f, $4f, $4f, $4f
; Tile mask 31
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 32
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 33
.byt $43, $41, $40, $40, $40, $40, $40, $40
res_end
.)

