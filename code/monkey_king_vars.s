

_SpriteMario_Life
	; 2x16
	.byt %000111,%110000
	.byt %000111,%110000
	.byt %011111,%111000
	.byt %000101,%111000
	.byt %011101,%111100
	.byt %001111,%111100
	.byt %000111,%111000
	.byt %000011,%110011
	.byt %011001,%111110
	.byt %111111,%110100
	.byt %000011,%110000
	.byt %000011,%111000
	.byt %011011,%011110
	.byt %011110,%000110
	.byt %001100,%000100
	.byt %000000,%000000


TableCollisionCount
	.byt 5	; first floor
	.byt 5	; second floor
	.byt 1	; barrel coming from the right on third floor
	.byt 1	; barrel from the top left
	.byt 1	; barrel from the top mid
	.byt 1	; barrel from the top right
TableCollisionSrc
	.byt FirstBarrel-_FirstSprite
	.byt SecondFloorBarrel-_FirstSprite
	.byt BarrelInsertionLeft-_FirstSprite
	.byt BarrelCollideFallLeft-_FirstSprite
	.byt BarrelCollideFallMiddle-_FirstSprite
	.byt BarrelCollideFallRight-_FirstSprite
TableCollisionDst
	.byt FirstFloorMario-_FirstSprite
	.byt SecondFloorMario-_FirstSprite
	.byt MarioLaderCollide-_FirstSprite
	.byt ThirdFloorMario-_FirstSprite
	.byt ThirdFloorMario+1-_FirstSprite
	.byt ThirdFloorMario+2-_FirstSprite




FixationCount			.byt 1	;4		; Number of fix that keep the platform attached
_GameCraneCurrentTick	.byt 1
best_score				.dsb 2
_GameCraneDelayTick		.byt 64
_GameGirderDelayTick	.byt 200		; Speed of movement
_GameDelayTick			.byt 255
				



SevenDigitPatterns
    ; 0
    .byt %100011
    .byt %011101
    .byt %111111
    .byt %011101
    .byt %100011
    ; 1
    .byt %111111
    .byt %111101
    .byt %111111
    .byt %111101
    .byt %111111
    ; 2
    .byt %100011
    .byt %111101
    .byt %100011
    .byt %011111
    .byt %100011
    ; 3
    .byt %100011
    .byt %111101
    .byt %100011
    .byt %111101
    .byt %100011
    ; 4
    .byt %111111
    .byt %011101
    .byt %100011
    .byt %111101
    .byt %111111
    ; 5
    .byt %100011
    .byt %011111
    .byt %100011
    .byt %111101
    .byt %100011
    ; 6
    .byt %100011
    .byt %011111
    .byt %100011
    .byt %011101
    .byt %100011
    ; 7
    .byt %100011
    .byt %111101
    .byt %111011
    .byt %111101
    .byt %111011
    ; 8
    .byt %100011
    .byt %011101
    .byt %100011
    .byt %011101
    .byt %100011
    ; 9
    .byt %100011
    .byt %011101
    .byt %100011
    .byt %111101
    .byt %100011


EndData

	.bss

* = EndData

;
; Allign the content of BSS section to a byte boudary
;
	.dsb 256-(*&255)

_BssStart_

_gScanlineTableLow      .dsb 224
_gScanlineTableHigh     .dsb 224

_SpriteDisplayState		.dsb 256		; 0=not displayed 1=displayed

_GameGirderTick			.byt 0			; Current movement counter
_GameGirderSpawnTick	.byt 0			; Current spawning counter

_KongFlagThrow			.byt 0			; Indicate if a throw movement is started
_GameCurrentTick		.byt 0

_BssEnd_
	.dsb 256-(*&255)    ; This will be overwriten
_BssEndClear_
