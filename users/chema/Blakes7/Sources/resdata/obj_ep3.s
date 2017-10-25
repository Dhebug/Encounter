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

; Object resource 48: Wooden Log
.(
	.byt RESOURCE_OBJECT
	.word (res_end-res_start+4)
	.byt WOODENLOG
res_start
	.byt OBJ_FLAG_USEDWITHOTHER
	; All this data is ignored, as it is put in inventory
	.byt 5,2	;Size (cols, rows)
	.byt $0		;Initial room
	.byt 0,0	;Location (col, row)
	.byt ZPLANE_0	;Zplane
	.byt $5,$11	;Walk position (col, row)
	.byt $ff
	.byt 0	; Color of text

	; tiles and pointers to animatory states are setup in the costume
	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed
	
	; Use a local costume, as it is only drawn in a specific room
	.byt 200		; costume ($ff for none) and skip the rest
	.byt 0			; entry in costume resource		
	.byt 0			; direction (0 or LOOK_RIGHT for animstate 0)
	.byt 0			; animation speed	
#ifdef ENGLISH	
	.asc "Wooden log",0		;Object's name
#endif
#ifdef SPANISH
	.asc "Tronco",0
#endif	
	
res_end
.)

; Object resource 49: Cup
.(
	.byt RESOURCE_OBJECT
	.word (res_end-res_start+4)
	.byt CUP
res_start
	.byt OBJ_FLAG_USEDWITHOTHER
	.byt 3,2	;Size (cols, rows)
	.byt $ff	;Initial room
	.byt 0,14	;Location (col, row)
	.byt ZPLANE_1	;Zplane
	.byt $ff,$ff	;Walk position (col, row)
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
	.asc "Cup",0
#endif
#ifdef SPANISH
	.asc "Taza",0
#endif
res_end
.)


; Object resource 50: Uniform
.(
	.byt RESOURCE_OBJECT
	.word (res_end-res_start+4)
	.byt UNIFORM
res_start
	.byt 0
	.byt 3,2	;Size (cols, rows)
	.byt $ff	;Initial room
	.byt 0,14	;Location (col, row)
	.byt ZPLANE_1	;Zplane
	.byt $ff,$ff	;Walk position (col, row)
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
	.asc "Uniform",0
#endif
#ifdef SPANISH
	.asc "Uniforme",0
#endif
res_end
.)

; Object resource 24: Cally
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt CALLY
res_start
	.byt OBJ_FLAG_ACTOR	; If OBJ_FLAG_PROP skip all costume data
	.byt 5,7		; Size (cols rows)
	.byt $ff		; Room
	.byt 33-2,13		; Pos (col, row)
	.byt ZPLANE_1		; Zplane
	.byt $ff,$ff		; Walk position (col, row)
	.byt $ff		; Facing direction for interaction
	.byt A_FWWHITE		; Color of text

	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt 13			; costume ($ff for none) and skip the rest
	.byt 0			; entry in costume resource		
	.byt 0		; direction (0 or LOOK_RIGHT for animstate 0)
	.byt 1			; animation speed	
	.asc "Cally",0
res_end	
.)


; Transponder
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 51
res_start
	.byt 0	; If OBJ_FLAG_PROP skip all costume data
	.byt 2,2		; Size (col, row)
	.byt $fe		; Room ($ff = current)
	.byt 13,10		; Pos (col, row)
	.byt ZPLANE_0		; Zplane
	.byt 9,13		; Walk position (col, row)
	.byt FACING_RIGHT	; Facing direction for interaction
	.byt 00			; Color of text
	; tiles and pointers to animatory states are setup in the costume
	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt 200		; costume ($ff for none) and skip the rest
	.byt 0			; entry in costume resource		
	.byt 0			; direction (0 or LOOK_RIGHT for animstate 0)
	.byt 0			; animation speed	
#ifdef ENGLISH
	.asc "Transponder",0
#endif
#ifdef SPANISH
	.asc "Transpondedor",0
#endif
res_end	
.)


; Transmitter
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 29
res_start
	.byt OBJ_FLAG_USEDWITHOTHER	; If OBJ_FLAG_PROP skip all costume data
	.byt 2,2		; Size (col, row)
	.byt $fe		; Room ($ff = current)
	.byt 13,10		; Pos (col, row)
	.byt ZPLANE_0		; Zplane
	.byt 9,13		; Walk position (col, row)
	.byt FACING_RIGHT	; Facing direction for interaction
	.byt 00			; Color of text
	; tiles and pointers to animatory states are setup in the costume
	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt $ff		; costume ($ff for none) and skip the rest
	.byt 0			; entry in costume resource		
	.byt 0			; direction (0 or LOOK_RIGHT for animstate 0)
	.byt 0			; animation speed	
#ifdef ENGLISH
	.asc "Transmitter",0
#endif
#ifdef SPANISH
	.asc "Transmisor",0
#endif
res_end	
.)


; Transmitter
.(
	.byt RESOURCE_OBJECT
	.word (res_end - res_start +4)
	.byt 30
res_start
	.byt OBJ_FLAG_USEDWITHOTHER	; If OBJ_FLAG_PROP skip all costume data
	.byt 2,2		; Size (col, row)
	.byt $fe		; Room ($ff = current)
	.byt 13,10		; Pos (col, row)
	.byt ZPLANE_0		; Zplane
	.byt 9,13		; Walk position (col, row)
	.byt FACING_RIGHT	; Facing direction for interaction
	.byt 00			; Color of text
	; tiles and pointers to animatory states are setup in the costume
	; Load the costume ID, load the resource, setup pointers, load animatory state and set it.
	; also setup direction and anim_speed	
	.byt $ff		; costume ($ff for none) and skip the rest
	.byt 0			; entry in costume resource		
	.byt 0			; direction (0 or LOOK_RIGHT for animstate 0)
	.byt 0			; animation speed	
#ifdef ENGLISH
	.asc "Remote relay",0
#endif
#ifdef SPANISH
	.asc "Rel","Z"+2," remoto",0
#endif
res_end	
.)



