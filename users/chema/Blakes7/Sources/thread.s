;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ------------------------------------------
;;                 OASIS
;; Oric Adventure Script Interpreting System
;; ------------------------------------------
;;	       (c) Chema 2015
;;            enguita@gmail.com
;; ------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Thread management cooperative multithreading
#include "params.h"
#include "debug.h"
#include "script.h"
#include "thread.h"

.zero
lvarp 	.word 0000
lflagp	.word 0000
.text

; META: Maybe these tables should be moved
#if MAX_THREADS <> 16
#error Number of threads changed. Add/remove space from local vars
#endif

lspacep_lo 
.byt <(_LSPACE-200)+LSPACE_S*0, <(_LSPACE-200)+LSPACE_S*1, <(_LSPACE-200)+LSPACE_S*2, <(_LSPACE-200)+LSPACE_S*3
.byt <(_LSPACE-200)+LSPACE_S*4, <(_LSPACE-200)+LSPACE_S*5, <(_LSPACE-200)+LSPACE_S*6, <(_LSPACE-200)+LSPACE_S*7
.byt <(_LSPACE-200)+LSPACE_S*8, <(_LSPACE-200)+LSPACE_S*9, <(_LSPACE-200)+LSPACE_S*10, <(_LSPACE-200)+LSPACE_S*11
.byt <(_LSPACE-200)+LSPACE_S*12, <(_LSPACE-200)+LSPACE_S*13, <(_LSPACE-200)+LSPACE_S*14, <(_LSPACE-200)+LSPACE_S*15

lspacep_hi
.byt >(_LSPACE-200)+LSPACE_S*0, >(_LSPACE-200)+LSPACE_S*1, >(_LSPACE-200)+LSPACE_S*2, >(_LSPACE-200)+LSPACE_S*3
.byt >(_LSPACE-200)+LSPACE_S*4, >(_LSPACE-200)+LSPACE_S*5, >(_LSPACE-200)+LSPACE_S*6, >(_LSPACE-200)+LSPACE_S*7
.byt >(_LSPACE-200)+LSPACE_S*8, >(_LSPACE-200)+LSPACE_S*9, >(_LSPACE-200)+LSPACE_S*10, >(_LSPACE-200)+LSPACE_S*11
.byt >(_LSPACE-200)+LSPACE_S*12, >(_LSPACE-200)+LSPACE_S*13, >(_LSPACE-200)+LSPACE_S*14, >(_LSPACE-200)+LSPACE_S*15


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Initialize the thread engine
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
InitializeThreads
.(
	lda #TH_STATE_EMPTY
	ldx #(MAX_THREADS-1)
loop
	;sta thread_script_id,x
	sta thread_state,x
	dex
	bpl loop

	stx _CurrentThread
	stx override_thread
	inx
	stx _EngineEvents
	rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Update thread pointers
; used after memory compaction
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
UpdateThreadPointers
.(
	ldx #MAX_THREADS-1
loop
	lda thread_state,x
	;cmp #TH_STATE_EMPTY
	beq next_thread ; Thread is empty
	
	; There is a script here, get type
	; to decide if it is a normal script
	; or object code.
	stx sav+1
	lda thread_script_type,x	
	pha
	lda thread_script_id,x	
	tax
	pla
	jsr GetPointerToResource
#ifdef DOCHECKS_B
	; Something nasty happened!!! throw an exception
	bne found
	lda #ERR_NOSCRIPT
	jsr catchEngineException
	rts
found	
#endif	
	; We have the pointer to the resource, add the header size and 
	; also skip the id to get a pointer to the start of the 
	; code to run
	ldy tmp0+1
	lda tmp0
	clc
	adc #RESOURCE_HEADER_SIZE+1	; Skip ID
	bcc skip
	iny
skip
	
	; And update the pointer fields for the thread
sav	
	ldx #0	
	sta thread_script_pt_lo,x
	tya
	sta thread_script_pt_hi,x
next_thread
	dex
	bpl loop
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Loops through the current threads
; running them if necessary
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
doThreadLoop
.(
	lda #MAX_THREADS-1
	sta counter
loop
	ldx counter
	lda thread_state,x
	;cmp #TH_STATE_EMPTY
	beq next_thread	; Thread is empty
	
	cmp #TH_STATE_PENDED
	beq next_thread	; Thread is pended

	cmp #TH_STATE_FROZEN
	beq next_thread	; Thread is frozen
	
	cmp #TH_STATE_WAITING
	bne notwaiting
	
	; Thread is waiting for event... check
	lda _EngineEvents
	and thread_event_mask,x
	beq next_thread	; Event not flagged yet
	bne settorun ; This always jumps	
notwaiting	
	cmp #TH_STATE_DELAYED
	bne notdelayed

/*	
	lda thread_timeout,x
	sec
	sbc LastFrameTime
	bpl noadj
	lda #0
noadj
	sta thread_timeout,x
*/	
	dec thread_timeout,x 
	bne next_thread	; Still Delayed
settorun	
	; Time to run thread
	lda #TH_STATE_RUNNING
	sta thread_state,x
notdelayed
	; Thread must be running if arrived here
	
	; Set it as current thread
	stx _CurrentThread
	
	; Switch context: this means
	; setting pointers to the current
	; local data space.
	lda lspacep_lo,x
	sta lvarp
	lda lspacep_hi,x
	sta lvarp+1
	
	clc
	lda #<(14+200-25)
	adc lvarp
	sta lflagp
	lda #>(14+200-25)
	adc lvarp+1
	sta lflagp+1
	
	; Switch control to thread
	jsr ExecuteThread
	lda #$ff
	sta _CurrentThread
	
	; Not running
next_thread
	dec counter
	bpl loop
	rts

counter .byt 0
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Runs a thread passed in reg X
; until de-scheduled. Used in entry and
; exit scripts to ensure they are given
; the chance to run in the frame they are
; loaded.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RunThreadOnce
.(
#ifdef DOCHECKS_A
	cpx #$ff
	beq end
	lda thread_state,x
	beq end
#endif 
	lda _CurrentThread
	pha
	stx _CurrentThread
	jsr ExecuteThread
	pla
	sta _CurrentThread
end	
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Runs current thread until de-scheduled
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ExecuteThread
.(
	; Get next command
	ldx _CurrentThread
	cpx #$ff
	; Something happened... probably a load game
	; Get rid of context and hopefully return safely
	; to the main loop
	bne cont
	pla
	pla
	rts
cont
	clc
	lda thread_offset_lo,x
	adc thread_script_pt_lo,x
	sta tmp0
	lda thread_offset_hi,x
	adc thread_script_pt_hi,x
	sta tmp0+1
	
	ldy #0
	lda (tmp0),y		; Get current command
	tay
	sta LastCommandCalled
	lda #$ff
	sta LastFunctionCalled
	lda commands_lo,y	; and its execution address
	sta exec_address+1
	lda commands_hi,y
	sta exec_address+2
	
	; Run script command
exec_address
	jsr $1234
	
	; Next command
	jmp ExecuteThread
.)


;;;;;;;;;;;;;;;;;;;;;;;;;
; Searchs for a script
; of ID passed in reg A
; and type script, and
; returns its thread id
; in reg X or $ff
; if not found.
;;;;;;;;;;;;;;;;;;;;;;;;
searchScriptID
.(
	sta id+1
	ldx #MAX_THREADS-1
loop
	lda thread_state,x
	beq notthis
id	
	lda #0
	cmp thread_script_id,x
	bne notthis
	lda #RESOURCE_SCRIPT
	cmp thread_script_type,x	
	beq found
notthis	
	dex
	bpl loop	
found	
	rts	
.)


; Parameters:  script id, parent thread, pointer to script (low), 
; pointer to script (high), script type
; For InstallScriptAtOffset offset (low) and offset (high)
; param_blk .dsb 7 ; Moved to data.s

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Loads a script and installs it 
; Params: reg X=script ID, Y=parent
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
LoadAndInstallScript
.(
	stx param_blk
	sty param_blk+1
	jsr LoadScript
error	
	beq error	
	sta param_blk+2
	sty param_blk+3
	lda #RESOURCE_SCRIPT
	sta param_blk+4	
	
	; Execution flow goes into InstallScript
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Looks for an empty entry in the
; thread list and installs a script
; there.
; Params: param block
; Returns X=$ff if not found, assigned
; id if found.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
InstallScript
.(
	ldx #MAX_THREADS-1
loop
	lda thread_state,x
	beq found
	dex
	bpl loop
	; Not found
	rts
found	
	; Found
	; Initialize fields
	lda #0
	sta thread_timeout,x
	sta thread_offset_hi,x
	sta thread_offset_lo,x
	sta thread_event_mask,x
	; Set thread as running
	lda #TH_STATE_RUNNING
	sta thread_state,x

	; Store data in parameter block
	lda param_blk
	sta thread_script_id,x		
	lda param_blk+1
	sta thread_parent_thread,x	
	lda param_blk+2
	sta thread_script_pt_lo,x
	lda param_blk+3
	sta thread_script_pt_hi,x
	lda param_blk+4
	sta thread_script_type,x
	
	; done.
	rts
.)

InstallScriptAtOffset
.(
	jsr InstallScript
+SetScriptOffsetFromParam	
	lda param_blk+5
	sta thread_offset_lo,x
	lda param_blk+6
	sta thread_offset_hi,x
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Unattach script from a given thread, passed
; in reg X (which is preserved).
; Marks thread as empty, wakes-up parent
; and Nukes the script
; TODO: Should also empty local data
; and maybe make sure there is not another
; copy of the script running before Nuking
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PurgeScript
.(
	stx savx+1
	; Set as empty
	lda #TH_STATE_EMPTY
	sta thread_state,x
	; Check if override_thread was this one
	cpx override_thread
	bne skipov
	lda #$ff
	sta override_thread
skipov
	; Wake up parent
	lda thread_parent_thread,x
	cmp #$ff
	beq skip
	tax
	lda thread_state,x
	cmp #TH_STATE_PENDED
	bne skip2  ; Not pending
	lda #TH_STATE_RUNNING
	sta thread_state,x
skip2	
savx
	ldx #0
skip
	; Get type and ID to Nuke resource
	lda thread_script_type,x
	pha
	lda thread_script_id,x
	tax
	pla
	jsr NukeResource
	ldx savx+1
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Stop and purge local scripts
; We don't need to Nuke scripts here because
; This is used when deleting all the local 
; resources.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PurgeLocalScripts
.(
	ldx #MAX_THREADS-1
loop
	; If it is not the thread currently running
	; (would create an error if called inside a local script
	; which is something I can't see why anybody would do
	; anyway...)
	;cpx _CurrentThread
	;beq skip

	; If the thread is not empty
	lda thread_state,x
	beq skip		; Empty is zero
	; And it contains a local script (or code of local object)
	lda thread_script_id,x
	cmp #RESOURCE_LOCALS_START
	bcc skip
	; Purge the script (old version just set the state as EMPTY)
	jsr PurgeScript
skip
	dex
	bpl loop

	rts
.)	

