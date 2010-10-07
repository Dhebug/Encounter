;Level Specific Data

;#include "Stormlord_map1.pac"
;#include "Stormlord_map2.pac"
;#include "Stormlord_map3.pac"

LevelStart_MapX
 .byt 42
 .byt 14
 .byt 14
LevelStart_HeroX
 .byt 21
 .byt 26
 .byt 26
LevelStart_Fairies2Collect
 .byt 8
 .byt 4
 .byt 5

TrampolenesLevelID
;Trampolenes to Advance
 .byt 0	;0
 .byt 0	;1
 .byt 0	;2
 .byt 0	;3
 .byt 0	;4 - Final Fairy on Level 0
;Trampolenes to take hero back
 .byt 0	;5
 .byt 0	;6
 .byt 0	;7
 
 .byt 1	;8
 .byt 1	;9
 .byt 1	;10
 .byt 1	;11
 .byt 1	;12
 .byt 1	;13 - Last one is to get from last fairy to bonus level
;Trampolenes to take hero back
 .byt 1	;14
 
 .byt 2	;15
 .byt 2	;16
 .byt 2	;17 - Final Fairy on Level 3
 .byt 255	;18
 .byt 0	;19 - Dummy entry for hitting trampolene when all fairies collected
TrampolenesStartMapX
 .byt 0
 .byt 56
 .byt 182
 .byt 0
 .byt 196	;Final Fairy on Level 0

 .byt $46
 .byt $7E
 .byt $E0

 .byt 0
 .byt 42
 .byt 56
 .byt 112
 .byt 126
 .byt 210
 
 .byt $E0
 
 .byt $8C
 .byt 0
 .byt $E0	;Final Fairy on Level 3
 .byt 0,0
TrampolenesEndMapX
 .byt 84
 .byt 126
 .byt 210
 .byt 0
 .byt 237	;Final Fairy on Level 1
 
 .byt $00
 .byt $46
 .byt $70

 .byt 42
 .byt 0
 .byt 126
 .byt 168
 .byt 84
 .byt 237 ;Final fairy on Level 2
 
 .byt $38
 
 .byt 0
 .byt $8C
 .byt 237	;Final Fairy on Level 3
 .byt 0,0
TrampolenesEndHeroX
 .byt 7
 .byt 26
 .byt 18
 .byt 0
 .byt 20	;Final Fairy on Level 0

 .byt $08
 .byt $1D
 .byt $1C

 .byt 30
 .byt 10
 .byt 20
 .byt 10
 .byt 20
 .byt 20
 
 .byt $1C
 
 .byt 8
 .byt 32
 .byt 20	;Final Fairy on Level 3
 .byt 0,0


