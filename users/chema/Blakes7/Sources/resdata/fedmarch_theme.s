#include "..\resource.h"
#include "..\sound.h"
*=$500


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Blake's 7: Federation March

; Music resource
; - Resource type: MUSIC
; - Resource Size
; - Resource ID
.(
.byt RESOURCE_MUSIC
.word res_end-res_start+4
.byt 3
res_start

__Blake_start
; Header: Tempo, pointers to patterns and pointers to pattern lists
.byt 10
.byt <Bl2pattern_list_lo-__Blake_start,>Bl2pattern_list_lo-__Blake_start
.byt <Bl2pattern_list_hi-__Blake_start,>Bl2pattern_list_hi-__Blake_start
.byt <_TuneDA-__Blake_start, >_TuneDA-__Blake_start
.byt <_TuneDB-__Blake_start, >_TuneDB-__Blake_start
.byt <_TuneDC-__Blake_start, >_TuneDC-__Blake_start

_TuneDA 	.byt ORN, 1, ENV, 1, SETVOL, 0, 0, 3, LOOP,0, END
_TuneDB		.byt ORN, 0, ENV, 4, SETVOL, 0, 2, LOOP,0, END ; Drums
_TuneDC		.byt ORN, 0, ENV, 4, SETVOL, 0, 1, LOOP,0, END ; Drums


Bl2pattern_list_lo 
	.byt <Bl2_main-__Blake_start,<Bl2_perc0-__Blake_start,<Bl2_perc1-__Blake_start,<B12_main2-__Blake_start
Bl2pattern_list_hi 
	.byt >Bl2_main-__Blake_start,>Bl2_perc0-__Blake_start,>Bl2_perc1-__Blake_start,>B12_main2-__Blake_start

#define OCTM (4)
#define OCTD 2
#define OCTD2 (OCTD-0)

Bl2_main
.byt RST+7

.byt (OCTM-2)*12+C_,RST+5-1, (OCTM-2)*12+CS_,RST
.byt (OCTM-2)*12+FS_,/*RST,*/(OCTM-2)*12+F_,/*RST+2,*/(OCTM-2)*12+E_,RST+2,(OCTM+1)*12+B_,(OCTM+1)*12+F_
.byt (OCTM+1)*12+A_,RST,OCTM*12+B_,OCTM*12+F_,OCTM*12+A_,RST,(OCTM-1)*12+B_,(OCTM-1)*12+F_
.byt (OCTM-1)*12+A_,RST+6

;.byt RST+7
.byt RST+7
.byt (OCTM-2)*12+D_,RST+5-1, (OCTM-2)*12+DS_,RST
.byt (OCTM-1)*12+A_,/*RST,*/(OCTM-2)*12+GS_,/*RST+2,*/(OCTM-2)*12+FS_,RST+4
;.byt ((OCTM+1)-1)*12+B_,RST+3, SIL+3
;.byt RST+7

.byt RST+7
.byt (OCTM+1)*12+DS_,(OCTM+1)*12+E_,RST+1,(OCTM+1)*12+F_,RST+2
.byt ((OCTM+1)-2)*12+B_,((OCTM+1)-1)*12+C_,RST+1,((OCTM+1)-1)*12+CS_,RST+2

.byt RST+7
.byt (OCTM-2)*12+C_,RST+5-1, (OCTM-2)*12+CS_,RST
.byt (OCTM-2)*12+FS_,/*RST,*/(OCTM-2)*12+F_,/*RST+2,*/(OCTM-2)*12+E_,RST+4


.byt END

B12_main2
.byt RST+4, (OCTM+2)*12+FS_,(OCTM+2)*12+CS_,RST
.byt RST, (OCTM+1)*12+FS_,(OCTM+1)*12+CS_,RST,(OCTM)*12+FS_,(OCTM)*12+CS_,RST+1

.byt RST+7
.byt RST+7
.byt (OCTM)*12+CS_,(OCTM)*12+A_,(OCTM)*12+CS_,(OCTM-1)*12+B_,RST+3
.byt (OCTM)*12+CS_,(OCTM-1)*12+F_,RST+5

.byt RST+7
.byt SETFLG+1

.byt END

Bl2_perc0
.byt (OCTD*12)+A_,RST,RST+1,(OCTD*12)+A_,RST,RST+1
.byt END

Bl2_perc1
.byt (OCTD2)*12+F_,RST,RST+1,(OCTD2)*12+F_,RST,RST+1
.byt END

__Blake_end

res_end
.)

