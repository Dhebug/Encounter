;;;;;;;;;;;;;;;;;;;;;;;;;;;
; OASIS resource data file
;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Common header
#include "..\params.h"
#include "..\object.h"
#include "..\script.h"
#include "..\resource.h"
#include "..\verbs.h"


#include "..\gameids.h"
#include "..\language.h"

*=$500


; Object resource 20: Jenna Stannis
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt JENNA
res_start
	.byt OBJ_FLAG_ACTOR	; If OBJ_FLAG_PROP skip all costume data
	.byt 5,7		; Size (cols rows)
	.byt $ff		; Room
	.byt 12,16		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt $ff,$ff		; Walk position (col, row)
	.byt $ff		; Facing direction for interaction
	.byt A_FWWHITE+A_FWCYAN*8+$c0	; Color of text

	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt 1			; costume ($ff for none) and skip the rest
	.byt 0			; entry in costume resource		
	.byt 0		; direction (0 or LOOK_RIGHT for animstate 0)
	.byt 1			; animation speed	
	.asc "Jenna Stannis",0
res_end	
.)

; Object resource 21: Vila Restal
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt VILA
res_start
	.byt OBJ_FLAG_ACTOR	; If OBJ_FLAG_PROP skip all costume data
	.byt 5,7		; Size (cols rows)
	.byt $ff		; Room
	.byt 5,14		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt $ff,$ff		; Walk position (col, row)
	.byt $ff		; Facing direction for interaction
	.byt A_FWGREEN+A_FWCYAN*8+$c0			; Color of text

	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt 10			; costume ($ff for none) and skip the rest
	.byt 0			; entry in costume resource		
	.byt 0		; direction (0 or LOOK_RIGHT for animstate 0)
	.byt 1			; animation speed	
	.asc "Vila Restal",0
res_end	
.)

; Object resource 22: Kerr Avon
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt AVON
res_start
	.byt OBJ_FLAG_ACTOR	; If OBJ_FLAG_PROP skip all costume data
	.byt 5,7		; Size (cols rows)
	.byt $ff		; Room
	.byt 41-2,16		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt $ff,$ff		; Walk position (col, row)
	.byt $ff		; Facing direction for interaction
	.byt A_FWYELLOW+A_FWGREEN*8+$c0			; Color of text

	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt 11			; costume ($ff for none) and skip the rest
	.byt 0			; entry in costume resource		
	.byt 0		; direction (0 or LOOK_RIGHT for animstate 0)
	.byt 1			; animation speed	
	.asc "Kerr Avon",0
res_end	
.)

; Object resource 23: Olag Gan
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt GAN
res_start
	.byt OBJ_FLAG_ACTOR	; If OBJ_FLAG_PROP skip all costume data
	.byt 5,7		; Size (cols rows)
	.byt $ff		; Room
	.byt 33-2,13		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt $ff,$ff		; Walk position (col, row)
	.byt $ff		; Facing direction for interaction
	.byt A_FWGREEN			; Color of text

	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt 12			; costume ($ff for none) and skip the rest
	.byt 0			; entry in costume resource		
	.byt 0		; direction (0 or LOOK_RIGHT for animstate 0)
	.byt 1			; animation speed	
	.asc "Olag Gan",0
res_end	
.)




; Object resource 37: Defensive ball robot
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt BALLROBOT
res_start
	.byt OBJ_FLAG_ACTOR	; If OBJ_FLAG_PROP skip all costume data
	.byt 5,4		; Size (cols rows)
	.byt $ff		; Room
	.byt 30-1,13		; Pos (col, row)
	.byt ZPLANE_3		; Zplane
	.byt 12,14		; Walk position (col, row)
	.byt LOOK_RIGHT		; Facing direction for interaction
	.byt A_FWGREEN			; Color of text

	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt 15			; costume ($ff for none) and skip the rest
	.byt 0			; entry in costume resource		
	.byt 0			; direction (0 or LOOK_RIGHT for animstate 0)
	.byt 0			; animation speed	
#ifdef ENGLISH	
	.asc "Ball Robot",0
#endif
#ifdef SPANISH
	.asc "Robot-bola",0
#endif	
#ifdef FRENCH
	.asc "Robot boule",0
#endif	
res_end	
.)


; Object resource 31: Y-pipe
.(
	.byt RESOURCE_OBJECT
	.word (res_end-res_start+4)
	.byt YPIPE
res_start
	.byt OBJ_FLAG_USEDWITHOTHER
	; All this data is ignored, as it is put in inventory
	.byt 3,2	;Size (cols, rows)
	.byt ROOM_BROOM	;Initial room
	.byt 0,14	;Location (col, row)
	.byt ZPLANE_1	;Zplane
	.byt 8,14	;Walk position (col, row)
	.byt FACING_RIGHT
	.byt 0	; Color of text

	; tiles and pointers to animatory states are setup in the costume
	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt $ff		; costume ($ff for none) and skip the rest
	.byt 0			; entry in costume resource		
	.byt 0			; direction (0 or LOOK_RIGHT for animstate 0)
	.byt 0			; animation speed	
#ifdef ENGLISH	
	.asc "Y-pipe",0		;Object's name
#endif
#ifdef SPANISH
	.asc "Tubo en Y",0
#endif	
#ifdef FRENCH
	.asc "Tuyau en Y",0
#endif	
	
res_end
.)

; Object resource 32: steel ball
.(
	.byt RESOURCE_OBJECT
	.word (res_end-res_start+4)
	.byt BEARING
res_start
	.byt OBJ_FLAG_USEDWITHOTHER
	; All this data is ignored, as it is put in inventory
	.byt 3,2	;Size (cols, rows)
	.byt ROOM_BROOM	;Initial room
	.byt 0,14	;Location (col, row)
	.byt ZPLANE_1	;Zplane
	.byt 8,14	;Walk position (col, row)
	.byt FACING_LEFT
	.byt 0	; Color of text

	; tiles and pointers to animatory states are setup in the costume
	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt $ff		; costume ($ff for none) and skip the rest
	.byt 0			; entry in costume resource		
	.byt 0			; direction (0 or LOOK_RIGHT for animstate 0)
	.byt 0			; animation speed	
#ifdef ENGLISH	
	.asc "Steel ball",0	;Object's name
#endif
#ifdef SPANISH
	.asc "Bola de acero",0
#endif		
#ifdef FRENCH
	.asc "Bille",0 ; "Bille en acier" est trop long: peut causer bug affichage si utilisé avec "Clé anglaise" 

#endif		
res_end
.)


; Object resource 33: Cinch
.(
	.byt RESOURCE_OBJECT
	.word (res_end-res_start+4)
	.byt CINCH
res_start
	.byt OBJ_FLAG_USEDWITHOTHER
	; All this data is ignored, as it is put in inventory
	.byt 3,2	;Size (cols, rows)
	.byt ROOM_BROOM	;Initial room
	.byt 0,14	;Location (col, row)
	.byt ZPLANE_1	;Zplane
	.byt 8,14	;Walk position (col, row)
	.byt FACING_LEFT
	.byt 0	; Color of text

	; tiles and pointers to animatory states are setup in the costume
	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt $ff		; costume ($ff for none) and skip the rest
	.byt 0			; entry in costume resource		
	.byt 0			; direction (0 or LOOK_RIGHT for animstate 0)
	.byt 0			; animation speed	
#ifdef ENGLISH	
	.asc "Piece of strap",0	;Object's name
#endif
#ifdef SPANISH
	.asc "Tira de goma",0
#endif		
#ifdef FRENCH
	; -- see ../scripts/liberatorcargo.os
	;.asc "Sangle ","Z"+2,"lastique",0	; [laurentd75] "Sangle élastique" is 16 chars, and when used with "tuyau en y" it garbles the display
	                                    ; ("Utiliser Sangle élastique avec tuyau en Y" is 42 chars long... :-( )
	.asc "Sangle ",0	                ; ==> Use just "Sangle" instead...
#endif		
res_end
.)

; Object resource 34: catpult
.(
	.byt RESOURCE_OBJECT
	.word (res_end-res_start+4)
	.byt CATPULT
res_start
	.byt OBJ_FLAG_USEDWITHOTHER
	; All this data is ignored, as it is put in inventory
	.byt 3,2	;Size (cols, rows)
	.byt ROOM_BROOM	;Initial room
	.byt 0,14	;Location (col, row)
	.byt ZPLANE_1	;Zplane
	.byt 8,14	;Walk position (col, row)
	.byt FACING_LEFT
	.byt 0	; Color of text

	; tiles and pointers to animatory states are setup in the costume
	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt $ff		; costume ($ff for none) and skip the rest
	.byt 0			; entry in costume resource		
	.byt 0			; direction (0 or LOOK_RIGHT for animstate 0)
	.byt 0			; animation speed	
#ifdef ENGLISH	
	.asc "Catapult",0	;Object's name
#endif
#ifdef SPANISH
	.asc "Tirachinas",0
#endif		
#ifdef FRENCH
	.asc "Fronde",0
#endif		

res_end
.)

; Object resource 35: BRACELET
.(
	.byt RESOURCE_OBJECT
	.word (res_end-res_start+4)
	.byt BRACELET
res_start
	.byt 0
	.byt $ff,$ff	;Size (cols, rows)
	.byt $ff	;Initial room
	.byt $ff,$ff	;Location (col, row)
	.byt ZPLANE_1	;Zplane
	.byt $ff,$ff	;Walk position (col, row)
	.byt $ff
	.byt 0	; Color of text

	; tiles and pointers to animatory states are setup in the costume
	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt $ff		; costume ($ff for none) and skip the rest
	.byt 0			; entry in costume resource		
	.byt 0			; direction (0 or LOOK_RIGHT for animstate 0)
	.byt 0			; animation speed	
#ifdef ENGLISH	
	.asc "Bracelet",0	;Object's name
#endif
#ifdef SPANISH
	.asc "Pulsera",0
#endif		
#ifdef FRENCH
	.asc "Bracelet",0
#endif
res_end
.)


; Object resource 36: GUN
.(
	.byt RESOURCE_OBJECT
	.word (res_end-res_start+4)
	.byt GUN
res_start
	.byt OBJ_FLAG_USEDWITHOTHER
	.byt $ff,$ff	;Size (cols, rows)
	.byt $ff	;Initial room
	.byt $ff,$ff	;Location (col, row)
	.byt ZPLANE_1	;Zplane
	.byt $ff,$ff	;Walk position (col, row)
	.byt $ff
	.byt 0	; Color of text

	; tiles and pointers to animatory states are setup in the costume
	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt $ff		; costume ($ff for none) and skip the rest
	.byt 0			; entry in costume resource		
	.byt 0			; direction (0 or LOOK_RIGHT for animstate 0)
	.byt 0			; animation speed	
#ifdef ENGLISH	
	.asc "Alien gun",0	;Object's name
#endif
#ifdef SPANISH
	.asc "Arma alien",0
#endif		
#ifdef FRENCH
	;.asc "Arme d'E.T.",0	; "arme d'extra-terrestre"
	.asc "Arme",0 ; [laurentd75]: shortened "Arme d'E.T." to "Arme" to avoid potential graphical bugs when used with "Jenna Stannis"
#endif
res_end
.)



; Object resource 38: scissors
.(
	.byt RESOURCE_OBJECT
	.word (res_end-res_start+4)
	.byt SCISSORS
res_start
	.byt OBJ_FLAG_USEDWITHOTHER
	.byt 2,2	;Size (cols, rows)
	.byt ROOM_LIBWORKSHOP	;Initial room
	.byt 9,7	;Location (col, row)
	.byt ZPLANE_1	;Zplane
	.byt 9,13	;Walk position (col, row)
	.byt FACING_UP
	.byt 0	; Color of text

	; tiles and pointers to animatory states are setup in the costume
	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt 200		; costume ($ff for none) and skip the rest
	.byt 0			; entry in costume resource		
	.byt 0			; direction (0 or LOOK_RIGHT for animstate 0)
	.byt 0			; animation speed	
#ifdef ENGLISH	
	.asc "Scissors",0	; Object's name
#endif
#ifdef SPANISH
	.asc "Tijeras",0
#endif			
#ifdef FRENCH
	.asc "Ciseaux",0
#endif			
res_end
.)

; Object resource 39: pliers
.(
	.byt RESOURCE_OBJECT
	.word (res_end-res_start+4)
	.byt PLIERS
res_start
	.byt OBJ_FLAG_USEDWITHOTHER
	.byt 2,2	;Size (cols, rows)
	.byt ROOM_LIBWORKSHOP	;Initial room
	.byt 11,7	;Location (col, row)
	.byt ZPLANE_1	;Zplane
	.byt 11,13	;Walk position (col, row)
	.byt FACING_UP
	.byt 0	; Color of text

	; tiles and pointers to animatory states are setup in the costume
	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt 200		; costume ($ff for none) and skip the rest
	.byt 0			; entry in costume resource		
	.byt 0			; direction (0 or LOOK_RIGHT for animstate 0)
	.byt 0			; animation speed	
#ifdef ENGLISH	
	.asc "Pliers",0	;Object's name
#endif
#ifdef SPANISH
	.asc "Tenazas",0
#endif			
#ifdef FRENCH
	.asc "Pinces",0
#endif			
res_end
.)

; Object resource 40: WRENCH
.(
	.byt RESOURCE_OBJECT
	.word (res_end-res_start+4)
	.byt WRENCH
res_start
	.byt OBJ_FLAG_USEDWITHOTHER
	.byt 2,2	;Size (cols, rows)
	.byt ROOM_LIBWORKSHOP	;Initial room
	.byt 13,7	;Location (col, row)
	.byt ZPLANE_1	;Zplane
	.byt 13,13	;Walk position (col, row)
	.byt FACING_UP
	.byt 0	; Color of text

	; tiles and pointers to animatory states are setup in the costume
	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt 200		; costume ($ff for none) and skip the rest
	.byt 0			; entry in costume resource		
	.byt 0			; direction (0 or LOOK_RIGHT for animstate 0)
	.byt 0			; animation speed	
#ifdef ENGLISH	
	.asc "Wrench",0	;Object's name
#endif
#ifdef SPANISH
	.asc "Llave inglesa",0
#endif				
#ifdef FRENCH
	; [laurentd75]: ATTENTION: "Utilise Clé anglaise avec Jenna Stannis" fait bugger l'affichage (trop long...)
	; Malheureusement, il n'existe aucun synonyme plus court ("clé à molette" est plus long..)
	; => on laisse comme ça, l'effet du bug potentiel se limitant à une perturbation mineure de l'affichage
	.asc "Cl","Z"+2," anglaise",0	; "Clé anglaise" 
#endif				
res_end
.)


; Object resource 41: SPRAY
.(
	.byt RESOURCE_OBJECT
	.word (res_end-res_start+4)
	.byt SPRAY
res_start
	.byt OBJ_FLAG_USEDWITHOTHER
	.byt 2,2	;Size (cols, rows)
	.byt ROOM_LIBWORKSHOP	;Initial room
	.byt 24,8	;Location (col, row)
	.byt ZPLANE_1	;Zplane
	.byt 24,13	;Walk position (col, row)
	.byt FACING_UP
	.byt 0	; Color of text

	; tiles and pointers to animatory states are setup in the costume
	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt 200		; costume ($ff for none) and skip the rest
	.byt 0			; entry in costume resource		
	.byt 0			; direction (0 or LOOK_RIGHT for animstate 0)
	.byt 0			; animation speed	
#ifdef ENGLISH		
	.asc "Spray can",0	;Object's name
#endif
#ifdef SPANISH
	.asc "Aerosol",0
#endif				
#ifdef FRENCH
	.asc "A","Z"+2,"rosol",0	; "Aérosol"
#endif				
res_end
.)


; Object resource 42: BRACELETS
.(
	.byt RESOURCE_OBJECT
	.word (res_end-res_start+4)
	.byt BRACELETS
res_start
	.byt 0
	.byt $ff,$ff	;Size (cols, rows)
	.byt $ff	;Initial room
	.byt $ff,$ff	;Location (col, row)
	.byt ZPLANE_1	;Zplane
	.byt $ff,$ff	;Walk position (col, row)
	.byt $ff
	.byt 0	; Color of text

	; tiles and pointers to animatory states are setup in the costume
	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt $ff		; costume ($ff for none) and skip the rest
	.byt 0			; entry in costume resource		
	.byt 0			; direction (0 or LOOK_RIGHT for animstate 0)
	.byt 0			; animation speed	
#ifdef ENGLISH		
	.asc "Bracelets",0	;Object's name
#endif
#ifdef SPANISH
	.asc "Pulseras",0
#endif					
#ifdef FRENCH
	.asc "Bracelets",0
#endif
res_end
.)

; Object resource 43: ROPE
.(
	.byt RESOURCE_OBJECT
	.word (res_end-res_start+4)
	.byt ROPE
res_start
	.byt OBJ_FLAG_USEDWITHOTHER
	.byt $ff,$ff	;Size (cols, rows)
	.byt $ff	;Initial room
	.byt $ff,$ff	;Location (col, row)
	.byt ZPLANE_1	;Zplane
	.byt $ff,$ff	;Walk position (col, row)
	.byt $ff
	.byt 0	; Color of text

	; tiles and pointers to animatory states are setup in the costume
	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt $ff		; costume ($ff for none) and skip the rest
	.byt 0			; entry in costume resource		
	.byt 0			; direction (0 or LOOK_RIGHT for animstate 0)
	.byt 0			; animation speed	
#ifdef ENGLISH		
	.asc "Rope",0	;Object's name
#endif
#ifdef SPANISH
	.asc "Cuerda",0
#endif						
#ifdef FRENCH
	.asc "Corde",0
#endif						
res_end
.)


; Object 44: Lamp
.(
	.byt RESOURCE_OBJECT|$80
	.word (res_end - res_start +4)
	.byt 44
res_start
	.byt 0			; If OBJ_FLAG_PROP skip all costume data
	.byt 3,3		; Size (cols rows)
	.byt $ff		; Room
	.byt 42,11		; Pos (col, row)
	.byt ZPLANE_0		; Zplane
	.byt 41,15		; Walk position (col, row)
	.byt FACING_UP		; Facing direction for interaction
	.byt 0			; Color of text

	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt 202		; costume ($ff for none) and skip the rest
	.byt 0			; entry in costume resource		
	.byt 0			; direction (0 or LOOK_RIGHT for animstate 0)
	.byt 0			; animation speed	
#ifdef ENGLISH		
	.asc "Lamp",0
#endif
#ifdef SPANISH
	.asc "L","Z"+1,"mpara",0
#endif						
#ifdef FRENCH
	.asc "Lampe",0
#endif
res_end	
.)



; Object resource 45: Vargas
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt VARGAS
res_start
	.byt OBJ_FLAG_ACTOR	; If OBJ_FLAG_PROP skip all costume data
	.byt 5,7		; Size (cols rows)
	.byt $ff		; Room
	.byt 12,16		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt $ff,$ff		; Walk position (col, row)
	.byt $ff		; Facing direction for interaction
	.byt A_FWWHITE+A_FWGREEN*8+$c0	; Color of text

	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt 17			; costume ($ff for none) and skip the rest
	.byt 0			; entry in costume resource		
	.byt 0		; direction (0 or LOOK_RIGHT for animstate 0)
	.byt 1			; animation speed	
	.asc "Vargas",0
res_end	
.)

; Object resource 46: Monk1
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt MONK1
res_start
	.byt OBJ_FLAG_ACTOR	; If OBJ_FLAG_PROP skip all costume data
	.byt 5,7		; Size (cols rows)
	.byt $ff		; Room
	.byt 12,16		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt $ff,$ff		; Walk position (col, row)
	.byt $ff		; Facing direction for interaction
	.byt A_FWGREEN		; Color of text

	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt 16			; costume ($ff for none) and skip the rest
	.byt 0			; entry in costume resource		
	.byt 0		; direction (0 or LOOK_RIGHT for animstate 0)
	.byt 1			; animation speed	
#ifdef ENGLISH		
	.asc "Monk",0
#endif
#ifdef SPANISH
	.asc "Monje",0
#endif						
#ifdef FRENCH
	.asc "Moine",0
#endif						
res_end	
.)

; Object resource 47: Monk2
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt MONK2
res_start
	.byt OBJ_FLAG_ACTOR	; If OBJ_FLAG_PROP skip all costume data
	.byt 5,7		; Size (cols rows)
	.byt $ff		; Room
	.byt 12,16		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt $ff,$ff		; Walk position (col, row)
	.byt $ff		; Facing direction for interaction
	.byt A_FWCYAN		; Color of text

	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt 16		; costume ($ff for none) and skip the rest
	.byt 0			; entry in costume resource		
	.byt 0		; direction (0 or LOOK_RIGHT for animstate 0)
	.byt 1			; animation speed	
#ifdef ENGLISH		
	.asc "Monk",0
#endif
#ifdef SPANISH
	.asc "Monje",0
#endif						
#ifdef FRENCH
	.asc "Moine",0
#endif						
res_end	
.)

; Object resource 52: energy cell
.(
	.byt RESOURCE_OBJECT
	.word (res_end-res_start+4)
	.byt ECELL
res_start
	.byt OBJ_FLAG_USEDWITHOTHER
	.byt 5,2	;Size (cols, rows)
	.byt ROOM_LIBCARGO	;Initial room
	.byt 9,7	;Location (col, row)
	.byt ZPLANE_1	;Zplane
	.byt 9,13	;Walk position (col, row)
	.byt FACING_UP
	.byt 0	; Color of text

	; tiles and pointers to animatory states are setup in the costume
	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt 200		; costume ($ff for none) and skip the rest
	.byt 0			; entry in costume resource		
	.byt 0			; direction (0 or LOOK_RIGHT for animstate 0)
	.byt 0			; animation speed	
#ifdef ENGLISH	
	.asc "Energy cell",0	;Object's name
#endif
#ifdef SPANISH
	.asc "C","Z"+2,"lula energ","Z"+3,"a",0
#endif			
#ifdef FRENCH
	; "Pile à combustible" ou "Cellule d'énergie" -- cf. room_hideout.s et liberatorcargo.os et ocode_ecell.os dans ../scripts
	.asc "Pile",0  ; "Pile" ou "Cellule" - préciser "d'énergie" est trop long: peut causer bug affichage si utilisé avec "Tuyau en Y" ou "Clé anglaise" 
#endif
res_end
.)


; Drone
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 28
res_start
	.byt OBJ_FLAG_USEDWITHOTHER	; If OBJ_FLAG_PROP skip all costume data
	.byt 3,2		; Size (col, row)
	.byt ROOM_LIBCARGO	; Room ($ff = current)
	.byt 29,16		; Pos (col, row)
	.byt ZPLANE_3		; Zplane
	.byt 29,16		; Walk position (col, row)
	.byt FACING_DOWN	; Facing direction for interaction
	.byt 00			; Color of text
	; tiles and pointers to animatory states are setup in the costume
	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt 200		; costume ($ff for none) and skip the rest
	.byt 0			; entry in costume resource		
	.byt 0			; direction (0 or LOOK_RIGHT for animstate 0)
	.byt 0			; animation speed	
#ifdef ENGLISH
	.asc "Drone",0
#endif
#ifdef SPANISH
	.asc "Dron",0
#endif
#ifdef FRENCH
	.asc "Drone",0
#endif
res_end	
.)
