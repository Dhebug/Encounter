;TextMessages.s
;Management, display and location of all text messages in AYT.

;There are two types of embedded messages..
;The embedded code refers to a variable and display format
;The embedded code refers to another text
;Can we merge into one?
;0 End of Message
;1-7 Ink change
;8-31(24) Embedded Variable pointer and display format
;32-95 ASCII character
;96-255 Embedded text pointer

TextVectorOffset0_Lo
TextVectorOffset16_Lo
TextVectorOffset32_Lo
TextVectorOffset48_Lo
TextVectorOffset64_Lo
TextVectorOffset80_Lo
TextVectorOffset96_Lo
TextVectorOffset112_Lo
TextVectorOffset128_Lo
TextVectorOffset144_Lo
TextVectorOffset160_Lo
TextVectorOffset176_Lo
TextVectorOffset192_Lo
TextVectorOffset208_Lo
TextVectorOffset224_Lo
TextVectorOffset240_Lo

TextVectorOffset0_Hi
TextVectorOffset16_Hi
TextVectorOffset32_Hi
TextVectorOffset48_Hi
TextVectorOffset64_Hi
TextVectorOffset80_Hi
TextVectorOffset96_Hi
TextVectorOffset112_Hi
TextVectorOffset128_Hi
TextVectorOffset144_Hi
TextVectorOffset160_Hi
TextVectorOffset176_Hi
TextVectorOffset192_Hi
TextVectorOffset208_Hi
TextVectorOffset224_Hi
TextVectorOffset240_Hi

TextMessage0
 .byt "CHP-A V-A",0
 .byt "CHP-B V-B",0
 .byt "CHP-C V-C",0
 .byt "CHP-A T-A",0
 .byt "CHP-B T-B",0
 .byt "CHP-C T-C",0
 .byt "EG E-A",0
 .byt "EG E-B",0
 .byt "EG E-AB",0
 .byt "EG E-C",0
 .byt "EG E-AC",0
 .byt "EG E-BC",0
 .byt "EG E-ABC",0
 .byt "NSE N-A",0
 .byt "NSE N-B",0
 .byt "NSE N-AB",0
TextMessage16
 .byt "NSE N-C",0
 .byt "NSE N-AC",0
 .byt "NSE N-BC",0
 .byt "NSE N-ABC",0
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
TextMessage32
 .byt "BEND AT RATE ",128," ON TRACKS ",130,0
 .byt "TR-OUT WRITING ",131,0
 .byt "TR-IN WAITING FOR ",131,0
 .byt "TEMPO ",129,0
 .byt "SET EG CYCLE ",128," ON TRACKS ",130,0
 .byt "SET EG PERIOD HI ",128," AND LO ",131,0
 .byt "SPARE",0
 .byt "REST",0
 .byt "BAR",0
 .byt "MIMIC V(",132,"),P(",133,"),T(",134,"),",135,0
 .byt "SOUND SOURCE(SS) - ",135,0
 .byt "SFX ",34,136,34,0

;Parsed
;A Text Message ID
DisplayText
	tay
	ldx #<TextMessage0
	stx TextSearchLoc
	ldx #>TextMessage0
	stx TextSearchLoc+1
	lsr
	lsr
	lsr
	lsr
	beq skip1
	tax
	lda TextVectorOffsetLo,x
	sta TextSearchLoc
	lda TextVectorOffsetHi,x
	sta TextSearchLoc+1
	tya
	and #15
skip1	;MessageID in Y - Count 0's up to Y
	ldy #00
	lda (
	
	