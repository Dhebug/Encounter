;Game Characters

;Indexed by CharacterID x 2
GameCharacterPropertyListLo
 .byt <NylotBlock
GameCharacterPropertyListHi
 .byt >NylotBlock

;Property Block
;+00 Health (0-15)					4
;+01 Mana   (0-15)                                          4
;+02 Item 1 (0-63 Item, +64 Hidden, 128 for no item)        7
;+03 Item 2                                                 7
;+04 Item 3                                                 7
;+05 Item 4                                                 7
;+06 Item 5                                                 7
;+07 Item 6                                                 7
;+08 Item 7                                                 7
;+09 Item 8                                                 7
;+10 Item 9                                                 7
;+11 Item 10                                                7
;+12 Gender (Female(0)Male(1)Unknown(2))
;+13 Info Flag (New Info(1) No Info(0))
;+14 Grotes Text (6)
;+20 Name (10 Characters)
;+30 Title (10 Characters)
;+40 Grotes BCD (3)
;+43 Face Graphic Lo
;+44 Face Graphic Hi
; .byt "01234567890123456789012345678901234
NylotDescription
 .byt "Short thin Tribesman, Nylot is a   "
 .byt "member of the Plik Tribe, the last "
 .byt "and oldest remaining nomadic tribe "
 .byt "in Wurlde."
NylotBlock
 .byt 12
 .byt 9

 .byt 0
 .byt 2
 .byt 4
 .byt 6
 .byt 13
 .byt 1+64
 .byt 1+64
 .byt 128
 .byt 128
 .byt 128

 .byt 0
 .byt 1
 .byt "000000"
 .byt "NYLOT     "
 .byt "TRIBESMAN "

 .byt 0,0,%00011111
 .byt <TribeFace
 .byt >TribeFace
2InnKeeperDrummond
3BarMaidLief
4BakerDumbol
5CobblerJumbee
6InnKeeperBarton
7BarMaid
8PirateKobla
9FishermanRibald
10FishermanMangard
11FishermanKlang
12SerfTygor
13SerfRetnig
14LighthousemanBiggs
15ProstituteMardon
16GirlLintu
17BoyTemple
18StewardTallard
19HarbourMasterKeggs
20BakerboyKinda
21AbbotKarsta
22Priest


Places
Kissing Widow Tavern, Sassubree Docks
 InnKeeperBarton
 BarMaid
 FishermanRibald
 FishermanMangard
 FishermanKlang
 ProstituteMardon
 HarbourMasterKeggs
Pirates Arms Inn, Sassubree Town
 InnKeeperDrummond
 BarMaidLief
 SerfTygor
 SerfRetnig
 LighthousemanBiggs
 GirlLintu
 BoyTemple
 LordTallard
Sassubree Market, Sassubree Town
 CobblerJumbee
 BlacksmithMelbo

Sassubree Bakery, Sassubree Town
 BakerDumbol
 BakerboyKinda
Mill House, Ritemoor
 Peasant
Windmill, Ritemoor
 Farmer
Wizards House, Homeland
Banit Witches Castle, Ritemoor
Tirn Church
 Priest


