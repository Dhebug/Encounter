;PlayerVariables.s

;All variables that may be restored when a game is saved (Sleeping at Inn)

;Isolate location of Hero
MapID		.byt 1
ScreenID	.byt 0

;Heroes status
HeroHealth
HeroMana
HeroGrotes


;Heroes Posessions
SelectedPocket	.byt 0
Backpack_Pockets
 .dsb 10,128
