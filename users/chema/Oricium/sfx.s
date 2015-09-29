;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; -----------------------------------
;;            Oricium
;;         Fast Scroll game
;; -----------------------------------
;;			(c) Chema 2013
;;         enguita@gmail.com
;; -----------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Sound effects and music definition


#include "sound.h"

#define FIRST_SFX_PAT 	0
#define FIRST_SFX_ORN 	5
#define FIRST_SFX_ENV	7

_SetSFX
.(
	sei

	jsr StopSound
	
	lda #0
	sta isr_plays_sound
	
	lda #<pattern_list_lo 
	sta pcodes_lo
	lda #>pattern_list_lo 
	sta pcodes_lo+1
	lda #<pattern_list_hi
	sta pcodes_hi
	lda #>pattern_list_hi
	sta pcodes_hi+1
	jmp _StartPlayer
.)



sfx_data	
; Available patterns		
pattern_list_lo 
	.byt <sfx_pick,<sfx_shoot,<sfx_pickb,<sfx_tiru,<sfx_jump,<sfx_zumzum,<sfx_beeple,<sfx_explosion,<sfx_alert,<sfx_labyrinth
pattern_list_hi 
	.byt >sfx_pick,>sfx_shoot,>sfx_pickb,>sfx_tiru,>sfx_jump,>sfx_zumzum,>sfx_beeple,>sfx_explosion,>sfx_alert,>sfx_labyrinth

	
; Instrument definition

Envelope_table
	; For music
	.byt 6,10,12,13,10,11,8,6
	.byt 13,13,13,13,10,11,8,6
	.byt 8,10,12,13,14,12,10,8
	.byt 10,10,12,13,15,15,14,10
; drums
	.byt 0,2,6,7,8,10,12,15
	.byt 9,10,11,13,12,14,15,12
	.byt 0,2,6,10,12,15,12,10

	; For sfx
	.byt 10,12,14,14,10,8,6,0 		; Pick A
	.byt 8,8,9,10,10,11,8,0 		; Shoot 	
	.byt 8,8,9,10,10,11,8,0 		; Pick B
	.byt 8,8,9,10,10,11,8,0 		; Tiru
	.byt 10,10,10,10,10,10,10,10 	; Jump
	.byt 11,11,11,00,00,11,11,11	; Zum-zum
	.byt 8,10,11,11,11,11,10,8		; Beeple
	.byt 8,8,8,9,9,10,11,11			; Explosion (phase 1)
	.byt 0,4,4,6,6,6,7,7			; Explosion (phase 2)
	.byt 11,11,11,00,00,11,11,11	; Alert
	
	
	
Ornament_table
	; For Music
	
	.byt 0,0,0,0,0,0,0,0
	.byt 0,$ff-1,0,1+1,0,$ff-1,0,1+1
	.byt 0,$fd-2,0,3+2,0,$fd-2,0,3+2
	.byt $70,$60,$50,$40,$30,$20,$10,0
	.byt 0,$ff,0,1,0,$ff,0,1

	; For sfx
	.byt 64,64,64,64,48,32,16,8 		; Pick A
	.byt 64,56,48,40,32,24,16,8       	; Shoot
	.byt 0,$ff,0,1,0,$ff,0,1		  	; Pick B
	.byt 14,14,14,14,0,0,0,0 		  	; Tiru - Invert for turi
	.byt $ff,0,$ff,0,2,8,14,28		  	; Jump (phase 1)
	.byt 28,14,8,2,$ff,0,$ff,0		  	; Jump (phase 2)
	.byt 0,$f0,0,16,0,$f0,0,16			; Zum-zum
	.byt 28,14,8,2,$ff,0,$ff,0 			; beepler .byt $ff,0,$ff,0,2,8,14,28 is cleaner
	.byt 0,0,0,0,0,0,0,0				; Explosion
	.byt 0,$f0,0,16,0,$f0,0,16			; Alert
	
	
sfx_listlo
		.byt <List_pick,<List_shoot,<List_pickb,<List_tiru,<List_jump,<List_zumzum,<List_beeple,<List_explosion,<List_alert,<List_labyrinth,<List_alert2,<List_switch
sfx_listhi
		.byt >List_pick,>List_shoot,>List_pickb,>List_tiru,>List_jump,>List_zumzum,>List_beeple,>List_explosion,>List_alert,>List_labyrinth,>List_alert2,>List_switch
sfx_priority
		.byt 2,1,2,1,1,1,1,4,3,5,3,3
	
sfx_pick
	.byt 7*12
	.byt END
List_pick
	.byt ENV, FIRST_SFX_ENV+0, ORN, FIRST_SFX_ORN+0, FIRST_SFX_PAT+0,END	

sfx_shoot
	.byt 5*12+10
	.byt END	
List_shoot
	.byt ENV, FIRST_SFX_ENV+1, ORN, FIRST_SFX_ORN+1, FIRST_SFX_PAT+1, END
	
sfx_pickb
	.byt 6*12+7
	.byt END
List_pickb
	.byt ENV, FIRST_SFX_ENV+2, ORN, FIRST_SFX_ORN+2, FIRST_SFX_PAT+2, END
	
sfx_tiru
	.byt 5*12
	.byt END
List_tiru
	.byt ENV, FIRST_SFX_ENV+3, ORN, FIRST_SFX_ORN+3, FIRST_SFX_PAT+3, END
	
sfx_jump
	.byt 5*12+0
	.byt END	
List_jump
	.byt ENV, FIRST_SFX_ENV+4, ORN, FIRST_SFX_ORN+4, FIRST_SFX_PAT+4
	.byt ORN, FIRST_SFX_ORN+5, FIRST_SFX_PAT+4, END	

	;.byt 9*12+0 for alert sound
	
sfx_zumzum 
	.byt 1*12+0 
	.byt END	
	
List_zumzum
	.byt ENV, FIRST_SFX_ENV+5, ORN, FIRST_SFX_ORN+6, FIRST_SFX_PAT+5, END	
	
	
sfx_beeple
	.byt 7*12+0 
	.byt END	
List_beeple
	.byt ENV, FIRST_SFX_ENV+6, ORN, FIRST_SFX_ORN+7, FIRST_SFX_PAT+6, END		

sfx_explosion
	.byt 9*12+0
	.byt END
List_explosion
	.byt NON, TOFF, NVAL, 30, ENV, FIRST_SFX_ENV+7, ORN, FIRST_SFX_ORN+8, FIRST_SFX_PAT+7
	.byt ENV, FIRST_SFX_ENV+8, FIRST_SFX_PAT+7, NOFF, TON, END

sfx_alert
	.byt 4*12+0
	.byt END
List_alert
	.byt ENV, FIRST_SFX_ENV+9, ORN, FIRST_SFX_ORN+9, SETVOL,0,FIRST_SFX_PAT+8,SETVOL,0, END	
	
sfx_labyrinth
	.byt 2*12+G_,2*12+G_,2*12+F_,2*12+G_,RST+1,2*12+AS_,RST,2*12+A_,2*12+A_,2*12+F_,2*12+G_,RST+2
	.byt END
List_labyrinth
	.byt ENV, FIRST_SFX_ENV+6, ORN, FIRST_SFX_ORN+8, FIRST_SFX_PAT+9, END		
	
List_alert2
	.byt ENV, FIRST_SFX_ENV+9, ORN, FIRST_SFX_ORN+9, NOFFSET,12,FIRST_SFX_PAT+8, NOFFSET,0,END	

List_switch
	.byt ENV, FIRST_SFX_ENV+2, ORN, FIRST_SFX_ORN+2, NOFFSET,$ff-(24+12), FIRST_SFX_PAT+2,NOFFSET,0, END

	