;Driver.s

















#include "CommonDefines.s"

 .zero
*=$00
#include "ZeroPage.s"
 .text
*=$500

Driver
	tsx
	stx OriginalStackPointer
	jsr IRQSetup
	; Clear status row(Need to init wipe right 3
	ldx #9
	txa
.(
loop1	sta $bb80+30,x
	dex
	bpl loop1
.)	
	; Display Top Row
	jsr DisplayTopRow
	; Display Default Editor
	jsr TrackList
	jsr eeDisplayLegend
	jsr ListPlot
	jsr eeDisplayStatus

	jmp EditorControl
;Could put prefs here but keys consume 322 bytes so will need to go at end	
 .dsb $600-*
;List Memory is here	$0600 (128x8x2)
#include "ListMemory.s"
EndOfListMemory

;Pattern Data is here	$0E00 (2x64x128)
PatternMemory
 .dsb 12288,244

;If DIGI's are used the theory is Patterns would be reduced to 96 and Digidrums would sit here
DigidrumMemory
 .dsb 4096,244
EndOfDigidrumMemory
EndOfPatternMemory

;SFX Data is here	$4E00 (64x64)
SFXMemory
 .dsb 64*64,221
EndOfSFXMemory

;SFX names are here	$5E00
SFXNames	;64*8
 .dsb 512,9
EndOfSFXNames
;$6000
KeyPreferences
#include "KeyPreferences.s"
EndOfKeyPreferences


EditorCode
;Editor Code is here	$7000(18432)


#include "data.s"
#include "CommonRoutines.s"
#include "EditorKeyControl.s"

#include "PatternPlot.s"
#include "PatternEditor.s"

#include "ListPlot.s"
#include "ListEditor.s"

#include "SFXPlot.s"
#include "SFXEditor.s"

;#include "MenuPlot.s"
;#include "MenuEditor.s"

#include "DisplayMessage.s"
#include "DisplaySimpleMessage.s"

#include "HelpPlot.s"

#include "FileEditor.s"

#include "LookupEditors.s"

#include "PlayMonitor.s"
#include "irq.s"
PlayRoutineMemoryStart	;2229 Bytes!
#include "InitPlays.s"
#include "PlayRoutine.s"
#include "prProcessPatternCommand.s"
#include "prProcPattern.s"
#include "prProcList.s"
#include "prMimic.s"
#include "prProcSFX.s"
#include "prTables.s"
PlayRoutineMemoryEnd
EndOfEditorCode
Himem
 .dsb $B500-*
#include "CharacterSet.s"

