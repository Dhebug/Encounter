
#include "..\resource.h"
#include "..\sound.h"
*=$500


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Blake's 7 main theme

; Music resource
; - Resource type: MUSIC
; - Resource Size
; - Resource ID
.(
.byt RESOURCE_MUSIC
.word res_end-res_start+4
.byt 0
res_start

__Blake_start
; Header: Tempo, pointers to patterns and pointers to pattern lists
.byt 8-2
.byt <(Blpattern_list_lo-__Blake_start), >(Blpattern_list_lo-__Blake_start)
.byt <(Blpattern_list_hi-__Blake_start), >(Blpattern_list_hi-__Blake_start)
.byt <(_TuneCA-__Blake_start),		 >(_TuneCA-__Blake_start)
.byt <(_TuneCB-__Blake_start), 		 >(_TuneCB-__Blake_start)
.byt <(_TuneCC-__Blake_start), 		 >(_TuneCC-__Blake_start)

_TuneCA 	.byt ORN, 1, ENV, 3, SETVOL, 2, 3, ORN, 0, ENV, 2, SETVOL, 3, 2, END
_TuneCB		.byt SETVOL, 3, NVAL, 7, ORN, 2, ENV, 4, 4, 4, ORN, 2, ENV, 3, SETVOL, 3, 1, END
_TuneCC		.byt ORN, 0, ENV, 5, SETVOL, 2, 0, END


Blpattern_list_lo 
	.byt <(Bl_main0-__Blake_start), <(Bl_main1-__Blake_start), <(Bl_main2-__Blake_start), <(Bl_init2-__Blake_start), <(Bl_drums-__Blake_start)
Blpattern_list_hi 
	.byt >(Bl_main0-__Blake_start), >(Bl_main1-__Blake_start), >(Bl_main2-__Blake_start), >(Bl_init2-__Blake_start), >(Bl_drums-__Blake_start)

#define OCTM (4)
#define OCTM1 (OCTM-1)
#define OCTD 1
#define OCT (OCTM+1)

Bl_main0
.byt (OCTM1-1)*12+G_,RST+4,OCTM1*12+G_,OCTM1*12+G_
.byt OCTM1*12+F_,RST,OCTM1*12+E_,RST,(OCTM1)*12+D_,RST,(OCTM1)*12+C_,RST
.byt (OCTM1-1)*12+B_,RST+6+8
;.byt SIL,RST+7

.byt (OCTM1-1)*12+A_,RST+4,(OCTM1)*12+A_,(OCTM1)*12+A_
.byt (OCTM1)*12+G_,RST,(OCTM1)*12+F_,RST,(OCTM1)*12+E_,RST,(OCTM1)*12+D_,RST
.byt (OCTM1)*12+DS_,RST+6+8
;.byt SIL,RST+7

.byt (OCTM1)*12+GS_,RST+6+6,SIL,RST+1
;***
.byt (OCTM1)*12+G_,RST+6

; Melody starts here...

.byt (OCTM-1)*12+G_,RST,(OCTM)*12+CS_,RST,(OCTM)*12+D_,RST+2
.byt SETFLG+1
.byt (OCTM)*12+F_,RST+1,(OCTM)*12+E_,(OCTM)*12+E_,RST+2+4



; Pag 2, bar 16
.byt /*SIL,RST+3,*/(OCTM)*12+C_,RST,(OCTM)*12+D_,RST
.byt SETFLG+1
.byt (OCTM)*12+F_,RST+1,(OCTM)*12+E_,(OCTM-1)*12+B_,RST+2+4
.byt /*SIL,RST+3,*/(OCTM)*12+C_,RST,(OCTM)*12+D_,RST

.byt SETFLG+1
.byt (OCTM)*12+F_,RST+1,(OCTM)*12+E_,(OCTM)*12+E_,RST+2+4


.byt /*SIL,RST+3,*/(OCTM)*12+G_,RST,(OCTM)*12+F_,RST
.byt SETFLG+1
.byt (OCTM)*12+E_,RST+1,(OCTM)*12+D_,RST,(OCTM-1)*12+B_,RST+1+4+4


;.byt SIL,RST+3
.byt SETFLG+1
.byt (OCTM)*12+F_,RST+1,(OCTM)*12+E_,(OCTM)*12+E_,RST+2+4
.byt /*SIL, RST+3,*/ (OCTM)*12+D_,(OCTM)*12+E_,(OCTM)*12+G_,(OCTM)*12+F_


; Pag 3, bar 25
.byt SETFLG+1
.byt (OCTM)*12+D_,RST+2, (OCTM)*12+D_, (OCTM-1)*12+A_, RST+1+8
;.byt SIL,RST+7
.byt SETFLG+1
.byt (OCTM)*12+E_,RST+2, (OCTM)*12+D_,RST, (OCTM)*12+D_, RST+2

.byt /*SIL,RST+1,*/ (OCTM)*12+F_,RST, (OCTM)*12+E_,RST+2
.byt (OCTM)*12+D_,RST, (OCTM)*12+C_,RST, (OCTM)*12+C_,RST+2
.byt (OCTM)*12+D_,RST,(OCTM)*12+DS_,RST+2,(OCTM)*12+D_,RST

.byt SETFLG+1
.byt (OCTM)*12+D_,RST,(OCTM-1)*12+B_,RST,(OCTM)*12+C_,RST+2
.byt (OCTM)*12+D_,RST,(OCTM-1)*12+B_,RST,(OCTM)*12+C_,RST+2
.byt (OCTM)*12+C_,RST+6
; Falta Silencio negra+corchea

.byt (OCTM+1-1)*12+B_,(OCTM+1)*12+E_,(OCTM+1)*12+GS_,RST,(OCTM+1)*12+B_,RST+3
.byt (OCTM+1)*12+A_,RST,(OCTM+1)*12+A_,RST+8


.byt END
#define OCTD 2
#define DN_ A_
Bl_drums
;.byt OCTD*12+C_,RST,PNON,OCTD*12+E_,RST,PNOFF,

;.byt OCTD*12+DN_,SIL,RST+2,OCTD*12+DN_,SIL,RST+2,OCTD*12+DN_,SIL,RST+1,OCTD*12+DN_,SIL,RST,OCTD*12+DN_,OCTD*12+DN_,SIL,RST
;.byt OCTD*12+DN_,SIL,RST+2,OCTD*12+DN_,SIL,RST+2,OCTD*12+DN_,SIL,RST+1,OCTD*12+DN_,SIL,RST,OCTD*12+DN_,OCTD*12+DN_,SIL,RST

.byt OCTD*12+DN_,RST+2,OCTD*12+DN_,RST+2,OCTD*12+DN_,RST+1,OCTD*12+DN_,RST,OCTD*12+DN_,OCTD*12+DN_,RST
.byt OCTD*12+DN_,RST+2,OCTD*12+DN_,RST+2,OCTD*12+DN_,RST+1,OCTD*12+DN_,RST,OCTD*12+DN_,OCTD*12+DN_,RST


.byt END

Bl_main1
/* DRUMS HERE? */
;.byt (OCTM1-2)*12+G_,RST+4,(OCTM1)*12+E_,(OCTM1)*12+E_
;.byt OCTM1*12+D_,RST,OCTM1*12+C_,RST,(OCTM1-1)*12+B_,RST,(OCTM1-1)*12+A_,RST
;.byt (OCTM1-1)*12+G_,RST+6
;.byt SIL,RST+7
;.byt SIL,RST+7
;.byt SIL,RST+7
;.byt SIL,RST+7

;.byt (OCTM1-1)*12+F_,RST+4,(OCTM1)*12+F_,(OCTM1)*12+F_
;.byt (OCTM1)*12+E_,RST,(OCTM1)*12+D_,RST,(OCTM1)*12+C_,RST,(OCTM1-1)*12+A_,RST
;.byt (OCTM1-1)*12+DS_,RST+6
;.byt SIL,RST+7
;.byt SIL,RST+7
;.byt SIL,RST+7
;.byt SIL,RST+7


/* UP TO HERE */

.byt (OCTM-1)*12+D_,RST+3, (OCTM-1)*12+GS_,RST,(OCTM-1)*12+GS_
.byt (OCTM-1)*12+G_,RST,(OCTM-1)*12+F_,RST,(OCTM-1)*12+E_,RST,(OCTM-1)*12+F_,RST
;.byt (OCTM)*12+CS_,RST+6
.byt (OCTM-1)*12+G_,RST+6



; Melody starts here...
.byt (OCTM-2)*12+G_,RST,(OCTM-1)*12+CS_,RST,(OCTM-1)*12+D_,RST+2
.byt (OCTM-1)*12+F_,RST+1,(OCTM-1)*12+E_,(OCTM-1)*12+E_,RST+2
; Pag 2, bar 16

.byt SIL,RST+7
.byt (OCTM-1)*12+E_,RST+6+8
;.byt SIL,RST+7


.byt (OCTM-1)*12+F_,RST+1,(OCTM-1)*12+E_,(OCTM-1)*12+E_,RST+2+8
;.byt RST+7
.byt (OCTM-1)*12+E_,RST+1,(OCTM-1)*12+D_,RST,(OCTM-2)*12+B_,RST+1+4


.byt SIL,RST+3
.byt (OCTM-1)*12+E_,RST+6+7
.byt SIL,RST/*+7*/

; Pag 3, bar 25

.byt (OCTM-1)*12+D_,RST+6+7
.byt SIL,RST
.byt (OCTM-1)*12+D_,RST+6+7

.byt SIL,RST/*+7*/
.byt (OCTM-1)*12+D_,RST, SIL, RST, (OCTM-1)*12+C_,RST+3+7
.byt SIL,RST/*+7*/

.byt (OCTM-1)*12+D_,RST+6
.byt (OCTM-2)*12+B_,RST+6
.byt (OCTM-1)*12+C_,RST+6

; Falta silencio negra

.byt END

Bl_init2
.byt (OCTM1-1)*12+G_,RST+6+8
.byt (OCTM1-2)*12+FS_,RST
.byt (OCT)*12+GS_,(OCT)*12+G_,(OCT)*12+F_,RST+1,(OCT)*12+DS_
.byt (OCT)*12+CS_,RST,(OCT)*12+CS_,(OCT)*12+C_,(OCT-1)*12+B_,RST+2

.byt (OCTM1-1)*12+F_,RST+6+8
.byt SIL,RST+1
.byt (OCT)*12+DS_,(OCT)*12+D_,(OCT)*12+C_,RST+1,(OCT-1)*12+AS_
.byt (OCT-1)*12+A_,RST,(OCT-1)*12+A_,(OCT-1)*12+G_,(OCT-1)*12+FS_,RST+2
.byt END

Bl_main2
.byt (OCTM-1)*12+GS_,RST+3, (OCTM-1)*12+GS_,RST,(OCTM-1)*12+GS_
.byt (OCTM-1)*12+GS_,RST,(OCTM-1)*12+GS_,RST,(OCTM-1)*12+GS_,RST,(OCTM-1)*12+GS_,RST
.byt (OCTM-1)*12+G_,RST+6+8
;.byt SIL,RST+7
.byt (OCTM-1)*12+G_,RST+6+8

; Pag 2, bar 16
;.byt SIL, RST+7
.byt (OCTM-1)*12+E_,RST+6+8
;.byt SIL, RST+7

.byt (OCTM-1)*12+A_,RST+2, (OCTM-1+1)*12+E_,RST+2+8
;.byt SIL, RST+7
.byt (OCTM-1)*12+GS_,RST+2, (OCTM-1+1)*12+E_,RST+2+8

;.byt SIL, RST+7
.byt (OCTM-1)*12+G_,RST+6+8
;.byt SIL, RST+7

; Page 3, bar 25

.byt (OCTM-1)*12+F_,RST+6+8
;.byt SIL, RST+7
.byt (OCTM-1)*12+F_,RST+6+8

;.byt SIL, RST+7
.byt (OCTM-1+1)*12+C_,RST+6
.byt (OCTM-1)*12+B_,RST+6

.byt (OCTM-1+1)*12+D_,RST+6
.byt (OCTM-1)*12+B_,RST+6
.byt (OCTM-1+1)*12+C_,RST+6

.byt END

__Blake_end

res_end
.)
