
#include "..\resource.h"
#include "..\sound.h"
*=$500


; Small tune for final of episode

.(
.byt RESOURCE_MUSIC
.word res_end-res_start+4
.byt 1
res_start

__Blake_start
; Header: Tempo, pointers to patterns and pointers to pattern lists
.byt 6
.byt <(Blpattern_list_lo-__Blake_start), >(Blpattern_list_lo-__Blake_start)
.byt <(Blpattern_list_hi-__Blake_start), >(Blpattern_list_hi-__Blake_start)
.byt <(_TuneCA-__Blake_start),		 >(_TuneCA-__Blake_start)
.byt <(_TuneCB-__Blake_start), 		 >(_TuneCB-__Blake_start)
.byt <(_TuneCC-__Blake_start), 		 >(_TuneCC-__Blake_start)

_TuneCA 	.byt ORN, 1, ENV, 3,  0, END
_TuneCB		.byt ORN, 4, ENV, 3, NOFFSET, 5,  0, END
_TuneCC		.byt ORN, 0, ENV, 5, NOFFSET, 12,  0, END


Blpattern_list_lo 
	.byt <(Bl_main0-__Blake_start)
Blpattern_list_hi 
	.byt >(Bl_main0-__Blake_start)

#define OCTM (4-1)

Bl_main0
.byt (OCTM)*12+CS_,(OCTM)*12+CS_,RST+2,(OCTM-1)*12+B_,(OCTM-1)*12+B_,RST+2
.byt (OCTM)*12+CS_,(OCTM)*12+CS_,/*RST,*/(OCTM-1)*12+B_,(OCTM-1)*12+B_,/*RST,*/(OCTM)*12+CS_,(OCTM)*12+CS_
.byt RST+4
.byt END

__Blake_end

res_end
.)
