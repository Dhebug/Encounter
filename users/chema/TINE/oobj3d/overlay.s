

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
	
.dsb 32,00
.dsb 32,00
.byt $ff
.asc "ChemaEn"
.byt 0,0,0,0,0,0
.asc "ESRASOCE"
.byt 0
.byt 2
.byt 0,0,0,0,0,0,0
.dsb 1

.dsb 32,00
.dsb 32,00
.dsb 32,00
.dsb 32,00
.dsb 32,00


; Two sectors for 8 slots (400 bytes)

.dsb 100
; This is for test... should be deleted in the end
; 50 bytes
		.asc "ChemaEn"          ; Commander's name
		.byt 00 
		.dsb 3 
		.dsb 17		            ; Contents of cargo bay
		.byt 8                  ; Current planet
		.byt 2                  ; Galaxy number (1-8)
		.byt $d0,$07            ; Four bytes for cash (200.0)
		.byt $10,$00
		.byt 70                 ; Amount of fuel
		.byt 0                  ; Price fluctuation
		.byt 35				    ; Current space left in cargo bay
		.byt 60                 ; Legal status 0=Clean, <50=Offender, >50=Fugitive
		.byt 00					; Score, remainder
		.word 10000             ; Current score
		.byt 0                  ; Current mission
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






