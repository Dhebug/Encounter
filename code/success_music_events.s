; Events generated by Arkos Tracker 2.

Events
	.word 97	; Wait for 96 frames.
	.byt 0

Events_Loop
	.word 49	; Wait for 48 frames.
	.byt 0

	.word 0	; End of sequence.
	.word Events_Loop	; Loops here.
