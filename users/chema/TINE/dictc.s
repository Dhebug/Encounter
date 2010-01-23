


#define A_FWBLACK        0
#define A_FWRED          1
#define A_FWGREEN        2
#define A_FWYELLOW       3
#define A_FWBLUE         4
#define A_FWMAGENTA      5
#define A_FWCYAN         6
#define A_FWWHITE        7
#define A_BGBLACK       16
#define A_BGRED         17
#define A_BGGREEN       18
#define A_BGYELLOW      19
#define A_BGBLUE        20
#define A_BGMAGENTA     21
#define A_BGCYAN        22
#define A_BGWHITE       23


__texts_start


; Strings for Tine

Baseprices .byt $13, $14, $41, $28, $53, $C4, $EB, $9A, $75, $4E, $7C, $B0, $20, $61, $AB, $2D, $35
Gradients  .byt $fe, $ff, $fd, $fb, $fb, $08, $1D, $0E, $06, $01, $0d, $f7, $ff, $ff, $fe, $ff, $0F
Basequants .byt $06, $0A, $02, $E2, $FB, $36, $08, $38, $28, $11, $1D, $DC, $35, $42, $37, $FA, $C0 
Maskbytes  .byt $01, $03, $07, $1F, $0F, $03, $78, $03, $07, $1F, $07, $3F, $03, $07, $1F, $0F, $07
Units      .byt 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 2, 0
Goodnames  .asc "F�d"
           .byt 0
           .asc "T�t�s"
           .byt 0
           .asc "R�io�tԝ"
           .byt 0
           .asc "Slav�"
           .byt 0
           .asc "LiƆs/W��"   
           .byt 0
           .asc "Lux�i�"
           .byt 0
           .asc "N�c��s"
           .byt 0
           .asc "�put�"
           .byt 0
           .asc "M�h��y"
           .byt 0
           .asc "Al�ys"
           .byt 0
           .asc "Fi��s"
           .byt 0
           .asc "F�"
           .byt 0
           .asc "M���s"
           .byt 0
           .asc "G�d"
           .byt 0
           .asc "Pl��um"
           .byt 0
           .asc "G�-St��"
           .byt 0
           .asc "Ali� It�s"
           .byt 0

Unitnames
            .asc "t"
            .byt 0
            .asc "kg"
            .byt 0
            .asc "g"
            .byt 0


; Inhabitants... Large Green Bug-eyed Rodents
Fierce 
    .asc "L�e"
    .byt 0
    .asc "Fi��"
    .byt 0
    .asc "Sm�l"
    .byt 0
Type
    .asc "G��"
    .byt 0
    .asc "R�"
    .byt 0
    .asc "Yàw"
    .byt 0
    .asc "Blue"
    .byt 0
    .asc "Bl�k"
    .byt 0
    .asc "Hޅss"
    .byt 0
Bugeyed
    .asc "Slimy"
    .byt 0
    .asc "B�-ey�"
    .byt 0
    .asc "H�n�"
    .byt 0
    .asc "B�y"
    .byt 0
    .asc "F�"
    .byt 0
    .asc "F�ry"
    .byt 0

Race
    .asc "Rod�"
    .byt 0
    .asc "F�g"
    .byt 0
    .asc "Liz�d"
    .byt 0
    .asc "Lob��"
    .byt 0
    .asc "Bird"
    .byt 0
    .asc "Hu��"
    .byt 0
    .asc "FÄe"
    .byt 0
    .asc "���"
    .byt 0

HumanCol
    .byt "Hu� �l��"
    .byt 0



; For system information

govnames
            .asc "An��y"
            .byt 0
            .asc "Feud�"
            .byt 0
            .asc "M�i-go�nm�"
            .byt 0
            .asc "D�t����"
            .byt 0
            .asc "�m�i�"
            .byt 0
            .asc "C�f���y"
            .byt 0
            .asc "Dİ�cy"
            .byt 0
            .asc "C�p���St�e"
            .byt 0

econnames
            .asc "R�h ����"
            .byt 0
            .asc "捿���"
            .byt 0
            .asc "������"
            .byt 0
            .asc "M�l�����"
            .byt 0
            .asc "M�֣�ɗ�"
            .byt 0
            .asc "R�h��ɗ�"
            .byt 0
            .asc "�A�ɗ�"
            .byt 0
            .asc "��A�ɗ�"
            .byt 0


str_data    .asc "D�a �"
            .byt 0
str_dist    .asc "Di���"
            .byt 0
str_eco     .asc "Ec�omy"
            .byt 0
str_gov     .asc "Go�nm�"
            .byt 0
str_tech    .asc "Te�.�ev�"
            .byt 0
str_gross   .asc "G�s�P٤�Ԍy"
            .byt 0
str_rad     .asc "�R�i�"
            .byt 0
str_pop     .asc "�p��"
            .byt 0
str_km      .asc " Km."
            .byt 0
str_bill    .asc " B�l�"
            .byt 0
str_ly      .asc "���Ye�s"
            .byt 0
str_cr      .asc "��r."
            .byt 0

; These are for market
str_mkt     .asc "m�k� p��"
            .byt 0
str_mktquant
            .asc "Ƽ�y"
            .byt 0    
str_mktlist 
            .asc "p٤�"
            .byt 0
str_mktunit
            .asc "��"
            .byt 0

str_mktin   .asc "�"
            .byt 0

str_mktprice
            .asc "p�e"
            .byt 0
str_mktsale
            .asc "�sa�"
            .byt 0             
str_mktcargo 
            .asc "��"
            .byt 0

; For market buying/selling

str_cash    .asc "C�h"
            .byt 0
str_freespace
            .asc "S���ft"
            .byt 0
str_credits
            .asc "Cr."
            .byt 0

; Goat soup dictionary

desc_list
;81
    .asc "f��d"
    .byt 0
    .asc "n���"
    .byt 0
    .asc "w�l kn�"
    .byt 0
    .asc "f��"
    .byt 0
    .asc "n��"
    .byt 0
;82
    .asc "�y"
    .byt 0
    .asc "m�d�"
    .byt 0
    .asc "mo�"
    .byt 0
    .asc "�����"
    .byt 0
    .asc " "
    .byt 0

;83	
    .asc "�ci�"
    .byt 0
    .byt $15,0
    .asc "g��"
    .byt 0
    .asc "va�"
    .byt 0
    .asc "p�k"
    .byt 0

;84
    .byt $1E," ", $1D," ",
    .asc "���s"
    .byt 0
    .asc "mo�t�s"
    .byt 0
    .byt $1C, 0
    .byt $14
    .asc " f�e�s"
    .byt 0
    .asc "�e�s"
    .byt 0
;85	
    .asc "�yn�s"
    .byt 0
    .asc "s�l��s"
    .byt 0
    .asc "m����d��s"
    .byt 0
    .asc "��h� of "
    .byt $06, 0
    .asc "���"
    .byt $06,0
;86
    .asc "f�d��n�s"
    .byt 0
    .asc "to�i�s"
    .byt 0
    .asc "po�ry"
    .byt 0
    .asc  "d��s"
    .byt 0
    .byt $0E
    .byt 0

;87
    .asc "t�k���e"
    .byt 0
    .asc "c�b"
    .byt 0
    .asc "b�"
    .byt 0
    .asc "�b�"
    .byt 0
    .byt $7D
    .byt 0

;88
    .asc "b��"
    .byt 0
    .asc "��u�"
    .byt 0
    .asc "�v��"
    .byt 0
    .asc "c��"
    .byt 0
    .asc "sҗg�"
    .byt 0

;89
    .byt $16
    .asc " cԥ w�"
    .byt 0
    .byt $1B," ", $18," ", $19
    .asc "s"
    .byt 0
    .asc "a "
    .byt $1B
    .asc " d�e�e"
    .byt 0
    .byt $16
    .asc " e����"
    .byt 0
    .byt $16
    .asc " s׃ �tԌy"
    .byt 0

;8A
    .asc "�"
    .byt $03," ", $04
    .byt 0
    .asc "ۍ"
    .byt $7C," ", $18," ", $19
    .byt 0
    .asc "��h���s' "
    .byt $1A," ", $05
    .byt 0
    .byt $22, 0
    .asc "�"
    .byt $0D," ", $0E
    .byt 0

;8B
    .asc "ju�e"
    .byt 0
    .asc "br�dy"
    .byt 0
    .asc "w��"
    .byt 0
    .asc "b�w"
    .byt 0
    .asc "g���la��"
    .byt 0

;8C
    .byt $7D,0
    .byt $7C," ", $19, 0
    .byt $7C," ", $7D, 0
    .byt $7C," ", $1B, 0
    .byt $1B," ", $7D, 0

;8D	
    .asc "f���"
    .byt 0
    .asc "ӻ�"
    .byt 0
    .asc "h�py"
    .byt 0
    .asc "��u�"
    .byt 0
    .asc "�c��"
    .byt 0

;8E	
    .asc "cu��e"
    .byt 0
    .asc "n��life"
    .byt 0
    .asc "c��os"
    .byt 0
    .asc "s� �ms"
    .byt 0
    .byt " ", $22, " ", 0

;8F
    .asc $7b, 0
    .asc "��� "
    .byt $7b, 0
    .asc "��w�ld "
    .byt $7b, 0
    .asc "�� �"
    .byt 0
    .asc "�� w�ld"
    .byt 0

;90
    .asc "n ��m�k��"
    .byt 0
    .asc "���"
    .byt 0
    .asc " d�l"
    .byt 0
    .asc "��i�"
    .byt 0
    .asc " �v�t�"
    .byt 0

;91
    .asc "�"
    .byt 0
    .asc "w�ld"
    .byt 0
    .asc "��e"
    .byt 0
    .asc "l�� �"
    .byt 0
    .asc "�mp"
    .byt 0

;92
    .asc "w�p"
    .byt 0
    .asc "m�h"
    .byt 0
    .asc "grub"
    .byt 0
    .asc "�"
    .byt 0
    .byt $7D
    .byt 0

;93
    .asc "po�"
    .byt 0
    .asc "�t�g���e"
    .byt 0
    .asc "y�"
    .byt 0
    .asc "sna�"
    .byt 0
    .asc "sl�"
    .byt 0

;94
    .asc "t�p��"
    .byt 0
    .asc "d��"
    .byt 0
    .asc "��"
    .byt 0
    .asc "imp���b�"
    .byt 0
    .asc "�ub��"
    .byt 0

;95
    .asc "f�ny"
    .byt 0
    .asc "wi�d"
    .byt 0
    .asc "��u�"
    .byt 0
    .asc "�ge"
    .byt 0
    .asc "pec�i�"
    .byt 0

;96
    .asc "f�Ƣ"
    .byt 0
    .asc "�c���"
    .byt 0
    .asc "�pr��t��"
    .byt 0
    .asc "d��f�"
    .byt 0
    .asc "de��"
    .byt 0

;97
    .byt $02," ", $01
    .asc " �"
    .byt $0A,0
    .byt $02," ", $01
    .asc " �"
    .byt $0A
    .asc " �d "
    .byt $0A
    .byt 0
    .byt $08
    .asc "��"
    .byt $09 ,0
    .byt $02," ", $01
    .asc " �"
    .byt $0A
    .asc "�u�"
    .byt $08
    .asc "��"
    .byt $09,0
    .asc "a"
    .byt $10," ", $11,0
;98
    .byt $1B
    .byt 0
    .asc "mo�t�"
    .byt 0
    .asc "�ib�"
    .byt 0
    .asc "t�e"
    .byt 0
    .asc "sp�t�"
    .byt 0

;99
    .byt $1F
    .byt 0
    .byt $21
    .byt 0
    .byt $07
    .asc "�"
    .byt 0
    .byt $13
    .byt 0
    .byt $12
    .byt 0

;9A
    .asc "�ci�"
    .byt 0
    .asc "��pt��"
    .byt 0
    .asc "ecc��"
    .byt 0
    .asc "����"
    .byt 0
    .byt $15
    .byt 0

;9B
    .asc "k�l�"
    .byt 0
    .asc "de��"
    .byt 0
    .asc "ev�"
    .byt 0
    .asc "�ۉ"
    .byt 0
    .asc "v�i�"
    .byt 0

;9C
    .asc "�k� m��"
    .byt 0
    .asc "�� c�uds"
    .byt 0
    .asc "��b�s"
    .byt 0
    .asc "r� f�m�s"
    .byt 0
    .asc "v�c�o�"
    .byt 0

;9D
    .asc "��"
    .byt 0
    .asc "t��"
    .byt 0
    .asc "b��a"
    .byt 0
    .asc "c�n"
    .byt 0
    .byt $7D
    .asc "we�"
    .byt 0

;9E
    .byt $7D
    .byt 0
    .byt $7C," ", $7D, 0
    .byt $7C," ", $1B, 0
    .asc "�h���"
    .byt 0
    .byt $7C, " ", $7D, 0

;9F
    .asc "��w"
    .byt 0
    .asc "bea�"
    .byt 0
    .asc "b��"
    .byt 0
    .asc "sn�e"
    .byt 0
    .asc "w�f"
    .byt 0

;A0
    .asc "�o�d"
    .byt 0
    .asc "c�"
    .byt 0
    .asc "m�key"
    .byt 0
    .asc "go�"
    .byt 0
    .asc "f�h"
    .byt 0

;A1
    .byt $0C, " ", $0B, 0
    .byt $7C, " ", $1F, " ", $23, 0
    .asc "�"
    .byt $0D, " ", $21, " ", $23, 0
    .byt $24, " ", $25, 0
    .byt $0C, " ", $0B, 0

;A2
    .asc "me�"
    .byt 0
    .asc "cu�t"
    .byt 0
    .asc "�e�"
    .byt 0
    .asc "b�g�"
    .byt 0
    .asc "so�"
    .byt 0

;A3
    .asc "�e"
    .byt 0
    .asc "mud"
    .byt 0
    .asc "Z�o-G"
    .byt 0
    .asc "v�uum"
    .byt 0
    .byt $7C
    .asc " ɐ"
    .byt 0

;A4
    .asc "h�ey"
    .byt 0
    .asc "c�k�"
    .byt 0
    .asc "k��e"
    .byt 0
    .asc "po�"
    .byt 0
    .asc "t�n�"
    .byt 0


; For charts
str_galactic_chart
    .byt 6 ;A_FWCYAN
    .asc "GALACTIC�HART"
    .byt 0

str_short_chart
    .byt 6 ;A_FWCYAN
    .asc "SHORT RANGE�HART"
    .byt 0


; For searching planets

str_searchplanet
    .asc "Se�� �:"
    .byt 0

str_notfound
    .asc "N� Fo�d"
    .byt 0


; For main screen
str_commander
    .asc "�"
    .byt 0
str_present
	.byt A_FWCYAN
    .asc "�s�"
    .byt 0
str_hyper
	.byt A_FWCYAN
    .asc "Hyp��e"
    .byt 0
str_system
	.byt A_FWCYAN
    .asc "Sy��"
    .byt 0
;str_fuel 
;    .asc "Fu�"
;    .byt 0
str_status
	.byt A_FWCYAN
    .asc "Leg��t��"
    .byt 0
str_rating
	.byt A_FWCYAN
    .asc "R��"
    .byt 0
str_colon
    .asc "�"
	.byt A_FWWHITE
    .byt 0

; Legal status
str_clean
    .asc "C��"
    .byt 0
str_offender
    .asc "Off��"
    .byt 0
str_fugitive
    .asc "F���e"
    .byt 0

; Rating
str_harmless
    .asc "Hޅss"
    .byt 0
str_mostly
    .asc "Mo�l�Hޅss"
    .byt 0
str_poor
    .asc "��"
    .byt 0
str_average
    .asc "�e"
    .byt 0
str_above
    .asc "Abo��e"
    .byt 0
str_competent
    .asc "�p��"
    .byt 0
str_dangerous
    .asc "D�g��"
    .byt 0
str_deadly
    .asc "L�h�"
    .byt 0
str_elite
    .asc "��� I T� ��"
    .byt 0



; Equipment

; Fuel, Missile and Pulse laser 
; Large Bay, Escape pod, Scoops, ECMs, Bomb, Energy, GH, Beam laser, Mil Laser, Speed, Man

; Prices
/*
priceseqLO
   .byt <2,<300,<2000
   .byt <4000,<6000,<5250,<10000,<9000,<15000,<50000,<10000,<60000,<30000;,<45000
priceseqHI
   .byt >2,>300,>2000
   .byt >4000,>6000,>5250,>10000,>9000,>15000,>50000,>10000,>60000,>30000;,>45000
*/


priceseqLO
   .byt <2,<300,<2000
   .byt <4000,<10000,<5250,<6000,<9000,<15000,<50000,<10000,<60000,<30000;,<45000
priceseqHI
   .byt >2,>300,>2000
   .byt >4000,>10000,>5250,>6000,>9000,>15000,>50000,>10000,>60000,>30000;,>45000


; Techlevel min

eq_tech
    .byt 1,1,1
    .byt 1,6,5,2,7,8,10,4,10,10;,10

str_equipment
    .asc "eƹm�"
    .byt 0
str_fuel
str_equip
    .asc "Fu�"
    .byt 0
    .asc "�"
    .byt 0
    .asc "P�s�l��"
    .byt 0
    .asc "L��C�o Bay"
    .byt 0
    .asc "Escap��d"
    .byt 0
    .asc "S�ops"
    .byt 0
    .asc "E.C.M.�y��"
    .byt 0
    .asc "En���mb"
    .byt 0
    .asc "Ext��n��Ќ"
    .byt 0
    .asc "G��t� Hyp��e"
    .byt 0
    .asc "Beј��"
    .byt 0
    .asc "M���y���"
    .byt 0
    .asc "Ext��pe� Ќ"
    .byt 0
;    .asc "Ext��euv�b���Ќ"
;    .byt 0

str_selleq
    .asc "Eƹ�h�"
    .byt 0

str_item
    .asc "It�"
    .byt 0
str_missile
    .asc "�"
    .byt 0


str_blank 
	.asc "��"
	.byt 0
str_ship_names
	.asc "� "
	.byt 0
	.asc " Debr� "
	.byt 0
	.asc "��d�"
	.byt 0
	.asc "�l�y�"
	.byt 0
	.asc "�o�"
	.byt 0
	.asc "ꕜ "
	.byt 0
	.asc "A���"
	.byt 0
	.asc "S��t�"
	.byt 0
	.asc "Shut� "
	.byt 0
	.asc "Shut� "
	.byt 0
	.asc " V���"
	.byt 0
	.asc "��a�"
	.byt 0
	.asc "�b�-3 "
	.byt 0
	.asc " Pyۋ "
	.byt 0
	.asc "An��da"
	.byt 0
	.asc "�W�m�"
	.byt 0
	.asc "�b�-1 "
	.byt 0
	.asc " Gecko�"
	.byt 0
	.asc " K���"
	.byt 0
	.asc "��ba�"
	.byt 0
	.asc " W�� "
	.byt 0
	.asc "�d��"
	.byt 0
	.asc "�ay�"
	.byt 0
	.asc "���"
	.byt 0
	.asc "�Asp�"
	.byt 0
	.asc "�b�-3 "
	.byt 0
	.asc " Pyۋ "
	.byt 0
	.asc "��a�"
	.byt 0
	.asc "���"
	.byt 0
	.asc "��� "
	.byt 0
	.asc "�kn� "
	.byt 0
	.asc " ��� "
	.byt 0
 




flight_message_base
	.asc "��m� �"
	.byt 0
	.asc "GэO�"
	.byt 0
	.asc "Escap��d�a�"
	.byt 0
	.asc "�s�S���"
	.byt 0
	.asc "T����"
	.byt 0
	.asc "T���o�"
	.byt 0
	.asc "̣rm�"
	.byt 0
	.asc "� �ފ"
	.byt 0
	.asc "M�s��"
	.byt 0
	.asc "P�h��"
	.byt 0
	.asc "De���� f�"
	.byt 0
	.asc "En�y��"
	.byt 0
;	.asc "R�ڋ��!"
;	.byt 0
;	.asc "Lo��av� � (Y/N)?"
;	.byt 0


;; For load/save
str_loadsavetitle
	.asc "LOAD/SAVE G�e"
	.byt 0
str_loadsaveempty
	.asc "��mpt�S�ڬ"
	.byt 0
str_doloadsave
	.byt $0c
	.byt (A_FWRED)
	.asc "(S)ave�(L)o� �(Q)u�?"
	.byt 0
str_galslot
	.asc "G��"
	.byt 0
str_sysslot
	.asc "Sys�"
	.byt 0

; Other informative messages
str_land
	.byt $0c
	.byt (A_FWGREEN)
	.asc "�����l�d����"
	.byt 0
str_launch
	.byt $0c
	.byt (A_FWGREEN)
	.asc " ����la����"
	.byt 0


;; For in-screen instructions
/*
#define SCR_FRONT   0
#define SCR_INFO    1
#define SCR_MARKET  2
#define SCR_SYSTEM  3
#define SCR_GALAXY  4
#define SCR_CHART   5
#define SCR_EQUIP   6
#define SCR_LOADSAVE 7
*/
str_instr
	.asc "�/d��r�t/�ft�buy/�ll"
	.byt 0
	.asc " "
	.byt 0
	.asc "Mo�c��,��Rʃ�"
	.byt 0
	.asc "Mo�c��,�� de���"
	.byt 0
	.asc "�/d��,� �ENTER�o�uy"
	.byt 0
	.asc "�/d�h�� �ENTER� s�t"
	.byt 0

__texts_end

#echo Size of texts in bytes:
#print (__texts_end - __texts_start)
#echo





__grammar_start
Grammar
.byt 101, 114
.byt 32, 32
.byt 97, 110
.byt 97, 114
.byt 105, 110
.byt 108, 101
.byt 111, 114
.byt 97, 116
.byt 115, 116
.byt 97, 108
.byt 101, 100
.byt 111, 110
.byt 105, 116
.byt 101, 32
.byt 105, 99
.byt 101, 110
.byt 114, 97
.byt 101, 116
.byt 114, 101
.byt 105, 115
.byt 67, 111
.byt 117, 108
.byt 97, 99
.byt 117, 114
.byt 32, 76
.byt 117, 110
.byt 132, 103
.byt 134, 32
.byt 100, 128
.byt 101, 115
.byt 58, 32
.byt 97, 115
.byt 108, 111
.byt 112, 108
.byt 143, 116
.byt 32, 65
.byt 100, 117
.byt 105, 108
.byt 105, 139
.byt 115, 101
.byt 117, 115
.byt 118, 128
.byt 131, 103
.byt 148, 109
.byt 45, 45
.byt 97, 98
.byt 99, 116
.byt 109, 130
.byt 111, 99
.byt 114, 142
.byt 115, 32
.byt 121, 32
.byt 32, 98
.byt 80, 111
.byt 97, 100
.byt 97, 103
.byt 102, 155
.byt 105, 112
.byt 105, 133
.byt 111, 116
.byt 130, 116
.byt 32, 116
.byt 44, 32
.byt 73, 110
.byt 77, 147
.byt 84, 104
.byt 99, 104
.byt 101, 108
.byt 101, 109
.byt 111, 119
.byt 113, 117
.byt 115, 186
.byt 128, 115
.byt 149, 116
.byt 158, 167
.byt 171, 175
.byt 192, 199
.byt 203, 156
.byt 32, 83
.byt 65, 169
.byt 85, 110
.byt 97, 109
.byt 99, 111
.byt 101, 120
.byt 105, 118
.byt 105, 137
.byt 108, 121
.byt 111, 108
.byt 111, 168
.byt 114, 111
.byt 116, 32
.byt 116, 104
.byt 129, 32
.byt 130, 145
.byt 131, 109
.byt 133, 174
.byt 135, 166
.byt 136, 114
.byt 161, 221
.byt 176, 107
.byt 197, 110
.byt 202, 223
.byt 207, 183
.byt 32, 67
.byt 32, 69
.byt 32, 77
.byt 66, 111
.byt 80, 146
.byt 97, 107
.byt 97, 132
.byt 99, 101
.byt 103, 104
.byt 103, 177
.byt 105, 100
.byt 105, 239
.byt 111, 111
.byt 111, 241
.byt 112, 131
.byt 112, 150
.byt 115, 104
.byt 116, 133
.byt 117, 103
.byt 117, 112
.byt 118, 141
.byt 128, 103
.byt 129, 129
.byt 140, 178
.byt 151, 115
__grammar_end


#echo Size of grammar in bytes:
#print (__grammar_end - __grammar_start)
#echo

