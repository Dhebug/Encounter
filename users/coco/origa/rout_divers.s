
; ---------------------------------------------------
; Module de calcul de nombres aléatoires
;	. routine 1 : _InitRandomize 	initialisation des valeurs
;	. routine 2 : _GetRandomize 	generation des nombres aléatoires
; ---------------------------------------------------

_RandomValueLow	 .byt 23
_RandomValueHigh .byt 35

_InitRandomize
	 lda _RandomValueHigh
	 sta _Random+1
	 lda _RandomValueLow
	 sta _Random
	 rts

_Random	.dsb	2,0
	 
; ----------------------------------------------------
; _GetRandomize()
; Generate a somewhat random repeating sequence.  I use
; a typical linear congruential algorithm
;      I(n+1) = (I(n)*a + c) mod m
; with m=65536, a=5, and c=13841 ($3611).  c was chosen
; to be a prime number near (1/2 - 1/6 sqrt(3))*m.
;
; Note that in general the higher bits are "more random"
; than the lower bits, so for instance in this program
; since only small integers (0..15, 0..39, etc.) are desired,
; they should be taken from the high byte _Random+1, which
; is returned in A.
; -----------------------------------------------------
_GetRandomize
         LDA _Random+1     
         STA RandomTMP     
         LDA _Random       
         ASL              
         ROL RandomTMP
         ASL              
         ROL RandomTMP   
         CLC              
         ADC _Random       
         PHA              
         LDA RandomTMP        
         ADC _Random+1     
         STA _Random+1     
         PLA              
         ADC #$11         
         STA _Random       
         LDA _Random+1     
         ADC #$36         
         STA _Random+1     
         RTS              

RandomTMP	.dsb	1

;
; Protection RESET
_Protection_Reset
		lda	#$40
		sta $22B		; uniquement pour Atmos 	$247 	rti
		rts
