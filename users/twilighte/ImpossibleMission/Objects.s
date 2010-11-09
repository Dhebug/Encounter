;Objects.s - Objects are extra graphics like Simon Computer, Sparks, Lift Foyer Graphics and Puzzle Pieces

;Object_X
;Object_Y
;Object_V
RestoreObjectsBackground
	lda Object_Y
	jsr CalcBGBufferRowAddress
	adc Object_X
	sta source
	tya
	adc #00
	sta source+1
	ldy Object_Y

	lda Object_X
	jsr RecalcScreen
	
	ldy Object_V
	ldx Object_Height,y
	
	lda Object_Width,y
	sta TempWidth
.(	
loop2	ldy TempWidth
	dey
loop1	lda (source),y
	sta (screen),y
	dey
	bpl loop1
	lda #40
	jsr AddSource
	jsr nl_screen
	dex
	bne loop2
.)
	rts

;Erase object from bgbuffer with dither
;Object_X
;Object_Y
;Object_V
EraseObjectsBackground
	ldx Object_V
	lda Object_Y
.(
	sta vector1+1
	jsr CalcBGBufferRowAddress
	adc Object_X
	sta source
	tya
	adc #00
	sta source+1
vector1	lda #00
.)	
	lda Object_Y
	lsr
.(
	bcc skip2
	lda #%01101010
	jmp skip1
skip2	lda #%01010101
skip1	sta DitherPattern
.)
	ldy Object_V
	ldx Object_Height,y
	
	lda Object_Width,y
	sta TempWidth
.(	
loop2	ldy TempWidth
	dey
loop1	lda DitherPattern
	sta (source),y
	dey
	bpl loop1
	lda DitherPattern
	eor #%00111111
	sta DitherPattern
	lda #40
	jsr AddSource
	dex
	bne loop2
.)
	rts

;Object_X
;Object_Y
;Object_V
;Object_R(Number of times to repeat)
;Object_D(Direction to repeat Down(0) Right(1))
RepeatDisplayGraphicObjectBG
	lda Object_R
	sta Object_Z
.(
loop1	jsr DisplayGraphicObjectBG
	ldx Object_V
	clc
	lda Object_D
	bne skip2
	lda Object_Y
	adc Object_Height,x
	sta Object_Y
	jmp skip1
skip2	lda Object_X
	adc Object_Width,x
	sta Object_X
skip1	dec Object_Z
	bne loop1
.)
	rts


;Object_X
;Object_Y
;Object_V
;Object_R(Number of times to repeat)
;Object_D(Direction to repeat Down(0) Right(1))
RepeatDisplayGraphicObject
	lda Object_R
	sta Object_Z
.(
loop1	jsr DisplayGraphicObject
	ldx Object_V
	clc
	lda Object_D
	bne skip2
	lda Object_Y
	adc Object_Height,x
	sta Object_Y
	jmp skip1
skip2	lda Object_X
	adc Object_Width,x
	sta Object_X
skip1	dec Object_Z
	bne loop1
.)
	rts
	
	
	

;Object_X
;Object_Y
;Object_V
DisplayGraphicObjectBG
	lda Object_Y
	jsr CalcBGBufferRowAddress
	adc Object_X
	sta screen
	tya
	adc #00
	sta screen+1

	ldy Object_V
	jmp DisplayObjectRent1	
 	


;Object_X
;Object_Y
;Object_V
DisplayGraphicObject
	ldy Object_Y
	lda Object_X
	jsr RecalcScreen
	ldy Object_V
	jmp DisplayObjectRent1
	
;Used by PlotRoom Room Data
;Direction(0-1),Repeats(0-199),X(1-39),Y(0-199),ObjectID
;x,y,o,d,r
DisplayRepeatedObjectBG
	;Fetch X
	lda (room),y
	sta Object_X
	;Fetch Y
	iny
	lda (room),y
	sta Object_Y
	;Fetch ObjectID
	iny
	lda (room),y
	sta Object_V
	;Fetch Direction
	iny
	lda (room),y
	sta Object_D
	;Fetch Repeats
	iny
	lda (room),y
	sta Object_R
	jmp RepeatDisplayGraphicObjectBG
	
DisplayRepeatedObject
	;Fetch X
	lda (room),y
	sta Object_X
	;Fetch Y
	iny
	lda (room),y
	sta Object_Y
	;Fetch ObjectID
	iny
	lda (room),y
	sta Object_V
	;Fetch Direction
	iny
	lda (room),y
	sta Object_D
	;Fetch Repeats
	iny
	lda (room),y
	sta Object_R
	jmp RepeatDisplayGraphicObject
	
;Used by PlotRoom Room Data
DisplayObject
	;Fetch X
	lda (room),y
	pha
	;Fetch Y
	iny
	lda (room),y
	tax
	pla
	clc
	
	sty TempRoomIndex
.(
	stx vector1+1
vector1	ldy #00
.)
	jsr RecalcScreen
	ldy TempRoomIndex

	;Now fetch object graphic address
	iny
	lda (room),y
	tay
	jmp DisplayObjectRent1

;Used by PlotRoom Room Data
DisplayObjectBG
	;Fetch X
	lda (room),y
.(
	sta vector2+1
	;Fetch Y
	iny
	lda (room),y
	sty vector1+1
	jsr CalcBGBufferRowAddress
vector2	adc #00
	sta screen
	tya
	adc #00
	sta screen+1
vector1	ldy #00
.)	
	;Now fetch object graphic address
	iny
	lda (room),y
	tay
DisplayObjectRent1
	ldx Object_Height,y
	lda Object_AddressLo,y
	sta source
	lda Object_AddressHi,y
	sta source+1
	lda Object_Width,y
;DisplayRent2
	sta TempWidth
.(	
loop2	ldy TempWidth
	dey
loop1	lda (source),y
	sta (screen),y
	dey
	bpl loop1
	lda TempWidth
	jsr AddSource
	jsr nl_screen
	dex
	bne loop2
.)
	rts
	
	

Object_Width
 .byt 2	;00 Object_TLSimonBorder  
 .byt 1   ;01 Object_TSimonBorder   
 .byt 2   ;02 Object_TRSimonBorder  
 .byt 2   ;03 Object_LSimonBorder   
 .byt 2   ;04 Object_RSimonBorder   
 .byt 2   ;05 Object_BLSimonBorder  
 .byt 1   ;06 Object_BSimonBorder
 .byt 2   ;07 Object_BRSimonBorder  
 .byt 2   ;08 Object_SimonBlackCell 
 .byt 2   ;09 Object_SimonWhiteCell 
 .byt 2   ;10 Object_SimonBlackCross
 .byt 2   ;11 Object_SimonWhiteCross
 .byt 4   ;12 Object_SimonBottomPipe
 .byt 4	;13 DroidSpark00
 .byt 4	;14 DroidSpark01
 .byt 4	;15 DroidSpark02
 .byt 4	;16 DroidSpark03
 .byt 4	;17 ShaftGFX
 .byt 1	;18 PlatformGFX
 .byt 4	;19 LiftPlatformGFX
 .byt 1	;20 WallGFX
 .byt 6	;21 MainShaftLiftGFX
 .byt 9	;22 MainShaftCorridor
 .byt 1	;23 EntranceGFX
 .byt 3	;24 SearchFoundResetLiftGFX
 .byt 3	;25 SearchFoundSnoozeDroidGFX
 .byt 7	;26 SearchWindowGFX
 .byt 4	;27 PuzzlePiece00
 .byt 4	;28 PuzzlePiece01
 .byt 4	;29 PuzzlePiece02
 .byt 4	;30 PuzzlePiece03
 .byt 4	;31 PuzzlePiece04
 .byt 4	;32 PuzzlePiece05
 .byt 4	;33 PuzzlePiece06
 .byt 4	;34 PuzzlePiece07
 .byt 4	;35 PuzzlePiece08
 .byt 4	;36 PuzzlePiece09
 .byt 4	;37 PuzzlePiece10
 .byt 4	;38 PuzzlePiece11
 .byt 4	;39 PuzzlePiece12
 .byt 4	;40 PuzzlePiece13
 .byt 4	;41 PuzzlePiece14
 .byt 4	;42 PuzzlePiece15
 .byt 4	;43 PuzzlePiece16
 .byt 4	;44 PuzzlePiece17
 .byt 4	;45 PuzzlePiece18
 .byt 4	;46 PuzzlePiece19
 .byt 4	;47 PuzzlePiece20
 .byt 4	;48 PuzzlePiece21
 .byt 4	;49 PuzzlePiece22
 .byt 4	;50 PuzzlePiece23
 .byt 4	;51 PuzzlePiece24
 .byt 4	;52 PuzzlePiece25
 .byt 4	;53 PuzzlePiece26
 .byt 4	;54 PuzzlePiece27
 .byt 1	;55 SHM_NONEXISTANT
 .byt 1	;56 shm_Room
 .byt 1	;57 shm_Shaft
 .byt 1	;58 shm_ShaftTL
 .byt 1	;59 shm_ShaftTR
 .byt 1	;60 shm_ShaftBL
 .byt 1	;61 shm_ShaftBR
 .byt 1	;62 shm_ShaftTLTR
 .byt 1	;63 shm_ShaftTLBR
 .byt 1	;64 shm_ShaftBLTR
 .byt 1	;65 shm_ShaftBLBR
 .byt 15	;66 shm_Template
 .byt 4	;67 MAINSHAFTLIFTCABLES
 .byt 1	;68 ColourAttributeYellowCyan
 .byt 2	;69 mon_part0 2x7
 .byt 1	;70 mon_part1 1x6
 .byt 2	;71 mon_part2 2x7
 .byt 1	;72 mon_part3 1x6
 .byt 1	;73 mon_part4 1x5
 .byt 1	;74 mon_part5 1x6
 .byt 1	;75 mon_part6 1x6
 .byt 2	;76 mon_part7 2x6
 .byt 1	;77 mon_part8 1x5
 .byt 2	;78 mon_part9 2x6
 .byt 2	;79 mon_part10 2x7
 .byt 1	;80 mon_part11 1x6
 .byt 3	;81 mon_part12 3x3
 .byt 1	;82 mon_part13 1x6
 .byt 3	;83 mon_part14 3x3
 .byt 1	;84 mon_part15 1x6
 .byt 1	;85 mon_part16 1x2
 .byt 1	;86 mon_part17 1x2
 .byt 1	;87 mon_part18 1x2
 .byt 4	;88 NormalButton00 2x12 (Power)
 .byt 4	;89 NormalButton01 2x12 (Flip)
 .byt 4	;90 NormalButton02 2x12 (Mirror)
 .byt 4	;91 NormalButton03 2x12 (Delete)
 .byt 4	;92 NormalButton04 2x12 (Merge)
 .byt 4	;93 NormalButton05 2x12 (Red)
 .byt 4	;94 NormalButton06 2x12 (Green)
 .byt 4	;95 NormalButton07 2x12 (White)
 .byt 4	;96 NormalButton08 2x12 (Modem)
 .byt 4	;97 NormalButton09 2x12 (Speaker)
 .byt 4	;98 NormalButton10 2x12 (Joystick)
 .byt 4	;99 NormalButton11 2x12 (Pause)
 .byt 4	;100 HighlightedButton00 2x12 (Power)   
 .byt 4	;101 HighlightedButton01 2x12 (Flip)    
 .byt 4	;102 HighlightedButton02 2x12 (Mirror)  
 .byt 4	;103 HighlightedButton03 2x12 (Delete)  
 .byt 4	;104 HighlightedButton04 2x12 (Merge)   
 .byt 4	;105 HighlightedButton05 2x12 (Red)     
 .byt 4	;106 HighlightedButton06 2x12 (Green)   
 .byt 4	;107 HighlightedButton07 2x12 (White)   
 .byt 4	;108 HighlightedButton08 2x12 (Modem)   
 .byt 4	;109 HighlightedButton09 2x12 (Speaker) 
 .byt 4	;110 HighlightedButton10 2x12 (Joystick)
 .byt 4	;111 HighlightedButton11 2x12 (Pause)   
 .byt 6	;112 PuzzleCursorHorizontal 6x1
 .byt 1	;113 PuzzleCursorVertical 1x10
 .byt 2	;114 PuzzleMemoryArrowUp 2x3
 .byt 2	;115 PuzzleMemoryArrowDown 2x3
 .byt 6	;116 PuzzleCursorDeletedHorizontalTop 6x1
 .byt 1	;117 PuzzleCursorDeletedVertical 1x10
 .byt 2	;118 PuzzleMemoryDeletedArrowUp 2x3
 .byt 2	;119 PuzzleMemoryDeletedArrowDown 2x3
 .byt 6	;120 PuzzleCursorDeletedHorizontalBottom
 .byt 4	;121 VoidPuzzlePiece
 .byt 3	;122 00 GFX_Terminal		
 .byt 7	;123 01 GFX_Sofa		
 .byt 8	;124 02 GFX_Fireplace           
 .byt 3	;125 03 GFX_Toilet              
 .byt 3	;126 04 GFX_Drawers             
 .byt 3	;127 05 GFX_Armchair            
 .byt 7	;128 06 GFX_Desk                
 .byt 7	;129 07 GFX_Bed          
 .byt 4	;130 08 GFX_Sink         
 .byt 6	;131 09 GFX_Bath         
 .byt 5	;132 10 GFX_Bookcase     
 .byt 5	;133 11 GFX_Candy        
 .byt 2	;134 12 GFX_Speaker      
 .byt 3	;135 13 GFX_Hifi         
 .byt 4	;136 14 GFX_Lamp         
 .byt 4	;137 15 GFX_Computer     
 .byt 5	;138 16 GFX_Tapestreamer 
 .byt 3	;139 17 GFX_Harddisk     
 .byt 3	;140 18 GFX_Harddisk2    
 .byt 3	;141 19 GFX_Basket
 .byt 7   ;142 20 GFX_FagDispenser             
 .byt 5   ;143 21 GFX_Telex                    
 .byt 5   ;144 22 GFX_Fridge
 .byt 7   ;145 23 GFX_Doorway                  
 .byt 8   ;146 24 GFX_SimonConsole             
 .byt 3   ;147 25 GFX_Picture 
 .byt 7   ;148 26 GFX_Sideboard
 .byt 0   ;149 27
 .byt 0   ;150 28            
 .byt 0   ;151 29            
 .byt 0   ;152 30            
 .byt 0   ;153 31            
 .byt 7	;154 32 GFX_SearchingBar
 .byt 1	;155 Mor_Room
 .byt 1	;156 Mor_ControlRoom
 .byt 1	;157 Mor_Blank
 .byt 1	;158 Mor_Shaft
 .byt 1	;159 Mor_Sh_TR
 .byt 1	;160 Mor_Sh_TL
 .byt 1	;161 Mor_Sh_TLTR
 .byt 1	;162 Mor_Sh_BR
 .byt 1	;163 Mor_Sh_BRTL
 .byt 1	;164 Mor_Sh_BL
 .byt 1	;165 Mor_Sh_BLTR
 .byt 1	;166 Mor_Sh_BLBR
 .byt 15	;167 Mor_Template
 .byt 2	;168 Object_SimonBlackCursor
 .byt 2	;169 Object_SimonWhiteCursor
 .byt 4	;170 Object_WorkPuzzlePieceGraphic
 .byt 5	;171 SpeechAargh
 .byt 7	;172 GFX_DoorwayOpening0
 .byt 7	;173 GFX_DoorwayOpening1
 .byt 7	;174 GFX_DoorwayOpening2
 .byt 1	;175 Mor_SimonRoom
Object_Height
 .byt 4 	;Object_TLSimonBorder  
 .byt 4   ;Object_TSimonBorder   
 .byt 4   ;Object_TRSimonBorder  
 .byt 2   ;Object_LSimonBorder   
 .byt 2   ;Object_RSimonBorder   
 .byt 4   ;Object_BLSimonBorder  
 .byt 4   ;Object_BSimonBorder   
 .byt 4   ;Object_BRSimonBorder  
 .byt 12  ;Object_SimonBlackCell 
 .byt 12  ;Object_SimonWhiteCell 
 .byt 12  ;Object_SimonBlackCross
 .byt 12  ;Object_SimonWhiteCross
 .byt 9   ;Object_SimonBottomPipe
 .byt 7	;DroidSpark00
 .byt 7	;DroidSpark01
 .byt 7	;DroidSpark02
 .byt 7	;DroidSpark03
 .byt 6	;ShaftGFX
 .byt 5	;PlatformGFX
 .byt 5	;LiftPlatformGFX
 .byt 4	;WallGFX
 .byt 45	;MainShaftLiftGFX
 .byt 38	;MainShaftCorridor
 .byt 6	;EntranceGFX
 .byt 8	;SearchFoundResetLiftGFX
 .byt 8	;SearchFoundSnoozeDroidGFX
 .byt 8	;SearchWindowGFX
 .byt 8	;PuzzlePiece00
 .byt 8	;PuzzlePiece01
 .byt 8	;PuzzlePiece02
 .byt 8	;PuzzlePiece03
 .byt 8	;PuzzlePiece04
 .byt 8	;PuzzlePiece05
 .byt 8	;PuzzlePiece06
 .byt 8	;PuzzlePiece07
 .byt 8	;PuzzlePiece08
 .byt 8	;PuzzlePiece09
 .byt 8	;PuzzlePiece10
 .byt 8	;PuzzlePiece11
 .byt 8	;PuzzlePiece12
 .byt 8	;PuzzlePiece13
 .byt 8	;PuzzlePiece14
 .byt 8	;PuzzlePiece15
 .byt 8	;PuzzlePiece16
 .byt 8	;PuzzlePiece17
 .byt 8	;PuzzlePiece18
 .byt 8	;PuzzlePiece19
 .byt 8	;PuzzlePiece20
 .byt 8	;PuzzlePiece21
 .byt 8	;PuzzlePiece22
 .byt 8	;PuzzlePiece23
 .byt 8	;PuzzlePiece24
 .byt 8	;PuzzlePiece25
 .byt 8	;PuzzlePiece26
 .byt 8	;PuzzlePiece27
 .byt 5	;SHM_NONEXISTANT
 .byt 5	;shm_Room
 .byt 5	;shm_Shaft
 .byt 5	;shm_ShaftTL
 .byt 5	;shm_ShaftTR
 .byt 5	;shm_ShaftBL
 .byt 5	;shm_ShaftBR
 .byt 5	;shm_ShaftTLTR
 .byt 5	;shm_ShaftTLBR
 .byt 5	;shm_ShaftBLTR
 .byt 5	;shm_ShaftBLBR
 .byt 1	;shm_Template
 .byt 2	;MAINSHAFTLIFTCABLES
 .byt 2	;ColourAttributeYellowCyan
 .byt 7	;mon_part0 2x7
 .byt 6	;mon_part1 1x6
 .byt 7	;mon_part2 2x7
 .byt 6	;mon_part3 1x6
 .byt 5	;mon_part4 1x5
 .byt 6	;mon_part5 1x6
 .byt 6	;mon_part6 1x6
 .byt 6	;mon_part7 2x6
 .byt 6	;mon_part8 1x5
 .byt 6	;mon_part9 2x6
 .byt 9	;mon_part10 2x7
 .byt 6	;mon_part11 1x6
 .byt 3	;mon_part12 3x3
 .byt 6	;mon_part13 1x6
 .byt 3	;mon_part14 3x3
 .byt 6	;mon_part15 1x6
 .byt 2	;mon_part16 1x2
 .byt 2	;mon_part17 1x2
 .byt 2	;mon_part18 1x2
 .byt 15	;NormalButton00 2x12
 .byt 15	;NormalButton01 2x12
 .byt 15	;NormalButton02 2x12
 .byt 15	;NormalButton03 2x12
 .byt 15	;NormalButton04 2x12
 .byt 15	;NormalButton05 2x12
 .byt 15	;NormalButton06 2x12
 .byt 15	;NormalButton07 2x12
 .byt 15	;NormalButton08 2x12
 .byt 15	;NormalButton09 2x12
 .byt 15	;NormalButton10 2x12
 .byt 15	;NormalButton11 2x12
 .byt 15	;HighlightedButton00 2x12
 .byt 15	;HighlightedButton01 2x12
 .byt 15	;HighlightedButton02 2x12
 .byt 15	;HighlightedButton03 2x12
 .byt 15	;HighlightedButton04 2x12
 .byt 15	;HighlightedButton05 2x12
 .byt 15	;HighlightedButton06 2x12
 .byt 15	;HighlightedButton07 2x12
 .byt 15	;HighlightedButton08 2x12
 .byt 15	;HighlightedButton09 2x12
 .byt 15	;HighlightedButton10 2x12
 .byt 15	;HighlightedButton11 2x12
 .byt 1	;PuzzleCursorHorizontal 6x1
 .byt 10	;PuzzleCursorVertical 1x10
 .byt 3	;PuzzleMemoryArrowUp 2x3
 .byt 3	;PuzzleMemoryArrowDown 2x3
 .byt 1	;PuzzleCursorDeletedHorizontalTop 6x1
 .byt 10	;PuzzleCursorDeletedVertical 1x10
 .byt 3	;PuzzleMemoryDeletedArrowUp 2x3
 .byt 3	;PuzzleMemoryDeletedArrowDown 2x3
 .byt 1	;PuzzleCursorDeletedHorizontalBottom
 .byt 8	;VoidPuzzlePiece
 .byt 20	;00 GFX_Terminal		
 .byt 16	;01 GFX_Sofa		
 .byt 21	;02 GFX_Fireplace           
 .byt 24	;03 GFX_Toilet              
 .byt 18	;04 GFX_Drawers             
 .byt 25	;05 GFX_Armchair            
 .byt 17	;06 GFX_Desk                
 .byt 10 	;07 GFX_Bed          
 .byt 24	;08 GFX_Sink         
 .byt 25	;09 GFX_Bath         
 .byt 30	;10 GFX_Bookcase     
 .byt 26	;11 GFX_Candy
 .byt 12	;12 GFX_Speaker      
 .byt 19	;13 GFX_Hifi         
 .byt 23	;14 GFX_Lamp         
 .byt 20	;15 GFX_Computer     
 .byt 24	;16 GFX_Tapestreamer 
 .byt 17	;17 GFX_Harddisk     
 .byt 17	;18 GFX_Harddisk2    
 .byt 8	;19 GFX_Basket
 .byt 24  ;20 GFX_FagDispenser             
 .byt 21  ;21 GFX_Telex                    
 .byt 21  ;22 GFX_Fridge
 .byt 31  ;23 GFX_Doorway                  
 .byt 23  ;24 GFX_SimonConsole             
 .byt 14  ;25 GFX_Picture
 .byt 19  ;26 GFX_Sideboard
 .byt 0   ;27            
 .byt 0   ;28            
 .byt 0   ;29            
 .byt 0   ;30            
 .byt 0   ;31            
 .byt 10	;32 GFX_SearchingBar
 .byt 5	;155 Mor_Room
 .byt 5	;156 Mor_ControlRoom
 .byt 5	;157 Mor_Blank
 .byt 5	;158 Mor_Shaft
 .byt 5	;159 Mor_Sh_TR
 .byt 5	;160 Mor_Sh_TL
 .byt 5	;161 Mor_Sh_TLTR
 .byt 5	;162 Mor_Sh_BR
 .byt 5	;163 Mor_Sh_BRTL
 .byt 5	;164 Mor_Sh_BL
 .byt 5	;165 Mor_Sh_BLTR
 .byt 5	;166 Mor_Sh_BLBR
 .byt 1	;167 Mor_Template
 .byt 12	;168 Object_SimonBlackCursor
 .byt 12	;169 Object_SimonWhiteCursor
 .byt 8	;170 Object_WorkPuzzlePieceGraphic
 .byt 12	;171 SpeechAargh
 .byt 31	;172 GFX_DoorwayOpening0
 .byt 31	;173 GFX_DoorwayOpening1
 .byt 31	;174 GFX_DoorwayOpening2
 .byt 5	;175 Mor_SimonRoom


Object_AddressLo
 .byt <Object_TLSimonBorder 
 .byt <Object_TSimonBorder  
 .byt <Object_TRSimonBorder 
 .byt <Object_LSimonBorder  
 .byt <Object_RSimonBorder  
 .byt <Object_BLSimonBorder 
 .byt <Object_BSimonBorder  
 .byt <Object_BRSimonBorder 
 .byt <Object_SimonBlackCell
 .byt <Object_SimonWhiteCell
 .byt <Object_SimonBlackCross
 .byt <Object_SimonWhiteCross
 .byt <Object_SimonBottomPipe
 .byt <DroidSpark00
 .byt <DroidSpark01
 .byt <DroidSpark02
 .byt <DroidSpark03
 .byt <ShaftGFX
 .byt <PlatformGFX
 .byt <LiftPlatformGFX
 .byt <WallGFX
 .byt <MainShaftLiftGFX	;6x43 
 .byt <MainShaftCorridor	;9x38
 .byt <EntranceGFX
 .byt <SearchFoundResetLiftGFX
 .byt <SearchFoundSnoozeDroidGFX
 .byt <SearchWindowGFX
 .byt <PuzzlePiece00
 .byt <PuzzlePiece01
 .byt <PuzzlePiece02
 .byt <PuzzlePiece03
 .byt <PuzzlePiece04
 .byt <PuzzlePiece05
 .byt <PuzzlePiece06
 .byt <PuzzlePiece07
 .byt <PuzzlePiece08
 .byt <PuzzlePiece09
 .byt <PuzzlePiece10
 .byt <PuzzlePiece11
 .byt <PuzzlePiece12
 .byt <PuzzlePiece13
 .byt <PuzzlePiece14
 .byt <PuzzlePiece15
 .byt <PuzzlePiece16
 .byt <PuzzlePiece17
 .byt <PuzzlePiece18
 .byt <PuzzlePiece19
 .byt <PuzzlePiece20
 .byt <PuzzlePiece21
 .byt <PuzzlePiece22
 .byt <PuzzlePiece23
 .byt <PuzzlePiece24
 .byt <PuzzlePiece25
 .byt <PuzzlePiece26
 .byt <PuzzlePiece27
 .byt <shm_NonExistant
 .byt <shm_Room
 .byt <shm_Shaft
 .byt <shm_ShaftTL
 .byt <shm_ShaftTR
 .byt <shm_ShaftBL
 .byt <shm_ShaftBR
 .byt <shm_ShaftTLTR
 .byt <shm_ShaftTLBR
 .byt <shm_ShaftBLTR
 .byt <shm_ShaftBLBR
 .byt <shm_Template
 .byt <MainShaftLiftCables
 .byt <ColourAttributeYellowCyan
 .byt <mon_part0
 .byt <mon_part1
 .byt <mon_part2
 .byt <mon_part3
 .byt <mon_part4
 .byt <mon_part5
 .byt <mon_part6
 .byt <mon_part7
 .byt <mon_part8
 .byt <mon_part9
 .byt <mon_part10
 .byt <mon_part11
 .byt <mon_part12
 .byt <mon_part13
 .byt <mon_part14
 .byt <mon_part15
 .byt <mon_part16
 .byt <mon_part17
 .byt <mon_part18
 .byt 0	;<gfx_UpPower
 .byt 0	;<gfx_UpFlip
 .byt 0	;<gfx_UpMirror
 .byt 0	;<gfx_UpUndo
 .byt 0	;<gfx_UpDisk
 .byt 0	;<gfx_UpYellow
 .byt 0	;<gfx_UpGreen
 .byt 0	;<gfx_UpWhite
 .byt 0	;<gfx_UpModem
 .byt 0	;<gfx_UpSound
 .byt 0	;<gfx_UpStats
 .byt 0	;<gfx_UpPause
 .byt <gfx_DownPower
 .byt <gfx_DownFlip
 .byt <gfx_DownMirror
 .byt <gfx_DownUndo
 .byt <gfx_DownDisk
 .byt <gfx_DownYellow
 .byt <gfx_DownGreen
 .byt <gfx_DownWhite
 .byt <gfx_DownModem
 .byt <gfx_DownSound
 .byt <gfx_DownStats
 .byt <gfx_DownPause
 .byt <PuzzleCursorHorizontal	;6x1
 .byt <PuzzleCursorVertical	;1x10
 .byt <PuzzleMemoryArrowUp	;2x3
 .byt <PuzzleMemoryArrowDown	;2x3
 .byt <PuzzleCursorDeletedHorizontalTop	;6x1
 .byt <PuzzleCursorDeletedVertical	;1x10
 .byt <PuzzleMemoryDeletedArrowUp 	;2x3
 .byt <PuzzleMemoryDeletedArrowDown 	;2x3
 .byt <PuzzleCursorDeletedHorizontalBottom
 .byt <VoidPuzzlePiece
 .byt <GFX_Terminal		;00
 .byt <GFX_Sofa		;01
 .byt <GFX_Fireplace          ;02
 .byt <GFX_Toilet             ;03 
 .byt <GFX_Drawers            ;04 
 .byt <GFX_Armchair           ;05 
 .byt <GFX_Desk               ;06 
 .byt <GFX_Bed                ;07 
 .byt <GFX_Sink               ;08 
 .byt <GFX_Bath               ;09 
 .byt <GFX_Bookcase           ;10 
 .byt <GFX_Candy              ;11 
 .byt <GFX_Speaker            ;12 
 .byt <GFX_Hifi               ;13 
 .byt <GFX_Lamp               ;14 
 .byt <GFX_Computer       	;15 
 .byt <GFX_Tapestreamer       ;16 
 .byt <GFX_Harddisk           ;17
 .byt <GFX_Harddisk2	;18
 .byt <GFX_Basket		;19
 .byt <GFX_FagDispenser       ;20
 .byt <GFX_Telex              ;21
 .byt <GFX_Fridge             ;22
 .byt <GFX_Doorway            ;23
 .byt <GFX_SimonConsole       ;24
 .byt 0			;<GFX_Picture            ;25
 .byt <GFX_Sideboard          ;26
 .byt 0			;27
 .byt 0                       ;28
 .byt 0                       ;29
 .byt 0                       ;30
 .byt 0                       ;31
 .byt <GFX_SearchingBar       ;32
 .byt <Mor_Room
 .byt <Mor_ControlRoom
 .byt <Mor_Blank
 .byt <Mor_Shaft
 .byt <Mor_Sh_TR
 .byt <Mor_Sh_TL
 .byt <Mor_Sh_TLTR
 .byt <Mor_Sh_BR
 .byt <Mor_Sh_BRTL
 .byt <Mor_Sh_BL
 .byt <Mor_Sh_BLTR
 .byt <Mor_Sh_BLBR
 .byt <Mor_Template
 .byt <Object_SimonBlackCursor
 .byt <Object_SimonWhiteCursor
 .byt <Object_WorkPuzzlePieceGraphic
 .byt <SpeechAargh
 .byt <GFX_DoorwayOpening0
 .byt <GFX_DoorwayOpening1
 .byt <GFX_DoorwayOpening2
 .byt <Mor_SimonRoom

Object_AddressHi
 .byt >Object_TLSimonBorder 
 .byt >Object_TSimonBorder  
 .byt >Object_TRSimonBorder 
 .byt >Object_LSimonBorder  
 .byt >Object_RSimonBorder  
 .byt >Object_BLSimonBorder 
 .byt >Object_BSimonBorder  
 .byt >Object_BRSimonBorder 
 .byt >Object_SimonBlackCell
 .byt >Object_SimonWhiteCell
 .byt >Object_SimonBlackCross
 .byt >Object_SimonWhiteCross
 .byt >Object_SimonBottomPipe
 .byt >DroidSpark00
 .byt >DroidSpark01
 .byt >DroidSpark02
 .byt >DroidSpark03
 .byt >ShaftGFX
 .byt >PlatformGFX
 .byt >LiftPlatformGFX
 .byt >WallGFX
 .byt >MainShaftLiftGFX	;6x43 
 .byt >MainShaftCorridor	;9x38
 .byt >EntranceGFX
 .byt >SearchFoundResetLiftGFX
 .byt >SearchFoundSnoozeDroidGFX
 .byt >SearchWindowGFX
 .byt >PuzzlePiece00
 .byt >PuzzlePiece01
 .byt >PuzzlePiece02
 .byt >PuzzlePiece03
 .byt >PuzzlePiece04
 .byt >PuzzlePiece05
 .byt >PuzzlePiece06
 .byt >PuzzlePiece07
 .byt >PuzzlePiece08
 .byt >PuzzlePiece09
 .byt >PuzzlePiece10
 .byt >PuzzlePiece11
 .byt >PuzzlePiece12
 .byt >PuzzlePiece13
 .byt >PuzzlePiece14
 .byt >PuzzlePiece15
 .byt >PuzzlePiece16
 .byt >PuzzlePiece17
 .byt >PuzzlePiece18
 .byt >PuzzlePiece19
 .byt >PuzzlePiece20
 .byt >PuzzlePiece21
 .byt >PuzzlePiece22
 .byt >PuzzlePiece23
 .byt >PuzzlePiece24
 .byt >PuzzlePiece25
 .byt >PuzzlePiece26
 .byt >PuzzlePiece27
 .byt >shm_NonExistant
 .byt >shm_Room
 .byt >shm_Shaft
 .byt >shm_ShaftTL
 .byt >shm_ShaftTR
 .byt >shm_ShaftBL
 .byt >shm_ShaftBR
 .byt >shm_ShaftTLTR
 .byt >shm_ShaftTLBR
 .byt >shm_ShaftBLTR
 .byt >shm_ShaftBLBR
 .byt >shm_Template
 .byt >MainShaftLiftCables
 .byt >ColourAttributeYellowCyan
 .byt >mon_part0
 .byt >mon_part1
 .byt >mon_part2
 .byt >mon_part3
 .byt >mon_part4
 .byt >mon_part5
 .byt >mon_part6
 .byt >mon_part7
 .byt >mon_part8
 .byt >mon_part9
 .byt >mon_part10
 .byt >mon_part11
 .byt >mon_part12
 .byt >mon_part13
 .byt >mon_part14
 .byt >mon_part15
 .byt >mon_part16
 .byt >mon_part17
 .byt >mon_part18
 .byt 0	;>gfx_UpPower
 .byt 0	;>gfx_UpFlip
 .byt 0	;>gfx_UpMirror
 .byt 0	;>gfx_UpUndo
 .byt 0	;>gfx_UpDisk
 .byt 0	;>gfx_UpYellow
 .byt 0	;>gfx_UpGreen
 .byt 0	;>gfx_UpWhite
 .byt 0	;>gfx_UpModem
 .byt 0	;>gfx_UpSound
 .byt 0	;>gfx_UpStats
 .byt 0	;>gfx_UpPause
 .byt >gfx_DownPower
 .byt >gfx_DownFlip
 .byt >gfx_DownMirror
 .byt >gfx_DownUndo
 .byt >gfx_DownDisk
 .byt >gfx_DownYellow
 .byt >gfx_DownGreen
 .byt >gfx_DownWhite
 .byt >gfx_DownModem
 .byt >gfx_DownSound
 .byt >gfx_DownStats
 .byt >gfx_DownPause
 .byt >PuzzleCursorHorizontal	;6x1
 .byt >PuzzleCursorVertical	;1x10
 .byt >PuzzleMemoryArrowUp	;2x3
 .byt >PuzzleMemoryArrowDown	;2x3
 .byt >PuzzleCursorDeletedHorizontalTop	;6x1
 .byt >PuzzleCursorDeletedVertical	;1x10
 .byt >PuzzleMemoryDeletedArrowUp 	;2x3
 .byt >PuzzleMemoryDeletedArrowDown 	;2x3
 .byt >PuzzleCursorDeletedHorizontalBottom
 .byt >VoidPuzzlePiece
 .byt >GFX_Terminal		;00
 .byt >GFX_Sofa		;01
 .byt >GFX_Fireplace          ;02
 .byt >GFX_Toilet             ;03 
 .byt >GFX_Drawers            ;04 
 .byt >GFX_Armchair           ;05 
 .byt >GFX_Desk               ;06 
 .byt >GFX_Bed                ;07 
 .byt >GFX_Sink               ;08 
 .byt >GFX_Bath               ;09 
 .byt >GFX_Bookcase           ;10 
 .byt >GFX_Candy              ;11 
 .byt >GFX_Speaker            ;12 
 .byt >GFX_Hifi               ;13 
 .byt >GFX_Lamp               ;14 
 .byt >GFX_Computer       	;15 
 .byt >GFX_Tapestreamer       ;16 
 .byt >GFX_Harddisk           ;17
 .byt >GFX_Harddisk2	;18
 .byt >GFX_Basket             ;19
 .byt >GFX_FagDispenser       ;20
 .byt >GFX_Telex              ;21
 .byt >GFX_Fridge             ;22
 .byt >GFX_Doorway            ;23
 .byt >GFX_SimonConsole       ;24
 .byt 0			;>GFX_Picture            ;25
 .byt >GFX_Sideboard          ;26
 .byt 0			;27
 .byt 0                       ;28
 .byt 0                       ;29
 .byt 0                       ;30
 .byt 0                       ;31
 .byt >GFX_SearchingBar       ;32
 .byt >Mor_Room
 .byt >Mor_ControlRoom
 .byt >Mor_Blank
 .byt >Mor_Shaft
 .byt >Mor_Sh_TR
 .byt >Mor_Sh_TL
 .byt >Mor_Sh_TLTR
 .byt >Mor_Sh_BR
 .byt >Mor_Sh_BRTL
 .byt >Mor_Sh_BL
 .byt >Mor_Sh_BLTR
 .byt >Mor_Sh_BLBR
 .byt >Mor_Template
 .byt >Object_SimonBlackCursor
 .byt >Object_SimonWhiteCursor
 .byt >Object_WorkPuzzlePieceGraphic
 .byt >SpeechAargh
 .byt >GFX_DoorwayOpening0
 .byt >GFX_DoorwayOpening1
 .byt >GFX_DoorwayOpening2
 .byt >Mor_SimonRoom

Object_TLSimonBorder 
 .byt $55,$40
 .byt $6A,$FF
 .byt $54,$4F
 .byt $6A,$E3
Object_TSimonBorder  
 .byt $40
 .byt $FF
 .byt $7F
 .byt $FF
Object_TRSimonBorder 
 .byt $40,$55
 .byt $FF,$4A
 .byt $7C,$55
 .byt $F1,$4A
Object_LSimonBorder
 .byt $54,$5C
 .byt $6A,$E3
Object_RSimonBorder
 .byt $4E,$55
 .byt $F1,$4A
Object_BLSimonBorder 
 .byt $6A,$E3
 .byt $54,$4F
 .byt $6A,$FF
 .byt $55,$40
Object_BSimonBorder  
 .byt $FF
 .byt $7F
 .byt $FF
 .byt $40
Object_BRSimonBorder 
 .byt $F1,$4A
 .byt $7C,$55
 .byt $FF,$4A
 .byt $40,$55
Object_SimonBlackCell
 .byt $40,$40
 .byt $40,$40
 .byt $40,$40
 .byt $40,$40
 .byt $40,$40
 .byt $40,$40
 .byt $40,$40
 .byt $40,$40
 .byt $40,$40
 .byt $40,$40
 .byt $40,$40
 .byt $40,$40
Object_SimonWhiteCell
 .byt $C0,$C0
 .byt $C0,$C0
 .byt $C0,$C0
 .byt $C0,$C0
 .byt $C0,$C0
 .byt $C0,$C0
 .byt $C0,$C0
 .byt $C0,$C0
 .byt $C0,$C0
 .byt $C0,$C0
 .byt $C0,$C0
 .byt $C0,$C0
Object_SimonBlackCross
 .byt $40,$40        
 .byt $58,$46        
 .byt $E3,$F1        
 .byt $4E,$5C        
 .byt $F8,$C7        
 .byt $43,$70        
 .byt $FC,$CF        
 .byt $47,$78        
 .byt $F1,$E3        
 .byt $5C,$4E        
 .byt $E7,$F9        
 .byt $40,$40        
Object_SimonWhiteCross
 .byt $C0,$C0        
 .byt $D8,$C6        
 .byt $DC,$CE        
 .byt $CE,$DC        
 .byt $C7,$F8        
 .byt $C3,$F0        
 .byt $C3,$F0        
 .byt $C7,$F8        
 .byt $CE,$DC        
 .byt $DC,$CE        
 .byt $D8,$C6        
 .byt $C0,$C0        
Object_SimonBottomPipe
 .byt $6A,$7F,$7F,$4A
 .byt $54,$4E,$5C,$55
 .byt $6A,$66,$5A,$6A
 .byt $55,$E9,$E6,$55
 .byt $6A,$66,$5A,$6A
 .byt $55,$E9,$E6,$55
 .byt $6A,$66,$5A,$6A
 .byt $55,$E9,$E6,$55
 .byt $6A,$66,$5A,$6A

DroidSpark00	;4x7
 .byt $55,$55,$51,$45
 .byt $4A,$6A,$DF,$42
 .byt $45,$55,$44,$51
 .byt $DD,$62,$4A,$D7
 .byt $51,$40,$55,$54
 .byt $68,$F7,$6A,$6A
 .byt $54,$55,$55,$55
DroidSpark01
 .byt $55,$55,$55,$54
 .byt $DD,$6A,$6A,$F7
 .byt $41,$55,$44,$41
 .byt $48,$6A,$FF,$62
 .byt $54,$50,$51,$55
 .byt $6A,$FF,$6A,$6A
 .byt $55,$45,$55,$55
DroidSpark02
 .byt $55,$55,$55,$55
 .byt $F7,$6A,$6A,$DF
 .byt $40,$54,$55,$41
 .byt $62,$F7,$4A,$48
 .byt $55,$41,$44,$55
 .byt $6A,$62,$DF,$6A
 .byt $55,$55,$51,$55
DroidSpark03
 .byt $55,$54,$55,$55
 .byt $6A,$D7,$48,$6A
 .byt $55,$51,$40,$55
 .byt $62,$62,$DD,$4A
 .byt $41,$45,$55,$44
 .byt $F7,$4A,$6A,$DF
 .byt $54,$55,$55,$51
ShaftGFX
 .byt %01101010,%01101010,%01101010,%01101010
 .byt %01010101,%01010001,%01010001,%01010101
 .byt %01101010,%01101010,%01101010,%01101010
 .byt %01010101,%01010001,%01010001,%01010101
 .byt %01101010,%01101010,%01101010,%01101010
 .byt %01010101,%01010001,%01010001,%01010101
PlatformGFX
 .byt $40
 .byt $C0
 .byt $7F
 .byt $FF
 .byt $40
LiftPlatformGFX
 .byt $40,$40,$40,$40
 .byt %01011111,$C0,$C0,%01111110
 .byt %01001111,$FF,$FF,%01111100
 .byt $40,$40,$40,$40
 .byt $40,$40,$40,$40
WallGFX
 .byt $D0
 .byt $DE
 .byt $C2
 .byt $DE
MainShaftLiftGFX	;6x43 
 .byt $07,$43,$60,$41,$70,$03
 .byt $40,$F8,$DE,$DE,$C7,$40
 .byt $41,$FF,$41,$60,$FF,$60
 .byt $43,$40,$FC,$CF,$40,$70
 .byt $4F,$C3,$48,$42,$F0,$7C
 .byt $F3,$40,$40,$40,$40,$F3
 .byt $40,$4A,$6F,$7E,$6A,$40
 .byt $F3,$40,$40,$40,$40,$F3
 .byt $40,$4B,$6A,$6A,$7A,$40
 .byt $F3,$40,$40,$40,$40,$F3
 .byt $40,$4A,$6A,$6A,$6A,$40
 .byt $F3,$40,$40,$40,$40,$F3
 .byt $40,$4A,$6A,$6A,$6A,$40
 .byt $F3,$40,$40,$40,$40,$F3
 .byt $40,$4A,$6A,$6A,$6A,$40
 .byt $F3,$40,$40,$40,$40,$F3
 .byt $40,$4A,$C0,$6A,$6A,$40
 .byt $F3,$40,$D5,$60,$40,$F3
 .byt $40,$4A,$C0,$6A,$6A,$40
 .byt $F3,$40,$D5,$60,$40,$F3
 .byt $40,$4A,$C0,$6A,$6A,$40
 .byt $F3,$40,$D5,$60,$40,$F3
 .byt $40,$4A,$C0,$6A,$6A,$40
 .byt $F3,$40,$40,$40,$40,$F3
 .byt $40,$4A,$6A,$6A,$6A,$40
 .byt $F3,$40,$40,$40,$40,$F3
 .byt $40,$4A,$6A,$6A,$6A,$40
 .byt $F3,$40,$40,$40,$40,$F3
 .byt $40,$4A,$6A,$6A,$6A,$40
 .byt $F3,$40,$40,$40,$40,$F3
 .byt $40,$4A,$6A,$6A,$6A,$40
 .byt $F3,$40,$40,$40,$40,$F3
 .byt $40,$4A,$6A,$6A,$6A,$40
 .byt $F3,$40,$40,$40,$40,$F3
 .byt $40,$4A,$6A,$6A,$6A,$40
 .byt $F3,$40,$40,$40,$40,$F3
 .byt $40,$5F,$7F,$7F,$7E,$40
 .byt $F3,$40,$40,$40,$40,$F3
 .byt $F8,$C0,$C0,$C0,$C0,$C7
 .byt $42,$FF,$FF,$FF,$FF,$50
 .byt $40,$E0,$C0,$C0,$C1,$40
 .byt $40,$48,$FF,$FF,$44,$40
 .byt $40,$40,$E0,$C1,$40,$40
 .byt $40,$40,$40,$40,$40,$40
MainShaftLiftGFX2
 .byt $40,$02,$41,$60,$03,$40
MainShaftCorridor	;9x38
; .byt $40,$40,$40,$40,$40,$40,$40,$40,$40
; .byt $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
; .byt $D1,$D1,$D1,$D1,$D1,$D1,$D1,$D1,$D1
; .byt $C5,$C5,$C5,$C5,$C5,$C5,$C5,$C5,$C5
; .byt $C0,$C0,$CC,$C0,$C0,$C0,$CC,$C0,$C0
; .byt $40,$40,$4C,$40,$40,$40,$4C,$40,$40
; .byt $F3,$6A,$62,$6A,$F3,$6A,$62,$6A,$F3
; .byt $40,$59,$4D,$58,$40,$59,$4D,$58,$40
; .byt $F3,$6A,$5E,$6A,$F3,$6A,$5E,$6A,$F3
; .byt $40,$54,$FF,$54,$40,$54,$FF,$54,$40
; .byt $F3,$6A,$D5,$6A,$F3,$6A,$D5,$6A,$F3
; .byt $40,$55,$55,$54,$40,$55,$55,$54,$40
; .byt $F3,$D5,$D5,$D5,$F3,$D5,$6A,$D5,$F3
; .byt $40,$55,$55,$54,$40,$55,$55,$54,$40
; .byt $F3,$6A,$6A,$6A,$F3,$6A,$6A,$6A,$F3
; .byt $40,$55,$55,$54,$40,$55,$55,$54,$40
; .byt $F3,$6A,$D5,$6A,$F3,$6A,$6A,$6A,$F3
; .byt $40,$55,$55,$54,$40,$55,$55,$54,$40
; .byt $F3,$6A,$6A,$6A,$F3,$6A,$6A,$6A,$F3
; .byt $40,$55,$55,$54,$40,$55,$55,$54,$40
; .byt $F3,$6A,$6A,$6A,$F3,$6A,$6A,$6A,$F3
; .byt $40,$55,$55,$54,$40,$55,$55,$54,$40
; .byt $F3,$6A,$6A,$6A,$F3,$6A,$6A,$6A,$F3
; .byt $40,$55,$55,$54,$40,$55,$55,$54,$40
; .byt $F3,$6A,$6A,$6A,$F3,$6A,$6A,$6A,$F3
; .byt $40,$55,$55,$54,$40,$55,$55,$54,$40
; .byt $F3,$6A,$6A,$6A,$F3,$6A,$6A,$6A,$F3
; .byt $40,$55,$55,$54,$40,$55,$55,$54,$40
; .byt $F3,$6A,$6A,$6A,$F3,$6A,$6A,$6A,$F3
; .byt $40,$55,$55,$54,$40,$55,$55,$54,$40
; .byt $F3,$6A,$6A,$6A,$F3,$6A,$6A,$6A,$F3
; .byt $40,$59,$55,$58,$40,$59,$55,$58,$40
; .byt $F3,$6A,$6A,$6A,$F3,$6A,$6A,$6A,$F3
; .byt $40,$40,$40,$40,$40,$40,$40,$40,$40
; .byt $C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0
; .byt $7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F
; .byt $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
; .byt $40,$40,$40,$40,$40,$40,$40,$40,$40
EntranceGFX
 .byt %01010101
 .byt %01101010
 .byt %01010101
 .byt %01101010
 .byt %01010101
 .byt %01101010
SearchFoundResetLiftGFX
 .byt $54,$40,$55
 .byt $6A,$E1,$4A
 .byt $54,$F3,$55
 .byt $68,$40,$42
 .byt $53,$7F,$79
 .byt $69,$DF,$72
 .byt $54,$40,$45
 .byt $6A,$6A,$6A
SearchFoundSnoozeDroidGFX
 .byt $54,$40,$55
 .byt $6A,$C6,$4A
 .byt $54,$76,$55
 .byt $68,$FB,$4A
 .byt $54,$40,$45
 .byt $68,$FB,$4A
 .byt $54,$4A,$45
 .byt $6A,$60,$6A
SearchWindowGFX
 .byt $E0,$C0,$C0,$C0,$C0,$C0,$C7
 .byt $E6,$F9,$CE,$CD,$D5,$C9,$C3
 .byt $53,$4D,$54,$6E,$4A,$55,$7E
 .byt $E6,$E3,$EE,$D1,$D5,$DB,$E1
 .byt $53,$45,$54,$72,$6A,$76,$6A
 .byt $5F,$7F,$7F,$7F,$7F,$7F,$7E
SearchWindowBarLocationStart
 .byt $EF,$FF,$FF,$FF,$FF,$FF,$FD
 .byt $5F,$7F,$7F,$7F,$7F,$7F,$7E
PuzzlePiece00
 .byt $7C,$40,$40,$40
 .byt $67,$40,$40,$40
 .byt $7F,$7C,$40,$40
 .byt $40,$7F,$70,$40
 .byt $40,$43,$7F,$40
 .byt $40,$40,$4F,$7F
 .byt $40,$40,$40,$7F
 .byt $40,$40,$40,$4F
PuzzlePiece01
 .byt $43,$7F,$40,$40
 .byt $40,$7C,$40,$70
 .byt $40,$40,$41,$78
 .byt $40,$40,$41,$78
 .byt $40,$7C,$40,$70
 .byt $7B,$7F,$40,$40
 .byt $68,$40,$40,$40
 .byt $78,$40,$40,$40
PuzzlePiece02
 .byt $40,$40,$4F,$40
 .byt $40,$40,$49,$40
 .byt $40,$40,$4E,$47
 .byt $40,$40,$4E,$47
 .byt $40,$40,$40,$4F
 .byt $44,$40,$70,$40
 .byt $47,$7F,$70,$40
 .byt $47,$7F,$70,$40
PuzzlePiece03
 .byt $40,$40,$70,$7F
 .byt $40,$43,$70,$4F
 .byt $40,$43,$70,$40
 .byt $7F,$40,$40,$40
 .byt $7F,$40,$40,$40
 .byt $40,$40,$40,$40
 .byt $40,$40,$4F,$40
 .byt $40,$40,$4F,$70
PuzzlePiece04
 .byt $43,$40,$40,$7F
 .byt $46,$40,$40,$73
 .byt $4C,$40,$40,$7F
 .byt $58,$40,$40,$40
 .byt $72,$40,$40,$40
 .byt $67,$40,$40,$40
 .byt $4C,$60,$40,$40
 .byt $5F,$70,$40,$40
PuzzlePiece05
 .byt $7C,$40,$43,$40
 .byt $78,$40,$47,$40
 .byt $70,$40,$4F,$40
 .byt $60,$40,$5C,$4F
 .byt $40,$40,$78,$4F
 .byt $40,$41,$70,$4F
 .byt $40,$43,$60,$49
 .byt $40,$43,$40,$4F
PuzzlePiece06
 .byt $40,$40,$40,$40
 .byt $40,$40,$40,$40
 .byt $43,$78,$40,$40
 .byt $47,$78,$43,$40
 .byt $4D,$78,$47,$40
 .byt $58,$78,$4F,$40
 .byt $70,$58,$5F,$40
 .byt $60,$48,$7F,$40
PuzzlePiece07
 .byt $40,$7F,$7C,$40
 .byt $41,$7C,$78,$40
 .byt $40,$47,$70,$40
 .byt $40,$47,$60,$70
 .byt $40,$47,$40,$70
 .byt $40,$46,$40,$70
 .byt $40,$44,$40,$70
 .byt $40,$44,$40,$70
PuzzlePiece08
 .byt $7F,$70,$40,$40
 .byt $7F,$70,$40,$40
 .byt $40,$40,$43,$73
 .byt $40,$40,$43,$7F
 .byt $7F,$70,$40,$40
 .byt $79,$70,$40,$40
 .byt $40,$40,$43,$7F
 .byt $40,$40,$43,$7F
PuzzlePiece09
 .byt $40,$4C,$40,$40
 .byt $40,$4C,$40,$40
 .byt $73,$7C,$40,$40
 .byt $7F,$7C,$40,$40
 .byt $40,$4C,$40,$40
 .byt $40,$4C,$40,$40
 .byt $7F,$7C,$40,$40
 .byt $7F,$7C,$40,$40
PuzzlePiece10
 .byt $40,$43,$7F,$7F
 .byt $40,$43,$7F,$7F
 .byt $40,$42,$60,$40
 .byt $40,$43,$60,$40
 .byt $40,$43,$40,$40
 .byt $40,$43,$40,$40
 .byt $40,$42,$40,$40
 .byt $40,$42,$40,$40
PuzzlePiece11
 .byt $40,$40,$40,$40
 .byt $40,$40,$40,$40
 .byt $40,$40,$5C,$40
 .byt $40,$40,$5C,$40
 .byt $40,$40,$7F,$7F
 .byt $40,$40,$67,$7F
 .byt $40,$41,$7C,$40
 .byt $40,$41,$7C,$40
PuzzlePiece12
 .byt $40,$47,$40,$40
 .byt $40,$4F,$60,$40
 .byt $40,$59,$70,$40
 .byt $40,$7F,$78,$40
 .byt $40,$7E,$58,$40
 .byt $40,$5F,$70,$40
 .byt $40,$4F,$60,$40
 .byt $40,$47,$40,$40
PuzzlePiece13
 .byt $7F,$78,$40,$40
 .byt $59,$70,$40,$40
 .byt $4F,$60,$40,$40
 .byt $47,$40,$40,$40
 .byt $43,$40,$40,$40
 .byt $43,$60,$40,$40
 .byt $43,$70,$40,$40
 .byt $43,$78,$40,$40
PuzzlePiece14
 .byt $40,$40,$7F,$78
 .byt $60,$40,$5F,$70
 .byt $70,$40,$4F,$60
 .byt $78,$40,$47,$40
 .byt $7C,$40,$47,$60
 .byt $70,$40,$4F,$70
 .byt $7C,$40,$59,$78
 .byt $7C,$40,$7F,$7C
PuzzlePiece15
 .byt $40,$40,$40,$47
 .byt $40,$40,$40,$4F
 .byt $40,$40,$40,$5F
 .byt $40,$40,$40,$7F
 .byt $40,$40,$40,$5F
 .byt $40,$40,$40,$4F
 .byt $40,$40,$40,$47
 .byt $40,$40,$40,$43
PuzzlePiece16
 .byt $40,$40,$40,$40
 .byt $40,$40,$40,$7E
 .byt $44,$40,$40,$7E
 .byt $4E,$40,$40,$72
 .byt $5F,$40,$40,$5C
 .byt $53,$40,$40,$48
 .byt $5F,$40,$40,$40
 .byt $40,$40,$40,$40
PuzzlePiece17
 .byt $7F,$70,$40,$40
 .byt $7E,$50,$40,$40
 .byt $7B,$70,$40,$40
 .byt $71,$70,$40,$40
 .byt $60,$70,$40,$40
 .byt $60,$70,$40,$40
 .byt $60,$70,$40,$40
 .byt $7F,$70,$40,$40
PuzzlePiece18
 .byt $40,$4F,$7C,$40
 .byt $40,$47,$7C,$40
 .byt $40,$43,$64,$40
 .byt $40,$41,$7C,$40
 .byt $40,$40,$7C,$43
 .byt $40,$40,$5C,$47
 .byt $40,$40,$4C,$4F
 .byt $40,$40,$44,$4F
PuzzlePiece19
 .byt $40,$40,$43,$7F
 .byt $40,$48,$43,$41
 .byt $40,$4C,$43,$41
 .byt $40,$4E,$43,$41
 .byt $40,$4F,$43,$60
 .byt $40,$4F,$63,$70
 .byt $40,$4C,$73,$70
 .byt $40,$4F,$7B,$70
PuzzlePiece20
 .byt $40,$40,$40,$40
 .byt $4C,$73,$4C,$73
 .byt $5F,$7F,$7F,$7E
 .byt $73,$4C,$73,$4C
 .byt $40,$40,$40,$40
 .byt $40,$40,$40,$40
 .byt $40,$40,$40,$40
 .byt $40,$40,$40,$40
PuzzlePiece21
 .byt $7F,$7F,$7F,$7F
 .byt $73,$4C,$73,$4C
 .byt $60,$40,$40,$40
 .byt $40,$40,$40,$40
 .byt $40,$40,$40,$40
 .byt $40,$40,$40,$40
 .byt $40,$40,$40,$40
 .byt $40,$40,$40,$40
PuzzlePiece22
 .byt $40,$40,$40,$40
 .byt $40,$40,$40,$40
 .byt $40,$40,$40,$40
 .byt $4C,$70,$40,$40
 .byt $7F,$64,$40,$40
 .byt $7F,$7E,$40,$40
 .byt $67,$7F,$40,$40
 .byt $7F,$7F,$60,$40
PuzzlePiece23
 .byt $40,$40,$40,$40
 .byt $40,$40,$40,$40
 .byt $40,$40,$40,$41
 .byt $40,$43,$4C,$73
 .byt $40,$43,$7F,$7F
 .byt $40,$41,$7F,$67
 .byt $40,$40,$7F,$7F
 .byt $40,$40,$5F,$7F
PuzzlePiece24
 .byt $40,$40,$40,$40
 .byt $46,$40,$40,$40
 .byt $5F,$60,$40,$40
 .byt $73,$70,$40,$40
 .byt $5F,$60,$40,$40
 .byt $46,$40,$40,$40
 .byt $40,$40,$40,$40
 .byt $40,$40,$40,$40
PuzzlePiece25
 .byt $7F,$78,$40,$40
 .byt $79,$78,$40,$40
 .byt $60,$58,$40,$40
 .byt $40,$4F,$70,$40
 .byt $60,$59,$70,$40
 .byt $79,$7F,$70,$40
 .byt $7F,$78,$40,$40
 .byt $7F,$78,$40,$40
PuzzlePiece26
 .byt $40,$47,$7F,$7F
 .byt $40,$46,$5F,$73
 .byt $40,$47,$7F,$7F
 .byt $40,$40,$41,$7F
 .byt $40,$40,$40,$7F
 .byt $40,$40,$40,$5F
 .byt $40,$40,$40,$4F
 .byt $40,$40,$40,$47
PuzzlePiece27
 .byt $40,$40,$40,$40
 .byt $40,$40,$40,$40
 .byt $40,$40,$40,$40
 .byt $40,$40,$4E,$40
 .byt $40,$40,$4F,$40
 .byt $40,$40,$4F,$60
 .byt $40,$47,$79,$70
 .byt $40,$47,$7F,$78
shm_NonExistant
 .byt $C0
 .byt $C0
 .byt $C0
 .byt $C0
 .byt $C0
shm_Room
 .byt $7F-$7F+$C0
 .byt $40
 .byt $40
 .byt $40
 .byt $7F-$7F+$C0
shm_Shaft
 .byt $7F-$73+$C0
 .byt $7F-$73+$C0
 .byt $7F-$73+$C0
 .byt $7F-$73+$C0
 .byt $7F-$73+$C0
shm_ShaftTL
 .byt $7F-$73+$C0
 .byt $43
 .byt $7F-$73+$C0
 .byt $7F-$73+$C0
 .byt $7F-$73+$C0
shm_ShaftTR
 .byt $7F-$73+$C0
 .byt $70
 .byt $7F-$73+$C0
 .byt $7F-$73+$C0
 .byt $7F-$73+$C0
shm_ShaftBL
 .byt $7F-$73+$C0
 .byt $7F-$73+$C0
 .byt $7F-$73+$C0
 .byt $43
 .byt $7F-$73+$C0
shm_ShaftBR
 .byt $7F-$73+$C0
 .byt $7F-$73+$C0
 .byt $7F-$73+$C0
 .byt $70
 .byt $7F-$73+$C0
shm_ShaftTLTR
 .byt $7F-$73+$C0
 .byt $40
 .byt $7F-$73+$C0
 .byt $7F-$73+$C0
 .byt $7F-$73+$C0
shm_ShaftTLBR
 .byt $7F-$73+$C0
 .byt $43
 .byt $7F-$73+$C0
 .byt $70
 .byt $7F-$73+$C0
shm_ShaftBLTR
 .byt $7F-$73+$C0
 .byt $70
 .byt $7F-$73+$C0
 .byt $43
 .byt $7F-$73+$C0
shm_ShaftBLBR
 .byt $7F-$73+$C0
 .byt $7F-$73+$C0
 .byt $7F-$73+$C0
 .byt $40
 .byt $7F-$73+$C0
shm_Template
 .byt %01000001,127,127,127,127,127,127,127,127,127,127,127,127,127,%01100000
MainShaftLiftCables
 .byt 7,%01101000,%01000101,3
 .byt 7,%01101000,%01000101,6
ColourAttributeYellowCyan
 .byt 3
 .byt 6


mon_part0
 .byt $6A,$68
 .byt $55,$43
 .byt $6A,$F0
 .byt $54,$E0
 .byt $6A,$E0
 .byt $54,$C0
 .byt $6A,$C0
mon_part1
 .byt $54
 .byt $6A 
 .byt $54 
 .byt $6A 
 .byt $54 
 .byt $6A 
mon_part2
 .byt $42,$6A
 .byt $71,$55 
 .byt $C3,$6A 
 .byt $C1,$55 
 .byt $C1,$4A 
 .byt $C0,$55 
 .byt $C0,$4A 
mon_part3
 .byt $55
 .byt $4A 
 .byt $55 
 .byt $4A 
 .byt $55 
 .byt $4A 
mon_part4
 .byt $70
 .byt $58
 .byt $4C
 .byt $46
 .byt $43
mon_part5
 .byt $43
 .byt $46 
 .byt $4C 
 .byt $5A 
 .byt $74 
 .byt $6A 
mon_part6
 .byt $41
 .byt $43 
 .byt $46 
 .byt $4D 
 .byt $5A 
 .byt $70 
mon_part7 
 .byt $6B,$54
 .byt $55,$6A 
 .byt $6A,$74 
 .byt $55,$5A 
 .byt $6A,$6D 
 .byt $40,$43
mon_part8
 .byt $6A
 .byt $55
 .byt $6A
 .byt $55
 .byt $6A
 .byt $40
mon_part9
 .byt $C0,$4A
 .byt $C1,$55
 .byt $C1,$4A
 .byt $C3,$55
 .byt $70,$6A
 .byt $41,$55
mon_part10
 .byt $54,$C0
 .byt $6A,$C0 
 .byt $54,$C0
 .byt $6A,$C0
 .byt $54,$E0
 .byt $6A,$E0
 .byt $55,$F0
 .byt $6A,$43
 .byt $55,$50
mon_part11
 .byt $C0
 .byt $40
 .byt $6A
 .byt $55
 .byt $40
 .byt $C0
mon_part12
 .byt $60,$55,$55
 .byt $C0,$60,$4A
 .byt $C0,$C0,$40
mon_part13
 .byt $C0
 .byt $C0 
 .byt $C0 
 .byt $C0 
 .byt $C0 
 .byt $C0 
mon_part14
 .byt $55,$54,$41
 .byt $6A,$41,$C0
 .byt $41,$C0,$C0
mon_part15
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
mon_part16
 .byt $40
 .byt $C0
mon_part17
 .byt $02
 .byt $02
mon_part18
 .byt $03
 .byt $06
PuzzleCursorHorizontal	;6x1
 .byt %01001111,%11000000,%11000000,%11000000,%11000000,%01111100
PuzzleCursorVertical	;1x10
 .byt %11110011
 .byt %01001100
 .byt %11110011
 .byt %01001100
 .byt %11110011
 .byt %01001100
 .byt %11110011
 .byt %01001100
 .byt %11110011
 .byt %01001100
PuzzleMemoryArrowUp
 .byt %01000001,%01100000
 .byt %11110000,%11000011
 .byt %11000000,%11000000
PuzzleMemoryArrowDown
 .byt %11000000,%11000000
 .byt %01001111,%01111100
 .byt %01000001,%01100000
PuzzleCursorDeletedHorizontalTop	;6x1
 .byt %01000000,%01000000,%01000000,%01000000,%01000000,%01000000
PuzzleCursorDeletedHorizontalBottom	;6x1
 .byt %11111111,%11111111,%11111111,%11111111,%11111111,%11111111
PuzzleCursorDeletedVertical	;1x10
 .byt %11111111
 .byt %01000000
 .byt %11111111
 .byt %01000000
 .byt %11111111
 .byt %01000000
 .byt %11111111
 .byt %01000000
 .byt %11111111
 .byt %01000000
PuzzleMemoryDeletedArrowUp 	;2x3
 .byt %01000000,%01000000
PuzzleMemoryDeletedArrowDown 	;2x3
 .byt %11111111,%11111111
 .byt %01000000,%01000000
 .byt %01000000,%01000000
VoidPuzzlePiece
 .dsb 32,64

GFX_SearchingBar
 .byt $40,$40,$40,$40,$40,$40,$40
 .byt $E0,$C0,$C0,$C0,$C0,$C0,$C7
 .byt $E6,$F9,$CE,$CD,$D5,$C9,$C3
 .byt $53,$4D,$54,$6E,$4A,$55,$7E
 .byt $E6,$E3,$EE,$D1,$D5,$DB,$E1
 .byt $53,$45,$54,$72,$6A,$76,$6A
 .byt $5F,$7F,$7F,$7F,$7F,$7F,$7E
 .byt $EF,$FF,$FF,$FF,$FF,$FF,$FD
 .byt $5F,$7F,$7F,$7F,$7F,$7F,$7E
 .byt $40,$40,$40,$40,$40,$40,$40


GFX_Terminal		;3x20
 .byt $6A,$40,$4A                    
 .byt $54,$C0,$65                    
 .byt $6A,$60,$6A                    
 .byt $54,$68,$65                    
 .byt $6A,$60,$6A                    
 .byt $54,$60,$65                    
 .byt $6A,$C0,$6A                    
 .byt $54,$40,$45                    
 .byt $69,$C0,$72                    
 .byt $55,$47,$55                    
 .byt $69,$C0,$72                    
 .byt $40,$40,$40                    
 .byt $FF,$FF,$FF                    
 .byt $44,$40,$48                    
 .byt $64,$6A,$6A                    
 .byt $55,$55,$49                    
 .byt $64,$6A,$6A                    
 .byt $55,$55,$49                    
 .byt $64,$6A,$6A                    
 .byt $55,$55,$49                    
GFX_Sofa			;6x16
 .byt $6A,$6A,$40,$40,$40,$40,$6A
 .byt $55,$50,$C2,$EA,$EA,$C9,$45
 .byt $6A,$63,$D4,$6C,$C5,$6D,$62
 .byt $55,$55,$CA,$EA,$E8,$EA,$75
 .byt $6A,$66,$6C,$C4,$6A,$C5,$62
 .byt $54,$45,$EA,$EA,$E2,$E8,$51
 .byt $68,$73,$D5,$6C,$D4,$6A,$6C
 .byt $55,$C2,$5D,$75,$75,$5D,$E0
 .byt $68,$7C,$40,$40,$40,$40,$5E
 .byt $54,$5D,$EA,$EA,$EA,$EA,$5D
 .byt $6A,$5C,$6A,$6A,$6A,$6A,$5C
 .byt $55,$E0,$C0,$C0,$C0,$C0,$7D
 .byt $6A,$5F,$7F,$7F,$7F,$7F,$7C
 .byt $55,$E0,$C0,$C0,$C0,$C0,$7D
 .byt $6A,$4D,$55,$55,$55,$55,$5A
 .byt $55,$F2,$EA,$EA,$EA,$EA,$59
GFX_Fireplace           	;8x21
 .byt $40,$40,$40,$40,$40,$40,$40,$45
 .byt $E0,$C0,$C0,$C0,$C0,$C0,$C0,$72
 .byt $4F,$7F,$7F,$7F,$7F,$7F,$7F,$65
 .byt $62,$6A,$6A,$6A,$6A,$6A,$6A,$4A
 .byt $50,$40,$40,$40,$40,$40,$40,$55
 .byt $6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A
 .byt $51,$51,$51,$51,$51,$51,$50,$55
 .byt $6A,$6A,$6A,$6A,$6A,$6A,$6A,$6A
 .byt $50,$40,$40,$40,$40,$40,$40,$55
 .byt $69,$55,$55,$55,$55,$55,$4A,$6A
 .byt $52,$4A,$4A,$4A,$4A,$4A,$54,$55
 .byt $69,$55,$55,$55,$55,$55,$4A,$6A
 .byt $50,$40,$40,$40,$40,$40,$40,$55
 .byt $6A,$6A,$68,$40,$40,$6A,$6A,$6A
 .byt $51,$51,$58,$45,$40,$71,$50,$55
 .byt $6A,$6A,$68,$F7,$60,$6A,$6A,$6A
 .byt $50,$40,$41,$55,$54,$40,$40,$55
 .byt $69,$55,$58,$6F,$68,$75,$4A,$6A
 .byt $52,$4A,$48,$50,$50,$6A,$54,$55
 .byt $69,$55,$58,$70,$58,$75,$4A,$6A
 .byt $50,$40,$40,$40,$40,$40,$40,$55
GFX_Toilet              	;3x24
 .byt $60,$40,$6A
 .byt $E0,$C0,$55
 .byt $5F,$7F,$42
 .byt $E0,$C0,$59
 .byt $E0,$C0,$42
 .byt $E0,$C0,$55
 .byt $E0,$C0,$42
 .byt $40,$40,$55
 .byt $6A,$6A,$62
 .byt $54,$65,$55
 .byt $6A,$6A,$6A
 .byt $54,$65,$5D
 .byt $6A,$6A,$5C
 .byt $54,$65,$5D
 .byt $60,$40,$6A
 .byt $E8,$C2,$55
 .byt $60,$40,$6A
 .byt $F0,$C1,$55
 .byt $6F,$7A,$6A
 .byt $E8,$CA,$55
 .byt $67,$78,$6A
 .byt $EC,$C6,$55
 .byt $6B,$7A,$6A
 .byt $E8,$C2,$55
GFX_Drawers             		;3x18
 .byt $40,$40,$40                    
 .byt $E0,$C0,$C1                    
 .byt $58,$40,$46                    
 .byt $55,$5E,$6A                    
 .byt $50,$40,$42                    
 .byt $55,$52,$6A                    
 .byt $52,$6D,$52                    
 .byt $55,$52,$6A                    
 .byt $50,$40,$42                    
 .byt $55,$52,$6A                    
 .byt $52,$6D,$52                    
 .byt $55,$52,$6A                    
 .byt $50,$40,$42                    
 .byt $55,$52,$6A                    
 .byt $52,$6D,$52                    
 .byt $55,$52,$6A                    
 .byt $50,$40,$42                    
 .byt $5F,$7F,$7E                    
GFX_Armchair            		;3x24
 .byt $54,$45,$55
 .byt $6B,$7A,$6A
 .byt $53,$D6,$55
 .byt $67,$7C,$6A
 .byt $57,$CA,$55
 .byt $6F,$C1,$6A
 .byt $40,$40,$55
 .byt $6A,$4A,$60
 .byt $55,$51,$4E
 .byt $6A,$4A,$6E
 .byt $55,$55,$4E
 .byt $6A,$4A,$6E
 .byt $55,$55,$5E
 .byt $6A,$4A,$5C
 .byt $55,$55,$5D
 .byt $6A,$4A,$6C
 .byt $E0,$E0,$C2
 .byt $C0,$E0,$7C
 .byt $E2,$55,$59
 .byt $6B,$5F,$7A
 .byt $4F,$5F,$79
 .byt $6B,$5F,$7A
 .byt $4F,$5F,$79
 .byt $6B,$5F,$7A
 .byt $4F,$5F,$79
GFX_Desk                		;7x17
 .byt $57,$C0,$C0,$55,$55,$55,$55
 .byt $6D,$4A,$FF,$6A,$6A,$6A,$6A
 .byt $55,$55,$EA,$55,$55,$55,$55
 .byt $68,$6A,$6A,$60,$4A,$6A,$6A
 .byt $55,$EA,$EA,$F0,$65,$55,$55
 .byt $68,$6A,$6A,$6F,$6A,$6A,$6A
 .byt $EB,$FF,$FF,$F0,$64,$40,$55
 .byt $40,$FF,$FF,$4F,$60,$FF,$40
 .byt $E0,$C0,$C0,$D0,$D0,$C0,$C1
 .byt $50,$40,$58,$4F,$61,$60,$42
 .byt $55,$55,$50,$4F,$60,$6A,$6A
 .byt $52,$72,$51,$77,$5C,$65,$52
 .byt $55,$55,$54,$72,$58,$6B,$6A
 .byt $50,$40,$52,$C0,$7A,$65,$52
 .byt $55,$55,$54,$47,$40,$6A,$6A
 .byt $52,$7A,$50,$46,$40,$65,$52
 .byt $55,$55,$55,$C0,$C3,$6A,$6A
GFX_Bed                 		;7x10
 .byt $6A,$6A,$6A,$6A,$6A,$60,$6A
 .byt $54,$40,$40,$40,$40,$4E,$55
 .byt $60,$FF,$FF,$FF,$FF,$C0,$4A
 .byt $4F,$C0,$C0,$C0,$C0,$C0,$65
 .byt $55,$55,$55,$55,$55,$55,$52
 .byt $4A,$D5,$D5,$D5,$D5,$D5,$65
 .byt $60,$40,$40,$40,$40,$40,$4A
 .byt $54,$FF,$FF,$FF,$FF,$FE,$55
 .byt $68,$40,$40,$40,$40,$40,$6A
 .byt $54,$FF,$FF,$FF,$FF,$FE,$55
GFX_Sink                		;4x24
 .byt $6A,$40,$40,$4A
 .byt $54,$C0,$C0,$55
 .byt $6A,$C0,$C8,$4A
 .byt $54,$C1,$C4,$55
 .byt $6A,$C0,$E0,$4A
 .byt $54,$C4,$D0,$55
 .byt $6A,$C2,$C0,$4A
 .byt $54,$C0,$C0,$55
 .byt $6A,$40,$40,$4A
 .byt $55,$50,$45,$41
 .byt $6A,$65,$52,$6C
 .byt $55,$44,$51,$4D
 .byt $40,$5F,$7C,$40
 .byt $E0,$C0,$C0,$C1
 .byt $E0,$C0,$C0,$C1
 .byt $40,$40,$40,$40
 .byt $6B,$C0,$E0,$75
 .byt $4B,$7F,$E0,$75
 .byt $6B,$C6,$EC,$74
 .byt $4B,$7F,$E0,$75
 .byt $6B,$C0,$E0,$74
 .byt $4B,$7F,$E0,$75
 .byt $6B,$C0,$E0,$74
 .byt $4B,$7F,$5F,$75
GFX_Bath                		;6x25
 .byt $78,$55,$55,$55,$55,$55
 .byt $53,$4A,$6A,$6A,$6A,$6A
 .byt $7E,$55,$55,$55,$55,$55
 .byt $54,$6A,$6A,$6A,$6A,$6A
 .byt $51,$55,$55,$55,$55,$55
 .byt $5A,$6A,$6A,$6A,$6A,$6A
 .byt $55,$55,$55,$55,$55,$55
 .byt $5A,$6A,$6A,$42,$6A,$6A
 .byt $55,$55,$54,$79,$55,$55
 .byt $6A,$6A,$6A,$7A,$6A,$6A
 .byt $41,$55,$54,$69,$55,$55
 .byt $68,$6A,$6A,$7A,$6A,$6A
 .byt $4E,$55,$54,$41,$55,$55
 .byt $5A,$6A,$6A,$6A,$6A,$6A
 .byt $58,$55,$55,$55,$55,$55
 .byt $40,$40,$40,$40,$40,$4A
 .byt $E0,$C0,$FF,$C0,$C0,$55
 .byt $E0,$C0,$7F,$C0,$C0,$4A
 .byt $E0,$C0,$FF,$C0,$C0,$55
 .byt $E0,$C0,$7F,$C0,$C0,$4A
 .byt $E0,$C0,$FF,$C0,$C0,$55
 .byt $E0,$C0,$C0,$C0,$C0,$4A
 .byt $E0,$C0,$C0,$C0,$C0,$55
 .byt $E0,$C0,$C0,$C0,$C0,$4A
 .byt $E0,$C0,$C0,$C0,$C0,$55
GFX_Bookcase            		;5x30
 .byt $6A,$40,$40,$40,$4A
 .byt $54,$C0,$C0,$C0,$55
 .byt $6A,$60,$40,$41,$4A
 .byt $54,$D5,$4A,$41,$55
 .byt $6A,$6A,$4A,$FE,$4A
 .byt $54,$D6,$4A,$41,$55
 .byt $6A,$69,$4A,$C2,$4A
 .byt $54,$D7,$6A,$41,$55
 .byt $6A,$C0,$C0,$C0,$4A
 .byt $54,$60,$40,$41,$55
 .byt $6A,$69,$5A,$59,$4A
 .byt $54,$69,$5A,$E6,$55
 .byt $6A,$65,$5A,$75,$4A
 .byt $54,$65,$5A,$CA,$55
 .byt $6A,$65,$5B,$65,$4A
 .byt $54,$C0,$C0,$C0,$55
 .byt $6A,$60,$40,$41,$4A
 .byt $54,$D1,$6B,$49,$55
 .byt $6A,$6E,$D4,$4B,$4A
 .byt $54,$D1,$6B,$53,$55
 .byt $6A,$6E,$D4,$55,$4A
 .byt $54,$D1,$6B,$55,$55
 .byt $6A,$C0,$C0,$C0,$4A
 .byt $54,$60,$FF,$FE,$55
 .byt $6A,$6A,$FF,$65,$4A
 .byt $54,$6A,$FF,$DA,$55
 .byt $6A,$6A,$FF,$69,$4A
 .byt $54,$6A,$FF,$D6,$55
 .byt $6A,$C0,$C0,$C0,$4A
 .byt $54,$70,$40,$43,$55
GFX_Candy               		;5x26
 .byt $40,$40,$40,$40,$4A
 .byt $E0,$C0,$C0,$C0,$55
 .byt $50,$40,$40,$D0,$4A
 .byt $53,$F3,$70,$CE,$55
 .byt $53,$4C,$70,$D0,$4A
 .byt $53,$F3,$70,$CC,$55
 .byt $50,$40,$40,$D2,$4A
 .byt $53,$4C,$70,$61,$55
 .byt $51,$44,$60,$C0,$4A
 .byt $53,$44,$70,$61,$55
 .byt $50,$40,$40,$D0,$4A
 .byt $53,$4C,$70,$61,$55
 .byt $53,$F3,$70,$C0,$4A
 .byt $53,$4C,$70,$61,$55
 .byt $50,$40,$40,$D4,$4A
 .byt $53,$4C,$70,$61,$55
 .byt $51,$48,$70,$C0,$4A
 .byt $53,$44,$50,$6D,$55
 .byt $50,$40,$40,$D2,$4A
 .byt $E0,$C0,$C0,$CC,$55
 .byt $50,$40,$40,$C0,$4A
 .byt $50,$40,$40,$73,$55
 .byt $50,$40,$40,$73,$4A
 .byt $E0,$C0,$C0,$C0,$55
 .byt $E0,$C0,$C0,$C0,$4A
 .byt $E0,$C0,$C0,$C0,$55
GFX_Speaker             		;2x12
 .byt $40,$40
 .byt $E0,$C2
 .byt $50,$44
 .byt $44,$51
 .byt $48,$48
 .byt $41,$41
 .byt $48,$48
 .byt $44,$51
 .byt $50,$44
 .byt $E0,$C2
 .byt $5F,$64
 .byt $E0,$C2
GFX_Hifi                		;3x19
 .byt $40,$40,$45
 .byt $6F,$C0,$6A
 .byt $4F,$C0,$65
 .byt $50,$40,$52
 .byt $55,$55,$55
 .byt $50,$40,$52
 .byt $57,$62,$55
 .byt $50,$40,$52
 .byt $55,$55,$55
 .byt $50,$40,$52
 .byt $57,$4D,$55
 .byt $57,$F2,$52
 .byt $50,$40,$55
 .byt $55,$55,$52
 .byt $52,$6A,$55
 .byt $55,$55,$52
 .byt $52,$6A,$55
 .byt $55,$55,$52
 .byt $52,$6A,$55
GFX_Lamp                ;4x23
 .byt $54,$41,$55,$55
 .byt $69,$78,$6A,$6A
 .byt $54,$C3,$55,$55
 .byt $69,$58,$4A,$6A
 .byt $54,$49,$45,$55
 .byt $6A,$62,$62,$6A
 .byt $55,$55,$51,$55
 .byt $6A,$6A,$68,$6A
 .byt $55,$55,$51,$55
 .byt $6A,$6A,$68,$6A
 .byt $55,$55,$54,$55
 .byt $6A,$6A,$68,$6A
 .byt $55,$55,$54,$55
 .byt $6A,$6A,$68,$6A
 .byt $55,$55,$54,$55
 .byt $6A,$6A,$68,$6A
 .byt $55,$55,$54,$55
 .byt $6A,$6A,$68,$6A
 .byt $55,$55,$54,$55
 .byt $6A,$6A,$68,$6A
 .byt $55,$55,$50,$45
 .byt $6A,$6A,$47,$62
 .byt $55,$55,$C0,$79
GFX_Computer		;4x20
 .byt $6A,$6A,$40,$6A
 .byt $55,$54,$C3,$55
 .byt $6A,$6A,$C0,$6A
 .byt $55,$54,$C0,$65
 .byt $6A,$6A,$C0,$6A
 .byt $55,$54,$C3,$55
 .byt $6A,$68,$4C,$6A
 .byt $55,$43,$C0,$55
 .byt $6A,$E0,$C0,$4A
 .byt $54,$FF,$FF,$55
 .byt $6A,$FF,$FF,$4A
 .byt $54,$FF,$FF,$55
 .byt $6A,$6A,$40,$4A
 .byt $55,$55,$54,$55
 .byt $6A,$6A,$6A,$4A
 .byt $55,$55,$54,$55
 .byt $6A,$6A,$6A,$4A
 .byt $55,$55,$54,$55
 .byt $6A,$6A,$68,$4A
 .byt $55,$50,$40,$55
GFX_Tapestreamer        ;5x24
 .byt $6A,$40,$40,$40,$4A
 .byt $54,$C0,$C0,$C0,$55
 .byt $6A,$DF,$FF,$CC,$4A
 .byt $54,$DC,$DF,$CC,$55
 .byt $6A,$D8,$CF,$C0,$4A
 .byt $54,$D2,$E3,$CC,$55
 .byt $6A,$D1,$C5,$C0,$4A
 .byt $54,$D2,$E7,$CC,$55
 .byt $6A,$D8,$CC,$C0,$4A
 .byt $54,$DC,$DC,$CC,$55
 .byt $6A,$DD,$DC,$C0,$4A
 .byt $54,$D8,$CF,$C0,$55
 .byt $6A,$D2,$E5,$CC,$4A
 .byt $54,$D1,$C3,$C0,$55
 .byt $6A,$D2,$E7,$CC,$4A
 .byt $54,$D8,$CF,$C0,$55
 .byt $6A,$DC,$DF,$CC,$4A
 .byt $54,$DF,$FF,$CC,$55
 .byt $6A,$C0,$C0,$C0,$4A
 .byt $54,$C0,$C0,$C0,$55
 .byt $6A,$C0,$C0,$C0,$4A
 .byt $54,$C0,$C0,$C0,$55
 .byt $6A,$C0,$C0,$C0,$4A
 .byt $54,$FF,$FF,$FF,$55
GFX_Harddisk            	;3x17
 .byt $54,$40,$55
 .byt $68,$7F,$42
 .byt $53,$40,$71
 .byt $64,$F3,$4A
 .byt $55,$40,$69
 .byt $64,$F3,$4A
 .byt $55,$40,$69
 .byt $64,$F3,$4A
 .byt $55,$40,$69
 .byt $64,$F3,$4A
 .byt $55,$40,$69
 .byt $60,$40,$42
 .byt $57,$C0,$79
 .byt $60,$40,$42
 .byt $57,$C0,$79
 .byt $67,$7E,$6A
 .byt $57,$C0,$79
GFX_Harddisk2            	;3x17
 .byt $54,$40,$55
 .byt $68,$7F,$42
 .byt $53,$7F,$71
 .byt $67,$CC,$7A
 .byt $56,$40,$59
 .byt $67,$CC,$7A
 .byt $56,$40,$59
 .byt $67,$CC,$7A
 .byt $56,$40,$59
 .byt $67,$CC,$7A
 .byt $56,$40,$59
 .byt $66,$CC,$7A
 .byt $55,$C0,$69
 .byt $67,$75,$5A
 .byt $57,$CA,$59
 .byt $67,$C0,$7A
 .byt $57,$C0,$79
GFX_FagDispenser		;7x24
 .byt $6A,$40,$40,$40,$40,$40,$4A
 .byt $54,$C0,$C0,$C0,$C0,$C0,$55
 .byt $6A,$60,$40,$40,$40,$41,$4A
 .byt $54,$68,$49,$44,$48,$49,$55
 .byt $6A,$60,$DF,$50,$DF,$61,$4A
 .byt $54,$62,$45,$42,$4A,$45,$55
 .byt $6A,$60,$40,$40,$40,$41,$4A
 .byt $54,$7F,$7F,$7F,$7F,$7F,$55
 .byt $6A,$40,$40,$40,$40,$40,$4A
 .byt $54,$FF,$FF,$FF,$FF,$F9,$55
 .byt $6A,$40,$40,$40,$40,$40,$4A
 .byt $54,$C0,$C0,$C0,$C0,$C0,$55
 .byt $6A,$70,$40,$40,$40,$43,$4A
 .byt $54,$C9,$FF,$F9,$F9,$FC,$55
 .byt $6A,$70,$46,$40,$70,$43,$4A
 .byt $54,$CF,$CF,$CF,$FF,$CC,$55
 .byt $6A,$70,$40,$40,$40,$43,$4A
 .byt $54,$C0,$C0,$C0,$C0,$C0,$55
 .byt $6A,$40,$40,$40,$40,$40,$4A
 .byt $54,$FF,$FF,$FF,$FF,$FF,$55
 .byt $6A,$40,$40,$40,$40,$40,$4A
 .byt $54,$FF,$FF,$FF,$FF,$FF,$55
 .byt $6A,$C0,$C0,$C0,$C0,$C0,$4A
 .byt $54,$FF,$FF,$FF,$FF,$FF,$55
GFX_Telex               	;5x21
 .byt $55,$55,$40,$55,$55
 .byt $6A,$6A,$C0,$4A,$6A
 .byt $55,$54,$C0,$55,$55
 .byt $6A,$6A,$C0,$4A,$6A
 .byt $55,$54,$C0,$55,$55
 .byt $6A,$6A,$C0,$4A,$6A
 .byt $55,$F2,$FF,$D3,$55
 .byt $6A,$5F,$7F,$7E,$6A
 .byt $55,$E0,$C0,$C1,$55
 .byt $6A,$4F,$7F,$7D,$6A
 .byt $55,$F0,$C0,$C2,$55
 .byt $6A,$6F,$CA,$64,$6A
 .byt $55,$F0,$C0,$C2,$55
 .byt $6A,$60,$40,$40,$6A
 .byt $55,$56,$55,$59,$55
 .byt $6A,$66,$6A,$5A,$6A
 .byt $55,$56,$55,$59,$55
 .byt $6A,$66,$6A,$5A,$6A
 .byt $55,$56,$55,$59,$55
 .byt $6A,$66,$6A,$5A,$6A
 .byt $55,$56,$55,$59,$55
GFX_Doorway		;7x31
 .byt $54,$C0,$C0,$C0,$C0,$C0,$55
 .byt $6A,$5F,$C0,$C0,$C0,$7E,$4A
 .byt $54,$D0,$C0,$C0,$C0,$C2,$55
 .byt $6A,$50,$40,$4C,$40,$42,$4A
 .byt $54,$DF,$FF,$FF,$FF,$FE,$55
 .byt $6A,$55,$55,$4C,$6A,$6A,$4A
 .byt $54,$DF,$FF,$FF,$FF,$FE,$55
 .byt $6A,$54,$41,$4C,$60,$4A,$4A
 .byt $54,$DF,$FF,$FF,$FF,$FE,$55
 .byt $6A,$54,$41,$4C,$60,$4A,$4A
 .byt $54,$DF,$FF,$FF,$FF,$FE,$55
 .byt $6A,$55,$55,$4C,$6A,$6A,$4A
 .byt $54,$DF,$FF,$FF,$FF,$FE,$55
 .byt $40,$50,$40,$4C,$40,$42,$4A
 .byt $5C,$DF,$FF,$FF,$FF,$FE,$55
 .byt $40,$55,$55,$4C,$6A,$6A,$4A
 .byt $5C,$DF,$FF,$FF,$FF,$FE,$55
 .byt $5C,$54,$41,$4C,$60,$4A,$4A
 .byt $5C,$DF,$FF,$FF,$FF,$FE,$55
 .byt $40,$54,$41,$4C,$60,$4A,$4A
 .byt $54,$DF,$FF,$FF,$FF,$FE,$55
 .byt $6A,$54,$41,$4C,$60,$4A,$4A
 .byt $54,$DF,$FF,$FF,$FF,$FE,$55
 .byt $6A,$54,$41,$4C,$60,$4A,$4A
 .byt $54,$DF,$FF,$FF,$FF,$FE,$55
 .byt $6A,$55,$55,$4C,$6A,$6A,$4A
 .byt $54,$DF,$FF,$FF,$FF,$FE,$55
 .byt $6A,$50,$40,$4C,$40,$42,$4A
 .byt $54,$D0,$C0,$C0,$C0,$C2,$55
 .byt $6A,$5F,$7F,$7F,$7F,$7E,$4A
 .byt $54,$C0,$C0,$C0,$C0,$C0,$55
GFX_SimonConsole		;8x23
 .byt $55,$55,$55,$E9,$E6,$55,$55,$55
 .byt $6A,$6A,$6A,$66,$5A,$6A,$6A,$6A
 .byt $55,$55,$55,$E9,$E6,$55,$55,$55
 .byt $6A,$6A,$6A,$66,$5A,$6A,$6A,$6A
 .byt $55,$55,$55,$E9,$E6,$55,$55,$55
 .byt $6A,$6A,$6A,$66,$5A,$6A,$6A,$6A
 .byt $55,$55,$55,$E9,$E6,$55,$55,$55
 .byt $6A,$6A,$6A,$66,$5A,$6A,$6A,$6A
 .byt $55,$55,$54,$40,$40,$55,$55,$55
 .byt $6A,$6A,$6A,$F3,$F3,$4A,$6A,$6A
 .byt $55,$55,$54,$40,$40,$55,$55,$55
 .byt $6A,$40,$40,$F3,$F3,$40,$40,$4A
 .byt $54,$C0,$C0,$D0,$C0,$C0,$C0,$55
 .byt $6A,$C1,$CC,$C0,$5D,$C2,$E8,$4A
 .byt $54,$4F,$C1,$C8,$C0,$C0,$7C,$55
 .byt $6A,$60,$40,$40,$40,$40,$42,$6A
 .byt $55,$55,$55,$55,$55,$55,$55,$55
 .byt $6A,$6A,$6A,$6A,$6B,$6A,$6A,$6A
 .byt $55,$55,$7D,$55,$55,$55,$55,$55
 .byt $6A,$6A,$6B,$6A,$6B,$6A,$7A,$6A
 .byt $55,$55,$55,$55,$55,$55,$55,$55
 .byt $6A,$6A,$6B,$6A,$6A,$6A,$7A,$6A
 .byt $55,$55,$55,$55,$55,$55,$55,$55
GFX_Fridge		;5x31
 .byt $54,$C0,$C0,$C0,$55
 .byt $6A,$C0,$C0,$C0,$4A
 .byt $54,$C0,$C0,$C0,$55
 .byt $6A,$C0,$C0,$C0,$4A
 .byt $54,$C0,$C0,$C2,$55
 .byt $6A,$C0,$C0,$C2,$4A
 .byt $54,$C0,$C0,$C2,$55
 .byt $6A,$C0,$C0,$C2,$4A
 .byt $54,$C0,$C0,$C2,$55
 .byt $6A,$C0,$C0,$C0,$4A
 .byt $54,$FF,$FF,$FF,$55
 .byt $6A,$C0,$C0,$C0,$4A
 .byt $54,$D8,$C0,$C2,$55
 .byt $6A,$C0,$C0,$C2,$4A
 .byt $54,$C0,$C0,$C2,$55
 .byt $6A,$C0,$C0,$C2,$4A
 .byt $54,$C0,$C0,$C2,$55
 .byt $6A,$C0,$C0,$C0,$4A
 .byt $54,$C0,$C0,$C0,$55
 .byt $6A,$C0,$C0,$C0,$4A
 .byt $54,$C0,$C0,$C0,$55
 .byt $6A,$C0,$C0,$C0,$4A
 .byt $54,$C0,$C0,$C0,$55
 .byt $6A,$C0,$C0,$C0,$4A
 .byt $54,$C0,$C0,$C0,$55
 .byt $6A,$C0,$C0,$C0,$4A
 .byt $54,$C0,$C0,$C0,$55
 .byt $6A,$C0,$C0,$C0,$4A
 .byt $54,$FF,$FF,$FF,$55
 .byt $6A,$40,$40,$40,$4A
 .byt $54,$FF,$FF,$FF,$55
;GFX_Picture	;3x14
; .byt $40,$40,$55
; .byt $E0,$C0,$4A
; .byt $EF,$FE,$55
; .byt $52,$6D,$4A
; .byt $EA,$F2,$55
; .byt $52,$61,$4A
; .byt $EE,$FE,$55
; .byt $51,$FE,$4A
; .byt $E8,$C2,$55
; .byt $57,$7D,$4A
; .byt $E8,$C2,$55
; .byt $50,$41,$4A
; .byt $5F,$C0,$55
; .byt $40,$40,$4A
GFX_Basket	;3x8
 .byt $6A,$40,$42
 .byt $54,$C0,$79
 .byt $6A,$C2,$52
 .byt $54,$C5,$69
 .byt $6A,$5D,$52
 .byt $55,$5A,$65
 .byt $6A,$55,$52
 .byt $55,$4E,$65
GFX_Sideboard	;7x19
 .byt $55,$55,$55,$54,$40,$40,$55
 .byt $6A,$6A,$6A,$6A,$C0,$C0,$4A
 .byt $55,$55,$55,$54,$DE,$DE,$55
 .byt $6A,$6A,$42,$6A,$61,$C0,$4A
 .byt $55,$50,$79,$54,$DE,$DE,$55
 .byt $6A,$47,$7A,$6A,$61,$61,$4A
 .byt $54,$7F,$79,$54,$C0,$C0,$55
 .byt $60,$40,$40,$40,$40,$40,$42
 .byt $E8,$C0,$C0,$C0,$C0,$C0,$79
 .byt $60,$40,$40,$40,$40,$40,$42
 .byt $56,$7F,$5F,$5F,$7D,$7F,$59
 .byt $66,$C0,$E0,$E0,$C2,$DC,$5A
 .byt $56,$7F,$5F,$5F,$7D,$7F,$59
 .byt $66,$C2,$E8,$E8,$C3,$40,$5A
 .byt $56,$7D,$57,$57,$7D,$7F,$59
 .byt $66,$C2,$E8,$E8,$C2,$DC,$5A
 .byt $56,$7F,$5F,$5F,$7D,$7F,$59
 .byt $66,$C0,$E0,$E0,$C2,$C0,$5A
 .byt $56,$7F,$5F,$5F,$7D,$7F,$59
Mor_Room
 .byt %11000000
 .byt %01000000
 .byt %01000000
 .byt %01000000
 .byt %11000000
Mor_ControlRoom
 .byt %11000000
 .byt %01000000
 .byt %01001100
 .byt %01000000
 .byt %11000000
Mor_SimonRoom
 .byt %11000000
 .byt %01000000
 .byt %01010010
 .byt %01000000
 .byt %11000000
Mor_Blank
 .byt %11000000
 .byt %11000000
 .byt %11000000
 .byt %11000000
 .byt %11000000
Mor_Shaft
 .byt $CC
 .byt $73
 .byt $CC
 .byt $73
 .byt $CC
Mor_Sh_TR
 .byt $CC
 .byt $70
 .byt $CC
 .byt $73
 .byt $CC
Mor_Sh_TL
 .byt $CC
 .byt $43
 .byt $CC
 .byt $73
 .byt $CC
Mor_Sh_TLTR
 .byt $CC
 .byt $40
 .byt $CC
 .byt $73
 .byt $CC
Mor_Sh_BR
 .byt $CC
 .byt $73
 .byt $CC
 .byt $70
 .byt $CC
Mor_Sh_BRTL
 .byt $CC
 .byt $43
 .byt $CC
 .byt $70
 .byt $CC
Mor_Sh_BL
 .byt $CC
 .byt $73
 .byt $CC
 .byt $43
 .byt $CC
Mor_Sh_BLTR
 .byt $CC
 .byt $70
 .byt $CC
 .byt $43
 .byt $CC
Mor_Sh_BLBR
 .byt $CC
 .byt $73
 .byt $CC
 .byt $40
 .byt $CC
Mor_Template
 .byt %01000001
 .dsb 13,%01111111
 .byt %01100000
Object_SimonBlackCursor
 .byt $40,$40
 .byt $5F,$7E
 .byt $50,$42
 .byt $50,$42
 .byt $50,$42
 .byt $50,$42
 .byt $50,$42
 .byt $50,$42
 .byt $50,$42
 .byt $50,$42
 .byt $5F,$7E
 .byt $40,$40
Object_SimonWhiteCursor
 .byt $C0,$C0
 .byt $DF,$FE
 .byt $D0,$C2
 .byt $D0,$C2
 .byt $D0,$C2
 .byt $D0,$C2
 .byt $D0,$C2
 .byt $D0,$C2
 .byt $D0,$C2
 .byt $D0,$C2
 .byt $DF,$FE
 .byt $C0,$C0
Object_WorkPuzzlePieceGraphic
 .dsb 32,64
SpeechAargh
 .byt $40,$40,$40,$40,$40
 .byt $F0,$C0,$C0,$C0,$C3
 .byt $E6,$CC,$F8,$F2,$E9
 .byt $E9,$D2,$E5,$C2,$E9
 .byt $EF,$DE,$F9,$DB,$E9
 .byt $E9,$D2,$E5,$CA,$E1
 .byt $E9,$D2,$E4,$F2,$E9
 .byt $F0,$C0,$C0,$C0,$C3
 .byt $40,$C0,$40,$40,$40
 .byt $68,$C1,$4A,$6A,$6A
 .byt $51,$78,$55,$55,$55
 .byt $60,$42,$6A,$6A,$6A
GFX_DoorwayOpening0	;7x31
 .byt $54,$C0,$C0,$C0,$C0,$C0,$55
 .byt $6A,$5F,$C0,$C0,$C0,$7E,$4A
 .byt $54,$D0,$C0,$C0,$C0,$C2,$55
 .byt $6A,$50,$41,$40,$60,$42,$4A
 .byt $54,$DF,$FF,$40,$FF,$FE,$55
 .byt $6A,$52,$69,$40,$65,$52,$4A
 .byt $54,$DF,$FF,$40,$FF,$FE,$55
 .byt $6A,$50,$49,$40,$64,$42,$4A
 .byt $54,$DF,$FF,$40,$FF,$FE,$55
 .byt $6A,$50,$49,$40,$64,$42,$4A
 .byt $54,$DF,$FF,$40,$FF,$FE,$55
 .byt $6A,$52,$69,$40,$65,$52,$4A
 .byt $54,$DF,$FF,$EF,$FF,$FE,$55
 .byt $40,$50,$41,$5E,$60,$42,$4A
 .byt $5C,$DF,$FF,$40,$FF,$FE,$55
 .byt $40,$52,$69,$5E,$65,$52,$4A
 .byt $5C,$DF,$FF,$40,$FF,$FE,$55
 .byt $54,$50,$49,$4E,$64,$42,$4A
 .byt $5C,$DF,$FF,$48,$FF,$FE,$55
 .byt $40,$50,$49,$4E,$64,$42,$4A
 .byt $54,$DF,$FF,$4E,$FF,$FE,$55
 .byt $6A,$50,$49,$40,$64,$42,$4A
 .byt $54,$DF,$FF,$4A,$FF,$FE,$55
 .byt $6A,$50,$49,$40,$64,$42,$4A
 .byt $54,$DF,$FF,$54,$FF,$FE,$55
 .byt $6A,$52,$69,$40,$65,$52,$4A
 .byt $54,$DF,$FF,$4A,$FF,$FE,$55
 .byt $6A,$50,$41,$40,$60,$42,$4A
 .byt $54,$D0,$C0,$C0,$C0,$C2,$55
 .byt $6A,$5F,$7F,$7F,$7F,$7E,$4A
 .byt $54,$C0,$C0,$C0,$C0,$C0,$55
GFX_DoorwayOpening1	;7x31
 .byt $54,$C0,$C0,$C0,$C0,$C0,$55
 .byt $6A,$5F,$C0,$C0,$C0,$7E,$4A
 .byt $54,$D0,$C0,$C0,$C0,$C2,$55
 .byt $6A,$50,$48,$40,$44,$42,$4A
 .byt $54,$DF,$FF,$40,$FF,$FE,$55
 .byt $6A,$55,$48,$40,$44,$6A,$4A
 .byt $54,$DF,$FF,$40,$FF,$FE,$55
 .byt $6A,$51,$48,$40,$44,$62,$4A
 .byt $54,$DF,$FF,$40,$FF,$FE,$55
 .byt $6A,$51,$48,$40,$44,$62,$4A
 .byt $54,$DF,$FF,$40,$FF,$FE,$55
 .byt $6A,$55,$4B,$60,$74,$6A,$4A
 .byt $54,$DF,$FC,$CE,$CF,$FE,$55
 .byt $40,$50,$4B,$C0,$74,$42,$4A
 .byt $5C,$DF,$FF,$40,$FF,$FE,$55
 .byt $40,$55,$4B,$C0,$74,$6A,$4A
 .byt $5C,$DF,$FF,$40,$FF,$FE,$55
 .byt $5C,$51,$4B,$6F,$64,$62,$4A
 .byt $5C,$DF,$FF,$68,$DF,$FE,$55
 .byt $40,$51,$4B,$6F,$64,$62,$4A
 .byt $54,$DF,$FC,$6F,$DF,$FE,$55
 .byt $6A,$51,$48,$40,$44,$62,$4A
 .byt $54,$DF,$FD,$6A,$DF,$FE,$55
 .byt $6A,$51,$48,$40,$44,$62,$4A
 .byt $54,$DF,$FE,$55,$FF,$FE,$55
 .byt $6A,$55,$48,$40,$44,$6A,$4A
 .byt $54,$DF,$FD,$6A,$DF,$FE,$55
 .byt $6A,$50,$48,$40,$44,$42,$4A
 .byt $54,$D0,$C0,$C0,$C0,$C2,$55
 .byt $6A,$5F,$7F,$7F,$7F,$7E,$4A
 .byt $54,$C0,$C0,$C0,$C0,$C0,$55
GFX_DoorwayOpening2	;7x31
 .byt $54,$C0,$C0,$C0,$C0,$C0,$55
 .byt $6A,$5F,$C0,$C0,$C0,$7E,$4A
 .byt $54,$D0,$C0,$C0,$C0,$C2,$55
 .byt $6A,$51,$40,$40,$40,$62,$4A
 .byt $54,$DF,$50,$61,$40,$FE,$55
 .byt $6A,$51,$44,$44,$42,$62,$4A
 .byt $54,$DF,$FF,$DE,$F7,$FE,$55
 .byt $6A,$51,$40,$40,$40,$62,$4A
 .byt $54,$DF,$40,$40,$40,$FE,$55
 .byt $6A,$51,$40,$40,$40,$62,$4A
 .byt $54,$DF,$40,$40,$40,$FE,$55
 .byt $6A,$51,$E0,$60,$C1,$62,$4A
 .byt $54,$DF,$EC,$CE,$CD,$FE,$55
 .byt $40,$51,$E0,$C0,$C1,$62,$4A
 .byt $5C,$DF,$40,$40,$40,$FE,$55
 .byt $40,$51,$E0,$C0,$C1,$62,$4A
 .byt $5C,$DF,$40,$40,$40,$FE,$55
 .byt $54,$51,$4F,$6F,$6E,$62,$4A
 .byt $5C,$DF,$48,$68,$68,$FE,$55
 .byt $40,$51,$4F,$6F,$6E,$62,$4A
 .byt $54,$DF,$4F,$6F,$6E,$FE,$55
 .byt $6A,$51,$40,$40,$40,$62,$4A
 .byt $54,$DF,$4A,$6A,$6A,$FE,$55
 .byt $6A,$51,$40,$40,$40,$62,$4A
 .byt $54,$DF,$45,$55,$54,$FE,$55
 .byt $6A,$51,$40,$40,$40,$62,$4A
 .byt $54,$DF,$4A,$6A,$6A,$FE,$55
 .byt $6A,$51,$40,$40,$40,$62,$4A
 .byt $54,$D0,$C0,$C0,$C0,$C2,$55
 .byt $6A,$5F,$7F,$7F,$7F,$7E,$4A
 .byt $54,$C0,$C0,$C0,$C0,$C0,$55
;gfx_UpPower
; .byt $E1,$40,$40,$C1
; .byt $E1,$C0,$C1,$C1
; .byt $C1,$C1,$7E,$E1
; .byt $C1,$C1,$7E,$D1
; .byt $C1,$CD,$66,$E1
; .byt $C1,$D9,$72,$D1
; .byt $C1,$6F,$7A,$E1
; .byt $C1,$6F,$7A,$D1
; .byt $C1,$6F,$7A,$E1
; .byt $C1,$77,$76,$D1
; .byt $C1,$78,$4E,$E1
; .byt $C1,$7F,$7E,$D1
; .byt $C1,$40,$40,$E1
; .byt $C0,$D5,$D5,$D1
; .byt $C0,$75,$55,$E1
;gfx_UpFlip
; .byt $C1,$40,$40,$C1
; .byt $E1,$7F,$7E,$C1
; .byt $E1,$C1,$C1,$E1
; .byt $E1,$7C,$5E,$D1
; .byt $E1,$78,$4E,$E1
; .byt $E1,$7F,$7E,$D1
; .byt $E1,$C0,$C1,$E1
; .byt $C1,$7F,$7E,$D1
; .byt $C1,$78,$4E,$E1
; .byt $C1,$7C,$5E,$D1
; .byt $E1,$C1,$C1,$E1
; .byt $E1,$7F,$7E,$D1
; .byt $E1,$40,$40,$E1
; .byt $E0,$D5,$D5,$D0
; .byt $E0,$CA,$EA,$E0
;gfx_UpMirror
; .byt $C1,$40,$40,$C1
; .byt $C1,$7F,$7E,$C1
; .byt $E1,$C0,$C1,$E1
; .byt $D1,$7F,$7E,$D1
; .byt $E1,$7B,$6E,$E1
; .byt $D1,$73,$66,$D1
; .byt $E1,$63,$62,$E1
; .byt $D1,$73,$66,$D1
; .byt $E1,$7B,$6E,$E1
; .byt $D1,$7F,$7E,$D1
; .byt $E1,$C0,$C1,$E1
; .byt $D1,$7F,$7E,$D1
; .byt $E1,$40,$40,$E1
; .byt $D0,$D5,$D5,$D0
; .byt $E0,$CA,$EA,$E0
;gfx_UpUndo
; .byt $C1,$40,$40,$C1
; .byt $C1,$7F,$7E,$C1
; .byt $E1,$C0,$F1,$E0
; .byt $D1,$7C,$7E,$D0
; .byt $E1,$CC,$C1,$E0
; .byt $D1,$70,$6E,$D0
; .byt $E1,$70,$E9,$E0
; .byt $D1,$70,$6E,$D0
; .byt $E1,$70,$E9,$E0
; .byt $D1,$70,$6E,$D0
; .byt $E1,$70,$E9,$E0
; .byt $D1,$7F,$7E,$D0
; .byt $E1,$40,$40,$E0
; .byt $D0,$D5,$D5,$D0
; .byt $E0,$CA,$EA,$E0
;gfx_UpDisk
; .byt $C1,$40,$40,$C1
; .byt $C1,$C0,$C3,$C1
; .byt $C1,$C0,$4E,$E1
; .byt $C1,$C0,$F1,$D1
; .byt $C1,$C0,$4E,$E1
; .byt $C1,$C0,$C1,$D1
; .byt $C1,$60,$42,$E1
; .byt $C1,$D0,$C5,$D1
; .byt $C1,$6F,$7A,$E1
; .byt $C1,$D0,$C5,$D1
; .byt $C1,$6F,$7A,$E1
; .byt $C1,$D0,$C5,$D1
; .byt $C1,$40,$40,$E1
; .byt $C0,$6A,$6A,$D1
; .byt $C0,$CA,$EA,$E1
;gfx_UpYellow
; .byt $E1,$40,$40,$C1
; .byt $C1,$7F,$7E,$C1
; .byt $C1,$C0,$C1,$E1
; .byt $C1,$7F,$7E,$D1
; .byt $E1,$C0,$C1,$E1
; .byt $E1,$7F,$7E,$D1
; .byt $E1,$C0,$C1,$E1
; .byt $E1,$7F,$7E,$D1
; .byt $E1,$C0,$C1,$E1
; .byt $E1,$7F,$7E,$D1
; .byt $C1,$C0,$C1,$E1
; .byt $C1,$7F,$7E,$D1
; .byt $C1,$40,$40,$E1
; .byt $E0,$6A,$6A,$D0
; .byt $E0,$CA,$EA,$E0
;gfx_UpGreen
; .byt $C1,$40,$40,$C1
; .byt $C1,$7F,$7E,$C1
; .byt $E1,$7F,$7E,$E1
; .byt $D1,$7F,$7E,$D1
; .byt $E1,$7F,$7E,$E1
; .byt $D1,$7F,$7E,$D1
; .byt $E1,$7F,$7E,$E1
; .byt $D1,$7F,$7E,$D1
; .byt $E1,$7F,$7E,$E1
; .byt $D1,$7F,$7E,$D1
; .byt $E1,$7F,$7E,$E1
; .byt $D1,$7F,$7E,$D1
; .byt $E1,$40,$40,$E1
; .byt $D0,$6A,$6A,$D0
; .byt $E0,$CA,$EA,$E0
;gfx_UpWhite
; .byt $C1,$40,$40,$C0
; .byt $C1,$C0,$C1,$C0
; .byt $E1,$C0,$C1,$E0
; .byt $D1,$C0,$C1,$D0
; .byt $E1,$C0,$C1,$E0
; .byt $D1,$C0,$C1,$D0
; .byt $E1,$C0,$C1,$E0
; .byt $D1,$C0,$C1,$D0
; .byt $E1,$C0,$C1,$E0
; .byt $D1,$C0,$C1,$D0
; .byt $E1,$C0,$C1,$E0
; .byt $D1,$C0,$C1,$D0
; .byt $E1,$40,$40,$E0
; .byt $D0,$6A,$6A,$D0
; .byt $E0,$CA,$EA,$E0
;gfx_UpModem
; .byt $C1,$40,$40,$C1
; .byt $C1,$7B,$6E,$C1
; .byt $C1,$C4,$D1,$E1
; .byt $C1,$7B,$6E,$D1
; .byt $C1,$40,$40,$E1
; .byt $C1,$7B,$6E,$D1
; .byt $C1,$C4,$6E,$E1
; .byt $C1,$7B,$6E,$D1
; .byt $C1,$40,$40,$E1
; .byt $C1,$7B,$6E,$D1
; .byt $C1,$C4,$6E,$E1
; .byt $C1,$7B,$6E,$D1
; .byt $C1,$40,$40,$E1
; .byt $E0,$D5,$D5,$D1
; .byt $E0,$75,$55,$E1
;gfx_UpSound
; .byt $E1,$40,$40,$C1
; .byt $E1,$7F,$7E,$C1
; .byt $E1,$7F,$76,$E1
; .byt $E1,$7F,$66,$D1
; .byt $C1,$7F,$46,$E1
; .byt $C1,$72,$46,$D1
; .byt $C1,$72,$46,$E1
; .byt $E1,$72,$46,$D1
; .byt $E1,$7F,$46,$E1
; .byt $E1,$7F,$66,$D1
; .byt $E1,$7F,$76,$E1
; .byt $E1,$7F,$7E,$D1
; .byt $E1,$40,$40,$E1
; .byt $C0,$D5,$D5,$D0
; .byt $C0,$75,$55,$E0
;gfx_UpStats
; .byt $C1,$40,$40,$C1
; .byt $C1,$7F,$7E,$C1
; .byt $E1,$7F,$7E,$E1
; .byt $D1,$6F,$7E,$D1
; .byt $E1,$6F,$7E,$E1
; .byt $D1,$6E,$7E,$D1
; .byt $E1,$6E,$7A,$E1
; .byt $D1,$6E,$7A,$D1
; .byt $E1,$6E,$6A,$E1
; .byt $D1,$6A,$6A,$D1
; .byt $E1,$6A,$6A,$E1
; .byt $D1,$7F,$7E,$D1
; .byt $E1,$40,$40,$E1
; .byt $D0,$D5,$D5,$D0
; .byt $E0,$75,$55,$E0
;gfx_UpPause
; .byt $C1,$40,$40,$C0
; .byt $C1,$7F,$7E,$C0
; .byt $E1,$7F,$7E,$E0
; .byt $D1,$79,$4E,$D0
; .byt $E1,$79,$4E,$E0
; .byt $D1,$79,$4E,$D0
; .byt $E1,$79,$4E,$E0
; .byt $D1,$79,$4E,$D0
; .byt $E1,$79,$4E,$E0
; .byt $D1,$79,$4E,$D0
; .byt $E1,$7F,$7E,$E0
; .byt $D1,$7F,$7E,$D0
; .byt $E1,$40,$40,$E0
; .byt $D0,$D5,$D5,$D1
; .byt $E0,$75,$55,$E1

gfx_DownPower	;4x15
 .byt $E0,$55,$55,$C1
 .byt $E1,$40,$40,$C1
 .byt $C0,$5F,$7F,$C1
 .byt $C1,$5F,$5F,$C1
 .byt $C0,$5F,$5F,$C1
 .byt $C1,$59,$53,$C1
 .byt $C0,$53,$59,$C1
 .byt $C1,$57,$C2,$C1
 .byt $C0,$57,$C2,$C1
 .byt $C1,$57,$C2,$C1
 .byt $C0,$5B,$C4,$C1
 .byt $C1,$5C,$47,$C1
 .byt $C0,$5F,$C0,$C1
 .byt $C0,$C0,$C0,$C1
 .byt $C0,$C0,$C0,$C1
gfx_DownFlip
 .byt $C0,$55,$55,$C1
 .byt $E1,$40,$40,$C1
 .byt $E0,$E0,$C0,$C1
 .byt $E1,$5F,$5F,$C1
 .byt $E0,$5E,$4F,$C1
 .byt $E1,$5C,$47,$C1
 .byt $E0,$E0,$C0,$C1
 .byt $C1,$5F,$7F,$C1
 .byt $C0,$E0,$C0,$C1
 .byt $C1,$5C,$47,$C1
 .byt $E0,$E1,$F0,$C1
 .byt $E1,$5F,$5F,$C1
 .byt $E0,$E0,$C0,$C1
 .byt $E0,$7F,$7F,$C0
 .byt $E0,$C0,$C0,$C0
gfx_DownMirror
 .byt $C0,$55,$55,$C1
 .byt $C1,$40,$40,$C1
 .byt $E0,$E0,$C0,$C1
 .byt $D1,$5F,$7F,$C1
 .byt $E0,$5F,$7F,$C1
 .byt $D1,$5D,$77,$C1
 .byt $E0,$59,$CC,$C1
 .byt $D1,$51,$71,$C1
 .byt $E0,$59,$CC,$C1
 .byt $D1,$5D,$77,$C1
 .byt $E0,$E0,$C0,$C1
 .byt $D1,$5F,$7F,$C1
 .byt $E0,$E0,$C0,$C1
 .byt $D0,$7F,$7F,$C0
 .byt $E0,$C0,$C0,$C0
gfx_DownUndo
 .byt $C0,$55,$55,$C1
 .byt $C1,$40,$40,$C1
 .byt $E0,$E0,$C0,$C0
 .byt $D1,$5F,$67,$C0
 .byt $E0,$E1,$E0,$C0
 .byt $D1,$59,$7F,$C0
 .byt $E0,$58,$E8,$C0
 .byt $D1,$58,$4B,$C0
 .byt $E0,$58,$E8,$C0
 .byt $D1,$58,$4B,$C0
 .byt $E0,$58,$E8,$C0
 .byt $D1,$58,$4B,$C0
 .byt $E0,$E0,$C0,$C0
 .byt $D0,$7F,$7F,$C0
 .byt $E0,$C0,$C0,$C0
gfx_DownDisk
 .byt $C0,$EA,$EA,$C1
 .byt $C1,$40,$40,$C1
 .byt $C0,$5F,$7E,$C1
 .byt $C1,$5F,$67,$C1
 .byt $C0,$5F,$67,$C1
 .byt $C1,$5F,$67,$C1
 .byt $C0,$5F,$C0,$C1
 .byt $C1,$EF,$FE,$C1
 .byt $C0,$57,$C2,$C1
 .byt $C1,$E8,$C2,$C1
 .byt $C0,$57,$C2,$C1
 .byt $C1,$E8,$C2,$C1
 .byt $C0,$57,$7D,$C1
 .byt $C0,$7F,$7F,$C1
 .byt $C0,$C0,$C0,$C1
gfx_DownYellow
 .byt $E0,$EA,$EA,$C1
 .byt $C1,$40,$40,$C1
 .byt $C0,$E0,$C0,$C1
 .byt $C1,$5F,$7F,$C1
 .byt $E0,$E0,$C0,$C1
 .byt $E1,$5F,$7F,$C1
 .byt $E0,$E0,$C0,$C1
 .byt $E1,$5F,$7F,$C1
 .byt $E0,$E0,$C0,$C1
 .byt $E1,$5F,$7F,$C1
 .byt $C0,$E0,$C0,$C1
 .byt $C1,$5F,$7F,$C1
 .byt $C0,$7F,$7F,$C1
 .byt $E0,$C0,$C0,$C0
 .byt $E0,$C0,$C0,$C0
gfx_DownGreen
 .byt $C0,$EA,$EA,$C1
 .byt $C1,$40,$40,$C1
 .byt $E0,$5F,$7F,$C1
 .byt $D1,$5F,$7F,$C1
 .byt $E0,$5F,$7F,$C1
 .byt $D1,$5F,$7F,$C1
 .byt $E0,$5F,$7F,$C1
 .byt $D1,$5F,$7F,$C1
 .byt $E0,$5F,$7F,$C1
 .byt $D1,$5F,$7F,$C1
 .byt $E0,$5F,$7F,$C1
 .byt $D1,$5F,$7F,$C1
 .byt $E0,$5F,$7F,$C1
 .byt $D0,$C0,$C0,$C0
 .byt $E0,$C0,$C0,$C0
gfx_DownWhite
 .byt $C0,$EA,$EA,$C0
 .byt $C1,$40,$40,$C0
 .byt $E0,$E0,$C0,$C0
 .byt $D1,$E0,$C0,$C0
 .byt $E0,$E0,$C0,$C0
 .byt $D1,$E0,$C0,$C0
 .byt $E0,$E0,$C0,$C0
 .byt $D1,$E0,$C0,$C0
 .byt $E0,$E0,$C0,$C0
 .byt $D1,$E0,$C0,$C0
 .byt $E0,$E0,$C0,$C0
 .byt $D1,$E0,$C0,$C0
 .byt $E0,$5F,$7F,$C0
 .byt $D0,$C0,$C0,$C0
 .byt $E0,$C0,$C0,$C0
gfx_DownModem
 .byt $C0,$55,$55,$C1
 .byt $C1,$40,$40,$C1
 .byt $C0,$5D,$C8,$C1
 .byt $C1,$5D,$77,$C1
 .byt $C0,$5D,$C8,$C1
 .byt $C1,$40,$40,$C1
 .byt $C0,$5D,$C8,$C1
 .byt $C1,$5D,$77,$C1
 .byt $C0,$5D,$C8,$C1
 .byt $C1,$40,$40,$C1
 .byt $C0,$E2,$C8,$C1
 .byt $C1,$5D,$77,$C1
 .byt $C0,$E2,$C8,$C1
 .byt $E0,$7F,$7F,$C1
 .byt $E0,$C0,$C0,$C1
gfx_DownSound
 .byt $E0,$55,$55,$C1
 .byt $E1,$40,$40,$C1
 .byt $E0,$5F,$7F,$C1
 .byt $E1,$5F,$7B,$C1
 .byt $C0,$5F,$73,$C1
 .byt $C1,$5F,$63,$C1
 .byt $C0,$59,$43,$C1
 .byt $E1,$59,$43,$C1
 .byt $E0,$59,$43,$C1
 .byt $E1,$5F,$63,$C1
 .byt $E0,$5F,$CC,$C1
 .byt $E1,$5F,$C4,$C1
 .byt $E0,$E0,$C0,$C1
 .byt $C0,$7F,$7F,$C0
 .byt $C0,$C0,$C0,$C0
gfx_DownStats
 .byt $C0,$55,$55,$C1
 .byt $C1,$40,$40,$C1
 .byt $E0,$5F,$7F,$C1
 .byt $D1,$5F,$7F,$C1
 .byt $E0,$57,$7F,$C1
 .byt $D1,$57,$7F,$C1
 .byt $E0,$57,$5F,$C1
 .byt $D1,$57,$5D,$C1
 .byt $E0,$57,$5D,$C1
 .byt $D1,$57,$55,$C1
 .byt $E0,$55,$EA,$C1
 .byt $D1,$55,$55,$C1
 .byt $E0,$E0,$C0,$C1
 .byt $D0,$7F,$7F,$C0
 .byt $E0,$C0,$C0,$C0
gfx_DownPause
 .byt $C0,$55,$55,$C0
 .byt $C1,$40,$40,$C0
 .byt $E0,$5F,$7F,$C0
 .byt $D1,$5F,$7F,$C0
 .byt $E0,$5C,$67,$C0
 .byt $D1,$5C,$67,$C0
 .byt $E0,$5C,$67,$C0
 .byt $D1,$5C,$67,$C0
 .byt $E0,$5C,$D8,$C0
 .byt $D1,$5C,$67,$C0
 .byt $E0,$5C,$D8,$C0
 .byt $D1,$5F,$7F,$C0
 .byt $E0,$E0,$C0,$C0
 .byt $D0,$7F,$7F,$C0
 .byt $E0,$C0,$C0,$C1
