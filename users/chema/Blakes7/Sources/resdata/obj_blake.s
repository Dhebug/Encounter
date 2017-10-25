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

; Object resource 0: Roj Blake
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt BLAKE
res_start
	.byt OBJ_FLAG_ACTOR	; If OBJ_FLAG_PROP skip all costume data
	.byt 5,7		; Size (cols rows)
	.byt INITIAL_ROOM	; Room
	.byt 13,14		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt $ff,$ff		; Walk position (col, row)
	.byt FACING_LEFT	; Facing direction for interaction
	.byt 3			; Color of text

	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt 0			; costume ($ff for none) and skip the rest
	.byt 0			; entry in costume resource		
	.byt LOOK_FRONT		; direction (0 or LOOK_RIGHT for animstate 0)
	.byt 1			; animation speed	
	.asc "Roj Blake",0
res_end	
.)

; Object resource 2: Guard
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt GUARD
res_start
	.byt OBJ_FLAG_ACTOR	; If OBJ_FLAG_PROP skip all costume data
	.byt 5,7		; Size (cols rows)
	.byt ROOM_HALLWAY	; Room
	.byt 111,12		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt $ff,$ff		; Walk position (col, row)
	.byt $ff		; Facing direction for interaction
	.byt 7			; Color of text

	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt 3			; costume ($ff for none) and skip the rest
	.byt 0			; entry in costume resource		
	.byt LOOK_RIGHT		; direction (0 or LOOK_RIGHT for animstate 0)
	.byt 1			; animation speed	
#ifdef ENGLISH
	.asc "Guard",0
#endif
#ifdef SPANISH
	.asc "Guardia",0
#endif
res_end	
.)


; Object resource 3: Sandwich
.(
	.byt RESOURCE_OBJECT
	.word (res_end-res_start+4)
	.byt SANDWICH
res_start
	.byt 0
	.byt 3,2	;Size (cols, rows)
	.byt ROOM_BROOM	;Initial room
	.byt 1,12	;Location (col, row)
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

	.asc "Sandwich",0	;Object's name
res_end
.)

; Object resource 4: Mug
.(
	.byt RESOURCE_OBJECT
	.word (res_end-res_start+4)
	.byt MUG
res_start
	.byt 0
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
	.asc "Mug",0
#endif
#ifdef SPANISH
	.asc "Taza",0
#endif	
res_end
.)

; Object resource 5: Laxative
.(
	.byt RESOURCE_OBJECT
	.word (res_end-res_start+4)
	.byt LAXATIVE
res_start
	.byt OBJ_FLAG_USEDWITHOTHER
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
	.asc "Laxative",0
#endif
#ifdef SPANISH
	.asc "Laxante",0
#endif	
res_end
.)


; Object resource 6: Coin
.(
	.byt RESOURCE_OBJECT
	.word (res_end-res_start+4)
	.byt COIN
res_start
	.byt OBJ_FLAG_USEDWITHOTHER
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
	.asc "Coin",0
#endif
#ifdef SPANISH
	.asc "Moneda",0
#endif
res_end
.)

; Object resource 7: Decaf
.(
	.byt RESOURCE_OBJECT
	.word (res_end-res_start+4)
	.byt DECAF
res_start
	.byt OBJ_FLAG_USEDWITHOTHER
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
	.asc "Decaf",0
#endif
#ifdef SPANISH
	.asc "Descafeinado",0
#endif
res_end
.)

; Object resource 8: KEY (locker)
.(
	.byt RESOURCE_OBJECT
	.word (res_end-res_start+4)
	.byt KEY
res_start
	.byt OBJ_FLAG_USEDWITHOTHER
	.byt 3,2	;Size (cols, rows)
	.byt ROOM_LOCKER;Initial room
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
	.asc "Key",0
#endif
#ifdef SPANISH
	.asc "Llave",0
#endif
res_end
.)





; Object resource 9: MAP
.(
	.byt RESOURCE_OBJECT
	.word (res_end-res_start+4)
	.byt MAP
res_start
	.byt 0
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
	.asc "Map",0
#endif
#ifdef SPANISH
	.asc "Mapa",0
#endif
res_end
.)


; Object resource: Camera technician
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt TECHCAM
res_start
	.byt OBJ_FLAG_ACTOR	; If OBJ_FLAG_PROP skip all costume data
	.byt 5,7		; Size (cols rows)
	.byt ROOM_CAMCONTROL	; Room
	.byt 23,15		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt $ff,$ff		; Walk position (col, row)
	.byt FACING_RIGHT	; Facing direction for interaction
	.byt 6			; Color of text

	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt 4			; costume ($ff for none) and skip the rest
	.byt 0			; entry in costume resource		
	.byt LOOK_RIGHT		; direction (0 or LOOK_RIGHT for animstate 0)
	.byt 1			; animation speed	
#ifdef ENGLISH
	.asc "Technician",0
#endif
#ifdef SPANISH
	.asc "T","Z"+2,"cnico",0
#endif
res_end	
.)

; Object resource 11: Staff at the information desk
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt INFOMAN 
res_start
	.byt 0			; If OBJ_FLAG_PROP skip all costume data
	.byt 5,7		; Size (col, row)
	.byt 6			; Room ($ff = current)
	.byt 6,10		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt 11,14		; Walk position (col, row)
	.byt FACING_LEFT	; Facing direction for interaction
	.byt 6			; Color of text

	; tiles and pointers to animatory states are setup in the costume
	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt 5			; costume ($ff for none) and skip the rest
	.byt 0			; entry in costume resource		
	.byt LOOK_RIGHT		; direction (0 or LOOK_RIGHT for animstate 0)
	.byt 1			; animation speed	
#ifdef ENGLISH
	.asc "Staff member",0
#endif
#ifdef SPANISH
	.asc "Empleado",0
#endif	
res_end	
.)


; Object resource 15: Second Guard
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt GUARD2
res_start
	.byt OBJ_FLAG_ACTOR	; If OBJ_FLAG_PROP skip all costume data
	.byt 5,7		; Size (cols rows)
	.byt $ff		; Room
	.byt 111,12		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt $ff,$ff		; Walk position (col, row)
	.byt $ff		; Facing direction for interaction
	.byt 7			; Color of text

	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt 3			; costume ($ff for none) and skip the rest
	.byt 0			; entry in costume resource		
	.byt LOOK_RIGHT		; direction (0 or LOOK_RIGHT for animstate 0)
	.byt 1			; animation speed	
#ifdef ENGLISH
	.asc "Guard",0
#endif
#ifdef SPANISH
	.asc "Guardia",0
#endif
res_end	
.)

; Object resource 25: Servalan
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt SERVALAN
res_start
	.byt OBJ_FLAG_ACTOR	; If OBJ_FLAG_PROP skip all costume data
	.byt 5,7		; Size (cols rows)
	.byt $ff		; Room
	.byt $ff,$16		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt $ff,$ff		; Walk position (col, row)
	.byt $ff		; Facing direction for interaction
	.byt 5			; Color of text

	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt 8			; costume ($ff for none) and skip the rest
	.byt 0			; entry in costume resource		
	.byt LOOK_RIGHT		; direction (0 or LOOK_RIGHT for animstate 0)
	.byt 1			; animation speed	
	.asc "Servalan",0
res_end	
.)

; Object resource 26: TRAVIS
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt TRAVIS
res_start
	.byt OBJ_FLAG_ACTOR	;|OBJ_FLAG_FROMDISTANCE	; If OBJ_FLAG_PROP skip all costume data
	.byt 5,7		; Size (cols rows)
	.byt $ff		; Room
	.byt $ff,$16		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt $ff,$ff		; Walk position (col, row)
	.byt $ff		; Facing direction for interaction
	.byt A_FWWHITE+A_FWGREEN*8+$c0			; Color of text

	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt 7			; costume ($ff for none) and skip the rest
	.byt 0			; entry in costume resource		
	.byt LOOK_RIGHT		; direction (0 or LOOK_RIGHT for animstate 0)
	.byt 1			; animation speed	
	.asc "Travis",0
res_end	
.)

