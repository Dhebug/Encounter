;ManageCharacterMovements.s

;This is a list of the existing characters in Wurlde..
;Nylot_Tribesman	0	1  of 32	06 LittlePee		Everyday		4s1
;Drummond_InnKeeper	1	2  of 32	01 Pirates Arms		Everyday		1s2
;Lief_Wench	2	8  of 32	01 Pirates Arms		Everyday		1s2
;Derb_Baker	3	9  of 32	07 Sassubree Bakery		Everyday		1s1
;Jumbee_Cobbler	4	22 of 32	02 Market Square		Everyday		1s3
;Barton_InnKeeper	5	20 of 32	00 Kissing Widow		Everyday		1s4
;Keesha_Wench	6	18 of 32	00 Kissing Widow		Everyday		1s4
;Kobla_Pirate	7	5  of 32	00 Kissing Widow		Nights		1s4
;Ribald_Fisherman	8	6  of 32	00 Kissing Widow		Nights		1s4
;Rangard_Fisherman	9	7  of 32	01 Fishy Plaice&Pirates Arms	Mornings&Evenings	1s5&1s2
;Keggs_Fisherman	10	11 of 32	14 Fishy Plaice&Pirates Arms	Mornings&Evenings	1s5&1s2
;Tygor_Peasant	11	19 of 32	01 Pirates Arms		Everyday		1s2
;Retnig_Peasant	12	21 of 32	00 Kissing Widow		Everyday		1s4
;Yltendoq_Priest	13	10 of 32	12 Tirn Church		Everyday		0s0
;Mardon_Peasant	14	16 of 32	01 Kissing Widow		Everyday		1s4
;Lintu_Child	15	27 of 32	02 Market Square		Everyday		1s3
;Temple_Child	16	4  of 32	02 Market Square		Everyday		1s3
;Tallard_Steward	17	3  of 32	01 Pirates Arms		Everyday		1s2
;Kinda_Bakerboy	18	17 of 32	07 Bakery&Fishy Plaice	Evenings&Mornings	1s1&1s5
;Abbot_Clergy	19	23 of 32	12 Tirn Church		Everyday		0s0
;Prest_Clergy	20	25 of 32	05 Monastery		Everyday		3s4
;Jiro_Child	21	29 of 32	10 Wizards House		Everyday		0s5
;OldTom_Farmer	22	24 of 32	08 Mill House		Days		2s2
;Merideth_Dealer	23	14 of 32	02 Market Square		Random Day	1s3
;Witch_Witch	24	12 of 32  11 Banit Castle		Everyday		1s0
;Spider_Wizard	25	13 of 32	03 log cabin		Everyday		3s1
;Erth_Wizard	26	15 of 32	10 Wizards House		Everyday		0s5
;Munk_Clergy	27	30 of 32	05 Monastery		Everyday		3s4
;Spare_Character1	28	26 of 32	"Big nose traveller" (Spare)
;Triffith_Dealer	29	32 of 32	02 Market Square		Random Day	1s3
;Callum_Dealer	30	31 of 32	02 Market Square		Random Day	1s3
;Jiles_Farmer	31	28 of 32	09 Windmill		Days		2s3

;The lower 3 bits of the game_ssccharacterlist hold the timezones the characters appear in..
;Bit 0 Mornings
;Bit 1 Afternoons
;Bit 2 Evenings
;If all bits are clear then the character will appear on random days

;The code scans the ssc module for characters associated to this location
;and picks up the time occurrence in the lower 3 bits.
;Then it cross references the character to the playerfile and adjusts its current
;location based on the current time held in SunMoonIndex.

ManageCharacterMovements
	;We have a problem here.
	;It seems because ManageCharacterMovements is handled in the main loop (after midnight)
	;it may inadvertantly feed the current location id into characters that don't usually reside
	;at some locations.
	
	;I guess we could just make things hardcoded a bit, like only a handful of characters will
	;really 
	lda ssc_CharacterListVectorHi
.(
	beq skip1	;No Occupants
	sta source2+1
	lda ssc_CharacterListVectorLo
	sta source2
	ldy #00
	
loop1	lda (source2),y
	cmp #255
	beq skip1
	;Deal with character who are here all day
	and #%00000111
	cmp #%00000111
	beq skip2
	;Deal with random days
	cmp #%00000000
	bne skip3
	;Only update character if time is midnight
	lda SunMoonIndex
	cmp #01
	bne skip2
	jsr getrand
	bpl CharacterAbsent
	jmp CharacterPresent
skip3	ldx SunMoonIndex
	and TimeZoneBit,x
	
	beq CharacterAbsent
CharacterPresent
	; Fetch CharacterID
	lda (source2),y
	and #%11111000
	tax
	; Fetch Location ID and adjust for insertion into playerfile
	lda ssc_LocationID
	asl
	asl
	sta temp01
	; Fetch Playerfile byte
	lda CharacterBlocks+1,x
          and #%11000011
          ; Insert LocationID
          ora temp01
          ; Store back
          sta CharacterBlocks+1,x
          jmp skip2
CharacterAbsent
	; Fetch CharacterID
	lda (source2),y
	and #%11111000
	tax
	; Fetch Playerfile byte
	lda CharacterBlocks+1,x
          and #%11000011
          ; Insert Absent location
          ora #%00111100
          ; Store back
          sta CharacterBlocks+1,x
skip2	;Progress to next character
	iny
	jmp loop1
skip1	rts
.)
	
TimeZoneBit	;Indexed with SunMoonIndex
 .byt %001	;	00                  02.00 XX1
 .byt %100	;    	01 Midnight	00.00 1XX
 .byt %100	;	02		22.00 1XX
 .byt %100	;	03		20.00 1XX
 .byt %100	;	04		18.00 1XX
 .byt %010	;	05		16.30 X1X
 .byt %010	;	06		15.00 X1X
 .byt %010	;	07		13.30 X1X
 .byt %010	;    	08 Noon		12.00 X1X
 .byt %001	;	09		10.00 XX1
 .byt %001	;	0A		08.00 XX1
 .byt %001	;	0B		06.00 XX1
 .byt %001	;	0C		04.00 XX1
