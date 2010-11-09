;GenerateMap.s

;B0 Possible TL
;B1 Possible TR 
;B2 Possible BL
;B3 Possible BR	
RoomLayoutProperty	;7x8
 .byt 8,12,12,12,12,12,4
 .byt 10,15,15,15,15,15,10
 .byt 10,15,15,15,15,15,10
 .byt 10,15,15,15,15,15,10
 .byt 10,15,15,15,15,15,10
 .byt 10,15,15,15,15,15,10
 .byt 10,15,15,15,15,15,10
 .byt 2,3,3,3,3,3,1 
 

;B0 Entrance TL
;B1 Entrance TR 
;B2 Entrance BL
;B3 Entrance BR	
;B7 Used
RoomProperty
 .byt ENTRANCE_BR		;00
 .byt ENTRANCE_BL+ENTRANCE_TR ;01  
 .byt ENTRANCE_BR             ;02
 .byt ENTRANCE_TL+ENTRANCE_TR ;03  
 .byt ENTRANCE_TR             ;04
 .byt ENTRANCE_TR             ;05
 .byt ENTRANCE_TR+ENTRANCE_BL ;06  
 .byt ENTRANCE_BR+ENTRANCE_TL ;07  
 .byt ENTRANCE_TR+ENTRANCE_BL ;08  
 .byt ENTRANCE_TL+ENTRANCE_BR ;09  
 .byt ENTRANCE_BL             ;10
 .byt ENTRANCE_BL             ;11
 .byt ENTRANCE_TL+ENTRANCE_TR ;12  
 .byt ENTRANCE_BL             ;13
 .byt ENTRANCE_BL+ENTRANCE_TR ;14  
 .byt ENTRANCE_BL+ENTRANCE_BR ;15  
 .byt ENTRANCE_TL             ;16
 .byt ENTRANCE_BL+ENTRANCE_BR ;17  
 .byt ENTRANCE_TR             ;18
 .byt ENTRANCE_TL+ENTRANCE_BR ;19  
 .byt ENTRANCE_BR             ;20
 .byt ENTRANCE_BL+ENTRANCE_BR ;21  
 .byt ENTRANCE_TL             ;22
 .byt ENTRANCE_TR             ;23
 .byt ENTRANCE_BL+ENTRANCE_TR ;24  
 .byt ENTRANCE_TL+ENTRANCE_TR ;25  
 .byt ENTRANCE_TL+ENTRANCE_TR ;26  
 .byt ENTRANCE_TL+ENTRANCE_BR ;27  
 .byt ENTRANCE_TL             ;28
 .byt ENTRANCE_TL             ;29
 .byt ENTRANCE_BR             ;30
 .byt ENTRANCE_BL+ENTRANCE_TR ;31  


;13x8
;B0-6 Character
;	0-31   Rooms
;	32-127 Direct Character code
;		57 shm_Shaft
;		58 shm_ShaftTL
;		59 shm_ShaftTR
;		60 shm_ShaftBL
;		61 shm_ShaftBR
;		62 shm_ShaftTLTR
;		63 shm_ShaftTLBR
;		64 shm_ShaftBLTR
;		65 shm_ShaftBLBR
;B7   Plundered Flag		+$80
;255  Room or Lift does not exist
;Rules are
; Top of map must only contain rooms with ground floor exits
;RoomsMap
; .byt 128+$02,128+65,128+$00,128+57,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
; .byt 128+$04,128+62,128+$03,128+58,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
; .byt 128+$05,128+63,128+$01,128+58,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
; .byt $FF,128+61,128+$06,128+58,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
; .byt $FF,128+57,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
; .byt $FF,128+57,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
; .byt $FF,128+57,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
; .byt $FF,128+57,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF

;Rules
;1) Top Left corner can only be BR    
;2) Top Right corner can only be BL   
;3) Top row can only be BL or BR      
;4) Left column can only be BR or TR  
;5) Right column can only be BL or TL 
;6) Bottom Row can only be TL or TR   
;7) Bottom Left corner can only be TR 
;8) Bottom Right corner can only be TL

;9) Must use all rooms when generating
;10) Must have a clear path from leftmost room column to rightmost lift column
GenerateMap
	;Clear 13x8 map
	ldx #103
	lda #$FF
.(
loop1	sta RoomsMap,x
	dex
	bpl loop1
.)
	;Clear RoomUsed Flags
	ldx #31
.(
loop1	lda RoomProperty,x
	and #127
	sta RoomProperty,x
	dex
	bpl loop1
.)
	;Draw line of rooms from left to right
	lda #00
	sta Room_X
.(
loop1
	jsr GetRandomNumber
	and #7
	sta Room_Y
	jsr GetRandomRoom
	bcs loop1	;This Position Is Used
	;Translate Room_X(0-6) and Room_Y(0-7) to Map Offset
	
	

	
GetRandomRoom
	lda Room_X
	asl
	asl
	asl
	ora Room_Y
	tay
	lda RoomProperty,y
	bmi Abort
	
	
	

	cmp #12
	beq EastSide
	lda Room_Y
	beq NorthSide
	cmp #7
	beq SouthSide
	
	
	