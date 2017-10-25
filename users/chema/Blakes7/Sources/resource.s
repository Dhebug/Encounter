;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ------------------------------------------
;;                 OASIS
;; Oric Adventure Script Interpreting System
;; ------------------------------------------
;;	       (c) Chema 2015
;;            enguita@gmail.com
;; ------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Resource managing 

; Each resource is stored in memory with the    	
; following header:					    	
; 1 byte: Type (bits 0 to 6) and status (bit 7) 	
; 2 byte: size							 
; Status bit 1 means resource is used			
; Status bit 0 means resource has been nuked, 	
; therefore the chunk could be reasigned, but	
; if the resource is loaded again before this	
; it is enough to make it active again.		

#include "params.h"
#include "debug.h"
#include "resource.h"



;; Some helpers to save bytes
auxPrepPointer
.(
	; Start from first address in resource memory
	lda #<__resource_memory_start
	sta tmp0
	lda #>__resource_memory_start
	sta tmp0+1
	rts
.)

auxNextEntry
.(
	ldy #2
	lda (tmp0),y
	pha
	dey
	lda (tmp0),y
	clc
	adc tmp0
	sta tmp0
	pla
	adc tmp0+1
	sta tmp0+1
		
	; Check if passed the end of the available
	; memory
	lda tmp0 ; op1-op2
	cmp #<__resource_memory_end
	lda tmp0+1
	sbc #>__resource_memory_end
	rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Locate a resource in memory
;
; Params: A=resource type, X=resource ID
; Returns pointer to resource *header* in tmp0
; and Z=1 if not found.
; First byte pointed by the returned pointer is the ID
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
LocateResource
.(
	; Save resource id and type 
	sta tmp
	stx tmp+1
	
	jsr auxPrepPointer
+LocateResourceEx	
loop
	; Get resource type without status bits
	ldy #0
	lda (tmp0),y
	and #%00001111
	cmp tmp
	bne not_found
	; Correct type, check id
	ldy #3
	lda (tmp0),y
	cmp tmp+1
	bne not_found
	; Both Correct: FOUND
	lda #1
	rts
not_found
	jsr auxNextEntry	
	bcc loop ; Not yet finished
	
	; Finished and not found
	lda #0
	rts
.)


#define GRBUFFER _GlobalResourceList
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Routine that saves a list of
; global resources in memory
; so they can be stored in disk
; and loaded back.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SaveListOfGlobalResources
.(
	; Store the list of TYPE (with flags)|ID
	; from byte 1 onwards. Byte 0 will be the number 
	; of resources saved.
	ldx #0
	stx GRBUFFER
	jsr auxPrepPointer
loop
	; Get resource type
	ldy #0
	lda (tmp0),y
	beq not_global	; Marked as NULL
	sta GRBUFFER+1,x
	; Check id
	ldy #3
	lda (tmp0),y
	cmp #RESOURCE_LOCALS_START
	bcs not_global
	sta GRBUFFER+2,x
	inc GRBUFFER
	inx
	inx
not_global
	jsr auxNextEntry	
	bcc loop ; Not yet finished
	rts
.)

/* Loads back resources saved to the list */
LoadGlobalResourcesFromList
.(
	lda GRBUFFER
	sta count 
.(	
	ldy #0
loop
	lda GRBUFFER+1,y ; Get resource type
	sta savflags+1	 ; Save id+flags
	and #%1111	 ; Remove flags
	cmp #RESOURCE_ROOM
	beq skiproom
	ldx GRBUFFER+2,y ; Get resource id
	sty savy+1
	jsr LoadResource ; Load it from disk
	; In tmp0 pointer to resource (raw)?
	; Restore flags
savflags
	lda #0
	ldy #0
	sta (tmp0),y
savy
	ldy #0
skiproom	
	iny
	iny
	dec count
	bne loop
.)
	; Now load the room and all the local resources
	jsr StopCharacterCommands
	jsr ClearSpeechArea	
	inc RoomChanged 

	ldx _CurrentRoom
	jsr LoadRoom	
	sta tmp0
	sty tmp0+1
	ldy #0
	
	; Read number of columns
	lda (tmp0),y
	sta nRoomCols

	; Read all the pointers
	jsr UpdateRoomPointers	
	
/*
	
	; Reload the costumes for global objects in the room. 
	; as they surely were discarded when no more needed when
	; we were not in this room and the memory compaction erased
	; them.
	lda tmp0
	pha
	lda tmp0+1
	pha
	jsr ReloadCostumes
	pla 
	sta tmp0+1
	pla
	sta tmp0
*/	
/*
	; Skip Entry and Exit scripts
	iny	
	iny
	
	; Read number of objects in the room
	iny
	lda (tmp0),y
	beq noobjects
	; Read ids and prepare objects
	sta tmp4
	lda tmp0
	sta tmp6
	lda tmp0+1
	sta tmp6+1
.(	
loop
	iny
	sty Savy+1
	lda (tmp6),y
	jsr LoadObjectToGame
Savy
	ldy #0
	dec tmp4
	bne loop
.)	
	
noobjects
	
	; Here comes the room name, TODO: ignore it for now
*/
	jsr UpdateAllPointers	; Won't update room pointers as RoomChanged is 1
	
	; Update the drawing queue
	jmp UpdateDrawingQueue
	;rts
count .byt 0
.)




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Lock a resource setting bit 7
; so it is not destroyed even if
; nuked and compaction is run
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
LockResource
.(
	jsr LocateResource
	beq notinmemory
	; Flag as unused
	ldy #0
	lda (tmp0),y
	ora #%10000000
	sta (tmp0),y
notinmemory
	; Flag Z is correctly set here
	; as it either comes from the beq above
	; or from the sta
	rts
.)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Unlock resource so it can be
; erased from memory
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
UnlockResource
.(
	jsr LocateResource
	
	beq notinmemory
	; Flag as unused
	ldy #0
	lda (tmp0),y
	and #%01111111
	sta (tmp0),y
notinmemory
	; Flag Z is correctly set here
	; as it either comes from the beq above
	; or from the sta, but a resouce cannot have
	; a type 0 (that means empty entry)
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Code to handle reference counts in resources
; Up to 2^3, that is 7 simultaneous users
; (zero means free).
; If incrementing beyond that point, an 
; exception is issued.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
increment_ref_count
	ldy #0
	lda (tmp0),y
	and #%01110000
	clc
	adc #%00010000
#ifdef DOCHECKS_B
	bpl ok
	lda #ERR_WRONGREFS
	jsr catchEngineException
	rts
ok		
#endif	
common_ref_count
	php	
	sta tmp
	lda (tmp0),y
	and #%10001111
	ora tmp
	sta (tmp0),y
	plp
	rts
decrement_ref_count
	ldy #0
	lda (tmp0),y
	and #%01110000
	clc
	adc #%11110000
.(	
	bpl skip
	; Ensure zero if less than zero.
	; This does not issue an exception because 
	; it failed when restoring local resources 
	;(ref count was not saved), and it is useless
	; anyway
	lda #%00000000
skip
.)
	jmp common_ref_count

/*	
increment_ref_count
	lda #%00010000
	sta smc_rcadd+1
common_ref_count	
	ldy #0
	lda (tmp0),y
	and #%01110000
	clc
smc_rcadd	
	adc #%10000
#ifdef DOCHECKS_B
	bpl ok
	lda #ERR_WRONGREFS
	jsr catchEngineException
	rts
ok		
#endif	
	php	
	sta tmp
	lda (tmp0),y
	and #%10001111
	ora tmp
	sta (tmp0),y
	plp
	rts
decrement_ref_count
	lda #%11110000
	sta smc_rcadd+1
	bne common_ref_count ; always jumps
*/
	
;; Compares two 16-bit numbers in op1 and op2
;; Performs signed and unsigned comparisions at the same time.
;; If the N flag is 1, then op1 (signed) < op2 (signed) and BMI will branch
;; If the N flag is 0, then op1 (signed) >= op2 (signed) and BPL will branch 
;; For unsigned comparisions ,the behaviour is the usual with the carry flag
;; If the C flag is 0, then op1 (unsigned) < op2 (unsigned) and BCC will branch 
;; If the C flag is 1, then op1 (unsigned) >= op2 (unsigned) and BCS will branch 
;; The Z flag DOES NOT indicate equality...

cmp16
.(
    lda op1 ; op1-op2
    cmp op2
    lda op1+1
    sbc op2+1
    bvc ret ; N eor V
    eor #$80
ret
    rts
.)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Loads a resource into the game if not already in memory
; and returns a pointer to it.
; Params: A=resource type, X=resource ID
; Returns pointer to resource data in Y (high) and A (low)
; and Z=1 if not found.
; First byte pointed by the returned pointer is the ID
; Resource location in disk and size should
; be in the main directory (whatever that is).
; The algorithm is:
; 1 - Look for the resource in memory
; 2 - If it is found:
;	2a- if its status bit is 1
;	 	then it is already active.
;		Success.
;	2b- if its status bit is 0
;		just set it to 1.
;		Success.
; 3 - If it is not found, get its size and check for room
;	3a- If a chunk is found with size >= resource size
;		just divide the chunk and load from disk there.
;		A new chunk with type 0 is created with the size
;		of that remaining.
;	3b- If no chunk is found with enough size, try to run
;		memory compaction routine and get back to 3a. If it
;		fails again, then an Out Of Memory error is generated.
LoadResource
.(
	jsr LocateResource
	beq notinmemory
	
	; Mark as used
	jsr increment_ref_count

getpointer
	; return pointer to resource data in A and Y
	php
	ldy tmp0+1
	lda tmp0
	clc
	adc #RESOURCE_HEADER_SIZE+1	; Skip ID
	bcc skip
	iny
skip	
	plp
	rts
notinmemory
	jmp LoadResourceFromDisk
	; Entry point to get pointer without incrementing reference count
	; nor loading from disk
+GetPointerToResource
	jsr LocateResource
	bne getpointer
	rts	; Returns with Z=1 if not in memory
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Nukes a resource from memory
; i.e. marks it as unused
; Params: A=resource type, X=resource ID
; Returns pointer to resource data in Y (high) and A (low)
; and Z=1 if not found.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
NukeResource
.(
	jsr LocateResource
	beq notinmemory
	; Flag as unused
	;ldy #0
	;lda (tmp0),y
	;and #%01111111
	;sta (tmp0),y
	jsr decrement_ref_count
	lda #1	; Clear Z Flag
notinmemory
	; Flag Z is correctly set here
	; as it either comes from the beq above
	; or from the sta, but a resouce cannot have
	; a type 0 (that means empty entry)
	rts
.)	
	


; The following routines are the main entry points.
; They prepare everything to call LoadResource with the
; correct parameters.
; The param is always reg X with the resource ID.
; Return the pointer to resource data in A (low)
; and Y (high), or Z=1 if not found. If debug info
; is on, LoadResource generates an exception if it cannot
; load the resource.

LoadSFX
LoadActor
	rts
LoadScript	
	lda #RESOURCE_SCRIPT
	bne LoadResource
LoadString
	lda #RESOURCE_STRING
	bne LoadResource
LoadObjectCode	
	lda #RESOURCE_OBJECTCODE
	bne LoadResource
LoadObject
	lda #RESOURCE_OBJECT
	bne LoadResource
LoadRoom
	lda #RESOURCE_ROOM
	bne LoadResource
LoadCostume	
	lda #RESOURCE_COSTUME
	bne LoadResource
LoadMusic
	lda #RESOURCE_MUSIC
	bne LoadResource
LoadDialog
	lda #RESOURCE_DIALOG
	bne LoadResource
	
NukeScript	
	lda #RESOURCE_SCRIPT
	bne NukeResource
NukeString
	lda #RESOURCE_STRING
	bne NukeResource
NukeObjectCode	
	lda #RESOURCE_OBJECTCODE
	bne NukeResource
NukeObject
	lda #RESOURCE_OBJECT
	bne NukeResource
NukeCostume	
	lda #RESOURCE_COSTUME
	bne NukeResource
NukeMusic
	lda #RESOURCE_MUSIC
	bne NukeResource
NukeDialog
	lda #RESOURCE_DIALOG
	bne NukeResource	
NukeRoom
.(
	; META: Shall a ROOM be nuked without all its local resources?
	; Maybe not, so let's do it here
	php	
	lda #RESOURCE_ROOM
	jsr NukeResource
	
	plp
	bcs end

	jsr PurgeLocalScripts
	jsr RemoveLocalObjects
	
	jsr auxPrepPointer
loop
	; Check if resource is local (i.e. ID>=RESOURCE_LOCALS_START)
	ldy #3
	lda (tmp0),y
	cmp #RESOURCE_LOCALS_START
	bcc notlocal
	; Clear status bits
	ldy #0
	lda (tmp0),y
	;and #%00111111
	and #%00001111
	sta (tmp0),y
notlocal	
	jsr auxNextEntry	
	bcc loop ; Not yet finished
end
	rts	
.)	


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Disk loading routines
; The resource directories are in tables.s
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
tab_dirs_hi
	.byt >dir_scripts, >dir_rooms, >dir_costumes, >dir_strings, >dir_objects, >dir_ocode, >dir_musics
tab_dirs_lo
	.byt <dir_scripts, <dir_rooms, <dir_costumes, <dir_strings, <dir_objects, <dir_ocode, <dir_musics
entry .byt 00
	
.zero
tmpPointer .word 00
.text

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Loads a resource from disk
; Params:
; tmp resource type, tmp+1 resource ID
; Makes a first attempt to find room
; in memory. If it fails, it compacts
; memory and retries
; If fails again, an exception ERR_NOMEMORY
; is generated.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
LoadResourceFromDisk
.(	
#ifdef SHOWDBGINFO
	jsr DisplayResToLoad
#endif
	jsr TryLoad
	beq fail
	rts
fail
	jsr CompactMemory
	jsr TryLoad2nd
	beq failagain
	rts
failagain	
	lda #0
	tay
#ifdef DOCHECKS_B
	lda #ERR_NOMEMORY
	jsr catchEngineException
#endif
	rts
.)	


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Helper copy loop
; Copy tmp2 onto tmp1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
AuxCopyResource
.(
	ldy #1
	lda #0
	sbc (tmp2),y
	sta tmp
	tax
	iny
	cmp #1
	lda (tmp2),y
	adc #0
	tay
	beq return

	sec
	lda tmp1
	sbc tmp
	sta memcpyloop+4
	lda tmp1+1
	sbc #0
	sta memcpyloop+5

	sec
	lda tmp2
	sbc tmp
	sta memcpyloop+1
	lda tmp2+1
	sbc #0
	sta memcpyloop+2

memcpyloop
	lda $2211,x
	sta $5544,x
	inx
	bne memcpyloop
	inc memcpyloop+2
	inc memcpyloop+5
	dey
	bne memcpyloop
return
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Tries to compact memory
; Should preserve op2, op2+1 and tmp, tmp+1
; and entry
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CompactMemory
.(
	; Wait for an IRQ in a desperate attempt to
	; be able to do the compaction while music is playing
	; without any pause. Anyway, if a frame or two are lost
	; it is not an issue.
	jsr WaitIRQ
	
	; Disable interrupts to avoid the music playing
	; routine to use non-updated pointers to data.
	sei
	
	; Save vars which need to be preserved
	lda tmp
	pha
	lda tmp+1
	pha
	lda op2
	pha
	lda op2+1
	pha

	; 1-Run the compaction loop. The algorithm works as follows.
	; We have three pointers:
	; One to the first empty area found (where to copy things) - tmp1
	; Another one with the first occupied chunk after tmp1, to copy to tmp1 - tmp2
	; The third points to tmp2+size of chunk pointed to by tmp2, where the search must
	; continue - tmp3.
	;
	; begin
	;  tmp1=SearchForEmptyChunk //if tmp1>=end_memory something nasty happened
	;  tmp2=FindNextOccupiedChunk(tmp1)
	; loop	
	;  if(tmp2>=end_memory) finished.
	;  tmp3=tmp2+size(tmp2)
	;  memcpy(tmp1,tmp2,size(tmp2))
	;  tmp1=tmp1+size(tmp1))  // End of recently copied chunk (size(tmp1 and tmp2) are equal now)
	;  tmp2=FindNextOccupiedChunk(tmp3) // Next occupied chunk in list
	;  goto loop
	;
	;  Mark block at tmp1 as empty with all the remaining size 
	; end
.(	
	jsr auxPrepPointer
loop
	; Is it empty?
	ldy #0
	lda (tmp0),y
	; Not empty and not locked
	and #%11110000
	beq found
	jsr auxNextEntry
	bcc loop ; Not yet finished
#ifdef DOCHECKS_B
	lda #ERR_NOMEMORY
	jsr catchEngineException
	rts
#endif
found
.)	
	lda tmp0
	sta tmp1
	lda tmp0+1
	sta tmp1+1
	
.(	
loop
	jsr auxNextEntry
	bcs finished
		
	; Is it NOT empty?
	ldy #0
	lda (tmp0),y
	and #%11110000
	beq loop
found	
.)	
compaction_loop
	lda tmp0
	sta tmp2
	lda tmp0+1
	sta tmp2+1

	jsr auxNextEntry
	bcs finished	
	lda tmp0
	sta tmp3
	lda tmp0+1
	sta tmp3+1

	; Copy tmp2 onto tmp1
	jsr AuxCopyResource

	ldy #1
	clc
	lda tmp1
	adc (tmp1),y
	pha
	iny
	lda tmp1+1
	adc (tmp1),y
	sta tmp1+1
	pla
	sta tmp1
	
	; Search for next non-empty entry
.(	
loop
	; Is it NOT empty?
	ldy #0
	lda (tmp0),y
	and #%11110000
	bne compaction_loop ; Another used chunk found, repeat
next	
	jsr auxNextEntry
	bcc loop ; Not yet finished
.)
finished
	; Set header for empty chunk
	ldy #0
	lda #RESOURCE_NULL	
	sta (tmp1),y
	iny
	lda #<__resource_memory_end
	sec
	sbc tmp1
	sta (tmp1),y
#ifdef DISPLAY_MEMORY
	sta freemem
#endif
	iny
	lda #>__resource_memory_end
	sbc tmp1+1
	sta (tmp1),y	
#ifdef DISPLAY_MEMORY
	sta freemem+1
	jsr DisplayMem
#endif	

	; This is made a subroutine, to be used after loading
	jsr UpdateAllPointers
	
	pla
	sta op2+1
	pla
	sta op2
	pla
	sta tmp+1
	pla
	sta tmp
	
	cli
	rts
.)	
	
UpdateAllPointers
.(	
	lda _PlayingTuneID
	cmp #$ff
	beq skipm
	jsr UpdateSongPointers
skipm	
	jsr UpdateThreadPointers
	jsr UpdateObjectPointers

	;lda RoomChanged
	;bne skip
	ldx _CurrentRoom
	cpx #$ff
	beq skip
	lda #RESOURCE_ROOM
	jsr GetPointerToResource
	beq skip
	sta tmp0
	sty tmp0+1	
	jmp UpdateRoomPointers	
skip
	rts
.)
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Attempts to load a resource. 	
; tmp resource type, tmp+1 resource ID
; 2 entry points: the first looks for resource in directory
; generating an exception ERR_NORESOURCE if it is not found
; then tries to find room in memory. If there is not it fails.
; Returns with Z=0 if resource was loaded, and pointer to
; it in A.Y (low, high), or Z=1 and A=Y=0 if not.
; The second entry point does not check for entry in
; directory again: it uses the vars entry (disk entry)
; and op1, op2 (size) 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
TryLoad
.(
	; Get entry from directory
#ifdef SHOWDBGINFO
	jsr DisplayResToLoad
#endif
	ldx tmp
	lda tab_dirs_lo-1,x 
	sta tmpPointer
	lda tab_dirs_hi-1,x 
	sta tmpPointer+1
	
	ldy #0
loop1
	lda (tmpPointer),y
	cmp tmp+1
	beq found
	cmp #$ff
	beq end
	lda tmpPointer
	clc
	adc #2
	bcc nocarry
	inc tmpPointer+1
nocarry	
	sta tmpPointer
	jmp loop1
end
	; Entry not found in directory
#ifdef DOCHECKS_C
	lda #ERR_NORESOURCE
	jsr catchScriptException
#endif	
	rts
	
found
	; Entry in directory found
	iny
	lda (tmpPointer),y
	sta entry
	
	; Store size in op2 for later cmp16
	tax
	lda FileSizeLow,x
	sta op2
	lda FileSizeHigh,x
	sta op2+1

+TryLoad2nd	
	; Now find room in memory to load the resource
	; Start from first address in resource memory
	jsr auxPrepPointer
loop
	; Is it empty?
	ldy #0
	lda (tmp0),y
	bne not_found
	; Check if enough room
	iny
	lda (tmp0),y
	sta op1
	iny
	lda (tmp0),y
	sta op1+1
	jsr cmp16
	bcc not_found
	; Both Correct: FOUND
	; Generate header for free remains
	; load and return pointer
	lda tmp0
	clc
	adc op2
	sta tmpPointer
	lda tmp0+1
	adc op2+1
	sta tmpPointer+1
	ldy #0
	lda #RESOURCE_NULL
	sta (tmpPointer),y
	iny
	lda op1
	sec
	sbc op2
	sta (tmpPointer),y
#ifdef DISPLAY_MEMORY
	sta freemem
#endif	
	iny
	lda op1+1
	sbc op2+1
	sta (tmpPointer),y
#ifdef DISPLAY_MEMORY
	sta freemem+1
	jsr DisplayMem
#endif	
	
	; Load disk data to tmp0
ldisk	
	ldx entry
	stx _LoaderApiEntryIndex
	lda tmp0
	sta _LoaderApiAddressLow
	lda tmp0+1
	sta _LoaderApiAddressHigh
	jsr _LoadApiLoadFileFromDirectory
	
	; Search inside chunk, in case there is more
	; than one resource here...
	jsr LocateResourceEx		
	beq end ; Issue an error if not found
	
	; Prepare pointer
	lda tmp
	ora #%00010000
	ldy #0
	sta (tmp0),y
	ldy tmp0+1
	lda tmp0
	clc
	adc #RESOURCE_HEADER_SIZE+1	; Skip ID
	bcc skip
	iny
skip
	; Return with Z=0
	ldx #1
	rts
	
not_found
	jsr auxNextEntry
	bcc loop ; Not yet finished

	; Finished and not found: Return with Z=1
	ldx #0
	rts
.)	



