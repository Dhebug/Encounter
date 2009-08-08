;Track Music
;For use in jumping between editors and ensuring editors get correct music data to work with
;Consolidate routines..
;1) SynchroniseMusicPointers
;2) TrackList
;3) TrackCurrentSongDetails

;1)Track current song to cursor row in order that note ranges are fed into pattern editor
;2)Track current song so that playing pattern will have correct tempo and stuff
;3)Track Pattern entry so that played SFX has correct starting ay and music settings
;4)

;Track all the way down to Individual Effect

;Provide the following variables before calling..
;A List Row(0-127)
;X Pattern Row(0-63)
;The idea being the music is tracked from the start of the song A is in to the current row
;in either List or Pattern.

TrackMusic
	sta tm_DestinationListRow
	stx tm_DestinationPatternRow
	;Find Song Start that A points to
	sta tm_ListRow
.(
loop1	jsr tm_FetchListRow
	;Look for New Song RWC
	lda tm_ListRowData+1
	cmp #%11000000
	bcc skip1
	lda tm_ListRowData
	and #7
	beq tm_FoundSongStart
skip1	dec tm_ListRow
	bpl loop1
.)
	;If no song start is found, assume start at entry 00
	inc tm_ListRow

;Now scan the List Entries..
tm_FoundSongStart
	;Set defaults as would be set when playing a song
	jsr tm_SetMusicDefaults
	;Now scan from Song Start(tm_ListRow) to tm_DestinationListRow/tm_DestinationPatternRow
.(
loop1	jsr tm_FetchListRow
	jsr tm_IsRowRWC
	bcc skip1
	jsr tm_ProcRWC
	jmp skip2
skip1	jsr tm_ProcTrackRow
skip2	inc tm_ListRow
	bmi skip3
	lda tm_ListRow
	cmp tm_DestinationListRow
	beq loop1
	bcc loop1
skip3	rts
.)

tm_IsRowRWC
	lda tm_ListRowData+1
	cmp #%11000000
	rts
	
tm_ProcRWC
	lda tm_ListRowData
	and #7
	;Skip if New Song, End Song or Fade
	cmp #3
	bcc
.(
	bne skip1
tm_TrackIRQRates
	lda tm_ListRowData+1
	and #3
	sta tm_SFXRate
	lda tm_ListRowData+2
	and #3
	sta tm_MusicRate
	rts
skip1	cmp #5
.)
.(
	bcs skip2
tm_TrackSharingBehaviour
	lda tm_ListRowData
	and #BIT5
	sta tm_Temp01
	lda tm_GlobalProperty
	and #%11011111
	ora tm_Temp01
	sta tm_GlobalProperty
	lda tm_ListRowData+2
	and #7
	sta tm_SharingTicks
	rts 
skip2	bne skip3
tm_TrackNoteOffset
	ldx #7
	lda tm_ListRowData+2
	sta tm_Temp01
loop1	lda Bitpos,x
	and tm_Temp01
	beq skip1
	lda tm_ListRowData+3
	and #63
	sta tm_NoteOffset,x
skip1	dex
	bpl loop1
skip4	rts
skip3	cmp #7
	bcs skip4
.)
tm_TrackResolutions
	lda tm_ListRowData
	and #BIT3+BIT4
	sta tm_Temp01
	lda tm_GlobalProperty
	and #%11100111
	ora tm_Temp01
	sta tm_GlobalProperty
	rts 

tm_ProcTrackRow
	lda #0
	sta tm_TrackID		;x1
	sta tm_ListTrackIndex	;x2
	
	lda tm_ListTrackIndex
	lda tm_ListRowData+1,x
	and #%11000000
	cmp #%01000000
	bcc tm_Pattern
	beq tm_MimicLeft
tm_MimicRight
	lda tm_ListRowData+1,x
	and #63
	sta 
	
	
	