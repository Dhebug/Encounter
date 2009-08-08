;Data.s

VersionHeaderText
 .byt 9,"TWILIGHTE 23/02/09 V0.03 -"
hpVersionLoc
 .byt " PATTERN KEYS"

OriginalStackPointer		.byt 0
;0 Menu
;1 List Editor
;2 Pattern Editor
;3 SFX Editor
;4 File Editor
CurrentEditor			.byt 1
HelpViewFlag			.byt 0
CurrentSFX			.byt 0

;MenuCursorX			.byt 0
OldSong				.byt 128
PatternCursorRow			.byt 0
PatternCursorX			.byt 0
peHighlightActive			.byt 0
peHighlightTrackStart		.byt 0
peHighlightTrackEnd			.byt 0
peHighlightRowStart			.byt 0
peHighlightRowEnd			.byt 0
peHighlightInverse			.byt 0
peTransferType			.byt 0
pecCurrentRow			.byt 0
pecCurrentTrack			.byt 0
peBlueRow				.byt 128
peNavStep				.byt 0

ExtendedOptionActionLo
 .byt <eoa_IncrementVolume
 .byt <eoa_DecrementVolume
 .byt <eoa_TransposeUp
 .byt <eoa_TransposeDown
 .byt <eoa_InsertRow
 .byt <eoa_DeleteRow
 .byt <eoa_Delete
ExtendedOptionActionHi
 .byt >eoa_IncrementVolume
 .byt >eoa_DecrementVolume
 .byt >eoa_TransposeUp
 .byt >eoa_TransposeDown
 .byt >eoa_InsertRow
 .byt >eoa_DeleteRow
 .byt >eoa_Delete
eoa_Note				.byt 0
eoa_Volume			.byt 0
eoa_SFX				.byt 0
eoa_Temp01			.byt 0
eoa_Temp02			.byt 0
eoa_Temp03			.byt 0

CurrentCommandFlag			.byt 0
PatternRowCommandChannelActivity	.byt 0
GrabbedPatternEntry0		.byt 0
GrabbedPatternEntry1		.byt 0

ListCursorRow			.byt 1
ListCursorX			.byt 0
RWCListCursorX			.byt 0	;0 or 1
eeHighlightRowStart			.byt 0
eeHighlightRowEnd			.byt 0
eeHighlightActive			.byt 0
eeTransferType			.byt 0
eeCopyRowStart			.byt 0
eeCopyRowEnd			.byt 0
eeGrabbedRow			.byt 0
eeGrabbedEntry
 .dsb 16,0
PatternUsageBitTable
 .dsb 16,0
eeGrabbedEntryType			.byt 0
CurrentSong			.byt 0
eeBlueRow				.byt 128

SFXNumber			.byt 0
SFXCursorRow			.byt 0
seRangeLo				.byt 0
seRangeHi				.byt 0
seHighlightRowStart			.byt 0
seHighlightRowEnd			.byt 0
seHighlightActive			.byt 0
seCopyRowStart			.byt 0
seCopyRowEnd			.byt 0
seCopyType			.byt 0
seGrabbedEntry			.byt 0
seGrabbedRow			.byt 0

dsmInverseFlag			.byt 0
dsmPreviousEnd			.byt 0
;Device Type
;0 Drive A
;1 Drive B
;2 Drive C
;3 Drive D
fnDeviceType			.byt 0
fnScreenIndex			.byt 0
fnCursorIndex			.byt 0
fnFilter				.byt 1
fnExtensionType			.byt 0
fnSectorsFreeLo			.byt 0
fnSectorsFreeHi			.byt 0

MonitorMode			.byt 0
hpCursorIndex			.byt 0

ipRules				.byt 0
ipMaxLength			.byt 0
ipScreenIndex			.byt 0
ipInputBuffer			.dsb 16,32
ipNewCharacter			.byt 0
ipCursorX				.byt 0

DigiOffLook			.byt 0
BlankPatternRow
 .byt 8
 .byt 8,8,8,8
 .byt 127
 .byt 8,8,8,8
 .byt 127
 .byt 8,8,8,8
 .byt 127
 .byt 8,8,8,8
 .byt 127
 .byt 8,8,8,8
 .byt 127
 .byt 8,8,8,8
 .byt 127
 .byt 8,8,8,8
 .byt 127
 .byt 8,8,8,8
 
Bitpos
 .byt %00000001
 .byt %00000010
 .byt %00000100
 .byt %00001000
 .byt %00010000
 .byt %00100000
 .byt %01000000
 .byt %10000000

BitposMask
 .byt %11111110
 .byt %11111101
 .byt %11111011
 .byt %11110111
 .byt %11101111
 .byt %11011111
 .byt %10111111
 .byt %01111111

YLOCL
 .byt <$BB80	 ;0
 .byt <$BB80+40*1    ;1
 .byt <$BB80+40*2    ;2
 .byt <$BB80+40*3    ;3
 .byt <$BB80+40*4    ;4
 .byt <$BB80+40*5    ;5
 .byt <$BB80+40*6    ;6
 .byt <$BB80+40*7    ;7
 .byt <$BB80+40*8    ;8
 .byt <$BB80+40*9    ;9
 .byt <$BB80+40*10   ;10
 .byt <$BB80+40*11   ;11
 .byt <$BB80+40*12   ;12
 .byt <$BB80+40*13   ;13
 .byt <$BB80+40*14   ;14
 .byt <$BB80+40*15   ;15
 .byt <$BB80+40*16   ;16
 .byt <$BB80+40*17   ;17
 .byt <$BB80+40*18   ;18
 .byt <$BB80+40*19   ;19
 .byt <$BB80+40*20   ;20
 .byt <$BB80+40*21   ;21
 .byt <$BB80+40*22   ;22
 .byt <$BB80+40*23   ;23
 .byt <$BB80+40*24   ;24
 .byt <$BB80+40*25   ;25
 .byt <$BB80+40*26   ;26
 .byt <$BB80+40*27   ;27
YLOCH
 .byt >$BB80	 ;0
 .byt >$BB80+40*1    ;1
 .byt >$BB80+40*2    ;2
 .byt >$BB80+40*3    ;3
 .byt >$BB80+40*4    ;4
 .byt >$BB80+40*5    ;5
 .byt >$BB80+40*6    ;6
 .byt >$BB80+40*7    ;7
 .byt >$BB80+40*8    ;8
 .byt >$BB80+40*9    ;9
 .byt >$BB80+40*10   ;10
 .byt >$BB80+40*11   ;11
 .byt >$BB80+40*12   ;12
 .byt >$BB80+40*13   ;13
 .byt >$BB80+40*14   ;14
 .byt >$BB80+40*15   ;15
 .byt >$BB80+40*16   ;16
 .byt >$BB80+40*17   ;17
 .byt >$BB80+40*18   ;18
 .byt >$BB80+40*19   ;19
 .byt >$BB80+40*20   ;20
 .byt >$BB80+40*21   ;21
 .byt >$BB80+40*22   ;22
 .byt >$BB80+40*23   ;23
 .byt >$BB80+40*24   ;24
 .byt >$BB80+40*25   ;25
 .byt >$BB80+40*26   ;26
 .byt >$BB80+40*27   ;27

Notes12ToNote
 .byt 0,0,2,2,4,5,5,7,7,9,9,11
Notes12ToSharp
 .byt 0,1,0,1,0,0,1,0,1,0,1,0
;peKeyNote
; .byt "CDEFGAB"
;peActualNote
; .byt 0,2,4,5,7,9,11
peActualNote
 .byt 9,11,0,2,4,5,7
EnteredNote	.byt 0

;TrackProperty - Current Properties of each track
;	B0-4 SS for Track
;         B5   Display Numeric rather than Note
;	B6   Command Track
;	B7   Active
TrackProperty
 .byt 128,128+32,128+32,128,0,128,128,128+64
;CurrentPattern - Current Pattern assigned to Each Track
CurrentPattern
 .byt 0,1,2,3,4,5,6,7

SoundSourceNumericFlag	;Indexed by sound source ABCENT (0-5)
 .byt 0,0,0,1,1,1

DefaultTrackRow
 .byt 127,0,127,0,127,0,127,0,127,0,127,0,127,0,127,0
;All control for all keys in all editors are handled centrally by EditorInput in EditorKeyControl.s
;This reduces the amount of coding neccesary for each editor so apart from config only the actual
;editor key command routines need to be written
;Editors
;0 Menu
;1 List Editor
;2 Pattern Editor
;3 SFX Editor
;4 File Editor

EditorHardKeyTableLo
 .byt 0	;<HardKeys4Menu
 .byt <HardKeys4ListEditor
 .byt <HardKeys4PatternEditor
 .byt <HardKeys4SFXEditor
 .byt <HardKeys4FileEditor
EditorHardKeyTableHi
 .byt 0	;>HardKeys4Menu
 .byt >HardKeys4ListEditor
 .byt >HardKeys4PatternEditor
 .byt >HardKeys4SFXEditor
 .byt >HardKeys4FileEditor
EditorSoftKeyTableLo
 .byt 0	;<SoftKeys4Menu
 .byt <SoftKeys4ListEditor
 .byt <SoftKeys4PatternEditor
 .byt <SoftKeys4SFXEditor
 .byt <SoftKeys4FileEditor
EditorSoftKeyTableHi
 .byt 0	;>SoftKeys4Menu
 .byt >SoftKeys4ListEditor
 .byt >SoftKeys4PatternEditor
 .byt >SoftKeys4SFXEditor
 .byt >SoftKeys4FileEditor
EditorsUltimateKey
 .byt 0		;0 Menu          
 .byt 50            ;1 List Editor  
 .byt 66            ;2 Pattern Editor
 .byt 49            ;3 SFX Editor    
 .byt 20            ;4 File Editor   
EditorKeyDescriptionPointerTableLo
 .byt 0	;<KeyDescriptionPointers4MenuEditor	;0 Menu          
 .byt <KeyDescriptionPointers4ListEditor	;1 List Editor  
 .byt <KeyDescriptionPointers4PatternEditor	;2 Pattern Editor
 .byt <KeyDescriptionPointers4SFXEditor	;3 SFX Editor    
 .byt <KeyDescriptionPointers4FileEditor	;3 File Editor
EditorKeyDescriptionPointerTableHi
 .byt 0	;>KeyDescriptionPointers4MenuEditor	;0 Menu          
 .byt >KeyDescriptionPointers4ListEditor	;1 List Editor  
 .byt >KeyDescriptionPointers4PatternEditor	;2 Pattern Editor
 .byt >KeyDescriptionPointers4SFXEditor	;3 SFX Editor    
 .byt >KeyDescriptionPointers4FileEditor	;3 File Editor
EditorKeyVectorLoTableLo
 .byt 0	;<KeyVector4MenuLo
 .byt <KeyVector4ListEditorLo
 .byt <KeyVector4PatternEditorLo
 .byt <KeyVector4SFXEditorLo
 .byt <KeyVector4FileEditorLo
EditorKeyVectorLoTableHi
 .byt 0	;>KeyVector4MenuLo
 .byt >KeyVector4ListEditorLo
 .byt >KeyVector4PatternEditorLo
 .byt >KeyVector4SFXEditorLo
 .byt >KeyVector4FileEditorLo
EditorKeyVectorHiTableLo
 .byt 0	;<KeyVector4MenuHi
 .byt <KeyVector4ListEditorHi
 .byt <KeyVector4PatternEditorHi
 .byt <KeyVector4SFXEditorHi
 .byt <KeyVector4FileEditorHi
EditorKeyVectorHiTableHi
 .byt 0	;>KeyVector4MenuHi
 .byt >KeyVector4ListEditorHi
 .byt >KeyVector4PatternEditorHi
 .byt >KeyVector4SFXEditorHi
 .byt >KeyVector4FileEditorHi
;Process Routines are executed within EditorControl
PreProcessVectorLo
 .byt 0	;<PlotMenuCursor
 .byt <eeDisplayCursor
 .byt <peDisplayCursor
 .byt <seDisplayCursor
 .byt <fnDisplayCursor
PreProcessVectorHi
 .byt 0	;>PlotMenuCursor
 .byt >eeDisplayCursor
 .byt >peDisplayCursor
 .byt >seDisplayCursor
 .byt >fnDisplayCursor
IntProcessVectorLo
 .byt 0
 .byt <eeFetchEntryData
 .byt <peFetchEntryData
 .byt <seCalcCurrentSFXRowAddress
 .byt <fnDeleteCursor
IntProcessVectorHi
 .byt 0
 .byt >eeFetchEntryData
 .byt >peFetchEntryData
 .byt >seCalcCurrentSFXRowAddress
 .byt >fnDeleteCursor
ProProcessVectorLo
 .byt 0	;<MainMenuPlot
 .byt <ListPlot
 .byt <PatternPlot
 .byt <SFXPlot
 .byt 0
ProProcessVectorHi
 .byt 0	;>MainMenuPlot
 .byt >ListPlot
 .byt >PatternPlot
 .byt >SFXPlot
 .byt 0

;********** Key Tables for List Editor *************** 
PartitionText
 .byt 2,"NAVIGATION",7
 .byt 3,"MODIFY----",7
 .byt 5,"OPERATORS-",7
 .byt 6,"COPYING---",7
 .byt 1,"PLAYING---",7


KeyVector4ListEditorLo
 .byt PARTITION_NAVIGATE
 .byt <eeNavTrackLeft	;- CTRL Left
 .byt <eeNavTrackRight    	;- CTRL Right
 .byt <eeNavLeft          	;- Left
 .byt <eeNavRight         	;- Right
 .byt <eeNavUp            	;- Up
 .byt <eeNavDown          	;- Down
 .byt <eeNavPU             	;- CTRL Up
 .byt <eeNavPD              	;- CTRL Down
 .byt <leSongPrevious	;- CTRL -
 .byt <leSongNext		;- CTRL =
 .byt <JumpPattern        	;- CTRL P
; .byt <JumpMenu           	;- ESC
 .byt <JumpSFX         	;- CTRL S
 .byt <JumpFile           	;- CTRL F
 .byt <JumpHelp           	;- CTRL H
 .byt <eeToggleBlue		;- CTRL R
 .byt PARTITION_MODIFY
 .byt <eeIncrement        	;- =
 .byt <eeDecrement        	;- -
 .byt <eeReset            	;- DEL
 .byt <eeToggle           	;- SPACE
 .byt <eeInsertGap		;- CTRL I
 .byt <eeDeleteGap		;- CTRL D
 .byt PARTITION_OPERATERS
 .byt <eeRest             	;- R
 .byt <eePattern          	;- T	- Set Tracks
 .byt <eeComMimicLeft     	;- FUNC ,
 .byt <eeComMimicRight    	;- FUNC .
 .byt <eeComNewSong       	;- FUNC N
 .byt <eeComEndSong       	;- FUNC E
 .byt <eeComFadeMusic     	;- FUNC F
 .byt <eeComIRQRates      	;- FUNC I
 .byt <eeComSharing       	;- FUNC S
 .byt <eeComOctaveRange   	;- FUNC O
 .byt <eeComResolutions   	;- FUNC R
 .byt <eeCommandH		;- FUNC C
 .byt <eeAutoAssignPatterns	;- FUNC A
 .byt PARTITION_COPYING
 .byt <eeHilightDown      	;- SHFT Down
 .byt <eeHilightUp        	;- SHFT Up
 .byt <eeCopy             	;- CTRL C
 .byt <eeCut              	;- CTRL X
 .byt <eePaste            	;- CTRL V
 .byt <eeGrab             	;- J
 .byt <eeDrop             	;- K
 .byt <eeCopyLast		;- ,
 .byt <eeCopyNext		;- .
 .byt PARTITION_PLAY
 .byt <PlayFromRow		;- Return
 .byt <JumpPlay		;- SHFT Return
 .byt <JumpAllStop		;- SHFT S

 
KeyVector4ListEditorHi
 .byt PARTITION_NAVIGATE
 .byt >eeNavTrackLeft	;- CTRL Left
 .byt >eeNavTrackRight    	;- CTRL Right
 .byt >eeNavLeft          	;- Left
 .byt >eeNavRight         	;- Right
 .byt >eeNavUp            	;- Up
 .byt >eeNavDown          	;- Down
 .byt >eeNavPU             	;- CTRL Up
 .byt >eeNavPD              	;- CTRL Down
 .byt >leSongPrevious	;- CTRL -
 .byt >leSongNext		;- CTRL =
 .byt >JumpPattern        	;- CTRL P
; .byt >JumpMenu           	;- ESC
 .byt >JumpSFX         	;- CTRL S
 .byt >JumpFile           	;- CTRL F
 .byt >JumpHelp           	;- CTRL H
 .byt >eeToggleBlue		;- CTRL R
 .byt PARTITION_MODIFY
 .byt >eeIncrement        	;- =
 .byt >eeDecrement        	;- -
 .byt >eeReset            	;- DEL
 .byt >eeToggle           	;- SPACE
 .byt >eeInsertGap		;- CTRL I
 .byt >eeDeleteGap		;- CTRL D
 .byt PARTITION_OPERATERS
 .byt >eeRest             	;- R
 .byt >eePattern          	;- T	- Set Tracks
 .byt >eeComMimicLeft     	;- FUNC ,
 .byt >eeComMimicRight    	;- FUNC .
 .byt >eeComNewSong       	;- FUNC N
 .byt >eeComEndSong       	;- FUNC E
 .byt >eeComFadeMusic     	;- FUNC F
 .byt >eeComIRQRates      	;- FUNC I
 .byt >eeComSharing       	;- FUNC S
 .byt >eeComOctaveRange   	;- FUNC O
 .byt >eeComResolutions   	;- FUNC R
 .byt >eeCommandH		;- FUNC C
 .byt >eeAutoAssignPatterns	;- FUNC A
 .byt PARTITION_COPYING
 .byt >eeHilightDown      	;- SHFT Down
 .byt >eeHilightUp        	;- SHFT Up
 .byt >eeCopy             	;- CTRL C
 .byt >eeCut              	;- CTRL X
 .byt >eePaste            	;- CTRL V
 .byt >eeGrab             	;- J
 .byt >eeDrop             	;- K
 .byt >eeCopyLast		;- ,
 .byt >eeCopyNext		;- .
 .byt PARTITION_PLAY
 .byt >PlayFromRow
 .byt >JumpPlay
 .byt >JumpAllStop		;- SHFT S



KeyDescriptionPointers4ListEditor
 .byt 0
 .byt 0	;eeNavTrackLeft
 .byt 1	;eeNavTrackRight
 .byt 2	;eeNavLeft
 .byt 3	;eeNavRight
 .byt 4	;eeNavUp
 .byt 5	;eeNavDown
 .byt 111	;eePageUP           - CTRL Up
 .byt 112	;eePageDN           - CTRL Down
 .byt 100	;leSongPrevious	- CTRL -
 .byt 101	;leSongNext	- CTRL =
 .byt 20	;JumpPattern        - CTRL P
; .byt 28	;JumpMenu           - ESC
 .byt 29	;JumpSFX         - CTRL S
 .byt 83	;JumpFile           - CTRL F
 .byt 48	;JumpHelp           - CTRL H
 .byt 108	;eeToggleBlue	- CTRL R
 .byt 0
 .byt 23	;eeIncrement        - =
 .byt 24	;eeDecrement        - -
 .byt 25	;eeReset            - DEL
 .byt 50	;eeToggle           - SPACE
 .byt 51	;eeInsertGap	- CTRL I
 .byt 52	;eeDeleteGap	- CTRL D
 .byt 0
 .byt 85	;eeRest             - R
 .byt 102	;eePattern          - P	- Set Tracks
 .byt 87	;eeComMimicLeft     - FUNC ,
 .byt 88	;eeComMimicRight    - FUNC .
 .byt 89	;eeComNewSong       - FUNC N
 .byt 91	;eeComEndSong       - FUNC E
 .byt 92	;eeComFadeMusic     - FUNC F
 .byt 93	;eeComLoopMusic     - FUNC I - IRQ Settings
 .byt 94	;eeComSongBehaviour - FUNC S - Sharing Behaviour
 .byt 95	;eeComNoteSettings  - FUNC O   Octave Settings   
 .byt 96	;eeComNoteBehaviour - FUNC R   Resolutions Settings
 .byt 10	;eeCommandH	- FUNC C
 .byt 109	;eeAutoAssignPatterns FUNC A
 .byt 0 
 .byt 34	;eeHilightDown      - SHFT Down
 .byt 35	;eeHilightUp        - SHFT Up
 .byt 39	;eeCopy             - CTRL C
 .byt 41	;eeCut              - CTRL X
 .byt 40	;eePaste            - CTRL V
 .byt 31	;eeGrab             - J
 .byt 32	;eeDrop             - K
 .byt 26	;eeCopyLast	- ,
 .byt 27	;eeCopyNext	- .
 .byt 0
 .byt 97	;eePlayCursor	- RETURN
 .byt 44	;eePlaySong	- SHIFT RETURN
 .byt 107

;********** Key Tables for Pattern Editor *************** 
 
KeyVector4PatternEditorLo
 .byt PARTITION_NAVIGATE
 .byt <peNavTrackLeft
 .byt <peNavTrackRight
 .byt <peNavLeft
 .byt <peNavRight
 .byt <peNavUp
 .byt <peNavDown
 .byt <peNavPU
 .byt <peNavPD
; .byt <JumpMenu
 .byt <JumpList
 .byt <JumpSFX
 .byt <JumpFile
 .byt <JumpHelp
 .byt <peToggleBlue		;- CTRL R
 .byt PARTITION_MODIFY
 .byt <peIncrement
 .byt <peDecrement
 .byt <peReset
; .byt <peToggle
 .byt <peInsert
 .byt <peDelete
 .byt <peMoveEntryDown
 .byt <peMoveEntryUp
 .byt PARTITION_OPERATERS
 .byt <peOctave
 .byt <peOctave
 .byt <peOctave
 .byt <peOctave
 .byt <peOctave
 .byt <peOctave
 .byt <peOctave
 .byt <peOctave
 .byt <peOctave
 .byt <peOctave
 .byt <peNote
 .byt <peNote
 .byt <peNote
 .byt <peNote
 .byt <peNote
 .byt <peNote
 .byt <peNote
 .byt <peBar
 .byt <peToggleCommand

 .byt <peCmdTriggerOut
 .byt <peCmdTriggerIn
 .byt <peCmdSongTempo
 .byt <peCmdBend
 .byt <peCmdEGWave		;fW
 .byt <peCmdEGPeriod	;fP
 
 .byt PARTITION_COPYING
 .byt <peHighlightDown
 .byt <peHighlightUp
 .byt <peHighlightLeft
 .byt <peHighlightRight
 .byt <peCopy
 .byt <pePaste
 .byt <peCut
 .byt <peMerge
 .byt <peGrab
 .byt <peDrop
 .byt <peContextualDrop
 .byt <peCopyLast
 .byt <peCopyNext
 .byt PARTITION_PLAY
 .byt <pePlayPattern
 .byt <JumpPlay
 .byt <JumpAllStop		;- SHFT S
 .byt <peMuteTrack



KeyVector4PatternEditorHi
 .byt PARTITION_NAVIGATE
 .byt >peNavTrackLeft
 .byt >peNavTrackRight
 .byt >peNavLeft
 .byt >peNavRight
 .byt >peNavUp
 .byt >peNavDown
 .byt >peNavPU
 .byt >peNavPD
; .byt >JumpMenu
 .byt >JumpList
 .byt >JumpSFX
 .byt >JumpFile
 .byt >JumpHelp
 .byt >peToggleBlue		;- CTRL R
 .byt PARTITION_MODIFY
 .byt >peIncrement
 .byt >peDecrement
 .byt >peReset
; .byt >peToggle
 .byt >peInsert
 .byt >peDelete
 .byt >peMoveEntryDown
 .byt >peMoveEntryUp
 .byt PARTITION_OPERATERS
 .byt >peOctave
 .byt >peOctave
 .byt >peOctave
 .byt >peOctave
 .byt >peOctave
 .byt >peOctave
 .byt >peOctave
 .byt >peOctave
 .byt >peOctave
 .byt >peOctave
 .byt >peNote
 .byt >peNote
 .byt >peNote
 .byt >peNote
 .byt >peNote
 .byt >peNote
 .byt >peNote
 .byt >peBar
 .byt >peToggleCommand
 .byt >peCmdTriggerOut
 .byt >peCmdTriggerIn
 .byt >peCmdSongTempo
 .byt >peCmdBend
 .byt >peCmdEGWave		;fW
 .byt >peCmdEGPeriod	;fP
 .byt PARTITION_COPYING
 .byt >peHighlightDown
 .byt >peHighlightUp
 .byt >peHighlightLeft
 .byt >peHighlightRight
 .byt >peCopy
 .byt >pePaste
 .byt >peCut
 .byt >peMerge
 .byt >peGrab
 .byt >peDrop
 .byt >peContextualDrop
 .byt >peCopyLast
 .byt >peCopyNext
 .byt PARTITION_PLAY
 .byt >pePlayPattern
 .byt >JumpPlay
 .byt >JumpAllStop		;- SHFT S
 .byt >peMuteTrack

KeyDescriptionPointers4PatternEditor
 .byt PARTITION_NAVIGATE
 .byt 0	; peNavTrackLeft
 .byt 1	; peNavTrackRight
 .byt 2	; peNavLeft
 .byt 3	; peNavRight
 .byt 4	; peNavUp
 .byt 5	; peNavDown
 .byt 111	; peNavHome
 .byt 112	; peNavEnd
; .byt 28	; JumpMenu
 .byt 30	; JumpList
 .byt 29	; JumpSFX
 .byt 83	; JumpFile
 .byt 48	; JumpHelp
 .byt 108	; peToggleBlue
 .byt PARTITION_MODIFY
 .byt 23	; peIncrement
 .byt 24	; peDecrement
 .byt 25	; peReset
; .byt 50	; peToggle
 .byt 51	; peInsert
 .byt 52	; peDelete
 .byt 76	; peMoveEntryDown
 .byt 77	; peMoveEntryUp
 .byt PARTITION_OPERATERS
 .byt 8	; peOctave
 .byt 8	; peOctave
 .byt 8	; peOctave
 .byt 8	; peOctave
 .byt 8	; peOctave
 .byt 8	; peOctave
 .byt 8	; peOctave
 .byt 8	; peOctave
 .byt 8	; peOctave
 .byt 8	; peOctave
 .byt 22	; peNote
 .byt 22	; peNote
 .byt 22	; peNote
 .byt 22	; peNote
 .byt 22	; peNote
 .byt 22	; peNote
 .byt 22	; peNote
 .byt 33	; peBar
 .byt 99	; peToggleCommand
 .byt 103	; peCmdTriggerOut
 .byt 104	; peCmdTriggerIn
 .byt 105	; peCmdSongTempo
 .byt 106	; peCmdBend
 .byt 9 	; peCmdEGWave		;fW
 .byt 113 ; peCmdEGPeriod	;fP

 .byt PARTITION_COPYING
 .byt 34	; peHighlightDown
 .byt 35	; peHighlightUp
 .byt 36	; peHighlightLeft
 .byt 37	; peHighlightRight
 .byt 39	; peCopy
 .byt 40	; pePaste
 .byt 41	; peCut
 .byt 42	; peMerge
 .byt 31	; peGrab
 .byt 32	; peDrop
 .byt 110 ; peContextualDrop
 .byt 26	; peCopyLast
 .byt 27	; peCopyNext
 .byt PARTITION_PLAY
 .byt 43	; pePlayPattern
 .byt 44	; JumpPlay
 .byt 107	; Stop/Silence
 .byt 45	; peMuteTrack

;********** Key Tables for Menu *************** 
;KeyVector4MenuLo
; .byt PARTITION_NAVIGATE	
; .byt <mnuLeft
; .byt <mnuRight
; .byt <JumpHelp
; .byt <mnuEscape
; .byt PARTITION_OPERATERS	
; .byt <mnuReturn
;
;KeyVector4MenuHi
; .byt PARTITION_NAVIGATE	
; .byt >mnuLeft
; .byt >mnuRight
; .byt >JumpHelp
; .byt >mnuEscape
; .byt PARTITION_OPERATERS	
; .byt >mnuReturn
;
;KeyDescriptionPointers4MenuEditor
; .byt PARTITION_NAVIGATE	
; .byt 2  	;mnuLeft            - Left
; .byt 3   ;mnuRight           - Right
; .byt 48	;mnuHelp            - CTRL H
; .byt 54 	;mnuEscape          - Escape
; .byt PARTITION_OPERATERS	
; .byt 53	;mnuReturn	- Return

;********** Key Tables for SFX Editor *************** 

KeyVector4SFXEditorLo
 .byt PARTITION_NAVIGATE	
 .byt <seNavDown	;- Down
 .byt <seNavUp	;- Up
 .byt <seHome       ;- CTRL Up
 .byt <seEnd        ;- CTRL Down
 .byt <seDecSFX   	;- CTRL -
 .byt <seIncSFX   	;- CTRL =
 .byt <JumpList   	;- CTRL E
 .byt <JumpPattern 	;- CTRL P
 .byt <JumpFile	;- CTRL F
 .byt <JumpHelp    	;- CTRL H	
 .byt PARTITION_MODIFY	;any key beyond row 12 will silence music/sfx
 .byt <seIncrement  ;- =
 .byt <seDecrement  ;- -
 .byt <seDeleteVal  ;- DEL
 .byt <seToggleVal  ;- Space
 .byt <seDeleteGap  ;- CTRL D
 .byt <seInsertGap  ;- CTRL I
 .byt PARTITION_OPERATERS	
 .byt <seCommand    ;- P
 .byt <seCommand    ;- N
 .byt <seCommand    ;- V
 .byt <seCommand    ;- S
 .byt <seCommand    ;- E
 .byt <seCommand    ;- G
 .byt <seCommand    ;- T
 .byt <seCommand    ;- O
 .byt <seCommand    ;- /
 .byt <seCommand    ;- X
 .byt <seCommand    ;- F
 .byt <seCommand    ;- D
 .byt <seCommand    ;- C
 .byt <seCommand    ;- L
 .byt <seCommand    ;- R
 .byt <seCommand    ;- W
 .byt <seNameSFX	;- FUNC N
 .byt PARTITION_COPYING	
 .byt <seHiliteDown  	;- SHFT Down
 .byt <seHighlightUp 	;- SHFT Up
 .byt <seHighlightAll	;- CTRL A
 .byt <seCopy        	;- CTRL C
 .byt <sePaste       	;- CTRL V
 .byt <seCut		;- CTRL X
 .byt <seGrab        	;- J
 .byt <seDrop        	;- K
 .byt <seLastEntry   	;- ,
 .byt <seNextEntry   	;- .
 .byt PARTITION_PLAY	
 .byt <sePlay        	;- RETURN
 .byt <JumpAllStop		;- SHFT S
 


KeyVector4SFXEditorHi
 .byt PARTITION_NAVIGATE	
 .byt >seNavDown	;- Down
 .byt >seNavUp	;- Up
 .byt >seHome       ;- CTRL Up
 .byt >seEnd        ;- CTRL Down
 .byt >seDecSFX   	;- CTRL -
 .byt >seIncSFX   	;- CTRL =
 .byt >JumpList   	;- CTRL E
 .byt >JumpPattern 	;- CTRL P
 .byt >JumpFile	;- CTRL F
 .byt >JumpHelp    	;- CTRL H
 .byt PARTITION_MODIFY	
 .byt >seIncrement  ;- =
 .byt >seDecrement  ;- -
 .byt >seDeleteVal  ;- DEL
 .byt >seToggleVal  ;- Space
 .byt >seDeleteGap  ;- CTRL D
 .byt >seInsertGap  ;- CTRL I
 .byt PARTITION_OPERATERS	
 .byt >seCommand    ;- P
 .byt >seCommand    ;- N
 .byt >seCommand    ;- V
 .byt >seCommand    ;- S
 .byt >seCommand    ;- E
 .byt >seCommand    ;- G
 .byt >seCommand    ;- T
 .byt >seCommand    ;- O
 .byt >seCommand    ;- /
 .byt >seCommand    ;- X
 .byt >seCommand    ;- F
 .byt >seCommand    ;- D
 .byt >seCommand    ;- C
 .byt >seCommand    ;- L
 .byt >seCommand    ;- R
 .byt >seCommand    ;- W
 .byt >seNameSFX	;- FUNC N
 .byt PARTITION_COPYING	
 .byt >seHiliteDown  	;- SHFT Down
 .byt >seHighlightUp 	;- SHFT Up
 .byt >seHighlightAll	;- CTRL A
 .byt >seCopy        	;- CTRL C
 .byt >sePaste       	;- CTRL V
 .byt >seCut		;- CTRL X
 .byt >seGrab        	;- J
 .byt >seDrop        	;- K
 .byt >seLastEntry   	;- ,
 .byt >seNextEntry   	;- .
 .byt PARTITION_PLAY	
 .byt >sePlay        	;- RETURN
 .byt >JumpAllStop		;- SHFT S

KeyDescriptionPointers4SFXEditor
 .byt PARTITION_NAVIGATE	
 .byt 5	;seNavDown	- Down
 .byt 4	;seNavUp		- Up
 .byt 6	;seHome       	- CTRL Up
 .byt 7	;seEnd         	- CTRL Down
 .byt 73	;seDecSFX   	- CTRL -
 .byt 74	;seIncSFX   	- CTRL =
 .byt 30	;JumpList   	- CTRL E
 .byt 20	;JumpPattern 	- CTRL P
 .byt 83 	;JumpFile		- CTRL F
 .byt 48	;JumpHelp    	- CTRL H
 .byt PARTITION_MODIFY	
 .byt 23	;seIncrement   	- =
 .byt 24	;seDecrement   	- -
 .byt 25	;seDeleteVal        - DEL
 .byt 50	;seToggleVal   	- Space
 .byt 52	;seDeleteGap   	- CTRL D
 .byt 51	;seInsertGap   	- CTRL I
 .byt PARTITION_OPERATERS	
 .byt 56	;seCommand     	- P
 .byt 57	;seCommand     	- N
 .byt 58	;seCommand     	- V
 .byt 59	;seCommand     	- S
 .byt 60	;seCommand     	- E
 .byt 61	;seCommand     	- G
 .byt 62	;seCommand     	- T
 .byt 63	;seCommand     	- O
 .byt 64	;seCommand     	- /

 .byt 66	;seCommand     	- X
 .byt 67	;seCommand     	- F
 .byt 68	;seCommand     	- D
 .byt 65	;seCommand     	- C

 .byt 69	;seCommand     	- L
 .byt 70	;seCommand     	- R
 .byt 9 	;seCommand     	- W
 .byt 98 	;seNameSFX	- FUNC N
 
 .byt PARTITION_COPYING
 .byt 34	;seHiliteDown  	- SHFT Down
 .byt 35	;seHighlightUp 	- SHFT Up
 .byt 38	;seHighlightAll	- CTRL A
 .byt 39	;seCopy        	- CTRL C
 .byt 40	;sePaste       	- CTRL V
 .byt 41	;seCut		- CTRL X
 .byt 31	;seGrab        	- J
 .byt 32	;seDrop        	- K
 .byt 26	;seLastEntry   	- ,
 .byt 27	;seNextEntry   	- .
 .byt PARTITION_PLAY	
 .byt 46	;sePlay        	- RETURN
 .byt 107

;********** Key Tables for File Editor *************** 
KeyVector4FileEditorLo
 .byt PARTITION_NAVIGATE	
 .byt <fnNavLeft 
 .byt <fnNavRight
 .byt <fnNavDown 
 .byt <fnNavUp	  
 .byt <fnHome
 .byt <fnEnd
 .byt <JumpHelp	 
 .byt <JumpList
 .byt <JumpPattern
 .byt <JumpSFX
 .byt PARTITION_OPERATERS	
 .byt <fnLoad	   
 .byt <fnLoad	   
 .byt <fnSave	   
 .byt <fnRefresh 
 .byt <fnKeyFilter
 .byt <fnPrint	  
 .byt <fnDrive
 .byt PARTITION_PLAY	
 .byt <fnPlay	   

KeyVector4FileEditorHi
 .byt PARTITION_NAVIGATE	
 .byt >fnNavLeft 
 .byt >fnNavRight
 .byt >fnNavDown 
 .byt >fnNavUp	  
 .byt >fnHome
 .byt >fnEnd
 .byt >JumpHelp	 
 .byt >JumpList
 .byt >JumpPattern
 .byt >JumpSFX
 .byt PARTITION_OPERATERS	
 .byt >fnLoad	   
 .byt >fnLoad	   
 .byt >fnSave	   
 .byt >fnRefresh 
 .byt >fnKeyFilter
 .byt >fnPrint	  
 .byt >fnDrive
 .byt PARTITION_PLAY	
 .byt >fnPlay	   

KeyDescriptionPointers4FileEditor
 .byt PARTITION_NAVIGATE	
 .byt 2	;fnNavLeft 
 .byt 3	;fnNavRight
 .byt 5	;fnNavDown 
 .byt 4	;fnNavUp	  
 .byt 6	;fnHome
 .byt 7	;fnEnd
 .byt 48	;JumpHelp	 
 .byt 30	;JumpList
 .byt 20	;JumpPattern
 .byt 29	;JumpSFX
 .byt PARTITION_OPERATERS	
 .byt 78	;fnLoad	   
 .byt 78	;fnLoad	   
 .byt 79	;fnSave	   
 .byt 80	;fnRefresh 
 .byt 81	;fnKeyFilter
 .byt 82	;fnPrint	  
 .byt 84	;fnDrive
 .byt PARTITION_PLAY	
 .byt 46	;fnPlay	   

;Tables for TrackList Routine
SongStartIndex
 .dsb 32,0

;0123456789012345678901234567890123456789
;N00-A 01-A 02-E 01-N 03-B 10-C 09-C 08-T
;MC0VXmC0VXmC0VXmC0VXmC0VXmC0VXmC0VXmC0VX
PatternCursorIndex2ScreenIndex
 .byt 1,2,3,4
 .byt 6,7,8,9
 .byt 11,12,13,14
 .byt 16,17,18,19
 .byt 21,22,23,24
 .byt 26,27,28,29
 .byt 31,32,33,34
 .byt 36,37,38,39

ListCursorIndex2ScreenIndex
 .byt 1,4
 .byt 6,9
 .byt 11,14
 .byt 16,19
 .byt 21,24
 .byt 26,29
 .byt 31,34
 .byt 36,39
ListCursorIndex2ScreenLength
 .byt 3,1
 .byt 3,1
 .byt 3,1
 .byt 3,1
 .byt 3,1
 .byt 3,1
 .byt 3,1
 .byt 3,1
 
SFXRangeThreshold	;27
 .byt 0	;00 Positive Pitch Offset 1-25
 .byt 25	;01 Negative Pitch Offset 1-25
 .byt 50	;02 Positive Note Offset 1-25
 .byt 75	;03 Negative Note Offset 1-25
 .byt 100	;04 Positive Volume Offset 1 to 15
 .byt 115	;05 Negative Volume Offset 1 to 15
 .byt 130 ;06 Positive Noise Offset 1 to 16
 .byt 146 ;07 Negative Noise Offset 1 to 16
 .byt 162 ;08 Positive EG Offset 1 to 8
 .byt 170 ;09 Negative EG Offset 1 to 8
 .byt 178 ;10 Envelope Off(0) or On(1)
 .byt 180 ;11 Tone On(0) or Off(1)
 .byt 182 ;12 Noise On(0) or Off(1)
 .byt 184 ;13 Skip Loop when Volume Over
 .byt 185 ;14 Skip Loop when Counter Over
 .byt 186 ;15 Skip Loop unconditionally
 .byt 187 ;17 Filter 1 to 4
 .byt 192 ;18 Delay 1 to 10
 .byt 202	;19 Set Counter 1 to 20
 .byt 221 ;20 End SFX
 .byt 222 ;21 Loop 0 to 24
 .byt 247 ;22 Random Delay
 .byt 248 ;23 Random Noise
 .byt 249 ;24 Random Volume
 .byt 250	;25 Random Note
 .byt 251 ;26 Random Pitch
 .byt 252 ;27 EG Wave 1 to 4
 .byt 0	; We use this to permit one table to work out both min and max in range

;The data corresponds to the key offset to commands in the Key list.
;So the 19 is Command Pitch OFS which has two types (19,19).
;The index relates to the existing field index in the row being edited.
;For 19 thats indexes 0 and 1 which correspond to 0(+ Pitch) and 25(- Pitch)
GroupPerKeyIndex				   ;
 .byt 19,19,20,20,21,21,22,22,23,23,24,25,26,27,27,27,28,29,30,31,32,33,33,33,33,33,34
;This simply points to the first value if the command type selected is different to the
;command in situ.
FirstRangeInGroup
 .byt 0,50,100,130,162,178,180,182,184,187,192,202,221,222,247,252

seSFXTextLo
 .byt <seSFXText0
 .byt <seSFXText1
 .byt <seSFXText2
 .byt <seSFXText3
 .byt <seSFXText4
 .byt <seSFXText5
 .byt <seSFXText6
 .byt <seSFXText7
 .byt <seSFXText8
 .byt <seSFXText9
 .byt <seSFXText10
 .byt <seSFXText11
 .byt <seSFXText12
 .byt <seSFXText13
 .byt <seSFXText14
 .byt <seSFXText15
; .byt <seSFXText16
 .byt <seSFXText17
 .byt <seSFXText18
 .byt <seSFXText19
 .byt <seSFXText20
 .byt <seSFXText21
 .byt <seSFXText22
 .byt <seSFXText23
 .byt <seSFXText24
 .byt <seSFXText25
 .byt <seSFXText26
 .byt <seSFXText27
seSFXTextHi
 .byt >seSFXText0
 .byt >seSFXText1
 .byt >seSFXText2
 .byt >seSFXText3
 .byt >seSFXText4
 .byt >seSFXText5
 .byt >seSFXText6
 .byt >seSFXText7
 .byt >seSFXText8
 .byt >seSFXText9
 .byt >seSFXText10
 .byt >seSFXText11
 .byt >seSFXText12
 .byt >seSFXText13
 .byt >seSFXText14
 .byt >seSFXText15
; .byt >seSFXText16
 .byt >seSFXText17
 .byt >seSFXText18
 .byt >seSFXText19
 .byt >seSFXText20
 .byt >seSFXText21
 .byt >seSFXText22
 .byt >seSFXText23
 .byt >seSFXText24
 .byt >seSFXText25
 .byt >seSFXText26
 .byt >seSFXText27


seSFXText0
 .byt 9,"INC PITCH BY",8,129
seSFXText1
 .byt 9,"DEC PITCH BY",8,129
seSFXText2
 .byt 9,"INC NOTE BY",8,129
seSFXText3
 .byt 9,"DEC NOTE BY",8,129
seSFXText4
 .byt 9,"INC VOLUME BY",8,129
seSFXText5
 .byt 9,"DEC VOLUME BY",8,129
seSFXText6
 .byt 9,"INC NOISE BY",8,129
seSFXText7
 .byt 9,"DEC NOISE BY",8,129
seSFXText8
 .byt 9,"INC EG PERIOD BY",8,129
seSFXText9
 .byt 9,"DEC EG PERIOD BY",8,129
seSFXText10
 .byt 9,"SET E FLAG",9,130
seSFXText11
 .byt 9,"SET T FLAG",9,130
seSFXText12
 .byt 9,"SET N FLAG",9,130
seSFXText13
 .byt 9,"SKIP LOOP ON VOLUME OVER",128
seSFXText14
 .byt 9,"SKIP LOOP ON COUNT OVER",128
seSFXText15
 .byt 9,"SKIP LOOP UNCONDITIONALLY",128
;seSFXText16
; .byt 9,"FILTER OFF",128
seSFXText17
 .byt 9,"SET FILTER",8,129
seSFXText18
 .byt 9,"DELAY",8,129
seSFXText19
 .byt 9,"SET COUNT TO",8,129
seSFXText20
 .byt 9,"END SFX!!",128
seSFXText21
 .byt 9,"LOOP TO ROW",8,132
seSFXText22
 .byt 9,"RND DELAY",128
seSFXText23
 .byt 9,"RND NOISE",128
seSFXText24
 .byt 9,"RND VOLUME",128
seSFXText25
 .byt 9,"RND NOTE",128
seSFXText26
 .byt 9,"RND PITCH",128
seSFXText27
 .byt 9,"SET EG WAVE",9,131

;" FILE List PATTERN SFX >HO -------- "
;  7777 7777 7777777 777 222 333 66666666
;" FILE LIST PATTERN SFX >HO S00 -------- "
;  PRESS ESC FOR HELP
;MainMenuRowText
TopRowText
 .byt 9,"PRESS",1,"ESC",7,"FOR HELP             "
; .byt 9,"FILE",9,"LIST",9,"PATTERN",9,"SFX",2,"abc",3,"S"
;MainMenuRowText_SongCount
; .byt "00",6,6



 
KeyDescriptionTexts
 .byt 146,130,0			;00 128 TRK LEFT               
 .byt 146,131,0  			;01 129 TRK RIGHT            
 .byt "LEFT",0      		;02 130 LEFT                 
 .byt "RIGHT",0     		;03 131 RIGHT                
 .byt "UP",0        		;04 132 UP                   
 .byt "DOWN",0      		;05 133 DOWN                 
 .byt "HOME",0        		;06 134 HOME               
 .byt 144,0         		;07 135 END                  
 .byt "OCTAVE",0	      		;08 136 OCTAVE            
 .byt "m ",147,"WAVE",0     		;09 137 COM EG WAVE   
 .byt "COMMAND H",0			;10 138 COM                        
 .byt "OFS",0			;11 139 OFFSET                  
 .byt "VAL",0			;12 140 VALUE                    
 .byt "FLAG",0			;13 141 FLAG                      
 .byt "NSE",0			;14 142 NOISE                    
 .byt "GAP",0			;15 143 GAP                        
 .byt "END",0			;16 144 END                        
 .byt "SFX",0			;17 145 SFX                  
 .byt "TRK",0			;18 146 TRK                    
 .byt "EG",0			;19 147 EG                          
 .byt 175,149,0			;20 148 GO PATTERN             
 .byt "PATTERN",0			;21 149 PATTERN                
 .byt "NOTE",0			;22 150 NOTE                      
 .byt "INC ",140,0			;23 151 INC VALUE              
 .byt "DEC ",140,0			;24 152 DEC VALUE              
 .byt "DEL ",140,0			;25 153 DEL VALUE          
 .byt 167,"LAST",0			;26 154 COPY LAST             
 .byt 167,"NEXT",0			;27 155 COPY NEXT             
 .byt 175,0			;28 156 GO
 .byt 175,145,0			;29 157 GO SFX              
 .byt 175,"LIST",0			;30 158 GO ListS          
 .byt "GRAB",0			;31 159 GRAB                      
 .byt "DROP",0			;32 160 DROP                      
 .byt "BAR",0			;33 161 BAR                        
 .byt 183,133,0			;34 162 HL DOWN              
 .byt 183,132,0			;35 163 HL UP                
 .byt 183,130,0			;36 164 HL LEFT              
 .byt 183,131,0			;37 165 HL RIGHT             
 .byt 183,"ALL",0			;38 166 HL ALL             
 .byt "COPY",0			;39 167 COPY                      
 .byt "PASTE",0			;40 168 PASTE                    
 .byt "CUT",0			;41 169 CUT                        
 .byt "MERGE",0			;42 170 MERGE                    
 .byt "l PAT",0			;43 171 < PATTN
 .byt "l ",218,0			;44 172 < SONG   
 .byt "MUTE",146,0			;45 173 MUTE TRK  
 .byt "l",0			;46 174 PLAY                      
 .byt "GO",0			;47 175 GO                      
 .byt 175,"HELP",0			;48 176 GO HELP             
 .byt "LOOKUP",0			;49 177 LOOKUP                  
 .byt "TOGGLE",0			;50 178 TOGGLE                  
 .byt "INS ",143,0			;51 179 INSERT GAP           
 .byt "DEL ",143,0			;52 180 DELETE GAP           
 .byt "ACTION",0			;53 181 ACTION                  
 .byt "QUIT!!",0			;54 182 QUIT!!                  
 .byt "HL",0			;55 183 HL                  
 .byt "mP-",139,0			;56 184 COM P-OFS  
 .byt "mN-",139,0			;57 185 COM N-OFS
 .byt "mV-",139,0			;58 186 COM V-OFS
 .byt "mNS-",139,0	     		;59 187 COM NS-OFS
 .byt "mE-",139,0     		;60 188 COM E-OFS
 .byt "mE-",141,0     		;61 189 COM E-FLAG      
 .byt "mT-",141,0	     		;62 190 COM T-FLAG 
 .byt "mNS-",141,0	     		;63 191 COM NS-FLAG  
 .byt "m","SKIP CND",0	     	;64 192 COM SKIP COND
 .byt "m",144,145,0		     	;65 193 COM END SFX  
 .byt "m",209,0     		;66 194 COM FILTER      
 .byt "m","DELAY",0	     		;67 195 COM DELAY       
 .byt "m","COUNTER",0     		;68 196 COM COUNTER    
 .byt "m","LOOP",0	     		;69 197 COM LOOP         
 .byt "m","RANDOM",0     		;70 198 COM RANDOM      
 .byt "DEC",0			;71 199 DEC
 .byt "INC",0			;72 200 INC
 .byt 199,145,0			;73 201 DEC SFX
 .byt 200,145,0			;74 202 INC SFX
 .byt "MOVE",0			;75 203 ENTRY
 .byt 203,133,0			;76 204 ENTRY DOWN
 .byt 203,132,0			;77 205 ENTRY UP
 .byt "LOAD",0			;78 206 LOAD
 .byt "SAVE",0			;79 207 SAVE
 .byt "REFRESH",0			;80 208 REFRESH
 .byt "FILTER",0			;81 209 FILTER
 .byt "PRINT",0			;82 210 PRINT
 .byt 175,"FILE",0			;83 211 GO FILE
 .byt "DRIVE",0			;84 212 DRIVE
 .byt "REST",0			;85 213 REST
 .byt "MIMIC",0			;86 214 MIMIC
 .byt 214,"<",0			;87 215 MIMIC <
 .byt 214,">",0			;88 216 MIMIC >
 .byt "m","NEW",218,0		;89 217 COM NEW SONG
 .byt "SONG",0			;90 218 SONG
 .byt "m",144,0			;91 219 COM END
 .byt "m","FADE",0			;92 220 COM FADE
 .byt "m","IRQ",0			;93 221 COM LOOP
 .byt "m","SHARING",0		;94 222 COM TMSLOT
 .byt "m",136,0			;95 223 COM OCTAVE
 .byt "m","RES'S",0			;96 224 COM SYSTEM
 .byt "l CRSR",0			;97 225 < CRSR
 .byt "NAME ",145,0			;98 226 NAME SFX
 .byt "m FLAG",0			;99 227 c FLAG
 .byt "PREV ",218,0			;100228 PREV SONG
 .byt "NEXT ",218,0			;101229 NEXT SONG
 .byt "TRACKS",0			;102230 TRACKS
 .byt "m TR-OUT",0			;103231 TR-OUT
 .byt "m TR-IN",0			;104232
 .byt "m TEMPO",0			;105233
 .byt "m P-BEND",0			;106234
 .byt "l STOP",0			;107235
 .byt "BLUE ROW",0			;108236
 .byt "NEW PAT",0			;109237
 .byt "X DROP",0			;110238
 .byt "PAGE ",38,0			;111239 PAGE UP
 .byt "PAGE ",37,0			;112240 PAGE DOWN
 .byt "m ",147,"PER",0		;113241 EG PERIOD
hpSoftKeyCharacter
 .byt 9
 .byt "S"+128
 .byt 9
 .byt "F"+128
 .byt "C"+128
 
HelpPlotScreenLo
 .byt <$BBA8
 .byt <$BBA8+40*1
 .byt <$BBA8+40*2
 .byt <$BBA8+40*3
 .byt <$BBA8+40*4
 .byt <$BBA8+40*5
 .byt <$BBA8+40*6
 .byt <$BBA8+40*7
 .byt <$BBA8+40*8
 .byt <$BBA8+40*9
 .byt <$BBA8+40*10
 .byt <$BBA8+40*11
 .byt <$BBA8+40*12
 .byt <$BBA8+40*13
 .byt <$BBA8+40*14
 .byt <$BBA8+40*15
 .byt <$BBA8+40*16
 .byt <$BBA8+40*17
 .byt <$BBA8+40*18
 .byt <$BBA8+40*19
 .byt <$BBA8+40*20
 .byt <$BBA8+40*21
 .byt <$BBA8+40*22
 .byt <$BBA8+40*23
 .byt <$BBA8+40*24
 .byt <$BBA8+40*25
 .byt <$BBA8+13
 .byt <$BBA8+13+40*1
 .byt <$BBA8+13+40*2
 .byt <$BBA8+13+40*3
 .byt <$BBA8+13+40*4
 .byt <$BBA8+13+40*5
 .byt <$BBA8+13+40*6
 .byt <$BBA8+13+40*7
 .byt <$BBA8+13+40*8
 .byt <$BBA8+13+40*9
 .byt <$BBA8+13+40*10
 .byt <$BBA8+13+40*11
 .byt <$BBA8+13+40*12
 .byt <$BBA8+13+40*13
 .byt <$BBA8+13+40*14
 .byt <$BBA8+13+40*15
 .byt <$BBA8+13+40*16
 .byt <$BBA8+13+40*17
 .byt <$BBA8+13+40*18
 .byt <$BBA8+13+40*19
 .byt <$BBA8+13+40*20
 .byt <$BBA8+13+40*21
 .byt <$BBA8+13+40*22
 .byt <$BBA8+13+40*23
 .byt <$BBA8+13+40*24
 .byt <$BBA8+13+40*25
 .byt <$BBA8+26
 .byt <$BBA8+26+40*1
 .byt <$BBA8+26+40*2
 .byt <$BBA8+26+40*3
 .byt <$BBA8+26+40*4
 .byt <$BBA8+26+40*5
 .byt <$BBA8+26+40*6
 .byt <$BBA8+26+40*7
 .byt <$BBA8+26+40*8
 .byt <$BBA8+26+40*9
 .byt <$BBA8+26+40*10
 .byt <$BBA8+26+40*11
 .byt <$BBA8+26+40*12
 .byt <$BBA8+26+40*13
 .byt <$BBA8+26+40*14
 .byt <$BBA8+26+40*15
 .byt <$BBA8+26+40*16
 .byt <$BBA8+26+40*17
 .byt <$BBA8+26+40*18
 .byt <$BBA8+26+40*19
 .byt <$BBA8+26+40*20
 .byt <$BBA8+26+40*21
 .byt <$BBA8+26+40*22
 .byt <$BBA8+26+40*23
 .byt <$BBA8+26+40*24
 .byt <$BBA8+26+40*25
 
HelpPlotScreenHi
 .byt >$BBA8
 .byt >$BBA8+40*1
 .byt >$BBA8+40*2
 .byt >$BBA8+40*3
 .byt >$BBA8+40*4
 .byt >$BBA8+40*5
 .byt >$BBA8+40*6
 .byt >$BBA8+40*7
 .byt >$BBA8+40*8
 .byt >$BBA8+40*9
 .byt >$BBA8+40*10
 .byt >$BBA8+40*11
 .byt >$BBA8+40*12
 .byt >$BBA8+40*13
 .byt >$BBA8+40*14
 .byt >$BBA8+40*15
 .byt >$BBA8+40*16
 .byt >$BBA8+40*17
 .byt >$BBA8+40*18
 .byt >$BBA8+40*19
 .byt >$BBA8+40*20
 .byt >$BBA8+40*21
 .byt >$BBA8+40*22
 .byt >$BBA8+40*23
 .byt >$BBA8+40*24
 .byt >$BBA8+40*25
 .byt >$BBA8+13
 .byt >$BBA8+13+40*1
 .byt >$BBA8+13+40*2
 .byt >$BBA8+13+40*3
 .byt >$BBA8+13+40*4
 .byt >$BBA8+13+40*5
 .byt >$BBA8+13+40*6
 .byt >$BBA8+13+40*7
 .byt >$BBA8+13+40*8
 .byt >$BBA8+13+40*9
 .byt >$BBA8+13+40*10
 .byt >$BBA8+13+40*11
 .byt >$BBA8+13+40*12
 .byt >$BBA8+13+40*13
 .byt >$BBA8+13+40*14
 .byt >$BBA8+13+40*15
 .byt >$BBA8+13+40*16
 .byt >$BBA8+13+40*17
 .byt >$BBA8+13+40*18
 .byt >$BBA8+13+40*19
 .byt >$BBA8+13+40*20
 .byt >$BBA8+13+40*21
 .byt >$BBA8+13+40*22
 .byt >$BBA8+13+40*23
 .byt >$BBA8+13+40*24
 .byt >$BBA8+13+40*25
 .byt >$BBA8+26
 .byt >$BBA8+26+40*1
 .byt >$BBA8+26+40*2
 .byt >$BBA8+26+40*3
 .byt >$BBA8+26+40*4
 .byt >$BBA8+26+40*5
 .byt >$BBA8+26+40*6
 .byt >$BBA8+26+40*7
 .byt >$BBA8+26+40*8
 .byt >$BBA8+26+40*9
 .byt >$BBA8+26+40*10
 .byt >$BBA8+26+40*11
 .byt >$BBA8+26+40*12
 .byt >$BBA8+26+40*13
 .byt >$BBA8+26+40*14
 .byt >$BBA8+26+40*15
 .byt >$BBA8+26+40*16
 .byt >$BBA8+26+40*17
 .byt >$BBA8+26+40*18
 .byt >$BBA8+26+40*19
 .byt >$BBA8+26+40*20
 .byt >$BBA8+26+40*21
 .byt >$BBA8+26+40*22
 .byt >$BBA8+26+40*23
 .byt >$BBA8+26+40*24
 .byt >$BBA8+26+40*25
SpecialCharacterKey
 .byt 8
 .byt 9
 .byt 10
 .byt 11
 .byt 13
 .byt 27
 .byt 32
 .byt 127
SpecialCharacterChar
 .byt 35	;Normally Hash
 .byt 36	;Normally String
 .byt 37	;Normally Percent
 .byt 38	;Normally Ampersand
 .byt 42	;Normally Asterisk
 .byt 64	;Normally At
 .byt 94	;Normally Power
 .byt 95	;Normally Pound
;0123456789012345678901234567890123456789
;-vvvv TO MOVE v MODIFY v QUIT v EXIT!!
HelpPlotFooterText
 .byt 9,3,35,36,37,38," TO MOVE",7,42," MODIFY",2,64," BACK",6,"X QUIT!!  "
; .byt 9,"NAVIGATE, RETURN CHANGES OR ESC QUITS  "

JumpVectorLo
 .byt 0	;<JumpMenu	;0 Menu
 .byt <JumpList	;1 List Editor
 .byt <JumpPattern	;2 Pattern Editor
 .byt <JumpSFX	;3 SFX Editor
 .byt <JumpFile
JumpVectorHi
 .byt 0	;>JumpMenu	;0 Menu
 .byt >JumpList	;1 List Editor
 .byt >JumpPattern	;2 Pattern Editor
 .byt >JumpSFX	;3 SFX Editor
 .byt >JumpFile

;MenuVectorJumpLo
; .byt <JumpFile
; .byt <JumpList
; .byt <JumpPattern
; .byt <JumpSFX
; .byt <JumpPlay
; .byt <JumpPause
; .byt <JumpStop
; .byt <JumpSelectSong
; .byt <JumpSelectMonitorView
;MenuVectorJumpHi
; .byt >JumpFile
; .byt >JumpList
; .byt >JumpPattern
; .byt >JumpSFX
; .byt >JumpPlay
; .byt >JumpPause
; .byt >JumpStop
; .byt >JumpSelectSong
; .byt >JumpSelectMonitorView

;0123456789012345678901234567890123456789
eeLegend
; ---------- CURRENT SONG "1234567890123"
 .byt 9,"---------- CURRENT SONG ",34
eeLegend_SongName
 .byt "             ",34

peLegend
; REST REST REST REST REST REST REST REST
 .byt 9,"REST REST REST REST REST REST REST REST"

seLegend
; ---------------- SFX 03 - "12345678"
 .byt 9,"SFX"
seLegend_SFXNumber
 .byt "00",2,34
seLegend_SFXName
 .byt "        ",34,3,"V-"
seLegend_VRES
 .byt "4BIT N-"
seLegend_NRES
 .byt "5BIT",7,"NOTE",8
seLegend_SFXNote
 .byt "C3"
seLegend_SFXVolume
 .byt "1"


SFXGrabbedRowStatus
 .byt 9,"                         GRABBED ROW "
SFXGrabbedRowStatus_Entry
 .byt "--"
PatternGrabbedStatus
 .byt 9,"                                 -",8
PatternGrabbedStatus_Entry
 .byt "----"


fnExtensionText
 .byt "  ELUDOM"	;AY0 List,Patterns,SFX,SFX Names,Key Preferences	93 
 .byt "   CISUM"	;AY1 List,Patterns,SFX,SFX Names                    
 .byt "    TSIL"	;AY2 List                                           
 .byt "SNRETTAP"	;AY3 Patterns                                       
 .byt "     XFS"	;AY4 SFX,SFX Names                                  
 .byt "    SYEK"	;AY5 Key Preferences                                
 .byt "   ERAPS"	;AY6 Not Used (Eventually Digidrum)                 
 .byt "EPYT YNA"	;AY? 
FilterCharacter
 .byt "0123456?"

fnDiscDirText
 .byt 34,"a-*.AY"
fnFilterPoint
 .byt "?",34,00
 
fnFileTypeStartVectorLo
 .byt <ListMemory		;AY0 List,Patterns,SFX,SFX Names,Key Preferences	93 
 .byt <ListMemory		;AY1 List,Patterns,SFX,SFX Names                    
 .byt <ListMemory		;AY2 List                                           
 .byt <PatternMemory	;AY3 Patterns                                       
 .byt <SFXMemory		;AY4 SFX,SFX Names                                  
 .byt <KeyPreferences	;AY5 Key Preferences                                
 .byt 0                       ;AY6 Not Used (Eventually Digidrum)                 
fnFileTypeStartVectorHi
 .byt >ListMemory		;AY0 List,Patterns,SFX,SFX Names,Key Preferences	93 
 .byt >ListMemory		;AY1 List,Patterns,SFX,SFX Names                    
 .byt >ListMemory		;AY2 List                                           
 .byt >PatternMemory	;AY3 Patterns                                       
 .byt >SFXMemory		;AY4 SFX,SFX Names                                  
 .byt >KeyPreferences	;AY5 Key Preferences                                
 .byt 0                       ;AY6 Not Used (Eventually Digidrum)                 
fnFileTypeEndVectorLo
 .byt <EndOfKeyPreferences-1	;AY0 List,Patterns,SFX,SFX Names,Key Preferences	93 
 .byt <EndOfSFXNames-1	;AY1 List,Patterns,SFX,SFX Names                    
 .byt <EndOfListMemory-1	;AY2 List                                           
 .byt <EndOfPatternMemory-1	;AY3 Patterns                                       
 .byt <EndOfSFXNames-1	;AY4 SFX,SFX Names                                  
 .byt <EndOfKeyPreferences-1	;AY5 Key Preferences                                
 .byt 0                       ;AY6 Not Used (Eventually Digidrum)                 
fnFileTypeEndVectorHi
 .byt >EndOfKeyPreferences-1	;AY0 List,Patterns,SFX,SFX Names,Key Preferences	93 
 .byt >EndOfSFXNames-1	;AY1 List,Patterns,SFX,SFX Names                    
 .byt >EndOfListMemory-1	;AY2 List                                           
 .byt >EndOfPatternMemory-1	;AY3 Patterns                                       
 .byt >EndOfSFXNames-1	;AY4 SFX,SFX Names                                  
 .byt >EndOfKeyPreferences-1	;AY5 Key Preferences                                
 .byt 0                       ;AY6 Not Used (Eventually Digidrum)                 
fnTypeLetter
 .byt "OUIAFEPN"

fnFilenameScreenLocLo
 .byt <$BBA9
 .byt <$BBA9+40*1
 .byt <$BBA9+40*2
 .byt <$BBA9+40*3
 .byt <$BBA9+40*4
 .byt <$BBA9+40*5
 .byt <$BBA9+40*6
 .byt <$BBA9+40*7
 .byt <$BBA9+40*8
 .byt <$BBA9+40*9
 .byt <$BBA9+40*10
 .byt <$BBA9+40*11
 .byt <$BBA9+40*12
 .byt <$BBA9+40*13
 .byt <$BBA9+40*14
 .byt <$BBA9+40*15
 .byt <$BBA9+40*16
 .byt <$BBA9+40*17
 .byt <$BBA9+40*18
 .byt <$BBA9+40*19
 .byt <$BBA9+40*20
 .byt <$BBA9+40*21
 .byt <$BBA9+40*22
 .byt <$BBA9+40*23
 .byt <$BBA9+40*24
 .byt <$BBA9+40*25
 .byt <$BBA9+20
 .byt <$BBA9+20+40*1
 .byt <$BBA9+20+40*2
 .byt <$BBA9+20+40*3
 .byt <$BBA9+20+40*4
 .byt <$BBA9+20+40*5
 .byt <$BBA9+20+40*6
 .byt <$BBA9+20+40*7
 .byt <$BBA9+20+40*8
 .byt <$BBA9+20+40*9
 .byt <$BBA9+20+40*10
 .byt <$BBA9+20+40*11
 .byt <$BBA9+20+40*12
 .byt <$BBA9+20+40*13
 .byt <$BBA9+20+40*14
 .byt <$BBA9+20+40*15
 .byt <$BBA9+20+40*16
 .byt <$BBA9+20+40*17
 .byt <$BBA9+20+40*18
 .byt <$BBA9+20+40*19
 .byt <$BBA9+20+40*20
 .byt <$BBA9+20+40*21
 .byt <$BBA9+20+40*22
 .byt <$BBA9+20+40*23
 .byt <$BBA9+20+40*24
 .byt <$BBA9+20+40*25
fnFilenameScreenLocHi
 .byt >$BBA9
 .byt >$BBA9+40*1
 .byt >$BBA9+40*2
 .byt >$BBA9+40*3
 .byt >$BBA9+40*4
 .byt >$BBA9+40*5
 .byt >$BBA9+40*6
 .byt >$BBA9+40*7
 .byt >$BBA9+40*8
 .byt >$BBA9+40*9
 .byt >$BBA9+40*10
 .byt >$BBA9+40*11
 .byt >$BBA9+40*12
 .byt >$BBA9+40*13
 .byt >$BBA9+40*14
 .byt >$BBA9+40*15
 .byt >$BBA9+40*16
 .byt >$BBA9+40*17
 .byt >$BBA9+40*18
 .byt >$BBA9+40*19
 .byt >$BBA9+40*20
 .byt >$BBA9+40*21
 .byt >$BBA9+40*22
 .byt >$BBA9+40*23
 .byt >$BBA9+40*24
 .byt >$BBA9+40*25
 .byt >$BBA9+20
 .byt >$BBA9+20+40*1
 .byt >$BBA9+20+40*2
 .byt >$BBA9+20+40*3
 .byt >$BBA9+20+40*4
 .byt >$BBA9+20+40*5
 .byt >$BBA9+20+40*6
 .byt >$BBA9+20+40*7
 .byt >$BBA9+20+40*8
 .byt >$BBA9+20+40*9
 .byt >$BBA9+20+40*10
 .byt >$BBA9+20+40*11
 .byt >$BBA9+20+40*12
 .byt >$BBA9+20+40*13
 .byt >$BBA9+20+40*14
 .byt >$BBA9+20+40*15
 .byt >$BBA9+20+40*16
 .byt >$BBA9+20+40*17
 .byt >$BBA9+20+40*18
 .byt >$BBA9+20+40*19
 .byt >$BBA9+20+40*20
 .byt >$BBA9+20+40*21
 .byt >$BBA9+20+40*22
 .byt >$BBA9+20+40*23
 .byt >$BBA9+20+40*24
 .byt >$BBA9+20+40*25

fnDirectoryRefreshText
 .byt 9,"PLEASE WAIT, REFRESHING DIRECTORY...   "

;0123456789012345678901234567890123456789
; ERR;--   "A-MYNEWTUNE"   SHOW PATTERNS
; ERR;00 "A-MYNEWTUNE" 1942FREE  PATTERNS
fnStatusBar
 .byt 9,"ERR:"
fnStatusBar_ErrorNumber
 .byt "00",3,34
fnStatusBar_Filename
 .byt "A-MYNEWTUNE",34,2
fnStatusBar_SectorsFree
 .byt "---- FREE",7
fnStatusBar_ShowAreaName
 .byt "MODULE  "

;fnNormalStatusBar
; .byt 9,"ERR:--   ",34
;fnStatusFilename
; .byt "A-MYNEWTUNE",34,"   SHOW "
; .byt "PATTERNS "

MonitorCPULoadText
 .byt 2,"LOAD 99% "
MonitorVolumeLevelCharacterSet
 .byt %000000	;100 (d) - Level 0 Volume (Play Monitor)
 .byt %000000
 .byt %000000
 .byt %000000
 .byt %000000
 .byt %000000
 .byt %000000
 .byt %000000

 .byt %000000	;101 (e) - Level 1 Volume (Play Monitor)
 .byt %000000
 .byt %000000
 .byt %000000
 .byt %000000
 .byt %000000
 .byt %011110
 .byt %000000

 .byt %000000	;102 (f) - Level 2 Volume (Play Monitor)
 .byt %000000
 .byt %000000
 .byt %000000
 .byt %000000
 .byt %011110
 .byt %011110
 .byt %000000

 .byt %000000	;103 (g) - Level 3 Volume (Play Monitor)
 .byt %000000
 .byt %000000
 .byt %000000
 .byt %011110
 .byt %011110
 .byt %011110
 .byt %000000

 .byt %000000	;104 (h) - Level 4 Volume (Play Monitor)
 .byt %000000
 .byt %000000
 .byt %011110
 .byt %011110
 .byt %011110
 .byt %011110
 .byt %000000

 .byt %000000	;105 (i) - Level 5 Volume (Play Monitor)
 .byt %000000
 .byt %011110
 .byt %011110
 .byt %011110
 .byt %011110
 .byt %011110
 .byt %000000

 .byt %000000	;106 (j) - Level 6 Volume (Play Monitor)
 .byt %011110
 .byt %011110
 .byt %011110
 .byt %011110
 .byt %011110
 .byt %011110
 .byt %000000

 .byt %011110	;107 (k) - Level 7 Volume (Play Monitor)
 .byt %011110
 .byt %011110
 .byt %011110
 .byt %011110
 .byt %011110
 .byt %011110
 .byt %000000
MonitorVolumeLevelCharacters
 .byt "defghijk"

ipValidCharacter
TrackLetter
 .byt "ABCDEFGHIJKLMNOPQRSTUVWXYZ"	;0-25
 .byt " "				;26
 .byt "',-./;=[\]"			;27-36
fnExtensionCharacter3
 .byt "0123456789"			;37-46
CharacterType
 .byt 0
 .byt 0
 .byt 0
 .byt 0
 .byt 0
 .byt 0
 .byt 0
 .byt 0
 .byt 0
 .byt 0
 .byt 0
 .byt 0
 .byt 0
 .byt 0
 .byt 0
 .byt 0
 .byt 0
 .byt 0
 .byt 0
 .byt 0
 .byt 0
 .byt 0
 .byt 0
 .byt 0
 .byt 0
 .byt 0
 .byt 1
 .byt 2
 .byt 2
 .byt 2
 .byt 2
 .byt 2
 .byt 2
 .byt 2
 .byt 2
 .byt 2
 .byt 2
 .byt 3
 .byt 3
 .byt 3
 .byt 3
 .byt 3
 .byt 3
 .byt 3
 .byt 3
 .byt 3
 .byt 3
CharacterTypeVectorLo
 .byt <ipProcLetter
 .byt <ipProcSpace
 .byt <ipProcPunctuation
 .byt <ipProcNumeric
CharacterTypeVectorHi
 .byt >ipProcLetter
 .byt >ipProcSpace
 .byt >ipProcPunctuation
 .byt >ipProcNumeric
SureText
 .byt 13,"SURE YN?"
PatternContextual	;16x8
 .byt "A-RESTED TRACK  "
 .byt "A-NOTE          "
 .byt "A-OCTAVE        "
 .byt "A-VOLUME        "
 .byt "A-SFX ",34,"        ",34
 .byt "A-REST          "
 .byt "A-VRST          "
 .byt "A-BAR           "


;The CopyBuffer is set to the size of a group of Pattern Tracks
;which is 8*(64*2) == 1024Bytes
peCopyTrackStart	.byt 0
peCopyTrackEnd	.byt 0
peCopyRowStart	.byt 0
peCopyRowEnd	.byt 0
peCopyTracks	.byt 0
peCopiedTracks	.byt 0

CopyByteCount	.dsb 2,0
CopyEditor	.byt 128
CopyBuffer
 .dsb 1024,0

ParsedFilename
 .dsb 15,0	

 
hpoldtext
 .dsb 13,32

hpEditorText
;0 Menu
 .byt "    MENU"
;1 List Editor
 .byt "    LIST"
;2 Pattern Editor
 .byt " PATTERN"
;3 SFX Editor
 .byt "     SFX"
;4 File Editor
 .byt "    FILE"

veSFXTypeVectorLo
 .byt <veNoChange	;prProc_SFXPositivePitch
 .byt <veNoChange	;prProc_SFXNegativePitch
 .byt <veNoChange	;prProc_SFXPositiveNote
 .byt <veNoChange	;prProc_SFXNegativeNote
 .byt <vePlusVol	;prProc_SFXPositiveVolume
 .byt <veMinusVol	;prProc_SFXNegativeVolume
 .byt <veNoChange	;prProc_SFXPositiveNoise
 .byt <veNoChange	;prProc_SFXNegativeNoise
 .byt <veNoChange	;prProc_SFXPositiveEGPeriod
 .byt <veNoChange	;prProc_SFXNegativeEGPeriod
 .byt <veNoChange	;prProc_SFXSwitchEG
 .byt <veNoChange	;prProc_SFXSwitchTone
 .byt <veNoChange	;prProc_SFXSwitchNoise
 .byt <veSkipCond	;prProc_SFXSetSkipCondition
 .byt <veNoChange	;prProc_SFXFilter
 .byt <veSetDelay	;prProc_SFXDelay
 .byt <veSetCount	;prProc_SFXSetCounter
 .byt <veEndSFX	;prProc_SFXEndSFX
 .byt <veSFXLoop	;prProc_SFXLoop
 .byt <veRNDDelay	;prProc_SFXRandomDelay
 .byt <veNoChange	;prProc_SFXRandomNoise
 .byt <veRNDVol	;prProc_SFXRandomVolume
 .byt <veNoChange	;prProc_SFXRandomNote
 .byt <veNoChange	;prProc_SFXRandomPitch
 .byt <veNoChange	;prProc_SFXWave

veSFXTypeVectorHi
 .byt >veNoChange	;prProc_SFXPositivePitch
 .byt >veNoChange	;prProc_SFXNegativePitch
 .byt >veNoChange	;prProc_SFXPositiveNote
 .byt >veNoChange	;prProc_SFXNegativeNote
 .byt >vePlusVol	;prProc_SFXPositiveVolume
 .byt >veMinusVol	;prProc_SFXNegativeVolume
 .byt >veNoChange	;prProc_SFXPositiveNoise
 .byt >veNoChange	;prProc_SFXNegativeNoise
 .byt >veNoChange	;prProc_SFXPositiveEGPeriod
 .byt >veNoChange	;prProc_SFXNegativeEGPeriod
 .byt >veNoChange	;prProc_SFXSwitchEG
 .byt >veNoChange	;prProc_SFXSwitchTone
 .byt >veNoChange	;prProc_SFXSwitchNoise
 .byt >veSkipCond	;prProc_SFXSetSkipCondition
 .byt >veNoChange	;prProc_SFXFilter
 .byt >veSetDelay	;prProc_SFXDelay
 .byt >veSetCount	;prProc_SFXSetCounter
 .byt >veEndSFX	;prProc_SFXEndSFX
 .byt >veSFXLoop	;prProc_SFXLoop
 .byt >veRNDDelay	;prProc_SFXRandomDelay
 .byt >veNoChange	;prProc_SFXRandomNoise
 .byt >veRNDVol	;prProc_SFXRandomVolume
 .byt >veNoChange	;prProc_SFXRandomNote
 .byt >veNoChange	;prProc_SFXRandomPitch
 .byt >veNoChange	;prProc_SFXWave

	;00-15 Pitchbend	c0p-
	;16    Trigger Out	c0-q
	;17    Trigger In	c0-q
	;18    Note Tempo	c0-q
	;19-34 EG Cycle	c0-q
	;35-50 EG Period	c0pq
	;51-60 -            ----
	;61    Rest	----
	;62    -		----
	;63    Bar	====
	;Only display command flag if command id 0-15 or 19-34
	lda ModifyParamFlags,x
	and #%11000000
	cmp #%01000000
.(
	bne skip1
	lda PatternEntryByte1
	sta PatternRowCommandChannelActivity
skip1	iny
.)
	lda cpDigit0,x

cpDigit0
 .byt SIXTYFOUR_CHARACTERBASE		;00-15 Pitchbend	c0p-
 .byt SIXTYFOUR_CHARACTERBASE+1	;00-15 Pitchbend	c0p-
 .byt SIXTYFOUR_CHARACTERBASE+2	;00-15 Pitchbend	c0p-
 .byt SIXTYFOUR_CHARACTERBASE+3	;00-15 Pitchbend	c0p-
 .byt SIXTYFOUR_CHARACTERBASE+4	;00-15 Pitchbend	c0p-
 .byt SIXTYFOUR_CHARACTERBASE+5	;00-15 Pitchbend	c0p-
 .byt SIXTYFOUR_CHARACTERBASE+6	;00-15 Pitchbend	c0p-
 .byt SIXTYFOUR_CHARACTERBASE+7	;00-15 Pitchbend	c0p-
 .byt SIXTYFOUR_CHARACTERBASE+8	;00-15 Pitchbend	c0p-
 .byt SIXTYFOUR_CHARACTERBASE+9	;00-15 Pitchbend	c0p-
 .byt SIXTYFOUR_CHARACTERBASE+10	;00-15 Pitchbend	c0p-
 .byt SIXTYFOUR_CHARACTERBASE+11	;00-15 Pitchbend	c0p-
 .byt SIXTYFOUR_CHARACTERBASE+12	;00-15 Pitchbend	c0p-
 .byt SIXTYFOUR_CHARACTERBASE+13	;00-15 Pitchbend	c0p-
 .byt SIXTYFOUR_CHARACTERBASE+14	;00-15 Pitchbend	c0p-
 .byt SIXTYFOUR_CHARACTERBASE+15	;00-15 Pitchbend	c0p-
 .byt HYPHEN_CHARACTER+128		;16    Trigger Out	c0-q
 .byt HYPHEN_CHARACTER+128		;17    Trigger In	c0-q
 .byt HYPHEN_CHARACTER+128		;18    Note Tempo	c0-q
 .byt SIXTYFOUR_CHARACTERBASE		;19-34 EG Period	c0pq
 .byt SIXTYFOUR_CHARACTERBASE+1	;19-34 EG Period	c0pq
 .byt SIXTYFOUR_CHARACTERBASE+2	;19-34 EG Period	c0pq
 .byt SIXTYFOUR_CHARACTERBASE+3	;19-34 EG Period	c0pq
 .byt SIXTYFOUR_CHARACTERBASE+4	;19-34 EG Period	c0pq
 .byt SIXTYFOUR_CHARACTERBASE+5	;19-34 EG Period	c0pq
 .byt SIXTYFOUR_CHARACTERBASE+6	;19-34 EG Period	c0pq
 .byt SIXTYFOUR_CHARACTERBASE+7	;19-34 EG Period	c0pq
 .byt SIXTYFOUR_CHARACTERBASE+8	;19-34 EG Period	c0pq
 .byt SIXTYFOUR_CHARACTERBASE+9	;19-34 EG Period	c0pq
 .byt SIXTYFOUR_CHARACTERBASE+10	;19-34 EG Period	c0pq
 .byt SIXTYFOUR_CHARACTERBASE+11	;19-34 EG Period	c0pq
 .byt SIXTYFOUR_CHARACTERBASE+12	;19-34 EG Period	c0pq
 .byt SIXTYFOUR_CHARACTERBASE+13	;19-34 EG Period	c0pq
 .byt SIXTYFOUR_CHARACTERBASE+14	;19-34 EG Period	c0pq
 .byt SIXTYFOUR_CHARACTERBASE+15	;19-34 EG Period	c0pq
 
 .byt SIXTYFOUR_CHARACTERBASE+128   	;35-50 -            ----
 .byt SIXTYFOUR_CHARACTERBASE+1+128 	;35-50 -            ----
 .byt SIXTYFOUR_CHARACTERBASE+2+128 	;35-50 -            ----
 .byt SIXTYFOUR_CHARACTERBASE+3+128 	;35-50 -            ----
 .byt SIXTYFOUR_CHARACTERBASE+4+128 	;35-50 -            ----
 .byt SIXTYFOUR_CHARACTERBASE+5+128 	;35-50 -            ----
 .byt SIXTYFOUR_CHARACTERBASE+6+128 	;35-50 -            ----
 .byt SIXTYFOUR_CHARACTERBASE+7+128 	;35-50 -            ----
 .byt SIXTYFOUR_CHARACTERBASE+8+128 	;35-50 -            ----
 .byt SIXTYFOUR_CHARACTERBASE+9+128 	;35-50 -            ----
 .byt SIXTYFOUR_CHARACTERBASE+10+128	;35-50 -            ----
 .byt SIXTYFOUR_CHARACTERBASE+11+128	;35-50 -            ----
 .byt SIXTYFOUR_CHARACTERBASE+12+128	;35-50 -            ----
 .byt SIXTYFOUR_CHARACTERBASE+13+128	;35-50 -            ----
 .byt SIXTYFOUR_CHARACTERBASE+14+128	;35-50 -            ----
 .byt SIXTYFOUR_CHARACTERBASE+15+128	;35-50 -            ----

 .byt HYPHEN_CHARACTER		;51-60 -            ----
 .byt HYPHEN_CHARACTER		;51-60 -            ----
 .byt HYPHEN_CHARACTER		;51-60 -            ----
 .byt HYPHEN_CHARACTER		;51-60 -            ----
 .byt HYPHEN_CHARACTER		;51-60 -            ----
 .byt HYPHEN_CHARACTER		;51-60 -            ----
 .byt HYPHEN_CHARACTER		;51-60 -            ----
 .byt HYPHEN_CHARACTER		;51-60 -            ----
 .byt HYPHEN_CHARACTER		;51-60 -            ----
 .byt HYPHEN_CHARACTER		;51-60 -            ----
 .byt HYPHEN_CHARACTER		;61    Rest	----
 .byt HYPHEN_CHARACTER		;62    -		----

PatternCommandRange		.byt 0

RowWideListCommandTextTemplateLo
 .byt <rwNewTemplate	;New Song
 .byt <rwEndTemplate	;End Song
 .byt <rwFadeTemplate	;Fade Song
 .byt <rwIRQTemplate	;System Speeds
 .byt <rwSharingTemplate	;Sharing
 .byt <rwOctaveTemplate	;Octave Settings
 .byt <rwResolutionsTemplate	;System Behaviour(Spare)
 .byt <rwReservedTemplate	;-
RowWideListCommandTextTemplateHi
 .byt >rwNewTemplate	;New Song
 .byt >rwEndTemplate	;End Song
 .byt >rwFadeTemplate	;Fade Song
 .byt >rwIRQTemplate	;System Speeds
 .byt >rwSharingTemplate	;Sharing
 .byt >rwOctaveTemplate	;Octave Settings
 .byt >rwResolutionsTemplate	;System Behaviour(Spare)
 .byt >rwReservedTemplate	;-
PatternBARRow
 .dsb 5,BAR_CHARACTER
 .byt TRACKPARTITION_CHARACTER
 .dsb 4,BAR_CHARACTER
 .byt TRACKPARTITION_CHARACTER
 .dsb 4,BAR_CHARACTER
 .byt TRACKPARTITION_CHARACTER
 .dsb 4,BAR_CHARACTER
 .byt TRACKPARTITION_CHARACTER
 .dsb 4,BAR_CHARACTER
 .byt TRACKPARTITION_CHARACTER
 .dsb 4,BAR_CHARACTER
 .byt TRACKPARTITION_CHARACTER
 .dsb 4,BAR_CHARACTER
 .byt TRACKPARTITION_CHARACTER
 .dsb 4,BAR_CHARACTER

;0123456789012345678901234567890123456789
;  NEW SONG '12345678901234' TEMPO 000
rwNewTemplate	;New Song
 .byt "NEW SONG ",34,1,34," TEMPO ",2,0
;0123456789012345678901234567890123456789
;  END OF SONG(SILENCED) LOOP ROW 000
rwEndTemplate	;End Song
 .byt "END SONG(",3,") LOOP ROW ",12,0
;0123456789012345678901234567890123456789
;  FADE SONG OUT AT RATE OF 15       
rwFadeTemplate	;Fade Song
 .byt "FADE SONG ",4," AT RATE OF ",2,0
;0123456789012345678901234567890123456789
;  SFX IRQ BASE 200Hz AT TEMPO 31 
rwIRQTemplate	;Loop Song
 .byt "SFX IRQ ",5,"HZ, MUSIC IRQ ",11,"HZ",0
;0123456789012345678901234567890123456789
;  SHARE PROCSFX ALOTTING 000 TICKS???
rwSharingTemplate	;Timeslot Behaviour
 .byt "SHARE ",6," ALOTTING ",2," TICKS",0
;.byt "SHARING IS ",6," AT ",2," TICKS",0

;0123456789012345678901234567890123456789
;  OFFSET NOTE BY C-3 ON TRACKS ABCDEFGH
;  OCTAVE RANGE 5-9 ON TRACKS ABCDEFGH
rwOctaveTemplate	;Octave Settings
  .byt "OFFSET NOTE BY",7,"ON TRACKS ",8,0
; .byt "OCTAVES ",7," ON TRACKS ",8,0		;0-4
;0123456789012345678901234567890123456789
;  RESOLUTIONS - VOLUME 4BIT, NOISE 5BIT
rwResolutionsTemplate	;System Behaviour
 .byt "RESOLUTIONS - NOISE ",10,"BIT, VOLUME ",9,"BIT",0
;0123456789012345678901234567890123456789
;  RESERVED (Could have other TSB rule like SFXs continue to process outside timeslot)
rwReservedTemplate	;Reserved
 .byt "RESERVED",0

rwcCursorFieldPosTableLo
 .byt <rwcNewPos	        
 .byt <rwcEndPos	        
 .byt <rwcFadePos	       
 .byt <rwcIRQPos	        
 .byt <rwcSharingPos	    
 .byt <rwcOctavePos	     
 .byt <rwcResolutionsPos	
 .byt <rwcReservedPos	   
rwcCursorFieldPosTableHi
 .byt >rwcNewPos	        
 .byt >rwcEndPos	        
 .byt >rwcFadePos	       
 .byt >rwcIRQPos	        
 .byt >rwcSharingPos	    
 .byt >rwcOctavePos	     
 .byt >rwcResolutionsPos	
 .byt >rwcReservedPos	   
rwcCursorFieldLenTableLo
 .byt <rwcNewLen	        
 .byt <rwcEndLen	        
 .byt <rwcFadeLen	       
 .byt <rwcIRQLen	        
 .byt <rwcSharingLen	    
 .byt <rwcOctaveLen	     
 .byt <rwcResolutionsLen	
 .byt <rwcReservedLen	   
rwcCursorFieldLenTableHi
 .byt >rwcNewLen
 .byt >rwcEndLen
 .byt >rwcFadeLen
 .byt >rwcIRQLen
 .byt >rwcSharingLen
 .byt >rwcOctaveLen
 .byt >rwcResolutionsLen
 .byt >rwcReservedLen


;0 New Music (Always set on Track A)
; 0123456789012345678901234567890123456789
;   NEW SONG '1234567890123' TEMPO 000
;             -------------        ---
rwcNewPos
 .byt 12,33
rwcNewLen
 .byt 13,3
;1 End of Song
; 0123456789012345678901234567890123456789
;   END OF SONG(SILENCED) LOOP ROW 000
;               --------           ---
rwcEndPos
 .byt 11,30
rwcEndLen
 .byt 8,3
;2 Fade Music (Always set on Track A)
; 0123456789012345678901234567890123456789
;   FADE SONG OUT AT RATE OF 255
;             ---            ---
rwcFadePos
 .byt 12,27
rwcFadeLen
 .byt 3,3
;3 SFX Settings
; 0123456789012345678901234567890123456789
;   SFX IRQ 200Hz MUSIC IRQ 25Hz
;                   ---            ---
rwcIRQPos
 .byt 10,27
rwcIRQLen
 .byt 5,5
;4 TimeSlot Behaviour
; 0123456789012345678901234567890123456789
;   TIMESLOT IS SHARED AT RATE OF 255 
;               ------            ---
rwcSharingPos
 .byt 8,25
rwcSharingLen
 .byt 7,3
;5 Octave Settings
; 0123456789012345678901234567890123456789
;   OCTAVES 0-4 ON TRACKS ABCDEFGH    
;           ---           --------
rwcOctavePos
 .byt 17,30
rwcOctaveLen
 .byt 2,8
;6 Resolution Settings
; 0123456789012345678901234567890123456789
;   RESOLUTIONS - NOISE 4BIT, VOLUME 5BIT
;                       -            -
rwcResolutionsPos
 .byt 22,35
rwcResolutionsLen
 .byt 1,1
;7 Reserved
; 0123456789012345678901234567890123456789
;   RESERVED
;   --------
rwcReservedPos
 .byt 2,2
rwcReservedLen
 .byt 8,8

rwTemplateEmbeddedFieldDisplayLo
 .byt <rwField1	;1 13 chars from D-H            
 .byt <rwField2	;2 3DD in C0-7
 .byt <rwField3	;3 SILENCED(A3=1) or _NORMAL_(0)
 .byt <rwField4	;4 IN_(A3=1) or OUT(0)          
 .byt <rwField5	;5 _25,_50,100,200(B0-1)        
 .byt <rwField6	;6 SHARED(A5=1) or NORMAL(0)    
 .byt <rwField7	;7 C-0 to B-5(D0-6)
 .byt <rwField8	;8 ABCDEFGH(C0-7)               
 .byt <rwField9	;9 6(A4=1) or 4(0)              
 .byt <rwField10	;A 7(A3=1) or 5(0)
 .byt <rwField11	;B _25,_50,100,200(C0-1)
 .byt <rwField12	;C 3DD in C0-7 (If 0 then ---)
rwTemplateEmbeddedFieldDisplayHi
 .byt >rwField1	;1 13 chars from D-H            
 .byt >rwField2	;2 3DD in C0-7                  
 .byt >rwField3	;3 SILENCED(A3=1) or _NORMAL_(0)
 .byt >rwField4	;4 IN_(A3=1) or OUT(0)          
 .byt >rwField5	;5 _25,_50,100,200(B0-1)        
 .byt >rwField6	;6 SHARED(A5=1) or NORMAL(0)    
 .byt >rwField7	;7 0-4,1-5,2-6,3-7,4-8,5-9(A3-5)
 .byt >rwField8	;8 ABCDEFGH(C0-7)               
 .byt >rwField9	;9 6(A3=1) or 4(0)              
 .byt >rwField10	;A 7(A4=1) or 5(0)              
 .byt >rwField11	;B 500,_1K,_2K,_3K(C0-1)
 .byt >rwField12	;C 3DD in C0-7 (If 0 then ---)
