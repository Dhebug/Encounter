;GenericTables.s

;BonusSpeed
; .byt 15	;Easy
; .byt 10  ;Normal
; .byt 2	;Insane

InitialLives
 .byt 9	;Easy  
 .byt 3   ;Normal
 .byt 1   ;Insane

Bitpos
 .byt 1,2,4,8,16,32,64
;--FUD-RL
KeyRow
 .byt 4	;01 L
 .byt 4	;02 R
 .byt 0
 .byt 4	;08 D
 .byt 4	;10 U
 .byt 4	;20 F
 .byt 1	;40 X
KeyColumn
 .byt $DF ;L
 .byt $7F ;R
 .byt $7F	;-
 .byt $BF ;D
 .byt $F7 ;U
 .byt $FE ;F
 .byt $DF	;X
 
;KeyRow
; .byt 1	;X 128
; .byt 2	;F 64
; .byt 4	;L 32
; .byt 4	;R 16
; .byt 4	;U 8
; .byt 4	;D 4
;KeyColumn
; .byt $DF
; .byt $EF
; .byt $DF
; .byt $7F
; .byt $F7
; .byt $BF
OptionValue
Option_Sound	.byt 0
Option_Ingame       .byt 0
Option_Input        .byt 0
Option_Screen       .byt 0
Option_Difficulty	.byt 1

ObjectSFX
 .byt 5
 .byt 17
 .byt 16
 .byt 18

OptionRange
 .byt 2
 .byt 1
 .byt 3
 .byt 1
 .byt 2

LowScoreDigitOffset
 .byt 0,2,4
HighScoreDigitOffset
 .byt 0,1,3

;;Each Ink Table is 10 bytes long for each raster row
;InkPatternAddressLo
; .byt <InkPattern1
; .byt <InkPattern2
; .byt <InkPattern3
; .byt <InkPattern1
; .byt <InkPattern1
; .byt <InkPattern6
; .byt <InkPattern7
; .byt <InkPatternN
; .byt <InkPattern9
;InkPatternAddressHi
; .byt >InkPattern1
; .byt >InkPattern2
; .byt >InkPattern3
; .byt >InkPattern1
; .byt >InkPattern1
; .byt >InkPattern6
; .byt >InkPattern7
; .byt >InkPatternN
; .byt >InkPattern9
;
;InkPattern1
; .byt 1,1,1,1,1,1,1,1,1,1
;InkPattern2
; .byt 2,2,2,2,2,2,2,2,2,2
;InkPattern3
; .byt 3,3,3,3,3,3,3,3,3,3
;InkPattern6
; .byt 6,6,6,6,6,6,6,6,6,6
;InkPattern7
; .byt 7,7,7,7,7,7,7,7,7,7
;InkPatternN
; .byt 6,3,6,3,6,3,6,3,6,3
;InkPattern9
; .byt 1,5,3,3,7,3,5,1,1,1

Character_a
 .byt $40
 .byt $40
 .byt $40
 .byt $E1
 .byt $C9
 .byt $C9
 .byt $C1
 .byt $56
 .byt $40
 .byt $40
Character_b
 .byt $58
 .byt $70
 .byt $74
 .byt $C1
 .byt $C9
 .byt $C9
 .byt $C9
 .byt $7C
 .byt $40
 .byt $40
Character_c
 .byt $40
 .byt $40
 .byt $40
 .byt $E1
 .byt $C9
 .byt $70
 .byt $72
 .byt $E3
 .byt $40
 .byt $40
Character_d
 .byt $43
 .byt $46
 .byt $46
 .byt $E1
 .byt $C9
 .byt $C9
 .byt $C1
 .byt $E9
 .byt $40
 .byt $40
Character_e
 .byt $40
 .byt $40
 .byt $40
 .byt $E3
 .byt $76
 .byt $C3
 .byt $72
 .byt $5C
 .byt $40
 .byt $40
Character_f
 .byt $4C
 .byt $58
 .byt $58
 .byt $C1
 .byt $58
 .byt $58
 .byt $58
 .byt $58
 .byt $58
 .byt $70
Character_g
 .byt $40
 .byt $40
 .byt $40
 .byt $5C
 .byt $C9
 .byt $C9
 .byt $C1
 .byt $56
 .byt $46
 .byt $4C
Character_h
 .byt $58
 .byt $70
 .byt $74
 .byt $C1
 .byt $C9
 .byt $C9
 .byt $C9
 .byt $C9
 .byt $40
 .byt $40
Character_i
 .byt $48
 .byt $50
 .byt $48
 .byt $58
 .byt $78
 .byt $58
 .byt $5A
 .byt $4C
 .byt $40
 .byt $40
Character_j
 .byt $48
 .byt $50
 .byt $48
 .byt $58
 .byt $78
 .byt $58
 .byt $58
 .byt $58
 .byt $58
 .byt $70
Character_k
 .byt $58
 .byt $70
 .byt $74
 .byt $C5
 .byt $72
 .byt $C3
 .byt $C9
 .byt $73
 .byt $40
 .byt $40
Character_l
 .byt $58
 .byt $70
 .byt $70
 .byt $70
 .byt $70
 .byt $70
 .byt $72
 .byt $C3
 .byt $40
 .byt $40
Character_m
 .byt $40
 .byt $40
 .byt $40
 .byt $E5
 .byt $C1
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $40
 .byt $40
Character_n
 .byt $40
 .byt $40
 .byt $40
 .byt $CB
 .byt $C1
 .byt $C9
 .byt $C9
 .byt $C9
 .byt $40
 .byt $40
Character_o
 .byt $40
 .byt $40
 .byt $40
 .byt $E3
 .byt $C9
 .byt $C9
 .byt $7C
 .byt $58
 .byt $40
 .byt $40
Character_p
 .byt $40
 .byt $40
 .byt $40
 .byt $74
 .byt $7E
 .byt $76
 .byt $76
 .byt $7C
 .byt $70
 .byt $60
Character_q
 .byt $40
 .byt $40
 .byt $40
 .byt $E1
 .byt $C9
 .byt $C9
 .byt $C1
 .byt $56
 .byt $47
 .byt $46
Character_r
 .byt $40
 .byt $40
 .byt $40
 .byt $5A
 .byt $C0
 .byt $58
 .byt $58
 .byt $58
 .byt $40
 .byt $40
Character_s
 .byt $40
 .byt $40
 .byt $41
 .byt $E3
 .byt $72
 .byt $E3
 .byt $66
 .byt $E3
 .byt $40
 .byt $40
Character_t
 .byt $50
 .byt $70
 .byt $C1
 .byt $70
 .byt $70
 .byt $CB
 .byt $78
 .byt $70
 .byt $40
 .byt $40
Character_u
 .byt $40
 .byt $40
 .byt $40
 .byt $C9
 .byt $C9
 .byt $C9
 .byt $C0
 .byt $56
 .byt $40
 .byt $40
Character_v
 .byt $40
 .byt $40
 .byt $40
 .byt $C9
 .byt $C9
 .byt $CB
 .byt $78
 .byt $50
 .byt $40
 .byt $40
Character_w
 .byt $40
 .byt $40
 .byt $40
 .byt $D5
 .byt $6A
 .byt $D5
 .byt $C5
 .byt $6C
 .byt $40
 .byt $40
Character_x
 .byt $40
 .byt $40
 .byt $40
 .byt $D9
 .byt $74
 .byt $58
 .byt $6C
 .byt $D9
 .byt $40
 .byt $40
Character_y
 .byt $40
 .byt $40
 .byt $40
 .byt $C9
 .byt $C9
 .byt $C9
 .byt $C1
 .byt $56
 .byt $46
 .byt $4C
Character_z
 .byt $40
 .byt $40
 .byt $40
 .byt $E1
 .byt $66
 .byt $4C
 .byt $5A
 .byt $C3
 .byt $40
 .byt $40
Character_Exclamation
 .byt $44
 .byt $F1
 .byt $4E
 .byt $F3
 .byt $4C
 .byt $48
 .byt $40
 .byt $58
 .byt $58
 .byt $40
Character_Question
 .byt $40
 .byt $E3
 .byt $C9
 .byt $46
 .byt $4C
 .byt $58
 .byt $40
 .byt $58
 .byt $40
 .byt $40
Character_Dot
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
Character_Heart
 .byt $40
 .byt $40
 .byt $52
 .byt $C0
 .byt $D8
 .byt $E9
 .byt $E1
 .byt $4C
 .byt $40
 .byt $40
Character_Back
 .byt $40
 .byt $40
 .byt $40
 .byt $4C
 .byt $58
 .byt $C1
 .byt $58
 .byt $4C
 .byt $40
 .byt $40
Character_Return
 .byt $40
 .byt $40
 .byt $41
 .byt $4D
 .byt $5B
 .byt $C1
 .byt $58
 .byt $4C
 .byt $40
 .byt $40
Character_Seperator
 .byt $40
 .byt $40
 .byt $40
 .byt $44
 .byt $4A
 .byt $EA
 .byt $4A
 .byt $44
 .byt $40
 .byt $40
;2C67-2DB1 == 330 Bytes

;58   Heart(Colon)
;59 ; Separator
;60 < Back Symbol
;61 = Return Symbol
;62 > Dot
;63 ? Question Mark
;64 @ Exclamation Mark
;65-90 Letters
CharacterAddressLo
 .byt <Character_Heart
 .byt <Character_Seperator
 .byt <Character_Back
 .byt <Character_Return
 .byt <Character_Dot
 .byt <Character_Question
 .byt <Character_Exclamation
 .byt <Character_a
 .byt <Character_b
 .byt <Character_c
 .byt <Character_d
 .byt <Character_e
 .byt <Character_f
 .byt <Character_g
 .byt <Character_h
 .byt <Character_i
 .byt <Character_j
 .byt <Character_k
 .byt <Character_l
 .byt <Character_m
 .byt <Character_n
 .byt <Character_o
 .byt <Character_p
 .byt <Character_q
 .byt <Character_r
 .byt <Character_s
 .byt <Character_t
 .byt <Character_u
 .byt <Character_v
 .byt <Character_w
 .byt <Character_x
 .byt <Character_y
 .byt <Character_z
CharacterAddressHi
 .byt >Character_Heart
 .byt >Character_Seperator
 .byt >Character_Back
 .byt >Character_Return
 .byt >Character_Dot
 .byt >Character_Question
 .byt >Character_Exclamation
 .byt >Character_a
 .byt >Character_b
 .byt >Character_c
 .byt >Character_d
 .byt >Character_e
 .byt >Character_f
 .byt >Character_g
 .byt >Character_h
 .byt >Character_i
 .byt >Character_j
 .byt >Character_k
 .byt >Character_l
 .byt >Character_m
 .byt >Character_n
 .byt >Character_o
 .byt >Character_p
 .byt >Character_q
 .byt >Character_r
 .byt >Character_s
 .byt >Character_t
 .byt >Character_u
 .byt >Character_v
 .byt >Character_w
 .byt >Character_x
 .byt >Character_y
 .byt >Character_z

;Non Player Characters (NPC) Tables
NPCUltimateIndex	.byt 0
NPC_Activity
 .dsb 12,128
NPC_Progress
 .dsb 12,0
NPC_ScreenX
 .dsb 12,0
NPC_ScreenY
 .dsb 12,0
NPC_ScreenXOrigin
 .dsb 12,0
NPC_ScreenYOrigin
 .dsb 12,0
NPC_Count
NPC_Direction	;Used for Grubs
 .dsb 12,0
NPC_Special
 .dsb 12,0
NPC_SpriteFrame	;Used in the restoration of the screen after NPC is destroyed
 .dsb 12,0

NPC_SpriteFrame4Activity
 .byt 0	;NPCA_BALLRISING	0
 .byt 0	;NPCA_BALLBOUNCE	1
 .byt 0	;NPCA_BALLPAUSE	2
 .byt 4	;NPCA_GRUBPEEP	3
 .byt 4	;NPCA_GRUBMOVE	4
 .byt 10	;NPCA_RAINDROP	5
 .byt 25	;NPCA_EGGWASP	6
 .byt 11	;NPCA_DRAGONLEFT	7
 .byt 11	;NPCA_DRAGONRIGHT	8
 .byt 13	;NPCA_BEE		9
 .byt 19	;NPCA_EXPLODE	10
 .byt 32	;NPCA_SPIDER	11

HeroOffsetsInCollisionMap
 .byt 0,1,40,41

;Starfield tables
BitMap
 .byt 32,16,8,4,2,1
 .byt 32,16,8,4,2,1
 .byt 32,16,8,4,2,1
 .byt 32,16,8,4,2,1
 .byt 32,16,8,4,2,1
 .byt 32,16,8,4,2,1
 .byt 32,16,8,4,2,1
 .byt 32,16,8,4,2,1
 .byt 32,16,8,4,2,1
 .byt 32,16,8,4,2,1
 .byt 32,16,8,4,2,1
 .byt 32,16,8,4,2,1
 .byt 32,16,8,4,2,1
 .byt 32,16,8,4,2,1
 .byt 32,16,8,4,2,1
 .byt 32,16,8,4,2,1
 .byt 32,16,8,4,2,1
 .byt 32,16,8,4,2,1
 .byt 32,16,8,4,2,1
 .byt 32,16,8,4,2,1
 .byt 32,16,8,4,2,1
 .byt 32,16,8,4,2,1
 .byt 32,16,8,4,2,1
 .byt 32,16,8,4,2,1
 .byt 32,16,8,4,2,1
 .byt 32,16,8,4,2,1
 .byt 32,16,8,4,2,1
 .byt 32,16,8,4,2,1
 .byt 32,16,8,4,2,1
 .byt 32,16,8,4,2,1
 .byt 32,16,8,4,2,1
 .byt 32,16,8,4,2,1
 .byt 32,16,8,4,2,1
 .byt 32,16,8,4,2,1
 .byt 32,16,8,4,2,1
 .byt 32,16,8,4,2,1
 .byt 32,16,8,4,2,1
 .byt 32,16,8,4,2,1
 .byt 32,16,8,4,2,1
 .byt 32,16,8,4,2,1
BitIndex
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5

;Bees must buzz around a set point so that when the honeypot arrives the single point can be moved
;instead of each individual bee
;So they should use a 2's compliment signed sine table then have a random index for both x and y to create
;a movement pattern similar to the wave demo for wurlde.
SignedSineTable	;256x(-7 to +7) Imperfect sine
 .byt 242,242,242,244,244,246,248,250,252,254,1,3,3,5,5,5
 .byt 7,7,7,7,5,5,5,3,3,1,254,252,250,248,246,244
 .byt 244,242,242,242,240,240,240,240,242,242,242,242,244,244,244,246
 .byt 246,248,248,250,252,254,1,3,3,3,3,1,1,254,254,252
 .byt 252,250,250,248,246,246,244,244,242,242,242,240,240,240,240,240
 .byt 242,242,244,246,248,250,252,254,1,3,3,1,1,1,254,254
 .byt 252,250,248,246,244,242,242,244,244,246,246,248,248,248,248,246
 .byt 246,246,244,244,244,242,242,242,242,242,242,244,244,246,248,250
 .byt 252,254,1,3,3,5,5,5,7,7,7,7,5,5,5,3
 .byt 3,1,254,252,250,248,246,244,244,242,242,242,240,240,240,240
 .byt 242,244,246,248,250,252,254,1,3,5,5,7,7,7,9,9
 .byt 9,9,9,11,11,11,13,13,13,15,13,13,13,11,11,11
 .byt 11,9,9,9,9,9,7,7,7,5,5,3,1,254,252,250
 .byt 248,246,244,242,244,246,248,248,250,250,250,252,252,252,252,250
 .byt 250,250,248,248,246,244,242,242,242,242,240,240,240,240,240,240
 .byt 242,242,242,244,244,246,248,248,248,248,246,246,246,244,244,244

XLOC
 .dsb 6,0
 .dsb 6,1
 .dsb 6,2
 .dsb 6,3
 .dsb 6,4
 .dsb 6,5
 .dsb 6,6
 .dsb 6,7
 .dsb 6,8
 .dsb 6,9
 .dsb 6,10
 .dsb 6,11
 .dsb 6,12
 .dsb 6,13
 .dsb 6,14
 .dsb 6,15
 .dsb 6,16
 .dsb 6,17
 .dsb 6,18
 .dsb 6,19
 .dsb 6,20
 .dsb 6,21
 .dsb 6,22
 .dsb 6,23
 .dsb 6,24
 .dsb 6,25
 .dsb 6,26
 .dsb 6,27
 .dsb 6,28
 .dsb 6,29
 .dsb 6,30
 .dsb 6,31
 .dsb 6,32
 .dsb 6,33
 .dsb 6,34
 .dsb 6,35
 .dsb 6,36
 .dsb 6,37
 .dsb 6,38
 .dsb 6,39

 
prj_X
 .dsb 8,0
prj_Y
 .dsb 8,0
prj_XStep
 .dsb 8,0
prj_YStep
 .dsb 8,0
prj_GFXID
 .dsb 8,0
 
;fg_LevelID
; .byt 1
; .byt 1
; .byt 128
;fg_MapX
; .byt 98
; .byt 112
;fg_TLTankMapLo
; .byt <Stormlord_Map+110+6*256
; .byt <Stormlord_Map+110+6*256
;fg_TLTankMapHi
; .byt >Stormlord_Map+110+6*256
; .byt >Stormlord_Map+110+6*256
;fg_TLTankWidth	;0 base
; .byt 6
; .byt 6
;fg_TLTankHeight
; .byt 2
; .byt 2
;fg_FloodMapLo
; .byt <Stormlord_Map+94+7*256
; .byt 0
;fg_FloodMapHi
; .byt >Stormlord_Map+94+7*256
; .byt 0
;fg_FloodMapWidth	;0 base
; .byt 22
; .byt 128	;Water drains away

ScorePanelSunMoon	;4x64
 .byt $40,$6C,$73,$40
 .byt $41,$66,$76,$40
 .byt $4C,$C9,$D1,$40
 .byt $46,$70,$59,$70
 .byt $43,$F0,$D8,$60
 .byt $72,$72,$5A,$50
 .byt $5D,$C0,$C2,$78
 .byt $4D,$62,$4D,$60
 .byt $63,$52,$56,$58
 .byt $7B,$67,$4E,$70
 .byt $E4,$C0,$C1,$40
 .byt $42,$78,$7A,$78
 .byt $5B,$D0,$D1,$58
 .byt $7D,$70,$5D,$60
 .byt $71,$78,$C2,$78
 .byt $46,$7F,$7A,$70
 .byt $E1,$E0,$D8,$40
 .byt $59,$60,$59,$60
 .byt $43,$F2,$D3,$40
 .byt $43,$59,$64,$40
 .byt $42,$58,$60,$40
 .byt $40,$40,$40,$40	;

 .byt $40,$40,$40,$40	;
 .byt $40,$40,$40,$40	;
 .byt $40,$40,$40,$40	;
 .byt $40,$40,$40,$40	;
 .byt $40,$40,$40,$40	;
 .byt $40,$40,$40,$40	;
 .byt $40,$40,$40,$40	;
 .byt $40,$40,$40,$40	;
 .byt $40,$40,$40,$40	;
 .byt $40,$40,$40,$40	;

 .byt $40,$47,$7E,$40
 .byt $40,$C0,$DF,$40
 .byt $43,$7E,$40,$40
 .byt $F8,$C3,$40,$40
 .byt $4F,$78,$48,$40
 .byt $E0,$70,$5C,$40
 .byt $5F,$70,$48,$48
 .byt $C3,$60,$40,$40
 .byt $7A,$60,$40,$40
 .byt $C6,$41,$40,$40
 .byt $7E,$60,$41,$40
 .byt $C8,$70,$40,$40
 .byt $6B,$40,$41,$40
 .byt $C3,$40,$4B,$68
 .byt $5E,$40,$41,$40
 .byt $E0,$70,$40,$40
 .byt $4F,$78,$41,$40
 .byt $F8,$C3,$40,$40
 .byt $43,$7E,$40,$40
 .byt $40,$C0,$DF,$40
 .byt $40,$47,$7E,$40
 .byt $40,$40,$40,$40

 .byt $40,$40,$40,$40	;
 .byt $40,$40,$40,$40	;
 .byt $40,$40,$40,$40	;
 .byt $40,$40,$40,$40	;
 .byt $40,$40,$40,$40	;
 .byt $40,$40,$40,$40	;
 .byt $40,$40,$40,$40	;
 .byt $40,$40,$40,$40	;
 .byt $40,$40,$40,$40	;
 .byt $40,$40,$40,$40	;


