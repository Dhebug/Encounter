;StrongholdRoutines.s
;Rooms are organised as a map of 7x8(columns x rows) Bytes.
;Each cell holds a value from 0 to 127. +128 to indicate room or corridor has been visited.
;Cell values of 0-31 are rooms and 32 to 127 are lift shaft codes (directly specify ObjectID).

;On entering the Lift shaft the map is drawn in the bgbuffer and then copied to screen.
;The current Ethan position in the complex tracks the bgbuffer whilst the screen displays
;his position with a glowing pixel group.

;Note- when ethan enters a room the map may still be present on screen and the bgbuffer will be overwritten.
;      this is not such an issue since the game doesn't rely on the map whilst in a room.


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

StripAddressTableLo
 .byt <Strip_LeftEarth_RightEarth_Map
 .byt <Strip_LeftCorridor_RightEarth_Map
 .byt <Strip_LeftEarth_RightCorridor_Map
 .byt <Strip_LeftCorridor_RightCorridor_Map
StripAddressTableHi
 .byt >Strip_LeftEarth_RightEarth_Map
 .byt >Strip_LeftCorridor_RightEarth_Map
 .byt >Strip_LeftEarth_RightCorridor_Map
 .byt >Strip_LeftCorridor_RightCorridor_Map

Strip_LeftEarth_RightEarth_Map
 .byt 16*4  
 .byt 1+16*5
 .byt 2+16*6
 .byt 3+16*7
 .byt 16*4  
 .byt 1+16*5
 .byt 2+16*6
 .byt 3+16*7
 .byt 16*4  
 .byt 16*4  
 .byt 1+16*5
 .byt 2+16*6
 .byt 3+16*7
 .byt 16*4  
 .byt 1+16*5
 .byt 2+16*6
 .byt 3+16*7
 .byt 16*4  
 .byt 16*4  
 .byt 1+16*5
 .byt 2+16*6
 .byt 3+16*7
 .byt 16*4  
 .byt 1+16*5
 .byt 2+16*6

Strip_LeftCorridor_RightEarth_Map
 .byt 16*4  
 .byt 1+16*5
 .byt 2+16*6
 .byt 3+16*7
 .byt 16*4  
 .byt 1+16*5
 .byt 2+16*6
 .byt 3+16*7
 .byt 16*4  
 .byt 8+16*4
 .byt 9+16*5
 .byt 10+16*6
 .byt 10+16*7
 .byt 10+16*4
 .byt 10+16*5
 .byt 11+16*6
 .byt 16*4  
 .byt 1+16*5
 .byt 2+16*6
 .byt 3+16*7
 .byt 16*4  
 .byt 1+16*5
 .byt 2+16*6
 .byt 3+16*7
 .byt 16*4  
Strip_LeftEarth_RightCorridor_Map
 .byt 16*4  
 .byt 1+16*5
 .byt 2+16*6
 .byt 3+16*7
 .byt 16*4  
 .byt 1+16*5
 .byt 2+16*6
 .byt 3+16*7
 .byt 16*4  
 .byt 16*12
 .byt 1+16*13
 .byt 2+16*14
 .byt 3+16*14
 .byt 1+16*14
 .byt 2+16*14
 .byt 3+16*15
 .byt 16*4  
 .byt 1+16*5
 .byt 2+16*6
 .byt 3+16*7
 .byt 16*4  
 .byt 1+16*5
 .byt 2+16*6
 .byt 3+16*7
 .byt 16*4  
Strip_LeftCorridor_RightCorridor_Map
 .byt 16*4
 .byt 1+16*5
 .byt 2+16*6
 .byt 3+16*7
 .byt 16*4
 .byt 1+16*5
 .byt 2+16*6
 .byt 3+16*7
 .byt 16*4
 .byt 8+16*12
 .byt 9+16*13
 .byt 10+16*14
 .byt 10+16*14
 .byt 10+16*14
 .byt 10+16*14
 .byt 11+16*15
 .byt 16*4  
 .byt 1+16*5
 .byt 2+16*6
 .byt 3+16*7
 .byt 16*4  
 .byt 1+16*5
 .byt 2+16*6
 .byt 3+16*7
 .byt 16*4  

ScreenOffset17x6
 .byt 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17
 .byt 40+1,40+2,40+3,40+4,40+5,40+6,40+7,40+8,40+9,40+10,40+11,40+12,40+13,40+14,40+15,40+16,40+17
 .byt 80+1,80+2,80+3,80+4,80+5,80+6,80+7,80+8,80+9,80+10,80+11,80+12,80+13,80+14,80+15,80+16,80+17
 .byt 120+1,120+2,120+3,120+4,120+5,120+6,120+7,120+8,120+9,120+10,120+11,120+12,120+13,120+14,120+15,120+16,120+17
 .byt 160+1,160+2,160+3,160+4,160+5,160+6,160+7,160+8,160+9,160+10,160+11,160+12,160+13,160+14,160+15,160+16,160+17
 .byt 200+1,200+2,200+3,200+4,200+5,200+6,200+7,200+8,200+9,200+10,200+11,200+12,200+13,200+14,200+15,200+16,200+17
ScreenOffset16x6
 .byt 24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39
 .byt 40+24,40+25,40+26,40+27,40+28,40+29,40+30,40+31,40+32,40+33,40+34,40+35,40+36,40+37,40+38,40+39
 .byt 80+24,80+25,80+26,80+27,80+28,80+29,80+30,80+31,80+32,80+33,80+34,80+35,80+36,80+37,80+38,80+39
 .byt 120+24,120+25,120+26,120+27,120+28,120+29,120+30,120+31,120+32,120+33,120+34,120+35,120+36,120+37,120+38,120+39
 .byt 160+24,160+25,160+26,160+27,160+28,160+29,160+30,160+31,160+32,160+33,160+34,160+35,160+36,160+37,160+38,160+39
 .byt 200+24,200+25,200+26,200+27,200+28,200+29,200+30,200+31,200+32,200+33,200+34,200+35,200+36,200+37,200+38,200+39

lsm_GraphicAddressLo
 .byt <lsm_LeftEarthMix0  		;00
 .byt <lsm_LeftEarthMix1                ;01
 .byt <lsm_LeftEarthMix2                ;02
 .byt <lsm_LeftEarthMix3                ;03
 .byt <lsm_RightEarthMix0  		;04
 .byt <lsm_RightEarthMix1               ;05 
 .byt <lsm_RightEarthMix2               ;06 
 .byt <lsm_RightEarthMix3               ;07 
 .byt <lsm_LeftCorridorStrip            ;08
 .byt <lsm_LeftCorridorShadow           ;09
 .byt <lsm_LeftCorridorColumns          ;10
 .byt <lsm_LeftCorridorFloor            ;11
 .byt <lsm_RightCorridorStrip           ;12
 .byt <lsm_RightCorridorShadow          ;13
 .byt <lsm_RightCorridorColumns         ;14
 .byt <lsm_RightCorridorFloor           ;15
lsm_GraphicAddressHi
 .byt >lsm_LeftEarthMix0  		;00
 .byt >lsm_LeftEarthMix1                ;01
 .byt >lsm_LeftEarthMix2                ;02
 .byt >lsm_LeftEarthMix3                ;03
 .byt >lsm_RightEarthMix0  		;04
 .byt >lsm_RightEarthMix1               ;05 
 .byt >lsm_RightEarthMix2               ;06 
 .byt >lsm_RightEarthMix3               ;07 
 .byt >lsm_LeftCorridorStrip            ;08
 .byt >lsm_LeftCorridorShadow           ;09
 .byt >lsm_LeftCorridorColumns          ;10
 .byt >lsm_LeftCorridorFloor            ;11
 .byt >lsm_RightCorridorStrip           ;12
 .byt >lsm_RightCorridorShadow          ;13
 .byt >lsm_RightCorridorColumns         ;14
 .byt >lsm_RightCorridorFloor           ;15

lsm_LeftEarthMix0  		;00 17x6
 .byt $49,$40,$44,$40,$6C,$60,$58,$4A,$6C,$4C,$7E,$43,$58,$55,$58,$68,$D0
 .byt $50,$46,$50,$40,$68,$51,$40,$63,$50,$41,$50,$49,$7D,$78,$5C,$40,$DE
 .byt $58,$5C,$41,$50,$52,$58,$42,$58,$48,$41,$41,$40,$40,$40,$44,$42,$C2
 .byt $70,$42,$40,$40,$44,$52,$69,$48,$51,$52,$63,$4B,$47,$70,$45,$40,$DE
 .byt $40,$62,$48,$50,$40,$42,$58,$40,$61,$44,$48,$41,$40,$50,$40,$4C,$D0
 .byt $70,$44,$52,$40,$70,$40,$42,$41,$50,$53,$61,$40,$44,$60,$63,$48,$DE
lsm_LeftEarthMix1  		;01 17x6
 .byt $41,$72,$4B,$44,$68,$62,$41,$60,$45,$44,$54,$40,$51,$40,$58,$40,$C2
 .byt $40,$60,$48,$73,$60,$44,$50,$40,$4A,$40,$45,$40,$48,$42,$62,$40,$DE
 .byt $46,$43,$54,$70,$44,$62,$44,$42,$40,$40,$50,$55,$4A,$4D,$40,$66,$D0
 .byt $68,$4A,$48,$68,$69,$4A,$69,$50,$48,$40,$50,$44,$40,$62,$74,$46,$DE
 .byt $40,$60,$40,$4C,$66,$40,$42,$40,$50,$49,$58,$50,$44,$49,$60,$50,$C2
 .byt $50,$6C,$41,$60,$4A,$78,$4D,$54,$42,$40,$50,$50,$40,$48,$54,$40,$DE
lsm_LeftEarthMix2  		;02 17x6
 .byt $40,$40,$4A,$60,$42,$40,$68,$64,$51,$40,$43,$46,$43,$50,$61,$60,$D0
 .byt $51,$40,$40,$40,$70,$40,$42,$61,$40,$44,$44,$40,$42,$40,$52,$40,$DE
 .byt $48,$42,$60,$40,$4C,$40,$68,$60,$70,$41,$42,$41,$44,$42,$58,$60,$C2
 .byt $60,$40,$44,$47,$42,$62,$52,$4A,$4E,$54,$40,$4C,$41,$44,$70,$40,$DE
 .byt $72,$50,$45,$40,$6C,$50,$40,$40,$62,$63,$40,$41,$4A,$40,$50,$50,$D0
 .byt $40,$57,$79,$49,$50,$48,$4B,$42,$40,$42,$58,$44,$55,$59,$40,$48,$DE
lsm_LeftEarthMix3  		;03 17x6
 .byt $41,$71,$70,$4B,$46,$41,$60,$4E,$4C,$50,$42,$60,$5C,$61,$74,$40,$C2
 .byt $48,$4C,$40,$62,$42,$61,$58,$48,$59,$64,$49,$44,$50,$41,$44,$72,$DE
 .byt $40,$40,$40,$43,$45,$48,$68,$58,$49,$5E,$46,$63,$64,$4A,$41,$70,$D0
 .byt $56,$60,$40,$40,$50,$48,$48,$60,$40,$42,$54,$4C,$4A,$40,$42,$48,$DE
 .byt $40,$41,$6C,$48,$41,$40,$51,$52,$50,$40,$4F,$48,$40,$43,$74,$42,$C2
 .byt $78,$68,$46,$40,$61,$5E,$68,$42,$44,$48,$41,$40,$44,$40,$64,$48,$DE
lsm_LeftCorridorStrip         ;08
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$C0
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$D2
 .byt $C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C1,$D2
 .byt $7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7E,$7F
 .byt $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
 .byt $40,$40,$41,$C0,$C0,$C0,$60,$40,$41,$C0,$C0,$C0,$60,$40,$40,$40,$40
lsm_LeftCorridorShadow        ;09
 .byt $55,$F3,$54,$40,$40,$40,$45,$F3,$54,$40,$40,$40,$45,$F3,$55,$55,$54
 .byt $6A,$40,$6A,$6A,$6A,$6A,$6A,$40,$6A,$6A,$6A,$6A,$6A,$40,$6A,$6A,$6A
 .byt $55,$F3,$55,$55,$55,$55,$55,$F3,$55,$55,$55,$55,$55,$F3,$55,$55,$54
 .byt $6A,$40,$6A,$6A,$6A,$6A,$6A,$40,$6A,$6A,$6A,$6A,$6A,$40,$6A,$6A,$6A
 .byt $55,$F3,$55,$55,$55,$55,$55,$F3,$55,$55,$55,$55,$55,$F3,$55,$55,$54
 .byt $6A,$40,$6A,$6A,$6A,$6A,$6A,$40,$6A,$6A,$6A,$6A,$6A,$40,$6A,$6A,$6A
lsm_LeftCorridorColumns       ;10
 .byt $55,$F3,$55,$55,$55,$55,$55,$F3,$55,$55,$55,$55,$55,$F3,$55,$55,$54
 .byt $6A,$40,$6A,$6A,$6A,$6A,$6A,$40,$6A,$6A,$6A,$6A,$6A,$40,$6A,$6A,$6A
 .byt $55,$F3,$55,$55,$55,$55,$55,$F3,$55,$55,$55,$55,$55,$F3,$55,$55,$54
 .byt $6A,$40,$6A,$6A,$6A,$6A,$6A,$40,$6A,$6A,$6A,$6A,$6A,$40,$6A,$6A,$6A
 .byt $55,$F3,$55,$55,$55,$55,$55,$F3,$55,$55,$55,$55,$55,$F3,$55,$55,$54
 .byt $6A,$40,$6A,$6A,$6A,$6A,$6A,$40,$6A,$6A,$6A,$6A,$6A,$40,$6A,$6A,$6A
lsm_LeftCorridorFloor         ;11
 .byt $40,$F3,$40,$40,$40,$40,$40,$F3,$40,$40,$40,$40,$40,$F3,$40,$40,$40
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
 .byt $C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C1,$C0
 .byt $7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7E,$D2
 .byt $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$D2
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$C0
lsm_RightEarthMix0  	;04
 .byt $D0,$50,$57,$42,$40,$40,$60,$50,$46,$70,$44,$40,$66,$51,$40,$44
 .byt $DE,$48,$60,$71,$49,$40,$41,$50,$50,$43,$43,$50,$42,$40,$61,$60
 .byt $C2,$48,$40,$54,$64,$54,$40,$60,$40,$40,$53,$50,$40,$44,$40,$44
 .byt $DE,$40,$48,$62,$4A,$48,$60,$44,$50,$49,$60,$44,$43,$40,$50,$40
 .byt $D0,$41,$62,$40,$4D,$4C,$40,$68,$40,$41,$42,$44,$70,$66,$62,$40
 .byt $DE,$40,$58,$40,$41,$42,$67,$40,$48,$40,$48,$70,$40,$49,$40,$46
lsm_RightEarthMix1  	;04
 .byt $C2,$40,$52,$73,$42,$40,$42,$41,$62,$5A,$50,$50,$54,$42,$48,$68
 .byt $DE,$58,$44,$60,$72,$60,$42,$68,$68,$42,$61,$62,$44,$42,$51,$40
 .byt $D0,$43,$61,$40,$60,$52,$71,$40,$51,$40,$41,$42,$46,$40,$42,$46
 .byt $DE,$40,$5E,$60,$40,$40,$56,$41,$48,$44,$42,$4F,$48,$48,$44,$48
 .byt $C2,$44,$68,$40,$54,$6A,$40,$42,$4A,$40,$60,$65,$71,$40,$41,$4A
 .byt $DE,$50,$40,$40,$40,$40,$61,$68,$61,$60,$70,$45,$41,$48,$51,$43
lsm_RightEarthMix2  	;04
 .byt $D0,$52,$68,$50,$40,$48,$40,$40,$40,$40,$68,$40,$60,$62,$60,$44
 .byt $DE,$40,$54,$50,$75,$44,$4D,$40,$44,$70,$45,$6D,$44,$46,$68,$61
 .byt $C2,$4C,$60,$60,$61,$42,$44,$40,$60,$41,$40,$60,$60,$46,$54,$5D
 .byt $DE,$50,$50,$48,$50,$50,$44,$64,$60,$48,$40,$40,$44,$50,$40,$68
 .byt $D0,$44,$63,$50,$40,$41,$64,$4C,$40,$40,$40,$41,$41,$50,$66,$40
 .byt $DE,$44,$64,$45,$50,$58,$50,$4C,$42,$42,$58,$60,$45,$40,$40,$40
lsm_RightEarthMix3  	;04
 .byt $C2,$51,$63,$49,$78,$48,$60,$68,$41,$60,$40,$74,$50,$48,$58,$55
 .byt $DE,$44,$56,$60,$51,$51,$4D,$40,$52,$49,$48,$49,$40,$60,$61,$42
 .byt $D0,$48,$50,$40,$62,$60,$40,$53,$69,$58,$70,$40,$41,$68,$40,$4A
 .byt $DE,$50,$48,$60,$48,$64,$40,$40,$4B,$40,$51,$40,$6C,$70,$71,$40
 .byt $C2,$47,$64,$44,$44,$4A,$60,$44,$41,$60,$48,$42,$40,$50,$50,$64
 .byt $DE,$42,$6B,$42,$41,$49,$45,$48,$41,$60,$44,$49,$54,$44,$55,$50
lsm_RightCorridorStrip        ;12
 .byt $C0,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
 .byt $D2,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
 .byt $D2,$E0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0
 .byt $7F,$5F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F
 .byt $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
 .byt $40,$40,$41,$C0,$C0,$C0,$60,$40,$41,$C0,$C0,$C0,$60,$40,$40,$40
lsm_RightCorridorShadow       ;13
 .byt $55,$F3,$54,$40,$40,$40,$45,$F3,$54,$40,$40,$40,$45,$F3,$55,$55
 .byt $4A,$40,$6A,$6A,$6A,$6A,$6A,$40,$6A,$6A,$6A,$6A,$6A,$40,$6A,$6A
 .byt $55,$F3,$55,$55,$55,$55,$55,$F3,$55,$55,$55,$55,$55,$F3,$55,$55
 .byt $4A,$40,$6A,$6A,$6A,$6A,$6A,$40,$6A,$6A,$6A,$6A,$6A,$40,$6A,$6A
 .byt $55,$F3,$55,$55,$55,$55,$55,$F3,$55,$55,$55,$55,$55,$F3,$55,$55
 .byt $4A,$40,$6A,$6A,$6A,$6A,$6A,$40,$6A,$6A,$6A,$6A,$6A,$40,$6A,$6A
lsm_RightCorridorColumns      ;14
 .byt $55,$F3,$55,$55,$55,$55,$55,$F3,$55,$55,$55,$55,$55,$F3,$55,$55
 .byt $4A,$40,$6A,$6A,$6A,$6A,$6A,$40,$6A,$6A,$6A,$6A,$6A,$40,$6A,$6A
 .byt $55,$F3,$55,$55,$55,$55,$55,$F3,$55,$55,$55,$55,$55,$F3,$55,$55
 .byt $4A,$40,$6A,$6A,$6A,$6A,$6A,$40,$6A,$6A,$6A,$6A,$6A,$40,$6A,$6A
 .byt $55,$F3,$55,$55,$55,$55,$55,$F3,$55,$55,$55,$55,$55,$F3,$55,$55
 .byt $4A,$40,$6A,$6A,$6A,$6A,$6A,$40,$6A,$6A,$6A,$6A,$6A,$40,$6A,$6A
lsm_RightCorridorFloor        ;15
 .byt $40,$F3,$40,$40,$40,$40,$40,$F3,$40,$40,$40,$40,$40,$F3,$40,$40
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
 .byt $C0,$E0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0
 .byt $D2,$5F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F
 .byt $D2,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
 .byt $C0,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40

ExitRoom
	;Eye-Close room
	jsr EyeCloseRoom
	
	jsr lsm_DisplayComplexMap
	
	jsr lsm_RenderFullScreenBG
	
	jsr EyeOpenRoom
	
	jsr lsm_GenerateCollisionMap
	
twi99	nop
	jmp twi99


lsm_BGBufferRowLo
lsm_ScreenRowLo
 .byt <$A000
 .byt <$A000+240*1
 .byt <$A000+240*2
 .byt <$A000+240*3
 .byt <$A000+240*4
 .byt <$A000+240*5
 .byt <$A000+240*6
 .byt <$A000+240*7
 .byt <$A000+240*8
 .byt <$A000+240*9
 .byt <$A000+240*10
 .byt <$A000+240*11
 .byt <$A000+240*12
 .byt <$A000+240*13
 .byt <$A000+240*14
 .byt <$A000+240*15
 .byt <$A000+240*16
 .byt <$A000+240*17
 .byt <$A000+240*18
 .byt <$A000+240*19
 .byt <$A000+240*20
 .byt <$A000+240*21
 .byt <$A000+240*22
 .byt <$A000+240*23
 .byt <$A000+240*24
lsm_BGBufferRowHi
lsm_ScreenRowHi
 .byt >$A000
 .byt >$A000+240*1
 .byt >$A000+240*2
 .byt >$A000+240*3
 .byt >$A000+240*4
 .byt >$A000+240*5
 .byt >$A000+240*6
 .byt >$A000+240*7
 .byt >$A000+240*8
 .byt >$A000+240*9
 .byt >$A000+240*10
 .byt >$A000+240*11
 .byt >$A000+240*12
 .byt >$A000+240*13
 .byt >$A000+240*14
 .byt >$A000+240*15
 .byt >$A000+240*16
 .byt >$A000+240*17
 .byt >$A000+240*18
 .byt >$A000+240*19
 .byt >$A000+240*20
 .byt >$A000+240*21
 .byt >$A000+240*22
 .byt >$A000+240*23
 .byt >$A000+240*24
	
lsm_RenderFullScreenBG
	;Calc location in MapOfRooms
	jsr CalcLocationInMapOfRooms
	
	;Fetch The room code to the left
	ldy MapOfRooms-1,x
	
	;Branch if Ethan is on bottom exit corridor
	lda RoomPositionY
	lsr
.(
	bcc skip1
	
	;Check Bottom Right exit
	;B0 Top Left exit
	;B1 Top Right exit
	;B2 Bottom Left Exit
	;B3 Bottom Right Exit
	lda RoomExits,y
	ldy #0
	and #BIT3
	beq skip3
	ldy #2
skip3	sty Temp01
	
	;Fetch The room code to the right
	ldy MapOfRooms+1,x
	
	;Check Bottom Left exit
	lda RoomExits,y
	ldy #0
	and #BIT2
	beq skip4
	ldy #1
skip4	tya
	ora Temp01

	jmp skip2
	
	
skip1	;Check Top Right exit
	lda RoomExits,y
	ldy #0
	and #BIT1
	beq skip5
	ldy #2
skip5	sty Temp01
	
	;Fetch The room code to the right
	ldy MapOfRooms+1,x
	
	;Check Top Left exit
	lda RoomExits,y
	ldy #0
	and #BIT0
	beq skip6
	ldy #1
skip6	tya
	ora Temp01
	
skip2	;Generate Map
.)
	tay
	lda StripAddressTableLo,y
	sta map
	lda StripAddressTableHi,y
	sta map+1
	
	lda #00
	sta MapIndex	;Also row index
.(	
loop2	ldy MapIndex
	lda (map),y
	;Sort left side
	and #15
	tax
	lda lsm_GraphicAddressLo,x
	sta vector1+1
	lda lsm_GraphicAddressHi,x
	sta vector1+2
	lda lsm_BGBufferRowLo,y
	sta screen
	lda lsm_BGBufferRowHi,y
	sta screen+1
	
	ldx #101
loop1	ldy ScreenOffset17x6,x
vector1	lda $dead,x
	sta (screen),y
	dex
	bpl loop1
	
	ldy MapIndex
	lda (map),y
	;Sort right side
	lsr
	lsr
	lsr
	lsr
	tax
	lda lsm_GraphicAddressLo,x
	sta vector2+1
	lda lsm_GraphicAddressHi,x
	sta vector2+2
	
	ldx #95
loop3	ldy ScreenOffset16x6,x
vector2	lda $dead,x
	sta (screen),y
	dex
	bpl loop3
	
	inc MapIndex
	lda MapIndex
	cmp #25
	bcc loop2
.)

	;Plot Lift Shaft in Background Buffer (Clear area)
	lda #<$A000+18
	sta screen
	lda #>$A000+18
	sta screen+1
	ldx #150
.(
loop2	ldy #5
	lda #$40
loop1	sta (screen),y
	dey
	bpl loop1
	jsr nl_screen
	dex
	bne loop2
.)


	;Plot Lift Cables(4x2) in Background Buffer
	lda #19
	sta Object_X
	lda #0
	sta Object_Y
	lda #26
	sta Object_R
	lda #REPEATOBJECTDOWN
	sta Object_D
	lda #MAINSHAFTLIFTCABLES
	sta Object_V
	jsr RepeatDisplayGraphicObject

	;Plot Lift in Background Buffer
	lda #18
	sta Object_X
	lda #54
	sta Object_Y
	lda #MAINSHAFTLIFTGFX
	sta Object_V
	jmp DisplayGraphicObject

RenderStripMap2Screen
	ldy #00
	sty RowCounter
	lda StripIndex
	sta Temp01
	lda map
.(
	sta vector3+1
	lda map+1
	sta vector3+2

loop2	lda lsm_ScreenRowLo,y
	sta vector2+1
	sta vector4+1
	lda lsm_ScreenRowHi,y
	sta vector2+2
	sta vector4+2
	ldy Temp01
vector3	lda $dead,y
	pha
	and #15
	tax
	lda lsm_GraphicAddressLo,x
	sta vector1+1
	lda lsm_GraphicAddressHi,x
	sta vector1+2
	iny
	sty Temp01
	
	ldx #101
loop1	ldy ScreenOffset17x6,x
vector1	lda $dead,x
vector2	sta $dead,y
	dex
	bpl loop1
	
	pla
	lsr
	lsr
	lsr
	lsr
	tax
	lda lsm_GraphicAddressLo,x
	sta vector5+1
	lda lsm_GraphicAddressHi,x
	sta vector5+2
	
	ldx #95
loop3	ldy ScreenOffset16x6,x
vector5	lda $dead,x
vector4	sta $dead,y
	dex
	bpl loop3
	
	ldy RowCounter
	iny
	sty RowCounter
	cpy #25
	bcc loop2
.)
	rts

CalcLocationInMapOfRooms
	lda RoomPositionY
	and #%11111110	;B0 is half room flag
	asl	;x13 == x8 + x4 + !
	asl
.(
	sta vector1+1
	asl
vector1	adc #00
.)
	adc RoomPositionY
	adc RoomPositionX
	tax
	rts

MainLiftDown
;	nop
;	jmp MainLiftDown
	;This is a fixed sequence event to move lift to next room corridor down
	
	;Check for end of map
	lda RoomPositionY
	cmp #15
.(
	bcs NoExitsBelow

	;Copy current map strip to first half of strip buffer
	ldx RoomPositionX
	ldy RoomPositionY
	jsr LocateMapStrip	;into A
	ldx #00
	jsr CopyStrip2StripBuffer
	
	;locate and copy next half row map strip to second half of strip buffer
	ldx RoomPositionX
	ldy RoomPositionY
	iny
	jsr LocateMapStrip	;into A
	ldx #25
	jsr CopyStrip2StripBuffer
	
	;Move pointer from beginning of strip buffer to halfway(25) displaying next 25 rows
	lda #00
	sta StripIndex
	lda #<StripBuffer
	sta map
	lda #>StripBuffer
	sta map+1

loop1	jsr RenderStripMap2Screen

	ldy StripIndex
	iny
	sty StripIndex
	cpy #26
	bcc loop1
	inc RoomPositionY
NoExitsBelow
.)
	rts


MainLiftUp
	;This is a fixed sequence event to move lift to next room corridor up
	
	;Check for end of map
	lda RoomPositionY
.(
	beq NoExitsAbove
	
	;Copy current map strip to second half of strip buffer
	ldx RoomPositionX
	ldy RoomPositionY
	jsr LocateMapStrip	;into A
	ldx #25
	jsr CopyStrip2StripBuffer
	
	;locate and copy previous half row map strip to first half of strip buffer
	ldx RoomPositionX
	ldy RoomPositionY
	dey
	jsr LocateMapStrip	;into A
	ldx #00
	jsr CopyStrip2StripBuffer
	
	;Move pointer from offset 25 in strip buffer to zero displaying next 25 rows
	lda #25
	sta StripIndex
	lda #<StripBuffer
	sta map
	lda #>StripBuffer
	sta map+1

loop1	jsr RenderStripMap2Screen

	dec StripIndex
	bpl loop1
	dec RoomPositionY
NoExitsAbove
.)
	rts	

CopyStrip2StripBuffer
	tay
	lda StripAddressTableLo,y
	sta source
	lda StripAddressTableHi,y
	sta source+1
	ldy #00
.(
loop1	lda (source),y
	sta StripBuffer,x
	inx
	iny
	cpy #25
	bcc loop1
.)
	rts
	
LocateMapStrip
	;Place TBF into Carry
	tya
	lsr
	tay
	php	
	
	;Calculate Room location
	txa
	clc
	adc MultiplyBy13,y
	tay
	
	;branch on Bottom TBF
	plp
.(
	bcs skip1
	
	;Process Top TBF
	ldx MapOfRooms-1,y
	lda RoomExits,x
	and #BIT1
	lsr
	sta StripIndex
	ldx MapOfRooms+1,y
	lda RoomExits,x
	and #BIT0
	asl
	ora StripIndex
	rts
	
skip1	;Process Top TBF
.)
	ldx MapOfRooms-1,y
	lda RoomExits,x
	and #BIT3
	lsr
	lsr
	lsr
	sta StripIndex
	ldx MapOfRooms+1,y
	lda RoomExits,x
	and #BIT2
	lsr
	ora StripIndex
	rts

StripBuffer
 .dsb 50,0
MultiplyBy13
 .byt 0
 .byt 13*1
 .byt 13*2
 .byt 13*3
 .byt 13*4
 .byt 13*5
 .byt 13*6
 .byt 13*7

GenerateRandomRoomMap
;	nop
;	jmp GenerateRandomRoomMap
	;Clear current mapofrooms
	lda #$FF
	ldx #12
.(
loop1	sta MapOfRooms,x
	sta MapOfRooms+13*1,x
	sta MapOfRooms+13*2,x
	sta MapOfRooms+13*3,x
	sta MapOfRooms+13*4,x
	sta MapOfRooms+13*5,x
	sta MapOfRooms+13*6,x
	sta MapOfRooms+13*7,x
	eor #$FF
	dex
	bpl loop1
.)
	;Clear Checklist flags
	ldx #31
.(
loop1	lda RoomChecklist,x
	and #%1111
	sta RoomChecklist,x
	dex
	bpl loop1
.)
	;Set flag to ensure when the next piece of code draws a path of rooms from left to write
	;any rooms lying in the middle are all left/right exited
	lda #1
	sta LeftRightExitOnlyFlag
	;Plot Path from left to right
	ldx #00
	stx RoomPositionX
.(	
loop1	;Get Random Y position 0-7
	jsr GetRandomNumber
	and #7
	sta RoomPositionY
GetRandomRoomID
	;Fetch another random number for room id
	jsr GetRandomNumber
	and #31
	sta TempRoomID
	
	jsr PerformNewRoomChecks
	bcs GetRandomRoomID
	
	;Store it
	ldy RoomPositionY
	lda MultiplyBy13,y
	clc
	adc RoomPositionX
	tay
	lda TempRoomID
	sta MapOfRooms,y
	
	;Progress Index
	inc RoomPositionX
	inc RoomPositionX
	lda RoomPositionX
	cmp #13
	bcc loop1
.)
	;Now plot remainder of rooms in random room positions
	lda #0
	sta LeftRightExitOnlyFlag
	
	;Fetch Random X position (0-12 but in steps of 2)
.(
loop1	jsr GetRandomNumber
	and #7
	cmp #7
	bcs loop1
	asl
	sta RoomPositionX
	
	;Fetch Random Y position (0-7)
	jsr GetRandomNumber
	and #7
	sta RoomPositionY
	
	;Check room location
	ldy RoomPositionY
	lda MultiplyBy13,y
	clc
	adc RoomPositionX
	tay
	sty NewRoomOffset
	lda MapOfRooms,y
	cmp #$FF
	bne loop1
	
	;Fetch next free room
	ldx #31
loop2	lda RoomExits,x
	bpl skip1
	dex
	bpl loop2
	;Reset RoomPosition fields to top left of map (Default start position) before exiting
	ldx #01
	stx RoomPositionX
	dex
	stx RoomPositionY
	rts
skip1	stx TempRoomID
	
	;Check Room
	jsr PerformNewRoomChecks
	bcs loop1
	
	;Store room
	ldy NewRoomOffset
	lda TempRoomID
	sta MapOfRooms,y
	
	;Proceed to next room allocation
	jmp loop1
.)
	
PerformNewRoomChecks
	;If Leftside then right exit only rooms
	lda RoomPositionX
	cmp #00
.(
	bne skip2
	ldx TempRoomID
	cpx #16
	bcs Failed
	cpx #8
	bcc Failed
	jmp skip1
	
skip2	;If Rightside then left exit only rooms
	cmp #12
	bne skip3
	ldx TempRoomID
	cpx #8
	bcs Failed
	jmp skip1

skip3	lda LeftRightExitOnlyFlag
	beq skip4

	;If in Middle then left/right exit rooms only
	ldx TempRoomID
	cpx #16
	bcc Failed
	
skip1	;Check this room has not been used before
	ldx TempRoomID
	lda RoomChecklist,x
	bmi Failed
	
skip4	;Flag room as used in checklist
	ora #128
	sta RoomChecklist,x
	clc
	rts
Failed	sec
.)
	rts
;B0-4 Room ID
;B6   Plundered Flag
;B7   No Room

; .byt $FF,0,$FF,0,$FF,0,$FF,0,$FF,0,$FF,0,$FF
; .byt $FF,0,$FF,0,$FF,0,$FF,0,$FF,0,$FF,0,$FF
; .byt $FF,0,$FF,0,$FF,0,$FF,0,$FF,0,$FF,0,$FF
; .byt $FF,0,$FF,0,$FF,0,$FF,0,$FF,0,$FF,0,$FF
; .byt $FF,0,$FF,0,$FF,0,$FF,0,$FF,0,$FF,0,$FF
; .byt $FF,0,$FF,0,$FF,0,$FF,0,$FF,0,$FF,0,$FF
; .byt $FF,0,$FF,0,$FF,0,$FF,0,$FF,0,$FF,0,$FF
; .byt $FF,0,$FF,0,$FF,0,$FF,0,$FF,0,$FF,0,$FF
;B0 Top Left exit
;B1 Top Right exit
;B2 Bottom Left Exit
;B3 Bottom Right Exit
;B7 Checklist used room flag(only used during the creation of the room map)
RoomChecklist
RoomExits		;   B3 B2 B1 B0
 .byt %1000	;00 BR              Left Side	
 .byt %0010	;01       TR	Left Side
 .byt %0010	;02       TR        Left Side
 .byt %0010	;03       TR        Left Side
 .byt %1000	;04 BR              Left Side
 .byt %0010	;05       TR        Left Side
 .byt %0001	;06       TR        Left Side
 .byt %1000	;07 BR              Left Side
 .byt %0100	;08    BL                     Right Side
 .byt %0001	;09          TL               Right Side
 .byt %0100	;10    BL                     Right Side
 .byt %0100	;11    BL                     Right Side
 .byt %0100	;12    BL                     Right Side
 .byt %0001	;13          TL               Right Side
 .byt %0001	;14          TL               Right Side
 .byt %0001	;15          TL               Right Side
 .byt %0110	;16    BL TR
 .byt %0110	;17    BL TR
 .byt %1001	;18 BR       TL
 .byt %0110	;19    BL TR
 .byt %1001	;20 BR       TL
 .byt %0011	;21       TR TL
 .byt %0110	;22    BL TR
 .byt %1100	;23 BR BL
 .byt %1100	;24 BR BL
 .byt %1001	;25 BR       TL
 .byt %1100	;26 BR BL
 .byt %0110	;27    BL TR
 .byt %0011	;28       TR TL
 .byt %0011	;29       TR TL
 .byt %1001	;30 BR       TL
 .byt %0110	;31    BL TR


