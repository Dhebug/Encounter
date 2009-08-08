;zeropage.s
;
HeroSprite	.dsb 1	;00
HeroX		.dsb 1	;01
HeroY		.dsb 1	;02
PreservedA	.dsb 1
PreservedX	.dsb 1
PreservedY	.dsb 1
PreviousHeroSprite	.dsb 1
PreviousHeroWidth       .dsb 1
PreviousHeroHeight      .dsb 1
dfcMinimumY	.dsb 1
source		.dsb 2	;03
header		.dsb 2	;05
bgmask
buffer
chaddr
bgbuff		.dsb 2	;07
screen		.dsb 2	;09
source2
screen2
oddscn		.dsb 2
evnscn		.dsb 2
bitmap		.dsb 2
SpriteWidth 	.dsb 1	;0B
SpriteHeight	.dsb 1	;0C
FrameXByte	.dsb 1
;
KeyRegister	.dsb 1	;0D
;
HeroIndex	.dsb 1	;
HeroAction	.dsb 1
HeroStopped	.dsb 1

ptcTemp01	.dsb 1	;Text Handler
ptcTempX	.dsb 1
ptcTempY	.dsb 1
;
taTempX
temp01		.dsb 1
taTempY
temp02		.dsb 1
tempy		.dsb 1
TextIndex		.dsb 1
ScreenIndex	.dsb 1
;
OccurrenceFlag	.dsb 1
;
rndRandom	.dsb 2
rndTemp		.dsb 2
;Collision Map
cmTemp01	.dsb 1
cmTemp02	.dsb 1
cmTemp03	.dsb 1
ContourFloor	.dsb 2
ContourCeiling	.dsb 2
ContourCollision	.dsb 2
;
HeroAnimDelayFrac	.dsb 1
HeroAnimDelayReference	.dsb 1
;
text
TestInverse		.dsb 2

;SideApproachFlag - Hero Appears on Left(0) or Right(1)
SideApproachFlag	.dsb 1
GameStackPointer	.dsb 1


;Items
iiFrame		.dsb 1
;Unpack
unpMaskValue	.dsb 1
unpSource	.dsb 2
unpSourceBack	.dsb 2
unpDestination	.dsb 2
unpNBDst	.dsb 1
unpOffset	.dsb 2
;
;Whilst SubgameProperty in playerfile provides bitwise flags related to the game
;This variable is used for subgame progression.
;Currently used in Temple search where (1) indicates horn found, temple moving off
;and (2) indicates subgame complete
SubGameResult	.dsb 1
SubGameStartLocation	.dsb 1
;If we put above we would need to recompile all ssc modules again
temp03		.dsb 1
