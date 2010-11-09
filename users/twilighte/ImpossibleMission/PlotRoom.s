;Plot IM Screen
;Construct room in BGBuffer up until we are about to plot the lift platforms then eye-open to screen.
;Then plot rest of room (lift platforms and droids).

;Rooms are constructed from a number of parts which must always follow this order..
;1 - Entrances
;2 - Platforms
;3 - Lift Shafts
;4 - Furniture
;5 - Lift Platforms
;6 - Droid positions
;7 - End
;Each part is both plotted to BGB/Screen and Collision map

PlotRoom  ;If plotting room 32(Terminal) then avoid setting some variables
	lda RoomID
	cmp #ROOM_SECURITYTERMINAL
.(
	beq skip1
	
	ldx #0
	stx EyeOpenedYet
	dex
	stx UltimateLiftPlatform

	;If we're restoring the room after coming out of the security terminal
	;we don't want to reset Droid positions/actions
	ldy RestoringRoomFromSecurityTerminal
	bne skip2
	stx UltimateDroid
skip2	lda #07
	sta FurnitureSequenceID
	jsr DisplayTemplate
	jmp DrawObjects
skip1	;Display template for Security Terminal
.)
	lda #<$A000
	sta screen
	lda #>$A000
	sta screen+1
	jsr DisplayTemplate4SecurityTerminal
	jmp DrawObjects
;Normal is 3/6
;Other good mixes are 3/2,2/2,2/3,2/6,6/6,6/3,3/3,6/2
;EO
;36
;32
;33
;23
;22
;26
;62
;63
EvenColour
 .byt 3,3,3,2,2,2,6,6
OddColour
 .byt 6,2,3,2,3,6,2,3


DisplayTemplate
	lda #<BGBuffer
	sta screen
	lda #>BGBuffer
	sta screen+1
DisplayTemplate4SecurityTerminal
	ldx #75
.(
loop3	ldy #39
	lda #%01010101
loop1	sta (screen),y
	dey
	bne loop1
	
	jsr nl_screen
	ldy #39
	lda #%01101010
loop2	sta (screen),y
	dey
	bne loop2
	
	jsr nl_screen
	dex
	bne loop3
.)
	;We also use the room plot routine for displaying the Security Terminal(32)
	lda RoomID
	cmp #ROOM_SECURITYTERMINAL
.(
	bne skip1
	rts	
skip1	;Reset Collision Map
.)
	lda #0
	sta Object_X
	sta Object_Y
	sta Object_V
	lda #40
	sta Object_W
	lda #25
	sta Object_H
	jsr PlotCollisionObject
	;And plot the left wall in the collision map
	ldx #1
	stx Object_X
	stx Object_W
	dex
	stx Object_Y
	lda #COL_WALL
	sta Object_V
	lda #25
	sta Object_H
	jsr PlotCollisionObject
	;Plot the left wall on the screen
	ldx #1
	stx Object_X
	dex
	stx Object_Y
	lda #WALLGFX
	sta Object_V
	lda #37
	sta Object_R
	lda #REPEATOBJECTDOWN
	sta Object_D
	jsr RepeatDisplayGraphicObjectBG

	;now plot the right wall in the collision map
	lda #39
	sta Object_X
	ldx #1
	stx Object_W
	dex
	stx Object_Y
	lda #COL_WALL
	sta Object_V
	lda #25
	sta Object_H
	jsr PlotCollisionObject
	;And finally the right wall on the screen
	lda #39
	sta Object_X
	lda #0
	sta Object_Y
	lda #WALLGFX
	sta Object_V
	lda #37
	sta Object_R
	lda #REPEATOBJECTDOWN
	sta Object_D
	jmp RepeatDisplayGraphicObjectBG



DrawObjects
	ldx RoomID
	lda RoomAddressLo,x
	sta room
	lda RoomAddressHi,x
	sta room+1
	
	ldy #00
	sty tempY
.(
loop1	ldy tempY
	lda (room),y
	beq EndRoom
	tax
	lda CommandAddressLo,x
	sta vector1+1
	lda CommandAddressHi,x
	sta vector1+2
	tya
	clc
	adc CommandBytes,x
	sta tempY
	iny
vector1	jsr $dead
	jmp loop1
EndRoom	;If bgb has not been opened yet (like no lifts or simon room) then do it here
.)
	lda EyeOpenedYet
.(
	bne skip1
	jsr EyeOpenRoom
skip1	;Reset flag
.)
	lda #00
	sta RestoringRoomFromSecurityTerminal
	rts

RestoringRoomFromSecurityTerminal	.byt 0
	
;PLATFORM		X,Y(Platform 0-7),Length
DisplayPlatform
	;Fetch X
	lda (room),y
	sta Object_TempX
	sta Object_X
	iny
	;Fetch Y
	lda (room),y
	tax
	lda PlatformYPOS,x
	sta Object_Y
	;Fetch Length
	iny
	lda (room),y
	sta Object_R
	lda #REPEATOBJECTRIGHT
	sta Object_D
	lda #PLATFORMGFX
	sta Object_V

	jsr RepeatDisplayGraphicObjectBG

	;Now Show it in collision map
	lda Object_TempX
	sta Object_X
	lda Object_R
	sta Object_W
	lda #1
	sta Object_H
	lda #COL_PLATFORM
	sta Object_V
	jmp PlotCollisionObject
	
ScreenOffset
 .byt 0,40,80,120,160,200,240
 
;IM Lifts are split into LIFTSHAFT and LIFTPLATFORM
;LIFTSHAFT specifies the x position of a lift shaft and how many levels it spans(G,X,S)
;	G governs the index (group) that a lift shaft is for
;	X specifies the X position of the lift shaft
;	S Levels the shaft Spans held as a bitmap where each bit represents a level
;	      			Example
;	   B7 Top Platform Level(0)	0
;	   B6                         1 Lift shaft spans levels 1 to 3
;	   B5                         1
;	   B4                         1
;	   B3                         0
;	   B2                         0
;	   B1                         0
;	   B0 Bottom Platform Level(7)0
;LIFTPLATFORMS specifies the default and current positions of lifts in a group (G,DL,CL)
;	G is the group (Lift Shaft) this platform is used for
;	DL is the default level the platform resides at
;	CL is the current level the platform resides at

;How do we remember the last level of the lifts in each game?
;When a lift is moved, the new position of the lifts in the group are stored back in the CL data field.
;We can locate the record by looking for the LIFTPLATFORMS command, matching its GroupID to the
;Lift Collision value and storing the new levels for all lifts in the group(single byte store).

;How do we reset the lift platforms?
;We locate the Room List and replace all CL with DL in the LIFTPLATFORMS commands.

DisplayLiftShaft
	;Fetch GroupID
	lda (room),y
	tax
	;Fetch X
	iny
	lda (room),y
	sta LiftShaft_X,x
	sta Object_X
	;Fetch S
	iny
	lda (room),y
	sta screen
	sta screen+1
	;locate start Y position Shaft starts from
	lda #01
	clc
.(
loop1	adc #18
	asl screen
	bcc loop1
.)	
	sta LiftShaft_Y,x
	sta Object_Y
	sta Object_TempY
	
	;Count bits in Liftshaft bitmap
	lda #00
	sta screen
	ldy #07
.(
loop1	lda screen+1
	and Bitpos,y
	beq skip1
	inc screen
skip1	dey
	bpl loop1
.)
	;Multiply number of bits by 3 to get number of shaft gfx down
	dec screen
	lda screen
	asl
	adc screen
	adc #1
	sta Object_R
	sta Object_H
	
	lda screen+1
	sta LiftShaft_Levels,x
	
	;Now Display Lift shaft using RepeatDisplayGraphicObject
	lda #SHAFTGFX
	sta Object_V
	lda #REPEATOBJECTDOWN
	sta Object_D
	jsr RepeatDisplayGraphicObjectBG
	
	;Now plot in collision map (doing same repeat as above)
	lda Object_TempY
	sta Object_Y
	lda #4
	sta Object_W
	lda #COL_BACKGROUND
	sta Object_V

	jmp PlotCollisionObject

;LIFTPLATFORMS specifies the default and current positions of lifts in a group (G,DL,CL)
;	G is the group (Lift Shaft) this platform is used for
;	DL is the default level the platform resides at
;	CL is the current level the platform resides at
DisplayLiftPlatforms
;	nop
;	jmp DisplayLiftPlatforms
	lda EyeOpenedYet
.(
	bne skip1
	;We now have most stuff in the BGBuffer.
	;However the lift platforms and droids must not be plotted to the bgbuffer, so at this point
	;perform the eye-open sequence (to copy bgbuffer to screen) then continue on screen.
	inc EyeOpenedYet
	sty TempYDuringCBGB
	jsr EyeOpenRoom
	ldy TempYDuringCBGB
skip1	;Fetch Group
.)
	lda (room),y
	sta TempGroup
	tax
	lda LiftShaft_X,x
	sta Object_X
	lda #19	;LiftShaft_Y,x
	sta Object_Y
	iny
	
	iny
	lda (room),y
	sta LiftShaft_Platforms,x
	sta TempPlatforms
	
	;Store Lift CL location so that when exiting the room we'll be able to store back the
	;any changes to the lift positions(index by group)
	tya
	sta LiftShaft_CL_RoomOffset,x
	
	lda #7
	sta LevelCounter
.(	
loop1	lda TempPlatforms
	ldy LevelCounter
	and Bitpos,y
	bne skip4
	jmp skip1
	
skip4	lda #LIFTGFX
	sta Object_V

	;Display Lift on screen
	jsr DisplayGraphicObject

	;Place lift in collision map(4) as Platform-Lift-Lift-Platform
	;This is a special case since normally we'd just paste the same value over the area
	
	;We really could do with creating each lift platforms X,Y,Group and bounds here then storing
	;2 bytes of the absolute index in the collision map.
	;Bounds would say "can move up this much and down that much" in units of 6 pixels then just
	;dec "up this much" and inc "down this much" when moving up and vice versa when moving down.
	
	;It would make this much simpler to move the lift later on.
	inc UltimateLiftPlatform
	ldx UltimateLiftPlatform
	
	;Store Lift-Platforms Screen X position
	lda Object_X
	sta LiftPlatform_X,x
	
	;Store Lift-Platforms Screen Y position
	lda Object_Y
	sta LiftPlatform_Y,x
	
	;Store Lift-Platforms Group
	lda TempGroup
	sta LiftPlatform_Group,x
	
	;Calculate bounds
	;how far can this lift platform move up?
	;LiftShaft_Levels,x(group) holds the total levels available as a bitmap
	;TempPlatforms is the bitmap
	;So by shifting left (moving up) then ANDing with the shaft levels available
	;we can work out how far up we can go with the group of platform lifts.
;loop99	nop
;	jmp loop99
	
	lda TempPlatforms
	sta Temp01
	lda #00
	sta Count
	ldy TempGroup
	
loop2	asl Temp01
	bcs skip2
	lda Temp01
	and LiftShaft_Levels,y
	cmp Temp01
	bne skip2
	inc Count
	jmp loop2
	
skip2	;Multiply Count by 3
	lda Count
	asl
	adc Count
	sta LiftPlatform_CanMoveThisMuchUp,x
	
	;And by shifting down (instead of up) we can discover how far we can move down
	;Now do opposite for down
	lda TempPlatforms
	sta Temp01
	lda #00
	sta Count
	
loop3	lsr Temp01
	bcs skip3
	lda Temp01
	and LiftShaft_Levels,y
	cmp Temp01
	bne skip3
	inc Count
	jmp loop3
	
skip3	;Multiply Count by 3
	lda Count
	asl
	adc Count
	sta LiftPlatform_CanMoveThisMuchDown,x
	
	;Now display in Collision map
	lda Object_X
	ldy Object_Y
	jsr FetchCollisionMapLocation
	ldy #00
	lda #COL_PLATFORM
	sta (screen),y
	ldy #03
	sta (screen),y
	ldy #01
	txa
	adc #COL_LIFTPLATFORM0
	sta (screen),y
	iny
	sta (screen),y

skip1	lda Object_Y
	clc
	adc #18
	sta Object_Y
	dec LevelCounter
	bmi skip5
	jmp loop1
skip5	rts
.)	

PlatformYPOS
 .byt 19,37,55,73,91,109,127,145

LiftPlatform_X
 .dsb 12,0
LiftPlatform_Y
 .dsb 12,0
LiftPlatform_Group
 .dsb 12,0
LiftPlatform_CanMoveThisMuchUp
 .dsb 12,0
LiftPlatform_CanMoveThisMuchDown
 .dsb 12,0
 
 

LiftShaft_X
 .dsb 8,0
LiftShaft_Y
 .dsb 8,0
LiftShaft_Levels
 .dsb 8,0
LiftShaft_Platforms
 .dsb 8,0
LiftShaft_CL_RoomOffset
 .dsb 8,0

Bitpos
 .byt 1,2,4,8,16,32,64,128


;X,Y,FurnitureID
;The furnitureID is 0-31 but also contains a Plundered flag in B7 which is set every time a search of the
;furniture is finished (to not show it anymore).
;On a game restart this flag is cleared.
DisplayFurniture
	;Fetch  and store X
	lda (room),y
	sta Object_X
	
	;Fetch Y
	iny
	lda (room),y
	tax
	iny
	sty TempRoomFurnitureIndex
	
	;Fetch ID
	lda (room),y
	bmi PlunderedItem
	and #31
	
	;Calculate Object
	clc
	adc #BASEOFFURNITURE
	sta Object_V
	tay
	
	;Calculate Y
	lda PlatformYPOS,x
	sec
	sbc Object_Height,y
	sta Object_Y
	
	;Fetch width and height (for collision plotting)
	lda Object_Width,y
	sta Object_W
	lda FurnitureCollisionHeight-122,y
	sta Object_H
	
	;Plot Object to screen
	jsr DisplayGraphicObjectBG
	
	;Calculate Value to write to collision map
	inc FurnitureSequenceID
	ldy FurnitureSequenceID
	sty Object_V
	
	;Write away furniture to tables for use later when searching
	lda TempRoomFurnitureIndex
	sta RoomFurniturePiece_RoomIndex-8,y
	lda #00
	sta RoomFurniturePiece_SearchProgress-8,y
	
	;Plot object to collsion map
	jmp PlotCollisionObject
PlunderedItem
	rts	

RoomFurniturePiece_RoomIndex
 .dsb 12,0
RoomFurniturePiece_SearchProgress
 .dsb 12,0
FurnitureCollisionHeight	;Basically just a division by 6 of normal height
 .byt 4	;00 GFX_Terminal		
 .byt 3	;01 GFX_Sofa		
 .byt 4	;02 GFX_Fireplace           
 .byt 4	;03 GFX_Toilet              
 .byt 3	;04 GFX_Drawers             
 .byt 4	;05 GFX_Armchair            
 .byt 3	;06 GFX_Desk                
 .byt 2 	;07 GFX_Bed                      
 .byt 4	;08 GFX_Sink                     
 .byt 4	;09 GFX_Bath                     
 .byt 5	;10 GFX_Bookcase                 
 .byt 5	;11 GFX_Candy                    
 .byt 2	;12 GFX_Speaker                  
 .byt 3	;13 GFX_Hifi                     
 .byt 4	;14 GFX_Lamp                     
 .byt 4	;15 GFX_Computer                 
 .byt 4	;16 GFX_Tapestreamer             
 .byt 3	;17 GFX_Harddisk                 
 .byt 3	;18 GFX_Harddisk2                
 .byt 2   ;19 GFX_Basket
 .byt 4   ;20 GFX_FagDispenser                         
 .byt 4   ;21 GFX_Telex                                
 .byt 4   ;22 GFX_FilingCabinet                        
 .byt 5   ;23 GFX_Doorway                              
 .byt 4   ;24 GFX_SimonConsole                         
 .byt 2   ;25 GFX_Picture
 .byt 3   ;26 GFX_Sideboard
 .byt 0   ;27            
 .byt 0   ;28            
 .byt 0   ;29            
 .byt 0   ;30            
 .byt 0   ;31            
 .byt 0	;32 GFX_SearchingBar
FurnitureSearchStep	;Is the step size of each increment of the progress bar
 .byt 0	;00 GFX_Terminal		
 .byt 1	;01 GFX_Sofa		
 .byt 1	;02 GFX_Fireplace           
 .byt 4	;03 GFX_Toilet              
 .byt 1	;04 GFX_Drawers             
 .byt 2	;05 GFX_Armchair            
 .byt 1	;06 GFX_Desk                
 .byt 1 	;07 GFX_Bed                      
 .byt 3	;08 GFX_Sink                     
 .byt 4	;09 GFX_Bath                     
 .byt 1	;10 GFX_Bookcase                 
 .byt 2	;11 GFX_Candy                    
 .byt 4	;12 GFX_Speaker                  
 .byt 4	;13 GFX_Hifi                     
 .byt 4	;14 GFX_Lamp                     
 .byt 4	;15 GFX_Computer                 
 .byt 2	;16 GFX_Tapestreamer             
 .byt 2	;17 GFX_Harddisk                 
 .byt 2	;18 GFX_Harddisk2                
 .byt 1   ;19 GFX_Basket
 .byt 2   ;20 GFX_FagDispenser                         
 .byt 3   ;21 GFX_Telex                                
 .byt 1   ;22 GFX_FilingCabinet                        
 .byt 0   ;23 GFX_Doorway                              
 .byt 0   ;24 GFX_SimonConsole                         
 .byt 4   ;25 GFX_Picture
 .byt 1   ;26 GFX_Sideboard
 .byt 0   ;27            
 .byt 0   ;28            
 .byt 0   ;29            
 .byt 0   ;30            
 .byt 0   ;31            
 .byt 0	;32 GFX_SearchingBar


SetDroid	;If we're restoring the room after coming out of the security terminal
	;we don't want to reset current Droid positions/actions
	lda RestoringRoomFromSecurityTerminal
.(
	bne skip1
	;X(1 or 39),Y(Platform 0-7),Length of Rail(1-39),Type(0-15)
	;Fetch X
	lda (room),y
	inc UltimateDroid
	ldx UltimateDroid
	sta DroidX,x
	sta DroidsRailStart,x
	;Fetch Y
	iny
	lda (room),y
	;However Y is simply the platform number 0-7 so save till later
	pha
	;Fetch Rail Length
	iny
	lda (room),y
	clc
	adc DroidsRailStart,x
	sta DroidsRailEnd,x
	;Fetch Type (This is randomised on every new game)
	iny
	lda (room),y
	sta DroidScriptID,x
	;Set Other Droid fields
	lda #00
	sta DroidScriptIndex,x
	sta DroidDelayCount,x
	lda #01
	sta DroidDirection,x
	sta DroidDelayRefer,x
	lda #128
	sta DroidAction,x
	lda #DROIDRIGHT
	sta DroidFrameID,x

	;Now fetch the platform number 0-7
	pla
	tay
	;Turn into Screen YPOS
	lda PlatformYPOS,y
	;Subtract the droid height of 12
	sec
	sbc #12
	sta DroidY,x
skip1	rts
.)

	
SetEntrance
	;X(0 or 39),Y(Normally 1 or 7)
	;Erase wall at specified level
	;Fetch X
	lda (room),y
	sta Object_X
	sta TempXpos
	;Fetch Y
	iny
	lda (room),y
	sta TempYpos
	;Calculate Y position on screen
.(
	beq skip1
	lda #108
skip1	clc
.)
	adc #8
	sta Object_Y
	sta TempYpos
	;Display entrance
	lda #5
	sta Object_R
	lda #REPEATOBJECTDOWN
	sta Object_D
	lda #ENTRANCEGFX
	sta Object_V
	jsr RepeatDisplayGraphicObjectBG
	;Plot In Collision Map
	lda TempXpos
	sta Object_X
	lda TempYpos
	sta Object_Y
	lda #1
	sta Object_W
	lda #5
	sta Object_H
	lda #COL_ENTRANCE
	sta Object_V
	jmp PlotCollisionObject

CommandAddressLo
 .byt 0
 .byt <DisplayPlatform
 .byt <DisplayLiftShaft
 .byt <DisplayLiftPlatforms
 .byt <DisplayFurniture
 .byt <SetDroid
 .byt <SetEntrance
 .byt <DisplayObjectBG
 .byt <DisplayRepeatedObjectBG
 .byt <DisplayObject
 .byt <DisplayRepeatedObject

CommandAddressHi
 .byt 0
 .byt >DisplayPlatform
 .byt >DisplayLiftShaft
 .byt >DisplayLiftPlatforms
 .byt >DisplayFurniture
 .byt >SetDroid
 .byt >SetEntrance
 .byt >DisplayObjectBG
 .byt >DisplayRepeatedObjectBG
 .byt >DisplayObject
 .byt >DisplayRepeatedObject

CommandBytes	;Includes command
 .byt 1	;END,
 .byt 4	;PLATFORM,x,y,l
 .byt 4	;LIFTSHAFT,g,x,l
 .byt 4	;LIFTPLATFORMS,g,dl,cl
 .byt 4	;FURNITURE,x,y,f
 .byt 5	;DROID,x,y,l,t
 .byt 4	;ENTRANCE,x,y,PuzzlePiece
 .byt 4	;OBJECT,x,y,o
 .byt 6	;REPEATOBJECT,x,y,o,d,r
 .byt 4	;OBJECT,x,y,o
 .byt 6	;REPEATOBJECT,x,y,o,d,r

;A == X(0-39)
;Y == Y(0-137)
RecalcScreen
	;(Yx40)+X+$A000
	sta TempRX
	lda #00
	sta screen+1
	tya
	
	;Yx8
	asl
	rol screen+1
	asl
	rol screen+1
	asl
	rol screen+1
	sta TempLo
	ldy screen+1
	
	;Yx32
	asl
	rol screen+1
	asl
	rol screen+1
	
	;Yx8 + Yx32
	adc TempLo
	sta screen
	tya
	adc screen+1
	tay
	
	;+X
	lda screen
	adc TempRX
	sta screen
	
	;+$A000
	tya
	adc #$A0
	sta screen+1
	rts


RoomAddressLo
 .byt <Room_00	;RB
 .byt <Room_01      ;
 .byt <Room_02      ;
 .byt <Room_03      ;
 .byt <Room_04      ;
 .byt <Room_05      ;
 .byt <Room_06      ;
 .byt <Room_07      ;
 .byt <Room_08      ;
 .byt <Room_09      ;
 .byt <Room_10      ;
 .byt <Room_11      ;
 .byt <Room_12      ;
 .byt <Room_13      ;
 .byt <Room_14      ;
 .byt <Room_15      ;
 .byt <Room_16      ;
 .byt <Room_17      ;
 .byt <Room_18      ;
 .byt <Room_19      ;
 .byt <Room_20      ;
 .byt <Room_21      ;
 .byt <Room_22      ;
 .byt <Room_23      ;
 .byt <Room_24      ;
 .byt <Room_25      ;
 .byt <Room_26      ;
 .byt <Room_27      ;
 .byt <Room_28      ;
 .byt <Room_29      ;
 .byt <Room_30      ;
 .byt <Room_31      ;
 .byt <Room_32
RoomAddressHi
 .byt >Room_00	;Simon Computer Room
 .byt >Room_01
 .byt >Room_02
 .byt >Room_03
 .byt >Room_04
 .byt >Room_05
 .byt >Room_06
 .byt >Room_07
 .byt >Room_08
 .byt >Room_09
 .byt >Room_10
 .byt >Room_11
 .byt >Room_12
 .byt >Room_13
 .byt >Room_14
 .byt >Room_15
 .byt >Room_16
 .byt >Room_17
 .byt >Room_18
 .byt >Room_19
 .byt >Room_20
 .byt >Room_21
 .byt >Room_22
 .byt >Room_23
 .byt >Room_24
 .byt >Room_25
 .byt >Room_26	;Control room
 .byt >Room_27
 .byt >Room_28
 .byt >Room_29
 .byt >Room_30
 .byt >Room_31
 .byt >Room_32

;A room consists of Platforms, lifts, furniture and marks for Robots

;The room contents must also be echoed in a collision map with each cell 6x6 pixels
;The collision map is 39x25. Each cell represents the objects as follows..
;
;00 - Background
;01 - Wall
;02 - Entrance
;03 - Platform
;05 - Main Foyer Lift
;06 - Orb
;07 - Spark
;08 - Furniture Item 00
;09 - Furniture Item 01
;0A - Furniture Item 02
;0B - Furniture Item 03
;0C - Furniture Item 04
;0D - Furniture Item 05
;0E - Furniture Item 06
;0F - Furniture Item 07
;10 - Furniture Item 08
;11 - Furniture Item 09
;12 - Furniture Item 10
;13 - Furniture Item 11
;14 - Robot 0        
;15 - Robot 1        
;16 - Robot 2        
;17 - Robot 3        
;18 - Robot 4        
;19 - Robot 5        
;1A - Robot 6        
;1B - Robot 7        
;1C - Lift Platform 0
;1D - Lift Platform 1
;1E - Lift Platform 2
;1F - Lift Platform 3
;20 - Lift Platform 4
;21 - Lift Platform 5
;22 - Lift Platform 6
;23 - Lift Platform 7


;Parsed
;Object_X
;Object_Y
;Object_W
;Object_H
;Object_V
PlotCollisionObject
	stx Object_TempX
	sty Object_TempY
	lda Object_X
	ldy Object_Y
	jsr FetchCollisionMapLocation
	ldx Object_H
.(
loop2	ldy Object_W
	dey
	lda Object_V
loop1	sta (screen),y
	dey
	bpl loop1
	jsr nl_screen
	dex
	bne loop2
.)
	ldx Object_TempX
	ldy Object_TempY
	rts



CollisionMapYLOCL_ForPixelYPOS
 .dsb 6,<CollisionMap
 .dsb 6,<CollisionMap+40*1
 .dsb 6,<CollisionMap+40*2
 .dsb 6,<CollisionMap+40*3
 .dsb 6,<CollisionMap+40*4
 .dsb 6,<CollisionMap+40*5
 .dsb 6,<CollisionMap+40*6
 .dsb 6,<CollisionMap+40*7
 .dsb 6,<CollisionMap+40*8
 .dsb 6,<CollisionMap+40*9
 .dsb 6,<CollisionMap+40*10
 .dsb 6,<CollisionMap+40*11
 .dsb 6,<CollisionMap+40*12
 .dsb 6,<CollisionMap+40*13
 .dsb 6,<CollisionMap+40*14
 .dsb 6,<CollisionMap+40*15
 .dsb 6,<CollisionMap+40*16
 .dsb 6,<CollisionMap+40*17
 .dsb 6,<CollisionMap+40*18
 .dsb 6,<CollisionMap+40*19
 .dsb 6,<CollisionMap+40*20
 .dsb 6,<CollisionMap+40*21
 .dsb 6,<CollisionMap+40*22
 .dsb 6,<CollisionMap+40*23
 .dsb 6,<CollisionMap+40*24
CollisionMapYLOCH_ForPixelYPOS
 .dsb 6,>CollisionMap
 .dsb 6,>CollisionMap+40*1
 .dsb 6,>CollisionMap+40*2
 .dsb 6,>CollisionMap+40*3
 .dsb 6,>CollisionMap+40*4
 .dsb 6,>CollisionMap+40*5
 .dsb 6,>CollisionMap+40*6
 .dsb 6,>CollisionMap+40*7
 .dsb 6,>CollisionMap+40*8
 .dsb 6,>CollisionMap+40*9
 .dsb 6,>CollisionMap+40*10
 .dsb 6,>CollisionMap+40*11
 .dsb 6,>CollisionMap+40*12
 .dsb 6,>CollisionMap+40*13
 .dsb 6,>CollisionMap+40*14
 .dsb 6,>CollisionMap+40*15
 .dsb 6,>CollisionMap+40*16
 .dsb 6,>CollisionMap+40*17
 .dsb 6,>CollisionMap+40*18
 .dsb 6,>CollisionMap+40*19
 .dsb 6,>CollisionMap+40*20
 .dsb 6,>CollisionMap+40*21
 .dsb 6,>CollisionMap+40*22
 .dsb 6,>CollisionMap+40*23
 .dsb 6,>CollisionMap+40*24



