
; #######################################
; #######################################
;        All sprites of the game
; #######################################
; #######################################



; =======================================
;			All 26 barels
; =======================================
_KongSprite_Barel_FallDiagonal_1
	; 2x11
	.byt %000110,%000000
	.byt %011011,%110000
	.byt %011010,%011000
	.byt %111110,%001100
	.byt %111111,%101010
	.byt %111111,%111010
	.byt %111111,%111010
	.byt %111111,%101010
	.byt %011111,%110100
	.byt %001111,%101100
	.byt %000111,%111000

_KongSprite_Barel_FallDiagonal_2
	; 2x10
	.byt %000111,%111000
	.byt %001100,%110100
	.byt %011000,%111010
	.byt %101011,%111010
	.byt %101111,%101010
	.byt %111111,%111010
	.byt %111111,%110010
	.byt %111111,%111100
	.byt %011111,%111000
	.byt %001111,%110000

_KongSprite_Barel_FallStraight
	; 2x9
	.byt %001111,%111000
	.byt %010001,%000110
	.byt %111111,%111101
	.byt %111111,%111101
	.byt %111111,%111101
	.byt %111111,%111101
	.byt %111111,%111101
	.byt %111111,%111111
	.byt %011111,%111110

_KongSprite_Barel_BottomLeft
	; 2x10
	.byt %000111,%100000
	.byt %001111,%110000
	.byt %010111,%111000
	.byt %101110,%011100
	.byt %101110,%011100
	.byt %101111,%111100
	.byt %100111,%111100
	.byt %010011,%101000
	.byt %001000,%010000
	.byt %000111,%100000

_KongSprite_Barel_BottomRight
	; 2x10
	.byt %000111,%100000
	.byt %001111,%110000
	.byt %011111,%101000
	.byt %111001,%110100
	.byt %111001,%110100
	.byt %111111,%110100
	.byt %111111,%100100
	.byt %010111,%001000
	.byt %001000,%010000
	.byt %000111,%100000

_KongSprite_Barel_TopRight
	; 2x10
	.byt %000111,%100000
	.byt %001000,%010000
	.byt %010111,%001000
	.byt %111111,%100100
	.byt %111111,%110100
	.byt %111001,%110100
	.byt %111001,%110100
	.byt %011111,%101000
	.byt %001111,%110000
	.byt %000111,%100000

_KongSprite_Barel_TopLeft
	; 2x10
	.byt %000111,%100000
	.byt %001000,%010000
	.byt %010011,%101000
	.byt %100111,%111100
	.byt %101111,%111100
	.byt %101110,%011100
	.byt %101110,%011100
	.byt %010111,%111000
	.byt %001111,%110000
	.byt %000111,%100000
	
_KongSprite_Barel_Bottom
	; 2x10
	.byt %000111,%100000
	.byt %001111,%110000
	.byt %011111,%111000
	.byt %110100,%101100
	.byt %101100,%110100
	.byt %101111,%110100
	.byt %101111,%110100
	.byt %010111,%101000
	.byt %001000,%010000
	.byt %000111,%100000

_KongSprite_Barel_Top
	; 2x10
	.byt %000111,%100000
	.byt %001000,%010000
	.byt %010111,%101000
	.byt %101111,%110100
	.byt %101111,%110100
	.byt %101100,%110100
	.byt %110100,%101100
	.byt %011111,%111000
	.byt %001111,%110000
	.byt %000111,%100000

_KongSprite_Barel_Left
	; 2x10
	.byt %000111,%100000
	.byt %001000,%110000
	.byt %010111,%011000
	.byt %101111,%111100
	.byt %101110,%011100
	.byt %101110,%011100
	.byt %101111,%111100
	.byt %010111,%011000
	.byt %001000,%110000
	.byt %000111,%100000

_KongSprite_Barel_Right
	; 2x10
	.byt %000111,%100000
	.byt %001100,%010000
	.byt %011111,%101000
	.byt %111111,%110100
	.byt %111001,%110100
	.byt %111001,%110100
	.byt %111111,%110100
	.byt %011011,%101000
	.byt %001100,%010000
	.byt %000111,%100000



; =======================================
;			The moving girders
; =======================================

_KongSprite_Girder_1
	; 4x11
	.byt %000000,%000111,%110000,%000000
	.byt %000000,%000011,%100000,%000000
	.byt %000000,%000001,%000000,%000000
	.byt %000000,%000010,%100000,%000000
	.byt %000000,%000011,%100000,%000000
	.byt %000000,%000001,%000000,%111111
	.byt %000000,%111111,%111111,%111111
	.byt %111111,%111111,%111110,%011000
	.byt %111110,%001100,%001100,%111111
	.byt %001100,%111111,%111111,%100000
	.byt %111111,%100000,%000000,%000000

_KongSprite_Girder_2
	; 4x11
	.byt %000000,%000111,%110000,%000000
	.byt %000000,%000011,%100000,%000000
	.byt %000000,%000001,%000000,%000000
	.byt %000000,%000010,%100000,%000000
	.byt %000000,%000011,%100000,%000000
	.byt %111110,%000001,%000000,%000000
	.byt %111111,%111111,%111110,%000000
	.byt %001100,%111111,%111111,%111111
	.byt %111110,%001100,%011000,%111111
	.byt %000011,%111111,%111110,%110000
	.byt %000000,%000000,%000011,%111110


; =======================================
;			Donkey kong (3x4=12)
; =======================================

_KongSprite_Kong_Body
	; 3x25
	.byt %000000,%011110,%000000
	.byt %000001,%111111,%100000
	.byt %000111,%111111,%111000
	.byt %001110,%001100,%011100
	.byt %011110,%100001,%011110
	.byt %111011,%111111,%110111
	.byt %110001,%010010,%100011
	.byt %111100,%000000,%001111
	.byt %111110,%011110,%011111
	.byt %111110,%111111,%011111
	.byt %111111,%100001,%111111
	.byt %111110,%101101,%011111
	.byt %011010,%111111,%010110
	.byt %011001,%000000,%100110
	.byt %001100,%111111,%001100
	.byt %000100,%000000,%001100
	.byt %000110,%000000,%011000
	.byt %000111,%000000,%111000
	.byt %001111,%100001,%111100
	.byt %001111,%111111,%111100
	.byt %011111,%110011,%111110
	.byt %011111,%100001,%111110
	.byt %110000,%100001,%000011
	.byt %101010,%010010,%010101
	.byt %111111,%110011,%111111

_KongSprite_Kong_Barel
	; 3x13
	.byt %000001,%111111,%100000
	.byt %000011,%000000,%010000
	.byt %000110,%101010,%101000
	.byt %000111,%110101,%111000
	.byt %001001,%111111,%100100
	.byt %010111,%111111,%111010
	.byt %100000,%111111,%000001
	.byt %100111,%111111,%111001
	.byt %100001,%111111,%100001
	.byt %110111,%000000,%111011
	.byt %111100,%000000,%001111
	.byt %110000,%000000,%000011
	.byt %100000,%000000,%000001

_KongSprite_Kong_LeftHand
	; 2x11
	.byt %000010,%000000
	.byt %000110,%000000
	.byt %001110,%000000
	.byt %011110,%000000
	.byt %011110,%000000
	.byt %111110,%000000
	.byt %110001,%000000
	.byt %100011,%000000
	.byt %100101,%100000
	.byt %110010,%100000
	.byt %011111,%000000

_KongSprite_Kong_Righthand
	; 2x11
	.byt %000000,%010000
	.byt %000000,%011000
	.byt %000000,%011100
	.byt %000000,%011110
	.byt %000000,%011110
	.byt %000000,%011111
	.byt %000000,%100011
	.byt %000000,%110001
	.byt %000001,%101001
	.byt %000001,%010011
	.byt %000000,%111110

_KongSprite_Kong_Falling
	; 4x28
	.byt %011110,%000000,%001110,%000000
	.byt %100001,%111000,%010001,%000000
	.byt %110000,%000100,%010000,%100000
	.byt %100000,%000010,%010000,%100000
	.byt %011000,%001100,%010000,%010000
	.byt %000111,%110001,%110001,%100000
	.byt %001111,%100011,%110011,%000000
	.byt %011111,%000111,%110001,%000000
	.byt %111111,%111101,%111000,%100000
	.byt %111111,%110000,%111111,%000000
	.byt %011111,%110000,%111100,%000000
	.byt %000111,%111001,%111000,%000000
	.byt %000001,%111111,%111000,%000000
	.byt %000000,%111111,%110000,%000000
	.byt %000000,%111111,%111000,%000000
	.byt %000000,%111111,%111100,%011000
	.byt %000000,%111111,%111111,%100100
	.byt %000001,%111111,%110001,%010100
	.byt %000011,%111111,%100100,%001000
	.byt %000111,%111110,%110010,%111100
	.byt %001111,%111100,%011011,%111100
	.byt %011111,%111110,%100001,%010110
	.byt %011111,%111111,%101110,%000010
	.byt %001111,%111111,%111011,%010011
	.byt %010001,%111111,%110001,%111001
	.byt %100000,%001110,%111100,%010101
	.byt %101010,%101000,%001111,%001110
	.byt %011110,%110000,%000000,%000000

	
; =======================================
;		Platforms (3 large ones)
; =======================================

_KongSprite_Plaform
	; 7x5
	.byt %011111,%111111,%111111,%111111,%111111,%111111
	.byt %011111,%111111,%111111,%111111,%111111,%111111
	.byt %011110,%000111,%111111,%111111,%111110,%000110
	.byt %111110,%000100,%000000,%000000,%000010,%000110
	.byt %111111,%111100,%000000,%000000,%000011,%111110

_KongSprite_Plaform_Falling1
	; 4x30
	.byt %000000,%000000,%000000,%000001
	.byt %000000,%000000,%000000,%000011
	.byt %000000,%000000,%000000,%110110
	.byt %000000,%000000,%000000,%111110
	.byt %000000,%000000,%000001,%101100
	.byt %000000,%000000,%000001,%100100
	.byt %000000,%000000,%000011,%001100
	.byt %000000,%000000,%000011,%001000
	.byt %000000,%000000,%000111,%111000
	.byt %000000,%000000,%000110,%110000
	.byt %000000,%000000,%001110,%000000
	.byt %000000,%000000,%011100,%000000
	.byt %000000,%000000,%011100,%000000
	.byt %000000,%000000,%111000,%000000
	.byt %000000,%000000,%111000,%000000
	.byt %000000,%000001,%110000,%000000
	.byt %000000,%000001,%110000,%000000
	.byt %000000,%000011,%100000,%000000
	.byt %000000,%000111,%000000,%000000
	.byt %000000,%000111,%000000,%000000
	.byt %000000,%001110,%000000,%000000
	.byt %000000,%001110,%000000,%000000
	.byt %000000,%011011,%000000,%000000
	.byt %000000,%110010,%000000,%000000
	.byt %000000,%110110,%000000,%000000
	.byt %000001,%100100,%000000,%000000
	.byt %000001,%111100,%000000,%000000
	.byt %000011,%011000,%000000,%000000
	.byt %000011,%000000,%000000,%000000
	.byt %000110,%000000,%000000,%000000

_KongSprite_Plaform_Falling2
	; 3x34
	.byt %000001,%100000,%000000
	.byt %000001,%100000,%000000
	.byt %000000,%110000,%000000
	.byt %000000,%110000,%000000
	.byt %000000,%111000,%000000
	.byt %000011,%111000,%000000
	.byt %000010,%011000,%000000
	.byt %000011,%001100,%000000
	.byt %000001,%001100,%000000
	.byt %000001,%101110,%000000
	.byt %000000,%111110,%000000
	.byt %000000,%001110,%000000
	.byt %000000,%001111,%000000
	.byt %000000,%000111,%000000
	.byt %000000,%000111,%100000
	.byt %000000,%000011,%100000
	.byt %000000,%000011,%110000
	.byt %000000,%000011,%110000
	.byt %000000,%000001,%110000
	.byt %000000,%000001,%111000
	.byt %000000,%000000,%111000
	.byt %000000,%000000,%111100
	.byt %000000,%000000,%011100
	.byt %000000,%000000,%011100
	.byt %000000,%000000,%111110
	.byt %000000,%000000,%100110
	.byt %000000,%000000,%110011
	.byt %000000,%000000,%110011
	.byt %000000,%000000,%011110
	.byt %000000,%000000,%011100
	.byt %000000,%000000,%001100
	.byt %000000,%000000,%001110
	.byt %000000,%000000,%000110
	.byt %000000,%000000,%000100

_KongSprite_Plaform_Falling3
	; 6x12
	.byt %000000,%000000,%000000,%000000,%000000,%000110
	.byt %000000,%000000,%000000,%000000,%000000,%111110
	.byt %000000,%000000,%000000,%000000,%000111,%111000
	.byt %000000,%000000,%000000,%000000,%111111,%001000
	.byt %000000,%000000,%000000,%000111,%111100,%011000
	.byt %000000,%000000,%000000,%011111,%111111,%110000
	.byt %000000,%000000,%000011,%111111,%000010,%000000
	.byt %000000,%000000,%011111,%111000,%000000,%000000
	.byt %000000,%000011,%111111,%100000,%000000,%000000
	.byt %000000,%011111,%111100,%000000,%000000,%000000
	.byt %000001,%111100,%001000,%000000,%000000,%000000
	.byt %000001,%100111,%111000,%000000,%000000,%000000	

; =======================================
;		Hooks (4 of them)
; =======================================
_KongSprite_Hook
	; 1x26
	.byt %000110
	.byt %000110
	.byt %000110
	.byt %000110
	.byt %000110
	.byt %000110
	.byt %000110
	.byt %000110
	.byt %000110
	.byt %000110
	.byt %000110
	.byt %000110
	.byt %000110
	.byt %000110
	.byt %000110
	.byt %000110
	.byt %001111
	.byt %001101
	.byt %001011
	.byt %001011
	.byt %001011
	.byt %001011
	.byt %001110
	.byt %001110
	.byt %111100
	.byt %011000


; =======================================
;		Mario sprites (4 of them)
; =======================================

_KongSprite_Mario_Right_1
	; 3x19
	.byt %000000,%011111,%111000
	.byt %000000,%011111,%111000
	.byt %000000,%111111,%001110
	.byt %000000,%111111,%011000
	.byt %000001,%111111,%001110
	.byt %000001,%110101,%111100
	.byt %111000,%110101,%011000
	.byt %111100,%010101,%001100
	.byt %011110,%011111,%100000
	.byt %000111,%111000,%000111
	.byt %000001,%101111,%111110
	.byt %000001,%001000,%001100
	.byt %000011,%001000,%000000
	.byt %000011,%111100,%110000
	.byt %000011,%001111,%110000
	.byt %000011,%111111,%110000
	.byt %000011,%100001,%100000
	.byt %001111,%100001,%100000
	.byt %001111,%000000,%000000

_KongSprite_Mario_Left_1
	; 3x20
	.byt %000000,%001001,%100000
	.byt %000000,%001111,%110000
	.byt %000000,%000111,%111100
	.byt %000000,%110101,%111110
	.byt %000000,%111101,%111110
	.byt %000000,%011001,%111110
	.byt %000000,%011111,%111110
	.byt %000101,%011111,%111110
	.byt %000111,%011111,%111110
	.byt %000011,%000111,%111100
	.byt %010001,%100011,%111100
	.byt %111000,%111111,%000000
	.byt %111110,%111001,%000000
	.byt %011111,%101111,%100000
	.byt %011001,%111110,%110000
	.byt %000000,%111101,%111000
	.byt %000000,%011100,%101000
	.byt %000000,%001100,%000000
	.byt %000000,%011111,%000000
	.byt %000000,%011110,%000000

_KongSprite_Mario_JumpForHook
	; 3x24
	.byt %000011,%010000,%000000
	.byt %000111,%110000,%000000
	.byt %001111,%110110,%000000
	.byt %011111,%011110,%000000
	.byt %111111,%001100,%000000
	.byt %111111,%111110,%000000
	.byt %011111,%110000,%100000
	.byt %001111,%100000,%110000
	.byt %001111,%000100,%111110
	.byt %001111,%001100,%111100
	.byt %000111,%111001,%100000
	.byt %010000,%110111,%000000
	.byt %111111,%110110,%000000
	.byt %011001,%110110,%000000
	.byt %000000,%111110,%000000
	.byt %110111,%110110,%000000
	.byt %111111,%111110,%000000
	.byt %111000,%111110,%000000
	.byt %011100,%011100,%000000
	.byt %001100,%111000,%000000
	.byt %000001,%110000,%000000
	.byt %000001,%100000,%000000
	.byt %000011,%100000,%000000
	.byt %000011,%100000,%000000

_KongSprite_Mario_Fall
	; 3x20
	.byt %000000,%000000,%111000
	.byt %000000,%000011,%111000
	.byt %000000,%000001,%100000
	.byt %110100,%000011,%100000
	.byt %111101,%111111,%000000
	.byt %011111,%111110,%000000
	.byt %000011,%101100,%000101
	.byt %000011,%111100,%001111
	.byt %000001,%101000,%111110
	.byt %000001,%101011,%111010
	.byt %000000,%101111,%110000
	.byt %010111,%111111,%111100
	.byt %111110,%011111,%111110
	.byt %111100,%011111,%101110
	.byt %010000,%110011,%000111
	.byt %000000,%110001,%100100
	.byt %000000,%010001,%110110
	.byt %000000,%000001,%111110
	.byt %000000,%000000,%111000
	.byt %000000,%000000,%011000

_KongSprite_Mario_Crash
	; 3x21
	.byt %000000,%000000,%001100
	.byt %000000,%000000,%011100
	.byt %000000,%000011,%111000
	.byt %110000,%000011,%110000
	.byt %111110,%000001,%100000
	.byt %011100,%000001,%110000
	.byt %001111,%111111,%110000
	.byt %000111,%011110,%110000
	.byt %000001,%111111,%100000
	.byt %000001,%101101,%000010
	.byt %000000,%110011,%100110
	.byt %000001,%110011,%111111
	.byt %000011,%101101,%100100
	.byt %010110,%111111,%110000
	.byt %111000,%111111,%100000
	.byt %010001,%100100,%100000
	.byt %000011,%100000,%111000
	.byt %000011,%001010,%011000
	.byt %000001,%100100,%110000
	.byt %000000,%111111,%100000
	.byt %000000,%001110,%000000

_KongSprite_Mario_GrippedToHook
	; 3x20
	.byt %000000,%000000,%010000
	.byt %001110,%000000,%010000
	.byt %001111,%110000,%110000
	.byt %111111,%111001,%110000
	.byt %001111,%111000,%100000
	.byt %001001,%111100,%100000
	.byt %011101,%111101,%100000
	.byt %111111,%111101,%100000
	.byt %011111,%011101,%100000
	.byt %001110,%011111,%110000
	.byt %000000,%010011,%011100
	.byt %000000,%000111,%110100
	.byt %000000,%001111,%111110
	.byt %000001,%011100,%111111
	.byt %000011,%110001,%111111
	.byt %000001,%100011,%100111
	.byt %000000,%000010,%001110
	.byt %000000,%000000,%111000
	.byt %000000,%000000,%011000
	.byt %000000,%000000,%001100

_KongSprite_Mario_Jump_Right
	; 3x17
	.byt %000001,%111111,%100000
	.byt %000001,%111111,%100000
	.byt %000001,%111111,%110000
	.byt %000011,%111100,%100000
	.byt %000011,%111101,%111000
	.byt %000111,%111111,%111000
	.byt %000111,%111000,%110000
	.byt %000111,%110000,%000000
	.byt %000011,%111111,%010000
	.byt %001000,%011000,%011100
	.byt %111111,%111100,%111110
	.byt %011001,%101111,%000000
	.byt %000000,%110110,%001100
	.byt %001101,%111111,%101100
	.byt %011111,%110111,%111100
	.byt %111011,%111100,%011100
	.byt %110000,%000000,%001000

_KongSprite_Mario_Jump_Left
	; 3x18
	.byt %000001,%111111,%000000
	.byt %000001,%111111,%000000
	.byt %000111,%111111,%000000
	.byt %000010,%011111,%100000
	.byt %000010,%011111,%100000
	.byt %000110,%111111,%110000
	.byt %000111,%101111,%110000
	.byt %000011,%000111,%110000
	.byt %000000,%000111,%000000
	.byt %000100,%111110,%000100
	.byt %011110,%000110,%111111
	.byt %010111,%111111,%110110
	.byt %000000,%001011,%000000
	.byt %001100,%011011,%001000
	.byt %001101,%111111,%101100
	.byt %001111,%111011,%111110
	.byt %001110,%001110,%110110
	.byt %000100,%000000,%000010

_KongSprite_Mario_Manette
	; 4x19
	.byt %000000,%000010,%000000,%000000
	.byt %000001,%110110,%000000,%000000
	.byt %000011,%111100,%000000,%000000
	.byt %000111,%110111,%100000,%000000
	.byt %001111,%110011,%100000,%000000
	.byt %001111,%111011,%100000,%000000
	.byt %001111,%111111,%000001,%000000
	.byt %000111,%111100,%000011,%011000
	.byt %000111,%111001,%100011,%110000
	.byt %000011,%111011,%000111,%100001
	.byt %000011,%111111,%111110,%000011
	.byt %000001,%111011,%110011,%111111
	.byt %000000,%110001,%111111,%111111
	.byt %000000,%000000,%011100,%110011
	.byt %000000,%000000,%001111,%100000
	.byt %000000,%000000,%011110,%000000
	.byt %000000,%000000,%011100,%000000
	.byt %000000,%000001,%111110,%000000
	.byt %000000,%000001,%111110,%000000

_KongSprite_Mario_Climb
	; 3x22
	.byt %000000,%000011,%101100
	.byt %000000,%000111,%111000
	.byt %000000,%001111,%111000
	.byt %000000,%011111,%011110
	.byt %000000,%111110,%001111
	.byt %011010,%011110,%111111
	.byt %001110,%011110,%011110
	.byt %001110,%011111,%111110
	.byt %000111,%001100,%111000
	.byt %000011,%111110,%000000
	.byt %110000,%010101,%110000
	.byt %110111,%110011,%000000
	.byt %111110,%101011,%000000
	.byt %111111,%111111,%110000
	.byt %011101,%111010,%111100
	.byt %001001,%111110,%011110
	.byt %000000,%011111,%001010
	.byt %000000,%000011,%000000
	.byt %000000,%000110,%000000
	.byt %000000,%001111,%100000
	.byt %000000,%000111,%110000
	.byt %000000,%000001,%110000

_KongSprite_Mario_LoopUp
	; 4x18
	.byt %000000,%000000,%000000,%100000
	.byt %000000,%000000,%000000,%101000
	.byt %000000,%000000,%001101,%111100
	.byt %000000,%110000,%001110,%111110
	.byt %000000,%011111,%000110,%011111
	.byt %000000,%001110,%000110,%001111
	.byt %000000,%000110,%010011,%011111
	.byt %000000,%000110,%011001,%111111
	.byt %000000,%000011,%111101,%111111
	.byt %000000,%110111,%100111,%111110
	.byt %000110,%111110,%111111,%111100
	.byt %001111,%110100,%111011,%000000
	.byt %001011,%100111,%110001,%100000
	.byt %000001,%100011,%110001,%111000
	.byt %000000,%000000,%111000,%110000
	.byt %000000,%000000,%111000,%010000
	.byt %000000,%000001,%111110,%000000
	.byt %000000,%000001,%111110,%000000

_KongSprite_Mario_HandDown
	; 2x8
	.byt %000000,%000100
	.byt %000000,%001110
	.byt %000000,%011000
	.byt %000000,%110000
	.byt %000011,%100000
	.byt %000001,%100000
	.byt %000011,%000000
	.byt %000010,%000000

_KongSprite_Mario_HandUp
	; 2x5
	.byt %000011,%000000
	.byt %000001,%010000
	.byt %000001,%110000
	.byt %000000,%111110
	.byt %000000,%000110


; =======================================
;		Crane and hook sprites
; =======================================

_KongSprite_Crane_Stick
	; 7x8
	.byt %000001,%111111,%111111,%111111,%111111,%111111,%111111,%111111
	.byt %000110,%001010,%001010,%001010,%001010,%001010,%001010,%001010
	.byt %001100,%010001,%010001,%010001,%010001,%010001,%010001,%010001
	.byt %011110,%100000,%100000,%100000,%100000,%100000,%100000,%100000
	.byt %110011,%111111,%111111,%111111,%111111,%111111,%111111,%111111
	.byt %110011,%111111,%111111,%111111,%111111,%111111,%111111,%111111
	.byt %011110,%000000,%000000,%000000,%000000,%000000,%000000,%000000
	.byt %001100,%000000,%000000,%000000,%000000,%000000,%000000,%000000

_KongSprite_Crane_Hook_1
	; 2x4
	.byt %111000,%000010
	.byt %000111,%100001
	.byt %000000,%011001
	.byt %000000,%000110

_KongSprite_Crane_Hook_2
	; 2x8
	.byt %000010,%000000
	.byt %000001,%000000
	.byt %000000,%100000
	.byt %000000,%010000
	.byt %000000,%010000
	.byt %000000,%010001
	.byt %000000,%001001
	.byt %000000,%000110

_KongSprite_Crane_Hook_3
	; 1x12
	.byt %000100
	.byt %000100
	.byt %000100
	.byt %000100
	.byt %000100
	.byt %000100
	.byt %000100
	.byt %000100
	.byt %001000
	.byt %001000
	.byt %001001
	.byt %000110

_KongSprite_Crane_Hook_4
	; 2x11
	.byt %000000,%100000
	.byt %000000,%100000
	.byt %000001,%000000
	.byt %000001,%000000
	.byt %000010,%000000
	.byt %000100,%000000
	.byt %001000,%000000
	.byt %010000,%000000
	.byt %010000,%000000
	.byt %010010,%000000
	.byt %001100,%000000

_KongSprite_Crane_Hook_5
	; 2x8
	.byt %000000,%000001
	.byt %000000,%000110
	.byt %000000,%011000
	.byt %000111,%100000
	.byt %001000,%000000
	.byt %001000,%000000
	.byt %001000,%000000
	.byt %000111,%000000

_KongSprite_Crane_ControlDown
	; 2x4
	.byt %000000,%110000
	.byt %111111,%111000
	.byt %000000,%101000
	.byt %000000,%010000

_KongSprite_Crane_ControlUp
	; 2x8
	.byt %000000,%110000
	.byt %000001,%111000
	.byt %000001,%101000
	.byt %000001,%110000
	.byt %000001,%000000
	.byt %000011,%000000
	.byt %000110,%000000
	.byt %001100,%000000
	.byt %000100,%000000

; =======================================
;		Small hearts
; =======================================
_KongSprite_SmallHeart
	; 1x7
	.byt %000100
	.byt %011010
	.byt %101010
	.byt %100010
	.byt %010010
	.byt %001100
	.byt %001000

_KongSprite_BigHeart
	; 2x8
	.byt %000001,%100110
	.byt %000010,%011001
	.byt %000010,%001001
	.byt %000001,%000001
	.byt %000001,%000001
	.byt %000000,%100010
	.byt %000000,%101100
	.byt %000000,%010000

; #######################################
; #######################################
;			All data access tables !!!
; #######################################
; #######################################

; Table of all sprites (Low part)
__FirstSprite
_KongSpriteAdd_Low
	; All 26 barels
	; First floor (5)
__FirstBarel
	.byt <_KongSprite_Barel_Right
	.byt <_KongSprite_Barel_BottomRight
	.byt <_KongSprite_Barel_Bottom
	.byt <_KongSprite_Barel_BottomLeft
	.byt <_KongSprite_Barel_Left
	; Second floor (6)
	.byt <_KongSprite_Barel_BottomLeft
__SecondFloorBarel
	.byt <_KongSprite_Barel_Bottom
	.byt <_KongSprite_Barel_BottomRight
	.byt <_KongSprite_Barel_Right
	.byt <_KongSprite_Barel_TopRight
	.byt <_KongSprite_Barel_Top
	; Third floor (6)
	.byt <_KongSprite_Barel_Right
__BarelInsertionLeft
	.byt <_KongSprite_Barel_Right
	.byt <_KongSprite_Barel_Right
__BarelInsertionMiddle
	.byt <_KongSprite_Barel_Right
	.byt <_KongSprite_Barel_Right
__BarelInsertionRight
	.byt <_KongSprite_Barel_Right
__LastBarel
	; Left fall (3)
	.byt <_KongSprite_Barel_FallDiagonal_2
__BarelCollideFallLeft
	.byt <_KongSprite_Barel_FallDiagonal_1
__BarelStartLeft
	.byt <_KongSprite_Barel_FallStraight
	; Middle fall (3)
	.byt <_KongSprite_Barel_FallDiagonal_1
__BarelCollideFallMiddle
	.byt <_KongSprite_Barel_FallDiagonal_2
__BarelStartMiddle
	.byt <_KongSprite_Barel_FallStraight
	; Right fall (3)
	.byt <_KongSprite_Barel_FallDiagonal_2
__BarelCollideFallRight
	.byt <_KongSprite_Barel_FallDiagonal_1
__BarelStartRight
	.byt <_KongSprite_Barel_FallStraight

__FirstGirder
	; Moving girders (5)
	.byt <_KongSprite_Girder_1
	.byt <_KongSprite_Girder_2
	.byt <_KongSprite_Girder_1
	.byt <_KongSprite_Girder_2
	.byt <_KongSprite_Girder_1

__FirstKong
	; Kong 1 (4)
	.byt <_KongSprite_Kong_Barel
	.byt <_KongSprite_Kong_Body
	.byt <_KongSprite_Kong_LeftHand
	.byt <_KongSprite_Kong_Righthand
	; Kong 2 (4)
	.byt <_KongSprite_Kong_Barel
	.byt <_KongSprite_Kong_Body
	.byt <_KongSprite_Kong_LeftHand
	.byt <_KongSprite_Kong_Righthand
	; Kong 3 (4)
	.byt <_KongSprite_Kong_Barel
	.byt <_KongSprite_Kong_Body
	.byt <_KongSprite_Kong_LeftHand
	.byt <_KongSprite_Kong_Righthand
	; Kong falling (1)
__FirstKongFalling
	.byt <_KongSprite_Kong_Falling
__LastKong

	; Long platforms (3)
__FirstPlatform
	.byt <_KongSprite_Plaform
	.byt <_KongSprite_Plaform
	.byt <_KongSprite_Plaform
	; Long platforms falling down (3)
__FirstPlatformFalling
	.byt <_KongSprite_Plaform_Falling1
	.byt <_KongSprite_Plaform_Falling2
	.byt <_KongSprite_Plaform_Falling3
	; Hooks that attach platforms (4)
__FirstHook
	.byt <_KongSprite_Hook
	.byt <_KongSprite_Hook
	.byt <_KongSprite_Hook
	.byt <_KongSprite_Hook
__LastHook
	; All 22 mario sprites
__FirstMario
	; First floor (5)
__FirstFloorMario
	.byt <_KongSprite_Mario_Right_1	; * . . .
	.byt <_KongSprite_Mario_Right_1	; . * . .
	.byt <_KongSprite_Mario_Right_1	; . . * .
	.byt <_KongSprite_Mario_Right_1	; . . . *
__MarioLader_1
	.byt <_KongSprite_Mario_Climb
	; Second floor (5)
__SecondFloorMario
	.byt <_KongSprite_Mario_Left_1  ; . . . . *
	.byt <_KongSprite_Mario_Left_1  ; . . . * .
	.byt <_KongSprite_Mario_Left_1  ; . . * . .
	.byt <_KongSprite_Mario_Left_1  ; . * . . .
	.byt <_KongSprite_Mario_Left_1	; * . . . .
__MarioLader_2
	; Lader (2)
	.byt <_KongSprite_Mario_Climb
__MarioLaderCollide
	.byt <_KongSprite_Mario_Climb
	; Third floor (3)
__ThirdFloorMario
	.byt <_KongSprite_Mario_Manette
	.byt <_KongSprite_Mario_LoopUp
	.byt <_KongSprite_Mario_Manette
__MarioJump
	; Mario jumping and falling (3)
	.byt <_KongSprite_Mario_JumpForHook
	.byt <_KongSprite_Mario_Fall
	.byt <_KongSprite_Mario_Crash
	; Mario gripped to hook
	.byt <_KongSprite_Mario_GrippedToHook
__FirstMarioJump
	; Mario jumping First Floor (2)
	.byt <_KongSprite_Mario_Jump_Right
	.byt <_KongSprite_Mario_Jump_Right
	; Mario jumping Second Floor (2)
	.byt <_KongSprite_Mario_Jump_Left
	.byt <_KongSprite_Mario_Jump_Left
__LastMario
	; Crane stick (3 positions)
__FirstCrane
	.byt <_KongSprite_Crane_Stick
	.byt <_KongSprite_Crane_Stick
	.byt <_KongSprite_Crane_Stick
	; Hooks (5 positions)
__FirstCraneHook
	.byt <_KongSprite_Crane_Hook_1
	.byt <_KongSprite_Crane_Hook_2
	.byt <_KongSprite_Crane_Hook_3
	.byt <_KongSprite_Crane_Hook_4
	.byt <_KongSprite_Crane_Hook_5
	; Victory poses (2x2 positions)
__FirstVictoryPose
	.byt <_KongSprite_Crane_Hook_4
	.byt <_KongSprite_Mario_GrippedToHook
	.byt <_KongSprite_Crane_Hook_2
	.byt <_KongSprite_Mario_GrippedToHook
__LastCrane
	; Mario hands (2)
__FirstMarioHand
	.byt <_KongSprite_Mario_HandDown
	.byt <_KongSprite_Mario_HandUp
	; Crane control stick (2)
__FirstCraneStick
	.byt <_KongSprite_Crane_ControlDown
	.byt <_KongSprite_Crane_ControlUp
	; Hearts of victory (2)
__FirstHeart
	.byt <_KongSprite_SmallHeart
	.byt <_KongSprite_BigHeart


; Table of all sprites (High part)
_KongSpriteAdd_High
	; All 26 barels
	; First floor (5)
	.byt >_KongSprite_Barel_Right
	.byt >_KongSprite_Barel_BottomRight
	.byt >_KongSprite_Barel_Bottom
	.byt >_KongSprite_Barel_BottomLeft
	.byt >_KongSprite_Barel_Left
	; Second floor (6)
	.byt >_KongSprite_Barel_BottomLeft
	.byt >_KongSprite_Barel_Bottom
	.byt >_KongSprite_Barel_BottomRight
	.byt >_KongSprite_Barel_Right
	.byt >_KongSprite_Barel_TopRight
	.byt >_KongSprite_Barel_Top
	; Third floor (6)
	.byt >_KongSprite_Barel_Right
	.byt >_KongSprite_Barel_Right
	.byt >_KongSprite_Barel_Right
	.byt >_KongSprite_Barel_Right
	.byt >_KongSprite_Barel_Right
	.byt >_KongSprite_Barel_Right
	; Left fall (3)
	.byt >_KongSprite_Barel_FallDiagonal_2
	.byt >_KongSprite_Barel_FallDiagonal_1
	.byt >_KongSprite_Barel_FallStraight
	; Middle fall (3)
	.byt >_KongSprite_Barel_FallDiagonal_1
	.byt >_KongSprite_Barel_FallDiagonal_2
	.byt >_KongSprite_Barel_FallStraight
	; Right fall (3)
	.byt >_KongSprite_Barel_FallDiagonal_2
	.byt >_KongSprite_Barel_FallDiagonal_1
	.byt >_KongSprite_Barel_FallStraight
	; Moving girders (5)
	.byt >_KongSprite_Girder_1
	.byt >_KongSprite_Girder_2
	.byt >_KongSprite_Girder_1
	.byt >_KongSprite_Girder_2
	.byt >_KongSprite_Girder_1
	; Kong 1 (4)
	.byt >_KongSprite_Kong_Barel
	.byt >_KongSprite_Kong_Body
	.byt >_KongSprite_Kong_LeftHand
	.byt >_KongSprite_Kong_Righthand
	; Kong 2 (4)
	.byt >_KongSprite_Kong_Barel
	.byt >_KongSprite_Kong_Body
	.byt >_KongSprite_Kong_LeftHand
	.byt >_KongSprite_Kong_Righthand
	; Kong 3 (4)
	.byt >_KongSprite_Kong_Barel
	.byt >_KongSprite_Kong_Body
	.byt >_KongSprite_Kong_LeftHand
	.byt >_KongSprite_Kong_Righthand
	; Kong falling (1)
	.byt >_KongSprite_Kong_Falling
	; Long platforms (3)
	.byt >_KongSprite_Plaform
	.byt >_KongSprite_Plaform
	.byt >_KongSprite_Plaform
	; Long platforms falling down(3)
	.byt >_KongSprite_Plaform_Falling1
	.byt >_KongSprite_Plaform_Falling2
	.byt >_KongSprite_Plaform_Falling3
	; Hooks that attach platforms (4)
	.byt >_KongSprite_Hook
	.byt >_KongSprite_Hook
	.byt >_KongSprite_Hook
	.byt >_KongSprite_Hook
	; All 22 mario sprites
	; First floor (5)
	.byt >_KongSprite_Mario_Right_1
	.byt >_KongSprite_Mario_Right_1
	.byt >_KongSprite_Mario_Right_1
	.byt >_KongSprite_Mario_Right_1
	.byt >_KongSprite_Mario_Climb
	; Second floor (5)
	.byt >_KongSprite_Mario_Left_1
	.byt >_KongSprite_Mario_Left_1
	.byt >_KongSprite_Mario_Left_1
	.byt >_KongSprite_Mario_Left_1
	.byt >_KongSprite_Mario_Left_1
	; Lader (2)
	.byt >_KongSprite_Mario_Climb
	.byt >_KongSprite_Mario_Climb
	; Third floor (3)
	.byt >_KongSprite_Mario_Manette
	.byt >_KongSprite_Mario_LoopUp
	.byt >_KongSprite_Mario_Manette
	; Mario jumping and falling (3)
	.byt >_KongSprite_Mario_JumpForHook
	.byt >_KongSprite_Mario_Fall
	.byt >_KongSprite_Mario_Crash
	; Mario gripped to hook
	.byt >_KongSprite_Mario_GrippedToHook
	; Mario jumping First Floor (2)
	.byt >_KongSprite_Mario_Jump_Right
	.byt >_KongSprite_Mario_Jump_Right
	; Mario jumping Second Floor (2)
	.byt >_KongSprite_Mario_Jump_Left
	.byt >_KongSprite_Mario_Jump_Left
	; Crane stick (3 positions)
	.byt >_KongSprite_Crane_Stick
	.byt >_KongSprite_Crane_Stick
	.byt >_KongSprite_Crane_Stick
	; Hooks (5 positions)
	.byt >_KongSprite_Crane_Hook_1
	.byt >_KongSprite_Crane_Hook_2
	.byt >_KongSprite_Crane_Hook_3
	.byt >_KongSprite_Crane_Hook_4
	.byt >_KongSprite_Crane_Hook_5
	; Victory poses (2x2 positions)
	.byt >_KongSprite_Crane_Hook_4
	.byt >_KongSprite_Mario_GrippedToHook
	.byt >_KongSprite_Crane_Hook_2
	.byt >_KongSprite_Mario_GrippedToHook
	; Mario hands (2)
	.byt >_KongSprite_Mario_HandDown
	.byt >_KongSprite_Mario_HandUp
	; Crane control stick (2)
	.byt >_KongSprite_Crane_ControlDown
	.byt >_KongSprite_Crane_ControlUp
	; Hearts of victory (2)
	.byt >_KongSprite_SmallHeart
	.byt >_KongSprite_BigHeart


; Table of screen position (X coordinate)
_KongSpriteScreenX
	; All 26 barels
	; First floor (5)
	.byt 9
	.byt 14
	.byt 19
	.byt 24
	.byt 30
	; Second floor (6)
	.byt 30
	.byt 24
	.byt 19
	.byt 14
	.byt 9
	.byt 4
	; Third floor (6)
	.byt 4 
	.byt 9 
	.byt 13
	.byt 16
	.byt 19
	.byt 22
	; Left fall (3)
	.byt 9 
	.byt 9 
	.byt 9 
	; Middle fall (3)
	.byt 16 
	.byt 16 
	.byt 16 
	; Right fall (3)
	.byt 22 
	.byt 22 
	.byt 22 
	; Moving girders (5)
	.byt 5 
	.byt 10 
	.byt 15
	.byt 21
	.byt 26
	; Kong 1 (4)
	.byt 9 
	.byt 9 
	.byt 8 
	.byt 11
	; Kong 2 (4)
	.byt 7+8 
	.byt 7+8 
	.byt 7+7 
	.byt 7+10 
	; Kong 3 (4)
	.byt 13+8 
	.byt 13+8 
	.byt 13+7 
	.byt 13+10 
	; Kong falling (1)
	.byt 24
	; Long platforms (3)
	.byt 7
	.byt 13
	.byt 19
	; Long platforms falling down(3)
	.byt 5
	.byt 12
	.byt 16
	; Hooks that attach platforms (4)
	.byt 25
	.byt 26
	.byt 27
	.byt 28
	; All 22 mario sprites
	; First floor (5)
	.byt 6
	.byt 11
	.byt 16
	.byt 21
	.byt 26
	; Second floor (5)
	.byt 26
	.byt 21
	.byt 16
	.byt 11
	.byt 6
	; Lader (2)
	.byt 6
	.byt 6
	; Third floor (3)
	.byt 7
	.byt 15
	.byt 20
	; Mario jumping and falling (3)
	.byt 25
	.byt 26
	.byt 29
	; Mario gripped to hook
	.byt 28
	; Mario jumping First Floor (2)
	.byt 7
	.byt 21
	; Mario jumping Second Floor (2)
	.byt 21
	.byt 16
	; Crane stick (3 positions)
	.byt 32
	.byt 29
	.byt 33
	; Hooks (5 positions)
	.byt 30
	.byt 29
	.byt 29
	.byt 28
	.byt 27
	; Victory poses (2x2 positions)
	.byt 32
	.byt 31
	.byt 32
	.byt 32
	; Mario hands (2)
	.byt 7
	.byt 6
	; Crane control stick (2)
	.byt 6
	.byt 5
	; Hearts of victory (2)
	.byt 6
	.byt 6

; Table of screen position (Y coordinate)
_KongSpriteScreenY
	; All 26 barels
	; First floor (5)
	.byt 200
	.byt 198
	.byt 196
	.byt 192
	.byt 190
	; Second floor (6)
	.byt 155
	.byt 155
	.byt 155
	.byt 155
	.byt 155
	.byt 150
	; Third floor (6)
	.byt 109
	.byt 102
	.byt 102
	.byt 102
	.byt 102
	.byt 102
	; Left fall (3)
	.byt 87
	.byt 59
	.byt 42
	; Middle fall (3)
	.byt 87
	.byt 59
	.byt 42
	; Right fall (3)
	.byt 87
	.byt 59
	.byt 42
	; Moving girders (5)
	.byt 115
	.byt 115
	.byt 115
	.byt 115
	.byt 115
	; Kong 1 (4)
	.byt 2
	.byt 12
	.byt 19
	.byt 19
	; Kong 2 (4)
	.byt 2
	.byt 12
	.byt 19
	.byt 19
	; Kong 3 (4)
	.byt 2
	.byt 12
	.byt 19
	.byt 19
	; Kong falling (1)
	.byt 84
	; Long platforms (3)
	.byt 38
	.byt 38
	.byt 38
	; Long platforms falling down(3)
	.byt 44
	.byt 44
	.byt 44
	; Hooks that attach platforms (4)
	.byt 17
	.byt 17
	.byt 17
	.byt 17
	; All 22 mario sprites
	; First floor (5)
	.byt 181+8+5
	.byt 181+6+5
	.byt 181+4+4
	.byt 181+2+3
	.byt 178+1
	; Second floor (5)
	.byt 144
	.byt 144
	.byt 144
	.byt 144
	.byt 144
	; Lader (2)
	.byt 127
	.byt 90
	; Third floor (3)
	.byt 65
	.byt 66
	.byt 65
	; Mario jumping and falling (3)
	.byt 45
	.byt 68
	.byt 91
	; Mario gripped to hook
	.byt 56
	; Mario jumping First Floor (2)
	.byt 169
	.byt 169
	; Mario jumping Second Floor (2)
	.byt 126
	.byt 126
	; Crane stick (3 positions)
	.byt 74
	.byt 38
	.byt 2
	; Hooks (5 positions)
	.byt 45
	.byt 46
	.byt 46
	.byt 45
	.byt 44
	; Victory poses (2x2 positions)
	.byt 10
	.byt 20
	.byt 83
	.byt 90
	; Mario hands (2)
	.byt 78
	.byt 75
	; Crane control stick (2)
	.byt 82
	.byt 72
	; Hearts of victory (2)
	.byt 8
	.byt 2





; Table of width
_KongSpriteWidth
	; All 26 barels
	; First floor (5)
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	; Second floor (6)
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	; Third floor (6)
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	; Left fall (3)
	.byt 2
	.byt 2
	.byt 2
	; Middle fall (3)
	.byt 2
	.byt 2
	.byt 2
	; Right fall (3)
	.byt 2
	.byt 2
	.byt 2
	; Moving girders (5)
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	; Kong 1 (4)
	.byt 3
	.byt 3
	.byt 2
	.byt 2
	; Kong 2 (4)
	.byt 3
	.byt 3
	.byt 2
	.byt 2
	; Kong 3 (4)
	.byt 3
	.byt 3
	.byt 2
	.byt 2
	; Kong falling (1)
	.byt 4
	; Long platforms (3)
	.byt 6
	.byt 6
	.byt 6
	; Long platforms falling down(3)
	.byt 4
	.byt 3
	.byt 6
	; Hooks that attach platforms (4)
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	; All 22 mario sprites
	; First floor (5)
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	; Second floor (5)
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	; Lader (2)
	.byt 3
	.byt 3
	; Third floor (3)
	.byt 4
	.byt 4
	.byt 4
	; Mario jumping and falling (3)
	.byt 3
	.byt 3
	.byt 3
	; Mario gripped to hook
	.byt 3
	; Mario jumping First Floor (2)
	.byt 3
	.byt 3
	; Mario jumping Second Floor (2)
	.byt 3
	.byt 3
	; Crane stick (3 positions)
	.byt 5
	.byt 8
	.byt 4
	; Hooks (5 positions)
	.byt 2
	.byt 2
	.byt 1
	.byt 2
	.byt 2 
	; Victory poses (2x2 positions)
	.byt 2
	.byt 3
	.byt 2
	.byt 3
	; Mario hands (2)
	.byt 2
	.byt 2
	; Crane control stick (2)
	.byt 2
	.byt 2
	; Hearts of victory (2)
	.byt 1
	.byt 2


; Table of height
_KongSpriteHeight
	; All 26 barels
	; First floor (5)
	.byt 10
	.byt 10
	.byt 10
	.byt 10
	.byt 10
	; Second floor (6)
	.byt 10
	.byt 10
	.byt 10
	.byt 10
	.byt 10
	.byt 10
	; Third floor (6)
	.byt 10
	.byt 10
	.byt 10
	.byt 10
	.byt 10
	.byt 10
	; Left fall (3)
	.byt 10
	.byt 11
	.byt 9
	; Middle fall (3)
	.byt 11
	.byt 10
	.byt 9
	; Right fall (3)
	.byt 10
	.byt 11
	.byt 9
	; Moving girders (5)
	.byt 11
	.byt 11
	.byt 11
	.byt 11
	.byt 11
	; Kong 1 (4)
	.byt 13
	.byt 25
	.byt 11
	.byt 11
	; Kong 2 (4)
	.byt 13
	.byt 25
	.byt 11
	.byt 11
	; Kong 3 (4)
	.byt 13
	.byt 25
	.byt 11
	.byt 11
	; Kong falling (1)
	.byt 28
	; Long platforms (3)
	.byt 5
	.byt 5
	.byt 5
	; Long platforms falling down(3)
	.byt 30
	.byt 34
	.byt 12
	; Hooks that attach platforms (4)
	.byt 26
	.byt 26
	.byt 26
	.byt 26
	; All 22 mario sprites
	; First floor (5)
	.byt 19
	.byt 19
	.byt 19
	.byt 19
	.byt 22
	; Second floor (5)
	.byt 20
	.byt 20
	.byt 20
	.byt 20
	.byt 20
	; Lader (2)
	.byt 22
	.byt 22
	; Third floor (3)
	.byt 19
	.byt 18
	.byt 19
	; Mario jumping and falling (3)
	.byt 24
	.byt 20
	.byt 21
	; Mario gripped to hook
	.byt 20
	; Mario jumping First Floor (2)
	.byt 17
	.byt 17
	; Mario jumping Second Floor (2)
	.byt 18
	.byt 18
	; Crane stick (3 positions)
	.byt 8
	.byt 8
	.byt 8
	; Hooks (5 positions)
	.byt 4
	.byt 8
	.byt 12
	.byt 11
	.byt 8
	; Victory poses (2x2 positions)
	.byt 11
	.byt 20
	.byt 8
	.byt 20
	; Mario hands (2)
	.byt 8
	.byt 5
	; Crane control stick (2)
	.byt 4
	.byt 9
	; Hearts of victory (2)
	.byt 7
	.byt 8

