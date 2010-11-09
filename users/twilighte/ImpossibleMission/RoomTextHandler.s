;RoomTextHandler.s
;Displays and scrolls text in the pocket computer triggered by events in the room

EraseRoomText
	ldx #4
	lda #ROOMTEXT_BLANK
.(
loop1	sta RoomTextList,x
	dex
	bpl loop1
.)
	rts

;X==TextID
DisplayRoomText
	jsr ScrollRoomTextUp
	stx RoomTextList+4
	jmp RedisplayRoomText

ScrollRoomTextUp
	;Scroll Room Text list then redisplay all lines
	ldy #0
.(
loop1	lda RoomTextList+1,y
	sta RoomTextList,y
	iny
	cpy #4
	bcc loop1
.)	
	;pop 5th line with Blank
	lda #ROOMTEXT_BLANK
	sta RoomTextList+4
	rts
	
RedisplayRoomText
	;Display all 5 lines
	ldx #04
.(	
loop1	ldy RoomTextList,x
	lda RoomTextLocationLo,y
	sta line
	lda RoomTextLocationHi,y
	sta line+1
	
	;Display Line
	stx RoomTextTemp01

	ldy RoomTextCursorY2RealY,x
	lda #0
	ldx #5
	jsr DisplayTextLine
	
	ldx RoomTextTemp01
	dex
	bpl loop1
.)
	rts

RoomTextList
 .byt ROOMTEXT_BLANK
 .byt ROOMTEXT_BLANK
 .byt ROOMTEXT_BLANK
 .byt ROOMTEXT_BLANK
 .byt ROOMTEXT_BLANK

RoomTextCursorY2RealY
 .byt 156
 .byt 164
 .byt 172
 .byt 180
 .byt 188

RoomTextLocationLo
 .byt <RoomText_DestroyHimMyRobots	;0 (Replace with any new single message)
 .byt <RoomText_Blank                   ;1
 .byt <RoomText_No                      ;2
 .byt <RoomText_Ahhhh                   ;3
 .byt <RoomText_Congratulations         ;4
 .byt <RoomText_FoundNothing            ;5
 .byt <RoomText_FoundPuzzlePiece        ;6
 .byt <RoomText_FoundLiftReset          ;7
 .byt <RoomText_FoundSnooze             ;8
 .byt <RoomText_Just30Seconds           ;9
 .byt <RoomText_Just30MinutesLeft       ;10
 .byt <RoomText_SequenceFailed          ;11
 .byt <RoomText_SequenceFound           ;12
 .byt <RoomText1Hours                   ;13
 .byt <RoomText2Hours                   ;14
 .byt <RoomText3Hours                   ;15
 .byt <RoomText4Hours                   ;16
 .byt <RoomText5Hours                   ;17
 .byt <RoomText6Hours                   ;18
 .byt <RoomText7Hours                   ;19
 
 .byt <RoomText_RunHimOver		;20
 .byt <RoomText_KillHimRobots		;21
 .byt <RoomText_YouWillDie		;22
 .byt <RoomText_DestroyHimMyRobots	;23

 .byt <RoomTextSimonEnter		;24
 .byt <RoomText_GameComplete            ;25

 .byt <RoomText_PunchCardExists	;26
 .byt <RoomText_NeedMorePieces          ;27
 .byt <RoomText_RoomsLocated            ;28

RoomTextLocationHi
 .byt >RoomText_DestroyHimMyRobots
 .byt >RoomText_Blank
 .byt >RoomText_No
 .byt >RoomText_Ahhhh
 .byt >RoomText_Congratulations
 .byt >RoomText_FoundNothing
 .byt >RoomText_FoundPuzzlePiece
 .byt >RoomText_FoundLiftReset
 .byt >RoomText_FoundSnooze
 .byt >RoomText_Just30Seconds
 .byt >RoomText_Just30MinutesLeft
 .byt >RoomText_SequenceFailed
 .byt >RoomText_SequenceFound
 .byt >RoomText1Hours
 .byt >RoomText2Hours
 .byt >RoomText3Hours
 .byt >RoomText4Hours
 .byt >RoomText5Hours
 .byt >RoomText6Hours
 .byt >RoomText7Hours

 .byt >RoomText_RunHimOver		;20
 .byt >RoomText_KillHimRobots		;21
 .byt >RoomText_YouWillDie		;22
 .byt >RoomText_DestroyHimMyRobots	;23

 .byt >RoomTextSimonEnter
 .byt >RoomText_GameComplete

 .byt >RoomText_PunchCardExists
 .byt >RoomText_NeedMorePieces
 .byt >RoomText_RoomsLocated

;Text is limited to single line 15 characters
;Some texts have been moved into bottom of hires to save memory
RoomText_DestroyHimMyRobots
;      123456789012345
 .byt "DESTROY HIM!!  ",0
RoomText_RunHimOver
 .byt "JUST KILL HIM!!",0
RoomText_YouWillDie
 .byt "YOU WILL DIE!! ",0
RoomText_Blank
 .byt "               ",0
RoomText_No
 .byt "NO...          ",0
RoomText_Ahhhh
 .byt "YOU DIED!!     ",0
RoomText_Congratulations
 .byt "CONGRATULATIONS",0
RoomText_FoundNothing
 .byt "FOUND NOTHING  ",0
RoomText_FoundPuzzlePiece
 .byt "FOUND PUZZLE   ",0
RoomText_FoundLiftReset
 .byt "FOUND LIFTRESET",0
RoomText_FoundSnooze
 .byt "FOUND SNOOZE   ",0
RoomText_Just30Seconds
 .byt "JUST 30 SECONDS",0
RoomText_Just30MinutesLeft
 .byt "30 MINUTES LEFT",0
RoomText7Hours
 .byt "HOW TIME FLIES!",0
RoomText6Hours
 .byt "STILL ALIVE? HM",0
RoomText5Hours
 .byt "GIVE UP NOW..  ",0
RoomText4Hours
 .byt "SUCH STAMINA.. ",0
RoomText3Hours
 .byt "SUCH BRAVADO!  ",0
RoomText2Hours
 .byt "NEAR YET SO FAR",0
RoomText1Hours
 .byt "MY TIME IS NEAR",0

RoomTextSimonEnter
 .byt "ENTER SEQUENCE ",0
RoomText_SequenceFailed
 .byt "OUT OF SEQUENCE",0
RoomText_SequenceFound
 .byt "CHECK STATS!   ",0
RoomText_GameComplete
 .byt "GAME COMPLETED!",0
RoomText_PunchCardExists
 .byt " A CARD EXISTS ",0
RoomText_NeedMorePieces
 .byt "  NEED MORE!!  ",0
RoomText_RoomsLocated
 .byt " ROOMS LOCATED ",0
;
;YOU MAY ASWELL
;GIVE UP NOW   
;
;Despite all your efforts, I doubt you are going to make it"
;<_Dbug_> or "tic toc tic toc... the clock turns!"
;012345678901234
;ONLY A FEW HOURS TILL WORLD DOMINATION!!
;