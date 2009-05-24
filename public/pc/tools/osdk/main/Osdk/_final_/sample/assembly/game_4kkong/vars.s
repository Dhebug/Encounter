

;	.data

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


_VerticalColorPattern
	.byt 0			; Black INK
	.byt 16+6		; Cyan paper



_ScoreBoardValues_Up
	.byt 16			; Black paper
	.byt 16+1		; Red paper


IntroText1	.byt 1,10,"4KKong       ",255
IntroText2	.byt 3,12,"SPACE to play"

_ScoreBoardValues_Down
	.byt 10			; Double height standard
	.byt 16+4		; Blue paper
	.byt "LIVES:"
	.byt 8			; Normal height standard
	.byt "  "		; Life one
	.byt "  "		; Life two
	.byt "  "		; Life three
	.byt " "
	.byt 10			; Double height standard
	.byt 3			; Yellow ink
	.byt "SCORE:"
	.byt "    "
	.byt " "
	.byt 5			; Purple ink
	.byt "BEST:"
	.byt "    "
_ScoreBoardValues_DownEnd	


_FloorRastersDraw
	.byt 16+3
	.byt 16+1
	.byt 16+4

_FloorRastersErase
	.byt 16+6


_LaderPattern_Left
	.byt 64+%010000
	.byt 64+%010000
	.byt 64+%011111
	.byt 64+%010000

_LaderPattern_Right
	.byt 64+%000010
	.byt 64+%000010
	.byt 64+%111110
	.byt 64+%000010



_VerticalGirderPattern
_VerticalGirderPattern_Left
	.byt 64+%111000
	.byt 64+%111000
	.byt 64+%111001
	.byt 64+%111010
	.byt 64+%111101
	.byt 64+%101110
	.byt 64+%111101
	.byt 64+%111010
	.byt 64+%111001
	.byt 64+%111000

_VerticalGirderPattern_Right
	.byt 64+%111101
	.byt 64+%101111
	.byt 64+%010111
	.byt 64+%100111
	.byt 64+%000111
	.byt 64+%000111
	.byt 64+%000111
	.byt 64+%100111
	.byt 64+%010111
	.byt 64+%101111


_HorizontalGirderPattern
_HorizontalGirderPattern_Left
	.byt 64+%111111
	.byt 64+%111011
	.byt 64+%001110
	.byt 64+%010101
	.byt 64+%101010
	.byt 64+%010001
	.byt 64+%100000
	.byt 64+%000000
	.byt 64+%000000
	.byt 64+%111111
	.byt 64+%111111

_HorizontalGirderPattern_Right
	.byt 64+%111111
	.byt 64+%111111
	.byt 64+%000000
	.byt 64+%000000
	.byt 64+%100000
	.byt 64+%010001
	.byt 64+%101010
	.byt 64+%010101
	.byt 64+%001110
	.byt 64+%111011
	.byt 64+%111111


_CraneControlPattern
_CraneControlPattern_Left
	.byt 64+%111100
	.byt 64+%000011
	.byt 64+%111100
	.byt 64+%111111
	.byt 64+%111111
	.byt 64+%111111+128
	.byt 64+%100001+128
	.byt 64+%100001+128
	.byt 64+%100001+128
	.byt 64+%111111+128
	.byt 64+%111111
	.byt 64+%010101
	.byt 64+%111111


_CraneControlPattern_Right
	.byt 64+%000000
	.byt 64+%000000
	.byt 64+%110000
	.byt 64+%001000
	.byt 64+%110100
	.byt 64+%111010
	.byt 64+%111101
	.byt 64+%111101
	.byt 64+%111101
	.byt 64+%111101
	.byt 64+%111111
	.byt 64+%010101
	.byt 64+%111111

_HookPattern
_HookPattern_Left
	.byt 64+%000000
	.byt 64+%000000
	.byt 64+%000000
	.byt 64+%000000
	.byt 64+%000001
	.byt 64+%000001
	.byt 64+%000011
	.byt 64+%000111
	.byt 64+%000111
	.byt 64+%001110
	.byt 64+%001110
	.byt 64+%001110
	.byt 64+%001110
	.byt 64+%000111
	.byt 64+%000011
	.byt 64+%000001

_HookPattern_Right
	.byt 64+%111000
	.byt 64+%111000
	.byt 64+%111000
	.byt 64+%111000
	.byt 64+%111000
	.byt 64+%111000
	.byt 64+%110000
	.byt 64+%000000
	.byt 64+%000000
	.byt 64+%000000
	.byt 64+%000000
	.byt 64+%000001
	.byt 64+%000001
	.byt 64+%000111
	.byt 64+%111110
	.byt 64+%111100



_PrincessPattern_Left
	.byt 64+%000011
	.byt 64+%000111
	.byt 64+%001111
	.byt 64+%001100
	.byt 64+%011000
	.byt 64+%011010
	.byt 64+%011000
	.byt 64+%001101
	.byt 64+%001100
	.byt 64+%001010
	.byt 64+%000111
	.byt 64+%001111
	.byt 64+%011111
	.byt 64+%011111
	.byt 64+%011111
	.byt 64+%011111
	.byt 64+%010111
	.byt 64+%010111
	.byt 64+%010111
	.byt 64+%001011
	.byt 64+%001100
	.byt 64+%001111
	.byt 64+%011111
	.byt 64+%011111
	.byt 64+%011111
	.byt 64+%011111
	.byt 64+%001111
	.byt 64+%000110
	.byt 64+%000110
	.byt 64+%001110
	.byt 64+%011110

_PrincessPattern_Right
	.byt 64+%110000
	.byt 64+%111000
	.byt 64+%111100
	.byt 64+%101100
	.byt 64+%000110
	.byt 64+%010110
	.byt 64+%000110
	.byt 64+%101100
	.byt 64+%001100
	.byt 64+%010100
	.byt 64+%111000
	.byt 64+%111100
	.byt 64+%111110
	.byt 64+%111110
	.byt 64+%111110
	.byt 64+%111110
	.byt 64+%111010
	.byt 64+%111010
	.byt 64+%111010
	.byt 64+%110100
	.byt 64+%001100
	.byt 64+%111100
	.byt 64+%111110
	.byt 64+%111110
	.byt 64+%111110
	.byt 64+%111110
	.byt 64+%111100
	.byt 64+%011000
	.byt 64+%011000
	.byt 64+%011100
	.byt 64+%011110



; Number of blocs to draw ;) [0=end]
_ScreenLayoutData_Counters
	.byt 10
	.byt 1
	.byt 1
	.byt 2
	.byt 1
	.byt 1
	.byt 1
	.byt 3
	.byt 3
	.byt 3
	.byt 1
	.byt 0		; End marker
	
_ScreenLayoutData_PatternsAddrLow
	.byt <_HorizontalGirderPattern		; Horizontal girders
	.byt <_HookPattern					; Hook on the top of screen
	.byt <_CraneControlPattern			; Crane control box
	.byt <_VerticalGirderPattern		; Vertical left girder
	.byt <_VerticalColorPattern			; Vertical color change
	.byt <_ScoreBoardValues_Up
	.byt <_ScoreBoardValues_Down
	.byt <_FloorRastersDraw
	.byt <_FloorRastersErase
	.byt <_LaderPattern_Left
	.byt <_PrincessPattern_Left

_ScreenLayoutData_PatternsAddrHigh
	.byt >_HorizontalGirderPattern		; Horizontal girders
	.byt >_HookPattern					; Hook on the top of screen
	.byt >_CraneControlPattern			; Crane control box
	.byt >_VerticalGirderPattern		; Vertical left girder
	.byt >_VerticalColorPattern			; Vertical color change
	.byt >_ScoreBoardValues_Up
	.byt >_ScoreBoardValues_Down
	.byt >_FloorRastersDraw
	.byt >_FloorRastersErase
	.byt >_LaderPattern_Left
	.byt >_PrincessPattern_Left

_ScreenLayoutData_BlocWidth
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt 2
	.byt _ScoreBoardValues_DownEnd-_ScoreBoardValues_Down
	.byt 1
	.byt 1
	.byt 2
	.byt 2

_ScreenLayoutData_BlocHeight
	.byt 11
	.byt 16
	.byt 13
	.byt 10
	.byt 1
	.byt 1
	.byt 1
	.byt 3
	.byt 1
	.byt 4
	.byt 31






_ScreenLayoutData_ScreenAddrLow
	; First roof
	.byt <$a000+(40*168)+4
	.byt <$a000+(40*168)+10
	.byt <$a000+(40*168)+24
	.byt <$a000+(40*168)+29
	; Second roof
	.byt <$a000+(40*130)+9
	.byt <$a000+(40*130)+25
	.byt <$a000+(40*120)+31
	; Third kong roof
	.byt <$a000+(40*87)+12
	.byt <$a000+(40*87)+18
	; Donkey kong roof
	.byt <$a000+(40*38)+4
	; Hook on the top of screen
	.byt <$a000+26
	; Crane control box
	.byt <$a000+(40*78)+4
	; Left girder
	.byt <$a000+(40*0)+2
	; Right girder
	.byt <$a000+(40*0)+37
	; Rasters
	.byt <$a000+(40*0)+0
	; Score board up
	.byt <$bb80+(40*25)+0
	; Score board down
	.byt <$bb80+(40*26)+0
	; Rasters draw
	.byt <$a000+(40*84)+6
	.byt <$a000+(40*112)+6
	.byt <$a000+(40*165)+4
	; Rasters erase
	.byt <$a000+(40*84)+23
	.byt <$a000+(40*112)+31
	.byt <$a000+(40*165)+31
	; Left ladder
	.byt <$a000+(40*87)+6
	.byt <$a000+(40*129)+6
	.byt <$a000+(40*168)+26
	; Princess
	.byt <$a000+(40*6)+4

_ScreenLayoutData_ScreenAddrHigh
	; First roof
	.byt >$a000+(40*168)+4
	.byt >$a000+(40*168)+10
	.byt >$a000+(40*168)+24
	.byt >$a000+(40*168)+29
	; Second roof
	.byt >$a000+(40*130)+9
	.byt >$a000+(40*130)+25
	.byt >$a000+(40*120)+31
	; Third kong roof
	.byt >$a000+(40*87)+12
	.byt >$a000+(40*87)+18
	; Donkey kong roof
	.byt >$a000+(40*38)+4
	; Hook on the top of screen
	.byt >$a000+26
	; Crane control box
	.byt >$a000+40*78+4
	; Left girder
	.byt >$a000+40*0+2
	; Right girder
	.byt >$a000+40*0+37
	; Rasters
	.byt >$a000+40*0+0
	; Score board up
	.byt >$bb80+40*25+0
	; Score board down
	.byt >$bb80+40*26+0
	; Rasters draw
	.byt >$a000+(40*84)+6
	.byt >$a000+(40*112)+6
	.byt >$a000+(40*165)+4
	; Rasters erase
	.byt >$a000+(40*84)+23
	.byt >$a000+(40*112)+31
	.byt >$a000+(40*165)+31
	; Left ladder
	.byt >$a000+(40*87)+6
	.byt >$a000+(40*129)+6
	.byt >$a000+(40*168)+26
	; Princess
	.byt >$a000+(40*6)+4

_ScreenLayoutData_PaintWidth
	; First roof
	.byt 1
	.byt 5
	.byt 1								
	.byt 1								
	; Second roof
	.byt 3								
	.byt 6								
	.byt 3								
	; Third kong roof
	.byt 2								
	.byt 2								
	; Donkey kong roof
	.byt 1								
	; Hook on the top of screen
	.byt 1								
	; Crane control box
	.byt 1								
	; Left girder
	.byt 1
	; Right girder
	.byt 1
	; Rasters
	.byt 1
	; Score board up
	.byt 1
	; Score board down
	.byt 1
	; Rasters draw
	.byt 1
	.byt 1
	.byt 1
	; Rasters erase
	.byt 1
	.byt 1
	.byt 1
	; Left ladder
	.byt 1
	.byt 1
	.byt 1
	; Princess
	.byt 1

_ScreenLayoutData_PaintHeight
	; First roof
	.byt 1
	.byt 1
	.byt 1								
	.byt 1								
	; Second roof
	.byt 1								
	.byt 1								
	.byt 1								
	; Third kong roof
	.byt 1								
	.byt 1								
	; Donkey kong roof
	.byt 1								
	; Hook on the top of screen
	.byt 1								
	; Crane control box
	.byt 1								
	; Left girder
	.byt 20
	; Right girder
	.byt 20
	; Rasters
	.byt 200
	; Score board up
	.byt 1
	; Score board down
	.byt 2
	; Rasters draw
	.byt 1
	.byt 1
	.byt 1
	; Rasters erase
	.byt 3
	.byt 3
	.byt 3
	; Left ladder
	.byt 4
	.byt 4
	.byt 4
	; Princess
	.byt 1




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




;FixationCount			.byt 1	;4		; Number of fix that keep the platform attached
_GameCraneCurrentTick	.byt 1
best_score				.dsb 2
HexDigits				.byt "0123456789"
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
	.byt 172
	.byt 188
	.byt 180
	.byt 156
	.byt 132
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


LifeDisplayTable
	.byt 32,32,32,32
	.byt 32,32,32,32
	.byt 32,32,32,32
	.byt 91,92,93,94
	.byt 91,92,93,94
	.byt 91,92,93,94

	.bss

;
; Allign the content of BSS section to a byte boudary
;
	.dsb 256-(*&255)

_BssStart_

_SpriteDisplayState		.dsb 256		; 0=not displayed 1=displayed

_GameGirderTick			.byt 0			; Current movement counter
_GameGirderSpawnTick	.byt 0			; Current spawning counter

_KongFlagThrow			.byt 0			; Indicate if a throw movement is started
_GameCurrentTick		.byt 0

_BssEnd_
