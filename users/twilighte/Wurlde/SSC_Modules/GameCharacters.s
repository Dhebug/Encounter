;Game Characters

;Indexed by CharacterID x 2
GameCharacterPropertyListLo
 .byt <NylotBlock
GameCharacterPropertyListHi
 .byt >NylotBlock

;Property Block
;+00 Health (0-15)
;+01 Mana   (0-15)
;+02 Item 1 (0-63 Item, +64 Hidden, 128 for no item)
;+03 Item 2
;+04 Item 3
;+05 Item 4
;+06 Item 5
;+07 Item 6
;+08 Item 7
;+09 Item 8
;+10 Item 9
;+11 Item 10
;+12 Gender (Female(0)Male(1)Unknown(2))
;+13 Info Flag (New Info(1) No Info(0))
;+14 Grotes Text (6)
;+20 Name (10 Characters)
;+30 Title (10 Characters)
;+40 Grotes BCD (3)
;+43 Face Graphic Lo
;+44 Face Graphic Hi
NylotBlock
 .byt 75
 .byt 10

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

 .byt 1
 .byt 0
 .byt "000000"
 .byt "NYLOT     "
 .byt "TRIBESMAN "

 .byt 0,0,%00011111
 .byt <TribeFace
 .byt >TribeFace

;Face Graphic is always 3x15
;BG is always alternating Red rows, starting on first row
TribeFace
 .byt $5F,$78,$7F
 .byt $40,$40,$40
 .byt $7F,$62,$4F
 .byt $07,$42,$40
 .byt $7F,$42,$47
 .byt $05,$4D,$60
 .byt $7E,$62,$4B
 .byt $01,$48,$60
 .byt $7F,$47,$47
 .byt $03,$50,$50
 .byt $7E,$57,$53
 .byt $01,$48,$60
 .byt $7D,$67,$4D
 .byt $06,$42,$40
 .byt $7F,$78,$7F

