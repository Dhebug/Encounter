;ZeroPage.s


;General Variables
screen	.dsb 2
source	.dsb 2
source2	.dsb 2
source3	.dsb 2

;Pattern Plot
ppTempX			.dsb 1
ppTempVolume
ppTempA			.dsb 1
RowCounter		.dsb 1
RowIndex			.dsb 1

;Pattern Editor
PatternEntryType		.dsb 1
PatternEntryByte0		.dsb 1
PatternEntryByte1		.dsb 1
PatternEntryNote		.dsb 1
PatternEntrySharp		.dsb 1
PatternEntryOctave		.dsb 1
PatternEntryVolume		.dsb 1
PatternEntrySFX		.dsb 1
PatternEntryLongNote	.dsb 1
PatternEntryCommand		.dsb 1
PatternEntryParam1		.dsb 1
PatternEntryParam2		.dsb 1
peTempX			.dsb 1
peTempY			.dsb 1


;List Plot
ListCommandParam		.dsb 1
ListEntryByte0		.dsb 1
ListEntryByte1		.dsb 1
epTemp01			.dsb 1
epTemp02			.dsb 1
eeHighlightInverse		.dsb 1
eeTempY			.dsb 1
eeTemp01			.dsb 1
eeTemp02			.dsb 1
rwTemplateIndex		.dsb 1
rwScreenIndex		.dsb 1


;List Editor
eeListByte0		.dsb 1
eeListByte1		.dsb 1
tlUltimateSong		.dsb 1

;Generic
Temp01			.dsb 1
Temp02			.dsb 1
ipInverseMode		.dsb 1

;SFX Plot
seTemp01			.dsb 1
seTemp02			.dsb 1
seHighlightInverse		.dsb 1

;Key Routines
SoftKeyRegister		.dsb 1
HardKeyRegister		.dsb 1

;IRQ Routines
irqBackupA		.dsb 1
irqBackupX		.dsb 1
irqBackupY		.dsb 1
IRQCounter		.dsb 1
prMusicFrequency		.dsb 1
prSFXFrequency		.dsb 1
prTransferFrequency		.dsb 1
prResolutionFrequency	.dsb 1

;Play Routines
prTemp01			.dsb 1
prTemp02			.dsb 1
prTemp03			.dsb 1
prPatternCommandX		.dsb 1
list			.dsb 2
pattern			.dsb 2
SFX			.dsb 2
prLastTrack2UseResource	.dsb 8
prMimicVolume		.dsb 1
prMimicPitchLo      	.dsb 1
prMimicPitchHi      	.dsb 1
bstTemp01			.dsb 1
prNoteDelayRefer		.dsb 1
prNoteDelayCount		.dsb 1
prTimeslotDelayRefer	.dsb 1
prTimeslotDelayCount	.dsb 1

;Message Display Handler
msgScreenIndex		.dsb 1
Iterance			.dsb 1
;Permit up to 3 iterances
msgAddr			.dsb 6

;HelpPlot
hpLastKey			.dsb 1
hpKeyIndex		.dsb 1
hpNewSoftKey		.dsb 1
hpNewHardKey		.dsb 1
hpTemp01			.dsb 1
hpTemp02                      .dsb 1

;CPU Load
irqCycles			.dsb 2
TotalCycles		.dsb 2

copy			.dsb 2
cpyByte0			.dsb 1
cpyByte1			.dsb 1

;Validate SFX
veVolume			.dsb 1
veCount			.dsb 1
veSkipCondition		.dsb 1
veInfiniteCount		.dsb 1
veOverallCount		.dsb 1

;Track the Music
tmPageBoundTop		.dsb 1
tmPageBoundTopLimited	.dsb 1
tmPageBoundBottomLimited	.dsb 1
tmTemp01			.dsb 1
tmCommonCursorY		.dsb 1
tmScreen			.dsb 2
tmTrackingSFX		.dsb 1
tmTrackingSFXIndex		.dsb 1

;pitchbend parameters (held in zp for speed)
prPitchbendLo		.dsb 8
prPitchbendHi		.dsb 8
prPitchbendDelay		.dsb 8
prPitchbendDelayCount	.dsb 8
prPitchbendStep		.dsb 8
prPitchbendDirection	.dsb 8
