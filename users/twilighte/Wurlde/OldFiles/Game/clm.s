;Character Location Management

;LocationID corresponds to the place the Character resides
;00 Sassubree Kissing Widow Tavern
;	Barton, Keesha, Kobla(Nights), Ribald(Nights), Keggs(Evenings), Retnig
;01 Sassubree Pirates Arms Inn
;	Drummond, Lief, Rangard(Evenings), Tygor, Tallard, Mardon
;02 Sassubree Market
;	Jumbee, Lintu, Temple, Merideth(Every 5th Day), Triffith(Every 3rd Day),Callum(Every 7th Day)
;03
;04
;05 Monastery, Samson Isle
;	Prest
;	Munk
;06 LittlePee
;	Nylot
;07 Sassubree Bakery
;	Derb, Kinda(Nights)
;08 Mill House, Ritemoor
;	Old Tom(Days)
;09 Windmill, Ritemoor
;	Jiles
;10 Wizards House, Homeland
;	Jiro, Erth
;11 Banit Witches Castle, Ritemoor
;	Witch1
;	Witch2
;	Witch3
;12 Tirn Church
;	Yltendoq
;14 Fishy Place, Sasubree
;	Rangard(Mornings), Keggs(Mornings), Kinda (Mornings)
;15 Nowhere


BuildLocalCharactersTable
	lda #255
	sta UltimateCharacterIndex
	ldx #31
.(
loop1	;Is this character alive?
	txa
	asl
	asl
	tay
	lda CharacterBlocks,y
	and #15
	beq no2	;Character Is Dead

	;Is character likely to be at this location today?
	lda Character_Locations,x
	and #15
	cmp ssc_LocationID
	bne no1
	lda Character_LocationDays,x
	and #15
	ldy DayCounter
	and DayBit,y
	beq no1

	lda Character_LocationTimes,x
	and #15
	ldy SunMoonIndex
	and TodBit,y
	bne yes

no1
	lda Character_Locations,x
	lsr
	lsr
	lsr
	lsr
	cmp ssc_LocationID
	bne no2
	lda Character_LocationDays,x
	lsr
	lsr
	lsr
	lsr
	ldy DayCounter
	and DayBit,y
	beq no2
	lda Character_LocationTimes,x
	lsr
	lsr
	lsr
	lsr
	ldy SunMoonIndex
	and TodBit,y
	beq no2

yes	txa
	inc UltimateCharacterIndex
	ldy UltimateCharacterIndex
	sta LocalCharacters,y

no2	dex
	bpl loop1
.)
	rts

;This table holds 2 locations character can exist and are held in lower and upper 4 bits
Character_Locations
 .byt 6+16*6	;0  Nylot_Tribesman           06
 .byt 0		;1  Drummond_InnKeeper	00
 .byt 0		;2  Lief_Wench	          00
 .byt 7+16*7	;3  Derb_Baker                07
 .byt 2+16*2	;4  Jumbee_Cobbler		02
 .byt 1+16*1	;5  Barton_InnKeeper	01
 .byt 1+16*1	;6  Keesha_Wench		01
 .byt 0		;7  Kobla_Pirate		00
 .byt 0		;8  Ribald_Fisherman	00
 .byt 1+16*14	;9  Rangard_Fisherman	01,14
 .byt 16*14	;10 Keggs_Fisherman		00,14
 .byt 1+16*1	;11 Tygor_Peasant		01
 .byt 0		;12 Retnig_Peasant		00
 .byt 12+16*12	;13 Yltendoq_Priest           12
 .byt 1+16*1	;14 Mardon_Peasant		01
 .byt 2+16*2	;15 Lintu_Child		02
 .byt 2+16*2	;16 Temple_Child		02
 .byt 1+16*1	;17 Tallard_Steward		01
 .byt 7+16*14	;18 Kinda_Bakerboy            07,14
 .byt 2+16*2	;19 Merideth_Dealer		02
 .byt 5+16*5	;20 Prest_Clergy		05
 .byt 10+16*10	;21 Jiro_Child                10
 .byt 8+16*8	;22 Old Tom                   08
 .byt 11+16*11    	;23 Witch1                    11
 .byt 11+16*11      ;24 Witch2                    11
 .byt 11+16*11      ;25 Witch3                    11
 .byt 10+16*10      ;26 Erth			10
 .byt 5+16*5	;27 Munk                      05
 .byt 9+16*9    	;28 Jiles			09
 .byt 2+16*2    	;29 Triffith		02
 .byt 2+16*2    	;30 Callum		02
 .byt 15+16*15    	;31 -


;LocationID corresponds to the place the Character resides
;00 Sassubree Kissing Widow Tavern
;	Drummond, Lief, Kobla(Nights), Ribald(Nights), Keggs(Evenings), Retnig
;01 Sassubree Pirates Arms Inn
;	Barton, Keesha, Rangard(Evenings), Tygor, Tallard, Mardon
;02 Sassubree Market
;	Jumbee, Lintu, Temple, Merideth(Every 5th Day), Triffith(Every 3rd Day),Callum(Every 7th Day)
;03
;04
;05 Monastery, Samson Isle
;	Prest
;	Munk
;06 LittlePee
;	Nylot
;07 Sassubree Bakery
;	Derb, Kinda(Nights)
;08 Mill House, Ritemoor
;	Old Tom(Days)
;09 Windmill, Ritemoor
;	Jiles
;10 Wizards House, Homeland
;	Jiro, Erth
;11 Banit Witches Castle, Ritemoor
;	Witch1
;	Witch2
;	Witch3
;12 Tirn Church
;	Yltendoq
;14 Fishy Place, Sasubree
;	Rangard(Mornings), Keggs(Mornings), Kinda (Mornings)
;15 Nowhere


Character_LocationDays
 .byt %11111111 ;0  Nylot_Tribesman         06     Always
 .byt %11111111 ;1  Drummond_InnKeeper	00     Always
 .byt %11111111 ;2  Lief_Wench	          00     Always
 .byt %11111111 ;3  Derb_Baker              07     Always
 .byt %11111111 ;4  Jumbee_Cobbler	02     Always
 .byt %11111111 ;5  Barton_InnKeeper	01     Always
 .byt %11111111 ;6  Keesha_Wench		01     Always
 .byt %11111111 ;7  Kobla_Pirate		00     Always
 .byt %11111111 ;8  Ribald_Fisherman	00     Always
 .byt %11111111 ;9  Rangard_Fisherman	01,14  Always
 .byt %11111111 ;10 Keggs_Fisherman	00,14  Always
 .byt %11111111 ;11 Tygor_Peasant		01     Always
 .byt %11111111 ;12 Retnig_Peasant	00     Always
 .byt %11111111 	  ;13 Yltendoq_Priest         12     Always
 .byt %11111111 ;14 Mardon_Peasant	01     Always
 .byt %11111111 ;15 Lintu_Child		02     Always
 .byt %11111111 ;16 Temple_Child		02     Always
 .byt %11111111 ;17 Tallard_Steward	01     Always
 .byt %11111111 ;18 Kinda_Bakerboy          07,14  Always
 .byt %10001000 ;19 Merideth_Dealer	02     4th day
 .byt %11111111 ;20 Prest_Clergy		05     Always
 .byt %11111111 	  ;21 Jiro_Child              10     Always
 .byt %11111111 ;22 Old Tom                 08     Always
 .byt %11111111       ;23 Witch1                  11     Always
 .byt %11111111       ;24 Witch2                  11     Always
 .byt %11111111       ;25 Witch3                  11     Always
 .byt %11111111       ;26 Erth		10     Always
 .byt %11111111 ;27 Munk                    05     Always
 .byt %11111111   	  ;28 Jiles		09     Always
 .byt %01000100   	  ;29 Triffith		02     3rd Day
 .byt %10001000   	  ;30 Callum		02     4th Day
 .byt %11111111       ;31 -

DayBit
 .byt %00000001
 .byt %00000010
 .byt %00000100
 .byt %00001000

Character_LocationTimes
 .byt %10001000 ;0  Nylot_Tribesman         06     Mornings
 .byt %11111111 ;1  Drummond_InnKeeper	00     Always
 .byt %11111111 ;2  Lief_Wench	          00     Always
 .byt %01000100 ;3  Derb_Baker              07     Days
 .byt %01000100 ;4  Jumbee_Cobbler	02     Days
 .byt %11111111 ;5  Barton_InnKeeper	01     Always
 .byt %11111111 ;6  Keesha_Wench		01     Always
 .byt %10111011 ;7  Kobla_Pirate		00     Nights
 .byt %00110011 ;8  Ribald_Fisherman	00     Evenings
 .byt %00111000 ;9  Rangard_Fisherman	01,14  Evenings,Mornings
 .byt %00111000 ;10 Keggs_Fisherman	00,14  Evenings,Mornings
 .byt %00110011 ;11 Tygor_Peasant		01     Evenings
 .byt %00110011 ;12 Retnig_Peasant	00     Evenings
 .byt %01000100 	  ;13 Yltendoq_Priest         12     Days
 .byt %00110011 ;14 Mardon_Peasant	01     Evenings
 .byt %10001000 ;15 Lintu_Child		02     Mornings
 .byt %01000100 ;16 Temple_Child		02     Days
 .byt %00110011 ;17 Tallard_Steward	01     Evenings
 .byt %00000000 ;18 Kinda_Bakerboy          07,14  Afternoon,Mornings
 .byt %00000000 ;19 Merideth_Dealer	02     Lunchtime
 .byt %00000000 ;20 Prest_Clergy		05     Always
 .byt %00000000 	  ;21 Jiro_Child              10     Days
 .byt %00000000 ;22 Old Tom                 08     Days
 .byt %00000000       ;23 Witch1                  11     Always
 .byt %00000000       ;24 Witch2                  11     Always
 .byt %00000000       ;25 Witch3                  11     Always
 .byt %00000000       ;26 Erth		10     Always
 .byt %00000000 ;27 Munk                    05     Always
 .byt %00000000   	  ;28 Jiles		09     Days
 .byt %00000000   	  ;29 Triffith		02     Afternoon
 .byt %00000000   	  ;30 Callum		02     Morning
 .byt %00000000       ;31 -

;Bitmap Times
;B0 04:00 to 09:59
;B1 10:00 to 15:59
;B2 16:00 to 21:59
;B3 22:00 to 03:59
TodBit
 .byt


;	0		04:00   Night
;	1		06:00   Morning
;	2		08:00   Morning
;	3		10:00   Morning
;    	4  Noon		12:00   Afternoon
;	5		13:30   Afternoon
;	6		15:00   Afternoon
;	7		16:30   Afternoon
;	8		18:00   Evening
;	9		20:00   Evening
;	10		22:00   Evening
;    	11 Midnight	00:00   Night
;	12                  02:00   Night




;	0		04:00
;	1		06:00
;	2		08:00
;	3		10:00
;    	4  Noon		12:00
;	5		13:30
;	6		15:00
;	7		16:30
;	8		18:00
;	9		20:00
;	10		22:00
;    	11 Midnight	00:00
;	12                  02:00
