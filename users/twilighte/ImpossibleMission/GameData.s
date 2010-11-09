;Game data - Miraculously its exactly 256 atm


;Hero Position
GameDataStart

;These variables held sequentially in Zero page
Game_EthanX		.byt 0
Game_EthanY		.byt 0
Game_EthansCurrentLevel	.byt 0
Game_EthanFrame		.byt 0
Game_EthanFacingID		.byt 0
Game_LiftResets		.byt 0
Game_RobotSnoozes		.byt 0
Game_RoomPositionX		.byt 0
Game_RoomPositionY		.byt 0
UltimateMemoryListIndex	.byt 8
UltimateWorkListIndex	.byt 255
PuzzleMemory
 .dsb 28,0
WorkMemory
 .dsb 4,0

;Number of Simon steps achieved
svUltimateCount
 .byt 3

Score
 .byt 0	;MSB
 .byt 0
 .byt 0	;LSB

Stats_Vars
Stats_FurnitureCount	.byt 0
Stats_RoomCount		.byt 0
Stats_PuzzleCount             .byt 0
Stats_PunchcardCount          .byt 0
Stats_SimonSteps              .byt 0

GameScreenColouring	.byt 1
GameDifficulty	.byt 0	
AudioFlag		.byt 128
;We also use a block of 17 bytes where each bit holds the plundered state of all 133 furniture items
;in every room
GamePlunderedBits
 .dsb 17,0

Time_Seconds        .byt 0
Time_Minutes        .byt 0
Time_Hours          .byt 8
Time_OldMinutes	.byt 128
Time_OldHours	.byt 128
TimeExpired	.byt 0
EvenTimerRow	.byt 128+63
OddTimerRow	.byt 0
TenMinuteCounter	.byt 10

;Holds embedded position of lifts in all rooms
LiftPositionBuffer
 .dsb 97,0


;Holds map of rooms in IM
;B0-4 Room ID
;B6   Plundered Flag
;B7   No Room
MapOfRooms
;      Rm |  Rm |  Rm |  Rm |  Rm |  Rm |  Rm
 .byt $FF,0,$FF,0,$FF,0,$FF,0,$FF,0,$FF,0,$FF
 .byt $FF,0,$FF,0,$FF,0,$FF,0,$FF,0,$FF,0,$FF
 .byt $FF,0,$FF,0,$FF,0,$FF,0,$FF,0,$FF,0,$FF
 .byt $FF,0,$FF,0,$FF,0,$FF,0,$FF,0,$FF,0,$FF
 .byt $FF,0,$FF,0,$FF,0,$FF,0,$FF,0,$FF,0,$FF
 .byt $FF,0,$FF,0,$FF,0,$FF,0,$FF,0,$FF,0,$FF
 .byt $FF,0,$FF,0,$FF,0,$FF,0,$FF,0,$FF,0,$FF
 .byt $FF,0,$FF,0,$FF,0,$FF,0,$FF,0,$FF,0,$FF
 .byt 0
;Current accumulated Passwords
PasswordText
 .dsb 7,32
 .byt 0
Game_Checksum
 .byt 0
GameDataEnd
 .byt 0
