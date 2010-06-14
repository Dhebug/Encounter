

__overlay_start

#include "lib3dtab.s"
#include "..\models.s"
#include "..\music.s"
#include "..\dictc.s"
; Grammar for text decompressing
.dsb 256-(*&255)
#include "..\grammar.s"

__overlay_end

; Savegame data

; List of saved games (8 entries of 32 bytes)
; Record= 1 byte (0=empty, $ff=used)
;		  13 chars (Commander's name)
;		  9 bytes (System's name, 0 ended)
;		  1 byte (Current galaxy)
;		  2 bytes (score)
;		  1 byte (status)
;		  4 bytes (cash)
;		  1 byte empty
	
; Tutorial slot

#ifdef TUTORIAL SLOT
.byt $ff
.asc "Tutorial"
.byt 0,0,0,0,0
.asc "LAVE"
.byt 0, 0,0,0,0
.byt 1
.byt 0,0,0,0,0,0,0
.dsb 1
#endif


.dsb 32,00
.dsb 32,00


.byt $ff
.asc "ChemaEn"
.byt 0,0,0,0,0,0
;.asc "MAREGEIS"
;.asc "LAENIN"
.asc "BEVERI"
.byt 0
.byt 0,0
.byt 2
.byt 0,0,0,0,0,0,0
.dsb 1

.dsb 32,00
.dsb 32,00
.dsb 32,00
.dsb 32,00
.dsb 32,00


; Two sectors for 8 slots (400 bytes)

#ifdef TUTORIAL SLOT
; Tutorial slot

		.asc "Tutorial"          ; Commander's name
		.byt 00 
		.dsb 2 
		.dsb 17		            ; Contents of cargo bay
		.byt 7                 ; Current planet
		.byt 1                  ; Galaxy number (1-8)
		.byt $e8,$03            ; Four bytes for cash (200.0)
		.byt $00,$00
		.byt 70                 ; Amount of fuel
		.byt 0                  ; Price fluctuation
		.byt 35				    ; Current space left in cargo bay
		.byt 0                  ; Legal status 0=Clean, <50=Offender, >50=Fugitive
		.byt 00		 			; Score, remainder
		.word 00000             ; Current score
		.byt 13                 ; Current mission
		.word $0001             ; Equipment flags
		.byt 13			        ; Current player's ship
		.byt 3					; Number of missiles
; Stats for player's ship. Initially the basic for the ship, but may vary with equipment
		.byt 23					; Ship speed
		.byt 72		  		    ; Ship energy
		.byt 4					; Maximum number of missiles
		.byt 4					; Laser damage
#endif

.dsb 50
.dsb 50
; This is for test... should be deleted in the end
; 50 bytes
		.asc "ChemaEn"          ; Commander's name
		.byt 00 
		.dsb 3 
		.dsb 17		            ; Contents of cargo bay
		;.byt 64                 ; Current planet
		;.byt 101
		;.byt 60
		;.byt 181
		;.byt 31
		.byt $22
		.byt 4                  ; Galaxy number (1-8)
		.byt $d0,$07            ; Four bytes for cash (200.0)
		.byt $10,$00
		.byt 70                 ; Amount of fuel
		.byt 0                  ; Price fluctuation
		.byt 35				    ; Current space left in cargo bay
		.byt 0                  ; Legal status 0=Clean, <50=Offender, >50=Fugitive
		.byt 00		 			; Score, remainder
		.word 10000             ; Current score
		.byt 28+8+5+4+4             ; Current mission
		.word $0efe             ; Equipment flags
		.byt 13			        ; Current player's ship
		.byt 4					; Number of missiles
; Stats for player's ship. Initially the basic for the ship, but may vary with equipment
		.byt 28					; Ship speed
		.byt 190				; Ship energy
		.byt 4					; Maximum number of missiles
		.byt 10					; Laser damage
.dsb 256-150
.dsb 256

#echo ***** Used space in overlay:
#print (__overlay_end - __overlay_start)
#echo


; Missions
;.dsb 256-(*&255)
#include "..\missions.s"



