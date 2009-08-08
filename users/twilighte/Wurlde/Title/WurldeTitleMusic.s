;WurldeTitleMusic.s


;IRQ
;IRQ1 - Timer1 - Fixed    - Digidrum and 50Hz
;IRQ2 - Timer2 - Variable - Synth SID
 .zero
*=$00
wirqTemp01	.dsb 1

 .text

;Ensure Wurlde IRQ starts at xx00
 .dsb
WurldeIRQ0
	;Reserve the Accumulator
	sta wirqTemp01
	;Redirect IRQ
	lda #<WurldeIRQ1
	sta sys_VectorIRQ
	;Examine the IRQ that occurred
	Bit via_ifr
	;Bit sets V on T1 timeout
	bvs ProcDigidrumLow
	;Trigger AY Register 13
	lda #13
	sta via_porta
	lda #$FF
	sta via_pcr
	lda #$FD
	sta via_pcr
	;Set second cycle timer period(this also resets irq)
	lda #
	sta via_t2cl
	lda #
	sta via_t2ch
	;restore Accumulator
	lda wirqTemp01
	;Return
	rti
ProcDigidrumLow
	;Set Digidrum Register
	lda #
.(
	bmi skip1	;Digidrum is disabled
	sta via_porta
	lda #$FF
	sta via_pcr
	lda #$DD
	sta via_pcr
	;Fetch Digidrum value
vector1	lda $dead
	and #15
	sta via_porta
	lda #$FD
	sta via_pcr
	lda #$DD
	sta via_pcr
	;Adjust address of Digidrum data
	inc vector1+1
	bne skip1
	inc vector1+2
skip1	;Check on 50Hz
.)
	dec VBLCounter
	beq ProcessSlowIRQ
	;Reset IRQ by reading T1 Counter(also restores to T1 latch values)
	lda via_t1cl
	;Restore Accumulator
	lda wirqTemp01
	;Return
	rti

WurldeIRQ1
	;Reserve the Accumulator
	sta wirqTemp01
	;Redirect IRQ
	lda #<WurldeIRQ1
	sta sys_VectorIRQ
	;Examine the IRQ that occurred
	Bit via_ifr
	;Bit sets V on T1 timeout
	bvs ProcDigidrumHigh
	;Trigger AY Register 13
	lda #13
	sta via_porta
	lda #$FF
	sta via_pcr
	lda #$FD
	sta via_pcr
	lda #$DD
	sta via_pcr
	;Set first cycle timer period(this also resets irq)
	lda #
	sta via_t2cl
	lda #
	sta via_t2ch
	;restore Accumulator
	lda wirqTemp01
	;Return
	rti

ProcDigidrumHigh
	;Set Digidrum Register
	lda #
.(
	bmi skip1	;Digidrum is disabled
	sta via_porta
	lda #$FF
	sta via_pcr
	lda #$DD
	sta via_pcr
	;Fetch Digidrum value
	lda $dead
	lsr
	lsr
	lsr
	lsr
	sta via_porta
	lda #$FD
	sta via_pcr
	lda #$DD
	sta via_pcr
	;Reset IRQ by reading T1 Counter(also restores to T1 latch values)
skip1	lda via_t1cl
	;Restore Accumulator
	lda wirqTemp01
	;Return
	rti

ProcessSlowIRQ
	;Process the following events
	;1) Process Sound Effects
	;2) Process Channel Patterns
	;3) Detect end of Digidrum
	;4) Read keyboard


Small memory footprint
high speed
supporting freeform (independant patterns)

