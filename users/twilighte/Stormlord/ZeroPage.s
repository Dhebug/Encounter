;ZeroPage.s

graphic			.dsb 2
mask
map			.dsb 2
source
screen			.dsb 2
bgbuff			.dsb 2
ColumnCount		.dsb 1
RowCount            	.dsb 1
PlotMapX            	.dsb 1
OriginalMapX        	.dsb 1

TempRX			.dsb 1
TempLo			.dsb 1
TempHi			.dsb 1	;

;64==Fire
;32==Left
;16==Right
;08==Up
;04==Down?
;02==
;01==
KeyRegister		.dsb 1
SecondCounter		.dsb 1

;Update SunMoon zp vars
usm_SunMoonYPos		.dsb 1
usm_RowIndex		.dsb 1
usm_screen		.dsb 2
usm_graphic		.dsb 2

;Speed Control
ProgrammableCountdown	.dsb 1

dm_CursorX		.dsb 1
dm_CursorY                    .dsb 1
dm_MapIndex                   .dsb 1
MomentaryBlock                .dsb 1

cmap			.dsb 2
text			.dsb 2
char                          .dsb 2
ScreenX			.dsb 1
ScreenY			.dsb 1

;Collision Variables
ColX			.dsb 1
ColY                          .dsb 1
ColW                          .dsb 1
ColH                          .dsb 1
ColC                          .dsb 1

;Starfield
StarfieldDistance		.dsb 1
sfTemp01			.dsb 1

;Random Number source Variables
rndRandom			.dsb 2
rndTemp			.dsb 1

;Explode/Destroy
TempCount			.dsb 1

FloodWidth		.dsb 1
TankWidth			.dsb 1

;For filepack
ptr_source		.dsb 2
ptr_destination               .dsb 2
ptr_destination_end           .dsb 2
ptr_source_back               .dsb 2
offset			.dsb 2
mask_value		.dsb 1
nb_dst			.dsb 2

reg0			.dsb 1
reg2                          .dsb 1
tmp4                          .dsb 2

;For sfx
sfx			.dsb 2
sfxTemp1			.dsb 1
sfxTemp2                      .dsb 1
sfx_CurrentChannel		.dsb 1

;For Music
pattern			.dsb 2	;00-01 Current Pattern Row Address
effect
ornament			.dsb 2	;02-03 Current Ornament/Effect base Address
header			.dsb 2    ;04-05 Music Header Location
pat			.dsb 2    ;06-07 Pattern Address Table
eat			.dsb 2    ;08-09 Effect Address Table
oat			.dsb 2    ;0A-0B Ornament Address Table
TempVolume		.dsb 1

GameFlag			.dsb 1
screen2			.dsb 2

;NPC Collision map routines
CollisionWidth		.dsb 1
CollisionHeightCount	.dsb 1

TimeAlt			.dsb 1
