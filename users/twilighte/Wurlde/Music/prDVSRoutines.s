;prDVSRoutines.s
;prPlayDIGILO - Play Digidrum B0-3
;prPlayDIGIHI - Play Digidrum B4-7
;prPlaySID    - Play SID and Buzzer
;It would seem that pulse mode is not supported on Emulator.
;However cb2 high is supported. But we can only set cb2 high on Digidrum.
;Setting Cb2 permanently high for SID would 
prPlayDIGILO
	sta DigiLoAcc+1
DigiLoAddress
	lda $DEAD
	and #15
	beq DigiLoAcc
	sta VIA_PORTA
	inc DigiLoAddress+1
	bne DigiLoAcc
	inc DigiLoAddress+2
DigiLoAcc	lda #00
	rti

prPlayDIGIHI
	sta DigiHiAcc+1
DigiHiAddress
	lda $DEAD
	lsr
	lsr
	lsr
	lsr
	beq DigiHiAcc
	sta VIA_PORTA
	inc DigiHiAddress+1
	bne DigiHiAcc
	inc DigiHiAddress+2
DigiHiAcc	lda #00
	rti

prPlaySID
	pha
SID_Vector1
	lda #00	;0==Off 1==On 129==On
	beq SID_Exit1
	eor #128
	sta SID_Vector1+1
	bmi SID_Value2
SID_Value1
	lda #00
	sta VIA_PORTA
	lda #PCR_WRITEVALUE
	sta VIA_PCR
	lda #PCR_SETINACTIVE
	sta VIA_PCR
	pla
	rti
SID_Value2
	lda #00
	sta VIA_PORTA
	lda #PCR_WRITEVALUE
	sta VIA_PCR
	lda #PCR_SETINACTIVE
	sta VIA_PCR
SID_Exit1	pla
	rti
prPlayPulsar	;24 Cycles
	sta prPulsarA+1
	lda #PCR_WRITEVALUE
	sta VIA_PCR
	lda #PCR_SETINACTIVE
	sta VIA_PCR
prPulsarA	lda #00
prDVSOffVector
	rti
