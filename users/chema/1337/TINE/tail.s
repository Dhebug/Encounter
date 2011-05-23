#include "main.h"

; Tail for program... Let's put some BIG buffers here


;.dsb 256-(*&255)

buffer
_controls

.byt $41,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$60
.byt $03,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$F4,$C0,$C0,$C0,$C0,$C2,$C1,$CA,$EB,$DE,$F5,$D4,$E0,$D0,$C0,$C0,$C0,$C0,$D7,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$40
.byt $06,$6A,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$61,$D0,$C0,$C0,$7F,$7F,$77,$6A,$69,$4C,$65,$55,$7B,$7F,$7F,$C0,$C0,$C4,$45,$50,$41,$40,$50,$40,$FF,$FF,$FF,$FF,$55,$40
.byt $03,$54,$5F,$7F,$7F,$7F,$7F,$7F,$7F,$7E,$54,$40,$FF,$40,$FF,$40,$FF,$40,$FF,$40,$FF,$40,$FF,$40,$FF,$40,$FF,$40,$F5,$6B,$C3,$E0,$47,$7A,$5F,$7F,$7F,$7E,$4A,$40
.byt $06,$6A,$E0,$C0,$C0,$C0,$C0,$C0,$C0,$C1,$4A,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$55,$52,$CC,$60,$79,$68,$E8,$C0,$C0,$C5,$55,$40
.byt $03,$54,$5F,$7F,$7F,$7F,$7F,$7F,$7F,$7E,$EA,$FF,$40,$FF,$40,$FF,$40,$FF,$40,$FF,$40,$FF,$40,$FF,$40,$FF,$40,$FF,$D5,$D4,$D3,$40,$46,$7A,$5C,$5C,$5C,$5E,$4A,$40
.byt $06,$6A,$E7,$CD,$FF,$FF,$FF,$FF,$C7,$C1,$4A,$60,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$41,$55,$53,$50,$40,$41,$58,$E4,$C4,$C4,$C1,$55,$40
.byt $03,$54,$5B,$6E,$40,$40,$40,$40,$74,$5E,$EA,$50,$FF,$40,$FF,$40,$FF,$40,$FF,$40,$FF,$40,$FF,$40,$FF,$40,$FF,$42,$D5,$6A,$60,$40,$40,$6A,$5A,$7A,$7A,$7E,$4A,$40
.byt $06,$6A,$E6,$C9,$40,$40,$40,$40,$70,$E1,$4A,$60,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$41,$55,$51,$40,$40,$40,$50,$E0,$D0,$D0,$D1,$55,$40
.byt $03,$54,$5B,$7A,$40,$40,$40,$40,$70,$5E,$EA,$EB,$40,$FF,$40,$FF,$40,$FF,$40,$FF,$40,$FF,$40,$FF,$40,$FF,$40,$F5,$D5,$69,$40,$40,$40,$52,$E2,$E2,$5D,$5E,$4A,$40
.byt $06,$6A,$E4,$D9,$FF,$FF,$FF,$FF,$C7,$C1,$4A,$68,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$45,$55,$52,$40,$40,$40,$48,$E0,$C0,$C0,$C1,$55,$40
.byt $03,$54,$5F,$7F,$7F,$7F,$7F,$7F,$7F,$7E,$EA,$EA,$FF,$40,$FF,$40,$FF,$40,$FF,$40,$FF,$40,$FF,$40,$FF,$40,$FF,$D5,$D5,$6A,$40,$40,$40,$4A,$5F,$4F,$7B,$7E,$4A,$40
.byt $06,$6A,$E2,$CD,$FF,$FF,$FF,$FF,$C7,$C1,$4A,$60,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$41,$55,$52,$40,$40,$40,$48,$E0,$E1,$C4,$C1,$55,$40
.byt $03,$54,$5A,$6E,$40,$40,$40,$40,$74,$5E,$EA,$EB,$40,$FF,$40,$FF,$40,$FF,$40,$FF,$40,$FF,$40,$FF,$40,$FF,$40,$F5,$D5,$64,$40,$40,$40,$44,$5E,$5E,$79,$7E,$4A,$40
.byt $06,$6A,$E7,$C9,$40,$40,$40,$40,$70,$E1,$4A,$68,$40,$40,$40,$40,$40,$40,$6A,$6A,$6A,$40,$40,$40,$40,$40,$40,$45,$55,$54,$40,$40,$40,$45,$E0,$C0,$C0,$C1,$55,$40
.byt $03,$54,$5A,$7A,$40,$40,$40,$40,$70,$5E,$EA,$EA,$FF,$40,$FF,$40,$FF,$6A,$40,$40,$40,$55,$FF,$40,$FF,$40,$FF,$D5,$D5,$64,$40,$40,$40,$44,$5F,$4F,$7F,$7E,$4A,$40
.byt $06,$60,$C5,$D9,$FF,$FF,$FF,$FF,$C7,$C1,$4A,$60,$40,$40,$40,$40,$4A,$40,$40,$40,$40,$40,$54,$40,$40,$40,$40,$41,$55,$54,$40,$40,$40,$44,$E1,$D8,$C0,$C1,$55,$40
.byt $03,$4E,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7E,$EA,$EB,$40,$FF,$40,$5A,$61,$40,$40,$40,$40,$41,$41,$56,$40,$FF,$40,$F5,$D5,$64,$40,$40,$40,$44,$5D,$73,$7F,$7E,$4A,$40
.byt $06,$68,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C1,$4A,$68,$40,$40,$47,$40,$40,$50,$40,$40,$40,$44,$40,$40,$78,$40,$40,$45,$55,$52,$40,$40,$40,$48,$E4,$78,$40,$C1,$55,$40
.byt $03,$48,$5F,$C0,$7F,$7F,$C0,$7F,$7F,$7E,$EA,$EA,$FF,$40,$70,$44,$44,$40,$40,$40,$40,$40,$50,$50,$43,$40,$FF,$D5,$D5,$6A,$40,$40,$40,$48,$58,$41,$7F,$7E,$4A,$40
.byt $06,$6A,$FE,$C3,$FF,$FF,$E0,$CF,$FF,$FF,$4A,$60,$40,$46,$40,$40,$40,$44,$40,$40,$40,$50,$40,$40,$40,$58,$40,$41,$55,$52,$40,$40,$40,$48,$E0,$C0,$C0,$C1,$55,$40
.byt $03,$48,$40,$40,$40,$40,$40,$40,$40,$40,$EA,$EB,$40,$50,$40,$60,$50,$48,$40,$40,$40,$48,$44,$42,$40,$42,$40,$F5,$D5,$69,$40,$40,$40,$52,$7F,$7F,$7F,$7E,$4A,$40
.byt $06,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$68,$41,$FF,$FF,$FF,$FF,$FE,$40,$40,$41,$FF,$FF,$FF,$FF,$FF,$60,$45,$55,$51,$40,$40,$40,$54,$C0,$C0,$C0,$C1,$55,$40
.byt $03,$49,$54,$69,$55,$55,$4A,$65,$55,$EA,$EA,$EA,$44,$40,$44,$41,$40,$50,$40,$40,$40,$44,$41,$40,$50,$40,$48,$D5,$D5,$6A,$60,$40,$40,$62,$7E,$59,$66,$5E,$4A,$40
.byt $06,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$60,$50,$40,$40,$40,$40,$40,$50,$40,$44,$40,$40,$40,$40,$40,$42,$45,$55,$53,$50,$40,$41,$48,$C1,$E6,$D9,$E1,$55,$40
.byt $03,$48,$40,$40,$40,$40,$40,$40,$40,$40,$EA,$51,$40,$40,$60,$44,$40,$60,$50,$40,$44,$42,$40,$50,$42,$40,$40,$62,$D5,$6B,$6C,$40,$46,$5A,$7E,$59,$66,$5E,$4A,$40
.byt $06,$6A,$FE,$C3,$FF,$FF,$E0,$CF,$FF,$FF,$4A,$62,$40,$40,$40,$40,$40,$40,$44,$40,$50,$40,$40,$40,$40,$40,$40,$50,$55,$52,$73,$60,$78,$68,$C1,$E6,$D9,$E1,$55,$40
.byt $03,$48,$5F,$7F,$7F,$7F,$C0,$7F,$7F,$7E,$EA,$44,$40,$44,$40,$50,$41,$40,$60,$40,$42,$41,$40,$44,$40,$50,$40,$48,$D5,$6B,$7C,$5F,$43,$7A,$7E,$59,$66,$5E,$4A,$40
.byt $06,$68,$C3,$DD,$40,$40,$40,$40,$40,$E1,$4A,$48,$40,$40,$40,$40,$40,$40,$41,$41,$40,$40,$40,$40,$40,$40,$40,$44,$55,$50,$41,$40,$50,$40,$C0,$C0,$C0,$C5,$55,$40
.byt $03,$4E,$7D,$6A,$40,$40,$40,$40,$40,$5E,$EB,$50,$40,$60,$41,$40,$42,$40,$60,$48,$42,$40,$60,$41,$40,$42,$40,$42,$F5,$D5,$6A,$55,$4A,$6A,$7F,$7F,$7F,$7E,$4A,$40
.byt $06,$60,$C2,$DD,$40,$40,$40,$40,$40,$E1,$4A,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$E3,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$45,$55,$55,$55,$55,$54,$FF,$E0,$CF,$FF,$55,$40
.byt $03,$54,$59,$6E,$40,$40,$40,$40,$40,$5E,$EB,$60,$44,$40,$44,$40,$44,$41,$40,$48,$41,$40,$50,$40,$50,$40,$50,$41,$F5,$6A,$D5,$55,$4A,$6A,$40,$40,$40,$40,$4A,$40
.byt $06,$6A,$E0,$C0,$C0,$C0,$C0,$C0,$C0,$C1,$49,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$65,$55,$55,$55,$55,$55,$55,$4A,$65,$55,$55,$40
.byt $03,$54,$E0,$C0,$7F,$7F,$7F,$7F,$7F,$7E,$EA,$40,$60,$40,$50,$40,$48,$41,$40,$48,$41,$40,$48,$40,$44,$40,$42,$40,$D5,$D5,$6A,$55,$4A,$6A,$6A,$4A,$62,$6A,$6A,$40
.byt $06,$6A,$E0,$C0,$FF,$FF,$FF,$FF,$FF,$FF,$49,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$65,$55,$55,$55,$55,$55,$55,$4A,$65,$55,$55,$40
.byt $03,$54,$E0,$C0,$40,$40,$40,$40,$55,$50,$EA,$64,$40,$41,$40,$40,$50,$42,$40,$48,$40,$60,$44,$40,$41,$40,$40,$51,$D5,$40,$40,$40,$40,$40,$40,$40,$40,$40,$4A,$40
.byt $06,$6A,$55,$54,$4A,$6A,$FF,$FF,$FF,$FF,$68,$60,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$41,$44,$FF,$FF,$C0,$DF,$FF,$FF,$E0,$CF,$FF,$55,$40
.byt $03,$55,$55,$55,$55,$55,$5F,$7F,$7F,$7E,$EB,$50,$40,$44,$40,$40,$60,$42,$40,$48,$40,$60,$42,$40,$40,$50,$40,$42,$F5,$F0,$C0,$C0,$7F,$7F,$7F,$7F,$7F,$7C,$4A,$40
.byt $06,$6A,$55,$54,$4A,$6A,$E8,$F9,$40,$F1,$68,$48,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$44,$44,$E4,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C9,$55,$40
.byt $03,$54,$C0,$C0,$40,$40,$77,$6C,$75,$66,$EB,$44,$40,$50,$40,$41,$40,$44,$40,$48,$40,$50,$41,$40,$40,$44,$40,$48,$F5,$EA,$C0,$C0,$7F,$7F,$7F,$7F,$7F,$6A,$4A,$40
.byt $06,$6A,$D8,$43,$5F,$7E,$C8,$D2,$60,$C9,$69,$42,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$50,$44,$E4,$40,$C1,$41,$C1,$41,$C1,$41,$C9,$55,$40
.byt $03,$54,$C0,$5B,$40,$40,$71,$6D,$FF,$56,$EA,$41,$41,$40,$40,$42,$40,$44,$40,$48,$40,$50,$40,$60,$40,$41,$40,$60,$D5,$E1,$40,$C1,$40,$7E,$40,$7E,$40,$7E,$4A,$40
.byt $06,$6A,$D8,$43,$5F,$7E,$C0,$C3,$40,$F9,$69,$60,$70,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$43,$40,$64,$E1,$40,$E1,$40,$E1,$40,$E1,$40,$E1,$55,$40
.byt $03,$54,$C0,$C0,$40,$40,$7F,$75,$EF,$56,$EA,$60,$4C,$40,$40,$44,$40,$48,$40,$48,$40,$48,$40,$50,$40,$40,$4C,$41,$D5,$5E,$40,$5E,$40,$5E,$40,$5E,$40,$5E,$4A,$40
.byt $06,$6A,$40,$40,$4A,$6A,$E0,$C3,$40,$F9,$69,$70,$43,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$70,$43,$64,$E1,$40,$E1,$40,$E1,$40,$E1,$40,$E1,$55,$40
.byt $03,$55,$4D,$6D,$55,$55,$5F,$75,$EF,$56,$EB,$78,$40,$70,$40,$48,$40,$48,$40,$48,$40,$48,$40,$48,$40,$43,$40,$47,$F5,$5E,$40,$5E,$40,$5E,$40,$5E,$40,$5E,$4A,$40
.byt $06,$6A,$6D,$6C,$6A,$6A,$E0,$C3,$40,$F9,$6A,$7C,$40,$4C,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$5C,$40,$4F,$54,$E1,$40,$E1,$40,$E1,$40,$E1,$40,$E0,$41,$40
.byt $03,$54,$40,$40,$40,$55,$5F,$75,$EF,$56,$EB,$E1,$40,$43,$60,$50,$40,$50,$40,$48,$40,$44,$40,$44,$43,$60,$40,$E1,$D5,$5E,$40,$5E,$40,$5E,$40,$5E,$40,$5F,$5A,$40
.byt $06,$6A,$C0,$C0,$C0,$4A,$E0,$C3,$40,$F9,$6A,$4F,$40,$40,$5C,$40,$40,$40,$40,$40,$40,$40,$40,$40,$5C,$40,$40,$7D,$54,$E1,$40,$E1,$40,$E1,$40,$E1,$40,$E0,$41,$40
.byt $03,$54,$7F,$7F,$7F,$55,$5E,$65,$EF,$56,$EA,$4F,$70,$40,$43,$78,$40,$50,$40,$48,$40,$44,$40,$47,$60,$40,$43,$7A,$D5,$5E,$40,$5E,$40,$5E,$40,$5E,$40,$5F,$42,$40
.byt $06,$60,$CC,$F3,$CC,$4A,$E0,$C3,$40,$F9,$6A,$63,$7C,$40,$40,$47,$70,$40,$40,$40,$40,$40,$43,$78,$40,$40,$4F,$75,$54,$E1,$40,$E1,$40,$E1,$40,$E1,$40,$E0,$59,$40
.byt $03,$46,$73,$4C,$73,$55,$5F,$75,$EF,$56,$EB,$41,$C0,$40,$40,$40,$4F,$70,$40,$48,$40,$43,$7C,$40,$40,$40,$C0,$DF,$D5,$5F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$42,$40
.byt $06,$60,$D7,$DD,$F6,$4A,$E0,$C3,$40,$F9,$68,$40,$C0,$70,$40,$40,$40,$4F,$7F,$7F,$7F,$7C,$40,$40,$40,$43,$C0,$40,$54,$E4,$CC,$C0,$F6,$C1,$ED,$E0,$F5,$C8,$41,$40
.byt $03,$4E,$C0,$C0,$C2,$55,$5F,$75,$EF,$56,$EF,$40,$4F,$7C,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$E0,$7C,$40,$F5,$55,$73,$7F,$49,$7E,$52,$5F,$48,$6B,$5A,$40
.byt $06,$60,$D7,$DD,$F6,$40,$E0,$C3,$40,$F9,$60,$40,$43,$C0,$60,$40,$40,$40,$40,$40,$40,$40,$40,$40,$43,$C0,$70,$40,$44,$E4,$CC,$C0,$F6,$C1,$ED,$E0,$F2,$C8,$41,$40
.byt $03,$46,$73,$4C,$73,$5D,$5F,$75,$EF,$56,$50,$FF,$40,$C0,$7C,$40,$40,$40,$40,$40,$40,$40,$40,$40,$E0,$C0,$40,$FF,$42,$4F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7C,$42,$40
.byt $06,$60,$CC,$F3,$CC,$44,$E0,$C3,$40,$F9,$60,$40,$40,$4F,$C0,$78,$40,$40,$40,$40,$40,$40,$40,$47,$C0,$7C,$40,$40,$44,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$55,$40
.byt $03,$54,$7F,$7F,$7F,$55,$5F,$7D,$FF,$56,$FF,$40,$FF,$43,$C0,$C0,$70,$40,$40,$40,$40,$40,$43,$C0,$C0,$70,$FF,$40,$FD,$40,$40,$40,$40,$40,$40,$40,$40,$40,$4A,$40
.byt $06,$6A,$C0,$C0,$C0,$44,$E3,$EA,$60,$C9,$60,$40,$40,$40,$E0,$C0,$C8,$C0,$C0,$C0,$C0,$C0,$C2,$C0,$C1,$40,$40,$40,$41,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$40
.byt $03,$54,$40,$40,$40,$55,$5D,$5C,$CA,$66,$40,$FF,$40,$FF,$43,$C0,$C6,$C1,$E3,$F3,$F1,$F8,$DC,$C0,$70,$FF,$40,$FF,$42,$D5,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$40
.byt $06,$6A,$6A,$6A,$6A,$64,$E3,$E1,$40,$F1,$60,$40,$40,$40,$40,$E0,$C4,$C3,$E0,$D8,$D8,$67,$C8,$C1,$40,$40,$40,$40,$41,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$40
.byt $03,$55,$55,$55,$55,$55,$5F,$7F,$7F,$7E,$FF,$40,$FF,$40,$FF,$43,$C3,$C1,$E1,$F1,$F0,$F0,$F0,$70,$FF,$40,$FF,$40,$FF,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A,$40
.byt $06,$6A,$6A,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$41,$E1,$E0,$D8,$D8,$4E,$60,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$55,$55,$40
.byt $03,$55,$FF,$EA,$EA,$EA,$EA,$EA,$EA,$EA,$50,$FF,$40,$FF,$40,$FF,$40,$E3,$4C,$4C,$F0,$F1,$40,$FF,$40,$FF,$40,$FF,$41,$EA,$EA,$EA,$EA,$EA,$EA,$EA,$EA,$40,$6A,$40
.byt $06,$68,$F5,$D5,$D5,$D5,$D5,$D5,$D5,$D5,$D5,$60,$40,$40,$40,$40,$06,$4F,$C0,$7F,$7F,$7C,$40,$40,$40,$40,$40,$40,$D5,$D5,$D5,$D5,$D5,$D5,$D5,$D5,$D5,$D5,$45,$40
.byt $03,$51,$EA,$EA,$EA,$EA,$EA,$EA,$EA,$EA,$EA,$50,$FF,$40,$FF,$40,$FF,$40,$40,$40,$40,$40,$FF,$40,$FF,$40,$FF,$41,$EA,$EA,$EA,$EA,$EA,$EA,$EA,$EA,$EA,$EA,$ED,$40
.byt $03,$dd,$d5,$d5,$d5,$d5,$d5,$d5
	.byt $d5,$d5,$d5,$d7,$ff,$ff,$ff,$ff,$ff,$ff,$06,$f3,$03,$ff,$ff,$ff
	.byt $ff,$ff,$ff,$fd,$d5,$d5,$d5,$d5,$d5,$d5,$d5,$d5,$d5,$d5,$d6,$40
	.byt $03,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
	.byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
	.byt $40,$40,$40,$40,$40,$40,$40,$40

_up_controls
	.byt $06,$6a,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$40,$40,$47
	.byt $c0,$c0,$c0,$c0,$c0,$c0,$c0,$c0,$78,$50,$51,$4a,$6a,$f3,$4a,$6a
	.byt $f3,$4a,$64,$ff,$ff,$ff,$ff,$40,$03,$54,$5f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7e,$5f,$7f,$c9,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	.byt $5b,$57,$57,$54,$40,$40,$40,$40,$40,$40,$55,$c0,$7f,$61,$7f,$40
	.byt $06,$40,$ea,$c0,$40,$c0,$40,$c0,$40,$c0,$40,$c0,$c1,$40,$40,$46
	.byt $40,$40,$40,$40,$40,$40,$40,$40,$58,$50,$50,$4a,$c0,$c0,$c0,$c0
	.byt $c0,$c0,$45,$80,$88,$5e,$c0,$40,$03,$7e,$54,$80,$5e,$80,$5e,$80
	.byt $5e,$80,$5e,$83,$7e,$5f,$7f,$76,$40,$40,$40,$40,$40,$40,$40,$40
	.byt $5b,$57,$75,$54,$7e,$ff,$ff,$ff,$ff,$5f,$5d,$80,$88,$5e,$c0,$40
	.byt $06,$40,$ea,$c0,$40,$c0,$40,$c0,$40,$c0,$40,$c0,$c1,$40,$40,$46
	.byt $40,$40,$40,$40,$40,$40,$40,$40,$58,$50,$42,$6a,$c1,$40,$40,$40
	.byt $40,$e0,$41,$80,$88,$5e,$c0,$40,$03,$7e,$5f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7e,$5f,$7f,$76,$40,$40,$40,$40,$40,$40,$40,$40
	.byt $5b,$75,$55,$54,$7e,$ff,$ff,$ff,$ff,$5f,$54,$40,$7f,$61,$7f,$40
	.byt $06,$40,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$40,$40,$46
	.byt $40,$40,$40,$40,$40,$40,$40,$40,$58,$42,$40,$40,$c1,$40,$40,$40
	.byt $40,$e0,$40,$76,$ff,$ff,$ff,$40,$03,$54,$40,$40,$40,$40,$40,$40
	.byt $40,$40,$40,$40,$40,$55,$4a,$d9,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	.byt $59,$54,$c0,$5e,$7e,$ff,$ff,$ff,$ff,$5f,$5f,$76,$40,$40,$40,$40
	.byt $06,$6a,$6a,$6a,$6a,$6a,$6a,$6a,$6a,$6a,$6a,$6a,$6a,$6a,$45,$57
	.byt $c0,$c0,$c0,$c0,$c0,$c0,$c0,$c0,$7a,$6a,$d8,$40,$c1,$40,$40,$40
	.byt $40,$e0,$40,$46,$6a,$6a,$6a,$40,$03,$55,$55,$55,$55,$55,$55,$55
	.byt $55,$55,$55,$55,$55,$55,$4a,$df,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	.byt $41,$54,$c0,$5e,$7f,$7f,$7f,$7f,$7f,$7f,$5f,$7e,$55,$55,$55,$40
	.byt $41,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
	.byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
	.byt $40,$40,$40,$40,$40,$40,$40,$60
_disk_buffer
	.dsb 256
_freebuffer 
    .dsb 256
    .dsb 256
    .dsb 256
    .dsb 256
    .dsb 256
	.dsb 184+40
	.dsb 40


#ifdef HAVE_MISSIONS

#define TXTPTRLO $fe
#define TXTPTRHI $ff

/* General routines for missions, which are fixed and NOT
   loaded from disk */


clear_msg
.(
	lda double_buff
	beq nodb
	jsr clr_hires2
	jsr set_ink2
	jsr dump_buf
	ldx #6
	ldy #25
	jmp cont
nodb
	jsr clr_hires
	jsr set_ink2
	ldx #6
	ldy #(25+11)
cont
	stx pm_savx+1
	sty pm_savy+1
	jmp gotoXY
.)

print_mission_message
.(
	jsr clear_msg
	lda #<str_inctrans
	ldx #>str_inctrans
	jsr print

	jsr wait
	jsr wait
+pm_savx
	ldx #0 ;SMC
+pm_savy
	ldy #0
	jsr gotoXY
	jsr put_space

	jsr perform_CRLF
	jsr perform_CRLF

	lda $fe
	ldx $ff
	jsr print

	; Do we exit with end of string or newpage?
	cmp #11
	bne endtrans
	
	; new page
	txa
	sec
	adc $fe
	sta $fe
	bcc nocarry
	inc $ff
nocarry
	jsr perform_CRLF
	jsr perform_CRLF

	lda #<str_moretrans
	ldx #>str_moretrans
	jsr print
	jsr rkey
	jsr clear_msg
	jmp pm_savx

endtrans
	jsr perform_CRLF
	jsr perform_CRLF

	lda #<str_endtrans
	ldx #>str_endtrans
	jsr print
	jsr rkey

	lda _mission
	cmp #$fc	; Failed
	beq FailMissionPack
	cmp #$f8	; Success
	beq FinishMissionPack

	lda NeedsDiskLoad
	beq end
	dec NeedsDiskLoad
	jmp load_mission	; This is jsr/rts
end
	rts
.)

rkey
.(
	jsr ReadKeyNoBounce
	cmp #" "; Using ESC ($1b) may accidentaly make player launch the escape pod!
	bne rkey
	rts
.)

FailMissionPack
.(
	lda #<str_failpack
	pha
	lda #>str_failpack
	pha
	jmp EmptyMission
.)

FinishMissionPack
.(
	lda #<str_successpack
	pha
	lda #>str_successpack
	pha
.)
EmptyMission
.(
  	jsr clear_msg
	pla
	tax
	pla
  	jsr print
	jsr rkey

+EmptyVectors
	; Put clc/rts/00 at all jump vectors
	ldy #0
	sty NeedsDiskLoad
	sty AvoidOtherShips
	sty MissionCargo

	lda #<OnPlayerLaunch
	sta tmp0
	lda #>OnPlayerLaunch
	sta tmp0+1
loop
	lda #$18
	sta (tmp0),y
	iny
	lda #$60
	sta (tmp0),y
	iny
	lda #$00
	sta (tmp0),y

	iny
	cpy #30
	bcc loop

	rts

.)

#define OVERLAY_MISSION 100+NUM_SECT_OVL+3

#define MISSION_CODE_START	$a000-NUM_SECT_MISSION_CODE*256

load_mission
.(
	lda _mission
	cmp #$fc	; Failed
	beq EmptyVectors
	cmp #$f8	; Success
	beq EmptyVectors

	jsr _init_disk

    ; Sector to read    
	lda _mission
	lsr
	lsr

	; Multiply by 6
	asl
	sta tmp
	asl
	clc
	adc tmp

	;clc
	adc #<OVERLAY_MISSION
    ldy #0
    sta (sp),y
	pha
	iny
	lda #>OVERLAY_MISSION
	adc #0
    sta (sp),y

    ;Sedoric bug workaround 
	beq testbug
	pla
	jmp dobug
testbug
	pla
	cmp #225 ;$f3
	bcc nosedbug
dobug
	dey
	lda (sp),y
	clc
	adc #1
	sta (sp),y
	iny
nosedbug

	; Address of buffer
    iny
    lda #<(MISSION_CODE_START)
    sta (sp),y
    lda #>(MISSION_CODE_START)
    iny
    sta (sp),y

	; Load mission code
    lda #NUM_SECT_MISSION_CODE
    sta tmp
	sei
loop
    jsr _sect_read
    jsr inc_disk_params

    dec tmp
    bne loop
	cli

	jmp _init_irq_routine
	;rts

.)

#endif

osdk_stack .dsb 4
osdk_end 
; End of program


#ifdef HAVE_MISSIONS

.dsb MISSION_CODE_START-*-24

_mission_callbacks

// Jump table for routines accessible from mission code
IndFlightMessage
	jmp fligth_message_b
IndAddSpaceObject	
	jmp AddSpaceObject
IndSetShipEquip
	jmp SetShipEquip
IndRnd
#ifdef REALRANDOM
		jmp randgen
#else
		jmp _gen_rnd_number
#endif
IndSetCurOb
	jmp SetCurOb
IndLaunchShip
	jmp LaunchShipFromOther
IndGetShipPos
	jmp GetShipPos
IndGetShipType
	jmp GetShipType
__start_mission_code

// Jump table to mission functions    
// These are kind of event handlers   
// OnPlayerXXX. The idea is patching these with the necessary jumps. If returns C=1 it means
// that text is to be plotted to screen (brief or debrief). 

OnPlayerLaunch			.dsb 3
OnPlayerDock			.dsb 3
OnPlayerHyper			.dsb 3
OnExplodeShip			.dsb 3
OnDockedShip			.dsb 3
OnHyperShip				.dsb 3
OnEnteringSystem		.dsb 3
OnNewEncounter			.dsb 3

// In OnScoopObject returning with C=1 means that the main program is not to handle
// the object scooped (generating and storing items in bay)
OnScoopObject			.dsb 3
	
// OnGameLoadad called whenever a game is loaded from disk (for initializing things)
OnGameLoaded			.dsb 3

// Some public variables 
NeedsDiskLoad		.byt 0	; Will be set to $ff when a new mission needs to be loaded from disk
MissionSummary		.word 0
MissionCargo		.byt 0	; Tons in cargo for mission
AvoidOtherShips		.byt 0  ; if not zero, no encounters.
#endif

; Here will go everything that will be put in overlay ram Check osdk_config.bat

.bss
*=$c000



#ifdef HAVE_MISSIONS
#echo **** Free space:
#print (_mission_callbacks-osdk_end)
#echo
#else
#echo **** Free space:
#print ($a000-osdk_end)
#echo
#endif