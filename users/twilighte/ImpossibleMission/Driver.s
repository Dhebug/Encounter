;Driver.s

#include "CommonDefines.s"

 .zero
*=$00
#include "ZeroPage.s"

 .text
*=$400

Driver	jmp Driver2
;We jump here so we could put page alligned stuff here
EthanBMPFrameBuffer
 .dsb 45,0	;Set to tallest and widest (tho always 3) bitmap so 3x15
EthanMSKFrameBuffer
 .dsb 69,0	;Set to tallest and widest (tho always 3) bitmap so 3x23

Driver2	sei
	ldx #34
.(
loop1	lda PatchMemory,x
	sta $BB80,x
	dex
	bpl loop1
.)
	;Setup IRQ
	jsr SetupIRQ
	cli
	jsr TurnOffGlow
	
	;Record Stack pointer at this point
	tsx
	stx GameStartsStackPointer
TitleReEntry
	jsr GameMenu
	
	;>>Game Start
	ldx #39
	lda #0
.(
loop1	sta $a000+40*150,x
	dex
	bpl loop1
.)	
	;Init New Game
	tax
	stx CursorX
	stx GamePaused
	stx TimeExpired
	dex
	stx UltimateMemoryListIndex
	
	;Reset all lifts and restore all furniture in all rooms
	ldx #31
	stx RoomID
.(
loop1	jsr RestoreLiftPositions
	dec RoomID
	bpl loop1
.)	
	;Time depends on difficulty
	jsr SetTime2Difficulty
	
	jsr DisplayPassword
	jsr RandomiseGame
	
	;Set Ethan to top left Lift shaft and flag position in map as plundered
	lda MapOfRooms+1
	ora #64
	sta MapOfRooms+1
	ldx #1
	stx RoomPositionX
	stx EthanFacingID
	stx EthansLocation
	dex
	;x=0
	stx GlowState
	stx RoomPositionY
	lda #$E0
	sta glow
	lda #$BF
	sta glow+1
	
	;Set other variables
	;x=0
	stx LiftResets
	stx RobotSnoozes
	stx DroidDelay
	stx DisplayingSearchResult
	stx LiftStatus
	stx SearchingStatus
	stx EthanFrame
	stx EthanCurrentAction
	stx PuzzleMemoryBase
	txa
	ldy #7
.(
loop1	txa
	sta Score,y	;Also resets stats
	lda #32
	sta PasswordText-1,y
	dey
	bpl loop1
.)
	
	jsr Display_Score
	jsr Display_LiftResets
	jsr Display_RobotSnoozes
	jsr DisplayPassword

	;Set Ethan facing right within lift
	lda #19
	sta EthanX
	lda #4
	sta EthansCurrentLevel
EntryAfterLoadOldGame
	jsr TieEthan2Platform
	;Setup everything to start in Shaft
	jsr lsm_DisplayScoresComplexMap
	jsr DisplayRoomCursor
	jsr lsm_RenderFullScreenBG
	jsr EyeOpenRoom
	jsr lsm_GenerateCollisionMap

MainPlay	;Branch on Ethans location
	lda EthansLocation
	beq Play_Room
	cmp #1
	bne Play_Phone
	jmp Play_Shaft
	
PatchMemory
 .byt $06,$C1,$6F,$7A,$E1,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$E1,$DE,$40,$66,$66,$4C,$E1,$40,$66,$66,$E1,$C0,$C1,$E1,$7F
;LocationCodeVectorLo
; .byt <Play_Room
; .byt <Play_Shaft
; .byt <Play_Simon
; .byt <Play_Terminal
; .byt <Play_Pocket
; .byt <Play_Phone
;LocationCodeVectorHi
; .byt >Play_Room
; .byt >Play_Shaft
; .byt >Play_Simon
; .byt >Play_Terminal
; .byt >Play_Pocket
; .byt >Play_Phone

GamePaused	.byt 0

GameOver 	jsr FadeDitherGameScreen
	jsr SilenceSFX
	ldx GameStartsStackPointer
	tsx
	jmp TitleReEntry

WaitOnKey_NoRepeat
	jsr FlushInputBuffer
.(
loop2	lda TimeExpired
	bne GameOver
skip6	lda InputRegister
	beq loop2
.)
	rts

Play_Shaft
	;Main Lift shaft loop
.(
loop1	lda EthanDelay
	bne skip2
	lda #3
	sta EthanDelay
	jsr ControlEthan
	lda TimeExpired
	bne GameOver
skip2	jmp loop1
.)

;Play_Simon
;Play_Terminal
;Play_Pocket
Play_Phone
;	lda #17
;	sta $BFDE
Play_Room
	lda #00
;	jmp Play_Room
	sta DroidsSnoozing
	sta GameCompleteFlag
.(
Loop1	;Check for time expired
	lda TimeExpired
	bne GameOver

	;Check for hourly message
	lda EthansLocation
	cmp #IN_CORRIDOR
	beq skip5
	lda Time_Hours
	cmp Kept_Hours
	beq skip5
	sta Kept_Hours
	jsr DisplayHourlyMessage

skip5	;Display Search result
	lda DisplayingSearchResult
	beq skip4
	;Whilst controller up is held the message continues to be displayed
	lda InputRegister
	and #CONTROLLER_UP
	bne skip2
;	lda #00
	sta DisplayingSearchResult
	jsr DisplayingSearchResultEnd
	jmp skip2
skip4	;Slow Ethan
	lda EthanDelay
	bne skip2
	lda #3
	sta EthanDelay
	lda LiftStatus
	bne PreProcessRoomLift
	lda SearchingStatus
	bne PreProcessSearching
	jsr ControlEthan
	lda GameCompleteFlag
	bne GameComplete
skip2	;Slow Droids
	lda DroidDelay
	bne skip1
	inc DroidDelay
	jsr DroidEngine
skip1	lda DroidsSnoozing
	bne Loop1
	jsr DetectEthanDroidCollision
	jmp Loop1

PreProcessRoomLift
	jsr ProcessRoomLift
	jmp skip2

PreProcessSearching
	lda InputRegister
	cmp #CONTROLLER_UP
	bne skip3
	jsr ProcessSearching
	jmp skip2
skip3
	lda #SEARCH_OFF
	sta SearchingStatus
	
	;Delete Search Window
	jsr CalculateSearchWindowPosition
	lda #SEARCHWINDOWGFX
	sta Object_V
	
	jsr RestoreObjectsBackground
	;Problem - If search window was over lift, background will not contain lift gfx therefore corruption!
	;so replot all lifts
	jsr RedisplayLifts
	
	lda #ACTION_STANDING
	sta EthanCurrentAction
	
	jsr DeleteEthan
	lda #ETHAN_STANDING
	sta EthanFrame
	
	;Tie ethan to the current level
	jsr TieEthan2Platform

	jsr PlotEthan
	jmp skip2
.)
GameComplete
	;Display door opening frames
	lda #172
	sta FrameIndex
.(	
loop2	lda FrameIndex
	cmp #175
	bcs skip1
	sta Object_V
	lda #10
	sta Object_X
	lda #114
	sta Object_Y
	jsr DisplayGraphicObject
	
skip1	;At same time display NO..
	ldy FrameIndex
	ldx RoomText4FrameIndex-172,y
	jsr DisplayRoomText
	
	lda #60
	jsr SlowDown
	
	inc FrameIndex
	lda FrameIndex
	cmp #177
	bcc loop2
.)
	jmp GameOver
RoomText4FrameIndex
 .byt 2,2,2,4,25	
	
DisplayHourlyMessage
	;Work on Hours+1
	lda Time_Hours
	cmp #8
.(
	bcs skip1
;	clc
	adc #13
	tax
	jsr DisplayRoomText
skip1	rts	 
.)
SetTime2Difficulty
	ldx GameDifficulty
	lda Hours4Difficulty,x
	sta Time_Hours
	sta Kept_Hours
	lda #00
	sta Time_Seconds
	sta Time_Minutes
	rts
	
SetupIRQ	;We only require IRQ for SFX(50Hz) (Relay on Oric booted settings)
	lda #<20000
	sta VIA_T1LL
	lda #>20000
	sta VIA_T1LH
	;Redirect IRQ but read 6502 irq vector so it'll work on Oric-1 too
	;However we know it'll be page 2
	ldx $FFFE
	ldy #2
.(
loop1	lda OpcodeData,y
	sta $0200,x
	inx
	dey
	bpl loop1
.)
;	
;	
;	lda #<IM_IRQ
;	sta SYS_IRQVECTORLO
;	lda #>IM_IRQ
;	sta SYS_IRQVECTORHI
	rts

	

ControlSpeedOfGame
	lda EthanDelay
.(
	beq skip1
	dec EthanDelay
skip1	lda DroidDelay
	beq skip2
	dec DroidDelay
skip2	;Process timer events that require seconds intervals
	dec SecondsDelay
	bne skip4
	lda #50
	sta SecondsDelay
	
	;Process events that take place every Second
	lda TimedDelay
	beq skip3
	dec TimedDelay
skip3	lda GamePaused
	bne skip4
	jsr UpdateTime
skip4	rts
.)

AnimateRoomCursor
	;GlowState
	;B7   Inverse state of current screen location
	;B0-6
	;   0 Don't Glow
	;
	lda GlowState
.(
	and #127
	beq skip1
	lda GlowColourIndex
	clc
	adc #1
	and #15
	sta GlowColourIndex
	tax
	lda GlowState
	and #128
	ora GlowColours,x
	ldy #00
	sta (glow),y
skip1	rts
.)	

TurnOffGlow
	sei
	lda GlowState
	and #128
	sta GlowState
	cli
	rts

GlowColours
 .byt 0,4,1,5,2,6,3,7,3,7,3,6,2,5,1,4	

IM_IRQ
	php
	pha
	stx IRQPreservedX
	sty IRQPreservedY
	cld
	
	lda VIA_T1CL
	
	jsr sfx_ScriptEngine
	jsr ReadController

	jsr ControlSpeedOfGame
	jsr AnimateRoomCursor
	
	pla
	ldx IRQPreservedX
	ldy IRQPreservedY
	plp
	rti



	
;#include "RestoreTapeLoad.s"	;Required to restore BASICs Ready prompt in HIRES after CLOADing
#include "RandomiseGame.s"
#include "PlotRoom.s"	;Generate Room from Room Map
#include "CommonRoutines.s"
#include "DroidEngine.s"
#include "DroidGraphics.s"
#include "DroidScripts.s"
#include "Ethans.s"
#include "EthanFrames.s"
#include "Rooms.s"		;Room Maps + Terminal Map
#include "Objects.s"
#include "sfx.s"		;SFX Script Play Engine
#include "SFX_Scripts.s"	;SFX Scripts(data)
#include "DetectEthanDroidCollision.s"
#include "GameMenu.s"
#include "TextHandler.s"
#include "PocketComputer.s"
#include "Lifts.s"
#include "ProcessSearching.s"
#include "LiftShaftRoutines.s"
#include "SimpleSimon.s"
#include "EyeOpener.s"
#include "Time.s"
#include "ControlTerminalMenu.s"
#include "KillEthan.s"
;#include "JoystickDrivers.s"
#include "RoomTextHandler.s"
#include "PlotPocketButton.s"
#include "DitherFade.s"
#include "TapeRoutines.s"
#include "GameData.s"
;#include "TestRoutines.s"

;#include "TestRoutines.s"
himem
 .dsb $A000-*
#include "im_title.s"
#include "Scorepanel.s"
;The area immediately below the scorepanel is a hidden 40 bytes of useful Storage
BasePitchLo
 .byt <477
 .byt <425
 .byt <379
 .byt <357
 .byt <318
 .byt <284
 .byt <253
 .byt <477
BasePitchHi
 .byt >477
 .byt >425
 .byt >379
 .byt >357
 .byt >318
 .byt >284
 .byt >253
 .byt >477
DialPitchB
 .byt 46	;0
 .byt 46	;0
 .byt 46	;0
 .byt 46	;5
 .byt 42	;3
 .byt 42	;9
 .byt 42	;6
 .byt 42	;3
 .byt 51	;1
 .byt 51	;7
Hours4Difficulty
 .byt 6
 .byt 4
 .byt 2
PausedMessage	;11
 .byt "GAME PAUSED"
;This next part is the 3 lines of text. We can still put this memory(119 bytes!) to good use by setting the
;first byte of each line to 0(black ink) then using the rest for non-inversed text only tables.
 .byt 0
SecurityTerminalResponseFrameText	;24
 .byt "(((((((((((((((((((((((",0
SecurityTerminalCursorText
 .byt "="
ModemMenuCursorText
 .byt "=>",0
SecurityTerminalCursorDelText
 .byt " "
ModemMenuCursorDelText
 .byt "  ",0
PasswordLetter
 .byt "PHOENIX"
 
 .byt 0
SecurityTerminalAcceptanceText	;24
 .byt "(( PASSWORD ACCEPTED ((",0
RoomText_KillHimRobots
 .byt "DEATH IS NEAR!!"

 .byt 0
SecurityTerminalDeniedText		;24
 .byt "(( PASSWORD REQUIRED ((",0
DialPitchA	;The actual number is the FBI Houston Office
 .byt 66	;0
 .byt 66	;0
 .byt 66	;0
 .byt 80	;5
 .byt 89	;3
 .byt 73	;9
 .byt 80	;6
 .byt 89	;3
 .byt 89	;1
 .byt 73	;7
;BFDB
 .dsb 4,0	;Spare
HIRESSwitch	;BFDF
 .byt 28
