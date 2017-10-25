; Common header
#include "..\params.h"
#include "..\object.h"
#include "..\script.h"
#include "..\resource.h"
#include "..\verbs.h"

*=$500

#include "..\scripts\stringmain.s"

/*
; String resource main
; - Resource type: STRING
; - Resource Size
; - Resource ID
.(
.byt RESOURCE_STRING 
.word res_end-res_start+4
.byt 0
res_start
.asc "That doesn't seem to work.",0
.asc "I can't do that.",0
.asc "I don't know what you mean.",0
.asc "What?!",0
.asc "I don't follow your banter.",0

.asc "Look at what?",0
.asc "Ok I'm looking... oh very nice!",0
.asc "What do you want me to look at?",0
.asc "Can't see anything of interest.",0

.asc "Let's avoid unnecessary violence.",0
res_end
.)

*/

