;wmsl_Data.s

;The Engine Property sets design parameters
;Bit0
;Bit1
;Bit2
;Bit3
;Bit4
;Bit5
;Bit6
;Bit7
wmsl_EngineProperty
 .byt %00000001
;This is the label list. Each entry should hold a pointer to sequential labels
;through the instruction script. Labels are used for ?
wmsl_ra_RowListLo
 .dsb 128,0
wmsl_ra_RowListHi
 .dsb 128,0

#define   ScreenID	0
#define	GraphicID	1

#define	InitialiseRoutineID	0

ExampleGraphic	;3x12
 .byt $70,$40,$43
 .byt $61,$61,$61
 .byt $41,$61,$60
 .byt $40,$40,$40
 .byt $40,$4C,$40
 .byt $40,$4C,$40
 .byt $46,$40,$58
 .byt $43,$40,$70
 .byt $41,$73,$60
 .byt $40,$5E,$40
 .byt $60,$40,$41
 .byt $70,$40,$43

;This is where the Script resides.
;For the first example, we'll display a graphic on the right of the screen
wmsl_ScriptList
 ;Set this routine as subroutine so further example may expand upon it
 .byt wmsl_STARTSUB,InitialiseRoutineID
 ;Set Screen Buffer Area
 .byt wmsl_SETALL,ScreenID,40,100,<$A000,>$A000
 ;Set Visible area within Screen Buffer
 .byt wmsl_SETALL,ScreenID+wmsl_VFlag,3,12,<20+10*40,>20+10*40
 ;Set Graphic location as Buffer
 .byt wmsl_SETALL,GraphicID,3,12,<ExampleGraphic,>ExampleGraphic
 ;Transfer Graphic Buffer to Visible area on Screen
 .byt wmsl_MOVE,ScreenID+wmsl_VFlag,GraphicID
 ;Finish
 .byt wmsl_END

#define wmsl_SetScrollCount	wmsl_SETV0
#define wmsl_IncScrollCount	wmsl_INCV0
#define ScrollCount		wmsl_V0
;For second example, display graphic on the right of screen and scroll to left
 ;Repeat Script above
 .byt wmsl_CALLSUB,InitialiseRoutineID
 ;Expand screen visible area to allow scroll
 .byt wmsl_SETALL,ScreenID+wmsl_VFlag,4,12,<19+10*40,>19+10*40
 ;Set Scroll count to 0
 .byt wmsl_SetScrollCount,0
 ;scroll this area left
 .byt wmsl_SCROLLPIXELLEFT,ScreenID+wmsl_VFlag
 ;Increment Scroll Count
 .byt wmsl_IncScrollCount,1
 ;Branch back 2 rows if ScrollCount is less than 6
 .byt wmsl_BRANCHBACK,wmsl_Less,ScrollCount,6,2
