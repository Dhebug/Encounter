

_SpriteMario_Life
	; 2x16
	.byt %000111
	.byt %000111
	.byt %011111
	.byt %000101
	.byt %011101
	.byt %001111
	.byt %000111
	.byt %000011

	.byt %011001
	.byt %111111
	.byt %000011
	.byt %000011
	.byt %011011
	.byt %011110
	.byt %001100
	.byt %000000

	.byt %110000
	.byt %110000
	.byt %111000
	.byt %111000
	.byt %111100
	.byt %111100
	.byt %111000
	.byt %110011

	.byt %111110
	.byt %110100
	.byt %110000
	.byt %111000
	.byt %011110
	.byt %000110
	.byt %000100
	.byt %000000


TableCollisionCount
	.byt 5	; first floor
	.byt 5	; second floor
	.byt 1	; barel comming from the right on third floor
	.byt 1	; barel from the top left
	.byt 1	; barel from the top mid
	.byt 1	; barel from the top right
TableCollisionSrc
	.byt __FirstBarel-__FirstSprite
	.byt __SecondFloorBarel-__FirstSprite
	.byt __BarelInsertionLeft-__FirstSprite
	.byt __BarelCollideFallLeft-__FirstSprite
	.byt __BarelCollideFallMiddle-__FirstSprite
	.byt __BarelCollideFallRight-__FirstSprite
TableCollisionDst
	.byt __FirstFloorMario-__FirstSprite
	.byt __SecondFloorMario-__FirstSprite
	.byt __MarioLaderCollide-__FirstSprite
	.byt __ThirdFloorMario-__FirstSprite
	.byt __ThirdFloorMario+1-__FirstSprite
	.byt __ThirdFloorMario+2-__FirstSprite




FixationCount			.byt 1	;4		; Number of fix that keep the platform attached
_GameCraneCurrentTick	.byt 1
best_score				.dsb 2
_GameCraneDelayTick		.byt 64
_GameGirderDelayTick	.byt 200		; Speed of movement
_GameDelayTick			.byt 255
				

;// Scan codes:
;// 172 = Left
;// 188 = Right
;// 180 = Down
;// 156 = Up
;// 132 = Space
KeyboardRouter_ScanCode		
	.byt KEY_LEFT
	.byt KEY_RIGHT
	.byt KEY_DOWN
	.byt KEY_UP
	.byt KEY_SPACE
	.byt 0

KeyboardRouter_AddrLow		
	.byt <HeroMoveLeft
	.byt <HeroMoveRight
	.byt <HeroMoveDown
	.byt <HeroMoveUp
	.byt <HeroMoveSpace

KeyboardRouter_AddrHigh		
	.byt >HeroMoveLeft
	.byt >HeroMoveRight
	.byt >HeroMoveDown
	.byt >HeroMoveUp
	.byt >HeroMoveSpace



SevenDigitPatterns
    ; 0
    .byt %110001
    .byt %101110
    .byt %111111
    .byt %101110
    .byt %110001
    ; 1
    .byt %111111
    .byt %111110
    .byt %111111
    .byt %111110
    .byt %111111
    ; 2
    .byt %110001
    .byt %111110
    .byt %110001
    .byt %101111
    .byt %110001
    ; 3
    .byt %110001
    .byt %111110
    .byt %110001
    .byt %111110
    .byt %110001
    ; 4
    .byt %111111
    .byt %101110
    .byt %110001
    .byt %111110
    .byt %111111
    ; 5
    .byt %110001
    .byt %101111
    .byt %110001
    .byt %111110
    .byt %110001
    ; 6
    .byt %110001
    .byt %101111
    .byt %110001
    .byt %101110
    .byt %110001
    ; 7
    .byt %110001
    .byt %111110
    .byt %111101
    .byt %111110
    .byt %111101
    ; 8
    .byt %110001
    .byt %101110
    .byt %110001
    .byt %101110
    .byt %110001
    ; 9
    .byt %110001
    .byt %101110
    .byt %110001
    .byt %111110
    .byt %110001


LifeDisplayTable
	.byt 32,32,32,32
	.byt 32,32,32,32
	.byt 32,32,32,32
	.byt 91,92,93,94
	.byt 91,92,93,94
	.byt 91,92,93,94

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
