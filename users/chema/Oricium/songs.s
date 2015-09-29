#include "sound.h"

#ifdef ALLSONGS
__OrdinaryWorld_start
; Header: Tempo, pointers to pattern lists
.byt 9
.byt <owpattern_list_lo,>owpattern_list_lo,<owpattern_list_hi,>owpattern_list_hi
.byt <_Tune1A, >_Tune1A, <_Tune1B, >_Tune1B, <_Tune1C, >_Tune1C



_Tune1A .byt ORN, 2, ENV, 3, 12, ENV, 0,         14,7,  14,7,  14,7,  14,8,  14,9, 10,10, 12  ,END
_Tune1B	.byt ORN, 0, ENV, 3, 11, ENV, 1,         13,0,1,13,2,3,13,0,1,13,2,4,13,5,  6, 6      ,END
_Tune1C	.byt NOFFSET, 12, ORN, 0, ENV, 3, 11, ENV, 2, ORN, 1, 13,0,1,13,2,3,13,0,1,13,2,4,13,5,  6, 6,ORN, 0, ENV, 3,11  ,END



owpattern_list_lo .byt <_ow_p0,<_ow_p1,<_ow_p2,<_ow_p3,<_ow_p4,<_ow_p5,<_ow_pa0,<_ow_2_p0,<_ow_2_p1,<_ow_2_p2,<_ow_2_pa0, <_ow_i, <_ow_i_2, <_ow_s0,<_ow_2_s0
owpattern_list_hi .byt >_ow_p0,>_ow_p1,>_ow_p2,>_ow_p3,>_ow_p4,>_ow_p5,>_ow_pa0,>_ow_2_p0,>_ow_2_p1,>_ow_2_p2,>_ow_2_pa0, >_ow_i, >_ow_i_2, >_ow_s0,>_ow_2_s0

#define OCT 4

_ow_s0
    .byt (OCT-1)*12+GS_,RST, OCT*12+CS_,RST, OCT*12+DS_,RST, OCT*12+CS_,OCT*12+DS_, OCT*12+DS_,RST,END

_ow_p0
	;.byt (OCT-1)*12+GS_,RST, OCT*12+CS_,RST, OCT*12+DS_,RST, OCT*12+CS_,OCT*12+DS_, OCT*12+DS_,RST, OCT*12+CS_,RST, OCT*12+DS_,RST, OCT*12+CS_,RST
    .byt OCT*12+CS_,RST, OCT*12+DS_,RST, OCT*12+CS_,RST
	.byt END

_ow_p1
	.byt OCT*12+DS_,RST, OCT*12+CS_,RST, OCT*12+CS_,OCT*12+DS_, (OCT-1)*12+GS_,RST, (OCT-1)*12+GS_,RST+2, SIL, RST+3
	.byt END

_ow_p2
	;.byt (OCT-1)*12+GS_,RST, OCT*12+CS_,RST, OCT*12+DS_,RST, OCT*12+CS_,OCT*12+DS_, OCT*12+DS_,RST, OCT*12+E_,OCT*12+DS_, OCT*12+DS_,RST, OCT*12+CS_,RST
	.byt OCT*12+E_,OCT*12+DS_, OCT*12+DS_,RST, OCT*12+CS_,RST
    .byt END

_ow_p3
	.byt SIL, RST+9, (OCT-1)*12+B_,RST+2, (OCT-1)*12+AS_,RST
	.byt END

_ow_p4
	.byt OCT*12+CS_,(OCT-1)*12+B_, (OCT-1)*12+B_,RST+2,(OCT-1)*12+B_,RST, SIL, RST+7
	.byt END

_ow_p5
	;.byt (OCT-1)*12+GS_,RST, OCT*12+CS_,RST, OCT*12+DS_,RST, OCT*12+CS_,OCT*12+DS_, OCT*12+DS_,RST, OCT*12+CS_,RST, OCT*12+DS_,RST+2
    .byt OCT*12+CS_,RST, OCT*12+DS_,RST+2
	.byt (OCT-1)*12+GS_,RST, OCT*12+CS_,RST, OCT*12+DS_,OCT*12+CS_, OCT*12+DS_,RST+4, SIL, RST+3
	.byt OCT*12+CS_,RST,OCT*12+CS_,RST,OCT*12+CS_,RST,OCT*12+CS_,RST, (OCT-1)*12+B_,RST, OCT*12+DS_,RST, OCT*12+CS_,OCT*12+DS_, (OCT-1)*12+B_,RST
	;.byt (OCT-1)*12+B_,RST+2,(OCT-1)*12+B_,RST,SIL,RST+9
    .byt (OCT-1)*12+B_,RST+4,SIL,RST+9
	.byt END


_ow_pa0
	.byt SIL, RST+1, (OCT-1)*12+B_,OCT*12+DS_,OCT*12+FS_,RST+2, OCT*12+FS_,RST,OCT*12+FS_,OCT*12+E_,OCT*12+E_,RST,OCT*12+DS_,OCT*12+CS_
	.byt OCT*12+CS_,RST+2,OCT*12+CS_,RST,(OCT-1)*12+B_,OCT*12+CS_,OCT*12+CS_,RST,(OCT-1)*12+B_,OCT*12+CS_,OCT*12+CS_,RST+1,OCT*12+E_
	.byt OCT*12+E_,RST+2,OCT*12+CS_,OCT*12+E_,RST+1, OCT*12+E_,RST+2, OCT*12+E_,RST,OCT*12+FS_,OCT*12+FS_
	.byt OCT*12+FS_,RST+10,SIL,RST+3
	.byt END


_ow_i
	.byt SIL
	.byt OCT*12+E_,OCT*12+E_,OCT*12+E_,OCT*12+E_
	.byt OCT*12+E_,OCT*12+DS_,OCT*12+DS_,OCT*12+DS_,OCT*12+DS_, OCT*12+CS_,OCT*12+CS_,OCT*12+CS_,OCT*12+CS_,(OCT-1)*12+B_,(OCT-1)*12+B_,(OCT-1)*12+B_,(OCT-1)*12+B_,RST,OCT*12+FS_,OCT*12+FS_,OCT*12+FS_
	.byt OCT*12+FS_,OCT*12+E_,OCT*12+E_,OCT*12+E_,OCT*12+E_,OCT*12+DS_,OCT*12+DS_,OCT*12+DS_,OCT*12+DS_,OCT*12+CS_,OCT*12+CS_,RST,OCT*12+CS_,(OCT-1)*12+B_,RST+1
	.byt (OCT-1)*12+B_,RST,(OCT-1)*12+E_,(OCT-1)*12+B_,(OCT-1)*12+B_,(OCT-1)*12+E_,(OCT-1)*12+B_,RST,(OCT-1)*12+B_,RST+6
	.byt (OCT-1)*12+A_,RST,(OCT-1)*12+E_,(OCT-1)*12+A_,(OCT-1)*12+A_,(OCT-1)*12+E_,(OCT-1)*12+A_,RST,(OCT-1)*12+A_,RST+2,(OCT-1)*12+E_,RST+2
	.byt END

#define OCT 2
_ow_i_2
	.byt SIL
	.byt RST+3
	.byt RST+15,RST+15,RST+15,RST+15,RST
/*
	.byt OCT*12+GS_,RST+2
	.byt OCT*12+B_,RST+4,OCT*12+B_,OCT*12+GS_,OCT*12+B_,OCT*12+B_,OCT*12+B_,RST+2,OCT*12+B_,RST
	.byt OCT*12+GS_,RST+4,OCT*12+GS_,OCT*12+GS_,OCT*12+GS_,RST,OCT*12+GS_,RST,OCT*12+GS_,OCT*12+GS_,(OCT+1)*12+CS_,OCT*12+GS_

	.byt OCT*12+D_,RST+4,OCT*12+DS_,OCT*12+DS_,OCT*12+CS_,RST,OCT*12+CS_,RST+2,OCT*12+CS_,RST
	.byt OCT*12+C_,RST+4,OCT*12+CS_,OCT*12+CS_,OCT*12+A_,OCT*12+G_,RST+1,OCT*12+GS_,RST,OCT*12+CS_,RST
*/
	.byt END


#define OCT 2
_ow_2_s0
	.byt OCT*12+CS_,RST+4,OCT*12+CS_,OCT*12+CS_,OCT*12+CS_,RST,OCT*12+CS_,RST+2,OCT*12+CS_,RST
    .byt END
_ow_2_p0
	;.byt OCT*12+CS_,RST+4,OCT*12+CS_,OCT*12+CS_,OCT*12+CS_,RST,OCT*12+CS_,RST+2,OCT*12+CS_,RST
	.byt OCT*12+E_,RST+4,OCT*12+E_,OCT*12+E_,OCT*12+FS_,RST,OCT*12+FS_,RST+2,OCT*12+CS_,RST
	.byt END

_ow_2_p1
	;.byt OCT*12+CS_,RST+4,OCT*12+CS_,OCT*12+CS_,OCT*12+CS_,RST,OCT*12+CS_,RST+2,OCT*12+CS_,RST
	.byt OCT*12+E_,RST, (OCT+1)*12+CS_,RST, OCT*12+B_,RST+2, OCT*12+FS_,OCT*12+FS_,OCT*12+FS_,OCT*12+FS_, OCT*12+E_,RST, OCT*12+CS_,RST
	.byt END

_ow_2_p2
	;.byt OCT*12+CS_,RST+4,OCT*12+CS_,OCT*12+CS_,OCT*12+CS_,RST,OCT*12+CS_,RST+2,OCT*12+CS_,RST
	.byt OCT*12+GS_,RST+4,OCT*12+GS_,OCT*12+GS_,OCT*12+GS_,RST,OCT*12+GS_,RST+2,OCT*12+GS_,RST
	.byt OCT*12+DS_,RST+4,OCT*12+DS_,OCT*12+DS_,OCT*12+DS_,RST,OCT*12+DS_,RST+2,OCT*12+DS_,OCT*12+E_
	.byt END

#define OCT 2
_ow_2_pa0
	.byt SIL
	.byt OCT*12+B_,RST+4,OCT*12+B_,OCT*12+B_,OCT*12+B_,RST,OCT*12+B_,RST+2,OCT*12+B_,RST
	.byt OCT*12+FS_,RST+4,OCT*12+FS_,OCT*12+FS_,OCT*12+FS_,RST,OCT*12+FS_,RST+2,OCT*12+FS_,RST
	.byt (OCT+1)*12+CS_,RST+4,(OCT+1)*12+CS_,(OCT+1)*12+CS_,(OCT+1)*12+CS_,RST,(OCT+1)*12+CS_,RST+2,(OCT+1)*12+CS_,RST	
	.byt (OCT+1)*12+E_,RST+4,(OCT+1)*12+E_,(OCT+1)*12+E_,(OCT+1)*12+E_,RST,(OCT+1)*12+E_,RST+2,(OCT+1)*12+E_,RST	
	.byt END
	
__OrdinaryWorld_end

#endif

__TaintedLove_start
; Header: Tempo, pointers to patterns and pointers to pattern lists
.byt 8
.byt <tlpattern_list_lo,>tlpattern_list_lo,<tlpattern_list_hi,>tlpattern_list_hi
.byt <_Tune2A, >_Tune2A, <_Tune2B, >_Tune2B, <_Tune2C, >_Tune2C


_Tune2A .byt SETVOL,2,ORN, 0, ENV, 5, 						0,0,0,0,0,0,5,6,0,0,0,5,6, 5,5,6,6,7,7,8,8,8,8,0,0,LOOP,0, END
_Tune2B	.byt ORN,3, ENV,4, 2,2,ORN,1,ENV,0,           4,             LOOP,0,END
_Tune2C	.byt ORN, 3, ENV, 4, 	    1,1,1,3,3,3,1,1,3,3,3,1,1,1,1,1,3,3, LOOP,0,END



tlpattern_list_lo 
	.byt <tl_p0,<tl_drums,<tl_wait,<tl_drums2,<tl_main1,<tl_p1,<t1_p2,<t1_p3,<t1_p4
tlpattern_list_hi 
	.byt >tl_p0,>tl_drums,>tl_wait,>tl_drums2,>tl_main1,>tl_p1,>t1_p2,>t1_p3,>t1_p4

#define OCT 2

tl_p0
.byt OCT*12+G_,RST, OCT*12+G_,RST, OCT*12+AS_,RST, OCT*12+AS_,RST,SIL
.byt (OCT+1)*12+DS_,RST, (OCT+1)*12+DS_,RST, OCT*12+AS_,(OCT+1)*12+C_,RST+1,SIL
.byt END

tl_p1
.byt OCT*12+G_,RST,OCT*12+G_,RST,OCT*12+G_,RST,OCT*12+G_,RST
.byt END

t1_p2
.byt OCT*12+AS_,RST,OCT*12+AS_,RST,OCT*12+AS_,RST,OCT*12+AS_,RST
.byt END

t1_p3
.byt (OCT+1)*12+DS_,RST,(OCT+1)*12+DS_,RST,(OCT+1)*12+DS_,RST,(OCT+1)*12+DS_,RST
.byt END

t1_p4
.byt (OCT+1)*12+C_,RST,(OCT+1)*12+C_,RST,(OCT+1)*12+C_,RST,(OCT+1)*12+C_,RST
.byt END


#define OCTD 3
tl_drums
.byt RST+1, OCTD*12+D_,RST, SIL,RST+1, OCTD*12+D_,RST,SIL
.byt RST+1, OCTD*12+D_,RST, SIL,RST+1, OCTD*12+D_,RST,SIL
.byt END

tl_drums2
.byt RST+1, OCTD*12+D_, RST, SIL, RST+1, OCTD*12+D_,RST,SIL
.byt RST+1, OCTD*12+D_, RST, OCTD*12+D_, OCTD*12+D_, OCTD*12+D_,RST,SIL
.byt END

/*
tl_drums3
.byt RST+1, OCTD*12+D_, RST, RST+1, OCTD*12+D_,RST
.byt RST+1, OCTD*12+D_, RST, RST, OCTD*12+D_, OCTD*12+D_,RST
.byt END
*/

tl_wait
	.byt (OCTD-1)*12+G_,RST,SIL,(OCTD-1)*12+G_,RST,SIL, RST+3, RST+7,END

#define OCTM 3
tl_main1
	.byt RST+13,(OCTM+1)*12+C_,RST
	.byt (OCTM+1)*12+D_,RST+1,OCTM*12+G_,RST+1,OCTM*12+AS_,RST,SIL
	.byt RST+1,OCTM*12+G_,RST,OCTM*12+AS_,RST,(OCTM+1)*12+C_,RST,SIL
	
	.byt RST+1,(OCTM+1)*12+D_,RST,OCTM*12+G_,RST,OCTM*12+AS_,RST,SIL
	.byt RST+1,OCTM*12+G_,RST,OCTM*12+AS_,RST,(OCTM+1)*12+C_,RST,SIL
	.byt RST+1,(OCTM+1)*12+D_,RST,OCTM*12+G_,RST,OCTM*12+AS_,RST,SIL

	.byt RST+1,(OCTM*12)+G_,OCTM*12+G_,OCTM*12+AS_,RST,(OCTM+1)*12+C_,RST
	.byt (OCTM+1)*12+D_,OCTM*12+G_,RST,OCTM*12+G_,RST,OCTM*12+G_,RST,(OCTM)*12+F_
	.byt OCTM*12+G_,OCTM*12+AS_,(OCTM+1)*12+C_,(OCTM+1)*12+D_,RST,(OCTM+1)*12+F_,(OCTM+1)*12+D_,RST,SIL
	
	.byt RST+2,OCTM*12+G_, RST+1, OCTM*12+AS_,RST,SIL
	.byt RST+1,OCTM*12+G_,RST,OCTM*12+AS_,RST,(OCTM+1)*12+C_,RST,SIL
	.byt RST+2,(OCTM+1)*12+D_,OCTM*12+G_,RST,OCTM*12+AS_,RST,SIL
	.byt RST+1,(OCTM*12)+G_,OCTM*12+G_,OCTM*12+AS_,RST,(OCTM+1)*12+C_,RST

	.byt (OCTM+1)*12+D_,RST+2,OCTM*12+G_,RST,OCTM*12+AS_,RST,SIL
	.byt RST+2,OCTM*12+G_,OCTM*12+AS_,RST,(OCTM+1)*12+C_,RST 
	
	.byt (OCTM+1)*12+D_,(OCTM+1)*12+D_,RST,(OCTM+1)*12+D_,RST,(OCTM+1)*12+D_,(OCTM+1)*12+D_,(OCTM+1)*12+C_
	.byt (OCTM+1)*12+D_,RST,(OCTM+1)*12+D_,RST,(OCTM+1)*12+D_,RST+2,SIL
	.byt RST+3,(OCTM)*12+B_,(OCTM)*12+A_,(OCTM)*12+G_,RST,SIL
	.byt (OCTM)*12+A_,RST,(OCTM)*12+G_,(OCTM)*12+G_,RST+3,SIL
	.byt RST+3,(OCTM+1)*12+D_,RST,(OCTM+1)*12+C_,(OCTM)*12+AS_
	.byt (OCTM+1)*12+D_,RST+2,OCTM*12+G_,OCTM*12+AS_,RST, SIL, RST
	.byt (OCTM+1)*12+DS_,RST,(OCTM+1)*12+DS_,RST,(OCTM+1)*12+DS_,RST,(OCTM+1)*12+DS_,RST
	.byt (OCTM+1)*12+DS_,RST,(OCTM+1)*12+F_,RST,(OCTM+1)*12+DS_,RST,(OCTM+1)*12+DS_,RST
	.byt (OCTM+1)*12+C_,RST,(OCTM+1)*12+C_,(OCTM+1)*12+C_,RST+2,(OCTM+1)*12+C_
	.byt (OCTM+1)*12+D_,RST,(OCTM+1)*12+C_,RST,(OCTM)*12+G_,RST,(OCTM+1)*12+C_,RST
	
	.byt (OCTM+1)*12+D_,RST,(OCTM+1)*12+D_,RST,(OCTM+1)*12+D_,RST,(OCTM+1)*12+D_,RST
	.byt (OCTM+1)*12+D_,RST,(OCTM+1)*12+D_,RST,(OCTM+1)*12+D_,(OCTM+1)*12+D_,(OCTM+1)*12+G_,RST,SIL
	.byt RST,(OCTM+1)*12+D_,(OCTM)*12+G_,RST,(OCTM)*12+AS_,RST+2,SIL
	.byt RST+7

	;.byt RST,(OCTM+1)*12+D_,(OCTM)*12+G_,RST,(OCTM)*12+AS_,RST+2,SIL
	.byt (OCTM+1)*12+D_,RST,SIL,RST+1,(OCTM)*12+G_,RST,(OCTM)*12+AS_,RST,SIL
	.byt RST+7
	
	.byt END


	
__TaintedLove_end



__EnolaGay_start
; Header: Tempo, pointers to patterns and pointers to pattern lists
.byt 8
.byt <egpattern_list_lo,>egpattern_list_lo,<egpattern_list_hi,>egpattern_list_hi
.byt <_Tune3A, >_Tune3A, <_Tune3B, >_Tune3B, <_Tune3C, >_Tune3C


_Tune3A .byt ORN, 1, ENV, 2,SETVOL,0,		0,0,0,1,0,0,0,1,0,0,0,1, 0,1,6,  LOOP,0,END
_Tune3B	.byt ORN, 3, ENV, 4,SETVOL,0,NOFF, NVAL, 2,		2,     2,     7,      8, 8,8,8,8,8,8,8,8,  LOOP,0,END
_Tune3C	.byt ORN, 1, ENV, 0,SETVOL,0, 		3,3,3,3,4,4,4,4,5,5,5,5, 9,9,10,10,11,11,12,12,13,13,     LOOP,0,END



egpattern_list_lo 
	.byt <eg_p0,<eg_p1,<eg_drums0,<eg_pm0,<eg_pm1,<eg_pm2,<eg_p2,<eg_drums1,<eg_drums2,<eg_pm3,<eg_pm4,<eg_pm5,<eg_pm6,<eg_pm7
egpattern_list_hi 
	.byt >eg_p0,>eg_p1,>eg_drums0,>eg_pm0,>eg_pm1,>eg_pm2,>eg_p2,>eg_drums1,>eg_drums2,>eg_pm3,>eg_pm4,>eg_pm5,>eg_pm6,>eg_pm7

#define OCT 4

eg_p0
.byt OCT*12+F_,OCT*12+D_,OCT*12+F_,OCT*12+E_
.byt END

eg_p1
.byt OCT*12+F_,OCT*12+D_,OCT*12+G_,OCT*12+E_
.byt END

eg_p2
.byt OCT*12+F_,OCT*12+F_,OCT*12+A_,OCT*12+AS_,(OCT+1)*12+C_,OCT*12+AS_,OCT*12+A_,OCT*12+F_

.byt RST,OCT*12+F_,OCT*12+A_,OCT*12+AS_,(OCT+1)*12+C_,(OCT)*12+AS_,OCT*12+A_,RST
.byt OCT*12+D_,OCT*12+D_,OCT*12+F_,OCT*12+G_,OCT*12+A_,OCT*12+G_,OCT*12+F_,OCT*12+D_
.byt RST,OCT*12+D_,OCT*12+A_,OCT*12+A_,OCT*12+G_,RST,OCT*12+F_,RST

.byt (OCT-1)*12+AS_,(OCT-1)*12+AS_,(OCT)*12+D_,(OCT)*12+DS_,(OCT)*12+F_,(OCT)*12+DS_,(OCT)*12+D_,(OCT-1)*12+AS_
.byt RST,(OCT-1)*12+AS_,(OCT)*12+D_,(OCT)*12+DS_,(OCT)*12+F_,(OCT)*12+DS_,(OCT)*12+D_,RST
.byt (OCT)*12+C_,(OCT)*12+C_,(OCT)*12+E_,(OCT)*12+F_,(OCT)*12+G_,(OCT)*12+F_,(OCT)*12+E_,(OCT)*12+C_

.byt RST,(OCT)*12+C_,(OCT)*12+G_,(OCT)*12+G_,(OCT)*12+F_,RST,(OCT)*12+E_,RST

.byt END




#define OCTD 3
eg_drums0
.byt OCTD*12+D_, RST+2, OCTD*12+D_,RST+2
.byt OCTD*12+D_, RST+2, OCTD*12+D_,RST+2
.byt END

eg_drums1
.byt OCTD*12+D_, RST+2, OCTD*12+D_,RST+2
.byt OCTD*12+D_, OCTD*12+D_, OCTD*12+D_, OCTD*12+D_, OCTD*12+D_, OCTD*12+D_, OCTD*12+D_, OCTD*12+D_
.byt END

eg_drums2
.byt OCTD*12+D_, RST, OCTD*12+D_, RST, OCTD*12+D_, OCTD*12+D_, PNON,OCTD*12+D_, RST,PNOFF 
.byt END

#define OCTM 3
eg_pm0
.byt OCTM*12+F_,OCTM*12+F_,OCTM*12+F_,OCTM*12+F_
.byt END
eg_pm1
.byt OCTM*12+D_,OCTM*12+D_,OCTM*12+D_,OCTM*12+D_
.byt END
eg_pm2
.byt (OCTM-1)*12+AS_,(OCTM-1)*12+AS_,(OCTM-1)*12+AS_,(OCTM-1)*12+AS_
.byt END
eg_pm3
.byt OCTM*12+C_,OCTM*12+C_,OCTM*12+C_,OCTM*12+C_
.byt END
eg_pm4
.byt (OCTM-1)*12+F_,(OCTM)*12+F_,(OCTM)*12+F_,(OCTM-1)*12+F_
.byt (OCTM)*12+F_,(OCTM-1)*12+F_,(OCTM)*12+F_,(OCTM)*12+F_
.byt END
eg_pm5
.byt (OCTM-1)*12+D_,(OCTM)*12+D_,(OCTM)*12+D_,(OCTM-1)*12+D_
.byt (OCTM)*12+D_,(OCTM-1)*12+D_,(OCTM)*12+D_,(OCTM)*12+D_
.byt END
eg_pm6
.byt (OCTM-1)*12+AS_,(OCTM)*12+AS_,(OCTM)*12+AS_,(OCTM-1)*12+AS_
.byt (OCTM)*12+AS_,(OCTM-1)*12+AS_,(OCTM)*12+AS_,(OCTM)*12+AS_
.byt END
eg_pm7
.byt (OCTM-1)*12+C_,(OCTM)*12+C_,(OCTM)*12+C_,(OCTM-1)*12+C_
.byt (OCTM)*12+C_,(OCTM-1)*12+C_,(OCTM)*12+C_,(OCTM)*12+C_
.byt END

__EnolaGay_end



__LivingOnVideo_start
; Header: Tempo, pointers to patterns and pointers to pattern lists
.byt 8
.byt <lvpattern_list_lo,>lvpattern_list_lo,<lvpattern_list_hi,>lvpattern_list_hi
.byt <_Tune4A, >_Tune4A, <_Tune4B, >_Tune4B, <_Tune4C, >_Tune4C


_Tune4A .byt ORN, 0, ENV, 1,		0,0,0,0,   2,5,  5,  5,  5,  5,  5,  5      ,LOOP,9,END
_Tune4B	.byt ORN, 2, ENV, 1,		1,1,	   3,4,3,4,3,4,3,4,3,4,3,4,3,4,3  ,LOOP,7,END
_Tune4C	.byt ORN, 4, ENV, 2, 		0,0,0,0,   0,0,0,0,0,0,6,  6,  6,  6  ,0    ,LOOP,9,END


lvpattern_list_lo 
	.byt <lv_wait,<lv_p0,<lv_p0m,<lv_p1,<lv_p2,<lv_p1m,<lv_p1v
lvpattern_list_hi 
	.byt >lv_wait,>lv_p0,>lv_p0m,>lv_p1,>lv_p2,>lv_p1m,>lv_p1v


lv_wait
.byt SIL,RST+7
.byt END

#define OCT 2

lv_p0
.byt OCT*12+GS_,RST,OCT*12+GS_,RST,OCT*12+DS_,RST,OCT*12+E_,RST
.byt OCT*12+FS_,RST,OCT*12+FS_,RST,OCT*12+FS_,RST,OCT*12+FS_,RST
.byt END

lv_p1
.byt OCT*12+GS_,(OCT+1)*12+GS_,OCT*12+GS_,(OCT+1)*12+GS_,OCT*12+DS_,(OCT+1)*12+DS_,OCT*12+E_,(OCT+1)*12+E_
.byt END

lv_p2
.byt OCT*12+FS_,(OCT+1)*12+FS_,OCT*12+FS_,(OCT+1)*12+FS_,OCT*12+FS_,(OCT+1)*12+FS_,OCT*12+FS_,(OCT+1)*12+FS_
.byt END


#define OCTM 4
lv_p0m
.byt OCTM*12+B_,OCTM*12+GS_,OCTM*12+B_,OCTM*12+DS_,OCTM*12+B_,OCTM*12+GS_,OCTM*12+B_,OCTM*12+E_
.byt END

lv_p1m
.byt (OCTM+1)*12+CS_,OCTM*12+AS_,(OCTM+1)*12+CS_,OCTM*12+FS_,OCTM*12+B_,OCTM*12+AS_,OCTM*12+B_,OCTM*12+GS_
.byt OCTM*12+B_,OCTM*12+GS_,OCTM*12+B_,OCTM*12+DS_, OCTM*12+B_,OCTM*12+GS_,OCTM*12+B_,OCTM*12+E_
.byt END

#define OCTV 5
lv_p1v
.byt OCTV*12+GS_,RST,OCTV*12+GS_,OCTV*12+AS_,OCTV*12+B_,OCTV*12+E_,SIL,RST,OCTV*12+FS_
.byt OCTV*12+FS_,OCTV*12+GS_,OCTV*12+FS_,RST,(OCTV+1)*12+CS_,OCTV*12+B_,OCTV*12+AS_,SIL,RST
.byt END


__LivingOnVideo_end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Take on Me

__TakeOnMe_start
; Header: Tempo, pointers to patterns and pointers to pattern lists
.byt 8
.byt <tonpattern_list_lo,>tonpattern_list_lo,<tonpattern_list_hi,>tonpattern_list_hi
.byt <_Tune8A, >_Tune8A, <_Tune8B, >_Tune8B, <_Tune8C, >_Tune8C

_Tune8A .byt ORN, 0, ENV, 1, 				1,2,1, 	ENV, 5,						4,4,4, 			 LOOP,9, END
_Tune8B	.byt ORN, 1, ENV, 1,				1,3, ORN, 2, ENV, 3, 			5,6,7,6,6,6,6,   LOOP, 11, END
_Tune8C	.byt ORN, 3, ENV, 4, NVAL,7, 		0, LOOP, 4, END


tonpattern_list_lo 
	.byt <ton_drums0,<ton_wait,<ton_initA,<ton_initB,<ton_main0,<ton_bass0,<ton_bass1,<ton_bass2
tonpattern_list_hi 
	.byt >ton_drums0,>ton_wait,>ton_initA,>ton_initB,>ton_main0,>ton_bass0,>ton_bass1,>ton_bass2


#define OCTD 2
ton_drums0
/*
.byt PNON, OCTD*12+FS_, OCTD*12+FS_, PNOFF, OCTD*12+FS_, PNON, OCTD*12+FS_
.byt OCTD*12+FS_, SIL,RST, PNOFF, OCTD*12+FS_, PNON,OCTD*12+FS_,PNOFF
*/

.byt PNOFF, OCTD*12+FS_, OCTD*12+FS_, PNON, OCTD*12+FS_, PNOFF, OCTD*12+FS_
.byt OCTD*12+FS_, SIL,RST, PNON, OCTD*12+FS_, PNOFF,OCTD*12+FS_


.byt END

#define OCTB 2
ton_bass0
.byt OCTB*12+B_,RST,SIL,RST,(OCTB-1)*12+B_,RST+1,(OCTB-1)*12+B_,(OCTB-1)*12+B_
.byt OCTB*12+B_,OCTB*12+B_,RST+1,(OCTB-1)*12+B_,RST,(OCTB-1)*12+B_,(OCTB-1)*12+B_
.byt OCTB*12+B_,RST,SIL,RST,(OCTB-1)*12+B_,RST+1,(OCTB-1)*12+B_,(OCTB-1)*12+B_
.byt OCTB*12+B_,OCTB*12+B_,RST,OCTB*12+B_,RST+2,SIL,RST
.byt END

ton_bass1
.byt OCTB*12+B_,OCTB*12+B_,RST,OCTB*12+B_,RST,SIL,RST+1,OCTB*12+E_
.byt RST,OCTB*12+E_,RST,SIL,RST,OCTB*12+E_,OCTB*12+E_,RST,SIL,RST
.byt END

ton_bass2
.byt OCTB*12+A_,OCTB*12+A_,RST,OCTB*12+A_,RST,SIL,RST+1,OCTD*12+E_
.byt RST,OCTB*12+D_,RST,SIL,RST,OCTB*12+CS_,OCTB*12+CS_,RST,SIL,RST
.byt END


ton_wait
;.byt RST+7
;.byt RST+7
.byt RST+7
.byt RST+7, END


#define OCT 5
ton_initA
.byt OCT*12+CS_,RST+6,SIL,RST+11,RST+11
.byt (OCT-1)*12+FS_,RST+6+8,SIL
.byt END

ton_initB
.byt (OCT-1)*12+FS_,RST+6,SIL,RST+11,RST+11
.byt END

#define OCTM 4
ton_main0
.byt OCTM*12+FS_,OCTM*12+FS_,OCTM*12+D_,(OCTM-1)*12+B_,RST,(OCTM-1)*12+B_,RST,OCTM*12+E_
.byt RST,OCTM*12+E_,RST,OCTM*12+E_,OCTM*12+GS_,OCTM*12+GS_,OCTM*12+A_,OCTM*12+B_

.byt OCTM*12+A_,OCTM*12+A_,OCTM*12+A_,OCTM*12+E_,RST,OCTM*12+D_,RST,OCTM*12+FS_
.byt RST,OCTM*12+FS_,RST,OCTM*12+FS_,OCTM*12+E_,OCTM*12+E_,OCTM*12+FS_,OCTM*12+E_

.byt END

/*
ton_main1
.byt OCTM*12+A_,OCTM*12+A_,OCTM*12+A_,OCTM*12+FS_,RST,OCTM*12+D_,RST,OCTM*12+FS_
.byt RST,OCTM*12+FS_,RST,OCTM*12+FS_,OCTM*12+E_,OCTM*12+E_,OCTM*12+E_,(OCTM-1)*12+B_

;.byt OCTM*12+D_,RST,SIL,RST,OCTM*12+D_,OCTM*12+D_,OCTM*12+CS_,OCTM*12+B_,RST+1; One extra
;.byt SIL,RST+6

.byt END
*/
__TakeOnMe_end




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Walking on Sunshine

__Walking_start
; Header: Tempo, pointers to patterns and pointers to pattern lists
.byt 6
.byt <wspattern_list_lo,>wspattern_list_lo,<wspattern_list_hi,>wspattern_list_hi
.byt <_Tune10A, >_Tune10A, <_Tune10B, >_Tune10B, <_Tune10C, >_Tune10C

_Tune10A 	.byt ORN, 0, ENV, 2, SETVOL,2, 	3,3,		2, 	LOOP,8, END
_Tune10B	.byt ORN, /*4*/1, ENV, 2, SETVOL,1,	3,3,3,3, 		4,4,		LOOP, 8, END
_Tune10C	.byt ORN, 1, ENV, 4, NVAL,7, 	0,0,0,1, 			LOOP, 4, END


wspattern_list_lo 
	.byt <ws_drums0,<ws_drums1,<ws_synth0,<ws_wait,<ws_main0
wspattern_list_hi 
	.byt >ws_drums0,>ws_drums1,>ws_synth0,>ws_wait,>ws_main0

#define OCTM (4+1)
#define OCTD 2
#define OCT (4-1)

ws_drums0
.byt OCTD*12+C_,RST,PNON,OCTD*12+E_,RST,PNOFF,OCTD*12+C_,RST,PNON,OCTD*12+E_,PNOFF,OCTD*12+C_,RST,OCTD*12+C_,PNON,OCTD*12+E_,PNOFF,OCTD*12+C_,OCTD*12+C_,RST,PNON,OCTD*12+E_,RST,PNOFF
.byt END

ws_drums1
.byt OCTD*12+C_,RST,PNON,OCTD*12+E_,RST,PNOFF,OCTD*12+C_,RST,PNON,OCTD*12+E_,PNOFF,OCTD*12+C_,RST,OCTD*12+C_,PNON,OCTD*12+E_,PNOFF,OCTD*12+C_,OCTD*12+C_,PNON,OCTD*12+E_,OCTD*12+E_,PNOFF,RST
.byt END


ws_synth0
.byt OCT*12+GS_,RST,OCT*12+GS_,RST,OCT*12+GS_,RST,(OCT-1)*12+B_,(OCT)*12+A_,RST,(OCT)*12+A_,(OCT)*12+A_,SIL,RST,(OCT)*12+A_,(OCT)*12+A_,(OCT)*12+A_,(OCT)*12+A_    ;,RST,(OCT)*12+A_,RST,(OCT)*12+A_,RST ;,(OCT)*12+A_,RST
.byt OCT*12+B_,RST,OCT*12+B_,RST,OCT*12+B_,RST,OCT*12+DS_,OCT*12+A_,RST,OCT*12+A_,RST,OCT*12+A_,OCT*12+A_,RST,OCT*12+A_,RST
.byt END

ws_wait
.byt RST+7,RST+7,RST+7,RST+7,END

ws_main0

.byt OCTM*12+E_,RST+2,SIL,RST+4,/*OCTM*12+E_,RST,OCTM*12+CS_,(OCTM-1)*12+GS_,RST,*/OCTM*12+CS_,OCTM*12+CS_,OCTM*12+CS_,OCTM*12+CS_,RST,OCTM*12+CS_,RST+1
.byt OCTM*12+DS_,RST,OCTM*12+DS_,OCTM*12+DS_,OCTM*12+DS_,OCTM*12+D_,OCTM*12+CS_,RST+2,SIL,RST+4

.byt END



__Walking_end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Big in Japan 

__BigInJapan_start
; Header: Tempo, pointers to patterns and pointers to pattern lists
.byt 6
.byt <bjpattern_list_lo,>bjpattern_list_lo,<bjpattern_list_hi,>bjpattern_list_hi
.byt <_Tune11A, >_Tune11A, <_Tune11B, >_Tune11B, <_Tune11C, >_Tune11C

_Tune11A 	.byt ORN, 1, ENV, 2, SETVOL,1, 	3,ENV, 3,3,5, 	LOOP,6+1, END
_Tune11B	.byt ORN, 1, ENV, 5, SETVOL,1,	4,4,2,2,		LOOP, 6+2, END
_Tune11C	.byt ORN, 1, ENV, 4, NVAL,7-3, 	4,4,0,0,0,0,0,0,0,1, 			LOOP, 6+2, END


bjpattern_list_lo 
	.byt <bj_drums0,<bj_drums1,<bj_synth0,<bj_main0,<bj_wait,<bj_main1
bjpattern_list_hi 
	.byt >bj_drums0,>bj_drums1,>bj_synth0,>bj_main0,>bj_wait,>bj_main1

#define OCTM (4)
#define OCTD 1
#define OCT (4-1)

bj_drums0
.byt OCTD*12+B_,RST+1,OCTD*12+B_,PNON,OCTD*12+D_,RST,SIL,RST+1,PNOFF
.byt END

bj_drums1
.byt OCTD*12+B_,RST+1,OCTD*12+B_,PNON,OCTD*12+D_,RST,OCTD*12+D_,RST,PNOFF
.byt END


bj_synth0
.byt OCT*12+D_,OCT*12+D_,RST,OCT*12+D_,OCT*12+D_,RST,OCT*12+D_,OCT*12+D_,OCT*12+D_,OCT*12+D_,RST,OCT*12+D_,OCT*12+D_,RST,OCT*12+D_,OCT*12+D_
.byt (OCT-1)*12+AS_,(OCT-1)*12+AS_,RST,(OCT-1)*12+AS_,(OCT-1)*12+AS_,RST,(OCT-1)*12+AS_,(OCT-1)*12+AS_,(OCT-1)*12+AS_,(OCT-1)*12+AS_,RST,(OCT-1)*12+AS_,(OCT-1)*12+AS_,RST,(OCT-1)*12+AS_,(OCT-1)*12+AS_
.byt OCT*12+C_,OCT*12+C_,RST,OCT*12+C_,OCT*12+C_,RST,OCT*12+C_,OCT*12+C_,OCT*12+C_,OCT*12+C_,RST,OCT*12+C_,OCT*12+C_,RST,OCT*12+C_,OCT*12+C_

.byt (OCT-1)*12+A_,(OCT-1)*12+A_,RST,(OCT-1)*12+A_,(OCT-1)*12+A_,RST,(OCT-1)*12+A_,(OCT-1)*12+A_,(OCT-1)*12+A_,(OCT-1)*12+A_,RST,(OCT-1)*12+A_,(OCT-1)*12+A_,RST,(OCT-1)*12+A_,(OCT-1)*12+A_
/*
.byt OCT*12+D_,OCT*12+D_,RST,OCT*12+D_,OCT*12+D_,RST,OCT*12+D_,OCT*12+D_,OCT*12+D_,OCT*12+D_,RST,OCT*12+D_,OCT*12+D_,RST,OCT*12+D_,OCT*12+D_
.byt (OCT-1)*12+AS_,(OCT-1)*12+AS_,RST,(OCT-1)*12+AS_,(OCT-1)*12+AS_,RST,(OCT-1)*12+AS_,(OCT-1)*12+AS_,(OCT-1)*12+AS_,(OCT-1)*12+AS_,RST,(OCT-1)*12+AS_,(OCT-1)*12+AS_,RST,(OCT-1)*12+AS_,(OCT-1)*12+AS_

.byt OCT*12+C_,OCT*12+C_,RST,OCT*12+C_,OCT*12+C_,RST,OCT*12+C_,OCT*12+C_,OCT*12+C_,OCT*12+C_,RST,OCT*12+C_,OCT*12+C_,RST,OCT*12+C_,OCT*12+C_
;.byt (OCT-1)*12+AS_,(OCT-1)*12+AS_,RST,(OCT-1)*12+AS_,(OCT-1)*12+AS_,RST,(OCT-1)*12+AS_,(OCT-1)*12+AS_,(OCT-1)*12+AS_,(OCT-1)*12+AS_,RST,(OCT-1)*12+AS_,(OCT-1)*12+AS_,RST,(OCT-1)*12+AS_,(OCT-1)*12+AS_
.byt (OCT-1)*12+A_,(OCT-1)*12+A_,RST,(OCT-1)*12+A_,(OCT-1)*12+A_,RST,(OCT-1)*12+A_,(OCT-1)*12+A_,(OCT-1)*12+A_,(OCT-1)*12+A_,RST,(OCT-1)*12+A_,(OCT-1)*12+A_,RST,(OCT-1)*12+A_,(OCT-1)*12+A_
;.byt SIL,RST+15
*/
.byt END


bj_wait
.byt RST+15,END

bj_main0

.byt OCTM*12+F_,RST,OCTM*12+D_,RST,OCTM*12+C_,OCTM*12+C_,OCTM*12+D_,OCTM*12+F_,RST+1,SIL,RST+5
.byt OCTM*12+F_,RST,OCTM*12+D_,RST,OCTM*12+C_,OCTM*12+C_,OCTM*12+D_,OCTM*12+G_,RST+1,SIL,RST+1,OCTM*12+F_,RST+2
.byt END

bj_main1
.byt OCTM*12+F_,RST,OCTM*12+D_,RST,OCTM*12+C_,OCTM*12+C_,OCTM*12+D_,OCTM*12+F_,OCTM*12+F_,OCTM*12+D_,OCTM*12+C_,RST,OCTM*12+D_,RST,SIL,RST+1

.byt OCTM*12+A_,RST,OCTM*12+A_,RST,OCTM*12+A_,RST,(OCTM+1)*12+C_,RST,(OCTM+1)*12+C_,RST,(OCTM+1)*12+C_,RST,SIL,RST+3
.byt OCTM*12+F_,RST,OCTM*12+D_,RST,OCTM*12+C_,OCTM*12+C_,OCTM*12+D_,OCTM*12+F_,OCTM*12+F_,OCTM*12+D_,OCTM*12+C_,RST,OCTM*12+D_,RST,SIL,RST+1
.byt OCTM*12+F_,RST,OCTM*12+D_,RST,OCTM*12+C_,OCTM*12+C_,OCTM*12+D_,OCTM*12+G_,SIL,RST,OCTM*12+G_,RST,OCTM*12+G_,OCTM*12+F_,OCTM*12+F_,RST,SIL,RST

.byt OCTM*12+F_,RST,OCTM*12+D_,RST,OCTM*12+C_,OCTM*12+C_,OCTM*12+D_,OCTM*12+F_,OCTM*12+F_,OCTM*12+D_,OCTM*12+C_,RST,OCTM*12+D_,RST,SIL,RST+1
.byt OCTM*12+A_,RST,OCTM*12+A_,RST,OCTM*12+A_,RST,OCTM*12+A_,RST,OCTM*12+G_,(OCTM+1)*12+C_,OCTM*12+G_,OCTM*12+A_,RST+3,SIL

;.byt SIL,RST+15

.byt END



__BigInJapan_end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Blue Monday

__BlueMonday_start
; Header: Tempo, pointers to patterns and pointers to pattern lists
.byt 5
.byt <bmpattern_list_lo,>bmpattern_list_lo,<bmpattern_list_hi,>bmpattern_list_hi
.byt <_Tune12A, >_Tune12A, <_Tune12B, >_Tune12B, <_Tune12C, >_Tune12C

_Tune12A 	.byt ORN, 2, ENV, 06,SETVOL,2, 								                3,3,3,3,3,2, 	LOOP,9+2, END
_Tune12B	.byt ORN, 1, ENV, 4-4, SETVOL,10,	1,SETVOL,5, 6,SETVOL,3, 1,SETVOL,1,       6,1,6,1,	LOOP, 15, END
_Tune12C	.byt ORN, 1, ENV, 4, NVAL,20,NOFF, 							            0,0,0,0,0,0, 	LOOP, 6+1, END


bmpattern_list_lo 
	.byt <bm_drums0,<bm_synth0,<bm_main0,<bm_wait,<bm_main1,<bm_drums1,<bm_synth1
bmpattern_list_hi 
	.byt >bm_drums0,>bm_synth0,>bm_main0,>bm_wait,>bm_main1,>bm_drums1,>bm_synth1

#define OCTM (2)
#define OCTD 1
#define OCT (4)

bm_drums0
.byt OCTD*12+C_,RST,SIL,RST+1,OCTD*12+C_,RST,SIL,RST+1,OCTD*12+C_,OCTD*12+C_,OCTD*12+C_,OCTD*12+C_,OCTD*12+C_,OCTD*12+C_,OCTD*12+C_,OCTD*12+C_
.byt OCTD*12+C_,RST,SIL,RST+1,OCTD*12+C_,RST,SIL,RST+1,OCTD*12+C_,RST,SIL,RST+1,OCTD*12+C_,RST,SIL,RST+1
.byt END

bm_drums1
.byt OCTD*12+B_,RST+1,OCTD*12+B_,PNON,OCTD*12+D_,RST,OCTD*12+D_,RST,PNOFF
.byt END


bm_synth0
/*.byt OCT*12+F_,OCT*12+F_,OCT*12+F_,RST+2, OCT*12+G_,OCT*12+G_,OCT*12+C_,RST+2, OCT*12+C_,OCT*12+C_,OCT*12+D_,SIL,RST
.byt OCT*12+D_,OCT*12+D_,OCT*12+D_,RST+2, OCT*12+D_,OCT*12+D_,OCT*12+D_,RST+2, OCT*12+D_,OCT*12+D_,RST+1
*/

/*
.byt RST+1,OCT*12+F_,RST,OCT*12+F_,RST+2,OCT*12+C_,RST,OCT*12+C_,RST+2,OCT*12+D_,RST,SIL
.byt OCT*12+D_,RST+2,OCT*12+D_,RST,OCT*12+D_,RST+2,OCT*12+D_,RST,OCT*12+D_,RST+2,SIL
*/

.byt OCT*12+F_,OCT*12+F_,OCT*12+F_,RST,OCT*12+F_,RST,OCT*12+G_,OCT*12+G_,OCT*12+C_,RST,OCT*12+C_,RST,OCT*12+D_,OCT*12+D_,OCT*12+D_,RST,SIL
.byt OCT*12+D_,RST,OCT*12+D_,OCT*12+D_,OCT*12+D_,RST,OCT*12+D_,RST,OCT*12+D_,OCT*12+D_,OCT*12+D_,RST,OCT*12+D_,RST,OCT*12+D_,OCT*12+D_,SIL

.byt END

bm_synth1
.byt OCT*12+F_,RST,OCT*12+F_,RST,OCT*12+F_,OCT*12+G_,OCT*12+G_,RST,OCT*12+C_,RST,OCT*12+C_,OCT*12+C_,OCT*12+C_,RST,OCT*12+D_,RST
.byt OCT*12+D_,RST,OCT*12+D_,OCT*12+D_,OCT*12+D_,RST,OCT*12+D_,RST,OCT*12+D_,OCT*12+D_,OCT*12+D_,RST,OCT*12+D_,RST,OCT*12+D_,OCT*12+D_,SIL

.byt END

bm_wait
.byt RST+15,RST+15,END

bm_main0
.byt OCTM*12+F_,RST,OCTM*12+F_,OCTM*12+F_,OCTM*12+F_,OCTM*12+F_,OCTM*12+F_,OCTM*12+C_,SIL,RST+1,OCTM*12+C_,OCTM*12+C_,OCTM*12+C_,RST,OCTM*12+C_,OCTM*12+C_
.byt OCTM*12+D_,RST,OCTM*12+D_,OCTM*12+D_,OCTM*12+D_,OCTM*12+D_,OCTM*12+D_,OCTM*12+D_,SIL,RST+1,OCTM*12+D_,OCTM*12+D_,OCTM*12+D_,RST,OCTM*12+D_,OCTM*12+D_
.byt OCTM*12+G_,RST,OCTM*12+G_,OCTM*12+G_,OCTM*12+G_,OCTM*12+G_,OCTM*12+G_,OCTM*12+G_,SIL,RST+1,OCTM*12+G_,OCTM*12+G_,OCTM*12+G_,RST,OCTM*12+G_,OCTM*12+G_
.byt OCTM*12+D_,RST,OCTM*12+D_,OCTM*12+D_,OCTM*12+D_,OCTM*12+D_,OCTM*12+D_,OCTM*12+D_,SIL,RST+1,OCTM*12+D_,OCTM*12+D_,OCTM*12+D_,RST,OCTM*12+D_,OCTM*12+D_

/*
.byt OCTM*12+D_,OCTM*12+D_,OCTM*12+D_,OCTM*12+D_,RST+3,OCTM*12+D_,OCTM*12+D_,OCTM*12+D_,OCTM*12+D_,OCTM*12+D_,OCTM*12+D_,OCTM*12+D_,OCTM*12+D_
.byt OCTM*12+G_,OCTM*12+G_,OCTM*12+G_,OCTM*12+G_,RST+3,OCTM*12+G_,OCTM*12+G_,OCTM*12+G_,OCTM*12+G_,OCTM*12+G_,OCTM*12+G_,OCTM*12+G_,OCTM*12+G_
.byt OCTM*12+D_,OCTM*12+D_,OCTM*12+D_,OCTM*12+D_,RST+3,OCTM*12+D_,OCTM*12+D_,OCTM*12+D_,OCTM*12+D_,OCTM*12+D_,OCTM*12+D_,OCTM*12+D_,OCTM*12+D_
*/
.byt END

bm_main1
.byt END



__BlueMonday_end


__LessonsInLove_start
; Header: Tempo, pointers to patterns and pointers to pattern lists
.byt 5
;.byt 15
.byt <llpattern_list_lo,>llpattern_list_lo,<llpattern_list_hi,>llpattern_list_hi
.byt <_Tune6A, >_Tune6A, <_Tune6B, >_Tune6B, <_Tune6C, >_Tune6C

_Tune6A .byt ORN, 1, ENV, 2, SETVOL,2,		5,5,0,ORN, 1, ENV, 0, SETVOL,2,			0,0,0,0,0,4,9,			LOOP,21,	END
_Tune6B	.byt ORN, 1, ENV, 2, SETVOL,2,		6,6,0,ORN, 2, ENV, 3, SETVOL,3,			2,3,3,3,3, 				LOOP,16,END
_Tune6C	.byt ORN, 1, ENV, 2, SETVOL,2, 		7,7,ENV, 3, ORN, 1,8,ORN, 3, ENV, 4, SETVOL,0, 			1,	LOOP,17+2,			END
5

llpattern_list_lo 
	.byt <ll_wait,<ll_drums0,<ll_p0,<ll_p1,<ll_pm0,<ll_init1,<ll_init2,<ll_init3,<ll_init4,<ll_pm1
llpattern_list_hi 
	.byt >ll_wait,>ll_drums0,>ll_p0,>ll_p1,>ll_pm0,>ll_init1,>ll_init2,>ll_init3,>ll_init4,>ll_pm1

#define OCTI 4
ll_init1
.byt OCTI*12+GS_,RST+3+2, OCTI*12+A_,RST+4+3/*, OCTI*12+D_,RST+3+2*/
.byt OCTI*12+A_,RST+14
.byt END

ll_init2
.byt OCTI*12+E_,RST+14
.byt OCTI*12+C_,RST+14
.byt END

ll_init3
.byt (OCTI-1)*12+E_,RST+3+2, (OCTI-1)*12+D_,RST+4+3/*, RST+4+2*/
.byt (OCTI-1)*12+C_,RST+14
.byt END

ll_init4
.byt SIL,(OCTI+1)*12+G_,RST,(OCTI+1)*12+FS_,RST,(OCTI+1)*12+E_,RST,(OCTI)*12+G_,RST,(OCTI)*12+G_,RST+3+3,END

ll_wait
.byt SIL,RST+15,END

#define OCTD 1
ll_drums0
/*
.byt PNON,OCTD*12+FS_,PNOFF,OCTD*12+FS_,OCTD*12+FS_,OCTD*12+FS_
.byt PNON,OCTD*12+FS_,PNOFF,OCTD*12+FS_,OCTD*12+FS_,OCTD*12+FS_
.byt PNON,OCTD*12+FS_,PNOFF,OCTD*12+FS_,OCTD*12+FS_,OCTD*12+FS_
.byt PNON,OCTD*12+FS_,PNOFF,OCTD*12+FS_,OCTD*12+FS_,OCTD*12+FS_
*/
.byt OCTD*12+FS_,RST+2
.byt OCTD*12+FS_,RST+2
.byt OCTD*12+FS_,RST+2
.byt OCTD*12+FS_,RST+2

.byt END

#define OCT 2
ll_p0
.byt OCT*12+G_,RST,OCT*12+G_,OCT*12+G_,OCT*12+G_,RST,OCT*12+G_,OCT*12+G_
.byt OCT*12+G_,RST,OCT*12+G_,OCT*12+G_,OCT*12+G_,RST,OCT*12+G_,RST
.byt END

ll_p1
.byt OCT*12+G_,RST,OCT*12+G_,OCT*12+G_,OCT*12+B_,RST,OCT*12+B_,OCT*12+B_
.byt (OCT+1)*12+D_,RST,(OCT+1)*12+D_,(OCT+1)*12+D_,(OCT+1)*12+G_,RST,(OCT+1)*12+G_,(OCT+1)*12+G_

.byt (OCT+1)*12+B_,RST,(OCT+1)*12+B_,(OCT+1)*12+B_,(OCT+1)*12+DS_,RST,(OCT+1)*12+DS_,(OCT+1)*12+DS_
.byt (OCT+1)*12+FS_,RST,(OCT+1)*12+FS_,(OCT+1)*12+FS_,(OCT+1)*12+B_,RST,(OCT+1)*12+B_,(OCT+1)*12+B_

.byt (OCT)*12+E_,RST,(OCT)*12+E_,(OCT)*12+E_,(OCT)*12+G_,RST,(OCT)*12+G_,(OCT)*12+G_
.byt (OCT)*12+B_,RST,(OCT)*12+B_,(OCT)*12+B_,(OCT)*12+E_,RST,(OCT)*12+E_,(OCT)*12+E_

.byt (OCT)*12+C_,RST,(OCT)*12+C_,(OCT)*12+C_,(OCT)*12+E_,RST,(OCT)*12+E_,(OCT)*12+E_
.byt (OCT)*12+G_,RST,(OCT)*12+G_,(OCT)*12+G_,(OCT+1)*12+C_,RST,(OCT+1)*12+C_,(OCT+1)*12+C_


.byt END

#define OCTM 4
ll_pm0
.byt OCTM*12+G_,RST+2,SIL,RST+3,OCTM*12+G_,RST+2,OCTM*12+A_,RST+2
.byt OCTM*12+FS_,RST+2,SIL,RST+1,OCTM*12+B_,RST+2,OCTM*12+A_,RST+2,OCTM*12+G_,RST+4
.byt SIL,RST+3,OCTM*12+A_,RST+2,OCTM*12+B_,RST+2
.byt END

ll_pm1
.byt (OCTM+1)*12+C_,RST+2,OCTM*12+G_,RST,(OCTM+1)*12+C_,RST+2,(OCTM+1)*12+D_,RST+2,OCTM*12+B_,RST+4
.byt SIL,RST+3,OCTM*12+B_,RST+2,OCTM*12+D_,RST+2
.byt (OCTM+1)*12+DS_,RST+2,OCTM*12+B_,RST,OCTM*12+A_,RST+2,OCTM*12+B_,RST+2,OCTM*12+G_,RST+4
.byt SIL,RST+3,OCTM*12+A_,RST+2,OCTM*12+B_,RST+2
.byt (OCTM+1)*12+C_,RST+2,OCTM*12+G_,RST,(OCTM+1)*12+C_,RST+2,(OCTM+1)*12+D_,RST+2,OCTM*12+B_,OCTM*12+A_
.byt OCTM*12+G_,RST+4,SIL,RST+1,OCTM*12+G_,RST+2,OCTM*12+A_,RST+2
.byt OCTM*12+FS_,RST+4,OCTM*12+B_,RST+2,OCTM*12+A_,RST+2,OCTM*12+G_,RST+4
.byt SIL,RST+3,OCTM*12+A_,RST+2,OCTM*12+B_,RST+2
.byt END


.byt END


__LessonsInLove_end


__Stay_start
; Header: Tempo, pointers to patterns and pointers to pattern lists
.byt 14
.byt <spattern_list_lo,>spattern_list_lo,<spattern_list_hi,>spattern_list_hi
.byt <_Tune5A, >_Tune5A, <_Tune5B, >_Tune5B, <_Tune5C, >_Tune5C

_Tune5A .byt ORN, 2, ENV, 1, SETVOL,4,				0,2,  2,  2,  2,			 2,  2,  2,  0,0,		LOOP,0,END
_Tune5B	.byt ORN, 1, ENV, 2, SETVOL,2,				3,						  			 		 	    		LOOP,0,END
_Tune5C	.byt ORN, 3, ENV, 4,NVAL, 1,SETVOL,4, 		0,1,1,1,1,1,1,1,SETVOL,0, 4,SETVOL,3,1,1,1,1,1,1,SETVOL,0,NVAL,8,5,4,		LOOP,0,END


spattern_list_lo 
	.byt <s_wait,<s_drums0,<s_p0,<s_m0,<s_drums1,<s_drums2
spattern_list_hi 
	.byt >s_wait,>s_drums0,>s_p0,>s_m0,>s_drums1,>s_drums2


s_wait
.byt SIL,RST+7,END

#define OCTD 2
s_drums0
.byt PNON,OCTD*12+FS_,PNOFF,OCTD*12+FS_,PNON,OCTD*12+FS_,OCTD*12+FS_,PNOFF
.byt PNON,OCTD*12+FS_,PNOFF,OCTD*12+FS_,PNON,OCTD*12+FS_,OCTD*12+FS_,PNOFF
.byt END

s_drums1
.byt OCTD*12+E_,OCTD*12+E_,OCTD*12+E_,OCTD*12+E_
.byt OCTD*12+C_,OCTD*12+C_,OCTD*12+C_,PNON,OCTD*12+A_,PNOFF
.byt END

s_drums2
.byt PNON,OCTD*12+E_,OCTD*12+B_,OCTD*12+CS_,PNOFF,RST+4
.byt END

#define OCT 2
s_p0
.byt OCT*12+G_,RST,SIL,RST,OCT*12+G_,OCT*12+E_,RST+1,OCT*12+E_,SIL
.byt OCT*12+C_,OCT*12+C_,RST,SIL,OCT*12+C_,OCT*12+D_,RST+1,OCT*12+D_
.byt END


#define OCTM 4

s_m0
.byt RST+5,OCTM*12+G_,OCTM*12+G_
.byt OCTM*12+G_,RST+6
.byt RST+1,OCTM*12+G_,OCTM*12+G_,OCTM*12+FS_,OCTM*12+G_,OCTM*12+A_,OCTM*12+G_

.byt OCTM*12+B_,RST,OCTM*12+G_,RST+4
.byt RST+4,OCTM*12+B_,OCTM*12+A_,OCTM*12+G_
.byt OCTM*12+G_,RST+2,OCTM*12+B_,RST+2

.byt SIL,RST,OCTM*12+G_,RST,OCTM*12+G_,OCTM*12+FS_,OCTM*12+G_,OCTM*12+A_,OCTM*12+G_
.byt OCTM*12+B_,RST+2,OCTM*12+G_,RST+2

.byt SIL,RST+5,OCTM*12+D_,OCTM*12+D_ 
.byt OCTM*12+B_,OCTM*12+G_,OCTM*12+A_,OCTM*12+E_,OCTM*12+G_,RST+2
.byt SIL,RST+5,OCTM*12+D_,OCTM*12+D_ 
.byt OCTM*12+B_,OCTM*12+G_,OCTM*12+A_,OCTM*12+E_,OCTM*12+G_,RST+2  

.byt SIL,RST+5,OCTM*12+D_,OCTM*12+D_ 
.byt OCTM*12+B_,OCTM*12+G_,OCTM*12+A_,OCTM*12+E_,OCTM*12+G_,SIL,RST,OCTM*12+E_,OCTM*12+D_
.byt OCTM*12+B_,OCTM*12+G_,OCTM*12+A_,OCTM*12+E_,OCTM*12+G_,SIL,RST,OCTM*12+E_,OCTM*12+D_

.byt RST+1,(OCTM+1)*12+E_,RST+2,OCTM*12+B_,OCTM*12+A_,SIL
.byt OCTM*12+G_,RST+2,SIL,RST+3;,(OCTM+1)*12+B_,RST,(OCTM+2)*12+D_,RST,(OCTM+1)*12+B_,RST


.byt END



__Stay_end

