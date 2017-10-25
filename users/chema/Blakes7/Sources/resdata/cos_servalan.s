#include "..\resource.h"
#include "..\verbs.h"

*=$500

; Resource data
; This could be the costume resources. Jenna and Blake share tile graphics, so...
; They should include: 
; - Resource Type: COSTUME 
; - Resource ID
; - Offset to tile data
; - Offset to mask data
; - Number of costumes (2 in this case)
; 	- pointer to start of animstates for costume 1
;	- pointer to start of animstates for costume 2
;	- ...

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; COSTUME for Servalan
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#include "..\characters\Servalan\cost_res.s"


