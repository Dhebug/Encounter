;reset microdisc
#define fdc_Control     $0314

*=$500
loop1   nop
        jmp loop1
	sei
        lda fdc_Control
        and #%01111101
        sta fdc_Control
	jmp ($fffc)
