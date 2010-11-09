;Ethans.s (3x25 x 32)
ReadController
	;Allow run left and right for now
	;## Joy	Key
	;B0 Left	Crsr Left
	;B1 Right	Crsr Right
	;B2 -
	;B3 Down	Crsr Down
	;B4 Up	Crsr Up
	;B5 Fire	Left Ctrl
	;Read Keyboard
	lda #$0E
	sta VIA_PORTA
	lda #$FF
	sta VIA_PCR
	lda #$FD
	sta VIA_PCR
	lda #00
	sta InputRegister

	ldx #11
.(
loop1	lda KeyColumn,x
	sta VIA_PORTA
	lda #$FD
	sta VIA_PCR
	lda #$DD
	sta VIA_PCR
	lda KeyRow,x
	sta VIA_PORTB
	nop
	nop
	nop
	nop
	lda VIA_PORTB
	and #8
	beq skip1
	lda KeyBit,x
	ora InputRegister
	sta InputRegister
skip1	dex
	bpl loop1
.)
	rts

ControlEthan
	;If Ethan is Falling(4) then ignore keys
	lda EthanCurrentAction
	cmp #ACTION_FALLING
	beq FallEthan
	;If Ethan is Jumping(2) then ignore keys
	cmp #ACTION_JUMPING
.(
	bne skip1
	jmp JumpEthan
skip1	lda InputRegister
.)
	and #CONTROLLER_FIRE1
.(
	beq skip1
	jmp ProcessEthanJump
skip1	lda InputRegister
	and #CONTROLLER_LEFT
	beq skip2
	jmp RunEthanLeft
skip2	lda InputRegister
	and #CONTROLLER_RIGHT
	beq skip5
;twi99	nop
;	jmp twi99
	jmp RunEthanRight
skip5	lda InputRegister
	and #CONTROLLER_UP
	beq skip3
	jmp ProcessEthanUp
skip3	lda InputRegister
	and #CONTROLLER_DOWN
	beq skip4
	jmp ProcessEthanDown
skip4	lda EthanFrame
.)
.(
	;Don't do anything if Ethan already standing
	cmp #ETHAN_STANDING
	beq skip1
	;Otherwise Change to Standing (depending on current direction)
	jsr DeleteEthan
	lda #ETHAN_STANDING
	sta EthanFrame
	;Tie ethan to the current level
	jsr TieEthan2Platform
	;Check If there is a platform beneath Ethans feet
	jsr GroundCheck
	bcc SetEthan2Fall
skip1	jmp PlotEthan

SetEthan2Fall
	lda #ACTION_FALLING
	sta EthanCurrentAction
	jmp skip1
.)
FallEthan
	jsr DeleteEthan
	lda EthansCurrentLevel
	cmp #7
	bcs FellThroughChasm
	inc EthansCurrentLevel
	jsr GroundCheck
	bcs ReachedGround
	lda #ETHAN_STANDING
	sta EthanFrame
	jsr TieEthan2Platform
	jmp PlotEthan
FellThroughChasm
	jmp DeathByHeight
ReachedGround
	lda #ACTION_STANDING
	sta EthanCurrentAction
	jsr RedisplayLifts
	jsr TieEthan2Platform
	jmp PlotEthan

JumpEthan
	jsr DeleteEthan
	
	;Update Frame
	inc EthanFrame
	ldx EthanFrame
	
	;Adjust Y
	ldy EthansCurrentLevel
	lda PlatformYPOS,y
	sec
	sbc EthanFrameYOffset,x
	sta Check_Y

	lda FreezeJumpXSteps
.(
	beq skip1
	lda EthanX
	sta Check_X
	jmp JumpingRent
	
skip1	;Adjust X
.)
	lda EthanX
	ldy EthanFacingID
.(
	beq FacingLeft
	clc
	adc EthanFrameXStep,x
	jmp skip1
FacingLeft
	sec
	sbc EthanFrameXStep,x
skip1	sta Check_X	;A== Check_X
.)

	;Fetch location of Ethan in Collision map
JumpingRent
	ldy Check_Y
	;Ensure Ethan remains below Full height ceiling in search (Foot problem)
	iny
	iny
	jsr FetchCollisionMapLocation
	
	;Scan for 
	;1)COL_WALL	   - Ignore New X
	;2)COL_ENTRANCE        - Exit screen
	;3)COL_PLATFORM        - If frame +8 or more then rise onto it
	;		     Otherwise Ignore New X
	;4)COL_LIFTPLATFORM0-7 - If frame +8 or more then rise onto it
	;		     Otherwise Ignore New X
	
	;For jump frames ETHAN_JUMP+0 to +2 scan 3x3
	;For jump frames ETHAN_JUMP+3 to +6 scan 3x2
	;For jump frames ETHAN_JUMP+7 to +9 scan 3x3
	;For jump frames ETHAN_JUMP+10 to +11 scan 3x4
	lda JumpFrameCollisionHeight-16,x
	tax
	ldy #00
	sty IgnoreNewXFlag
.(	
loop2	ldy #2

loop1	lda (screen),y
	and #31
	beq skip1
	cmp #COL_WALL
	bne skip4
	;Set flag to ignore X after this loop
	inc IgnoreNewXFlag
	jmp skip1
skip4	cmp #COL_ENTRANCE
	beq ExitScreen2
	cmp #COL_LIFTPLATFORM0
	bcs skip2
	cmp #COL_PLATFORM
	bne skip1
skip2	;Check frame for raised platform/lift
	lda #1
	sta FreezeJumpXSteps
	lda EthansCurrentLevel
	cmp #2
	bcc skip3
	dec EthansCurrentLevel
	jmp skip3
skip1	dey
	bpl loop1

	jsr nl_screen
	dex
	bne loop2
skip3	lda IgnoreNewXFlag
	bne skip5
	;No Collision	
	lda Check_X
	sta EthanX
skip5
.)
	lda Check_Y
	sta EthanY
	
	jsr PlotEthan
	
	lda EthanFrame
	cmp #ETHAN_JUMP_END
.(
	bcc skip1
	;Here is just after Ethan has somersaulted
	
	;Check immediately below for platform
	ldx EthansCurrentLevel
	ldy PlatformYPOS,x
	lda EthanX
	jsr FetchCollisionMapLocation
	ldy #1
	lda (screen),y
	
	ldx #ACTION_FALLING
	and #31
	beq skip3
	cmp #4
	beq skip3
	cmp #$14
	bcs skip4
	cmp #6
	bcs skip3

	
skip4	;Reset to standing
	ldx #ACTION_STANDING
skip3	stx EthanCurrentAction
	
	lda #SFX_CORRIDORFOOTSTEPS
	ldy EthansLocation
	;If Ethan's in corridor then don't play footstep followed by room background
	cpy #IN_CORRIDOR
	beq skip2
	;If Ethans in Simon room then avoid same
	ldy RoomID
	cpy #ROOM_SIMON
	beq skip2
	lda #SFX_ROOMFOOTSTEP
skip2	jsr KickSFX
skip1	rts
.)
ExitScreen2
	jmp ExitScreen


;For jump frames ETHAN_JUMP+0 to +2 scan 3x3
;For jump frames ETHAN_JUMP+3 to +6 scan 3x2
;For jump frames ETHAN_JUMP+7 to +9 scan 3x3
;For jump frames ETHAN_JUMP+10 to +11 scan 3x4
JumpFrameCollisionHeight
 .byt 3,3
 .byt 2,2,2,2,2,2
 .byt 3,3
 .byt 4,4

;IM Keys   == --FUD-RL
;## Joy	Key
;B0 Left	Crsr Left
;B1 Right	Crsr Right
;B2 -
;B3 Down	Crsr Down
;B4 Up	Crsr Up
;B5 Fire	Left Ctrl (but any other key)
KeyColumn
 .byt %11011111	;Row 4
 .byt %01111111	;Row 4
 .byt %10111111	;Row 4
 .byt %11110111	;Row 4
 .byt %11101000	;Row 4(all other keys)
 .byt %00000000	;Row 0
 .byt %00000000	;Row 1
 .byt %00000000	;Row 2
 .byt %00000000	;Row 3
 .byt %00000000	;Row 5
 .byt %00000000	;Row 6
 .byt %00000000	;Row 7
; .byt $EF	
KeyRow
 .byt 4
 .byt 4
 .byt 4
 .byt 4
 .byt 4
 .byt 0
 .byt 1
 .byt 2
 .byt 3
 .byt 5
 .byt 6
 .byt 7
KeyBit
 .byt %00000001
 .byt %00000010
 .byt %00001000
 .byt %00010000
 .byt %00100000
 .byt %00100000
 .byt %00100000
 .byt %00100000
 .byt %00100000
 .byt %00100000
 .byt %00100000
 .byt %00100000

;Will be..
;00 Keyboard
;01 IJK
ControllerType
 .byt 0
ProcessEthanJump
	;Jump depends
	lda EthansLocation
	cmp #IN_CORRIDOR
.(
	bne skip1
	;If just fire pressed then SwitchOnPocketComputer else continue to jump
	lda InputRegister
	;B0 Left	Crsr Left
	;B1 Right	Crsr Right
	;B2 Fire1	Left Ctrl
	and #%00100011
	cmp #%00100000
	beq SwitchOnPocketComputer
skip1	;Initialise Ethan jumping
	lda #ACTION_JUMPING
.)
	sta EthanCurrentAction
	;Attempt to improve jumping in opposite direction to facing by detecting opposite key here
	lda EthanFacingID
	cmp #FACING_LEFT
.(
	bne skip1
	;Ethan facing left so detect Right
	lda InputRegister
	and #CONTROLLER_RIGHT
	beq skip3
	;Switch Ethan to face Right
	lda #FACING_RIGHT
	sta EthanFacingID
rent1	;About to jump Right - Scan ahead for half platform higher
	jmp skip2

skip1	lda InputRegister
	and #CONTROLLER_LEFT
	beq rent1
	;Switch Ethan to face left
	lda #FACING_LEFT
	sta EthanFacingID
skip3	;About to jump left - Scan ahead for half platform higher

skip2	;
.)
	lda #00
	sta FreezeJumpXSteps
	jsr DeleteEthan
	lda #ETHAN_JUMP
	sta EthanFrame
	jmp PlotEthan
SwitchOnPocketComputer
	;Switch off glow
	jsr TurnOffGlow
	;Turn off any current sfx
	lda #00
	sta sfx_Status
	sta sfx_Status+1
	sta sfx_Status+2
	jsr PocketControl
	jmp PlotEthan

CorridorLiftFinish
	lda #SFX_LIFTEND
	jsr KickSFX
	jsr DisplayRoomCursor
	jsr DeleteEthan
	jsr CopyRoom2BGBuffer
	jsr PlotEthan
	jsr lsm_GenerateCollisionMap
	;However do not permit RTS until SFX has finished
	ldx #1
	jmp WaitUntilSFXFinished

AttemptToAscendCorridorLift
	;Check if we can move up
	lda RoomPositionY
.(
	beq skip2
	lda #SFX_LIFTSTART
	jsr KickSFX
;	jmp skip1

	;Reset Ethan frame to standing
	jsr DeleteEthan
	lda #$46
	sta EthanY
	ldx #ETHAN_STANDING
	stx EthanFrame
	jsr PlotEthan

loop1	jsr MainLiftUp
	;To save time if the player continues to press up then keep moving up lift
	lda InputRegister
	and #CONTROLLER_UP
	bne loop1
	jmp CorridorLiftFinish
skip2	rts
.)

AttemptToDescendCorridorLift
	lda RoomPositionY
	cmp #15
.(
	bcs skip1
	lda #SFX_LIFTSTART
	jsr KickSFX
	
	;Reset Ethan frame to standing
	jsr DeleteEthan
	lda #$46
	sta EthanY
	ldx #ETHAN_STANDING
	stx EthanFrame
	jsr PlotEthan
	
loop1	jsr MainLiftDown

	;To save time if the player continues to press up then keep moving up lift
	lda InputRegister
	and #CONTROLLER_DOWN
	bne loop1

	jmp CorridorLiftFinish
skip1	rts
.)

ProcessEthanDown
	;Move lift down
	ldx EthansCurrentLevel
	ldy PlatformYPOS,x
	lda EthanX
	jsr FetchCollisionMapLocation
	ldy #1
	lda (screen),y
	and #31
	ldy EthansLocation
	cpy #IN_CORRIDOR
.(
	bne skip1
	cmp #LSM_FOYERLIFT
	beq AttemptToDescendCorridorLift
skip1	cmp #COL_LIFTPLATFORM0
.)
.(
	bcc skip1
	jmp AttemptToDescendLift
skip1	jmp PlotEthan
.)
	
ProcessEthanUp
	;Look at foot of Ethan
	ldy EthansCurrentLevel
	lda PlatformYPOS,y
	sec
	sbc #6
	tay
	lda EthanX
	jsr FetchCollisionMapLocation
	;Is Ethan on Lift?
	ldy #41
	lda (screen),y
	and #31
	ldy EthansLocation
	cpy #IN_CORRIDOR
.(
	bne skip1
	cmp #LSM_FOYERLIFT
	bne skip1
	jmp AttemptToAscendCorridorLift
skip1	cmp #COL_LIFTPLATFORM0
.)
	bcs AttemptToAscendLift
	;Is Ethan infront of furniture?
	ldy #1
	lda (screen),y
	and #31
	cmp #COL_FURNITUREITEM00
	bcs ProcessUpOnFurniture
	;No Furniture Found - Set to stand frame
	ldx EthanFrame
	cpx #ETHAN_STANDING
.(
	beq skip1
	jsr DeleteEthan
	ldx #ETHAN_STANDING
	stx EthanFrame
	;Tie ethan to the current level
	jsr TieEthan2Platform
	jmp PlotEthan
skip1	rts
.)
	
AttemptToAscendLift
	;Is lift already moving?
	ldx LiftStatus
	bne MoveLiftskip1
	;We first need to find out which lift Ethan is standing on.
	;This is provided in the collision byte(A) which is the lift index
	sec
	sbc #COL_LIFTPLATFORM0
	tay
	lda LiftPlatform_CanMoveThisMuchUp,y
	beq MoveLiftskip1	;CannotRaiseLiftFurther
	lda #LIFT_GOINGUP

	sta LiftStatus
	sty CurrentLift
	
	;Store change in map
	ldx RoomID
	lda RoomAddressLo,x
	sta room
	lda RoomAddressHi,x
	sta room+1
	ldx LiftPlatform_Group,y
	asl LiftShaft_Platforms,x
MoveLiftRent
	ldy LiftShaft_CL_RoomOffset,x
	lda LiftShaft_Platforms,x
	sta (room),y

	lda #3
	sta Lifts_TotalStepsCount
	
	;Reset Hero to standing
	jsr DeleteEthan
	lda #ETHAN_STANDING
	sta EthanFrame
	
	;Tie ethan to the current level
	jsr TieEthan2Platform
	
	jmp PlotEthan
	
MoveLiftskip1
	rts

	
AttemptToDescendLift
	;Is lift already moving?
	ldx LiftStatus
	bne MoveLiftskip1
	;We first need to find out which lift Ethan is standing on.
	;This is provided in the collision byte(A) which is the lift index
	sec
	sbc #COL_LIFTPLATFORM0
	tay
	lda LiftPlatform_CanMoveThisMuchDown,y
	beq MoveLiftskip1	;CannotRaiseLiftFurther
	lda #LIFT_GOINGDOWN
	sta LiftStatus
	sty CurrentLift
	
	;Store change in map
	ldx RoomID
	lda RoomAddressLo,x
	sta room
	lda RoomAddressHi,x
	sta room+1
	ldx LiftPlatform_Group,y
	lsr LiftShaft_Platforms,x
	jmp MoveLiftRent

ProcessUpOnFurniture
	;A holds the furniture item sequence ID, use it (-8) to index the furniture room index
	tax
	ldy RoomFurniturePiece_RoomIndex-8,x
	;Y now holds a pointer to the FurnitureID in room data.
	;By decrementing Y we can then get the X and Y when we delete the item from the screen
	;X,Y,FurnitureID
	;Fetch Furniture ID
	lda (room),y
	and #31
	cmp #DOORWAY
	beq AttemptEnteringControlRoom
	cmp #TERMINAL_
	beq Switch2LogIntoTerminal
	cmp #SIMONCONSOLE
	beq Switch2LogIntoSimon
	;Search Furniture
	jmp Switch2SearchFurniture
Switch2LogIntoTerminal
	
	;Backup RoomID
	lda RoomID
	sta Old_RoomID
	lda #32
	sta RoomID
	
	;Backup current (room) since we'll use this later when deleting
	;furniture and writing back lift positions.
	lda room
	sta Old_room
	lda room+1
	sta Old_room+1
	
	;Ensure colour to right of monitor is restored to room colour combo
	lda $A000
	sta mon_part18
	lda $A028
	sta mon_part18+1
	
	;Display Terminal
	jsr PlotRoom
	jsr DisplaySecurityTerminalMenu
	
	lda #02
	sta stOption
	lda #00
	sta ResetLiftOnReturn
	
	;Wait and act on choice
	jsr ControlTerminalMenu
	
	;Restore RoomID and (room)
	lda Old_RoomID
	sta RoomID
	lda Old_room
	sta room
	lda Old_room+1
	sta room+1
	
	;Was the ConfirmationOption chosen 0?
	lda ResetLiftOnReturn
.(
	beq skip1
	lda #00
	sta ResetLiftOnReturn
	
	;Restore rooms lift levels
	jsr RestoreLiftPositions

skip1	;Restore screen
.)
;	sei
	;jsr CopyBGBuffer2Room
	inc RestoringRoomFromSecurityTerminal
	jsr PlotRoom
	
	;Restore Lifts
	jsr RedisplayLifts
	
	;Restore Robots (reduce counter)
	lda #00
	sta DroidDelay
	
	;Redraw Robots
	ldx UltimateDroid
.(
	bmi skip1

loop1	jsr PlotDroid
	dex
	bpl loop1
skip1
.)
	
	;Display Ethan again
	jsr PlotEthan

	;Clear input Buffer
	jmp FlushInputBuffer
	

AttemptEnteringControlRoom
	;Check we have all 7 letters of password
	lda Stats_PunchcardCount
	cmp #7
.(
	bne skip1

	jsr DeleteEthan

	;Initiate game complete sequence
	inc GameCompleteFlag
	

skip1	rts
.)

Switch2LogIntoSimon
	jmp SimonEngine
	
RunEthanLeft
	;Delete Ethan
	jsr DeleteEthan

	lda EthanFacingID	;Facing Left(0) or Facing Right(1)
	bne Switch2RunLeft
	lda EthanCurrentAction
	;0 Standing
	;1 Running
	;2 Jumping
	;3 Searching
	;4 Falling
	;5 Dieing(Hit by Robot)
	cmp #ACTION_RUNNING
	beq Continue2Run
Switch2RunLeft
	lda #ETHAN_RUN
	sta EthanFrame
	lda #FACING_LEFT
	sta EthanFacingID
	lda #ACTION_RUNNING
	sta EthanCurrentAction
	jmp Continue2Run

RunEthanRight	
	;Delete Ethan
	jsr DeleteEthan

	lda EthanFacingID	;Facing Left(0) or Facing Right(1)
	beq Switch2RunRight
	lda EthanCurrentAction
	;0 Standing
	;1 Running
	;2 Jumping
	;3 Searching
	;4 Falling
	;5 Dieing(Hit by Robot)
	cmp #ACTION_RUNNING
	beq Continue2Run
Switch2RunRight
	lda #ETHAN_RUN
	sta EthanFrame
	lda #FACING_RIGHT
	sta EthanFacingID
	lda #ACTION_RUNNING
	sta EthanCurrentAction

Continue2Run
	;Update Frame
	lda EthanFrame
	clc
	adc #01
	cmp #ETHAN_RUN_END
.(
	bcc skip1
	lda #ETHAN_RUN
skip1	sta EthanFrame
.)
	;Update Position
	ldx EthanFrame
	;Sort X
	lda EthanX
	ldy EthanFacingID
.(
	beq skip2	;RunLeft
	clc
	adc EthanFrameXStep,x
	jmp skip1
skip2	sec
	sbc EthanFrameXStep,x
skip1	sta Check_X
.)
	;Sort Y
	ldy EthansCurrentLevel
	lda PlatformYPOS,y
	sec
	sbc EthanFrameYOffset,x
	sta Check_Y
	tay
	
	;Check Collision Map for Running					Code Value
	;1) Check left or right walls (look at complete area for COL_WALL)		1
	;2) Check half height Platforms (look at complete area for COL_PLATFORM)	3
	;3) Check half height Lifts (look at complete area for COL_LIFTPLATFORM0-7)	1C-23
	;3) Check collision with Robot (look at complete area for COL_ROBOT0-7)	14-1B
	;4) Check collision with spark (look at complete area for COL_SPARK)		7
	;5) Check collision with Orb (look at complete area for COL_ORB)		6
	;5) Check for left or right Entrances (look at complete area for COL_ENTRANCE)	2
	;Also if foot down then
	;1) Check collision with Background (look at centre cell for COL_BACKGROUND	0
	;2) Check collision with Background (look at centre cell for COL_CHASM	4
	;Calculate collision map location
	lda Check_X
	jsr FetchCollisionMapLocation

	;Since we are only running set height in collision map to 3
	ldx #3
.(	
loop2	ldy #2
loop1	lda (screen),y
	and #31
	;We can merge some of the checking ranges
	;0?
	beq skip1
	;1,2,3,6 or 7
	cmp #COL_FURNITUREITEM00
	bcc CollisionFound
	;14-1B and 1C-23
	cmp #COL_LIFTPLATFORM0
	bcs CollisionFound
skip1	dey
	bpl loop1
	
	jsr nl_screen
	
	dex
	bne loop2
.)
	ldx EthanFrame
	lda EthanFootDown,x
.(
	bpl skip1
	
	;The Bit0 flag prevents the sfx repeating by signifying when the foot hits the ground
	cmp #129
	bne skip4
	lda #SFX_CORRIDORFOOTSTEPS
	ldy EthansLocation
	cpy #IN_CORRIDOR
	beq skip3
	;If Ethans in Simon room then avoid same
	ldy RoomID
	cpy #ROOM_SIMON
	beq skip3
	lda #SFX_ROOMFOOTSTEP
skip3	jsr KickSFX
	
skip4	;Progressing to next line in colmap(screen) here makes it look at floor below
	jsr nl_screen
	;Check for absence of platform - Either look left/middle(Facing left) or middle/right(facing right)
	ldy #00
	lda EthanFacingID
	beq skip2
	iny
skip2	;Both offsets must have either space(0) or furniture(8-13) to say fall
	;However if the offset contains a robot or spark then ???
	lda (screen),y
	and #31
	beq skip5
	cmp #8
	bcc skip1
	cmp #$14
	bcs skip1
skip5	iny
	lda (screen),y
	and #31
	beq CollisionFound
	cmp #8
	bcc skip1
	cmp #$14
	bcc CollisionFound
skip1
.)
StoreNewPosition
	lda Check_X

	sta EthanX
	lda Check_Y
	sta EthanY
IgnoreNewPosition
	jmp PlotEthan

CollisionFound
	;A contains type of collision
	;COL_WALL		- Ignore New position
	;COL_PLATFORM	- Ignore New position
	;COL_LIFTPLATFORM0-7- Ignore New position
	;COL_BACKGROUND	- Change action to Falling
	;COL_CHASM	- Change Action to Dieing through Falling
	;COL_ROBOT0-7	- Change action to Dieing through electricution
	;COL_SPARK	- Change action to Dieing through electricution
	;COL_ORB		- Change action to Dieing through electricution
	;COL_ENTRANCE	- Exit screen (Entrance depends on EthanX<>20)
	cmp #COL_BACKGROUND
	beq ChangeAction2Falling
	
	cmp #COL_WALL
	beq IgnoreNewPosition
	cmp #COL_PLATFORM
	beq IgnoreNewPosition
	cmp #COL_LIFTPLATFORM0
	bcs IgnoreNewPosition
	
	cmp #COL_ENTRANCE
	beq ExitScreen
	
	cmp #COL_CHASM
	beq Switch2DieingOfFalling	;Through gap in ground
	jmp DeathByElectricution

ChangeAction2Falling
	lda #ACTION_FALLING
	sta EthanCurrentAction
	jmp StoreNewPosition

Switch2DieingOfFalling
	jmp DeathByHeight

	

	

ExitScreen
	;Exit screen can occur..
	;1)When Ethan runs into a corridor exit
	;2)When ethan runs into a room exit
 	lda EthansLocation
	cmp #IN_CORRIDOR
	bne ProcessCorridorEntry
	jmp ProcessRoomEntry
ProcessCorridorEntry
	;Eye-Close room
	jsr EyeCloseRoom
	
	;Silence all active sfx
	jsr SilenceSFX

	;Restore 3/6 ink combo
	lda #0
	sta Object_X
	sta Object_Y
	lda #REPEATOBJECTDOWN
	sta Object_D
	lda #75
	sta Object_R
	lda #MON_PART18
	sta Object_V
	jsr RepeatDisplayGraphicObjectBG
	
	;Fetch equivalant TBF flag for room into Carry
	lda EthansCurrentLevel
	cmp #4
	lda RoomPositionY
	and #%11111110
.(
	bcc skip1
	ora #%00000001
skip1	sta RoomPositionY
.)	
	;On Exiting the room Ethan will be standing either left or right, so determine entry pos
	lda EthanX
	ldx #36
	cmp #20
.(
	bcc skip1
	ldx #2
	inc RoomPositionX
	jmp skip2
skip1	dec RoomPositionX

skip2	stx EthanX
.)
	lda #IN_CORRIDOR
	sta EthansLocation

	;Set Ethan facing right within lift
	lda #ETHAN_STANDING
	sta EthanFrame
	lda #ACTION_STANDING
	sta EthanCurrentAction
	
	;Set Ethans y and level
	lda #4
	sta EthansCurrentLevel
	jsr TieEthan2Platform
	
	;Ensure shaft entered has now been plundered
	lda RoomPositionY
	lsr
	tay
	lda RoomPositionX
	clc
	adc MultiplyBy13,y
	tay
	lda MapOfRooms,y
	ora #64
	sta MapOfRooms,y

	;Setup everything to start in Shaft
	jsr lsm_DisplayScoresComplexMap
	
	;Temporarily disable glowing(IRQ driven)
	jsr TurnOffGlow
	jsr DisplayRoomCursor2
	jsr lsm_RenderFullScreenBG
	jsr EyeOpenRoom
	jsr lsm_GenerateCollisionMap
	
	pla
	pla
	jmp MainPlay
	
ProcessRoomEntry
	;Eye-Close room
	jsr EyeCloseRoom

	;X position depends on 
	lda EthanX
	cmp #20
.(
	bcc skip1
	inc RoomPositionX
	ldx #2
	jmp skip2
skip1	dec RoomPositionX
	ldx #36
skip2	stx EthanX
.)
	;ypos and level depend on RoomPositionY
	lda RoomPositionY
	lsr
	sta Temp01
	ldy #1
.(
	bcc skip1
	ldy #7
skip1	sty EthansCurrentLevel
.)	
	jsr TieEthan2Platform
	
	;Find room
	ldy Temp01
	lda RoomPositionX
	clc
	adc MultiplyBy13,y
	tay
	
	;If Room not yet plundered then update rooms visited count else flag as plundered
	lda MapOfRooms,y
	and #127
	cmp #64
.(
	bcs skip1
	inc Stats_RoomCount
	lda MapOfRooms,y
	ora #64
	sta MapOfRooms,y
skip1	;Extract RoomID
.)
	and #31
	sta RoomID
	
	lda #IN_ROOM
	sta EthansLocation
	
	;Remember where ethan started in room (ressurection after death) and dir
	lda EthanX
	sta EthansStartX
	lda EthanY
	sta EthansStartY
	lda EthanFacingID
	sta EthanStartFacingID
	lda EthansCurrentLevel
	sta EthanStartLevel
	
	jsr PlotRoom
	
	;Clear MapofRooms area for Text Info
	jsr TurnOffGlow
	jsr CLS
	
	
	;Display Random Elvin message
	jsr EraseRoomText
	lda RoomID
	cmp #ROOM_SIMON
.(
	beq skip1
	jsr GetRandomNumber
	and #3
	clc
	adc #ROOMTEXT_DESTROYHIMMYROBOTS
	tax
	jsr DisplayRoomText	

skip1	pla
.)
	pla
	
	;Play footstep to restore room gurgle in rooms without droids
	lda RoomID
	cmp #ROOM_SIMON
.(
	beq skip1
	lda #SFX_ROOMFOOTSTEP
	jsr KickSFX
skip1
.)
	jmp MainPlay

PlotEthan	;Fetch Bitmap and Mask Addresses for Frame
	ldy EthanFrame
	
	lda EthanBitmapFrameAddressLo,y
	sta bitmap
	lda EthanBitmapFrameAddressHi,y
	sta bitmap+1
	
	lda EthanMaskFrameAddressLo,y
	sta mask
	lda EthanMaskFrameAddressHi,y
	sta mask+1

	jsr MirrorEthanFrame
	
	;Set FrameBuffer's to mask and bitmap
	ldx EthanFrame
	lda #<EthanBMPFrameBuffer
	sta bitmap
	lda #>EthanBMPFrameBuffer
	sta bitmap+1
	lda #<EthanMSKFrameBuffer
	sta mask
	lda #>EthanMSKFrameBuffer
	sta mask+1

	;Locate Ethan in physical screen
	lda EthanX
	ldy EthanY
	jsr RecalcScreen
	
	;Locate Ethan in Background Buffer
	lda EthanY
	jsr CalcBGBufferRowAddress	;into A&Y
	adc EthanX
	sta bgbuff
	tya
	adc #00
	sta bgbuff+1
	
	;Take copy of values written to the screen for collision detection
	lda #<EthansScreenImage
	sta copy
	lda #>EthansScreenImage
	sta copy+1
	
	;Fetch Ethans dimensions
	lda EthanMSKPixelHeight,x
	sta RowCount
	lda EthanBMPPixelHeight,x
	sta TempHeight
	
	;Branch if Ethan is in corridor
	ldy EthansLocation
	cpy #IN_CORRIDOR
	beq PlotCorridorEthan

	;Display Ethan
	ldx #00
.(
loop2	ldy #2
loop1	lda (bgbuff),y
	bmi CheckMask
	and (mask),y
	cpx TempHeight
	bcs skip1
	ora (bitmap),y
	jmp skip1
CheckMask	;If the Background(screen) is inversed then invert and mask
	eor #63
	and (mask),y
	cpx TempHeight
	bcs skip1
	ora (bitmap),y
skip1	sta (screen),y
	sta (copy),y
	dey
	bpl loop1
	
	jsr nl_screen
	
	lda copy
	adc #3
	sta copy
	bcc skip2
	inc copy+1
	clc
skip2	lda #40
	adc bgbuff
	sta bgbuff
	bcc skip3
	inc bgbuff+1
	clc
skip3	lda mask
	adc #3
	sta mask
;	bcc skip4
;	inc mask+1
;	clc
;skip4
	lda bitmap
	adc #3
	sta bitmap
;	bcc skip5
;	inc bitmap+1
;skip5
	inx
	cpx RowCount
	bcc loop2
.)
	rts

PlotCorridorEthan
	;
	lda #<CorridorColumn2Miss
	clc
	adc EthanX
.(
	sta loop1+1
	lda #>CorridorColumn2Miss
	adc #00
	sta loop1+2
	
	
	;Display Ethan
	ldx #00
loop2	ldy #2
loop1	lda $dead,y
	bne skip2
	lda (bgbuff),y
	bmi CheckMask
	and (mask),y
	cpx TempHeight
	bcs skip1
	ora (bitmap),y
	jmp skip1
CheckMask	;If the Background(screen) is inversed then invert and mask
	eor #63
	and (mask),y
	cpx TempHeight
	bcs skip1
	ora (bitmap),y
skip1	sta (screen),y
	sta (copy),y
skip2	dey
	bpl loop1
	
	jsr nl_screen
	
	lda copy
	adc #3
	sta copy
	bcc skip3
	inc copy+1
	clc
skip3	lda #40
	adc bgbuff
	sta bgbuff
	bcc skip4
	inc bgbuff+1
	clc
skip4	lda mask
	adc #3
	sta mask
	bcc skip5
	inc mask+1
	clc
skip5	lda bitmap
	adc #3
	sta bitmap
	bcc skip6
	inc bitmap+1
skip6	inx
	cpx RowCount
	bcc loop2
.)
	rts

EthansScreenImage
 .dsb 25*3,0	;Maximum height x 3 width

CorridorColumn2Miss
 .byt 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0
 .byt 0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

MirrorEthanFrame
	;Override Mirroring if Searching
	cpy #ETHAN_SEARCHING
.(
	beq skip1
	
	;Mirror or Copy Ethan BMP&MSK Frame to EthanFrameBuffer
	lda EthanFacingID
	cmp #FACING_RIGHT
	beq skip1

	;Facing Left - Mirror Copy BMP Frame to FrameBuffer
	ldx EthanBMPPixelHeight,y
	dex
	
loop1	ldy LeftByteOffset,x
	lda (bitmap),y
	tay
	lda Mirror64-64,y
	ldy FrameBufferRowOffset,x
	sta EthanBMPFrameBuffer+2,y
	
	ldy RightByteOffset,x
	lda (bitmap),y
	tay
	lda Mirror64-64,y
	ldy FrameBufferRowOffset,x
	sta EthanBMPFrameBuffer,y
	
	ldy CentreByteOffset,x
	lda (bitmap),y
	tay
	lda Mirror64-64,y
	ldy FrameBufferRowOffset,x
	sta EthanBMPFrameBuffer+1,y
	
	dex
	bpl loop1
	ldy EthanFrame
	ldx EthanMSKPixelHeight,y
	dex

loop2	ldy LeftByteOffset,x
	lda (mask),y
	tay
	lda Mirror64-64,y
	ldy FrameBufferRowOffset,x
	sta EthanMSKFrameBuffer+2,y
	
	ldy RightByteOffset,x
	lda (mask),y
	tay
	lda Mirror64-64,y
	ldy FrameBufferRowOffset,x
	sta EthanMSKFrameBuffer,y
	
	ldy CentreByteOffset,x
	lda (mask),y
	tay
	lda Mirror64-64,y
	ldy FrameBufferRowOffset,x
	sta EthanMSKFrameBuffer+1,y
	
	dex
	bpl loop2
	jmp skip2


skip1	ldx EthanBMPPixelHeight,y
	dex
	
loop3	ldy LeftByteOffset,x
	lda (bitmap),y
	ldy FrameBufferRowOffset,x
	sta EthanBMPFrameBuffer,y
	
	ldy RightByteOffset,x
	lda (bitmap),y
	ldy FrameBufferRowOffset,x
	sta EthanBMPFrameBuffer+2,y
	
	ldy CentreByteOffset,x
	lda (bitmap),y
	ldy FrameBufferRowOffset,x
	sta EthanBMPFrameBuffer+1,y
	
	dex
	bpl loop3
	ldy EthanFrame
	ldx EthanMSKPixelHeight,y
	dex

loop4	ldy LeftByteOffset,x
	lda (mask),y
	ldy FrameBufferRowOffset,x
	sta EthanMSKFrameBuffer,y
	
	ldy RightByteOffset,x
	lda (mask),y
	ldy FrameBufferRowOffset,x
	sta EthanMSKFrameBuffer+2,y
	
	ldy CentreByteOffset,x
	lda (mask),y
	ldy FrameBufferRowOffset,x
	sta EthanMSKFrameBuffer+1,y
	
	dex
	bpl loop4


skip2	rts
.)	

LeftByteOffset
FrameBufferRowOffset
 .byt 0,3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57,60,63,66,69,72	;25
CentreByteOffset
 .byt 1,4,7,10,13,16,19,22,25,28,31,34,37,40,43,46,49,52,55,58,61,64,67,70,73
RightByteOffset
 .byt 2,5,8,11,14,17,20,23,26,29,32,35,38,41,44,47,50,53,56,59,62,65,68,71,74





DeleteEthan
	;Restore BG from BGBuffer
	lda EthanX
	ldy EthanY
	jsr RecalcScreen
	
	lda EthanY
	jsr CalcBGBufferRowAddress
	adc EthanX
	sta source
	tya
	adc #00
	sta source+1
	
	
	ldy EthanFrame
	ldx EthanMSKPixelHeight,y
.(
loop2	ldy #2
loop1	lda (source),y
	sta (screen),y
	dey
	bpl loop1
	jsr nl_screen
	lda #40
	jsr AddSource
	dex
	bne loop2
.)
	rts	
	
	
WhiteOutEthan
	;Capture BG and Mask Ethan/Plot Ethan depending on Screen(128/0)
	ldy EthanFrame
	lda EthanMaskFrameAddressLo,y
	sta mask
	lda EthanMaskFrameAddressHi,y
	sta mask+1
	
	lda EthanX
	ldy EthanY
	jsr RecalcScreen
	
	ldy EthanFrame
	jsr MirrorEthanFrame
	
	;Set FrameBuffer's to mask and bitmap
	ldx EthanFrame	;<<Is this needed?
	lda #<EthanMSKFrameBuffer
	sta mask
	lda #>EthanMSKFrameBuffer
	sta mask+1

	;Locate Ethan in physical screen
	lda EthanX
	ldy EthanY
	jsr RecalcScreen
	
	;Locate Ethan in Background Buffer
	lda EthanY
	jsr CalcBGBufferRowAddress	;into A&Y
	adc EthanX
	sta bgbuff
	tya
	adc #00
	sta bgbuff+1
	
	;Fetch Ethans dimensions
	lda EthanMSKPixelHeight,x
	sta RowCount

	;Display Ethan
	ldx #00
.(
loop2	ldy #2
loop1	;Capture Inverted mask
	lda (mask),y
	eor #63
	sta WhiteOutBitmap
	lda (bgbuff),y
	bmi CheckMask
	and (mask),y
	ora WhiteOutBitmap
	jmp skip1
CheckMask	;If the Background(screen) is inversed then invert and mask
	lda WhiteOutBitmap
skip1	sta (screen),y
skip2	dey
	bpl loop1
	
	jsr nl_screen
	
	lda #40
	adc bgbuff
	sta bgbuff
	bcc skip3
	inc bgbuff+1
	clc
skip3	lda mask
	adc #3
	sta mask
	bcc skip4
	inc mask+1
skip4	inx
	cpx RowCount
	bcc loop2
.)
	rts	
	

FetchEthanCollision
	;1) Collision with plasma bolt
	;2) collision with robot
	;3) no ground
	;4) furniture
	;5) lift platform
	lda EthanX

GroundCheck
	ldx EthansCurrentLevel
	ldy PlatformYPOS,x
	lda EthanX
	clc
	adc CollisionMapYLOCL_ForPixelYPOS,y
	sta source
	lda CollisionMapYLOCH_ForPixelYPOS,y
	adc #00
	sta source+1
	
	ldy #00
	lda EthanFacingID
.(
	beq skip1
	ldy #01
skip1	;Check Middle and right byte
	lda (source),y
	and #31
	cmp #COL_PLATFORM
	beq skip2
	cmp #COL_MAINFOYERLIFT
	beq skip2
	cmp #COL_LIFTPLATFORM0
	bcs skip2
	iny
	lda (source),y
	and #31
	cmp #COL_PLATFORM
	beq skip2
	cmp #COL_MAINFOYERLIFT
	beq skip2
	cmp #COL_LIFTPLATFORM0
skip2	rts
.)	
	

TieEthan2Platform
	ldy EthansCurrentLevel
	lda PlatformYPOS,y
	ldx EthanFrame
	sec
	sbc EthanMSKPixelHeight,x
	sta EthanY
	rts


Mirror64
 .byt %01000000,%01100000,%01010000,%01110000,%01001000,%01101000,%01011000,%01111000
 .byt %01000100,%01100100,%01010100,%01110100,%01001100,%01101100,%01011100,%01111100
 .byt %01000010,%01100010,%01010010,%01110010,%01001010,%01101010,%01011010,%01111010
 .byt %01000110,%01100110,%01010110,%01110110,%01001110,%01101110,%01011110,%01111110
 .byt %01000001,%01100001,%01010001,%01110001,%01001001,%01101001,%01011001,%01111001
 .byt %01000101,%01100101,%01010101,%01110101,%01001101,%01101101,%01011101,%01111101
 .byt %01000011,%01100011,%01010011,%01110011,%01001011,%01101011,%01011011,%01111011
 .byt %01000111,%01100111,%01010111,%01110111,%01001111,%01101111,%01011111,%01111111
