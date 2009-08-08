;Import Sonix 3.5 file
;Sets Sonix music within a single song with IRQ RWC both to 100Hz
;Sonix Format..
;Patterns
; 5B00 0-6 0-125 Note(Channel A)
;          126   Rest
;          127   Bar
;      7-7 0     Sample
;	 1     Volume
;      0-3 0-15  Sample/Volume
;      4-7 0-15  Ornament
; 6B00 0-6 0-125 Note(Channel B)
;          126   Rest
;          127   Bar
;      7-7 0     Sample
;	 1     Volume
;      0-3 0-15  Sample/Volume
;      4-7 0-15  Ornament
; 7B00 0-6 0-125 Note(Channel C)
;          126   Rest
;          127   Bar
;      7-7 0     Sample
;	 1     Volume
;      0-3 0-15  Sample/Volume
;      4-7 0-15  Ornament
;Events..
; 8B00 0-4 0-31  Pattern(Channel A)
;      5-7 0-7   Repeats
; 8C00 0-6 0-127 Note Offset(Default 64)
;      7-7 0-1   -
; 8D00 0-4 0-31  Pattern(Channel B)
;      5-7 0-7   -
; 8E00 0-6 0-127 Note Offset(Default 64)
;      7-7 0-1   -
; 8F00 0-4 0-31  Pattern(Channel C)
;      5-7 0-7   -
; 9000 0-6 0-127 Note Offset(Default 64)
;      7-7 0-1   -
;Samples..
; 9100 0-3 0-15  Volume(Sample Bank 0)
;      4-7 0-15  Noise(B1-4)
; 9200 0-3 0-15  Volume(Sample Bank 1)
;      4-7 0-15  Noise(B1-4)
;Ornaments..
; 9300 0-5 0-63  Relative Offset(Ornament Bank 0)
;      6-6 0     Note Offset
;          1     Pitch Offset
;      7-7 0     Negative Offset
;          1     Positive Offset
; 9400 0-5 0-63  Relative Offset(Ornament Bank 1)
;      6-6 0     Note Offset
;          1     Pitch Offset
;      7-7 0     Negative Offset
;          1     Positive Offset
; 9500 -
; 9510 0-7 0-255 Start Event
; 9511 -
; 9512 0-7 0-255 End Event
; 9513 -
; 9514 0-7 0-255 Note Tempo
; 9515 -
; 9516 0-7 0-255 Effects Tempo


;import just Sonix Notes
	