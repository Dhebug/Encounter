;ZeroPage.s
;The following locations must be reserved for ROM tape ops
;0C
;0D
;2F
;33
;34

screen			.dsb 2	;00-01
source			.dsb 2    ;02-03
mask			.dsb 2    ;04-05
bitmap			.dsb 2    ;06-07
dscript			.dsb 2    ;08-09
room			.dsb 2    ;0A-0B
Tape_Display		.dsb 2	; 0C-0D
Old_room			.dsb 2    ;0E-0F
bgbuff			.dsb 2    ;10-11
map			.dsb 2    ;12-13

SecondsDelay		.dsb 1    ;14
WhiteOutBitmap		.dsb 1    ;15

EthanX			.dsb 1    ;16
EthanY			.dsb 1    ;17
EthansCurrentLevel		.dsb 1    ;18
EthanFrame		.dsb 1    ;19
EthanFacingID		.dsb 1    ;1A
LiftResets		.dsb 1    ;1B
RobotSnoozes		.dsb 1    ;1C
RoomPositionX		.dsb 1    ;1D
RoomPositionY		.dsb 1    ;1E

EthansStartX		.dsb 1    ;1F
EthansStartY		.dsb 1    ;20
EthanStartFacingID		.dsb 1    ;21
EthanStartLevel		.dsb 1    ;22

FreezeJumpXSteps		.dsb 1    ;23
;0 Standing
;1 Running
;2 Jumping
;3 Searching
;4 Falling
;5 Dieing(Hit by Robot)
EthanCurrentAction		.dsb 1	;24
;0 Room
;1 Lift shaft and Corridor
;2 Simon Computer
;3 Terminal
;4 Pocket computer
;5 Phone menu
EthansLocation		.dsb 1	;25
copy			.dsb 2	;26-27

Check_X			.dsb 1	;28
Check_Y			.dsb 1	;29

InputRegister		.dsb 1	;2A
                    	
DroidDelay		.dsb 1	;2B
EthanDelay		.dsb 1    ;2C
TimedDelay		.dsb 1    ;2D
ModemMenuOption		.dsb 1    ;2E
Tape_TransferBit		.dsb 1	; 2F
RoomID			.dsb 1    ;30
Old_RoomID		.dsb 1    ;31
tempY			.dsb 1    ;32
Tape_TransferVector		.dsb 2	; 33-34
TempWidth			.dsb 1    ;
TempHeight		.dsb 1    ;
TempXpos			.dsb 1    ;
TempYpos			.dsb 1    ;
                    	
ScriptTempX		.dsb 1
                    	
Object_X			.dsb 1	;XPos
Object_Y            	.dsb 1	;YPos
Object_W            	.dsb 1	;Width
Object_H            	.dsb 1	;Height
Object_V            	.dsb 1	;Object ID
Object_B			.dsb 1	;
Object_D			.dsb 1	;Direction ID
Object_R			.dsb 1	;Number of Repeats
Object_Z			.dsb 1	;
Object_TempX        	.dsb 1
Object_TempY        	.dsb 1
                    	
TempLevelsBelow		.dsb 1
                    	
LiftStatus		.dsb 1
CurrentLift		.dsb 1
Lifts_TotalStepsCount	.dsb 1
pl_tempx			.dsb 1
                    	
TempGroup			.dsb 1
TempPlatforms		.dsb 1
LevelCounter		.dsb 1

;Used for Ethan and PlotRoom when deciding on Lift Platform bounds
Temp01			.dsb 1
Temp02			.dsb 1
LastFurnitureID
Temp03			.dsb 1
Count			.dsb 1

                    	
sfxTemp1           		.dsb 1
sfxTemp2           		.dsb 1
sfx			.dsb 2
sfx_CurrentChannel		.dsb 3

;IRQPreservedA		.dsb 1
IRQPreservedX		.dsb 1
IRQPreservedY		.dsb 1
TimeTemp01		.dsb 1
                    	
TempYDuringCBGB		.dsb 1
EyeOpenedYet		.dsb 1

SearchStep		.dsb 1
SearchingStatus		.dsb 1
CollisionFurnitureSequenceID	.dsb 1
CurrentFurnitureRoomIndex	.dsb 1

rndRandom			.dsb 2
rndTemp			.dsb 1

DisplayingSearchResult	.dsb 1
DisplayingSearchResultX	.dsb 1
DisplayingSearchResultY	.dsb 1
DitherPattern		.dsb 1


line			.dsb 2

TopCloseY			.dsb 1
BottomCloseY		.dsb 1
RowCount
RowCounter		.dsb 1
chars			.dsb 2

glow			.dsb 2
GlowState			.dsb 1
GlowColourIndex		.dsb 1

dt_InverseFlag                .dsb 1
dt_LineIndex                  .dsb 1
dt_Temp01                     .dsb 1

;Pocket Computer
CursorX			.dsb 1
CurrentPunchcardColour	.dsb 1
CurrentPunchcardOrientation	.dsb 1
TempGroupID		.dsb 1

MapIndex			.dsb 1
TempRoomID		.dsb 1
NewRoomOffset		.dsb 1
StripIndex		.dsb 1
LeftRightExitOnlyFlag	.dsb 1


boTemp01			.dsb 1
GroupCount		.dsb 1
stOption			.dsb 1
ConfirmationOption		.dsb 1

cbaTemp01			.dsb 1
cbaTemp02			.dsb 1
cbaTemp03			.dsb 1

RoomTextTemp01		.dsb 1
FoundOnceFlag		.dsb 1
keMinuteCounter		.dsb 1
TensDigit			.dsb 1
Kept_Hours		.dsb 1

TempRoomFurnitureList	.dsb 12
FurnitureID_Counter           .dsb 1
TempFurnitureTableIndex       .dsb 1
TempFurnitureWithPuzzle	.dsb 1
colour			.dsb 2

TempRX			.dsb 1
TempLo			.dsb 1
TempHi			.dsb 1
TempRoomIndex		.dsb 1
TempRoomFurnitureIndex	.dsb 1
FurnitureSequenceID		.dsb 1
lsmTempX1			.dsb 1
lsmTempX2			.dsb 1
CycleCount		.dsb 1
svNoteTable		.dsb 32
IgnoreNewXFlag		.dsb 1
GameCompleteFlag		.dsb 1
FrameIndex		.dsb 1
ModemsEventualMessage	.dsb 1
CurrentMenuScreen		.dsb 1
MenuType			.dsb 1
GameStartsStackPointer	.dsb 1
MenuBGType		.dsb 1
svNoteSequenceIndex		.dsb 1
svCursorX			.dsb 1
svCursorY			.dsb 1
svTemp01			.dsb 1
erl_ExtractFlag		.dsb 1
GameLiftPositionsTableIndex	.dsb 1
PlunderedIndex		.dsb 1
PlunderedBitCount		.dsb 1
DitherStepSize		.dsb 1
ResetLiftOnReturn		.dsb 1
UltimateLiftPlatform	.dsb 1
svTempNote		.dsb 1
Update_Hours		.dsb 1
Update_Minutes		.dsb 1

