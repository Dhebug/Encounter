;Driver.s
;Memory is split up as follows
;0200 Area Load Code
;0400 Game Code and Data
;9900 HIRES Character Set
;9C00 PlayerFile
;9E00 Spare
;A000 HIRES
;C000 SSC Module
;FE00 Disk Routines and FAT


#include "WurldeDefines.s"
#include "SSCModuleHeader.s"

 .zero
*=$00
#include "zeropage.s"

 .text
*=$400

;** Main Code Vector Block **
;Starting exactly at $500 is a list of JMP's to regular routines in the
;Main Code. $500 always jumps to Start of Game
;The location of each jump is also held in "MainCodeVectorJumps.s"
Driver
	jmp GameDriver2
MainCodeVectorJumps
	jmp $dead		;$403 nl_screen
	jmp $dead		;$406 AddItem
	jmp $dead		;$409 IncreaseHealth
	jmp $dead		;$40C DecreaseHealth
	jmp $dead		;$40F UpdateItemText
	jmp $dead		;$412 GetRNDRange
	jmp $dead		;$415 PlotHero
	jmp $dead		;$418 PlotPlace
	jmp $dead		;$41B Selector
	jmp $dead		;$41E ScreenCopy
	jmp $dead		;$421 EraseInlay
.byt <BackgroundBuffer	;$424 BackgroundBuffer vector (Used by SSCM-OM1S5)
.byt >BackgroundBuffer
.byt 0 ;<BGBYlocl		;$426 Background buffer yloc low table vector
.byt 0 ;>BGBYlocl
.byt 0 ;<BGBYloch                ;$428 Background buffer yloc high table vector
.byt 0 ;>BGBYloch
	jmp $dead		;$42A DeleteHero
.byt 128			;$42D Cut-Scene Trigger Flag (Normally 128) and picked up by hero.s
	jmp $dead		;$42E DisplayText
 .byt <HeroAnimationProperty	;$431 - Used to detect Airbourne flag (Stepping stones)
 .byt >HeroAnimationProperty
	jmp $dead		;$433 - DisplayPockets
	jmp $dead		;$436 - ReadKeyboard
; .dsb $0440-*
;Following this is the main game code and data

GameDriver2
#include "GameDriver.s"

;Memory must not exceed $98FF
GameMemoryEnd

 .dsb $9900-*

#include "C:\OSDK\Projects\Wurlde\Title\TextBorderCharacterSet.s"
;BSS added so that Player variables may be read but memory is not stored
 .bss

FreeSpace1
 .dsb $9C00-*

;$9C00-$9FFF Player Variables(1024)

#include "C:\OSDK\Projects\Wurlde\PlayerFile\PlayerFile.s"
