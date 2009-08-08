;Save Sector (512 Bytes)
;This file is the Player file and is saved and loaded from the Game when the player enters a Inn and acquires lodging.
;In memory it resides at 9C00-9FFF(1024)

;The player file holds Player variables, Wurlde Items and Character variables
;9C00
*=$9C00

;Player Variables are as follows

;Location - Inns are always in a unique SSC module
MapID		;9C00
 .byt 2
ScreenID		;9C01
 .byt 6

;Posessions - Up to 10 items (0-99 Code or 128 if no item)
HeroSelectedPocket	;9C02
 .byt 0

HeroHealth	;9C03
 .byt 1	;0-15	Always starts low
HeroToxicLevel	;9C04
 .byt 0
HeroToxicLimit	;9C05
 .byt 4
HeroMana		;9C06
 .byt 0

;Grotes
HeroGrotes	;9C07,9C08,9C09
 .byt $00,$00,$10	;10000 == 01 00 00

;Controller - Keyboard(0) Pase(1) IJK(2)
Controller	;9C0A
 .byt 0

;		;9C0B
KeywordsLearntIndex	.byt 255
;123-152 Keyword	;9C0C-9C2B
KeywordsLearnt
 .dsb 32,0
;
;Bits in each byte set properties of the sub-game
;Bit Property
; 0  Game is repeatable(1)
; 1  Game has been completed(1)
; 2  Game is currently active(1)
SubGameProperty
 .byt 0				;00 Kissing Widow  Pergas Pipe
 .byt 0                                 ;01 Pirates Arms 
 .byt 0                                 ;02 Market Square
 .byt 0                                 ;03 Log Cabin    
 .byt 0                                 ;04 
 .byt 0                                 ;05 Monastery    
 .byt 0                                 ;06 Littlepee    
 .byt 0                                 ;07 The Bakery   
 .byt 0                                 ;08 Mill House   
 .byt 0                                 ;09 Windmill     
 .byt 0                                 ;10 Wizards House
 .byt 0                                 ;11 Banit Castle 
 .byt 0                                 ;12 Tirn Church
 .byt 0                                 ;13              
 .byt 0				;14 Fishy Plaice   Temples Great Horn Search
 .byt 0                                 ;15              

;An Object(Up to 128) may be placed on the ground, held by a creature or posessed
;by the hero. Must allow for new items being added (hero adding infinite item)
;3 Tables define the object

;A0-4 XPOS (4-35)
;A5-7
;B0-2 ScreenID(0-7)
;B3-7 ObjectID(0-30)
;C0-3 Outside MapID(0-5)
;C4
;C5   Shown(0) or Hidden(1)
;C6   One Off(0) or Infinite Supply(1) will always appear at location
;C7   Used(0) or Unused(1)

;A0-4 XPOS (4-35)
;A5-7
;B0-2 ScreenID(0-7)
;B3-7 ObjectID(0-30)
;C0-3 Inside MapID(6-9)
;C4
;C5   Shown(0) or Hidden(1)
;C6   One Off(0) or Infinite Supply(1) will always appear at location
;C7   Used(0) or Unused(1)

;A0-4  CreatureID(0-31)
;A5-7
;B0   Owned by Creature(0) or Held for Hero(1)
;B1   Shown(0) or Hidden(1)
;B2   Normally Shown(0) Normally Hidden(1)
;B3-7 ObjectID
;C0-3 Held by Creature(10)
;C4-5
;C6   One Off(0) or Infinite Supply(1) like Derbs Bread
;C7   Used(0) or Unused(1)


;A0-4 CreatureID of lender
;A5-7
;B0   Owned by Hero(0) or Held for Creature(1) I think this is redundant
;B1   Shown(0) or Hidden(1) (Do not reveal to characters)
;B2   Normally Shown(0) Normally Hidden(1)
;B3-7 ObjectID
;C0-3 Held by Hero(11)
;C4
;C5   Shown(0) or Hidden(1)
;C6   One Off(0) or Infinite Supply(1) like Magic knife
;C7   Used(0) or Unused(1)

;A0-4 -
;A5-7 -
;B0-2 -
;B3-7 ObjectID
;C0-3 Held in Sub-game(12-15)
;C4
;C5   Shown(0) or Hidden(1)
;C6   One Off(0) or Infinite Supply(1) will always appear at location
;C7   Used(0) or Unused or inactive(1)

#include "c:\osdk\projects\wurlde\playerfile\otDefines.s"
Objects_A		;9C2C
 .byt oXPOS19	;SSC-OM2S5 Knife
 .byt oXPOS31	;SSC-OM2S6 Blue Potion in sand
 .byt oXPOS6	;SSC-OM0S6 Toadstool

;Items held by characters
;Nylot holds GreenPotion,BluePotion and hides Scroll
 .byt oCreatureID0 	;Nylots Green Potion
 .byt oCreatureID0 	;Nylots Blue Potion
 .byt oCreatureID0 	;Nylots Hidden Scroll
 .byt oCreatureID1 	;Drummonds Birdcage
 .byt oCreatureID2 	;Liefs Flask
 .byt oCreatureID5 	;Bartons Fish Stew

 .byt oCreatureID3 	;Derbs Bread
 .byt oCreatureID30 ;Callum's Fruit
 .byt oCreatureID30 ;Callum's Blak Loaf
 .byt oCreatureID30 ;Callum's Lem Bread
 .byt oCreatureID30 ;Callum's Funghi
 
 .byt oCreatureID11 ;milos ebony wand     
 .byt oCreatureID11 ;milos bows +         
 .byt oCreatureID11 ;milos quills +       
 .byt oCreatureID11 ;milos Butterfly Net +
                       
 .byt oCreatureID23 ;merideths Potion +   
 .byt oCreatureID23 ;merideths Elixir +   
 .byt oCreatureID23 ;merideths Vial +   
 .byt oCreatureID23 ;merideths Emerald +  
 .byt oCreatureID23 ;merideths Diamond +  
 .byt oCreatureID23 ;merideths Scroll +   
 .byt oCreatureID23 ;merideths Ivory Wand 
 .byt oCreatureID23 ;merideths Tablet?    
 .byt oCreatureID23 ;merideths Parchment +
                       
 .byt oCreatureID28 ;Rotfilsh's Bok Fish +   
 .byt oCreatureID28 ;Rotfilsh's Glant +      
                       
 .byt oCreatureID29 ;Triffiths Knife +    
 .byt oCreatureID29 ;Triffiths Sword +    
 .byt oCreatureID29 ;Triffiths Bird Cage  
                       
 .byt oCreatureID5 	;Bartons Ale +        
 .byt oCreatureID6 	;Keeshas Ale +        
 .byt oCreatureID1 	;Drummonds Ale +      
 .byt oCreatureID2 	;Liefs Ale +          
 
 .byt oCreatureID5 	;Bartons Ale +        
 .byt oCreatureID1 	;Drummonds Ale +      
 
 .byt oCreatureID16	;Temples Glant (Fishy Plaice)
 .byt oCreatureID16	;Temples Horn (Once he gets it)
 ;
 .dsb 88,0

;Wood next to mill house
;Health potion in sand
Objects_B		;9CAC
 .byt oScreenID5+oObjectID19	;SSC-OM2S5 Parchment (Hints for crossing Quagmire)
 .byt oScreenID6+oObjectID3	;SSC-OM2S6 Health Potion(On Shore next to hero)
 .byt oScreenID6+oObjectID27	;SSC-OM0S6 Toadstool 

 .byt 8*2		;Nylots Green Potion
 .byt 8*4		;Nylots Blue Potion -
 .byt 2+8*9	;Nylots Hidden Scroll - Distortion Shield against wraithes
 .byt 8*18	;InnKeepers Birdcage - first hint of gas in mines
 .byt 8*21	;Liefs Flask (Contains Grease for Windmill)
 .byt 8*15	;Bartons Fish Stew

 .byt oOwned+oShown+oNormallyShown+oObjectID25 ;Derb's Bread
 .byt oOwned+oShown+oNormallyShown+oObjectID0  ;Callum's Fruit
 .byt oOwned+oShown+oNormallyShown+oObjectID25 ;Callums Blak Loaf
 .byt oOwned+oShown+oNormallyShown+oObjectID26 ;Callums Lem Bread
 .byt oOwned+oShown+oNormallyShown+oObjectID27 ;Callums Funghi   

 .byt oOwned+oShown+oNormallyShown+oObjectID13 ;milos ebony wand     
 .byt oOwned+oShown+oNormallyShown+oObjectID28 ;milos bows +         
 .byt oOwned+oShown+oNormallyShown+oObjectID29 ;milos quills +       
 .byt oOwned+oShown+oNormallyShown+oObjectID1  ;milos Butterfly Net +
                       
 .byt oOwned+oShown+oNormallyShown+oObjectID2  ;merideths Potion +   
 .byt oOwned+oShown+oNormallyShown+oObjectID3  ;merideths Elixir +   
 .byt oOwned+oShown+oNormallyShown+oObjectID4  ;merideths Vial +   
 .byt oOwned+oShown+oNormallyShown+oObjectID7  ;merideths Emerald +  
 .byt oOwned+oShown+oNormallyShown+oObjectID10 ;merideths Diamond +  
 .byt oOwned+oShown+oNormallyShown+oObjectID9  ;merideths Scroll +   
 .byt oOwned+oShown+oNormallyShown+oObjectID12 ;merideths Ivory Wand 
 .byt oOwned+oShown+oNormallyShown+oObjectID17 ;merideths Tablet?    
 .byt oOwned+oShown+oNormallyShown+oObjectID19 ;merideths Parchment +
                       
 .byt oOwned+oShown+oNormallyShown+oObjectID5  ;Rotfilsh's Bok Fish +   
 .byt oOwned+oShown+oNormallyShown+oObjectID23 ;Rotfilsh's Glant +      
                       
 .byt oOwned+oShown+oNormallyShown+oObjectID14 ;Triffiths Knife +    
 .byt oOwned+oShown+oNormallyShown+oObjectID16 ;Triffiths Sword +    
 .byt oOwned+oShown+oNormallyShown+oObjectID18 ;Triffiths Bird Cage  
                       
 .byt oOwned+oShown+oNormallyShown+oObjectID22 	;Bartons Ale +        
 .byt oOwned+oShown+oNormallyShown+oObjectID22 	;Keeshas Ale +        
 .byt oOwned+oShown+oNormallyShown+oObjectID22 	;Drummonds Ale +      
 .byt oOwned+oShown+oNormallyShown+oObjectID22 	;Liefs Ale +          
 .byt oOwned+oShown+oNormallyShown+oObjectID24 	;Bartons Lodging +
 .byt oOwned+oShown+oNormallyShown+oObjectID24 	;Drummonds Lodging +
 
 .byt oOwned+oShown+oNormallyShown+oObjectID23	;Temples Glant (Fishy Plaice)
 .byt oOwned+oShown+oNormallyShown+oObjectID30	;Temples Horn (Once he gets it)
 .dsb 88,0

Objects_C
 .byt oMap2
 .byt oMap2
 .byt oMap0
 
 .byt oCreatureHeld	;Same constant as LS_HELDBYCREATURE
 .byt oCreatureHeld
 .byt oCreatureHeld
 .byt oCreatureHeld
 .byt oCreatureHeld
 .byt oCreatureHeld+oInfiniteSupply	;Bartons Fish Stew
 
 .byt oCreatureHeld+oInfiniteSupply	;Derb's Bread
 .byt oCreatureHeld+oInfiniteSupply	;Callum's Fruit
 .byt oCreatureHeld+oInfiniteSupply	;Callums Blak Loaf
 .byt oCreatureHeld+oInfiniteSupply	;Callums Lem Bread
 .byt oCreatureHeld+oInfiniteSupply	;Callums Funghi
 
 .byt oCreatureHeld			;milos ebony wand
 .byt oCreatureHeld+oInfiniteSupply	;milos bows +
 .byt oCreatureHeld+oInfiniteSupply	;milos quills +
 .byt oCreatureHeld+oInfiniteSupply	;milos Butterfly Net +
 
 .byt oCreatureHeld+oInfiniteSupply	;merideths Potion +
 .byt oCreatureHeld+oInfiniteSupply	;merideths Elixir +
 .byt oCreatureHeld+oInfiniteSupply	;merideths Fusion +
 .byt oCreatureHeld+oInfiniteSupply	;merideths Emerald +
 .byt oCreatureHeld+oInfiniteSupply	;merideths Diamond +
 .byt oCreatureHeld+oInfiniteSupply	;merideths Scroll +
 .byt oCreatureHeld			;merideths Ivory Wand
 .byt oCreatureHeld			;merideths Tablet?
 .byt oCreatureHeld+oInfiniteSupply	;merideths Parchment +

 .byt oCreatureHeld+oInfiniteSupply	;Rotfilsh's Bok Fish +
 .byt oCreatureHeld+oInfiniteSupply	;Rotfilsh's Glant +
 
 .byt oCreatureHeld+oInfiniteSupply	;Triffiths Knife +
 .byt oCreatureHeld+oInfiniteSupply	;Triffiths Sword +
 .byt oCreatureHeld			;Triffiths Bird Cage

 .byt oCreatureHeld+oInfiniteSupply	;Bartons Ale +
 .byt oCreatureHeld+oInfiniteSupply	;Keeshas Ale +
 .byt oCreatureHeld+oInfiniteSupply	;Drummonds Ale +
 .byt oCreatureHeld+oInfiniteSupply	;Liefs Ale +
 .byt oCreatureHeld+oInfiniteSupply	;Bartons Lodging +
 .byt oCreatureHeld+oInfiniteSupply	;Drummonds Lodging +
 
 .byt oCreatureHeld+oInfiniteSupply	;Temples Glant (Fishy Plaice)
 .byt oCreatureHeld+128		;Temples Horn (Once he gets it)
 .dsb 88,128
 
;Whilst there are up to 128 objects spread across Wurlde, there are but 32 unique objects
;And each must be assigned a price that applies to them when bought or sold.
;However as the game progresses (or the day) the prices will change so the prices are held
;here. All Prices(32) held as 2 digit BCD and with max markup of 1.75 each item cannot be
;more than 57 Grotes
Current_GamePrices
Price_Fruit	.byt $07	;0 Ranges thru day between 07 and 12 Grotes
Price_ButterflyNet  .byt $28	;1
Price_PotionRed     .byt $25	;2 As game progresses price rises to 60
Price_ElixirGreen   .byt $25	;3 As game progresses price rises to 60
Price_VialBlue      .byt $30	;4 As game progresses price rises to 70
Price_FishBok       .byt $25	;5 Ranges thru day between 10 and 15 Grotes
Price_Spare         .byt $05	;6
Price_Spare2        .byt $03	;7
Price_Butterfly     .byt $01	;8
Price_Scroll        .byt $40	;9
Price_AquaStone     .byt $57	;10 X
Price_Sapphire	.byt $10  ;11 X
Price_IvoryWand     .byt $57	;12
Price_EbonyWand     .byt $57	;13
Price_Knife         .byt $55	;14
Price_FishStew      .byt $06	;15
Price_Sword         .byt $57	;16 X
Price_Tablet        .byt $45	;17
Price_Birdcage      .byt $20	;18
Price_Parchment     .byt $32	;19
Price_OldBriar      .byt $10	;20
Price_Flask         .byt $15	;21 Grease
Price_Grog          .byt $04	;22 Ranges thru day between 04 and 08 Grotes
Price_Glant         .byt $05	;23 Ranges thru day between 05 and 10 Grotes
Price_Lodging       .byt $25	;24 Ranges thru day between 05 and 10 Grotes
Price_BlakLoaf      .byt $03	;25
Price_LemBread      .byt $04	;26
Price_Funghi	.byt $10  ;27
Price_Bow		.byt $25  ;28
Price_Arrows	.byt $20  ;29
Price_GreatHorn     .byt $30	;30
Price_SpellBook     .byt $32	;31

;Based on Object table Format 32 Interactive unique Characters exist in Wurlde.
;Each Interactive Character has a block of 8 Bytes (x32 Characters == 256) defining them.

;+00 Health B0-3(0-15)  Mana B4-7(0-15)
;+01 Gender B0(Female(0) or Male(1))
;    - Stall holder B1(Character only(0) Character has stall(1))
;    Character LocationID B2-5(0-15)
;    Allegiance B6(Friend(0) or Foe(1))
;    Character Unused B7(Character Used(0) Character Unused(1))
;+02 RumourMongerer B0-1(Never(0) - Always(3))
;    B2-3
;    GroupID B4-7(0-15)
;+03 Intoxication Level B0-3(0-15)
;    Intoxication Limit B4-7(0-15)
;+04 Fraction for Buying B0-1
;	0(1.0) 1(1.25) 2(1.5) 3(1.75)
;    Fraction for Selling B2-3
;	0(1.0) 1(1.25) 2(1.5) 3(1.75)
;    B4-7
;+05 Grotes(3xBCD)


#include "c:\osdk\projects\wurlde\playerfile\cbDefines.s"

CharacterBlocks	;9D2C

Nylot_Tribesman	;0
 .byt cbHealth12+cbMana9
 .byt cbMale+cbLocation6+cbFriend
 .byt cbRumourSet0+cbGroup_Tribesman
 .byt cbToxicLevel0+cbToxicLimit5
 .byt cbBuyingFrac100+cbSellingFrac100
 .byt $00,$02,$54
Drummond_Publican	;1
 .byt cbHealth14+cbMana0
 .byt cbMale+cbInfo+cbLocation1+cbFriend
 .byt cbRumourSet0+cbGroup_Publican
 .byt cbToxicLevel0+cbToxicLimit15
 .byt cbBuyingFrac125+cbSellingFrac150
 .byt $00,$03,$74
Lief_Publican	;2
 .byt cbHealth10+cbMana5
 .byt cbFemale+cbInfo+cbLocation1+cbFriend
 .byt cbRumourSet0+cbGroup_Publican
 .byt cbToxicLevel0+cbToxicLimit15
 .byt cbBuyingFrac125+cbSellingFrac150
 .byt $00,$02,$76
Derb_Baker	;3
 .byt cbHealth15+cbMana2
 .byt cbMale+cbLocation7+cbFriend
 .byt cbRumourSet1+cbGroup_Baker
 .byt cbToxicLevel0+cbToxicLimit8
 .byt cbBuyingFrac125+cbSellingFrac175
 .byt $00,$94,$27
Jumbee_Cobbler	;4
 .byt cbHealth10+cbMana0
 .byt cbMale+cbLocation2+cbFriend
 .byt cbRumourSet3+cbGroup_Cobbler
 .byt cbToxicLevel0+cbToxicLimit10
 .byt cbBuyingFrac125+cbSellingFrac150
 .byt $00,$01,$34
Barton_InnKeeper	;5
 .byt cbHealth14+cbMana1
 .byt cbMale+cbInfo+cbLocation0+cbFriend
 .byt cbRumourSet1+cbGroup_Publican
 .byt cbToxicLevel0+cbToxicLimit15
 .byt cbBuyingFrac125+cbSellingFrac150
 .byt $00,$05,$73
Keesha_Publican	;6
 .byt cbHealth12+cbMana3
 .byt cbFemale+cbLocation0+cbFriend
 .byt cbRumourSet0+cbGroup_Publican
 .byt cbToxicLevel0+cbToxicLimit15
 .byt cbBuyingFrac100+cbSellingFrac150
 .byt $00,$04,$89
Kobla_Pirate	;7
 .byt cbHealth14+cbMana8
 .byt cbMale+cbLocation0+cbFriend
 .byt cbRumourSet2+cbGroup_Pirate
 .byt cbToxicLevel0+cbToxicLimit12
 .byt cbBuyingFrac100+cbSellingFrac175
 .byt $00,$87,$93
Ribald_Fisherman	;8
 .byt cbHealth7+cbMana0
 .byt cbMale+cbLocation0+cbFriend
 .byt cbRumourSet2+cbGroup_Pirate
 .byt cbToxicLevel5+cbToxicLimit9
 .byt cbBuyingFrac150+cbSellingFrac175
 .byt $00,$52,$86
Rangard_Fisherman	;9
 .byt cbHealth10+cbMana1
 .byt cbMale+cbLocation1+cbFriend
 .byt cbRumourSet1+cbGroup_Fisherman
 .byt cbToxicLevel0+cbToxicLimit10
 .byt cbBuyingFrac125+cbSellingFrac175
 .byt $00,$01,$34
Keggs_Fisherman	;10
 .byt cbHealth7+cbMana0
 .byt cbMale+cbLocation1+cbFriend
 .byt cbRumourSet0+cbGroup_Fisherman
 .byt cbToxicLevel0+cbToxicLimit8
 .byt cbBuyingFrac150+cbSellingFrac175
 .byt $00,$00,$35
Milo_Carpenter	;11
 .byt cbHealth3+cbMana2
 .byt cbFemale+cbLocation2+cbFriend
 .byt cbRumourSet1+cbGroup_Carpenter
 .byt cbToxicLevel0+cbToxicLimit7
 .byt cbBuyingFrac150+cbSellingFrac175
 .byt $00,$04,$09
Retnig_Serf	;12
 .byt cbHealth5+cbMana8
 .byt cbMale+cbLocation1+cbFriend
 .byt cbRumourSet3+cbGroup_Peasant
 .byt cbToxicLevel0+cbToxicLimit9
 .byt cbBuyingFrac125+cbSellingFrac150
 .byt $00,$01,$00
Yltendoq_Priest	;13
 .byt cbHealth4+cbMana13
 .byt cbMale+cbLocation12+cbFriend
 .byt cbRumourSet0+cbGroup_Clergyman
 .byt cbToxicLevel0+cbToxicLimit4
 .byt cbBuyingFrac125+cbSellingFrac175
 .byt $00,$00,$43
Mardon_Serf	;14
 .byt cbHealth15+cbMana10
 .byt cbMale+cbLocation0+cbFriend
 .byt cbRumourSet3+cbGroup_Peasant
 .byt cbToxicLevel0+cbToxicLimit10
 .byt cbBuyingFrac100+cbSellingFrac175
 .byt $00,$00,$73
Lintu_Child	;15
 .byt cbHealth13+cbMana12
 .byt cbFemale+cbLocation9+cbFriend
 .byt cbRumourSet3+cbGroup_Peasant
 .byt cbToxicLevel0+cbToxicLimit2
 .byt cbBuyingFrac100+cbSellingFrac100
 .byt $00,$00,$21
;Tell Temple about artifact lost beneath the waves, leave and return to map
;and he will posess it (after diving to fetch it).
Temple_Child	;16
 .byt cbHealth15+cbMana13
 .byt cbMale+cbLocation14+cbFriend
 .byt cbRumourSet3+cbGroup_Peasant
 .byt cbToxicLevel0+cbToxicLimit2
 .byt cbBuyingFrac100+cbSellingFrac125
 .byt $00,$05,$42
Tallard_Steward	;17
 .byt cbHealth14+cbMana0
 .byt cbMale+cbLocation1+cbFriend
 .byt cbRumourSet0+cbGroup_Steward
 .byt cbToxicLevel0+cbToxicLimit6
 .byt cbBuyingFrac100+cbSellingFrac125
 .byt $00,$19,$43
Kinda_Bakerboy	;18
 .byt cbHealth12+cbMana3
 .byt cbMale+cbLocation7+cbFriend
 .byt cbRumourSet0+cbGroup_Labourer
 .byt cbToxicLevel0+cbToxicLimit8
 .byt cbBuyingFrac125+cbSellingFrac150
 .byt $00,$00,$40
Abbot_Clergy	;19
 .byt cbHealth8+cbMana0
 .byt cbMale+cbLocation12+cbFriend
 .byt cbRumourSet0+cbGroup_Clergyman
 .byt cbToxicLevel0+cbToxicLimit5
 .byt cbBuyingFrac100+cbSellingFrac100
 .byt $00,$00,$36
Prest_Clergy	;20
 .byt cbHealth9+cbMana0
 .byt cbMale+cbLocation5+cbFriend
 .byt cbRumourSet0+cbGroup_Clergyman
 .byt cbToxicLevel0+cbToxicLimit4
 .byt cbBuyingFrac100+cbSellingFrac100
 .byt $00,$01,$22
Jiro_Child	;21
 .byt cbHealth15+cbMana14		;0
 .byt cbMale+cbLocation10+cbFriend      ;1
 .byt cbRumourSet0+cbGroup_Sorcerer     ;2
 .byt cbToxicLevel0+cbToxicLimit15      ;3
 .byt cbBuyingFrac125+cbSellingFrac150	;4
 .byt $00,$00,$10                       ;5,6,7
OldTom_Farmer	;22
 .byt cbHealth5+cbMana0
 .byt cbMale+cbLocation8+cbFriend
 .byt cbRumourSet0+cbGroup_Labourer
 .byt cbToxicLevel8+cbToxicLimit8
 .byt cbBuyingFrac100+cbSellingFrac125
 .byt $00,$00,$47
Merideth_Dealer	;23
 .byt cbHealth14+cbMana8
 .byt cbFemale+cbLocation2
 .byt cbRumourSet0+cbGroup_Antiquary
 .byt cbToxicLevel2+cbToxicLimit15
 .byt cbBuyingFrac125+cbSellingFrac175
 .byt $00,$82,$39
Witch_Witch	;24
 .byt cbHealth14+cbMana8
 .byt cbFemale+cbLocation11
 .byt cbRumourSet0+cbGroup_Sorcerer
 .byt cbToxicLevel2+cbToxicLimit15
 .byt cbBuyingFrac100+cbSellingFrac100
 .byt $00,$53,$86
Spider_Wizard	;25
 .byt cbHealth14+cbMana8
 .byt cbFemale+cbLocation3
 .byt cbRumourSet0+cbGroup_Sorcerer
 .byt cbToxicLevel2+cbToxicLimit15
 .byt cbBuyingFrac100+cbSellingFrac125
 .byt $00,$00,$00
Erth_Wizard	;26
 .byt cbHealth12+cbMana15
 .byt cbMale+cbLocation10
 .byt cbRumourSet0+cbGroup_Sorcerer
 .byt cbToxicLevel0+cbToxicLimit15
 .byt cbBuyingFrac100+cbSellingFrac100
 .byt $00,$10,$03
Munk_Clergy	;27
 .byt cbHealth15+cbMana5
 .byt cbMale+cbLocation5
 .byt cbRumourSet0+cbGroup_Clergyman
 .byt cbToxicLevel2+cbToxicLimit14
 .byt cbBuyingFrac100+cbSellingFrac100
 .byt $00,$01,$00
Rotfilsh_FishMonger	;28
 .byt cbHealth15+cbMana5
 .byt cbMale+cbLocation2
 .byt cbRumourSet0+cbGroup_FishMonger
 .byt cbToxicLevel2+cbToxicLimit14
 .byt cbBuyingFrac125+cbSellingFrac175
 .byt $00,$05,$76
Triffith_Ironsmith	;29
 .byt cbHealth12+cbMana0
 .byt cbMale+cbLocation2
 .byt cbRumourSet0+cbGroup_IronSmith
 .byt cbToxicLevel0+cbToxicLimit10
 .byt cbBuyingFrac125+cbSellingFrac175
 .byt $00,$02,$21
Callum_Grocer	;30
 .byt cbHealth12+cbMana2
 .byt cbMale+cbLocation2
 .byt cbRumourSet0+cbGroup_Grocer
 .byt cbToxicLevel0+cbToxicLimit15
 .byt cbBuyingFrac125+cbSellingFrac175
 .byt $00,$05,$23
Jiles_Farmer	;31
 .byt cbHealth15+cbMana5
 .byt cbMale+cbLocation9
 .byt cbRumourSet0+cbGroup_Labourer
 .byt cbToxicLevel2+cbToxicLimit14
 .byt cbBuyingFrac125+cbSellingFrac125
 .byt $00,$00,$50
;9E2C
;GroupID corresponds to the group that the character is associated with and is displayed
;aside the Characters name in the Character Selection Form.
;00 Publican
;01 Pirate
;02 Baker
;03 Cobbler
;04 Labourer
;05 Fisherman
;06 Serf
;07 Tribesman
;08 Dealer
;09 Child
;10 Steward
;11 Farmer
;12 
;13 Clergy
;14 Witch
;15 Wizard


;Remainder unused
 .dsb 256-(*&255)
;Name/Group	Index	GFX	Location/Description		Time

;Nylot_Tribesman	;0	1  of 32	06 LittlePee, Mount Ciro		Everyday
;Drummond_InnKeeper	;1	2  of 32	01 Pirates Arms Inn, Sassubree	Everyday
;Lief_Wench	;2	8  of 32	01 Pirates Arms Inn, Sassubree	Everyday
;Derb_Baker	;3	9  of 32	07 Sassubree Bakery, Sassubree	Everyday
;Jumbee_Cobbler	;4	22 of 32	02 Market, Sassubree		Everyday
;Barton_InnKeeper	;5	20 of 32	00 Kissing Widow Tavern, Sassubree	Everyday
;Keesha_Wench	;6	18 of 32	00 Kissing Widow Tavern, Sassubree	Everyday
;Kobla_Pirate	;7	5  of 32	00 Kissing Widow Tavern, Sassubree	Nights
;Ribald_Fisherman	;8	6  of 32	00 Kissing Widow Tavern, Sassubree	Nights
;Rangard_Fisherman	;9	7  of 32	01 Pirates Arms&Fishy Plaice, Sassubree	Evenings&Mornings
;Keggs_Fisherman	;10	11 of 32	14 Fishy Place&Kissing Widow, Sasubree	Mornings&Evenings
;Tygor_Peasant	;11	19 of 32	01 Pirates Arms Inn, Sassubree	Everyday
;Retnig_Peasant	;12	21 of 32	00 Kissing Widow Tavern, Sassubree	Everyday
;Yltendoq_Priest	;13	10 of 32	12 Tirn Church, Homeland		Everyday
;Mardon_Peasant	;14	16 of 32	01 Pirates Arms Inn, Sassubree	Everyday
;Lintu_Child	;15	27 of 32	02 Market, Sassubree		Everyday
;Temple_Child	;16	4  of 32	02 Market, Sassubree		Everyday
;Tallard_Steward	;17	3  of 32	01 Pirates Arms Inn, Sassubree	Everyday
;Kinda_Bakerboy	;18	17 of 32	07 Bakery&Fishy Plaice, Sassubree	Nights&Mornings
;Abbot_Clergy	;19	23 of 32	12 Tirn Church, Homeland		Everyday
;Prest_Clergy	;20	25 of 32	05 Monastery, Samson Isle		Everyday
;Jiro_Child	;21	29 of 32	10 Wizards House, Homeland		Everyday
;OldTom_Farmer	;22	24 of 32	08 Mill House, Ritemoor		Days
;Merideth_Dealer	;23	14 of 32	02 Market, Sassubree		Every 5th Day
;Witch_Witch	;24	12 of 32  11 Banit Witches Castle, Sassubree	Everyday
;Spider_Wizard	;25	13 of 32	03 spider for log cabin,samson	Everyday
;Erth_Wizard	;26	15 of 32	10 Wizards House, Homeland		Everyday
;Munk_Clergy	;27	30 of 32	05 Monastery, Samson Isle		Everyday
;Spare_Character1	;28	26 of 32	"Big nose traveller" (Spare)
;Triffith_Dealer	;29	32 of 32	02 Market, Sassubree		Every 3rd Day
;Callum_Dealer	;30	31 of 32	02 Market, Sassubree		Every 3rd Day
;Jiles_Farmer	;31	28 of 32	09 Windmill, Ritemoor		Days

