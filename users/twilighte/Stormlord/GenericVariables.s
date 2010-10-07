;GenericVariables.s
LevelID			.byt 1
HeroLives			.byt 8
HeroScore
 .dsb 3,0
HeroLevelScore
 .dsb 3,0
HighScore
 .dsb 3,0
MenuOptionsY		.byt 0
CurrentDisplay		.byt 0
InactivityCountdown		.byt 0
TextCursor		.byt 0

ObjectSwapped		.byt 0
SwappedDirection		.byt 0

;MusicTempoRef		.byt 12
;CounterReference
; Normal game 200 == 10 second delay between update
; Bonus level 20  == <second delay
CounterReference		.byt 200
GameAction		.byt 0

MapX			.byt 14
MapGrubCount		.byt 0
HeroX			.byt 21
HeroY			.byt 30
HeroFrame			.byt 0
HeroCapturedFairies		.byt 0
HeroRequiredFairies 	.byt 3
HeroHolding		.byt 255
;BonusTears		.byt 0
;Temp variable used during swapping
ThisOneIsToHold		.byt 0
;sob_Index		.byt 0

;SpecialObjectSequence	.byt 255
csxy_Temp			.byt 0
npcc_TempX		.byt 0
pswm_Temp			.byt 0

;NPC Sprite variables
SpriteFrame		.byt 0
pswm_TempX		.byt 0
pswm_TempW		.byt 0
BeeOriginX		.byt 0
BeeOriginY                    .byt 0
BeesPresentHere		.byt 0
Honeypot_Found		.byt 0
ThisTrampolenesID		.byt 0


do_X			.byt 0
do_Y                      	.byt 0
do_BlockID                	.byt 0
do_CollisionID            	.byt 0
ReservedSOBIndex		.byt 0
