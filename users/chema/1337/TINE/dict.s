
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
Goodnames  .asc "Food"
           .byt 0
           .asc "Textiles"
           .byt 0
           .asc "Radioactives"
           .byt 0
           .asc "Slaves"
           .byt 0
           .asc "Liquors/Wines"   
           .byt 0
           .asc "Luxuries"
           .byt 0
           .asc "Narcotics"
           .byt 0
           .asc "Computers"
           .byt 0
           .asc "Machinery"
           .byt 0
           .asc "Alloys"
           .byt 0
           .asc "Firearms"
           .byt 0
           .asc "Furs"
           .byt 0
           .asc "Minerals"
           .byt 0
           .asc "Gold"
           .byt 0
           .asc "Platinum"
           .byt 0
           .asc "Gem-Stones"
           .byt 0
           .asc "Alien Items"
           .byt 0
		   .asc "Quirium found: refueling"
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
    .asc "Large"
    .byt 0
    .asc "Fierce"
    .byt 0
    .asc "Small"
    .byt 0
Type
    .asc "Green"
    .byt 0
    .asc "Red"
    .byt 0
    .asc "Yellow"
    .byt 0
    .asc "Blue"
    .byt 0
    .asc "Black"
    .byt 0
    .asc "Harmless"
    .byt 0
Bugeyed
    .asc "Slimy"
    .byt 0
    .asc "Bug-eyed"
    .byt 0
    .asc "Horned"
    .byt 0
    .asc "Bony"
    .byt 0
    .asc "Fat"
    .byt 0
    .asc "Furry"
    .byt 0

Race
    .asc "Rodent"
    .byt 0
    .asc "Frog"
    .byt 0
    .asc "Lizard"
    .byt 0
    .asc "Lobster"
    .byt 0
    .asc "Bird"
    .byt 0
    .asc "Humanoid"
    .byt 0
    .asc "Feline"
    .byt 0
    .asc "Insect"
    .byt 0

HumanCol
    .byt "Human Colonial"
    .byt 0



; For system information

govnames
            .asc "Anarchy"
            .byt 0
            .asc "Feudal"
            .byt 0
            .asc "Multi-government"
            .byt 0
            .asc "Dictatorship"
            .byt 0
            .asc "Communist"
            .byt 0
            .asc "Confederacy"
            .byt 0
            .asc "Democracy"
            .byt 0
            .asc "Corporate State"
            .byt 0

econnames
            .asc "Rich Industrial"
            .byt 0
            .asc "Average Industrial"
            .byt 0
            .asc "Poor Industrial"
            .byt 0
            .asc "Mainly Industrial"
            .byt 0
            .asc "Mainly Agricultural"
            .byt 0
            .asc "Rich Agricultural"
            .byt 0
            .asc "Average Agricultural"
            .byt 0
            .asc "Poor Agricultural"
            .byt 0


str_data    .asc "Data on"
            .byt 0
str_dist    .asc "Distance"
            .byt 0
str_eco     .asc "Economy"
            .byt 0
str_gov     .asc "Government"
            .byt 0
str_tech    .asc "Tech. Level"
            .byt 0
str_gross   .asc "Gross Productivity"
            .byt 0
str_rad     .asc "Average Radius"
            .byt 0
str_pop     .asc "Population"
            .byt 0
str_km      .asc " Km."
            .byt 0
str_bill    .asc " Billion"
            .byt 0
str_ly      .asc " Light Years"
            .byt 0
str_cr      .asc " M Cr."
            .byt 0

; These are for market
str_mkt     .asc "market prices"
            .byt 0
str_mktquant
            .asc "quantity"
            .byt 0    
str_mktlist 
            .asc "product"
            .byt 0
str_mktunit
            .asc "unit"
            .byt 0

str_mktin   .asc "in"
            .byt 0

str_mktprice
            .asc "price"
            .byt 0
str_mktsale
            .asc "for sale"
            .byt 0             
str_mktcargo 
            .asc "ship"
            .byt 0

; For market buying/selling

str_cash    .asc "Cash"
            .byt 0
str_freespace
            .asc "Space left"
            .byt 0
str_credits
            .asc "Cr."
            .byt 0

; Goat soup dictionary

desc_list
;81
    .asc "fabled"
    .byt 0
    .asc "notable"
    .byt 0
    .asc "well known"
    .byt 0
    .asc "famous"
    .byt 0
    .asc "noted"
    .byt 0
;82
    .asc "very"
    .byt 0
    .asc "mildly"
    .byt 0
    .asc "most"
    .byt 0
    .asc "reasonably"
    .byt 0
    .asc " "
    .byt 0

;83	
    .asc "ancient"
    .byt 0
    .byt $15,0
    .asc "great"
    .byt 0
    .asc "vast"
    .byt 0
    .asc "pink"
    .byt 0

;84
    .byt $1E," ", $1D," ",
    .asc "plantations"
    .byt 0
    .asc "mountains"
    .byt 0
    .byt $1C, 0
    .byt $14
    .asc " forests"
    .byt 0
    .asc "oceans"
    .byt 0
;85	
    .asc "shyness"
    .byt 0
    .asc "silliness"
    .byt 0
    .asc "mating traditions"
    .byt 0
    .asc "loathing of "
    .byt $06, 0
    .asc "love for "
    .byt $06,0
;86
    .asc "food blenders"
    .byt 0
    .asc "tourists"
    .byt 0
    .asc "poetry"
    .byt 0
    .asc  "discos"
    .byt 0
    .byt $0E
    .byt 0

;87
    .asc "talking tree"
    .byt 0
    .asc "crab"
    .byt 0
    .asc "bat"
    .byt 0
    .asc "lobst"
    .byt 0
    .byt $7D
    .byt 0

;88
    .asc "beset"
    .byt 0
    .asc "plagued"
    .byt 0
    .asc "ravaged"
    .byt 0
    .asc "cursed"
    .byt 0
    .asc "scourged"
    .byt 0

;89
    .byt $16
    .asc " civil war"
    .byt 0
    .byt $1B," ", $18," ", $19
    .asc "s"
    .byt 0
    .asc "a "
    .byt $1B
    .asc " disease"
    .byt 0
    .byt $16
    .asc " earthquakes"
    .byt 0
    .byt $16
    .asc " solar activity"
    .byt 0

;8A
    .asc "its "
    .byt $03," ", $04
    .byt 0
    .asc "the "
    .byt $7C," ", $18," ", $19
    .byt 0
    .asc "its inhabitants' "
    .byt $1A," ", $05
    .byt 0
    .byt $22, 0
    .asc "its "
    .byt $0D," ", $0E
    .byt 0

;8B
    .asc "juice"
    .byt 0
    .asc "brandy"
    .byt 0
    .asc "water"
    .byt 0
    .asc "brew"
    .byt 0
    .asc "gargle blasters"
    .byt 0

;8C
    .byt $7D,0
    .byt $7C," ", $19, 0
    .byt $7C," ", $7D, 0
    .byt $7C," ", $1B, 0
    .byt $1B," ", $7D, 0

;8D	
    .asc "fabulous"
    .byt 0
    .asc "exotic"
    .byt 0
    .asc "hoopy"
    .byt 0
    .asc "unusual"
    .byt 0
    .asc "exciting"
    .byt 0

;8E	
    .asc "cuisine"
    .byt 0
    .asc "night life"
    .byt 0
    .asc "casinos"
    .byt 0
    .asc "sit coms"
    .byt 0
    .byt " ", $22, " ", 0

;8F
    .asc $7b, 0
    .asc "The planet "
    .byt $7b, 0
    .asc "The world "
    .byt $7b, 0
    .asc "This planet"
    .byt 0
    .asc "This world"
    .byt 0

;90
    .asc "n unremarkable"
    .byt 0
    .asc " boring"
    .byt 0
    .asc " dull"
    .byt 0
    .asc " tedious"
    .byt 0
    .asc " revolting"
    .byt 0

;91
    .asc "planet"
    .byt 0
    .asc "world"
    .byt 0
    .asc "place"
    .byt 0
    .asc "little planet"
    .byt 0
    .asc "dump"
    .byt 0

;92
    .asc "wasp"
    .byt 0
    .asc "moth"
    .byt 0
    .asc "grub"
    .byt 0
    .asc "ant"
    .byt 0
    .byt $7D
    .byt 0

;93
    .asc "poet"
    .byt 0
    .asc "arts graduate"
    .byt 0
    .asc "yak"
    .byt 0
    .asc "snail"
    .byt 0
    .asc "slug"
    .byt 0

;94
    .asc "tropical"
    .byt 0
    .asc "dense"
    .byt 0
    .asc "rain"
    .byt 0
    .asc "impenetrable"
    .byt 0
    .asc "exuberant"
    .byt 0

;95
    .asc "funny"
    .byt 0
    .asc "wierd"
    .byt 0
    .asc "unusual"
    .byt 0
    .asc "strange"
    .byt 0
    .asc "peculiar"
    .byt 0

;96
    .asc "frequent"
    .byt 0
    .asc "occasional"
    .byt 0
    .asc "unpredictable"
    .byt 0
    .asc "dreadful"
    .byt 0
    .asc "deadly"
    .byt 0

;97
    .byt $02," ", $01
    .asc " for "
    .byt $0A,0
    .byt $02," ", $01
    .asc " for "
    .byt $0A
    .asc " and "
    .byt $0A
    .byt 0
    .byt $08
    .asc " by "
    .byt $09 ,0
    .byt $02," ", $01
    .asc " for "
    .byt $0A
    .asc " but "
    .byt $08
    .asc " by "
    .byt $09,0
    .asc "a"
    .byt $10," ", $11,0
;98
    .byt $1B
    .byt 0
    .asc "mountain"
    .byt 0
    .asc "edible"
    .byt 0
    .asc "tree"
    .byt 0
    .asc "spotted"
    .byt 0

;99
    .byt $1F
    .byt 0
    .byt $21
    .byt 0
    .byt $07
    .asc "oid"
    .byt 0
    .byt $13
    .byt 0
    .byt $12
    .byt 0

;9A
    .asc "ancient"
    .byt 0
    .asc "exceptional"
    .byt 0
    .asc "eccentric"
    .byt 0
    .asc "ingrained"
    .byt 0
    .byt $15
    .byt 0

;9B
    .asc "killer"
    .byt 0
    .asc "deadly"
    .byt 0
    .asc "evil"
    .byt 0
    .asc "lethal"
    .byt 0
    .asc "vicious"
    .byt 0

;9C
    .asc "parking meters"
    .byt 0
    .asc "dust clouds"
    .byt 0
    .asc "ice bergs"
    .byt 0
    .asc "rock formations"
    .byt 0
    .asc "volcanoes"
    .byt 0

;9D
    .asc "plant"
    .byt 0
    .asc "tulip"
    .byt 0
    .asc "banana"
    .byt 0
    .asc "corn"
    .byt 0
    .byt $7D
    .asc "weed"
    .byt 0

;9E
    .byt $7D
    .byt 0
    .byt $7C," ", $7D, 0
    .byt $7C," ", $1B, 0
    .asc "inhabitant"
    .byt 0
    .byt $7C, " ", $7D, 0

;9F
    .asc "shrew"
    .byt 0
    .asc "beast"
    .byt 0
    .asc "bison"
    .byt 0
    .asc "snake"
    .byt 0
    .asc "wolf"
    .byt 0

;A0
    .asc "leopard"
    .byt 0
    .asc "cat"
    .byt 0
    .asc "monkey"
    .byt 0
    .asc "goat"
    .byt 0
    .asc "fish"
    .byt 0

;A1
    .byt $0C, " ", $0B, 0
    .byt $7C, " ", $1F, " ", $23, 0
    .asc "its "
    .byt $0D, " ", $21, " ", $23, 0
    .byt $24, " ", $25, 0
    .byt $0C, " ", $0B, 0

;A2
    .asc "meat"
    .byt 0
    .asc "cutlet"
    .byt 0
    .asc "steak"
    .byt 0
    .asc "burgers"
    .byt 0
    .asc "soup"
    .byt 0

;A3
    .asc "ice"
    .byt 0
    .asc "mud"
    .byt 0
    .asc "Zero-G"
    .byt 0
    .asc "vacuum"
    .byt 0
    .byt $7C
    .asc " ultra"
    .byt 0

;A4
    .asc "hockey"
    .byt 0
    .asc "cricket"
    .byt 0
    .asc "karate"
    .byt 0
    .asc "polo"
    .byt 0
    .asc "tennis"
    .byt 0


; For charts
str_galactic_chart
    .asc "Galactic chart"
    .byt 0

str_short_chart
    .asc "Short range chart"
    .byt 0


; For searching planets

str_searchplanet
    .asc "Search planet:"
    .byt 0

str_notfound
    .asc "Not Found"
    .byt 0


; For main screen
str_commander
    .asc "Commander"
    .byt 0
str_present
	.byt A_FWCYAN
    .asc "Present"
    .byt 0
str_hyper
	.byt A_FWCYAN
    .asc "Hyperspace"
    .byt 0
str_system
	.byt A_FWCYAN
    .asc "System"
    .byt 0
;str_fuel 
;    .asc "Fuel"
;    .byt 0
str_status
	.byt A_FWCYAN
    .asc "Legal Status"
    .byt 0
str_rating
	.byt A_FWCYAN
    .asc "Rating"
    .byt 0
str_colon
    .asc ": "
	.byt A_FWWHITE
    .byt 0

; Legal status
str_clean
    .asc "Clean"
    .byt 0
str_offender
    .asc "Offender"
    .byt 0
str_fugitive
    .asc "Fugitive"
    .byt 0

; Rating
str_harmless
    .asc "Harmless"
    .byt 0
str_mostly
    .asc "Mostly Harmless"
    .byt 0
str_poor
    .asc "Poor"
    .byt 0
str_average
    .asc "Average"
    .byt 0
str_above
    .asc "Above Average"
    .byt 0
str_competent
    .asc "Competent"
    .byt 0
str_dangerous
    .asc "Dangerous"
    .byt 0
str_deadly
    .asc "Lethal"
    .byt 0
str_elite
    .asc "---- E L I T E ----"
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
   .byt <4000,<10000,<5250,<6000,<9000,<15000,<50000,<10000,<60000,<30000,<45000
priceseqHI
   .byt >2,>300,>2000
   .byt >4000,>10000,>5250,>6000,>9000,>15000,>50000,>10000,>60000,>30000,>45000


; Techlevel min

eq_tech
    .byt 0,0,3
    .byt 1,6,5,2,7,8,10,4,10,10,10

str_equipment
    .asc "equipment"
    .byt 0
str_fuel
str_equip
    .asc "Fuel"
    .byt 0
    .asc "Missile"
    .byt 0
str_equip2
    .asc "Pulse laser"
    .byt 0
    .asc "Large Cargo Bay"
    .byt 0
    .asc "Escape Pod"
    .byt 0
    .asc "Scoops"
    .byt 0
    .asc "E.C.M. System"
    .byt 0
    .asc "Energy Bomb"
    .byt 0
    .asc "Extra Energy Unit"
    .byt 0
    .asc "Galactic Hyperspace"
    .byt 0
    .asc "Beam Laser"
    .byt 0
    .asc "Military Laser"
    .byt 0
    .asc "Extra Speed Unit"
    .byt 0
    .asc "Extra Maneuverability Unit"
    .byt 0
	.asc "Fuel Optimizing Unit"
	.byt 0
	.asc "Quirium Processing Unit"
	.byt 0


str_selleq
    .asc "Equip Ship"
    .byt 0

str_item
    .asc "Item"
    .byt 0
str_missile
    .asc "Missile"
    .byt 0


str_nocash
	.byt (A_FWRED)
	.asc "No cash"
	.byt 0
str_nospace
	.byt (A_FWRED)
	.asc "No cargo space"
	.byt 0
str_equipped
	.byt (A_FWRED)
	.asc "Already fitted"
	.byt 0

str_blank 
	.asc "        "
	.byt 0
str_ship_names
	.asc "  Moon  "
	.byt 0
	.asc "Missile "
	.byt 0
	.asc " Debris "
	.byt 0
	.asc "  Pod   "
	.byt 0
	.asc " Alloys "
	.byt 0
	.asc " Cargo  "
	.byt 0
	.asc "Boulder "
	.byt 0
	.asc "Asteroid"
	.byt 0
	.asc "Splinter"
	.byt 0
	.asc "Shuttle "
	.byt 0
	.asc "Shuttle "
	.byt 0
	.asc " Viper  "
	.byt 0
	.asc "  Boa   "
	.byt 0
	.asc "Cobra-3 "
	.byt 0
	.asc " Python "
	.byt 0
	.asc "Anaconda"
	.byt 0
	.asc "  Worm  "
	.byt 0
	.asc "Cobra-1 "
	.byt 0
	.asc " Gecko  "
	.byt 0
	.asc " Krait  "
	.byt 0
	.asc " Mamba  "
	.byt 0
	.asc " Winder "
	.byt 0
	.asc " Adder  "
	.byt 0
	.asc " Moray  "
	.byt 0
	.asc " Lance  "
	.byt 0
	.asc "  Asp   "
	.byt 0
	.asc "Cobra-3 "
	.byt 0
	.asc " Python "
	.byt 0
	.asc "  Boa   "
	.byt 0
	.asc "Thargoid"
	.byt 0
	.asc "Thargon "
	.byt 0
	.asc "Unknown "
	.byt 0
	.asc " Cougar "
	.byt 0
	.asc "Asteroid"
	.byt 0


flight_message_base
	.asc "Incoming Missile"
	.byt 0
	.asc "Game Over"
	.byt 0
	.asc "Escape Pod Launched"
	.byt 0
;	.asc "Press Space Commander"
	.asc "Launch Tutorial (Y/N)?"
	.byt 0
	.asc "Target Locked"
	.byt 0
	.asc "Target Lost"
	.byt 0
	.asc "Missile Armed"
	.byt 0
	.asc "Missile Unarmed"
	.byt 0
	.asc "Mass Locked"
	.byt 0
	.asc "Path Locked"
	.byt 0
	.asc "Destination too far"
	.byt 0
	.asc "Energy Low"
	.byt 0
	.asc "Right on, Commander!"
	.byt 0
;	.asc "Load Saved Commander (Y/N)?"
;	.byt 0


;; For load/save
str_loadsavetitle
	.asc "LOAD/SAVE Game"
	.byt 0
str_loadsaveempty
	.asc "-- Empty Slot --"
	.byt 0
str_doloadsave
	.byt $0c
	.byt (A_FWRED)
	.asc "(S)ave, (L)oad or (Q)uit?"
	.byt 0
str_galslot
	.asc "Gal: "
	.byt 0
str_sysslot
	.asc "Sys: "
	.byt 0

str_namechange
	.asc "Enter Commander's name: "
	.byt 0

; Other informative messages
; Add 	.byt $0c for flashing
str_land
	;.byt (A_FWGREEN)
	.asc "Prepare  for  landing"
	.byt 0
str_launch
	.byt (A_FWGREEN)
	.asc "Prepare for launching"
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
	.asc "up/down: select, right/left: buy/sell"
	.byt 0
	.asc " "
	.byt 0
	.asc "SXNM: move , A: select, R: search"
	.byt 0
	.asc "SXNM: move , A: select destination"
	.byt 0
	.asc "up/down: select, A or ENTER to buy"
	.byt 0
	.asc "up/down then A or ENTER: select slot"
	.byt 0

;; For alarms when in text screens
str_alarm
 	.byt $0c
	.asc "alarm: under attack"
	.byt 0
	.byt $0c
	.asc "alarm: planet signal weak"
	.byt 0
	.byt $0c
	.asc "alarm: incoming missile"
	.byt 0

;; For losing equipment
str_destroyed
	.asc " destroyed"
	.byt 0

; Missions
str_missiondesctitle
	.byt (A_FWMAGENTA)
	.asc "Current mission:"
	.byt 0

str_missionspace
	.byt $0c
	.byt A_FWRED
	.asc "No room for mission cargo"
	.byt 0
str_missionspaced
	.asc "                           "
	.byt 0


; Transmission
str_inctrans
	.byt $0c
	.asc "--- INCOMING TRANSMISSION"
	.byt 0
str_endtrans
	.asc " --- MESSAGE ENDS."
str_moretrans
	.byt 13
	.byt 13
	.byt A_FWRED
	.asc "   (press SPACE)"
	.byt 0


; Mission pack messages
str_successpack
	.byt A_FWRED
	.asc "You have successfuly completed"
	.byt 13
	.byt A_FWRED
	.asc "this mission pack."
	.byt 13
	.byt 13
	.byt A_FWRED
	.asc "Congratulations!"
	.byt 13
	.byt A_FWRED
	.asc "   (press SPACE)"
	.byt 0

str_failpack
	.byt A_FWRED
	.asc "You have failed to complete"
	.byt 13
	.byt A_FWRED
	.asc "this mission pack."
	.byt 13
	.byt 13
	.byt A_FWRED
	.asc "Try again!"
	.byt 13
	.byt A_FWRED
	.asc "   (press SPACE)"
	.byt 0


__texts_end

#echo Size of texts in bytes:
#print (__texts_end - __texts_start)
#echo



