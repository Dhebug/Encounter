
#include "..\resource.h"
#include "..\sound.h"
*=$500


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Blake's 7 FInal variation

; Music resource
; - Resource type: MUSIC
; - Resource Size
; - Resource ID
.(
.byt RESOURCE_MUSIC
.word res_end-res_start+4
.byt 2
res_start

__Blake_start
; Header: Tempo, pointers to patterns and pointers to pattern lists
.byt 8
.byt <(Blpattern_list_lo-__Blake_start), >(Blpattern_list_lo-__Blake_start)
.byt <(Blpattern_list_hi-__Blake_start), >(Blpattern_list_hi-__Blake_start)
.byt <(_TuneCA-__Blake_start),		 >(_TuneCA-__Blake_start)
.byt <(_TuneCB-__Blake_start), 		 >(_TuneCB-__Blake_start)
.byt <(_TuneCC-__Blake_start), 		 >(_TuneCC-__Blake_start)

_TuneCA 	.byt ORN, 1, ENV, 4, NVAL,0, 4,2,2,2,2,2,2,2,3,2,2,3,2,4,4,4,4,4,4,4, END
_TuneCB		.byt ORN, 0, ENV, 6, SETVOL, 1, 1, END
_TuneCC		.byt ORN, 1, ENV, 0, 0, END
Blpattern_list_lo
	.byt <(Bl_main0-__Blake_start),<(Bl_main1-__Blake_start),<(Bl_drums-__Blake_start),<(Bl_drums2-__Blake_start),<(Bl_pause-__Blake_start)
Blpattern_list_hi
	.byt >(Bl_main0-__Blake_start),>(Bl_main1-__Blake_start),>(Bl_drums-__Blake_start),>(Bl_drums-__Blake_start),>(Bl_pause-__Blake_start)

#define OCTM (4)
#define OCTM2 (OCTM-1)
#define OCTD 1
#define OCT (OCTM+1)

Bl_main0

; Melody starts here...
.byt (OCTM-1)*12+G_,RST,(OCTM)*12+CS_,RST,(OCTM)*12+D_,RST+2
.byt (OCTM)*12+F_,RST+1,(OCTM)*12+E_,(OCTM)*12+E_,RST+2+4



; Pag 2, bar 16

.byt (OCTM)*12+C_,RST,(OCTM)*12+D_,RST
.byt (OCTM)*12+F_,RST+1,(OCTM)*12+E_,(OCTM-1)*12+B_,RST+2+4
.byt (OCTM)*12+C_,RST,(OCTM)*12+D_,RST

.byt (OCTM)*12+F_,RST+1,(OCTM)*12+E_,(OCTM)*12+E_,RST+2+4
.byt (OCTM)*12+G_,RST,(OCTM)*12+F_,RST
/**********************/
.byt (OCTM)*12+E_,RST+1,(OCTM)*12+D_,(OCTM-1)*12+B_,RST+2+4+4


.byt (OCTM)*12+F_,RST+1,(OCTM)*12+E_,(OCTM)*12+E_,RST+2+4
.byt (OCTM)*12+D_,(OCTM)*12+E_,(OCTM)*12+G_,(OCTM)*12+F_


; Pag 3, bar 25

.byt (OCTM)*12+D_,RST+2, (OCTM)*12+D_, (OCTM-1)*12+A_, RST+8+1
.byt (OCTM)*12+E_,RST+2, (OCTM)*12+D_,RST, (OCTM)*12+D_, RST+2
.byt (OCTM)*12+F_,RST, (OCTM)*12+E_,RST+2

.byt (OCTM)*12+D_,RST, (OCTM)*12+C_,RST, (OCTM)*12+C_,RST+2
.byt (OCTM)*12+D_,RST,(OCTM)*12+DS_,RST+2,(OCTM)*12+D_,RST

.byt (OCTM)*12+D_,RST,(OCTM-1)*12+B_,RST,(OCTM)*12+C_,RST+2
.byt (OCTM)*12+D_,RST,(OCTM-1)*12+B_,RST,(OCTM)*12+C_,RST+2
.byt (OCTM)*12+C_,RST+6
; Falta Silencio negra+corchea

.byt END

Bl_main1

; Melody starts here...
.byt (OCTM2-1)*12+G_,RST,(OCTM2)*12+CS_,RST,(OCTM2)*12+D_,RST+2
.byt (OCTM2)*12+F_,RST+1,(OCTM2)*12+E_,(OCTM2)*12+E_,RST+2+8
; Pag 2, bar 16
.byt (OCTM2)*12+E_,RST+6+8
.byt (OCTM2)*12+F_,RST+1,(OCTM2)*12+E_,(OCTM2)*12+E_,RST+2+8
.byt (OCTM2)*12+E_,RST+1,(OCTM2)*12+D_,RST,(OCTM2-1)*12+B_,RST+1+4

.byt SIL,RST+3
.byt (OCTM2)*12+E_,RST+6+7
.byt SIL,RST/*+7*/

; Pag 3, bar 25

.byt (OCTM2)*12+D_,RST+6+7
.byt SIL,RST
.byt (OCTM2)*12+D_,RST+6+7

.byt SIL,RST/*+7*/
.byt (OCTM2)*12+D_,RST, SIL, RST, (OCTM2)*12+C_,RST+3+7
.byt SIL,RST/*+7*/

.byt (OCTM2)*12+D_,RST+6
.byt (OCTM2-1)*12+B_,RST+6
.byt (OCTM2)*12+C_,RST+6

; Falta silencio negra

.byt END

#define OCTD 2
Bl_drums
;.byt OCTD*12+C_,RST,PNON,OCTD*12+E_,RST,PNOFF,OCTD*12+C_,RST,PNON,OCTD*12+E_,PNOFF,OCTD*12+C_,RST,OCTD*12+C_,PNON,OCTD*12+E_,PNOFF,OCTD*12+C_,OCTD*12+C_,RST,PNON,OCTD*12+E_,RST,PNOFF
;.byt PNON,OCTD*12+E_,RST,PNOFF,SIL,RST+1,OCTD*12+C_,RST,OCTD*12+C_,RST
.byt PNON,OCTD*12+F_,RST+1,PNOFF,SIL,RST
;.byt PNON,OCTD*12+F_,RST+1,PNOFF,SIL,RST
.byt OCTD*12+C_,RST,OCTD*12+C_,RST
.byt END

Bl_drums2
;.byt OCTD*12+C_,RST,PNON,OCTD*12+E_,RST,PNOFF,OCTD*12+C_,RST,PNON,OCTD*12+E_,PNOFF,OCTD*12+C_,RST,OCTD*12+C_,PNON,OCTD*12+E_,PNOFF,OCTD*12+C_,OCTD*12+C_,RST,PNON,OCTD*12+E_,RST,PNOFF
.byt OCTD*12+C_,RST,OCTD*12+C_,RST,OCTD*12+C_,OCTD*12+C_,OCTD*12+C_,RST
.byt END

Bl_pause
.byt SIL,RST+7
.byt END

__Blake_end

res_end
.)


