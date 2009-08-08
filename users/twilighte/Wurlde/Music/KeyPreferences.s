;
;Common Controls
;CTRL+L List Editor
;CTRL+S SFX Editor
;CTRL+P Pattern Editor
;CTRL+F File Editor

;, Copy Last
;. Copy Next

HardKeys4ListEditor
 .byt PARTITION_NAVIGATE
 .byt 8	;eeNavTrackLeft	- CTRL Left
 .byt 9	;eeNavTrackRight    - CTRL Right
 .byt 8	;eeNavLeft          - Left
 .byt 9	;eeNavRight         - Right
 .byt 11	;eeNavUp            - Up
 .byt 10	;eeNavDown          - Down
 .byt 11	;eeHome             - CTRL Up
 .byt 10	;eeEnd              - CTRL Down
 .byt "-"	;leSongPrevious	- CTRL -
 .byt "="	;leSongNext	- CTRL =
 .byt "P"	;JumpPattern        - CTRL P
 .byt "S"	;JumpSFX         - CTRL S
 .byt "F"	;JumpFile           - CTRL F
 .byt 27	;JumpHelp           - CTRL H
 .byt "R" ;eeToggleBlue	- CTRL R
 .byt PARTITION_MODIFY
 .byt "="	;eeIncrement        - =
 .byt "-"	;eeDecrement        - -
 .byt 127	;eeReset            - DEL
 .byt 32	;eeToggle           - SPACE
 .byt "I"	;eeInsertGap	- CTRL I
 .byt "D"	;eeDeleteGap	- CTRL D
 .byt PARTITION_OPERATERS
 .byt "R"	;eeRest             - R
 .byt "T"	;eePattern          - T	- Set Tracks
 .byt ","	;eeComMimicLeft     - FUNC ,
 .byt "."	;eeComMimicRight    - FUNC .
 .byt "N"	;eeComNewSong       - FUNC N
 .byt "E"	;eeComEndSong       - FUNC E
 .byt "F"	;eeComFadeMusic     - FUNC F
 .byt "I"	;eeComIRQRates      - FUNC I
 .byt "S"	;eeComSharing       - FUNC S
 .byt "O"	;eeComOctaveRange   - FUNC O
 .byt "R"	;eeComResolutions   - FUNC R
 .byt "C"	;eeCommandH	- FUNC C
 .byt "A"	;eeAutoAssignPatterns FUNC A
 .byt PARTITION_COPYING
 .byt 10	;eeHilightDown      - SHFT Down
 .byt 11	;eeHilightUp        - SHFT Up
 .byt "C"	;eeCopy             - CTRL C
 .byt "X"	;eeCut              - CTRL X
 .byt "V"	;eePaste            - CTRL V
 .byt "J"	;eeGrab             - J
 .byt "K"	;eeDrop             - K
 .byt ","	;eeCopyLast	- ,
 .byt "." ;eeCopyNext	- .
 .byt PARTITION_PLAY
 .byt 13	;<eePlayCursor	- RETURN
 .byt 13	;<eePlaySong	- SHIFT RETURN
 .byt "S"	;<JumpAllStop	- SHFT S

SoftKeys4ListEditor
 .byt PARTITION_NAVIGATE
 .byt SOFT_CTRL	;eeNavTrackLeft	- CTRL Left
 .byt SOFT_CTRL	;eeNavTrackRight    - CTRL Right
 .byt 0		;eeNavLeft          - Left
 .byt 0		;eeNavRight         - Right
 .byt 0		;eeNavUp            - Up
 .byt 0		;eeNavDown          - Down
 .byt SOFT_CTRL	;eeHome             - CTRL Up
 .byt SOFT_CTRL	;eeEnd              - CTRL Down
 .byt SOFT_CTRL	;leSongPrevious	- CTRL -
 .byt SOFT_CTRL	;leSongNext	- CTRL =
 .byt SOFT_CTRL	;JumpPattern        - CTRL P
 .byt SOFT_CTRL	;JumpSFX         - CTRL S
 .byt SOFT_CTRL	;JumpFile           - CTRL F
 .byt 0		;JumpHelp           - CTRL H
 .byt SOFT_CTRL	;eeToggleBlue	- CTRL R
 .byt PARTITION_MODIFY
 .byt 0		;eeIncrement        - =
 .byt 0		;eeDecrement        - -
 .byt 0		;eeReset            - DEL
 .byt 0		;eeToggle           - SPACE
 .byt SOFT_CTRL	;eeInsertGap	- CTRL I
 .byt SOFT_CTRL	;eeDeleteGap	- CTRL D
 .byt PARTITION_OPERATERS
 .byt 0		;eeRest             - R
 .byt 0		;eePattern          - P
 .byt SOFT_FUNC	;eeComMimicLeft     - FUNC ,
 .byt SOFT_FUNC	;eeComMimicRight    - FUNC .
 .byt SOFT_FUNC	;eeComNewSong       - FUNC N
 .byt SOFT_FUNC	;eeComEndSong       - FUNC E
 .byt SOFT_FUNC	;eeComFadeMusic     - FUNC F
 .byt SOFT_FUNC	;eeComIRQRates      - FUNC I
 .byt SOFT_FUNC	;eeComSharing       - FUNC S
 .byt SOFT_FUNC	;eeComOctaveRange   - FUNC O
 .byt SOFT_FUNC	;eeComResolutions   - FUNC R
 .byt SOFT_FUNC	;eeCommandH	- FUNC C
 .byt SOFT_FUNC	;eeAutoAssignPatterns FUNC A
 .byt PARTITION_COPYING
 .byt SOFT_SHFT	;eeHilightDown      - SHFT Down
 .byt SOFT_SHFT	;eeHilightUp        - SHFT Up
 .byt SOFT_CTRL	;eeCopy             - CTRL C
 .byt SOFT_CTRL	;eeCut              - CTRL X
 .byt SOFT_CTRL	;eePaste            - CTRL V
 .byt 0		;eeGrab             - J
 .byt 0		;eeDrop             - K
 .byt 0		;eeCopyLast	- ,
 .byt 0 		;eeCopyNext	- .
 .byt PARTITION_PLAY
 .byt 0		;eePlayCursor	- RETURN
 .byt SOFT_SHFT	;eePlaySong	- SHIFT RETURN
 .byt SOFT_SHFT	;<JumpAllStop	- SHFT S


HardKeys4PatternEditor
 .byt PARTITION_NAVIGATE
 .byt 8	; peNavTrackLeft
 .byt 9	; peNavTrackRight
 .byt 8	; peNavLeft
 .byt 9	; peNavRight
 .byt 11	; peNavUp
 .byt 10	; peNavDown
 .byt 11	; peNavHome
 .byt 10	; peNavEnd
 .byt "L"	; JumpList
 .byt "S"	; JumpSFX
 .byt "F"	; JumpFile
 .byt 27	; JumpHelp
 .byt "R" ; peToggleBlue
 .byt PARTITION_MODIFY
 .byt "="	; peIncrement
 .byt "-"	; peDecrement
 .byt 127	; peReset
; .byt " "	; peToggle
 .byt "I"	; peInsert
 .byt "D"	; peDelete
 .byt 10	; peMoveEntryDown
 .byt 11	; peMoveEntryUp
 .byt PARTITION_OPERATERS
 .byt "0"	; peOctave
 .byt "1"	; peOctave
 .byt "2"	; peOctave
 .byt "3"	; peOctave
 .byt "4"	; peOctave
 .byt "5"	; peOctave
 .byt "6"	; peOctave
 .byt "7"	; peOctave
 .byt "8"	; peOctave
 .byt "9"	; peOctave
 .byt "C"	; peNote
 .byt "D"	; peNote
 .byt "E"	; peNote
 .byt "F"	; peNote
 .byt "G"	; peNote
 .byt "A"	; peNote
 .byt "B"	; peNote
 .byt "B"	; peBar		CTRL B
 .byt "C"	; peToggleCommand
 .byt "O"	; peCmdTriggerOut 	FUNC O
 .byt "I"	; peCmdTriggerIn  	FUNC I
 .byt "T"	; peCmdSongTempo  	FUNC T
 .byt "B"	; peCmdBend     	FUNC U
 .byt "W"	; peCmdEGWave	FUNC W
 .byt "P" ; peCmdEGPeriod	FUNC P
 .byt PARTITION_COPYING
 .byt 10	; peHighlightDown
 .byt 11	; peHighlightUp
 .byt 8	; peHighlightLeft
 .byt 9	; peHighlightRight
 .byt "C"	; peCopy
 .byt "V"	; pePaste
 .byt "X"	; peCut
 .byt "M"	; peMerge
 .byt "J"	; peGrab
 .byt "K"	; peDrop
 .byt "L" ; peContextualDrop
 .byt ","	; peCopyLast
 .byt "."	; peCopyNext
 .byt PARTITION_PLAY
 .byt 13	; pePlayPattern
 .byt 13	; JumpPlay
 .byt "S"	;<JumpAllStop	- SHFT S
 .byt "M"	; peMuteTrack

 
SoftKeys4PatternEditor
 .byt PARTITION_NAVIGATE
 .byt SOFT_CTRL	; peNavTrackLeft
 .byt SOFT_CTRL	; peNavTrackRight
 .byt 0		; peNavLeft
 .byt 0		; peNavRight
 .byt 0		; peNavUp
 .byt 0		; peNavDown
 .byt SOFT_CTRL	; peNavHome
 .byt SOFT_CTRL	; peNavEnd
 .byt SOFT_CTRL	; JumpList
 .byt SOFT_CTRL	; JumpSFX
 .byt SOFT_CTRL	; JumpFile
 .byt 0		; JumpHelp
 .byt SOFT_CTRL	; peToggleBlue
 .byt PARTITION_MODIFY
 .byt 0		; peIncrement
 .byt 0		; peDecrement
 .byt 0		; peReset
; .byt 0		; peToggle
 .byt SOFT_CTRL	; peInsert
 .byt SOFT_CTRL	; peDelete
 .byt SOFT_FUNC	; peMoveEntryDown
 .byt SOFT_FUNC	; peMoveEntryUp
 .byt PARTITION_OPERATERS
 .byt 0		; peOctave
 .byt 0		; peOctave
 .byt 0		; peOctave
 .byt 0		; peOctave
 .byt 0		; peOctave
 .byt 0		; peOctave
 .byt 0		; peOctave
 .byt 0		; peOctave
 .byt 0		; peOctave
 .byt 0		; peOctave
 .byt 0		; peNote
 .byt 0		; peNote
 .byt 0		; peNote
 .byt 0		; peNote
 .byt 0		; peNote
 .byt 0		; peNote
 .byt 0		; peNote
 .byt SOFT_CTRL	; peBar
 .byt SOFT_FUNC	; peToggleCommand
 .byt SOFT_FUNC	; peCmdTriggerOut 	FUNC O
 .byt SOFT_FUNC	; peCmdTriggerIn  	FUNC I
 .byt SOFT_FUNC	; peCmdSongTempo  	FUNC T
 .byt SOFT_FUNC	; peCmdBend     	FUNC U
 .byt SOFT_FUNC	; peCmdEGWave	FUNC W
 .byt SOFT_FUNC 	; peCmdEGPeriod	FUNC P
 .byt PARTITION_COPYING
 .byt SOFT_SHFT	; peHighlightDown
 .byt SOFT_SHFT	; peHighlightUp
 .byt SOFT_SHFT	; peHighlightLeft
 .byt SOFT_SHFT	; peHighlightRight
 .byt SOFT_CTRL	; peCopy
 .byt SOFT_CTRL	; pePaste
 .byt SOFT_CTRL	; peCut
 .byt SOFT_CTRL	; peMerge
 .byt 0		; peGrab
 .byt 0		; peDrop
 .byt 0		; peContextualDrop
 .byt 0		; peCopyLast
 .byt 0		; peCopyNext
 .byt PARTITION_PLAY
 .byt 0		; pePlayPattern
 .byt SOFT_SHFT	; JumpPlay
 .byt SOFT_SHFT	;<JumpAllStop	- SHFT S
 .byt SOFT_SHFT	; peMuteTrack

;HardKeys4Menu
; .byt PARTITION_NAVIGATE	
; .byt 8  	;mnuLeft            - Left
; .byt 9   ;mnuRight           - Right
; .byt "H"	;mnuHelp            - CTRL H
; .byt 27 	;mnuEscape          - Escape
; .byt PARTITION_OPERATERS	
; .byt 13	;mnuReturn	- Return
;
;SoftKeys4Menu
; .byt PARTITION_NAVIGATE	
; .byt 0  		;mnuLeft            - Left
; .byt 0   	;mnuRight           - Right
; .byt SOFT_CTRL	;mnuHelp            - CTRL H
; .byt 0 		;mnuEscape          - Escape
; .byt PARTITION_OPERATERS	
; .byt 0		;mnuReturn	- Return

HardKeys4SFXEditor
 .byt PARTITION_NAVIGATE     ;00
 .byt 10	;seNavDown	01- Down
 .byt 11	;seNavUp		02- Up
 .byt 11	;seHome       	03- CTRL Up
 .byt 10	;seEnd         	04- CTRL Down
 .byt "-"	;seDecSFX   	05- CTRL -
 .byt "="	;seIncSFX   	06- CTRL =
 .byt "L"	;JumpList   	08- CTRL E
 .byt "P"	;JumpPattern 	09- CTRL P
 .byt "F" ;JumpFile		10- CTRL F
 .byt 27	;JumpHelp    	11- CTRL H
 .byt PARTITION_MODIFY       ;12
 .byt "="	;seIncrement   	13- =
 .byt "-"	;seDecrement   	14- -
 .byt 127	;seDeleteVal        15- DEL
 .byt " "	;seToggleVal   	16- Space
 .byt "D"	;seDeleteGap   	17- CTRL D
 .byt "I"	;seInsertGap   	18- CTRL I
 .byt PARTITION_OPERATERS    ;19
 .byt "P"	;seCommand     	20- P
 .byt "N"	;seCommand     	21- N
 .byt "V"	;seCommand     	22- V
 .byt "S"	;seCommand     	23- S
 .byt "E"	;seCommand     	24- E
 .byt "G"	;seCommand     	25- G
 .byt "T"	;seCommand     	26- T
 .byt "O"	;seCommand     	27- O
 .byt "/"	;seCommand     	28- /
 .byt "F"	;seCommand     	30- F
 .byt "D"	;seCommand     	31- D
 .byt "C"	;seCommand     	32- C
 .byt "X"	;seCommand     	29- X
 .byt "L"	;seCommand     	33- L
 .byt "R"	;seCommand     	34- R
 .byt "W"	;seCommand     	35- W
 .byt "N" ;seNameSFX	36- FUNC N
 .byt PARTITION_COPYING      ;37
 .byt 10 	;seHiliteDown  	38- SHFT Down
 .byt 11 	;seHighlightUp 	39- SHFT Up
 .byt "A"	;seHighlightAll	- CTRL A
 .byt "C"	;seCopy        	- CTRL C
 .byt "V"	;sePaste       	- CTRL V
 .byt "X"	;seCut		- CTRL X
 .byt "J"	;seGrab        	- J
 .byt "K"	;seDrop        	- K
 .byt ","	;seLastEntry   	- ,
 .byt "."	;seNextEntry   	- .
 .byt PARTITION_PLAY	
 .byt 13	;sePlay        	- RETURN
 .byt "S"	;<JumpAllStop	- SHFT S


SoftKeys4SFXEditor
 .byt PARTITION_NAVIGATE	
 .byt 0		;seNavDown	- Down
 .byt 0		;seNavUp		- Up
 .byt SOFT_CTRL	;seHome       	- CTRL Up
 .byt SOFT_CTRL	;seEnd         	- CTRL Down
 .byt SOFT_CTRL	;seDecSFX   	- CTRL -
 .byt SOFT_CTRL	;seIncSFX   	- CTRL =
 .byt SOFT_CTRL	;JumpList   	- CTRL E
 .byt SOFT_CTRL	;JumpPattern 	- CTRL P
 .byt SOFT_CTRL	;JumpFile		- CTRL F
 .byt 0		;JumpHelp    	- CTRL H
 .byt PARTITION_MODIFY	
 .byt 0		;seIncrement   	- =
 .byt 0		;seDecrement   	- -
 .byt 0		;seDeleteVal        - DEL
 .byt 0		;seToggleVal   	- Space
 .byt SOFT_CTRL	;seDeleteGap   	- CTRL D
 .byt SOFT_CTRL	;seInsertGap   	- CTRL I
 .byt PARTITION_OPERATERS	
 .byt 0		;seCommand     	- P	;This must always be index 20 (used to index command type)
 .byt 0		;seCommand     	- N
 .byt 0		;seCommand     	- V
 .byt 0		;seCommand     	- S
 .byt 0		;seCommand     	- E
 .byt 0		;seCommand     	- G
 .byt 0		;seCommand     	- T
 .byt 0		;seCommand     	- O
 .byt 0		;seCommand     	- /
 .byt 0		;seCommand     	- X
 .byt 0		;seCommand     	- F
 .byt 0		;seCommand     	- D
 .byt 0		;seCommand     	- C
 .byt 0		;seCommand     	- L
 .byt 0		;seCommand     	- R
 .byt 0		;seCommand     	- W
 .byt SOFT_FUNC 	;seNameSFX	- FUNC N
 .byt PARTITION_COPYING	
 .byt SOFT_SHFT	;seHiliteDown  	- SHFT Down
 .byt SOFT_SHFT	;seHighlightUp 	- SHFT Up
 .byt SOFT_CTRL	;seHighlightAll	- CTRL A
 .byt SOFT_CTRL	;seCopy        	- CTRL C
 .byt SOFT_CTRL	;sePaste       	- CTRL V
 .byt SOFT_CTRL	;seCut		- CTRL X
 .byt 0		;seGrab        	- J
 .byt 0		;seDrop        	- K
 .byt 0		;seLastEntry   	- ,
 .byt 0		;seNextEntry   	- .
 .byt PARTITION_PLAY	
 .byt 0		;sePlay        	- RETURN
 .byt SOFT_SHFT	;<JumpAllStop	- SHFT S



HardKeys4FileEditor
 .byt PARTITION_NAVIGATE	
 .byt 8	;fnNavLeft 
 .byt 9	;fnNavRight
 .byt 10	;fnNavDown 
 .byt 11	;fnNavUp	  
 .byt 11	;fnHome
 .byt 10	;fnEnd
 .byt 27	;JumpHelp	 
 .byt "L"	;JumpList
 .byt "P"	;JumpPattern
 .byt "S"	;JumpSFX
 .byt PARTITION_OPERATERS	
 .byt 13	;fnLoad	   
 .byt "L"	;fnLoad	   
 .byt "S"	;fnSave	   
 .byt "5"	;fnRefresh 
 .byt "F"	;fnKeyFilter
 .byt "P"	;fnPrint	  
 .byt "D"	;fnDrive
 .byt PARTITION_PLAY	
 .byt 13	;fnPlay	   

SoftKeys4FileEditor
 .byt PARTITION_NAVIGATE	
 .byt 0		;fnNavLeft 
 .byt 0		;fnNavRight
 .byt 0		;fnNavDown 
 .byt 0		;fnNavUp	  
 .byt SOFT_CTRL	;fnHome
 .byt SOFT_CTRL	;fnEnd
 .byt 0		;JumpHelp	 
 .byt SOFT_CTRL	;JumpList
 .byt SOFT_CTRL	;JumpPattern
 .byt SOFT_CTRL	;JumpSFX
 .byt PARTITION_OPERATERS	
 .byt 0		;fnLoad	   
 .byt SOFT_FUNC	;fnLoad	   
 .byt SOFT_FUNC	;fnSave	   
 .byt SOFT_FUNC	;fnRefresh 
 .byt SOFT_FUNC	;fnKeyFilter
 .byt SOFT_FUNC	;fnPrint	  
 .byt SOFT_FUNC	;fnDrive
 .byt PARTITION_PLAY	
 .byt SOFT_SHFT	;fnPlay	   


