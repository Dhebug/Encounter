;ZeroPage.s

PlayerLives		.dsb 2
PlayerHealth		.dsb 2
PlayerA_Shield		.dsb 1
PlayerB_Shield		.dsb 1
screen			.dsb 2
source			.dsb 2
block			.dsb 2
wave			.dsb 2
TempX			.dsb 1
TempY			.dsb 1
RowCount			.dsb 1
bgbRowStart		.dsb 1
bgbPlotRow		.dsb 1
CurrentMapRow		.dsb 1
GraphicBlockRowOffset	.dsb 1
NextMapRowFlag		.dsb 1
TempSpriteID		.dsb 1
;ControllerA_Register
;B0 - Left
;B1 - Right
;B2 - Fire 1
;B3 - Up
;B4 - Down
;B5 - Fire 2
ControllerA_Register	.dsb 1
;ControllerB_Register
;B0 - Left
;B1 - Right
;B2 - Fire 1
;B3 - Up
;B4 - Down
;B5 - Fire 2
ControllerB_Register	.dsb 1
PlayerA_SpriteIndex		.dsb 1
PlayerB_SpriteIndex		.dsb 1
PressFireBlinkingFlag	.dsb 2
Temp01			.dsb 1
Temp02			.dsb 1
TestPlaneY		.dsb 1

UltimateSprite		.dsb 1	;128
ScriptTempX		.dsb 1
ScriptTempY		.dsb 1
kbdTempX			.dsb 1
kbdTempY			.dsb 1
Sprite_TempA		.dsb 1
EmbeddedObjective		.dsb 1
Temp_BGFlag		.dsb 1
WaveQuantity		.dsb 1
Temp_OnDelay		.dsb 1
Temp_ScriptID		.dsb 1
Sprite_TempY		.dsb 1
Sprite_TempX		.dsb 1
bitmaplo			.dsb 2
bitmaphi			.dsb 2
masklo			.dsb 2
maskhi			.dsb 2
TempCalc			.dsb 1
UniqueID_SequenceNumber	.dsb 1
cmap			.dsb 2
NibbleGnd
NibbleMask		.dsb 1
NibbleSky
NibbleValue		.dsb 1
BGBScrollDelay		.dsb 1

PlayerA_XMovement		.dsb 1
PlayerB_XMovement		.dsb 1
PlayerA_YMovement		.dsb 1
PlayerB_YMovement		.dsb 1
PlayerA_Status		.dsb 1
PlayerB_Status		.dsb 1
TemporaryCollisionByte	.dsb 1
LSBDigitIndex		.dsb 1
MSBDigitIndex		.dsb 1

zpscript			.dsb 2
SpawnGroupFlag		.dsb 1
SpawnTempX		.dsb 1
ssTemp01			.dsb 1
ssTemp02			.dsb 1

gfxTemp01			.dsb 1
CraftTempX		.dsb 1

UltimateProjectile		.dsb 1
ProjectileMask		.dsb 2
ProjectileBitmap		.dsb 2
ProjectileTempY		.dsb 1
rsflTempX			.dsb 1
FireFrequencyCounterA	.dsb 1
FireFrequencyCounterB	.dsb 1

;B0 Forward Cannon(1)	Shoots N (One or two parallel shots depending on strength)
;B1 Forward Cannon(2)
;B2 Splay
;B3 Sidewinders
;B4 Retro-fire
;B5 smart bomb
;B6 shield
;B7 ?
PlayerA_Weapons		.dsb 1
PlayerB_Weapons		.dsb 1
zpVector			.dsb 2
pbfpTempX			.dsb 1
pbfpTempY			.dsb 1
pbfpTempA			.dsb 1
bpTempX			.dsb 1
bpWeapons			.dsb 1
BluPrintXOffset               .dsb 1
bpShield                      .dsb 1
spTemp01			.dsb 1
spHitpoints		.dsb 1
WaitingOnKeyup		.dsb 1
MenuKeyColumn		.dsb 1
