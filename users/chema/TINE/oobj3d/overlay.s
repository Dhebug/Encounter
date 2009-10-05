

; Start at $c000 - 512 *2, so soundovl gets labels and pointers correctly set up
;*=$bc00 

; Sector where game is saved
Savegame
;.dsb  256*2,$ff

; Sector used to keep a copy of game status 
; in case there is not valid savepoint
Savegame2
;.dsb 256*2,$ff

; Grammar for text decompressing
;#include"..\grammar.s"

; World data
;#include "world.s"

;.dsb 256-(*&255)

; Include sound and sfx routines and data
;#include "..\sound.s"



#include "lib3dtab.s"
#include "..\models.s"







