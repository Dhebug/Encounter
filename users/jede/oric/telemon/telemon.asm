telemon
	*=$c000
#define lc2a6 $c2a6
#define ld903 $d903
#define lc4d1 $c4d1
#define lc0ac $c0ac
#define lc838 $c838
#define lc45f $c45f
#define lda4f $da4f
#define lc2dc $c2dc
#define lc524 $c524
#define lc464 $c464
#define lc2e0 $c2e0
#define lc5eb $c5eb

lc000
	sei
	cld
	ldx #$ff ; setting stack
	txs
	inx
	stx $0418 ; met a 0 la pile des banques
	jsr lc2a6 ;initialise les E/S (ACIA, VIAsÖ)
	jsr lda4f ;Èteint le PSG
	jsr ld903  ;balaye le clavier dans KBDCOL
	ldx #$0f
lc014
	lsr $02ae,x ;met a 0 les 16 vecteurs d'E/S possibles
	dex ; pour les 4 canaux
	bpl lc014
lc01a
	lda #$d0 ; envoie la commande %1101000 au FDC
	jsr lc4d1  ; soit interdiction d'interruption
	lda $02fa ; le vecteur IRQ est OK ?
	cmp #$4c 
	bne lc035 ; non
lc026
	lda $026d ; oui, est-ce un DEL+RESET (reset a froid)
	and #$20
	bne lc035  ;non
lc02d
	lda $020d  ; oui, on isole b1 de FLGTEL (SED present?)
	and #$01
	clc
	bcc lc038 ; inconditionnel
lc035
	lda #$01  ; force SED prÈsent
	sec
lc038
	sta $020d ; dans FLGTEL
	ror $02ee ; b7 de FLGRST a 1 si DEL+RESET
	bmi lc043 ;pour 48
lc040
	jmp lc0ac
lc043
	ldx #$2f
lc045
	lda lc838,x ;dÈplacements. On installe les vecteurs
	sta $02be,x ; D'E/S par dÈfaut en ADIOB
	dex
	bpl lc045
lc04e
	ldx #$04
lc050
	lda lc45f,x ;on place la racine du gÈnÈrateur alÈatoire
	sta $02ef,x ; dans CSRND (rÈel 5 octets)
	dex
	bpl lc050
lc059
	nop  ;???
	nop  ;???
	ldx #$03
lc05d
	lda lc2dc,x ; les lecteurs A ‡ D sont-ils branchÈs ?
	sta $0314 
	lda #$08 ;commande SEEK au FDC (placer la tÍte sur
	sta $0310 ; piste 0) dans FDCCR
	tay
lc069
	iny  ; 248 boucles
	bne lc069 ; pour attente de rÈponse
lc06c
	nop ; ??? dÈcidÈment
	ldy #$40
	stx $00
lc071
	lda $0310 ;si b1 de ACIACR = 0
	lsr
	bcc lc081 ;on installe le drive
lc077
	inc $00 ; on teste plus de 200 fois pour Ítre sur
	bne lc071
lc07b
	dey ; mais alors vraiment, vraiment sur !
	bne lc071
lc07e
	tya ; y=0,le nombre de piste sera 0,drive absent
lc07f
	beq lc086 ;inconditionnel
lc081	
	lsr $020d ;on indique SED prÈsent
lc084
	lda #$aa ;on indique 42 pistes double face
lc086
	sta $0208,x ;dans le drive trouvÈ
lc089
	dex
lc08a
	bpl lc05d  ;et on les teste tous
lc08c
	nop  ; ??? aie, aie, aie
	inx
lc08e
	lda lc524,x ;on installe la gestion IRQ, BRK et banques
	sta $0400,x ; en $0400
	lda lc464,x ;routine de chargement du STRATSED
	sta $b800,x ;routine d'installation de la routine des
	lda lc2e0,x  ;buffers
	sta $0600,x 
	lda lc5eb,x ;routine des buffers qui sera en $C500
	sta $0700,x ;  banque 0
	INX
	BNE $C08E
	JSR $0603 ; installe la routine de gestion des buffers
	LDA #$00 ;x=buffer clavier
	PHA ;on sauve le numÈro
	TAX
	JSR $C4EA ; on inisialise le buffer x
	PLA
	CLC
	ADC #$0C ; on passÈ au buffer suivant
	CMP #$30 ; est-ce aprËs le buffer SORTIE PARALLELE ?
	BNE $C0AE ;non, on passÈ au suivant
	LDA #$00
	STA $020E ; 0 Ko de ROM
	LDA #$40 ; 64 Ko de RAM
	STA $020F
	LDX #$07
	LDY $0200,X ;on lit le statut des banques
	TYA
	AND #$10 ; on ignore ?
	
	bne $C0EB ; oui 
    tya  ; 2non, on sauve la valeur 
    pha 
    and #$0F ; combien de mÔøΩmoire ? 
    tay 
    iny  ; 2dans Y 
    pla 
    and #$20 ; est-ce une RAM ou une ROM 
    clc 
    beq $C0E4 ; 
    tya  ; une ROM 
    adc $020E ;  on ajoute ÔøΩ la ROM totale 
    sta $020E ;  
    bcc $C0EB ; inconditionnel 
    tya  ; une RAM 
    adc $020F ;  on ajoute ÔøΩ la RAM totale 
    sta $020F ;  
    dex  ; 2banque suivante 
    bne $C0C7 ; 
    bit $02EE ;  b7 de FLGRST = 1 
    bpl $C101 ; non, c'est un RESET a chaud 
    ldx #$0B ; oui, on place les vecteurs VNMI, VIRQ et 
    lda $C386,X ;  VAPLIC 
    sta $02F4,X ;  
    dex 
    bpl $C0F5 ; 
    jsr $D9B1 ;  et installe les valeurs clavier 
    lda $026C ;  
    and #$90 ; a-t-on pressÔøΩ SHIFT droit ? 
    beq $C110 ; non 
    lda $020D ;  oui, on force b6 de FLGTEL a 1 
    ora #$40 ; pour indiquer le mode MINITEL 
    sta $020D ;  
    jsr $DF5B ;  initialise les valeurs ÔøΩcran TEXT 
    jsr $DA56 ;  initialise l'imprimante 
    jsr $D5BD ;  initialise variables VDT 
    jsr $DFAB ;  initialise JOYSTICK, SOURIS et TIMERs 
    jsr $DB54 ;  initialise RS232 
    lda $0275 ;  
    lsr  ; 2on isole le mode clavier 
    and #$03 ; dans B1-2-3 de FLGKBD 
    .byt $00,$52 ; et on place le type de clavier 
    lda #$80 ; 
    .byt $00,$00 ; on ouvre le clavier en entrÔøΩe sur canal 0 
    lda #$88 ; 
    .byt $00,$00 ; et l'ÔøΩcran fenÔøΩtre 0 en sortie 
    .byt $00,$3C ; on met l'horloge a 0 
    lda #$8F ; on ouvre le MINITEL en sortie 
        .byt $00,$01 ; sur le canal 1 
        lda #$13 ; indexe mode non rouleau et 
        ldy #$C4 ; curseur ÔøΩteint sur MINITEL 
        bit $020D ;  est-on en mode MINITEL ? 
        bvc $C146 ; non 
        lda #$8F ; oui, on ouvre le MINITEL en sortie 
        .byt $00,$00 ; sur le canal 1 
        lda #$0D ; on indexe mode rouleau et curseur allumÔøΩ 
        ldy #$C4 ; 
        .byt $00,$15 ; on envoie les codes au Minitel 
        bit $02EE ;  RESET ÔøΩ froid ? 
        bpl $C173 ; non 
        lda #$9B ; 
        ldy #$C3 ; 
        .byt $00,$14 ; on affiche TELESTRAT 
        lda #$E1 ; 
        ldy #$C3 ; 
        .byt $00,$14 ; on affiche CopyrightÔøΩ 
        .byt $00,$25 ; on passÔøΩ ÔøΩ la ligne 
        lda $020F ;  on affiche la RAM 
        jsr $C29B ;  en dÔøΩcimal deux chiffres 
        lda #$B9 ; 
        ldy #$C3 ; 
        .byt $00,$14 ; Ko RAM 
        lda $020E ;  puis la ROM 
        jsr $C29B ;  
        lda #$C2 ; Ko ROM 
        ldy #$C3 ; 
        .byt $00,$14 ; 
        jsr $C6BF ;  l'imprimante est prÔøΩte ? 
        bne $C17D ; oui 
        .byt $00,$25 ; non, on sautÔøΩ une ligne 
        jmp $C188 ;  BNE aurait ÔøΩtÔøΩ mieux 
        bit $02EE ;  RESET ÔøΩ froid ? 
        bpl $C188 ; non 
        lda #$01 ; oui, on affiche "Imprimante" 
        ldy #$C4 ; 
        .byt $00,$14 ; 
        bit $02EE ;  RESET ÔøΩ froid ? 
		.byt $30,$0f ; FIXME   
        jsr $C268 ;  on coupe l'entrÔøΩe Minitel sur canal 1 
        ldx $02F4 ;  et on exÔøΩcute VNMI ÔøΩ banque X 
        lda $02F5 ;  adresse AY 
        ldy $02F6 ;  
        jmp $C25C ;  car changement de banque probable 
        ldx #$00 ; on va afficher les drives 
        lda $0208,X ;  le drive X est branchÔøΩ ? 
        bne $C1AA ; oui 
        inx  ; 2non 
        cpx #$04 ; on fait les quatre possibles 
        bne $C19E ; 
        beq $C1E0 ; inconditinnel 
        txa 
        pha 
        lda $0220 ;  sommes-nous au dÔøΩbut de la ligne ? 
        beq $C1B5 ; oui 
        lda #$2C ; non, on affiche "," 
        .byt $00,$10 ; 
        lda #$CC ; on affiche "Drive :" 
        ldy #$C3 ; 
        .byt $00,$14 ; 
        pla 
        pha 
        tax 
        lda $C2DC,X ;  on indique au FDC la commande 1xx00100 
        sta $0314 ;  soit activer le drive xx , face B 
        stx $020C ;  et drive courant dans DRVDEF, drive par dÔøΩfaut 
        pla 
        tax 
        txa  ; 2on prend le numÔøΩro du drive 
        clc 
        adc #$41 ; on ajoute "A" 
        .byt $00,$10 ; et on affiche 
        inx 
        cpx #$04 ; pour tous les drives 
        beq $C1E5 ; (4 maxi) 
        lda $0208,X ;  on lit le drive X 
        beq $C1CF ; vide ? 
        lda #$2D ; non, on affiche "-" 
        .byt $00,$10 ; et on continue 
        jmp $C1C9 ;  pourquoi pas BNE ??? 
        lda $0220 ;  on est au dÔøΩbut de la ligne ? 
        beq $C1E7 ; oui 
        .byt $00,$25 ; non on sautÔøΩ une ligne 
        lda #$D3 ; on affiche TELEMON V2.4 etcÔøΩ 
        ldy #$C3 ; 
        .byt $00,$14 ; 
        lda #$00 ; on met 0 en dÔøΩfinition pour la banque 0 (RAM) 
        sta $0200 ;  
        lda $020D ;  
        lsr  ; 2STRATSED present ? 
        bcs $C207 ; non 
        lda #$19 ; oui, on affiche "InsÔøΩrez une disquette" 
        ldy #$C4 ; clignotant 
        .byt $00,$14 ; 
        jsr $B800 ;  on attend une dsk STRATSED, on charge le SED 
        lda #$30 ; on arÔøΩte de clignoter 
        ldy #$C4 ; 
        .byt $00,$14 ; 
        ldx #$02 ; 
        lda $C45C,X ;  on place l'extension COM 
        sta $055D,X ;  dans l'extension par dÔøΩfaut 
        dex 
        bpl $C209 ; 
        jsr $0600 ;  affiche le copyright des banques 
        jsr $C268 ;  ferme le minitel sur le canal 1 
        lda $020D ;  SED present ? 
        lsr 
        bcs $C24D ; non 
        lda #$55 ; indexe BONJOUR 
        ldy #$C4 ; 
        ldx #$07 ; 
        .byt $00,$24 ; dans BUFNOM 
        ldx #$00 ; 
        
      	lda #$7D ; appel a XTRVNM 
        ldy #$FF ; 
        jsr $C25C ;  BONJOUR.COM est-il prÔøΩsent ? 
        beq $C24D ; non 
        lda $020D ;  oui, on l'indique dans FLGTEL 
        ora #$04 ; 
        sta $020D ;  
        ldx #$06 ; 
        lda $0200,X ;  on lit le statut des banques 
        cmp #$EF ; %11101111, il ne faut pas ignorer la banque 
        beq $C247 ; alors on se branchÔøΩ dessus 
        dex 
        bpl $C23B ; 
        bmi $C24D ; inconditionnel, on exÔøΩcute l'APLIC 
        lda #$00 ; X contient le numÔøΩro de la banque 
        ldy #$C0 ; on exÔøΩcute le logiciel qui s'y trouve 
        bne $C25C ; inconditionnel 
        ldx #$00 ; on affiche le curseur 
        ;brk $35 ; 
        .byt $00,$35
        ldx $02FD ;  y-a-t-il une cartouche application ? 
        bmi $C286 ; non, on saute 
        lda $02FE ;  on indexe l'adresse de l'application 
        ldy $02FF ;  VAPLIC (port droit) 
        sta $0415 ;  et on exÔøΩcute sur la banque X 
        sty $0416 ;  
        stx $0417 ;  
        jmp $040C ;  par EXBNK 
        ; ETEINT L'ENTREE MINITEL SUR LE CANAL 1
		; Action  vide le buffer d'entrÈe du Minitel et ferme l'entrÈe sÈrie sur le canal numÈro 1.
	cli  ; 2en $C268, on autorise les interruptions. 
	lda #$02 ; en $C269, on ne touchÈ pas aux interruptions. 
	sta $44 ; 
	lda $44 ; 
	bne $C26D ; on attend 3 dixiËmes de secondes 
	ldx #$0C ; on vide le buffer sÈrie ACIA entrÈe 
	;brk $57 ; par XVIDBU 
	.byt 00,$57
	lda $031E ;  
	and #$F3 ; on force b2 ‡ 0 
	ora #$08 ; et b3 ‡ 1 
	sta $031E ;  dans le registre de commande de l'ACIA 
	lda #$8F ; on ferme le minitel en sortie sur le canal 1 
	;brk $05 ; pourquoi pas JMP $C723 ??? 
	.byt 00,05
	rts
; Action  un code au clavier, si c'est CTRL-C, saute en $9000, si c'est CTRL-A, on se branche
; en $E000 sur la banque 0. Cette routine n'est en fait jamais appelÈe (il faut qu'aucun
; langage ne soit prÈsent, ni aucune application) il s'agit donc probablement d'une
; routine de mise au point.	
	 
	;brk $10 ; lit un code 
	.byt 0,$10
	; brk $0C ; demande une touchÈ au clavier 
	.byt 0,$0C
	cmp #$03 ; CTRL-C ? 
	bne $C28F ; non, on saute 
	jsr $9000 ;  oui, on exÈcute en $9000 
	cmp #$01 ; CTRL-A ? 
	bne $C284 ; non, on insisteÖ 
	lda #$00 ; oui, on indexe $E000, banque 0 (RAM) 
	ldy #$E0 ; 
	ldx #$00 ; 
	beq $C25C ; et on saute 
;AFFICHE A EN DECIMAL SUR 3 CHIFFRES
;Action en entrÈe, A contient un nombre qui sera affichÈ sur le canal 0 par le biais de la routine
;XDECIM.
;En sortie, Y=0
	
	ldy #$00 ; AY contient A 
	ldx #$20 ; le caractËre par dÈfaut est " " 
	stx $14 ; dans DEFAFF 
	ldx #$01 ; il faut afficher 3 caractËres (X+2) 
	jmp $CE39 ;  on affiche par XDECIM 
	
	
	lda #$7F ; interdit toute interruptions 
	sta $030E ;  dans VIA 6522-1 
	sta $032E ;  et VIA 6522-2 
	sta $031D ;  et ACIA 6551 
	lda #$00 ; 
	sta $0314 ;  aucune directive au FDC 
	lda #$FF ; %11111111 
	sta $0303 ;  port A en sortie sur VIA1 
	lda #$F7 ; %11110111 
	sta $0300 ;  dans port B du VIA1 
	sta $0302 ;  port B en sortie sauf PB3 
	lda #$17 ; %00010111 
	sta $0321 ;  dans port A du VIA2 
	sta $0323 ;  PA0-1-2-4 en sortie et PA3-5-6-7 en entree 
	lda #$E0 ; %11100000 
	sta $0320 ;  dans port B du VIA2 
	sta $0322 ;  PB0Åc4 en entree et PB5-6-7 en sortie 
	lda #$CC ; %10101010 CA2 et CB2 en sortie/ecriture VIADR 
	sta $030C ;  dans V1PCR 
	sta $032C ;  et V2PCR 
	rts 
	.byt $84,$a4,$c4,$e4
	jmp $0650 ;  
	lda #$00 ; 
	sta $0321 ;  force banque 0 
	tax 
	; fill $c500 from $0700 value
.(
loop	
	lda $0700,X ;  envoie 256 octets de $0700 
	sta $C500,X ;  a $C500, routine de gestion des buffers 
	inx 
	bne loop ; 
.)
	ldx #$07 ; force banque 7 
	stx $0321 ;  force banque X 
	ldy #$00 ; 
	lda $FF00,Y ;  lit un octet 
	pha 
	adc #$04 ; boucle d'attente 
	bcc $C2FD ; en sortie, C=1 
	pla 
	cmp $FF00,Y ;  le code a-t-il ete rafraichi ou garde ? 
	bne $C31B ; non, on doit ignorer la banque 
	iny  ; a-t-on fait 256 tests 
	bne $C2F9 ; 
	sty $FFFB ;  oui, on met 0 en definition banque 0 
	lda $FFFB ;  on lit la definition. 
	cpy $FFFB ;  est-elle toujours la meme ? 
	bne $C31D ; non, c'est de la ROM 
	iny  ; Y=1, c'est de la RAM 
	bne $C30A ; a-t-on passe 256 valeurs ? 
	lda #$0F ; oui, A=%00001111 (16 Ko RAM) 
	// bit  ; on saute l'instruction suivante 
	.byt $2c ; FIXME
	lda #$10 ; A=%0001000 (banque a ignorer) 
	sta $0200,X ;  banque X selon A (ignorer ou RAM 16 Ko) 
	cmp #$02 ; (en fait, ici A=0 ou A=15 ou A=16) 
	bne $C327 ; inconditionnel 
	jmp  ($FFFC) ;  
	dex 
	bne $C2F4 ; on fait toutes les banques 
	lda #$07 ; 
	sta $0321 ;  on force la banque 7 et on sort. 
	rts 


/*



C29B A0 00 LDY #$00 AY contient A
C29D A2 20 LDX #$20 le caractËre par dÈfaut est " "
C29F 86 14 STX $14 dans DEFAFF
C2A1 A2 01 LDX #$01 il faut afficher 3 caractËres (X+2)
C2A3 4C 39 CE JMP $CE39 on affiche par XDECIM


C2A6 A9 7F LDA #$7F interdit toute interruptions
C2A8 8D 0E 03 STA $030E dans VIA 6522-1
C2AB 8D 2E 03 STA $032E et VIA 6522-2
C2AE 8D 1D 03 STA $031D et ACIA 6551
C2B1 A9 00 LDA #$00
C2B3 8D 14 03 STA $0314 aucune directive au FDC
C2B6 A9 FF LDA #$FF %11111111
C2B8 8D 03 03 STA $0303 port A en sortie sur VIA1
C2BB A9 F7 LDA #$F7 %11110111
C2BD 8D 00 03 STA $0300 dans port B du VIA1
C2C0 8D 02 03 STA $0302 port B en sortie sauf PB3
21
C2C3 A9 17 LDA #$17 %00010111
C2C5 8D 21 03 STA $0321 dans port A du VIA2
C2C8 8D 23 03 STA $0323 PA0-1-2-4 en sortie et PA3-5-6-7 en entree
C2CB A9 E0 LDA #$E0 %11100000
C2CD 8D 20 03 STA $0320 dans port B du VIA2
C2D0 8D 22 03 STA $0322 PB0Åc4 en entree et PB5-6-7 en sortie
C2D3 A9 CC LDA #$CC %10101010 CA2 et CB2 en sortie/ecriture VIADR
C2D5 8D 0C 03 STA $030C dans V1PCR
C2D8 8D 2C 03 STA $032C et V2PCR
C2DB 60 RTS
C2DC BYT %10000100, %10100100, %11000100,%11100100 octets de tests des
drives ABCD
ROUTINE A TRANSFERER EN $0600
Action : en $0600, elle affiche les copyrights des banques et eventuellement execute le logiciel
qui s'y trouve.
En $0603, elle teste si les banques sont active, RAM ou ROM et place leur octet de
statut au cas echeant.
C2E0 4C 50 06 JMP $0650
C2E3 A9 00 LDA #$00
C2E5 8D 21 03 STA $0321 force banque 0
C2E8 AA TAX
C2E9 BD 00 07 LDA $0700,X envoie 256 octets de $0700
C2EC 9D 00 C5 STA $C500,X a $C500, routine de gestion des buffers
C2EF E8 INX
C2F0 D0 F7 BNE $C2E9
C2F2 A2 07 LDX #$07 force banque 7
C2F4 8E 21 03 STX $0321 force banque X
C2F7 A0 00 LDY #$00
C2F9 B9 00 FF LDA $FF00,Y lit un octet
C2FC 48 PHA
C2FD 69 04 ADC #$04 boucle d'attente
C2FF 90 FC BCC $C2FD en sortie, C=1
C301 68 PLA
C302 D9 00 FF CMP $FF00,Y le code a-t-il ete rafraichi ou garde ?
C305 D0 14 BNE $C31B non, on doit ignorer la banque
C307 C8 INY a-t-on fait 256 tests
C308 D0 EF BNE $C2F9
C30A 8C FB FF STY $FFFB oui, on met 0 en definition banque 0
C30D AD FB FF LDA $FFFB on lit la definition.
C310 CC FB FF CPY $FFFB est-elle toujours la meme ?
C313 D0 08 BNE $C31D non, c'est de la ROM
C315 C8 INY Y=1, c'est de la RAM
C316 D0 F2 BNE $C30A a-t-on passe 256 valeurs ?
C318 A9 0F LDA #$0F oui, A=%00001111 (16 Ko RAM)
C31A 2C BIT on saute l'instruction suivante
C21B A9 10 LDA #$10 A=%0001000 (banque a ignorer)
22
C31D 9D 00 02 STA $0200,X banque X selon A (ignorer ou RAM 16 Ko)
C320 C9 02 CMP #$02 (en fait, ici A=0 ou A=15 ou A=16)
C322 D0 03 BNE $C327 inconditionnel
C324 6C FC FF JMP ($FFFC)
C327 CA DEX
C328 D0 CA BNE $C2F4 on fait toutes les banques
C32A A9 07 LDA #$07
C32C 8D 21 03 STA $0321 on force la banque 7 et on sort.
C32F 60 RTS
*/	

	


		

	
	
	
	ldx #$00 ; banque 0 ($0650) 
	jsr $065E ;  
	ldx #$06 ; banque 6 
	jsr $065E ;  on affiche le copyright et on execute 
	dex  ; 2execute si une banque le demande. 
	bne $C337 ; 
	rts 
	lda $0200,X ;  on prend l'octet de definition de la banque X 
	bpl $C365 ; y-a-t-il un copyright a afficher ? 
	stx $0321 ;  oui, on force la banque X 
	lda $FFF8 ;  on stocke l'adresse du copyright dans RESB 
	sta $02 ; 
	lda $FFF9 ;  
	sta $03 ; 
	ldy #$00 ; 
	stx $0321 ;  on force la banque X 
	lda ($02),Y ; on lit le copyright 
	pha 
	lda #$07 ; banque 7 
	sta $0321 ;  
	pla 
	beq $C365 ; est-ce 0 ? 
	; brk $10 ; non, on affiche et on continue 
	.byt 0,$10
	iny 
	bne $C352 ; 
	lda $0200,X ;  
	asl  ; 2le programme doit-il se lancer automatiquement 
	bpl $C382 ; non 
	stx $0321 ;  
	lda $FFFC ;  on lit l'adresse d'execution 
	ldy $FFFD ;  
	sta $02FE ;  dans VAPLIC 
	sty $02FF ;  
	stx $02FD ;  
	lda #$07 ; on force banque 7 
	sta $0321 ;  et on sort 
	rts 
	
	jmp $0000 ;  vecteur non repertorie 
	.byt $07,$92,$c3
	;.byt $4c,$00,$00,$4c,$06,$04
	jmp $0000 ;  vecteur non repertorie 
	jmp $0406 ;  vecteur IRQ 
	.byt $80
	.byt $00,$00
	
	lda #$33 ; indexe "Logiciel. . . " 
	ldy #$C4 ; 
	; brk $14 ; affiche 
	.byt 00,$14
	jmp $C398 ;  et boucle indefiniment. 
	
	
	
	.byt $0c
	




	/* Couleurs pour affichage telestrat */
	.byt $97,$96,$95,$94,$93,$92,$91,$90
	.asc " TELESTRAT "
	.byt $90,$91,$92,$93,$94,$95,$96,$97,$90,$00
	/* RAM */
	.asc " Ko RAM,",0
	.asc " Ko ROM"
	.byt $0d,$0a,$00
	
	.asc "Drive:"
	.byt $00,$0d,$0a
	.asc "TELEMON V2.4"
	.byt $0d,$0a ; colors or 2.4 version ?
	.asc "(c) 1986 ORIC International"
	.byt $0d,$0a
	.byt $00,$0a
	.asc "Imprimante"
	.byt $00,$1b,$3a,$69
	.byt $43,$11,$00,$1b,$3a,$6a,$43,$14,$00,$8c
	
	.asc "Inserez une disquette",0
	
	.byt $0d,$18,$00
	.asc "Logiciel ecrit par Fabrice BROCHE",0
	.asc "BONJOURCOM"
	.byt $80
	.byt $4f,$c7,$52,$58,$a9,$e8,$8d,$21,$03

	lda #$00 ; 
	ldy #$C1 ; 
	sta $00 ; $C100 dans RES 
	sty $01 ; 
	ldx #$01 ; on lit piste 0 secteur 1 
	stx $0312 ;  1 dans le registre de secteur 
	jsr $B84F ;  on lit le secteur 
	lda $C100 ;  on prend l'indicateur 
	bne $C4AD ; est-ce le bon SED ? 
	lda $C103 ;  oui, on lit l'adresse 
	ldy $C104 ;  ou il faut charger le SED 
	sta $00 ; dans RES 
	sty $01 ; 
	cpx $C101 ;  a-t-on lu toute la piste ? 
	bne $C496 ; non 
	lda #$58 ; oui, %01011000 
	jsr $B86D ;  soit deplacer la tete d'une piste 
	ldx #$00 ; compteur de secteur a 0 
	nop  ; 2tss tss 
	nop 
	inx  ; 2on lit un secteur du SED 
	stx $0312 ;  
	jsr $B84F ;  
	inc $01 ; on passe a la page suivante 
	dec $C102 ;  a-t-on fait tous les secteurs du SED ? 
	bne $C488 ; non 
	jsr $C105 ;  oui, on execute l'amorce du SED 
	lda $FFFB ;  on lit l'etat de la banque 
	sta $0200 ;  dans l'octet de STATUS banque 0 
	lda #$EF ; et on repasse sur la banque 7 
	sta $0321 ;  
	rts 
	
	
	

	.byt $a9,$88,$8d,$10,$03,$a0,$04,$88,$d0,$fd,$ad,$10,$03
	.byt $4a,$90,$1e,$ad,$18,$03,$30,$f5,$ad,$13,$03,$91,$00,$c8,$4c,$5f
	.byt $b8,$8d,$10,$03,$a0,$03,$88,$d0,$fd,$ad,$10,$03,$4a,$b0,$fa,$60
	
	.byt $ea,$ad,$10,$03,$29,$1c,$f0,$f7,$d0,$c9,$86,$02,$8a,$a2,$ff,$38
	.byt $e9,$03,$e8,$b0,$fa,$bd,$af,$c6,$85,$00,$bd,$b0,$c6,$85,$01,$bd
	.byt $b1,$c6,$bc,$b2,$c6,$a6,$02,$2c,$18,$c5,$50,$08,$a9,$00,$2c,$a9
	.byt $01,$2c,$24,$c5,$38,$4c,$09,$04,$2c,$18,$c5,$50,$03,$2c,$24,$c5
	.byt $18,$4c,$09,$04,$4c,$93,$04,$4c,$a1,$04,$4c,$7e,$04,$4c,$19,$04
	.byt $4c,$36,$04,$00,$00,$4c,$af,$04,$4c,$00,$00,$00,$00,$08,$78,$48
	.byt $ad,$21,$03,$29,$f8,$8d,$21,$03,$68,$20,$00,$c5,$a8,$ad,$21,$03
	.byt $09,$07,$8d,$21,$03,$6a,$28,$0a,$98,$60
	
	
		/*
	
	lda #$E8 ; %11101000 soit banque 0 
	sta $0321 ;  dans V2DRA 
	
	    
	

	
	
	
	lda #$88 ; %10001000 dans FDCCR 
	sta $0310 ;  soit lire un secteur 
	ldy #$04 ; 
	dey  ; 2delai pour attendre la fin de la lecture 
	bne $C4BA ; 
	lda $0310 ;  on lit le registre de commande 
	lsr  ; 2operation terminee ? 
	bcc $C4E1 ; oui 
	lda $0318 ;  non, est-on en DATA READY ? 
	bmi $C4BD ; non, on boucle 
	lda $0313 ;  oui, on lit le numero de piste 
	sta ($00),Y ; dans le buffer 
	iny  ; 2et on pointe sur la position suivante 
	jmp $B85F ;  pourquoi pas BNE ??? 
	sta $0310 ;  ($B86D) on envoie la commande A 
	ldy #$03 ; on attend la reponse 
	dey 
	bne $C4D6 ; 
	lda $0310 ;  ordre traite 
	lsr 
	bcs $C4D9 ; non 
	rts  ; oui, on sort 
	nop 
	lda $0310 ;  on lit le retour 
	and #$1C ; y-a-t-il une erreur ? 
	beq $C4DF ; non, RTS 
	bne $C4B3 ; oui, on recommence 
	stx $02 ; on sauve l'index du buffer 
	txa 
	ldx #$FF ; on calcule la position des 4 octets 
	sec  ; 2de definition du buffer X 
	sbc #$03 ; 
	inx 
	bcs $C4EF ; 
	lda $C6AF,X ;  on lit l'adresse de debut 
	sta $00 ; dans RES 
	lda $C6B0,X ;  
	sta $01 ; 
	lda $C6B1,X ;  et l'adresse de fin (non incluse dans le buffer) 
	ldy $C6B2,X ;  dans AY 
	ldx $02 ; et on initialise 
	bit $C518 ;  adresse de debut dans RES 
	bvc $C514 ; adresse de fin dans AY 
	lda #$00 ; 
	lda #$01 ; 
	bit $C524 ;  
	sec 
	jmp $0409 ;  
	bit $C518 ;  
	bvc $C520 ; 
	bit $C524 ;  
	clc 
	jmp $0409 ;  
	jmp $0493 ;  $0400 . fin d'IRQ 
	jmp $04A1 ;  $0403 . fin de BRK 
	jmp $047E ;  $0406 . IRQ EXBNK 
	jmp $0419 ;  $0409 . gestion des buffers 
	jmp $0436 ;  $040C . gestion des banques 
	jmp $04AF ;  $0411 . lecture d'une donnee Durant BRK 
	jmp $0000 ;  $0414 . vecteur d'execution inter-banque VEXBNK 
	php  ; ($0419) on sauve P 
	sei  ; car on interdit les interruptions 
	pha 
	lda $0321 ;  on force la banque 0 
	and #$F8 ; (RAM) car les buffers 
	sta $0321 ;  sont en RAM 
	pla 
	jsr $C500 ;  et on execute la routine des buffers 
	tay  ; on preserve la donnee 
	lda $0321 ;  
	ora #$07 ; on repasse sur la banque 7 
	sta $0321 ;  
	ror  ; on preserve C 
	plp 
	asl 
	tya  ; 2C et A sont representatifs du resultat 
	rts 
	php  ; 2($0436) 
	sei 
	pha  ; 2on sauve A et X 
	txa 
	pha 
	lda $0321 ;  on sauve la banque actuelle dans la pile locale 
	ldx $0418 ;  dont le pointeur est en $0418 
	sta $04C8,X ;  
	inc $0418 ;  
	pla 
	tax 
	lda $0417 ;  A = banque cible 
	jsr $046A ;  on force la banque A 
	pla 
	plp 
	jsr $0414 ;  on execute le vecteur VEXBNK 
	php 
	sei 
	pha 
	txa 
	pha 
	dec $0418 ;  on restaure la banque d'avant 
	ldx $0418 ;  l'appel 
	lda $04C8,X ;  
	jsr $046A ;  
	pla 
	tax 
	pla 
	plp  ; 2et on sort avec A, X, Y et P preserves et 
	rts  ; 2representatives de l'appel 
	php  ; 2($046A) 
	sei 
	and #$07 ; il n'y a que 7 banques . . . 
	sta $04C7 ;  dans une variable temporaire 
	lda $0321 ;  
	and #$F8 ; on force la banque A 
	ora $04C7 ;  
	sta $0321 ;  
	plp 
	rts 
	sta $21 ; ($047E) on sauve A 
	lda $0321 ;  on force la banque 7 
	and #$07 ; 
	sta $040F ;  apres avoir sauve la banque courante 
	lda $0321 ;  
	ora #$07 ; 
	sta $0321 ;  
	jmp $C868 ;  et on execute les IRQ 
	lda $0321 ;  ($0493) 
	and #$F8 ; on restaure la banque par $040F 
	ora $040F ;  donc en sortie d'IRQ 
	sta $0321 ;  
	lda $21 ; on recupere A 
	rti  ; 2et on sort 
	pha  ; 2($04A1) 
	lda $0321 ;  on force la banque selon 
	and #$F8 ; le contenu de $0410 
	ora $0410 ;  
	sta $0321 ;  tout en preservant A 
	pla 
	rts 
	lda $0321 ;  ($04AF) on force la banque selon $0410 
	and #$F8 ; sauve par BRK 
	ora $0410 ;  
	sta $0321 ;  
	lda ($15),Y ; on lit l'octet pointe indirectement 
	pha  ; 2sur la banque de l'appelant 
	lda $0321 ;  on repasse sur la banque 7 
	ora #$07 ; 
	sta $0321 ;  
	pla  ; 2et on sort avec la donnee lue dans A 
	rts 
	bcc $C639 ; si C=0, c'est une lecture/ecriture 
	bvc $C5FE ; C=1 si V=0 on initialise un buffer 
	tay 
	beq $C61E ; C=1 V=1 si Z=1 on vide le buffer 
	lda $C088,X ;  sinon, on teste le buffer 
	ora $C089,X ;  longueur = 0 
	beq $C5FC ; oui C=1 
	clc  ; 2non C=0 
	rts 
	sec 
	rts 
	sta $02 ; on initialise avec fin+1 dans RESB 
	sty $03 ; 
	sec 
	sbc $00 ; fin-debut 
	sta $C08A,X ;  dans longueur du buffer 
	tya 
	sbc $01 ; 
	sta $C08B,X ;  
	txa 
	adc #$03 ; 
	tax 
	ldy #$03 ; 
	lda $0000,Y ;  pourquoi pas LDA $00,Y ? etiquette peut-etre 
	sta $C07F,X ;  on place adresse de debut et de fin (exclue) 
	dex 
	dey 
	bpl $C614 ; 
	lda #$00 ; vide le buffer 
	sta $C088,X ;  longueur de fin 
	sta $C089,X ;  
	lda $C082,X ;  adresse de fin 
	sta $C084,X ;  dans pointeur de lecture 
	sta $C086,X ;  et pointeur d'ecriture 
	lda $C083,X ;  
	sta $C085,X ;  
	sta $C087,X ;  
	rts  ; 2et on sort 
	bvs $C661 ; C=0 si V=1 on ecrit 
	jsr $C507 ;  sinon, lecture buffer vide ? 
	bcs $C660 ; oui on sort C=1 
	lda $C086,X ;  prend pointeur de lecture dans AY 
	ldy $C087,X ;  
	jsr $C5A6 ;  on calcule la prochaine position de lecture 
	sta $C086,X ;  dans le pointeur de lecture 
	tya 
	sta $C087,X ;  
	lda $C088,X ;  on decremente le pointeur d'ecriture 
	bne $C658 ; 
	dec $C089,X ;  
	dec $C088,X ;  
	ldy #$00 ; on lit le code dans A 
	lda ($24),Y ; 
	clc  ; lecture OK, C=0 
	rts 
	pha 
	lda $C088,X ;  longueur utilisee < longueur du buffer ? 
	cmp $C08A,X ;  
	lda $C089,X ;  
	sbc $C08B,X ;  
	bcs $C68F ; non, on recupere la donnee et on sort 
	lda $C084,X ;  on calcule la prochaine position 
	ldy $C085,X ;  d'ecriture 
	jsr $C5A6 ;  
	sta $C084,X ;  dans le pointeur d'ecriture 
	tya 
	sta $C085,X ;  
	inc $C088,X ;  on ajoute 1 a la longueur utilisee 
	bne $C688 ; 
	inc $C089,X ;  
	ldy #$00 ; 
	pla 
	sta ($24),Y ; on ecrit la donnee 
	clc  ; 2C=0 et A est intact 
	rts 
	pla  ; 2ecriture ratee, C=1, A restaure 
	rts 
	clc  ; 2($C5A6) 
	adc #$01 ; on incremente l'adresse AY 
	bcc $C697 ; 
	iny 
	cmp $C082,X ;  
	sta $24 ; AY < adresse de fin ? 
	tya 
	sbc $C083,X ;  
	bcc $C6AA ; oui dans $24-$25 
	lda $C080,X ;  non, on prend l'adresse de debut du buffer 
	ldy $C081,X ;  
	sta $24 ; dans $24-$25 
	sty $25 ; 
	lda $24 ; AY contient l'adresse de la prochaine 
	rts  ; 2position dans le buffer 
	ldx #$00 ; on met un 0 sur le port A 
	stx $0301 ;  du VIA 1 
	lda $0300 ;  on force PB4 a 0 
	and #$EF ; %11101111, soit pas de STROBE 
	sta $0300 ;  on depose B sur le bus 
	ora #$10 ; puis on genere un STROBE par PB4 
	sta $0300 ;  
	lda $030D ;  on lit IFR 
	and #$02 ; transition CA1 (ACK) ? 
	bne $C6DC ; oui, l'imprimante est branchee 
	dex  ; 2non 
	bne $C6D1 ; on fait le test 256 fois pour etre sur 
	rts  ; 2et on sort si l'imprimante n'a pas repondu 
	lda $020D ;  
	ora #$02 ; on indique imprimante detectee 
	sta $020D ;  dans FLGTEL 
	rts  ; 2et on sort 
	ldx #$00 ; pour canal 0 
	ldx #$04 ; pour canal 1 
	ldx #$08 ; pour canal 2 
	ldx #$0C ; pour canal 3 
	pha  ; 2on sauve l'E/S 
	pla  ; 2on lit l'E/S 
	cmp $02AE,X ;  est-elle deja ouverte sur le canal en question 
	beq $C704 ; oui C=1 et on sort 
	ldy $02AE,X ;  le canal est-il sature ? 
	bpl $C705 ; non, on peut ouvrir l'E/S 
	inx 
	pha 
	txa 
	and #$03 ; on teste les 4 E/S du canal 
	bne $C6F1 ; 
	pla 
	rts  ; 2En sortie, A contient l'E/S 
	ldy #$0F ; pour 4*4 E/S possibles 
	cmp $02AE,Y ;  l'E/S est-elle ouverte sur un des 4 canaux ? 
	beq $C71B ; oui, on ouvre simplement l'E/S sur le canal 
	dey 
	bpl $C707 ; 
	stx $19 ; on sauve le numero du canal 
	pha 
	ldy #$80 ; N=1 Z=0 
	tax 
	jsr $C81C ;  on active l'E/S dans X 
	ldx $19 ; on recupere l'index 
	pla  ; 2l'E/S 
	sta $02AE,X ;  et on ouvre l'E/S 
	clc  ; 2C=0 
	rts 
	ldx #$00 ; index canal 0 
	ldx #$04 ; index canal 1 
	ldx #$08 ; index canal 2 
	ldx #$0C ; index canal 3 
	ldy #$03 ; pour 4 E/S 
	cmp #$00 ; doit-t-on fermer toutes les E/S ? 
	beq $C74E ; oui 
	cmp $02AE,X ;  l'E/S est-elle ouverte ? 
	beq $C73B ; oui 
	inx 
	dey 
	bpl $C731 ; 
	rts  ; 2l'E/S n'etait pas ouverte 
	lsr $02AE,X ;  on ferme l'E/S 
	ldx #$0F ; si l'E/S n'est ouverte sur aucun 
	cmp $02AE,X ;  autre canal. 
	beq $C73A ; 
	dex 
	bpl $C740 ; 
	tax 
	ldy #$81 ; N=1 C=1 V=0 
	jmp $C81C ;  on desactive l'E/S 
	lsr $02AE,X ;  on ferme les 4 E/S sur le canal 
	inx 
	dey 
	bpl $C74E ; 
	rts  ; 2et on sort 
	lda #$0A ; on envoie un CR (ASCII 13) 
	jsr $C75D ;  sur le canal 0 
	lda #$0D ; et un LF (ASCII 11) 
	pha  ; 2on sauve la donnee 
	lda #$00 ; index canal 0 
	beq $C76F ; inconditionnel 
	pha 
	lda #$04 ; index canal 1 
	bne $C76F ; 
	pha 
	lda #$08 ; index canal 2 
	bne $C76F ; 
	pha 
	lda #$0C ; index canal 3 
	sta $19 ; on sauve le numero du canal 
	pla 
	sta $1B ; et la donnee 
	lda #$04 ; 
	sta $1A ; pour 4 E/S a tester 
	txa  ; 2on sauve X et Y 
	pha 
	tya 
	pha 
	ldx $19 ; donnee dans X 
	lda $02AE,X ;  l'E/S est elle une sortie ? 
	cmp #$88 ; 
	bcc $C79B ; non, on passe 
	asl 
	tax 
	lda $02BE,X ;  oui, on met son adresse dans 
	sta $02F8 ;  $02F8 - $02F9 
	lda $02BF,X ;  
	sta $02F9 ;  
	lda $1B ; donnee dans A 
	bit $C795 ;  N=0 C=1 
	jsr $02F7 ;  on ecrit la donnee sur l'E/S 
	inc $19 ; 
	dec $1A ; 
	bne $C77C ; et on scrute 4 E/S 
	pla 
	tay 
	pla  ; 2on recupere A, X et Y 
	tax 
	lda $1B ; 
	rts 
	ldx #$00 ; on index le canal 0 
	ldx #$04 ; on index le canal 1 
	ldx #$08 ; on index le canal 2 
	ldx #$0C ; on index le canal 3 
	stx $1C ; on sauve le canal 
	sta $15 ; et l'adresse de la chaine 
	sty $16 ; 
	lda $1C ; 
	sta $19 ; on positionne le canal 
	ldy #$00 ; Y=0 pour adressage indirect 
	jsr $0411 ;  et on lit un octet 
	beq $C7A7 ; est-ce 0 ? oui on sort 
	jsr $C772 ;  non, on l'affiche directement 
	inc $15 ; on incremente l'adresse 
	bne $C7B9 ; et on boucle 
	inc $16 ; 
	bne $C7B9 ; inconditionnel 
	lda #$00 ; on index canal 0 
	lda #$04 ; on index canal 1 
	lda #$08 ; on index canal 2 
	lda #$0C ; on index canal 3 
	sta $19 ; on sauve le canal 
	lda #$04 ; pour 4 E/S 
	sta $1A ; 
	txa  ; 2on sauve les registres 
	pha 
	tya 
	pha 
	ldx $19 ; 
	lda $02AE,X ;  y a-t-il une E/S ouverte ? 
	bpl $C7F9 ; non, suivante 
	cmp #$88 ; oui, une entree ? 
	bcs $C7F9 ; non, suivante 
	tax  ; 2on prend l'index 
	ldy #$40 ; N=0 V=1 C=0 
	jsr $C81C ;  on lit la donnee 
	sta $1D ; et on la sauve 
	bcc $C7FF ; C=0, on sort si une donnee a ete lue 
	inc $19 ; 
	dec $1A ; 
	bne $C7E4 ; on scrute les 4 E/S si besoin est 
	pla  ; 2on recupere X et Y 
	tay 
	pla 
	tax 
	lda $1D ; et la donnee 
	rts  ; 2C=1 si aucune donnee n'est lue 
	.  ;  
	lda #$00 ; indexer canal 0 
	lda #$04 ; indexer canal 1 
	lda #$08 ; indexer canal 2 
	lda  ; 2#$0C indexer canal 3 
	sta $1B ; on sauve le canal 
	lda $1B ; pourquoi pas TAX/TXA ? 2 octets de perdus . . 
	jsr $C7DA ;  on lit un code 
	bcs $C813 ; si pas de code lu, on boucle 
	sec  ; 2sinon, C=1, ca cloche ! 
	rts 
	sty $17 ; on sauve la commande 
	sty $18 ; 
	pha  ; 2et la donnee (pourquoi ???) 
	txa 
	asl  ; 2on multiplie le numero de l'E/S par deux 
	tax 
	lda $02BE,X ;  et on prepare le saut a l'adresse 
	sta $02F8 ;  de gestion de l'E/S 
	lda $02BF,X ;  
	sta $02F9 ;  
	pla  ; 2on recupere la donnee 
	lsr $17 ; on positionne C 
	bit $18 ; N et V 
	jmp $02F7 ;  et on execute la routine de l'E/S 

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30
	brk 

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30
: ;1 on depile P et l'adresse de la routine que l'on execute. 
: ;1 fin de la routine, on depile $0402 donc on se branche en $0403. 
: ;1 fin de la $0403, on depile l'adresse de retour de base que l'on a deja 
	stx $22 ; on sauve X 
	sty $23 ; on sauve Y 
	pla 
	sta $24 ; et P dans IRQSVX, IRQSVY et $0024 
	and #$10 ; B=1 ? (est-ce un BRK) 
	beq $C8B3 ; non, on passe aux IRQ systeme 
	tsx  ; 2on prend 
	pla  ; 2on decremente l'adresse de retour 
	bne $C87A ; car RTS incremente apres depilement 
	dec $0102,X ;  
	sec 
	sbc #$01 ; 
	pha 
	sta $15 ; on sauve l'adresse de retour -1 
	lda $0102,X ;  dans $0015-$0016 pour lire le code suivant le BRK 
	sta $16 ; 
	lda $040F ;  on place la banque d'appel comme banque de BRK 
	sta $0410 ;  
	ldy #$00 ; 
	jsr $0411 ;  on lit le numero de la routine appelee 
	asl 
Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 69
 ; 2*2 car une adresse a deux octets 
	tax 
	lda #$04 ; on met dans la pile $0403-1 
	pha  ; 2car on va s'y brancher par RTS 
	lda #$02 ; pourquoi pas LSR ? 
	pha 
	lda $CAA5,X ;  on lit l'adresse de la routine 
	ldy $CAA4,X ;  
	bcc $C8A6 ; si C=1 
	lda $CBA5,X ;  on lit dans la deuxieme table car 
	ldy $CBA4,X ;  le code etait > 127 
	pha  ; 2on empile l'adresse exacte 
	tya  ; 2car on appelle par RTI 
	pha  ; 2on empile P (RTI oblige) 
	lda $24 ; 
	pha 
	lda $21 ; on prend A, X et Y 
	ldy $23 ; 
	ldx $22 ; 
	rti  ; 2et on execute la routine 
	lda $24 ; on replace P 
	pha 
	sec 
	ror $1E ; on force b7 ($1E) a 1 pour indiquer premier passage 
	jsr $C8BF ;  on gere la RS232 (entree et sortie) 
	jmp $C9B9 ;  et on poursuit le traitement des IRQ 
	tya  ; 2on sauve Y 
	pha 
	lda $031D ;  on prend l'etat de la RS232 
	bpl $C91B ; occupee ? on saute 
	lsr $1E ; oui, on annule b7 ($1E) 
	pha  ; 2on sauve ACIASR 
	and #$08 ; b4=1 ? 
	beq $C8DF ; non 
	ldx $031C ;  oui, on lit la donnee 
	pla  ; 2et l'etat 
	pha 
	and #$07 ; donÅft on isole b2 b1 b0 
	beq $C8D9 ; tout a 0 ? oui 
	ora #$B0 ; non %1011000 on force les bits 
	txa  ; 2donnee dans A 
	ldx #$0C ; indexe buffer ACIA entree 
	jsr $C51D ;  et on inscrit la donnee 
	pla  ; 2on sort l'etat sauvegarde 
	and #$10 ; libre en ecriture ? 
	beq $C91B ; non 
	ldx #$18 ; oui, on lit le buffer ACIA sortie 
	jsr $C50F ;  y-a-t-il une donnee ? 
	bcs $C901 ; non 
	lda $031D ;  oui, on lit l'etat 
	and #$20 ; ecriture possible ? 
	bne $C91B ; non, on sort 
	jsr $C518 ;  oui, on lit une donnee dans le buffer 
	sta $031C ;  on la depose sur le registre de donnees 
	lda $031F ;  on envoie la 
	and #$07 ; pour 7 bits 
	sta $3F ; dans $3f 
	bcc $C91B ; inconditionnel 
	inc $20 ; si $20 non nul 
	bne $C91B ; on sort 
	dec $3F ; $3F non nul, on sort 
	bne $C91B ; 
	lda $028A ;  si imprimante serie, C=1 
	lsr 
	lsr 
	lsr 
	lda $031E ;  on force b4 b3 de ACIA Command Register 
	and #$F3 ; 
	bcc $C918 ; si imprimante centronics, on passe 
	and #$FE ; si RS232, on force b1 a 0 
	sta $031E ;  on place la commande 
	pla 
	tay  ; 2on recupere Y et on sort 
	rts 
	dec $0215 ;  faut-il gerer horloges et imprimante ? 
	bne $C973 ; non 
	lda #$04 ; on replace le compteur pour 1/10 de seconde 
	sta $0215 ;  
	bit $028A ;  imprimante prete ? 
	bpl $C930 ; 
	jsr $CA2F ;  oui, on gere l'imprimante 
	lda $44 ; on decompte les dixiemes utilisateurs 
	bne $C936 ; dans 16 bits de TIMEUD 
	dec $45 ; 
	dec $44 ; 
	sec 
	inc $0210 ;  on compte 0,1 seconde dans l'horloge temps reel 
	lda $0210 ;  
	sbc #$0A ; 
	bcc $C973 ; a-t-on 10 dixiemes ? 
	sta $0210 ;  oui, on met 0 
	bit $0214 ;  faut-il afficher l'horloge 
	bpl $C94E ; 
	jsr $CA75 ;  oui, so do we ! 
	inc $0211 ;  on ajuste les secondes 
	lda $42 ; et le timer utilisateur en secondes 
	bne $C957 ; (pourquoi ?? rien ne dit qu'il concorde 
	dec $43 ; avec l'horloge !!!) 
	dec $42 ; donc TIMEUD et TIMEUS sont desynchronises 
	lda $0211 ;  60 secondes ? 
	sbc #$3C ; 
	bcc $C973 ; 
	sta $0211 ;  oui, on ajoute une minute 
	inc $0212 ;  
	lda $0212 ;  
	sbc #$3C ; 60 minutes ? 
	bcc $C973 ; 
	sta $0212 ;  
	inc $0213 ;  oui on ajoute une heure 
	dec $0216 ;  faut-il gerer le curseur 
	bne $C991 ; 
	lda #$0A ; oui, on remet le compteur de quart de secondes 
	sta $0216 ;  
	lda $0217 ;  on inverse l'etat du curseur 
	eor #$80 ; 
	sta $0217 ;  
	bit $0248 ;  test pour la fenetre 0 
	bpl $C991 ; si curseur absent, on sort 
	bvs $C991 ; si curseur fixe aussi 
	ldx $28 ; on gere le curseur dans la fenetre courante 
	jmp $DE2D ;  (et si ce n'est pas la fenetre 0 ?!) 
	rts 
	lda $030D ;  IRQ par T2 ? 
	and #$20 ; 
	beq $C9B9 ; non, on passe sur T1 
	lda $028F ;  oui, on replace la valeur de 
	ldy $0290 ;  base (10000) dans T2 
	sta $0308 ;  
	sty $0309 ;  
	lda $028C ;  souris branchee ? 
	lsr 
	bcc $C9B1 ; non 
	jsr $E085 ;  oui, on gere la souris 
	jmp $C8B9 ;  et on poursuit les IRQ 
	lda #$FF ; on place le compteur largement pour 
	sta $0309 ;  ne pas etre derange par une souris absente 
	jmp $C8B9 ;  et on poursuit (BNE, non ?) 
	bit $030D ;  IRQ traitee ? 
	bmi $C9CC ; non 
	bit $1E ; oui, transmission serie en cours ? 
	bpl $C9C9 ; oui 
	ldx $22 ; non, on termine 
	ldy $23 ; normalement les IRQ 
	jmp $0400 ;  
	jmp $C8B6 ;  on poursuit la transmission serie 
	lsr $1E ; on indique transmission en cours 
	bit $030D ;  IRQ par T1 ? 
	bvc $CA1F ; non 
	bit $0304 ;  on annule T1L 
	jsr $C91E ;  on gere les timers, l'imprimante et le curseur 
	dec $02A6 ;  $02A6=0 
	bne $CA00 ; non, on passe 
	jsr $D7DF ;  oui, on gere le clavier 
	jsr $C8BF ;  et la transmission serie 
	bit $0270 ;  b7 de $0270 ? 
	bpl $C9F0 ; 0, on passe 
	lda #$14 ; on met 20 dans $02A7 
	sta $02A7 ;  
	bne $C9FB ; et on saute 
	lda $02A8 ;  on prend $02A8 
	bit $02A7 ;  b7 de $02A7=1 ? 
	bmi $C9FD ; oui, on met $02A8 dans $02A6 
	dec $02A7 ;  non 
	lda #$01 ; on met 1 
	sta $02A6 ;  dans $02A6 
	bit $028C ;  joystick droit connecte ? 
	bpl $CA0B ; 
	jsr $DFFA ;  on gere le joy droit (enfin, on devrait -> RTS) 
	bit $028C ;  joystick gauche ? 
	bvc $CA10 ; 
	jsr $DFFB ;  oui, on gere le port gauche 
	lda $028C ;  souris connectee ? 
	lsr 
	bcc $CA19 ; non 
	jsr $E0E1 ;  oui, on gere la souris (double gestion donc) 
	jmp $C8B9 ;  on poursuit la transmission serie 
	jmp $C992 ;  on gere les IRQ par T2 
	lda $030D ;  l'IRQ ne vient pas de T1 
	and #$02 ; ACK imprimante ? 
	beq $CA1C ; non 
	bit $0301 ;  oui, on annule le ACK 
	jsr $CA2F ;  on gere l'imprimante 
	jmp $C8B9 ;  et on poursuit la transmission serie 
	ldx #$24 ; indexe buffer imprimante 
	jsr $C518 ;  on lit une donnee 
	bcc $CA3E ; buffer vide ? non 
	asl $028A ;  oui 
	sec  ; 2on indique imprimante libre 
	ror $028A ;  
	rts  ; 2et on sort 
	sta $0301 ;  on met la donnee sur le port A 
	lda $0300 ;  et on genere un STROBE 
	and #$EF ; en mettant successivement a 0 
	sta $0300 ;  
	ora #$10 ; et a 1 la broche PB4 
	sta $0300 ;  
	asl $028A ;  et on indique imprimante occupee 
	lsr $028A ;  
	rts 
	lda #$00 ; on met 0 
	ldx #$04 ; 
	sta $0210,X ;  dans TIMEH, TIMEM, TIMES et TIMED 
	dex 
	bpl $CA59 ; 
	lda #$01 ; puis on force l'ajustement de l'horloge 
	sta $0215 ;  a la prochaine IRQ 
	rts 
	lsr $0214 ;  on indique pas d'affiche dans FLGCLK 
	rts 
	php  ; 2on interdit les interruptions 
	sei  ; 2pour ne pas qu'un affichage se fasse entre 
	sta $40 ; CA6B et CA6D 
	sty $41 ; on stocke l'adresse d'affichage dans ADCLK 
	sec 
	ror $0214 ;  et on indique qu'il faut afficher l'horloge 
	plp  ; 2toutes les secondes 
	rts 
	ldy #$00 ; on positionne l'affiche en ADCLK 
	lda $0213 ;  on lit l'heure 
	jsr $CA90 ;  et on affiche deux chiffres 
	lda #$3A ; on affiche ":" 
	sta ($40),Y ; 
	iny 
	lda $0212 ;  on lit les minutes 
	jsr $CA90 ;  que l'on affiche 
	lda #$3A ; suivies de ":" 
	sta ($40),Y ; 
	iny 
	lda $0211 ;  et on affiche les secondes 
	clc  ;  SEC en trop, et une habile gestion des registres et des 
	ldx #$2F ; X contient "0"-1 
	sec 
	sbc #$0A ; on soustrait 10 a A 
	inx  ; 2et on ajoute 1 a X 
	bcs $CA93 ; on a depasse ? 
	pha  ; 2oui, on sauve le reste 
	txa  ; 2et on affiche X, le premier chiffre 
	sta ($40),Y ; 
	pla  ; 2on reprend le reste 
	iny  ; 2on indexe la position suivante 
	adc #$3A ; on ajoute "0"+10 au reste 
	sta ($40),Y ; et on l'affiche 
	iny  ; 2puis on indexe la prochaine position 
	rts 
	brk 
	sty $60 ; on sauve les donnees 
	sta $66 ; passees par registre 
	stx $63 ; 
	ldx #$00 ; 
	jsr $DE1E ;  on eteint le curseur dans la fenetre 0 
	ldy $62 ; Y = premiere ligne dans la fenetre 
	ldx $66 ; X = premier choix a afficher 
	iny  ; 2on passe a la ligne et 
	inx  ; 2au choix suivant 
	jsr $CCF9 ;  on affiche le choix 
	bmi $CBFB ; si dernier choix on passe 
	cpy $63 ; sinon, fin de la fenetre ? 
	bne $CBF0 ; non 
	stx $67 ; on stocke le numero du dernier choix 
	ldx $60 ; X = choix ou placer la barre 
	sec 
	txa 
	sbc $66 ; on enleve le premier choix affiche 
	clc 
	adc $62 ; et on ajoute la premiere ligne de la fenetre 
	tay 
	jsr $CCD3 ;  on affiche la barre 
	jsr $C806 ;  on attend une touche 
	pha  ; 2on sauve la touche 
	bit $020D ;  est-on en mode Minitel ? 
	bvc $CC20 ; non 
	lda #$08 ; oui, on enleve le marqueur 
	jsr $C75D ;  
	lda #$20 ; 
	jsr $C75D ;  
	jmp $CC2E ;  pourquoi pas BNE ??? 
	ldy $61 ; 
	ldx $65 ; 
	lda ($26),Y ; on efface la barre en video inverse 
	and #$7F ; 
	sta ($26),Y ; 
	iny 
	dex 
	bne $CC24 ; 
	pla  ; 2on lit la touche 
	cmp #$20 ; espace ? 
	beq $CC3B ; oui, on sort 
	cmp #$1B ; ESC ? 
	beq $CC3B ; oui, on sort 
	cmp #$0D ; RETURN ? 
	bne $CC3E ; non, on passe 
	ldx $60 ; sortie A contient le code de la touche de sortie 
	rts 
	cmp #$0A ; fleche bas ? 
	bne $CC6D ; non, on passe 
	lda $60 ; la barre est en bas ? 
	cmp $67 ; 
	beq $CC4D ; 
	inc $60 ; non, on descend la barre 
	jmp $CBFD ;  et on recommence 
	bit $68 ; oui, y a-t-il encore des choix ? 
	bmi $CBFD ; non, on recommence 
	inc $60 ; oui, on ajuste les variables 
	inc $67 ; 
	inc $66 ; 
	bit $020D ;  mode Minitel ? 
	bvs $CBEB ; oui, on reaffiche tout 
	ldx $62 ; non, on scrolle la fenetre 
	ldy $63 ; 
	jsr $DE54 ;  vers le haut 
	ldy $63 ; 
	ldx $60 ; 
	jsr $CCF9 ;  on affiche le choix suivant 
	jmp $CBFD ;  et on boucle 
	cmp #$0B ; fleche haut ? 
	bne $CC9A ; non, on passe 
	lda $60 ; on est en haut de la fenetre ? 
	cmp $66 ; 
	bne $CC92 ; non 
	lda $60 ; oui, premier choix ? 
	beq $CC94 ; oui 
	dec $66 ; on ajuste les variables 
	dec $67 ; 
	dec $60 ; 
	bit $020D ;  mode Minitel ? 
	bvs $CC97 ; oui, on repart 
	ldx $62 ; non, on scrolle vers le bas 
	ldy $63 ; 
	jsr $DE5C ;  
	ldy $62 ; 
	jmp $CC65 ;  et on affiche le choix et on boucle 
	dec $60 ; 
	jmp $CBFD ;  on boucle 
	jmp $CBEB ;  
	cmp #$30 ; est- on entre "0" 
	bcc $CC94 ; 
	cmp #$3A ; et "9" inclus ? 
	bcs $CC94 ; non, on repart 
	ldx $60 ; oui, le choix courant 
	cpx #$19 ; est inferieur a 25 ? 
	bcc $CCAE ; oui 
	ldx $66 ; non, on place la barre 
	stx $60 ; sur le premier choix 
	bcs $CC94 ; et on boucle 
	pha  ; 2on sauve la touche 
	asl $60 ; choix actuel *2 
	lda $60 ; 
	asl $60 ; *4 
	asl $60 ; *8 
	adc $60 ; *10 
	sta $60 ; 
	pla 
	and #$0F ; on isole le numero demande 
	adc $60 ; on ajoute au choix courant 
	sbc #$00 ; -1 si on depasse 
	sta $60 ; 
	bcc $CCA8 ; et on boucle tant qu'on depasse 
	cmp $66 ; 
	bcc $CCA8 ; ou jusqu'a ce qu'on soit a la fin de la fenetre 
	cmp $67 ; 
	beq $CCD0 ; 
	bcs $CCA8 ; 
	jmp $CBFD ;  et on boucle 
	jsr $CD5A ;  on positionne le curseur en X, Y 
	bit $020D ;  mode Minitel ? 
	bvc $CCEA ; non 
	ldx #$02 ; oui, on decale le curseur a droite 3 fois 
	lda #$09 ; 
	jsr $C75D ;  
	dex 
	bpl $CCDD ; 
	lda #$2D ; et on affiche "-" 
	jmp $C75D ;  
	ldy $61 ; on prend l'abscisse de la fenetre 
	ldx $65 ; on prend la longueur de la barre 
	lda ($26),Y ; 
	ora #$80 ; et on inverse la barre 
	sta ($26),Y ; 
	iny 
	dex 
	bne $CCEE ; 
	rts 
	tya  ; 2on va afficher le choix X 
	pha  ; 2en $61,Y 
	txa 
	pha 
	pha 
	jsr $CD5A ;  positionnement 
	inx  ; 2on est deja sur le choix 0 
	lda $69 ; on sauve l'adresse de la table des choix 
	ldy $6A ; 
	sta $15 ; car on lit sur une autre banque 
	sty $16 ; 
	ldy #$00 ; on indexe le premier caractere 
	dex  ; 2on est sur le bon choix ? 
	beq $CD20 ; oui 
	iny  ; 2non, on indexe le code suivant 
	bne $CD14 ; 
	inc $16 ; sur 16 bits 
	jsr $0411 ;  et on lit le caractere suivant 
	bne $CD0F ; 0 ? 
	iny  ; 2oui, on a passe un choix 
	bne $CD0C ; 
	inc $16 ; 
	bne $CD0C ; inconditionnel 
	ldx $16 ; 
	clc 
	tya 
	adc $15 ; 
	bcc $CD29 ; 
	inx 
	sta $02 ; on met l'adresse du choix 
	stx $03 ; dans $02-03 
	lda #$20 ; et un espace comme valeur par defaut en aff. dec. 
	sta $14 ; 
	pla  ; 2on sort le numero du choix 
	clc 
	adc #$01 ; +1 car le premier est 0 
	ldy #$00 ; AY=A 
	ldx #$01 ; pour 3 codes a afficher 
	jsr $CE39 ;  et on affiche le numero du choix en decimal 
	lda #$20 ; puis un espace 
	jsr $C75D ;  
	lda $02 ; puis le choix lui-meme 
	ldy $03 ; 
	jsr $C7A8 ;  par XWSTRO 
	ldy #$01 ; 
	jsr $0411 ;  on lit le code suivant le choix 
	sec  ; 2si 0, C=1 
	beq $CD51 ; 
	clc  ; 2sinon C=0 
	ror $68 ; et on ajuste MENFLG 
	pla  ; 2on restaure les registres 
	tax 
	pla 
	tay 
	bit $68 ; et N=1 si dernier choix 
	rts 
	lda #$1F ; 
	jsr $C75D ;  on envoie US 
	tya  ; 2Y est inferieur a 64 
	ora #$40 ; donc on force le bit 6 a 1 pour ajouter 64 
	jsr $C75D ;  Y+64 
	lda $61 ; 
	ora #$40 ; 
	jmp $C75D ;  $61+64 
	pha  ; 2on sauve les registres 
	txa 
	pha 
	tya 
	pha 
	sec 
	lda $06 ; on calcule le nombre d'octets a decaler 
	sbc $04 ; dans YX 
	tay 
	lda $07 ; 
	sbc $05 ; 
	tax 
	bcc $CDB9 ; si debut>fin, on sort 
	stx $0B ; nombre de pages a decaler dans $06 
	lda $08 ; on compare la cible 
	cmp $04 ; a l'adresse de debut 
	lda $09 ; 
	sbc $05 ; 
	bcs $CDBF ; cible>=debut, on decale de bas en haut 
	tya  ; 2decalage de haut en bas 
	eor #$FF ; on complemente le nombre d'octets hors pages 
	adc #$01 ; a 2 car on change de sens 
	tay 
	sta $0A ; 
	bcc $CD97 ; 
	dex  ; 2au besoin, on enleve une page 
	inc $07 ; 
	sec 
	lda $08 ; on enleve le nombre d'octets hors-pages 
	sbc $0A ; a l'adresse cible 
	sta $08 ; 
	bcs $CDA2 ; 
	dec $09 ; 
	clc 
	lda $07 ; et le nombre de pages +1 
	sbc $0B ; a l'adresse de fin 
	sta $07 ; 
	inx 
	lda ($06),Y ; on decale les octets hors pages d'abord 
	sta ($08),Y ; puis les pages completes ensuite 
	iny 
	bne $CDAA ; 
	inc $07 ; puisqu'on deplace des pages, on ajuste 
	inc $09 ; uniquement les poids fort des adresses 
	dex 
	bne $CDAA ; 
	sec  ; 2C=1 si le decalage s'est effectue 
	pla  ; 2C=0 sinon 
	tay  ; 2on restaure les registres et on sort 
	pla 
	tax 
	pla 
	rts 
	txa  ; 2decalage vers le haut 
	clc 
	adc $05 ; on ajoute le nombre de pages a l'adresse 
	sta $05 ; de debut du bloc 
	txa 
	clc 
	adc $09 ; et a l'adresse cible 
	sta $09 ; 
	inx  ; 2et on decale comme precedemment 
	dey 
	lda ($04),Y ; 
	sta ($08),Y ; 
	tya 
	bne $CDCC ; 
	dec $05 ; 
	dec $09 ; 
	dex 
	bne $CDCC ; 
	beq $CDB8 ; inconditionnel 
	ldx #$00 ; on indique 2 chiffres 
	ldy #$00 ; AY=A 
	ldx #$03 ; on indique 5 chiffres 
	ldx #$02 ; on indique 4 chiffres 
	sta $0D ; on sauve le nombre 
	sty $0E ; 
	lda #$00 ; et on met 0 dans l'index d'ecriture 
	sta $0F ; et l'indicateur de 0 en debut de nombre 
	sta $10 ; 
	lda #$FF ; et 255 dans $0C 
	sta $0C ; 
	inc $0C ; pour calculer le chiffre courant 
	sec 
	lda $0D ; on enleve la puissance de dix courante 
	tay 
	sbc $CDDD,X ;  au poids faible 
	sta $0D ; 
	lda $0E ; 
	pha 
	sbc $CDE1,X ;  puis au poids fort 
	sta $0E ; 
	pla 
	bcs $CDFD ; jusqu'a ce qu'on deborde 
	sty $0D ; on reprend le nombre d'avant qu'il 
	sta $0E ; deborde 
	lda $0C ; le chiffre est 0 ? 
	beq $CE1F ; oui 
	sta $0F ; non, on le stocke 
	bne $CE26 ; inconditionnel 
	ldy $0F ; 0 en debut de nombre ? 
	bne $CE26 ; non 
	lda $14 ; oui, on prend le caractere par defaut 
	ora #$30 ; on ajoute "0" 
	jsr $CE32 ;  et on le stocke dans le buffer 
	dex  ; 2pour tous les chiffres sauf les unites 
	bpl $CDF9 ; 
	lda $0D ; puis les unites 
	ora #$30 ; +"0" (un nombre nul affiche 0) 
	ldy $10 ; on prend l'index 
	sta ($11),Y ; et on stocke le chiffre 
	inc $10 ; puis on augmente l'index 
	rts 
	pha 
	lda #$00 ; on sauve BUFTRV ($100) 
	sta $11 ; 
	lda #$01 ; 
	sta $12 ; dans $11-12 
	pla 
	jsr $CDEF ;  on convertit 
	ldy #$00 ; 
	lda $0100,Y ;  
	jsr $C75D ;  et on affiche 
	iny 
	cpy $10 ; 
	bne $CE48 ; 
	rts 
	pha  ; 2on sauve le nombre 
	and #$0F ; on isole le quartet de droite 
	jsr $CE60 ;  on les convertit en chiffre hexa 
	tay  ; 2dans Y 
	pla 
	lsr  ; 2puis on isole le quartet de gauche 
	lsr 
	lsr 
	lsr  ; 2que l'on convertit a son tour 
	ora #$30 ; on ajoute "0" 
	cmp #$3A ; superieur a 9 ? 
	bcc $CE68 ; non 
	adc #$06 ; oui, on en fait une lettre 
	rts 
	ldy #$00 ; AY=A 
	sta $00 ; dans RES 
	sty $01 ; 
	asl 
Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 69
 ; 2*2 
	rol $01 ; 
	asl 
Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 69
 ; 2*4 
	rol $01 ; 
	adc $00 ; *5 
	bcc $CE7B ; 
	inc $01 ; 
	asl 
Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 69
 ; 2*10 
	rol $01 ; 
	asl 
Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 69
 ; 2*20 
	rol $01 ; 
	asl 
Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 69
 ; 2*40 
	rol $01 ; 
	sta $00 ; dans RES et AY 
	ldy $01 ; 
	rts 
	clc 
	adc $00 ; poids faible de RES 
	sta $00 ; + poids faible de AY 
	pha  ; 2sauve 
	tya 
	adc $01 ; poids fort de RES 
	sta $01 ; + poids fort de AY 
	tay  ; 2sauve 
	pla 
	rts 
	sta $10 ; multiplicateur dans TR5-6 
	sty $11 ; 
	ldx #$00 ; 0 dans : le resultat 
	stx $0C ; - 
	stx $0D ; - 
	stx $0E ; - 
	stx $0F ; - 
	stx $02 ; et dans l'extension du multiplicande 
	stx $03 ; 
	ldx #$10 ; pour 16 decalages (inutile ! voir plus loin) 
	lsr $11 ; on isole le bit 16-X du multiplicateur 
	ror $10 ; 
	bcc $CECA ; 0 
	clc  ; 21 on additionne le multiplicande au resultat 
	lda $00 ; octet 0 
	adc $0C ; 
	sta $0C ; 
	lda $01 ; octet 1 
	adc $0D ; 
	sta $0D ; 
	lda $02 ; octet 2 
	adc $0E ; 
	sta $0E ; 
	lda $03 ; octet 3 
	adc $0F ; 
	sta $0F ; 
	asl $00 ; on multiplie le multiplicande par 2 
	rol $01 ; 
	rol $02 ; 
	rol $03 ; 
	lda $10 ; le multiplicateur est nul ? 
	ora $11 ; 
	beq $CEDB ; oui, on sort 
	dex  ; 2inutile ! apres 16 glissements, le multiplicateur 
	bne $CEAB ; est toujours nulÅc BNE suffit 
	rts  ; 2Z=1 en sortie 
	sta $0C ; diviseur dans TR0-1 
	sty $0D ; 
	ldx #$00 ; reste est 0 
	stx $02 ; 
	stx $03 ; 
	ldx #$10 ; pour 16 decalages du diviseur 
	asl $00 ; on decale le dividende 
	rol $01 ; avec report dans le reste partiel 
	rol $02 ; 
	rol $03 ; 
	sec 
	lda $02 ; on soustrait le diviseur 
	sbc $0C ; au reste dans YA 
	tay 
	lda $03 ; 
	sbc $0D ; diviseur > reste ? 
	bcc $CF02 ; oui, on saute 
	sty $02 ; non, on sauve le reste partiel 
	sta $03 ; 
	inc $00 ; et on ajoute 1 au dividende 
	dex 
	bne $CEE8 ; 
	rts 
	lda #$00 ; RES=$A000, debut de l'ecran HIRES 
	ldy #$A0 ; 
	sta $00 ; 
	sty $01 ; 
	ldy #$68 ; YX=$BF68, fin de l'ecran 
	ldx #$BF ; 
	lda #$40 ; on remplit avec %01000000, soit pixels eteints 
	pha  ; 2on sauve le code 
	sec 
	tya 
	sbc $00 ; on calcule dans YX 
	tay  ; 2la taille de la zone a remplit 
	txa 
	sbc $01 ; (YX-RES) 
	tax 
	sty $02 ; et si RES est superieur a YX ?!?! 
	pla  ; 2on sort le code de remplissage 
	ldy #$00 ; premier octet hors page 
	cpy $02 ; on a fini la zone hors-page ? 
	bcs $CF2C ; oui 
	sta ($00),Y ; non, on remplit la zone hors-page 
	iny 
	bne $CF23 ; 
	pha  ; 2on sauve la donnee 
	tya  ; 2AY=Y 
	ldy #$00 ; 
	jsr $CE89 ;  on augment l'adresse de debut de Y (deja remplie) 
	pla  ; 2on prend la donnee 
	cpx #$00 ; y a-t-il des pages a remplir ? 
	beq $CF44 ; non 
	ldy #$00 ; oui, on remplit une page 
	sta ($00),Y ; 
	iny 
	bne $CF3A ; 
	inc $01 ; et toutes les autres 
	dex 
	bne $CF3A ; 
	rts  ; 2Z=1 en sortie 
	ldx #$00 ; 
	ldy #$FF ; 
	sty $02AA ;  pattern = %11111111, ligne pleine 
	iny  ; 2Y=0 X=0 
	jsr $E7F3 ;  on initialise les donnees HRS 
	lda $020D ;  est-on en HIRES ? 
	bmi $CF06 ; oui, on efface simplement 
	ora #$80 ; non, on force mode HIRES 
	sta $020D ;  
	php  ; 2on inhibe les interruptions 
	sei 
	lda #$1F ; place attribute HIRES 
	sta $BF67 ;  
	jsr $CFA4 ;  on attend 1/3 de seconde 
	jsr $FED8 ;  on deplace la table des caracteres 
	lda #$5C ; fenetre TEXT en HIRES 
	ldy #$02 ; 
	ldx #$00 ; fenetre 0 
	jsr $DEFD ;  on initialise la fenetre TEXT 
	jsr $CF06 ;  on efface l'ecran HIRES 
	plp  ; 2pourquoi pas PLP/JMP $CF06 ??? 
	rts 
	lda $020D ;  est-on deja en TEXT ? 
	bpl $CFA3 ; BPL $CF74 aurait ete mieux 
	php  ; 2on inhibe les IRQ 
	sei 
	and #$7F ; on indique mode TEXT 
	sta $020D ;  dans FLGTEL 
	jsr $FEDB ;  on replace la table des caracteres 
	lda #$56 ; 
	ldy #$02 ; 
	ldx #$00 ; 
	jsr $DEFD ;  on initialise la fenetre 0 (tout l'ecran) 
	lda #$1A ; on pose un attribut TEXT 
	sta $BFDF ;  a la fin de l'ecran 
	jsr $CFA4 ;  on attend 1/3 de seconde 
	ldx #$28 ; on efface l'ecran 
	lda #$20 ; 
	sta $BB7F,X ;  
	dex 
	bne $CF99 ; 
	jsr $DE20 ;  on affiche le curseur 
	plp  ; 2PLP/JMP aurait ete mieux 
	rts 
	ldy #$1F ; on boucle 8192 fois 
	ldx #$00 ; avec un temps moyen de 4 É s par boucle 
	dex  ; 2ce qui fait pres de 32000 É s 
	bne $CFA8 ; donc 1/3 de second 
	dey 
	bne $CFA8 ; 
	rts 
	sec  ; 2C=1 
	clc  ; 2ou C=0 
	ror $15 ; dans b7 ($15) (?) 
	ldx #$00 ; 
	jsr $C50F ;  on teste si le buffer X est vide 
	bcc $CFC3 ; non, on sort avec C=0 
	txa 
	adc #$0B ; on passe au buffer suivant (C=1 donc +11) 
	tax 
	cpx #$30 ; a-t-on fait les 4 buffers ? 
	bne $CFB6 ; non, on boucle 
	php  ; 2on sauve C 
	lda #$DC ; on indexe prompt plein 
	ldy #$CF ; si tous les buffers sont vides 
	bcs $CFCE ; 
	lda #$E6 ; ou prompt vide sinon 
	ldy #$CF ; 
	bit $15 ; ??? 
	bpl $CFD7 ; 
	jsr $FEF9 ;  on redefinit le prompt 
	plp  ; 2et on sort 
	rts 
	jsr $FEF9 ;  id, (quel interet ?) 
	plp 
	rts 
	sta $15 ; on sauve l'adresse du nom dans $15-16 
	sty $16 ; pour permettre la lecture inter-banques 
	stx $00 ; longueur dans $0 
	inc $00 ; +1 pour tests 
	ldy $020C ;  on prend le drive courant 
	sty $0517 ;  dans BUFNOM 
	sty $0500 ;  et DRIVE 
	ldy #$0C ; on place 12 jokers ("?") dans BUFNOM 
	lda #$3F ; pour nom="?????????.???" 
	sta $0517,Y ;  
	dey 
	bne $D005 ; 
	txa  ; 2longueur nulle ? 
	beq $D049 ; oui on sort 
	cpx #$01 ; longueur = 1 ? 
	bne $D034 ; non, on passe 
	jsr $D0DF ;  oui, on lit le caractere 
	sec 
	sbc #$41 ; on lui enleve "A" 
	cmp #$04 ; superieure a 3 ? 
	bcs $D05C ; oui, ce n'est pas un drive 
	sta $0517 ;  non, on place le drive demande 
	sta $0500 ;  dans BUFNOM et DRIVE 
	ldx #$01 ; y a-t-il encore des jokers ? 
	ldy #$0C ; 
	lda #$3F ; 
	cmp $0517,Y ;  
	beq $D032 ; oui, on sort avec C=1 
	dey 
	bne $D028 ; 
	clc  ; 2non, on sort avec C=0 
	rts 
	sec 
	rts 
	ldy #$01 ; on lit le premier caractere 
	jsr $D0DF ;  
	cmp #$2D ; est-ce un trait "-" ? 
	bne $D05C ; non, ok on lit le nom 
	ldy #$00 ; oui, on prend le numero du drive 
	jsr $D0DF ;  
	sec 
	sbc #$41 ; on enleve "A" 
	bcs $D04A ; si < 0 
	ldx #$81 ; on indique drive invalide 
	rts 
	cmp #$04 ; 
	bcs $D047 ; (ou superieur a 4) 
	cpx #$02 ; sinon, X=2 (juste drive + "-") 
	bne $D056 ; non, on lit la suite du nom 
	sta $020C ;  oui, on change le drive par defaut 
	rts 
	sta $0517 ;  on met le drive dans BUFNOM 
	ldy #$02 ; et on lit la suite du nom 
	ldy #$00 ; pas de drive dans le nom, on lit tout le nom 
	ldx #$00 ; 
	jsr $D0DF ;  on lit le caractere suivant 
	bcs $D082 ; fin du nom ? oui 
	cmp #$2E ; on a un point ? 
	beq $D082 ; oui 
	cmp #$2A ; non, une etoile ? 
	beq $D08F ; oui 
	jsr $D0FB ;  non, un caractere valide ? 
	bcc $D078 ; oui 
	ldx #$80 ; non, on sort avec X=128 
	rts 
	ldx #$82 ; 
	rts 
	cpx #$09 ; X=9 ? 
	beq $D075 ; oui, on sort avec 130 
	sta $0518,X ;  non, on place le caractere dans BUFNOM 
	inx 
	bne $D060 ; et on boucle 
	lda #$20 ; on complete la fin du nom avec des espaces 
	cpx #$09 ; non, fini ? 
	beq $D08E ; oui 
	sta $0518,X ;  non, on complete 
	inx 
	bne $D084 ; 
	dey  ; 2on lit le caractere suivant 
	ldx #$00 ; 
	jsr $D0DF ;  
	bcc $D0A4 ; on a fini ? non, on saute 
	ldy #$02 ; oui, on met l'extension par defaut 
	lda $055D,Y ;  (on devrait la passer en majuscules avantÅc) 
	sta $0521,Y ;  
	dey 
	bpl $D098 ; 
	jmp $D022 ;  et on termine 
	cmp #$2E ; a-t-on "." ? 
	bne $D072 ; pas de ".", nom de fichier invalide 
	jsr $D0DF ;  caractere suivant 
	bcs $D08E ; il n'y en a pas, on met l'extension par defaut 
	dey 
	jsr $D0DF ;  on lit le code 
	bcc $D0C1 ; on l'interprete 
	lda #$20 ; il n'y en a plus, 
	cpx #$03 ; on complete l'extension avec des espaces 
	beq $D0A1 ; 
	sta $0521,X ;  
	inx 
	bne $D0B5 ; 
	beq $D0A1 ; et on sort 
	cmp #$2A ; est-ce "*" 
	bne $D0CD ; non, on passe 
	jsr $D0DF ;  oui, elle est seule ? 
	bcs $D0A1 ; oui, on termine 
	ldx #$83 ; non, trop de jokers 
	rts 
	jsr $D0FB ;  caractere valide ? 
	bcs $D072 ; non, nom invalide et on sort 
	cpx #$03 ; oui, fin de l'extension ? 
	beq $D0DC ; oui, extension invalide et on sort 
	sta $0521,X ;  non, on stocke le caractere 
	inx 
	bne $D0AE ; et on poursuit 
	ldx #$84 ; 
	rts 
	jsr $0411 ;  on lit le caractere courant 
	jsr $D0F0 ;  en majuscules 
	iny 
	cpy $00 ; est-ce le dernier ? 
	bcs $D0EF ; oui, C=1 non, C=0 
	cmp #$20 ; est-ce un espace ? 
	beq $D0DF ; oui, on lit le suivant 
	clc 
	rts 
	cmp #$61 ; entre "a" 
	bcc $D0FA ; 
	cmp #$7B ; et "z" 
	bcs $D0FA ; 
	sbc #$1F ; oui, on retire 32 (31+(1-C) avec C=0) 
	rts 
	cmp #$3F ; est-ce "?" 
	beq $D10D ; oui, ok 
	cmp #$30 ; entre 0 
	bcc $D10F ; 
	cmp #$3A ; et 9 ? 
	bcc $D10D ; oui, ok 
	cmp #$41 ; superieur a "A" ? 
	bcc $D10F ; 
	cmp #$5B ; ridicule ! on met C a 0 de toutes facons !!! 
	clc  ; 2C=0, caractere OK 
	rts 
	sec  ; 2C=1, caractere invalide 
	rts 
	ldy #$00 ; AY=$9000 
	lda #$90 ; 
	sty $00 ; dans RES 
	sta $01 ; 
	ldx #$94 ; YX=$9400 
	lda #$00 ; A=0 
	jsr $CF14 ;  on remplit de $9000 a $9400 de 0 
	ldy #$00 ; 
	lda #$94 ; 
	sty $00 ; 
	sta $01 ; 
	ldx #$98 ; 
	lda #$87 ; 
	jsr $CF14 ;  on remplit de $9400 a $9800 de %10000111 
	ldy #$00 ; 
	lda #$A0 ; 
	sty $00 ; 
	sta $01 ; 
	ldy #$3F ; 
	ldx #$BF ; 
	lda #$10 ; 
	jmp $CF14 ;  on remplit de $A000 a $BF3F de %0001000 
	lda $39 ; prend VDTY, ordonnee du curseur VDT 
	jsr $CE69 ;  calcul VDT*40 
	pha  ; 2dans AY et RES 
	tya 
	pha 
	lda #$00 ; ajoute l'adresse de la table ASCII 
	ldy #$90 ; 
	jsr $CE89 ;  
	sta $2E ; dans ADASC (table ASCII VDT) 
	sty $2F ; 
	sta $30 ; ajoute 4 pages ($400) 
	iny 
	iny 
	iny 
	iny 
	sty $31 ; et stocke ADATR (table des couleurs) 
	pla  ; 2on sort poids fort de VDTY*40 
	sta $01 ; dans $01 
	pla  ; 2et poids faible dans A 
	asl  ; 2on multiplie par 8 
	rol $01 ; car chaque caractere fait 8 lignes 
	asl 
	rol $01 ; 
	asl 
	rol $01 ; 
	sta $00 ; dans RES 
	lda #$00 ; on ajoute l'adresse de l'ecran HIRES 
	ldy #$A0 ; 
	jsr $CE89 ;  
	sta $2C ; dans ADVDT (adresse du point courant en HIRES) 
	sty $2D ; 
	jmp $D756 ;  et on gere le curseur VDT 
	sta $3E ; on sauve la donnee 
	tya  ; 2et les registres 
	pha 
	txa 
	pha 
	lda $39 ; VDTY=0 ? 
	beq $D18A ; oui 
	sta $0281 ;  non, on sauve VDTX et VDTY 
	lda $38 ; dans $280 et $281 
	sta $0280 ;  
	bit $3C ; sequence en cour ? 
	bmi $D1ED ; oui, on passe 
	lda $3E ; on prend la donnee 
	jsr $D442 ;  on la code 
	sta $00 ; et on la stocke 
	beq $D1E6 ; est-ce 0 ? oui, on debute une sequence 
	cmp #$20 ; non, est-ce un code de controle ? 
	bcc $D1F3 ; oui, on le gere 
	cmp #$A0 ; est-ce un caractere OK ? 
	bcs $D1E1 ; oui, on le sauve 
	sta $0285 ;  
	and #$7F ; b7 a 0 
	tax  ; 2dans X 
	lda $34 ; on prend VDTATR 
	bmi $D1BB ; mode mosaique (G1) ? oui 
	ldy $38 ; VDTX=39 
	cpy #$27 ; 
	bne $D1B1 ; non 
	and #$DF ; oui, on interdit la double largeur 
	ldy $39 ; VDTY <2 
	cpy #$02 ; 
	bcs $D1BB ; non, VDTY>1 
	and #$EF ; oui, on interdit la double hauteur 
	sta $34 ; on sauve VDTATR 
	pha  ; 2on sauve encore VDTATR 
	jsr $D530 ;  on place le code dans les tables VDT 
	jsr $D5DC ;  on affiche le code a l'ecran 
	pla  ; 2on lit VDTATR 
	pha 
	bmi $D1D0 ; mode G1 ? oui 
	and #$20 ; mode double largeur ? 
	beq $D1D0 ; non 
	jsr $D391 ;  oui, on deplace le curseur a droite deux fois 
	jsr $D759 ;  on eteint le curseur 
	jsr $D391 ;  on deplace le curseur a droite 
	pla  ; 2on sort VDTATR 
	bmi $D1E1 ; mode G1 ? oui 
	ldx $38 ; non, VDTX=0 ? 
	bne $D1E1 ; non 
	and #$10 ; oui, double hauteur ? 
	beq $D1E1 ; non 
	jsr $D3A0 ;  oui, on saute une ligne 
	lda $0285 ;  en sortie $00 contient la donnee codee 
	sta $00 ; (pour recursivite) 
	pla  ; 2une chance que les sequences on au plus 3 
	tax  ; 2caracteres, sans quoi la pile deborderait vite 
	pla 
Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 69
 ; 2(4 appels recursifs empilent 8 valeurs pour les 
	tay  ; 2registres et 8 pour les adresses, soit 16Åc) 
	lda $00 ; 
	rts 
	jsr $D22E ;  on traite la sequence 
	jmp $D1E6 ;  et on sort 
	jsr $D1F9 ;  on traite le code 
	jmp $D1E6 ;  et on sort 
	.  ;  
	tax  ; 2code dans X 
	clc 
	lda $D20B,X ;  on lit l'octet correspondant 
	adc #$7E ; on ajoute le poids faible de $D37E 
	sta $00 ; on sauve 
	lda #$D3 ; et le poids fort de $D37E 
	adc #$00 ; que l'on sauve aussi 
	sta $01 ; 
	jmp  ;  et on execute la routine de gestion du code 
	jmp $D2B7 ;  saut a la gestion de sequence ESC 
	lda $3C ; on isole le nombre de caractere (-1) 
	and #$03 ; 
	sta $36 ; dans $36 
	lda $3C ; on prend la sequence 
	asl  ; 2est-ce ESC ? 
	bmi $D22B ; oui 
	asl  ; 2non 
	asl  ; 2US ? 
	bmi $D24E ; oui 
	lda $3E ; non, c'est REP, on lit le code actuel a envoyer 
	and #$3F ; on elimine b7b6 (entre 0 et 63) 
	tax  ; 2dans X 
	lsr $3C ; on indique fin de sequence 
	lda $0285 ;  et on repete l'envoi du 
	jsr $D178 ;  caractere 
	dex  ; 2X fois 
	bne $D244 ; 
	rts 
	lda $36 ; sequence US 
	beq $D26F ; fin de sequence ? oui 
	lda $3E ; non, on lit la donnee 
	cmp #$30 ; entre "0" et "0"+39 (?) ? 
	bcc $D26A ; 
	cmp #$59 ; 
	bcs $D26A ; non, incorrect 
	sta $0282 ;  on stocke l'ordonnee dans VDTPIL 
	dec $3C ; on indique un code de moins en sequence 
	lda #$07 ; encre blanche 
	sta $34 ; 
	lda #$00 ; fond noir 
	sta $32 ; 
	rts 
	lsr $3C ; on indique fin de sequence 
	jmp $D178 ;  et on envoie simplement la donnee 
	lsr $3C ; fin de sequence US 
	lda $3E ; on lit le code 
	cmp #$30 ; entre "0" et "0"+56 (?) 
	bcc $D26A ; 
	cmp #$69 ; 
	bcs $D26A ; non 
	and #$3F ; oui, on isole b3b2b1b0 
	sta $0283 ;  dans VDTPIL+1 
	lda $3E ; la donnee est-elle > "A" 
	cmp #$40 ; 
	bcs $D2A3 ; oui 
	lda $0282 ;  non, on prend l'ordonnee 
	and #$03 ; que l'on triture 
	asl  ; 2pour ramener de "0" a "0"+39 
	asl  ; 2a 0 . . 25 
	adc $0282 ;  
	sbc #$2F ; 
	asl 
	adc $0283 ;  
	sbc #$2F ; 
	sta $39 ; dans VDTY 
	jsr $D3D7 ;  on ramene le curseur en debut de ligne 
	jsr $D759 ;  on eteint le curseur 
	jmp $D140 ;  on ajuste les tables et affiche le curseur 
	jsr $D759 ;  on eteint le curseur 
	lda $0283 ;  on prend l'abscisse 
	sta $38 ; dans VDTX 
	dec $38 ; 
	lda $0282 ;  l'ordonnee 
	and #$3F ; dans VDTY 
	sta $39 ; 
	jmp $D140 ;  on ajuste les tables et on affiche le curseur 
	.  ;  
	ldx $36 ; on lit le nombre de caractere a traiter 
	lda $3E ; on lit la donnee 
	cpx #$03 ; 4 caracteres a traiter ? 
	bne $D2E1 ; non 
	sta $0282 ;  on sauve le code (PROx ou 3/6) 
	ldx #$00 ; on met 0 
	stx $35 ; dans VDTFT (pas SEP ni SS2) 
	cmp #$36 ; est-ce 3/6 ? 
	beq $D2D7 ; oui 
	cmp #$39 ; est-ce entre PRO1 (3/9) 
	bcc $D2F0 ; 
	cmp #$3C ; et PRO3 (3/B)? 
	bcs $D2F0 ; non, on passe 
	and #$03 ; on isole le PRO 
	sbc #$00 ; -1 (donc 0,1,2 pour PRO1,2,3) 
	lda $00 ; on force PRO1 
	ora #$C0 ; et on indique 
	sta $3C ; 
	rts 
	lsr $3C ; fin de sequence sans action 
	rts 
	inc $35 ; on indexe le parametre suivant 
	ldx $35 ; 
	sta $0281,X ;  et on le stocke dans la PILE VDT 
	dec $3C ; on indique un code de moins 
	dec $36 ; 
	bpl $D2DD ; on sort simplement s'il en reste 
	bmi $D2DE ; on sort avec fin de sequence si c'etait le dernier 
	cmp #$40 ; est-ce un attribut C1 ? 
	bcc $D2DD ; non, on sort 
	lsr $3C ; oui, on indique fin de sequence 
	cmp #$48 ; est-ce un code couleur texte ? 
	bcs $D307 ; non 
	and #$07 ; oui, on isole la couleur 
	sta $36 ; 
	lda $34 ; 
	and #$F8 ; 
	ora $36 ; 
	sta $34 ; dans VDTATR 
	rts 
	cmp #$4A ; est-ce un code clignotement ? 
	bcs $D317 ; non 
	lsr  ; 2oui, C=1 si fixe, 0 si clignotement 
	lda $34 ; 
	and #$F7 ; 
	bcs $D314 ; 
	ora #$08 ; 
	sta $34 ; dans VDTATR 
	rts 
	cmp #$4C ; est-ce rien ? 
	bcc $D34A ; oui . . . on sort 
	cmp #$50 ; est-ce un attribut taille ? 
	bcs $D330 ; non 
	and #$03 ; oui 
	asl 
	asl 
	asl 
	asl 
	sta $36 ; 
	lda $34 ; 
	and #$CF ; 
	ora $36 ; on indique lequel dans 
	sta $34 ; VDTATR 
	rts 
	cmp #$58 ; est-ce un attribut fond ? 
	bcs $D34B ; non 
	and #$07 ; oui, on isole la couleur 
	asl 
	asl 
	asl 
	asl 
	sta $36 ; 
	lda $32 ; 
	and #$84 ; 
	ora $36 ; dans A 
	bit $34 ; est-ce en G1 
	bmi $D348 ; oui, on passe 
	ora #$80 ; non, on indique attribut a valider 
	sta $32 ; et on stocke la couleur de fond 
	rts 
	bne $D34D ; (aie ! aie ! aie ! voila qui est louche !) 
	cmp #$5B ; est-ce le lignage ? 
	bcs $D36C ; non 
	lsr  ; 2C=0 si lignage, 1 si fin de lignage 
	bit $34 ; est on en G1 
	bpl $D35F ; non 
	lda #$00 ; oui, ca devient video normale 
	bcc $D35C ; 
	lda #$40 ; et video inverse 
	sta $33 ; 
	rts 
	lda $32 ; pas G1 
	and #$70 ; 
	bcs $D367 ; on indique lignage ou non 
	ora #$04 ; 
	ora #$80 ; et attribut a valider 
	sta $32 ; dans VDTPAR 
	rts 
	beq $D36B ; on ne gere pas l'echappement ISO 6429 
	cmp #$5E ; est-ce l'inversion video 
	bcs $D37E ; non 
	lsr  ; 2C=1 si inverse, 0 si normal 
	lda $34 ; 
	and #$BF ; 
	bcc $D37B ; 
	ora #$40 ; 
	sta $34 ; on indique dans VDTATR 
	rts 
	rts  ; 2holala !!! quelle horreur ! 
	jmp $DDD8 ;  envoie un OUPS 
	h  ;  
	jsr $D759 ;  eteint le curseur 
	lda $38 ; on est en colonne 0 ? 
	beq $D3BE ; oui 
	dec $38 ; non, on deplace vers la gauche 
	jmp $D756 ;  et on affiche le curseur 
	i  ;  
	jsr $D759 ;  on eteint le curseur 
	inc $38 ; on deplace a droite 
	lda $38 ; 
	cmp #$28 ; on est en colonne 40 ? 
	bcc $D38B ; non 
	lda $39 ; oui, on est sur la ligne d'etat ? 
	beq $D389 ; oui 
	jsr $D3D7 ;  non, on descend d'une ligne 
	j  ;  
	jsr $D759 ;  on eteint le curseur 
	ldx $39 ; est on en ligne 0 ? 
	beq $D3B3 ; oui, on reste ou on est 
	cpx #$18 ; non, en derniere ligne ? 
	bne $D3AD ; non 
	ldx #$00 ; oui, on passe en ligne 1 
	inx 
	stx $39 ; dans VDTY 
	jmp $D140 ;  on ajuste tables et curseur 
	lda $0280 ;  on est sur la ligne d'etat 
	ldx $0281 ;  
	sta $38 ; 
	jmp $D3AE ;  et on y reste 
	lda #$27 ; on indique colonne 39 
	sta $38 ; et on remonte 
	k  ;  
	jsr $D759 ;  on eteint le curseur 
	ldx $39 ; on deplace vers le haut 
	dex  ; 2on est en 0 ? 
	bne $D3CC ; non 
	ldx #$18 ; oui, on passe en ligne 24 
	stx $39 ; dans VDTY 
	jmp $D140 ;  on ajuste tables et curseur 
	l  ;  
	jsr $D111 ;  on initialise l'ecran VIDEOTEX 
	jmp $D425 ;  et on met le curseur en 0,0 
	m  ;  
	jsr $D759 ;  on eteint le curseur 
	lda #$00 ; on ramene le curseur en debut de ligne 
	sta $38 ; et on remet le curseur 
	jmp $D756 ;  
	n  ;  
	lda #$40 ; on indique G1 joint 
	sta $33 ; dans VDTASC 
	lda $32 ; 
	and #$74 ; %01110100 
	sta $32 ; et pas d'attribut G1 dans VDTPAR 
	lda $34 ; on force G1 
	and #$0F ; 
	ora #$80 ; 
	sta $34 ; dans VDTATR 
	rts 
	o  ;  
	lda $34 ; on force G1 a 0 et pas d'attributs 
	and #$0F ; (passage en G0) 
	sta $34 ; dans VDTATR 
	rts 
	q  ;  
	jmp $D74F ;  on allume le curseur 
	t  ;  
	jmp $D74D ;  on eteint le curseur 
	x  ;  
	lda $38 ; on sauve VDTX et VDTY 
	pha 
	lda $39 ; 
	pha 
	lda #$20 ; on envoie un espace 
	jsr $D178 ;  
	lda $38 ; on a fini la ligne ? 
	beq $D419 ; oui 
	cmp #$27 ; inutile ! on perd des octets betement . . . 
	bne $D407 ; BNE suffit amplement 
	lda #$20 ; 
	jsr $D178 ;  
	jsr $D759 ;  on eteint le curseur 
	pla  ; 2on restaure VDTX et VDTY 
	sta $39 ; 
	pla 
	sta $38 ; 
	jmp $D140 ;  et on ajuste tables et curseur 
	jsr $D3D7 ;  curseur en debut de ligne 
	jsr $D261 ;  pas d'attributs 
	jsr $D759 ;  curseur eteint 
	jmp $D3AB ;  VDTY=1 et on ajuste les tables 
	lda #$89 ; %10001001, sequence REP avec deux codes 
	lda #$84 ; %10000100, sequence SEP avec un code 
	lda #$A1 ; %10100001, sequence SYN avec deux codes 
	lda #$C3 ; %11000011, sequence ESC avec trios codes 
	lda #$91 ; %10010001, sequence US avec deux codes 
	sta $3C ; dans VDTFLG0 
	rts 
	ldy $37 ; on lit l'indicateur de sequence 
	bit $37 ; 
	php  ; 2on sauve P 
	ldx #$00 ; indique pas de sequence 
	stx $37 ; 
	plp 
	bmi $D46A ; N=1 (SS2) 
	bvs $D466 ; V=1 (SEP) 
	cmp #$13 ; est-ce un SEP 
	beq $D45F ; oui 
	cmp #$19 ; est-ce un SS2 
	beq $D45C ; oui 
	cmp #$16 ; ou un SYN 
	bne $D465 ; non 
	lda #$80 ; on indique SS2 ou SYN 
	lda #$40 ; on indique SEP 
	sta $37 ; dans $37 
	lda #$00 ; et A=0 (debut de sequence) 
	rts  ; 2code de sequence caractere invalide 
	clc  ; 2sequence SEP 
	adc #$5F ; on ajoute 95 au code dans A 
	rts 
	bvs $D48A ; V=1 et N=1 fin de sequence SS2 (accent) 
	ldx #$14 ; le code est-il dans la table SS2/SYN ? 
	cmp $D4A7,X ;  
	beq $D479 ; oui 
	dex 
	bpl $D46E ; 
	lda #$5F ; non, A=95 et on sort 
	rts 
	cpx #$05 ; est-ce un accent ? 
	bcs $D485 ; non, un caractere 
	txa  ; 2X contient le numero de l'accent 
	ora #$C0 ; on met b7 et b6 a 1 pour indiquer sequence 
	sta $37 ; SS2 deuxieme phase dans $37 
	lda #$00 ; A=0 (sequence en cours) 
	rts  ; 2et on sort 
	and #$1F ; on calcule son code 
	ora #$80 ; dans A 
	rts 
	pha  ; 2on sauve le caractere a accentuer 
	tya  ; 2on prend le numero de l'accent 
	and #$07 ; entre 0 et 7 (il n'y a que 5 accents) 
	tax  ; 2dans X 
	lda $D4C1,X ;  on lit le nombre de caracteres ayant cet accent 
	tay  ; 2dans Y 
	lda $D4BC,X ;  et la position de ces caracteres dans X 
	tax 
	pla  ; 2on prend le code a accentuer 
	cmp $D4C6,X ;  peut-il etre accentue ? 
	beq $D4A3 ; oui 
	inx 
	dey 
	bne $D498 ; 
	tax  ; 2non, A contient le code en sortie 
	rts 
	lda $D4DE,X ;  on lit le code du caractere ainsi accentue 
	rts  ; 2et on sort 

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30
	ldx #$00 ; X=0 
	cmp #$A0 ; la donnee est-elle un caractere ? 
	bcc $D4FC ; non 
	sbc #$5F ; on lui enleve 95 (#A0-ÅgAÅh=95) 
	ldy #$13 ; et Y=1/3 (SEP) 
	rts 
	tay  ; 2donnee dans Y 
	bmi $D503 ; si > 128, on passe 
	tay  ; 2non 
	lda #$00 ; A=0 
	rts  ; 2et on sort 
	ldy #$12 ; pour 18 testes 
	cmp $D4DE,Y ;  est-ce un caractere accentue ? 
	beq $D51D ; oui 
	dey 
	bpl $D505 ; non, on boucle 
	clc 
	adc #$A0 ; on ajoute 160 
	cmp #$2A ; est-ce Åg-Åg 
	beq $D518 ; oui 
	cmp #$3A ; est-ce Åg=Åh 
	bne $D51A ; non 
	ora #$40 ; on force b6 a 1 
	ldy #$19 ; Y=1/9 SS2 
	rts 
	tya  ; 2position de lÅfaccent dans A 
	ldx #$04 ; on calcule sa position dans la table des 
	cmp $D4BC,X ;  caracteres 
	bcs $D528 ; on a trouve 
	dex 
	bne $D520 ; 
	lda $D4D9,X ;  on lit lÅfaccent 
	ldx $D4C6,Y ;  et le caractere 
	bne $D51A ; inconditionnel, Y=SS2 et on sort 
	sta $36 ; on sauve VDTATR 
	asl $36 ; b5 dans b7 
	asl $36 ; mosaique (G1) ? 
	tay 
	bpl $D55F ; non 
	pha  ; 2on sauve VDTATR 
	txa  ; 2donnee dans A 
	cmp #$60 ; inferieure a ÅgaÅh-1 
	bcc $D541 ; oui 
	sbc #$20 ; non, on lui enleve 32 
	sec  ; 2on lui enleve 32 
	sbc #$20 ; 
	sta $36 ; dans $36 
	lda $33 ; on prend VDTASC 
	and #$40 ; on isole b6 (code ASCII ou type de mosaique) 
	ora $36 ; ajoute a la donnee 
	tax  ; 2dans X 
	lda $32 ; on lit VDTPAR 
	and #$70 ; %0111000, on isole la couleur de fond 
	sta $36 ; dans $36 
	pla  ; 2on prend VDTATR 
	and #$8F ; %10001111, on isole G1, video et couleur de texte 
	ora $36 ; A contient la donnee et ses attributs 
	ldy $38 ; VDTX 
	sty $36 ; dans $36 
	jmp $D5AF ;  pourquoi pas BPL ? on stocke dans les tables 
	cpx #$20 ; la donnee est un espace ? 
	bne $D58E ; non 
	bit $32 ; doit-on valider lÅfattribut ? 
	bpl $D58E ; non 
	and #$70 ; %01110000, on isole les attributs caractere 
	sta $35 ; dans VDTFT 
	lda $32 ; 
	and #$04 ; on isole le lignage 
	ora #$80 ; on force b7 a 1 
	ora $35 ; et les attributs dans A 
	tax  ; 2dans X 
	lda $32 ; on lit VDTPAR 
	and #$74 ; %01110100, on isole couleur de fond et lignage 
	sta $32 ; dans VDTPAR 
	and #$70 ; on isole couleur de fond dans VDTFT 
	sta $35 ; 
	lsr  ; 2on met la couleur dans b2b1b0 
	lsr 
	lsr 
	lsr 
	bit $34 ; video inverse ? 
	bvc $D58A ; non 
	lda $34 ; oui, on prend la couleur de texte 
	and #$07 ; comme couleur de fond 
	ora $35 ; on ajoute lÅfattribut 
	ora #$80 ; et b7 a 1 (attribut a valider) 
	bit $36 ; double hauteur ? 
	bvc $D5A5 ; non 
	dec $2F ; oui, on enleve une page 
	dec $31 ; aux tables ASCII et ATTRIBUT 
	pha  ; 2on sauve la donnee 
	sec 
	lda $38 ; on enleve 40 a VDTX 
	sbc #$28 ; 
	tay  ; 2dans Y 
	pla  ; 2on prend la donnee 
	jsr $D5A7 ;  on envoie le code une ligne plus haut donc 
	inc $2F ; puis on ajoute une page de nouveau 
	inc $31 ; et on envoie le code sur la ligne courante 
	ldy $38 ; on prend VDTX dans Y 
	jsr $D5AF ;  on envoie le code 
	bit $36 ; double largeur ? 
	bpl $D5B6 ; non, on sort 
	iny  ; 2oui, on ecrit le code une deuxieme fois 
	pha  ; 2on sauve lÅfattribut 
	txa 
	sta ($2E),Y ; on ecrit le code ASCII 
	pla 
	sta ($30),Y ; et lÅfattribut 
	rts 
	jsr $CF75 ;  on passe en TEXT 
	jmp $D74D ;  on eteint le curseur VIDEOTEX 
	lda #$00 ; on met 0 
	sta $3C ; dans FLGVD0 
	sta $3D ; FLGVD1 
	sta $37 ; et le flag de sequence 
	rts 
	bpl $D5D9 ; N=0, on ecrit une donnee sur lÅfecran 
	bcs $D5B7 ; C=1, on ferme lÅfE/S 
	jsr $CF45 ;  on passe en HIRES 
	jsr $D5BD ;  on initialize les flags VIDEOTEX 
	lda #$96 ; AY=$D796 
	ldy #$D7 ; 
	jsr $FEF9 ;  on redefinit les caracteres VIDEOTEX 
	lda #$0C ; et on efface lÅfecran 
	jmp $D178 ;  
	lsr $3D ; on sort N/B dans C 
	php 
	rol $3D ; 
	plp 
	bcs $D60F ; si mode N/B, on saute 
	ldy $38 ; on prend VDTX 
	beq $D60F ; si 0, on saute aussi 
	pha  ; 2on sauve le code et son attribut 
	txa 
	pha 
	dey  ; 2on revient un cran a gauche 
	lda ($2E),Y ; on lit le code 
	bmi $D60B ; >128 ? oui, on saute 
	tax  ; 2non, on sauve lÅfASCII dans X 
	lda ($30),Y ; on lit lÅfattribut 
	bmi $D5FB ; >128 ? oui, on saute 
	cpx #$20 ; est-ce un espace ? 
	bne $D60B ; non, on passe 
	beq $D600 ; inconditionnel 
	txa  ; 2on prend le code 
	and #$3F ; %00111111, on enleve b6 et b7 
	bne $D60B ; sÅfil nÅfest pas nul, on saute 
	lda $34 ; on prend VDTATR 
	and #$07 ; on isole la couleur du texte 
	dec $38 ; on decale dÅfune colonne a droite 
	jsr $D648 ;  on affiche le code 
	inc $38 ; et on revient une colonne a droite 
	pla  ; 2on recupere code dans X 
	tax  ; 2et attribut dans A 
	pla 
	clc 
	tay  ; 2b7 dÅfattribut=1 
	bpl $D653 ; non, on passe 
	txa  ; 2b7 de code=1 ? 
	bmi $D63A ; oui, on saute 
	ldy #$00 ; non, on met $9C00 
	lda #$9C ; dans RES 
	sty $00 ; (table G2, caracteres accentues) 
	sta $01 ; 
	txa  ; 2et le code 
	sta $03 ; dans $03 
	jsr $FEB2 ;  on place le code G1 dans la table 
	ldx #$07 ; pour 8 elements 
	lda $9C00,X ;  on prend un code 
	bit $03 ; b6 du code=1 ? 
	bvs $D62F ; oui, on passe 
	and $D709,X ;  non, on disjoint les paves 
	ora #$40 ; on force b6 a 1 
	sta $9C00,X ;  et on sauve dans la table 
	dex 
	bpl $D625 ; 
	jmp $D6B0 ;  et on affiche 
	lda #$00 ; A=0 
	bcs $D640 ; si C=1, on passe 
	lda $32 ; sinon, A=VDTPAR 
	lsr  ; 2on isole la couleur de fond 
	lsr 
	lsr 
	lsr 
	and #$07 ; 
	ora #$10 ; force b4 a 1 
	ldx #$0F ; et on stock 16 fois de suite dans la table 
	sta $9C00,X ;  
	dex 
	bpl $D64A ; 
	jmp $D69F ;  
	txa  ; 2caractere normal 
	ldx #$13 ; on calcule son adresse 
	stx $03 ; #1300*8=#9800 
	asl  ; 2auquel on ajoute 8*ASCII 
	rol $03 ; 
	asl 
	rol $03 ; 
	asl 
	rol $03 ; 
	sta $02 ; dans $02-03 
	ldy #$07 ; on lit les 8 codes 
	lda ($02),Y ; 
	ora #$40 ; force b6 a 1 (pixel HIRES) 
	sta $9C00,Y ;  dans la table 
	dey 
	bpl $D665 ; 
	ldy $38 ; on prend VDTX 
	lda ($2E),Y ; on prend le code en VDTX,Y 
	bpl $D67B ; si b7=0 on passe 
	and #$04 ; on isole b2 (souligne) 
	bne $D680 ; oui 
	beq $D685 ; non 
	dey  ; 2on lit le code precedent 
	bpl $D671 ; pas dÅfattribut ? on passe 
	bmi $D685 ; attribut, on gere 
	lda #$3F ; on souligne le code 
	sta $9C07 ;  dans la derniere ligne du caractere 
	bit $36 ; double larger ? 
	bpl $D69F ; 
	ldx #$07 ; 
	lda $9C00,X ;  
	sta $02 ; 
	jsr $D6F5 ;  le code de droite 
	sta $9C08,X ;  
	jsr $D6F5 ;  et celui de gauche 
	sta $9C00,X ;  
	dex 
	bpl $D68B ; 
	bit $34 ; inverse video 
	bvc $D6B0 ; non 
	ldy #$0F ; oui, on force b7 des octets 
	lda $9C00,Y ;  HIRES a 1 
	ora #$80 ; pour inversion video 
	sta $9C00,Y ;  
	dey 
	bpl $D6A5 ; 
	lda $2C ; AY contient lÅfadresse du code 
	ldy $2D ; 
	bit $36 ; double hauteur ? 
	bvc $D6BF ; non 
	sec  ; 2oui, on passe une ligne au dessus 
	sbc #$40 ; 
	dey 
	bcs $D6BF ; 
	dey 
	sta $00 ; et on stocke lÅfadresse dans RES 
	sty $01 ; 
	ldx #$00 ; Y=0 
	lsr $03 ; b7 de $03=0 
	ldy $38 ; on lit lÅfabcisse du caractere 
	lda $9C00,X ;  on lit le code 
	sta ($00),Y ; et on lÅfaffiche 
	bit $36 ; double largeur ? 
	bpl $D6D8 ; non 
	lda $9C08,X ;  oui, on lit la deuxieme moitie 
	iny  ; 2et on lÅfaffiche 
	sta ($00),Y ; 
	clc 
	lda $00 ; on ajoute 40 a lÅfadresse du caractere 
	adc #$28 ; 
	sta $00 ; 
	bcc $D6E3 ; 
	inc $01 ; 
	bit $36 ; double hauteur 
	bvc $D6EF ; non 
	lda $03 ; oui, on inverse b7 
	eor #$80 ; de $03 
	sta $03 ; 
	bmi $D6C7 ; on affiche deux fois la ligne 
	inx 
	cpx #$08 ; 
	bne $D6C7 ; 
	rts 
	lda #$00 ; A=0 
	ldy #$03 ; pour 3 decalages 
	lsr $02 ; on sort un bit dans C 
	php  ; 2on sauve C 
	ror  ; 2on entre ce bit dans A 
	plp 
	ror  ; 2deux fois 
	dey 
	bne $D6F9 ; 
	lsr  ; 2on ramene a b0 dans A 
	lsr 
	and #$3F ; inutile ! A contenait 0 en entree ! 
	ora #$40 ; et on force b6 pour affichage HIRES 
	rts 
	lda #$00 ; A=2 
	ldx #$03 ; X=3 
	ldy $3B ; on lit VDTGY (0, 1, ou 2 selon la ligne du motif) 
	beq $D722 ; Y=0 X=3 A=2 
	dex  ; 2X=X-1 
	lda #$03 ; A=3 si X=2 
	dey  ; 2si Y etait 1 
	beq $D722 ; X=2 et A=3 ok 
	inx 
	lda #$05 ; X=3 et A=5 
	jsr $CE69 ;  A*40 dans AY on calcule la ligne Y 
	lda $2C ; on additionne 
	ldy $2D ; 
	jsr $CE89 ;  lÅfadresse du motif 
	lda #$38 ; %00111000 dans A 
	ldy $3A ; Y=VDTGX, 0 ou 1 (mosaique a deux colonnes) 
	beq $D734 ; si 0, on saute, A a le motif colonne 0 
	lda #$07 ; sinon, motif colonne 1 = %00000111 
	sta $02 ; dans RESB 
	ldy $38 ; 
	lda ($00),Y ; et on prend lÅfoctet 
	asl  ; 2on sort le bit de video inverse 
	bmi $D73F ; si pixels, on saute 
	lda #$80 ; sinon, on force pixel 
	ror  ; 2sans alterer la video inverse 
	eor $02 ; on depose le motif 
	sta ($00),Y ; et on le stocke 
	tya 
	clc 
	adc #$28 ; +40 pour ligne suivante 
	tay 
	dex 
	bne $D738 ; 
	rts  ; 2et on sort 
	clc  ; 2C=0 
	sec  ; 2C=1 
	php  ; 2on sauve P 
	asl $3D ; 
	plp 
	ror $3D ; et on met C dans b7 de FLGVD1 
	lda #$80 ; A=%10000000 
	lda #$00 ; A=%00000000 
	and $3D ; si pas de curseur, alors on ne fait rien 
	bit $3D ; est-on en mode graphique ? 
	bvc $D763 ; non, ok 
	lda #$00 ; oui, pas de curseur 
	sta $02 ; dans RESB 
	lda $2C ; adresse de la ligne du curseur dans RES 
	ldy $2D ; 
	sta $00 ; 
	sty $01 ; 
	ldy $38 ; 
	lda ($30),Y ; on lit le code actuel 
	bmi $D77D ; si inverse video, on saute 
	and #$40 ; si attribute aussi 
	beq $D77D ; 
	lda $02 ; on prend lÅfoctet 
	eor #$80 ; et on lui accole le curseur 
	sta $02 ; dans RESB 
	ldx #$08 ; on prend la position du curseur 
	ldy $38 ; 
	lda ($00),Y ; on prend le code qui sÅfy trouve 
	and #$7F ; on lui met le curseur ou non 
	ora $02 ; 
	sta ($00),Y ; et on le stocke 
	clc 
	tya 
	adc #$28 ; +40 pour ligne suivante 
	tay 
	bcc $D792 ; 
	inc $01 ; eventuellement poids fort aussi 
	dex  ; 2pour 8 lignes 
	bne $D781 ; 
	rts 
	jsr $D903 ;  on scrute le clavier 
	beq $D812 ; si aucune touche, on sort 
	ldx $0270 ;  touche pressee au tour precedent ? 
	bpl $D7F1 ; non 
	lda $0271 ;  la touche est celle que lÅfon avait pressee ? 
	and $01E8,X ;  oui, (X=128+col, $1E8+128=$268, KBDCOL !) 
	bne $D807 ; on gere la repetition 
	dey  ; 2Y contient la colonne ou la touche a ete pressee 
	lda $0268,Y ;  on lit la colonne 
	sta $0271 ;  dans $271 
	tya 
	ora #$80 ; et b7 de $270 a 1 
	sta $0270 ;  
	jsr $D81F ;  on convertit en ASCII et on gere le buffer 
	lda $0272 ;  on lit le nombre avant repetition 
	jmp $D818 ;  dans le compteur 
	dec $0274 ;  meme touche pressee, faut-il repeter ? 
	bne $D81B ; non 
	jsr $D81F ;  oui, on convertit la meme touche dans le buffer 
	jmp $D815 ;  et on indique touche pressee et delai 
	sta $0270 ;  on nÅfindique pas de touche pressee 
	lda $0273 ;  on place le diviseur 
	sta $0274 ;  de repetition dans la delai 
	rts 
	jmp $D8DD ;  saut a la gestion de la touche FUNCT 
	jsr $C8BF ;  on gere la RS232 (decidement, on la gere partout) 
	lda #$00 ; on posse 0 
	pha 
	lda $0270 ;  on lit le numero de colonne 
	asl  ; 2dans b6b5b3 
	asl 
	asl 
	tay  ; 2et Y 
	lda $0271 ;  on lit la colonne 
	lsr  ; 2est-on sur la bonne ligne ? 
	bcs $D835 ; oui 
	iny  ; 2non, ligne suivante 
	bcc $D82F ; incoditionnel 
	lda $026C ;  on lit colonne 4 
	tax  ; 2dans X 
	and #$90 ; %10010000, SHIFT presse ? 
	beq $D845 ; non, on passe 
	pla  ; 2on met 1 dans la pile 
	ora #$01 ; on indique SHIFT dans la pile 
	pha 
	tya  ; 2on prend lÅfindex caractere 
	adc #$3F ; on ajoute 64 (C=1) pour majuscule 
	tay 
	tya 
	cmp #$20 ; colonne 4 ? 
	bcc $D853 ; en dessous 
	sbc #$08 ; on en leve une ligne 
	cmp #$58 ; %01011000, on depasse ? 
	bcc $D852 ; non 
	sbc #$08 ; on enleve une colonne 
	tay  ; 2on replace 
	txa  ; 2on prend la colonne 4 
	and #$20 ; bit 5 ? (FUNCT) 
	bne $D81C ; oui, on gere la touche FUNCT 
	lda ($2A),Y ; non, on lit le code ASCII de la touche demandee 
	bit $0275 ;  majuscule ? 
	bpl $D869 ; non 
	cmp #$61 ; oui, on passe en majuscule 
	bcc $D869 ; le code si il y a lieu 
	cmp #$7B ; 
	bcs $D869 ; 
	sbc #$1F ; en enlevant 32 (C=0) 
	tay  ; 2code ASCII dans Y 
	txa 
	and #$04 ; touche CTRL ? 
	beq $D881 ; non 
	and $026FC ;  presse ? 
	beq $D879 ; non 
	lda #$80 ; oui, on indique CTRL-C 
	sta $027E ;  pourquoi pas SEC/ROR ? 
	pla 
	ora #$80 ; on indique CTRL dans la pila 
	pha 
	tya  ; 2puisque CTRL, on limite le code 
	and #$1F ; entre 0 et 31 (1 pour A, 2 pour B, etc Åc) 
	tay 
	tya  ; 2on lit le code dans A 
	ldx #$00 ; X=0 
	pha  ; 2on pousse le code ASCII 
	cmp #$06 ; est-ce CTRL-F ? 
	bne $D890 ; non 
	lda $0275 ;  oui, on bascule le bip clavier 
	eor #$40 ; 
	bcs $D8B3 ; inconditionnel 
	cmp #$14 ; est-ce CTRL-T ? 
	beq $D8AE ; oui 
	cmp #$17 ; est-ce CTRL-W ? 
	bne $D89F ; non 
	lda $0275 ;  on force ESC=CTRL-T 
	eor #$20 ; 
	bcs $D8B3 ; inconditionnel 
	cmp #$1B ; est-ce ESC ? 
	bne $D8B6 ; non 
	lda $0275 ;  oui, ESC=CTRL-T ? 
	and #$20 ; 
	beq $D8B6 ; non 
	pla  ; 2oui 
	lda #$00 ; on pousse 0 dans la pile 
	pha 
Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 69
 ; 2(on devrait pousser CTRL-T/#14 !) 
	lda $0275 ;  on bascule le mode Majuscules 
	eor #$80 ; 
	sta $0275 ;  et on stocke FLGKBD 
	pla  ; 2on sort la donnee 
	ldx #$00 ; X=buffer clavier (et de deux !) 
	jsr $C51D ;  et on envoie le code ASCII 
	pla  ; 2on sort le code KBDSHT 
	ldx #$00 ; encore ?!?!?! decidement Åc 
	jsr $C51D ;  et on ecrit le code KBDSHT 
	bit $0275 ;  bip clavier actif ? 
	bvc $D8CE ; BVC $D8F9 aurait permis de gagner un octet Åc 
	ldx #$CF ; on indexe bip clavier 
	ldy #$D8 ; 
	jmp $D9E7 ;  et on emet 
	rts 
	pha  ;  sortir KBDSHT de la pile et 
	lda ($2A),Y ; on lit le code ASCII de la touche pressee 
	cmp #$2D ; est-ce Åg=Åh 
	beq $D8F8 ; oui, on affiche le copyright 
	cmp #$3D ; est-ce Åg-Åg 
	beq $D8FB ; oui, on affiche le pave strie 
	pla  ; 2aucun des deux 
	ora #$40 ; on indique FUNCT pressee 
	pha 
	lda $0275 ;  faut-il gerer les touches de fonctions ? 
	lsr 
	bcs $D900 ; oui, Y contient lÅfindex de la touche 
	lda ($2A),Y ; on lit le code 
	and #$1F ; comme CTRL 
	ora #$80 ; mais en inverse video 
	lda #$60 ; indexe c 
	lda #$7E ; indexe pave strie 
	jmp $D882 ;  et on envoie les donnees dans le buffer 
	jmp  ;  gestion FUNCT utilisateur 
a ;1 1 dans la bonne colonne. 
	ldy #$07 ; pour 8 colonnes 
	lda #$7F ; %01111111 pour motif colonne 7 
	pha  ; 2dans la pile 
	tax 
	lda #$0E ; registre 14 du PSG (IOA) 
	jsr $DA1A ;  on envoie la colonne 
	lda #$00 ; on met 0 dans la colonne pour lÅfinstant 
	sta $0268,Y ;  
	jsr $C8BF ;  on gere la RS232 en guise de delai de reponse (!) 
	lda $0300 ;  on lit port B 
	and #$B8 ; dans A (on elimine le numero de ligne) 
	tax  ; 2dans X 
	clc 
	adc #$08 ; on ajoute 8 (pour forcer le strobe) 
	sta $1F ; dans $1F 
	stx $0300 ;  on repose le port B. b2b1b0 contient la ligne 
	inx  ; 2on passe a la ligne suivante 
	lda #$08 ; a-t-on un strobe ? 
	and $0300 ;  
	bne $D932 ; oui, touche pressee 
	cpx $1F ; non, on a fini le teste ? 
	bne $D921 ; non, ligne suivante 
	beq $D946 ; inconditionnel 
	dex  ; 2on prend la ligne 
	txa 
	pha  ; 2que lÅfon sauve 
	and #$07 ; isole le numero (pas b7) 
	tax 
	lda $D9A9,X ;  lit la position du bit correspondant 
	ora $0268,Y ;  et le place 
	sta $0268,Y ;  dans la bonne colonne 
	pla 
	tax 
	inx  ; 2on recupere lÅfindexe 
	bne $D92C ; inconditionnel 
	pla  ; 2on sort le motif de la colonne 
	sec  ; 2que lÅfon decale 
	ror  ; 2pour colonne suivante 
	dey  ; 2on compte une colonne en moins 
	bpl $D907 ; fini ? non 
	ldy #$08 ; on va lire les 8 colonnes 
	lda $0267,Y ;  on en lit une 
	bne $D95B ; non nulle, une touche a ete pressee 
	cpy #$06 ; colonne 4 ? 
	bne $D958 ; non 
	dey  ; 2oui, on saute (SHIFT, CTRL et FUNCT) 
	dey  ; 2colonne suivante 
	bne $D94E ; si pas de touche pressee, Z=1 
	rts  ; 2<- une touche a ete pressee, Z=0 
	bmi $D985 ; N=1, ouverture ou fermeture 
	lda #$01 ; lecture, A=1 dans $2A8 et $2A6 
	sta $02A8 ;  
	sta $02A6 ;  
	php 
	sei  ; 2on interdit les IRQ 
	ldx #$00 ; 
	jsr $C518 ;  y a-t-il une donnee dans le buffer clavier ? 
	bcs $D982 ; non, C=1 et on sort 
	sta $0279 ;  oui, on la stocke en $279 
	ldx #$00 ; on lit le deuxieme code 
	jsr $C518 ;  sÅfil nÅfy en a pas, on sort 
	bcs $D982 ; avec C=1 
	sta $0278 ;  on stocke le code KBDSHT 
	lda $0279 ;  et dans A le code ASCII 
	plp  ; 2et on sort avec C=0 
	clc 
	rts 
	plp  ; 2pour economiser un RTS, on aurait pu coder la 
	sec  ; 2sequence PLP/CLC/RTS/PLP/SEC/RTS par PLP/CLC/ 
	rts  ; 2BIT $3808/RTS et pointer sur 08/38 pour C=1 
	bcc $D98D ; si C=0 on ouvre 
	lda #$40 ; on interdit les interruptions par T1 
	sta $030E ;  dans V1IER (Interrupt Enable Register) 
	rts  ; 2donc Entree clavier fermee 
	lda $030B ;  on lit V1ACR 
	ora #$40 ; on force MT1 (mode roue libre sur T1) 
	sta $030B ;  
	lda #$A8 ; AY=$61A8, soit 25000 soit 40 IRQ par secondes 
	ldy #$61 ; 
	sta $0304 ;  dans V1T1 timer T1 
	sty $0305 ;  
	lda #$C0 ; on autorise les IRQ par T1 
	sta $030E ;  
	ldx #$00 ; on indexe buffer clavier 
	jmp $C50C ;  et on vide 
	lda #$FF ; PORT A en sortie (PSG) 
	sta $0303 ;  dans V1DDRA 
	sta $02A7 ;  et $2A7 
	lda #$F7 ; %11110111 PB3 en entree (strobe clavier) 
	sta $0302 ;  dans V1DDRB 
	lda #$01 ; 
	sta $0273 ;  on indique vitesse 
	sta $0274 ;  de repetition maximale 
	sta $02A8 ;  
	sta $02A6 ;  
	lda #$0E ; et 14 IRQ (1/3 seconde) avant repetition 
	sta $0272 ;  
	lda #$3F ; table ASCII en $FA3F 
	ldy #$FA ; 
	sta $2A ; 
	sty $2B ; 
	lsr $0270 ;  pas de code pour repetition 
	lda #$C0 ; majuscule et bip clavier 
	sta $0275 ;  
	lda #$00 ; et pas CTRL-C 
	sta $027E ;  
	rts 
	clc  ; 2en $D9E7, C=0, lÅfappel vient de la banque 7 
	sec  ; 2en $D9E9, C=1, lÅfappel ne vient pas de la banque 7 
	php  ; 2on sauve P 
	sei 
	lda $16 ; et lÅfadresse en $15-$16 
	pha 
	lda $15 ; 
	pha 
	stx $15 ; et on met lÅfadresse des parametres 
	sty $16 ; dans $15-$16 
	php  ; 2on sauve C 
	ldy #$00 ; Y=0 
	plp  ; 2on lit C mais on le laisse dans la pile 
	php 
	bcs $DA01 ; si C=0 
	lda ($15),Y ; on lit la donne simplement 
	bcc $DA04 ; sinon 
	jsr $0411 ;  on passe par la gestion de banques 
	tax  ; 2dans X 
	tya  ; 2registre dans A 
	pha  ; 2inutile (la routine sÅfen occupe) 
	jsr $DA1A ;  on envoie la donnee au PSG 
	pla  ; 2inutile aussi 
	tay 
	iny 
	cpy #$0E ; et 14 donnees 
	bne $D9F9 ; 
	plp  ; 2on sort C 
	pla 
	sta $15 ; on recupere $15-$16 
	pla 
	sta $16 ; 
	plp  ; 2et P 
	rts 
	pha  ; 2on sauve le numero de registre 
	sta $030F ;  sur V1DRAB 
	cmp #$07 ; registre dÅfautorisation ? 
	bne $DA26 ; non 
	txa  ; 2oui, on force 
	ora #$40 ; le port A du PSG en sortie 
	tax 
	tya  ; 2registre dans A 
	pha  ; 2dans la pile 
	php 
	sei  ; 2interdit les IRQ 
	lda $030C ;  V1PCR 
	and #$11 ; sans changer les modes de transition 
	tay  ; 2dans Y 
	ora #$EE ; on force CA2 et CB2 a 1 
	sta $030C ;  pour indiquer le registre 
	tya  ; 2on recupere V1PCR 
	ora #$CC ; CA2 et CB2 a 0 
	sta $030C ;  pour valider le registre 
	stx $030F ;  on met la valeur sur V1DRAB 
	tya  ; 2on recupere V1PCR 
	ora #$EC ; CA2 a 1 et CB2 a 0 
	sta $030C ;  pour indiquer donnee 
	tya 
	ora #$CC ; CA2 et CB2 a 0 
	sta $030C ;  pour valider la donnee 
	plp  ; 2on sort P 
	pla  ; 2Y 
	tay 
	pla  ; 2et A 
	rts 
	lda #$07 ; registre 7 (autorisation) 
	ldx #$7F ; %01111111, tous canaux eteints 
	jmp $DA1A ;  au PSG 
	lda #$50 ; 80 colonnes 
	sta $0288 ;  dans LPRFX 
	lda #$00 ; ligne 0 
	sta $0286 ;  dans LPRX 
	lda #$80 ; imprimante prete 
	sta $028A ;  dans FLGLPR 
	lda #$53 ; $E253 (HCOPY) 
	ldy #$E2 ; 
	sta $0250 ;  dans $250-$251 
	sty $0251 ;  
	rts 
	bmi $DAD2 ; ouverture ou fermeture 
	pha  ; 2ecriture, on sauve les registres 
	txa  ; 2A et X 
	pha 
	lda #$82 ; on autorise les IRQ par CA1 (ACK) 
	sta $030E ;  
	tsx 
	lda $0102,X ;  on prend la donnee 
	jsr $DAA5 ;  on lÅfenvoie 
	bit $028A ;  gerer CRLF ? 
	bvs $DAA1 ; non 
	cmp #$20 ; oui, la donnee est un espace ? 
	bcs $DA90 ; au dessus, on passe 
	cmp #$0D ; un RETURN ? 
	bne $DAA1 ; non 
	beq $DA9C ; oui, on reprend a 0 
	ldx $0286 ;  on ajoute 1 a lÅfabscisse 
	inx 
	cpx $0288 ;  on est au bout ? 
	bcc $DA9E ; non 
	jsr $DAE4 ;  oui, on saute une ligne 
	ldx #$00 ; et on met 0 
	stx $0286 ;  dans la position du stylo 
	pla 
	tax  ; 2on restaure les registres et on sort 
	pla 
	rts 
	tax  ; 2Donnee dans X 
	lda $028A ;  mode RS232 ? 
	and #$04 ; 
	beq $DAB5 ; non, parallele 
	jsr $DB2F ;  oui, on prepare la RS232 
	txa  ; 2donnee dans A 
	ldx #$18 ; X=buffer ACIA sortie 
	bne $DABF ; inconditionnel 
	lda $020D ;  imprimante detectee ? 
	and #$02 ; 
	beq $DAD1 ; non, on sort 
	txa  ; 2oui, donnee dans A 
	ldx #$24 ; X=buffer CENTRONICS sortie 
	bit $028A ;  gerer CRLF ? 
	bvs $DACA ; non 
	cmp #$7F ; oui, A=DEL (127) ? 
	bne $DACA ; non 
	lda #$20 ; oui, on envoie un espace 
	pha  ; 2on sauve la donnee (inutile !!!) 
	jsr $C51D ;  on lÅfecrit 
	pla  ; 2on la recupere (inutile ! la routine la restitue) 
	bcs $DABF ; si lÅfecriture nÅfa pas eu lieu, on boucle 
	rts 
	bcs $DAE0 ; fermeture (rien en fait) 
	lda $028A ;  ouverture, imprimante serie ? 
	and #$04 ; 
	bne $DAE1 ; oui 
	lda #$82 ; on autorise les IRQ par CA1 
	sta $030E ;  pour le ACK 
	rts 
	jmp $DB7D ;  
	pha  ; 2on sauve A 
	lda #$0D ; on envoie un CR 
	jsr $DA72 ;  
	lda $028A ;  si pas LF apres CR 
	lsr 
	bcs $DAF5 ; on passe 
	lda #$0A ; sinon, on envoie 
	jsr $DA72 ;  un LF 
	pla  ; 2on recupere A 
	rts 
	bmi $DAFE ; ouverture- fermeture 
	ldx #$0C ; lecture : on indexe le buffer ACIA entree 
	jmp $C518 ;  et on lit un code 
	bcs $DB09 ; C=1, on ferme 
	lda $031E ;  ouverture : on lit ACIACR 
	and #$0D ; %00001101 isole b0 b2 et b3 
	ora #$60 ; %01100000 force b6b5 a 1 
	bne $DB43 ; inconditionnel 
	lda $031E ;  
	ora #$02 ; force b1 a 1 dans 
	sta $031E ;  ACIACR 
	rts 
	bmi $DB3A ; ouverture-fermeture 
	tax  ; 2donnee dans X 
	bpl $DB26 ; si <128, on passe 
	cmp #$C0 ; sinon, cÅfest <128+64 ? 
	bcs $DB26 ; 
	ora #$40 ; oui, on force b7 
	pha 
	lda #$1B ; et on envoie un ESC avant 
	ldx #$18 ; la donnee 
	jsr $C51D ;  
	pla 
	pha 
	ldx #$18 ; on envoie la donnee 
	jsr $C51D ;  dans le BUFFER ACIA sortie 
	pla 
	bcs $DB26 ; si la donnee nÅfa pas ete ecrite, on boucle 
	lda $031E ;  on prend V2IER 
	and #$F3 ; %11110011 force b2 a 0 
	ora #$04 ; et b3 a 1 
	sta $031E ;  dans ACIACR 
	rts 
	bcs $DB53 ; C=1 on ferme 
	lda $031E ;  ouverture 
	and #$02 ; ACIACR a 0 sauf b1 
	ora #$65 ; %01101001, bits forces a 1 
	sta $031E ;  dans ACIACR 
	lda $0321 ;  V2DRA 
	and #$EF ; %11101111 force mode MINITEL 
	sta $0321 ;  
	lda #$38 ; %00111000 dans ACIACT 
	sta $031F ;  
	rts  ; 2et on sort 
	lda #$1E ; %00011110 transmission 8 bits, horologe interne 
	sta $59 ; 1 bit de stop, 9600 bauds dans RS232T 
	lda #$00 ; pas dÅfecho et pas de parite 
	sta $5A ; dans RS232C 
	rts 
	bpl $DAF7 ; lecture, voir MINITEL (pourquoi pas $DAF9 ?) 
	bcs $DB09 ; C=1, on ferme 
	lda $031E ;  on ouvre 
	and #$0D ; on fixe le mode de controle 
	ora $5A ; dans la RS232 
	sta $031E ;  
	lda $0321 ;  
	ora #$10 ; %00010000 on force RS232 
	sta $0321 ;  
	lda $59 ; et on fixe le mode de transmission 
	sta $031F ;  dans ACIACR 
	rts 
	bpl $DB26 ; ecriture, comme MINITEL 
	bcs $DB53 ; pas de fermeture (RTS) 
	lda $031E ;  ouverture, on lit ACIACR 
	and #$02 ; isole b1 
	ora #$05 ; %00000101 force b0 et b2 a 1 
	bne $DB66 ; inconditionnel 
	pha  ; 2on sauve A et P 
	php 
	lda #$00 ; fenetre 0 
	beq $DB9C ; inconditionnel 
	pha 
	php 
	lda #$01 ; fenetre 1 
	bne $DB9C ; 
	pha 
	php 
	lda #$02 ; fenetre 2 
	bne $DB9C ; 
	pha 
	php 
	lda #$03 ; fenetre 3 
	sta $28 ; stocke la fenetre dans SCRNB 
	plp  ; 2on lit la commande 
	bpl $DBA4 ; ecriture 
	jmp $DECE ;  ouverture 
	pla  ; 2on lit la donnee 
	sta $29 ; que lÅfon sauve 
	lda $028A ;  echo sur imprimante ? 
	and #$02 ; 
	beq $DBB3 ; non 
	lda $29 ; oui, on envoie le code sur lÅfimprimante 
	jsr $DA72 ;  
	lda $29 ; 

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30
	sta $29 ; 
	pha  ; 2on sauve les registres 
	txa 
	pha 
	tya 
	pha 
	ldx $28 ; on lit la fenetre 
	lda $0218,X ;  on stocke lÅfadresse de la fenetre 
	sta $26 ; dans ADSCR 
	lda $021C,X ;  
	sta $27 ; 
	lda $29 ; on prend le code 
	cmp #$20 ; espace ? 
	bcs $DC4C ; caractere 
	lda $0248,X ;  code de controle, on prend FLGSCR 
	pha  ; 2dans la pile 
	jsr $DE1E ;  on eteint le curseur 
	lda #$DC ; on empile la fin de gestion 
	pha  ; 2soit $DC2B-1 car on sÅfy branche par RTS 
	lda #$2A ; 
	pha 
	lda $29 ; on lit le code 
	asl 
	tay 
	lda $DBEC,Y ;  on lit le poids fort 
	pha  ; 2dans la pile 
	lda $DBEB,Y ;  et le poids faible 
	pha  ; 2dans la pile de lÅfadresse de gestion du code 
	lda #$00 ; A=0 
	sec  ; 2C=1 
	rts  ; 2on gere le code 

Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30

Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 30
	ldx $28 ; on prend la fenetre dans X 
	ldy $0220,X ;  position colonne 
	lda ($26),Y ; on lit le code sous le curseur 
	sta $024C,X ;  et on le place dans CURSCR 
	lda $26 ; on stocke lÅfadresse de la fenetre X 
	sta $0218,X ;  dans ADSCRL 
	lda $27 ; 
	sta $021C,X ;  ADSCRH 
	pla  ; 2on recupere FLGSCR 
	sta $0248,X ;  que lÅfon replace 
	jsr $DE2D ;  on inverse le curseur ($DE30 aurait ete mieux !) 
	pla  ; 2on restaure les registres 
	tay 
	pla 
	tax 
	pla 
	rts  ; 2et on sort definitivement 
	lda $0248,X ;  on prend le flag de la fenetre X 
	and #$0C ; %00001100, ESC ou US en cours ? 
	bne $DC9A ; oui 
	lda $29 ; non, on prend le code 
	bpl $DC5D ; caractere normal 
	cmp #$A0 ; <128+32 ? 
	bcs $DC5D ; non 
	and #$7F ; oui, on en fait un code simple 
	sta $29 ; dans $29 
	jsr $DC6B ;  on affiche le code 
	lda #$09 ; puis on deplace le curseur vers la droite 
	sta $29 ; 
	jmp $DBCE ;  
	sta $29 ; on sauve le code 
	ldy #$80 ; Y=128 
	lda $0248,X ;  on lit FLGSCR 
	and #$20 ; video inverse ? 
	bne $DC76 ; oui, on laisse Y 
	ldy #$00 ; non, Y=0 
	tya  ; 2dans A 
	ora $29 ; on superpose le code 
	sta $024C,X ;  dans CURSCR 
	ldy $0220,X ;  et sur lÅfecran 
	sta ($26),Y ; 
	lda $0248,X ;  
	and #$02 ; double hauteur ? 
	beq $DC99 ; non 
	lda $0224,X ;  oui 
	cmp $0234,X ;  on est a la fin de la fenetre ? 
	beq $DC99 ; oui 
	tya  ; 2non, on ajoute 40 colonnes (1 ligne) 
	adc #$28 ; 
	tay 
	lda $024C,X ;  
	sta ($26),Y ; et on affiche encore le code 
	rts 
	and #$08 ; est-ce ESC ? 
	beq $DCB8 ; non, US 
	lda $29 ; oui, on lit le code 
	bmi $DC46 ; >128, on sort 
	cmp #$40 ; <64 (ÅgAÅh-1) ? 
	bcc $DC46 ; oui, on sort 
	and #$1F ; sinon, on isole le code (0-31) 
	jsr $DC69 ;  on le place a lÅfecran 
	lda #$09 ; on deplace le curseur a droite 
	jsr $DBB5 ;  
	lda #$1B ; on envoie un ESC (fin de ESC) 
	jsr $DBB5 ;  
	jmp $DC46 ;  et on sort 
	lda $0248,X ;  US, on lit FLGSCR 
	pha  ; 2que lÅfon sauve 
	jsr $DE1E ;  on eteint le curseur 
	pla  ; 2on prend FLGSCR 
	pha 
	lsr  ; 2doit-on envoyer Y ou X ? 
	bcs $DCDC ; X 
	lda $29 ; on lit Y 
	and #$3F ; on vire b4 (protocol US) 
	sta $0224,X ;  et on fixe Y 
	jsr $DE07 ;  on ajuste lÅfadresse dans la fenetre 
	sta $0218,X ;  dans ADSCRL 
	tya 
	sta $021C,X ;  et ADSCRH 
	pla  ; 2on indique prochain code X 
	ora #$01 ; 
	pha 
	jmp $DC2B ;  et on sort 
	lda $29 ; on lit X 
	and #$3F ; on vire b4 
	sta $0220,X ;  dans SCRX 
	pla 
	and #$FA ; on indique fin de US 
	pha 
	jmp $DC2B ;  et on sort 
	rts 
	rts  ;  en fait en $DC2B, routine 
	a  ;  
	lda $0220,X ;  on lit la colonne 
	and #$F8 ; on la met a 0 
	adc #$07 ; on place sur une tabulation 8 (C=1) 
	cmp $022C,X ;  est-on en fin de ligne ? 
	beq $DD09 ; non 
	bcc $DD09 ; 
	jsr $DD67 ;  oui, on ramene le curseur en debut de ligne 
	jsr $DD9D ;  et on passe une ligne 
	ldx $28 ; 
	lda $0220,X ;  on prend la colonne 
	and #$07 ; est-on sur une tabulation 
	bne $DCEB ; non, on tabule . . . 
	rts 
	sta $0220,X ;  on sauve la colonne 
	rts  ; 2et on sort 
	d  ;  
	ror  ; 2on prepare masque %00000010 
	ror  ; 2on prepare masque %00000100 
	ror  ; 2on prepare masque %00001000 
	ror  ; 2on prepare masque %00010000 
	v  ;  
	ror  ; 2on prepare masque %00100000 
	p  ;  
	ror  ; 2on prepare masque %01000000 
	q  ;  
	ror  ; 2on prepare masque %10000000 
	tay  ; 2dans Y 
	tsx  ; 2on indexe FLGSCR dans la pile 
	eor $0103,X ;  on inverse le bit correspondant au code (bascule) 
	sta $0103,X ;  et on replace 
	sta $00 ; et dans $00 
	tya 
	and #$10 ; mode 38/40 colonne ? 
	bne $DD24 ; oui 
	rts  ; 2non on sort 
	ldx $28 ; on prend le numero de fenetre 
	and $00 ; mode monochrome (ou 40 colonnes) ? 
	beq $DD3C ; oui 
	inc $0228,X ;  non, on interdit la premiere colonne 
	inc $0228,X ;  et la deuxieme 
	lda $0220,X ;  est-on dans une colonne 
	cmp $0228,X ;  interdite ? 
	bcs $DD3B ; non 
	jmp $DD67 ;  oui, on en sort 
	rts 
	dec $0228,X ;  on autorise colonne 0 et 1 
	dec $0228,X ;  
	rts 
	dec $0220,X ;  on ramene le curseur un cran a gauche 
	rts 
	h  ;  
	lda $0220,X ;  est-on deja au debut de la fenetre ? 
	cmp $0228,X ;  
	bne $DD43 ; non, on ramene a gauche 
	lda $022C,X ;  oui, on se place a la fin de la fenetre 
	sta $0220,X ;  
	k  ;  
	lda $0224,X ;  et si on est pas 
	cmp $0230,X ;  au sommet de la fenetre, 
	bne $DD6E ; on remonte dÅfune ligne 
	lda $0230,X ;  X et Y contiennent le debut et la 
	ldy $0234,X ;  fin de la fenetre X 
	tax 
	jsr $DE5C ;  on scrolle lÅfecran vers le bas ligne X a Y 
	lda $0228,X ;  on place debut de la fenetre dans X 
	sta $0220,X ;  
	rts 
	dec $0224,X ;  on remontre le curseur 
	jmp $DE07 ;  et ON ajuste ADSCR 
	n  ;  
	ldy $0228,X ;  on prend la premiere colonne de la fenetre 
	jmp $DD7D ;  et on efface ce qui suit (BPL aurait ete mieux. .) 
	x  ;  
	ldy $0220,X ;  on prend la colonne du curseur 
	lda $022C,X ;  et la derniere colonne de la fenetre 
	sta $29 ; dans $29 
	lda #$20 ; on envoie un espace 
	sta ($26),Y ; 
	iny  ; 2jusquÅfa la fin de la ligne 
	cpy $29 ; 
	bcc $DD84 ; 
	sta ($26),Y ; et a la derniere position aussi 
	rts 
Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 69
 ; 2(INC $29 avant la boucle aurait ete mieux !) 
	inc $0220,X ;  
	rts 
	i  ;  
	lda $0220,X ;  on lit la colonne du curseur 
	cmp $022C,X ;  derniere colonne ? 
	bne $DD8E ; non, on deplace le curseur 
	jsr $DD67 ;  oui, on revient a la premiere colonne 
	j  ;  
	lda $0224,X ;  on est en bas de la fenetre ? 
	cmp $0234,X ;  
	bne $DDB2 ; non 
	lda $0230,X ;  oui, X et Y contiennent debut et fin de fenetre 
	ldy $0234,X ;  
	tax 
	jsr $DE54 ;  on scrolle la fenetre 
	jmp $DD67 ;  on revient en debut de ligne 
	inc $0224,X ;  on incremente la ligne 
	jmp $DE07 ;  et on ajuste ADSCR 
	l  ;  
	jsr $DDFB ;  on remet le curseur en haut de la fenetre 
	jsr $DD74 ;  on efface la ligne courante 
	lda $0224,X ;  on est a la fin de la fenetre 
	cmp $0234,X ;  
	beq $DDFB ; oui, on sort en replacant le curseur en haut 
	jsr $DD9D ;  non, on deplace le curseur vers le bas 
	jmp $DDBB ;  et on boucle (et BPL, non ?!?!) 
	s  ;  
	jmp $E1B9 ;  on execute un TCOPY 
	r  ;  
	lda #$02 ; on inverse b1 
	eor $028A ;  de FLGLPR 
	sta $028A ;  
	rts 
	ldx #$F0 ; on indexe les 14 donnees du OUPS 
	ldy #$DD ; 
	jsr $D9E7 ;  et on envoie au PSG 
	ldy #$60 ; 
	ldx #$00 ; 
	dex  ; 2Delai dÅfune seconde 
	bne $DDE3 ; 
	dey 
	bne $DDE3 ; 
	lda #$07 ; un JMP $DA4F suffisait . . . 
	ldx #$3F ; 
	jmp $DA1A ;  
	lda $0228,X ;  on prend la premiere colonne 
	sta $0220,X ;  dans SCRX 
	lda $0230,X ;  la premiere ligne dans 
	sta $0224,X ;  SCRY 
	lda $0224,X ;  et on calcule lÅfadresse 
	jsr $DE12 ;  de la ligne 
	sta $26 ; dans ADSCR 
	sty $27 ; 
	rts 
	jsr $CE69 ;  RES=A*40 
	lda $0238,X ;  AY=adresse de la fenetre 
	ldy $023C,X ;  
	jmp $CE89 ;  on calcule dans RES lÅfadresse de la ligne 
	clc  ; 2C=0 
	sec  ; 2C=1 
	php  ; 2on sauve C 
	asl $0248,X ;  on decale FLGSCR 
	plp  ; 2on prend C 
	ror $0248,X ;  et on place le bit curseur dans FLGSCR 
	bmi $DE53 ; on a allume le curseur, on passe 
	lda #$80 ; on prend A=%10000000 
	and $0248,X ;  curseur a afficher ? 
	and #$80 ; prend juste b7 
	eor $024C,X ;  et on inverse lÅfetat curseur du code concerne 
	ldy $0220,X ;  
	sta ($26),Y ; et onplace le code 
	pha  ; 2on sauve le code 
	lda $0248,X ;  
	and #$02 ; double hauteur ? 
	beq $DE52 ; non 
	lda $0224,X ;  oui, si on nÅfest pas 
	cmp $0234,X ;  en bas de la fenetre 
	beq $DE52 ; 
	tya  ; 2on ajoute une ligne 
	adc #$28 ; 
	tay 
	pla 
	sta ($26),Y ; et on affiche le code une deuxieme fois 
	rts 
	pla 
	rts 
	lda #$00 ; on prend $0028, soit 40 
	sta $07 ; 
	lda #$28 ; 
	bne $DE62 ; inconditionnel 
	lda #$FF ; on prend $FFD8, soit -40 en complement a 2 
	sta $07 ; 
	lda #$D8 ; 
	sta $06 ; $06-07 contiennent le deplacement 
	stx $00 ; on met la ligne de depart en RES 
	tya 
	sec 
	sbc $00 ; on calcule le nombre de lignes 
	pha  ; 2on sauve le nombre de lignes 
	txa  ; 2ligne de debut dans A 
	bit $06 ; 
	bpl $DE71 ; deplacement negatif ? 
	tya  ; 2oui, ligne de fin dans A 
	ldx $28 ; 
	jsr $DE12 ;  on calcule lÅfadresse de la ligne 
	clc 
	adc $0228,X ;  lÅfadresse exacte de la ligne dans la fenetre 
	bcc $DE7D ; 
	iny 
	sta $08 ; est dans $08-09 
	sty $09 ; 
	clc  ; 2on ajoute le deplacement 
	adc $06 ; 
	sta $04 ; 
	tya 
	adc $07 ; 
	sta $05 ; dans $04-05 
	pla  ; 2on sort le nombre de lignes 
	sta $00 ; dans RES 
	beq $DEC4 ; si nul on fait nÅfimporte quoi ! on devrait sortir ! 
	bmi $DECD ; si negatif, on sort 
	sec  ; 2on calcule 
	ldx $28 ; 
	lda $022C,X ;  la largeur de la fenetre 
	sbc $0228,X ;  
	sta $01 ; dans RES+1 
	ldy $01 ; 
	lda ($04),Y ; on transfere une ligne 
	sta ($08),Y ; 
	dey 
	bpl $DE9F ; 
	clc 
	lda $04 ; on ajoute le deplacement 
	adc $06 ; a lÅfadresse de base 
	sta $04 ; 
	lda $05 ; 
	adc $07 ; 
	sta $05 ; 
	clc 
	lda $08 ; et a lÅfadresse dÅfarrivee 
	adc $06 ; 
	sta $08 ; 
	lda $09 ; 
	adc $07 ; 
	sta $09 ; 
	dec $00 ; on decompte une ligne de faite 
	bne $DE9D ; et on fait toutes les lignes 
	ldy $01 ; on remplit la derniere ligne 
	lda #$20 ; 
	sta ($08),Y ; avec des espaces 
	dey 
	bpl $DEC8 ; 
	rts 
	bcc $DED7 ; si C=0 on passe 
	ldx $28 ; 
	jsr $DE1E ;  on eteint le curseur 
	pla  ; 2et on sort A de la pile 
	rts 
	lda #$01 ; on met 1 en $216 
	sta $0216 ;  
	lda #$80 ; on force b7 a 1 dans $217 
	sta $0217 ;  
	pla  ; 2on sort A 
	rts  ; 2et on sort 
	sec  ; 2C=1, on appelle dÅfune autre banque que la 7 
	clc  ; 2C=0, on appelle de la banque 7 
	php  ; 2on sauve C 
	sta $15 ; on sauve lÅfadresse des parametres 
	sty $16 ; 
	txa  ; 2on ajoute 24 au numero de fenetre 
	clc 
Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 69
 ; 2(pour 6 parametres) 
	adc #$18 ; 
	tax 
	ldy #$05 ; on indexe six parametres 
	plp  ; 2on lit C 
	php 
	bcs $DF12 ; C=1, on change de banque 
	lda ($15),Y ; C=0, on lit les codes sur la banque 7 
	bcc $DF15 ; 
	jsr $0411 ;  
	sta $0224,X ;  on sauve le parametre 
	txa 
	sec 
	sbc #$04 ; et on passe au parametre suivant 
	tax 
Warning: eregi(): REG_EPAREN in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 69
 ; 2(il y a 4 fenetres) 
	dey 
	bpl $DF0A ; 
	lda #$07 ; texte blanc 
	sta $0240,X ;  
	lda #$00 ; et fond noir 
	sta $0244,X ;  
	lda #$00 ; pas de curseur 
	sta $0248,X ;  
	lda $0228,X ;  curseur en haut a gauche de 
	sta $0220,X ;  la fenetre 
	lda $0230,X ;  
	sta $0224,X ;  
	lda $0238,X ;  adresse courante=adresse de base 
	sta $0218,X ;  
	lda $023C,X ;  
	sta $021C,X ;  
	lda #$20 ; on met un espace sous le curseur 
	sta $024C,X ;  
	lda $28 ; on sauve la fenetre 
	pha 
	stx $28 ; on force fenetre courante=fenetre creee 
	lda #$0C ; on efface la fenetre 
	jsr $DBB5 ;  
	pla  ; 2on replace le numero de fenetre courante 
	sta $28 ; 
	plp  ; 2on sort P 
	rts 
	lda #$1A ; on indique mode TEXT 
	sta $BFDF ;  
	jsr $FE49 ;  on redefinit les caracteres 
	ldx #$27 ; pour 40 colonnes 
	lda #$20 ; 
	sta $BB80,X ;  on efface la ligne des statuts (ligne 0) 
	dex 
	bpl $DF67 ; 
	ldy #$11 ; on fixe les valeurs par defaut 
	lda $DEE3,Y ;  
	sta $0256,Y ;  des 3 fenetres (TEXT, HIRES et TRACE) 
	dey 
	bpl $DF6F ; 
	asl $020D ;  on indique mode TEXT 
	lsr $020D ;  
	lda #$F5 ; AY=$DEF5 (fenetre VIDEOTEX) 
	ldy #$DE ; 
	bit $020D ;  mode minitel ? 
	bvs $DF8B ; oui, on indexe la bonne fenetre 
	lda #$56 ; non, on indexe $256 (fenetre TEXT) 
	ldy #$02 ; 
	ldx #$00 ; pour la fenetre 0 
	jmp $DEFD ;  et on definit la fenetre 0 
	lda $0320 ;  on lit V2DRB 
	and #$3F ; on force b7b6 a 0 
	ora #$40 ; et b6 a 1 
	bne $DFA0 ; incondionnel 
	lda $0320 ;  on lit V2DRB 
	and #$3F ; on force b7b6 a 0 
	ora #$80 ; et b7 a 1 
	sta $0320 ;  dans V2DRB 
	lda $0320 ;  on lit V2DRB 
	and #$1F ; on isole b5-b0 pour valeur 
	rts  ; 2et on sort 
	sec 
	rts 
	lda #$41 ; %01000001, joystick gauche et souris 
	sta $028C ;  dans FLGJCK 
	ldx #$06 ; on lit les valeurs par defaut 
	lda $DFF3,X ;  dans les 7 octets de valeurs touche/joystick 
	sta $029D,X ;  de JCKTAB a JCKTAB+6 
	dex 
	bpl $DFB2 ; 
	lda #$01 ; 1 en $297 diviseur repetition joystick 
	sta $0297 ;  $29C diviseur bouton central souris 
	sta $029C ;  
	lda #$06 ; 6 en $298 compteur avant repetition joystick 
	sta $0298 ;  $29B compteur bouton central souris 
	sta $029B ;  
	lda #$01 ; 1 en $299 diviseur repetition souris 
	sta $0299 ;  
	lda #$0A ; 10 en $29A compteur avant repetition souris 
	sta $029A ;  
	lda #$03 ; 3 en $2A4 diviseur deplacement souris 
	sta $02A4 ;  $2A5 valeur par defaut du diviseur 
	sta $02A5 ;  
	lda #$10 ; $2710 = 10000 
	ldy #$27 ; 
	sta $028F ;  dans $28F-290 (valeur timer T2) 
	sty $0290 ;  
	sta $0308 ;  et dans T2 
	sty $0309 ;  
	lda #$A0 ; %10100000, autorisation IRQ par T2 
	sta $030E ;  dans V1IER 
	rts 
	rts 
	lda $028D ;  on lit JGCVAL 
	and #$04 ; bouton presse ? 
	bne $E014 ; non 
	jsr $DF90 ;  oui, on lit le joystick 
	and #$04 ; bouton presse ? 
	bne $E01E ; non 
	dec $0293 ;  oui, repetition ? 
	bne $E037 ; non, on passe 
	ldx $0297 ;  on lit diviseur avant repetition 
	jmp $E01E ;  
	jsr $DF90 ;  on lit le JOYSTICK 
	and #$04 ; bouton presse ? 
	bne $E037 ; non 
	ldx $0298 ;  on lit le compteur par defaut 
	stx $0293 ;  dans repetition joy 
	sta $58 ; on sauve la valeur Feu 
	lda $028D ;  on lit la valeur joystick 
	and #$1B ; %00011011, on elimine le Feu 
	ora $58 ; on ajoute la valeur lue sur VIA2 
	sta $028D ;  dans JGCVAL 
	lda $58 ; feu presse ? 
	bne $E037 ; non 
	lda $029F ;  oui, on lit le code ASCII correspondant 
	jsr $E19F ;  et on lÅfenvoie dans le buffer clavier 
	lda $028D ;  on lit JGCVAL 
	and #$1B ; on isole les bits de direction 
	eor #$1B ; et on les inverse 
	beq $E05B ; si pas de direction, on passe 
	jsr $DF90 ;  on lit la valeur deplacement joystick 
	and #$1B ; on isole les bits direction 
	sta $58 ; dans $58 
	lda $028D ;  on lit JGCVAL 
	and #$1B ; on isole les bits de direction 
	eor $58 ; est-ce le meme mouvement ? 
	bne $E062 ; non 
	dec $0291 ;  oui, on repete ? 
	bne $E084 ; non 
	ldx $0297 ;  oui, on prend diviseur repetition 
	jmp $E065 ;  et on saute 
	jsr $DF90 ;  on lit la valeur 
	and #$1B ; deplacement 
	sta $58 ; dans $58 
	ldx $0298 ;  on prend le nombre avant repetition 
	stx $0291 ;  dans decompte repetition 
	lda $028D ;  on prend JGCVAL 
	and #$04 ; isole Feu 
	ora $58 ; ajoute direction 
	sta $028D ;  
	ldx #$04 ; 5 valeurs 
	ora #$04 ; on indique pas de FEU 
	lsr  ; 2on envoie les codes ASCII correspondant 
	pha 
	bcs $E080 ; 
	lda $029D,X ;  au directions detectees 
	jsr $E19F ;  dans le buffer clavier 
	pla 
	dex 
	bpl $E076 ; 
	rts 
	jsr $DF99 ;  on lit la valeur souris 
	and #$1B ; on isole les directions 
	sta $58 ; dans $58 
	cmp #$1B ; la souris bouge ? 
	bne $E095 ; non 
	dec $02A4 ;  on deplace ? 
	bne $E084 ; non, on sort 
	lda $02A5 ;  on place vitesse deplacement dans 
	sta $02A4 ;  $2A4 
	lda $58 ; on lit le code 
	cmp #$1B ; souris fixe ? 
	beq $E0B5 ; oui 
	and #$1B ; non, on isole les valeurs direction 
	eor $028E ;  et on retourne les bits de JCDVAL 
	and #$1B ; en isolant les bits de direction 
	bne $E0B5 ; ce ne sont pas les memes exactement 
	dec $0292 ;  on repete ? 
	bne $E0E0 ; non 
	ldx $0299 ;  oui, on met le diviseur repetition 
	jmp $E0BB ;  dans le compteur 
	jsr $DF99 ;  on lit la souris 
	ldx $029A ;  on place le compteur avant repetition 
	stx $0292 ;  dans le decompteur 
	and #$1B ; on isole les bits de direction 
	sta $58 ; dans $58 
	lda $028E ;  on prend JDCVAL 
	and #$64 ; %01100100, on isole les bits de Feu 
	ora $58 ; on ajoute les bits de direction 
	sta $028E ;  dans JDCVAL 
	lda $58 ; 
	ora #$04 ; on eteint le feu principal 
	ldx #$04 ; 
	lsr 
	pha 
	bcs $E0DC ; 
	lda $029D,X ;  et on envoie les valeurs ASCII dans le buffer 
	jsr $E19D ;  
	pla 
	dex 
	bpl $E0D2 ; 
	rts 
	.  ;  
	lda $028E ;  on lit JDCVAL 
	and #$04 ; bouton gauche ? 
	bne $E0FA ; oui 
	jsr $DF99 ;  non, on lit la souris 
	and #$04 ; bouton toujours presse ? 
	bne $E102 ; non 
	dec $0294 ;  oui, on repete ? 
	bne $E11B ; non 
	ldx $0297 ;  oui, on prepare vitesse 
	jmp $E102 ;  et on saute 
	jsr $DF99 ;  bouton gauche presse ? 
	and #$04 ; 
	ldx $0298 ;  X=compteur avant repetition 
	sta $58 ; dans $58 
	stx $0294 ;  on place X dans decompte souris 
	lda $028E ;  on lit JDCVAL 
	and #$7B ; %011111011 tout sauf bouton gauche 
	ora $58 ; met $58 dessus 
	sta $028E ;  et on replace 
	lda $58 ; bouton presse ? 
	bne $E11B ; non 
	lda $029F ;  oui, on envoie lÅfASCII correspondant 
	jsr $E19D ;  dans le buffer clavier 
	lda $028E ;  lit bouton central 
	and #$20 ; %00100000, presse ? 
	bne $E137 ; non 
	jsr $DF99 ;  oui, bouton toujours presse ? 
	lda $032F ;  
	and #$20 ; 
	bne $E140 ; non, on sauve lÅfimage bouton central 
	dec $0295 ;  oui, on repete ? 
	bne $E15B ; non, on va gerer le bouton droit 
	ldx $029C ;  oui, on prend le diviseur repetition 
	jmp $E140 ;  et on le sauve 
	jsr $DF99 ;  on lit lÅfimage souris 
	lda $032F ;  
	ldx $029B ;  on remet le compteur avant repetition 
	stx $0295 ;  dans decompte bouton central 
	and #$20 ; bouton central presse ? 
	sta $58 ; dans $58 
	lda $028E ;  on lit JDCVAL 
	and #$5F ; %01011111 sans bouton central 
	ora $58 ; on ajoute le bouton central 
	sta $028E ;  dans JDCVAL 
	and #$20 ; on isole le bouton central 
	bne $E15B ; presse ? non 
	lda $02A2 ;  oui, on envoie le code ASCII correspondant 
	jsr $E19D ;  dans le buffer clavier 
	lda $028E ;  on lit le bouton droit 
	and #$40 ; presse ? 
	bne $E177 ; non 
	jsr $DF99 ;  oui, on lit la souris 
	lda $032F ;  
	and #$80 ; b7=1 ? (mode souris ?) 
	bne $E180 ; non 
	dec $0296 ;  oui, on a decompte a 0 ? 
	bne $E19C ; non 
	ldx $029C ;  oui, on prend le diviseur 
	jmp $E180 ;  et on saute 
	jsr $DF99 ;  on lit la souris 
	lda $032F ;  on prend la valeur 
	ldx $029B ;  et le compteur 
	stx $0296 ;  dans le decompte 
	lsr 
	and #$40 ; on met b7 dans b6, et on isole 
	sta $58 ; dans $58 
	lda $028E ;  on prend JDCVAL 
	and #$3F ; isole directions 
	ora $58 ; ajoute b6 sauve 
	sta $028E ;  dans JDCVAL 
	and #$40 ; bouton presse ? 
	bne $E19C ; non, on sort 
	lda $02A3 ;  oui, on envoie le code bouton souris 
	jmp $E19D ;  ou mieux : faire pointer le branchement en $E1B6 
	rts 
	sec 
	clc 
	php  ; 2C=1 si code souris, 0 si code joystick 
	stx $58 ; on sauve X 
	ldx #$00 ; on envoie le code au buffer clavier 
	jsr $C51D ;  (buffer 0) 
	lda #$08 ; on prend le code souris 
	plp 
	bcs $E1AF ; 
	lda #$20 ; si C=0, on prend code JOYSTICK 
	ldx #$00 ; 
	jsr $C51D ;  et on envoie le code KBDSHT 
	ldx $58 ; on restaure X 
	rts  ; 2et on sort 
	sec  ; 2lÅfutilite de ces codes est douteuse . . il y a 
	rts  ; 2surement dÅfautres SEC/RTS entre $C000 et $FFFF 
	ldx $28 ; on sauve la position du curseur 
	lda $0220,X ;  
	pha 
	lda $0224,X ;  
	pha 
	lda #$1E ; on fait un HOME 
	jsr $DBB5 ;  (curseur en haut a gauche de la fenetre) 
	jsr $DAE4 ;  on saute une ligne sur lÅfimprimante 
	ldx $28 ; on prend le numero de la fenetre 
	ldy $0220,X ;  
	lda ($26),Y ; on lit un code 
	cmp #$20 ; code de controle ? 
	bcs $E1D8 ; 
	lda #$20 ; oui, on affiche un espace 
	jsr $DA72 ;  sur lÅfimprimante 
	lda $0220,X ;  on est a la fin de la ligne ? 
	cmp $022C,X ;  
	beq $E1EB ; oui 
	lda #$09 ; on deplace le curseur a droite 
	jsr $DBB5 ;  a lÅfecran 
	jmp $E1CB ;  et on tourne 
	jsr $DAE4 ;  on passe a la ligne suivante 
	ldx $28 ; 
	lda $0224,X ;  on est sur la derniere ligne ? 
	cmp $0234,X ;  
	bne $E1E3 ; non, on deplace encore a droite 
	lda #$1F ; 
	jsr $DBB5 ;  
	pla  ; 2on sort X 
	ora #$40 ; 
	jsr $DBB5 ;  
	pla  ; 2et X 
	ora #$40 ; 
	jmp $DBB5 ;  et on replace le curseur 
	jsr $DAE4 ;  on saute une ligne 
	lda $0288 ;  on sauve larger dÅfimpression 
	pha 
	lda #$28 ; on met largeur a 40 
	sta $0288 ;  
	lda #$1E ; on place le curseur en 0,0 
	jsr $D178 ;  
	ldy $38 ; 
	lda ($30),Y ; on lit lÅfattribut du code 
	bmi $E226 ; >128, on saute 
	lda ($2E),Y ; on prend le code 
	cmp #$20 ; code de controle ? 
	bcs $E228 ; non 
	lda #$20 ; on prend un espace 
	jsr $DA72 ;  on affiche le code 
	lda #$09 ; on deplace le curseur a droite 
	jsr $D178 ;  
	lda $38 ; on ajuste la position suivante 
	bne $E21A ; 
	ldy $39 ; 
	dey 
	bne $E21A ; et on boucle 
	jsr $DAE4 ;  on saute une ligne 
	pla  ; 2et on bugge !!! 
	sta $0286 ;  STA $0228 aurait ete mieux. . . 
	rts 
	jmp  ;  
	ldx #$05 ; on va envoyer 5 codes 
	lda $028A ;  on sauve FLGLPR 
	pha 
	ora #$40 ; et on interdit le CRLF du TELEMON 
	sta $028A ;  
	lda $E240,X ;  on envoie le passage en 24/216Åf de pouce 
	jsr $DA72 ;  a lÅfimprimante 
	dex 
	bne $E25E ; 
	stx $0C ; on met 0 dans $0C 
	ldx #$06 ; on envoie 6 codes 
	lda $E245,X ;  
	jsr $DA72 ;  soit passage en graphiques 240 points/ligne 
	dex 
	bne $E26B ; 
	stx $0D ; et 0 dans $0D 
	lda #$05 ; on va faire 6 pixels (5+1) 
	sta $0E ; dans $0E 
	lda $0C ; on prend la ligne 
	asl 
Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 69
 ; 2*2 
	asl 
Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 69
 ; 2*4 
	asl 
Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 69
 ; 2*8 
	jsr $CE69 ;  *40 (donc on calcule la ligne suivante) 
	sta $11 ; dans $11-$12 
	tya  ; 2on calcule #A000+ligne*8*40 
	clc 
	adc #$A0 ; 
	sta $12 ; 
	lda #$08 ; pour 8 ligne 
	sta $10 ; dans $10 
	ldy $0D ; on prend la colonne 
	lda ($11),Y ; on lit le code 
	tax  ; 2dans X 
	and #$40 ; pixels ? 
	bne $E29B ; oui 
	txa  ; 2attributs, on inverse video ? 
	and #$80 ; b7=1 si video inverse 
	tax 
	txa 
	bpl $E2A0 ; video inverse ? non 
	eor #$3F ; oui, on inverse les pixels 
	ldx $0E ; on isole le bit (numero dans $0E) 
	lsr  ; 2dans C 
	dex 
	bpl $E2A2 ; 
	rol $0F ; on lÅfajoute a la ligne (dans $0F) 
	tya 
	clc 
	adc #$28 ; on saute une ligne ecran 
	tay 
	bcc $E2B1 ; 
	inc $12 ; 
	dec $10 ; et on fait 8 lignes 
	bne $E290 ; 
	lda $0F ; on envoie le code calcule 
	jsr $DA72 ;  a lÅfimprimante 
	dec $0E ; 
	bpl $E27A ; on fait 6 bits 
	inc $0D ; 
	lda $0D ; 
	cmp #$28 ; 
	bne $E276 ; on fait 40 colonnes de 6 bits 
	inc $0C ; 
	lda $0C ; 
	cmp #$19 ; et 25 lignes de 40 colonnes de 6 bits 
	bne $E269 ; 
	ldx #$04 ; 
	lda $E24B,X ;  puis on initialise lÅfimprimante 
	jsr $DA72 ;  
	dex 
	bne $E2D0 ; 
	pla 
	sta $028A ;  et on recupere lÅfetat initial du CRLF 
	rts 
	ldy $022C,X ;  on prend la derniere colonne de la fenetre 
	dey  ; 2on decale dÅfune colonne a gauche 
	lda ($00),Y ; est-on sur un espace ? 
	cmp #$20 ; 
	bne $E2F0 ; non 
	tya  ; 2oui 
	cmp $0228,X ;  on est au debut de la fenetre ? 
	bne $E2E2 ; non 
	rts 
	cmp #$7F ; est-ce le prompt ? 
	bne $E2F8 ; non, on sort 
	tya  ; 2oui, Y contient la colonne 
	cmp $0228,X ;  et Z=1 si on est sur la premiere colonne 
	rts 
	ldy $0228,X ;  on prend le debut de la fenetre 
	lda ($00),Y ; on lit le caractere qui sÅfy trouve 
	cmp #$7F ; on le compare au prompt 
	rts  ; 2Z=1 si il y a un prompt en debut de ligne 
	ldx $28 ; X=numero de fenetre 
	lda $0224,X ;  on prend la ligne du curseur 
	sta $61 ; dans $61 
	lda $61 ; on prend la ligne du curseur 
	jsr $DE12 ;  AY et RES contiennent lÅfadresse de la ligne 
	jsr $E2F9 ;  y a-t-il un prompt au debut de la ligne ? 
	beq $E31D ; oui 
	lda $61 ; non, le curseur est-il 
	cmp $0230,X ;  en haut de la fenetre ? 
	beq $E321 ; oui, on passe 
	dec $61 ; non, on remonte une ligne et 
	bcs $E308 ; on poursuit le test 
	clc  ; 2C=0 
	iny 
	sty $60 ; $60 contient la colonne apres le prompt 
	rts 
	ldx $28 ; X=numero de fenetre courante 
	lda $0224,X ;  on prend la ligne du curseur 
	sta $63 ; dans $63 
	jsr $DE12 ;  on calcule lÅfadresse de la ligne dans RES et AY 
	jsr $E2DE ;  on place le curseur sur le dernier caractere 
	sty $62 ; est-on au debut de la ligne 
	beq $E34E ; oui 
	lda $63 ; non, on prend la ligne 
	cmp $0234,X ;  est-on en bas de la fenetre ? 
	beq $E34D ; oui 
	inc $63 ; non, on descend dÅfune ligne 
	lda $63 ; 
	jsr $DE12 ;  on calcule son adresse 
	jsr $E2F9 ;  on est sur un prompt ? 
	beq $E34B ; oui 
	jsr $E2De ;  non, on cherche le dernier caractere 
	bne $E32F ; tant quÅfon nÅfest pas sur la premiere colonne 
	dec $63 ; on remonte dÅfune ligne 
	rts 
	rts  ; 2ben voyons ! le $E34D ne suffisait pas !? 
	jsr $E301 ;  on calcule la position dÅfun prompt ($60-$61) 
	jmp $E361 ;  et on envoie . . . 
	ldx $28 ; 
	lda $0220,X ;  
	sta $60 ; on prend les coordonnees du curseur 
	lda $0224,X ;  
	sta $61 ; 
	jsr $E322 ;  on calcule le debut de la ligne ($62-$63) 
	lda $61 ; on sauve la ligne trouvee 
	sta $65 ; 
	cmp $63 ; est-ce apres un prompt ? 
	bne $E378 ; non 
	lda $62 ; oui, les colonnes correspondent ? 
	cmp $60 ; 
	bcs $E378 ; non, le prompt est avant le debut de ligne 
	lda #$00 ; oui, on indique commande vide 
	sta $0590 ;  dans BUFEDT 
	rts 
	lda #$00 ; on met 0 
	sta $64 ; dans $64 
	lsr $66 ; on decale $66 (b7=0) 
	lda $65 ; on lit la ligne dans $65 
	jsr $DE12 ;  on calcule son adresse dans RES 
	ldy $60 ; on prend la colonne de debut de commande 
	lda $65 ; et la ligne dans $65 
	cmp $61 ; est-ce la ligne de debut de commande ? 
	beq $E390 ; oui 
	ldx $28 ; 
	ldy $0228,X ;  non, alors la colonne est le debut de la fenetre 
	lda ($00),Y ; on lit le code qui sÅfy trouve 
	cmp #$20 ; un code de controle ? 
	bcs $E398 ; non 
	ora #$80 ; oui, on lÅfinverse par b7=1 (pourquoi ?) 
	ldx $64 ; X=position dans la ligne 
	bit $66 ; b7 de $66=1 ? 
	bpl $E3A4 ; non 
	lda #$20 ; oui on efface le code 
	sta ($00),Y ; on met un espace sous le curseur 
	bne $E3B1 ; inconditionnel 
	sta $0590,X ;  on stocke le code 
	inc $64 ; on indexe la position suivante 
	cpx $67 ; est on en fin de ligne ? 
	bcc $E3B1 ; non 
	dec $64 ; oui, on decremente lÅfindex 
	ror $66 ; et on met b7 de $66 a 1 
	tya  ; 2on sauve la position ecran du curseur dans A 
	iny  ; 2on avance sur le caractere suivant 
	ldx $65 ; on prend lÅfindexe de ligne 
	cpx $63 ; on est sur la derniere ligne ? 
	bne $E3C5 ; non 
	cmp $62 ; oui, derniere colonne ? 
	bne $E390 ; non 
	ldx $64 ; 
	lda #$00 ; 
	sta $0590,X ;  oui, on indique fin de commande 
	rts  ; 2et on sort 
	ldx $28 ; on prend le numero de la fenetre 
	cmp $022C,X ;  on est sur la derniere colonne de la fenetre ? 
	bne $E390 ; pas fin de la fenetre, on boucle 
	inc $65 ; fin, on ajoute 1 a la ligne 
	bne $E37E ; inconditionnel, on continue la lecture 
	ror $66 ; C dans b7 de $66 
	lda #$00 ; 0 en $64 
	sta $64 ; 
	lda $26 ; AY=ADSCR 
	ldy $27 ; 
	sta $00 ; dans RES 
	sty $01 ; 
	ldx $28 ; 
	ldy $0220,X ;  on prend la colonne du curseur 
	ldx $64 ; 
	lda $0590,X ;  on lit le code indexe dans BUFEDT 
	beq $E41C ; si 0, on saute 
	lda #$20 ; on met espace dans A 
	bit $66 ; si il faut effacer la ligne 
	bmi $E3FB ; on efface 
	lda $0590,X ;  sinon, on lit un code 
	bpl $E3FB ; 
	cmp #$A0 ; >32+128 ? 
	bcs $E3FB ; oui 
	and #$1F ; non, code de controle 
	sta ($00),Y ; a lÅfecran 
	bit $020D ;  mode minitel 
	bvc $E405 ; non 
	jsr $E656 ;  oui, on envoie le code dans le buffer SERIE OUT 
	tya  ; 2index ecran dans A 
	iny  ; 2on ajoute une colonne 
	ldx $28 ; 
	cmp $022C,X ;  derniere colonne ? 
	bne $E418 ; non 
	lda #$28 ; on ajoute 40 (une ligne) 
	ldy #$00 ; a RES (adresse curseur) 
	jsr $CE89 ;  par ADRES 
	ldy $0228,X ;  Y=premiere colonne de la fenetre 
	inc $64 ; on indexe caractere suivant dans BUFEDT 
	bne $E3E3 ; inconditionnel 
	bit $020D ;  mode minitel ? 
	bvc $E42A ; non, on sort 
	ldx $0220 ;  on prend la position du curseur (BUG !!!) 
	ldy $0224 ;  et la ligne (RE-BUG !! pourquoi fenetre 0 ?) 
	jsr $E62A ;  et on positionne le curseur 
	ldy $0220 ;  on prend la position du curseur (BUG : LDY,X !) 
	lda ($26),Y ; on lit le code 
	ldx $28 ; 
	sta $024C,X ;  et on le place sous le curseur 
	rts 
	sta $67 ; on sauve la longueur demandee 
	txa  ; 2le deplacement 
	pha 
	tya 
	bpl $E446 ; faut-il revenir au debut de la ligne ? non 
	jsr $E301 ;  on calcule les coordonnees du debut de ligne 
	ldx $60 ; 
	ldy $61 ; 
	jsr $E62A ;  et on positionne le curseur 
	lda #$0D ; on envoie un CR 
	jsr $E648 ;  
	jsr $E66C ;  on affiche le prompt 
	pla 
	tax  ; 2on recupere le deplacement 
	beq $E45A ; 
	lda #$09 ; et on se deplace 
	jsr $E648 ;  
	dex  ; 2X fois 
	bne $E452 ; 
	ldx $28 ; X=numero de fenetre courante 
	lda $0248,X ;  le curseur doit-etre affiche ? 
	bmi $E466 ; oui 
	lda #$11 ; non, on bascule, donc on force lÅfaffichage 
	jsr $E648 ;  
	jsr $CFAF ;  on teste les buffers 
	jsr $C7CF ;  on lit un code au clavier 
	bcs $E466 ; pas de code, on boucle 
	pha  ; 2on sauve le code 
	lda #$11 ; on efface le curseur 
	jsr $E648 ;  
	pla  ; 2on reprend le code 
	cmp #$0D ; est-ce RETURN ? 
	bne $E4BC ; non 
	pha 
	jsr $E34F ;  oui, on code BUFEDT 
	pla 
	pha 
	cmp #$0B ; est-ce fleche haut ? 
	beq $E494 ; oui 
	ldx $62 ; on prend les coordonnees courantes 
	ldy $63 ; du curseur 
	jsr $E62A ;  et on positionne le curseur 
	lda #$0D ; et on emet un CR 
	jsr $E648 ;  
	lda #$0A ; puis un LF 
	jsr $E648 ;  
	ldx #$FF ; 
	inx  ; 2on va eliminer les espaces de debut de ligne 
	lda $0590,X ;  
	cmp #$20 ; un espace ? 
	beq $E496 ; oui 
	txa  ; 2non, on sauve le nombre dÅfespaces bidons 
	pha 
	ldy #$00 ; 
	inx 
	iny 
	lda $0590,X ;  on ramene les caracteres apres les espaces 
	sta $0590,Y ;  au debut de la ligne 
	bne $E4A3 ; et on sort si on est sur le 0 final 
	lda #$90 ; AY=$590, BUFEDT 
	ldy #$05 ; 
	jsr $E749 ;  on calcule le numero de ligne dans RES 
	sta $00 ; 
	sty $01 ; 
	pla  ; 2on sort le nombre dÅfespaces bidon dans Y 
	tay 
	pla  ; 2et le mode de sortie dans A 
	rts 
	cmp #$03 ; est-ce CTRL-C ? 
	beq $E479 ; oui, on sort 
	cmp #$0E ; non, CTRL-N ? 
	bne $E4D1 ; non 
	jsr $E301 ;  oui, on calcule la position du debut de la ligne 
	ldx $60 ; 
	ldy $61 ; 
	jsr $E62A ;  on ramene le curseur en debut de ligne 
	jmp $E4D5 ;  et on saute 
	cmp #$18 ; CTRL-X ? 
	bne $E4DF ; non 
	jsr $E355 ;  oui, on vide la ligne 
	sec  ; 2C=1 pour vider BUFEDT 
	jsr $E3D0 ;  on vide BUFEDT 
	jmp $E45A ;  et on continue lÅfedition 
	cmp #$7F ; DEL ? 
	bne $E52A ; non, on passe 
	lda $0278 ;  SHIFT presse ? 
	lsr 
	bcs $E4F3 ; oui 
	bcc $E4EB ; nÅfimporte quoi ! 
	lda #$08 ; A=deplacement vers la gauche du curseur 
	lda #$09 ; A=deplacement vers la droite 
	jsr $E648 ;  on envoie le deplacement 
	ldx $28 ; X=numero de fenetre courante 
	lda $024C,X ;  on prend le code sous le curseur 
	cmp #$7F ; est-ce un prompt ? 
	beq $E4EE ; oui, on deplace le curseur a gauche 
	jsr $E355 ;  on recopie la ligne dans BUFEDT 
	lda $0590 ;  ligne vide ? 
	bne $E511 ; non 
	lda #$20 ; on envoie un espace a lÅfecran 
	jsr $E648 ;  
	lda #$08 ; et on replace le curseur sur lÅfespace 
	jsr $E648 ;  
	jmp $E45A ;  et on continue lÅfedition 
	ldx #$01 ; on prend un code 
	lda $0590,X ;  
	beq $E51E ; si 0, on sort 
	sta $058F,X ;  sinon, on le ramene a gauche dans BUFEDT 
	inx 
	bne $E513 ; et on ramene ainsi la ligne 
	lda #$20 ; et on envoie un espace en derniere position 
	sta $058F,X ;  
	clc  ; 2C=0, on affiche BUFEDT 
	jsr $E3D0 ;  
	jmp $E45A ;  et on continue lÅfedition 
	cmp #$20 ; code CTRL ? 
	bcc $E534 ; oui 
	jsr $E537 ;  non, on envoie le code 
	jmp $E45A ;  et on continue lÅfedition 
	jmp $E5B9 ;  on gere les codes de controle 
	.  ;  
	tay  ; 2code dans Y 
	txa  ; 2on sauve X 
	pha 
	tya  ; 2et le code 
	pha 
	jsr $E355 ;  on copie la commande apres le curseur dans BUFEDT 
	lda $62 ; A=colonne 
	ldy $0590 ;  Y=premier code 
	bne $E548 ; si pas fin de buffer, on saute 
	lda $60 ; A=colonne dans la fenetre 
	ldx $28 ; X=numero de fenetre 
	cmp $022C,X ;  est-on a la fin de la fenetre ? 
	bne $E5AE ; non 
	lda $63 ; 
	cmp $0234,X ;  fin de fenetre en bas ? 
	beq $E5AE ; oui, on sort 
	adc #$01 ; non, on ajoute 1 ligne 
	jsr $DE12 ;  on calcule lÅfadresse de la ligne 
	jsr $E2F9 ;  on est sur un prompt ? 
	bne $E5AE ; non, on sort 
	ldy $0234,X ;  oui, Y=fin de la fenetre 
	ldx $63 ; X=ligne curseur 
	inx 
Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 69
 ; 2+1 
	jsr $DE5C ;  on scrolle la fenetre 
	bit $020D ;  mode minitel ? 
	bvc $E5AE ; non, on sort 
	ldx #$00 ; 
	ldy $63 ; 
	iny 
	jsr $E62A ;  on se positionne sur la colonne 12 virtuelle 
	lda #$18 ; on envoie un CTRL-X 
	jsr $E656 ;  
	lda #$0A ; et un saut de ligne 
	jsr $E648 ;  
	ldx $28 ; 
	lda $024C,X ;  on est sur un prompt ? 
	cmp #$7F ; 
	bne $E58F ; 
	jsr $E66C ;  oui, on affiche le prompt 
	jmp $E597 ;  et on saute 
	jsr $E656 ;  non, on envoie le code sur le buffer SERIE 
	lda #$09 ; et on deplace le curseur a droite 
	jsr $DBB5 ;  sur la fenetre courante 
	lda $0224 ;  , X !!! bug :on lit la fenetre 0 ! 
	cmp $0234,X ;  est-on en fin de page ? 
	bne $E580 ; non, on boucle pour trouver le prompt 
	lda $0220 ;  fin de colonne ? (re-BUG !!!) 
	cmp $022C,X ;  
	bne $E580 ; non, id 
	ldy $61 ; et on positionne le curseur 
	ldx $60 ; apres le prompt 
	jsr $E62A ;  
	pla  ; 2on sort le code 
	jsr $E648 ;  on lÅfenvoie a lÅfecran 
	clc  ; 2C=0 
	jsr $E3D0 ;  et dans le buffer 
	pla  ; 2on recupere X 
	tax 
	rts  ; 2et on sort 
	cmp #$08 ; est-ce fleche gauche ? 
	bne $E5D5 ; non 
	pha 
	lda $0278 ;  SHIFT ? 
	lsr 
	bcs $E5CB ; oui 
	pla  ; 2on sort le code 
	jsr $E648 ;  on lÅfenvoie 
	jmp $E45A ;  et on sort 
	jsr $E301 ;  on cherche le debut de la ligne 
	ldx $60 ; 
	ldy $61 ; 
	jmp $E5E7 ;  et on ramene le curseur 
	cmp #$09 ; fleche droite ? 
	bne $E5EE ; non 
	pha 
	lda $0278 ;  oui, SHIFT 
	lsr 
	bcc $E5C4 ; non 
	jsr $E322 ;  oui, on cherche la fin de la ligne 
	ldx $62 ; 
	ldy $63 ; 
	pla 
	jsr $E62A ;  on positionne le curseur 
	jmp $E45A ;  et on sort 
	cmp #$0A ; fleche bas ? 
	bne $E604 ; non 
	ldx $28 ; oui 
	lda $0224,X ;  on est en bas de la fenetre ? 
	cmp $0234,X ;  
	bne $E615 ; non 
	lda #$0A ; oui, on indique deplacement vers le bas 
	lda $0B ; on indique deplacement vers le haut 
	jmp $E479 ;  et on poursuit 
	cmp #$0B ; fleche haut ? 
	bne $E617 ; non 
	ldx $28 ; 
	lda $0224,X ;  debut de fenetre ? 
	cmp $0230,X ;  
	beq $E5FF ; oui 
	lda #$0B ; on indique deplacement vers le haut 
	lda #$0A ; on indique deplacement vers le bas 
	cmp #$0C ; CTRL-L ? 
	bne $E624 ; non 
	jsr $E648 ;  oui, on efface lÅfecran 
	jsr $E66C ;  on affiche le prompt 
	jmp $E45A ;  et on boucle 
	jsr $E648 ;  on envoie le code a lÅfecran 
	jmp $E45A ;  et on boucle lÅfedition 
	lda #$1F ; on envoie un US 
	jsr $E648 ;  
	tya  ; 2on envoie Y+64 
	ora #$40 ; 
	jsr $E648 ;  
	txa  ; 2et X+64 
	ora #$40 ; 
	jsr $DBB5 ;  
	bit $020D ;  mode minitel ? 
	bvc $E66B ; non 
	inx  ; 2on ajoute une colonne 
	txa  ; 2dans A 
	dex  ; 2et on revient en arriere 
	ora #$40 ; on ajoute 40 
	jmp $E656 ;  et on envoie au minitel 
	bit $020D ;  mode minitel ? 
	bvc $E650 ; non 
	jsr $E656 ;  oui, on envoie le code au minitel 
	bit $E650 ;  V=0 et N=0 pour ecriture 
	jmp $DB86 ;  dans la fenetre 0 
	sta $0C ; on sauve le code 
	tya  ; 2on sauve Y 
	pha 
	txa  ; 2et X 
	pha 
	ldx #$18 ; on indexe buffer ACIA sortie (minitel sortie) 
	lda $0C ; on envoie le code 
	jsr $C51D ;  
	pla  ; 2on restaure les registres 
	tax 
	pla 
	tay 
	lda $0C ; 
	bcs $E656 ; si lÅfenvoi sÅfest mal passe, on recommence 
	rts 
	bit $020D ;  mode minitel 
	bvc $E67B ; non 
	lda #$19 ; on envoie SS2 2/E au minitel 
	jsr $E656 ;  
	lda #$2E ; donc on affiche la fleche -> 
	jsr $E656 ;  
	lda #$7F ; on affiche un prompt 
	jmp $DBB5 ;  a lÅfecran 
	lda $5C ; AX=adresse de base de recherche 
	ldx $5D ; 
	stx $03 ; dans RESB 
	sta $02 ; 
	ldy #$00 ; 
	lda ($02),Y ; on lit la longueur de la ligne 
	beq $E6AE ; 0, on sort 
	tax  ; 2on sauve la longueur dans X 
	ldy #$02 ; on lit le numero de la ligne 
	lda $01 ; 
	cmp ($02),Y ; poids fort lu egal au demande ? 
	bcc $E6AE ; superieur, on sort 
	beq $E69B ; egal, on continue le test 
	bcs $E6A4 ; inferieur, on passe 
	dey  ; 2on lit le poids faible 
	lda $00 ; 
	cmp ($02),Y ; poids faible lu egal au demande ? 
	bcc $E6AE ; superieur, on sort 
	beq $E6AF ; egal, on sort avec C=1 
	clc 
	txa 
	adc $02 ; on passe la ligne 
	bcc $E686 ; 
	inc $03 ; 
	bcs $E686 ; et on continue 
	clc  ; 2C=0, ligne non trouvee 
	rts 
	sta $0E ; sauve la longueur de la ligne 
	lda #$00 ; met 0 dans TR3-4 
	sta $0F ; 
	sta $10 ; 
	jsr $E680 ;  cherche le numero de la ligne a inserer 
	bcc $E6E7 ; la ligne nÅfexiste pas 
	stx $0F ; on sauve la longueur de la ligne trouvee 
	lda $5E ; on met SCEFIN 
	ldy $5F ; 
	sta $06 ; dans DECFIN 
	sty $07 ; 
	lda $02 ; adresse de la ligne trouvee 
	ldy $03 ; 
	sta $08 ; dans DECCIB 
	sty $09 ; 
	clc 
	txa 
	adc $02 ; 
	bcc $E6D6 ; et lÅfadresse de la fin de la ligne 
	iny 
	sta $04 ; dans DECDEB 
	sty $05 ; 
	jsr $CD6C ;  et on ramene la fin du listing (efface la ligne) 
	lda #$FF ; on met -1 
	sta $10 ; dans TR4 
	eor $0F ; on complemente TR3 a 2 
	sta $0F ; donc on remet dans TR3-4 
	inc $0F ; lÅfoppose de TR3-4 
	lda $0E ; on prend la longueur a inserer 
	beq $E738 ; cÅfest 0, on devait effacer la ligne 
	lda $5E ; on prend la fin du listing 
	ldy $5F ; 
	sta $06 ; dans DECFIN 
	sty $07 ; 
	lda $02 ; on prend lÅfadresse de la ligne 
	ldy $03 ; 
	sta $04 ; dans DECDEB 
	sty $05 ; 
	clc 
	lda $0E ; on ajoute 3 a la longueur (entete de ligne) 
	adc #$03 ; 
	pha  ; 2dans la pile 
	adc $02 ; on ajoute la longueur 
	bcc $E706 ; a DECDEB 
	iny 
	sta $08 ; dans DECCIB 
	sty $09 ; 
	jsr $CD6C ;  et on libere la place pour la ligne 
	clc 
	pla 
	pha  ; 2on prend la longueur 
	adc $0F ; on calcule longueur nouvelle ligne 
	sta $0F ; - longueur ligne precedente 
	bcc $E718 ; 
	inc $10 ; dans TR3-4 (complement a 2) 
	ldy #$00 ; on ecrit la longueur de la ligne 
	pla 
	sta ($02),Y ; 
	iny 
	lda $00 ; 
	sta ($02),Y ; le poids faible du numero de ligne 
	iny 
	lda $01 ; 
	sta ($02),Y ; le poids fort du numero de ligne 
	ldx #$00 ; 
	iny 
	lda ($0C,X) ; et le contenu de la ligne 
	sta ($02),Y ; a la suite 
	inc $0C ; 
	bne $E734 ; 
	inc $0D ; 
	dec $0E ; jusquÅfa la fin 
	bne $E729 ; 
	clc 
	lda $0F ; on calcule dans SCEFIN 
	adc $5E ; 
	sta $5E ; 
	ldy $10 ; la nouvelle adresse de fin du listing 
	tya 
	adc $5F ; 
	sta $5F ; 
	lda $0F ; et AY=difference de longueur de lignes 
	rts 
	sta $00 ; on sauve lÅfadresse du nombre 
	sty $01 ; dans RES 
	ldy #$00 ; et on met RESB a 0 
	sty $02 ; 
	sty $03 ; 
	lda ($00),Y ; on lit le code 
	cmp #$30 ; inferieur a 0 ? 
	bcc $E785 ; oui 
	cmp #$3A ; superieur a 9 ? 
	bcs $E785 ; oui 
	and #$0F ; on isole le chiffre 
	pha  ; 2dans la pile 
	asl $02 ; RESB*2 
	rol $03 ; 
	lda $02 ; AX=RESB*2 
	ldx $03 ; 
	asl $02 ; *4 
	rol $03 ; 
	asl $02 ; *8 
	rol $03 ; 
	adc $02 ; +RESB*2 
	sta $02 ; 
	txa 
	adc $03 ; 
	sta $03 ; = RESB*10 
	pla  ; 2plus chiffre lu 
	adc $02 ; 
	sta $02 ; 
	bcc $E782 ; 
	inc $03 ; 
	iny  ; 2on ajoute un chiffre lu 
	bne $E753 ; et on recommence 
	tya  ; 2nombre de chiffres lus 
	tax  ; 2dans X 
	lda $02 ; nombre dans AY et RESB 
	ldy $03 ; 
	rts 
	clc  ; 2C=0 
	bit $56 ; on fait tourner HRS5+1 sur lui-meme 
	bpl $E798 ; afin de conserver le pattern 
	sec 
	rol $56 ; 
	bcc $E7C0 ; si b7 de $56 a 0, on saute 
	ldy $49 ; sinon on prend X/6 
	lda ($4B),Y ; on lit le code actuel 
	asl  ; 2on sort b7 
	bpl $E7C0 ; pas pixel, on sort 
	ldx $4A ; on prend le reste de X/6 
	lda $E78C,X ;  on lit le bit correspondant 
	bit $57 ; b7 de HRSFB a 1 ? 
	bmi $E7BA ; b7 a 1, donc 3 ou 2 
	bvc $E7B3 ; FB=0 
	ora ($4B),Y ; FB=1, on ajoute le code 
	sta ($4B),Y ; et on le place 
	rts 
	eor #$7F ; on inverse le bit 
	and ($4B),Y ; et on lÅfeteint 
	sta ($4B),Y ; avant de le placer 
	rts 
	bvs $E7C0 ; FB=3, on sort 
	eor ($4B),Y ; FB=2, on inverse le bit 
	sta ($4B),Y ; et on sort 
	rts 
	clc  ; 2on ajoute 40 
	lda $4B ; a ADHRS 
	adc #$28 ; 
	sta $4B ; 
	bcc $E7C0 ; 
	inc $4C ; 
	rts  ; 2et on sort 
	sec  ; 2on soustrait 40 
	lda $4B ; a ADHRS 
	sbc #$28 ; 
	sta $4B ; 
	bcs $E7C0 ; 
	dec $4C ; 
	rts 
	ldx $4A ; on deplace dÅfun pixel 
	inx 
	cpx #$06 ; si on est a la fin 
	bne $E7E4 ; 
	ldx #$00 ; on revient au debut 
	inc $49 ; et ajoute une colonne 
	stx $4A ; 
	rts 
	ldx $4A ; 
	dex  ; 2on deplace a gauche 
	bpl $E7F0 ; si on sort 
	ldx #$05 ; on se place a droite 
	dec $49 ; et on enleve une colonne 
	stx $4A ; 
	rts 
	brk  ; 2XHRSSE. . . 
	sty $47 ; Y dans HRSY 
	stx $46 ; X dans HRSX 
	tya  ; 2et Y dans A 
	ldy #$00 ; AY=A, ligne du curseur 
	jsr $CE69 ;  on calcule 40*ligne 
	sta $4B ; 
	clc 
	tya 
	adc #$A0 ; et on ajoute $A000, ecran HIRES 
	sta $4C ; dans ADHRS 
	stx $00 ; on met la colonne dans RES 
	lda #$06 ; A=6 
	ldy #$00 ; et Y=0 (dans RES+1) 
	sty $01 ; AY=6 et RES=colonne 
	jsr $CEDC ;  on divise la colonne par 6 
	lda $00 ; on sauve colonne/6 dans HRSX40 
	sta $49 ; 
	lda $02 ; et le reste dans HRSX6 
	sta $4A ; 
	rts 
	clc  ; 2C=0 
	lda $46 ; on place les coordonnees actuelles 
	sta $06 ; du curseur dans $06-07 
	adc $4D ; et les coordonnees (X+dx, Y+dy) 
	sta $08 ; 
	lda $47 ; 
	sta $07 ; 
	adc $4F ; 
	sta $09 ; dans $08-09 
	bcc $E83A ; inconditionnel 
	ldy #$06 ; on place les 4 parametres (poids faible seulement) 
	ldx #$03 ; 
	lda $004D,Y ;  de HRSx 
	sta $06,X ; dans $06-7-8-9 
	dey 
	dey 
	dex 
	bpl $E830 ; 
	ldx #$03 ; on va tracer 4 traits 
	stx $05 ; dans $05 
	lda $E862,X ;  on lit le code coordonnees 
	sta $04 ; dans $04 
	ldx #$06 ; on va extraire 8 bits 
	lda #$00 ; A=0 
	sta $4E,X ; poids fort HRSx a 0 et positif 
	lsr $04 ; on sort 2 bits 
	rol  ; 2dans A 
	lsr $04 ; 
	rol 
	tay  ; 2et Y 
	lda $0006,Y ;  on lit la coordonnee correspondante 
	sta $4D,X ; et on stocke dans HRSx 
	dex 
	dex 
	bpl $E845 ; on fait les 4 coordonnees ADRAW 
	jsr $E866 ;  on trace le trait en absolu 
	ldx $05 ; 
	dex 
	bpl $E83C ; et on fait 4 traits 
	rts 
	ldx $4D ; X=colonne 
	ldy $4F ; Y=ligne du curseur 
	jsr $E7F3 ;  on place le curseur en X, Y 
	ldx #$FF ; on met -1 dans X pour un changement de signe 
	sec  ; 2eventuel dans les parametres 
	lda $51 ; on prend X2 
	sbc $4D ; -X1 
	sta $4D ; dans HRS1 (DX) 
	bcs $E87B ; si DX<0, on inverse le signe de HRS1 
	stx $4E ; DEC $4E aurait ete mieux. . . 
	sec 
	lda $53 ; on prend Y2 
	sbc $4F ; -Y1 
	sta $4F ; dans HRS2 (DY) 
	bcs $E885 ; et si DY negatif, on met signe -1 
	stx $50 ; ou DEC $50 
	lda $02AA ;  sauve le pattern 
	sta $56 ; dans HRS1+1 
	jsr $E942 ;  verifie la validite de dX et dY 
	stx $46 ; X et Y contiennent HRSX+dX et HRSY+dY 
	sty $47 ; dans HRSX et HRSY 
	bit $4E ; dX negative ? 
	bpl $E89D ; non 
	lda $4D ; oui, on complemente 
	eor #$FF ; dX 
	sta $4D ; 
	inc $4D ; a 2 
	bit $50 ; dY negative ? 
	bpl $E8A9 ; non 
	lda $4F ; oui, on complemente 
	eor #$FF ; dY 
	sta $4F ; 
	inc $4F ; a 2 
	lda $4D ; on teste dX et dY 
	cmp $4F ; 
	bcc $E8ED ; dX<dY 
	php  ; 2dX>=dY, on trace selon dX 
	lda $4D ; on prends dX 
	beq $E8EB ; dX=0, on sort 
	ldx $4F ; X=dY 
	jsr $E921 ;  on calcule dY/dX 
	plp 
	bne $E8C0 ; dX<>dY 
	lda #$FF ; dX=dY, la tangent est 1 
	sta $00 ; en fait, -1, mais c'est la meme chose 
	bit $4E ; on teste dX 
	bpl $E8CA ; dX>0 
	jsr $E7E7 ;  dX<0, on deplace le curseur a gauche 
	jmp $E8CD ;  
	jsr $E7D9 ;  on deplace le curseur a droite 
	clc  ; 2a-t-on parcouru une valeur de la tangente 
	lda $00 ; 
	adc $02 ; on stocke le resultat dans $02 
	sta $02 ; 
	bcc $E8E3 ; non, on continue 
	bit $50 ; oui, dY<0 ? 
	bmi $E8E0 ; oui 
	jsr $E7C1 ;  non, on deplace le curseur 
	jmp $E8E3 ;  vers le bas 
	jsr $E7CD ;  on deplace vers le haut 
	jsr $E792 ;  on affiche le point 
	dec $4D ; on decrement dX 
	bne $E8C0 ; on n'a pas parcouru tout l'axe 
	rts  ; 2sinon, on sort 
	plp 
	rts 
	lda $4F ; on trace la droite selon dY 
	beq $E8EA ; dY=0, on sort 
	ldx $4D ; X=dX 
	jsr $E921 ;  on calculi dX/dY dans RES 
	bit $50 ; 
	bpl $E900 ; dY>0 
	jsr $E7CD ;  dY<0, on deplace vers le haut 
	jmp $E903 ;  et on saute 
	jsr $E7C1 ;  on deplace vers le bas 
	clc  ; 2a-t-on parcouru la tangent ? 
	lda $00 ; 
	adc $02 ; 
	sta $02 ; (dans $02) 
	bcc $E919 ; non 
	bit $4E ; 
	bpl $E916 ; dX>0 
	jsr $E7E7 ;  dX<0, on deplace vers 
	jmp $E919 ;  la gauche 
	jsr $E7D9 ;  on deplace vers la droite 
	jsr $E792 ;  on affiche le point 
	dec $4F ; et on decrit dY 
	bne $E8F6 ; 
	rts  ; 2avant de sortir 
	stx $01 ; dX (ou dY)*256 dans RES+1 
	ldy #$00 ; dY (ou dX) dans AY 
	sty $00 ; 
	jsr $CEDC ;  calcul dX*256/dY (ou dY/dX) 
	lda #$FF ; reste =-1 
	sta $02 ; resultat dans RES 
	rts 
	ldx $4D ; X=HRSX 
	ldy $4F ; Y=HRSY 
	jsr $E94E ;  on verifie les coordonnees 
	jsr $E7F3 ;  on place le curseur en X,Y 
	jmp $E79C ;  et on affiche sans gerer pattern 
	jsr $E942 ;  on verifie les parametres 
	jmp $E936 ;  et on deplace 
	clc 
	lda $46 ; on prend HRSX 
	adc $4D ; plus le deplacement horizontal 
	tax  ; 2dans X 
	clc 
	lda $47 ; HRSY 
	adc $4F ; plus le deplacement vertical 
	tay  ; 2dans Y 
	cpx #$F0 ; X>=240 ? 
	bcs $E957 ; oui 
	cpy #$C8 ; Y>=200 ? 
	bcs $E957 ; oui 
	rts  ; 2coordonnees ok, on sort. 
	pla  ; 2on depile poids fort (>0) 
	sta $02AB ;  dans HRSERR 
	pla  ; 2et poids faible de l'adresse de retour 
	rts  ; 2et on retourne a l'appelant de l'appelant 
	clc 
	sec 
	pha  ; 2on sauve la couleur 
	php  ; 2et C 
	stx $00 ; fenetre dans RES 
	bit $00 ; HIRES ? 
	bmi $E9A7 ; oui 
	stx $28 ; TEXT, on met le numero de la fenetre dans $28 
	bcc $E971 ; si C=0, c'est PAPER 
	sta $0240,X ;  on stocke la couleur d'encre 
	bcs $E974 ; si C=1 c'est INK 
	sta $0244,X ;  ou la couleur de fond 
	lda $0248,X ;  est on en 38 colonnes ? 
	and #$10 ; 
	bne $E987 ; mode 38 colonne 
	lda #$0C ; mode 40 colonnes, on efface l'ecran 
	jsr $DBB5 ;  (on envoie CHR$(12)) 
	lda #$1D ; et on passe en 38 colonnes 
	jsr $DBB5 ;  (on envoie CHR$(29)) 
	ldx $28 ; on prend X=numero de fenetre 
	lda $0230,X ;  on prend la ligne 0 de la fenetre 
	jsr $CE69 ;  *40 dans RES 
	lda $0238,X ;  AY=adresse de base de la fenetre 
	ldy $023C,X ;  
	jsr $CE89 ;  on ajoute l'adresse a RES (ligne 0 *40) dans RES 
	ldy $0228,X ;  on prend la premiere colonne de la fenetre 
	dey  ; 2on enleve deux colonnes 
	dey 
	sec 
	lda $0234,X ;  on calcule le nombre de lignes 
	sbc $0230,X ;  de la fenetre 
	tax  ; 2dans X 
	inx 
	tya  ; 2colonne 0 dans Y 
	bcs $E9B3 ; inconditionnel 
	lda #$00 ; 
	ldx #$A0 ; 
	sta $00 ; RES=$A000, adresse HIRES 
	stx $01 ; 
	ldx #$C8 ; X=200 pour 200 lignes 
	lda #$00 ; A=0 pour colonne de debut = colonne 0 
	plp  ; 2on sort C 
	adc #$00 ; A=A+C 
	tay  ; 2dans Y 
	pla  ; 2on sort le code 
	sta ($00),Y ; on le place dans la colonne correspondante 
	pha  ; 2on le sauve 
	clc 
	lda $00 ; on passe 28 colonnes 
	adc #$28 ; (donc une ligne) 
	sta $00 ; 
	bcc $E9C6 ; 
	inc $01 ; 
	pla  ; 2on sort le code 
	dex  ; 2on compte X ligne 
	bne $E9B8 ; 
	rts  ; 2et on sort 
	lda $46 ; on sauve HRSX 
	pha 
	lda $47 ; et HRSY 
	pha 
	lda $02AA ;  et on met le pattern dans $56 
	sta $56 ; car le trace du cercle en tient compte 
	lda $47 ; on prend HRSY 
	sec 
	sbc $4D ; -rayon 
	tay  ; 2dans Y 
	ldx $46 ; on prend HRSX 
	jsr $E7F3 ;  et on place le premier point du cercle (X,Y-R) 
	ldx #$08 ; X=7+1 pour calculer N tel que Rayon (2^N) 
	lda $4D ; on prend le rayon 
	dex  ; 2on enleve une puissance 
	asl  ; 2on decale le rayon a gauche 
	bpl $E9E5 ; jusqu'a ce qu'un bit se presente dans b7 
	stx $0C ; exposant du rayon dans $0C 
	lda #$80 ; A=$80 soit 0,5 en decimal 
	sta $0E ; dans sfX 
	sta $10 ; et sfY 
	asl  ; 2A=0 
	sta $0F ; dans seX 
	lda $4D ; A=Rayon 
	sta $11 ; dans seY 
	sec 
	ror $0D ; on met b7 de $0D a 1 (ne pas afficher le point) 
	lda $10 ; AX=sY 
	ldx $11 ; 
	jsr $EA62 ;  on calcule sY/R (en fait sY/2^N) 
	clc 
	lda $0E ; on calcule sX=sX+sY/R 
	adc $12 ; 
	sta $0E ; 
	lda $0F ; 
	sta $12 ; 
	adc $13 ; 
	sta $0F ; la partie entiere seX a bouge ? 
	cmp $12 ; 
	beq $EA22 ; non 
	bcs $EA1D ; elle a augmente 
	jsr $E7D9 ;  elle a baisse, on deplace le curseur 
	jmp $EA20 ;  a droite 
	jsr $E7E7 ;  on deplace le curseur a gauche 
	lsr $0D ; on indique qu'il faut afficher le point 
	lda $0E ; AX=sX 
	ldx $0F ; 
	jsr $EA62 ;  on calcule sX/R (en fait sX/2^N) 
	sec 
	lda $10 ; et sY=sY-sX/R 
	sbc $12 ; 
	sta $10 ; 
	lda $11 ; 
	sta $12 ; 
	sbc $13 ; 
	sta $11 ; seY a change (faut-il se deplacer verticalement)? 
	cmp $12 ; 
	beq $EA4A ; non 
	bcs $EA44 ; on monte 
	jsr $E7C1 ;  on est descend, on deplace le curseur 
	jmp $EA4E ;  vers le bas et on affiche 
	jsr $E7CD ;  on deplace le curseur vers le haut 
	jmp $EA4E ;  et on affiche 
	bit $0D ; faut-il afficher le point ? 
	bmi $EA51 ; non, on passe 
	jsr $E792 ;  on affiche le point nouvellement calcule 
	lda $0F ; seX=0 
	bne $E9F8 ; non, on boucle 
	lda $11 ; oui, seY=rayon ? 
	cmp $4D ; 
	bne $E9F8 ; non, on boucle 
	pla  ; 2oui, on a fait le tour 
	tay  ; 2on reprend les coordonnees du curseur sauvees 
	pla  ; 2dans X et Y 
	tax 
	jmp $E7F3 ;  et on replace le curseur 
	sta $12 ; on place la partie fractionnaire dans $12 
	stx $13 ; et la partie entiere dans $13 
	ldx $0C ; X=N tel que Rayon<2^N 
	lda $13 ; on garde le signe du resultat 
	rol 
	ror $13 ; et on divise par 2^X 
	ror $12 ; dans $13, $12 
	dex 
	bne $EA68 ; 
	rts 
	bit 6 ; a 1, ce sera des pixels, son bit 7 a 1 ce sera 
	lda $4B ; AY=adresse de la ligne du curseur 
	ldy $4C ; 
	sta $00 ; dans RES 
	sty $01 ; 
	ldx $4F ; X=nombre de colonnes 
	ldy $49 ; Y= position du curseur 
	lda $51 ; 
	sta ($00),Y ; on ecrit X colonnes 
	iny 
	dex 
	bne $EA81 ; 
	lda #$28 ; on ajoute une ligne 
	ldy #$00 ; a l'adresse 
	jsr $CE89 ;  
	dec $4D ; et on fait toutes les lignes 
	bne $EA7B ; 
	rts 
	sta $51 ; on sauve l'adresse de la chaine dans HRS3 
	sty $52 ; 
	stx $4F ; et sa longueur dans HRS2 
	lda #$40 ; FB=1 
	sta $57 ; dans HRSFB 
	ldy #$00 ; on indexe le premier caractere 
	sty $50 ; dans HRS2+1 
	cpy $4F ; on a fini ? 
	bcs $EA92 ; oui, on sort 
	lda ($51),Y ; non, on prend un code 
	jsr $EAB5 ;  on l'envoie 
	ldy $50 ; et on indexe le caractere suivant 
	iny 
	bne $EA9F ; 
	lda $4D ; on prend le code dans A 
	asl  ; 2on sort b7 
	lsr $4F ; on met dans C le type de caractere a afficher 
	ror  ; 2et dans b7 donc A>128 si caractere alterne 
	pha  ; 2dans la pile 
	lda $46 ; est-on au dela de la colonne 234 ? 
	cmp #$EA ; 
	bcc $EAD3 ; non 
	ldx $4A ; oui, X=HRSX6 
	lda $47 ; A=HRSY 
	adc #$07 ; on ajoute a HRSY 
	tay  ; 2dans Y 
	sbc #$BF ; -191 (donc on complemente a 199) 
	bcc $EAD0 ; si HRSY est bon 
	beq $EAD0 ; meme egal 
	cmp #$08 ; est-on a 8 ? 
	bne $EACF ; non, ok 
	lda #$00 ; oui, alors on met HRSY=0 
	tay  ; 2on remet A dans Y 
	jsr $E7F3 ;  on recalcule la position du point 
	pla  ; 2on prend le code 
	jsr $FF31 ;  on calcule son adresse dans RESB 
	ldy #$00 ; on met 0 dans RES 
	sty $00 ; 
	lda $49 ; on sauve HRSX6 et HRSX40 dans la pile 
	pha 
	lda $4A ; 
	pha 
	lda ($02),Y ; on lit la ligne courante du caractere 
	asl  ; 2on elimine b7 et b6 qui n'ont pas d'utilite 
	asl 
	beq $EAF3 ; si le code est 0, on passe 
	pha  ; 2on sauve la ligne 
	bpl $EAED ; si le point est allume 
	jsr $E79C ;  on l'affiche sans gerer le pattern 
	jsr $E7D9 ;  puis on deplace le curseur a droite 
	pla  ; 2on prend le code 
	bne $EAE4 ; si ce n'est pas 0, on boucle 
	jsr $E7C1 ;  on descend le curseur d'une ligne 
	pla  ; 2on recupere HRSX6 et HRSX40 
	sta $4A ; 
	pla 
	sta $49 ; 
	ldy $00 ; on ajoute une ligne de faite 
	iny 
	cpy #$08 ; 
	bne $EAD9 ; et on fait les 8 
	lda $46 ; on ajoute 6 (5+1 car C=1) 
	adc #$05 ; a HRSX 
	tax  ; 2dans X 
	ldy $47 ; HRSY dans Y 
	jmp $E7F3 ;  et on positionne le curseur en X,Y 
	lda $4F ; on prend la definition d'autorisation des 
	asl  ; 2canaux de bruit 
	asl  ; 2dans b5b4b3 
	asl 
	ora $4D ; et les canaux musicaux dans b2b1b0 
	eor #$3F ; on inverse la tout 
	tax  ; 2dans X 
	lda #$07 ; registre 7 (autorisation) 
	jsr $DA1A ;  et on ouvre les canaux demandes 
	asl $53 ; on multiplie la periode par 2 
	rol $54 ; 
	ldx $53 ; on envoie la periode poids faible 
	lda #$0B ; 
	jsr $DA1A ;  
	ldx $54 ; 
	lda #$0C ; et poids fort 
	jsr $DA1A ;  
	ldy $51 ; on prend la numero de l'enveloppe demandee 
	ldx $EB38,Y ;  on lit l'enveloppe PSG correspondante 
	lda #$0D ; et on valide l'enveloppe 
	jmp $DA1A ;  
	ldy $4F ; on prend l'octave dans X 
	lda $51 ; la note dans A 
	asl 
Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 69
 ; 2*2 car 2 octets par note 
	tax  ; 2dans X 
	lda $EB40,X ;  on lit la note 
	sta $4F ; 
	lda $EB41,X ;  et on multiplie par 2^(octave+1) 
	lsr 
Warning: eregi(): REG_BADRPT in /mnt/hdexterne/projets/miniserve.defence-force.org/users/jede/oric/telemon/mouline.php on line 69
 ; 2(+1 car les notes sont stockees pour octave -1) 
	ror $4F ; 
	dey 
	bpl $EB68 ; 
	sta $50 ; $4F-$50 contient la note 
	ldx $53 ; on lit le volume dans X 
	ldx $51 ; on lit le volume dans X 
	txa  ; 2on met le volume dans A 
	bne $EB7A ; volume <>0, on l'envoie 
	ldx #$10 ; on indique volume gere par l'enveloppe 
	ldy $4D ; on prend le canal 
	dey  ; 2-1 
	tya  ; 2dans A 
	cmp #$03 ; >3 ? 
	bcc $EB84 ; non 
	sbc #$03 ; oui, on enleve 3 
	ora #$08 ; et on indique registres de volume (8,9,10) 
	jsr $DA1A ;  et on ecrit le registre de volume 
	cpy #$03 ; canal >=3 ? 
	bcs $EB99 ; oui 
	tya  ; 2on envoie les frequences dans le registre du canal 
	asl 
	tay 
	adc #$01 ; +1 
	ldx $50 ; on envoie le poids fort 
	jsr $DA1A ;  
	tya  ; 2registre poids faible dans A 
	lda #$06 ; A=6 pour periode de bruit blanc 
	ldx $4F ; X=poids faible de la periode 
	jmp $DA1A ;  on envoie 
	ldx #$A0 ; on indexe PING 
	ldy #$EB ; 
	bne $EBE9 ; et on envoie 
	ldx #$AE ; on indexe SHOOT 
	ldy #$EB ; 
	bne $EBE9 ; et on envoie 
	ldx #$BC ; on indexe EXPLODE 
	ldy #$EB ; 
	jmp $D9E7 ;  et on envoie 
	ldx #$CA ; on envoie les donnees de base 
	ldy #$EB ; 
	jsr $D9E7 ;  au PSG 
	lda #$00 ; 
	tax  ; 20 dans X 
	txa 
	pha  ; 2dans la pile 
	lda #$00 ; on envoie X dans le canal 0 
	jsr $DA1A ;  
	ldx #$00 ; on attend pres d'1 ms 
	dex 
	bne $EBFF ; 
	pla 
	tax 
	inx 
	cpx #$70 ; et cela 112 fois, donc periode croissante 
	bne $EBF6 ; 
	and #$7F ; on enlËve b7 
	pha  ; 2dans la pile 
	lda #$01 ; en envoie un 01 
	jsr $EC49 ;  
	pla 
	bit $EC49 ;  N=0, V=0 
	jmp $DB12 ;  on envoie le code dans A 
	stx $0C ; on sauve X et Y 
	sty $0D ; 
	pha  ; 2et A 
	bit $5B ; b7 de $5B ‡ 1 ? 
	bpl $EC5E ; non 
	jsr $EC21 ;  on envoie A au MINITEL 
	jmp $EC61 ;  et on passe 
	jsr $EC1B ;  on envoie simplement A au buffer 
	pla  ; 2on reprend le code 
	eor $0E ; on inverse selon $0E 
	sta $0E ; et on place dans $0E pour contrÙle (CHECK) 
	ldx $0C ; on rÈcupËre X et Y 
	ldy $0D ; 
	rts 
	stx $0C ; on sauve X et Y 
	sty $0D ; 
	asl $027E ;  CTRL-C pressÈ ? 
	bcc $EC77 ; non, on saute 
	pla  ; 2oui, on dÈpile le retour ‡ l'appelant 
	pla 
	rts  ; 2et on retourne ‡ l'appelant dans l'appelant 
	bit $5B ; b7 de $5B ‡ 1 ? 
	bmi $EC8B ; oui 
	jsr $EC10 ;  non, on lit un code venant de la RS232 
	bcs $EC6F ; si pas de code lu, on saute au CTRL-C 
	pha  ; 2on sauve le code 
	eor $0E ; on ajuste le CHECK 
	sta $0E ; 
	pla  ; 2on prend le code 
	ldx $0C ; et on restaure X et Y 
	ldy $0D ; 
	rts 
	jsr $ECB4 ;  on lit un code sur la RS232 
	bcs $EC6F ; pas de code, on boucle sur CTRL-C 
	bit $5B ; b6 de $5B ‡ 1 ? 
	bvs $EC80 ; oui, on sort 
	cmp #$20 ; code de contrÙle ? 
	bcs $EC80 ; non, on sort 
	pha  ; 2on sauve le code de contrÙle 
	jsr $ECB9 ;  on attend un code RS232 
	tax  ; 2dans X 
	pla 
	tay  ; 2on prend le code de contrÙle dans Y 
	txa  ; 2et son suivant dans A 
	cpy #$01 ; le contrÙle est 01 ? 
	bne $ECA8 ; non 
	ora #$80 ; oui, on force b7 ‡ 1 
	bmi $EC80 ; et on saute 
	cmp #$40 ; code suivant <64 ? 
	bcs $ECB0 ; non 
	sbc #$1F ; oui, on retir 31 
	bcs $EC80 ; inconditionnel 
	adc #$3F ; on ajoute 63 
	bcc $EC80 ; inconditionnel 
	ldx #$0C ; indexe buffer sÈrie entrÈe 
	jmp $C518 ;  lit le code dans le buffer 
	jsr $ECB4 ;  on lit le code 
	bcs $ECB9 ; jusqu'‡ ce que la lecture soit faite 
	rts 
	sec  ; 2C=1 
	clc  ; 2C=0 
	lda #$80 ; A=128, N=1 
	jmp $DB5D ;  ferme ou ouvre l'entrÈe RS232 
	sec  ; 2C=1 
	clc  ; 2C=0 
	lda #$80 ; N=1 
	jmp $DB79 ;  ferme (C=1) ou ouvre la sortie RS232 
	sec  ; 2C=1 
	clc  ; 2C=0 
	lda #$80 ; N=1 
	jmp $DAF7 ;  ferme ou ouvre l'entrÈe MINITEL 
	sec  ; 2C=1 
	clc  ; 2C=0 
	lda #$80 ; N=1 
	jmp $DB12 ;  ferme ou ouvre la sortie MINITEL 
	sec 
	lda $052F ;  on calcule dans LOSALO 
	sbc $052D ;  la diffÈrence entre les adresses 
	sta $052A ;  de dÈbut et de fin du fichier : 
	lda $0530 ;  FISALO-DESALO 
	sbc $052E ;  
	sta $052B ;  
	lda $052D ;  
	ldy $052E ;  
	sta $00 ; on met dans RES l'adresse de dÈbut du fichier 
	sty $01 ; 
	rts 
	ldx #$32 ; on envoie 50 fois l'octet de synchro 
	lda #$16 ; 16 (SYN) 
	jsr $EC4F ;  
	dex 
	bne $ECFF ; 
	lda #$24 ; puis un octet 24 
	jsr $EC4F ;  
	lda #$00 ; 
	sta $0E ; 
	ldx #$00 ; 
	lda $0518,X ;  puis le nom du fichier 
	jsr $EC4F ;  
	inx 
	cpx #$0C ; (12 caractËres) 
	bne $ED12 ; 
	lda #$00 ; puis un 0 pour finir le nom 
	jsr $EC4F ;  
	ldx #$00 ; puis type et adresses du fichier 
	lda $052C,X ;  
	jsr $EC4F ;  
	inx 
	cpx #$07 ; 1+2+2+2 font 7 
	bne $ED24 ; 
	lda $0E ; puis 1 octet de contrÙle 
	jmp $EC4F ;  
	jsr $EC6B ;  on lit un code RS232 
	cmp #$16 ; est-ce SYN ? 
	bne $ED34 ; non, on boucle 
	ldx #$0A ; on va lire 10 SYN 
	jsr $EC6B ;  on lit 
	cmp #$16 ; SYN ? 
	bne $ED34 ; non, on reprend la synchro au dÈbut 
	dex 
	bne $ED3D ; oui, on lit 10 
	jsr $EC6B ;  on lit le code 
	cmp #$16 ; fin de synchro 
	beq $ED47 ; non 
	cmp #$24 ; oui est-ce 24 ? 
	bne $ED34 ; non, la synchro est rate, on repart ‡ 0 
	lda #$00 ; on met le CHECK 
	sta $0E ; ‡ 0 
	jsr $EC6B ;  on lit un code 
	tax 
	beq $ED62 ; 0, on saute 
	jsr $DBB5 ;  on affiche le caractËre du nom 
	jmp $ED56 ;  et on affiche tout le nom 
	ldx #$00 ; 
	jsr $EC6B ;  on lit la dÈfinition du fichier 
	sta $052C,X ;  
	inx 
	cpx #$07 ; (7 octets) 
	bne $ED64 ; 
	jsr $EC6B ;  on lit l'octet de CHECK 
	ora #$30 ; on force b5b4 ‡ 11 
	jmp $DBB5 ;  et on l'affiche 
	jsr $ECC1 ;  on ouvre le buffer RS232 entrÈe 
	jsr $ECC9 ;  on ouvre le buffer RS232 sortie 
	jsr $EC10 ;  on lit un code en entrÈe 
	bcs $ED85 ; si pas de code on saute 
	jsr $DBB5 ;  on affiche le code ‡ l'Ècran 
	jsr $C7CF ;  on lit un code sur canal 0 
	bcs $ED7D ; pas de code, on saute 
	cmp #$03 ; CTRL-C ? 
	beq $ED94 ; oui 
	jsr $EC1B ;  non, on Ècrit le code en sortie RS232 
	jmp $ED7D ;  et on boucle 
	jsr $ECBF ;  on ferme l'entrÈe RS232 
	jmp $ECC7 ;  et la sortie RS232 
	jsr $ECC1 ;  on ouvre le buffer RS232 entrÈe 
	asl $027E ;  on teste si CTRL-C 
	bcs $EDC7 ; oui, on sort 
	jsr $EC10 ;  on lit le code 
	bcs $ED9D ; pas de code 
	tax 
	bmi $EDAE ; b7=1, on saute 
	cmp #$20 ; code de contrÙle ? 
	bcs $EDC1 ; non 
	pha  ; 2on sauve le code 
	lda #$81 ; on envoie encre rouge 
	jsr $DBB5 ;  
	pla 
	jsr $CE54 ;  on convertit le code en hexa 
	jsr $DBB5 ;  et on affiche 
	tya 
	jsr $DBB5 ;  
	lda #$87 ; encre blanche 
	jsr $DBB5 ;  
	jmp $ED9D ;  et on boucle 
	jmp $ECBF ;  on ferme le buffer RS232 entrÈe 
	ror $5B ; on met 0 dans b7 de $5B 
	lsr $5B ; sans toucher ‡ l'indicateur d'entÍte 
	jsr $ECC9 ;  on ouvre le buffer RS232 sortie 
	jsr $EE0A ;  on envoie le programme 
	jmp $ECC7 ;  et on ferme le buffer RS232 sortie 
	ror $5B ; on met 1 dans b7 de $5B 
	sec  ; 2sans toucher ‡ l'indicateur d'entÍte 
	ror $5B ; 
	jsr $ECD9 ;  
	jsr $EE0A ;  
	jmp $ECD7 ;  
	ror $5B ; b7 de $5B ‡ 0 pour envoi RS232 
	lsr $5B ; 
	lda #$40 ; bug corrigÈ par rapport au TELEMON V2.3 
	sta $030E ;  on interdit les IRQ par T1 
	jsr $ECC1 ;  on ouvre la sortie RS232 
	jsr $EE56 ;  on envoie le programme 
	lda #$C0 ; et on rÈtablit les IRQ 
	sta $030E ;  
	jmp $ECBF ;  on ferme la sortie RS232 
	ror $5B ; b7 de $5B ‡ 1 pour envoi MINITEL 
	sec 
	ror $5B ; 
	jsr $ECD1 ;  on ouvre la sortie MINITEL 
	jsr $EE56 ;  on envoie le programme 
	jmp $ECCF ;  et on ferme la sortie MINITEL 
	bit  ;  ‡ 1 si on envoie sans entÍte. 
	bit $5B ; entÍte ‡ envoyer 
	bvs $EE11 ; non 
	jsr $ECFD ;  on envoie l'entÍte 
	jsr $ECDF ;  on calcule la taille du programme 
	lda #$00 ; on met 0 
	sta $0E ; dans le CHECK 
	lda $052A ;  on envoie la partie hors-page (comme dÈcalage) 
	beq $EE2F ; si fin, on saute 
	ldy #$00 ; 
	lda ($00),Y ; on lit l'octet 
	jsr $EC4F ;  on l'envoie en sortie sÈrie 
	dec $052A ;  on dÈcompte les octets 
	inc $00 ; on ajuste l'adresse de lecture 
	bne $EE18 ; 
	inc $01 ; 
	bne $EE18 ; inconditionnel 
	lda $052B ;  on envoie page par page 
	beq $EE51 ; 
	ldy #$00 ; 
	lda ($00),Y ; on lit le code 
	jsr $EC4F ;  on l'envoie 
	iny  ; 2256 fois 
	bne $EE36 ; 
	dec $052B ;  on indique une page de moins 
	inc $01 ; on ajoute une page ‡ l'adresse de lecture 
	bit $5B ; mode minitel ? 
	bpl $EE2F ; non 
	lda #$30 ; oui, on indique 48 dixiËmes 
	sta $44 ; dans TIMEUD 
	lda $44 ; 
	bne $EE4B ; et on attend le retour ‡ 0 (donc 0,5 secondes) 
	beq $EE2F ; et on boucle 
	lda $0E ; puis on envoie le code de contrÙle 
	jmp $EC4F ;  
	bit $5B ; entÍte ? 
	bvs $EE5D ; non 
	jsr $ED34 ;  oui, on lit l'entÍte 
	jsr $ECDF ;  on calcule la taille du fichier 
	bit $5B ; entÍte ? 
	bvc $EE6C ; oui 
	lda #$FF ; non, on indique 64 Ko 
	sta $052A ;  ‡ lire (sans valeur puisqu'on arrÍte de charger 
	sta $052B ;  par CTRL-C) 
	ldy #$00 ; 0 dans CHECK 
	sty $0E ; (somme de contrÙle) 
	lda $052A ;  on lit les octets hors-page 
	beq $EE86 ; fini 
	jsr $EC6B ;  on lit un code venant de la RS232 
	sta ($00),Y ; en mÈmoire 
	dec $052A ;  on indique un code lu 
	inc $00 ; on ajuste l'adresse mÈmoire 
	bne $EE70 ; 
	inc $01 ; 
	jmp $EE70 ;  et on boucle 
	lda $052B ;  puis les pages 
	beq $EE9D ; fini 
	ldy #$00 ; 
	jsr $EC6B ;  on lit un code 
	sta ($00),Y ; en mÈmoire 
	iny  ; 2et ainsi pour 256 octets 
	bne $EE8D ; 
	inc $01 ; on ajoute une page en mÈmoire 
	dec $052B ;  une page lue de plus 
	jmp $EE86 ;  et on boucle 
	jsr $EC6B ;  on lit le CHECK 
	ora #$30 ; force b5b4 ‡ 11 
	jmp $DBB5 ;  et on l'affiche 
	lda #$00 ; on met 0 dans valeur joystick 
	sta $028C ;  car le joystick parasite la ligne (!) 
	lda #$10 ; on prend %00010000 pour test V2IFR 
	bit $032D ;  transition CB1 ? 
	bne $EEE3 ; non, on passe 
	sec  ; 2oui C=1 
	rts  ; 2on sort 
	lda #$FF ; on met 65536 
	sta $0328 ;  dans V2T2 
	sta $0329 ;  
	lda $0329 ;  on lit V2T2H 
	cmp #$C5 ; = $C5 ? (donc 15 ms passes ?) 
	bcs $EEBB ; au dessus 
	bit $0320 ;  ? 
	lda #$20 ; on isole l'Ètat VIA2 
	and $032D ;  de T2 
	bne $EEDF ; T2=0 on passe 
	lda #$10 ; on isole CB1 
	and $032D ;  CB1 ‡ 1 ? 
	beq $EEC5 ; non 
	lda $0329 ;  oui, on lit V2T2H 
	cmp #$AD ; = $AD (donc 13 ms passes ?) 
	bcc $EEE1 ; oui, A>0, C=1 et on sort 
	cmp #$B5 ; non, 7 ms passes ? (oui:C=0 sinon C=1) 
	lda #$01 ; A=1 
	rts 
	lda #$00 ; A=0 
	sec  ; 2C=1 
	rts  ; 2on sort 
	sei  ; 2pas d'interruption 
	ldx #$04 ; on teste 4 fois la sonnerie 
	jsr $EEB3 ;  
	dex 
	bne $EEE6 ; 
	jsr $EEB3 ;  on teste la sonnerie 
	beq $EEFB ; pas de sonnerie 
	bcs $EEEC ; C=1, transition rapide, X=0 
	inx 
	jmp $EEEC ;  
	cli  ; 2on rÈtablit les IRQ 
	jmp $EEAA ;  et on boucle sur le test CB2 
	cpx #$06 ; X=6 ? 
	bcc $EEF7 ; en dessous, on boucle 
	jsr $EEB3 ;  on lit CB1 
	bcs $EEFF ; on boucle sur la dÈtection 
	ldy #$1E ; Y=30 
	ldx #$00 ; 
	jsr $EEB3 ;  on dÈtecte la sonnerie 
	bcc $EF0E ; pas dÈtectÈe 
	inx  ; 2dÈtectÈe, on compte une fois de plus 
	dey 
	bne $EF08 ; on boucle 
	cpx #$0F ; on ‡ dÈtectÈ 15 fois ? 
	bcs $EEF7 ; plus, on repart 
	cli  ; 2oui, on rÈtablit les IRQ (encore ?) 
	lda #$0A ; on attend 0,5 secondes 
	sta $44 ; 
	lda $44 ; 
	bne $EF1A ; 
	clc  ; 2C=0 
	rts  ; 2et on sort 
	jsr $ECD9 ;  ouvre la sortie MINITEL 
	lda #$6F ; envoie ESC/39/6F 
	jsr $EF30 ;  soit PRO1 OPPO (retournement) 
	lda #$68 ; ESC/39/68 
	jsr $EF30 ;  soit PRO1 CONNEXION (prise de ligne) 
	jmp $ECD7 ;  et ferme la sortie MINITEL 
	pha  ; 2sauve le code XX de PRO1 XX 
	lda #$1B ; envoie ESC 
	jsr $EC49 ;  
	lda #$39 ; et 39 au minitel 
	jsr $EC49 ;  (ESC/39 = PRO1) 
	pla 
	jmp $EC49 ;  et la donnÈe 
	jsr $ECD9 ;  ouvre la sortie minitel 
	lda #$67 ; envoie PRO1 DECONNEXION 
	jsr $EF30 ;  
	jmp $ECD7 ;  et ferme la sortie minitel 
	jsr $ECD1 ;  ouvre l'entrÈe minitel 
	lda #$FA ; attend 1 seconde 
	sta $44 ; 
	lda $44 ; 
	cmp #$F0 ; 
	bne $EF51 ; 
	ldx #$0C ; X=12 (entrÈe sÈrie) 
	jsr $C50C ;  vide le buffer minitel 
	lda $44 ; on avait 25 secondes 
	bne $EF65 ; le temps n'est pas ÈcoulÈ 
	jsr $ECCF ;  25 secondes ÈcoulÈes 
	sec  ; 2C=1, entrÈe minitel fermÈe 
	rts 
	jsr $ECB4 ;  on lit un code minitel 
	bcs $EF5C ; pas de code 
	cmp #$13 ; est-ce SEP ? 
	bne $EF5C ; non 
	jsr $ECB9 ;  oui, on lit le deuxiËme 
	cmp #$53 ; est 53 ? (SEP/53=connexion/fin) 
	bne $EF5C ; non 
	jsr $ECCF ;  oui, on ferme l'entrÈe minitel 
	clc  ; 2et C=0 
	rts 
	pha  ; 2sauve la donnÈe 
	jsr $ECD9 ;  ouvre le minitel en sortie 
	pla 
	jsr $EC49 ;  envoie le code 
	jmp $ECD7 ;  ferme le minitel en sortie 
	pha  ; 2sauve la donnÈe 
	jsr $ECC9 ;  ouvre la RS232 en sortie 
	pla 
	jsr $EC1B ;  envoie la donnÈe 
	jmp $ECC7 ;  ferme la RS232 en sortie 
	lda #$E4 ; indexe 1/2 
	ldy #$F5 ; 
	jmp $EFAF ;  fait (AY)+ACC1 
	rts  ; 2ben voyons ! le EF79 Ètait trop loin ? 
	jsr $F1EC ;  on met (AY) dans ACC2 
	lda $65 ; on complÈment le signe de ACC1 
	eor #$FF ; 
	sta $65 ; 
	eor $6D ; on plaque ACC2S 
	sta $6E ; et on stocke le produit des signes (ACCPS) 
	lda $60 ; on positionne A et P selon ACC1E 
	jmp $EFB2 ;  et on additionne 
	a  ;  
	jsr $F0E5 ;  on justifie 
	bcc $EFEE ; inconditionnel 
	jsr $F1EC ;  (AY) -> ACC2 
	bne $EFB7 ; ACC1<>0, on passe 
	jmp $F377 ;  ACC1=0, on sort avec ACC2 dans ACC1 
	tsx  ; 2on sauve SP pour retour en cas d'erreur 
	stx $89 ; dans FLSVS 
	ldx $66 ; on sauve le bit d'extension 
	stx $7F ; dans FLTRL 
	ldx #$68 ; on indexe ACC2 
	lda $68 ; et on prend ACC2E (exposant) 
	tay  ; 2dans Y 
	beq $EF97 ; si ACC2=0, on sort simplement (pourquoi pas EF79 ?) 
	sec 
	sbc $60 ; on calcule la diffÈrence des exposants 
	beq $EFEE ; exposants Ègaux 
	bcc $EFDE ; ACC2E<ACC1E 
	sty $60 ; l'exposant du rÈsultat est ACC2E 
	ldy $6D ; le signe 
	sty $65 ; est ACC2S 
	eor #$FF ; on complÈmente le signe 
	adc #$00 ; =1 (C=1), donc S=-S 
	ldy #$00 ; 0 dans l'extension 
	sty $7F ; car ACC2 n'a pas d'extension 
	ldx #$60 ; on indexe ACC1 pour justification 
	bne $EFE2 ; inconditionnel 
	ldy #$00 ; on indique 
	sty $66 ; pas d'extension 
	cmp #$F9 ; plus de 8 dÈcalages ? 
	bmi $EFAA ; oui, on dÈcale un octet 
	tay  ; 2on indexe le nombre de dÈcalages 
	lda $66 ; ACC1EX dans A 
	lsr $01,X ; on indique signe ‡ 0 
	jsr $F0FC ;  et on justifie 
	bit $6E ; on teste le produit des signes 
	bpl $F049 ; signes identiques, on passe 
	ldy #$60 ; on indexe ACC1 
	cpx #$68 ; c'est ACC1 le plus grand ? 
	beq $EFFA ; oui 
	ldy #$68 ; non, c'est ACC2, on l'indexe 
	sec 
	eor #$FF ; on complÈmente l'extension 
	adc $7F ; +1+extension, on ajoute les extensions 
	sta $66 ; dans ACC1EXE 
	lda $0004,Y ;  soustrait octet 3 de la mantisse 
	sbc $04,X ; 
	sta $64 ; 
	lda $0003,Y ;  octet 2 
	sbc $03,X ; 
	sta $63 ; 
	lda $0002,Y ;  octet 1 
	sbc $02,X ; 
	sta $62 ; 
	lda $0001,Y ;  octet 0 
	sbc $01,X ; 
	sta $61 ; 
	bcs $F022 ; positif, on passe 
	jsr $F090 ;  nÈgatif, on complÈmente 
	ldy #$00 ; 
	tya  ; 2extension=0 
	clc  ; 2dÈcalages=0 
	ldx $61 ; on prend l'octet 0 de la mantisse 
	bne $F074 ; pas 0, on dÈcale bit ‡ bit 
	ldx $62 ; sinon, on dÈcale octet 1 -> octet 0 
	stx $61 ; 
	ldx $63 ; 2 -> 1 
	stx $62 ; 
	ldx $64 ; 3 -> 2 
	stx $63 ; 
	ldx $66 ; extension -> 3 
	stx $64 ; 
	sty $66 ; 0 dans l'extension 
	adc #$08 ; on ajoute 8 aux dÈcalages 
	cmp #$28 ; 5 dÈcalages faits ? 
	bne $F026 ; 
	lda #$00 ; oui, 0 dans exposant 
	sta $60 ; donc nombre nul 
	sta $65 ; et 0 dans le signe 
	rts 
	adc $7F ; extansion dans 
	sta $66 ; ACC1EX 
	lda $64 ; octets 3 
	adc $6C ; 
	sta $64 ; 
	lda $63 ; octets 2 
	adc $6B ; 
	sta $63 ; 
	lda $62 ; octets 1 
	adc $6A ; 
	sta $62 ; 
	lda $61 ; octets 0 
	adc $69 ; 
	sta $61 ; 
	jmp $F081 ;  et on ajoute l'exposant 
A ;1 BIT 
	adc #$01 ; on indique un dÈcalage de plus 
	asl $66 ; on dÈcale l'extension 
	rol $64 ; et la mantisse 
	rol $63 ; 
	rol $62 ; 
	rol $61 ; 
	bpl $F068 ; si toujours pas assez, on boucle 
	sec  ; 2justification terminÈe 
	sbc $60 ; on ajuste l'exposant 
	bcs $F042 ; exposant dÈborde, le nombre Ètait trop petit 
	eor #$FF ; on retrouve l'exposant 
	adc #$01 ; par inversion 
	sta $60 ; dans ACC1E 
	bcc $F08F ; 
	inc $60 ; on incrÈmente l'exposant 
	beq $F0C7 ; et on sort avec OVERFLOW s'il revient ‡ 0 
	ror $61 ; sinon, on dÈcale la mantisse 
	ror $62 ; pour retrouver le signe 
	ror $63 ; 
	ror $64 ; 
	rts 
	lda $65 ; on complÈmente 
	eor #$FF ; le signe 
	sta $65 ; 
	lda $61 ; octet 0 
	eor #$FF ; 
	sta $61 ; 
	lda $62 ; octet 1 
	eor #$FF ; 
	sta $62 ; 
	lda $63 ; octet 2 
	eor #$FF ; 
	sta $63 ; 
	lda $64 ; octet 3 
	eor #$FF ; 
	sta $64 ; 
	lda $66 ; extension 
	eor #$FF ; 
	sta $66 ; 
	inc $66 ; et on ajoute 1 
	bne $F0C6 ; 
	inc $64 ; 
	bne $F0C6 ; 
	inc $63 ; 
	bne $F0C6 ; 
	inc $62 ; 
	bne $F0C6 ; 
	inc $61 ; 
	rts 
	lda #$01 ; on indexe erreur 1 
	sta $8B ; dans FLERR 
	ldx $89 ; 
	txs  ; 2on restaure la pile sur l'appelant primaire 
	rts  ; 2et on sort 
	ldx #$6E ; 
	bit  ; 2par bit (F0F2) et cela jusqu'‡ ce que A = 0. 
	ldy $04,X ; octet 3 
	sty $66 ; dans extension 
	ldy $03,X ; octet 2 
	sty $04,X ; dans 3 
	ldy $02,X ; 1 
	sty $03,X ; dans 2 
	ldy $01,X ; 0 
	sty $02,X ; dans 1 
	ldy $67 ; code de remplissage (0 en gÈnÈral) 
	sty $01,X ; dans octet 0 
	adc #$08 ; on ajoute 8 
	bmi $F0D1 ; nÈgatif 
	beq $F0D1 ; ou nul, on continue octet par octet 
	sbc #$08 ; on rÈcupËre la valeur 
	tay  ; 2en index 
	lda $66 ; extension dans A 
	bcs $F106 ; si pas de dÈcalages (Y=0) on sort 
	asl $01,X ; on dÈcale l'octet 0 
	bcc $F0F8 ; pas de bit sorti 
	inc $01,X ; bit sorti, on ajoute 1 
	ror $01,X ; on ajuste l'octet 0 
	ror $01,X ; et on dÈcale les 4 
	ror $02,X ; 
	ror $03,X ; 
	ror $04,X ; 
	ror  ; 2et l'extension 
	iny  ; 2on a fini ? 
	bne $F0F2 ; non, on boucle 
	clc  ; 2C=0 
	rts 
	rts  ; 2pour sortie relative 
	lda #$02 ; on indexe erreur PARAMETRE NUL OU NEGATIF 
	jmp $F0C9 ;  et on sort avec erreur 
	tsx  ; 2on sauve l'adresse de l'appelant 
	stx $89 ; dans FLSVS 
	jsr $F3BD ;  on prend le signe de ACC1 
	beq $F141 ; 0, erreur 
	bmi $F141 ; nÈgatif, erreur aussi 
	lda $60 ; on prend l'exposant 
	sbc #$7F ; -128 (C=0) donc on isole sa valeur 
	pha  ; 2dans la pile 
	lda #$80 ; on place exposant +0 
	sta $60 ; dans ACC1E 
	lda #$2C ; on indexe SQR(2)/2 
	ldy #$F1 ; 
	jsr $EFAF ;  on ajoute ‡ ACC1 
	lda #$31 ; on indexe SQR(2) 
	ldy #$F1 ; 
	jsr $F287 ;  on divise SRQ(2)/ACC1 
	lda #$A5 ; on indexe 1 
	ldy #$F8 ; 
	jsr $EF98 ;  on calcule 1-ACC1 
	lda #$17 ; on indexe le polynome 
	ldy #$F1 ; 
	jsr $F6E1 ;  et on calcule P(ACC1) 
	lda #$36 ; on indexe -1/2 
	ldy #$F1 ; 
	jsr $EFAF ;  et on calcule ACC1-1/2 
	pla  ; 2on prend l'exposant 
	jsr $F9E9 ;  on calcule E+ACC1 
	lda #$3B ; 
	ldy #$F1 ; 
	jsr $F1EC ;  on multiplie par LN(2) 
	beq $F140 ; si ACC1=0, on sort 
	bne $F190 ; sinon, on multiplie ACC2*ACC1 soit ACC1*LN(2) 
	bit  ;  multiplicateur 
	bit  ;  1, ajouter le multiplicande au rÈsultat 
	beq $F140 ; Z positionnÈ selon ACC1E, si ACC1=0, on sort 
	tsx  ; 2on sauve l'adresse 
	stx $89 ; de l'appelant dans FLSVS 
	jsr $F217 ;  on additionne les exposants 
	lda #$00 ; on met 0 
	sta $6F ; dans ACC3 (mantisses) 
	sta $70 ; l'exposant d'ACC3 est inexistent car 
	sta $71 ; l'exposant de la multiplication est 
	sta $72 ; dÈj‡ calcule en partie dans ACC1E 
	lda $66 ; on prend l'extension 
	jsr $F1B9 ;  * ACC3 
	lda $64 ; octet 3 
	jsr $F1B9 ;  * ACC3 
	lda $63 ; octet 2 
	jsr $F1B9 ;  * ACC3 
	lda $62 ; octet 1 
	jsr $F1B9 ;  * ACC3 
	lda $61 ; octet 0 
	jsr $F1BE ;  
	jmp $F301 ;  et on passe ACC3 -> ACC1 avec justification 
	bne $F1BE ; si l'octet ‡ multiplier est nul 
	jmp $F0CF ;  on indique 8 dÈcalages et on passÈ sans ajouter 
	lsr  ; 2pourquoi pas SEC/ROR ? 
	ora #$80 ; on met b7 ‡ 1 pour compter 8 dÈcalages 
	tay  ; 2dans Y 
	bcc $F1DD ; si il ne faut pas additionner, on saute 
	clc 
	lda $72 ; on additionne ACC2 ‡ ACC3 
	adc $6C ; octet 3 
	sta $72 ; 
	lda $71 ; 
	adc $6B ; octet 2 
	sta $71 ; 
	lda $70 ; 
	adc $6A ; octet 1 
	sta $70 ; 
	lda $6F ; 
	adc $69 ; octet 0 
	sta $6F ; 
	ror $6F ; on dÈcale ACC1 
	ror $70 ; donc le multiplicande ‡ droite 
	ror $71 ; 
	ror $72 ; 
	ror $66 ; 
	tya 
	lsr 
	bne $F1C1 ; et on fait pour les 8 bits du multiplicateur 
	rts 
	sta $7D ; on sauve l'adresse du nombre 
	sty $7E ; 
	ldy #$04 ; pour 5 octets 
	lda ($7D),Y ; octet 3 
	sta $6C ; 
	dey 
	lda ($7D),Y ; octet 2 
	sta $6B ; 
	dey 
	lda ($7D),Y ; octet 1 
	sta $6A ; 
	dey 
	lda ($7D),Y ; octet 0 
	sta $6D ; dans le signe de ACC2 
	eor $65 ; produit signes ACC1S et ACC2S 
	sta $6E ; dans ACCPS 
	lda $6D ; bit force ‡ 1 
	ora #$80 ; 
	sta $69 ; dans octet 0 
	dey 
	lda ($7D),Y ; et l'exposant 
	sta $68 ; 
	lda $60 ; en sortie A et P positionnÈs selon ACC1E 
	rts 
	lda $68 ; si ACC2=0 
	beq $F237 ; on sort avec ACC1=0 
	clc 
	adc $60 ; on ajoute ACC1E 
	bcc $F224 ; pas de dÈpassement 
	bmi $F23C ; dÈpassement et nÈgative, trop grand 
	clc  ; 2C=0 
	bpl $F237 ; pas de dÈpassement et positif, nombre trop petit 
	adc #$80 ; on ajoute 128 
	sta $60 ; pour rÈcupÈrer le bon rÈsultat dans ACC1E 
	beq $F23F ; si 0, on sort avec ACC1>0 
	lda $6E ; on met le produit des signes 
	sta $65 ; dans ACC1S 
	rts 
	lda $65 ; on complÈmente le signe de ACC1 ‡ 1 
	eor #$FF ; s'il Ètait nÈgative, N=0 et on sort 
	bmi $F23C ; sinon, on indique OVERFLOW et on sort 
	pla  ; 2on dÈpile l'adresse de reour 
	pla  ; 2pour retourner ‡ l'appelant de l'appelant 
	jmp $F042 ;  on sort avec ACC1=0 
	jmp $F0C7 ;  indique erreur OVERFLOW 
	jmp $F046 ;  on indique ACC1 positif 
	jsr $F387 ;  on met ACC1 dans ACC2 
	tax  ; 2ACC1=0 ? 
	beq $F258 ; oui, on sort 
	clc 
	adc #$02 ; ACC1*4 (on ajoute 2 ‡ l'exposant donc on 
	bcs $F23C ; multiplie pas 2^2) si on dÈpasse OVERFLOW 
	ldx #$00 ; on met 0 dans le produit des signes 
	stx $6E ; 
	jsr $EFC2 ;  +ACC2 donc *5 
	inc $60 ; et exposant +1 donc *2 donc finalement *10 
	beq $F23C ; si exposant nul, OVERFLOW 
	rts 
	jsr $F387 ;  on met ACC1 dans ACC2 
	ldx #$00 ; produit des signes ‡ 0 
	lda #$59 ; on indexe 10 
	ldy #$F2 ; 
	stx $6E ; 
	jsr $F323 ;  on met 10 dans ACC1 
	jmp $F28A ;  et on calcule ACC2/ACC1 
	tsx  ; 2on sauve pour sortie aprËs erreur 
	stx $89 ; 
	jsr $F149 ;  on calcule LN de ACC1 
	jsr $F387 ;  on arrondit ACC1 dans ACC2 
	lda #$08 ; on indexe LN(10) 
	ldy #$F1 ; 
	jsr $F323 ;  dans ACC1 
	jmp $F28A ;  et on divise ACC2 par ACC1 
	lda #$03 ; on indique erreur 3 
	sta $8B ; dans FLERR 
	rts 
	jsr $F1EC ;  ACC1=0 ? 
	beq $F282 ; oui, division par 0 
	tsx  ; 2non, on sauve le pointeur de pile 
	stx $89 ; 
	jsr $F396 ;  on arrondit ACC1 
	lda #$00 ; on veut E2-E1 
	sec  ; 2donc E2+(-E1) 
	sbc $60 ; donc on complÈmente ACC1E 
	sta $60 ; 
	jsr $F217 ;  et on additione les deux exposants 
	inc $60 ; on ajoute 1 car inverse=complement ‡ 2 
	beq $F23C ; si le rÈsultat est nul, il y a OVERFLOW 
	ldx #$FC ; on indexe ACC3 
	lda #$01 ; on prepare 8 dÈcalages 
	ldy $69 ; 
	cpy $61 ; on compare le diviseur au dividende 
	bne $F2BA ; s'ils sont different, on passe 
	ldy $6A ; 
	cpy $62 ; 
	bne $F2BA ; 
	ldy $6B ; 
	cpy $63 ; 
	bne $F2BA ; 
	ldy $6C ; 
	cpy $64 ; 
	php  ; 2on sauve le rÈsultat de la comparaison 
	rol  ; 2on met 1 ou 0 dans le rÈsultat 
	bcc $F2CA ; si pas de dÈbordement, on sautÈ 
	inx  ; 2sinon, on sauve le rÈsultat 
	sta $72,X ; 
	beq $F2C8 ; s'il est nul, on passe 
	bpl $F2F8 ; si index positif, on sort 
	lda #$01 ; on refait 8 dÈcalages 
	lda #$40 ; on indexe l'extension 
	plp  ; 2on rÈcupËre le rÈsultat de la comparaison 
	bcs $F2DB ; dividende > diviseur, on soustrait 
	asl $6C ; on dÈcale le dividende 
	rol $6B ; ‡ gauche 
	rol $6A ; 
	rol $69 ; 
	bcs $F2BA ; si un bit dÈborde, ACC2 > Acc1 
	bmi $F2A4 ; sinon, on compare ACC2 et ACC1 
	bpl $F2BA ; si b7 de ACC2=0, alors ACC1 < ACC2 
	tay  ; 2on sauve le rÈsultat provisoire 
	lda $6C ; on soustrait ACC1 ‡ ACC2 
	sbc $64 ; 
	sta $6C ; 
	lda $6B ; 
	sbc $63 ; 
	sta $6B ; 
	lda $6A ; 
	sbc $62 ; 
	sta $6A ; 
	lda $69 ; 
	sbc $61 ; 
	sta $69 ; 
	tya  ; 2on rÈcupËre le rÈsultat et on dÈcale le dividende 
	jmp $F2CD ;  pourquoi pas BCS ? 
	asl 
	asl 
	asl 
	asl 
	asl 
	asl 
	sta $66 ; on sauve dans ACC1EX 
	plp  ; 2on ajuste la pile 
	lda $6F ; on transfËre ACC3 dans ACC1 
	sta $61 ; 
	lda $70 ; 
	sta $62 ; 
	lda $71 ; 
	sta $63 ; 
	lda $72 ; 
	sta $64 ; 
	jmp $F022 ;  
	jsr $F8C7 ;  quel mode de calcul d'angles ? 
	beq $F31F ; radian 
	lda #$12 ; degrÈ, on indexe 180 
	ldy #$F1 ; 
	bne $F323 ; 
	lda #$0D ; on indexe 3,14159265 
	ldy #$F1 ; 
	sta $7D ; on sauve AY 
	sty $7E ; 
	ldy #$04 ; 
	lda ($7D),Y ; octet 3 
	sta $64 ; 
	dey 
	lda ($7D),Y ; octet 2 
	sta $63 ; 
	dey 
	lda ($7D),Y ; octet 1 
	sta $62 ; 
	dey 
	lda ($7D),Y ; octet 0 
	sta $65 ; on sauve le signe 
	ora #$80 ; on force b7 ‡ 1 
	sta $61 ; et on sauve l'octet 1 
	dey 
	lda ($7D),Y ; 
	sta $60 ; exposant 
	sty $66 ; et 0 dans l'extension 
	rts 
	ldx #$73 ; on indexe ACC5 
	ldx #$78 ; on indexe ACC4 
	ldy #$00 ; Y=0 
	jsr $F396 ;  on arrondit ACC1 
	stx $7D ; on sauve XY 
	sty $7E ; 
	ldy #$04 ; et on transfËre comme d'habitude 
	lda $64 ; 
	sta ($7D),Y ; octet 3 
	dey 
	lda $63 ; 
	sta ($7D),Y ; octet 2 
	dey 
	lda $62 ; 
	sta ($7D),Y ; octet 1 
	dey 
	lda $65 ; octet 0 
	ora #$7F ; 
	and $61 ; avec signe 
	sta ($7D),Y ; 
	dey 
	lda $60 ; 
	sta ($7D),Y ; et exposant 
	sty $66 ; 
	rts  ; 2Y=0 
	lda $6D ; signe 
	sta $65 ; 
	ldx #$05 ; et 5 octets de la mantisse 
	lda $67,X ; 
	sta $5F,X ; 
	dex 
	bne $F37D ; 
	stx $66 ; et 0 dans l'extension 
	rts 
	jsr $F396 ;  on arrondit ACC1 
	ldx #$06 ; 6 octets 
	lda $5F,X ; en transfert direct 
	sta $67,X ; 
	dex 
	bne $F38C ; 
	stx $66 ; et 0 dans l'extension 
	rts 
	lda $60 ; ACC1=0 ? 
	beq $F395 ; oui, on sort 
	asl $66 ; non, bit d'extension ? 
	bcc $F395 ; non, on sort 
	jsr $F0B8 ;  oui, on incrÈmente la mantisse 
	bne $F395 ; si pas 0, on sort 
	jmp $F083 ;  si 0, on incrÈmente l'exposant 
	lda $65 ; nombre nÈgative ? 
	bmi $F3B8 ; oui 
	lda $60 ; 
	cmp #$91 ; nombre > 65536 ? 
	bcs $F3B8 ; oui 
	jsr $F439 ;  on convertit en entier 
	lda $64 ; et on sauve dans YA (pourquoi pas AY ?) 
	ldy $63 ; 
	rts 
	lda #$0A ; erreur 10 
	jmp $F0C9 ;  (nombre trop grand ou trop petit) 
	lda $60 ; ACC1=0 ? 
	beq $F3CA ; oui, on sort 
	lda $65 ; non, negative ? 
	rol 
	lda #$FF ; oui, A=255=-1 
	bcs $F3CA ; 
	lda #$01 ; non, A=1 
	rts 
	jsr $F3BD ;  prend signe de ACC1 
	lda #$FF ; force signe nÈgatif 
	sta $61 ; on sauve A 
	lda #$00 ; 
	sta $62 ; on annule le poids faible 
	ldx #$88 ; exposant=+7 
	lda $61 ; on prend le signe 
	eor #$FF ; on l'inverse 
	rol  ; 2dans C 
	lda #$00 ; A=0 
	sta $63 ; on annule la mantisse 
	sta $64 ; 
	stx $60 ; on fixe l'exposant 
	sta $66 ; 
	sta $65 ; 
	jmp $F01D ;  et on ajoute la mantisse selon l'exposant 
	sta $61 ; on sauve YA 
	sty $62 ; 
	ldx #$90 ; on fixe l'exposant ‡ +15 
	sec 
	bcs $F3DE ; inconditionnel, on termine la conversion 
	lsr $65 ; on enlËve le signe de ACC1 
	rts  ; 2et on sort 
	sta $7D ; on sauve AY 
	sty $7E ; 
	ldy #$00 ; 
	lda ($7D),Y ; on prend l'exposant 
	iny 
	tax  ; 2dans Y 
	beq $F3BD ; si nombre nul, le rÈsultat vient de ACC1 
	lda ($7D),Y ; on prend le signe (intÈgrÈe ‡ la mantisse) 
	eor $65 ; et on le compare ‡ ACC1S 
	bmi $F3C1 ; les signes sont diffÈrent, on retourne selon ACC1 
	cpx $60 ; on compare les exposants 
	bne $F430 ; diffÈrents, on passe (C contient le signe) 
	lda ($7D),Y ; on reprend la mantisse 
	ora #$80 ; bit de signe ‡ 1 
	cmp $61 ; premier octet identique ? 
	bne $F430 ; non, C contient le signe 
	iny 
	lda ($7D),Y ; oui, octet suivant ? 
	cmp $62 ; 
	bne $F430 ; id 
	iny 
	lda ($7D),Y ; octet 2 
	cmp $63 ; 
	bne $F430 ; id 
	iny 
	lda #$7F ; extension nulle ? 
	cmp $66 ; oui, C=1, non C=0 
	lda ($7D),Y ; on soustrai la mantisse 3 
	sbc $64 ; et l'extension d'ACC1 
	beq $F3F8 ; si 0, alors nombres Ègaux 
	lda $65 ; on prend ACC1S 
	bcc $F436 ; si ACC1>(AY) on passe 
	eor #$FF ; sinon, on inverse le signe 
	jmp $F3C3 ;  et on positionne A en sortie 
	lda $60 ; nombre nul ? 
	beq $F487 ; oui, nombre nul aussi et on sort 
	sec  ; 2non, on retire exposant $A0 
	sbc #$A0 ; pour ramener ‡ 0-31 
	bit $65 ; ACC1 positif ? 
	bpl $F44D ; oui 
	tax  ; 2exposant dans X 
	lda #$FF ; on indique nombre nÈgatif 
	sta $67 ; dans ACC1J 
	jsr $F096 ;  on complÈmente la mantisse 
	txa  ; 2et on rÈcupËre l'exposant 
	ldx #$60 ; on prÈpare les opÈrations 
	cmp #$F9 ; y a-t-il plus de 8 dÈcalages ‡ faire ? 
	bpl $F459 ; non, on saute 
	jsr $F0E5 ;  oui, on fait les dÈcalages 
	sty $67 ; on remet 0 
	rts 
	tay  ; 2exposant dans Y 
	lda $65 ; on prend le signe 
	and #$80 ; dans b7 
	lsr $61 ; on replace dans $61 
	ora $61 ; 
	sta $61 ; 
	jsr $F0FC ;  et on dÈcale la mantisse 
	sty $67 ; et 0 dans ACC1J 
	rts 
	lda $60 ; on prend ACC1E 
	cmp #$A0 ; supÈrieur ‡ 31 
	bcs $F469 ; oui, on ne fait rien 
	jsr $F439 ;  on convertit en entier 32 bits 
	sty $66 ; extension ‡ 0 
	lda $65 ; on prend le signe 
	sty $65 ; et on le fixe positif 
	eor #$80 ; on l'inverse 
	rol  ; 2dans C 
	lda #$A0 ; exposant=31 
	sta $60 ; 
	lda $64 ; on prend le poids faible 
	sta $88 ; dans FLINT (ACC1 est un entier) 
	jmp $F01D ;  et on justifie la mantisse 
	sta $61 ; A=0, on annule ACC1M 
	sta $62 ; 
	sta $63 ; 
	sta $64 ; 
	tay  ; 2et Y=0 
	rts 
	sta $61 ; on sauve le poids fort 
	stx $62 ; et le poids faible 
	ldx #$90 ; exposants = + 15 
	sec  ; 2C=1 
	jmp $F3DE ;  et on convertit en flottant 
	jsr $F4A5 ;  convertit ACC1 en dÈcimal 
	lda #$00 ; indexe BUFTRV (INUTILE ! AY l'indexe dÈj‡ 
	ldy #$01 ; en sortie de conversion dÈcimal !!) 
	jmp $C7A8 ;  et affiche le nombre 



C330 A2 00 LDX #$00 banque 0 ($0650)
C332 20 5E 06 JSR $065E
C335 A2 06 LDX #$06 banque 6
C337 20 5E 06 JSR $065E on affiche le copyright et on execute
C33A CA DEX execute si une banque le demande.
C33B D0 FA BNE $C337
C33D 60 RTS
C33E BD 00 02 LDA $0200,X on prend l'octet de definition de la banque X
C341 10 22 BPL $C365 y-a-t-il un copyright a afficher ?
C343 8E 21 03 STX $0321 oui, on force la banque X
C346 AD F8 FF LDA $FFF8 on stocke l'adresse du copyright dans RESB
C349 85 02 STA $02
C34B AD F9 FF LDA $FFF9
C34E 85 03 STA $03
C350 A0 00 LDY #$00
C352 8E 21 03 STX $0321 on force la banque X
C355 B1 02 LDA ($02),Y on lit le copyright
C357 48 PHA
C358 A9 07 LDA #$07 banque 7
C35A 8D 21 03 STA $0321
C35D 68 PLA
C35E F0 05 BEQ $C365 est-ce 0 ?
C360 00 10 BRK $10 non, on affiche et on continue
C362 C8 INY
C363 D0 ED BNE $C352
C365 BD 00 02 LDA $0200,X
C368 0A ASL le programme doit-il se lancer automatiquement
C369 10 17 BPL $C382 non
C36B 8E 21 03 STX $0321
C36E AD FC FF LDA $FFFC on lit l'adresse d'execution
C371 AC FD FF LDY $FFFD
C374 8D FE 02 STA $02FE dans VAPLIC
C377 8C FF 02 STY $02FF
C37A 8E FD 02 STX $02FD
C37D A9 07 LDA #$07 on force banque 7
C37F 8D 21 03 STA $0321 et on sort
C382 60 RTS
C383 4C 00 00 JMP $0000 vecteur non repertorie
C386 BYT 07,92,C3 $C392, banque 7, adresse par defaut du RESET a chaud
C389 4C 00 00 JMP $0000 vecteur non repertorie
C38C 4C 06 04 JMP $0406 vecteur IRQ
C38F BYT 80,00,00 valeur nulle du APLIC, banque et adresse.
23
NMI PAR DEFAUT
Action : Cette routine est executee si on actionne le poussoir NMI (RESET a chaud) avant
qu'une application ait ete lancee. Elle affiche la fameuse "Logiciel ecrit par Fabrice
BROCHE" qui ne peut que nous rappeler la non moins fameuse "SOFTWARE BY
PETER HALFORD AND ANDY BROWN" de la ROM V1.0.
C392 A9 33 LDA #$33 indexe "Logiciel. . . "
C394 A0 C4 LDY #$C4
C396 00 14 BRK $14 affiche
C398 4C 98 C3 JMP $C398 et boucle indefiniment.
CODES ET CHAINES DIVERSES
Usage : ces codes sont utilises lors de l'initialisation par un RESET ou un NMI.
C39B BYT 0C code CLS
C39C BYT 96,95,94,93,92,91,90 codes de couleurs degrades
C3A4 BYT " TELESTRAT "
C3AF BYT 90,91,92,93,94,95,96 codes de couleurs
C3B8 BYT 00 terminateur de chaine
C3B9 BYT " Ko RAM, ",00
C3C2 BYT " Ko ROM",CR,LF,00
C3CC BYT " Drive:",00
C3D3 BYT CR,LF,"TELEMON V2.4
C3E1 BYT CR,LF,"c 1986 "
C3EC BYT "ORIC International"
C3FE BYT CR,LF,00
C401 BYT LF,"Imprimante",00
C40D BYT 1B,3A,69,43,11,00 ESC,PRO2,START,ROULEAU,Con-instructions VDT
C413 BYT 1B,3A,6A,43,14,00 ESC,PRO2,STOP,ROULEAU,Coff
C419 BYT 8C code clignotant
C41A BYT "Inserez une disquette",00
C430 BYT CR,18,00
C433 BYT "Logiciel ecrit par Fabrice BROCHE",00
C455 BYT "BONJOUR","COM
C45F BYT 80,4F,C7,52,58 racine du generateur aleatoire, soit
0,811630249
ZONE A TRANSFERER EN B800
Action : Charge le STRASED s'il y a lieu et execute l'amorce du SED (programme
situe a la fin du premier secteur de SED)
24
C464 A9 E8 LDA #$E8 %11101000 soit banque 0
C466 8D 21 03 STA $0321 dans V2DRA
C469 A9 00 LDA #$00
C46B A0 C1 LDY #$C1
C46D 85 00 STA $00 $C100 dans RES
C46F 84 01 STY $01
C471 A2 01 LDX #$01 on lit piste 0 secteur 1
C473 8E 12 03 STX $0312 1 dans le registre de secteur
C476 20 4F B8 JSR $B84F on lit le secteur
C479 AD 00 C1 LDA $C100 on prend l'indicateur
C47C D0 2F BNE $C4AD est-ce le bon SED ?
C47E AD 03 C1 LDA $C103 oui, on lit l'adresse
C481 AC 04 C1 LDY $C104 ou il faut charger le SED
C484 85 00 STA $00 dans RES
C486 84 01 STY $01
C488 EC 01 C1 CPX $C101 a-t-on lu toute la piste ?
C48B D0 09 BNE $C496 non
C48D A9 58 LDA #$58 oui, %01011000
C48F 20 6D B8 JSR $B86D soit deplacer la tete d'une piste
C492 A2 00 LDX #$00 compteur de secteur a 0
C494 EA NOP tss tss
C495 EA NOP
C496 E8 INX on lit un secteur du SED
C497 8E 12 03 STX $0312
C49A 20 4F B8 JSR $B84F
C49D E6 01 INC $01 on passe a la page suivante
C49F CE 02 C1 DEC $C102 a-t-on fait tous les secteurs du SED ?
C4A2 D0 E4 BNE $C488 non
C4A4 20 05 C1 JSR $C105 oui, on execute l'amorce du SED
C4A7 AD FB FF LDA $FFFB on lit l'etat de la banque
C4AA 8D 00 02 STA $0200 dans l'octet de STATUS banque 0
C4AD A9 EF LDA #$EF et on repasse sur la banque 7
C4AF 8D 21 03 STA $0321
C4B2 60 RTS
C4B3 A9 88 LDA #$88 %10001000 dans FDCCR
C4B5 8D 10 03 STA $0310 soit lire un secteur
C4B8 A0 04 LDY #$04
C4BA 88 DEY delai pour attendre la fin de la lecture
C4BB D0 FD BNE $C4BA
C4BD AD 10 03 LDA $0310 on lit le registre de commande
C4C0 4A LSR operation terminee ?
C4C1 90 1E BCC $C4E1 oui
C4C3 AD 18 03 LDA $0318 non, est-on en DATA READY ?
C4C6 30 F5 BMI $C4BD non, on boucle
C4C8 AD 13 03 LDA $0313 oui, on lit le numero de piste
C4CB 91 00 STA ($00),Y dans le buffer
C4CD C8 INY et on pointe sur la position suivante
C4CE 4C 5F B8 JMP $B85F pourquoi pas BNE ???
C4D1 8D 10 03 STA $0310 ($B86D) on envoie la commande A
C4D4 A0 03 LDY #$03 on attend la reponse
C4D6 88 DEY
C4D7 D0 FD BNE $C4D6
C4D9 AD 10 03 LDA $0310 ordre traite
25
C4DC 4A LSR
C4DD B0 FA BCS $C4D9 non
C4DF 60 RTS oui, on sort
C4E0 EA NOP
C4E1 AD 10 03 LDA $0310 on lit le retour
C4E4 29 1C AND #$1C y-a-t-il une erreur ?
C4E6 F0 F7 BEQ $C4DF non, RTS
C4E8 D0 C9 BNE $C4B3 oui, on recommence
ROUTINES DE GESTION DES BUFFER
Principe : x contient le numero du buffer, A la donnee et AY s'il y a deux donnees
+ pour lire une donnee V=0 C=0
+ pour ecrire une donnee V=1 C=0
+ pour initialiser un buffer V=0 C=1
+ pour vider un buffer V=1 C=1 Z=1
+ pour tester un buffer V=1 C=1 Z=0
BUFFER PAR DEFAUT
C4EA 86 02 STX $02 on sauve l'index du buffer
C4EC 8A TXA
C4ED A2 FF LDX #$FF on calcule la position des 4 octets
C4EF 38 SEC de definition du buffer X
C4F0 E9 03 SBC #$03
C4F2 E8 INX
C4F3 B0 FA BCS $C4EF
C4F5 BD AF C6 LDA $C6AF,X on lit l'adresse de debut
C4F8 85 00 STA $00 dans RES
C4FA BD B0 C6 LDA $C6B0,X
C4FD 85 01 STA $01
C4FF BD B1 C6 LDA $C6B1,X et l'adresse de fin (non incluse dans le buffer)
C502 BC B2 C6 LDY $C6B2,X dans AY
C505 A6 02 LDX $02 et on initialise
INITIALISE UN BUFFER
C507 2C 18 C5 BIT $C518 adresse de debut dans RES
C50A 50 08 BVC $C514 adresse de fin dans AY
26
VIDE UN BUFFER
C50C A9 00 LDA #$00
C50E 2C BYT $2C
TESTE UN BUFFER
C50F A9 01 LDA #$01
C511 2C 24 C5 BIT $C524
C514 38 SEC
C515 4C 09 04 JMP $0409
LIT UNE DONNEE DANS UN BUFFER
C518 2C 18 C5 BIT $C518
C51B 50 03 BVC $C520
ECRIT UNE DONNEE DANS UN BUFFER
C51D 2C 24 C5 BIT $C524
C520 18 CLC
C521 4C 09 04 JMP $0409
ROUTINE A TRANSFERER EN $0400
Action : la page 4 contient les routines d'interfacage avec les banques.
Les routines sont les suivantes :
$0400 : termine une IRQ non BRK
$0403 : termine une IRQ BRK
$0406 : vecteur terminal des IRQ
$040C : EXBNK execution d'une routine sur une banque donnee
$0411 : lecture d'un octet sur la banque contenant le BRK
Tous les vecteurs peuvent bien sur etre detournes, a condition bien sur de respecter le
protocole.
C524 4C 93 04 JMP $0493 $0400 . fin d'IRQ
C527 4C A1 04 JMP $04A1 $0403 . fin de BRK
C52A 4C 7E 04 JMP $047E $0406 . IRQ EXBNK
C52D 4C 19 04 JMP $0419 $0409 . gestion des buffers
C530 4C 36 04 JMP $0436 $040C . gestion des banques
27
C533 RES 1 $040F . tampon pour banque lors d'IRQ
C534 RES 1 $0410 . tampon pour banque lors de BRK
C535 4C AF 04 JMP $04AF $0411 . lecture d'une donnee Durant BRK
C538 4C 00 00 JMP $0000 $0414 . vecteur d'execution inter-banque VEXBNK
C53B RES 1 $0417 . banque cible pour $040C BNKCIB
C53C RES 1 $0418 . pointeur de pile des banques
C53D 08 PHP ($0419) on sauve P
C53E 78 SEI car on interdit les interruptions
C53F 48 PHA
C540 AD 21 03 LDA $0321 on force la banque 0
C543 29 F8 AND #$F8 (RAM) car les buffers
C545 8D 21 03 STA $0321 sont en RAM
C548 68 PLA
C549 20 00 C5 JSR $C500 et on execute la routine des buffers
C54C A8 TAY on preserve la donnee
C54D AD 21 03 LDA $0321
C550 09 07 ORA #$07 on repasse sur la banque 7
C552 8D 21 03 STA $0321
C555 6A ROR on preserve C
C556 28 PLP
C557 0A ASL
C558 98 TYA C et A sont representatifs du resultat
C559 60 RTS
C55A 08 PHP ($0436)
C55B 78 SEI
C55C 48 PHA on sauve A et X
C55D 8A TXA
C55E 48 PHA
C55F AD 21 03 LDA $0321 on sauve la banque actuelle dans la pile locale
C562 AE 18 04 LDX $0418 dont le pointeur est en $0418
C565 9D C8 04 STA $04C8,X
C568 EE 18 04 INC $0418
C56B 68 PLA
C56C AA TAX
C56D AD 17 04 LDA $0417 A = banque cible
C570 20 6A 04 JSR $046A on force la banque A
C573 68 PLA
C574 28 PLP
C575 20 14 04 JSR $0414 on execute le vecteur VEXBNK
C578 08 PHP
C579 78 SEI
C57A 48 PHA
C57B 8A TXA
C57C 48 PHA
C57D CE 18 04 DEC $0418 on restaure la banque d'avant
C580 AE 18 04 LDX $0418 l'appel
C583 BD C8 04 LDA $04C8,X
C586 20 6A 04 JSR $046A
C589 68 PLA
C58A AA TAX
C58B 68 PLA
C58C 28 PLP et on sort avec A, X, Y et P preserves et
28
C58D 60 RTS representatives de l'appel
C58E 08 PHP ($046A)
C58F 78 SEI
C590 29 07 AND #$07 il n'y a que 7 banques . . .
C592 8D C7 04 STA $04C7 dans une variable temporaire
C595 AD 21 03 LDA $0321
C598 29 F8 AND #$F8 on force la banque A
C59A 0D C7 04 ORA $04C7
C59D 8D 21 03 STA $0321
C5A0 28 PLP
C5A1 60 RTS
C5A2 85 21 STA $21 ($047E) on sauve A
C5A4 AD 21 03 LDA $0321 on force la banque 7
C5A7 29 07 AND #$07
C5A9 8D 0F 04 STA $040F apres avoir sauve la banque courante
C5AC AD 21 03 LDA $0321
C5AF 09 07 ORA #$07
C5B1 8D 21 03 STA $0321
C5B4 4C 68 C8 JMP $C868 et on execute les IRQ
C5B7 AD 21 03 LDA $0321 ($0493)
C5BA 29 F8 AND #$F8 on restaure la banque par $040F
C5BC 0D 0F 04 ORA $040F donc en sortie d'IRQ
C5BF 8D 21 03 STA $0321
C5C2 A5 21 LDA $21 on recupere A
C5C4 40 RTI et on sort
C5C5 48 PHA ($04A1)
C5C6 AD 21 03 LDA $0321 on force la banque selon
C5C9 29 F8 AND #$F8 le contenu de $0410
C5CB 0D 10 04 ORA $0410
C5CE 8D 21 03 STA $0321 tout en preservant A
C5D1 68 PLA
C5D2 60 RTS
C5D3 AD 21 03 LDA $0321 ($04AF) on force la banque selon $0410
C5D6 29 F8 AND #$F8 sauve par BRK
C5D8 0D 10 04 ORA $0410
C5DB 8D 21 03 STA $0321
C5DE B1 15 LDA ($15),Y on lit l'octet pointe indirectement
C5E0 48 PHA sur la banque de l'appelant
C5E1 AD 21 03 LDA $0321 on repasse sur la banque 7
C5E4 09 07 ORA #$07
C5E6 8D 21 03 STA $0321
C5E9 68 PLA et on sort avec la donnee lue dans A
C5EA 60 RTS
29
ROUTINE A TRANSFERER EN $0700
Action : Cette routine normalisee selon la gestion d'E/S, gere les buffers integres du
TELESTRAT (clavier, serie in/out, parallele) mais aussi les buffers crees par
l'utilisateur.
Le protocole est ainsi fait :
C=0 V=0 lecture dans A (C=1 si buffer vide)
V=1 ecriture de A (C=1 si buffer plein)
C=1 V=0 initialise un buffer (en sortie, A=0, Y=255, Z=1)
V=1 Z=0 teste le buffer (C=1 si vide)
Z=1 vide le buffer (A et P comme pour C=1/V=0)
En sortie, en regle generale, C est a 1 si l'operation ne s'est pas deroulee correctement
(buffer plein en ecriture, vide en lecture, etc . . . )
C5EB 90 4C BCC $C639 si C=0, c'est une lecture/ecriture
C5ED 50 0F BVC $C5FE C=1 si V=0 on initialise un buffer
C5EF A8 TAY
C5F0 F0 2C BEQ $C61E C=1 V=1 si Z=1 on vide le buffer
C5F2 BD 88 C0 LDA $C088,X sinon, on teste le buffer
C5F5 1D 89 C0 ORA $C089,X longueur = 0
C5F8 F0 02 BEQ $C5FC oui C=1
C5FA 18 CLC non C=0
C5FB 60 RTS
C5FC 38 SEC
C5FD 60 RTS
C5FE 85 02 STA $02 on initialise avec fin+1 dans RESB
C600 84 03 STY $03
C602 38 SEC
C603 E5 00 SBC $00 fin-debut
C605 9D 8A C0 STA $C08A,X dans longueur du buffer
C608 98 TYA
C609 E5 01 SBC $01
C60B 9D 8B C0 STA $C08B,X
C60E 8A TXA
C60F 69 03 ADC #$03
C611 AA TAX
C612 A0 03 LDY #$03
C614 B9 00 00 LDA $0000,Y pourquoi pas LDA $00,Y ? etiquette peut-etre
C617 9D 7F C0 STA $C07F,X on place adresse de debut et de fin (exclue)
C61A CA DEX
C61B 88 DEY
C61C 10 F6 BPL $C614
C61E A9 00 LDA #$00 vide le buffer
C620 9D 88 C0 STA $C088,X longueur de fin
C623 9D 89 C0 STA $C089,X
C626 BD 82 C0 LDA $C082,X adresse de fin
C629 9D 84 C0 STA $C084,X dans pointeur de lecture
C62C 9D 86 C0 STA $C086,X et pointeur d'ecriture
30
C62F BD 83 C0 LDA $C083,X
C632 9D 85 C0 STA $C085,X
C635 9D 87 C0 STA $C087,X
C638 60 RTS et on sort
C639 70 26 BVS $C661 C=0 si V=1 on ecrit
C63B 20 07 C5 JSR $C507 sinon, lecture buffer vide ?
C63E B0 20 BCS $C660 oui on sort C=1
C640 BD 86 C0 LDA $C086,X prend pointeur de lecture dans AY
C643 BC 87 C0 LDY $C087,X
C646 20 A6 C5 JSR $C5A6 on calcule la prochaine position de lecture
C649 9D 86 C0 STA $C086,X dans le pointeur de lecture
C64C 98 TYA
C64D 9D 87 C0 STA $C087,X
C650 BD 88 C0 LDA $C088,X on decremente le pointeur d'ecriture
C653 D0 03 BNE $C658
C655 DE 89 C0 DEC $C089,X
C658 DE 88 C0 DEC $C088,X
C65B A0 00 LDY #$00 on lit le code dans A
C65D B1 24 LDA ($24),Y
C65F 18 CLC lecture OK, C=0
C660 60 RTS
C661 48 PHA
C662 BD 88 C0 LDA $C088,X longueur utilisee < longueur du buffer ?
C665 DD 8A C0 CMP $C08A,X
C668 BD 89 C0 LDA $C089,X
C66B FD 8B C0 SBC $C08B,X
C66E B0 1F BCS $C68F non, on recupere la donnee et on sort
C670 BD 84 C0 LDA $C084,X on calcule la prochaine position
C673 BC 85 C0 LDY $C085,X d'ecriture
C676 20 A6 C5 JSR $C5A6
C679 9D 84 C0 STA $C084,X dans le pointeur d'ecriture
C67C 98 TYA
C67D 9D 85 C0 STA $C085,X
C680 FE 88 C0 INC $C088,X on ajoute 1 a la longueur utilisee
C683 D0 03 BNE $C688
C685 FE 89 C0 INC $C089,X
C688 A0 00 LDY #$00
C68A 68 PLA
C68B 91 24 STA ($24),Y on ecrit la donnee
C68D 18 CLC C=0 et A est intact
C68E 60 RTS
C68F 68 PLA ecriture ratee, C=1, A restaure
C690 60 RTS
C691 18 CLC ($C5A6)
C692 69 01 ADC #$01 on incremente l'adresse AY
C694 90 01 BCC $C697
C696 C8 INY
C697 DD 82 C0 CMP $C082,X
C69A 85 24 STA $24 AY < adresse de fin ?
C69C 98 TYA
C69D FD 83 C0 SBC $C083,X
31
C6A0 90 08 BCC $C6AA oui dans $24-$25
C6A2 BD 80 C0 LDA $C080,X non, on prend l'adresse de debut du buffer
C6A5 BC 81 C0 LDY $C081,X
C6A8 85 24 STA $24 dans $24-$25
C6AA 84 25 STY $25
C6AC A5 24 LDA $24 AY contient l'adresse de la prochaine
C6AE 60 RTS position dans le buffer
ADRESSES DES BUFFERS
Contenu : deux adresses definissent l'adresse de debut et de fin (exclue) par defaut. Les buffers
utilisateurs n'ont pas de valeur par defaut, donc si on tente de leur rendre une valeur
par defaut, cette valeur sera prise dans la routine suivante !!!
C6AF BYT $C5C4,$C680 buffer clavier
C6B3 BYT $C680,$C800 buffer entree serie ACIA/MINITEL
C6B7 BYT $C800,$CA00 buffer sortie serie ACIA/MINITEL
C6BB BYT $CA00,$D200 buffer sortie parallele (imprimante)
TESTE SI L'IMPRIMANTE EST BRANCHEE
Principe : On genere un STROBE et on attend la reponse (ACKnowledge) de l'imprimante. Si
un ACK est lu, l'imprimante est bien branchee.
C6BF A2 00 LDX #$00 on met un 0 sur le port A
C6C1 8E 01 03 STX $0301 du VIA 1
C6C4 AD 00 03 LDA $0300 on force PB4 a 0
C6C7 29 EF AND #$EF %11101111, soit pas de STROBE
C6C9 8D 00 03 STA $0300 on depose B sur le bus
C6CC 09 10 ORA #$10 puis on genere un STROBE par PB4
C6CE 8D 00 03 STA $0300
C6D1 AD 0D 03 LDA $030D on lit IFR
C6D4 29 02 AND #$02 transition CA1 (ACK) ?
C6D6 D0 04 BNE $C6DC oui, l'imprimante est branchee
C6D8 CA DEX non
C6D9 D0 F6 BNE $C6D1 on fait le test 256 fois pour etre sur
C6DB 60 RTS et on sort si l'imprimante n'a pas repondu
C6DC AD 0D 02 LDA $020D
C6DF 09 02 ORA #$02 on indique imprimante detectee
C6E1 8D 0D 02 STA $020D dans FLGTEL
C6E4 60 RTS et on sort
32
OUVRIR UNE E/S SUR UN CANAL
Principe : X contient 4 fois le numero du canal (4 E/S par canal) et A le numero de l'E/S a
ouvrir. Si elle est deja ouverte sur ce canal, on sort. Sinon, on verifie si elle est deja
ouverte sur un des autres canaux. Si ce n'est pas le cas, on l'active avant de l'ouvrir
sur le canal. En sortie, C=0 si l'E/S a ete ouverte, C=1 si elle etait deja ouverte.
C6E5 A2 00 LDX #$00 pour canal 0
C6E6 BYT $2C sauter l'instruction suivante
C6E7 A2 04 LDX #$04 pour canal 1
C6E9 BYT $2C sauter l'instruction suivante
C6EA A2 08 LDX #$08 pour canal 2
C6EC BYT $2C sauter l'instruction suivante
C6ED A2 0C LDX #$0C pour canal 3
C6F0 48 PHA on sauve l'E/S
C6F1 68 PLA on lit l'E/S
C6F2 DD AE 02 CMP $02AE,X est-elle deja ouverte sur le canal en question
C6F5 F0 0D BEQ $C704 oui C=1 et on sort
C6F7 BC AE 02 LDY $02AE,X le canal est-il sature ?
C6FA 10 09 BPL $C705 non, on peut ouvrir l'E/S
C6FC E8 INX
C6FD 48 PHA
C6FE 8A TXA
C6FF 29 03 AND #$03 on teste les 4 E/S du canal
C701 D0 EE BNE $C6F1
C703 68 PLA
C704 60 RTS En sortie, A contient l'E/S
C705 A0 0F LDY #$0F pour 4*4 E/S possibles
C707 D9 AE 02 CMP $02AE,Y l'E/S est-elle ouverte sur un des 4 canaux ?
C70A F0 0F BEQ $C71B oui, on ouvre simplement l'E/S sur le canal
C70C 88 DEY
C70D 10 F8 BPL $C707
C70F 86 19 STX $19 on sauve le numero du canal
C711 48 PHA
C712 A0 80 LDY #$80 N=1 Z=0
C714 AA TAX
C715 20 1C C8 JSR $C81C on active l'E/S dans X
C718 A6 19 LDX $19 on recupere l'index
C71A 68 PLA l'E/S
C71B 9D AE 02 STA $02AE,X et on ouvre l'E/S
C71E 18 CLC C=0
C71F 60 RTS
33
FERMER UNE E/S SUR UN CANAL
Principe : identique a l'ouverture, si ce n'est que si une E/S n'etait ouverte que sur ce canal, elle
est desactivee.
De plus C n'a pas de valeur particuliere en sortie.
Si A contient la valeur 0, toutes les E/S sont fermees sur le canal en question.
C720 A2 00 LDX #$00 index canal 0
C722 BYT $2C sauter instruction suivante
C723 A2 04 LDX #$04 index canal 1
C725 BYT $2C sauter instruction suivante
C726 A2 08 LDX #$08 index canal 2
C728 BYT $2C sauter instruction suivante
C729 A2 0C LDX #$0C index canal 3
C72B A0 03 LDY #$03 pour 4 E/S
C72D C9 00 CMP #$00 doit-t-on fermer toutes les E/S ?
C72F F0 1D BEQ $C74E oui
C731 DD AE 02 CMP $02AE,X l'E/S est-elle ouverte ?
C734 F0 05 BEQ $C73B oui
C736 E8 INX
C737 88 DEY
C738 10 F7 BPL $C731
C73A 60 RTS l'E/S n'etait pas ouverte
C73B 5E AE 02 LSR $02AE,X on ferme l'E/S
C73E A2 0F LDX #$0F si l'E/S n'est ouverte sur aucun
C740 DD AE 02 CMP $02AE,X autre canal.
C743 F0 F5 BEQ $C73A
C745 CA DEX
C746 10 F8 BPL $C740
C748 AA TAX
C749 A0 81 LDY #$81 N=1 C=1 V=0
C74B 4C 1C C8 JMP $C81C on desactive l'E/S
C74E 5E AE 02 LSR $02AE,X on ferme les 4 E/S sur le canal
C751 E8 INX
C752 88 DEY
C753 10 F9 BPL $C74E
C755 60 RTS et on sort
SAUTER UNE LIGNE SUR LE CANAL 0
C756 A9 0A LDA #$0A on envoie un CR (ASCII 13)
C758 20 5D C7 JSR $C75D sur le canal 0
C75B A9 0D LDA #$0D et un LF (ASCII 11)
34
ENVOYER UN CODE SUR UN CANAL
Principe : pour ne pas detruire les registres, on sauve la donnee a ecrire et on met dans A 4 fois
le numero du canal. On envoie la donnee ensuite a toutes les E/S ouvertes sur le
canal.
Pour ecrire une donnee sur une E/S, N=0 et C=1 avec la donnee dans A.
C75D 48 PHA on sauve la donnee
C75E A9 00 LDA #$00 index canal 0
C760 F0 0D BEQ $C76F inconditionnel
C762 48 PHA
C763 A9 04 LDA #$04 index canal 1
C765 D0 08 BNE $C76F
C767 48 PHA
C768 A9 08 LDA #$08 index canal 2
C76A D0 03 BNE $C76F
C76C 48 PHA
C76D A9 0C LDA #$0C index canal 3
C76F 85 19 STA $19 on sauve le numero du canal
C771 68 PLA
C772 85 1B STA $1B et la donnee
C774 A9 04 LDA #$04
C776 85 1A STA $1A pour 4 E/S a tester
C778 8A TXA on sauve X et Y
C779 48 PHA
C77A 98 TYA
C77B 48 PHA
C77C A6 19 LDX $19 donnee dans X
C77E BD AE 02 LDA $02AE,X l'E/S est elle une sortie ?
C781 C9 88 CMP #$88
C783 90 16 BCC $C79B non, on passe
C785 0A ASL
C786 AA TAX
C787 BD BE 02 LDA $02BE,X oui, on met son adresse dans
C78A 8D F8 02 STA $02F8 $02F8 - $02F9
C78D BD BF 02 LDA $02BF,X
C790 8D F9 02 STA $02F9
C793 A5 1B LDA $1B donnee dans A
C795 2C 95 C7 BIT $C795 N=0 C=1
C798 20 F7 02 JSR $02F7 on ecrit la donnee sur l'E/S
C79B E6 19 INC $19
C79D C6 1A DEC $1A
C79F D0 DB BNE $C77C et on scrute 4 E/S
C7A1 68 PLA
C7A2 A8 TAY
C7A3 68 PLA on recupere A, X et Y
C7A4 AA TAX
35
C7A5 A5 1B LDA $1B
C7A7 60 RTS
ENVOIE UNE SERIE DE CODES SUR UN CANAL
Principe : On envoie en fait les codes un par un, une boucle sur le canal. Etant sur la banque 7,
pour lire les donnees sur la banque d'appel, on stocke l'adresse en $15-$16 et on
utilise $0411. En entree, la serie de codes, terminee par un 0, est a l'adresse AY.
C7A8 A2 00 LDX #$00 on index le canal 0
C7AA BYT $2C et on saute l'instruction suivante
C7AB A2 04 LDX #$04 on index le canal 1
C7AD BYT $2C et on saute l'instruction suivante
C7AE A2 08 LDX #$08 on index le canal 2
C7B0 BYT $2C et on saute l'instruction suivante
C7B1 A2 0C LDX #$0C on index le canal 3
C7B3 86 1C STX $1C on sauve le canal
C7B5 85 15 STA $15 et l'adresse de la chaine
C7B7 84 16 STY $16
C7B9 A5 1C LDA $1C
C7BB 85 19 STA $19 on positionne le canal
C7BD A0 00 LDY #$00 Y=0 pour adressage indirect
C7BF 20 11 04 JSR $0411 et on lit un octet
C7C2 F0 E3 BEQ $C7A7 est-ce 0 ? oui on sort
C7C4 20 72 C7 JSR $C772 non, on l'affiche directement
C7C7 E6 15 INC $15 on incremente l'adresse
C7C9 D0 EE BNE $C7B9 et on boucle
C7CB E6 16 INC $16
C7CD D0 EA BNE $C7B9 inconditionnel
LIRE UN CODE SUR UN CANAL
Principe : On indexe le canal comme d'habitude et on positionne N a 0 et C a 0 avant l'appel a
chaque routine d'E/S. Des qu'une donnee est lue, on sort sans scruter les autres E/S.
Ce qui fait qu'une E/S ouverte avant une autre est prioritaire.
Comme pour la routine d'ecriture, les registres A, X et Y sont conserves. En sortie,
C=0 si une donnee a ete lue, C=1 sinon.
C7CF A9 00 LDA #$00 on index canal 0
C7D1 BYT $2C sauter l'instruction suivante
C7D2 A9 04 LDA #$04 on index canal 1
C7D4 BYT $2C on saute . . .
C7D5 A9 08 LDA #$08 on index canal 2
C7D7 BYT $2C on saute . . .
36
C7D8 A9 0C LDA #$0C on index canal 3
C7DA 85 19 STA $19 on sauve le canal
C7DC A9 04 LDA #$04 pour 4 E/S
C7DE 85 1A STA $1A
C7E0 8A TXA on sauve les registres
C7E1 48 PHA
C7E2 98 TYA
C7E3 48 PHA
C7E4 A6 19 LDX $19
C7E6 BD AE 02 LDA $02AE,X y a-t-il une E/S ouverte ?
C7E9 10 0E BPL $C7F9 non, suivante
C7EB C9 88 CMP #$88 oui, une entree ?
C7ED B0 0A BCS $C7F9 non, suivante
C7EF AA TAX on prend l'index
C7F0 A0 40 LDY #$40 N=0 V=1 C=0
C7F2 20 1C C8 JSR $C81C on lit la donnee
C7F5 85 1D STA $1D et on la sauve
C7F7 90 06 BCC $C7FF C=0, on sort si une donnee a ete lue
C7F9 E6 19 INC $19
C7FB C6 1A DEC $1A
C7FD D0 E5 BNE $C7E4 on scrute les 4 E/S si besoin est
C7FF 68 PLA on recupere X et Y
C800 A8 TAY
C801 68 PLA
C802 AA TAX
C803 A5 1D LDA $1D et la donnee
C805 60 RTS C=1 si aucune donnee n'est lue
ATTENDRE UN CODE SUR UN CANAL
Principe : on lit un code jusqu'a ce qu'un code soit veritablement lu . . . Cette routine est baclee
en deux points. D'une part le STA/LDA qui aurait avantageusement pu etre remplace
par TAX/TXA puisque X et Y ne sont pas modifies, et d'autre part le SEC final qui
met C a 1 en sortie alors que le protocole observe jusqu'ici donnait C=0 pour une
operation correctement executee. . .
C806 A9 00 LDA #$00 indexer canal 0
C808 BYT $2C sauter instruction suivante
C809 A9 04 LDA #$04 indexer canal 1
C80B BYT $2C et passer . . .
C80C A9 08 LDA #$08 indexer canal 2
C80E BYT $2C et passer . . .
C80FA9 0C LDA #$0C indexer canal 3
C811 85 1B STA $1B on sauve le canal
C813 A5 1B LDA $1B pourquoi pas TAX/TXA ? 2 octets de perdus . .
C815 20 DA C7 JSR $C7DA on lit un code
37
C818 B0 F9 BCS $C813 si pas de code lu, on boucle
C81A 38 SEC sinon, C=1, ca cloche !
C81B 60 RTS
ENVOYER UNE COMMANDE A UNE E/S
Principe : Y contient de quoi influencer N,V et C et X contient le numero de l'E/S a activer.
Pour l'activation, on place l'adresse de l'E/S dans le vecteur $02F8-$02F9 et on se
branche dessus.
Pour lire une donnee : Y=%0100000, pour fermer l'E/S, Y=%10000001 et pour
ouvrir l'E/S, Y=%10000000. Curieusement, suite a un manque d'optimisation
flagrant, cette routine ne sert pas a la lecture d'une donnee, ce qui fait perdre a la
routine $C75D et qui remet en question la presence du PHA/PLA.
C81C 84 17 STY $17 on sauve la commande
C81E 84 18 STY $18
C820 48 PHA et la donnee (pourquoi ???)
C821 8A TXA
C822 0A ASL on multiplie le numero de l'E/S par deux
C823 AA TAX
C824 BD BE 02 LDA $02BE,X et on prepare le saut a l'adresse
C827 8D F8 02 STA $02F8 de gestion de l'E/S
C82A BD BF 02 LDA $02BF,X
C82D 8D F9 02 STA $02F9
C830 68 PLA on recupere la donnee
C831 46 17 LSR $17 on positionne C
C833 24 18 BIT $18 N et V
C835 4C F7 02 JMP $02F7 et on execute la routine de l'E/S
TABLE DES ROUTINES D'E/S
Remarque : Les vecteurs sans valeurs pointent sur SEC/RTS, donc l'operation s'est mal
deroulee. Ce qui est clair.
C838 WRD $D95C routine KBD gestion du clavier
C83A WRD $C81A rien
C83C WRD $DAF7 routine MDE entree Minitel
C83E WRD $DB5D routine RSE entree RS232
C840 WRD $C81A rien (aurait du etre MIE, entree MIDI)
C842 WRD $C81A rien
C844 WRD $C81A rien (US 1 libre pour l'utilisateur)
C846 WRD $C81A rien (US 2 libre pour l'utilisateur)
C848 WRD $DB86 routine SCR ecran fenetre 0
C84A WRD $DB8C routine SC1 fenetre 1
C84C WRD $DB92 routine SC2 fenetre 2
C84E WRD $DB98 routine SC3 fenetre 3
38
C850 WRD $C81A rien (aurait du etre MIS, sortie MIDI)
C852 WRD $C81A rien
C854 WRD $DA70 routine LPR sortie CENTRONICS parallele
C856 WRD $DB12 routine MDS sortie Minitel
C858 WRD $DB79 routine RSS sortie RS232
C85A WRD $D5C6 routine VDT sortie HIRESS emulation Videotex
C85C WRD $C81A rien
C85E WRD $C81A rien
C860 WRD $C81A rien (US 4 libre pour l'utilisateur)
C862 WRD $C81A rien (US 5 libre pour l'utilisateur)
C864 WRD $C81A rien (US 6 libre pour l'utilisateur)
C866 WRD $C81A rien (US 7 libre pour l'utilisateur)
TRAITEMENT DU BRK
Principe : Trivial mais o combien genial ! Seul un farfelu comme BROCHE pouvait y penser.
L'appel a une routine du moniteur se fait non pas par des JMP mais par le BRK qui
pour l'occasion devient une instruction page 0.
Voici le principal :
- Apres un BRK, donc a l'entree de la routine, la pile contient dans l'ordre d'entree
PC+2 (PC est l'adresse exacte du BRK) et P.
- On depile P que l'on sauve car on en aura besoin pour le RTI.
- On enleve 1 a l'adresse de retour de l'IRQ, donc il y a dans la pile PC+1. C'est en
PC+1 que le code de la routine se trouve, on le lit.
- On empile l'adresse de retour du BRK decrementee de 1.
- On empile l'adresse exacte de la routine.
- Et on empile P.
La routine est prete a etre executee :
- RTI : on depile P et l'adresse de la routine que l'on execute.
- RTS : fin de la routine, on depile $0402 donc on se branche en $0403.
- RTS : fin de la $0403, on depile l'adresse de retour de base que l'on a deja
decremente de 1 (par chance, le BRK sauve l'adresse d'appel+2 car a la base,
il remplacait des codes sur 2 octets le plus souvent). Le RTS incremente et se
branche, le programme se poursuit naturellement !!!
C868 86 22 STX $22 on sauve X
C86A 84 23 STY $23 on sauve Y
C86C 68 PLA
C86D 85 24 STA $24 et P dans IRQSVX, IRQSVY et $0024
C86F 29 10 AND #$10 B=1 ? (est-ce un BRK)
C871 F0 40 BEQ $C8B3 non, on passe aux IRQ systeme
C873 BA TSX on prend
C874 68 PLA on decremente l'adresse de retour
C875 D0 03 BNE $C87A car RTS incremente apres depilement
39
C877 DE 02 01 DEC $0102,X
C87A 38 SEC
C87B E9 01 SBC #$01
C87D 48 PHA
C87E 85 15 STA $15 on sauve l'adresse de retour -1
C880 BD 02 01 LDA $0102,X dans $0015-$0016 pour lire le code suivant le BRK
C883 85 16 STA $16
C885 AD 0F 04 LDA $040F on place la banque d'appel comme banque de BRK
C888 8D 10 04 STA $0410
C88B A0 00 LDY #$00
C88D 20 11 04 JSR $0411 on lit le numero de la routine appelee
C890 0A ASL *2 car une adresse a deux octets
C891 AA TAX
C892 A9 04 LDA #$04 on met dans la pile $0403-1
C894 48 PHA car on va s'y brancher par RTS
C895 A9 02 LDA #$02 pourquoi pas LSR ?
C897 48 PHA
C898 BD A5 CA LDA $CAA5,X on lit l'adresse de la routine
C89B BC A4 CA LDY $CAA4,X
C89E 90 06 BCC $C8A6 si C=1
C8A0 BD A5 CB LDA $CBA5,X on lit dans la deuxieme table car
C8A3 BC A4 CB LDY $CBA4,X le code etait > 127
C8A6 48 PHA on empile l'adresse exacte
C8A7 98 TYA car on appelle par RTI
C8A8 48 PHA on empile P (RTI oblige)
C8A9 A5 24 LDA $24
C8AB 48 PHA
C8AC A5 21 LDA $21 on prend A, X et Y
C8AE A4 23 LDY $23
C8B0 A6 22 LDX $22
C8B2 40 RTI et on execute la routine
GESTION NORMALE DES IRQ
C8B3 A5 24 LDA $24 on replace P
C8B5 48 PHA
C8B6 38 SEC
C8B7 66 1E ROR $1E on force b7 ($1E) a 1 pour indiquer premier passage
C8B9 20 BF C8 JSR $C8BF on gere la RS232 (entree et sortie)
C8BC 4C B9 C9 JMP $C9B9 et on poursuit le traitement des IRQ
GERE LA RS232
Principe : A chaque IRQ, on va tester si la ligne est libre et au cas echeant lire ou ecrire une
donnee. Si la ligne etait libre, on force b7 ($1E) a 0 afin d'indiquer qu'une donnee est
en cours de lecture ou d'ecriture. Les octets $20 et $3F servent au decompte des bits
40
lors de la transmission. De plus, avant de latcher une donnee, on teste si on l'envoie
sur une imprimante ou non. Y sort indemne de la routine.
C8BF 98 TYA on sauve Y
C8C0 48 PHA
C8C1 AD 1D 03 LDA $031D on prend l'etat de la RS232
C8C4 10 55 BPL $C91B occupee ? on saute
C8C6 46 1E LSR $1E oui, on annule b7 ($1E)
C8C8 48 PHA on sauve ACIASR
C8C9 29 08 AND #$08 b4=1 ?
C8CB F0 12 BEQ $C8DF non
C8CD AE 1C 03 LDX $031C oui, on lit la donnee
C8D0 68 PLA et l'etat
C8D1 48 PHA
C8D2 29 07 AND #$07 donÅft on isole b2 b1 b0
C8D4 F0 03 BEQ $C8D9 tout a 0 ? oui
C8D6 09 B0 ORA #$B0 non %1011000 on force les bits
C8D8 BYT $24 et on saute la suivante
C8D9 8A TXA donnee dans A
C8DA A2 0C LDX #$0C indexe buffer ACIA entree
C8DC 20 1D C5 JSR $C51D et on inscrit la donnee
C8DF 68 PLA on sort l'etat sauvegarde
C8E0 29 10 AND #$10 libre en ecriture ?
C8E2 F0 37 BEQ $C91B non
C8E4 A2 18 LDX #$18 oui, on lit le buffer ACIA sortie
C8E6 20 0F C5 JSR $C50F y-a-t-il une donnee ?
C8E9 B0 16 BCS $C901 non
C8EB AD 1D 03 LDA $031D oui, on lit l'etat
C8EE 29 20 AND #$20 ecriture possible ?
C8F0 D0 29 BNE $C91B non, on sort
C8F2 20 18 C5 JSR $C518 oui, on lit une donnee dans le buffer
C8F5 8D 1C 03 STA $031C on la depose sur le registre de donnees
C8F8 AD 1F 03 LDA $031F on envoie la
C8FB 29 07 AND #$07 pour 7 bits
C8FD 85 3F STA $3F dans $3f
C8FF 90 1A BCC $C91B inconditionnel
C901 E6 20 INC $20 si $20 non nul
C903 D0 16 BNE $C91B on sort
C905 C6 3F DEC $3F $3F non nul, on sort
C907 D0 12 BNE $C91B
C909 AD 8A 02 LDA $028A si imprimante serie, C=1
C90C 4A LSR
C90D 4A LSR
C90E 4A LSR
C90F AD 1E 03 LDA $031E on force b4 b3 de ACIA Command Register
C912 29 F3 AND #$F3
C914 90 02 BCC $C918 si imprimante centronics, on passe
C916 29 FE AND #$FE si RS232, on force b1 a 0
C918 8D 1E 03 STA $031E on place la commande
C91B 68 PLA
C91C A8 TAY on recupere Y et on sort
C91D 60 RTS
41
GESTION TIMERS, IMPRIMANTE ET CURSEUR
Principe : toutes les 0,1 secondes (en fait 4 fois toutes les 25000 É s decomptees sur T1),
l'horloge utilisateur et temps reel sont mises a jour. Si on passe une seconde, l'heure
est affichee si necessaire. L'imprimante se voit eventuellement envoyer une donnee si
elle est libre, 4 fois par secondes (ou 10 toutes les 25000 É s decomptees), on inverse
l'etat du curseur dans la fenetre courante selon les parametres de la fenetre 0. Tout va
bien si on ne travaille qu'avec la fenetre 0, mais ca bugge des qu'on jongle avec les
fenetres . . . pas tres serieux.
C91E CE 15 02 DEC $0215 faut-il gerer horloges et imprimante ?
C921 D0 50 BNE $C973 non
C923 A9 04 LDA #$04 on replace le compteur pour 1/10 de seconde
C925 8D 15 02 STA $0215
C928 2C 8A 02 BIT $028A imprimante prete ?
C92B 10 03 BPL $C930
C92D 20 2F CA JSR $CA2F oui, on gere l'imprimante
C930 A5 44 LDA $44 on decompte les dixiemes utilisateurs
C932 D0 02 BNE $C936 dans 16 bits de TIMEUD
C934 C6 45 DEC $45
C936 C6 44 DEC $44
C938 38 SEC
C939 EE 10 02 INC $0210 on compte 0,1 seconde dans l'horloge temps reel
C93C AD 10 02 LDA $0210
C93F E9 0A SBC #$0A
C941 90 30 BCC $C973 a-t-on 10 dixiemes ?
C943 8D 10 02 STA $0210 oui, on met 0
C946 2C 14 02 BIT $0214 faut-il afficher l'horloge
C949 10 03 BPL $C94E
C94B 20 75 CA JSR $CA75 oui, so do we !
C94E EE 11 02 INC $0211 on ajuste les secondes
C951 A5 42 LDA $42 et le timer utilisateur en secondes
C953 D0 02 BNE $C957 (pourquoi ?? rien ne dit qu'il concorde
C955 C6 43 DEC $43 avec l'horloge !!!)
C957 C6 42 DEC $42 donc TIMEUD et TIMEUS sont desynchronises
C959 AD 11 02 LDA $0211 60 secondes ?
C95C E9 3C SBC #$3C
C95E 90 13 BCC $C973
C960 8D 11 02 STA $0211 oui, on ajoute une minute
C963 EE 12 02 INC $0212
C966 AD 12 02 LDA $0212
C969 E9 3C SBC #$3C 60 minutes ?
C96B 90 06 BCC $C973
C96D 8D 12 02 STA $0212
C970 EE 13 02 INC $0213 oui on ajoute une heure
C973 CE 16 02 DEC $0216 faut-il gerer le curseur
C976 D0 19 BNE $C991
C978 A9 0A LDA #$0A oui, on remet le compteur de quart de secondes
C97A 8D 16 02 STA $0216
C97D AD 17 02 LDA $0217 on inverse l'etat du curseur
42
C980 49 80 EOR #$80
C982 8D 17 02 STA $0217
C985 2C 48 02 BIT $0248 test pour la fenetre 0
C988 10 07 BPL $C991 si curseur absent, on sort
C98A 70 05 BVS $C991 si curseur fixe aussi
C98C A6 28 LDX $28 on gere le curseur dans la fenetre courante
C98E 4C 2D DE JMP $DE2D (et si ce n'est pas la fenetre 0 ?!)
C991 60 RTS
GESTION DES IRQ T1 et T2
Principe : Si c'est T2 qui a declenche l'IRQ, on teste la souris.
Si c'est T1, on teste le clavier et le joystick gauche et la souris. Tant que b7($1E ) est
nul, on poursuit la transmission serie. A noter que la gestion du joystick droit n'est
que fumisterie puisqu'elle pointe sur un RTS.
C992 AD 0D 03 LDA $030D IRQ par T2 ?
C995 29 20 AND #$20
C997 F0 20 BEQ $C9B9 non, on passe sur T1
C999 AD 8F 02 LDA $028F oui, on replace la valeur de
C99C AC 90 02 LDY $0290 base (10000) dans T2
C99F 8D 08 03 STA $0308
C9A2 8C 09 03 STY $0309
C9A5 AD 8C 02 LDA $028C souris branchee ?
C9A8 4A LSR
C9A9 90 06 BCC $C9B1 non
C9AB 20 85 E0 JSR $E085 oui, on gere la souris
C9AE 4C B9 C8 JMP $C8B9 et on poursuit les IRQ
C9B1 A9 FF LDA #$FF on place le compteur largement pour
C9B3 8D 09 03 STA $0309 ne pas etre derange par une souris absente
C9B6 4C B9 C8 JMP $C8B9 et on poursuit (BNE, non ?)
C9B9 2C 0D 03 BIT $030D IRQ traitee ?
C9BC 30 0E BMI $C9CC non
C9BE 24 1E BIT $1E oui, transmission serie en cours ?
C9C0 10 07 BPL $C9C9 oui
C9C2 A6 22 LDX $22 non, on termine
C9C4 A4 23 LDY $23 normalement les IRQ
C9C6 4C 00 04 JMP $0400
C9C9 4C B6 C8 JMP $C8B6 on poursuit la transmission serie
C9CC 46 1E LSR $1E on indique transmission en cours
C9CE 2C 0D 03 BIT $030D IRQ par T1 ?
C9D1 50 4C BVC $CA1F non
C9D3 2C 04 03 BIT $0304 on annule T1L
C9D6 20 1E C9 JSR $C91E on gere les timers, l'imprimante et le curseur
C9D9 CE A6 02 DEC $02A6 $02A6=0
C9DC D0 22 BNE $CA00 non, on passe
C9DE 20 DF D7 JSR $D7DF oui, on gere le clavier
C9E1 20 BF C8 JSR $C8BF et la transmission serie
C9E4 2C 70 02 BIT $0270 b7 de $0270 ?
43
C9E7 10 07 BPL $C9F0 0, on passe
C9E9 A9 14 LDA #$14 on met 20 dans $02A7
C9EB 8D A7 02 STA $02A7
C9EE D0 0B BNE $C9FB et on saute
C9F0 AD A8 02 LDA $02A8 on prend $02A8
C9F3 2C A7 02 BIT $02A7 b7 de $02A7=1 ?
C9F6 30 05 BMI $C9FD oui, on met $02A8 dans $02A6
C9F8 CE A7 02 DEC $02A7 non
C9FB A9 01 LDA #$01 on met 1
C9FD 8D A6 02 STA $02A6 dans $02A6
CA00 2C 8C 02 BIT $028C joystick droit connecte ?
CA03 10 06 BPL $CA0B
CA05 20 FA DF JSR $DFFA on gere le joy droit (enfin, on devrait -> RTS)
CA08 2C 8C 02 BIT $028C joystick gauche ?
CA0B 50 03 BVC $CA10
CA0D 20 FB DF JSR $DFFB oui, on gere le port gauche
CA10 AD 8C 02 LDA $028C souris connectee ?
CA13 4A LSR
CA14 90 03 BCC $CA19 non
CA16 20 E1 E0 JSR $E0E1 oui, on gere la souris (double gestion donc)
CA19 4C B9 C8 JMP $C8B9 on poursuit la transmission serie
CA1C 4C 92 C9 JMP $C992 on gere les IRQ par T2
CA1F AD 0D 03 LDA $030D l'IRQ ne vient pas de T1
CA22 29 02 AND #$02 ACK imprimante ?
CA24 F0 F6 BEQ $CA1C non
CA26 2C 01 03 BIT $0301 oui, on annule le ACK
CA29 20 2F CA JSR $CA2F on gere l'imprimante
CA2C 4C B9 C8 JMP $C8B9 et on poursuit la transmission serie
GERE L'IMPRIMANTE
Principe : Lorsqu'un ACK est detecte, ou que l'imprimante est prete, lors d'une IRQ, on teste si
une donnee est dans le buffer. Dans ce cas, on l'envie et on indique imprimante
occupee. Sinon on indique imprimante libre.
CA2F A2 24 LDX #$24 indexe buffer imprimante
CA31 20 18 C5 JSR $C518 on lit une donnee
CA34 90 08 BCC $CA3E buffer vide ? non
CA36 0E 8A 02 ASL $028A oui
CA39 38 SEC on indique imprimante libre
CA3A 6E 8A 02 ROR $028A
CA3D 60 RTS et on sort
CA3E 8D 01 03 STA $0301 on met la donnee sur le port A
CA41 AD 00 03 LDA $0300 et on genere un STROBE
CA44 29 EF AND #$EF en mettant successivement a 0
CA46 8D 00 03 STA $0300
CA49 09 10 ORA #$10 et a 1 la broche PB4
CA4B 8D 00 03 STA $0300
CA4E 0E 8A 02 ASL $028A et on indique imprimante occupee
CA51 4E 8A 02 LSR $028A
CA54 60 RTS
44
REMET L'HORLOGE A 0
Principe : On met dixiemes, secondes, minutes et heures a 0 et on indique au compteur de
secondes systemes ($0215) qu'il faut ajuster l'horloge des la prochaine IRQ.
CA55 A9 00 LDA #$00 on met 0
CA57 A2 04 LDX #$04
CA59 9D 10 02 STA $0210,X dans TIMEH, TIMEM, TIMES et TIMED
CA5C CA DEX
CA5D 10 FA BPL $CA59
CA5F A9 01 LDA #$01 puis on force l'ajustement de l'horloge
CA61 8D 15 02 STA $0215 a la prochaine IRQ
CA64 60 RTS
STOPPE L'AFFICHAGE DE L'HORLOGE
CA65 4E 14 02 LSR $0214 on indique pas d'affiche dans FLGCLK
CA68 60 RTS
DEMANDE L'AFFICHAGE REGULIER DE L'HORLOGE
CA69 08 PHP on interdit les interruptions
CA6A 78 SEI pour ne pas qu'un affichage se fasse entre
CA6B 85 40 STA $40 CA6B et CA6D
CA6D 84 41 STY $41 on stocke l'adresse d'affichage dans ADCLK
CA6F 38 SEC
CA70 6E 14 02 ROR $0214 et on indique qu'il faut afficher l'horloge
CA73 28 PLP toutes les secondes
CA74 60 RTS
AFFICHE L'HORLOGE
Action : Affiche l'horloge selon ADCLK sous la forme HH:MM:SS. Aucun test n'est fait sur
ADCLK ce qui permet d'envoyer l'horloge n'importe ou en RAM.
CA75 A0 00 LDY #$00 on positionne l'affiche en ADCLK
CA77 AD 13 02 LDA $0213 on lit l'heure
CA7A 20 90 CA JSR $CA90 et on affiche deux chiffres
CA7D A9 3A LDA #$3A on affiche ":"
CA7F 91 40 STA ($40),Y
CA81 C8 INY
45
CA82 AD 12 02 LDA $0212 on lit les minutes
CA85 20 90 CA JSR $CA90 que l'on affiche
CA88 A9 3A LDA #$3A suivies de ":"
CA8A 91 40 STA ($40),Y
CA8C C8 INY
CA8D AD 11 02 LDA $0211 et on affiche les secondes
AFFICHER A EN DECIMAL SUR DEUX CHIFFRES
Principe : on retire 10 a A jusqu'a ce que A devienne negatif, alors on affiche A/10, puis on
affiche le reste soit A MOD 10. Cette routine, courte, est un bon exemple
d'optimisation : Pas de CLC ou SEC en trop, et une habile gestion des registres et des
valeurs.
CA90 A2 2F LDX #$2F X contient "0"-1
CA92 38 SEC
CA93 E9 0A SBC #$0A on soustrait 10 a A
CA95 E8 INX et on ajoute 1 a X
CA96 B0 FB BCS $CA93 on a depasse ?
CA98 48 PHA oui, on sauve le reste
CA99 8A TXA et on affiche X, le premier chiffre
CA9A 91 40 STA ($40),Y
CA9C 68 PLA on reprend le reste
CA9D C8 INY on indexe la position suivante
CA9E 69 3A ADC #$3A on ajoute "0"+10 au reste
CAA0 91 40 STA ($40),Y et on l'affiche
CAA2 C8 INY puis on indexe la prochaine position
CAA3 60 RTS
TABLE DES VECTEURS BRK
Principe: Tous les vecteurs BRK, appeles X. . . . sauf pour ZADCHA (sans doute une faute de
frappe de BROCHE . . .), sont ranges ici selon leur numero. L'adresse codee est ici
l'adresse exacte puisqu'elle sera appelee par un RTI. Parmi les vecteurs non
repertories, certains pointent sur 0, un RTS aurait ete mieux, d'autre sur des adresses
bidons et d'autres encore sur des routines interessantes.
CAA4 WRD $C6E5 00 XOP0 ouverture d'une E/S sur le canal 0
CAA6 WRD $C6E8 01 XOP1 ouverture d'une E/S sur le canal 1
CAA8 WRD $C6EB 02 XOP2 ouverture d'une E/S sur le canal 2
CAAA WRD $C6EE 03 XOP3 ouverture d'une E/S sur le canal 3
CAAC WRD $C720 04 XCL0 fermeture d'une E/S sur le canal 0
CAAE WRD $C723 05 XCL1 fermeture d'une E/S sur le canal 1
CAB0 WRD $C726 06 XCL2 fermeture d'une E/S sur le canal 2
CAB2 WRD $C729 07 XCL3 fermeture d'une E/S sur le canal 3
CAB4 WRD $C7CF 08 XRD0 lecture d'un code sur le canal 0
CAB6 WRD $C7D2 09 XRD1 lecture d'un code sur le canal 1
46
CAB8 WRD $C7D5 0A XRD2 lecture d'un code sur le canal 2
CABA WRD $C7D8 0B XRD3 lecture d'un code sur le canal 3
CABC WRD $C806 0C XRDW0 attente d'un code sur le canal 0
CABE WRD $C809 0D XRDW1 attente d'un code sur le canal 1
CAC0 WRD $C80C 0E XRDW2 attente d'un code sur le canal 2
CAC2 WRD $C80F 0F XRDW3 attente d'un code sur le canal 3
CAC4 WRD $C75D 10 XWR0 ecriture d'un code sur le canal 0
CAC6 WRD $C762 11 XWR1 ecriture d'un code sur le canal 1
CAC8 WRD $C767 12 XWR2 ecriture d'un code sur le canal 2
CACA WRD $C76C 13 XWR3 ecriture d'un code sur le canal 3
CACC WRD $C7A8 14 XWSTR0 ecriture d'une chaine sur le canal 0
CACE WRD $C7AB 15 XWSTR1 ecriture d'une chaine sur le canal 1
CAD0 WRD $C7AE 16 XWSTR2 ecriture d'une chaine sur le canal 2
CAD2 WRD $C7B1 17 XWSTR3 ecriture d'une chaine sur le canal 3
CAD4 WRD $CD6C 18 XDECAL deplacement d'un bloc memoire
CAD6 WRD $CF75 19 XTEXT passage en mode TEXT
CAD8 WRD $CF45 1A XHIRES passage en mode HIRES
CADA WRD $CF06 1B XEFFHI effacer la page HIRES
CADC WRD $CF14 1C XFILLM remplir un bloc memoire
CADE WRD $FF31 1D ZADCHA trouver l'adresse d'un code ASCII
CAE0 WRD $C6BF 1E XTSTLP tester l'imprimante
CAE2 WRD $D0F0 1F XMINMA passe A en majuscules s'il y a lieu
CAE4 WRD $CE69 20 XMUL40 multiplication par 40
CAE6 WRD $CE97 21 XMULT multiplication
CAE8 WRD $CE89 22 XADRES addition
CAEA WRD $CEDC 23 XDIVIS division
CAEC WRD $CFF0 24 XNOMFI envoie un nom dans BUFNOM
CAEE WRD $C756 25 XCRLF saute une ligne sur le canal 0
CAF0 WRD $E749 26 XDECAY passage decimal-ASCII -> binaire AY
CAF2 WRD $0000 27 rien (pourquoi pas CAA3 par exemple ?)
CAF4 WRD $CDEF 28 XBINDX conversion decimal-ASCII
CAF6 WRD $CE39 29 XDECIM conversion avec affichage sur canal 0
CAF8 WRD $CE54 2A XHEXA conversion hexa
CAFA WRD $F49B 2B XA1AFF affiche ACC1 sur le canal 0
CAFC WRD $CBE0 2C XMENU gestion de menu deroulent
CAFE WRD $E435 2D XEDT edition plein page sur canal 0
CB00 WRD $E6EB 2E XINSER insertion de ligne dans un listing
CB02 WRD $E680 2F XSCELG recharge de ligne dans un listing
CB04 WRD $D140 30 gere le curseur Hires emulation VIDEOTEX
CB06 WRD $D711 31 affiche un motif mosaique en HIRES VDT
CB08 WRD $E537 32 XEDTIN (que fait-elle ?)
CB0A WRD $E66C 33 XECRPR ecrit le prompt
CB0C WRD $DE1E 34 XCDSCR efface le curseur dans une fenetre
CB0E WRD $DE20 35 XCSSCR affiche le curseur dans une fenetre
CB10 WRD $DEFB 36 XSCRSE initialise une fenetre
CB12 WRD $DE54 37 XSCROH scrolle une fenetre vers le haut
CB14 WRD $DE5C 38 XSCROB id. mais vers le bas
CB16 WRD $FEF7 39 XSCRNE redefinisseur de caracteres
CB18 WRD $D442 3A gere les sequences VIDEOTEX
CB1A WRD $D4F1 3B calcule une sequence VIDEOTEX
CB1C WRD $CA55 3C remet l'horloge a 0
CB1E WRD $CA65 3D XCLCL stoppe l'affichage de l'horloge
CB20 WRD $CA69 3E XWRCLK force l'affichage de l'horloge
CB22 WRD $0000 3F rien
47
CB24 WRD $D9E9 40 XSDNPS envoie 14 parametre au PSG 8912
CB26 WRD $DA1A 41 XEPSG envoie une valeur au PSG 8912
CB28 WRD $DDD8 42 XOUPS emet un OUPS
CB2A WRD $EB0D 43 XPLAY commande PLAY de l'HYPER-BASIC
CB2C WRD $EB73 44 XSOUND commande SOUND de l'HYPER-BASIC
CB2E WRD $EB5A 45 XMUSIC commande MUSIC de l'HYPER-BASIC
CB30 WRD $EBEC 46 XZAP emet un ZAP
CB32 WRD $EBDF 47 XSHOOT emet un SHOOT
CB34 WRD $DA72 48 XLPRBI envoie un code a l'imprimante
CB36 WRD $DAE4 49 XLPCRL saute une ligne sur l'imprimante
CB38 WRD $E1B9 4A XHCSCR hard-copy TEXT
CB3A WRD $E209 4B XHCVDT hard-copy HIRES emulation VIDEOTEX
CB3C WRD $E250 4C XHCHRS hard-copy HIRES
CB3E WRD $0000 4D rien
CB40 WRD $0000 4E rien
CB42 WRD $0000 4F rien
CB44 WRD $D903 50 XALLKB scrute le clavier dans KBDCOL (8 col.)
CB46 WRD $D81F 51 XKBDAS convertit en ASCII KBDCOL dans le buffer
CB48 WRD $FF4C 52 XGOKBD change le type de clavier
CB4A WRD $0000 53 rien
CB4C WRD $C51D 54 XECRBU ecrit une donnee dans un buffer
CB4E WRD $C518 55 XLISBU lit une donnee dans un buffer
CB50 WRD $C50F 56 XTSTBU teste si un buffer est vide
CB52 WRD $C50C 57 XVIDBU vide un buffer
CB54 WRD $C507 58 XINIBU initialise un buffer
CB56 WRD $C4EA 59 XDEFBU donne les valeurs par defaut a un buffer
CB58 WRD $CFB1 5A XBUSY teste si un des buffer est non vide
CB5A WRD $0000 5B rien
CB5C WRD $ED9A 5C XSDUMP dumpe l'entree RS232
CB5E WRD $ED77 5D XCONSO commande console de l'HYPER-BASIC
CB60 WRD $EDE5 5E XSLOAD charge un fichier via la RS232
CB62 WRD $EDCA 5F XSSAVE sauve un fichier via la RS232
CB64 WRD $EDFC 60 XMLOAD charge un fichier via le MINITEL
CB66 WRD $EDD7 61 XMSAVE sauve un fichier via le MINITEL
CB68 WRD $EEA5 62 XRING commande RING de l'HYPER-BASIC
CB6A WRD $EF4A 63 XWCXFI commande WCXFIN de l'HYPER-BASIC
CB6C WRD $EF20 64 XLIGNE prise de ligne
CB6E WRD $EF3F 65 XDECON commande UNCONNECT de l'HYPER-BASIC
CB70 WRD $EF7A 66 XMOUT envoie un code au MINITEL
CB72 WRD $EF85 67 XSOUT envoie un code a la RS232
CB74 WRD $F4A5 68 XA1DEC convertit ACC1 en decimal-ASCII
CB76 WRD $F91E 69 XDECA1 convertit une chaine decimale dans ACC1
CB78 WRD $EFB2 6A XA1PA2 somme
CB7A WRD $EF9B 6B XA2NA1 soustraction
CB7C WRD $F18B 6C XA1MA2 multiplication
CB7E WRD $F28A 6D XA2DA1 division
CB80 WRD $F61A 6E XA1EA2 exponentiation
CB82 WRD $F653 6F XNA1 negation
CB84 WRD $F78E 70 XSIN sinus
CB86 WRD $F781 71 XCOS cosinus
CB88 WRD $F80A 72 XTAN tangente
CB8A WRD $F835 73 XATAN arctangente
CB8C WRD $F68C 74 XEXP exponentielle
CB8E WRD $F146 75 XLN logarithme neperien
48
CB90 WRD $F26F 76 XLOG logarithme decimal
CB92 WRD $F735 77 XRND renvoie un nombre aleatoire dans ACC1
CB94 WRD $F610 78 XSQR racine carree
CB96 WRD $F8B6 79 XRAD conversion degre -> radian
CB98 WRD $F8AA 7A XDEG conversion radian -> degre
CB9A WRD $F46A 7B XINT calcul de INT(ACC1)
CB9C WRD $F314 7C XPI place la valeur PI dans ACC1
CB9E WRD $F771 7D XRAND ACC1=RAND(ACC1)
CBA0 WRD $F387 7E XA1A2 met ACC1 dans ACC2
CBA2 WRD $F377 7F XA2A1 met ACC2 dans ACC1
CBA4 WRD $F3ED 80 XIYAA1 YA (et non AY !) dans ACC1
CBA6 WRD $F323 81 XAYA1 (AY) dans ACC1
CBA8 WRD $F3A6 82 XA1IAY INT(ACC1) dans AY
CBAA WRD $F352 83 XA1XY ACC1 en (XY)
CBAC WRD $F396 84 XAA1 arrondit ACC1 selon ACC1EX
CBAE WRD $F8CD 85 XADNXT (AY)+ACC1 -> (AY)
CBB0 WRD $FA12 86 XINTEG teste si ACC1 est un entier
CBB2 WRD $0000 87 rien
CBB4 WRD $E7E7 88 deplace le curseur HIRES vers la gauche
CBB6 WRD $E7D9 89 id. vers la droite
CBB8 WRD $E7C1 8A id. vers le bas
CBBA WRD $E7CD 8B id. vers le haut
CBBC WRD $E792 8C XHRSSE place le curseur en X,Y
CBBE WRD $E866 8D XDRAWA commande ADRAW de l'HYPER-BASIC
CBC0 WRD $E885 8E XDRAWR commande DRAW de l'HYPER-BASIC
CBC2 WRD $E9CB 8F XCIRCL commande CIRCLE de l'HYPER-BASIC
CBC4 WRD $E92F 90 XCURSE commande CURSET de l'HYPER-BASIC
CBC6 WRD $E93C 91 XCURMO commande CURMOV de l'HYPER-BASIC
CBC8 WRD $E85D 92 XPAPER commande PAPER de l'HYPER-BASIC
CBCA WRD $E85F 93 XINK commande INK de l'HYPER-BASIC
CBCC WRD $E819 94 XBOX commande BOX de l'HYPER-BASIC
CBCE WRD $E82C 95 XABOX commande ABOX de l'HYPER-BASIC
CBD0 WRD $EA73 96 XFILL commande FILL de l'HYPER-BASIC
CBD2 WRD $EAAF 97 XCHAR commande CHAR de l'HYPER-BASIC
CDD4 WRD $EA93 98 XSCHAR commande SCHAR de l'HYPER-BASIC
CBD6 WRD $0000 99 rien
CBD8 WRD $0000 9A rien
CBDA WRD $0000 9B rien
CBDC WRD $EBE5 9C XEXPLO emet un EXPLODE
CBDE WRD $EBD9 9D XPING emet un PING
GESTION D'UN MENU DEROULANT
Action : Les choix du menu doivent se trouver a l'adresse ADMEN, separes
par un 0. Le dernier choix est termine par un double 0. MENDDY et
X contiennent respectivement l'ordonnee de la premiere et de la
derniere ligne de la fenetre menu dans l'ecran. MENDDX contient
l'abscisse de la fenetre dans l'ecran. MENLX contient la largeur
de la barre en video inverse. A contient le premier choix a
afficher (0 pour le premier) et Y le numero du choix a afficher
(id.).
49
En sortie, X contient le numero du choix (id.) et A le mode de
sortie :
13 pour RETURN
27 pour ESC
32 pour la barre d'espace
Le CTRL-C n'est pas gere.
CBE0 84 60 STY $60 on sauve les donnees
CBE2 85 66 STA $66 passees par registre
CBE4 86 63 STX $63
CBE6 A2 00 LDX #$00
CBE8 20 1E DE JSR $DE1E on eteint le curseur dans la fenetre 0
CBEB A4 62 LDY $62 Y = premiere ligne dans la fenetre
CBED A6 66 LDX $66 X = premier choix a afficher
CBEF 2C BYT $2C et on saute
CBF0 E8 INY on passe a la ligne et
CBF1 C8 INX au choix suivant
CBF2 20 F9 CC JSR $CCF9 on affiche le choix
CBF5 30 04 BMI $CBFB si dernier choix on passe
CBF7 C4 63 CPY $63 sinon, fin de la fenetre ?
CBF9 D0 F5 BNE $CBF0 non
CBFB 86 67 STX $67 on stocke le numero du dernier choix
CBFD A6 60 LDX $60 X = choix ou placer la barre
CBFF 38 SEC
CC00 8A TXA
CC01 E5 66 SBC $66 on enleve le premier choix affiche
CC03 18 CLC
CC04 65 62 ADC $62 et on ajoute la premiere ligne de la fenetre
CC06 A8 TAY
CC07 20 D3 CC JSR $CCD3 on affiche la barre
CC0A 20 06 C8 JSR $C806 on attend une touche
CC0D 48 PHA on sauve la touche
CC0E 2C 0D 02 BIT $020D est-on en mode Minitel ?
CC11 50 0D BVC $CC20 non
CC13 A9 08 LDA #$08 oui, on enleve le marqueur
CC15 20 5D C7 JSR $C75D
CC18 A9 20 LDA #$20
CC1A 20 5D C7 JSR $C75D
CC1D 4C 2E CC JMP $CC2E pourquoi pas BNE ???
CC20 A4 61 LDY $61
CC22 A6 65 LDX $65
CC24 B1 26 LDA ($26),Y on efface la barre en video inverse
CC26 29 7F AND #$7F
CC28 91 26 STA ($26),Y
CC2A C8 INY
CC2B CA DEX
CC2C D0 F6 BNE $CC24
CC2E 68 PLA on lit la touche
CC2F C9 20 CMP #$20 espace ?
CC31 F0 08 BEQ $CC3B oui, on sort
CC33 C9 1B CMP #$1B ESC ?
CC35 F0 04 BEQ $CC3B oui, on sort
CC37 C9 0D CMP #$0D RETURN ?
50
CC39 D0 03 BNE $CC3E non, on passe
CC3B A6 60 LDX $60 sortie A contient le code de la touche de sortie
CC3D 60 RTS
CC3E C9 0A CMP #$0A fleche bas ?
CC40 D0 2B BNE $CC6D non, on passe
CC42 A5 60 LDA $60 la barre est en bas ?
CC44 C5 67 CMP $67
CC46 F0 05 BEQ $CC4D
CC48 E6 60 INC $60 non, on descend la barre
CC4A 4C FD CB JMP $CBFD et on recommence
CC4D 24 68 BIT $68 oui, y a-t-il encore des choix ?
CC4F 30 AC BMI $CBFD non, on recommence
CC51 E6 60 INC $60 oui, on ajuste les variables
CC53 E6 67 INC $67
CC55 E6 66 INC $66
CC57 2C 0D 02 BIT $020D mode Minitel ?
CC5A 70 8F BVS $CBEB oui, on reaffiche tout
CC5C A6 62 LDX $62 non, on scrolle la fenetre
CC5E A4 63 LDY $63
CC60 20 54 DE JSR $DE54 vers le haut
CC63 A4 63 LDY $63
CC65 A6 60 LDX $60
CC67 20 F9 CC JSR $CCF9 on affiche le choix suivant
CC6A 4C FD CB JMP $CBFD et on boucle
CC6D C9 0B CMP #$0B fleche haut ?
CC6F D0 29 BNE $CC9A non, on passe
CC71 A5 60 LDA $60 on est en haut de la fenetre ?
CC73 C5 66 CMP $66
CC75 D0 1B BNE $CC92 non
CC77 A5 60 LDA $60 oui, premier choix ?
CC79 F0 19 BEQ $CC94 oui
CC7B C6 66 DEC $66 on ajuste les variables
CC7D C6 67 DEC $67
CC7F C6 60 DEC $60
CC81 2C 0D 02 BIT $020D mode Minitel ?
CC84 70 11 BVS $CC97 oui, on repart
CC86 A6 62 LDX $62 non, on scrolle vers le bas
CC88 A4 63 LDY $63
CC8A 20 5C DE JSR $DE5C
CC8D A4 62 LDY $62
CC8F 4C 65 CC JMP $CC65 et on affiche le choix et on boucle
CC92 C6 60 DEC $60
CC94 4C FD CB JMP $CBFD on boucle
CC97 4C EB CB JMP $CBEB
CC9A C9 30 CMP #$30 est- on entre "0"
CC9C 90 F6 BCC $CC94
CC9E C9 3A CMP #$3A et "9" inclus ?
CCA0 B0 F2 BCS $CC94 non, on repart
CCA2 A6 60 LDX $60 oui, le choix courant
CCA4 E0 19 CPX #$19 est inferieur a 25 ?
CCA6 90 06 BCC $CCAE oui
CCA8 A6 66 LDX $66 non, on place la barre
CCAA 86 60 STX $60 sur le premier choix
CCAC B0 E6 BCS $CC94 et on boucle
51
CCAE 48 PHA on sauve la touche
CCAF 06 60 ASL $60 choix actuel *2
CCB1 A5 60 LDA $60
CCB3 06 60 ASL $60 *4
CCB5 06 60 ASL $60 *8
CCB7 65 60 ADC $60 *10
CCB9 85 60 STA $60
CCBB 68 PLA
CCBC 29 0F AND #$0F on isole le numero demande
CCBE 65 60 ADC $60 on ajoute au choix courant
CCC0 E9 00 SBC #$00 -1 si on depasse
CCC2 85 60 STA $60
CCC4 90 E2 BCC $CCA8 et on boucle tant qu'on depasse
CCC6 C5 66 CMP $66
CCC8 90 DE BCC $CCA8 ou jusqu'a ce qu'on soit a la fin de la fenetre
CCCA C5 67 CMP $67
CCCC F0 02 BEQ $CCD0
CCCE B0 D8 BCS $CCA8
CCD0 4C FD CB JMP $CBFD et on boucle
AFFICHER LA BARRE EN VIDEO INVERSE
CCD3 20 5A CD JSR $CD5A on positionne le curseur en X, Y
CCD6 2C 0D 02 BIT $020D mode Minitel ?
CCD9 50 0F BVC $CCEA non
CCDB A2 02 LDX #$02 oui, on decale le curseur a droite 3 fois
CCDD A9 09 LDA #$09
CCDF 20 5D C7 JSR $C75D
CCE2 CA DEX
CCE3 10 F8 BPL $CCDD
CCE5 A9 2D LDA #$2D et on affiche "-"
CCE7 4C 5D C7 JMP $C75D
CCEA A4 61 LDY $61 on prend l'abscisse de la fenetre
CCEC A6 65 LDX $65 on prend la longueur de la barre
CCEE B1 26 LDA ($26),Y
CCF0 09 80 ORA #$80 et on inverse la barre
CCF2 91 26 STA ($26),Y
CCF4 C8 INY
CCF5 CA DEX
CCF6 D0 F6 BNE $CCEE
CCF8 60 RTS
AFFICHE LE CHOIX X
CCF9 98 TYA on va afficher le choix X
CCFA 48 PHA en $61,Y
CCFB 8A TXA
52
CCFC 48 PHA
CCFD 48 PHA
CCFE 20 5A CD JSR $CD5A positionnement
CD01 E8 INX on est deja sur le choix 0
CD02 A5 69 LDA $69 on sauve l'adresse de la table des choix
CD04 A4 6A LDY $6A
CD06 85 15 STA $15 car on lit sur une autre banque
CD08 84 16 STY $16
CD0A A0 00 LDY #$00 on indexe le premier caractere
CD0C CA DEX on est sur le bon choix ?
CD0D F0 11 BEQ $CD20 oui
CD0F C8 INY non, on indexe le code suivant
CD10 D0 02 BNE $CD14
CD12 E6 16 INC $16 sur 16 bits
CD14 20 11 04 JSR $0411 et on lit le caractere suivant
CD17 D0 F6 BNE $CD0F 0 ?
CD19 C8 INY oui, on a passe un choix
CD1A D0 F0 BNE $CD0C
CD1C E6 16 INC $16
CD1E D0 EC BNE $CD0C inconditionnel
CD20 A6 16 LDX $16
CD22 18 CLC
CD23 98 TYA
CD24 65 15 ADC $15
CD26 90 01 BCC $CD29
CD28 E8 INX
CD29 85 02 STA $02 on met l'adresse du choix
CD2B 86 03 STX $03 dans $02-03
CD2D A9 20 LDA #$20 et un espace comme valeur par defaut en aff. dec.
CD2F 85 14 STA $14
CD31 68 PLA on sort le numero du choix
CD32 18 CLC
CD33 69 01 ADC #$01 +1 car le premier est 0
CD35 A0 00 LDY #$00 AY=A
CD37 A2 01 LDX #$01 pour 3 codes a afficher
CD39 20 39 CE JSR $CE39 et on affiche le numero du choix en decimal
CD3C A9 20 LDA #$20 puis un espace
CD3E 20 5D C7 JSR $C75D
CD41 A5 02 LDA $02 puis le choix lui-meme
CD43 A4 03 LDY $03
CD45 20 A8 C7 JSR $C7A8 par XWSTRO
CD48 A0 01 LDY #$01
CD4A 20 11 04 JSR $0411 on lit le code suivant le choix
CD4D 38 SEC si 0, C=1
CD4E F0 01 BEQ $CD51
CD50 18 CLC sinon C=0
CD51 66 68 ROR $68 et on ajuste MENFLG
CD53 68 PLA on restaure les registres
CD54 AA TAX
CD55 68 PLA
CD56 A8 TAY
CD57 24 68 BIT $68 et N=1 si dernier choix
CD59 60 RTS
53
POSITIONNE LE CURSEUR EN $61,X
Principe : Classique, dans la norme ASCII, on envoie la sequence
US/Y+64/X+64 pour positionner le curseur en X, Y.
CD5A A9 1F LDA #$1F
CD5C 20 5D C7 JSR $C75D on envoie US
CD5F 98 TYA Y est inferieur a 64
CD60 09 40 ORA #$40 donc on force le bit 6 a 1 pour ajouter 64
CD62 20 5D C7 JSR $C75D Y+64
CD65 A5 61 LDA $61
CD67 09 40 ORA #$40
CD69 4C 5D C7 JMP $C75D $61+64
DECALAGE D'UN BLOC MEMOIRE
Principe : Etant donne l'usage sur-frequent qu'il est fait de cette
routine, elle a ete optimisee en temps, au detriment de la
place memoire. Deux routines ont ete ecrites, une pour les
decalages vers le haut et une pour les decalages vers le bas.
Le principe consiste d'abord a decaler le petit morceau final
de moins de 256 octets pour se ramener ensuite a un decalage de
pages. Ce sont en effet les ajustements des adresses de
transfert qui sont les plus gourmand en temps. Il faut ici pres
de 14 millisecondes pour decaler l'ecran d'une ligne, ce qui
est un temps pres de 2 fois plus court que sur la V1.1. Le
decalage vers le bas est d'ailleurs tres sensiblement plus lent
que le decalage vers le haut.
CD6C 48 PHA on sauve les registres
CD6D 8A TXA
CD6E 48 PHA
CD6F 98 TYA
CD70 48 PHA
CD71 38 SEC
CD72 A5 06 LDA $06 on calcule le nombre d'octets a decaler
CD74 E5 04 SBC $04 dans YX
CD76 A8 TAY
CD77 A5 07 LDA $07
CD79 E5 05 SBC $05
CD7B AA TAX
CD7C 90 3B BCC $CDB9 si debut>fin, on sort
CD7E 86 0B STX $0B nombre de pages a decaler dans $06
CD80 A5 08 LDA $08 on compare la cible
CD82 C5 04 CMP $04 a l'adresse de debut
CD84 A5 09 LDA $09
CD86 E5 05 SBC $05
54
CD88 B0 35 BCS $CDBF cible>=debut, on decale de bas en haut
CD8A 98 TYA decalage de haut en bas
CD8B 49 FF EOR #$FF on complemente le nombre d'octets hors pages
CD8D 69 01 ADC #$01 a 2 car on change de sens
CD8F A8 TAY
CD90 85 0A STA $0A
CD92 90 03 BCC $CD97
CD94 CA DEX au besoin, on enleve une page
CD95 E6 07 INC $07
CD97 38 SEC
CD98 A5 08 LDA $08 on enleve le nombre d'octets hors-pages
CD9A E5 0A SBC $0A a l'adresse cible
CD9C 85 08 STA $08
CD9E B0 02 BCS $CDA2
CDA0 C6 09 DEC $09
CDA2 18 CLC
CDA3 A5 07 LDA $07 et le nombre de pages +1
CDA5 E5 0B SBC $0B a l'adresse de fin
CDA7 85 07 STA $07
CDA9 E8 INX
CDAA B1 06 LDA ($06),Y on decale les octets hors pages d'abord
CDAC 91 08 STA ($08),Y puis les pages completes ensuite
CDAE C8 INY
CDAF D0 F9 BNE $CDAA
CDB1 E6 07 INC $07 puisqu'on deplace des pages, on ajuste
CDB3 E6 09 INC $09 uniquement les poids fort des adresses
CDB5 CA DEX
CDB6 D0 F2 BNE $CDAA
CDB8 38 SEC C=1 si le decalage s'est effectue
CDB9 68 PLA C=0 sinon
CDBA A8 TAY on restaure les registres et on sort
CDBB 68 PLA
CDBC AA TAX
CDBD 68 PLA
CDBE 60 RTS
CDBF 8A TXA decalage vers le haut
CDC0 18 CLC
CDC1 65 05 ADC $05 on ajoute le nombre de pages a l'adresse
CDC3 85 05 STA $05 de debut du bloc
CDC5 8A TXA
CDC6 18 CLC
CDC7 65 09 ADC $09 et a l'adresse cible
CDC9 85 09 STA $09
CDCB E8 INX et on decale comme precedemment
CDCC 88 DEY
CDCD B1 04 LDA ($04),Y
CDCF 91 08 STA ($08),Y
CDD1 98 TYA
CDD2 D0 F8 BNE $CDCC
CDD4 C6 05 DEC $05
CDD6 C6 09 DEC $09
CDD8 CA DEX
CDD9 D0 F1 BNE $CDCC
CDDB F0 DB BEQ $CDB8 inconditionnel
55
DONNEES POUR CONVERSION DECIMALE
CDDD BYT $0A poids faible de 000A=10
CDDE BYT $64 0064=100
CDDF BYT $E8 03E8=1000
CDE0 BYT $E1 2710=10000
CDE1 BYT $00 poids forts des nombres ci-dessus
CDE2 BYT $00
CDE3 BYT $03
CDE4 BYT $27
CONVERSION DECIMALE 0-99
CDE5 A2 00 LDX #$00 on indique 2 chiffres
CDE7 A0 00 LDY #$00 AY=A
CDE9 BYT $2C et on saute la suivante
CONVERSION DECIMAL 0-65535
CDEA A2 03 LDX #$03 on indique 5 chiffres
CDEC 2C BYT $2C et on saute la suite
CONVERSION DECIMALE 0-9999
CDED A2 02 LDX #$02 on indique 4 chiffres
CONVERSION DECIMALE
Principe : En entree, AY contient le nombre et X le nombre de chiffres du
nombre (son logarithme decimal en fait). On soustrait
successivement des puissances de dix au nombre pour trouver ses
chiffres.
Les 0 devant le chiffre seront remplaces par le contenu de
DEFAFF. En sortie, les ($10) nombres du chiffre sont dans ($11-
12).
CDEF 85 0D STA $0D on sauve le nombre
CDF1 84 0E STY $0E
CDF3 A9 00 LDA #$00 et on met 0 dans l'index d'ecriture
CDF5 85 0F STA $0F et l'indicateur de 0 en debut de nombre
CDF7 85 10 STA $10
CDF9 A9 FF LDA #$FF et 255 dans $0C
CDFB 85 0C STA $0C
CDFD E6 0C INC $0C pour calculer le chiffre courant
CDFF 38 SEC
CE00 A5 0D LDA $0D on enleve la puissance de dix courante
CE02 A8 TAY
CE03 FD DD CD SBC $CDDD,X au poids faible
56
CE06 85 0D STA $0D
CE08 A5 0E LDA $0E
CE0A 48 PHA
CE0B FD E1 CD SBC $CDE1,X puis au poids fort
CE0E 85 0E STA $0E
CE10 68 PLA
CE11 B0 EA BCS $CDFD jusqu'a ce qu'on deborde
CE13 84 0D STY $0D on reprend le nombre d'avant qu'il
CE15 85 0E STA $0E deborde
CE17 A5 0C LDA $0C le chiffre est 0 ?
CE19 F0 04 BEQ $CE1F oui
CE1B 85 0F STA $0F non, on le stocke
CE1D D0 07 BNE $CE26 inconditionnel
CE1F A4 0F LDY $0F 0 en debut de nombre ?
CE21 D0 03 BNE $CE26 non
CE23 A5 14 LDA $14 oui, on prend le caractere par defaut
CE25 2C BYT $2C et on saute l'instruction suivante
CE26 09 30 ORA #$30 on ajoute "0"
CE28 20 32 CE JSR $CE32 et on le stocke dans le buffer
CE2B CA DEX pour tous les chiffres sauf les unites
CE2C 10 CB BPL $CDF9
CE2E A5 0D LDA $0D puis les unites
CE30 09 30 ORA #$30 +"0" (un nombre nul affiche 0)
CE32 A4 10 LDY $10 on prend l'index
CE34 91 11 STA ($11),Y et on stocke le chiffre
CE36 E6 10 INC $10 puis on augmente l'index
CE38 60 RTS
CONVERSION DECIMALE AVEC AFFICHAGE SUR CANAL 0
Action : En entree, tout comme pour la conversion decimale. Le nombre est
stocke dans le bas de la pile (BUFTRV).
CE39 48 PHA
CE3A A9 00 LDA #$00 on sauve BUFTRV ($100)
CE3C 85 11 STA $11
CE3E A9 01 LDA #$01
CE40 85 12 STA $12 dans $11-12
CE42 68 PLA
CE43 20 EF CD JSR $CDEF on convertit
CE46 A0 00 LDY #$00
CE48 B9 00 01 LDA $0100,Y
CE4B 20 5D C7 JSR $C75D et on affiche
CE4E C8 INY
CE4F C4 10 CPY $10
CE51 D0 F5 BNE $CE48
CE53 60 RTS
57
CONVERSION HEXADECIMALE
Action : Renvoie dans AY les deux chiffres Hexa du nombre contenu dans A
en entree.
CE54 48 PHA on sauve le nombre
CE55 29 0F AND #$0F on isole le quartet de droite
CE57 20 60 CE JSR $CE60 on les convertit en chiffre hexa
CE5A A8 TAY dans Y
CE5B 68 PLA
CE5C 4A LSR puis on isole le quartet de gauche
CE5D 4A LSR
CE5E 4A LSR
CE5F 4A LSR que l'on convertit a son tour
CE60 09 30 ORA #$30 on ajoute "0"
CE62 C9 3A CMP #$3A superieur a 9 ?
CE64 90 02 BCC $CE68 non
CE66 69 06 ADC #$06 oui, on en fait une lettre
CE68 60 RTS
MULTIPLICATION PAR 40
Action : Par glissements et additions, on multiplie A (en fait AY avec
Y=0) par 40. Le resultat est a la fois dans AY et dans RES. Cette
routine sert aux calculs de position sur l'ecran puisqu'il a 40
colonnes.
CE69 A0 00 LDY #$00 AY=A
CE6B 85 00 STA $00 dans RES
CE6D 84 01 STY $01
CE6F 0A ASL *2
CE70 26 01 ROL $01
CE72 0A ASL *4
CE73 26 01 ROL $01
CE75 65 00 ADC $00 *5
CE77 90 02 BCC $CE7B
CE79 E6 01 INC $01
CE7B 0A ASL *10
CE7C 26 01 ROL $01
CE7E 0A ASL *20
CE7F 26 01 ROL $01
CE81 0A ASL *40
CE82 26 01 ROL $01
CE84 85 00 STA $00 dans RES et AY
CE86 A4 01 LDY $01
CE88 60 RTS
58
ADDITION D'ENTIERS
Action : Additionne RES et AY dans RES et AY
CE89 18 CLC
CE8A 65 00 ADC $00 poids faible de RES
CE8C 85 00 STA $00 + poids faible de AY
CE8E 48 PHA sauve
CE8F 98 TYA
CE90 65 01 ADC $01 poids fort de RES
CE92 85 01 STA $01 + poids fort de AY
CE94 A8 TAY sauve
CE95 68 PLA
CE96 60 RTS
MULTIPLICATION ENTIERE
Principe : On teste chaque bit du multiplicateur, tout en decalant le
multiplicande a gauche a chaque fois (comme en decimal). Et ainsi
de suite. Cette routine aurait pu etre encore plus rapide en
testant au debut si le multiplicande est bien plus que le
multiplicateur, en les permutant sinon. En effet, multiplier 1
(RES) par 65535 (AY) revient au meme (en temps) que multiplier
65535 par lui-meme !
En entree, AY et RES contiennent les facteurs. En sortie, TR0-1-
2-3 contient le resultat.
CE97 85 10 STA $10 multiplicateur dans TR5-6
CE99 84 11 STY $11
CE9B A2 00 LDX #$00 0 dans : le resultat
CE9D 86 0C STX $0C -
CE9F 86 0D STX $0D -
CEA1 86 0E STX $0E -
CEA3 86 0F STX $0F -
CEA5 86 02 STX $02 et dans l'extension du multiplicande
CEA7 86 03 STX $03
CEA9 A2 10 LDX #$10 pour 16 decalages (inutile ! voir plus loin)
CEAB 46 11 LSR $11 on isole le bit 16-X du multiplicateur
CEAD 66 10 ROR $10
CEAF 90 19 BCC $CECA 0
CEB1 18 CLC 1 on additionne le multiplicande au resultat
CEB2 A5 00 LDA $00 octet 0
CEB4 65 0C ADC $0C
CEB6 85 0C STA $0C
CEB8 A5 01 LDA $01 octet 1
CEBA 65 0D ADC $0D
CEBC 85 0D STA $0D
59
CEBE A5 02 LDA $02 octet 2
CEC0 65 0E ADC $0E
CEC2 85 0E STA $0E
CEC4 A5 03 LDA $03 octet 3
CEC6 65 0F ADC $0F
CEC8 85 0F STA $0F
CECA 06 00 ASL $00 on multiplie le multiplicande par 2
CECC 26 01 ROL $01
CECE 26 02 ROL $02
CED0 26 03 ROL $03
CED2 A5 10 LDA $10 le multiplicateur est nul ?
CED4 05 11 ORA $11
CED6 F0 03 BEQ $CEDB oui, on sort
CED8 CA DEX inutile ! apres 16 glissements, le multiplicateur
CED9 D0 D0 BNE $CEAB est toujours nulÅc BNE suffit
CEDB 60 RTS Z=1 en sortie
DIVISION ENTIERE
Principe : Comme pour la multiplication, on teste les bits du diviseur et
on enleve ou non le diviseur au reste selon les bits. On sort
apres 16 tests. Divise RES par AY. Le resultat est dans RES et le
reste dans RESB. Cette routine est bien plus optimisee que la
precedente. . .
CEDC 85 0C STA $0C diviseur dans TR0-1
CEDE 84 0D STY $0D
CEE0 A2 00 LDX #$00 reste est 0
CEE2 86 02 STX $02
CEE4 86 03 STX $03
CEE6 A2 10 LDX #$10 pour 16 decalages du diviseur
CEE8 06 00 ASL $00 on decale le dividende
CEEA 26 01 ROL $01 avec report dans le reste partiel
CEEC 26 02 ROL $02
CEEE 26 03 ROL $03
CEF0 38 SEC
CEF1 A5 02 LDA $02 on soustrait le diviseur
CEF3 E5 0C SBC $0C au reste dans YA
CEF5 A8 TAY
CEF6 A5 03 LDA $03
CEF8 E5 0D SBC $0D diviseur > reste ?
CEFA 90 06 BCC $CF02 oui, on saute
CEFC 84 02 STY $02 non, on sauve le reste partiel
CEFE 85 03 STA $03
CF00 E6 00 INC $00 et on ajoute 1 au dividende
CF02 CA DEX
CF03 D0 E3 BNE $CEE8
CF05 60 RTS
60
EFFACE L'ECRAN HIRES
CF06 A9 00 LDA #$00 RES=$A000, debut de l'ecran HIRES
CF08 A0 A0 LDY #$A0
CF0A 85 00 STA $00
CF0C 84 01 STY $01
CF0E A0 68 LDY #$68 YX=$BF68, fin de l'ecran
CF10 A2 BF LDX #$BF
CF12 A9 40 LDA #$40 on remplit avec %01000000, soit pixels eteints
REMPLIT UNE ZONE MEMOIRE
Principe : identique au decalage, pour se ramener a un remplissage de
pages, on commence par remplir la zone hors-page (- de 256
octets). Remplit la zone de RES a YX avec le code dans A.
CF14 48 PHA on sauve le code
CF15 38 SEC
CF16 98 TYA
CF17 E5 00 SBC $00 on calcule dans YX
CF19 A8 TAY la taille de la zone a remplit
CF1A 8A TXA
CF1B E5 01 SBC $01 (YX-RES)
CF1D AA TAX
CF1E 84 02 STY $02 et si RES est superieur a YX ?!?!
CF20 68 PLA on sort le code de remplissage
CF21 A0 00 LDY #$00 premier octet hors page
CF23 C4 02 CPY $02 on a fini la zone hors-page ?
CF25 B0 05 BCS $CF2C oui
CF27 91 00 STA ($00),Y non, on remplit la zone hors-page
CF29 C8 INY
CF2A D0 F7 BNE $CF23
CF2C 48 PHA on sauve la donnee
CF2D 98 TYA AY=Y
CF2E A0 00 LDY #$00
CF30 20 89 CE JSR $CE89 on augment l'adresse de debut de Y (deja remplie)
CF33 68 PLA on prend la donnee
CF34 E0 00 CPX #$00 y a-t-il des pages a remplir ?
CF36 F0 0C BEQ $CF44 non
CF38 A0 00 LDY #$00 oui, on remplit une page
CF3A 91 00 STA ($00),Y
CF3C C8 INY
CF3D D0 FB BNE $CF3A
CF3F E6 01 INC $01 et toutes les autres
CF41 CA DEX
CF42 D0 F6 BNE $CF3A
CF44 60 RTS Z=1 en sortie
61
PASSAGE EN HIRES
CF45 A2 00 LDX #$00
CF47 A0 FF LDY #$FF
CF49 8C AA 02 STY $02AA pattern = %11111111, ligne pleine
CF4C C8 INY Y=0 X=0
CF4D 20 F3 E7 JSR $E7F3 on initialise les donnees HRS
CF50 AD 0D 02 LDA $020D est-on en HIRES ?
CF53 30 B1 BMI $CF06 oui, on efface simplement
CF55 09 80 ORA #$80 non, on force mode HIRES
CF57 8D 0D 02 STA $020D
CF5A 08 PHP on inhibe les interruptions
CF5B 78 SEI
CF5C A9 1F LDA #$1F place attribute HIRES
CF5E 8D 67 BF STA $BF67
CF61 20 A4 CF JSR $CFA4 on attend 1/3 de seconde
CF64 20 D8 FE JSR $FED8 on deplace la table des caracteres
CF67 A9 5C LDA #$5C fenetre TEXT en HIRES
CF69 A0 02 LDY #$02
CF6B A2 00 LDX #$00 fenetre 0
CF6D 20 FD DE JSR $DEFD on initialise la fenetre TEXT
CF70 20 06 CF JSR $CF06 on efface l'ecran HIRES
CF73 28 PLP pourquoi pas PLP/JMP $CF06 ???
CF74 60 RTS
PASSAGE EN MODE TEXT
CF75 AD 0D 02 LDA $020D est-on deja en TEXT ?
CF78 10 29 BPL $CFA3 BPL $CF74 aurait ete mieux
CF7A 08 PHP on inhibe les IRQ
CF7B 78 SEI
CF7C 29 7F AND #$7F on indique mode TEXT
CF7E 8D 0D 02 STA $020D dans FLGTEL
CF81 20 DB FE JSR $FEDB on replace la table des caracteres
CF84 A9 56 LDA #$56
CF86 A0 02 LDY #$02
CF88 A2 00 LDX #$00
CF8A 20 FD DE JSR $DEFD on initialise la fenetre 0 (tout l'ecran)
CF8D A9 1A LDA #$1A on pose un attribut TEXT
CF8F 8D DF BF STA $BFDF a la fin de l'ecran
CF92 20 A4 CF JSR $CFA4 on attend 1/3 de seconde
CF95 A2 28 LDX #$28 on efface l'ecran
CF97 A9 20 LDA #$20
CF99 9D 7F BB STA $BB7F,X
CF9C CA DEX
CF9D D0 FA BNE $CF99
CF9F 20 20 DE JSR $DE20 on affiche le curseur
CFA2 28 PLP PLP/JMP aurait ete mieux
CFA3 60 RTS
62

ATTEND 1/3 DE SECONDES
CFA4 A0 1F LDY #$1F on boucle 8192 fois
CFA6 A2 00 LDX #$00 avec un temps moyen de 4 É s par boucle
CFA8 CA DEX ce qui fait pres de 32000 É s
CFA9 D0 FD BNE $CFA8 donc 1/3 de second
CFAB 88 DEY
CFAC D0 FA BNE $CFA8
CFAE 60 RTS
TESTE SI TOUS LES BUFFERS SONT VIDES
Principe : On scrute les buffers 1 par 1, si on en trouve un non vide, on
sort avec C=0, sinon C=1. Cette routine ne teste pas les buffers
definis par l'utilisateur. De plus, que viennent faire les deux
entrees (CFAF et CFB1) puisque qu'a part le fait de faire perdre
5 octets, elles ont le meme effet ?
CFAF 38 SEC C=1
CFB0 BYT $24
CFB1 18 CLC ou C=0
CFB2 66 15 ROR $15 dans b7 ($15) (?)
CFB4 A2 00 LDX #$00
CFB6 20 0F C5 JSR $C50F on teste si le buffer X est vide
CFB9 90 08 BCC $CFC3 non, on sort avec C=0
CFBB 8A TXA
CFBC 69 0B ADC #$0B on passe au buffer suivant (C=1 donc +11)
CFBE AA TAX
CFBF E0 30 CPX #$30 a-t-on fait les 4 buffers ?
CFC1 D0 F3 BNE $CFB6 non, on boucle
CFC3 08 PHP on sauve C
CFC4 A9 DC LDA #$DC on indexe prompt plein
CFC6 A0 CF LDY #$CF si tous les buffers sont vides
CFC8 B0 04 BCS $CFCE
CFCA A9 E6 LDA #$E6 ou prompt vide sinon
CFCC A0 CF LDY #$CF
CFCE 24 15 BIT $15 ???
CFD0 10 05 BPL $CFD7
CFD2 20 F9 FE JSR $FEF9 on redefinit le prompt
CFD5 28 PLP et on sort
CFD6 60 RTS
CFD7 20 F9 FE JSR $FEF9 id, (quel interet ?)
CFDA 28 PLP
CFDB 60 RTS
63
TABLES DE DEFINITION DU PROMPT
CFDC BYT $7F code ASCII 127 (prompt)
CFDD BYT 00,00,08,3C,3E,3C,08,00 valeur prompt plein
CFE5 BYT 0 terminateur
CFE6 BYT $7F code du prompt
CFE7 BYT 00,00,08,34,32,34,08,00 valeur prompt vide
CFEF BYT 0 terminateur
PLACE UN NOM DE FICHIER DANS BUFNOM
Action : place le nom de fichier de longueur X, a l'adresse AY dans
BUFNOM. En sortie, X=0 si longueur du nom nulle : X=1 si le nom
n'a qu'une lettre, C=1 s'il contient des jokers; X>127 s'il est
invalide.
X=128 si un des caracteres du nom est invalide.
X=129 si drive specifie incorrect
X=130 si nom de fichier trop long
X=131 si plusieurs * dans le nom
X=132 si l'extension est invalide
CFF0 85 15 STA $15 on sauve l'adresse du nom dans $15-16
CFF2 84 16 STY $16 pour permettre la lecture inter-banques
CFF4 86 00 STX $00 longueur dans $0
CFF6 E6 00 INC $00 +1 pour tests
CFF8 AC 0C 02 LDY $020C on prend le drive courant
CFFB 8C 17 05 STY $0517 dans BUFNOM
CFFE 8C 00 05 STY $0500 et DRIVE
D001 A0 0C LDY #$0C on place 12 jokers ("?") dans BUFNOM
D003 A9 3F LDA #$3F pour nom="?????????.???"
D005 99 17 05 STA $0517,Y
D008 88 DEY
D009 D0 FA BNE $D005
D00B 8A TXA longueur nulle ?
D00C F0 3B BEQ $D049 oui on sort
D00E E0 01 CPX #$01 longueur = 1 ?
D010 D0 22 BNE $D034 non, on passe
D012 20 DF D0 JSR $D0DF oui, on lit le caractere
D015 38 SEC
D016 E9 41 SBC #$41 on lui enleve "A"
D018 C9 04 CMP #$04 superieure a 3 ?
D01A B0 40 BCS $D05C oui, ce n'est pas un drive
D01C 8D 17 05 STA $0517 non, on place le drive demande
D01F 8D 00 05 STA $0500 dans BUFNOM et DRIVE
D022 A2 01 LDX #$01 y a-t-il encore des jokers ?
D024 A0 0C LDY #$0C
D026 A9 3F LDA #$3F
D028 D9 17 05 CMP $0517,Y
D02B F0 05 BEQ $D032 oui, on sort avec C=1
64
D02D 88 DEY
D02E D0 F8 BNE $D028
D030 18 CLC non, on sort avec C=0
D031 60 RTS
D032 38 SEC
D033 60 RTS
D034 A0 01 LDY #$01 on lit le premier caractere
D036 20 DF D0 JSR $D0DF
D039 C9 2D CMP #$2D est-ce un trait "-" ?
D03B D0 1F BNE $D05C non, ok on lit le nom
D03D A0 00 LDY #$00 oui, on prend le numero du drive
D03F 20 DF D0 JSR $D0DF
D042 38 SEC
D043 E9 41 SBC #$41 on enleve "A"
D045 B0 03 BCS $D04A si < 0
D047 A2 81 LDX #$81 on indique drive invalide
D049 60 RTS
D04A C9 04 CMP #$04
D04C B0 F9 BCS $D047 (ou superieur a 4)
D04E E0 02 CPX #$02 sinon, X=2 (juste drive + "-")
D050 D0 04 BNE $D056 non, on lit la suite du nom
D052 8D 0C 02 STA $020C oui, on change le drive par defaut
D055 60 RTS
D056 8D 17 05 STA $0517 on met le drive dans BUFNOM
D059 A0 02 LDY #$02 et on lit la suite du nom
D05B BYT $2C sauter l'instruction suivante
D05C A0 00 LDY #$00 pas de drive dans le nom, on lit tout le nom
D05E A2 00 LDX #$00
D060 20 DF D0 JSR $D0DF on lit le caractere suivant
D063 B0 1D BCS $D082 fin du nom ? oui
D065 C9 2E CMP #$2E on a un point ?
D067 F0 19 BEQ $D082 oui
D069 C9 2A CMP #$2A non, une etoile ?
D06B F0 22 BEQ $D08F oui
D06D 20 FB D0 JSR $D0FB non, un caractere valide ?
D070 90 06 BCC $D078 oui
D072 A2 80 LDX #$80 non, on sort avec X=128
D074 60 RTS
D075 A2 82 LDX #$82
D077 60 RTS
D078 E0 09 CPX #$09 X=9 ?
D07A F0 F9 BEQ $D075 oui, on sort avec 130
D07C 9D 18 05 STA $0518,X non, on place le caractere dans BUFNOM
D07F E8 INX
D080 D0 DE BNE $D060 et on boucle
D082 A9 20 LDA #$20 on complete la fin du nom avec des espaces
D084 E0 09 CPX #$09 non, fini ?
D086 F0 06 BEQ $D08E oui
D088 9D 18 05 STA $0518,X non, on complete
D08B E8 INX
D08C D0 F6 BNE $D084
D08E 88 DEY on lit le caractere suivant
D08F A2 00 LDX #$00
D091 20 DF D0 JSR $D0DF
65
D094 90 0E BCC $D0A4 on a fini ? non, on saute
D096 A0 02 LDY #$02 oui, on met l'extension par defaut
D098 B9 5D 05 LDA $055D,Y (on devrait la passer en majuscules avantÅc)
D09B 99 21 05 STA $0521,Y
D09E 88 DEY
D09F 10 F7 BPL $D098
D0A1 4C 22 D0 JMP $D022 et on termine
D0A4 C9 2E CMP #$2E a-t-on "." ?
D0A6 D0 CA BNE $D072 pas de ".", nom de fichier invalide
D0A8 20 DF D0 JSR $D0DF caractere suivant
D0AB B0 E1 BCS $D08E il n'y en a pas, on met l'extension par defaut
D0AD 88 DEY
D0AE 20 DF D0 JSR $D0DF on lit le code
D0B1 90 0E BCC $D0C1 on l'interprete
D0B3 A9 20 LDA #$20 il n'y en a plus,
D0B5 E0 03 CPX #$03 on complete l'extension avec des espaces
D0B7 F0 E8 BEQ $D0A1
D0B9 9D 21 05 STA $0521,X
D0BC E8 INX
D0BD D0 F6 BNE $D0B5
D0BF F0 E0 BEQ $D0A1 et on sort
D0C1 C9 2A CMP #$2A est-ce "*"
D0C3 D0 08 BNE $D0CD non, on passe
D0C5 20 DF D0 JSR $D0DF oui, elle est seule ?
D0C8 B0 D7 BCS $D0A1 oui, on termine
D0CA A2 83 LDX #$83 non, trop de jokers
D0CC 60 RTS
D0CD 20 FB D0 JSR $D0FB caractere valide ?
D0D0 B0 A0 BCS $D072 non, nom invalide et on sort
D0D2 E0 03 CPX #$03 oui, fin de l'extension ?
D0D4 F0 06 BEQ $D0DC oui, extension invalide et on sort
D0D6 9D 21 05 STA $0521,X non, on stocke le caractere
D0D9 E8 INX
D0DA D0 D2 BNE $D0AE et on poursuit
D0DC A2 84 LDX #$84
D0DE 60 RTS
D0DF 20 11 04 JSR $0411 on lit le caractere courant
D0E2 20 F0 D0 JSR $D0F0 en majuscules
D0E5 C8 INY
D0E6 C4 00 CPY $00 est-ce le dernier ?
D0E8 B0 05 BCS $D0EF oui, C=1 non, C=0
D0EA C9 20 CMP #$20 est-ce un espace ?
D0EC F0 F1 BEQ $D0DF oui, on lit le suivant
D0EE 18 CLC
D0EF 60 RTS
66
PASSE A EN MAJUSCULES
D0F0 C9 61 CMP #$61 entre "a"
D0F2 90 06 BCC $D0FA
D0F4 C9 7B CMP #$7B et "z"
D0F6 B0 02 BCS $D0FA
D0F8 E9 1F SBC #$1F oui, on retire 32 (31+(1-C) avec C=0)
D0FA 60 RTS
TESTE SI A EST VALIDE DANS UN NOM DE FICHIER
D0FB C9 3F CMP #$3F est-ce "?"
D0FD F0 0E BEQ $D10D oui, ok
D0FF C9 30 CMP #$30 entre 0
D101 90 0C BCC $D10F
D103 C9 3A CMP #$3A et 9 ?
D105 90 06 BCC $D10D oui, ok
D107 C9 41 CMP #$41 superieur a "A" ?
D109 90 04 BCC $D10F
D10B C9 5B CMP #$5B ridicule ! on met C a 0 de toutes facons !!!
D10D 18 CLC C=0, caractere OK
D10E 60 RTS
D10F 38 SEC C=1, caractere invalide
D110 60 RTS
INITIALISE LES TABLES VDT
Action :initialise la table ASCII VDT ($9000-$9400), la table des couleurs
VDT ($9400-$9800) et l'ecran VDT ($A000-$BF3F, HIRES). VDT
signifie mode HIRES en emulation VIDEOTEX.
D111 A0 00 LDY #$00 AY=$9000
D113 A9 90 LDA #$90
D115 84 00 STY $00 dans RES
D117 85 01 STA $01
D119 A2 94 LDX #$94 YX=$9400
D11B A9 00 LDA #$00 A=0
D11D 20 14 CF JSR $CF14 on remplit de $9000 a $9400 de 0
D120 A0 00 LDY #$00
D122 A9 94 LDA #$94
D124 84 00 STY $00
D126 85 01 STA $01
D128 A2 98 LDX #$98
D12A A9 87 LDA #$87
D12C 20 14 CF JSR $CF14 on remplit de $9400 a $9800 de %10000111
D12F A0 00 LDY #$00
D131 A9 A0 LDA #$A0
67
D133 84 00 STY $00
D135 85 01 STA $01
D137 A0 3F LDY #$3F
D139 A2 BF LDX #$BF
D13B A9 10 LDA #$10
D13D 4C 14 CF JMP $CF14 on remplit de $A000 a $BF3F de %0001000
GERE LE CURSEUR VDT
Action :Calcul dans VDTASC, VDTATR et ADVDT la position du code, de la
couleur et de l'affichage VDT du point courant VDT et gere le
curseur VDT.
D140 A5 39 LDA $39 prend VDTY, ordonnee du curseur VDT
D142 20 69 CE JSR $CE69 calcul VDT*40
D145 48 PHA dans AY et RES
D146 98 TYA
D147 48 PHA
D148 A9 00 LDA #$00 ajoute l'adresse de la table ASCII
D14A A0 90 LDY #$90
D14C 20 89 CE JSR $CE89
D14F 85 2E STA $2E dans ADASC (table ASCII VDT)
D151 84 2F STY $2F
D153 85 30 STA $30 ajoute 4 pages ($400)
D155 C8 INY
D156 C8 INY
D157 C8 INY
D158 C8 INY
D159 84 31 STY $31 et stocke ADATR (table des couleurs)
D15B 68 PLA on sort poids fort de VDTY*40
D15C 85 01 STA $01 dans $01
D15E 68 PLA et poids faible dans A
D15F 0A ASL on multiplie par 8
D160 26 01 ROL $01 car chaque caractere fait 8 lignes
D162 0A ASL
D163 26 01 ROL $01
D165 0A ASL
D166 26 01 ROL $01
D168 85 00 STA $00 dans RES
D16A A9 00 LDA #$00 on ajoute l'adresse de l'ecran HIRES
D16C A0 A0 LDY #$A0
D16E 20 89 CE JSR $CE89
D171 85 2C STA $2C dans ADVDT (adresse du point courant en HIRES)
D173 84 2D STY $2D
D175 4C 56 D7 JMP $D756 et on gere le curseur VDT
68
ENVOIE A SUR L'ECRAN VIDEOTEX
Action : Cette routine est la routine principale de l'emulateur VIDEOTEX
integre. Elle envoie A, code ASCII, en HIRES emulant la norme
VIDEOTEX, en gerant tous les codes (REP, SEP, SYN, etc. . .). Les
sequences sont affichees recursivement. La routine est
compliquees a suivre car tres optimisees.
D178 85 3E STA $3E on sauve la donnee
D17A 98 TYA et les registres
D17B 48 PHA
D17C 8A TXA
D17D 48 PHA
D17E A5 39 LDA $39 VDTY=0 ?
D180 F0 08 BEQ $D18A oui
D182 8D 81 02 STA $0281 non, on sauve VDTX et VDTY
D185 A5 38 LDA $38 dans $280 et $281
D187 8D 80 02 STA $0280
D18A 24 3C BIT $3C sequence en cour ?
D18C 30 5F BMI $D1ED oui, on passe
D18E A5 3E LDA $3E on prend la donnee
D190 20 42 D4 JSR $D442 on la code
D193 85 00 STA $00 et on la stocke
D195 F0 4F BEQ $D1E6 est-ce 0 ? oui, on debute une sequence
D197 C9 20 CMP #$20 non, est-ce un code de controle ?
D199 90 58 BCC $D1F3 oui, on le gere
D19B C9 A0 CMP #$A0 est-ce un caractere OK ?
D19D B0 42 BCS $D1E1 oui, on le sauve
D19F 8D 85 02 STA $0285
D1A2 29 7F AND #$7F b7 a 0
D1A4 AA TAX dans X
D1A5 A5 34 LDA $34 on prend VDTATR
D1A7 30 12 BMI $D1BB mode mosaique (G1) ? oui
D1A9 A4 38 LDY $38 VDTX=39
D1AB C0 27 CPY #$27
D1AD D0 02 BNE $D1B1 non
D1AF 29 DF AND #$DF oui, on interdit la double largeur
D1B1 A4 39 LDY $39 VDTY <2
D1B3 C0 02 CPY #$02
D1B5 B0 04 BCS $D1BB non, VDTY>1
D1B7 29 EF AND #$EF oui, on interdit la double hauteur
D1B9 85 34 STA $34 on sauve VDTATR
D1BB 48 PHA on sauve encore VDTATR
D1BC 20 30 D5 JSR $D530 on place le code dans les tables VDT
D1BF 20 DC D5 JSR $D5DC on affiche le code a l'ecran
D1C2 68 PLA on lit VDTATR
D1C3 48 PHA
D1C4 30 0A BMI $D1D0 mode G1 ? oui
D1C6 29 20 AND #$20 mode double largeur ?
D1C8 F0 06 BEQ $D1D0 non
D1CA 20 91 D3 JSR $D391 oui, on deplace le curseur a droite deux fois
69
D1CD 20 59 D7 JSR $D759 on eteint le curseur
D1D0 20 91 D3 JSR $D391 on deplace le curseur a droite
D1D3 68 PLA on sort VDTATR
D1D4 30 0B BMI $D1E1 mode G1 ? oui
D1D6 A6 38 LDX $38 non, VDTX=0 ?
D1D8 D0 07 BNE $D1E1 non
D1DA 29 10 AND #$10 oui, double hauteur ?
D1DC F0 03 BEQ $D1E1 non
D1DE 20 A0 D3 JSR $D3A0 oui, on saute une ligne
D1E1 AD 85 02 LDA $0285 en sortie $00 contient la donnee codee
D1E4 85 00 STA $00 (pour recursivite)
D1E6 68 PLA une chance que les sequences on au plus 3
D1E7 AA TAX caracteres, sans quoi la pile deborderait vite
D1E8 68 PLA (4 appels recursifs empilent 8 valeurs pour les
D1E9 A8 TAY registres et 8 pour les adresses, soit 16Åc)
D1EA A5 00 LDA $00
D1EC 60 RTS
POURSUIT UNE SEQUENCE
D1ED 20 2E D2 JSR $D22E on traite la sequence
D1F0 4C E6 D1 JMP $D1E6 et on sort
GERE LES CODES DE CONTROLE
D1F3 20 F9 D1 JSR $D1F9 on traite le code
D1F6 4C E6 D1 JMP $D1E6 et on sort
GERE LES CODES DE CONTROLE VIDEOTEX
Principe : En entree, A contient un code ASCII entre 0 et 31. On calcule
l'adresse de gestion du code d'apres une table d'octets en
ajoutant $D37E a l'octet correspondant au code. Un JMP indirect
et on execute. . .
D1F9 AA TAX code dans X
D1FA 18 CLC
D1FB BD 0B D2 LDA $D20B,X on lit l'octet correspondant
D1FE 69 7E ADC #$7E on ajoute le poids faible de $D37E
D200 85 00 STA $00 on sauve
D202 A9 D3 LDA #$D3 et le poids fort de $D37E
D204 69 00 ADC #$00 que l'on sauve aussi
D206 85 01 STA $01
D208 6C 00 00 JMP ($0000) et on execute la routine de gestion du code
70
TABLE DE GESTION DES CODES DE CONTROLE
D20B BYT 0,0,0,0,0,0,0 Les codes de 0 a 6 ne sont pas traites
D212 BYT $01 code 07 BEL - $D37F emet un bip
D213 BYT $04 08 BS - $D382 deplace le curseur a gauche
D214 BYT $10 09 HT - $D38E deplace le curseur a droite
D215 BYT $22 10 LF - $D3A0 deplace le curseur vers le bas
D216 BYT $44 11 VT - $D3C2 deplace le curseur vers le haut
D217 BYT $53 12 FF - $D3D1 efface l'ecran
D218 BYT $59 13 CR - $D3D7 curseur en debut de ligne
D219 BYT $63 14 SO - $D3E1 passe en G1
D21A BYT $76 15 SI - $D3F4 passe en G0
D21B BYT 0
D21C BYT $7D 17 Con - $D3FB allume le curseur
D21D BYT $B3 18 REP - $D431 repete un code
D21E BYT $B6 19 SEP - $D434 sequence clavier et accents
D21F BYT $80 20 Coff- $D3FE eteint le curseur
D220 BYT 0
D221 BYT $B9 22 SYN - $D437
D222 BYT 0
D223 BYT $83 24 CAN - $D401 efface la fin de ligne
D224 BYT $B9 25 SS2 - $D437 (comme SYN)
D225 BYT 0
D226 BYT $BC 27 ESC - $D43A sequence a quatre caracteres
D227 BYT 0,0
D229 BYT $A7 30 RS - $D425 ramene le curseur en 0,0
D22A BYT $BF 31 US - $D43D positionne le curseur en X,Y
D22B 4C B7 D2 JMP $D2B7 saut a la gestion de sequence ESC
GERE UNE SEQUENCE
Action : Gere totalement la sequence code dans FLGVD0. Cette routine est
recursive, c'est-a-dire qu'elle appelle la $D182 (son appelant).
En tout cas, il semble bien difficile de respecter la norme
VIDEOTEX !
D22E A5 3C LDA $3C on isole le nombre de caractere (-1)
D230 29 03 AND #$03
D232 85 36 STA $36 dans $36
D234 A5 3C LDA $3C on prend la sequence
D236 0A ASL est-ce ESC ?
D237 30 F2 BMI $D22B oui
D239 0A ASL non
D23A 0A ASL US ?
D23B 30 11 BMI $D24E oui
D23D A5 3E LDA $3E non, c'est REP, on lit le code actuel a envoyer
D23F 29 3F AND #$3F on elimine b7b6 (entre 0 et 63)
D241 AA TAX dans X
D242 46 3C LSR $3C on indique fin de sequence
71
D244 AD 85 02 LDA $0285 et on repete l'envoi du
D247 20 78 D1 JSR $D178 caractere
D24A CA DEX X fois
D24B D0 F7 BNE $D244
D24D 60 RTS
D24E A5 36 LDA $36 sequence US
D250 F0 1D BEQ $D26F fin de sequence ? oui
D252 A5 3E LDA $3E non, on lit la donnee
D254 C9 30 CMP #$30 entre "0" et "0"+39 (?) ?
D256 90 12 BCC $D26A
D258 C9 59 CMP #$59
D25A B0 0E BCS $D26A non, incorrect
D25C 8D 82 02 STA $0282 on stocke l'ordonnee dans VDTPIL
D25F C6 3C DEC $3C on indique un code de moins en sequence
D261 A9 07 LDA #$07 encre blanche
D263 85 34 STA $34
D265 A9 00 LDA #$00 fond noir
D267 85 32 STA $32
D269 60 RTS
D26A 46 3C LSR $3C on indique fin de sequence
D26C 4C 78 D1 JMP $D178 et on envoie simplement la donnee
D26F 46 3C LSR $3C fin de sequence US
D271 A5 3E LDA $3E on lit le code
D273 C9 30 CMP #$30 entre "0" et "0"+56 (?)
D275 90 F3 BCC $D26A
D277 C9 69 CMP #$69
D279 B0 EF BCS $D26A non
D27B 29 3F AND #$3F oui, on isole b3b2b1b0
D27D 8D 83 02 STA $0283 dans VDTPIL+1
D280 A5 3E LDA $3E la donnee est-elle > "A"
D282 C9 40 CMP #$40
D284 B0 1D BCS $D2A3 oui
D286 AD 82 02 LDA $0282 non, on prend l'ordonnee
D289 29 03 AND #$03 que l'on triture
D28B 0A ASL pour ramener de "0" a "0"+39
D28C 0A ASL a 0 . . 25
D28D 6D 82 02 ADC $0282
D290 E9 2F SBC #$2F
D292 0A ASL
D293 6D 83 02 ADC $0283
D296 E9 2F SBC #$2F
D298 85 39 STA $39 dans VDTY
D29A 20 D7 D3 JSR $D3D7 on ramene le curseur en debut de ligne
D29D 20 59 D7 JSR $D759 on eteint le curseur
D2A0 4C 40 D1 JMP $D140 on ajuste les tables et affiche le curseur
D2A3 20 59 D7 JSR $D759 on eteint le curseur
D2A6 AD 83 02 LDA $0283 on prend l'abscisse
D2A9 85 38 STA $38 dans VDTX
D2AB C6 38 DEC $38
D2AD AD 82 02 LDA $0282 l'ordonnee
D2B0 29 3F AND #$3F dans VDTY
D2B2 85 39 STA $39
D2B4 4C 40 D1 JMP $D140 on ajuste les tables et on affiche le curseur
72
GESTION DE SEQUENCE ESC
Entree : $36 contient le nombre de caracteres de la sequence, $3E contient
le caractere a traiter. Le codage est aise car PRO1, PRO2 et PRO3
sont suivis respectivement de 1, 2 et 3 codes. Le masquage et le
demasquage devant certainement etre geres dans une version
ulterieur, mais ne l'etant pas dans celle-ci, on laisse de
vilaines traces . . .
D2B7 A6 36 LDX $36 on lit le nombre de caractere a traiter
D2B9 A5 3E LDA $3E on lit la donnee
D2BB E0 03 CPX #$03 4 caracteres a traiter ?
D2BD D0 22 BNE $D2E1 non
D2BF 8D 82 02 STA $0282 on sauve le code (PROx ou 3/6)
D2C2 A2 00 LDX #$00 on met 0
D2C4 86 35 STX $35 dans VDTFT (pas SEP ni SS2)
D2C6 C9 36 CMP #$36 est-ce 3/6 ?
D2C8 F0 0D BEQ $D2D7 oui
D2CA C9 39 CMP #$39 est-ce entre PRO1 (3/9)
D2CC 90 22 BCC $D2F0
D2CE C9 3C CMP #$3C et PRO3 (3/B)?
D2D0 B0 1E BCS $D2F0 non, on passe
D2D2 29 03 AND #$03 on isole le PRO
D2D4 E9 00 SBC #$00 -1 (donc 0,1,2 pour PRO1,2,3)
D2D6 BYT $2C et on passe l'instruction suivante
D2D7 A9 00 LDA $00 on force PRO1
D2D9 09 C0 ORA #$C0 et on indique
D2DB 85 3C STA $3C
D2DD 60 RTS
D2DE 46 3C LSR $3C fin de sequence sans action
D2E0 60 RTS
D2E1 E6 35 INC $35 on indexe le parametre suivant
D2E3 A6 35 LDX $35
D2E5 9D 81 02 STA $0281,X et on le stocke dans la PILE VDT
D2E8 C6 3C DEC $3C on indique un code de moins
D2EA C6 36 DEC $36
D2EC 10 EF BPL $D2DD on sort simplement s'il en reste
D2EE 30 EE BMI $D2DE on sort avec fin de sequence si c'etait le dernier
GESTION DE SEQUENCE C1
Action: Les sequences C1 sont les sequences ESC xx, qui donnent acces aux
attributs caractere (couleur, lignage, clignotement, etc . . .).
Leur gestion est longue, mais c'est la plus importante !
73
D2F0 C9 40 CMP #$40 est-ce un attribut C1 ?
D2F2 90 E9 BCC $D2DD non, on sort
D2F4 46 3C LSR $3C oui, on indique fin de sequence
D2F6 C9 48 CMP #$48 est-ce un code couleur texte ?
D2F8 B0 0D BCS $D307 non
D2FA 29 07 AND #$07 oui, on isole la couleur
D2FC 85 36 STA $36
D2FE A5 34 LDA $34
D300 29 F8 AND #$F8
D302 05 36 ORA $36
D304 85 34 STA $34 dans VDTATR
D306 60 RTS
D307 C9 4A CMP #$4A est-ce un code clignotement ?
D309 B0 0C BCS $D317 non
D30B 4A LSR oui, C=1 si fixe, 0 si clignotement
D30C A5 34 LDA $34
D30E 29 F7 AND #$F7
D310 B0 02 BCS $D314
D312 09 08 ORA #$08
D314 85 34 STA $34 dans VDTATR
D316 60 RTS
D317 C9 4C CMP #$4C est-ce rien ?
D319 90 2F BCC $D34A oui . . . on sort
D31B C9 50 CMP #$50 est-ce un attribut taille ?
D31D B0 11 BCS $D330 non
D31F 29 03 AND #$03 oui
D321 0A ASL
D322 0A ASL
D323 0A ASL
D324 0A ASL
D325 85 36 STA $36
D327 A5 34 LDA $34
D329 29 CF AND #$CF
D32B 05 36 ORA $36 on indique lequel dans
D32D 85 34 STA $34 VDTATR
D32F 60 RTS
D330 C9 58 CMP #$58 est-ce un attribut fond ?
D332 B0 17 BCS $D34B non
D334 29 07 AND #$07 oui, on isole la couleur
D336 0A ASL
D337 0A ASL
D338 0A ASL
D339 0A ASL
D33A 85 36 STA $36
D33C A5 32 LDA $32
D33E 29 84 AND #$84
D340 05 36 ORA $36 dans A
D342 24 34 BIT $34 est-ce en G1
D344 30 02 BMI $D348 oui, on passe
D346 09 80 ORA #$80 non, on indique attribut a valider
D348 85 32 STA $32 et on stocke la couleur de fond
D34A 60 RTS
D34B D0 00 BNE $D34D (aie ! aie ! aie ! voila qui est louche !)
D34D C9 5B CMP #$5B est-ce le lignage ?
74
D34F B0 1B BCS $D36C non
D351 4A LSR C=0 si lignage, 1 si fin de lignage
D352 24 34 BIT $34 est on en G1
D354 10 09 BPL $D35F non
D356 A9 00 LDA #$00 oui, ca devient video normale
D358 90 02 BCC $D35C
D35A A9 40 LDA #$40 et video inverse
D35C 85 33 STA $33
D35E 60 RTS
D35F A5 32 LDA $32 pas G1
D361 29 70 AND #$70
D363 B0 02 BCS $D367 on indique lignage ou non
D365 09 04 ORA #$04
D367 09 80 ORA #$80 et attribut a valider
D369 85 32 STA $32 dans VDTPAR
D36B 60 RTS
D36C F0 FD BEQ $D36B on ne gere pas l'echappement ISO 6429
D36E C9 5E CMP #$5E est-ce l'inversion video
D370 B0 0C BCS $D37E non
D372 4A LSR C=1 si inverse, 0 si normal
D373 A5 34 LDA $34
D375 29 BF AND #$BF
D377 90 02 BCC $D37B
D379 09 40 ORA #$40
D37B 85 34 STA $34 on indique dans VDTATR
D37D 60 RTS
D37E 60 RTS holala !!! quelle horreur !
ROUTINES DE GESTION DES CODES DE CONTROLE
CODE 7 . CTRL G
D37F 4C D8 DD JMP $DDD8 envoie un OUPS
CODE 8 . CTRL H
D382 20 59 D7 JSR $D759 eteint le curseur
D385 A5 38 LDA $38 on est en colonne 0 ?
D387 F0 35 BEQ $D3BE oui
D389 C6 38 DEC $38 non, on deplace vers la gauche
D38B 4C 56 D7 JMP $D756 et on affiche le curseur
CODE 9 . CTRL I
D38E 20 59 D7 JSR $D759 on eteint le curseur
D391 E6 38 INC $38 on deplace a droite
D393 A5 38 LDA $38
D395 C9 28 CMP #$28 on est en colonne 40 ?
75
D397 90 F2 BCC $D38B non
D399 A5 39 LDA $39 oui, on est sur la ligne d'etat ?
D39B F0 EC BEQ $D389 oui
D39D 20 D7 D3 JSR $D3D7 non, on descend d'une ligne
CODE 10 . CTRL J
D3A0 20 59 D7 JSR $D759 on eteint le curseur
D3A3 A6 39 LDX $39 est on en ligne 0 ?
D3A5 F0 0C BEQ $D3B3 oui, on reste ou on est
D3A7 E0 18 CPX #$18 non, en derniere ligne ?
D3A9 D0 02 BNE $D3AD non
D3AB A2 00 LDX #$00 oui, on passe en ligne 1
D3AD E8 INX
D3AE 86 39 STX $39 dans VDTY
D3B0 4C 40 D1 JMP $D140 on ajuste tables et curseur
D3B3 AD 80 02 LDA $0280 on est sur la ligne d'etat
D3B6 AE 81 02 LDX $0281
D3B9 85 38 STA $38
D3BB 4C AE D3 JMP $D3AE et on y reste
D3BE A9 27 LDA #$27 on indique colonne 39
D3C0 85 38 STA $38 et on remonte
CODE 11 . CTRL K
D3C2 20 59 D7 JSR $D759 on eteint le curseur
D3C5 A6 39 LDX $39 on deplace vers le haut
D3C7 CA DEX on est en 0 ?
D3C8 D0 02 BNE $D3CC non
D3CA A2 18 LDX #$18 oui, on passe en ligne 24
D3CC 86 39 STX $39 dans VDTY
D3CE 4C 40 D1 JMP $D140 on ajuste tables et curseur
CODE 12 . CTRL L
D3D1 20 11 D1 JSR $D111 on initialise l'ecran VIDEOTEX
D3D4 4C 25 D4 JMP $D425 et on met le curseur en 0,0
CODE 13 . CTRL M
D3D7 20 59 D7 JSR $D759 on eteint le curseur
D3DA A9 00 LDA #$00 on ramene le curseur en debut de ligne
D3DC 85 38 STA $38 et on remet le curseur
D3DE 4C 56 D7 JMP $D756
CODE 14 . CTRL N
D3E1 A9 40 LDA #$40 on indique G1 joint
D3E3 85 33 STA $33 dans VDTASC
D3E5 A5 32 LDA $32
76
D3E7 29 74 AND #$74 %01110100
D3E9 85 32 STA $32 et pas d'attribut G1 dans VDTPAR
D3EB A5 34 LDA $34 on force G1
D3ED 29 0F AND #$0F
D3EF 09 80 ORA #$80
D3F1 85 34 STA $34 dans VDTATR
D3F3 60 RTS
CODE 15 . CTRL O
D3F4 A5 34 LDA $34 on force G1 a 0 et pas d'attributs
D3F6 29 0F AND #$0F (passage en G0)
D3F8 85 34 STA $34 dans VDTATR
D3FA 60 RTS
CODE 17 . CTRL Q
D3FB 4C 4F D7 JMP $D74F on allume le curseur
CODE 20 . CTRL T
D3FE 4C 4D D7 JMP $D74D on eteint le curseur
CODE 23 . CTRL X
D401 A5 38 LDA $38 on sauve VDTX et VDTY
D403 48 PHA
D404 A5 39 LDA $39
D406 48 PHA
D407 A9 20 LDA #$20 on envoie un espace
D409 20 78 D1 JSR $D178
D40C A5 38 LDA $38 on a fini la ligne ?
D40E F0 09 BEQ $D419 oui
D410 C9 27 CMP #$27 inutile ! on perd des octets betement . . .
D412 D0 F3 BNE $D407 BNE suffit amplement
D414 A9 20 LDA #$20
D416 20 78 D1 JSR $D178
D419 20 59 D7 JSR $D759 on eteint le curseur
D41C 68 PLA on restaure VDTX et VDTY
D41D 85 39 STA $39
D41F 68 PLA
D420 85 38 STA $38
D422 4C 40 D1 JMP $D140 et on ajuste tables et curseur
CODE 30 . CTRL
D425 20 D7 D3 JSR $D3D7 curseur en debut de ligne
D428 20 61 D2 JSR $D261 pas d'attributs
D42B 20 59 D7 JSR $D759 curseur eteint
D42E 4C AB D3 JMP $D3AB VDTY=1 et on ajuste les tables
77
CODES 18,19,22,24,27,31
Principe : On met dans FLGVD0 les bits necessaires a un pour expliciter la
sequence decodee : %1EYURSnn avec
E a 1 si sequence ESC
Y a 1 si sequence SYN ou CAN
U a 1 si sequence US
R a 1 si sequence REP
S a 1 si sequence SEP
nn contient le nombre de codes de la sequence-1 (00=1, 11=4 etc .
. .)
D431 A9 89 LDA #$89 %10001001, sequence REP avec deux codes
D433 BYT $2C et on saute
D434 A9 84 LDA #$84 %10000100, sequence SEP avec un code
D436 BYT $2C sautons . . .
D437 A9 A1 LDA #$A1 %10100001, sequence SYN avec deux codes
D439 BYT $2C etc . . .
D43A A9 C3 LDA #$C3 %11000011, sequence ESC avec trios codes
D43C BYT $2C . . . caetera . . .
D43D A9 91 LDA #$91 %10010001, sequence US avec deux codes
D43F 85 3C STA $3C dans VDTFLG0
D441 60 RTS
CODE UNE DONNEE A ENVOYER SUR L'ECRAN VIDEOTEX
Principe : Des le debut, la routine teste si on est en sequence. Si tel
est le cas on essaye d'interpreter le deuxieme caractere. S'il
est bon, on le traite, sinon, on sort avec A=#$5F (95).
Voici les registres et flags en sortie :
Si on debute une sequence SEP, $37=%01000000 et A=0
SYN, $37=%10000000 et A=0
SS2 (id)
Si on a poursuivi une sequence :
SEP : A contient le code majore de 95
SS2 : si c'est un code caractere unique, A contient son code VDT
Si c'est un accent, $37=%1100000 et A=0
En fin de sequence SS2, A contient le code du caractere accentue
s'il existe ou 95 sinon.
D442 A4 37 LDY $37 on lit l'indicateur de sequence
D444 24 37 BIT $37
D446 08 PHP on sauve P
D447 A2 00 LDX #$00 indique pas de sequence
D449 86 37 STX $37
D44B 28 PLP
78
D44C 30 1C BMI $D46A N=1 (SS2)
D44E 70 16 BVS $D466 V=1 (SEP)
D450 C9 13 CMP #$13 est-ce un SEP
D452 F0 0B BEQ $D45F oui
D454 C9 19 CMP #$19 est-ce un SS2
D456 F0 04 BEQ $D45C oui
D458 C9 16 CMP #$16 ou un SYN
D45A D0 09 BNE $D465 non
D45C A9 80 LDA #$80 on indique SS2 ou SYN
D45E BYT $2C et on saute l'instruction suivante
D45F A9 40 LDA #$40 on indique SEP
D461 85 37 STA $37 dans $37
D463 A9 00 LDA #$00 et A=0 (debut de sequence)
D465 60 RTS code de sequence caractere invalide
D466 18 CLC sequence SEP
D467 69 5F ADC #$5F on ajoute 95 au code dans A
D469 60 RTS
D46A 70 1E BVS $D48A V=1 et N=1 fin de sequence SS2 (accent)
D46C A2 14 LDX #$14 le code est-il dans la table SS2/SYN ?
D46E DD A7 D4 CMP $D4A7,X
D471 F0 06 BEQ $D479 oui
D473 CA DEX
D474 10 F8 BPL $D46E
D476 A9 5F LDA #$5F non, A=95 et on sort
D478 60 RTS
D479 E0 05 CPX #$05 est-ce un accent ?
D47B B0 08 BCS $D485 non, un caractere
D47D 8A TXA X contient le numero de l'accent
D47E 09 C0 ORA #$C0 on met b7 et b6 a 1 pour indiquer sequence
D480 85 37 STA $37 SS2 deuxieme phase dans $37
D482 A9 00 LDA #$00 A=0 (sequence en cours)
D484 60 RTS et on sort
D485 29 1F AND #$1F on calcule son code
D487 09 80 ORA #$80 dans A
D489 60 RTS
D48A 48 PHA on sauve le caractere a accentuer
D48B 98 TYA on prend le numero de l'accent
D48C 29 07 AND #$07 entre 0 et 7 (il n'y a que 5 accents)
D48E AA TAX dans X
D48F BD C1 D4 LDA $D4C1,X on lit le nombre de caracteres ayant cet accent
D492 A8 TAY dans Y
D493 BD BC D4 LDA $D4BC,X et la position de ces caracteres dans X
D496 AA TAX
D497 68 PLA on prend le code a accentuer
D498 DD C6 D4 CMP $D4C6,X peut-il etre accentue ?
D49B F0 06 BEQ $D4A3 oui
D49D E8 INX
D49E 88 DEY
D49F D0 F7 BNE $D498
D4A1 AA TAX non, A contient le code en sortie
D4A2 60 RTS
D4A3 BD DE D4 LDA $D4DE,X on lit le code du caractere ainsi accentue
D4A6 60 RTS et on sort
79
TABLES DE SEQUENCES CARACTERES
TABLES DES CODES SS2 ET SYN
D4A7 BYT $41,$42,$43,$48,$4B codes accents grave, aigu, circonflexe,
trema et cedille
D4AC BYT $20,$23,$24,$26 rien, livre sterling, dollar, diese
D4AF BYT $2C,$2D,$2E,$2F fleches gauche, haut, droite, bas
D4B4 BYT $30,$31,$38,$3C degre, plus ou moins, divise, un quart
D4B8 BYT $3D,$3E,$6A,$7A un demi, un tiers, E dans O, e dans o
TABLES DES POSITIONS
D4BC BYT 0,5,7,11 position des caracteres par accent dans la table
NOMBRES D'ACCENT PAR CARACTERE
D4C1 BYT 5 accents graves (A, a, E, e, u)
D4C2 BYT 2 accents aigus (E, e)
D4C3 BYT 7 accents circonflexes (A, a, E, e, u, I, o)
D4C4 BYT 3 tremas (E, e, i)
D4C5 BYT 2 cedilles (C, c)
CARACTERES RANGES PAR CATEGORIE D'ACCENT
D4C6 BYT "A","a","E","e","u" accent grave
D4CB BYT "E","e" accent aigu
D4CD BYT "A","a","E","e","u","I,"o" accent circonflexe
D4D4 BYT "E","e","I" trema
D4D7 BYT "C","c" cedilles
D4D9 BYT $41,$42,$43,$48,$4B et de deux ! une n'etait pas suffisante
CODES CORRESPONDANT AUX CARACTERES ACCENTUES
D4DE BYT $87,$97,$89,$99,$88
D4E2 BYT $82,$92
D4E5 BYT $81,$86,$8B,$9B,$96,$80,$9F
D4EC BYT $84,$93,$94
D4EF BYT $85,$95
80
EFFECTUE LE CODAGE VDT HIRES -> VIDEOTEX
Action : Un caractere lu sur lÅfecran HIRES en emulation VIDEOTEX est
donnee en entree. En sortie, y contient le code de sequence (si
sequence), A le premier code de la sequence (si sequence) et X le
deuxieme si la sequence est un caractere accentue. Cette routine
effectue en fait le codage inverse de celui effectue par la
$D44E.
D4F1 A2 00 LDX #$00 X=0
D4F3 C9 A0 CMP #$A0 la donnee est-elle un caractere ?
D4F5 90 05 BCC $D4FC non
D4F7 E9 5F SBC #$5F on lui enleve 95 (#A0-ÅgAÅh=95)
D4F9 A0 13 LDY #$13 et Y=1/3 (SEP)
D4FB 60 RTS
D4FC A8 TAY donnee dans Y
D4FD 30 04 BMI $D503 si > 128, on passe
D4FF A8 TAY non
D500 A9 00 LDA #$00 A=0
D502 60 RTS et on sort
D503 A0 12 LDY #$12 pour 18 testes
D505 D9 DE D4 CMP $D4DE,Y est-ce un caractere accentue ?
D508 F0 13 BEQ $D51D oui
D50A 88 DEY
D50B 10 F8 BPL $D505 non, on boucle
D50D 18 CLC
D50E 69 A0 ADC #$A0 on ajoute 160
D510 C9 2A CMP #$2A est-ce Åg-Åg
D512 F0 04 BEQ $D518 oui
D514 C9 3A CMP #$3A est-ce Åg=Åh
D516 D0 02 BNE $D51A non
D518 09 40 ORA #$40 on force b6 a 1
D51A A0 19 LDY #$19 Y=1/9 SS2
D51C 60 RTS
D51D 98 TYA position de lÅfaccent dans A
D51E A2 04 LDX #$04 on calcule sa position dans la table des
D520 DD BC D4 CMP $D4BC,X caracteres
D523 B0 03 BCS $D528 on a trouve
D525 CA DEX
D526 D0 F8 BNE $D520
D528 BD D9 D4 LDA $D4D9,X on lit lÅfaccent
D52B BE C6 D4 LDX $D4C6,Y et le caractere
D52E D0 EA BNE $D51A inconditionnel, Y=SS2 et on sort
81
PLACE UNE DONNEE DANS LES TABLES VIDEOTEX
Action : En entree, X contient le code a placer et A VDTATR. Le code
modifie les tables VDTASC (ASCII), VDTATR (attributs) mais pas le
pointeur ecran.
D530 85 36 STA $36 on sauve VDTATR
D532 06 36 ASL $36 b5 dans b7
D534 06 36 ASL $36 mosaique (G1) ?
D536 A8 TAY
D537 10 26 BPL $D55F non
D539 48 PHA on sauve VDTATR
D53A 8A TXA donnee dans A
D53B C9 60 CMP #$60 inferieure a ÅgaÅh-1
D53D 90 02 BCC $D541 oui
D53F E9 20 SBC #$20 non, on lui enleve 32
D541 38 SEC on lui enleve 32
D542 E9 20 SBC #$20
D544 85 36 STA $36 dans $36
D546 A5 33 LDA $33 on prend VDTASC
D548 29 40 AND #$40 on isole b6 (code ASCII ou type de mosaique)
D54A 05 36 ORA $36 ajoute a la donnee
D54C AA TAX dans X
D54D A5 32 LDA $32 on lit VDTPAR
D54F 29 70 AND #$70 %0111000, on isole la couleur de fond
D551 85 36 STA $36 dans $36
D553 68 PLA on prend VDTATR
D554 29 8F AND #$8F %10001111, on isole G1, video et couleur de texte
D556 05 36 ORA $36 A contient la donnee et ses attributs
D558 A4 38 LDY $38 VDTX
D55A 84 36 STY $36 dans $36
D55C 4C AF D5 JMP $D5AF pourquoi pas BPL ? on stocke dans les tables
D55F E0 20 CPX #$20 la donnee est un espace ?
D561 D0 2B BNE $D58E non
D563 24 32 BIT $32 doit-on valider lÅfattribut ?
D565 10 27 BPL $D58E non
D567 29 70 AND #$70 %01110000, on isole les attributs caractere
D569 85 35 STA $35 dans VDTFT
D56B A5 32 LDA $32
D56D 29 04 AND #$04 on isole le lignage
D56F 09 80 ORA #$80 on force b7 a 1
D571 05 35 ORA $35 et les attributs dans A
D573 AA TAX dans X
D574 A5 32 LDA $32 on lit VDTPAR
D576 29 74 AND #$74 %01110100, on isole couleur de fond et lignage
D578 85 32 STA $32 dans VDTPAR
D57A 29 70 AND #$70 on isole couleur de fond dans VDTFT
D57C 85 35 STA $35
D57E 4A LSR on met la couleur dans b2b1b0
D57F 4A LSR
D580 4A LSR
D581 4A LSR
82
D582 24 34 BIT $34 video inverse ?
D584 50 04 BVC $D58A non
D586 A5 34 LDA $34 oui, on prend la couleur de texte
D588 29 07 AND #$07 comme couleur de fond
D58A 05 35 ORA $35 on ajoute lÅfattribut
D58C 09 80 ORA #$80 et b7 a 1 (attribut a valider)
D58E 24 36 BIT $36 double hauteur ?
D590 50 13 BVC $D5A5 non
D592 C6 2F DEC $2F oui, on enleve une page
D594 C6 31 DEC $31 aux tables ASCII et ATTRIBUT
D596 48 PHA on sauve la donnee
D597 38 SEC
D598 A5 38 LDA $38 on enleve 40 a VDTX
D59A E9 28 SBC #$28
D59C A8 TAY dans Y
D59D 68 PLA on prend la donnee
D59E 20 A7 D5 JSR $D5A7 on envoie le code une ligne plus haut donc
D5A1 E6 2F INC $2F puis on ajoute une page de nouveau
D5A3 E6 31 INC $31 et on envoie le code sur la ligne courante
D5A5 A4 38 LDY $38 on prend VDTX dans Y
D5A7 20 AF D5 JSR $D5AF on envoie le code
D5AA 24 36 BIT $36 double largeur ?
D5AC 10 08 BPL $D5B6 non, on sort
D5AE C8 INY oui, on ecrit le code une deuxieme fois
D5AF 48 PHA on sauve lÅfattribut
D5B0 8A TXA
D5B1 91 2E STA ($2E),Y on ecrit le code ASCII
D5B3 68 PLA
D5B4 91 30 STA ($30),Y et lÅfattribut
D5B6 60 RTS
STOPPE LÅfEMULATION VIDEOTEX
D5B7 20 75 CF JSR $CF75 on passe en TEXT
D5BA 4C 4D D7 JMP $D74D on eteint le curseur VIDEOTEX
INITIALISE LES FLAGS VIDEOTEX
D5BD A9 00 LDA #$00 on met 0
D5BF 85 3C STA $3C dans FLGVD0
D5C1 85 3D STA $3D FLGVD1
D5C3 85 37 STA $37 et le flag de sequence
D5C5 60 RTS
83
GESTION DES E/S VIDEOTEX
Action : Cette routine gere les entree/sortie avec lÅfecran HIRES emulation
VIDEOTEX.
En entree N=0 pour ecrire un code ASCII, C=0 pour ouvrir lÅfE/S et
1 pour fermer lÅfE/S. CÅfest le systeme standard de gestion des
E/S.
D5C6 10 11 BPL $D5D9 N=0, on ecrit une donnee sur lÅfecran
D5C8 B0 ED BCS $D5B7 C=1, on ferme lÅfE/S
D5CA 20 45 CF JSR $CF45 on passe en HIRES
D5CD 20 BD D5 JSR $D5BD on initialize les flags VIDEOTEX
D5D0 A9 96 LDA #$96 AY=$D796
D5D2 A0 D7 LDY #$D7
D5D4 20 F9 FE JSR $FEF9 on redefinit les caracteres VIDEOTEX
D5D7 A9 0C LDA #$0C et on efface lÅfecran
D5D9 4C 78 D1 JMP $D178
AFFICHAGE EN MODE VIDEOTEX
Action : En entree, X contient le code ASCII et A les attributs a
afficher.
D5DC 46 3D LSR $3D on sort N/B dans C
D5DE 08 PHP
D5DF 26 3D ROL $3D
D5E1 28 PLP
D5E2 B0 2B BCS $D60F si mode N/B, on saute
D5E4 A4 38 LDY $38 on prend VDTX
D5E6 F0 27 BEQ $D60F si 0, on saute aussi
D5E8 48 PHA on sauve le code et son attribut
D5E9 8A TXA
D5EA 48 PHA
D5EB 88 DEY on revient un cran a gauche
D5EC B1 2E LDA ($2E),Y on lit le code
D5EE 30 1B BMI $D60B >128 ? oui, on saute
D5F0 AA TAX non, on sauve lÅfASCII dans X
D5F1 B1 30 LDA ($30),Y on lit lÅfattribut
D5F3 30 06 BMI $D5FB >128 ? oui, on saute
D5F5 E0 20 CPX #$20 est-ce un espace ?
D5F7 D0 12 BNE $D60B non, on passe
D5F9 F0 05 BEQ $D600 inconditionnel
D5FB 8A TXA on prend le code
D5FC 29 3F AND #$3F %00111111, on enleve b6 et b7
D5FE D0 0B BNE $D60B sÅfil nÅfest pas nul, on saute
D600 A5 34 LDA $34 on prend VDTATR
D602 29 07 AND #$07 on isole la couleur du texte
D604 C6 38 DEC $38 on decale dÅfune colonne a droite
84
D606 20 48 D6 JSR $D648 on affiche le code
D609 E6 38 INC $38 et on revient une colonne a droite
D60B 68 PLA on recupere code dans X
D60C AA TAX et attribut dans A
D60D 68 PLA
D60E 18 CLC
D60F A8 TAY b7 dÅfattribut=1
D610 10 41 BPL $D653 non, on passe
D612 8A TXA b7 de code=1 ?
D613 30 25 BMI $D63A oui, on saute
D615 A0 00 LDY #$00 non, on met $9C00
D617 A9 9C LDA #$9C dans RES
D619 84 00 STY $00 (table G2, caracteres accentues)
D61B 85 01 STA $01
D61D 8A TXA et le code
D61E 85 03 STA $03 dans $03
D620 20 B2 FE JSR $FEB2 on place le code G1 dans la table
D623 A2 07 LDX #$07 pour 8 elements
D625 BD 00 9C LDA $9C00,X on prend un code
D628 24 03 BIT $03 b6 du code=1 ?
D62A 70 03 BVS $D62F oui, on passe
D62C 3D 09 D7 AND $D709,X non, on disjoint les paves
D62F 09 40 ORA #$40 on force b6 a 1
D631 9D 00 9C STA $9C00,X et on sauve dans la table
D634 CA DEX
D635 10 EE BPL $D625
D637 4C B0 D6 JMP $D6B0 et on affiche
D63A A9 00 LDA #$00 A=0
D63C B0 02 BCS $D640 si C=1, on passe
D63E A5 32 LDA $32 sinon, A=VDTPAR
D640 4A LSR on isole la couleur de fond
D641 4A LSR
D642 4A LSR
D643 4A LSR
D644 29 07 AND #$07
D646 09 10 ORA #$10 force b4 a 1
D648 A2 0F LDX #$0F et on stock 16 fois de suite dans la table
D64A 9D 00 9C STA $9C00,X
D64D CA DEX
D64E 10 FA BPL $D64A
D650 4C 9F D6 JMP $D69F
D653 8A TXA caractere normal
D654 A2 13 LDX #$13 on calcule son adresse
D656 86 03 STX $03 #1300*8=#9800
D658 0A ASL auquel on ajoute 8*ASCII
D659 26 03 ROL $03
D65B 0A ASL
D65C 26 03 ROL $03
D65E 0A ASL
D65F 26 03 ROL $03
D661 85 02 STA $02 dans $02-03
D663 A0 07 LDY #$07 on lit les 8 codes
D665 B1 02 LDA ($02),Y
D667 09 40 ORA #$40 force b6 a 1 (pixel HIRES)
85
D669 99 00 9C STA $9C00,Y dans la table
D66C 88 DEY
D66D 10 F6 BPL $D665
D66F A4 38 LDY $38 on prend VDTX
D671 B1 2E LDA ($2E),Y on prend le code en VDTX,Y
D673 10 06 BPL $D67B si b7=0 on passe
D675 29 04 AND #$04 on isole b2 (souligne)
D677 D0 07 BNE $D680 oui
D679 F0 0A BEQ $D685 non
D67B 88 DEY on lit le code precedent
D67C 10 F3 BPL $D671 pas dÅfattribut ? on passe
D67E 30 05 BMI $D685 attribut, on gere
D680 A9 3F LDA #$3F on souligne le code
D682 8D 07 9C STA $9C07 dans la derniere ligne du caractere
D685 24 36 BIT $36 double larger ?
D687 10 16 BPL $D69F
D689 A2 07 LDX #$07
D68B BD 00 9C LDA $9C00,X
D68E 85 02 STA $02
D690 20 F5 D6 JSR $D6F5 le code de droite
D693 9D 08 9C STA $9C08,X
D696 20 F5 D6 JSR $D6F5 et celui de gauche
D699 9D 00 9C STA $9C00,X
D69C CA DEX
D69D 10 EC BPL $D68B
D69F 24 34 BIT $34 inverse video
D6A1 50 0D BVC $D6B0 non
D6A3 A0 0F LDY #$0F oui, on force b7 des octets
D6A5 B9 00 9C LDA $9C00,Y HIRES a 1
D6A8 09 80 ORA #$80 pour inversion video
D6AA 99 00 9C STA $9C00,Y
D6AD 88 DEY
D6AE 10 F5 BPL $D6A5
D6B0 A5 2C LDA $2C AY contient lÅfadresse du code
D6B2 A4 2D LDY $2D
D6B4 24 36 BIT $36 double hauteur ?
D6B6 50 07 BVC $D6BF non
D6B8 38 SEC oui, on passe une ligne au dessus
D6B9 E9 40 SBC #$40
D6BB 88 DEY
D6BC B0 01 BCS $D6BF
D6BE 88 DEY
D6BF 85 00 STA $00 et on stocke lÅfadresse dans RES
D6C1 84 01 STY $01
D6C3 A2 00 LDX #$00 Y=0
D6C5 46 03 LSR $03 b7 de $03=0
D6C7 A4 38 LDY $38 on lit lÅfabcisse du caractere
D6C9 BD 00 9C LDA $9C00,X on lit le code
D6CC 91 00 STA ($00),Y et on lÅfaffiche
D6CE 24 36 BIT $36 double largeur ?
D6D0 10 06 BPL $D6D8 non
D6D2 BD 08 9C LDA $9C08,X oui, on lit la deuxieme moitie
D6D5 C8 INY et on lÅfaffiche
D6D6 91 00 STA ($00),Y
86
D6D8 18 CLC
D6D9 A5 00 LDA $00 on ajoute 40 a lÅfadresse du caractere
D6DB 69 28 ADC #$28
D6DD 85 00 STA $00
D6DF 90 02 BCC $D6E3
D6E1 E6 01 INC $01
D6E3 24 36 BIT $36 double hauteur
D6E5 50 08 BVC $D6EF non
D6E7 A5 03 LDA $03 oui, on inverse b7
D6E9 49 80 EOR #$80 de $03
D6EB 85 03 STA $03
D6ED 30 D8 BMI $D6C7 on affiche deux fois la ligne
D6EF E8 INX
D6F0 E0 08 CPX #$08
D6F2 D0 D3 BNE $D6C7
D6F4 60 RTS
CALCULE A ET $02 POUR DOUBLE LARGEUR
Principe : On sort a droite 3 bits de $02 et on les double dans A. $02
contient en entree une ligne de definition dÅfun caractere, et en
sortie les 3 bits de gauche de cette ligne. Deux appels
successifs a cette routine retournent donc les parties droite et
gauche dÅfune ligne de caractere doublees.
D6F5 A9 00 LDA #$00 A=0
D6F7 A0 03 LDY #$03 pour 3 decalages
D6F9 46 02 LSR $02 on sort un bit dans C
D6FB 08 PHP on sauve C
D6FC 6A ROR on entre ce bit dans A
D6FD 28 PLP
D6FE 6A ROR deux fois
D6FF 88 DEY
D700 D0 F7 BNE $D6F9
D702 4A LSR on ramene a b0 dans A
D703 4A LSR
D704 29 3F AND #$3F inutile ! A contenait 0 en entree !
D706 09 40 ORA #$40 et on force b6 pour affichage HIRES
D708 60 RTS
TABLE DE CONVERSION POUR G1 DISJOINT
D709 BYT $1B,$1B ($1B=%00011011, ce qui disjoint %00xxxxxx par EOR)
D70B BYT $00,$1B (EOR %00000111)
D70D BYT $00,$1B (-------------)
D70F BYT $1B,$00 (%00011100 ce qui est bien le disjoint de %111)
87
AFFICHE UN MOTIF MOSAIQUE EN HIRES VIDEOTEX
Action : Affiche un morceau de mosaique (colonne dans VDTGX et ligne dans
VDTGY). Pour afficher le bloc, il faut savoir quÅfun bloc median a
trois lignes alors quÅfun bloc bordant a deux lignes. DÅfou le
calcul du depart. Ensuite on affiche simplement le bloc sans
deplacer les attributs.
D711 A9 00 LDA #$00 A=2
D713 A2 03 LDX #$03 X=3
D715 A4 3B LDY $3B on lit VDTGY (0, 1, ou 2 selon la ligne du motif)
D717 F0 09 BEQ $D722 Y=0 X=3 A=2
D719 CA DEX X=X-1
D71A A9 03 LDA #$03 A=3 si X=2
D71C 88 DEY si Y etait 1
D71D F0 03 BEQ $D722 X=2 et A=3 ok
D71F E8 INX
D720 A9 05 LDA #$05 X=3 et A=5
D722 20 69 CE JSR $CE69 A*40 dans AY on calcule la ligne Y
D725 A5 2C LDA $2C on additionne
D727 A4 2D LDY $2D
D729 20 89 CE JSR $CE89 lÅfadresse du motif
D72C A9 38 LDA #$38 %00111000 dans A
D72E A4 3A LDY $3A Y=VDTGX, 0 ou 1 (mosaique a deux colonnes)
D730 F0 02 BEQ $D734 si 0, on saute, A a le motif colonne 0
D732 A9 07 LDA #$07 sinon, motif colonne 1 = %00000111
D734 85 02 STA $02 dans RESB
D736 A4 38 LDY $38
D738 B1 00 LDA ($00),Y et on prend lÅfoctet
D73A 0A ASL on sort le bit de video inverse
D73B 30 02 BMI $D73F si pixels, on saute
D73D A9 80 LDA #$80 sinon, on force pixel
D73F 6A ROR sans alterer la video inverse
D740 45 02 EOR $02 on depose le motif
D742 91 00 STA ($00),Y et on le stocke
D744 98 TYA
D745 18 CLC
D746 69 28 ADC #$28 +40 pour ligne suivante
D748 A8 TAY
D749 CA DEX
D74A D0 EC BNE $D738
D74C 60 RTS et on sort
ETEINT LE CURSEUR VIDEOTEX
D74D 18 CLC C=0
D74E BYT $24 et on saute le SEC
88
ALLUMER LE CURSEUR VIDEOTEX
D74F 38 SEC C=1
D750 08 PHP on sauve P
D751 06 3D ASL $3D
D753 28 PLP
D754 66 3D ROR $3D et on met C dans b7 de FLGVD1
AFFICHER LE CURSEUR VIDEOTEX
D756 A9 80 LDA #$80 A=%10000000
D758 BYT $2C et on saute la suite
EFFACER LE CURSEUR VIDEOTEX
D759 A9 00 LDA #$00 A=%00000000
D75B 25 3D AND $3D si pas de curseur, alors on ne fait rien
D75D 24 3D BIT $3D est-on en mode graphique ?
D75F 50 02 BVC $D763 non, ok
D761 A9 00 LDA #$00 oui, pas de curseur
D763 85 02 STA $02 dans RESB
D765 A5 2C LDA $2C adresse de la ligne du curseur dans RES
D767 A4 2D LDY $2D
D769 85 00 STA $00
D76B 84 01 STY $01
D76D A4 38 LDY $38
D76F B1 30 LDA ($30),Y on lit le code actuel
D771 30 0A BMI $D77D si inverse video, on saute
D773 29 40 AND #$40 si attribute aussi
D775 F0 06 BEQ $D77D
D777 A5 02 LDA $02 on prend lÅfoctet
D779 49 80 EOR #$80 et on lui accole le curseur
D77B 85 02 STA $02 dans RESB
D77D A2 08 LDX #$08 on prend la position du curseur
D77F A4 38 LDY $38
D781 B1 00 LDA ($00),Y on prend le code qui sÅfy trouve
D783 29 7F AND #$7F on lui met le curseur ou non
D785 05 02 ORA $02
D787 91 00 STA ($00),Y et on le stocke
D789 18 CLC
D78A 98 TYA
D78B 69 28 ADC #$28 +40 pour ligne suivante
D78D A8 TAY
D78E 90 02 BCC $D792
D790 E6 01 INC $01 eventuellement poids fort aussi
D792 CA DEX pour 8 lignes
D793 D0 EC BNE $D781
D795 60 RTS
89
TABLE DE REDEFINITION POUR CARACTERES VIDEOTEX
SPECIAUX
D796 BYT $2F Åg/Åh devient plus longue
D797 BYT 01,02,04,04,08,08,10,20 codes hexadecimaux de
redefinition
D79F BYT $5C ÅgcÅh devient grand backslash (inverse de ci-dessus)
D7A0 BYT 20,10,08,08,04,04,02,01
D7A8 BYT $5F livre sterling devient trait bas
D7A9 BYT 00,00,00,00,00,00,00,3F
D7B1 BYT $60 copyright devient trait mi-hauteur
D7B2 BYT 00,00,00,3F,00,00,00,00
D7BA BYT $7B accolade gauche devient trait vertical a gauche
D7BB BYT 20,20,20,20,20,20,20,20
D7C3 BYT $7C barre vertical devient vertical mediane
D7C4 BYT 08,08,08,08,08,08,08,08
D7CC BYT $7D accolade fermee devient trait vertical a droite
D7CD BYT 01,01,01,01,01,01,01,01
D7D5 BYT $7E pave strie devient trait haut
D7D6 BYT 3F,00,00,00,00,00,00,00
D7DE BYT 00 fin de table de redefinition
GESTION DU CLAVIER
Action : Scrute le clavier et eventuellement, si une touche est pressee,
stocke la donnee dans le buffer et gere la repetition, etant
donne que lÅfon teste la repetition sur la colonne et non sur un
caractere precis, la pression simultanee (en fait impossible) sur
deux touches fait repeter la plus proche de la ligne 0 meme si on
la relache mais quÅfon garde lÅfautre pressee.
D7DF 20 03 D9 JSR $D903 on scrute le clavier
D7E2 F0 2E BEQ $D812 si aucune touche, on sort
D7E4 AE 70 02 LDX $0270 touche pressee au tour precedent ?
D7E7 10 08 BPL $D7F1 non
D7E9 AD 71 02 LDA $0271 la touche est celle que lÅfon avait pressee ?
D7EC 3D E8 01 AND $01E8,X oui, (X=128+col, $1E8+128=$268, KBDCOL !)
D7EF D0 16 BNE $D807 on gere la repetition
D7F1 88 DEY Y contient la colonne ou la touche a ete pressee
D7F2 B9 68 02 LDA $0268,Y on lit la colonne
D7F5 8D 71 02 STA $0271 dans $271
90
D7F8 98 TYA
D7F9 09 80 ORA #$80 et b7 de $270 a 1
D7FB 8D 70 02 STA $0270
D7FE 20 1F D8 JSR $D81F on convertit en ASCII et on gere le buffer
D801 AD 72 02 LDA $0272 on lit le nombre avant repetition
D804 4C 18 D8 JMP $D818 dans le compteur
D807 CE 74 02 DEC $0274 meme touche pressee, faut-il repeter ?
D80A D0 0F BNE $D81B non
D80C 20 1F D8 JSR $D81F oui, on convertit la meme touche dans le buffer
D80F 4C 15 D8 JMP $D815 et on indique touche pressee et delai
D812 8D 70 02 STA $0270 on nÅfindique pas de touche pressee
D815 AD 73 02 LDA $0273 on place le diviseur
D818 8D 74 02 STA $0274 de repetition dans la delai
D81B 60 RTS
D81C 4C DD D8 JMP $D8DD saut a la gestion de la touche FUNCT
CONVERSION EN ASCII DANS LE BUFFER
Action : DÅfapres le motif de la colonne et le numero de la colonne ou une
touche ete pressee. Les codes de controle sont geres
immediatement et la gestion de la touche FUNCT est separee. En
sortie, on trouve dans le buffer clavier deux codes, un code de
type KBDSHT et le code ASCII de la touche KBDSHT ; %CFxxxxxS, C=1
si CTRL, F=1 si FUNCT et S=1 si SHIFT presse.
D81F 20 BF C8 JSR $C8BF on gere la RS232 (decidement, on la gere partout)
D822 A9 00 LDA #$00 on posse 0
D824 48 PHA
D825 AD 70 02 LDA $0270 on lit le numero de colonne
D828 0A ASL dans b6b5b3
D829 0A ASL
D82A 0A ASL
D82B A8 TAY et Y
D82C AD 71 02 LDA $0271 on lit la colonne
D82F 4A LSR est-on sur la bonne ligne ?
D830 B0 03 BCS $D835 oui
D832 C8 INY non, ligne suivante
D833 90 FA BCC $D82F incoditionnel
D835 AD 6C 02 LDA $026C on lit colonne 4
D838 AA TAX dans X
D839 29 90 AND #$90 %10010000, SHIFT presse ?
D83B F0 08 BEQ $D845 non, on passe
D83D 68 PLA on met 1 dans la pile
D83E 09 01 ORA #$01 on indique SHIFT dans la pile
D840 48 PHA
D841 98 TYA on prend lÅfindex caractere
D842 69 3F ADC #$3F on ajoute 64 (C=1) pour majuscule
D844 A8 TAY
D845 98 TYA
91
D846 C9 20 CMP #$20 colonne 4 ?
D848 90 09 BCC $D853 en dessous
D84A E9 08 SBC #$08 on en leve une ligne
D84C C9 58 CMP #$58 %01011000, on depasse ?
D84E 90 02 BCC $D852 non
D850 E9 08 SBC #$08 on enleve une colonne
D852 A8 TAY on replace
D853 8A TXA on prend la colonne 4
D854 29 20 AND #$20 bit 5 ? (FUNCT)
D856 D0 C4 BNE $D81C oui, on gere la touche FUNCT
D858 B1 2A LDA ($2A),Y non, on lit le code ASCII de la touche demandee
D85A 2C 75 02 BIT $0275 majuscule ?
D85D 10 0A BPL $D869 non
D85F C9 61 CMP #$61 oui, on passe en majuscule
D861 90 06 BCC $D869 le code si il y a lieu
D863 C9 7B CMP #$7B
D865 B0 02 BCS $D869
D867 E9 1F SBC #$1F en enlevant 32 (C=0)
D869 A8 TAY code ASCII dans Y
D86A 8A TXA
D86B 29 04 AND #$04 touche CTRL ?
D86D F0 12 BEQ $D881 non
D86F 2D 6F 02 AND $026FC presse ?
D872 F0 05 BEQ $D879 non
D874 A9 80 LDA #$80 oui, on indique CTRL-C
D876 8D 7E 02 STA $027E pourquoi pas SEC/ROR ?
D879 68 PLA
D87A 09 80 ORA #$80 on indique CTRL dans la pila
D87C 48 PHA
D87D 98 TYA puisque CTRL, on limite le code
D87E 29 1F AND #$1F entre 0 et 31 (1 pour A, 2 pour B, etc Åc)
D880 A8 TAY
D881 98 TYA on lit le code dans A
D882 A2 00 LDX #$00 X=0
D884 48 PHA on pousse le code ASCII
D885 C9 06 CMP #$06 est-ce CTRL-F ?
D887 D0 07 BNE $D890 non
D889 AD 75 02 LDA $0275 oui, on bascule le bip clavier
D88C 49 40 EOR #$40
D88E B0 23 BCS $D8B3 inconditionnel
D890 C9 14 CMP #$14 est-ce CTRL-T ?
D892 F0 1A BEQ $D8AE oui
D894 C9 17 CMP #$17 est-ce CTRL-W ?
D896 D0 07 BNE $D89F non
D898 AD 75 02 LDA $0275 on force ESC=CTRL-T
D89B 49 20 EOR #$20
D89D B0 14 BCS $D8B3 inconditionnel
D89F C9 1B CMP #$1B est-ce ESC ?
D8A1 D0 13 BNE $D8B6 non
D8A3 AD 75 02 LDA $0275 oui, ESC=CTRL-T ?
D8A6 29 20 AND #$20
D8A8 F0 0C BEQ $D8B6 non
D8AA 68 PLA oui
D8AB A9 00 LDA #$00 on pousse 0 dans la pile
92
D8AD 48 PHA (on devrait pousser CTRL-T/#14 !)
D8AE AD 75 02 LDA $0275 on bascule le mode Majuscules
D8B1 49 80 EOR #$80
D8B3 8D 75 02 STA $0275 et on stocke FLGKBD
D8B6 68 PLA on sort la donnee
D8B7 A2 00 LDX #$00 X=buffer clavier (et de deux !)
D8B9 20 1D C5 JSR $C51D et on envoie le code ASCII
D8BC 68 PLA on sort le code KBDSHT
D8BD A2 00 LDX #$00 encore ?!?!?! decidement Åc
D8BF 20 1D C5 JSR $C51D et on ecrit le code KBDSHT
D8C2 2C 75 02 BIT $0275 bip clavier actif ?
D8C5 50 07 BVC $D8CE BVC $D8F9 aurait permis de gagner un octet Åc
D8C7 A2 CF LDX #$CF on indexe bip clavier
D8C9 A0 D8 LDY #$D8
D8CB 4C E7 D9 JMP $D9E7 et on emet
D8CE 60 RTS
DONNEES BIP CLAVIER
D8CF BYT 1F,00,00,00,00,00,00 soit periode 0,5 ms ou frequence 2 Khz
D8D6 BYT 3E,10,00,00 pour canal A, volume gere par lÅfenveloppe
D8D9 BYT 1F,00,00 pour envelope 0, periode 0,5 ms
GESTION DE LA TOUCHE FUNCT
Action : On teste dÅfabord si FUNCT sert a obtenir le copyright ou le pave
strie. Si cÅfest le cas, on nÅfindique pas FUNCT presse. Sinon, on
teste sÅfil y a une gestion utilisateur de la touche FUNCT. Sinon,
on sort. Si oui, on saute a la gestion utilisateur dont les
premiers codes doivent etre PHA pour sortir KBDSHT de la pile et
LDA ($2A),Y pour lire lÅfASCII de la touche de fonction.
D8DD B1 2A LDA ($2A),Y on lit le code ASCII de la touche pressee
D8DF C9 2D CMP #$2D est-ce Åg=Åh
D8E1 F0 15 BEQ $D8F8 oui, on affiche le copyright
D8E3 C9 3D CMP #$3D est-ce Åg-Åg
D8E5 F0 14 BEQ $D8FB oui, on affiche le pave strie
D8E7 68 PLA aucun des deux
D8E8 09 40 ORA #$40 on indique FUNCT pressee
D8EA 48 PHA
D8EB AD 75 02 LDA $0275 faut-il gerer les touches de fonctions ?
D8EE 4A LSR
D8EF B0 0F BCS $D900 oui, Y contient lÅfindex de la touche
D8F1 B1 2A LDA ($2A),Y on lit le code
D8F3 29 1F AND #$1F comme CTRL
D8F5 09 80 ORA #$80 mais en inverse video
D8F7 BYT 2C sauter lÅfinstruction suivante
D8F8 A9 60 LDA #$60 indexe c
93
D8FA BYT 2C sauter lÅfinstruction suivante
D8FB A9 7E LDA #$7E indexe pave strie
D8FD 4C 82 D8 JMP $D882 et on envoie les donnees dans le buffer
D900 6C 76 02 JMP ($0276) gestion FUNCT utilisateur
SCRUTATION DU CLAVIER
Principe : On envoie au PSG le numero de la ligne sous la forme 255-2
(colonne), c'est-a-dire en mettant a 0 le bit colonne, ce qui
donne %10111111 pour la colonne 1. Ensuite, la donnee reste sur
le port, on va donc pouvoir tester les 8 lignes sans sÅfen
soucier. Pour tester une ligne, on met son numero dans PB0-1-2,
et on met le strobe clavier pour demander le test. Quelque
microsecondes apres, le strobe est a 1 si le contact etait fait a
lÅfintersection ligne/colonne. Auquel cas on indique dans KBDCOL
un bit a 1 dans la bonne colonne.
Avant de sortir, on teste si une touche a ete pressee, auquel cas
Z=0, sinon Z=1. En sortie, Y contient le numero de la colonne ou
une touche a ete pressee. Si plusieurs touches ont ete pressees,
cÅfest le plus proche de lig/col 0/0 qui sera prise en compte.
D903 A0 07 LDY #$07 pour 8 colonnes
D905 A9 7F LDA #$7F %01111111 pour motif colonne 7
D907 48 PHA dans la pile
D908 AA TAX
D909 A9 0E LDA #$0E registre 14 du PSG (IOA)
D90B 20 1A DA JSR $DA1A on envoie la colonne
D90E A9 00 LDA #$00 on met 0 dans la colonne pour lÅfinstant
D910 99 68 02 STA $0268,Y
D913 20 BF C8 JSR $C8BF on gere la RS232 en guise de delai de reponse (!)
D916 AD 00 03 LDA $0300 on lit port B
D919 29 B8 AND #$B8 dans A (on elimine le numero de ligne)
D91B AA TAX dans X
D91C 18 CLC
D91D 69 08 ADC #$08 on ajoute 8 (pour forcer le strobe)
D91F 85 1F STA $1F dans $1F
D921 8E 00 03 STX $0300 on repose le port B. b2b1b0 contient la ligne
D924 E8 INX on passe a la ligne suivante
D925 A9 08 LDA #$08 a-t-on un strobe ?
D927 2D 00 03 AND $0300
D92A D0 06 BNE $D932 oui, touche pressee
D92C E4 1F CPX $1F non, on a fini le teste ?
D92E D0 F1 BNE $D921 non, ligne suivante
D930 F0 14 BEQ $D946 inconditionnel
D932 CA DEX on prend la ligne
D933 8A TXA
D934 48 PHA que lÅfon sauve
D935 29 07 AND #$07 isole le numero (pas b7)
D937 AA TAX
D938 BD A9 D9 LDA $D9A9,X lit la position du bit correspondant
94
D93B 19 68 02 ORA $0268,Y et le place
D93E 99 68 02 STA $0268,Y dans la bonne colonne
D941 68 PLA
D942 AA TAX
D943 E8 INX on recupere lÅfindexe
D944 D0 E6 BNE $D92C inconditionnel
D946 68 PLA on sort le motif de la colonne
D947 38 SEC que lÅfon decale
D948 6A ROR pour colonne suivante
D949 88 DEY on compte une colonne en moins
D94A 10 BB BPL $D907 fini ? non
D94C A0 08 LDY #$08 on va lire les 8 colonnes
D94E B9 67 02 LDA $0267,Y on en lit une
D951 D0 08 BNE $D95B non nulle, une touche a ete pressee
D953 C0 06 CPY #$06 colonne 4 ?
D955 D0 01 BNE $D958 non
D957 88 DEY oui, on saute (SHIFT, CTRL et FUNCT)
D958 88 DEY colonne suivante
D959 D0 F3 BNE $D94E si pas de touche pressee, Z=1
D95B 60 RTS <- une touche a ete pressee, Z=0
GESTION DE LÅfE/S CLAVIER
Principe : Comme toutes les routines dÅfE/S, N,V et C decident de
lÅfoperation. Pour ouvrir lÅfE/S, on autorise les IRQ a raison de 4
par seconde, et pour fermer lÅfE/S, on interdit les IRQ par T1. En
sortie de lecture, est a 0 si une touche valide etait presente
dans le buffer. A noter le manque dÅfoptimisation a la fin de la
routine ; plus on avance . . .
D95C 30 27 BMI $D985 N=1, ouverture ou fermeture
D95E A9 01 LDA #$01 lecture, A=1 dans $2A8 et $2A6
D960 8D A8 02 STA $02A8
D963 8D A6 02 STA $02A6
D966 08 PHP
D967 78 SEI on interdit les IRQ
D968 A2 00 LDX #$00
D96A 20 18 C5 JSR $C518 y a-t-il une donnee dans le buffer clavier ?
D96D B0 13 BCS $D982 non, C=1 et on sort
D96F 8D 79 02 STA $0279 oui, on la stocke en $279
D972 A2 00 LDX #$00 on lit le deuxieme code
D974 20 18 C5 JSR $C518 sÅfil nÅfy en a pas, on sort
D977 B0 09 BCS $D982 avec C=1
D979 8D 78 02 STA $0278 on stocke le code KBDSHT
D97C AD 79 02 LDA $0279 et dans A le code ASCII
D97F 28 PLP et on sort avec C=0
D980 18 CLC
D981 60 RTS
D982 28 PLP pour economiser un RTS, on aurait pu coder la
D983 38 SEC sequence PLP/CLC/RTS/PLP/SEC/RTS par PLP/CLC/
95
D984 60 RTS BIT $3808/RTS et pointer sur 08/38 pour C=1
D985 90 06 BCC $D98D si C=0 on ouvre
D987 A9 40 LDA #$40 on interdit les interruptions par T1
D989 8D 0E 03 STA $030E dans V1IER (Interrupt Enable Register)
D98C 60 RTS donc Entree clavier fermee
D98D AD 0B 03 LDA $030B on lit V1ACR
D990 09 40 ORA #$40 on force MT1 (mode roue libre sur T1)
D992 8D 0B 03 STA $030B
D995 A9 A8 LDA #$A8 AY=$61A8, soit 25000 soit 40 IRQ par secondes
D997 A0 61 LDY #$61
D999 8D 04 03 STA $0304 dans V1T1 timer T1
D99C 8C 05 03 STY $0305
D99F A9 C0 LDA #$C0 on autorise les IRQ par T1
D9A1 8D 0E 03 STA $030E
VIDE LE BUFFER CLAVIER
Remarque : Une fonction qui aurait eu sa place dans lÅfHYPER-BASIC . . .
D9A4 A2 00 LDX #$00 on indexe buffer clavier
D9A6 4C 0C C5 JMP $C50C et on vide
D9A9 BYT 1,2,4,8,16,32,64 puissances de deux pour scrutation
Clavier
INITIALISE LE CLAVIER
Remarque : LÅfusage des variables $2A6 $2A7 et $2A8 est encore mal defini.
D9B1 A9 FF LDA #$FF PORT A en sortie (PSG)
D9B3 8D 03 03 STA $0303 dans V1DDRA
D9B6 8D A7 02 STA $02A7 et $2A7
D9B9 A9 F7 LDA #$F7 %11110111 PB3 en entree (strobe clavier)
D9BB 8D 02 03 STA $0302 dans V1DDRB
D9BE A9 01 LDA #$01
D9C0 8D 73 02 STA $0273 on indique vitesse
D9C3 8D 74 02 STA $0274 de repetition maximale
D9C6 8D A8 02 STA $02A8
D9C9 8D A6 02 STA $02A6
D9CC A9 0E LDA #$0E et 14 IRQ (1/3 seconde) avant repetition
D9CE 8D 72 02 STA $0272
D9D1 A9 3F LDA #$3F table ASCII en $FA3F
D9D3 A0 FA LDY #$FA
D9D5 85 2A STA $2A
D9D7 84 2B STY $2B
D9D9 4E 70 02 LSR $0270 pas de code pour repetition
D9DC A9 C0 LDA #$C0 majuscule et bip clavier
D9DE 8D 75 02 STA $0275
D9E1 A9 00 LDA #$00 et pas CTRL-C
D9E3 8D 7E 02 STA $027E
D9E6 60 RTS
96
ENVOI DE 14 PARAMETRES AU PSG
Action : Envoie 14 valeurs au PSG (R0-R13), soit un son completement
defini. Par souci dÅfoptimisation, la routine a deux points
dÅfentee selon quÅfon lÅfappelle de la banque 7 ou dÅfune autre.
Dans tous les cas, les 14 parametres sont a lÅfadresse XY.
D9E7 18 CLC en $D9E7, C=0, lÅfappel vient de la banque 7
D9E8 BYT $24 on saute le SEC
D9E9 38 SEC en $D9E9, C=1, lÅfappel ne vient pas de la banque 7
D9EA 08 PHP on sauve P
D9EB 78 SEI
D9EC A5 16 LDA $16 et lÅfadresse en $15-$16
D9EE 48 PHA
D9EF A5 15 LDA $15
D9F1 48 PHA
D9F2 86 15 STX $15 et on met lÅfadresse des parametres
D9F4 84 16 STY $16 dans $15-$16
D9F6 08 PHP on sauve C
D9F7 A0 00 LDY #$00 Y=0
D9F9 28 PLP on lit C mais on le laisse dans la pile
D9FA 08 PHP
D9FB B0 04 BCS $DA01 si C=0
D9FD B1 15 LDA ($15),Y on lit la donne simplement
D9FF 90 03 BCC $DA04 sinon
DA01 20 11 04 JSR $0411 on passe par la gestion de banques
DA04 AA TAX dans X
DA05 98 TYA registre dans A
DA06 48 PHA inutile (la routine sÅfen occupe)
DA07 20 1A DA JSR $DA1A on envoie la donnee au PSG
DA0A 68 PLA inutile aussi
DA0B A8 TAY
DA0C C8 INY
DA0D C0 0E CPY #$0E et 14 donnees
DA0F D0 E8 BNE $D9F9
DA11 28 PLP on sort C
DA12 68 PLA
DA13 85 15 STA $15 on recupere $15-$16
DA15 68 PLA
DA16 85 16 STA $16
DA18 28 PLP et P
DA19 60 RTS
97
ENVOIE UNE DONNEE AU PSG
Principe : Place la valeur X dans le registre A du PSG AY3-8912.
Les broches Bdir et BC1 du PSG sont reliees respectivement aux
Broches CB2 et CA2. Pour indiquer un registre, on met CA2 et
CB2 a 1, une donnee, CA2 a1 et CB2 a 0. La validation se fait
avec CB2 et CA2 a 0. Cette simplicite est due au fait que sur
lÅfORIC, la broche BC2 du PSG est forcee a lÅfetat haut.
DA1A 48 PHA on sauve le numero de registre
DA1B 8D 0F 03 STA $030F sur V1DRAB
DA1E C9 07 CMP #$07 registre dÅfautorisation ?
DA20 D0 04 BNE $DA26 non
DA22 8A TXA oui, on force
DA23 09 40 ORA #$40 le port A du PSG en sortie
DA25 AA TAX
DA26 98 TYA registre dans A
DA27 48 PHA dans la pile
DA28 08 PHP
DA29 78 SEI interdit les IRQ
DA2A AD 0C 03 LDA $030C V1PCR
DA2D 29 11 AND #$11 sans changer les modes de transition
DA2F A8 TAY dans Y
DA30 09 EE ORA #$EE on force CA2 et CB2 a 1
DA32 8D 0C 03 STA $030C pour indiquer le registre
DA35 98 TYA on recupere V1PCR
DA36 09 CC ORA #$CC CA2 et CB2 a 0
DA38 8D 0C 03 STA $030C pour valider le registre
DA3B 8E 0F 03 STX $030F on met la valeur sur V1DRAB
DA3E 98 TYA on recupere V1PCR
DA3F 09 EC ORA #$EC CA2 a 1 et CB2 a 0
DA41 8D 0C 03 STA $030C pour indiquer donnee
DA44 98 TYA
DA45 09 CC ORA #$CC CA2 et CB2 a 0
DA47 8D 0C 03 STA $030C pour valider la donnee
DA4A 28 PLP on sort P
DA4B 68 PLA Y
DA4C A8 TAY
DA4D 68 PLA et A
DA4E 60 RTS
COUPE LE SON DU PSG
DA4F A9 07 LDA #$07 registre 7 (autorisation)
DA51 A2 7F LDX #$7F %01111111, tous canaux eteints
DA53 4C 1A DA JMP $DA1A au PSG
98
INITIALISE LÅfIMPRIMANTE
Principe : Rien de bien complique, si ce nÅfest que le vecteur HCOPY est
$250 et non $24E comme indique dans le manuel developpeur.
DA56 A9 50 LDA #$50 80 colonnes
DA58 8D 88 02 STA $0288 dans LPRFX
DA5B A9 00 LDA #$00 ligne 0
DA5D 8D 86 02 STA $0286 dans LPRX
DA60 A9 80 LDA #$80 imprimante prete
DA62 8D 8A 02 STA $028A dans FLGLPR
DA65 A9 53 LDA #$53 $E253 (HCOPY)
DA67 A0 E2 LDY #$E2
DA69 8D 50 02 STA $0250 dans $250-$251
DA6C 8C 51 02 STY $0251
DA6F 60 RTS
GERE LA SORTIE IMPRIMANTE
Principe : LÅfE/S est geree comme les autres. Les imprimantes serie sont
prises en compte et il nÅfexiste pas de fermeture dÅfimprimante. En
ouverture, les IRQ par ACK sont autorisees pour determiner quand
lÅfimprimante est prete a recevoir une donnee.
DA70 30 60 BMI $DAD2 ouverture ou fermeture
DA72 48 PHA ecriture, on sauve les registres
DA73 8A TXA A et X
DA74 48 PHA
DA75 A9 82 LDA #$82 on autorise les IRQ par CA1 (ACK)
DA77 8D 0E 03 STA $030E
DA7A BA TSX
DA7B BD 02 01 LDA $0102,X on prend la donnee
DA7E 20 A5 DA JSR $DAA5 on lÅfenvoie
DA81 2C 8A 02 BIT $028A gerer CRLF ?
DA84 70 1B BVS $DAA1 non
DA86 C9 20 CMP #$20 oui, la donnee est un espace ?
DA88 B0 06 BCS $DA90 au dessus, on passe
DA8A C9 0D CMP #$0D un RETURN ?
DA8C D0 13 BNE $DAA1 non
DA8E F0 0C BEQ $DA9C oui, on reprend a 0
DA90 AE 86 02 LDX $0286 on ajoute 1 a lÅfabscisse
DA93 E8 INX
DA94 EC 88 02 CPX $0288 on est au bout ?
DA97 90 05 BCC $DA9E non
DA99 20 E4 DA JSR $DAE4 oui, on saute une ligne
DA9C A2 00 LDX #$00 et on met 0
DA9E 8E 86 02 STX $0286 dans la position du stylo
99
DAA1 68 PLA
DAA2 AA TAX on restaure les registres et on sort
DAA3 68 PLA
DAA4 60 RTS
DAA5 AA TAX Donnee dans X
DAA6 AD 8A 02 LDA $028A mode RS232 ?
DAA9 29 04 AND #$04
DAAB F0 08 BEQ $DAB5 non, parallele
DAAD 20 2F DB JSR $DB2F oui, on prepare la RS232
DAB0 8A TXA donnee dans A
DAB1 A2 18 LDX #$18 X=buffer ACIA sortie
DAB3 D0 0A BNE $DABF inconditionnel
DAB5 AD 0D 02 LDA $020D imprimante detectee ?
DAB8 29 02 AND #$02
DABA F0 15 BEQ $DAD1 non, on sort
DABC 8A TXA oui, donnee dans A
DABD A2 24 LDX #$24 X=buffer CENTRONICS sortie
DABF 2C 8A 02 BIT $028A gerer CRLF ?
DAC2 70 06 BVS $DACA non
DAC4 C9 7F CMP #$7F oui, A=DEL (127) ?
DAC6 D0 02 BNE $DACA non
DAC8 A9 20 LDA #$20 oui, on envoie un espace
DACA 48 PHA on sauve la donnee (inutile !!!)
DACB 20 1D C5 JSR $C51D on lÅfecrit
DACE 68 PLA on la recupere (inutile ! la routine la restitue)
DACF B0 EE BCS $DABF si lÅfecriture nÅfa pas eu lieu, on boucle
DAD1 60 RTS
DAD2 B0 0C BCS $DAE0 fermeture (rien en fait)
DAD4 AD 8A 02 LDA $028A ouverture, imprimante serie ?
DAD7 29 04 AND #$04
DAD9 D0 06 BNE $DAE1 oui
DADB A9 82 LDA #$82 on autorise les IRQ par CA1
DADD 8D 0E 03 STA $030E pour le ACK
DAE0 60 RTS
DAE1 4C 7D DB JMP $DB7D
ENVOIE UN CR,LF SUR IMPRIMANTE
DAE4 48 PHA on sauve A
DAE5 A9 0D LDA #$0D on envoie un CR
DAE7 20 72 DA JSR $DA72
DAEA AD 8A 02 LDA $028A si pas LF apres CR
DAED 4A LSR
DAEE B0 05 BCS $DAF5 on passe
DAF0 A9 0A LDA #$0A sinon, on envoie
DAF2 20 72 DA JSR $DA72 un LF
DAF5 68 PLA on recupere A
DAF6 60 RTS
100
GESTION DE LÅfENTREE MINITEL
DAF7 30 05 BMI $DAFE ouverture- fermeture
DAF9 A2 0C LDX #$0C lecture : on indexe le buffer ACIA entree
DAFB 4C 18 C5 JMP $C518 et on lit un code
DAFE B0 09 BCS $DB09 C=1, on ferme
DB00 AD 1E 03 LDA $031E ouverture : on lit ACIACR
DB03 29 0D AND #$0D %00001101 isole b0 b2 et b3
DB05 09 60 ORA #$60 %01100000 force b6b5 a 1
DB07 D0 3A BNE $DB43 inconditionnel
DB09 AD 1E 03 LDA $031E
DB0C 09 02 ORA #$02 force b1 a 1 dans
DB0E 8D 1E 03 STA $031E ACIACR
DB11 60 RTS
GESTION DE LA SORTIE MINITEL
Principe : NÅfetant guere familiarise avec les modes de fonctionnement de
lÅfACIA, je vous donne la source mais je serais bien incapable
dÅfexpliciter les modifications dÅfACIACR et dÅfACIACT, registres de
controle et de commande de lÅfACIA 6551.
DB12 30 26 BMI $DB3A ouverture-fermeture
DB14 AA TAX donnee dans X
DB15 10 0F BPL $DB26 si <128, on passe
DB17 C9 C0 CMP #$C0 sinon, cÅfest <128+64 ?
DB19 B0 0B BCS $DB26
DB1B 09 40 ORA #$40 oui, on force b7
DB1D 48 PHA
DB1E A9 1B LDA #$1B et on envoie un ESC avant
DB20 A2 18 LDX #$18 la donnee
DB22 20 1D C5 JSR $C51D
DB25 68 PLA
DB26 48 PHA
DB27 A2 18 LDX #$18 on envoie la donnee
DB29 20 1D C5 JSR $C51D dans le BUFFER ACIA sortie
DB2C 68 PLA
DB2D B0 F7 BCS $DB26 si la donnee nÅfa pas ete ecrite, on boucle
DB2F AD 1E 03 LDA $031E on prend V2IER
DB32 29 F3 AND #$F3 %11110011 force b2 a 0
DB34 09 04 ORA #$04 et b3 a 1
DB36 8D 1E 03 STA $031E dans ACIACR
DB39 60 RTS
DB3A B0 17 BCS $DB53 C=1 on ferme
DB3C AD 1E 03 LDA $031E ouverture
DB3F 29 02 AND #$02 ACIACR a 0 sauf b1
DB41 09 65 ORA #$65 %01101001, bits forces a 1
DB43 8D 1E 03 STA $031E dans ACIACR
DB46 AD 21 03 LDA $0321 V2DRA
DB49 29 EF AND #$EF %11101111 force mode MINITEL
DB4B 8D 21 03 STA $0321
101
DB4E A9 38 LDA #$38 %00111000 dans ACIACT
DB50 8D 1F 03 STA $031F
DB53 60 RTS et on sort
INITIALISE LES VALEURS RS232
DB54 A9 1E LDA #$1E %00011110 transmission 8 bits, horologe interne
DB56 85 59 STA $59 1 bit de stop, 9600 bauds dans RS232T
DB58 A9 00 LDA #$00 pas dÅfecho et pas de parite
DB5A 85 5A STA $5A dans RS232C
DB5C 60 RTS
GESTION DE LÅfENTREE RS232
DB5D 10 98 BPL $DAF7 lecture, voir MINITEL (pourquoi pas $DAF9 ?)
DB5F B0 A8 BCS $DB09 C=1, on ferme
DB61 AD 1E 03 LDA $031E on ouvre
DB64 29 0D AND #$0D on fixe le mode de controle
DB66 05 5A ORA $5A dans la RS232
DB68 8D 1E 03 STA $031E
DB6B AD 21 03 LDA $0321
DB6E 09 10 ORA #$10 %00010000 on force RS232
DB70 8D 21 03 STA $0321
DB73 A5 59 LDA $59 et on fixe le mode de transmission
DB75 8D 1F 03 STA $031F dans ACIACR
DB78 60 RTS
GESTION DE LA SORTIE RS232
DB79 10 AB BPL $DB26 ecriture, comme MINITEL
DB7B B0 D6 BCS $DB53 pas de fermeture (RTS)
DB7D AD 1E 03 LDA $031E ouverture, on lit ACIACR
DB80 29 02 AND #$02 isole b1
DB82 09 05 ORA #$05 %00000101 force b0 et b2 a 1
DB84 D0 E0 BNE $DB66 inconditionnel
GESTION DES SORTIES EN MODE TEXT
Principe : Tellement habituel que ca en devient monotone . . . mais bien
pratique !
DB86 48 PHA on sauve A et P
DB87 08 PHP
DB88 A9 00 LDA #$00 fenetre 0
102
DB8A F0 10 BEQ $DB9C inconditionnel
DB8C 48 PHA
DB8D 08 PHP
DB8E A9 01 LDA #$01 fenetre 1
DB90 D0 0A BNE $DB9C
DB92 48 PHA
DB93 08 PHP
DB94 A9 02 LDA #$02 fenetre 2
DB96 D0 04 BNE $DB9C
DB98 48 PHA
DB99 08 PHP
DB9A A9 03 LDA #$03 fenetre 3
DB9C 85 28 STA $28 stocke la fenetre dans SCRNB
DB9E 28 PLP on lit la commande
DB9F 10 03 BPL $DBA4 ecriture
DBA1 4C CE DE JMP $DECE ouverture
DBA4 68 PLA on lit la donnee
DBA5 85 29 STA $29 que lÅfon sauve
DBA7 AD 8A 02 LDA $028A echo sur imprimante ?
DBAA 29 02 AND #$02
DBAC F0 05 BEQ $DBB3 non
DBAE A5 29 LDA $29 oui, on envoie le code sur lÅfimprimante
DBB0 20 72 DA JSR $DA72
DBB3 A5 29 LDA $29
AFFICHE CODE A DANS FENETRE X
Principe : On lit le code, si cÅfest un caractere, on lÅfaffiche simplement.
Si cÅfest un caractere de controle, alors la cÅfest la folie !
On empile lÅfadresse de retour general des codes de controle (il
remettre le curseur, ajuster les coordonnees et depiler les
registres), puis lÅfadresse de gestion dudit code de controle. Un
RTS bien place suffira a executer cette routine, routine dont le
RTS terminera proprement lÅfaffichage (ou la gestion) dudit code.
Ouf !
DBB5 85 29 STA $29
DBB7 48 PHA on sauve les registres
DBB8 8A TXA
DBB9 48 PHA
DBBA 98 TYA
DBBB 48 PHA
DBBC A6 28 LDX $28 on lit la fenetre
DBBE BD 18 02 LDA $0218,X on stocke lÅfadresse de la fenetre
DBC1 85 26 STA $26 dans ADSCR
DBC3 BD 1C 02 LDA $021C,X
103
DBC6 85 27 STA $27
DBC8 A5 29 LDA $29 on prend le code
DBCA C9 20 CMP #$20 espace ?
DBCC B0 7E BCS $DC4C caractere
DBCE BD 48 02 LDA $0248,X code de controle, on prend FLGSCR
DBD1 48 PHA dans la pile
DBD2 20 1E DE JSR $DE1E on eteint le curseur
DBD5 A9 DC LDA #$DC on empile la fin de gestion
DBD7 48 PHA soit $DC2B-1 car on sÅfy branche par RTS
DBD8 A9 2A LDA #$2A
DBDA 48 PHA
DBDB A5 29 LDA $29 on lit le code
DBDD 0A ASL
DBDE A8 TAY
DBDF B9 EC DB LDA $DBEC,Y on lit le poids fort
DBE2 48 PHA dans la pile
DBE3 B9 EB DB LDA $DBEB,Y et le poids faible
DBE6 48 PHA dans la pile de lÅfadresse de gestion du code
DBE7 A9 00 LDA #$00 A=0
DBE9 38 SEC C=1
DBEA 60 RTS on gere le code
TABLE DE GESTION DES CODES DE CONTROLE
Principe : Chaque code de controle est gere par une routine particuliere
que lÅfon appelle par RTS. Les adresses stockees ici doivent donc
etre incrementees pour donner lÅfadresse exacte de gestion du
code. On calcule lÅfadresse de gestion dÅfun code par
DEEK($DBE9+2*code)+1.
DBEB BYT $DCEA-1 code 0 non gere
DBED BYT $DCEB-1 1 CTRL-A Tabulation
DBEF BYT $DCEA-1 2 CTRL-B non gere
DBF1 BYT $DCEA-1 3 CTRL-C deja gere (Durant le codage)
DBF3 BYT $DD0D-1 4 CTRL-D double hauteur
DBF5 BYT $DCEA-1 5 CTRL-E non gere
DBF7 BYT $DCEA-1 6 CTRL-F deja gere
DBF9 BYT $DDD8-1 7 CTRL-G emet un OUPS
DBFB BYT $DD47-1 8 CTRL-H deplacement curseur a gauche
DBFD BYT $DD92-1 9 CTRL-I deplacement curseur a droite
DBFF BYT $DD9D-1 10 CTRL-J deplacement curseur vers le bas
DC01 BYT $DD55-1 11 CTRL-K deplacement curseur vers le haut
DC03 BYT $DDB8-1 12 CTRL-L efface lÅfecran
DC05 BYT $DD67-1 13 CTRL-M saut de ligne
DC07 BYT $DD74-1 14 CTRL-N efface une ligne
DC09 BYT $DCEA-1 15 CTRL-O non gere
DC0B BYT $DD12-1 16 CTRL-P curseur fixe/clignotant
DC0D BYT $DD13-1 17 CTRL-Q curseur absent/present
DC0F BYT $DDCF-1 18 CTRL-R echo imprimante
DC11 BYT $DDCC-1 19 CTRL-S TCOPY (pourquoi pas $E1B9-1?!)
DC13 BYT $DCEA-1 20 CTRL-T deja gere
104
DC15 BYT $DCEA-1 21 CTRL-U non gere
DC17 BYT $DD11-1 22 CTRL-V video inverse/normale
DC19 BYT $DCEA-1 23 CTRL-W deja gere
DC1B BYT $DD7A-1 24 CTRL-X effacement de fin de ligne
DC1D BYT $DCEA-1 25 CTRL-Y non gere
DC1F BYT $DCEA-1 26 CTRL-Z non gere
DC21 BYT $DD0F-1 27 ESC code ecran
DC23 BYT $DD0F-1 28 ??? comme ESC
DC25 BYT $DD10-1 29 CTRL-Åò (crochet ferme) 38/40 colonnes
DC27 BYT $DDFB-1 30 HOME ramene le curseur en 0,0
DC29 BYT $DD0E-1 31 US adressage direct du curseur
SORTIE DE GESTION DES CODES DE CONTROLE
DC2B A6 28 LDX $28 on prend la fenetre dans X
DC2D BC 20 02 LDY $0220,X position colonne
DC30 B1 26 LDA ($26),Y on lit le code sous le curseur
DC32 9D 4C 02 STA $024C,X et on le place dans CURSCR
DC35 A5 26 LDA $26 on stocke lÅfadresse de la fenetre X
DC37 9D 18 02 STA $0218,X dans ADSCRL
DC3A A5 27 LDA $27
DC3C 9D 1C 02 STA $021C,X ADSCRH
DC3F 68 PLA on recupere FLGSCR
DC40 9D 48 02 STA $0248,X que lÅfon replace
DC43 20 2D DE JSR $DE2D on inverse le curseur ($DE30 aurait ete mieux !)
DC46 68 PLA on restaure les registres
DC47 A8 TAY
DC48 68 PLA
DC49 AA TAX
DC4A 68 PLA
DC4B 60 RTS et on sort definitivement
AFFICHAGE DÅfUN CARACTERE
DC4C BD 48 02 LDA $0248,X on prend le flag de la fenetre X
DC4F 29 0C AND #$0C %00001100, ESC ou US en cours ?
DC51 D0 47 BNE $DC9A oui
DC53 A5 29 LDA $29 non, on prend le code
DC55 10 06 BPL $DC5D caractere normal
DC57 C9 A0 CMP #$A0 <128+32 ?
DC59 B0 02 BCS $DC5D non
DC5B 29 7F AND #$7F oui, on en fait un code simple
DC5D 85 29 STA $29 dans $29
DC5F 20 6B DC JSR $DC6B on affiche le code
DC62 A9 09 LDA #$09 puis on deplace le curseur vers la droite
DC64 85 29 STA $29
DC66 4C CE DB JMP $DBCE
105
PLACEMENT DÅfUN CODE A LÅfECRAN
Principe : Trivial dans son ensemble puisquÅfil gere les sequences ESC et
US sequentiellement. Ca se complique lorsque des appels recursifs
croises entrent en jeu. Cette routine fait au moins preuve dÅfune
grande optimisation. En entree, X contient le numero de la
fenetre et A le code a afficher.
DC69 85 29 STA $29 on sauve le code
DC6B A0 80 LDY #$80 Y=128
DC6D BD 48 02 LDA $0248,X on lit FLGSCR
DC70 29 20 AND #$20 video inverse ?
DC72 D0 02 BNE $DC76 oui, on laisse Y
DC74 A0 00 LDY #$00 non, Y=0
DC76 98 TYA dans A
DC77 05 29 ORA $29 on superpose le code
DC79 9D 4C 02 STA $024C,X dans CURSCR
DC7C BC 20 02 LDY $0220,X et sur lÅfecran
DC7F 91 26 STA ($26),Y
DC81 BD 48 02 LDA $0248,X
DC84 29 02 AND #$02 double hauteur ?
DC86 F0 11 BEQ $DC99 non
DC88 BD 24 02 LDA $0224,X oui
DC8B DD 34 02 CMP $0234,X on est a la fin de la fenetre ?
DC8E F0 09 BEQ $DC99 oui
DC90 98 TYA non, on ajoute 40 colonnes (1 ligne)
DC91 69 28 ADC #$28
DC93 A8 TAY
DC94 BD 4C 02 LDA $024C,X
DC97 91 26 STA ($26),Y et on affiche encore le code
DC99 60 RTS
DC9A 29 08 AND #$08 est-ce ESC ?
DC9C F0 1A BEQ $DCB8 non, US
DC9E A5 29 LDA $29 oui, on lit le code
DCA0 30 A4 BMI $DC46 >128, on sort
DCA2 C9 40 CMP #$40 <64 (ÅgAÅh-1) ?
DCA4 90 A0 BCC $DC46 oui, on sort
DCA6 29 1F AND #$1F sinon, on isole le code (0-31)
DCA8 20 69 DC JSR $DC69 on le place a lÅfecran
DCAB A9 09 LDA #$09 on deplace le curseur a droite
DCAD 20 B5 DB JSR $DBB5
DCB0 A9 1B LDA #$1B on envoie un ESC (fin de ESC)
DCB2 20 B5 DB JSR $DBB5
DCB5 4C 46 DC JMP $DC46 et on sort
DCB8 BD 48 02 LDA $0248,X US, on lit FLGSCR
DCBB 48 PHA que lÅfon sauve
DCBC 20 1E DE JSR $DE1E on eteint le curseur
DCBF 68 PLA on prend FLGSCR
DCC0 48 PHA
DCC1 4A LSR doit-on envoyer Y ou X ?
DCC2 B0 18 BCS $DCDC X
106
DCC4 A5 29 LDA $29 on lit Y
DCC6 29 3F AND #$3F on vire b4 (protocol US)
DCC8 9D 24 02 STA $0224,X et on fixe Y
DCCB 20 07 DE JSR $DE07 on ajuste lÅfadresse dans la fenetre
DCCE 9D 18 02 STA $0218,X dans ADSCRL
DCD1 98 TYA
DCD2 9D 1C 02 STA $021C,X et ADSCRH
DCD5 68 PLA on indique prochain code X
DCD6 09 01 ORA #$01
DCD8 48 PHA
DCD9 4C 2B DC JMP $DC2B et on sort
DCDC A5 29 LDA $29 on lit X
DCDE 29 3F AND #$3F on vire b4
DCE0 9D 20 02 STA $0220,X dans SCRX
DCE3 68 PLA
DCE4 29 FA AND #$FA on indique fin de US
DCE6 48 PHA
DCE7 4C 2B DC JMP $DC2B et on sort
DCEA 60 RTS
GESTION DES CODES DE CONTROLE
Principe : Genial . . . la gestion des codes de controle est surement la
partie la plus caracteristique de lÅfesprit BROCHIEN (apres le BRK
bien sur). La gestion est supremement optimisee pour tous les
codes, elle est surement le fruit dÅfune mure reflexion. Chapeau.
En entree de chaque routine, A=0, C=1 et la pile contient en son
sommet -3, FLGSCR. Le RTS branche en fait en $DC2B, routine
generale de fin de gestion de code de controle.
CODE 01 . CTRL A
Action : Place le curseur sur une tabulation, colonne multiple de 8.
DCEB BD 20 02 LDA $0220,X on lit la colonne
DCEE 29 F8 AND #$F8 on la met a 0
DCF0 69 07 ADC #$07 on place sur une tabulation 8 (C=1)
DCF2 DD 2C 02 CMP $022C,X est-on en fin de ligne ?
DCF5 F0 12 BEQ $DD09 non
DCF7 90 10 BCC $DD09
DCF9 20 67 DD JSR $DD67 oui, on ramene le curseur en debut de ligne
DCFC 20 9D DD JSR $DD9D et on passe une ligne
DCFF A6 28 LDX $28
DD01 BD 20 02 LDA $0220,X on prend la colonne
DD04 29 07 AND #$07 est-on sur une tabulation
DD06 D0 E3 BNE $DCEB non, on tabule . . .
DD08 60 RTS
DD09 9D 20 02 STA $0220,X on sauve la colonne
DD0C 60 RTS et on sort
107
CODE 4 . CTRL D
DD0D 6A ROR on prepare masque %00000010
CODE 31 - US
DD0E 6A ROR on prepare masque %00000100
CODE 27 - ESC
DD0F 6A ROR on prepare masque %00001000
CODE 29 . CTRL Åò
DD10 6A ROR on prepare masque %00010000
CODE 22 . CTRL V
DD11 6A ROR on prepare masque %00100000
CODE 16 . CTRL P
DD12 6A ROR on prepare masque %01000000
CODE 17 . CTRL Q
DD13 6A ROR on prepare masque %10000000
DD14 A8 TAY dans Y
DD15 BA TSX on indexe FLGSCR dans la pile
DD16 5D 03 01 EOR $0103,X on inverse le bit correspondant au code (bascule)
DD19 9D 03 01 STA $0103,X et on replace
DD1C 85 00 STA $00 et dans $00
DD1E 98 TYA
DD1F 29 10 AND #$10 mode 38/40 colonne ?
DD21 D0 01 BNE $DD24 oui
DD23 60 RTS non on sort
DD24 A6 28 LDX $28 on prend le numero de fenetre
DD26 25 00 AND $00 mode monochrome (ou 40 colonnes) ?
DD28 F0 12 BEQ $DD3C oui
DD2A FE 28 02 INC $0228,X non, on interdit la premiere colonne
DD2D FE 28 02 INC $0228,X et la deuxieme
DD30 BD 20 02 LDA $0220,X est-on dans une colonne
DD33 DD 28 02 CMP $0228,X interdite ?
DD36 B0 03 BCS $DD3B non
DD38 4C 67 DD JMP $DD67 oui, on en sort
DD3B 60 RTS
DD3C DE 28 02 DEC $0228,X on autorise colonne 0 et 1
DD3F DE 28 02 DEC $0228,X
DD42 60 RTS
108
DD43 DE 20 02 DEC $0220,X on ramene le curseur un cran a gauche
DD46 60 RTS
CODE 8 . CTRL H
Action : Deplace le curseur vers la gauche
DD47 BD 20 02 LDA $0220,X est-on deja au debut de la fenetre ?
DD4A DD 28 02 CMP $0228,X
DD4D D0 F4 BNE $DD43 non, on ramene a gauche
DD4F BD 2C 02 LDA $022C,X oui, on se place a la fin de la fenetre
DD52 9D 20 02 STA $0220,X
CODE 11 . CTRL K
Action : Deplace le curseur vers le haut
DD55 BD 24 02 LDA $0224,X et si on est pas
DD58 DD 30 02 CMP $0230,X au sommet de la fenetre,
DD5B D0 11 BNE $DD6E on remonte dÅfune ligne
DD5D BD 30 02 LDA $0230,X X et Y contiennent le debut et la
DD60 BC 34 02 LDY $0234,X fin de la fenetre X
DD63 AA TAX
DD64 20 5C DE JSR $DE5C on scrolle lÅfecran vers le bas ligne X a Y
DD67 BD 28 02 LDA $0228,X on place debut de la fenetre dans X
DD6A 9D 20 02 STA $0220,X
DD6D 60 RTS
DD6E DE 24 02 DEC $0224,X on remontre le curseur
DD71 4C 07 DE JMP $DE07 et ON ajuste ADSCR
CODE 14 . CTRL N
Action : Efface la ligne courante
DD74 BC 28 02 LDY $0228,X on prend la premiere colonne de la fenetre
DD77 4C 7D DD JMP $DD7D et on efface ce qui suit (BPL aurait ete mieux. .)
CODE 24 . CTRL X
Action : Efface la fin de la ligne courante
DD7A BC 20 02 LDY $0220,X on prend la colonne du curseur
DD7D BD 2C 02 LDA $022C,X et la derniere colonne de la fenetre
DD80 85 29 STA $29 dans $29
DD82 A9 20 LDA #$20 on envoie un espace
DD84 91 26 STA ($26),Y
DD86 C8 INY jusquÅfa la fin de la ligne
DD87 C4 29 CPY $29
DD89 90 F9 BCC $DD84
DD8B 91 26 STA ($26),Y et a la derniere position aussi
DD8D 60 RTS (INC $29 avant la boucle aurait ete mieux !)
109
DD8E FE 20 02 INC $0220,X
DD91 60 RTS
CODE 9 . CTRL I
Action : Deplace le curseur a droite
DD92 BD 20 02 LDA $0220,X on lit la colonne du curseur
DD95 DD 2C 02 CMP $022C,X derniere colonne ?
DD98 D0 F4 BNE $DD8E non, on deplace le curseur
DD9A 20 67 DD JSR $DD67 oui, on revient a la premiere colonne
CODE 10 . CTRL J
Action : Deplace le curseur vers la droite
DD9D BD 24 02 LDA $0224,X on est en bas de la fenetre ?
DDA0 DD 34 02 CMP $0234,X
DDA3 D0 0D BNE $DDB2 non
DDA5 BD 30 02 LDA $0230,X oui, X et Y contiennent debut et fin de fenetre
DDA8 BC 34 02 LDY $0234,X
DDAB AA TAX
DDAC 20 54 DE JSR $DE54 on scrolle la fenetre
DDAF 4C 67 DD JMP $DD67 on revient en debut de ligne
DDB2 FE 24 02 INC $0224,X on incremente la ligne
DDB5 4C 07 DE JMP $DE07 et on ajuste ADSCR
CODE 12 . CTRL L
Action : Efface la fenetre
DDB8 20 FB DD JSR $DDFB on remet le curseur en haut de la fenetre
DDBB 20 74 DD JSR $DD74 on efface la ligne courante
DDBE BD 24 02 LDA $0224,X on est a la fin de la fenetre
DDC1 DD 34 02 CMP $0234,X
DDC4 F0 35 BEQ $DDFB oui, on sort en replacant le curseur en haut
DDC6 20 9D DD JSR $DD9D non, on deplace le curseur vers le bas
DDC9 4C BB DD JMP $DDBB et on boucle (et BPL, non ?!?!)
CODE 19 . CTRL S
DDCC 4C B9 E1 JMP $E1B9 on execute un TCOPY
110
CODE 18 . CTRL R
Action : Bascule lÅfecho imprimante du clavier
DDCF A9 02 LDA #$02 on inverse b1
DDD1 4D 8A 02 EOR $028A de FLGLPR
DDD4 8D 8A 02 STA $028A
DDD7 60 RTS
CODE 7 . CTRL G
Action : Emet un OUPS
DDD8 A2 F0 LDX #$F0 on indexe les 14 donnees du OUPS
DDDA A0 DD LDY #$DD
DDDC 20 E7 D9 JSR $D9E7 et on envoie au PSG
DDDF A0 60 LDY #$60
DDE1 A2 00 LDX #$00
DDE3 CA DEX Delai dÅfune seconde
DDE4 D0 FD BNE $DDE3
DDE6 88 DEY
DDE7 D0 FA BNE $DDE3
DDE9 A9 07 LDA #$07 un JMP $DA4F suffisait . . .
DDEB A2 3F LDX #$3F
DDED 4C 1A DA JMP $DA1A
DDF0 BYT $46,00,00,00,00,00 periode 1,12 ms, frequence 880 Hz (LA 4)
DDF6 BYT 00,$3E,$0F,00,00 canal 1, volume 15 musical
INITIALISE UNE FENETRE
Action : On place le curseur en (0,0) et on calculi son adresse.
DDFB BD 28 02 LDA $0228,X on prend la premiere colonne
DDFE 9D 20 02 STA $0220,X dans SCRX
DE01 BD 30 02 LDA $0230,X la premiere ligne dans
DE04 9D 24 02 STA $0224,X SCRY
DE07 BD 24 02 LDA $0224,X et on calcule lÅfadresse
DE0A 20 12 DE JSR $DE12 de la ligne
DE0D 85 26 STA $26 dans ADSCR
DE0F 84 27 STY $27
DE11 60 RTS
111
CALCULE LÅfADRESSE DE LA LIGNE A
Action : En entree, A contient le numero de la ligne et en sortie, RES
contient lÅfadresse a lÅfecran de cette ligne.
DE12 20 69 CE JSR $CE69 RES=A*40
DE15 BD 38 02 LDA $0238,X AY=adresse de la fenetre
DE18 BC 3C 02 LDY $023C,X
DE1B 4C 89 CE JMP $CE89 on calcule dans RES lÅfadresse de la ligne
ETEINDRE LE CURSEUR DANS UNE FENETRE
Action : Est censee eteindre le curseur dans une fenetre, mais la gestion
du des curseurs par fenetre est buggee. On nÅfaura donc de curseur
que dans la fenetre 0. Dommage, cÅfetait une bonne idee au
demeurant . . .
DE1E 18 CLC C=0
DE1F BYT $24 on passe lÅfinstruction suivante
ALLUMER LE CURSEUR DANS UNE FENETRE
Action : Voir plus haut en remplacant Å·eteindreÅ‚ par Å·allumerÅ‚.
DE20 38 SEC C=1
DE21 08 PHP on sauve C
DE22 1E 48 02 ASL $0248,X on decale FLGSCR
DE25 28 PLP on prend C
DE26 7E 48 02 ROR $0248,X et on place le bit curseur dans FLGSCR
DE29 30 28 BMI $DE53 on a allume le curseur, on passe
DE2B A9 80 LDA #$80 on prend A=%10000000
INVERSE LE CURSEUR
Action : Voir plus haut en remplacant Å·allumerÅ‚ par Å·inverserÅ‚.
DE2D 3D 48 02 AND $0248,X curseur a afficher ?
DE30 29 80 AND #$80 prend juste b7
DE32 5D 4C 02 EOR $024C,X et on inverse lÅfetat curseur du code concerne
DE35 BC 20 02 LDY $0220,X
DE38 91 26 STA ($26),Y et onplace le code
DE3A 48 PHA on sauve le code
DE3B BD 48 02 LDA $0248,X
DE3E 29 02 AND #$02 double hauteur ?
DE40 F0 10 BEQ $DE52 non
DE42 BD 24 02 LDA $0224,X oui, si on nÅfest pas
DE45 DD 34 02 CMP $0234,X en bas de la fenetre
112
DE48 F0 08 BEQ $DE52
DE4A 98 TYA on ajoute une ligne
DE4B 69 28 ADC #$28
DE4D A8 TAY
DE4E 68 PLA
DE4F 91 26 STA ($26),Y et on affiche le code une deuxieme fois
DE51 60 RTS
DE52 68 PLA
DE53 60 RTS
SCROLLE UNE FENETRE VERS LE BAS
Action : Scrolle vers le bas de la ligne X a la ligne Y la fenetre
courante.
DE54 A9 00 LDA #$00 on prend $0028, soit 40
DE56 85 07 STA $07
DE58 A9 28 LDA #$28
DE5A D0 06 BNE $DE62 inconditionnel
SCROLLE UNE FENETRE VERS LE HAUT
Action : Scrolle vers le haut de la ligne X a la ligne Y la fenetre
courante.
DE5C A9 FF LDA #$FF on prend $FFD8, soit -40 en complement a 2
DE5E 85 07 STA $07
DE60 A9 D8 LDA #$D8
DE62 85 06 STA $06 $06-07 contiennent le deplacement
DE64 86 00 STX $00 on met la ligne de depart en RES
DE66 98 TYA
DE67 38 SEC
DE68 E5 00 SBC $00 on calcule le nombre de lignes
DE6A 48 PHA on sauve le nombre de lignes
DE6B 8A TXA ligne de debut dans A
DE6C 24 06 BIT $06
DE6E 10 01 BPL $DE71 deplacement negatif ?
DE70 98 TYA oui, ligne de fin dans A
DE71 A6 28 LDX $28
DE73 20 12 DE JSR $DE12 on calcule lÅfadresse de la ligne
DE76 18 CLC
DE77 7D 28 02 ADC $0228,X lÅfadresse exacte de la ligne dans la fenetre
DE7A 90 01 BCC $DE7D
DE7C C8 INY
DE7D 85 08 STA $08 est dans $08-09
DE7F 84 09 STY $09
DE81 18 CLC on ajoute le deplacement
DE82 65 06 ADC $06
DE84 85 04 STA $04
DE86 98 TYA
113
DE87 65 07 ADC $07
DE89 85 05 STA $05 dans $04-05
DE8B 68 PLA on sort le nombre de lignes
DE8C 85 00 STA $00 dans RES
DE8E F0 34 BEQ $DEC4 si nul on fait nÅfimporte quoi ! on devrait sortir !
DE90 30 3B BMI $DECD si negatif, on sort
DE92 38 SEC on calcule
DE93 A6 28 LDX $28
DE95 BD 2C 02 LDA $022C,X la largeur de la fenetre
DE98 FD 28 02 SBC $0228,X
DE9B 85 01 STA $01 dans RES+1
DE9D A4 01 LDY $01
DE9F B1 04 LDA ($04),Y on transfere une ligne
DEA1 91 08 STA ($08),Y
DEA3 88 DEY
DEA4 10 F9 BPL $DE9F
DEA6 18 CLC
DEA7 A5 04 LDA $04 on ajoute le deplacement
DEA9 65 06 ADC $06 a lÅfadresse de base
DEAB 85 04 STA $04
DEAD A5 05 LDA $05
DEAF 65 07 ADC $07
DEB1 85 05 STA $05
DEB3 18 CLC
DEB4 A5 08 LDA $08 et a lÅfadresse dÅfarrivee
DEB6 65 06 ADC $06
DEB8 85 08 STA $08
DEBA A5 09 LDA $09
DEBC 65 07 ADC $07
DEBE 85 09 STA $09
DEC0 C6 00 DEC $00 on decompte une ligne de faite
DEC2 D0 D9 BNE $DE9D et on fait toutes les lignes
DEC4 A4 01 LDY $01 on remplit la derniere ligne
DEC6 A9 20 LDA #$20
DEC8 91 08 STA ($08),Y avec des espaces
DECA 88 DEY
DECB 10 FB BPL $DEC8
DECD 60 RTS
???
Action : Inconnue . . . ne semble pas etre appelee et utilise des
variables IRQ dont on ne sait rien.
DECE 90 07 BCC $DED7 si C=0 on passe
DED0 A6 28 LDX $28
DED2 20 1E DE JSR $DE1E on eteint le curseur
DED5 68 PLA et on sort A de la pile
DED6 60 RTS
DED7 A9 01 LDA #$01 on met 1 en $216
DED9 8D 16 02 STA $0216
DEDC A9 80 LDA #$80 on force b7 a 1 dans $217
DEDE 8D 17 02 STA $0217
114
DEE1 68 PLA on sort A
DEE2 60 RTS et on sort
DONNEES POUR FENETRES SYSTEME
Type : Chaque bloc de donnees contient 6 octets qui sont dans lÅfordre :
colonnes de debut et de fin de la fenetre, lignes de debut et de
fin, adresse de base de la fenetre.
FENETRE TEXT
DEE3 BYT 0,39 de 0 a 39
DEE5 BYT 1,27 de 1 a 27
DEE7 WRD $BB80 base de la fenetre
FENETRE HIRES
DEE9 BYT 0,39 de 0 a 39
DEEB BYT 1,2 de 1 a 2
DEED WRD $BF68 base de la fenetre
FENETRE TRACE
DEEF BYT 0,39 de 0 a 39
DEF1 BYT 26,27 de 26 a 27
DEF3 WRD $BB80 base de la fenetre
FENETRE VIDEOTEX
DEF5 BYT 0,39 de 0 a 39
DEF7 BYT 1,24 de 1 a 24
DEF9 WRD $BB80 base de la fenetre
CREE UNE FENETRE
Action : Cree la fenetre X selon les parametres en AY (voir tables cidessus).
La routine contient, comme on lÅfa deja vu, deux points
dÅfentree par souci de rapidite : En $DEFB, C=1 et on lit les
donnees sur la banque dÅfappel par BRK. En $DEFD, C=0, on lit les
donnees sur la banque 7.
DEFB 38 SEC C=1, on appelle dÅfune autre banque que la 7
DEFC BYT $24 on saute le CLC
DEFD 18 CLC C=0, on appelle de la banque 7
DEFE 08 PHP on sauve C
DEFF 85 15 STA $15 on sauve lÅfadresse des parametres
DF01 84 16 STY $16
DF03 8A TXA on ajoute 24 au numero de fenetre
DF04 18 CLC (pour 6 parametres)
115
DF05 69 18 ADC #$18
DF07 AA TAX
DF08 A0 05 LDY #$05 on indexe six parametres
DF0A 28 PLP on lit C
DF0B 08 PHP
DF0C B0 04 BCS $DF12 C=1, on change de banque
DF0E B1 15 LDA ($15),Y C=0, on lit les codes sur la banque 7
DF10 90 03 BCC $DF15
DF12 20 11 04 JSR $0411
DF15 9D 24 02 STA $0224,X on sauve le parametre
DF18 8A TXA
DF19 38 SEC
DF1A E9 04 SBC #$04 et on passe au parametre suivant
DF1C AA TAX (il y a 4 fenetres)
DF1D 88 DEY
DF1E 10 EA BPL $DF0A
DF20 A9 07 LDA #$07 texte blanc
DF22 9D 40 02 STA $0240,X
DF25 A9 00 LDA #$00 et fond noir
DF27 9D 44 02 STA $0244,X
DF2A A9 00 LDA #$00 pas de curseur
DF2C 9D 48 02 STA $0248,X
DF2F BD 28 02 LDA $0228,X curseur en haut a gauche de
DF32 9D 20 02 STA $0220,X la fenetre
DF35 BD 30 02 LDA $0230,X
DF38 9D 24 02 STA $0224,X
DF3B BD 38 02 LDA $0238,X adresse courante=adresse de base
DF3E 9D 18 02 STA $0218,X
DF41 BD 3C 02 LDA $023C,X
DF44 9D 1C 02 STA $021C,X
DF47 A9 20 LDA #$20 on met un espace sous le curseur
DF49 9D 4C 02 STA $024C,X
DF4C A5 28 LDA $28 on sauve la fenetre
DF4E 48 PHA
DF4F 86 28 STX $28 on force fenetre courante=fenetre creee
DF51 A9 0C LDA #$0C on efface la fenetre
DF53 20 B5 DB JSR $DBB5
DF56 68 PLA on replace le numero de fenetre courante
DF57 85 28 STA $28
DF59 28 PLP on sort P
DF5A 60 RTS
INITIALISATION DE LÅfAFFICHAGE
DF5B A9 1A LDA #$1A on indique mode TEXT
DF5D 8D DF BF STA $BFDF
DF60 20 49 FE JSR $FE49 on redefinit les caracteres
DF63 A2 27 LDX #$27 pour 40 colonnes
DF65 A9 20 LDA #$20
DF67 9D 80 BB STA $BB80,X on efface la ligne des statuts (ligne 0)
DF6A CA DEX
DF6B 10 FA BPL $DF67
116
DF6D A0 11 LDY #$11 on fixe les valeurs par defaut
DF6F B9 E3 DE LDA $DEE3,Y
DF72 99 56 02 STA $0256,Y des 3 fenetres (TEXT, HIRES et TRACE)
DF75 88 DEY
DF76 10 F7 BPL $DF6F
DF78 0E 0D 02 ASL $020D on indique mode TEXT
DF7B 4E 0D 02 LSR $020D
DF7E A9 F5 LDA #$F5 AY=$DEF5 (fenetre VIDEOTEX)
DF80 A0 DE LDY #$DE
DF82 2C 0D 02 BIT $020D mode minitel ?
DF85 70 04 BVS $DF8B oui, on indexe la bonne fenetre
DF87 A9 56 LDA #$56 non, on indexe $256 (fenetre TEXT)
DF89 A0 02 LDY #$02
DF8B A2 00 LDX #$00 pour la fenetre 0
DF8D 4C FD DE JMP $DEFD et on definit la fenetre 0
LIT VALEUR JOYSTICK GAUCHE
DF90 AD 20 03 LDA $0320 on lit V2DRB
DF93 29 3F AND #$3F on force b7b6 a 0
DF95 09 40 ORA #$40 et b6 a 1
DF97 D0 07 BNE $DFA0 incondionnel
LIT VALEUR SOURIS
DF99 AD 20 03 LDA $0320 on lit V2DRB
DF9C 29 3F AND #$3F on force b7b6 a 0
DF9E 09 80 ORA #$80 et b7 a 1
DFA0 8D 20 03 STA $0320 dans V2DRB
DFA3 AD 20 03 LDA $0320 on lit V2DRB
DFA6 29 1F AND #$1F on isole b5-b0 pour valeur
DFA8 60 RTS et on sort
DFA9 38 SEC
DFAA 60 RTS
INITIALISE LES PORTS JOYSTICK/SOURIS
Action : Installe le joystick gauche (le droit nÅfest pas gere) et la
souris, fixe les codes ASCII par defaut retournes par les ports,
et installe les IRQ par T2 pour se declencher une fois toutes les
10000 É s, soit 100 fois par secondes.
DFAB A9 41 LDA #$41 %01000001, joystick gauche et souris
DFAD 8D 8C 02 STA $028C dans FLGJCK
DFB0 A2 06 LDX #$06 on lit les valeurs par defaut
DFB2 BD F3 DF LDA $DFF3,X dans les 7 octets de valeurs touche/joystick
DFB5 9D 9D 02 STA $029D,X de JCKTAB a JCKTAB+6
DFB8 CA DEX
117
DFB9 10 F7 BPL $DFB2
DFBB A9 01 LDA #$01 1 en $297 diviseur repetition joystick
DFBD 8D 97 02 STA $0297 $29C diviseur bouton central souris
DFC0 8D 9C 02 STA $029C
DFC3 A9 06 LDA #$06 6 en $298 compteur avant repetition joystick
DFC5 8D 98 02 STA $0298 $29B compteur bouton central souris
DFC8 8D 9B 02 STA $029B
DFCB A9 01 LDA #$01 1 en $299 diviseur repetition souris
DFCD 8D 99 02 STA $0299
DFD0 A9 0A LDA #$0A 10 en $29A compteur avant repetition souris
DFD2 8D 9A 02 STA $029A
DFD5 A9 03 LDA #$03 3 en $2A4 diviseur deplacement souris
DFD7 8D A4 02 STA $02A4 $2A5 valeur par defaut du diviseur
DFDA 8D A5 02 STA $02A5
DFDD A9 10 LDA #$10 $2710 = 10000
DFDF A0 27 LDY #$27
DFE1 8D 8F 02 STA $028F dans $28F-290 (valeur timer T2)
DFE4 8C 90 02 STY $0290
DFE7 8D 08 03 STA $0308 et dans T2
DFEA 8C 09 03 STY $0309
DFED A9 A0 LDA #$A0 %10100000, autorisation IRQ par T2
DFEF 8D 0E 03 STA $030E dans V1IER
DFF2 60 RTS
VALEURS PAR DEFAUT JOYSTICK/SOURIS
DFF3 BYT 11,10,32,8,9,3,3 soit les quatres fleches pour les
directions, un espace pour le feu joystick ou souris gauche et
CTRL-C pour les feux D. et C. souris.
GESTION JOYSTICK DROIT
Action : Succinte . . .
DFFA 60 RTS
GESTION DU JOYSTICK GAUCHE
Action : Lit le joystick et envoie dans le buffer clavier les code ASCII
qui correspodent aux directions et au bouton. Le code KBDSHT
envoye avec les touches 32, soit b5 a 1.
DFFB AD 8D 02 LDA $028D on lit JGCVAL
DFFE 29 04 AND #$04 bouton presse ?
E000 D0 12 BNE $E014 non
E002 20 90 DF JSR $DF90 oui, on lit le joystick
E005 29 04 AND #$04 bouton presse ?
E007 D0 15 BNE $E01E non
E009 CE 93 02 DEC $0293 oui, repetition ?
118
E00C D0 29 BNE $E037 non, on passe
E00E AE 97 02 LDX $0297 on lit diviseur avant repetition
E011 4C 1E E0 JMP $E01E
E014 20 90 DF JSR $DF90 on lit le JOYSTICK
E017 29 04 AND #$04 bouton presse ?
E019 D0 1C BNE $E037 non
E01B AE 98 02 LDX $0298 on lit le compteur par defaut
E01E 8E 93 02 STX $0293 dans repetition joy
E021 85 58 STA $58 on sauve la valeur Feu
E023 AD 8D 02 LDA $028D on lit la valeur joystick
E026 29 1B AND #$1B %00011011, on elimine le Feu
E028 05 58 ORA $58 on ajoute la valeur lue sur VIA2
E02A 8D 8D 02 STA $028D dans JGCVAL
E02D A5 58 LDA $58 feu presse ?
E02F D0 06 BNE $E037 non
E031 AD 9F 02 LDA $029F oui, on lit le code ASCII correspondant
E034 20 9F E1 JSR $E19F et on lÅfenvoie dans le buffer clavier
E037 AD 8D 02 LDA $028D on lit JGCVAL
E03A 29 1B AND #$1B on isole les bits de direction
E03C 49 1B EOR #$1B et on les inverse
E03E F0 1B BEQ $E05B si pas de direction, on passe
E040 20 90 DF JSR $DF90 on lit la valeur deplacement joystick
E043 29 1B AND #$1B on isole les bits direction
E045 85 58 STA $58 dans $58
E047 AD 8D 02 LDA $028D on lit JGCVAL
E04A 29 1B AND #$1B on isole les bits de direction
E04C 45 58 EOR $58 est-ce le meme mouvement ?
E04E D0 12 BNE $E062 non
E050 CE 91 02 DEC $0291 oui, on repete ?
E053 D0 2F BNE $E084 non
E055 AE 97 02 LDX $0297 oui, on prend diviseur repetition
E058 4C 65 E0 JMP $E065 et on saute
E05B 20 90 DF JSR $DF90 on lit la valeur
E05E 29 1B AND #$1B deplacement
E060 85 58 STA $58 dans $58
E062 AE 98 02 LDX $0298 on prend le nombre avant repetition
E065 8E 91 02 STX $0291 dans decompte repetition
E068 AD 8D 02 LDA $028D on prend JGCVAL
E06B 29 04 AND #$04 isole Feu
E06D 05 58 ORA $58 ajoute direction
E06F 8D 8D 02 STA $028D
E072 A2 04 LDX #$04 5 valeurs
E074 09 04 ORA #$04 on indique pas de FEU
E076 4A LSR on envoie les codes ASCII correspondant
E077 48 PHA
E078 B0 06 BCS $E080
E07A BD 9D 02 LDA $029D,X au directions detectees
E07D 20 9F E1 JSR $E19F dans le buffer clavier
E080 68 PLA
E081 CA DEX
E082 10 F2 BPL $E076
E084 60 RTS
119
GESTION DE LA SOURIS
Action : Gere la souris comme precedemment le joystick gauche, a ceci pres
quÅfil ne sÅfagit plus avec la souris de gerer un delai de
repetition (sauf pour les boutons), mais plutot une vitesse de
repetition. Dans le buffer clavier, lÅfoctet KBDSHT ajoute au code
ASCII souris et 8, soit b3 a 1.
E085 20 99 DF JSR $DF99 on lit la valeur souris
E088 29 1B AND #$1B on isole les directions
E08A 85 58 STA $58 dans $58
E08C C9 1B CMP #$1B la souris bouge ?
E08E D0 05 BNE $E095 non
E090 CE A4 02 DEC $02A4 on deplace ?
E093 D0 EF BNE $E084 non, on sort
E095 AD A5 02 LDA $02A5 on place vitesse deplacement dans
E098 8D A4 02 STA $02A4 $2A4
E09B A5 58 LDA $58 on lit le code
E09D C9 1B CMP #$1B souris fixe ?
E09F F0 14 BEQ $E0B5 oui
E0A1 29 1B AND #$1B non, on isole les valeurs direction
E0A3 4D 8E 02 EOR $028E et on retourne les bits de JCDVAL
E0A6 29 1B AND #$1B en isolant les bits de direction
E0A8 D0 0B BNE $E0B5 ce ne sont pas les memes exactement
E0AA CE 92 02 DEC $0292 on repete ?
E0AD D0 31 BNE $E0E0 non
E0AF AE 99 02 LDX $0299 oui, on met le diviseur repetition
E0B2 4C BB E0 JMP $E0BB dans le compteur
E0B5 20 99 DF JSR $DF99 on lit la souris
E0B8 AE 9A 02 LDX $029A on place le compteur avant repetition
E0BB 8E 92 02 STX $0292 dans le decompteur
E0BE 29 1B AND #$1B on isole les bits de direction
E0C0 85 58 STA $58 dans $58
E0C2 AD 8E 02 LDA $028E on prend JDCVAL
E0C5 29 64 AND #$64 %01100100, on isole les bits de Feu
E0C7 05 58 ORA $58 on ajoute les bits de direction
E0C9 8D 8E 02 STA $028E dans JDCVAL
E0CC A5 58 LDA $58
E0CE 09 04 ORA #$04 on eteint le feu principal
E0D0 A2 04 LDX #$04
E0D2 4A LSR
E0D3 48 PHA
E0D4 B0 06 BCS $E0DC
E0D6 BD 9D 02 LDA $029D,X et on envoie les valeurs ASCII dans le buffer
E0D9 20 9D E1 JSR $E19D
E0DC 68 PLA
E0DD CA DEX
E0DE 10 F2 BPL $E0D2
E0E0 60 RTS
120
GERE LES BOUTONS DE LA SOURIS
Principe : Geres comme le feu du joystick, les boutons souris ont comme
les touches du clavier un delai et un diviseur de repetition.
Leur gestion est laborieuse et aurait pu etre ramene a une
routine moitie moins longue avec un peu de reflexion. De plus,
renvoyer des codes ASCII pour un deplacement de souris nÅfest pas
ce que lÅfon peut faire de mieux. Il aurait ete plus judicieux
dÅfajouter des coordonnees en memoire, ce qui aurait permis des
applications fort interessantes. . .
E0E1 AD 8E 02 LDA $028E on lit JDCVAL
E0E4 29 04 AND #$04 bouton gauche ?
E0E6 D0 12 BNE $E0FA oui
E0E8 20 99 DF JSR $DF99 non, on lit la souris
E0EB 29 04 AND #$04 bouton toujours presse ?
E0ED D0 13 BNE $E102 non
E0EF CE 94 02 DEC $0294 oui, on repete ?
E0F2 D0 27 BNE $E11B non
E0F4 AE 97 02 LDX $0297 oui, on prepare vitesse
E0F7 4C 02 E1 JMP $E102 et on saute
E0FA 20 99 DF JSR $DF99 bouton gauche presse ?
E0FD 29 04 AND #$04
E0FF AE 98 02 LDX $0298 X=compteur avant repetition
E102 85 58 STA $58 dans $58
E104 8E 94 02 STX $0294 on place X dans decompte souris
E107 AD 8E 02 LDA $028E on lit JDCVAL
E10A 29 7B AND #$7B %011111011 tout sauf bouton gauche
E10C 05 58 ORA $58 met $58 dessus
E10E 8D 8E 02 STA $028E et on replace
E111 A5 58 LDA $58 bouton presse ?
E113 D0 06 BNE $E11B non
E115 AD 9F 02 LDA $029F oui, on envoie lÅfASCII correspondant
E118 20 9D E1 JSR $E19D dans le buffer clavier
E11B AD 8E 02 LDA $028E lit bouton central
E11E 29 20 AND #$20 %00100000, presse ?
E120 D0 15 BNE $E137 non
E122 20 99 DF JSR $DF99 oui, bouton toujours presse ?
E125 AD 2F 03 LDA $032F
E128 29 20 AND #$20
E12A D0 14 BNE $E140 non, on sauve lÅfimage bouton central
E12C CE 95 02 DEC $0295 oui, on repete ?
E12F D0 2A BNE $E15B non, on va gerer le bouton droit
E131 AE 9C 02 LDX $029C oui, on prend le diviseur repetition
E134 4C 40 E1 JMP $E140 et on le sauve
E137 20 99 DF JSR $DF99 on lit lÅfimage souris
E13A AD 2F 03 LDA $032F
E13D AE 9B 02 LDX $029B on remet le compteur avant repetition
E140 8E 95 02 STX $0295 dans decompte bouton central
E143 29 20 AND #$20 bouton central presse ?
E145 85 58 STA $58 dans $58
E147 AD 8E 02 LDA $028E on lit JDCVAL
121
E14A 29 5F AND #$5F %01011111 sans bouton central
E14C 05 58 ORA $58 on ajoute le bouton central
E14E 8D 8E 02 STA $028E dans JDCVAL
E151 29 20 AND #$20 on isole le bouton central
E153 D0 06 BNE $E15B presse ? non
E155 AD A2 02 LDA $02A2 oui, on envoie le code ASCII correspondant
E158 20 9D E1 JSR $E19D dans le buffer clavier
E15B AD 8E 02 LDA $028E on lit le bouton droit
E15E 29 40 AND #$40 presse ?
E160 D0 15 BNE $E177 non
E162 20 99 DF JSR $DF99 oui, on lit la souris
E165 AD 2F 03 LDA $032F
E168 29 80 AND #$80 b7=1 ? (mode souris ?)
E16A D0 14 BNE $E180 non
E16C CE 96 02 DEC $0296 oui, on a decompte a 0 ?
E16F D0 2B BNE $E19C non
E171 AE 9C 02 LDX $029C oui, on prend le diviseur
E174 4C 80 E1 JMP $E180 et on saute
E177 20 99 DF JSR $DF99 on lit la souris
E17A AD 2F 03 LDA $032F on prend la valeur
E17D AE 9B 02 LDX $029B et le compteur
E180 8E 96 02 STX $0296 dans le decompte
E183 4A LSR
E184 29 40 AND #$40 on met b7 dans b6, et on isole
E186 85 58 STA $58 dans $58
E188 AD 8E 02 LDA $028E on prend JDCVAL
E18B 29 3F AND #$3F isole directions
E18D 05 58 ORA $58 ajoute b6 sauve
E18F 8D 8E 02 STA $028E dans JDCVAL
E192 29 40 AND #$40 bouton presse ?
E194 D0 06 BNE $E19C non, on sort
E196 AD A3 02 LDA $02A3 oui, on envoie le code bouton souris
E199 4C 9D E1 JMP $E19D ou mieux : faire pointer le branchement en $E1B6
E19C 60 RTS
ENVOIE UN CODE ASCII SOURIS
E19D 38 SEC
E19E BYT $2C
ENVOIE UN CODE ASCII JOYSTICK
E19F 18 CLC
E1A0 08 PHP C=1 si code souris, 0 si code joystick
E1A1 86 58 STX $58 on sauve X
E1A3 A2 00 LDX #$00 on envoie le code au buffer clavier
E1A5 20 1D C5 JSR $C51D (buffer 0)
E1A8 A9 08 LDA #$08 on prend le code souris
E1AA 28 PLP
E1AB B0 02 BCS $E1AF
E1AD A9 20 LDA #$20 si C=0, on prend code JOYSTICK
122
E1AF A2 00 LDX #$00
E1B1 20 1D C5 JSR $C51D et on envoie le code KBDSHT
E1B4 A6 58 LDX $58 on restaure X
E1B6 60 RTS et on sort
E1B7 38 SEC lÅfutilite de ces codes est douteuse . . il y a
E1B8 60 RTS surement dÅfautres SEC/RTS entre $C000 et $FFFF
HARD-COPY TEXT
Action : Recopie tous les caracteres a lÅfecran sur imprimante.
La fenetre est dans $28. Pour lire les codes, on deplace le
curseur de droite a gauche et de bas en haut en envoyant tout
code imprimable.
E1B9 A6 28 LDX $28 on sauve la position du curseur
E1BB BD 20 02 LDA $0220,X
E1BE 48 PHA
E1BF BD 24 02 LDA $0224,X
E1C2 48 PHA
E1C3 A9 1E LDA #$1E on fait un HOME
E1C5 20 B5 DB JSR $DBB5 (curseur en haut a gauche de la fenetre)
E1C8 20 E4 DA JSR $DAE4 on saute une ligne sur lÅfimprimante
E1CB A6 28 LDX $28 on prend le numero de la fenetre
E1CD BC 20 02 LDY $0220,X
E1D0 B1 26 LDA ($26),Y on lit un code
E1D2 C9 20 CMP #$20 code de controle ?
E1D4 B0 02 BCS $E1D8
E1D6 A9 20 LDA #$20 oui, on affiche un espace
E1D8 20 72 DA JSR $DA72 sur lÅfimprimante
E1DB BD 20 02 LDA $0220,X on est a la fin de la ligne ?
E1DE DD 2C 02 CMP $022C,X
E1E1 F0 08 BEQ $E1EB oui
E1E3 A9 09 LDA #$09 on deplace le curseur a droite
E1E5 20 B5 DB JSR $DBB5 a lÅfecran
E1E8 4C CB E1 JMP $E1CB et on tourne
E1EB 20 E4 DA JSR $DAE4 on passe a la ligne suivante
E1EE A6 28 LDX $28
E1F0 BD 24 02 LDA $0224,X on est sur la derniere ligne ?
E1F3 DD 34 02 CMP $0234,X
E1F6 D0 EB BNE $E1E3 non, on deplace encore a droite
E1F8 A9 1F LDA #$1F
E1FA 20 B5 DB JSR $DBB5
E1FD 68 PLA on sort X
E1FE 09 40 ORA #$40
E200 20 B5 DB JSR $DBB5
E203 68 PLA et X
E204 09 40 ORA #$40
E206 4C B5 DB JMP $DBB5 et on replace le curseur
123
HARD-COPY VIDEOTEX
Action : On envoie sur imprimante le contenu ASCII (contenu des tables
ASCII en fait) de lÅfecran HIRES en mode VIDEOTEX. Un petit bug
sÅfest glisse dans la routine : La largeur de la ligne sauvee au
debut nÅfest pas restituee a la fin, mais placee dans LPRX. Ce qui
nÅfest pas tres grave par ailleurs. Doc en sortie de cette
routine, LPRFX=40.
E209 20 E4 DA JSR $DAE4 on saute une ligne
E20C AD 88 02 LDA $0288 on sauve larger dÅfimpression
E20F 48 PHA
E210 A9 28 LDA #$28 on met largeur a 40
E212 8D 88 02 STA $0288
E215 A9 1E LDA #$1E on place le curseur en 0,0
E217 20 78 D1 JSR $D178
E21A A4 38 LDY $38
E21C B1 30 LDA ($30),Y on lit lÅfattribut du code
E21E 30 06 BMI $E226 >128, on saute
E220 B1 2E LDA ($2E),Y on prend le code
E222 C9 20 CMP #$20 code de controle ?
E224 B0 02 BCS $E228 non
E226 A9 20 LDA #$20 on prend un espace
E228 20 72 DA JSR $DA72 on affiche le code
E22B A9 09 LDA #$09 on deplace le curseur a droite
E22D 20 78 D1 JSR $D178
E230 A5 38 LDA $38 on ajuste la position suivante
E232 D0 E6 BNE $E21A
E234 A4 39 LDY $39
E236 88 DEY
E237 D0 E1 BNE $E21A et on boucle
E239 20 E4 DA JSR $DAE4 on saute une ligne
E23C 68 PLA et on bugge !!!
E23D 8D 86 02 STA $0286 STA $0228 aurait ete mieux. . .
E240 60 RTS
E241 BYT $18,$33,$1B,$0A,$0D soit saut de ligne, interligne 24/216
E246 BYT $00,$F0,$4B,$1B,$0D,$0A soit saut de ligne, 240 points
E24C BYT $40,$1B,$0A,$0A soit initialize lÅfimprimante
EXECUTION HARD-COPY HIRES
Principe : Le hard-copy HIRES est vectorise, cÅfest-a-dire que lÅfon peut
placer dans le vecteur $250 lÅfadresse de sa routine personnelle.
Pratique !
E250 6C 50 02 JMP ($0250)
124
ROUTINE DE HARD-COPY HIRES
Principe: Trivial, mais un bug se cache quelque part dans la routine (la
17eme ligne et la 18Åf sont superposees. . .) sans raison
apparente ! Les octets graphiques EPSON etant verticaux alors que
les octets (sextet en fait) graphiques ORIC sont horizontaux, on
va lire 8 sextets superposes verticalement, isoler leur bit du 5
au 0 et le faire entrer dans le motif EPSON. On envoie alors le
motif et on fait de meme pour les 6 bits, puis pour les 40
sextets et pour les 25 blocs de 8 fois 40 sextets . . . ouf ! La
routine est tres optimisee, profitez en !
E253 A2 05 LDX #$05 on va envoyer 5 codes
E255 AD 8A 02 LDA $028A on sauve FLGLPR
E258 48 PHA
E259 09 40 ORA #$40 et on interdit le CRLF du TELEMON
E25B 8D 8A 02 STA $028A
E25E BD 40 E2 LDA $E240,X on envoie le passage en 24/216Åf de pouce
E261 20 72 DA JSR $DA72 a lÅfimprimante
E264 CA DEX
E265 D0 F7 BNE $E25E
E267 86 0C STX $0C on met 0 dans $0C
E269 A2 06 LDX #$06 on envoie 6 codes
E26B BD 45 E2 LDA $E245,X
E26E 20 72 DA JSR $DA72 soit passage en graphiques 240 points/ligne
E271 CA DEX
E272 D0 F7 BNE $E26B
E274 86 0D STX $0D et 0 dans $0D
E276 A9 05 LDA #$05 on va faire 6 pixels (5+1)
E278 85 0E STA $0E dans $0E
E27A A5 0C LDA $0C on prend la ligne
E27C 0A ASL *2
E27D 0A ASL *4
E27E 0A ASL *8
E27F 20 69 CE JSR $CE69 *40 (donc on calcule la ligne suivante)
E282 85 11 STA $11 dans $11-$12
E284 98 TYA on calcule #A000+ligne*8*40
E285 18 CLC
E286 69 A0 ADC #$A0
E288 85 12 STA $12
E28A A9 08 LDA #$08 pour 8 ligne
E28C 85 10 STA $10 dans $10
E28E A4 0D LDY $0D on prend la colonne
E290 B1 11 LDA ($11),Y on lit le code
E292 AA TAX dans X
E293 29 40 AND #$40 pixels ?
E295 D0 04 BNE $E29B oui
E297 8A TXA attributs, on inverse video ?
E298 29 80 AND #$80 b7=1 si video inverse
E29A AA TAX
E29B 8A TXA
E29C 10 02 BPL $E2A0 video inverse ? non
125
E29E 49 3F EOR #$3F oui, on inverse les pixels
E2A0 A6 0E LDX $0E on isole le bit (numero dans $0E)
E2A2 4A LSR dans C
E2A3 CA DEX
E2A4 10 FC BPL $E2A2
E2A6 26 0F ROL $0F on lÅfajoute a la ligne (dans $0F)
E2A8 98 TYA
E2A9 18 CLC
E2AA 69 28 ADC #$28 on saute une ligne ecran
E2AC A8 TAY
E2AD 90 02 BCC $E2B1
E2AF E6 12 INC $12
E2B1 C6 10 DEC $10 et on fait 8 lignes
E2B3 D0 DB BNE $E290
E2B5 A5 0F LDA $0F on envoie le code calcule
E2B7 20 72 DA JSR $DA72 a lÅfimprimante
E2BA C6 0E DEC $0E
E2BC 10 BC BPL $E27A on fait 6 bits
E2BE E6 0D INC $0D
E2C0 A5 0D LDA $0D
E2C2 C9 28 CMP #$28
E2C4 D0 B0 BNE $E276 on fait 40 colonnes de 6 bits
E2C6 E6 0C INC $0C
E2C8 A5 0C LDA $0C
E2CA C9 19 CMP #$19 et 25 lignes de 40 colonnes de 6 bits
E2CC D0 9B BNE $E269
E2CE A2 04 LDX #$04
E2D0 BD 4B E2 LDA $E24B,X puis on initialise lÅfimprimante
E2D3 20 72 DA JSR $DA72
E2D6 CA DEX
E2D7 D0 F7 BNE $E2D0
E2D9 68 PLA
E2DA 8D 8A 02 STA $028A et on recupere lÅfetat initial du CRLF
E2DD 60 RTS
PLACE LE CURSEUR SUR LE DERNIER CARACTERE DE LA LIGNE
E2DE BC 2C 02 LDY $022C,X on prend la derniere colonne de la fenetre
E2E1 BYT $24 et on saute lÅfinstruction suivante
E2E2 88 DEY on decale dÅfune colonne a gauche
E2E3 B1 00 LDA ($00),Y est-on sur un espace ?
E2E5 C9 20 CMP #$20
E2E7 D0 07 BNE $E2F0 non
E2E9 98 TYA oui
E2EA DD 28 02 CMP $0228,X on est au debut de la fenetre ?
E2ED D0 F3 BNE $E2E2 non
E2EF 60 RTS
E2F0 C9 7F CMP #$7F est-ce le prompt ?
E2F2 D0 04 BNE $E2F8 non, on sort
E2F4 98 TYA oui, Y contient la colonne
E2F5 DD 28 02 CMP $0228,X et Z=1 si on est sur la premiere colonne
E2F8 60 RTS
126
TESTE SI UN PROMPT SE TROUVE EN DEBUT DE LIGNE
E2F9 BC 28 02 LDY $0228,X on prend le debut de la fenetre
E2FC B1 00 LDA ($00),Y on lit le caractere qui sÅfy trouve
E2FE C9 7F CMP #$7F on le compare au prompt
E300 60 RTS Z=1 si il y a un prompt en debut de ligne
CALCULE LA POSITION APRES UN PROMPT
Action : On calcule dans $60 et $61 la ligne et la colonne du premier
prompt avant le curseur. En fait, $60 contient la position
immediatement apres le prompt. En sortie, C=0.
E301 A6 28 LDX $28 X=numero de fenetre
E303 BD 24 02 LDA $0224,X on prend la ligne du curseur
E306 85 61 STA $61 dans $61
E308 A5 61 LDA $61 on prend la ligne du curseur
E30A 20 12 DE JSR $DE12 AY et RES contiennent lÅfadresse de la ligne
E30D 20 F9 E2 JSR $E2F9 y a-t-il un prompt au debut de la ligne ?
E310 F0 0B BEQ $E31D oui
E312 A5 61 LDA $61 non, le curseur est-il
E314 DD 30 02 CMP $0230,X en haut de la fenetre ?
E317 F0 08 BEQ $E321 oui, on passe
E319 C6 61 DEC $61 non, on remonte une ligne et
E31B B0 EB BCS $E308 on poursuit le test
E31D 18 CLC C=0
E31E C8 INY
E31F 84 60 STY $60 $60 contient la colonne apres le prompt
E321 60 RTS
RAMENE LE CURSEUR EN DEBUT DE LIGNE
Action : Calcule dans $62, $63 les coordonnees de la fin de la ligne ou de
la position du premier prompt +1.
E322 A6 28 LDX $28 X=numero de fenetre courante
E324 BD 24 02 LDA $0224,X on prend la ligne du curseur
E327 85 63 STA $63 dans $63
E329 20 12 DE JSR $DE12 on calcule lÅfadresse de la ligne dans RES et AY
E32C 20 DE E2 JSR $E2DE on place le curseur sur le dernier caractere
E32F 84 62 STY $62 est-on au debut de la ligne
E331 F0 1B BEQ $E34E oui
E333 A5 63 LDA $63 non, on prend la ligne
E335 DD 34 02 CMP $0234,X est-on en bas de la fenetre ?
E338 F0 13 BEQ $E34D oui
E33A E6 63 INC $63 non, on descend dÅfune ligne
E33C A5 63 LDA $63
E33E 20 12 DE JSR $DE12 on calcule son adresse
E341 20 F9 E2 JSR $E2F9 on est sur un prompt ?
127
E344 F0 05 BEQ $E34B oui
E346 20 DE E2 JSR $E2De non, on cherche le dernier caractere
E349 D0 E4 BNE $E32F tant quÅfon nÅfest pas sur la premiere colonne
E34B C6 63 DEC $63 on remonte dÅfune ligne
E34D 60 RTS
E34E 60 RTS ben voyons ! le $E34D ne suffisait pas !?
ENVOIE LA LIGNE DANS BUFEDT
E34F 20 01 E3 JSR $E301 on calcule la position dÅfun prompt ($60-$61)
E352 4C 61 E3 JMP $E361 et on envoie . . .
ENVOIE LA FIN DE LA LIGNE DANS BUFEDT
Action : Envoie la ligne courante a partir du curseur dans BUFEDT.
E355 A6 28 LDX $28
E357 BD 20 02 LDA $0220,X
E35A 85 60 STA $60 on prend les coordonnees du curseur
E35C BD 24 02 LDA $0224,X
E35F 85 61 STA $61
E361 20 22 E3 JSR $E322 on calcule le debut de la ligne ($62-$63)
E364 A5 61 LDA $61 on sauve la ligne trouvee
E366 85 65 STA $65
E368 C5 63 CMP $63 est-ce apres un prompt ?
E36A D0 0C BNE $E378 non
E36C A5 62 LDA $62 oui, les colonnes correspondent ?
E36E C5 60 CMP $60
E370 B0 06 BCS $E378 non, le prompt est avant le debut de ligne
E372 A9 00 LDA #$00 oui, on indique commande vide
E374 8D 90 05 STA $0590 dans BUFEDT
E377 60 RTS
E378 A9 00 LDA #$00 on met 0
E37A 85 64 STA $64 dans $64
E37C 46 66 LSR $66 on decale $66 (b7=0)
E37E A5 65 LDA $65 on lit la ligne dans $65
E380 20 12 DE JSR $DE12 on calcule son adresse dans RES
E383 A4 60 LDY $60 on prend la colonne de debut de commande
E385 A5 65 LDA $65 et la ligne dans $65
E387 C5 61 CMP $61 est-ce la ligne de debut de commande ?
E389 F0 05 BEQ $E390 oui
E38B A6 28 LDX $28
E38D BC 28 02 LDY $0228,X non, alors la colonne est le debut de la fenetre
E390 B1 00 LDA ($00),Y on lit le code qui sÅfy trouve
E392 C9 20 CMP #$20 un code de controle ?
E394 B0 02 BCS $E398 non
E396 09 80 ORA #$80 oui, on lÅfinverse par b7=1 (pourquoi ?)
E398 A6 64 LDX $64 X=position dans la ligne
E39A 24 66 BIT $66 b7 de $66=1 ?
E39C 10 06 BPL $E3A4 non
E39E A9 20 LDA #$20 oui on efface le code
E3A0 91 00 STA ($00),Y on met un espace sous le curseur
E3A2 D0 0D BNE $E3B1 inconditionnel
128
E3A4 9D 90 05 STA $0590,X on stocke le code
E3A7 E6 64 INC $64 on indexe la position suivante
E3A9 E4 67 CPX $67 est on en fin de ligne ?
E3AB 90 04 BCC $E3B1 non
E3AD C6 64 DEC $64 oui, on decremente lÅfindex
E3AF 66 66 ROR $66 et on met b7 de $66 a 1
E3B1 98 TYA on sauve la position ecran du curseur dans A
E3B2 C8 INY on avance sur le caractere suivant
E3B3 A6 65 LDX $65 on prend lÅfindexe de ligne
E3B5 E4 63 CPX $63 on est sur la derniere ligne ?
E3B7 D0 0C BNE $E3C5 non
E3B9 C5 62 CMP $62 oui, derniere colonne ?
E3BB D0 D3 BNE $E390 non
E3BD A6 64 LDX $64
E3BF A9 00 LDA #$00
E3C1 9D 90 05 STA $0590,X oui, on indique fin de commande
E3C4 60 RTS et on sort
E3C5 A6 28 LDX $28 on prend le numero de la fenetre
E3C7 DD 2C 02 CMP $022C,X on est sur la derniere colonne de la fenetre ?
E3CA D0 C4 BNE $E390 pas fin de la fenetre, on boucle
E3CC E6 65 INC $65 fin, on ajoute 1 a la ligne
E3CE D0 AE BNE $E37E inconditionnel, on continue la lecture
AFFICHE LE CONTENU DE BUFEDT
Action : Si C=1, efface la ligne de commande. Si C=0, affiche le buffer
dÅfedition sur la ligne de commande. Cette routine est buggee car
le dernier adressage du curseur gere sans crier gare lÅfunique
fenetre 0 ! LÅfedition de ligne ne se fera donc que sur la fenetre
0. . .
E3D0 66 66 ROR $66 C dans b7 de $66
E3D2 A9 00 LDA #$00 0 en $64
E3D4 85 64 STA $64
E3D6 A5 26 LDA $26 AY=ADSCR
E3D8 A4 27 LDY $27
E3DA 85 00 STA $00 dans RES
E3DC 84 01 STY $01
E3DE A6 28 LDX $28
E3E0 BC 20 02 LDY $0220,X on prend la colonne du curseur
E3E3 A6 64 LDX $64
E3E5 BD 90 05 LDA $0590,X on lit le code indexe dans BUFEDT
E3E8 F0 32 BEQ $E41C si 0, on saute
E3EA A9 20 LDA #$20 on met espace dans A
E3EC 24 66 BIT $66 si il faut effacer la ligne
E3EE 30 0B BMI $E3FB on efface
E3F0 BD 90 05 LDA $0590,X sinon, on lit un code
E3F3 10 06 BPL $E3FB
E3F5 C9 A0 CMP #$A0 >32+128 ?
E3F7 B0 02 BCS $E3FB oui
E3F9 29 1F AND #$1F non, code de controle
E3FB 91 00 STA ($00),Y a lÅfecran
129
E3FD 2C 0D 02 BIT $020D mode minitel
E400 50 03 BVC $E405 non
E402 20 56 E6 JSR $E656 oui, on envoie le code dans le buffer SERIE OUT
E405 98 TYA index ecran dans A
E406 C8 INY on ajoute une colonne
E407 A6 28 LDX $28
E409 DD 2C 02 CMP $022C,X derniere colonne ?
E40C D0 0A BNE $E418 non
E40E A9 28 LDA #$28 on ajoute 40 (une ligne)
E410 A0 00 LDY #$00 a RES (adresse curseur)
E412 20 89 CE JSR $CE89 par ADRES
E415 BC 28 02 LDY $0228,X Y=premiere colonne de la fenetre
E418 E6 64 INC $64 on indexe caractere suivant dans BUFEDT
E41A D0 C7 BNE $E3E3 inconditionnel
E41C 2C 0D 02 BIT $020D mode minitel ?
E41F 50 09 BVC $E42A non, on sort
E421 AE 20 02 LDX $0220 on prend la position du curseur (BUG !!!)
E424 AC 24 02 LDY $0224 et la ligne (RE-BUG !! pourquoi fenetre 0 ?)
E427 20 2A E6 JSR $E62A et on positionne le curseur
E42A AC 20 02 LDY $0220 on prend la position du curseur (BUG : LDY,X !)
E42D B1 26 LDA ($26),Y on lit le code
E42F A6 28 LDX $28
E431 9D 4C 02 STA $024C,X et on le place sous le curseur
E434 60 RTS
EDITION DE LIGNE DANS BUFEDT
Action : Cette macro routine lit au clavier une commande, calcule sÅfil y a
lieu le nombre en debut de ligne (suppose etre le numero de
ligne), et sort en codant la ligne dans BUFEDT. Un bug
malencontreux ne permet son usage que sur la fenetre 0.
En entree, A contient la longueur maxi de la commande (<110),
Y>128 sÅfil faut ramener le curseur en debut de ligne (il est
ramene de toutes facons par le CR en E446 !) et X le nombre de
caracteres a sauter avant lÅfedition. En sortie, la ligne est dans
BUFEDT terminee par un 0, A contient le mode de sortie (RETURN
13, CTRL-C 3 ou FLECHES 10,11) et RES le numero de ligne ainsi
que le nombre dÅfespaces bidons dans Y.
E435 85 67 STA $67 on sauve la longueur demandee
E437 8A TXA le deplacement
E438 48 PHA
E439 98 TYA
E43A 10 0A BPL $E446 faut-il revenir au debut de la ligne ? non
E43C 20 01 E3 JSR $E301 on calcule les coordonnees du debut de ligne
E43F A6 60 LDX $60
E441 A4 61 LDY $61
E443 20 2A E6 JSR $E62A et on positionne le curseur
E446 A9 0D LDA #$0D on envoie un CR
E448 20 48 E6 JSR $E648
E44B 20 6C E6 JSR $E66C on affiche le prompt
E44E 68 PLA
130
E44F AA TAX on recupere le deplacement
E450 F0 08 BEQ $E45A
E452 A9 09 LDA #$09 et on se deplace
E454 20 48 E6 JSR $E648
E457 CA DEX X fois
E458 D0 F8 BNE $E452
E45A A6 28 LDX $28 X=numero de fenetre courante
E45C BD 48 02 LDA $0248,X le curseur doit-etre affiche ?
E45F 30 05 BMI $E466 oui
E461 A9 11 LDA #$11 non, on bascule, donc on force lÅfaffichage
E463 20 48 E6 JSR $E648
E466 20 AF CF JSR $CFAF on teste les buffers
E469 20 CF C7 JSR $C7CF on lit un code au clavier
E46C B0 F8 BCS $E466 pas de code, on boucle
E46E 48 PHA on sauve le code
E46F A9 11 LDA #$11 on efface le curseur
E471 20 48 E6 JSR $E648
E474 68 PLA on reprend le code
E475 C9 0D CMP #$0D est-ce RETURN ?
E477 D0 43 BNE $E4BC non
E479 48 PHA
E47A 20 4F E3 JSR $E34F oui, on code BUFEDT
E47D 68 PLA
E47E 48 PHA
E47F C9 0B CMP #$0B est-ce fleche haut ?
E481 F0 11 BEQ $E494 oui
E483 A6 62 LDX $62 on prend les coordonnees courantes
E485 A4 63 LDY $63 du curseur
E487 20 2A E6 JSR $E62A et on positionne le curseur
E48A A9 0D LDA #$0D et on emet un CR
E48C 20 48 E6 JSR $E648
E48F A9 0A LDA #$0A puis un LF
E491 20 48 E6 JSR $E648
E494 A2 FF LDX #$FF
E496 E8 INX on va eliminer les espaces de debut de ligne
E497 BD 90 05 LDA $0590,X
E49A C9 20 CMP #$20 un espace ?
E49C F0 F8 BEQ $E496 oui
E49E 8A TXA non, on sauve le nombre dÅfespaces bidons
E49F 48 PHA
E4A0 A0 00 LDY #$00
E4A2 BYT $2C le premier tour se fait sans incrementer
E4A3 E8 INX
E4A4 C8 INY
E4A5 BD 90 05 LDA $0590,X on ramene les caracteres apres les espaces
E4A8 99 90 05 STA $0590,Y au debut de la ligne
E4AB D0 F6 BNE $E4A3 et on sort si on est sur le 0 final
E4AD A9 90 LDA #$90 AY=$590, BUFEDT
E4AF A0 05 LDY #$05
E4B1 20 49 E7 JSR $E749 on calcule le numero de ligne dans RES
E4B4 85 00 STA $00
E4B6 84 01 STY $01
E4B8 68 PLA on sort le nombre dÅfespaces bidon dans Y
E4B9 A8 TAY
131
E4BA 68 PLA et le mode de sortie dans A
E4BB 60 RTS
E4BC C9 03 CMP #$03 est-ce CTRL-C ?
E4BE F0 B9 BEQ $E479 oui, on sort
E4C0 C9 0E CMP #$0E non, CTRL-N ?
E4C2 D0 0D BNE $E4D1 non
E4C4 20 01 E3 JSR $E301 oui, on calcule la position du debut de la ligne
E4C7 A6 60 LDX $60
E4C9 A4 61 LDY $61
E4CB 20 2A E6 JSR $E62A on ramene le curseur en debut de ligne
E4CE 4C D5 E4 JMP $E4D5 et on saute
E4D1 C9 18 CMP #$18 CTRL-X ?
E4D3 D0 0A BNE $E4DF non
E4D5 20 55 E3 JSR $E355 oui, on vide la ligne
E4D8 38 SEC C=1 pour vider BUFEDT
E4D9 20 D0 E3 JSR $E3D0 on vide BUFEDT
E4DC 4C 5A E4 JMP $E45A et on continue lÅfedition
E4DF C9 7F CMP #$7F DEL ?
E4E1 D0 47 BNE $E52A non, on passe
E4E3 AD 78 02 LDA $0278 SHIFT presse ?
E4E6 4A LSR
E4E7 B0 0A BCS $E4F3 oui
E4E9 90 00 BCC $E4EB nÅfimporte quoi !
E4EB A9 08 LDA #$08 A=deplacement vers la gauche du curseur
E4ED BYT $2C et on saute lÅfinstruction suivante
E4EE A9 09 LDA #$09 A=deplacement vers la droite
E4F0 20 48 E6 JSR $E648 on envoie le deplacement
E4F3 A6 28 LDX $28 X=numero de fenetre courante
E4F5 BD 4C 02 LDA $024C,X on prend le code sous le curseur
E4F8 C9 7F CMP #$7F est-ce un prompt ?
E4FA F0 F2 BEQ $E4EE oui, on deplace le curseur a gauche
E4FC 20 55 E3 JSR $E355 on recopie la ligne dans BUFEDT
E4FF AD 90 05 LDA $0590 ligne vide ?
E502 D0 0D BNE $E511 non
E504 A9 20 LDA #$20 on envoie un espace a lÅfecran
E506 20 48 E6 JSR $E648
E509 A9 08 LDA #$08 et on replace le curseur sur lÅfespace
E50B 20 48 E6 JSR $E648
E50E 4C 5A E4 JMP $E45A et on continue lÅfedition
E511 A2 01 LDX #$01 on prend un code
E513 BD 90 05 LDA $0590,X
E516 F0 06 BEQ $E51E si 0, on sort
E518 9D 8F 05 STA $058F,X sinon, on le ramene a gauche dans BUFEDT
E51B E8 INX
E51C D0 F5 BNE $E513 et on ramene ainsi la ligne
E51E A9 20 LDA #$20 et on envoie un espace en derniere position
E520 9D 8F 05 STA $058F,X
E523 18 CLC C=0, on affiche BUFEDT
E524 20 D0 E3 JSR $E3D0
E527 4C 5A E4 JMP $E45A et on continue lÅfedition
E52A C9 20 CMP #$20 code CTRL ?
E52C 90 06 BCC $E534 oui
E52E 20 37 E5 JSR $E537 non, on envoie le code
E531 4C 5A E4 JMP $E45A et on continue lÅfedition
132
E534 4C B9 E5 JMP $E5B9 on gere les codes de controle
TRAITE LES CARACTERES NORMAUX
Remarque : Un gros BUG vient salir la routine de son empreinte
malodorante. . . les caracteres sortant a droite en bas de
lÅfecran sont perdus. . .
E537 A8 TAY code dans Y
E538 8A TXA on sauve X
E539 48 PHA
E53A 98 TYA et le code
E53B 48 PHA
E53C 20 55 E3 JSR $E355 on copie la commande apres le curseur dans BUFEDT
E53F A5 62 LDA $62 A=colonne
E541 AC 90 05 LDY $0590 Y=premier code
E544 D0 02 BNE $E548 si pas fin de buffer, on saute
E546 A5 60 LDA $60 A=colonne dans la fenetre
E548 A6 28 LDX $28 X=numero de fenetre
E54A DD 2C 02 CMP $022C,X est-on a la fin de la fenetre ?
E54D D0 5F BNE $E5AE non
E54F A5 63 LDA $63
E551 DD 34 02 CMP $0234,X fin de fenetre en bas ?
E554 F0 58 BEQ $E5AE oui, on sort
E556 69 01 ADC #$01 non, on ajoute 1 ligne
E558 20 12 DE JSR $DE12 on calcule lÅfadresse de la ligne
E55B 20 F9 E2 JSR $E2F9 on est sur un prompt ?
E55E D0 4E BNE $E5AE non, on sort
E560 BC 34 02 LDY $0234,X oui, Y=fin de la fenetre
E563 A6 63 LDX $63 X=ligne curseur
E565 E8 INX +1
E566 20 5C DE JSR $DE5C on scrolle la fenetre
E569 2C 0D 02 BIT $020D mode minitel ?
E56C 50 40 BVC $E5AE non, on sort
E56E A2 00 LDX #$00
E570 A4 63 LDY $63
E572 C8 INY
E573 20 2A E6 JSR $E62A on se positionne sur la colonne 12 virtuelle
E576 A9 18 LDA #$18 on envoie un CTRL-X
E578 20 56 E6 JSR $E656
E57B A9 0A LDA #$0A et un saut de ligne
E57D 20 48 E6 JSR $E648
E580 A6 28 LDX $28
E582 BD 4C 02 LDA $024C,X on est sur un prompt ?
E585 C9 7F CMP #$7F
E587 D0 06 BNE $E58F
E589 20 6C E6 JSR $E66C oui, on affiche le prompt
E58C 4C 97 E5 JMP $E597 et on saute
E58F 20 56 E6 JSR $E656 non, on envoie le code sur le buffer SERIE
E592 A9 09 LDA #$09 et on deplace le curseur a droite
E594 20 B5 DB JSR $DBB5 sur la fenetre courante
E597 AD 24 02 LDA $0224 , X !!! bug :on lit la fenetre 0 !
133
E59A DD 34 02 CMP $0234,X est-on en fin de page ?
E59D D0 E1 BNE $E580 non, on boucle pour trouver le prompt
E59F AD 20 02 LDA $0220 fin de colonne ? (re-BUG !!!)
E5A2 DD 2C 02 CMP $022C,X
E5A5 D0 D9 BNE $E580 non, id
E5A7 A4 61 LDY $61 et on positionne le curseur
E5A9 A6 60 LDX $60 apres le prompt
E5AB 20 2A E6 JSR $E62A
E5AE 68 PLA on sort le code
E5AF 20 48 E6 JSR $E648 on lÅfenvoie a lÅfecran
E5B2 18 CLC C=0
E5B3 20 D0 E3 JSR $E3D0 et dans le buffer
E5B6 68 PLA on recupere X
E5B7 AA TAX
E5B8 60 RTS et on sort
GERE LES CODES DE CONTROLE
E5B9 C9 08 CMP #$08 est-ce fleche gauche ?
E5BB D0 18 BNE $E5D5 non
E5BD 48 PHA
E5BE AD 78 02 LDA $0278 SHIFT ?
E5C1 4A LSR
E5C2 B0 07 BCS $E5CB oui
E5C4 68 PLA on sort le code
E5C5 20 48 E6 JSR $E648 on lÅfenvoie
E5C8 4C 5A E4 JMP $E45A et on sort
E5CB 20 01 E3 JSR $E301 on cherche le debut de la ligne
E5CE A6 60 LDX $60
E5D0 A4 61 LDY $61
E5D2 4C E7 E5 JMP $E5E7 et on ramene le curseur
E5D5 C9 09 CMP #$09 fleche droite ?
E5D7 D0 15 BNE $E5EE non
E5D9 48 PHA
E5DA AD 78 02 LDA $0278 oui, SHIFT
E5DD 4A LSR
E5DE 90 E4 BCC $E5C4 non
E5E0 20 22 E3 JSR $E322 oui, on cherche la fin de la ligne
E5E3 A6 62 LDX $62
E5E5 A4 63 LDY $63
E5E7 68 PLA
E5E8 20 2A E6 JSR $E62A on positionne le curseur
E5EB 4C 5A E4 JMP $E45A et on sort
E5EE C9 0A CMP #$0A fleche bas ?
E5F0 D0 12 BNE $E604 non
E5F2 A6 28 LDX $28 oui
E5F4 BD 24 02 LDA $0224,X on est en bas de la fenetre ?
E5F7 DD 34 02 CMP $0234,X
E5FA D0 19 BNE $E615 non
E5FC A9 0A LDA #$0A oui, on indique deplacement vers le bas
E5FE BYT $2C et on saute . . .
134
E5FF A9 0B LDA $0B on indique deplacement vers le haut
E601 4C 79 E4 JMP $E479 et on poursuit
E604 C9 0B CMP #$0B fleche haut ?
E606 D0 0F BNE $E617 non
E608 A6 28 LDX $28
E60A BD 24 02 LDA $0224,X debut de fenetre ?
E60D DD 30 02 CMP $0230,X
E610 F0 ED BEQ $E5FF oui
E612 A9 0B LDA #$0B on indique deplacement vers le haut
E614 BYT $2C et on saute lÅfinstruction suivante
E615 A9 0A LDA #$0A on indique deplacement vers le bas
E617 C9 0C CMP #$0C CTRL-L ?
E619 D0 09 BNE $E624 non
E61B 20 48 E6 JSR $E648 oui, on efface lÅfecran
E61E 20 6C E6 JSR $E66C on affiche le prompt
E621 4C 5A E4 JMP $E45A et on boucle
E624 20 48 E6 JSR $E648 on envoie le code a lÅfecran
E627 4C 5A E4 JMP $E45A et on boucle lÅfedition
POSITIONNE LE CURSEUR EN X,Y
Action : Positionne le curseur a lÅfecran et sur le minitel sÅfil est actif
en tant que sortie video.
E62A A9 1F LDA #$1F on envoie un US
E62C 20 48 E6 JSR $E648
E62F 98 TYA on envoie Y+64
E630 09 40 ORA #$40
E632 20 48 E6 JSR $E648
E635 8A TXA et X+64
E636 09 40 ORA #$40
E638 20 B5 DB JSR $DBB5
E63B 2C 0D 02 BIT $020D mode minitel ?
E63E 50 2B BVC $E66B non
E640 E8 INX on ajoute une colonne
E641 8A TXA dans A
E642 CA DEX et on revient en arriere
E643 09 40 ORA #$40 on ajoute 40
E645 4C 56 E6 JMP $E656 et on envoie au minitel
ENVOIE UN CODE SUR LE TERMINAL VIDEO
Action : Envoie un code sur lÅfecran et eventuellement sur le minitel sÅfil
est actif comme sortie video. Seule la fenetre 0 est geree, ce
qui ote definitivement tout espoir de gestion dÅfentree de
commande sur une autre fenetre.
135
E648 2C 0D 02 BIT $020D mode minitel ?
E64B 50 03 BVC $E650 non
E64D 20 56 E6 JSR $E656 oui, on envoie le code au minitel
E650 2C 50 E6 BIT $E650 V=0 et N=0 pour ecriture
E653 4C 86 DB JMP $DB86 dans la fenetre 0
ENVOIE UN CODE AU BUFFER SERIE SORTIE
E656 85 0C STA $0C on sauve le code
E658 98 TYA on sauve Y
E659 48 PHA
E65A 8A TXA et X
E65B 48 PHA
E65C A2 18 LDX #$18 on indexe buffer ACIA sortie (minitel sortie)
E65E A5 0C LDA $0C on envoie le code
E660 20 1D C5 JSR $C51D
E663 68 PLA on restaure les registres
E664 AA TAX
E665 68 PLA
E666 A8 TAY
E667 A5 0C LDA $0C
E669 B0 EB BCS $E656 si lÅfenvoi sÅfest mal passe, on recommence
E66B 60 RTS
AFFICHE LE PROMPT
E66C 2C 0D 02 BIT $020D mode minitel
E66F 50 0A BVC $E67B non
E671 A9 19 LDA #$19 on envoie SS2 2/E au minitel
E673 20 56 E6 JSR $E656
E676 A9 2E LDA #$2E donc on affiche la fleche ->
E678 20 56 E6 JSR $E656
E67B A9 7F LDA #$7F on affiche un prompt
E67D 4C B5 DB JMP $DBB5 a lÅfecran
CHERCHE UNE LIGNE DÅfAPRES SON NUMERO
Action : Recherche la ligne numero RES a partir de lÅfadresse SCEDES. Une
ligne de programme est composee de lÅfentete de 3 octets
suivants :
1er octet : longueur de la ligne, ou 0 si derniere ligne.
2 et 3ieme octet : numero de la ligne. En sortie, C=1 si la ligne a
ete trouvee (adresse dans RESB), 0 sinon.
E680 A5 5C LDA $5C AX=adresse de base de recherche
E682 A6 5D LDX $5D
136
E684 86 03 STX $03 dans RESB
E686 85 02 STA $02
E688 A0 00 LDY #$00
E68A B1 02 LDA ($02),Y on lit la longueur de la ligne
E68C F0 20 BEQ $E6AE 0, on sort
E68E AA TAX on sauve la longueur dans X
E68F A0 02 LDY #$02 on lit le numero de la ligne
E691 A5 01 LDA $01
E693 D1 02 CMP ($02),Y poids fort lu egal au demande ?
E695 90 17 BCC $E6AE superieur, on sort
E697 F0 02 BEQ $E69B egal, on continue le test
E699 B0 09 BCS $E6A4 inferieur, on passe
E69B 88 DEY on lit le poids faible
E69C A5 00 LDA $00
E69E D1 02 CMP ($02),Y poids faible lu egal au demande ?
E6A0 90 0C BCC $E6AE superieur, on sort
E6A2 F0 0B BEQ $E6AF egal, on sort avec C=1
E6A4 18 CLC
E6A5 8A TXA
E6A6 65 02 ADC $02 on passe la ligne
E6A8 90 DC BCC $E686
E6AA E6 03 INC $03
E6AC B0 D8 BCS $E686 et on continue
E6AE 18 CLC C=0, ligne non trouvee
E6AF 60 RTS
INSERE UNE LIGNE DANS UN LISTING
Action : Insere la ligne numero RES contenue a lÅfadresse TR0-1, de
longueur A dans le listing commencant a lÅfadresse SCEDEB et
finissant a lÅfadresse SCEFIN. En sortie, SCEDEB contient
lÅfadresse de la ligne dans le listing, SCEFIN la nouvelle fin du
listing et TR3-4 la difference de taille du listing, en
complement a 2. Tres pratique tout ca !
E6B0 85 0E STA $0E sauve la longueur de la ligne
E6B2 A9 00 LDA #$00 met 0 dans TR3-4
E6B4 85 0F STA $0F
E6B6 85 10 STA $10
E6B8 20 80 E6 JSR $E680 cherche le numero de la ligne a inserer
E6BB 90 2A BCC $E6E7 la ligne nÅfexiste pas
E6BD 86 0F STX $0F on sauve la longueur de la ligne trouvee
E6BF A5 5E LDA $5E on met SCEFIN
E6C1 A4 5F LDY $5F
E6C3 85 06 STA $06 dans DECFIN
E6C5 84 07 STY $07
E6C7 A5 02 LDA $02 adresse de la ligne trouvee
E6C9 A4 03 LDY $03
E6CB 85 08 STA $08 dans DECCIB
E6CD 84 09 STY $09
137
E6CF 18 CLC
E6D0 8A TXA
E6D1 65 02 ADC $02
E6D3 90 01 BCC $E6D6 et lÅfadresse de la fin de la ligne
E6D5 C8 INY
E6D6 85 04 STA $04 dans DECDEB
E6D8 84 05 STY $05
E6DA 20 6C CD JSR $CD6C et on ramene la fin du listing (efface la ligne)
E6DD A9 FF LDA #$FF on met -1
E6DF 85 10 STA $10 dans TR4
E6E1 45 0F EOR $0F on complemente TR3 a 2
E6E3 85 0F STA $0F donc on remet dans TR3-4
E6E5 E6 0F INC $0F lÅfoppose de TR3-4
E6E7 A5 0E LDA $0E on prend la longueur a inserer
E6E9 F0 4D BEQ $E738 cÅfest 0, on devait effacer la ligne
E6EB A5 5E LDA $5E on prend la fin du listing
E6ED A4 5F LDY $5F
E6EF 85 06 STA $06 dans DECFIN
E6F1 84 07 STY $07
E6F3 A5 02 LDA $02 on prend lÅfadresse de la ligne
E6F5 A4 03 LDY $03
E6F7 85 04 STA $04 dans DECDEB
E6F9 84 05 STY $05
E6FB 18 CLC
E6FC A5 0E LDA $0E on ajoute 3 a la longueur (entete de ligne)
E6FE 69 03 ADC #$03
E700 48 PHA dans la pile
E701 65 02 ADC $02 on ajoute la longueur
E703 90 01 BCC $E706 a DECDEB
E705 C8 INY
E706 85 08 STA $08 dans DECCIB
E708 84 09 STY $09
E70A 20 6C CD JSR $CD6C et on libere la place pour la ligne
E70D 18 CLC
E70E 68 PLA
E70F 48 PHA on prend la longueur
E710 65 0F ADC $0F on calcule longueur nouvelle ligne
E712 85 0F STA $0F - longueur ligne precedente
E714 90 02 BCC $E718
E716 E6 10 INC $10 dans TR3-4 (complement a 2)
E718 A0 00 LDY #$00 on ecrit la longueur de la ligne
E71A 68 PLA
E71B 91 02 STA ($02),Y
E71D C8 INY
E71E A5 00 LDA $00
E720 91 02 STA ($02),Y le poids faible du numero de ligne
E722 C8 INY
E723 A5 01 LDA $01
E725 91 02 STA ($02),Y le poids fort du numero de ligne
E727 A2 00 LDX #$00
E729 C8 INY
E72A A1 0C LDA ($0C,X) et le contenu de la ligne
E72C 91 02 STA ($02),Y a la suite
E72E E6 0C INC $0C
138
E730 D0 02 BNE $E734
E732 E6 0D INC $0D
E734 C6 0E DEC $0E jusquÅfa la fin
E736 D0 F1 BNE $E729
E738 18 CLC
E739 A5 0F LDA $0F on calcule dans SCEFIN
E73B 65 5E ADC $5E
E73D 85 5E STA $5E
E73F A4 10 LDY $10 la nouvelle adresse de fin du listing
E741 98 TYA
E742 65 5F ADC $5F
E744 85 5F STA $5F
E746 A5 0F LDA $0F et AY=difference de longueur de lignes
E748 60 RTS
CONVERSION ASCII -> BINAIRE
Principe : On lit un a un les chiffres de la chaine stockee en AY jusquÅfa
ce quÅfon ait plus de chiffres. On multiplie au fur et a mesure le
resultat par 10 avant dÅfajouter le chiffre trouve. Le principe
est aise a assimiler et la routine compacte. Un bon exemple
dÅfoptimisation. En sortie, AY et RESB contient le nombre, AY
lÅfadresse de la chaine, et X le nombre de caractere decodes.
E749 85 00 STA $00 on sauve lÅfadresse du nombre
E74B 84 01 STY $01 dans RES
E74D A0 00 LDY #$00 et on met RESB a 0
E74F 84 02 STY $02
E751 84 03 STY $03
E753 B1 00 LDA ($00),Y on lit le code
E755 C9 30 CMP #$30 inferieur a 0 ?
E757 90 2C BCC $E785 oui
E759 C9 3A CMP #$3A superieur a 9 ?
E75B B0 28 BCS $E785 oui
E75D 29 0F AND #$0F on isole le chiffre
E75F 48 PHA dans la pile
E760 06 02 ASL $02 RESB*2
E762 26 03 ROL $03
E764 A5 02 LDA $02 AX=RESB*2
E766 A6 03 LDX $03
E768 06 02 ASL $02 *4
E76A 26 03 ROL $03
E76C 06 02 ASL $02 *8
E76E 26 03 ROL $03
E770 65 02 ADC $02 +RESB*2
E772 85 02 STA $02
E774 8A TXA
E775 65 03 ADC $03
E777 85 03 STA $03 = RESB*10
E779 68 PLA plus chiffre lu
139
E77A 65 02 ADC $02
E77C 85 02 STA $02
E77E 90 02 BCC $E782
E780 E6 03 INC $03
E782 C8 INY on ajoute un chiffre lu
E783 D0 CE BNE $E753 et on recommence
E785 98 TYA nombre de chiffres lus
E786 AA TAX dans X
E787 A5 02 LDA $02 nombre dans AY et RESB
E789 A4 03 LDY $03
E78B 60 RTS
DONNEES POUR AFFICHAGE HIRES
E78C BYT 32,16,8,4,2,1 position des bits 5,4,3,2,1 et 0 pou masque
AFFICHE LE CURSEUR HIRES
Action : Si HRS5+1 est negatif, positionne le curseur selon HRS40, HRSX6
et ADHRS le FB est pris en compte dans b7b6 de HRSFB. En fait
HRS5+1 contient le pattern, dÅfou la rotation totale.
E792 18 CLC C=0
E793 24 56 BIT $56 on fait tourner HRS5+1 sur lui-meme
E795 10 01 BPL $E798 afin de conserver le pattern
E797 38 SEC
E798 26 56 ROL $56
E79A 90 24 BCC $E7C0 si b7 de $56 a 0, on saute
E79C A4 49 LDY $49 sinon on prend X/6
E79E B1 4B LDA ($4B),Y on lit le code actuel
E7A0 0A ASL on sort b7
E7A1 10 1D BPL $E7C0 pas pixel, on sort
E7A3 A6 4A LDX $4A on prend le reste de X/6
E7A5 BD 8C E7 LDA $E78C,X on lit le bit correspondant
E7A8 24 57 BIT $57 b7 de HRSFB a 1 ?
E7AA 30 0E BMI $E7BA b7 a 1, donc 3 ou 2
E7AC 50 05 BVC $E7B3 FB=0
E7AE 11 4B ORA ($4B),Y FB=1, on ajoute le code
E7B0 91 4B STA ($4B),Y et on le place
E7B2 60 RTS
E7B3 49 7F EOR #$7F on inverse le bit
E7B5 31 4B AND ($4B),Y et on lÅfeteint
E7B7 91 4B STA ($4B),Y avant de le placer
E7B9 60 RTS
E7BA 70 04 BVS $E7C0 FB=3, on sort
E7BC 51 4B EOR ($4B),Y FB=2, on inverse le bit
E7BE 91 4B STA ($4B),Y et on sort
E7C0 60 RTS
140
DEPLACEMENT RELATIF DU CURSEUR HIRES
Action : Ces quatre routines permettent un deplacement extremement rapide
du curseur HIRES dÅfapres lÅfadresse de la ligne ou il se trouve
(ADHRS), la colonne dans laquelle il se trouve (HRSX40) et sa
position dans lÅfoctet pointe (HRSX6).
Attention : Les coordonnees HRSX et HRSY ne sont pas modifiees ni
Verifiees avant le deplacement, a vous de gerer cela.
DEPLACE LE CURSEUR HIRES VERS LE BAS
E7C1 18 CLC on ajoute 40
E7C2 A5 4B LDA $4B a ADHRS
E7C4 69 28 ADC #$28
E7C6 85 4B STA $4B
E7C8 90 F6 BCC $E7C0
E7CA E6 4C INC $4C
E7CC 60 RTS et on sort
DEPLACE LE CURSEUR HIRES VERS LE HAUT
E7CD 38 SEC on soustrait 40
E7CE A5 4B LDA $4B a ADHRS
E7D0 E9 28 SBC #$28
E7D2 85 4B STA $4B
E7D4 B0 EA BCS $E7C0
E7D6 C6 4C DEC $4C
E7D8 60 RTS
DEPLACE LE CURSEUR HIRES VERS LA DROITE
E7D9 A6 4A LDX $4A on deplace dÅfun pixel
E7DB E8 INX
E7DC E0 06 CPX #$06 si on est a la fin
E7DE D0 04 BNE $E7E4
E7E0 A2 00 LDX #$00 on revient au debut
E7E2 E6 49 INC $49 et ajoute une colonne
E7E4 86 4A STX $4A
E7E6 60 RTS
DEPLACE LE CURSEUR HIRES VERS LA GAUCHE
E7E7 A6 4A LDX $4A
E7E9 CA DEX on deplace a gauche
E7EA 10 04 BPL $E7F0 si on sort
E7EC A2 05 LDX #$05 on se place a droite
141
E7EE C6 49 DEC $49 et on enleve une colonne
E7F0 86 4A STX $4A
E7F2 60 RTS
PLACE LE CURSEUR EN X,Y
Action : Calcule lÅfadresse du curseur en calculant la position de la ligne
par $A000+40*Y, la colonne dans X/6 et la position dans lÅfoctet
par X mod 6. Suite a une erreur dans la table des vecteurs
TELEMON, cette routine nÅfest pas appelee (alors quÅfelle devrait
lÅfetre) par BRK XHRSSE. . .
E7F3 84 47 STY $47 Y dans HRSY
E7F5 86 46 STX $46 X dans HRSX
E7F7 98 TYA et Y dans A
E7F8 A0 00 LDY #$00 AY=A, ligne du curseur
E7FA 20 69 CE JSR $CE69 on calcule 40*ligne
E7FD 85 4B STA $4B
E7FF 18 CLC
E800 98 TYA
E801 69 A0 ADC #$A0 et on ajoute $A000, ecran HIRES
E803 85 4C STA $4C dans ADHRS
E805 86 00 STX $00 on met la colonne dans RES
E807 A9 06 LDA #$06 A=6
E809 A0 00 LDY #$00 et Y=0 (dans RES+1)
E80B 84 01 STY $01 AY=6 et RES=colonne
E80D 20 DC CE JSR $CEDC on divise la colonne par 6
E810 A5 00 LDA $00 on sauve colonne/6 dans HRSX40
E812 85 49 STA $49
E814 A5 02 LDA $02 et le reste dans HRSX6
E816 85 4A STA $4A
E818 60 RTS
TRACE UN RECTANGLE EN RELATIF
Principe : On calcule les coordonnees absolues des 4 coins et on trace en
absolu. Pas tres optimise en temps tout cela, il aurait ete
plus simple de tracer directement en relatif !!!
Le rectangle est trace comme ABOX avec les parametres dans
HRSx.
E819 18 CLC C=0
E81A A5 46 LDA $46 on place les coordonnees actuelles
E81C 85 06 STA $06 du curseur dans $06-07
E81E 65 4D ADC $4D et les coordonnees (X+dx, Y+dy)
E820 85 08 STA $08
E822 A5 47 LDA $47
E824 85 07 STA $07
E826 65 4F ADC $4F
E828 85 09 STA $09 dans $08-09
E82A 90 0E BCC $E83A inconditionnel
142
TRACE UN RECTANGLE ABSOLU
Principe : Par un procede tres astucieux, on va tracer les 4 traits (en
absolu) joignant les 4 points. Voila bien la seule astuce
inutile ! Il aurait ete 100 (pourquoi pas 1000 !?) fois plus
simple, puisque le rectangle nÅfest fait que de verticales et
dÅfhorizontales, de tracer le rectangle immediatement en relatif
plutot que de passer par des calculs de tangentes lourds et
donnant un resultat connu (0 et infini) !!! Cette pietre
routine necessite les parametres comme ABOX dans HRSx.
E82C A0 06 LDY #$06 on place les 4 parametres (poids faible seulement)
E82E A2 03 LDX #$03
E830 B9 4D 00 LDA $004D,Y de HRSx
E833 95 06 STA $06,X dans $06-7-8-9
E835 88 DEY
E836 88 DEY
E837 CA DEX
E838 10 F6 BPL $E830
E83A A2 03 LDX #$03 on va tracer 4 traits
E83C 86 05 STX $05 dans $05
E83E BD 62 E8 LDA $E862,X on lit le code coordonnees
E841 85 04 STA $04 dans $04
E843 A2 06 LDX #$06 on va extraire 8 bits
E845 A9 00 LDA #$00 A=0
E847 95 4E STA $4E,X poids fort HRSx a 0 et positif
E849 46 04 LSR $04 on sort 2 bits
E84B 2A ROL dans A
E84C 46 04 LSR $04
E84E 2A ROL
E84F A8 TAY et Y
E850 B9 06 00 LDA $0006,Y on lit la coordonnee correspondante
E853 95 4D STA $4D,X et on stocke dans HRSx
E855 CA DEX
E856 CA DEX
E857 10 EC BPL $E845 on fait les 4 coordonnees ADRAW
E859 20 66 E8 JSR $E866 on trace le trait en absolu
E85C A6 05 LDX $05
E85E CA DEX
E85F 10 DB BPL $E83C et on fait 4 traits
E861 60 RTS
TABLE POUR TRACE DE RECTANGLES
Principe : Chaque octet contient, codee la sequence de coordonnees a
envoyer a la routine de trace de traits absolus. Dans un octet,
pour trouver la sequence de coordonnees, on isole les couples
de bits de gauche a droite, on inverse les deux bits et on
calcule en decimal. On obtient alors 0, 1, 2, 3 pour
respectivement X1, Y1, X2 et Y2. En fait, les Xi, Yi sont
stockes en $06-7-8-9 et les valeurs trouvees sont les index de
position des coordonnees par rapport a $06.
143
E862 BYT %00100110 soit 0, 1, 2, 1 ou X1, Y1, X2, Y1
E863 BYT %01100111 soit 2, 1, 2, 3 ou X2, Y1, X2, Y2
E864 BYT %01110011 soit 2, 3, 0, 3 ou X2, Y2, X1, Y2
E865 BYT %00110010 soit 0, 3, 0, 1 ou X1, Y2, X1, Y1
TRACE DE TRAIT EN ABSOLU
Action : On calcule dX et dY les deplacements dans HRS1 et HRS2 et on
trace en relatif. En entree, comme ADRAW dans HRSx.
E866 A6 4D LDX $4D X=colonne
E868 A4 4F LDY $4F Y=ligne du curseur
E86A 20 F3 E7 JSR $E7F3 on place le curseur en X, Y
E86D A2 FF LDX #$FF on met -1 dans X pour un changement de signe
E86F 38 SEC eventuel dans les parametres
E870 A5 51 LDA $51 on prend X2
E872 E5 4D SBC $4D -X1
E874 85 4D STA $4D dans HRS1 (DX)
E876 B0 03 BCS $E87B si DX<0, on inverse le signe de HRS1
E878 86 4E STX $4E DEC $4E aurait ete mieux. . .
E87A 38 SEC
E87B A5 53 LDA $53 on prend Y2
E87D E5 4F SBC $4F -Y1
E87F 85 4F STA $4F dans HRS2 (DY)
E881 B0 02 BCS $E885 et si DY negatif, on met signe -1
E883 86 50 STX $50 ou DEC $50
TRACE DE TRAIT EN RELATIF
Principe : Le principe du trace des droites est en fait assez complexe. On
aurait aime que F. BROCHE nous ponde une routine hyperoptimisee
dont il a le secret. Ce n'est malheureusement pas le
cas puisque cette routine l'algorithme des ROM V1.0 et 1.1.
Sans doute parce qu'il est tres efficaceÅc
Pour tracer un trait le plus rapidement possible, on cherche
lequel des deux axes est le plus grand et on trace selon cet
axe. Pour tracer, on avance sur l'axe de t points (t est la
valeur de la tangente) et on avance d'un point sur l'autre axe,
et ainsi de suite jusqu'a ce qu'on ait parcouru tout l'axe.
Ainsi DRAW 10,2,1 donnera en fait 2 paliers de 5 pixels de
large. Le cas dX=dY (deplacement egaux) est traite avec t=-1,
de plus les poids fort des deplacements gardent le signe car on
prend la valeur absolue de dx et dY pour les calculs.
E885 AD AA 02 LDA $02AA sauve le pattern
E888 85 56 STA $56 dans HRS1+1
E88A 20 42 E9 JSR $E942 verifie la validite de dX et dY
144
E88D 86 46 STX $46 X et Y contiennent HRSX+dX et HRSY+dY
E88F 84 47 STY $47 dans HRSX et HRSY
E891 24 4E BIT $4E dX negative ?
E893 10 08 BPL $E89D non
E895 A5 4D LDA $4D oui, on complemente
E897 49 FF EOR #$FF dX
E899 85 4D STA $4D
E89B E6 4D INC $4D a 2
E89D 24 50 BIT $50 dY negative ?
E89F 10 08 BPL $E8A9 non
E8A1 A5 4F LDA $4F oui, on complemente
E8A3 49 FF EOR #$FF dY
E8A5 85 4F STA $4F
E8A7 E6 4F INC $4F a 2
E8A9 A5 4D LDA $4D on teste dX et dY
E8AB C5 4F CMP $4F
E8AD 90 3E BCC $E8ED dX<dY
E8AF 08 PHP dX>=dY, on trace selon dX
E8B0 A5 4D LDA $4D on prends dX
E8B2 F0 37 BEQ $E8EB dX=0, on sort
E8B4 A6 4F LDX $4F X=dY
E8B6 20 21 E9 JSR $E921 on calcule dY/dX
E8B9 28 PLP
E8BA D0 04 BNE $E8C0 dX<>dY
E8BC A9 FF LDA #$FF dX=dY, la tangent est 1
E8BE 85 00 STA $00 en fait, -1, mais c'est la meme chose
E8C0 24 4E BIT $4E on teste dX
E8C2 10 06 BPL $E8CA dX>0
E8C4 20 E7 E7 JSR $E7E7 dX<0, on deplace le curseur a gauche
E8C7 4C CD E8 JMP $E8CD
E8CA 20 D9 E7 JSR $E7D9 on deplace le curseur a droite
E8CD 18 CLC a-t-on parcouru une valeur de la tangente
E8CE A5 00 LDA $00
E8D0 65 02 ADC $02 on stocke le resultat dans $02
E8D2 85 02 STA $02
E8D4 90 0D BCC $E8E3 non, on continue
E8D6 24 50 BIT $50 oui, dY<0 ?
E8D8 30 06 BMI $E8E0 oui
E8DA 20 C1 E7 JSR $E7C1 non, on deplace le curseur
E8DD 4C E3 E8 JMP $E8E3 vers le bas
E8E0 20 CD E7 JSR $E7CD on deplace vers le haut
E8E3 20 92 E7 JSR $E792 on affiche le point
E8E6 C6 4D DEC $4D on decrement dX
E8E8 D0 D6 BNE $E8C0 on n'a pas parcouru tout l'axe
E8EA 60 RTS sinon, on sort
E8EB 28 PLP
E8EC 60 RTS
E8ED A5 4F LDA $4F on trace la droite selon dY
E8EF F0 F9 BEQ $E8EA dY=0, on sort
E8F1 A6 4D LDX $4D X=dX
E8F3 20 21 E9 JSR $E921 on calculi dX/dY dans RES
E8F6 24 50 BIT $50
E8F8 10 06 BPL $E900 dY>0
E8FA 20 CD E7 JSR $E7CD dY<0, on deplace vers le haut
145
E8FD 4C 03 E9 JMP $E903 et on saute
E900 20 C1 E7 JSR $E7C1 on deplace vers le bas
E903 18 CLC a-t-on parcouru la tangent ?
E904 A5 00 LDA $00
E906 65 02 ADC $02
E908 85 02 STA $02 (dans $02)
E90A 90 0D BCC $E919 non
E90C 24 4E BIT $4E
E90E 10 06 BPL $E916 dX>0
E910 20 E7 E7 JSR $E7E7 dX<0, on deplace vers
E913 4C 19 E9 JMP $E919 la gauche
E916 20 D9 E7 JSR $E7D9 on deplace vers la droite
E919 20 92 E7 JSR $E792 on affiche le point
E91C C6 4F DEC $4F et on decrit dY
E91E D0 D6 BNE $E8F6
E920 60 RTS avant de sortir
CALCUL LA TANGENTE (*256) D'UN TRAIT
E921 86 01 STX $01 dX (ou dY)*256 dans RES+1
E923 A0 00 LDY #$00 dY (ou dX) dans AY
E925 84 00 STY $00
E927 20 DC CE JSR $CEDC calcul dX*256/dY (ou dY/dX)
E92A A9 FF LDA #$FF reste =-1
E92C 85 02 STA $02 resultat dans RES
E92E 60 RTS
ROUTINE CURSET
E92F A6 4D LDX $4D X=HRSX
E931 A4 4F LDY $4F Y=HRSY
E933 20 4E E9 JSR $E94E on verifie les coordonnees
E936 20 F3 E7 JSR $E7F3 on place le curseur en X,Y
E939 4C 9C E7 JMP $E79C et on affiche sans gerer pattern
ROUTINE CURMOV
E93C 20 42 E9 JSR $E942 on verifie les parametres
E93F 4C 36 E9 JMP $E936 et on deplace
VERIFIE LA VALIDITE DES PARAMETRES RELATIFS
Action : Verifie si l'adressage relatif du curseur est dans les limites de
l'ecran HIRES, soit si 0<=X+dX>240 et 0<=Y+dY<200.
146
E942 18 CLC
E943 A5 46 LDA $46 on prend HRSX
E945 65 4D ADC $4D plus le deplacement horizontal
E947 AA TAX dans X
E948 18 CLC
E949 A5 47 LDA $47 HRSY
E94B 65 4F ADC $4F plus le deplacement vertical
E94D A8 TAY dans Y
TESTE SI X ET Y SONT VALIDES
Principe : Si X>239 ou Y>199 alors on ne retourne pas au programme
appelant, mais a son appelant, en indiquant l'erreur dans
HRSERR.
E94E E0 F0 CPX #$F0 X>=240 ?
E950 B0 05 BCS $E957 oui
E952 C0 C8 CPY #$C8 Y>=200 ?
E954 B0 01 BCS $E957 oui
E956 60 RTS coordonnees ok, on sort.
E957 68 PLA on depile poids fort (>0)
E958 8D AB 02 STA $02AB dans HRSERR
E95B 68 PLA et poids faible de l'adresse de retour
E95C 60 RTS et on retourne a l'appelant de l'appelant
ROUTINE PAPER
E95D 18 CLC
E95E BYT $24
ROUTINE INK
E95F 38 SEC
FIXE LA COULEUR DE FOND OU DU TEXTE
Principe : A contient la couleur, X la fenetre ou 128 si mode HIRES et C=1
si la couleur est l'encre, o pour le fond.
Changer la couleur consiste a remplir la colonne couleur
correspondante avec le code de couleur. Aucun test de validite
n'etant fait, on peut utiliser ce moyen pour remplir les
colonnes 0 et 1 de n'importe quel attribut.
E960 48 PHA on sauve la couleur
147
E961 08 PHP et C
E962 86 00 STX $00 fenetre dans RES
E964 24 00 BIT $00 HIRES ?
E966 30 3F BMI $E9A7 oui
E968 86 28 STX $28 TEXT, on met le numero de la fenetre dans $28
E96A 90 05 BCC $E971 si C=0, c'est PAPER
E96C 9D 40 02 STA $0240,X on stocke la couleur d'encre
E96F B0 03 BCS $E974 si C=1 c'est INK
E971 9D 44 02 STA $0244,X ou la couleur de fond
E974 BD 48 02 LDA $0248,X est on en 38 colonnes ?
E977 29 10 AND #$10
E979 D0 0C BNE $E987 mode 38 colonne
E97B A9 0C LDA #$0C mode 40 colonnes, on efface l'ecran
E97D 20 B5 DB JSR $DBB5 (on envoie CHR$(12))
E980 A9 1D LDA #$1D et on passe en 38 colonnes
E982 20 B5 DB JSR $DBB5 (on envoie CHR$(29))
E985 A6 28 LDX $28 on prend X=numero de fenetre
E987 BD 30 02 LDA $0230,X on prend la ligne 0 de la fenetre
E98A 20 69 CE JSR $CE69 *40 dans RES
E98D BD 38 02 LDA $0238,X AY=adresse de base de la fenetre
E990 BC 3C 02 LDY $023C,X
E993 20 89 CE JSR $CE89 on ajoute l'adresse a RES (ligne 0 *40) dans RES
E996 BC 28 02 LDY $0228,X on prend la premiere colonne de la fenetre
E999 88 DEY on enleve deux colonnes
E99A 88 DEY
E99B 38 SEC
E99C BD 34 02 LDA $0234,X on calcule le nombre de lignes
E99F FD 30 02 SBC $0230,X de la fenetre
E9A2 AA TAX dans X
E9A3 E8 INX
E9A4 98 TYA colonne 0 dans Y
E9A5 B0 0C BCS $E9B3 inconditionnel
E9A7 A9 00 LDA #$00
E9A9 A2 A0 LDX #$A0
E9AB 85 00 STA $00 RES=$A000, adresse HIRES
E9AD 86 01 STX $01
E9AF A2 C8 LDX #$C8 X=200 pour 200 lignes
E9B1 A9 00 LDA #$00 A=0 pour colonne de debut = colonne 0
E9B3 28 PLP on sort C
E9B4 69 00 ADC #$00 A=A+C
E9B6 A8 TAY dans Y
E9B7 68 PLA on sort le code
E9B8 91 00 STA ($00),Y on le place dans la colonne correspondante
E9BA 48 PHA on le sauve
E9BB 18 CLC
E9BC A5 00 LDA $00 on passe 28 colonnes
E9BE 69 28 ADC #$28 (donc une ligne)
E9C0 85 00 STA $00
E9C2 90 02 BCC $E9C6
E9C4 E6 01 INC $01
E9C6 68 PLA on sort le code
E9C7 CA DEX on compte X ligne
E9C8 D0 EE BNE $E9B8
E9CA 60 RTS et on sort
148
TRACE UN CERCLE
Principe : Pour tracer une ellipsoide en general, on utilise la formule :
(X*X)/(A*A)+(Y*Y)/(B*B)=1, A et B etant respectivement la
largeur et la hauteur de l'ellipse. Pour un cercle, A=B donc on
ecrit : X*X+Y*Y=R*R soit encore X=SQR(R*R-Y*Y).
Pour tracer le cercle, il suffit de faire varier Y de 0 a R. On
obtient des valeurs positives de X et de Y dont le quart
inferieur droit du cercle. On trace les 3 autres quarts par
symetries. Le probleme d'un tel algorithme c'est qu'il
necessite le calcul d'une exponentiation (SQR(A)=A^0.5) et une
soustraction decimale. Son atout est de n'avoir a calculer
qu'un quart des valeurs. Les concepteurs de l'ATMOS (et a
fortiori F. BROCHE) ayant juge que cet algorithme etait par
trop complexe et laborieux, on prefere le calcul par suites
croisees dont la formule est :
X0=0 et Xn=X(n-1)+Yn/R (n et n-1 sont les indices des termes X
Y0=R et Yn=(n-1)-Xn/R et Y)
Etant donnee la priorite de calcul, on calcule en fait les
termes :
Xn=Xn-1+Yn-1/R
Yn=Yn-1-Xn/R ce qui fait deja une petite erreur de calcul.
De plus, diviser a chaque fois par R, serais long. Les
programmeurs et c'est la leur genie ont donc pense a deux
choses fort astucieuses :
a) on divisera non pas par R, mais par la puissance de deux
immediatement superieure a R afin de se ramener a des
decalages, on devient ainsi trop precis, ce qui rattrape
l'erreur passee.
b) on va coder Xn et Yn sur deux octets qui seront se et sf
respectivement les parties entieres et decimale de Xn et Yn
on calcule Xn=AB par Xn=A+B/256. Ce qui revient en fait a
considerer les 8 bits de B (b7b6b5b4b3b2b1b0) comme des bits
de puissance negatives decroissantes (b-1b-2b-3b-4b-5b-6b7b-
8). La precision est donc inferieure a 2^-9, soit a 0,002.
Ce qui est tres suffisant.
Une fois des deux conventions posees, on peut tracer le cercle
tres facilement. Son aspect sera de symetrie diagonales et non
verticale/horizontale du fait de la quadrature exercee sur les
valeurs mais bon. Pour tracer, on calcule un par un les termes
des suites et si la valeur entiere d'un des termes au moins
change on affiche le point. Et on continue jusqu'a Xn et Yn
soit revenus a leur position initiale.
149
Remarque : La routine est buggee, en effet si le rayon est 0 la boucle ce
calcule de la puissance de 2 > au rayon est infinie, idem si le
rayon est 128. Il aurait suffit d'incremente le rayon avant le
calcul.
E9CB A5 46 LDA $46 on sauve HRSX
E9CD 48 PHA
E9CE A5 47 LDA $47 et HRSY
E9D0 48 PHA
E9D1 AD AA 02 LDA $02AA et on met le pattern dans $56
E9D4 85 56 STA $56 car le trace du cercle en tient compte
E9D6 A5 47 LDA $47 on prend HRSY
E9D8 38 SEC
E9D9 E5 4D SBC $4D -rayon
E9DB A8 TAY dans Y
E9DC A6 46 LDX $46 on prend HRSX
E9DE 20 F3 E7 JSR $E7F3 et on place le premier point du cercle (X,Y-R)
E9E1 A2 08 LDX #$08 X=7+1 pour calculer N tel que Rayon (2^N)
E9E3 A5 4D LDA $4D on prend le rayon
E9E5 CA DEX on enleve une puissance
E9E6 0A ASL on decale le rayon a gauche
E9E7 10 FC BPL $E9E5 jusqu'a ce qu'un bit se presente dans b7
E9E9 86 0C STX $0C exposant du rayon dans $0C
E9EB A9 80 LDA #$80 A=$80 soit 0,5 en decimal
E9ED 85 0E STA $0E dans sfX
E9EF 85 10 STA $10 et sfY
E9F1 0A ASL A=0
E9F2 85 0F STA $0F dans seX
E9F4 A5 4D LDA $4D A=Rayon
E9F6 85 11 STA $11 dans seY
E9F8 38 SEC
E9F9 66 0D ROR $0D on met b7 de $0D a 1 (ne pas afficher le point)
E9FB A5 10 LDA $10 AX=sY
E9FD A6 11 LDX $11
E9FF 20 62 EA JSR $EA62 on calcule sY/R (en fait sY/2^N)
EA02 18 CLC
EA03 A5 0E LDA $0E on calcule sX=sX+sY/R
EA05 65 12 ADC $12
EA07 85 0E STA $0E
EA09 A5 0F LDA $0F
EA0B 85 12 STA $12
EA0D 65 13 ADC $13
EA0F 85 0F STA $0F la partie entiere seX a bouge ?
EA11 C5 12 CMP $12
EA13 F0 0D BEQ $EA22 non
EA15 B0 06 BCS $EA1D elle a augmente
EA17 20 D9 E7 JSR $E7D9 elle a baisse, on deplace le curseur
EA1A 4C 20 EA JMP $EA20 a droite
EA1D 20 E7 E7 JSR $E7E7 on deplace le curseur a gauche
EA20 46 0D LSR $0D on indique qu'il faut afficher le point
EA22 A5 0E LDA $0E AX=sX
EA24 A6 0F LDX $0F
EA26 20 62 EA JSR $EA62 on calcule sX/R (en fait sX/2^N)
EA29 38 SEC
150
EA2A A5 10 LDA $10 et sY=sY-sX/R
EA2C E5 12 SBC $12
EA2E 85 10 STA $10
EA30 A5 11 LDA $11
EA32 85 12 STA $12
EA34 E5 13 SBC $13
EA36 85 11 STA $11 seY a change (faut-il se deplacer verticalement)?
EA38 C5 12 CMP $12
EA3A F0 0E BEQ $EA4A non
EA3C B0 06 BCS $EA44 on monte
EA3E 20 C1 E7 JSR $E7C1 on est descend, on deplace le curseur
EA41 4C 4E EA JMP $EA4E vers le bas et on affiche
EA44 20 CD E7 JSR $E7CD on deplace le curseur vers le haut
EA47 4C 4E EA JMP $EA4E et on affiche
EA4A 24 0D BIT $0D faut-il afficher le point ?
EA4C 30 03 BMI $EA51 non, on passe
EA4E 20 92 E7 JSR $E792 on affiche le point nouvellement calcule
EA51 A5 0F LDA $0F seX=0
EA53 D0 A3 BNE $E9F8 non, on boucle
EA55 A5 11 LDA $11 oui, seY=rayon ?
EA57 C5 4D CMP $4D
EA59 D0 9D BNE $E9F8 non, on boucle
EA5B 68 PLA oui, on a fait le tour
EA5C A8 TAY on reprend les coordonnees du curseur sauvees
EA5D 68 PLA dans X et Y
EA5E AA TAX
EA5F 4C F3 E7 JMP $E7F3 et on replace le curseur
CALCUL LE DEPLACEMENT sX ou sY
Action : Calcule dans $13, $12 la valeur de (X,A)/R, en fait (X,A)/2^N.
EA62 85 12 STA $12 on place la partie fractionnaire dans $12
EA64 86 13 STX $13 et la partie entiere dans $13
EA66 A6 0C LDX $0C X=N tel que Rayon<2^N
EA68 A5 13 LDA $13 on garde le signe du resultat
EA6A 2A ROL
EA6B 66 13 ROR $13 et on divise par 2^X
EA6D 66 12 ROR $12 dans $13, $12
EA6F CA DEX
EA70 D0 F6 BNE $EA68
EA72 60 RTS
151
COMMANDE FILL
Action : Ecrit HRS1 lignes de HRS2 codes HRS3 a partir des coordonnees
Courantes du curseur. Le code HRS3 peut-etre n'importe quel code.
S'il a sont bit 6 a 1, ce sera des pixels, son bit 7 a 1 ce sera
en inverse video. Si son bit 6 est a 0, ce sera un code de
controle (0-31) ou un autre no defini (32-63).
EA73 A5 4B LDA $4B AY=adresse de la ligne du curseur
EA75 A4 4C LDY $4C
EA77 85 00 STA $00 dans RES
EA79 84 01 STY $01
EA7B A6 4F LDX $4F X=nombre de colonnes
EA7D A4 49 LDY $49 Y= position du curseur
EA7F A5 51 LDA $51
EA81 91 00 STA ($00),Y on ecrit X colonnes
EA83 C8 INY
EA84 CA DEX
EA85 D0 FA BNE $EA81
EA87 A9 28 LDA #$28 on ajoute une ligne
EA89 A0 00 LDY #$00 a l'adresse
EA8B 20 89 CE JSR $CE89
EA8E C6 4D DEC $4D et on fait toutes les lignes
EA90 D0 E9 BNE $EA7B
EA92 60 RTS
COMMANDE SCHAR
Action : Affiche une chaine de caracteres en HIRES par envois successifs
des caracteres de la chaine. Le FB est force a 1, dommageÅc
EA93 85 51 STA $51 on sauve l'adresse de la chaine dans HRS3
EA95 84 52 STY $52
EA97 86 4F STX $4F et sa longueur dans HRS2
EA99 A9 40 LDA #$40 FB=1
EA9B 85 57 STA $57 dans HRSFB
EA9D A0 00 LDY #$00 on indexe le premier caractere
EA9F 84 50 STY $50 dans HRS2+1
EAA1 C4 4F CPY $4F on a fini ?
EAA3 B0 ED BCS $EA92 oui, on sort
EAA5 B1 51 LDA ($51),Y non, on prend un code
EAA7 20 B5 EA JSR $EAB5 on l'envoie
EAAA A4 50 LDY $50 et on indexe le caractere suivant
EAAC C8 INY
EAAD D0 F0 BNE $EA9F
152
COMMANDE CHAR
Action : Affiche a la position du curseur le caractere HRS1 dans la table
HRS2 selon HRSFB. La table 0 represente les caracteres normeaux
et 1 les mosaiques. Le principe est facile a suivre et la routine
banale.
EAAF A5 4D LDA $4D on prend le code dans A
EAB1 0A ASL on sort b7
EAB2 46 4F LSR $4F on met dans C le type de caractere a afficher
EAB4 6A ROR et dans b7 donc A>128 si caractere alterne
EAB5 48 PHA dans la pile
EAB6 A5 46 LDA $46 est-on au dela de la colonne 234 ?
EAB8 C9 EA CMP #$EA
EABA 90 17 BCC $EAD3 non
EABC A6 4A LDX $4A oui, X=HRSX6
EABE A5 47 LDA $47 A=HRSY
EAC0 69 07 ADC #$07 on ajoute a HRSY
EAC2 A8 TAY dans Y
EAC3 E9 BF SBC #$BF -191 (donc on complemente a 199)
EAC5 90 09 BCC $EAD0 si HRSY est bon
EAC7 F0 07 BEQ $EAD0 meme egal
EAC9 C9 08 CMP #$08 est-on a 8 ?
EACB D0 02 BNE $EACF non, ok
EACD A9 00 LDA #$00 oui, alors on met HRSY=0
EACF A8 TAY on remet A dans Y
EAD0 20 F3 E7 JSR $E7F3 on recalcule la position du point
EAD3 68 PLA on prend le code
EAD4 20 31 FF JSR $FF31 on calcule son adresse dans RESB
EAD7 A0 00 LDY #$00 on met 0 dans RES
EAD9 84 00 STY $00
EADB A5 49 LDA $49 on sauve HRSX6 et HRSX40 dans la pile
EADD 48 PHA
EADE A5 4A LDA $4A
EAE0 48 PHA
EAE1 B1 02 LDA ($02),Y on lit la ligne courante du caractere
EAE3 0A ASL on elimine b7 et b6 qui n'ont pas d'utilite
EAE4 0A ASL
EAE5 F0 0C BEQ $EAF3 si le code est 0, on passe
EAE7 48 PHA on sauve la ligne
EAE8 10 03 BPL $EAED si le point est allume
EAEA 20 9C E7 JSR $E79C on l'affiche sans gerer le pattern
EAED 20 D9 E7 JSR $E7D9 puis on deplace le curseur a droite
EAF0 68 PLA on prend le code
EAF1 D0 F1 BNE $EAE4 si ce n'est pas 0, on boucle
EAF3 20 C1 E7 JSR $E7C1 on descend le curseur d'une ligne
EAF6 68 PLA on recupere HRSX6 et HRSX40
EAF7 85 4A STA $4A
EAF9 68 PLA
EAFA 85 49 STA $49
EAFC A4 00 LDY $00 on ajoute une ligne de faite
153
EAFE C8 INY
EAFF C0 08 CPY #$08
EB01 D0 D6 BNE $EAD9 et on fait les 8
EB03 A5 46 LDA $46 on ajoute 6 (5+1 car C=1)
EB05 69 05 ADC #$05 a HRSX
EB07 AA TAX dans X
EB08 A4 47 LDY $47 HRSY dans Y
EB0A 4C F3 E7 JMP $E7F3 et on positionne le curseur en X,Y
ROUTINE PLAY
Action : Ouvre les canaux musicaux selon HRS1, canaux de bruits selon
HRS2, avec l'enveloppe HRS3, de periode HRS4*32 É s.
EB0D A5 4F LDA $4F on prend la definition d'autorisation des
EB0F 0A ASL canaux de bruit
EB10 0A ASL dans b5b4b3
EB11 0A ASL
EB12 05 4D ORA $4D et les canaux musicaux dans b2b1b0
EB14 49 3F EOR #$3F on inverse la tout
EB16 AA TAX dans X
EB17 A9 07 LDA #$07 registre 7 (autorisation)
EB19 20 1A DA JSR $DA1A et on ouvre les canaux demandes
EB1C 06 53 ASL $53 on multiplie la periode par 2
EB1E 26 54 ROL $54
EB20 A6 53 LDX $53 on envoie la periode poids faible
EB22 A9 0B LDA #$0B
EB24 20 1A DA JSR $DA1A
EB27 A6 54 LDX $54
EB29 A9 0C LDA #$0C et poids fort
EB2B 20 1A DA JSR $DA1A
EB2E A4 51 LDY $51 on prend la numero de l'enveloppe demandee
EB30 BE 38 EB LDX $EB38,Y on lit l'enveloppe PSG correspondante
EB33 A9 0D LDA #$0D et on valide l'enveloppe
EB35 4C 1A DA JMP $DA1A
EB38 00 0B BYT 00,11,04,08,10,11,12,13 enveloppes PLAY de 0 a 7
PERIODE DES NOTES DE L'OCTAVE 0
Remarque : Les nombres sont des periodes en 16' de É s. donc pour avoir la
frequence de la note correspondante, on fait, si n'est le
nombre :
F=1/((n*16)*10^-6) c'est-a-dire F=1000000/16n
Attention : Les notes stockees ici sont a multiplier par 2 pour
obtenir les periodes de l'octave 0.
154
Note frequence octave 3 octave 7 (maxi)
EB40 BYT $0000 blanc | 00,000 Hertz| 000,00 Hertz| 0000,0 Hertz
EB42 BYT $0EEE DO | 16,352 " | 261,64 " | 4186,2 "
EB44 BYT $0E16 DO# | 17,352 " | 277,31 " | 4437 "
EB46 BYT $0D4C RE | 18,360 " | 293,77 " | 4700,3 "
EB48 BYT $0C8E RE# | 19,446 " | 311,13 " | 4978,2 "
EB4A BYT $0BD8 MI | 20,613 " | 329,81 " | 5277 "
EB4C BYT $0B2E FA | 21,837 " | 349,40 " | 5590,5 "
EB4E BYT $0A8E FA# | 23,131 " | 370,09 " | 5921,5 "
EB50 BYT $09F6 SOL | 24,509 " | 392,15 " | 6274,5 "
EB52 BYT $0966 SOL# | 25,976 " | 415,62 " | 6650 "
EB54 BYT $08E0 LA | 27,508 " | 440,14 " | 7042,2 "
EB56 BYT $0860 LA# | 29,151 " | 466,41 " | 7462,7 "
EB58 BYT $ 07E8 SI | 30,879 " | 494,07 " | 7905,1 "
COMMANDE MUSIC
Principe : On lit la note correspondant au troisieme parametre, puis on le
divise par 2^octave pour obtenir la periode juste. Puis on
replace la periode trouvee et on execute SOUND. Les parametres
de MUSIC sont dans HRSX, comme en BASIC.
EB5A A4 4F LDY $4F on prend l'octave dans X
EB5C A5 51 LDA $51 la note dans A
EB5E 0A ASL *2 car 2 octets par note
EB5F AA TAX dans X
EB60 BD 40 EB LDA $EB40,X on lit la note
EB63 85 4F STA $4F
EB65 BD 41 EB LDA $EB41,X et on multiplie par 2^(octave+1)
EB68 4A LSR (+1 car les notes sont stockees pour octave -1)
EB69 66 4F ROR $4F
EB6B 88 DEY
EB6C 10 FA BPL $EB68
EB6E 85 50 STA $50 $4F-$50 contient la note
EB70 A6 53 LDX $53 on lit le volume dans X
EB72 BYT $2C et on passe l'instruction suivante
COMMANDE SOUND
Principe : On envoie d'abord le volume, ou 16 si volume est nul. Ensuite
on teste si la periode demandee est musicale ou faite de bruit.
On ajuste ensuite les periodes musicales (16 bits) ou bruit (8
bits). Les parametres sont dans HRSX comme en HYPER-BASIC.
155
EB73 A6 51 LDX $51 on lit le volume dans X
EB75 8A TXA on met le volume dans A
EB76 D0 02 BNE $EB7A volume <>0, on l'envoie
EB78 A2 10 LDX #$10 on indique volume gere par l'enveloppe
EB7A A4 4D LDY $4D on prend le canal
EB7C 88 DEY -1
EB7D 98 TYA dans A
EB7E C9 03 CMP #$03 >3 ?
EB80 90 02 BCC $EB84 non
EB82 E9 03 SBC #$03 oui, on enleve 3
EB84 09 08 ORA #$08 et on indique registres de volume (8,9,10)
EB86 20 1A DA JSR $DA1A et on ecrit le registre de volume
EB89 C0 03 CPY #$03 canal >=3 ?
EB8B B0 0C BCS $EB99 oui
EB8D 98 TYA on envoie les frequences dans le registre du canal
EB8E 0A ASL
EB8F A8 TAY
EB90 69 01 ADC #$01 +1
EB92 A6 50 LDX $50 on envoie le poids fort
EB94 20 1A DA JSR $DA1A
EB97 98 TYA registre poids faible dans A
EB98 BYT $2C et on saute l'instruction suivante
EB99 A9 06 LDA #$06 A=6 pour periode de bruit blanc
EB9B A6 4F LDX $4F X=poids faible de la periode
EB9D 4C 1A DA JMP $DA1A on envoie
DONNEES POUR SONS PREPROGRAMMES
PING
EBA0 BYT $18,0,0,0,0,0,0 soit 2604 Hertz sur canal musical 1
EBA7 BYT $3E,$10,0,0,0 soit canal 1 musical, volume par enveloppe
EBAC BYT 0,$0F,0 soit periode 61,5 ms et enveloppe 0
SHOOT
EBAF BYT 0,0,0,0,0,0 pas de canaux musicaux
EBB4 BYT $0F,7,$10,$10,$10soit 3 canaux en bruit, volume par enveloppe
EBB9 BYT 0,8,0 soit Periode 30 ms et enveloppe 0
EXPLODE
EBBC BYT 0,0,0,0,0,0 pas de canaux musicaux
EBC1 BYT $1F,07 periode bruit identique a SHOOT ! (4 bits)
EBC3 BYT $10,$10,$10 tous canaux en bruits, volume par enveloppe
EBC6 BYT 0;$18;0 periode 98 ms et enveloppe 0
156
DONNEES ZAP
EBCA BYT 0,0,0,0,0,0,0 soit rien pour l'instant
EBD1 BYT $3E,$0F soit canal 1musical volume maxi
EBD3 BYT 0,0,0,0,0,0 soit pas d'enveloppe
ROUTINE PING
EBD9 A2 A0 LDX #$A0 on indexe PING
EBDB A0 EB LDY #$EB
EBDD D0 0A BNE $EBE9 et on envoie
ROUTINE SHOOT
EBDF A2 AE LDX #$AE on indexe SHOOT
EBE1 A0 EB LDY #$EB
EBE3 D0 04 BNE $EBE9 et on envoie
ROUTINE EXPLODE
EBE5 A2 BC LDX #$BC on indexe EXPLODE
EBE7 A0 EB LDY #$EB
EBE9 4C E7 D9 JMP $D9E7 et on envoie
ROUTINE ZAP
Principe : On augmente la periode du canal 1 de 0 a 1800 É s de 16 en 16 É s
par intervalle d'une milliseconde.
EBEC A2 CA LDX #$CA on envoie les donnees de base
EBEE A0 EB LDY #$EB
EBF0 20 E7 D9 JSR $D9E7 au PSG
EBF3 A9 00 LDA #$00
EBF5 AA TAX 0 dans X
EBF6 8A TXA
EBF7 48 PHA dans la pile
EBF8 A9 00 LDA #$00 on envoie X dans le canal 0
EBFA 20 1A DA JSR $DA1A
EBFD A2 00 LDX #$00 on attend pres d'1 ms
EBFF CA DEX
EC00 D0 FD BNE $EBFF
EC02 68 PLA
EC03 AA TAX
EC04 E8 INX
EC05 E0 70 CPX #$70 et cela 112 fois, donc periode croissante
EC07 D0 ED BNE $EBF6
157

EC40 29 7F AND #$7F on enlËve b7
EC42 48 PHA dans la pile
EC43 A9 01 LDA #$01 en envoie un 01
EC45 20 49 EC JSR $EC49
EC48 68 PLA
EC49 2C 49 EC BIT $EC49 N=0, V=0
EC4C 4C 12 DB JMP $DB12 on envoie le code dans A
ENVOIE A EN SORTIE SERIE AVEC CHECK
EC4F 86 0C STX $0C on sauve X et Y
EC51 84 0D STY $0D
EC53 48 PHA et A
EC54 24 5B BIT $5B b7 de $5B ‡ 1 ?
EC56 10 06 BPL $EC5E non
EC58 20 21 EC JSR $EC21 on envoie A au MINITEL
EC5B 4C 61 EC JMP $EC61 et on passe
EC5E 20 1B EC JSR $EC1B on envoie simplement A au buffer
EC61 68 PLA on reprend le code
EC62 45 0E EOR $0E on inverse selon $0E
EC64 85 0E STA $0E et on place dans $0E pour contrÙle (CHECK)
EC66 A6 0C LDX $0C on rÈcupËre X et Y
EC68 A4 0D LDY $0D
EC6A 60 RTS
LIT UN CODE SUR LA RS232
Action : lit un code sur la RS232 en gÈrant le CTRL-C. Si le code est un
code de contrÙle, renvoie le caractËre suivant avec son bit 7 ‡
1.
Dans le cas ou b7 ou b6 de $5B est ‡ 1, on renvoie le code
simplement.
Si b7=0, on lit le code par la $EC10
Si b7=1, on lit le code par la $C518
Ce qui revient au mÍme, allez comprendreÖ
EC6B 86 0C STX $0C on sauve X et Y
EC6D 84 0D STY $0D
EC6F 0E 7E 02 ASL $027E CTRL-C pressÈ ?
EC72 90 03 BCC $EC77 non, on saute
EC74 68 PLA oui, on dÈpile le retour ‡ l'appelant
EC75 68 PLA
EC76 60 RTS et on retourne ‡ l'appelant dans l'appelant
EC77 24 5B BIT $5B b7 de $5B ‡ 1 ?
EC79 30 10 BMI $EC8B oui
EC7B 20 10 EC JSR $EC10 non, on lit un code venant de la RS232
EC7E B0 EF BCS $EC6F si pas de code lu, on saute au CTRL-C
EC80 48 PHA on sauve le code
EC81 45 0E EOR $0E on ajuste le CHECK
EC83 85 0E STA $0E
159
EC85 68 PLA on prend le code
EC86 A6 0C LDX $0C et on restaure X et Y
EC88 A4 0D LDY $0D
EC8A 60 RTS
EC8B 20 B4 EC JSR $ECB4 on lit un code sur la RS232
EC8E B0 DF BCS $EC6F pas de code, on boucle sur CTRL-C
EC90 24 5B BIT $5B b6 de $5B ‡ 1 ?
EC92 70 EC BVS $EC80 oui, on sort
EC94 C9 20 CMP #$20 code de contrÙle ?
EC96 B0 E8 BCS $EC80 non, on sort
EC98 48 PHA on sauve le code de contrÙle
EC99 20 B9 EC JSR $ECB9 on attend un code RS232
EC9C AA TAX dans X
EC9D 68 PLA
EC9E A8 TAY on prend le code de contrÙle dans Y
EC9F 8A TXA et son suivant dans A
ECA0 C0 01 CPY #$01 le contrÙle est 01 ?
ECA2 D0 04 BNE $ECA8 non
ECA4 09 80 ORA #$80 oui, on force b7 ‡ 1
ECA6 30 D8 BMI $EC80 et on saute
ECA8 C9 40 CMP #$40 code suivant <64 ?
ECAA B0 04 BCS $ECB0 non
ECAC E9 1F SBC #$1F oui, on retir 31
ECAE B0 D0 BCS $EC80 inconditionnel
ECB0 69 3F ADC #$3F on ajoute 63
ECB2 90 CC BCC $EC80 inconditionnel
LIT UN CODE EN ENTREE SERIE
ECB4 A2 0C LDX #$0C indexe buffer sÈrie entrÈe
ECB6 4C 18 C5 JMP $C518 lit le code dans le buffer
ATTEND UN CODE DANS LE BUFFER ENTREE SERIE
ECB9 20 B4 EC JSR $ECB4 on lit le code
ECBC B0 FB BCS $ECB9 jusqu'‡ ce que la lecture soit faite
ECBE 60 RTS
ECBF 38 SEC C=1
ECC0 BYT $24 saute le CLC
ECC1 18 CLC C=0
ECC2 A9 80 LDA #$80 A=128, N=1
ECC4 4C 5D DB JMP $DB5D ferme ou ouvre l'entrÈe RS232
ECC7 38 SEC C=1
ECC8 BYT $24 saute le CLC
ECC9 18 CLC C=0
ECCA A9 80 LDA #$80 N=1
ECCC 4C 79 DB JMP $DB79 ferme (C=1) ou ouvre la sortie RS232
160
ECCF 38 SEC C=1
ECD0 BYT $24 saute le CLC
ECD1 18 CLC C=0
ECD2 A9 80 LDA #$80 N=1
ECD4 4C F7 DA JMP $DAF7 ferme ou ouvre l'entrÈe MINITEL
ECD7 38 SEC C=1
ECD8 BYT $24 saute le CLC
ECD9 18 CLC C=0
ECDA A9 80 LDA #$80 N=1
ECDC 4C 12 DB JMP $DB12 ferme ou ouvre la sortie MINITEL
CALCUL LA TAILLE D'UN FICHIER
ECDF 38 SEC
ECE0 AD 2F 05 LDA $052F on calcule dans LOSALO
ECE3 ED 2D 05 SBC $052D la diffÈrence entre les adresses
ECE6 8D 2A 05 STA $052A de dÈbut et de fin du fichier :
ECE9 AD 30 05 LDA $0530 FISALO-DESALO
ECEC ED 2E 05 SBC $052E
ECEF 8D 2B 05 STA $052B
ECF2 AD 2D 05 LDA $052D
ECF5 AC 2E 05 LDY $052E
ECF8 85 00 STA $00 on met dans RES l'adresse de dÈbut du fichier
ECFA 84 01 STY $01
ECFC 60 RTS
ENVOIE L'ENTETE SERIE D'UN FICHIER
Principe : l'entÍte d'un fichier sÈrie est comme suit :
50 fois SYN pour synchro
1 fois 24 pour fin de synchro
12 caractËres du nom
0 fin du nom
7 octets pour type, dÈbut, fin et exÈcution du programme
1 octet de contrÙle pour ce qui prÈcËde.
ECFD A2 32 LDX #$32 on envoie 50 fois l'octet de synchro
ECFF A9 16 LDA #$16 16 (SYN)
ED01 20 4F EC JSR $EC4F
ED04 CA DEX
ED05 D0 F8 BNE $ECFF
ED07 A9 24 LDA #$24 puis un octet 24
ED09 20 4F EC JSR $EC4F
ED0C A9 00 LDA #$00
ED0E 85 0E STA $0E
ED10 A2 00 LDX #$00
ED12 BD 18 05 LDA $0518,X puis le nom du fichier
161
ED15 20 4F EC JSR $EC4F
ED18 E8 INX
ED19 E0 0C CPX #$0C (12 caractËres)
ED1B D0 F5 BNE $ED12
ED1D A9 00 LDA #$00 puis un 0 pour finir le nom
ED1F 20 4F EC JSR $EC4F
ED22 A2 00 LDX #$00 puis type et adresses du fichier
ED24 BD 2C 05 LDA $052C,X
ED27 20 4F EC JSR $EC4F
ED2A E8 INX
ED2B E0 07 CPX #$07 1+2+2+2 font 7
ED2D D0 F5 BNE $ED24
ED2F A5 0E LDA $0E puis 1 octet de contrÙle
ED31 4C 4F EC JMP $EC4F
LIT L'ENTETE D'UN FICHIER
Principe : DËs qu'on est synchronisÈ avec l'entÍte et qu'on est sur qu'il
s'agit bien d'un entÍte TELESTRAT, on lit l'entÍte comme on l'a
sauvÈ puis on affiche le nom. Le caractËre bizarre qui suit le
nom n'est autre que le code de contrÙle (CHECK).
ED34 20 6B EC JSR $EC6B on lit un code RS232
ED37 C9 16 CMP #$16 est-ce SYN ?
ED39 D0 F9 BNE $ED34 non, on boucle
ED3B A2 0A LDX #$0A on va lire 10 SYN
ED3D 20 6B EC JSR $EC6B on lit
ED40 C9 16 CMP #$16 SYN ?
ED42 D0 F0 BNE $ED34 non, on reprend la synchro au dÈbut
ED44 CA DEX
ED45 D0 F6 BNE $ED3D oui, on lit 10
ED47 20 6B EC JSR $EC6B on lit le code
ED4A C9 16 CMP #$16 fin de synchro
ED4C F0 F9 BEQ $ED47 non
ED4E C9 24 CMP #$24 oui est-ce 24 ?
ED50 D0 E2 BNE $ED34 non, la synchro est rate, on repart ‡ 0
ED52 A9 00 LDA #$00 on met le CHECK
ED54 85 0E STA $0E ‡ 0
ED56 20 6B EC JSR $EC6B on lit un code
ED59 AA TAX
ED5A F0 06 BEQ $ED62 0, on saute
ED5C 20 B5 DB JSR $DBB5 on affiche le caractËre du nom
ED5F 4C 56 ED JMP $ED56 et on affiche tout le nom
ED62 A2 00 LDX #$00
ED64 20 6B EC JSR $EC6B on lit la dÈfinition du fichier
ED67 9D 2C 05 STA $052C,X
ED6A E8 INX
ED6B E0 07 CPX #$07 (7 octets)
ED6D D0 F5 BNE $ED64
ED6F 20 6B EC JSR $EC6B on lit l'octet de CHECK
ED72 09 30 ORA #$30 on force b5b4 ‡ 11
ED74 4C B5 DB JMP $DBB5 et on l'affiche
162
COMMANDE CONSOLE
Action : transforme le TELESTRAT en terminal sÈrie. Les codes tapÈs au
clavier sont transmis ‡ la RS232 et les codes reÁus via la RS232
sont affichÈs ‡ l'Ècran. On sort par CTRL-C.
ED77 20 C1 EC JSR $ECC1 on ouvre le buffer RS232 entrÈe
ED7A 20 C9 EC JSR $ECC9 on ouvre le buffer RS232 sortie
ED7D 20 10 EC JSR $EC10 on lit un code en entrÈe
ED80 B0 03 BCS $ED85 si pas de code on saute
ED82 20 B5 DB JSR $DBB5 on affiche le code ‡ l'Ècran
ED85 20 CF C7 JSR $C7CF on lit un code sur canal 0
ED88 B0 F3 BCS $ED7D pas de code, on saute
ED8A C9 03 CMP #$03 CTRL-C ?
ED8C F0 06 BEQ $ED94 oui
ED8E 20 1B EC JSR $EC1B non, on Ècrit le code en sortie RS232
ED91 4C 7D ED JMP $ED7D et on boucle
ED94 20 BF EC JSR $ECBF on ferme l'entrÈe RS232
ED97 4C C7 EC JMP $ECC7 et la sortie RS232
COMMANDE SDUMP
Principe : Envoie ‡ l'Ècran tous les codes lus sur l'entrÈe sÈrie. Les
codes de contrÙle sont affichÈs en hexa ‡ l'encre rouge, les
autres sous leur forme ASCII. CTRL-C arrÍte tout cela.
ED9A 20 C1 EC JSR $ECC1 on ouvre le buffer RS232 entrÈe
ED9D 0E 7E 02 ASL $027E on teste si CTRL-C
EDA0 B0 25 BCS $EDC7 oui, on sort
EDA2 20 10 EC JSR $EC10 on lit le code
EDA5 B0 F6 BCS $ED9D pas de code
EDA7 AA TAX
EDA8 30 04 BMI $EDAE b7=1, on saute
EDAA C9 20 CMP #$20 code de contrÙle ?
EDAC B0 13 BCS $EDC1 non
EDAE 48 PHA on sauve le code
EDAF A9 81 LDA #$81 on envoie encre rouge
EDB1 20 B5 DB JSR $DBB5
EDB4 68 PLA
EDB5 20 54 CE JSR $CE54 on convertit le code en hexa
EDB8 20 B5 DB JSR $DBB5 et on affiche
EDBB 98 TYA
EDBC 20 B5 DB JSR $DBB5
EDBF A9 87 LDA #$87 encre blanche
EDC1 20 B5 DB JSR $DBB5
EDC4 4C 9D ED JMP $ED9D et on boucle
EDC7 4C BF EC JMP $ECBF on ferme le buffer RS232 entrÈe
163
COMMANDE SSAVE
Remarque : C=1 en entrÈe pour SSAVE, 0 sinon.
EDCA 66 5B ROR $5B on met 0 dans b7 de $5B
EDCC 46 5B LSR $5B sans toucher ‡ l'indicateur d'entÍte
EDCE 20 C9 EC JSR $ECC9 on ouvre le buffer RS232 sortie
EDD1 20 0A EE JSR $EE0A on envoie le programme
EDD4 4C C7 EC JMP $ECC7 et on ferme le buffer RS232 sortie
COMMANDE MSAVE
Remarque : C=1 en entrÈe pour MSAVE, 0 sinon.
EDD7 66 5B ROR $5B on met 1 dans b7 de $5B
EDD9 38 SEC sans toucher ‡ l'indicateur d'entÍte
EDDA 66 5B ROR $5B
EDDC 20 D9 EC JSR $ECD9
EDDF 20 0A EE JSR $EE0A
EDE2 4C D7 EC JMP $ECD7
COMMANDE SLOAD
Remarque : C=1 en entrÈe pour SLOADA, 0 sinon.
EDE5 66 5B ROR $5B b7 de $5B ‡ 0 pour envoi RS232
EDE7 46 5B LSR $5B
EDE9 A9 40 LDA #$40 bug corrigÈ par rapport au TELEMON V2.3
EDEB 8D 0E 03 STA $030E on interdit les IRQ par T1
EDEE 20 C1 EC JSR $ECC1 on ouvre la sortie RS232
EDF1 20 56 EE JSR $EE56 on envoie le programme
EDF4 A9 C0 LDA #$C0 et on rÈtablit les IRQ
EDF6 8D 0E 03 STA $030E
EDF9 4C BF EC JMP $ECBF on ferme la sortie RS232
COMMANDE MLOAD
EDFC 66 5B ROR $5B b7 de $5B ‡ 1 pour envoi MINITEL
EDFE 38 SEC
EDFF 66 5B ROR $5B
EE01 20 D1 EC JSR $ECD1 on ouvre la sortie MINITEL
EE04 20 56 EE JSR $EE56 on envoie le programme
EE07 4C CF EC JMP $ECCF et on ferme la sortie MINITEL
164
SAUVE UN FICHIER RS232/MINITEL
Principe: En entrÈe, $5B ‡ son bit 7 selon le rÈcepteur (0 pour RS232 et 1
pour minitel) et son bit 6 ‡ 1 si on envoie sans entÍte.
La diffÈrence RS232/MINITEL est faite telle qu'il se passe une
1/2 seconde (normalement !) tous les 256 octets. En fait ce
temps est souvent rallongÈ ‡ cause des interruptions croisÈes
qui ralentissent la cadence de dÈcompte des timers.
EE0A 24 5B BIT $5B entÍte ‡ envoyer
EE0C 70 03 BVS $EE11 non
EE0E 20 FD EC JSR $ECFD on envoie l'entÍte
EE11 20 DF EC JSR $ECDF on calcule la taille du programme
EE14 A9 00 LDA #$00 on met 0
EE16 85 0E STA $0E dans le CHECK
EE18 AD 2A 05 LDA $052A on envoie la partie hors-page (comme dÈcalage)
EE1B F0 12 BEQ $EE2F si fin, on saute
EE1D A0 00 LDY #$00
EE1F B1 00 LDA ($00),Y on lit l'octet
EE21 20 4F EC JSR $EC4F on l'envoie en sortie sÈrie
EE24 CE 2A 05 DEC $052A on dÈcompte les octets
EE27 E6 00 INC $00 on ajuste l'adresse de lecture
EE29 D0 ED BNE $EE18
EE2B E6 01 INC $01
EE2D D0 E9 BNE $EE18 inconditionnel
EE2F AD 2B 05 LDA $052B on envoie page par page
EE32 F0 1D BEQ $EE51
EE34 A0 00 LDY #$00
EE36 B1 00 LDA ($00),Y on lit le code
EE38 20 4F EC JSR $EC4F on l'envoie
EE3B C8 INY 256 fois
EE3C D0 F8 BNE $EE36
EE3E CE 2B 05 DEC $052B on indique une page de moins
EE41 E6 01 INC $01 on ajoute une page ‡ l'adresse de lecture
EE43 24 5B BIT $5B mode minitel ?
EE45 10 E8 BPL $EE2F non
EE47 A9 30 LDA #$30 oui, on indique 48 dixiËmes
EE49 85 44 STA $44 dans TIMEUD
EE4B A5 44 LDA $44
EE4D D0 FC BNE $EE4B et on attend le retour ‡ 0 (donc 0,5 secondes)
EE4F F0 DE BEQ $EE2F et on boucle
EE51 A5 0E LDA $0E puis on envoie le code de contrÙle
EE53 4C 4F EC JMP $EC4F
LIT UN FICHIER RS232/MINITEL
Principe: Selon $5B (voir plus haut) on lit ou non l'entÍte et on charge
le fichier. On ne vÈrifie pas que l'entÍte est bien chargÈÖ
dommage! L'octet de CHECK du programme est ensuite affichÈ. Il
suffit de le comparer avec $0E pour savoir si le programme s'est
bien chargÈ.
165
EE56 24 5B BIT $5B entÍte ?
EE58 70 03 BVS $EE5D non
EE5A 20 34 ED JSR $ED34 oui, on lit l'entÍte
EE5D 20 DF EC JSR $ECDF on calcule la taille du fichier
EE60 24 5B BIT $5B entÍte ?
EE62 50 08 BVC $EE6C oui
EE64 A9 FF LDA #$FF non, on indique 64 Ko
EE66 8D 2A 05 STA $052A ‡ lire (sans valeur puisqu'on arrÍte de charger
EE69 8D 2B 05 STA $052B par CTRL-C)
EE6C A0 00 LDY #$00 0 dans CHECK
EE6E 84 0E STY $0E (somme de contrÙle)
EE70 AD 2A 05 LDA $052A on lit les octets hors-page
EE73 F0 11 BEQ $EE86 fini
EE75 20 6B EC JSR $EC6B on lit un code venant de la RS232
EE78 91 00 STA ($00),Y en mÈmoire
EE7A CE 2A 05 DEC $052A on indique un code lu
EE7D E6 00 INC $00 on ajuste l'adresse mÈmoire
EE7F D0 EF BNE $EE70
EE81 E6 01 INC $01
EE83 4C 70 EE JMP $EE70 et on boucle
EE86 AD 2B 05 LDA $052B puis les pages
EE89 F0 12 BEQ $EE9D fini
EE8B A0 00 LDY #$00
EE8D 20 6B EC JSR $EC6B on lit un code
EE90 91 00 STA ($00),Y en mÈmoire
EE92 C8 INY et ainsi pour 256 octets
EE93 D0 F8 BNE $EE8D
EE95 E6 01 INC $01 on ajoute une page en mÈmoire
EE97 CE 2B 05 DEC $052B une page lue de plus
EE9A 4C 86 EE JMP $EE86 et on boucle
EE9D 20 6B EC JSR $EC6B on lit le CHECK
EEA0 09 30 ORA #$30 force b5b4 ‡ 11
EEA2 4C B5 DB JMP $DBB5 et on l'affiche
COMMANDE RING
Action: Attend une sonnerie du tÈlÈphone. C=1 en sortie si la sonnerie
Ètait en route lors de l'appel ‡ la routine, 0 sinon.
EEA5 A9 00 LDA #$00 on met 0 dans valeur joystick
EEA7 8D 8C 02 STA $028C car le joystick parasite la ligne (!)
EEAA A9 10 LDA #$10 on prend %00010000 pour test V2IFR
EEAC 2C 2D 03 BIT $032D transition CB1 ?
EEAF D0 32 BNE $EEE3 non, on passe
EEB1 38 SEC oui C=1
EEB2 60 RTS on sort
166
DETECTE SONNERIE TELEPHONIQUE
Action: Attend pendant 65 ms une transition par CB1 du VIA2. Si le timer
arrive ‡ 0 sans transition, A=0 et C=1. Si une transition est
dÈtectÈe, alors A=1 et C=1 si la transition ‡ eu lieu dans les 28
ms, A=1 et C=1 si la transition n'‡ pas eu lieu dans les 28 ms A=1
et C=0 sinon.
EEB3 A9 FF LDA #$FF on met 65536
EEB5 8D 28 03 STA $0328 dans V2T2
EEB8 8D 29 03 STA $0329
EEBB AD 29 03 LDA $0329 on lit V2T2H
EEBE C9 C5 CMP #$C5 = $C5 ? (donc 15 ms passes ?)
EEC0 B0 F9 BCS $EEBB au dessus
EEC2 2C 20 03 BIT $0320 ?
EEC5 A9 20 LDA #$20 on isole l'Ètat VIA2
EEC7 2D 2D 03 AND $032D de T2
EECA D0 13 BNE $EEDF T2=0 on passe
EECC A9 10 LDA #$10 on isole CB1
EECE 2D 2D 03 AND $032D CB1 ‡ 1 ?
EED1 F0 F2 BEQ $EEC5 non
EED3 AD 29 03 LDA $0329 oui, on lit V2T2H
EED6 C9 AD CMP #$AD = $AD (donc 13 ms passes ?)
EED8 90 07 BCC $EEE1 oui, A>0, C=1 et on sort
EEDA C9 B5 CMP #$B5 non, 7 ms passes ? (oui:C=0 sinon C=1)
EEDC A9 01 LDA #$01 A=1
EEDE 60 RTS
EEDF A9 00 LDA #$00 A=0
EEE1 38 SEC C=1
EEE2 60 RTS on sort
DETECTION DE SONNERIE RING (suite)
EEE3 78 SEI pas d'interruption
EEE4 A2 04 LDX #$04 on teste 4 fois la sonnerie
EEE6 20 B3 EE JSR $EEB3
EEE9 CA DEX
EEEA D0 FA BNE $EEE6
EEEC 20 B3 EE JSR $EEB3 on teste la sonnerie
EEEF F0 0A BEQ $EEFB pas de sonnerie
EEF1 B0 F9 BCS $EEEC C=1, transition rapide, X=0
EEF3 E8 INX
EEF4 4C EC EE JMP $EEEC
EEF7 58 CLI on rÈtablit les IRQ
EEF8 4C AA EE JMP $EEAA et on boucle sur le test CB2
EEFB E0 06 CPX #$06 X=6 ?
EEFD 90 F8 BCC $EEF7 en dessous, on boucle
EEFF 20 B3 EE JSR $EEB3 on lit CB1
EF02 B0 FB BCS $EEFF on boucle sur la dÈtection
EF04 A0 1E LDY #$1E Y=30
167
EF06 A2 00 LDX #$00
EF08 20 B3 EE JSR $EEB3 on dÈtecte la sonnerie
EF0B 90 01 BCC $EF0E pas dÈtectÈe
EF0D E8 INX dÈtectÈe, on compte une fois de plus
EF0E 88 DEY
EF0F D0 F7 BNE $EF08 on boucle
EF11 E0 0F CPX #$0F on ‡ dÈtectÈ 15 fois ?
EF13 B0 E2 BCS $EEF7 plus, on repart
EF15 58 CLI oui, on rÈtablit les IRQ (encore ?)
EF16 A9 0A LDA #$0A on attend 0,5 secondes
EF18 85 44 STA $44
EF1A A5 44 LDA $44
EF1C D0 FC BNE $EF1A
EF1E 18 CLC C=0
EF1F 60 RTS et on sort
PRISE DE LIGNE
Action: Retourne le modem du Minitel et prend la ligneÖ
EF20 20 D9 EC JSR $ECD9 ouvre la sortie MINITEL
EF23 A9 6F LDA #$6F envoie ESC/39/6F
EF25 20 30 EF JSR $EF30 soit PRO1 OPPO (retournement)
EF28 A9 68 LDA #$68 ESC/39/68
EF2A 20 30 EF JSR $EF30 soit PRO1 CONNEXION (prise de ligne)
EF2D 4C D7 EC JMP $ECD7 et ferme la sortie MINITEL
ENVOIE UNE SEQUENCE PRO1 AU MINITEL
EF30 48 PHA sauve le code XX de PRO1 XX
EF31 A9 1B LDA #$1B envoie ESC
EF33 20 49 EC JSR $EC49
EF36 A9 39 LDA #$39 et 39 au minitel
EF38 20 49 EC JSR $EC49 (ESC/39 = PRO1)
EF3B 68 PLA
EF3C 4C 49 EC JMP $EC49 et la donnÈe
LIBERE LA LIGNE
EF3F 20 D9 EC JSR $ECD9 ouvre la sortie minitel
EF42 A9 67 LDA #$67 envoie PRO1 DECONNEXION
EF44 20 30 EF JSR $EF30
EF47 4C D7 EC JMP $ECD7 et ferme la sortie minitel
168
COMMANDE WCXFIN
Action: Attend que le correspondant frappe CONNEXION/FIN. S'il ne l'a pas
fait dans les 25 secondes, retourne C=1. Sinon, C=0.
EF4A 20 D1 EC JSR $ECD1 ouvre l'entrÈe minitel
EF4D A9 FA LDA #$FA attend 1 seconde
EF4F 85 44 STA $44
EF51 A5 44 LDA $44
EF53 C9 F0 CMP #$F0
EF55 D0 FA BNE $EF51
EF57 A2 0C LDX #$0C X=12 (entrÈe sÈrie)
EF59 20 0C C5 JSR $C50C vide le buffer minitel
EF5C A5 44 LDA $44 on avait 25 secondes
EF5E D0 05 BNE $EF65 le temps n'est pas ÈcoulÈ
EF60 20 CF EC JSR $ECCF 25 secondes ÈcoulÈes
EF63 38 SEC C=1, entrÈe minitel fermÈe
EF64 60 RTS
EF65 20 B4 EC JSR $ECB4 on lit un code minitel
EF68 B0 F2 BCS $EF5C pas de code
EF6A C9 13 CMP #$13 est-ce SEP ?
EF6C D0 EE BNE $EF5C non
EF6E 20 B9 EC JSR $ECB9 oui, on lit le deuxiËme
EF71 C9 53 CMP #$53 est 53 ? (SEP/53=connexion/fin)
EF73 D0 E7 BNE $EF5C non
EF75 20 CF EC JSR $ECCF oui, on ferme l'entrÈe minitel
EF78 18 CLC et C=0
EF79 60 RTS
COMMANDE MOUT
EF7A 48 PHA sauve la donnÈe
EF7B 20 D9 EC JSR $ECD9 ouvre le minitel en sortie
EF7E 68 PLA
EF7F 20 49 EC JSR $EC49 envoie le code
EF82 4C D7 EC JMP $ECD7 ferme le minitel en sortie
COMMANDE SOUT
EF85 48 PHA sauve la donnÈe
EF86 20 C9 EC JSR $ECC9 ouvre la RS232 en sortie
EF89 68 PLA
EF8A 20 1B EC JSR $EC1B envoie la donnÈe
EF8D 4C C7 EC JMP $ECC7 ferme la RS232 en sortie
AJOUTE 0,5 A ACC1
EF90 A9 E4 LDA #$E4 indexe 1/2
EF92 A0 F5 LDY #$F5
EF94 4C AF EF JMP $EFAF fait (AY)+ACC1
EF97 60 RTS ben voyons ! le EF79 Ètait trop loin ?
169
(AY)-ACC1
EF98 20 EC F1 JSR $F1EC on met (AY) dans ACC2
ACC2-ACC1
EF9B A5 65 LDA $65 on complÈment le signe de ACC1
EF9D 49 FF EOR #$FF
EF9F 85 65 STA $65
EFA1 45 6D EOR $6D on plaque ACC2S
EFA3 85 6E STA $6E et on stocke le produit des signes (ACCPS)
EFA5 A5 60 LDA $60 on positionne A et P selon ACC1E
EFA7 4C B2 EF JMP $EFB2 et on additionne
JUSTIFIER LA MANTISSE SELON A
EFAA 20 E5 F0 JSR $F0E5 on justifie
EFAD 90 3F BCC $EFEE inconditionnel
(AY)+ACC1
EFAF 20 EC F1 JSR $F1EC (AY) -> ACC2
ACC2+ACC1
Principe: Le principe de l'addition en virgule flottante est aisÈ ‡
assimiler, mais lourd ‡ programmer. En fait, le problËme est
d'additionner des nombres ayant mÍme exposant. Ainsi, on va
ramener le plus petit au mÍme exposant que le plus grand par une
justification (X dÈcalages de la mantisse, X Ètant la valeur
absolue de la diffÈrence des exposants). Ensuite, on ajoute les
mantisses et on ajuste l'exposant qui par dÈfaut est fixÈ au
plus grand des exposants de deux opÈrandes.
EFB2 D0 03 BNE $EFB7 ACC1<>0, on passe
EFB4 4C 77 F3 JMP $F377 ACC1=0, on sort avec ACC2 dans ACC1
EFB7 BA TSX on sauve SP pour retour en cas d'erreur
EFB8 86 89 STX $89 dans FLSVS
EFBA A6 66 LDX $66 on sauve le bit d'extension
EFBC 86 7F STX $7F dans FLTRL
EFBE A2 68 LDX #$68 on indexe ACC2
EFC0 A5 68 LDA $68 et on prend ACC2E (exposant)
EFC2 A8 TAY dans Y
EFC3 F0 D2 BEQ $EF97 si ACC2=0, on sort simplement (pourquoi pas EF79 ?)
EFC5 38 SEC
EFC6 E5 60 SBC $60 on calcule la diffÈrence des exposants
EFC8 F0 24 BEQ $EFEE exposants Ègaux
EFCA 90 12 BCC $EFDE ACC2E<ACC1E
EFCC 84 60 STY $60 l'exposant du rÈsultat est ACC2E
EFCE A4 6D LDY $6D le signe
EFD0 84 65 STY $65 est ACC2S
170
EFD2 49 FF EOR #$FF on complÈmente le signe
EFD4 69 00 ADC #$00 =1 (C=1), donc S=-S
EFD6 A0 00 LDY #$00 0 dans l'extension
EFD8 84 7F STY $7F car ACC2 n'a pas d'extension
EFDA A2 60 LDX #$60 on indexe ACC1 pour justification
EFDC D0 04 BNE $EFE2 inconditionnel
EFDE A0 00 LDY #$00 on indique
EFE0 84 66 STY $66 pas d'extension
EFE2 C9 F9 CMP #$F9 plus de 8 dÈcalages ?
EFE4 30 C4 BMI $EFAA oui, on dÈcale un octet
EFE6 A8 TAY on indexe le nombre de dÈcalages
EFE7 A5 66 LDA $66 ACC1EX dans A
EFE9 56 01 LSR $01,X on indique signe ‡ 0
EFEB 20 FC F0 JSR $F0FC et on justifie
EFEE 24 6E BIT $6E on teste le produit des signes
EFF0 10 57 BPL $F049 signes identiques, on passe
EFF2 A0 60 LDY #$60 on indexe ACC1
EFF4 E0 68 CPX #$68 c'est ACC1 le plus grand ?
EFF6 F0 02 BEQ $EFFA oui
EFF8 A0 68 LDY #$68 non, c'est ACC2, on l'indexe
EFFA 38 SEC
EFFB 49 FF EOR #$FF on complÈmente l'extension
EFFD 65 7F ADC $7F +1+extension, on ajoute les extensions
EFFF 85 66 STA $66 dans ACC1EXE
F001 B9 04 00 LDA $0004,Y soustrait octet 3 de la mantisse
F004 F5 04 SBC $04,X
F006 85 64 STA $64
F008 B9 03 00 LDA $0003,Y octet 2
F00B F5 03 SBC $03,X
F00D 85 63 STA $63
F00F B9 02 00 LDA $0002,Y octet 1
F012 F5 02 SBC $02,X
F014 85 62 STA $62
F016 B9 01 00 LDA $0001,Y octet 0
F019 F5 01 SBC $01,X
F01B 85 61 STA $61
F01D B0 03 BCS $F022 positif, on passe
F01F 20 90 F0 JSR $F090 nÈgatif, on complÈmente
F022 A0 00 LDY #$00
F024 98 TYA extension=0
F025 18 CLC dÈcalages=0
F026 A6 61 LDX $61 on prend l'octet 0 de la mantisse
F028 D0 4A BNE $F074 pas 0, on dÈcale bit ‡ bit
F02A A6 62 LDX $62 sinon, on dÈcale octet 1 -> octet 0
F02C 86 61 STX $61
F02E A6 63 LDX $63 2 -> 1
F030 86 62 STX $62
F032 A6 64 LDX $64 3 -> 2
F034 86 63 STX $63
F036 A6 66 LDX $66 extension -> 3
F038 86 64 STX $64
F03A 84 66 STY $66 0 dans l'extension
F03C 69 08 ADC #$08 on ajoute 8 aux dÈcalages
F03E C9 28 CMP #$28 5 dÈcalages faits ?
171
F040 D0 E4 BNE $F026
F042 A9 00 LDA #$00 oui, 0 dans exposant
F044 85 60 STA $60 donc nombre nul
F046 85 65 STA $65 et 0 dans le signe
F048 60 RTS
ADDITION DES MANTISSES
F049 65 7F ADC $7F extansion dans
F04B 85 66 STA $66 ACC1EX
F04D A5 64 LDA $64 octets 3
F04F 65 6C ADC $6C
F051 85 64 STA $64
F053 A5 63 LDA $63 octets 2
F055 65 6B ADC $6B
F057 85 63 STA $63
F059 A5 62 LDA $62 octets 1
F05B 65 6A ADC $6A
F05D 85 62 STA $62
F05F A5 61 LDA $61 octets 0
F061 65 69 ADC $69
F063 85 61 STA $61
F065 4C 81 F0 JMP $F081 et on ajoute l'exposant
JUSTIFICATION BIT A BIT
F068 69 01 ADC #$01 on indique un dÈcalage de plus
F06A 06 66 ASL $66 on dÈcale l'extension
F06C 26 64 ROL $64 et la mantisse
F06E 26 63 ROL $63
F070 26 62 ROL $62
F072 26 61 ROL $61
F074 10 F2 BPL $F068 si toujours pas assez, on boucle
F076 38 SEC justification terminÈe
F077 E5 60 SBC $60 on ajuste l'exposant
F079 B0 C7 BCS $F042 exposant dÈborde, le nombre Ètait trop petit
F07B 49 FF EOR #$FF on retrouve l'exposant
F07D 69 01 ADC #$01 par inversion
F07F 85 60 STA $60 dans ACC1E
F081 90 0C BCC $F08F
F083 E6 60 INC $60 on incrÈmente l'exposant
F085 F0 40 BEQ $F0C7 et on sort avec OVERFLOW s'il revient ‡ 0
F087 66 61 ROR $61 sinon, on dÈcale la mantisse
F089 66 62 ROR $62 pour retrouver le signe
F08B 66 63 ROR $63
F08D 66 64 ROR $64
F08F 60 RTS
172
COMPLEMENTE LA MANTISSE
F090 A5 65 LDA $65 on complÈmente
F092 49 FF EOR #$FF le signe
F094 85 65 STA $65
F096 A5 61 LDA $61 octet 0
F098 49 FF EOR #$FF
F09A 85 61 STA $61
F09C A5 62 LDA $62 octet 1
F09E 49 FF EOR #$FF
F0A0 85 62 STA $62
F0A2 A5 63 LDA $63 octet 2
F0A4 49 FF EOR #$FF
F0A6 85 63 STA $63
F0A8 A5 64 LDA $64 octet 3
F0AA 49 FF EOR #$FF
F0AC 85 64 STA $64
F0AE A5 66 LDA $66 extension
F0B0 49 FF EOR #$FF
F0B2 85 66 STA $66
F0B4 E6 66 INC $66 et on ajoute 1
F0B6 D0 0E BNE $F0C6
F0B8 E6 64 INC $64
F0BA D0 0A BNE $F0C6
F0BC E6 63 INC $63
F0BE D0 06 BNE $F0C6
F0C0 E6 62 INC $62
F0C2 D0 02 BNE $F0C6
F0C4 E6 61 INC $61
F0C6 60 RTS
SORTIE PAR OVERFLOW
F0C7 A9 01 LDA #$01 on indexe erreur 1
F0C9 85 8B STA $8B dans FLERR
F0CB A6 89 LDX $89
F0CD 9A TXS on restaure la pile sur l'appelant primaire
F0CE 60 RTS et on sort
JUSTIFIER ACC3 A DROITE
F0CF A2 6E LDX #$6E
JUSTIFIER A DROITE SELON A ET X
Action: X contient l'index de l'accumulateur flottant concernÈ et A
contient l'exposant de dÈpart. On dÈcale soit octet par octet
(F0D1) soit bit par bit (F0F2) et cela jusqu'‡ ce que A = 0.
173
F0D1 B4 04 LDY $04,X octet 3
F0D3 84 66 STY $66 dans extension
F0D5 B4 03 LDY $03,X octet 2
F0D7 94 04 STY $04,X dans 3
F0D9 B4 02 LDY $02,X 1
F0DB 94 03 STY $03,X dans 2
F0DD B4 01 LDY $01,X 0
F0DF 94 02 STY $02,X dans 1
F0E1 A4 67 LDY $67 code de remplissage (0 en gÈnÈral)
F0E3 94 01 STY $01,X dans octet 0
F0E5 69 08 ADC #$08 on ajoute 8
F0E7 30 E8 BMI $F0D1 nÈgatif
F0E9 F0 E6 BEQ $F0D1 ou nul, on continue octet par octet
F0EB E9 08 SBC #$08 on rÈcupËre la valeur
F0ED A8 TAY en index
F0EE A5 66 LDA $66 extension dans A
F0F0 B0 14 BCS $F106 si pas de dÈcalages (Y=0) on sort
F0F2 16 01 ASL $01,X on dÈcale l'octet 0
F0F4 90 02 BCC $F0F8 pas de bit sorti
F0F6 F6 01 INC $01,X bit sorti, on ajoute 1
F0F8 76 01 ROR $01,X on ajuste l'octet 0
F0FA 76 01 ROR $01,X et on dÈcale les 4
F0FC 76 02 ROR $02,X
F0FE 76 03 ROR $03,X
F100 76 04 ROR $04,X
F102 6A ROR et l'extension
F103 C8 INY on a fini ?
F104 D0 EC BNE $F0F2 non, on boucle
F106 18 CLC C=0
F107 60 RTS
CONSTANTES DE BASE
F108 BYT $82,$13,$5D,$8D,$DE soit 2,302585093 ou LN(10)
F10D BYT $82,$49,$0F,$DA,$9E soit 3,14159265 ou PI radians
F112 BYT $88,$34,$88,$00,$00 soit 180 ou PI degrÈs
COEFFICIENTS POLYNOME DE LN
F117 BYT $03 pour 4 coefficients
F118 BYT $7F,$5E,$56,$CB,$79 soit 0,4342559419 soit presque 2/7LN(2)
F11D BYT $80,$13,$9B,$0B,$64 soit 0,5765845412 # 2/5LN(2)
F122 BYT $80,$76,$38,$93,$16 soit 0,9618007592 # 2/3LN(2)
F127 BYT $82,$38,$AA,$3B,$20 soit 2,885390073 # 2/LN(2)
174
CONSTANTES POUR CALCUL LN
F12C BYT $80,$35,$04,$F3,$34 soit 0,7071067812 ou SQR(2)/2
F131 BYT $81,$35,$04,$F3,$34 soit 1,414213562 ou SQR(2)
F136 BYT $80,$80,$00,$00,$00 soit -0,5
F13B BYT $80,$31,$72,$17,$F8 soit 0,6931471806 ou LN(2)
F140 60 RTS pour sortie relative
F141 A9 02 LDA #$02 on indexe erreur PARAMETRE NUL OU NEGATIF
F143 4C C9 F0 JMP $F0C9 et on sort avec erreur
FONCTION LN
Principe: La premiËre des routines d'approximation de polynÙmes, et sans
doute le plus compliquÈe. Le problËme Ètant de ramener la valeur
‡ calculer dans l'intervalle (0,1). Pour cela on va poser les
Èquivalences suivantes:
soit X = m*2^E alors LN(X)=LN(m)+LN(2^E),
dío˘ LN(X)=LN(2)(E=1/LN(2)*LN(m)).
Il est bien Èvident que 0<=m<1 donc on peut maintenant calculer
le LN. Etant donnÈ que m est plus prËs de 1 que de 0, on va
calculer en fait LN(1-m). Plus prÈcisÈment,
LN(1-SQR(2)/(m+SQR(2)/2)-1/2). Le cheminement jusqu'‡ ce
rÈsultat vous sera ÈpargnÈ, rassurez-vous ! Le D.L. de cette
formule est: LN(X)=2*(X+X3/3+X5/5+X7/7). Le tout Ètant
finalement divisÈ par LN(2), ce qui explique que les
coefficients soit 2/tLN(2).
Remarque: Les coefficients sont lÈgËrement diffÈrents des valeurs donnÈes
(sauf le premier, Ètant donnÈ qu'ils rÈsultent d'une
transformation par les suites de CHEBYSHEV).
(cf: chapitre sur les fonctions mathÈmatiques).
F146 BA TSX on sauve l'adresse de l'appelant
F147 86 89 STX $89 dans FLSVS
F149 20 BD F3 JSR $F3BD on prend le signe de ACC1
F14C F0 F3 BEQ $F141 0, erreur
F14E 30 F1 BMI $F141 nÈgatif, erreur aussi
F150 A5 60 LDA $60 on prend l'exposant
F152 E9 7F SBC #$7F -128 (C=0) donc on isole sa valeur
F154 48 PHA dans la pile
F155 A9 80 LDA #$80 on place exposant +0
F157 85 60 STA $60 dans ACC1E
F159 A9 2C LDA #$2C on indexe SQR(2)/2
F15B A0 F1 LDY #$F1
F15D 20 AF EF JSR $EFAF on ajoute ‡ ACC1
F160 A9 31 LDA #$31 on indexe SQR(2)
F162 A0 F1 LDY #$F1
F164 20 87 F2 JSR $F287 on divise SRQ(2)/ACC1
175
F167 A9 A5 LDA #$A5 on indexe 1
F169 A0 F8 LDY #$F8
F16B 20 98 EF JSR $EF98 on calcule 1-ACC1
F16E A9 17 LDA #$17 on indexe le polynome
F170 A0 F1 LDY #$F1
F172 20 E1 F6 JSR $F6E1 et on calcule P(ACC1)
F175 A9 36 LDA #$36 on indexe -1/2
F177 A0 F1 LDY #$F1
F179 20 AF EF JSR $EFAF et on calcule ACC1-1/2
F17C 68 PLA on prend l'exposant
F17D 20 E9 F9 JSR $F9E9 on calcule E+ACC1
F180 A9 3B LDA #$3B
F182 A0 F1 LDY #$F1
F184 20 EC F1 JSR $F1EC on multiplie par LN(2)
F187 F0 B7 BEQ $F140 si ACC1=0, on sort
F189 D0 05 BNE $F190 sinon, on multiplie ACC2*ACC1 soit ACC1*LN(2)
MULTIPLICATION ACC1*ACC2
Principe: Trivial puisque c'est le mÍme qu'en dÈcimal:
Si xa=ma*2^Ea et xb=mb*2^Eb, on obtient pour xa*xb
Xa*xb=ma*mb*2^(Ea+Eb). Il suffit donc de multiplier les
mantisses en positionnant la multiplication comme en dÈcimal et
d'additionner les exposants (avec une justification Èventuelle).
Le principe de la multiplication binaire consiste ‡ faire 32
fois les opÈrations suivantes:
1 ñ sortir un bit du multiplicateur
2 ñ si ce bit est 1, ajouter le multiplicande au rÈsultat
partiel
3 ñ dÈcaler le multiplicande ‡ gauche
4 ñ si on n'a pas fait 32 tours, repartir en 1
Cette mÈthode nÈcessite de stocker le rÈsultat sur 32 bits
puisqu'on dÈcale 16 fois 16 bits. Les programmeurs de l'ATMOS
ont contournÈ cette perte de mÈmoire en dÈcalant le
multiplicateur ‡ gauche et le multiplicande ‡ droite. Ainsi le
rÈsultat ne nÈcessite que 16 bits, mais les bits perdue ‡ droite
auraient pu ajouter au rÈsultat: il s'ensuit donc une certaine
perte de prÈcision. Etait-il vraiment nÈcessaire d'Èconomiser 8
octets ? Un petit coup d'optimisation ‡ la BROCHE aurait permit
d'obtenir des rÈsultats plus probants.
F18B F0 B3 BEQ $F140 Z positionnÈ selon ACC1E, si ACC1=0, on sort
F18D BA TSX on sauve l'adresse
F18E 86 89 STX $89 de l'appelant dans FLSVS
F190 20 17 F2 JSR $F217 on additionne les exposants
F193 A9 00 LDA #$00 on met 0
F195 85 6F STA $6F dans ACC3 (mantisses)
F197 85 70 STA $70 l'exposant d'ACC3 est inexistent car
F199 85 71 STA $71 l'exposant de la multiplication est
F19B 85 72 STA $72 dÈj‡ calcule en partie dans ACC1E
F19D A5 66 LDA $66 on prend l'extension
F19F 20 B9 F1 JSR $F1B9 * ACC3
176
F1A2 A5 64 LDA $64 octet 3
F1A4 20 B9 F1 JSR $F1B9 * ACC3
F1A7 A5 63 LDA $63 octet 2
F1A9 20 B9 F1 JSR $F1B9 * ACC3
F1AC A5 62 LDA $62 octet 1
F1AE 20 B9 F1 JSR $F1B9 * ACC3
F1B1 A5 61 LDA $61 octet 0
F1B3 20 BE F1 JSR $F1BE
F1B6 4C 01 F3 JMP $F301 et on passe ACC3 -> ACC1 avec justification
MULTIPLICATION PARTIELLE
F1B9 D0 03 BNE $F1BE si l'octet ‡ multiplier est nul
F1BB 4C CF F0 JMP $F0CF on indique 8 dÈcalages et on passÈ sans ajouter
F1BE 4A LSR pourquoi pas SEC/ROR ?
F1BF 09 80 ORA #$80 on met b7 ‡ 1 pour compter 8 dÈcalages
F1C1 A8 TAY dans Y
F1C2 90 19 BCC $F1DD si il ne faut pas additionner, on saute
F1C4 18 CLC
F1C5 A5 72 LDA $72 on additionne ACC2 ‡ ACC3
F1C7 65 6C ADC $6C octet 3
F1C9 85 72 STA $72
F1CB A5 71 LDA $71
F1CD 65 6B ADC $6B octet 2
F1CF 85 71 STA $71
F1D1 A5 70 LDA $70
F1D3 65 6A ADC $6A octet 1
F1D5 85 70 STA $70
F1D7 A5 6F LDA $6F
F1D9 65 69 ADC $69 octet 0
F1DB 85 6F STA $6F
F1DD 66 6F ROR $6F on dÈcale ACC1
F1DF 66 70 ROR $70 donc le multiplicande ‡ droite
F1E1 66 71 ROR $71
F1E3 66 72 ROR $72
F1E5 66 66 ROR $66
F1E7 98 TYA
F1E8 4A LSR
F1E9 D0 D6 BNE $F1C1 et on fait pour les 8 bits du multiplicateur
F1EB 60 RTS
(AY) -> ACC2
F1EC 85 7D STA $7D on sauve l'adresse du nombre
F1EE 84 7E STY $7E
F1F0 A0 04 LDY #$04 pour 5 octets
F1F2 B1 7D LDA ($7D),Y octet 3
F1F4 85 6C STA $6C
F1F6 88 DEY
F1F7 B1 7D LDA ($7D),Y octet 2
F1F9 85 6B STA $6B
F1FB 88 DEY
F1FC B1 7D LDA ($7D),Y octet 1
177
F1FE 85 6A STA $6A
F200 88 DEY
F201 B1 7D LDA ($7D),Y octet 0
F203 85 6D STA $6D dans le signe de ACC2
F205 45 65 EOR $65 produit signes ACC1S et ACC2S
F207 85 6E STA $6E dans ACCPS
F209 A5 6D LDA $6D bit force ‡ 1
F20B 09 80 ORA #$80
F20D 85 69 STA $69 dans octet 0
F20F 88 DEY
F210 B1 7D LDA ($7D),Y et l'exposant
F212 85 68 STA $68
F214 A5 60 LDA $60 en sortie A et P positionnÈs selon ACC1E
F216 60 RTS
SOMME DES EXPOSANTS ACC1E+ACC2E
Action: Additionne ACC1E et ACC2E dans ACC1E. Ce qui est plus compliquÈ
qu'il n'y parait puisque d'aprËs les conventions sur les
exposants, #80=-1, #81=0 et #82=+1, dío˘ +1 + +1 = #82+#82 = 4
avec dÈpassement, de mÍme que -2 + -2 = #7F+#7F=#FE=+125 avec
signe nÈgatif.
En rËgle gÈnÈrale, la somme de deux exposants positifs donne un
rÈsultat positif qu'il suffit de majorer de #80 et la somme de
deux exposants nÈgatif un rÈsultat nÈgatif que l'on minorera de
#80. Si les exposants de signes opposÈes, pas de problËme, on
n'est sur de ne pas dÈpasser!
F217 A5 68 LDA $68 si ACC2=0
F219 F0 1C BEQ $F237 on sort avec ACC1=0
F21B 18 CLC
F21C 65 60 ADC $60 on ajoute ACC1E
F21E 90 04 BCC $F224 pas de dÈpassement
F220 30 1A BMI $F23C dÈpassement et nÈgative, trop grand
F222 18 CLC C=0
F223 2C BYT $2C et on sautÈ le BPL qui brancherait
F224 10 11 BPL $F237 pas de dÈpassement et positif, nombre trop petit
F226 69 80 ADC #$80 on ajoute 128
F228 85 60 STA $60 pour rÈcupÈrer le bon rÈsultat dans ACC1E
F22A F0 13 BEQ $F23F si 0, on sort avec ACC1>0
F22C A5 6E LDA $6E on met le produit des signes
F22E 85 65 STA $65 dans ACC1S
F230 60 RTS
F231 A5 65 LDA $65 on complÈmente le signe de ACC1 ‡ 1
F233 49 FF EOR #$FF s'il Ètait nÈgative, N=0 et on sort
F235 30 05 BMI $F23C sinon, on indique OVERFLOW et on sort
F237 68 PLA on dÈpile l'adresse de reour
F238 68 PLA pour retourner ‡ l'appelant de l'appelant
F239 4C 42 F0 JMP $F042 on sort avec ACC1=0
F23C 4C C7 F0 JMP $F0C7 indique erreur OVERFLOW
F23F 4C 46 F0 JMP $F046 on indique ACC1 positif
178
10*ACC1 -> ACC1
Principe: Cette routine Ètant appelÈe trËs souvent, son optimisation est
la bienvenue. Elle consiste ‡ sauver ACC1, ‡ ajouter 2 ‡ son
exposant, ce qui revient ‡ multiplier ACC1 par 4, ‡ ajouter la
valeur sauvÈe, donc on obtient ACC1*5 et ‡ ajouter ‡ l'exposant
pour tomber sur ACC1*10.
F242 20 87 F3 JSR $F387 on met ACC1 dans ACC2
F245 AA TAX ACC1=0 ?
F246 F0 10 BEQ $F258 oui, on sort
F248 18 CLC
F249 69 02 ADC #$02 ACC1*4 (on ajoute 2 ‡ l'exposant donc on
F24B B0 EF BCS $F23C multiplie pas 2^2) si on dÈpasse OVERFLOW
F24D A2 00 LDX #$00 on met 0 dans le produit des signes
F24F 86 6E STX $6E
F251 20 C2 EF JSR $EFC2 +ACC2 donc *5
F254 E6 60 INC $60 et exposant +1 donc *2 donc finalement *10
F256 F0 E4 BEQ $F23C si exposant nul, OVERFLOW
F258 60 RTS
F259 BYT $84,$20,$00,$00,$00 soit 10 en virgule flottante
ACC1/10 -> ACC1
F25E 20 87 F3 JSR $F387 on met ACC1 dans ACC2
F261 A2 00 LDX #$00 produit des signes ‡ 0
F263 A9 59 LDA #$59 on indexe 10
F265 A0 F2 LDY #$F2
F267 86 6E STX $6E
F269 20 23 F3 JSR $F323 on met 10 dans ACC1
F26C 4C 8A F2 JMP $F28A et on calcule ACC2/ACC1
FONCTION LOG
Principe: On se sert de l'ÈgalitÈ LOG X = LN x / ln 10.
F26F BA TSX on sauve pour sortie aprËs erreur
F270 86 89 STX $89
F272 20 49 F1 JSR $F149 on calcule LN de ACC1
F275 20 87 F3 JSR $F387 on arrondit ACC1 dans ACC2
F278 A9 08 LDA #$08 on indexe LN(10)
F27A A0 F1 LDY #$F1
F27C 20 23 F3 JSR $F323 dans ACC1
F27F 4C 8A F2 JMP $F28A et on divise ACC2 par ACC1
179
INDIQUE DIVISION PAR 0
F282 A9 03 LDA #$03 on indique erreur 3
F284 85 8B STA $8B dans FLERR
F286 60 RTS
DIVISION ACC2/ACC1
Principe: Si A1=M1*2^E1 et A2=M2*2^E2 alors A2/A1=M2/M1*2 (E2-E1).
Il suffit donc de diviser les mantisses et de soustraire les
exposants. Le procÈdÈ retenu par Fabrice BROCHE est
(malheureusement) identique ‡ celui retenu par Andy BROWN sur la
V1.1. La routine est en fait la mÍme alors qu'un effort de
finition (dixit BROCHE !) aurait pu faire gagner de prÈcieux
octets.
Enfin, toujours est-il que la division binaire est dans son
principe identique ‡ la division dÈcimale, c'est-‡-dire que l'on
doit essayer tous les chiffres de la base pour voir lequel
convient. En binaire, il se trouve que seul 0 et 1 existent, les
solutions sont donc triviales. Il suffit de soustraire le
diviseur au dividende et de regarder le signe de cette
diffÈrence. Positive, on ajoute 1 au rÈsultat, nÈgative 0. Et on
dÈcale le dividende jusqu'‡ ce qu'il soit nul.
F287 20 EC F1 JSR $F1EC ACC1=0 ?
F28A F0 F6 BEQ $F282 oui, division par 0
F28C BA TSX non, on sauve le pointeur de pile
F28D 86 89 STX $89
F28F 20 96 F3 JSR $F396 on arrondit ACC1
F292 A9 00 LDA #$00 on veut E2-E1
F294 38 SEC donc E2+(-E1)
F295 E5 60 SBC $60 donc on complÈmente ACC1E
F297 85 60 STA $60
F299 20 17 F2 JSR $F217 et on additione les deux exposants
F29C E6 60 INC $60 on ajoute 1 car inverse=complement ‡ 2
F29E F0 9C BEQ $F23C si le rÈsultat est nul, il y a OVERFLOW
F2A0 A2 FC LDX #$FC on indexe ACC3
F2A2 A9 01 LDA #$01 on prepare 8 dÈcalages
F2A4 A4 69 LDY $69
F2A6 C4 61 CPY $61 on compare le diviseur au dividende
F2A8 D0 10 BNE $F2BA s'ils sont different, on passe
F2AA A4 6A LDY $6A
F2AC C4 62 CPY $62
F2AE D0 0A BNE $F2BA
F2B0 A4 6B LDY $6B
F2B2 C4 63 CPY $63
F2B4 D0 04 BNE $F2BA
F2B6 A4 6C LDY $6C
F2B8 C4 64 CPY $64
F2BA 08 PHP on sauve le rÈsultat de la comparaison
F2BB 2A ROL on met 1 ou 0 dans le rÈsultat
F2BC 90 0C BCC $F2CA si pas de dÈbordement, on sautÈ
F2BE E8 INX sinon, on sauve le rÈsultat
180
F2BF 95 72 STA $72,X
F2C1 F0 05 BEQ $F2C8 s'il est nul, on passe
F2C3 10 33 BPL $F2F8 si index positif, on sort
F2C5 A9 01 LDA #$01 on refait 8 dÈcalages
F2C7 2C BYT $2C on sautÈ l'instruction suivante
F2C8 A9 40 LDA #$40 on indexe l'extension
F2CA 28 PLP on rÈcupËre le rÈsultat de la comparaison
F2CB B0 0E BCS $F2DB dividende > diviseur, on soustrait
F2CD 06 6C ASL $6C on dÈcale le dividende
F2CF 26 6B ROL $6B ‡ gauche
F2D1 26 6A ROL $6A
F2D3 26 69 ROL $69
F2D5 B0 E3 BCS $F2BA si un bit dÈborde, ACC2 > Acc1
F2D7 30 CB BMI $F2A4 sinon, on compare ACC2 et ACC1
F2D9 10 DF BPL $F2BA si b7 de ACC2=0, alors ACC1 < ACC2
F2DB A8 TAY on sauve le rÈsultat provisoire
F2DC A5 6C LDA $6C on soustrait ACC1 ‡ ACC2
F2DE E5 64 SBC $64
F2E0 85 6C STA $6C
F2E2 A5 6B LDA $6B
F2E4 E5 63 SBC $63
F2E6 85 6B STA $6B
F2E8 A5 6A LDA $6A
F2EA E5 62 SBC $62
F2EC 85 6A STA $6A
F2EE A5 69 LDA $69
F2F0 E5 61 SBC $61
F2F2 85 69 STA $69
F2F4 98 TYA on rÈcupËre le rÈsultat et on dÈcale le dividende
F2F5 4C CD F2 JMP $F2CD pourquoi pas BCS ?
F2F8 0A ASL
F2F9 0A ASL
F2FA 0A ASL
F2FB 0A ASL
F2FC 0A ASL
F2FD 0A ASL
F2FE 85 66 STA $66 on sauve dans ACC1EX
F300 28 PLP on ajuste la pile
ACC3 -> ACC1
F301 A5 6F LDA $6F on transfËre ACC3 dans ACC1
F303 85 61 STA $61
F305 A5 70 LDA $70
F307 85 62 STA $62
F309 A5 71 LDA $71
F30B 85 63 STA $63
F30D A5 72 LDA $72
F30F 85 64 STA $64
F311 4C 22 F0 JMP $F022
181
PI -> ACC1
F314 20 C7 F8 JSR $F8C7 quel mode de calcul d'angles ?
F317 F0 06 BEQ $F31F radian
F319 A9 12 LDA #$12 degrÈ, on indexe 180
F31B A0 F1 LDY #$F1
F31D D0 04 BNE $F323
F31F A9 0D LDA #$0D on indexe 3,14159265
F321 A0 F1 LDY #$F1
(AY) -> ACC1
F323 85 7D STA $7D on sauve AY
F325 84 7E STY $7E
F327 A0 04 LDY #$04
F329 B1 7D LDA ($7D),Y octet 3
F32B 85 64 STA $64
F32D 88 DEY
F32E B1 7D LDA ($7D),Y octet 2
F330 85 63 STA $63
F332 88 DEY
F333 B1 7D LDA ($7D),Y octet 1
F335 85 62 STA $62
F337 88 DEY
F338 B1 7D LDA ($7D),Y octet 0
F33A 85 65 STA $65 on sauve le signe
F33C 09 80 ORA #$80 on force b7 ‡ 1
F33E 85 61 STA $61 et on sauve l'octet 1
F340 88 DEY
F341 B1 7D LDA ($7D),Y
F343 85 60 STA $60 exposant
F345 84 66 STY $66 et 0 dans l'extension
F347 60 RTS
ARRONDIT ACC1 DANS ACC5
F348 A2 73 LDX #$73 on indexe ACC5
F34A 2C BYT $2C et on saute
ARRONDIT ACC1 DANS ACC4
F34B A2 78 LDX #$78 on indexe ACC4
F34D A0 00 LDY #$00 Y=0
ARRONDIT ACC1 DANS XY
F34F 20 96 F3 JSR $F396 on arrondit ACC1
F352 86 7D STX $7D on sauve XY
182
F354 84 7E STY $7E
F356 A0 04 LDY #$04 et on transfËre comme d'habitude
F358 A5 64 LDA $64
F35A 91 7D STA ($7D),Y octet 3
F35C 88 DEY
F35D A5 63 LDA $63
F35F 91 7D STA ($7D),Y octet 2
F361 88 DEY
F362 A5 62 LDA $62
F364 91 7D STA ($7D),Y octet 1
F366 88 DEY
F367 A5 65 LDA $65 octet 0
F369 09 7F ORA #$7F
F36B 25 61 AND $61 avec signe
F36D 91 7D STA ($7D),Y
F36F 88 DEY
F370 A5 60 LDA $60
F372 91 7D STA ($7D),Y et exposant
F374 84 66 STY $66
F376 60 RTS Y=0
ACC2 -> ACC1
F377 A5 6D LDA $6D signe
F379 85 65 STA $65
F37B A2 05 LDX #$05 et 5 octets de la mantisse
F37D B5 67 LDA $67,X
F37F 95 5F STA $5F,X
F381 CA DEX
F382 D0 F9 BNE $F37D
F384 86 66 STX $66 et 0 dans l'extension
F386 60 RTS
ARRONDIT ACC1 DANS ACC2
F387 20 96 F3 JSR $F396 on arrondit ACC1
ACC1 -> ACC2
F38A A2 06 LDX #$06 6 octets
F38C B5 5F LDA $5F,X en transfert direct
F38E 95 67 STA $67,X
F390 CA DEX
F391 D0 F9 BNE $F38C
F393 86 66 STX $66 et 0 dans l'extension
F395 60 RTS
183
ARRONDIT ACC1
Action: Arrondit ACC1 selon le bit de l'extension, cela revient ‡ ajouter
0,5 et ‡ prendre la partie entiËre d'un nombre dÈcimal.
F396 A5 60 LDA $60 ACC1=0 ?
F398 F0 FB BEQ $F395 oui, on sort
F39A 06 66 ASL $66 non, bit d'extension ?
F39C 90 F7 BCC $F395 non, on sort
F39E 20 B8 F0 JSR $F0B8 oui, on incrÈmente la mantisse
F3A1 D0 F2 BNE $F395 si pas 0, on sort
F3A3 4C 83 F0 JMP $F083 si 0, on incrÈmente l'exposant
INT(ACC1) -> AY
F3A6 A5 65 LDA $65 nombre nÈgative ?
F3A8 30 0E BMI $F3B8 oui
F3AA A5 60 LDA $60
F3AC C9 91 CMP #$91 nombre > 65536 ?
F3AE B0 08 BCS $F3B8 oui
F3B0 20 39 F4 JSR $F439 on convertit en entier
F3B3 A5 64 LDA $64 et on sauve dans YA (pourquoi pas AY ?)
F3B5 A4 63 LDY $63
F3B7 60 RTS
F3B8 A9 0A LDA #$0A erreur 10
F3BA 4C C9 F0 JMP $F0C9 (nombre trop grand ou trop petit)
RETOURNE LE SIGNE DE ACC1
Action: Retourne A=1 si ACC1>0, A=-1 si ACC1<0 ou a=0 si ACC1=0
F3BD A5 60 LDA $60 ACC1=0 ?
F3BF F0 09 BEQ $F3CA oui, on sort
F3C1 A5 65 LDA $65 non, negative ?
F3C3 2A ROL
F3C4 A9 FF LDA #$FF oui, A=255=-1
F3C6 B0 02 BCS $F3CA
F3C8 A9 01 LDA #$01 non, A=1
F3CA 60 RTS
SGN(ACC1) -> ACC1
F3CB 20 BD F3 JSR $F3BD prend signe de ACC1
F3CE 2C BYT $2C et saute l'instruction suivante
184
ACC1 = -1
F3CD A9 FF LDA #$FF force signe nÈgatif
A -> ACC1
F3D1 85 61 STA $61 on sauve A
F3D3 A9 00 LDA #$00
F3D5 85 62 STA $62 on annule le poids faible
F3D7 A2 88 LDX #$88 exposant=+7
F3D9 A5 61 LDA $61 on prend le signe
F3DB 49 FF EOR #$FF on l'inverse
F3DD 2A ROL dans C
F3DE A9 00 LDA #$00 A=0
F3E0 85 63 STA $63 on annule la mantisse
F3E2 85 64 STA $64
F3E4 86 60 STX $60 on fixe l'exposant
F3E6 85 66 STA $66
F3E8 85 65 STA $65
F3EA 4C 1D F0 JMP $F01D et on ajoute la mantisse selon l'exposant
INT(YA) -> ACC1 (non signÈ)
F3ED 85 61 STA $61 on sauve YA
F3EF 84 62 STY $62
F3F1 A2 90 LDX #$90 on fixe l'exposant ‡ +15
F3F3 38 SEC
F3F4 B0 E8 BCS $F3DE inconditionnel, on termine la conversion
FONCTION ABS
F3F6 46 65 LSR $65 on enlËve le signe de ACC1
F3F8 60 RTS et on sort
COMPARER (AY) ET ACC1
Action: Retourne dans A -1,0 ou 1 selon le signe de ACC1-(AY). Cette
routine, bien compliquÈe en apparence, nous plonge dans les
dÈlices des comparaisons en binaire signÈ.
F3F9 85 7D STA $7D on sauve AY
F3FB 84 7E STY $7E
F3FD A0 00 LDY #$00
F3FF B1 7D LDA ($7D),Y on prend l'exposant
F401 C8 INY
F402 AA TAX dans Y
F403 F0 B8 BEQ $F3BD si nombre nul, le rÈsultat vient de ACC1
F405 B1 7D LDA ($7D),Y on prend le signe (intÈgrÈe ‡ la mantisse)
185
F407 45 65 EOR $65 et on le compare ‡ ACC1S
F409 30 B6 BMI $F3C1 les signes sont diffÈrent, on retourne selon ACC1
F40B E4 60 CPX $60 on compare les exposants
F40D D0 21 BNE $F430 diffÈrents, on passe (C contient le signe)
F40F B1 7D LDA ($7D),Y on reprend la mantisse
F411 09 80 ORA #$80 bit de signe ‡ 1
F413 C5 61 CMP $61 premier octet identique ?
F415 D0 19 BNE $F430 non, C contient le signe
F417 C8 INY
F418 B1 7D LDA ($7D),Y oui, octet suivant ?
F41A C5 62 CMP $62
F41C D0 12 BNE $F430 id
F41E C8 INY
F41F B1 7D LDA ($7D),Y octet 2
F421 C5 63 CMP $63
F423 D0 0B BNE $F430 id
F425 C8 INY
F426 A9 7F LDA #$7F extension nulle ?
F428 C5 66 CMP $66 oui, C=1, non C=0
F42A B1 7D LDA ($7D),Y on soustrai la mantisse 3
F42C E5 64 SBC $64 et l'extension d'ACC1
F42E F0 C8 BEQ $F3F8 si 0, alors nombres Ègaux
F430 A5 65 LDA $65 on prend ACC1S
F432 90 02 BCC $F436 si ACC1>(AY) on passe
F434 49 FF EOR #$FF sinon, on inverse le signe
F436 4C C3 F3 JMP $F3C3 et on positionne A en sortie
ACC1 -> $64 63 62 61 en ENTIER SIGNE
Remarque: $67 n'est initialisÈ que si le nombre est nÈgatif, il doit donc
valoir 0 avant d'appeler la routine, sous peine de surprise !
Cet octet Ètant utilisÈ comme MENFY par la routine XMENU, il est
normal que les rÈsultats numÈriques soit erronÈs en sortie de
cette routine !
F439 A5 60 LDA $60 nombre nul ?
F43B F0 4A BEQ $F487 oui, nombre nul aussi et on sort
F43D 38 SEC non, on retire exposant $A0
F43E E9 A0 SBC #$A0 pour ramener ‡ 0-31
F440 24 65 BIT $65 ACC1 positif ?
F442 10 09 BPL $F44D oui
F444 AA TAX exposant dans X
F445 A9 FF LDA #$FF on indique nombre nÈgatif
F447 85 67 STA $67 dans ACC1J
F449 20 96 F0 JSR $F096 on complÈmente la mantisse
F44C 8A TXA et on rÈcupËre l'exposant
F44D A2 60 LDX #$60 on prÈpare les opÈrations
F44F C9 F9 CMP #$F9 y a-t-il plus de 8 dÈcalages ‡ faire ?
F451 10 06 BPL $F459 non, on saute
F453 20 E5 F0 JSR $F0E5 oui, on fait les dÈcalages
F456 84 67 STY $67 on remet 0
F458 60 RTS
186
F459 A8 TAY exposant dans Y
F45A A5 65 LDA $65 on prend le signe
F45C 29 80 AND #$80 dans b7
F45E 46 61 LSR $61 on replace dans $61
F460 05 61 ORA $61
F462 85 61 STA $61
F464 20 FC F0 JSR $F0FC et on dÈcale la mantisse
F467 84 67 STY $67 et 0 dans ACC1J
F469 60 RTS
FONCTION INT
F46A A5 60 LDA $60 on prend ACC1E
F46C C9 A0 CMP #$A0 supÈrieur ‡ 31
F46E B0 F9 BCS $F469 oui, on ne fait rien
F470 20 39 F4 JSR $F439 on convertit en entier 32 bits
F473 84 66 STY $66 extension ‡ 0
F475 A5 65 LDA $65 on prend le signe
F477 84 65 STY $65 et on le fixe positif
F479 49 80 EOR #$80 on l'inverse
F47B 2A ROL dans C
F47C A9 A0 LDA #$A0 exposant=31
F47E 85 60 STA $60
F480 A5 64 LDA $64 on prend le poids faible
F482 85 88 STA $88 dans FLINT (ACC1 est un entier)
F484 4C 1D F0 JMP $F01D et on justifie la mantisse
F487 85 61 STA $61 A=0, on annule ACC1M
F489 85 62 STA $62
F48B 85 63 STA $63
F48D 85 64 STA $64
F48F A8 TAY et Y=0
F490 60 RTS
AX -> ACC1
F491 85 61 STA $61 on sauve le poids fort
F493 86 62 STX $62 et le poids faible
F495 A2 90 LDX #$90 exposants = + 15
F497 38 SEC C=1
F498 4C DE F3 JMP $F3DE et on convertit en flottant
AFFICHE ACC1 EN DECIMAL
F49B 20 A5 F4 JSR $F4A5 convertit ACC1 en dÈcimal
F49E A9 00 LDA #$00 indexe BUFTRV (INUTILE ! AY l'indexe dÈj‡
F4A0 A0 01 LDY #$01 en sortie de conversion dÈcimal !!)
F4A2 4C A8 C7 JMP $C7A8 et affiche le nombre

*/
	
	
	.byt $08,$78,$48,$8a,$48,$ad
	.byt $21,$03,$ae,$18,$04,$9d,$c8,$04,$ee,$18,$04,$68,$aa,$ad,$17,$04
	.byt $20,$6a,$04,$68,$28,$20,$14,$04,$08,$78,$48,$8a,$48,$ce,$18,$04
	.byt $ae,$18,$04,$bd,$c8,$04,$20,$6a,$04,$68,$aa,$68,$28,$60,$08,$78
	.byt $29,$07,$8d,$c7,$04,$ad,$21,$03,$29,$f8,$0d,$c7,$04,$8d,$21,$03
	.byt $28,$60,$85,$21,$ad,$21,$03,$29,$07,$8d,$0f,$04,$ad,$21,$03,$09
	.byt $07,$8d,$21,$03,$4c,$68,$c8,$ad,$21,$03,$29,$f8,$0d,$0f,$04,$8d
	.byt $21,$03,$a5,$21,$40,$48,$ad,$21,$03,$29,$f8,$0d,$10,$04,$8d,$21
	.byt $03,$68,$60,$ad,$21,$03,$29,$f8,$0d,$10,$04,$8d,$21,$03,$b1,$15
	.byt $48,$ad,$21,$03,$09,$07,$8d,$21,$03,$68,$60,$90,$4c,$50,$0f,$a8
	.byt $f0,$2c,$bd,$88,$c0,$1d,$89,$c0,$f0,$02,$18,$60,$38,$60,$85,$02
	.byt $84,$03,$38,$e5,$00,$9d,$8a,$c0,$98,$e5,$01,$9d,$8b,$c0,$8a,$69
	.byt $03,$aa,$a0,$03,$b9,$00,$00,$9d,$7f,$c0,$ca,$88,$10,$f6,$a9,$00
	.byt $9d,$88,$c0,$9d,$89,$c0,$bd,$82,$c0,$9d,$84,$c0,$9d,$86,$c0,$bd
	.byt $83,$c0,$9d,$85,$c0,$9d,$87,$c0,$60,$70,$26,$20,$07,$c5,$b0,$20
	.byt $bd,$86,$c0,$bc,$87,$c0,$20,$a6,$c5,$9d,$86,$c0,$98,$9d,$87,$c0
	.byt $bd,$88,$c0,$d0,$03,$de,$89,$c0,$de,$88,$c0,$a0,$00,$b1,$24,$18
	.byt $60,$48,$bd,$88,$c0,$dd,$8a,$c0,$bd,$89,$c0,$fd,$8b,$c0,$b0,$1f
	.byt $bd,$84,$c0,$bc,$85,$c0,$20,$a6,$c5,$9d,$84,$c0,$98,$9d,$85,$c0
	.byt $fe,$88,$c0,$d0,$03,$fe,$89,$c0,$a0,$00,$68,$91,$24,$18,$60,$68
	.byt $60,$18,$69,$01,$90,$01,$c8,$dd,$82,$c0,$85,$24,$98,$fd,$83,$c0
	.byt $90,$08,$bd,$80,$c0,$bc,$81,$c0,$85,$24,$84,$25,$a5,$24,$60,$c4
	.byt $c5,$80,$c6,$80,$c6,$00,$c8,$00,$c8,$00,$ca,$00,$ca,$00,$d2,$a2
	.byt $00,$8e,$01,$03,$ad,$00,$03,$29,$ef,$8d,$00,$03,$09,$10,$8d,$00
	.byt $03,$ad,$0d,$03,$29,$02,$d0,$04,$ca,$d0,$f6,$60,$ad,$0d,$02,$09
	.byt $02,$8d,$0d,$02,$60,$a2,$00,$2c,$a2,$04,$2c,$a2,$08,$2c,$a2,$0c
	.byt $48,$68,$dd,$ae,$02,$f0,$0d,$bc,$ae,$02,$10,$09,$e8,$48,$8a,$29
	.byt $03,$d0,$ee,$68,$60,$a0,$0f,$d9,$ae,$02,$f0,$0f,$88,$10,$f8,$86
	.byt $19,$48,$a0,$80,$aa,$20,$1c,$c8,$a6,$19,$68,$9d,$ae,$02,$18,$60
	.byt $a2,$00,$2c,$a2,$04,$2c,$a2,$08,$2c,$a2,$0c,$a0,$03,$c9,$00,$f0
	.byt $1d,$dd,$ae,$02,$f0,$05,$e8,$88,$10,$f7,$60,$5e,$ae,$02,$a2,$0f
	.byt $dd,$ae,$02,$f0,$f5,$ca,$10,$f8,$aa,$a0,$81,$4c,$1c,$c8,$5e,$ae
	.byt $02,$e8,$88,$10,$f9,$60,$a9,$0a,$20,$5d,$c7,$a9,$0d,$48,$a9,$00
	.byt $f0,$0d,$48,$a9,$04,$d0,$08,$48,$a9,$08,$d0,$03,$48,$a9,$0c,$85
	.byt $19,$68,$85,$1b,$a9,$04,$85,$1a,$8a,$48,$98,$48,$a6,$19,$bd,$ae
	.byt $02,$c9,$88,$90,$16,$0a,$aa,$bd,$be,$02,$8d,$f8,$02,$bd,$bf,$02
	.byt $8d,$f9,$02,$a5,$1b,$2c,$95,$c7,$20,$f7,$02,$e6,$19,$c6,$1a,$d0
	.byt $db,$68,$a8,$68,$aa,$a5,$1b,$60,$a2,$00,$2c,$a2,$04,$2c,$a2,$08
	.byt $2c,$a2,$0c,$86,$1c,$85,$15,$84,$16,$a5,$1c,$85,$19,$a0,$00,$20
	.byt $11,$04,$f0,$e3,$20,$72,$c7,$e6,$15,$d0,$ee,$e6,$16,$d0,$ea,$a9
	.byt $00,$2c,$a9,$04,$2c,$a9,$08,$2c,$a9,$0c,$85,$19,$a9,$04,$85,$1a
	.byt $8a,$48,$98,$48,$a6,$19,$bd,$ae,$02,$10,$0e,$c9,$88,$b0,$0a,$aa
	.byt $a0,$40,$20,$1c,$c8,$85,$1d,$90,$06,$e6,$19,$c6,$1a,$d0,$e5,$68
	.byt $a8,$68,$aa,$a5,$1d,$60,$a9,$00,$2c,$a9,$04,$2c,$a9,$08,$2c,$a9
	.byt $0c,$85,$1b,$a5,$1b,$20,$da,$c7,$b0,$f9,$38,$60,$84,$17,$84,$18
	.byt $48,$8a,$0a,$aa,$bd,$be,$02,$8d,$f8,$02,$bd,$bf,$02,$8d,$f9,$02
	.byt $68,$46,$17,$24,$18,$4c,$f7,$02,$5c,$d9,$1a,$c8,$f7,$da,$5d,$db
	.byt $1a,$c8,$1a,$c8,$1a,$c8,$1a,$c8,$86,$db,$8c,$db,$92,$db,$98,$db
	.byt $1a,$c8,$1a,$c8,$70,$da,$12,$db,$79,$db,$c6,$d5,$1a,$c8,$1a,$c8
	.byt $1a,$c8,$1a,$c8,$1a,$c8,$1a,$c8,$86,$22,$84,$23,$68,$85,$24,$29
	.byt $10,$f0,$40,$ba,$68,$d0,$03,$de,$02,$01,$38,$e9,$01,$48,$85,$15
	.byt $bd,$02,$01,$85,$16,$ad,$0f,$04,$8d,$10,$04,$a0,$00,$20,$11,$04
	.byt $0a,$aa,$a9,$04,$48,$a9,$02,$48,$bd,$a5,$ca,$bc,$a4,$ca,$90,$06
	.byt $bd,$a5,$cb,$bc,$a4,$cb,$48,$98,$48,$a5,$24,$48,$a5,$21,$a4,$23
	.byt $a6,$22,$40,$a5,$24,$48,$38,$66,$1e,$20,$bf,$c8,$4c,$b9,$c9,$98
	.byt $48,$ad,$1d,$03,$10,$55,$46,$1e,$48,$29,$08,$f0,$12,$ae,$1c,$03
	.byt $68,$48,$29,$07,$f0,$03,$09,$b0,$24,$8a,$a2,$0c,$20,$1d,$c5,$68
	.byt $29,$10,$f0,$37,$a2,$18,$20,$0f,$c5,$b0,$16,$ad,$1d,$03,$29,$20
	.byt $d0,$29,$20,$18,$c5,$8d,$1c,$03,$ad,$1f,$03,$29,$07,$85,$3f,$90
	.byt $1a,$e6,$20,$d0,$16,$c6,$3f,$d0,$12,$ad,$8a,$02,$4a,$4a,$4a,$ad
	.byt $1e,$03,$29,$f3,$90,$02,$29,$fe,$8d,$1e,$03,$68,$a8,$60,$ce,$15
	.byt $02,$d0,$50,$a9,$04,$8d,$15,$02,$2c,$8a,$02,$10,$03,$20,$2f,$ca
	.byt $a5,$44,$d0,$02,$c6,$45,$c6,$44,$38,$ee,$10,$02,$ad,$10,$02,$e9
	.byt $0a,$90,$30,$8d,$10,$02,$2c,$14,$02,$10,$03,$20,$75,$ca,$ee,$11
	.byt $02,$a5,$42,$d0,$02,$c6,$43,$c6,$42,$ad,$11,$02,$e9,$3c,$90,$13
	.byt $8d,$11,$02,$ee,$12,$02,$ad,$12,$02,$e9,$3c,$90,$06,$8d,$12,$02
	.byt $ee,$13,$02,$ce,$16,$02,$d0,$19,$a9,$0a,$8d,$16,$02,$ad,$17,$02
	.byt $49,$80,$8d,$17,$02,$2c,$48,$02,$10,$07,$70,$05,$a6,$28,$4c,$2d
	.byt $de,$60,$ad,$0d,$03,$29,$20,$f0,$20,$ad,$8f,$02,$ac,$90,$02,$8d
	.byt $08,$03,$8c,$09,$03,$ad,$8c,$02,$4a,$90,$06,$20,$85,$e0,$4c,$b9
	.byt $c8,$a9,$ff,$8d,$09,$03,$4c,$b9,$c8,$2c,$0d,$03,$30,$0e,$24,$1e
	.byt $10,$07,$a6,$22,$a4,$23,$4c,$00,$04,$4c,$b6,$c8,$46,$1e,$2c,$0d
	.byt $03,$50,$4c,$2c,$04,$03,$20,$1e,$c9,$ce,$a6,$02,$d0,$22,$20,$df
	.byt $d7,$20,$bf,$c8,$2c,$70,$02,$10,$07,$a9,$14,$8d,$a7,$02,$d0,$0b
	.byt $ad,$a8,$02,$2c,$a7,$02,$30,$05,$ce,$a7,$02,$a9,$01,$8d,$a6,$02
	.byt $2c,$8c,$02,$10,$06,$20,$fa,$df,$2c,$8c,$02,$50,$03,$20,$fb,$df
	.byt $ad,$8c,$02,$4a,$90,$03,$20,$e1,$e0,$4c,$b9,$c8,$4c,$92,$c9,$ad
	.byt $0d,$03,$29,$02,$f0,$f6,$2c,$01,$03,$20,$2f,$ca,$4c,$b9,$c8,$a2
	.byt $24,$20,$18,$c5,$90,$08,$0e,$8a,$02,$38,$6e,$8a,$02,$60,$8d,$01
	.byt $03,$ad,$00,$03,$29,$ef,$8d,$00,$03,$09,$10,$8d,$00,$03,$0e,$8a
	.byt $02,$4e,$8a,$02,$60,$a9,$00,$a2,$04,$9d,$10,$02,$ca,$10,$fa,$a9
	.byt $01,$8d,$15,$02,$60,$4e,$14,$02,$60,$08,$78,$85,$40,$84,$41,$38
	.byt $6e,$14,$02,$28,$60,$a0,$00,$ad,$13,$02,$20,$90,$ca,$a9,$3a,$91
	.byt $40,$c8,$ad,$12,$02,$20,$90,$ca,$a9,$3a,$91,$40,$c8,$ad,$11,$02
	.byt $a2,$2f,$38,$e9,$0a,$e8,$b0,$fb,$48,$8a,$91,$40,$68,$c8,$69,$3a
	.byt $91,$40,$c8,$60,$e5,$c6,$e8,$c6,$eb,$c6,$ee,$c6,$20,$c7,$23,$c7
	.byt $26,$c7,$29,$c7,$cf,$c7,$d2,$c7,$d5,$c7,$d8,$c7,$06,$c8,$09,$c8
	.byt $0c,$c8,$0f,$c8,$5d,$c7,$62,$c7,$67,$c7,$6c,$c7,$a8,$c7,$ab,$c7
	.byt $ae,$c7,$b1,$c7,$6c,$cd,$75,$cf,$45,$cf,$06,$cf,$14,$cf,$31,$ff
	.byt $bf,$c6,$f0,$d0,$69,$ce,$97,$ce,$89,$ce,$dc,$ce,$f0,$cf,$56,$c7
	.byt $49,$e7,$00,$00,$ef,$cd,$39,$ce,$54,$ce,$9b,$f4,$e0,$cb,$35,$e4
	.byt $b0,$e6,$80,$e6,$40,$d1,$11,$d7,$37,$e5,$6c,$e6,$1e,$de,$20,$de
	.byt $fb,$de,$54,$de,$5c,$de,$f7,$fe,$42,$d4,$f1,$d4,$55,$ca,$65,$ca
	.byt $69,$ca,$00,$00,$e9,$d9,$1a,$da,$d8,$dd,$0d,$eb,$73,$eb,$5a,$eb
	.byt $ec,$eb,$df,$eb,$72,$da,$e4,$da,$b9,$e1,$09,$e2,$50,$e2,$00,$00
	.byt $00,$00,$00,$00,$03,$d9,$1f,$d8,$4c,$ff,$00,$00,$1d,$c5,$18,$c5
	.byt $0f,$c5,$0c,$c5,$07,$c5,$ea,$c4,$b1,$cf,$00,$00,$9a,$ed,$77,$ed
	.byt $e5,$ed,$ca,$ed,$fc,$ed,$d7,$ed,$a5,$ee,$4a,$ef,$20,$ef,$3f,$ef
	.byt $7a,$ef,$85,$ef,$a5,$f4,$1e,$f9,$b2,$ef,$9b,$ef,$8b,$f1,$8a,$f2
	.byt $1a,$f6,$53,$f6,$8e,$f7,$81,$f7,$0a,$f8,$35,$f8,$8c,$f6,$46,$f1
	.byt $6f,$f2,$35,$f7,$10,$f6,$b6,$f8,$aa,$f8,$6a,$f4,$14,$f3,$71,$f7
	.byt $87,$f3,$77,$f3,$ed,$f3,$23,$f3,$a6,$f3,$52,$f3,$96,$f3,$cd,$f8
	.byt $12,$fa,$00,$00,$e7,$e7,$d9,$e7,$c1,$e7,$cd,$e7,$92,$e7,$66,$e8
	.byt $85,$e8,$cb,$e9,$2f,$e9,$3c,$e9,$5d,$e9,$5f,$e9,$19,$e8,$2c,$e8
	.byt $73,$ea,$af,$ea,$93,$ea,$00,$00,$00,$00,$00,$00,$e5,$eb,$d9,$eb
	.byt $84,$60,$85,$66,$86,$63,$a2,$00,$20,$1e,$de,$a4,$62,$a6,$66,$2c
	.byt $e8,$c8,$20,$f9,$cc,$30,$04,$c4,$63,$d0,$f5,$86,$67,$a6,$60,$38
	.byt $8a,$e5,$66,$18,$65,$62,$a8,$20,$d3,$cc,$20,$06,$c8,$48,$2c,$0d
	.byt $02,$50,$0d,$a9,$08,$20,$5d,$c7,$a9,$20,$20,$5d,$c7,$4c,$2e,$cc
	.byt $a4,$61,$a6,$65,$b1,$26,$29,$7f,$91,$26,$c8,$ca,$d0,$f6,$68,$c9
	.byt $20,$f0,$08,$c9,$1b,$f0,$04,$c9,$0d,$d0,$03,$a6,$60,$60,$c9,$0a
	.byt $d0,$2b,$a5,$60,$c5,$67,$f0,$05,$e6,$60,$4c,$fd,$cb,$24,$68,$30
	.byt $ac,$e6,$60,$e6,$67,$e6,$66,$2c,$0d,$02,$70,$8f,$a6,$62,$a4,$63
	.byt $20,$54,$de,$a4,$63,$a6,$60,$20,$f9,$cc,$4c,$fd,$cb,$c9,$0b,$d0
	.byt $29,$a5,$60,$c5,$66,$d0,$1b,$a5,$60,$f0,$19,$c6,$66,$c6,$67,$c6
	.byt $60,$2c,$0d,$02,$70,$11,$a6,$62,$a4,$63,$20,$5c,$de,$a4,$62,$4c
	.byt $65,$cc,$c6,$60,$4c,$fd,$cb,$4c,$eb,$cb,$c9,$30,$90,$f6,$c9,$3a
	.byt $b0,$f2,$a6,$60,$e0,$19,$90,$06,$a6,$66,$86,$60,$b0,$e6,$48,$06
	.byt $60,$a5,$60,$06,$60,$06,$60,$65,$60,$85,$60,$68,$29,$0f,$65,$60
	.byt $e9,$00,$85,$60,$90,$e2,$c5,$66,$90,$de,$c5,$67,$f0,$02,$b0,$d8
	.byt $4c,$fd,$cb,$20,$5a,$cd,$2c,$0d,$02,$50,$0f,$a2,$02,$a9,$09,$20
	.byt $5d,$c7,$ca,$10,$f8,$a9,$2d,$4c,$5d,$c7,$a4,$61,$a6,$65,$b1,$26
	.byt $09,$80,$91,$26,$c8,$ca,$d0,$f6,$60,$98,$48,$8a,$48,$48,$20,$5a
	.byt $cd,$e8,$a5,$69,$a4,$6a,$85,$15,$84,$16,$a0,$00,$ca,$f0,$11,$c8
	.byt $d0,$02,$e6,$16,$20,$11,$04,$d0,$f6,$c8,$d0,$f0,$e6,$16,$d0,$ec
	.byt $a6,$16,$18,$98,$65,$15,$90,$01,$e8,$85,$02,$86,$03,$a9,$20,$85
	.byt $14,$68,$18,$69,$01,$a0,$00,$a2,$01,$20,$39,$ce,$a9,$20,$20,$5d
	.byt $c7,$a5,$02,$a4,$03,$20,$a8,$c7,$a0,$01,$20,$11,$04,$38,$f0,$01
	.byt $18,$66,$68,$68,$aa,$68,$a8,$24,$68,$60,$a9,$1f,$20,$5d,$c7,$98
	.byt $09,$40,$20,$5d,$c7,$a5,$61,$09,$40,$4c,$5d,$c7,$48,$8a,$48,$98
	.byt $48,$38,$a5,$06,$e5,$04,$a8,$a5,$07,$e5,$05,$aa,$90,$3b,$86,$0b
	.byt $a5,$08,$c5,$04,$a5,$09,$e5,$05,$b0,$35,$98,$49,$ff,$69,$01,$a8
	.byt $85,$0a,$90,$03,$ca,$e6,$07,$38,$a5,$08,$e5,$0a,$85,$08,$b0,$02
	.byt $c6,$09,$18,$a5,$07,$e5,$0b,$85,$07,$e8,$b1,$06,$91,$08,$c8,$d0
	.byt $f9,$e6,$07,$e6,$09,$ca,$d0,$f2,$38,$68,$a8,$68,$aa,$68,$60,$8a
	.byt $18,$65,$05,$85,$05,$8a,$18,$65,$09,$85,$09,$e8,$88,$b1,$04,$91
	.byt $08,$98,$d0,$f8,$c6,$05,$c6,$09,$ca,$d0,$f1,$f0,$db,$0a,$64,$e8
	.byt $10,$00,$00,$03,$27,$a2,$00,$a0,$00,$2c,$a2,$03,$2c,$a2,$02,$85
	.byt $0d,$84,$0e,$a9,$00,$85,$0f,$85,$10,$a9,$ff,$85,$0c,$e6,$0c,$38
	.byt $a5,$0d,$a8,$fd,$dd,$cd,$85,$0d,$a5,$0e,$48,$fd,$e1,$cd,$85,$0e
	.byt $68,$b0,$ea,$84,$0d,$85,$0e,$a5,$0c,$f0,$04,$85,$0f,$d0,$07,$a4
	.byt $0f,$d0,$03,$a5,$14,$2c,$09,$30,$20,$32,$ce,$ca,$10,$cb,$a5,$0d
	.byt $09,$30,$a4,$10,$91,$11,$e6,$10,$60,$48,$a9,$00,$85,$11,$a9,$01
	.byt $85,$12,$68,$20,$ef,$cd,$a0,$00,$b9,$00,$01,$20,$5d,$c7,$c8,$c4
	.byt $10,$d0,$f5,$60,$48,$29,$0f,$20,$60,$ce,$a8,$68,$4a,$4a,$4a,$4a
	.byt $09,$30,$c9,$3a,$90,$02,$69,$06,$60,$a0,$00,$85,$00,$84,$01,$0a
	.byt $26,$01,$0a,$26,$01,$65,$00,$90,$02,$e6,$01,$0a,$26,$01,$0a,$26
	.byt $01,$0a,$26,$01,$85,$00,$a4,$01,$60,$18,$65,$00,$85,$00,$48,$98
	.byt $65,$01,$85,$01,$a8,$68,$60,$85,$10,$84,$11,$a2,$00,$86,$0c,$86
	.byt $0d,$86,$0e,$86,$0f,$86,$02,$86,$03,$a2,$10,$46,$11,$66,$10,$90
	.byt $19,$18,$a5,$00,$65,$0c,$85,$0c,$a5,$01,$65,$0d,$85,$0d,$a5,$02
	.byt $65,$0e,$85,$0e,$a5,$03,$65,$0f,$85,$0f,$06,$00,$26,$01,$26,$02
	.byt $26,$03,$a5,$10,$05,$11,$f0,$03,$ca,$d0,$d0,$60,$85,$0c,$84,$0d
	.byt $a2,$00,$86,$02,$86,$03,$a2,$10,$06,$00,$26,$01,$26,$02,$26,$03
	.byt $38,$a5,$02,$e5,$0c,$a8,$a5,$03,$e5,$0d,$90,$06,$84,$02,$85,$03
	.byt $e6,$00,$ca,$d0,$e3,$60,$a9,$00,$a0,$a0,$85,$00,$84,$01,$a0,$68
	.byt $a2,$bf,$a9,$40,$48,$38,$98,$e5,$00,$a8,$8a,$e5,$01,$aa,$84,$02
	.byt $68,$a0,$00,$c4,$02,$b0,$05,$91,$00,$c8,$d0,$f7,$48,$98,$a0,$00
	.byt $20,$89,$ce,$68,$e0,$00,$f0,$0c,$a0,$00,$91,$00,$c8,$d0,$fb,$e6
	.byt $01,$ca,$d0,$f6,$60,$a2,$00,$a0,$ff,$8c,$aa,$02,$c8,$20,$f3,$e7
	.byt $ad,$0d,$02,$30,$b1,$09,$80,$8d,$0d,$02,$08,$78,$a9,$1f,$8d,$67
	.byt $bf,$20,$a4,$cf,$20,$d8,$fe,$a9,$5c,$a0,$02,$a2,$00,$20,$fd,$de
	.byt $20,$06,$cf,$28,$60,$ad,$0d,$02,$10,$29,$08,$78,$29,$7f,$8d,$0d
	.byt $02,$20,$db,$fe,$a9,$56,$a0,$02,$a2,$00,$20,$fd,$de,$a9,$1a,$8d
	.byt $df,$bf,$20,$a4,$cf,$a2,$28,$a9,$20,$9d,$7f,$bb,$ca,$d0,$fa,$20
	.byt $20,$de,$28,$60,$a0,$1f,$a2,$00,$ca,$d0,$fd,$88,$d0,$fa,$60,$38
	.byt $24,$18,$66,$15,$a2,$00,$20,$0f,$c5,$90,$08,$8a,$69,$0b,$aa,$e0
	.byt $30,$d0,$f3,$08,$a9,$dc,$a0,$cf,$b0,$04,$a9,$e6,$a0,$cf,$24,$15
	.byt $10,$05,$20,$f9,$fe,$28,$60,$20,$f9,$fe,$28,$60,$7f,$00,$00,$08
	.byt $3c,$3e,$3c,$08,$00,$00,$7f,$00,$00,$08,$34,$32,$34,$08,$00,$00
	.byt $85,$15,$84,$16,$86,$00,$e6,$00,$ac,$0c,$02,$8c,$17,$05,$8c,$00
	.byt $05,$a0,$0c,$a9,$3f,$99,$17,$05,$88,$d0,$fa,$8a,$f0,$3b,$e0,$01
	.byt $d0,$22,$20,$df,$d0,$38,$e9,$41,$c9,$04,$b0,$40,$8d,$17,$05,$8d
	.byt $00,$05,$a2,$01,$a0,$0c,$a9,$3f,$d9,$17,$05,$f0,$05,$88,$d0,$f8
	.byt $18,$60,$38,$60,$a0,$01,$20,$df,$d0,$c9,$2d,$d0,$1f,$a0,$00,$20
	.byt $df,$d0,$38,$e9,$41,$b0,$03,$a2,$81,$60,$c9,$04,$b0,$f9,$e0,$02
	.byt $d0,$04,$8d,$0c,$02,$60,$8d,$17,$05,$a0,$02,$2c,$a0,$00,$a2,$00
	.byt $20,$df,$d0,$b0,$1d,$c9,$2e,$f0,$19,$c9,$2a,$f0,$22,$20,$fb,$d0
	.byt $90,$06,$a2,$80,$60,$a2,$82,$60,$e0,$09,$f0,$f9,$9d,$18,$05,$e8
	.byt $d0,$de,$a9,$20,$e0,$09,$f0,$06,$9d,$18,$05,$e8,$d0,$f6,$88,$a2
	.byt $00,$20,$df,$d0,$90,$0e,$a0,$02,$b9,$5d,$05,$99,$21,$05,$88,$10
	.byt $f7,$4c,$22,$d0,$c9,$2e,$d0,$ca,$20,$df,$d0,$b0,$e1,$88,$20,$df
	.byt $d0,$90,$0e,$a9,$20,$e0,$03,$f0,$e8,$9d,$21,$05,$e8,$d0,$f6,$f0
	.byt $e0,$c9,$2a,$d0,$08,$20,$df,$d0,$b0,$d7,$a2,$83,$60,$20,$fb,$d0
	.byt $b0,$a0,$e0,$03,$f0,$06,$9d,$21,$05,$e8,$d0,$d2,$a2,$84,$60,$20
	.byt $11,$04,$20,$f0,$d0,$c8,$c4,$00,$b0,$05,$c9,$20,$f0,$f1,$18,$60
	.byt $c9,$61,$90,$06,$c9,$7b,$b0,$02,$e9,$1f,$60,$c9,$3f,$f0,$0e,$c9
	.byt $30,$90,$0c,$c9,$3a,$90,$06,$c9,$41,$90,$04,$c9,$5b,$18,$60,$38
	.byt $60,$a0,$00,$a9,$90,$84,$00,$85,$01,$a2,$94,$a9,$00,$20,$14,$cf
	.byt $a0,$00,$a9,$94,$84,$00,$85,$01,$a2,$98,$a9,$87,$20,$14,$cf,$a0
	.byt $00,$a9,$a0,$84,$00,$85,$01,$a0,$3f,$a2,$bf,$a9,$10,$4c,$14,$cf
	.byt $a5,$39,$20,$69,$ce,$48,$98,$48,$a9,$00,$a0,$90,$20,$89,$ce,$85
	.byt $2e,$84,$2f,$85,$30,$c8,$c8,$c8,$c8,$84,$31,$68,$85,$01,$68,$0a
	.byt $26,$01,$0a,$26,$01,$0a,$26,$01,$85,$00,$a9,$00,$a0,$a0,$20,$89
	.byt $ce,$85,$2c,$84,$2d,$4c,$56,$d7,$85,$3e,$98,$48,$8a,$48,$a5,$39
	.byt $f0,$08,$8d,$81,$02,$a5,$38,$8d,$80,$02,$24,$3c,$30,$5f,$a5,$3e
	.byt $20,$42,$d4,$85,$00,$f0,$4f,$c9,$20,$90,$58,$c9,$a0,$b0,$42,$8d
	.byt $85,$02,$29,$7f,$aa,$a5,$34,$30,$12,$a4,$38,$c0,$27,$d0,$02,$29
	.byt $df,$a4,$39,$c0,$02,$b0,$04,$29,$ef,$85,$34,$48,$20,$30,$d5,$20
	.byt $dc,$d5,$68,$48,$30,$0a,$29,$20,$f0,$06,$20,$91,$d3,$20,$59,$d7
	.byt $20,$91,$d3,$68,$30,$0b,$a6,$38,$d0,$07,$29,$10,$f0,$03,$20,$a0
	.byt $d3,$ad,$85,$02,$85,$00,$68,$aa,$68,$a8,$a5,$00,$60,$20,$2e,$d2
	.byt $4c,$e6,$d1,$20,$f9,$d1,$4c,$e6,$d1,$aa,$18,$bd,$0b,$d2,$69,$7e
	.byt $85,$00,$a9,$d3,$69,$00,$85,$01,$6c,$00,$00,$00,$00,$00,$00,$00
	.byt $00,$00,$01,$04,$10,$22,$44,$53,$59,$63,$76,$00,$7d,$b3,$b6,$80
	.byt $00,$b9,$00,$83,$b9,$00,$bc,$00,$00,$a7,$bf,$4c,$b7,$d2,$a5,$3c
	.byt $29,$03,$85,$36,$a5,$3c,$0a,$30,$f2,$0a,$0a,$30,$11,$a5,$3e,$29
	.byt $3f,$aa,$46,$3c,$ad,$85,$02,$20,$78,$d1,$ca,$d0,$f7,$60,$a5,$36
	.byt $f0,$1d,$a5,$3e,$c9,$30,$90,$12,$c9,$59,$b0,$0e,$8d,$82,$02,$c6
	.byt $3c,$a9,$07,$85,$34,$a9,$00,$85,$32,$60,$46,$3c,$4c,$78,$d1,$46
	.byt $3c,$a5,$3e,$c9,$30,$90,$f3,$c9,$69,$b0,$ef,$29,$3f,$8d,$83,$02
	.byt $a5,$3e,$c9,$40,$b0,$1d,$ad,$82,$02,$29,$03,$0a,$0a,$6d,$82,$02
	.byt $e9,$2f,$0a,$6d,$83,$02,$e9,$2f,$85,$39,$20,$d7,$d3,$20,$59,$d7
	.byt $4c,$40,$d1,$20,$59,$d7,$ad,$83,$02,$85,$38,$c6,$38,$ad,$82,$02
	.byt $29,$3f,$85,$39,$4c,$40,$d1,$a6,$36,$a5,$3e,$e0,$03,$d0,$22,$8d
	.byt $82,$02,$a2,$00,$86,$35,$c9,$36,$f0,$0d,$c9,$39,$90,$22,$c9,$3c
	.byt $b0,$1e,$29,$03,$e9,$00,$2c,$a9,$00,$09,$c0,$85,$3c,$60,$46,$3c
	.byt $60,$e6,$35,$a6,$35,$9d,$81,$02,$c6,$3c,$c6,$36,$10,$ef,$30,$ee
	.byt $c9,$40,$90,$e9,$46,$3c,$c9,$48,$b0,$0d,$29,$07,$85,$36,$a5,$34
	.byt $29,$f8,$05,$36,$85,$34,$60,$c9,$4a,$b0,$0c,$4a,$a5,$34,$29,$f7
	.byt $b0,$02,$09,$08,$85,$34,$60,$c9,$4c,$90,$2f,$c9,$50,$b0,$11,$29
	.byt $03,$0a,$0a,$0a,$0a,$85,$36,$a5,$34,$29,$cf,$05,$36,$85,$34,$60
	.byt $c9,$58,$b0,$17,$29,$07,$0a,$0a,$0a,$0a,$85,$36,$a5,$32,$29,$84
	.byt $05,$36,$24,$34,$30,$02,$09,$80,$85,$32,$60,$d0,$00,$c9,$5b,$b0
	.byt $1b,$4a,$24,$34,$10,$09,$a9,$00,$90,$02,$a9,$40,$85,$33,$60,$a5
	.byt $32,$29,$70,$b0,$02,$09,$04,$09,$80,$85,$32,$60,$f0,$fd,$c9,$5e
	.byt $b0,$0c,$4a,$a5,$34,$29,$bf,$90,$02,$09,$40,$85,$34,$60,$60,$4c
	.byt $d8,$dd,$20,$59,$d7,$a5,$38,$f0,$35,$c6,$38,$4c,$56,$d7,$20,$59
	.byt $d7,$e6,$38,$a5,$38,$c9,$28,$90,$f2,$a5,$39,$f0,$ec,$20,$d7,$d3
	.byt $20,$59,$d7,$a6,$39,$f0,$0c,$e0,$18,$d0,$02,$a2,$00,$e8,$86,$39
	.byt $4c,$40,$d1,$ad,$80,$02,$ae,$81,$02,$85,$38,$4c,$ae,$d3,$a9,$27
	.byt $85,$38,$20,$59,$d7,$a6,$39,$ca,$d0,$02,$a2,$18,$86,$39,$4c,$40
	.byt $d1,$20,$11,$d1,$4c,$25,$d4,$20,$59,$d7,$a9,$00,$85,$38,$4c,$56
	.byt $d7,$a9,$40,$85,$33,$a5,$32,$29,$74,$85,$32,$a5,$34,$29,$0f,$09
	.byt $80,$85,$34,$60,$a5,$34,$29,$0f,$85,$34,$60,$4c,$4f,$d7,$4c,$4d
	.byt $d7,$a5,$38,$48,$a5,$39,$48,$a9,$20,$20,$78,$d1,$a5,$38,$f0,$09
	.byt $c9,$27,$d0,$f3,$a9,$20,$20,$78,$d1,$20,$59,$d7,$68,$85,$39,$68
	.byt $85,$38,$4c,$40,$d1,$20,$d7,$d3,$20,$61,$d2,$20,$59,$d7,$4c,$ab
	.byt $d3,$a9,$89,$2c,$a9,$84,$2c,$a9,$a1,$2c,$a9,$c3,$2c,$a9,$91,$85
	.byt $3c,$60,$a4,$37,$24,$37,$08,$a2,$00,$86,$37,$28,$30,$1c,$70,$16
	.byt $c9,$13,$f0,$0b,$c9,$19,$f0,$04,$c9,$16,$d0,$09,$a9,$80,$2c,$a9
	.byt $40,$85,$37,$a9,$00,$60,$18,$69,$5f,$60,$70,$1e,$a2,$14,$dd,$a7
	.byt $d4,$f0,$06,$ca,$10,$f8,$a9,$5f,$60,$e0,$05,$b0,$08,$8a,$09,$c0
	.byt $85,$37,$a9,$00,$60,$29,$1f,$09,$80,$60,$48,$98,$29,$07,$aa,$bd
	.byt $c1,$d4,$a8,$bd,$bc,$d4,$aa,$68,$dd,$c6,$d4,$f0,$06,$e8,$88,$d0
	.byt $f7,$aa,$60,$bd,$de,$d4,$60,$41,$42,$43,$48,$4b,$20,$23,$24,$26
	.byt $2c,$2d,$2e,$2f,$30,$31,$38,$3c,$3d,$3e,$6a,$7a,$00,$05,$07,$0e
	.byt $11,$05,$02,$07,$03,$02,$41,$61,$45,$65,$75,$45,$65,$41,$61,$45
	.byt $65,$75,$69,$6f,$45,$65,$69,$43,$63,$41,$42,$43,$48,$4b,$87,$97
	.byt $89,$99,$88,$82,$92,$81,$86,$8b,$9b,$96,$80,$9f,$84,$93,$94,$85
	.byt $95,$a2,$00,$c9,$a0,$90,$05,$e9,$5f,$a0,$13,$60,$a8,$30,$04,$a8
	.byt $a9,$00,$60,$a0,$12,$d9,$de,$d4,$f0,$13,$88,$10,$f8,$18,$69,$a0
	.byt $c9,$2a,$f0,$04,$c9,$3a,$d0,$02,$09,$40,$a0,$19,$60,$98,$a2,$04
	.byt $dd,$bc,$d4,$b0,$03,$ca,$d0,$f8,$bd,$d9,$d4,$be,$c6,$d4,$d0,$ea
	.byt $85,$36,$06,$36,$06,$36,$a8,$10,$26,$48,$8a,$c9,$60,$90,$02,$e9
	.byt $20,$38,$e9,$20,$85,$36,$a5,$33,$29,$40,$05,$36,$aa,$a5,$32,$29
	.byt $70,$85,$36,$68,$29,$8f,$05,$36,$a4,$38,$84,$36,$4c,$af,$d5,$e0
	.byt $20,$d0,$2b,$24,$32,$10,$27,$29,$70,$85,$35,$a5,$32,$29,$04,$09
	.byt $80,$05,$35,$aa,$a5,$32,$29,$74,$85,$32,$29,$70,$85,$35,$4a,$4a
	.byt $4a,$4a,$24,$34,$50,$04,$a5,$34,$29,$07,$05,$35,$09,$80,$24,$36
	.byt $50,$13,$c6,$2f,$c6,$31,$48,$38,$a5,$38,$e9,$28,$a8,$68,$20,$a7
	.byt $d5,$e6,$2f,$e6,$31,$a4,$38,$20,$af,$d5,$24,$36,$10,$08,$c8,$48
	.byt $8a,$91,$2e,$68,$91,$30,$60,$20,$75,$cf,$4c,$4d,$d7,$a9,$00,$85
	.byt $3c,$85,$3d,$85,$37,$60,$10,$11,$b0,$ed,$20,$45,$cf,$20,$bd,$d5
	.byt $a9,$96,$a0,$d7,$20,$f9,$fe,$a9,$0c,$4c,$78,$d1,$46,$3d,$08,$26
	.byt $3d,$28,$b0,$2b,$a4,$38,$f0,$27,$48,$8a,$48,$88,$b1,$2e,$30,$1b
	.byt $aa,$b1,$30,$30,$06,$e0,$20,$d0,$12,$f0,$05,$8a,$29,$3f,$d0,$0b
	.byt $a5,$34,$29,$07,$c6,$38,$20,$48,$d6,$e6,$38,$68,$aa,$68,$18,$a8
	.byt $10,$41,$8a,$30,$25,$a0,$00,$a9,$9c,$84,$00,$85,$01,$8a,$85,$03
	.byt $20,$b2,$fe,$a2,$07,$bd,$00,$9c,$24,$03,$70,$03,$3d,$09,$d7,$09
	.byt $40,$9d,$00,$9c,$ca,$10,$ee,$4c,$b0,$d6,$a9,$00,$b0,$02,$a5,$32
	.byt $4a,$4a,$4a,$4a,$29,$07,$09,$10,$a2,$0f,$9d,$00,$9c,$ca,$10,$fa
	.byt $4c,$9f,$d6,$8a,$a2,$13,$86,$03,$0a,$26,$03,$0a,$26,$03,$0a,$26
	.byt $03,$85,$02,$a0,$07,$b1,$02,$09,$40,$99,$00,$9c,$88,$10,$f6,$a4
	.byt $38,$b1,$2e,$10,$06,$29,$04,$d0,$07,$f0,$0a,$88,$10,$f3,$30,$05
	.byt $a9,$3f,$8d,$07,$9c,$24,$36,$10,$16,$a2,$07,$bd,$00,$9c,$85,$02
	.byt $20,$f5,$d6,$9d,$08,$9c,$20,$f5,$d6,$9d,$00,$9c,$ca,$10,$ec,$24
	.byt $34,$50,$0d,$a0,$0f,$b9,$00,$9c,$09,$80,$99,$00,$9c,$88,$10,$f5
	.byt $a5,$2c,$a4,$2d,$24,$36,$50,$07,$38,$e9,$40,$88,$b0,$01,$88,$85
	.byt $00,$84,$01,$a2,$00,$46,$03,$a4,$38,$bd,$00,$9c,$91,$00,$24,$36
	.byt $10,$06,$bd,$08,$9c,$c8,$91,$00,$18,$a5,$00,$69,$28,$85,$00,$90
	.byt $02,$e6,$01,$24,$36,$50,$08,$a5,$03,$49,$80,$85,$03,$30,$d8,$e8
	.byt $e0,$08,$d0,$d3,$60,$a9,$00,$a0,$03,$46,$02,$08,$6a,$28,$6a,$88
	.byt $d0,$f7,$4a,$4a,$29,$3f,$09,$40,$60,$1b,$1b,$00,$1b,$00,$1b,$1b
	.byt $00,$a9,$00,$a2,$03,$a4,$3b,$f0,$09,$ca,$a9,$03,$88,$f0,$03,$e8
	.byt $a9,$05,$20,$69,$ce,$a5,$2c,$a4,$2d,$20,$89,$ce,$a9,$38,$a4,$3a
	.byt $f0,$02,$a9,$07,$85,$02,$a4,$38,$b1,$00,$0a,$30,$02,$a9,$80,$6a
	.byt $45,$02,$91,$00,$98,$18,$69,$28,$a8,$ca,$d0,$ec,$60,$18,$24,$38
	.byt $08,$06,$3d,$28,$66,$3d,$a9,$80,$2c,$a9,$00,$25,$3d,$24,$3d,$50
	.byt $02,$a9,$00,$85,$02,$a5,$2c,$a4,$2d,$85,$00,$84,$01,$a4,$38,$b1
	.byt $30,$30,$0a,$29,$40,$f0,$06,$a5,$02,$49,$80,$85,$02,$a2,$08,$a4
	.byt $38,$b1,$00,$29,$7f,$05,$02,$91,$00,$18,$98,$69,$28,$a8,$90,$02
	.byt $e6,$01,$ca,$d0,$ec,$60,$2f,$01,$02,$04,$04,$08,$08,$10,$20,$5c
	.byt $20,$10,$08,$08,$04,$04,$02,$01,$5f,$00,$00,$00,$00,$00,$00,$00
	.byt $3f,$60,$00,$00,$00,$3f,$00,$00,$00,$00,$7b,$20,$20,$20,$20,$20
	.byt $20,$20,$20,$7c,$08,$08,$08,$08,$08,$08,$08,$08,$7d,$01,$01,$01
	.byt $01,$01,$01,$01,$01,$7e,$3f,$00,$00,$00,$00,$00,$00,$00,$00,$20
	.byt $03,$d9,$f0,$2e,$ae,$70,$02,$10,$08,$ad,$71,$02,$3d,$e8,$01,$d0
	.byt $16,$88,$b9,$68,$02,$8d,$71,$02,$98,$09,$80,$8d,$70,$02,$20,$1f
	.byt $d8,$ad,$72,$02,$4c,$18,$d8,$ce,$74,$02,$d0,$0f,$20,$1f,$d8,$4c
	.byt $15,$d8,$8d,$70,$02,$ad,$73,$02,$8d,$74,$02,$60,$4c,$dd,$d8,$20
	.byt $bf,$c8,$a9,$00,$48,$ad,$70,$02,$0a,$0a,$0a,$a8,$ad,$71,$02,$4a
	.byt $b0,$03,$c8,$90,$fa,$ad,$6c,$02,$aa,$29,$90,$f0,$08,$68,$09,$01
	.byt $48,$98,$69,$3f,$a8,$98,$c9,$20,$90,$09,$e9,$08,$c9,$58,$90,$02
	.byt $e9,$08,$a8,$8a,$29,$20,$d0,$c4,$b1,$2a,$2c,$75,$02,$10,$0a,$c9
	.byt $61,$90,$06,$c9,$7b,$b0,$02,$e9,$1f,$a8,$8a,$29,$04,$f0,$12,$2d
	.byt $6f,$02,$f0,$05,$a9,$80,$8d,$7e,$02,$68,$09,$80,$48,$98,$29,$1f
	.byt $a8,$98,$a2,$00,$48,$c9,$06,$d0,$07,$ad,$75,$02,$49,$40,$b0,$23
	.byt $c9,$14,$f0,$1a,$c9,$17,$d0,$07,$ad,$75,$02,$49,$20,$b0,$14,$c9
	.byt $1b,$d0,$13,$ad,$75,$02,$29,$20,$f0,$0c,$68,$a9,$00,$48,$ad,$75
	.byt $02,$49,$80,$8d,$75,$02,$68,$a2,$00,$20,$1d,$c5,$68,$a2,$00,$20
	.byt $1d,$c5,$2c,$75,$02,$50,$07,$a2,$cf,$a0,$d8,$4c,$e7,$d9,$60,$1f
	.byt $00,$00,$00,$00,$00,$00,$3e,$10,$00,$00,$1f,$00,$00,$b1,$2a,$c9
	.byt $2d,$f0,$15,$c9,$3d,$f0,$14,$68,$09,$40,$48,$ad,$75,$02,$4a,$b0
	.byt $0f,$b1,$2a,$29,$1f,$09,$80,$2c,$a9,$60,$2c,$a9,$7e,$4c,$82,$d8
	.byt $6c,$76,$02,$a0,$07,$a9,$7f,$48,$aa,$a9,$0e,$20,$1a,$da,$a9,$00
	.byt $99,$68,$02,$20,$bf,$c8,$ad,$00,$03,$29,$b8,$aa,$18,$69,$08,$85
	.byt $1f,$8e,$00,$03,$e8,$a9,$08,$2d,$00,$03,$d0,$06,$e4,$1f,$d0,$f1
	.byt $f0,$14,$ca,$8a,$48,$29,$07,$aa,$bd,$a9,$d9,$19,$68,$02,$99,$68
	.byt $02,$68,$aa,$e8,$d0,$e6,$68,$38,$6a,$88,$10,$bb,$a0,$08,$b9,$67
	.byt $02,$d0,$08,$c0,$06,$d0,$01,$88,$88,$d0,$f3,$60,$30,$27,$a9,$01
	.byt $8d,$a8,$02,$8d,$a6,$02,$08,$78,$a2,$00,$20,$18,$c5,$b0,$13,$8d
	.byt $79,$02,$a2,$00,$20,$18,$c5,$b0,$09,$8d,$78,$02,$ad,$79,$02,$28
	.byt $18,$60,$28,$38,$60,$90,$06,$a9,$40,$8d,$0e,$03,$60,$ad,$0b,$03
	.byt $09,$40,$8d,$0b,$03,$a9,$a8,$a0,$61,$8d,$04,$03,$8c,$05,$03,$a9
	.byt $c0,$8d,$0e,$03,$a2,$00,$4c,$0c,$c5,$01,$02,$04,$08,$10,$20,$40
	.byt $80,$a9,$ff,$8d,$03,$03,$8d,$a7,$02,$a9,$f7,$8d,$02,$03,$a9,$01
	.byt $8d,$73,$02,$8d,$74,$02,$8d,$a8,$02,$8d,$a6,$02,$a9,$0e,$8d,$72
	.byt $02,$a9,$3f,$a0,$fa,$85,$2a,$84,$2b,$4e,$70,$02,$a9,$c0,$8d,$75
	.byt $02,$a9,$00,$8d,$7e,$02,$60,$18,$24,$38,$08,$78,$a5,$16,$48,$a5
	.byt $15,$48,$86,$15,$84,$16,$08,$a0,$00,$28,$08,$b0,$04,$b1,$15,$90
	.byt $03,$20,$11,$04,$aa,$98,$48,$20,$1a,$da,$68,$a8,$c8,$c0,$0e,$d0
	.byt $e8,$28,$68,$85,$15,$68,$85,$16,$28,$60,$48,$8d,$0f,$03,$c9,$07
	.byt $d0,$04,$8a,$09,$40,$aa,$98,$48,$08,$78,$ad,$0c,$03,$29,$11,$a8
	.byt $09,$ee,$8d,$0c,$03,$98,$09,$cc,$8d,$0c,$03,$8e,$0f,$03,$98,$09
	.byt $ec,$8d,$0c,$03,$98,$09,$cc,$8d,$0c,$03,$28,$68,$a8,$68,$60,$a9
	.byt $07,$a2,$7f,$4c,$1a,$da,$a9,$50,$8d,$88,$02,$a9,$00,$8d,$86,$02
	.byt $a9,$80,$8d,$8a,$02,$a9,$53,$a0,$e2,$8d,$50,$02,$8c,$51,$02,$60
	.byt $30,$60,$48,$8a,$48,$a9,$82,$8d,$0e,$03,$ba,$bd,$02,$01,$20,$a5
	.byt $da,$2c,$8a,$02,$70,$1b,$c9,$20,$b0,$06,$c9,$0d,$d0,$13,$f0,$0c
	.byt $ae,$86,$02,$e8,$ec,$88,$02,$90,$05,$20,$e4,$da,$a2,$00,$8e,$86
	.byt $02,$68,$aa,$68,$60,$aa,$ad,$8a,$02,$29,$04,$f0,$08,$20,$2f,$db
	.byt $8a,$a2,$18,$d0,$0a,$ad,$0d,$02,$29,$02,$f0,$15,$8a,$a2,$24,$2c
	.byt $8a,$02,$70,$06,$c9,$7f,$d0,$02,$a9,$20,$48,$20,$1d,$c5,$68,$b0
	.byt $ee,$60,$b0,$0c,$ad,$8a,$02,$29,$04,$d0,$06,$a9,$82,$8d,$0e,$03
	.byt $60,$4c,$7d,$db,$48,$a9,$0d,$20,$72,$da,$ad,$8a,$02,$4a,$b0,$05
	.byt $a9,$0a,$20,$72,$da,$68,$60,$30,$05,$a2,$0c,$4c,$18,$c5,$b0,$09
	.byt $ad,$1e,$03,$29,$0d,$09,$60,$d0,$3a,$ad,$1e,$03,$09,$02,$8d,$1e
	.byt $03,$60,$30,$26,$aa,$10,$0f,$c9,$c0,$b0,$0b,$09,$40,$48,$a9,$1b
	.byt $a2,$18,$20,$1d,$c5,$68,$48,$a2,$18,$20,$1d,$c5,$68,$b0,$f7,$ad
	.byt $1e,$03,$29,$f3,$09,$04,$8d,$1e,$03,$60,$b0,$17,$ad,$1e,$03,$29
	.byt $02,$09,$65,$8d,$1e,$03,$ad,$21,$03,$29,$ef,$8d,$21,$03,$a9,$38
	.byt $8d,$1f,$03,$60,$a9,$1e,$85,$59,$a9,$00,$85,$5a,$60,$10,$98,$b0
	.byt $a8,$ad,$1e,$03,$29,$0d,$05,$5a,$8d,$1e,$03,$ad,$21,$03,$09,$10
	.byt $8d,$21,$03,$a5,$59,$8d,$1f,$03,$60,$10,$ab,$b0,$d6,$ad,$1e,$03
	.byt $29,$02,$09,$05,$d0,$e0,$48,$08,$a9,$00,$f0,$10,$48,$08,$a9,$01
	.byt $d0,$0a,$48,$08,$a9,$02,$d0,$04,$48,$08,$a9,$03,$85,$28,$28,$10
	.byt $03,$4c,$ce,$de,$68,$85,$29,$ad,$8a,$02,$29,$02,$f0,$05,$a5,$29
	.byt $20,$72,$da,$a5,$29,$85,$29,$48,$8a,$48,$98,$48,$a6,$28,$bd,$18
	.byt $02,$85,$26,$bd,$1c,$02,$85,$27,$a5,$29,$c9,$20,$b0,$7e,$bd,$48
	.byt $02,$48,$20,$1e,$de,$a9,$dc,$48,$a9,$2a,$48,$a5,$29,$0a,$a8,$b9
	.byt $ec,$db,$48,$b9,$eb,$db,$48,$a9,$00,$38,$60,$e9,$dc,$ea,$dc,$e9
	.byt $dc,$e9,$dc,$0c,$dd,$e9,$dc,$e9,$dc,$d7,$dd,$46,$dd,$91,$dd,$9c
	.byt $dd,$54,$dd,$b7,$dd,$66,$dd,$73,$dd,$e9,$dc,$11,$dd,$12,$dd,$ce
	.byt $dd,$cb,$dd,$e9,$dc,$e9,$dc,$10,$dd,$e9,$dc,$79,$dd,$e9,$dc,$e9
	.byt $dc,$0e,$dd,$0e,$dd,$0f,$dd,$fa,$dd,$0d,$dd,$a6,$28,$bc,$20,$02
	.byt $b1,$26,$9d,$4c,$02,$a5,$26,$9d,$18,$02,$a5,$27,$9d,$1c,$02,$68
	.byt $9d,$48,$02,$20,$2d,$de,$68,$a8,$68,$aa,$68,$60,$bd,$48,$02,$29
	.byt $0c,$d0,$47,$a5,$29,$10,$06,$c9,$a0,$b0,$02,$29,$7f,$85,$29,$20
	.byt $6b,$dc,$a9,$09,$85,$29,$4c,$ce,$db,$85,$29,$a0,$80,$bd,$48,$02
	.byt $29,$20,$d0,$02,$a0,$00,$98,$05,$29,$9d,$4c,$02,$bc,$20,$02,$91
	.byt $26,$bd,$48,$02,$29,$02,$f0,$11,$bd,$24,$02,$dd,$34,$02,$f0,$09
	.byt $98,$69,$28,$a8,$bd,$4c,$02,$91,$26,$60,$29,$08,$f0,$1a,$a5,$29
	.byt $30,$a4,$c9,$40,$90,$a0,$29,$1f,$20,$69,$dc,$a9,$09,$20,$b5,$db
	.byt $a9,$1b,$20,$b5,$db,$4c,$46,$dc,$bd,$48,$02,$48,$20,$1e,$de,$68
	.byt $48,$4a,$b0,$18,$a5,$29,$29,$3f,$9d,$24,$02,$20,$07,$de,$9d,$18
	.byt $02,$98,$9d,$1c,$02,$68,$09,$01,$48,$4c,$2b,$dc,$a5,$29,$29,$3f
	.byt $9d,$20,$02,$68,$29,$fa,$48,$4c,$2b,$dc,$60,$bd,$20,$02,$29,$f8
	.byt $69,$07,$dd,$2c,$02,$f0,$12,$90,$10,$20,$67,$dd,$20,$9d,$dd,$a6
	.byt $28,$bd,$20,$02,$29,$07,$d0,$e3,$60,$9d,$20,$02,$60,$6a,$6a,$6a
	.byt $6a,$6a,$6a,$6a,$a8,$ba,$5d,$03,$01,$9d,$03,$01,$85,$00,$98,$29
	.byt $10,$d0,$01,$60,$a6,$28,$25,$00,$f0,$12,$fe,$28,$02,$fe,$28,$02
	.byt $bd,$20,$02,$dd,$28,$02,$b0,$03,$4c,$67,$dd,$60,$de,$28,$02,$de
	.byt $28,$02,$60,$de,$20,$02,$60,$bd,$20,$02,$dd,$28,$02,$d0,$f4,$bd
	.byt $2c,$02,$9d,$20,$02,$bd,$24,$02,$dd,$30,$02,$d0,$11,$bd,$30,$02
	.byt $bc,$34,$02,$aa,$20,$5c,$de,$bd,$28,$02,$9d,$20,$02,$60,$de,$24
	.byt $02,$4c,$07,$de,$bc,$28,$02,$4c,$7d,$dd,$bc,$20,$02,$bd,$2c,$02
	.byt $85,$29,$a9,$20,$91,$26,$c8,$c4,$29,$90,$f9,$91,$26,$60,$fe,$20
	.byt $02,$60,$bd,$20,$02,$dd,$2c,$02,$d0,$f4,$20,$67,$dd,$bd,$24,$02
	.byt $dd,$34,$02,$d0,$0d,$bd,$30,$02,$bc,$34,$02,$aa,$20,$54,$de,$4c
	.byt $67,$dd,$fe,$24,$02,$4c,$07,$de,$20,$fb,$dd,$20,$74,$dd,$bd,$24
	.byt $02,$dd,$34,$02,$f0,$35,$20,$9d,$dd,$4c,$bb,$dd,$4c,$b9,$e1,$a9
	.byt $02,$4d,$8a,$02,$8d,$8a,$02,$60,$a2,$f0,$a0,$dd,$20,$e7,$d9,$a0
	.byt $60,$a2,$00,$ca,$d0,$fd,$88,$d0,$fa,$a9,$07,$a2,$3f,$4c,$1a,$da
	.byt $46,$00,$00,$00,$00,$00,$00,$3e,$0f,$00,$00,$bd,$28,$02,$9d,$20
	.byt $02,$bd,$30,$02,$9d,$24,$02,$bd,$24,$02,$20,$12,$de,$85,$26,$84
	.byt $27,$60,$20,$69,$ce,$bd,$38,$02,$bc,$3c,$02,$4c,$89,$ce,$18,$24
	.byt $38,$08,$1e,$48,$02,$28,$7e,$48,$02,$30,$28,$a9,$80,$3d,$48,$02
	.byt $29,$80,$5d,$4c,$02,$bc,$20,$02,$91,$26,$48,$bd,$48,$02,$29,$02
	.byt $f0,$10,$bd,$24,$02,$dd,$34,$02,$f0,$08,$98,$69,$28,$a8,$68,$91
	.byt $26,$60,$68,$60,$a9,$00,$85,$07,$a9,$28,$d0,$06,$a9,$ff,$85,$07
	.byt $a9,$d8,$85,$06,$86,$00,$98,$38,$e5,$00,$48,$8a,$24,$06,$10,$01
	.byt $98,$a6,$28,$20,$12,$de,$18,$7d,$28,$02,$90,$01,$c8,$85,$08,$84
	.byt $09,$18,$65,$06,$85,$04,$98,$65,$07,$85,$05,$68,$85,$00,$f0,$34
	.byt $30,$3b,$38,$a6,$28,$bd,$2c,$02,$fd,$28,$02,$85,$01,$a4,$01,$b1
	.byt $04,$91,$08,$88,$10,$f9,$18,$a5,$04,$65,$06,$85,$04,$a5,$05,$65
	.byt $07,$85,$05,$18,$a5,$08,$65,$06,$85,$08,$a5,$09,$65,$07,$85,$09
	.byt $c6,$00,$d0,$d9,$a4,$01,$a9,$20,$91,$08,$88,$10,$fb,$60,$90,$07
	.byt $a6,$28,$20,$1e,$de,$68,$60,$a9,$01,$8d,$16,$02,$a9,$80,$8d,$17
	.byt $02,$68,$60,$00,$27,$01,$1b,$80,$bb,$00,$27,$00,$02,$68,$bf,$00
	.byt $27,$1a,$1b,$80,$bb,$00,$27,$01,$18,$80,$bb,$38,$24,$18,$08,$85
	.byt $15,$84,$16,$8a,$18,$69,$18,$aa,$a0,$05,$28,$08,$b0,$04,$b1,$15
	.byt $90,$03,$20,$11,$04,$9d,$24,$02,$8a,$38,$e9,$04,$aa,$88,$10,$ea
	.byt $a9,$07,$9d,$40,$02,$a9,$00,$9d,$44,$02,$a9,$00,$9d,$48,$02,$bd
	.byt $28,$02,$9d,$20,$02,$bd,$30,$02,$9d,$24,$02,$bd,$38,$02,$9d,$18
	.byt $02,$bd,$3c,$02,$9d,$1c,$02,$a9,$20,$9d,$4c,$02,$a5,$28,$48,$86
	.byt $28,$a9,$0c,$20,$b5,$db,$68,$85,$28,$28,$60,$a9,$1a,$8d,$df,$bf
	.byt $20,$49,$fe,$a2,$27,$a9,$20,$9d,$80,$bb,$ca,$10,$fa,$a0,$11,$b9
	.byt $e3,$de,$99,$56,$02,$88,$10,$f7,$0e,$0d,$02,$4e,$0d,$02,$a9,$f5
	.byt $a0,$de,$2c,$0d,$02,$70,$04,$a9,$56,$a0,$02,$a2,$00,$4c,$fd,$de
	.byt $ad,$20,$03,$29,$3f,$09,$40,$d0,$07,$ad,$20,$03,$29,$3f,$09,$80
	.byt $8d,$20,$03,$ad,$20,$03,$29,$1f,$60,$38,$60,$a9,$41,$8d,$8c,$02
	.byt $a2,$06,$bd,$f3,$df,$9d,$9d,$02,$ca,$10,$f7,$a9,$01,$8d,$97,$02
	.byt $8d,$9c,$02,$a9,$06,$8d,$98,$02,$8d,$9b,$02,$a9,$01,$8d,$99,$02
	.byt $a9,$0a,$8d,$9a,$02,$a9,$03,$8d,$a4,$02,$8d,$a5,$02,$a9,$10,$a0
	.byt $27,$8d,$8f,$02,$8c,$90,$02,$8d,$08,$03,$8c,$09,$03,$a9,$a0,$8d
	.byt $0e,$03,$60,$0b,$0a,$20,$08,$09,$03,$03,$60,$ad,$8d,$02,$29,$04
	.byt $d0,$12,$20,$90,$df,$29,$04,$d0,$15,$ce,$93,$02,$d0,$29,$ae,$97
	.byt $02,$4c,$1e,$e0,$20,$90,$df,$29,$04,$d0,$1c,$ae,$98,$02,$8e,$93
	.byt $02,$85,$58,$ad,$8d,$02,$29,$1b,$05,$58,$8d,$8d,$02,$a5,$58,$d0
	.byt $06,$ad,$9f,$02,$20,$9f,$e1,$ad,$8d,$02,$29,$1b,$49,$1b,$f0,$1b
	.byt $20,$90,$df,$29,$1b,$85,$58,$ad,$8d,$02,$29,$1b,$45,$58,$d0,$12
	.byt $ce,$91,$02,$d0,$2f,$ae,$97,$02,$4c,$65,$e0,$20,$90,$df,$29,$1b
	.byt $85,$58,$ae,$98,$02,$8e,$91,$02,$ad,$8d,$02,$29,$04,$05,$58,$8d
	.byt $8d,$02,$a2,$04,$09,$04,$4a,$48,$b0,$06,$bd,$9d,$02,$20,$9f,$e1
	.byt $68,$ca,$10,$f2,$60,$20,$99,$df,$29,$1b,$85,$58,$c9,$1b,$d0,$05
	.byt $ce,$a4,$02,$d0,$ef,$ad,$a5,$02,$8d,$a4,$02,$a5,$58,$c9,$1b,$f0
	.byt $14,$29,$1b,$4d,$8e,$02,$29,$1b,$d0,$0b,$ce,$92,$02,$d0,$31,$ae
	.byt $99,$02,$4c,$bb,$e0,$20,$99,$df,$ae,$9a,$02,$8e,$92,$02,$29,$1b
	.byt $85,$58,$ad,$8e,$02,$29,$64,$05,$58,$8d,$8e,$02,$a5,$58,$09,$04
	.byt $a2,$04,$4a,$48,$b0,$06,$bd,$9d,$02,$20,$9d,$e1,$68,$ca,$10,$f2
	.byt $60,$ad,$8e,$02,$29,$04,$d0,$12,$20,$99,$df,$29,$04,$d0,$13,$ce
	.byt $94,$02,$d0,$27,$ae,$97,$02,$4c,$02,$e1,$20,$99,$df,$29,$04,$ae
	.byt $98,$02,$85,$58,$8e,$94,$02,$ad,$8e,$02,$29,$7b,$05,$58,$8d,$8e
	.byt $02,$a5,$58,$d0,$06,$ad,$9f,$02,$20,$9d,$e1,$ad,$8e,$02,$29,$20
	.byt $d0,$15,$20,$99,$df,$ad,$2f,$03,$29,$20,$d0,$14,$ce,$95,$02,$d0
	.byt $2a,$ae,$9c,$02,$4c,$40,$e1,$20,$99,$df,$ad,$2f,$03,$ae,$9b,$02
	.byt $8e,$95,$02,$29,$20,$85,$58,$ad,$8e,$02,$29,$5f,$05,$58,$8d,$8e
	.byt $02,$29,$20,$d0,$06,$ad,$a2,$02,$20,$9d,$e1,$ad,$8e,$02,$29,$40
	.byt $d0,$15,$20,$99,$df,$ad,$2f,$03,$29,$80,$d0,$14,$ce,$96,$02,$d0
	.byt $2b,$ae,$9c,$02,$4c,$80,$e1,$20,$99,$df,$ad,$2f,$03,$ae,$9b,$02
	.byt $8e,$96,$02,$4a,$29,$40,$85,$58,$ad,$8e,$02,$29,$3f,$05,$58,$8d
	.byt $8e,$02,$29,$40,$d0,$06,$ad,$a3,$02,$4c,$9d,$e1,$60,$38,$24,$18
	.byt $08,$86,$58,$a2,$00,$20,$1d,$c5,$a9,$08,$28,$b0,$02,$a9,$20,$a2
	.byt $00,$20,$1d,$c5,$a6,$58,$60,$38,$60,$a6,$28,$bd,$20,$02,$48,$bd
	.byt $24,$02,$48,$a9,$1e,$20,$b5,$db,$20,$e4,$da,$a6,$28,$bc,$20,$02
	.byt $b1,$26,$c9,$20,$b0,$02,$a9,$20,$20,$72,$da,$bd,$20,$02,$dd,$2c
	.byt $02,$f0,$08,$a9,$09,$20,$b5,$db,$4c,$cb,$e1,$20,$e4,$da,$a6,$28
	.byt $bd,$24,$02,$dd,$34,$02,$d0,$eb,$a9,$1f,$20,$b5,$db,$68,$09,$40
	.byt $20,$b5,$db,$68,$09,$40,$4c,$b5,$db,$20,$e4,$da,$ad,$88,$02,$48
	.byt $a9,$28,$8d,$88,$02,$a9,$1e,$20,$78,$d1,$a4,$38,$b1,$30,$30,$06
	.byt $b1,$2e,$c9,$20,$b0,$02,$a9,$20,$20,$72,$da,$a9,$09,$20,$78,$d1
	.byt $a5,$38,$d0,$e6,$a4,$39,$88,$d0,$e1,$20,$e4,$da,$68,$8d,$86,$02
	.byt $60,$18,$33,$1b,$0a,$0d,$00,$f0,$4b,$1b,$0d,$0a,$40,$1b,$0a,$0a
	.byt $6c,$50,$02,$a2,$05,$ad,$8a,$02,$48,$09,$40,$8d,$8a,$02,$bd,$40
	.byt $e2,$20,$72,$da,$ca,$d0,$f7,$86,$0c,$a2,$06,$bd,$45,$e2,$20,$72
	.byt $da,$ca,$d0,$f7,$86,$0d,$a9,$05,$85,$0e,$a5,$0c,$0a,$0a,$0a,$20
	.byt $69,$ce,$85,$11,$98,$18,$69,$a0,$85,$12,$a9,$08,$85,$10,$a4,$0d
	.byt $b1,$11,$aa,$29,$40,$d0,$04,$8a,$29,$80,$aa,$8a,$10,$02,$49,$3f
	.byt $a6,$0e,$4a,$ca,$10,$fc,$26,$0f,$98,$18,$69,$28,$a8,$90,$02,$e6
	.byt $12,$c6,$10,$d0,$db,$a5,$0f,$20,$72,$da,$c6,$0e,$10,$bc,$e6,$0d
	.byt $a5,$0d,$c9,$28,$d0,$b0,$e6,$0c,$a5,$0c,$c9,$19,$d0,$9b,$a2,$04
	.byt $bd,$4b,$e2,$20,$72,$da,$ca,$d0,$f7,$68,$8d,$8a,$02,$60,$bc,$2c
	.byt $02,$24,$88,$b1,$00,$c9,$20,$d0,$07,$98,$dd,$28,$02,$d0,$f3,$60
	.byt $c9,$7f,$d0,$04,$98,$dd,$28,$02,$60,$bc,$28,$02,$b1,$00,$c9,$7f
	.byt $60,$a6,$28,$bd,$24,$02,$85,$61,$a5,$61,$20,$12,$de,$20,$f9,$e2
	.byt $f0,$0b,$a5,$61,$dd,$30,$02,$f0,$08,$c6,$61,$b0,$eb,$18,$c8,$84
	.byt $60,$60,$a6,$28,$bd,$24,$02,$85,$63,$20,$12,$de,$20,$de,$e2,$84
	.byt $62,$f0,$1b,$a5,$63,$dd,$34,$02,$f0,$13,$e6,$63,$a5,$63,$20,$12
	.byt $de,$20,$f9,$e2,$f0,$05,$20,$de,$e2,$d0,$e4,$c6,$63,$60,$60,$20
	.byt $01,$e3,$4c,$61,$e3,$a6,$28,$bd,$20,$02,$85,$60,$bd,$24,$02,$85
	.byt $61,$20,$22,$e3,$a5,$61,$85,$65,$c5,$63,$d0,$0c,$a5,$62,$c5,$60
	.byt $b0,$06,$a9,$00,$8d,$90,$05,$60,$a9,$00,$85,$64,$46,$66,$a5,$65
	.byt $20,$12,$de,$a4,$60,$a5,$65,$c5,$61,$f0,$05,$a6,$28,$bc,$28,$02
	.byt $b1,$00,$c9,$20,$b0,$02,$09,$80,$a6,$64,$24,$66,$10,$06,$a9,$20
	.byt $91,$00,$d0,$0d,$9d,$90,$05,$e6,$64,$e4,$67,$90,$04,$c6,$64,$66
	.byt $66,$98,$c8,$a6,$65,$e4,$63,$d0,$0c,$c5,$62,$d0,$d3,$a6,$64,$a9
	.byt $00,$9d,$90,$05,$60,$a6,$28,$dd,$2c,$02,$d0,$c4,$e6,$65,$d0,$ae
	.byt $66,$66,$a9,$00,$85,$64,$a5,$26,$a4,$27,$85,$00,$84,$01,$a6,$28
	.byt $bc,$20,$02,$a6,$64,$bd,$90,$05,$f0,$32,$a9,$20,$24,$66,$30,$0b
	.byt $bd,$90,$05,$10,$06,$c9,$a0,$b0,$02,$29,$1f,$91,$00,$2c,$0d,$02
	.byt $50,$03,$20,$56,$e6,$98,$c8,$a6,$28,$dd,$2c,$02,$d0,$0a,$a9,$28
	.byt $a0,$00,$20,$89,$ce,$bc,$28,$02,$e6,$64,$d0,$c7,$2c,$0d,$02,$50
	.byt $09,$ae,$20,$02,$ac,$24,$02,$20,$2a,$e6,$ac,$20,$02,$b1,$26,$a6
	.byt $28,$9d,$4c,$02,$60,$85,$67,$8a,$48,$98,$10,$0a,$20,$01,$e3,$a6
	.byt $60,$a4,$61,$20,$2a,$e6,$a9,$0d,$20,$48,$e6,$20,$6c,$e6,$68,$aa
	.byt $f0,$08,$a9,$09,$20,$48,$e6,$ca,$d0,$f8,$a6,$28,$bd,$48,$02,$30
	.byt $05,$a9,$11,$20,$48,$e6,$20,$af,$cf,$20,$cf,$c7,$b0,$f8,$48,$a9
	.byt $11,$20,$48,$e6,$68,$c9,$0d,$d0,$43,$48,$20,$4f,$e3,$68,$48,$c9
	.byt $0b,$f0,$11,$a6,$62,$a4,$63,$20,$2a,$e6,$a9,$0d,$20,$48,$e6,$a9
	.byt $0a,$20,$48,$e6,$a2,$ff,$e8,$bd,$90,$05,$c9,$20,$f0,$f8,$8a,$48
	.byt $a0,$00,$2c,$e8,$c8,$bd,$90,$05,$99,$90,$05,$d0,$f6,$a9,$90,$a0
	.byt $05,$20,$49,$e7,$85,$00,$84,$01,$68,$a8,$68,$60,$c9,$03,$f0,$b9
	.byt $c9,$0e,$d0,$0d,$20,$01,$e3,$a6,$60,$a4,$61,$20,$2a,$e6,$4c,$d5
	.byt $e4,$c9,$18,$d0,$0a,$20,$55,$e3,$38,$20,$d0,$e3,$4c,$5a,$e4,$c9
	.byt $7f,$d0,$47,$ad,$78,$02,$4a,$b0,$0a,$90,$00,$a9,$08,$2c,$a9,$09
	.byt $20,$48,$e6,$a6,$28,$bd,$4c,$02,$c9,$7f,$f0,$f2,$20,$55,$e3,$ad
	.byt $90,$05,$d0,$0d,$a9,$20,$20,$48,$e6,$a9,$08,$20,$48,$e6,$4c,$5a
	.byt $e4,$a2,$01,$bd,$90,$05,$f0,$06,$9d,$8f,$05,$e8,$d0,$f5,$a9,$20
	.byt $9d,$8f,$05,$18,$20,$d0,$e3,$4c,$5a,$e4,$c9,$20,$90,$06,$20,$37
	.byt $e5,$4c,$5a,$e4,$4c,$b9,$e5,$a8,$8a,$48,$98,$48,$20,$55,$e3,$a5
	.byt $62,$ac,$90,$05,$d0,$02,$a5,$60,$a6,$28,$dd,$2c,$02,$d0,$5f,$a5
	.byt $63,$dd,$34,$02,$f0,$58,$69,$01,$20,$12,$de,$20,$f9,$e2,$d0,$4e
	.byt $bc,$34,$02,$a6,$63,$e8,$20,$5c,$de,$2c,$0d,$02,$50,$40,$a2,$00
	.byt $a4,$63,$c8,$20,$2a,$e6,$a9,$18,$20,$56,$e6,$a9,$0a,$20,$48,$e6
	.byt $a6,$28,$bd,$4c,$02,$c9,$7f,$d0,$06,$20,$6c,$e6,$4c,$97,$e5,$20
	.byt $56,$e6,$a9,$09,$20,$b5,$db,$ad,$24,$02,$dd,$34,$02,$d0,$e1,$ad
	.byt $20,$02,$dd,$2c,$02,$d0,$d9,$a4,$61,$a6,$60,$20,$2a,$e6,$68,$20
	.byt $48,$e6,$18,$20,$d0,$e3,$68,$aa,$60,$c9,$08,$d0,$18,$48,$ad,$78
	.byt $02,$4a,$b0,$07,$68,$20,$48,$e6,$4c,$5a,$e4,$20,$01,$e3,$a6,$60
	.byt $a4,$61,$4c,$e7,$e5,$c9,$09,$d0,$15,$48,$ad,$78,$02,$4a,$90,$e4
	.byt $20,$22,$e3,$a6,$62,$a4,$63,$68,$20,$2a,$e6,$4c,$5a,$e4,$c9,$0a
	.byt $d0,$12,$a6,$28,$bd,$24,$02,$dd,$34,$02,$d0,$19,$a9,$0a,$2c,$a9
	.byt $0b,$4c,$79,$e4,$c9,$0b,$d0,$0f,$a6,$28,$bd,$24,$02,$dd,$30,$02
	.byt $f0,$ed,$a9,$0b,$2c,$a9,$0a,$c9,$0c,$d0,$09,$20,$48,$e6,$20,$6c
	.byt $e6,$4c,$5a,$e4,$20,$48,$e6,$4c,$5a,$e4,$a9,$1f,$20,$48,$e6,$98
	.byt $09,$40,$20,$48,$e6,$8a,$09,$40,$20,$b5,$db,$2c,$0d,$02,$50,$2b
	.byt $e8,$8a,$ca,$09,$40,$4c,$56,$e6,$2c,$0d,$02,$50,$03,$20,$56,$e6
	.byt $2c,$50,$e6,$4c,$86,$db,$85,$0c,$98,$48,$8a,$48,$a2,$18,$a5,$0c
	.byt $20,$1d,$c5,$68,$aa,$68,$a8,$a5,$0c,$b0,$eb,$60,$2c,$0d,$02,$50
	.byt $0a,$a9,$19,$20,$56,$e6,$a9,$2e,$20,$56,$e6,$a9,$7f,$4c,$b5,$db
	.byt $a5,$5c,$a6,$5d,$86,$03,$85,$02,$a0,$00,$b1,$02,$f0,$20,$aa,$a0
	.byt $02,$a5,$01,$d1,$02,$90,$17,$f0,$02,$b0,$09,$88,$a5,$00,$d1,$02
	.byt $90,$0c,$f0,$0b,$18,$8a,$65,$02,$90,$dc,$e6,$03,$b0,$d8,$18,$60
	.byt $85,$0e,$a9,$00,$85,$0f,$85,$10,$20,$80,$e6,$90,$2a,$86,$0f,$a5
	.byt $5e,$a4,$5f,$85,$06,$84,$07,$a5,$02,$a4,$03,$85,$08,$84,$09,$18
	.byt $8a,$65,$02,$90,$01,$c8,$85,$04,$84,$05,$20,$6c,$cd,$a9,$ff,$85
	.byt $10,$45,$0f,$85,$0f,$e6,$0f,$a5,$0e,$f0,$4d,$a5,$5e,$a4,$5f,$85
	.byt $06,$84,$07,$a5,$02,$a4,$03,$85,$04,$84,$05,$18,$a5,$0e,$69,$03
	.byt $48,$65,$02,$90,$01,$c8,$85,$08,$84,$09,$20,$6c,$cd,$18,$68,$48
	.byt $65,$0f,$85,$0f,$90,$02,$e6,$10,$a0,$00,$68,$91,$02,$c8,$a5,$00
	.byt $91,$02,$c8,$a5,$01,$91,$02,$a2,$00,$c8,$a1,$0c,$91,$02,$e6,$0c
	.byt $d0,$02,$e6,$0d,$c6,$0e,$d0,$f1,$18,$a5,$0f,$65,$5e,$85,$5e,$a4
	.byt $10,$98,$65,$5f,$85,$5f,$a5,$0f,$60,$85,$00,$84,$01,$a0,$00,$84
	.byt $02,$84,$03,$b1,$00,$c9,$30,$90,$2c,$c9,$3a,$b0,$28,$29,$0f,$48
	.byt $06,$02,$26,$03,$a5,$02,$a6,$03,$06,$02,$26,$03,$06,$02,$26,$03
	.byt $65,$02,$85,$02,$8a,$65,$03,$85,$03,$68,$65,$02,$85,$02,$90,$02
	.byt $e6,$03,$c8,$d0,$ce,$98,$aa,$a5,$02,$a4,$03,$60,$20,$10,$08,$04
	.byt $02,$01,$18,$24,$56,$10,$01,$38,$26,$56,$90,$24,$a4,$49,$b1,$4b
	.byt $0a,$10,$1d,$a6,$4a,$bd,$8c,$e7,$24,$57,$30,$0e,$50,$05,$11,$4b
	.byt $91,$4b,$60,$49,$7f,$31,$4b,$91,$4b,$60,$70,$04,$51,$4b,$91,$4b
	.byt $60,$18,$a5,$4b,$69,$28,$85,$4b,$90,$f6,$e6,$4c,$60,$38,$a5,$4b
	.byt $e9,$28,$85,$4b,$b0,$ea,$c6,$4c,$60,$a6,$4a,$e8,$e0,$06,$d0,$04
	.byt $a2,$00,$e6,$49,$86,$4a,$60,$a6,$4a,$ca,$10,$04,$a2,$05,$c6,$49
	.byt $86,$4a,$60,$84,$47,$86,$46,$98,$a0,$00,$20,$69,$ce,$85,$4b,$18
	.byt $98,$69,$a0,$85,$4c,$86,$00,$a9,$06,$a0,$00,$84,$01,$20,$dc,$ce
	.byt $a5,$00,$85,$49,$a5,$02,$85,$4a,$60,$18,$a5,$46,$85,$06,$65,$4d
	.byt $85,$08,$a5,$47,$85,$07,$65,$4f,$85,$09,$90,$0e,$a0,$06,$a2,$03
	.byt $b9,$4d,$00,$95,$06,$88,$88,$ca,$10,$f6,$a2,$03,$86,$05,$bd,$62
	.byt $e8,$85,$04,$a2,$06,$a9,$00,$95,$4e,$46,$04,$2a,$46,$04,$2a,$a8
	.byt $b9,$06,$00,$95,$4d,$ca,$ca,$10,$ec,$20,$66,$e8,$a6,$05,$ca,$10
	.byt $db,$60,$26,$67,$73,$32,$a6,$4d,$a4,$4f,$20,$f3,$e7,$a2,$ff,$38
	.byt $a5,$51,$e5,$4d,$85,$4d,$b0,$03,$86,$4e,$38,$a5,$53,$e5,$4f,$85
	.byt $4f,$b0,$02,$86,$50,$ad,$aa,$02,$85,$56,$20,$42,$e9,$86,$46,$84
	.byt $47,$24,$4e,$10,$08,$a5,$4d,$49,$ff,$85,$4d,$e6,$4d,$24,$50,$10
	.byt $08,$a5,$4f,$49,$ff,$85,$4f,$e6,$4f,$a5,$4d,$c5,$4f,$90,$3e,$08
	.byt $a5,$4d,$f0,$37,$a6,$4f,$20,$21,$e9,$28,$d0,$04,$a9,$ff,$85,$00
	.byt $24,$4e,$10,$06,$20,$e7,$e7,$4c,$cd,$e8,$20,$d9,$e7,$18,$a5,$00
	.byt $65,$02,$85,$02,$90,$0d,$24,$50,$30,$06,$20,$c1,$e7,$4c,$e3,$e8
	.byt $20,$cd,$e7,$20,$92,$e7,$c6,$4d,$d0,$d6,$60,$28,$60,$a5,$4f,$f0
	.byt $f9,$a6,$4d,$20,$21,$e9,$24,$50,$10,$06,$20,$cd,$e7,$4c,$03,$e9
	.byt $20,$c1,$e7,$18,$a5,$00,$65,$02,$85,$02,$90,$0d,$24,$4e,$10,$06
	.byt $20,$e7,$e7,$4c,$19,$e9,$20,$d9,$e7,$20,$92,$e7,$c6,$4f,$d0,$d6
	.byt $60,$86,$01,$a0,$00,$84,$00,$20,$dc,$ce,$a9,$ff,$85,$02,$60,$a6
	.byt $4d,$a4,$4f,$20,$4e,$e9,$20,$f3,$e7,$4c,$9c,$e7,$20,$42,$e9,$4c
	.byt $36,$e9,$18,$a5,$46,$65,$4d,$aa,$18,$a5,$47,$65,$4f,$a8,$e0,$f0
	.byt $b0,$05,$c0,$c8,$b0,$01,$60,$68,$8d,$ab,$02,$68,$60,$18,$24,$38
	.byt $48,$08,$86,$00,$24,$00,$30,$3f,$86,$28,$90,$05,$9d,$40,$02,$b0
	.byt $03,$9d,$44,$02,$bd,$48,$02,$29,$10,$d0,$0c,$a9,$0c,$20,$b5,$db
	.byt $a9,$1d,$20,$b5,$db,$a6,$28,$bd,$30,$02,$20,$69,$ce,$bd,$38,$02
	.byt $bc,$3c,$02,$20,$89,$ce,$bc,$28,$02,$88,$88,$38,$bd,$34,$02,$fd
	.byt $30,$02,$aa,$e8,$98,$b0,$0c,$a9,$00,$a2,$a0,$85,$00,$86,$01,$a2
	.byt $c8,$a9,$00,$28,$69,$00,$a8,$68,$91,$00,$48,$18,$a5,$00,$69,$28
	.byt $85,$00,$90,$02,$e6,$01,$68,$ca,$d0,$ee,$60,$a5,$46,$48,$a5,$47
	.byt $48,$ad,$aa,$02,$85,$56,$a5,$47,$38,$e5,$4d,$a8,$a6,$46,$20,$f3
	.byt $e7,$a2,$08,$a5,$4d,$ca,$0a,$10,$fc,$86,$0c,$a9,$80,$85,$0e,$85
	.byt $10,$0a,$85,$0f,$a5,$4d,$85,$11,$38,$66,$0d,$a5,$10,$a6,$11,$20
	.byt $62,$ea,$18,$a5,$0e,$65,$12,$85,$0e,$a5,$0f,$85,$12,$65,$13,$85
	.byt $0f,$c5,$12,$f0,$0d,$b0,$06,$20,$d9,$e7,$4c,$20,$ea,$20,$e7,$e7
	.byt $46,$0d,$a5,$0e,$a6,$0f,$20,$62,$ea,$38,$a5,$10,$e5,$12,$85,$10
	.byt $a5,$11,$85,$12,$e5,$13,$85,$11,$c5,$12,$f0,$0e,$b0,$06,$20,$c1
	.byt $e7,$4c,$4e,$ea,$20,$cd,$e7,$4c,$4e,$ea,$24,$0d,$30,$03,$20,$92
	.byt $e7,$a5,$0f,$d0,$a3,$a5,$11,$c5,$4d,$d0,$9d,$68,$a8,$68,$aa,$4c
	.byt $f3,$e7,$85,$12,$86,$13,$a6,$0c,$a5,$13,$2a,$66,$13,$66,$12,$ca
	.byt $d0,$f6,$60,$a5,$4b,$a4,$4c,$85,$00,$84,$01,$a6,$4f,$a4,$49,$a5
	.byt $51,$91,$00,$c8,$ca,$d0,$fa,$a9,$28,$a0,$00,$20,$89,$ce,$c6,$4d
	.byt $d0,$e9,$60,$85,$51,$84,$52,$86,$4f,$a9,$40,$85,$57,$a0,$00,$84
	.byt $50,$c4,$4f,$b0,$ed,$b1,$51,$20,$b5,$ea,$a4,$50,$c8,$d0,$f0,$a5
	.byt $4d,$0a,$46,$4f,$6a,$48,$a5,$46,$c9,$ea,$90,$17,$a6,$4a,$a5,$47
	.byt $69,$07,$a8,$e9,$bf,$90,$09,$f0,$07,$c9,$08,$d0,$02,$a9,$00,$a8
	.byt $20,$f3,$e7,$68,$20,$31,$ff,$a0,$00,$84,$00,$a5,$49,$48,$a5,$4a
	.byt $48,$b1,$02,$0a,$0a,$f0,$0c,$48,$10,$03,$20,$9c,$e7,$20,$d9,$e7
	.byt $68,$d0,$f1,$20,$c1,$e7,$68,$85,$4a,$68,$85,$49,$a4,$00,$c8,$c0
	.byt $08,$d0,$d6,$a5,$46,$69,$05,$aa,$a4,$47,$4c,$f3,$e7,$a5,$4f,$0a
	.byt $0a,$0a,$05,$4d,$49,$3f,$aa,$a9,$07,$20,$1a,$da,$06,$53,$26,$54
	.byt $a6,$53,$a9,$0b,$20,$1a,$da,$a6,$54,$a9,$0c,$20,$1a,$da,$a4,$51
	.byt $be,$38,$eb,$a9,$0d,$4c,$1a,$da,$00,$0b,$04,$08,$0a,$0b,$0c,$0d
	.byt $00,$00,$ee,$0e,$16,$0e,$4c,$0d,$8e,$0c,$d8,$0b,$2e,$0b,$8e,$0a
	.byt $f6,$09,$66,$09,$e0,$08,$60,$08,$e8,$07,$a4,$4f,$a5,$51,$0a,$aa
	.byt $bd,$40,$eb,$85,$4f,$bd,$41,$eb,$4a,$66,$4f,$88,$10,$fa,$85,$50
	.byt $a6,$53,$2c,$a6,$51,$8a,$d0,$02,$a2,$10,$a4,$4d,$88,$98,$c9,$03
	.byt $90,$02,$e9,$03,$09,$08,$20,$1a,$da,$c0,$03,$b0,$0c,$98,$0a,$a8
	.byt $69,$01,$a6,$50,$20,$1a,$da,$98,$2c,$a9,$06,$a6,$4f,$4c,$1a,$da
	.byt $18,$00,$00,$00,$00,$00,$00,$3e,$10,$00,$00,$00,$0f,$00,$00,$00
	.byt $00,$00,$00,$00,$0f,$07,$10,$10,$10,$00,$08,$00,$00,$00,$00,$00
	.byt $00,$00,$1f,$07,$10,$10,$10,$00,$18,$00,$00,$00,$00,$00,$00,$00
	.byt $00,$3e,$0f,$00,$00,$00,$00,$00,$00,$a2,$a0,$a0,$eb,$d0,$0a,$a2
	.byt $ae,$a0,$eb,$d0,$04,$a2,$bc,$a0,$eb,$4c,$e7,$d9,$a2,$ca,$a0,$eb
	.byt $20,$e7,$d9,$a9,$00,$aa,$8a,$48,$a9,$00,$20,$1a,$da,$a2,$00,$ca
	.byt $d0,$fd,$68,$aa,$e8,$e0,$70,$d0,$ed,$a9,$08,$a2,$00,$4c,$1a,$da
	.byt $a2,$0c,$4c,$5d,$db,$20,$10,$ec,$b0,$fb,$60,$2c,$1b,$ec,$4c,$79
	.byt $db,$24,$5b,$70,$24,$aa,$30,$10,$c9,$20,$b0,$1d,$69,$20,$48,$a9
	.byt $02,$20,$49,$ec,$68,$4c,$49,$ec,$c9,$a0,$b0,$04,$69,$c0,$b0,$ee
	.byt $29,$7f,$48,$a9,$01,$20,$49,$ec,$68,$2c,$49,$ec,$4c,$12,$db,$86
	.byt $0c,$84,$0d,$48,$24,$5b,$10,$06,$20,$21,$ec,$4c,$61,$ec,$20,$1b
	.byt $ec,$68,$45,$0e,$85,$0e,$a6,$0c,$a4,$0d,$60,$86,$0c,$84,$0d,$0e
	.byt $7e,$02,$90,$03,$68,$68,$60,$24,$5b,$30,$10,$20,$10,$ec,$b0,$ef
	.byt $48,$45,$0e,$85,$0e,$68,$a6,$0c,$a4,$0d,$60,$20,$b4,$ec,$b0,$df
	.byt $24,$5b,$70,$ec,$c9,$20,$b0,$e8,$48,$20,$b9,$ec,$aa,$68,$a8,$8a
	.byt $c0,$01,$d0,$04,$09,$80,$30,$d8,$c9,$40,$b0,$04,$e9,$1f,$b0,$d0
	.byt $69,$3f,$90,$cc,$a2,$0c,$4c,$18,$c5,$20,$b4,$ec,$b0,$fb,$60,$38
	.byt $24,$18,$a9,$80,$4c,$5d,$db,$38,$24,$18,$a9,$80,$4c,$79,$db,$38
	.byt $24,$18,$a9,$80,$4c,$f7,$da,$38,$24,$18,$a9,$80,$4c,$12,$db,$38
	.byt $ad,$2f,$05,$ed,$2d,$05,$8d,$2a,$05,$ad,$30,$05,$ed,$2e,$05,$8d
	.byt $2b,$05,$ad,$2d,$05,$ac,$2e,$05,$85,$00,$84,$01,$60,$a2,$32,$a9
	.byt $16,$20,$4f,$ec,$ca,$d0,$f8,$a9,$24,$20,$4f,$ec,$a9,$00,$85,$0e
	.byt $a2,$00,$bd,$18,$05,$20,$4f,$ec,$e8,$e0,$0c,$d0,$f5,$a9,$00,$20
	.byt $4f,$ec,$a2,$00,$bd,$2c,$05,$20,$4f,$ec,$e8,$e0,$07,$d0,$f5,$a5
	.byt $0e,$4c,$4f,$ec,$20,$6b,$ec,$c9,$16,$d0,$f9,$a2,$0a,$20,$6b,$ec
	.byt $c9,$16,$d0,$f0,$ca,$d0,$f6,$20,$6b,$ec,$c9,$16,$f0,$f9,$c9,$24
	.byt $d0,$e2,$a9,$00,$85,$0e,$20,$6b,$ec,$aa,$f0,$06,$20,$b5,$db,$4c
	.byt $56,$ed,$a2,$00,$20,$6b,$ec,$9d,$2c,$05,$e8,$e0,$07,$d0,$f5,$20
	.byt $6b,$ec,$09,$30,$4c,$b5,$db,$20,$c1,$ec,$20,$c9,$ec,$20,$10,$ec
	.byt $b0,$03,$20,$b5,$db,$20,$cf,$c7,$b0,$f3,$c9,$03,$f0,$06,$20,$1b
	.byt $ec,$4c,$7d,$ed,$20,$bf,$ec,$4c,$c7,$ec,$20,$c1,$ec,$0e,$7e,$02
	.byt $b0,$25,$20,$10,$ec,$b0,$f6,$aa,$30,$04,$c9,$20,$b0,$13,$48,$a9
	.byt $81,$20,$b5,$db,$68,$20,$54,$ce,$20,$b5,$db,$98,$20,$b5,$db,$a9
	.byt $87,$20,$b5,$db,$4c,$9d,$ed,$4c,$bf,$ec,$66,$5b,$46,$5b,$20,$c9
	.byt $ec,$20,$0a,$ee,$4c,$c7,$ec,$66,$5b,$38,$66,$5b,$20,$d9,$ec,$20
	.byt $0a,$ee,$4c,$d7,$ec,$66,$5b,$46,$5b,$a9,$40,$8d,$0e,$03,$20,$c1
	.byt $ec,$20,$56,$ee,$a9,$c0,$8d,$0e,$03,$4c,$bf,$ec,$66,$5b,$38,$66
	.byt $5b,$20,$d1,$ec,$20,$56,$ee,$4c,$cf,$ec,$24,$5b,$70,$03,$20,$fd
	.byt $ec,$20,$df,$ec,$a9,$00,$85,$0e,$ad,$2a,$05,$f0,$12,$a0,$00,$b1
	.byt $00,$20,$4f,$ec,$ce,$2a,$05,$e6,$00,$d0,$ed,$e6,$01,$d0,$e9,$ad
	.byt $2b,$05,$f0,$1d,$a0,$00,$b1,$00,$20,$4f,$ec,$c8,$d0,$f8,$ce,$2b
	.byt $05,$e6,$01,$24,$5b,$10,$e8,$a9,$30,$85,$44,$a5,$44,$d0,$fc,$f0
	.byt $de,$a5,$0e,$4c,$4f,$ec,$24,$5b,$70,$03,$20,$34,$ed,$20,$df,$ec
	.byt $24,$5b,$50,$08,$a9,$ff,$8d,$2a,$05,$8d,$2b,$05,$a0,$00,$84,$0e
	.byt $ad,$2a,$05,$f0,$11,$20,$6b,$ec,$91,$00,$ce,$2a,$05,$e6,$00,$d0
	.byt $ef,$e6,$01,$4c,$70,$ee,$ad,$2b,$05,$f0,$12,$a0,$00,$20,$6b,$ec
	.byt $91,$00,$c8,$d0,$f8,$e6,$01,$ce,$2b,$05,$4c,$86,$ee,$20,$6b,$ec
	.byt $09,$30,$4c,$b5,$db,$a9,$00,$8d,$8c,$02,$a9,$10,$2c,$2d,$03,$d0
	.byt $32,$38,$60,$a9,$ff,$8d,$28,$03,$8d,$29,$03,$ad,$29,$03,$c9,$c5
	.byt $b0,$f9,$2c,$20,$03,$a9,$20,$2d,$2d,$03,$d0,$13,$a9,$10,$2d,$2d
	.byt $03,$f0,$f2,$ad,$29,$03,$c9,$ad,$90,$07,$c9,$b5,$a9,$01,$60,$a9
	.byt $00,$38,$60,$78,$a2,$04,$20,$b3,$ee,$ca,$d0,$fa,$20,$b3,$ee,$f0
	.byt $0a,$b0,$f9,$e8,$4c,$ec,$ee,$58,$4c,$aa,$ee,$e0,$06,$90,$f8,$20
	.byt $b3,$ee,$b0,$fb,$a0,$1e,$a2,$00,$20,$b3,$ee,$90,$01,$e8,$88,$d0
	.byt $f7,$e0,$0f,$b0,$e2,$58,$a9,$0a,$85,$44,$a5,$44,$d0,$fc,$18,$60
	.byt $20,$d9,$ec,$a9,$6f,$20,$30,$ef,$a9,$68,$20,$30,$ef,$4c,$d7,$ec
	.byt $48,$a9,$1b,$20,$49,$ec,$a9,$39,$20,$49,$ec,$68,$4c,$49,$ec,$20
	.byt $d9,$ec,$a9,$67,$20,$30,$ef,$4c,$d7,$ec,$20,$d1,$ec,$a9,$fa,$85
	.byt $44,$a5,$44,$c9,$f0,$d0,$fa,$a2,$0c,$20,$0c,$c5,$a5,$44,$d0,$05
	.byt $20,$cf,$ec,$38,$60,$20,$b4,$ec,$b0,$f2,$c9,$13,$d0,$ee,$20,$b9
	.byt $ec,$c9,$53,$d0,$e7,$20,$cf,$ec,$18,$60,$48,$20,$d9,$ec,$68,$20
	.byt $49,$ec,$4c,$d7,$ec,$48,$20,$c9,$ec,$68,$20,$1b,$ec,$4c,$c7,$ec
	.byt $a9,$e4,$a0,$f5,$4c,$af,$ef,$60,$20,$ec,$f1,$a5,$65,$49,$ff,$85
	.byt $65,$45,$6d,$85,$6e,$a5,$60,$4c,$b2,$ef,$20,$e5,$f0,$90,$3f,$20
	.byt $ec,$f1,$d0,$03,$4c,$77,$f3,$ba,$86,$89,$a6,$66,$86,$7f,$a2,$68
	.byt $a5,$68,$a8,$f0,$d2,$38,$e5,$60,$f0,$24,$90,$12,$84,$60,$a4,$6d
	.byt $84,$65,$49,$ff,$69,$00,$a0,$00,$84,$7f,$a2,$60,$d0,$04,$a0,$00
	.byt $84,$66,$c9,$f9,$30,$c4,$a8,$a5,$66,$56,$01,$20,$fc,$f0,$24,$6e
	.byt $10,$57,$a0,$60,$e0,$68,$f0,$02,$a0,$68,$38,$49,$ff,$65,$7f,$85
	.byt $66,$b9,$04,$00,$f5,$04,$85,$64,$b9,$03,$00,$f5,$03,$85,$63,$b9
	.byt $02,$00,$f5,$02,$85,$62,$b9,$01,$00,$f5,$01,$85,$61,$b0,$03,$20
	.byt $90,$f0,$a0,$00,$98,$18,$a6,$61,$d0,$4a,$a6,$62,$86,$61,$a6,$63
	.byt $86,$62,$a6,$64,$86,$63,$a6,$66,$86,$64,$84,$66,$69,$08,$c9,$28
	.byt $d0,$e4,$a9,$00,$85,$60,$85,$65,$60,$65,$7f,$85,$66,$a5,$64,$65
	.byt $6c,$85,$64,$a5,$63,$65,$6b,$85,$63,$a5,$62,$65,$6a,$85,$62,$a5
	.byt $61,$65,$69,$85,$61,$4c,$81,$f0,$69,$01,$06,$66,$26,$64,$26,$63
	.byt $26,$62,$26,$61,$10,$f2,$38,$e5,$60,$b0,$c7,$49,$ff,$69,$01,$85
	.byt $60,$90,$0c,$e6,$60,$f0,$40,$66,$61,$66,$62,$66,$63,$66,$64,$60
	.byt $a5,$65,$49,$ff,$85,$65,$a5,$61,$49,$ff,$85,$61,$a5,$62,$49,$ff
	.byt $85,$62,$a5,$63,$49,$ff,$85,$63,$a5,$64,$49,$ff,$85,$64,$a5,$66
	.byt $49,$ff,$85,$66,$e6,$66,$d0,$0e,$e6,$64,$d0,$0a,$e6,$63,$d0,$06
	.byt $e6,$62,$d0,$02,$e6,$61,$60,$a9,$01,$85,$8b,$a6,$89,$9a,$60,$a2
	.byt $6e,$b4,$04,$84,$66,$b4,$03,$94,$04,$b4,$02,$94,$03,$b4,$01,$94
	.byt $02,$a4,$67,$94,$01,$69,$08,$30,$e8,$f0,$e6,$e9,$08,$a8,$a5,$66
	.byt $b0,$14,$16,$01,$90,$02,$f6,$01,$76,$01,$76,$01,$76,$02,$76,$03
	.byt $76,$04,$6a,$c8,$d0,$ec,$18,$60,$82,$13,$5d,$8d,$de,$82,$49,$0f
	.byt $da,$9e,$88,$34,$00,$00,$00,$03,$7f,$5e,$56,$cb,$79,$80,$13,$9b
	.byt $0b,$64,$80,$76,$38,$93,$16,$82,$38,$aa,$3b,$20,$80,$35,$04,$f3
	.byt $34,$81,$35,$04,$f3,$34,$80,$80,$00,$00,$00,$80,$31,$72,$17,$f8
	.byt $60,$a9,$02,$4c,$c9,$f0,$ba,$86,$89,$20,$bd,$f3,$f0,$f3,$30,$f1
	.byt $a5,$60,$e9,$7f,$48,$a9,$80,$85,$60,$a9,$2c,$a0,$f1,$20,$af,$ef
	.byt $a9,$31,$a0,$f1,$20,$87,$f2,$a9,$a5,$a0,$f8,$20,$98,$ef,$a9,$17
	.byt $a0,$f1,$20,$e1,$f6,$a9,$36,$a0,$f1,$20,$af,$ef,$68,$20,$e9,$f9
	.byt $a9,$3b,$a0,$f1,$20,$ec,$f1,$f0,$b7,$d0,$05,$f0,$b3,$ba,$86,$89
	.byt $20,$17,$f2,$a9,$00,$85,$6f,$85,$70,$85,$71,$85,$72,$a5,$66,$20
	.byt $b9,$f1,$a5,$64,$20,$b9,$f1,$a5,$63,$20,$b9,$f1,$a5,$62,$20,$b9
	.byt $f1,$a5,$61,$20,$be,$f1,$4c,$01,$f3,$d0,$03,$4c,$cf,$f0,$4a,$09
	.byt $80,$a8,$90,$19,$18,$a5,$72,$65,$6c,$85,$72,$a5,$71,$65,$6b,$85
	.byt $71,$a5,$70,$65,$6a,$85,$70,$a5,$6f,$65,$69,$85,$6f,$66,$6f,$66
	.byt $70,$66,$71,$66,$72,$66,$66,$98,$4a,$d0,$d6,$60,$85,$7d,$84,$7e
	.byt $a0,$04,$b1,$7d,$85,$6c,$88,$b1,$7d,$85,$6b,$88,$b1,$7d,$85,$6a
	.byt $88,$b1,$7d,$85,$6d,$45,$65,$85,$6e,$a5,$6d,$09,$80,$85,$69,$88
	.byt $b1,$7d,$85,$68,$a5,$60,$60,$a5,$68,$f0,$1c,$18,$65,$60,$90,$04
	.byt $30,$1a,$18,$2c,$10,$11,$69,$80,$85,$60,$f0,$13,$a5,$6e,$85,$65
	.byt $60,$a5,$65,$49,$ff,$30,$05,$68,$68,$4c,$42,$f0,$4c,$c7,$f0,$4c
	.byt $46,$f0,$20,$87,$f3,$aa,$f0,$10,$18,$69,$02,$b0,$ef,$a2,$00,$86
	.byt $6e,$20,$c2,$ef,$e6,$60,$f0,$e4,$60,$84,$20,$00,$00,$00,$20,$87
	.byt $f3,$a2,$00,$a9,$59,$a0,$f2,$86,$6e,$20,$23,$f3,$4c,$8a,$f2,$ba
	.byt $86,$89,$20,$49,$f1,$20,$87,$f3,$a9,$08,$a0,$f1,$20,$23,$f3,$4c
	.byt $8a,$f2,$a9,$03,$85,$8b,$60,$20,$ec,$f1,$f0,$f6,$ba,$86,$89,$20
	.byt $96,$f3,$a9,$00,$38,$e5,$60,$85,$60,$20,$17,$f2,$e6,$60,$f0,$9c
	.byt $a2,$fc,$a9,$01,$a4,$69,$c4,$61,$d0,$10,$a4,$6a,$c4,$62,$d0,$0a
	.byt $a4,$6b,$c4,$63,$d0,$04,$a4,$6c,$c4,$64,$08,$2a,$90,$0c,$e8,$95
	.byt $72,$f0,$05,$10,$33,$a9,$01,$2c,$a9,$40,$28,$b0,$0e,$06,$6c,$26
	.byt $6b,$26,$6a,$26,$69,$b0,$e3,$30,$cb,$10,$df,$a8,$a5,$6c,$e5,$64
	.byt $85,$6c,$a5,$6b,$e5,$63,$85,$6b,$a5,$6a,$e5,$62,$85,$6a,$a5,$69
	.byt $e5,$61,$85,$69,$98,$4c,$cd,$f2,$0a,$0a,$0a,$0a,$0a,$0a,$85,$66
	.byt $28,$a5,$6f,$85,$61,$a5,$70,$85,$62,$a5,$71,$85,$63,$a5,$72,$85
	.byt $64,$4c,$22,$f0,$20,$c7,$f8,$f0,$06,$a9,$12,$a0,$f1,$d0,$04,$a9
	.byt $0d,$a0,$f1,$85,$7d,$84,$7e,$a0,$04,$b1,$7d,$85,$64,$88,$b1,$7d
	.byt $85,$63,$88,$b1,$7d,$85,$62,$88,$b1,$7d,$85,$65,$09,$80,$85,$61
	.byt $88,$b1,$7d,$85,$60,$84,$66,$60,$a2,$73,$2c,$a2,$78,$a0,$00,$20
	.byt $96,$f3,$86,$7d,$84,$7e,$a0,$04,$a5,$64,$91,$7d,$88,$a5,$63,$91
	.byt $7d,$88,$a5,$62,$91,$7d,$88,$a5,$65,$09,$7f,$25,$61,$91,$7d,$88
	.byt $a5,$60,$91,$7d,$84,$66,$60,$a5,$6d,$85,$65,$a2,$05,$b5,$67,$95
	.byt $5f,$ca,$d0,$f9,$86,$66,$60,$20,$96,$f3,$a2,$06,$b5,$5f,$95,$67
	.byt $ca,$d0,$f9,$86,$66,$60,$a5,$60,$f0,$fb,$06,$66,$90,$f7,$20,$b8
	.byt $f0,$d0,$f2,$4c,$83,$f0,$a5,$65,$30,$0e,$a5,$60,$c9,$91,$b0,$08
	.byt $20,$39,$f4,$a5,$64,$a4,$63,$60,$a9,$0a,$4c,$c9,$f0,$a5,$60,$f0
	.byt $09,$a5,$65,$2a,$a9,$ff,$b0,$02,$a9,$01,$60,$20,$bd,$f3,$2c,$a9
	.byt $ff,$85,$61,$a9,$00,$85,$62,$a2,$88,$a5,$61,$49,$ff,$2a,$a9,$00
	.byt $85,$63,$85,$64,$86,$60,$85,$66,$85,$65,$4c,$1d,$f0,$85,$61,$84
	.byt $62,$a2,$90,$38,$b0,$e8,$46,$65,$60,$85,$7d,$84,$7e,$a0,$00,$b1
	.byt $7d,$c8,$aa,$f0,$b8,$b1,$7d,$45,$65,$30,$b6,$e4,$60,$d0,$21,$b1
	.byt $7d,$09,$80,$c5,$61,$d0,$19,$c8,$b1,$7d,$c5,$62,$d0,$12,$c8,$b1
	.byt $7d,$c5,$63,$d0,$0b,$c8,$a9,$7f,$c5,$66,$b1,$7d,$e5,$64,$f0,$c8
	.byt $a5,$65,$90,$02,$49,$ff,$4c,$c3,$f3,$a5,$60,$f0,$4a,$38,$e9,$a0
	.byt $24,$65,$10,$09,$aa,$a9,$ff,$85,$67,$20,$96,$f0,$8a,$a2,$60,$c9
	.byt $f9,$10,$06,$20,$e5,$f0,$84,$67,$60,$a8,$a5,$65,$29,$80,$46,$61
	.byt $05,$61,$85,$61,$20,$fc,$f0,$84,$67,$60,$a5,$60,$c9,$a0,$b0,$f9
	.byt $20,$39,$f4,$84,$66,$a5,$65,$84,$65,$49,$80,$2a,$a9,$a0,$85,$60
	.byt $a5,$64,$85,$88,$4c,$1d,$f0,$85,$61,$85,$62,$85,$63,$85,$64,$a8
	.byt $60,$85,$61,$86,$62,$a2,$90,$38,$4c,$de,$f3,$20,$a5,$f4,$a9,$00
	.byt $a0,$01,$4c,$a8,$c7,$a0,$00,$a9,$20,$24,$65,$10,$02,$a9,$2d,$99
	.byt $00,$01,$85,$65,$84,$77,$c8,$a9,$30,$a6,$60,$d0,$03,$4c,$c8,$f5
	.byt $a9,$00,$e0,$80,$f0,$02,$b0,$09,$a9,$d5,$a0,$f5,$20,$84,$f1,$a9
	.byt $f7,$85,$74,$a9,$da,$a0,$f5,$20,$f9,$f3,$f0,$1e,$10,$12,$a9,$df
	.byt $a0,$f5,$20,$f9,$f3,$f0,$02,$10,$0e,$20,$42,$f2,$c6,$74,$d0,$ee
	.byt $20,$5e,$f2,$e6,$74,$d0,$dc,$20,$90,$ef,$20,$39,$f4,$a2,$01,$a5
	.byt $74,$18,$69,$0a,$30,$09,$c9,$0b,$b0,$06,$69,$ff,$aa,$a9,$02,$38
	.byt $e9,$02,$85,$75,$86,$74,$8a,$f0,$02,$10,$13,$a4,$77,$a9,$2e,$c8
	.byt $99,$00,$01,$8a,$f0,$06,$a9,$30,$c8,$99,$00,$01,$84,$77,$a0,$00
	.byt $a2,$80,$18,$a5,$64,$79,$ec,$f5,$85,$64,$a5,$63,$79,$eb,$f5,$85
	.byt $63,$a5,$62,$79,$ea,$f5,$85,$62,$a5,$61,$79,$e9,$f5,$85,$61,$e8
	.byt $b0,$04,$10,$df,$30,$02,$30,$da,$8a,$90,$04,$49,$ff,$69,$0a,$69
	.byt $2f,$c8,$c8,$c8,$c8,$84,$76,$a4,$77,$c8,$aa,$29,$7f,$99,$00,$01
	.byt $c6,$74,$d0,$06,$a9,$2e,$c8,$99,$00,$01,$84,$77,$a4,$76,$8a,$49
	.byt $ff,$29,$80,$aa,$c0,$24,$d0,$ab,$a4,$77,$b9,$00,$01,$88,$c9,$30
	.byt $f0,$f8,$c9,$2e,$f0,$01,$c8,$a9,$2b,$a6,$75,$f0,$2e,$10,$08,$a9
	.byt $00,$38,$e5,$75,$aa,$a9,$2d,$99,$02,$01,$a9,$45,$99,$01,$01,$8a
	.byt $a2,$2f,$38,$e8,$e9,$0a,$b0,$fb,$69,$3a,$99,$04,$01,$8a,$99,$03
	.byt $01,$a9,$00,$99,$05,$01,$f0,$08,$99,$00,$01,$a9,$00,$99,$01,$01
	.byt $a9,$00,$a0,$01,$60,$9e,$6e,$6b,$28,$00,$9e,$6e,$6b,$27,$fd,$9b
	.byt $3e,$bc,$1f,$fd,$80,$00,$00,$00,$00,$fa,$0a,$1f,$00,$00,$98,$96
	.byt $80,$ff,$f0,$bd,$c0,$00,$01,$86,$a0,$ff,$ff,$d8,$f0,$00,$00,$03
	.byt $e8,$ff,$ff,$ff,$9c,$00,$00,$00,$0a,$ff,$ff,$ff,$ff,$4c,$42,$f0
	.byt $20,$87,$f3,$a9,$e4,$a0,$f5,$20,$23,$f3,$f0,$70,$ba,$86,$89,$a5
	.byt $68,$f0,$ea,$a2,$80,$a0,$00,$20,$52,$f3,$a5,$6d,$10,$0f,$20,$6a
	.byt $f4,$a9,$80,$a0,$00,$20,$f9,$f3,$d0,$03,$98,$a4,$88,$20,$79,$f3
	.byt $98,$48,$20,$49,$f1,$a9,$80,$a0,$00,$20,$84,$f1,$20,$8f,$f6,$68
	.byt $4a,$90,$0a,$a5,$60,$f0,$06,$a5,$65,$49,$ff,$85,$65,$60,$81,$38
	.byt $aa,$3b,$29,$07,$71,$34,$58,$3e,$56,$74,$16,$7e,$b3,$1b,$77,$2f
	.byt $ee,$e3,$85,$7a,$1d,$84,$1c,$2a,$7c,$63,$59,$58,$0a,$7e,$75,$fd
	.byt $e7,$c6,$80,$31,$72,$18,$10,$81,$00,$00,$00,$00,$ba,$86,$89,$a9
	.byt $5e,$a0,$f6,$20,$84,$f1,$a5,$66,$69,$50,$90,$03,$20,$96,$f3,$85
	.byt $7f,$20,$8a,$f3,$a5,$60,$c9,$88,$90,$03,$20,$31,$f2,$20,$6a,$f4
	.byt $a5,$88,$18,$69,$81,$f0,$f3,$38,$e9,$01,$48,$a2,$05,$b5,$68,$b4
	.byt $60,$95,$60,$94,$68,$ca,$10,$f5,$a5,$7f,$85,$66,$20,$9b,$ef,$20
	.byt $53,$f6,$a9,$63,$a0,$f6,$20,$f7,$f6,$a9,$00,$85,$6e,$68,$4c,$19
	.byt $f2,$85,$85,$84,$86,$20,$48,$f3,$a9,$73,$20,$84,$f1,$20,$fb,$f6
	.byt $a9,$73,$a0,$00,$4c,$84,$f1,$85,$85,$84,$86,$20,$4b,$f3,$b1,$85
	.byt $85,$87,$a4,$85,$c8,$98,$d0,$02,$e6,$86,$85,$85,$a4,$86,$20,$84
	.byt $f1,$a5,$85,$a4,$86,$18,$69,$05,$90,$01,$c8,$85,$85,$84,$86,$20
	.byt $af,$ef,$a9,$78,$a0,$00,$c6,$87,$d0,$e4,$60,$98,$35,$44,$7a,$6b
	.byt $68,$28,$b1,$46,$20,$20,$bd,$f3,$aa,$30,$18,$a9,$ef,$a0,$02,$20
	.byt $23,$f3,$8a,$f0,$e5,$a9,$2b,$a0,$f7,$20,$84,$f1,$a9,$30,$a0,$f7
	.byt $20,$af,$ef,$a6,$64,$a5,$61,$85,$64,$86,$61,$a9,$00,$85,$65,$a5
	.byt $60,$85,$66,$a9,$80,$85,$60,$20,$22,$f0,$a2,$ef,$a0,$02,$4c,$52
	.byt $f3,$20,$48,$f3,$20,$35,$f7,$a9,$73,$a0,$00,$20,$84,$f1,$4c,$6a
	.byt $f4,$20,$b1,$f8,$a9,$dc,$a0,$f7,$20,$af,$ef,$4c,$91,$f7,$20,$b1
	.byt $f8,$20,$87,$f3,$a9,$e1,$a0,$f7,$a6,$6d,$20,$67,$f2,$20,$87,$f3
	.byt $20,$6a,$f4,$a9,$00,$85,$6e,$20,$9b,$ef,$a9,$e6,$a0,$f7,$20,$98
	.byt $ef,$a5,$65,$48,$10,$0f,$20,$90,$ef,$a5,$65,$30,$0b,$a5,$8a,$49
	.byt $ff,$85,$8a,$24,$48,$20,$53,$f6,$a9,$e6,$a0,$f7,$20,$af,$ef,$68
	.byt $10,$03,$20,$53,$f6,$a9,$eb,$a0,$f7,$4c,$e1,$f6,$81,$49,$0f,$da
	.byt $a2,$83,$49,$0f,$da,$a2,$7f,$00,$00,$00,$00,$05,$84,$e6,$1a,$2d
	.byt $1b,$86,$28,$07,$fb,$f8,$87,$99,$68,$89,$01,$87,$23,$35,$df,$e1
	.byt $86,$a5,$5d,$e7,$28,$83,$49,$0f,$da,$a2,$20,$b1,$f8,$20,$48,$f3
	.byt $a9,$00,$85,$8a,$20,$91,$f7,$a2,$80,$a0,$00,$20,$52,$f3,$a9,$73
	.byt $a0,$00,$20,$23,$f3,$a9,$00,$85,$65,$a5,$8a,$20,$c4,$f7,$a9,$80
	.byt $a0,$00,$4c,$87,$f2,$a5,$65,$48,$10,$03,$20,$53,$f6,$a5,$60,$48
	.byt $c9,$81,$90,$07,$a9,$a5,$a0,$f8,$20,$87,$f2,$a9,$6d,$a0,$f8,$20
	.byt $e1,$f6,$68,$c9,$81,$90,$07,$a9,$dc,$a0,$f7,$20,$98,$ef,$68,$10
	.byt $03,$20,$53,$f6,$20,$c7,$f8,$f0,$03,$4c,$aa,$f8,$60,$0b,$76,$b3
	.byt $83,$bd,$d3,$79,$1e,$f4,$a6,$f5,$7b,$83,$fc,$b0,$10,$7c,$0c,$1f
	.byt $67,$ca,$7c,$de,$53,$cb,$c1,$7d,$14,$64,$70,$4c,$7d,$b7,$ea,$51
	.byt $7a,$7d,$63,$30,$88,$7e,$7e,$92,$44,$99,$3a,$7e,$4c,$cc,$91,$c7
	.byt $7f,$aa,$aa,$aa,$13,$81,$00,$00,$00,$00,$a9,$bd,$a0,$f8,$4c,$84
	.byt $f1,$20,$c7,$f8,$f0,$16,$a9,$c2,$a0,$f8,$4c,$84,$f1,$86,$65,$2e
	.byt $e0,$d8,$7b,$0e,$fa,$35,$19,$ad,$0d,$02,$29,$20,$60,$85,$00,$84
	.byt $01,$20,$af,$ef,$a6,$00,$a4,$01,$4c,$52,$f3,$20,$fc,$f9,$90,$07
	.byt $c9,$41,$90,$31,$e9,$37,$2c,$e9,$2f,$c9,$10,$b0,$28,$0a,$0a,$0a
	.byt $0a,$a2,$04,$0a,$26,$62,$26,$61,$b0,$18,$ca,$d0,$f6,$f0,$dc,$20
	.byt $fc,$f9,$b0,$11,$c9,$32,$b0,$0d,$c9,$31,$26,$62,$26,$61,$b0,$02
	.byt $90,$ed,$4c,$c7,$f0,$a2,$90,$38,$20,$de,$f3,$a2,$00,$60,$85,$00
	.byt $84,$01,$ba,$86,$89,$a9,$00,$85,$02,$85,$03,$85,$66,$a2,$05,$95
	.byt $60,$95,$73,$ca,$10,$f9,$20,$fe,$f9,$90,$16,$c9,$23,$f0,$9c,$c9
	.byt $25,$f0,$bc,$c9,$2d,$f0,$05,$c9,$2b,$d0,$08,$2c,$86,$03,$20,$fc
	.byt $f9,$90,$7a,$c9,$2e,$f0,$4f,$c9,$45,$f0,$04,$c9,$65,$d0,$4d,$a6
	.byt $02,$20,$fc,$f9,$90,$10,$c9,$2d,$f0,$05,$c9,$2b,$d0,$2a,$2c,$66
	.byt $77,$20,$fc,$f9,$b0,$24,$a5,$75,$c9,$0a,$90,$09,$a9,$64,$24,$77
	.byt $30,$11,$4c,$c7,$f0,$0a,$0a,$18,$65,$75,$0a,$18,$a4,$02,$71,$00
	.byt $38,$e9,$30,$85,$75,$4c,$71,$f9,$86,$02,$24,$77,$10,$0e,$a9,$00
	.byt $38,$e5,$75,$4c,$ae,$f9,$66,$76,$24,$76,$50,$a2,$a5,$75,$38,$e5
	.byt $74,$85,$75,$f0,$12,$10,$09,$20,$5e,$f2,$e6,$75,$d0,$f9,$f0,$07
	.byt $20,$42,$f2,$c6,$75,$d0,$f9,$a5,$03,$30,$16,$10,$17,$48,$24,$76
	.byt $10,$02,$e6,$74,$20,$42,$f2,$68,$38,$e9,$30,$20,$e9,$f9,$4c,$4e
	.byt $f9,$20,$53,$f6,$a2,$00,$4c,$96,$f3,$48,$20,$87,$f3,$68,$20,$d1
	.byt $f3,$a5,$6d,$45,$65,$85,$6e,$a6,$60,$4c,$b2,$ef,$e6,$02,$a4,$02
	.byt $b1,$00,$20,$f0,$d0,$c9,$20,$f0,$f3,$c9,$30,$90,$03,$c9,$3a,$60
	.byt $38,$60,$20,$87,$f3,$a5,$68,$f0,$19,$10,$21,$38,$a9,$a1,$e5,$68
	.byt $90,$1a,$aa,$ca,$f0,$13,$46,$69,$66,$6a,$66,$6b,$66,$6c,$90,$f3
	.byt $b0,$0a,$a2,$03,$95,$69,$ca,$10,$ea,$a9,$01,$60,$a9,$00,$60,$37
	.byt $6a,$6d,$6b,$20,$75,$79,$38,$6e,$74,$36,$39,$2c,$69,$68,$6c,$35
	.byt $72,$62,$3b,$2e,$6f,$67,$30,$76,$66,$34,$2d,$0b,$70,$65,$2f,$31
	.byt $1b,$7a,$00,$08,$7f,$61,$0d,$78,$71,$32,$5c,$0a,$5d,$73,$00,$33
	.byt $64,$63,$27,$09,$5b,$77,$3d,$26,$4a,$4d,$4b,$20,$55,$59,$2a,$4e
	.byt $54,$5e,$28,$3c,$49,$48,$4c,$25,$52,$42,$3a,$3e,$4f,$47,$29,$56
	.byt $46,$24,$5f,$0b,$50,$45,$3f,$21,$1b,$5a,$00,$08,$7f,$41,$0d,$58
	.byt $51,$40,$7c,$0a,$7d,$53,$00,$23,$44,$43,$22,$09,$7b,$57,$2b,$37
	.byt $6a,$3b,$6b,$20,$75,$79,$38,$6e,$74,$36,$39,$2c,$69,$68,$6c,$35
	.byt $72,$62,$6d,$2e,$6f,$67,$30,$76,$66,$34,$2d,$0b,$70,$65,$2f,$31
	.byt $1b,$77,$00,$08,$7f,$71,$0d,$78,$61,$32,$5c,$0a,$5d,$73,$00,$33
	.byt $64,$63,$27,$09,$5b,$7a,$3d,$26,$4a,$3a,$4b,$20,$55,$59,$2a,$4e
	.byt $54,$5e,$28,$3c,$49,$48,$4c,$25,$52,$42,$4d,$3e,$4f,$47,$29,$56
	.byt $46,$24,$5f,$0b,$50,$45,$3f,$21,$1b,$57,$00,$08,$7f,$51,$0d,$58
	.byt $41,$40,$7c,$0a,$7d,$53,$00,$23,$44,$43,$22,$09,$7b,$5a,$2b,$7d
	.byt $6a,$2c,$6b,$20,$75,$79,$21,$6e,$74,$7e,$5c,$3b,$69,$68,$6c,$28
	.byt $72,$62,$6d,$3a,$6f,$67,$40,$76,$66,$2f,$29,$0b,$70,$65,$3d,$26
	.byt $1b,$77,$00,$08,$7f,$71,$0d,$78,$61,$7b,$3c,$0a,$24,$73,$00,$22
	.byt $64,$63,$7c,$09,$60,$7a,$2d,$37,$4a,$3f,$4b,$20,$55,$59,$38,$4e
	.byt $54,$36,$39,$2e,$49,$48,$4c,$35,$52,$42,$4d,$5d,$4f,$47,$30,$56
	.byt $46,$34,$27,$0b,$50,$45,$2b,$31,$23,$57,$00,$08,$7f,$51,$0d,$58
	.byt $41,$32,$3e,$0a,$2a,$53,$00,$33,$44,$43,$25,$09,$5b,$5a,$5e,$1c
	.byt $22,$10,$48,$00,$c8,$1c,$22,$1c,$22,$3e,$22,$e2,$08,$10,$3e,$20
	.byt $3c,$20,$fe,$0e,$90,$3c,$10,$fe,$d4,$3e,$20,$3c,$20,$fe,$1c,$22
	.byt $a0,$22,$1c,$08,$1c,$22,$1c,$02,$1e,$22,$de,$dc,$1c,$22,$3e,$22
	.byt $e2,$10,$08,$a2,$22,$dc,$10,$08,$3e,$20,$3c,$20,$fe,$1e,$68,$2c
	.byt $68,$de,$08,$14,$3e,$20,$3c,$20,$fe,$00,$08,$10,$3f,$10,$08,$c0
	.byt $08,$1c,$2a,$88,$48,$00,$04,$02,$3f,$02,$04,$c0,$88,$48,$2a,$1c
	.byt $08,$18,$24,$18,$80,$c0,$48,$3e,$48,$00,$fe,$08,$10,$1c,$22,$3e
	.byt $20,$de,$d4,$1c,$22,$3e,$20,$de,$d4,$18,$88,$dc,$c0,$1e,$a0,$1e
	.byt $08,$08,$d4,$a2,$dc,$10,$08,$1c,$02,$1e,$22,$de,$00,$c8,$fe,$08
	.byt $c0,$10,$08,$1c,$22,$3e,$20,$de,$c0,$1e,$28,$2c,$28,$de,$08,$14
	.byt $1c,$22,$3e,$20,$de,$10,$30,$10,$12,$04,$08,$1e,$04,$10,$30,$14
	.byt $12,$14,$08,$de,$30,$10,$30,$22,$24,$08,$1e,$04,$1c,$22,$1c,$a2
	.byt $dc,$80,$80,$40,$88,$48,$00,$c8,$94,$80,$40,$54,$3e,$14,$3e,$54
	.byt $00,$08,$1e,$28,$1c,$0a,$3c,$c8,$30,$32,$04,$08,$10,$26,$c6,$10
	.byt $68,$10,$2a,$24,$da,$88,$80,$40,$08,$10,$a0,$10,$c8,$08,$04,$82
	.byt $04,$c8,$08,$2a,$1c,$08,$1c,$2a,$c8,$00,$48,$3e,$48,$40,$80,$40
	.byt $48,$10,$80,$3e,$80,$00,$80,$40,$04,$40,$00,$02,$04,$08,$10,$20
	.byt $40,$1c,$22,$26,$2a,$32,$22,$dc,$08,$18,$88,$08,$dc,$1c,$22,$02
	.byt $04,$08,$10,$fe,$3e,$02,$04,$0c,$02,$22,$dc,$04,$0c,$14,$24,$3e
	.byt $44,$00,$3e,$20,$3c,$42,$22,$dc,$0c,$10,$20,$3c,$22,$22,$dc,$3e
	.byt $02,$04,$08,$90,$00,$1c,$62,$1c,$62,$dc,$1c,$62,$1e,$02,$04,$d8
	.byt $40,$08,$40,$08,$40,$40,$08,$40,$48,$10,$04,$08,$10,$20,$10,$08
	.byt $c4,$40,$3e,$00,$3e,$80,$10,$08,$04,$02,$04,$08,$d0,$1c,$22,$04
	.byt $48,$00,$c8,$1c,$22,$2a,$2e,$2c,$20,$de,$08,$14,$62,$3e,$62,$00
	.byt $3c,$62,$3c,$62,$fc,$1c,$22,$a0,$22,$dc,$3c,$a2,$62,$fc,$3e,$60
	.byt $3c,$60,$fe,$3e,$60,$3c,$a0,$00,$1e,$a0,$26,$22,$de,$a2,$3e,$a2
	.byt $00,$1c,$88,$48,$dc,$82,$02,$02,$22,$dc,$22,$24,$28,$30,$28,$24
	.byt $e2,$a0,$a0,$fe,$22,$36,$6a,$a2,$00,$62,$32,$2a,$26,$62,$00,$1c
	.byt $62,$a2,$dc,$3c,$62,$3c,$a0,$00,$1c,$a2,$2a,$24,$da,$3c,$62,$3c
	.byt $28,$24,$e2,$1c,$22,$20,$1c,$02,$22,$dc,$3e,$88,$88,$00,$a2,$a2
	.byt $dc,$a2,$62,$14,$c8,$a2,$6a,$36,$e2,$62,$14,$08,$14,$62,$00,$62
	.byt $14,$88,$c8,$3e,$02,$04,$08,$10,$20,$fe,$1e,$90,$50,$de,$00,$20
	.byt $10,$08,$04,$02,$40,$3c,$84,$44,$fc,$08,$14,$2a,$88,$c8,$0e,$90
	.byt $3c,$10,$fe,$0c,$12,$2d,$69,$2d,$12,$0c,$40,$1c,$02,$1e,$22,$1e
	.byt $00,$60,$3c,$a2,$fc,$40,$1e,$a0,$de,$42,$1e,$a2,$de,$40,$1c,$22
	.byt $3e,$20,$de,$0c,$12,$10,$3c,$90,$00,$40,$1c,$62,$1e,$02,$1c,$60
	.byt $3c,$a2,$e2,$c8,$18,$88,$dc,$04,$00,$0c,$84,$24,$18,$60,$22,$24
	.byt $38,$24,$e2,$18,$88,$48,$dc,$40,$36,$aa,$e2,$40,$3c,$a2,$e2,$40
	.byt $1c,$a2,$dc,$40,$3c,$62,$3c,$60,$40,$1e,$62,$1e,$42,$40,$2e,$30
	.byt $a0,$00,$40,$1e,$20,$1c,$02,$fc,$50,$3c,$50,$12,$cc,$40,$a2,$26
	.byt $da,$40,$a2,$14,$c8,$40,$62,$6a,$f6,$40,$22,$14,$08,$14,$e2,$40
	.byt $a2,$1e,$02,$1c,$40,$3e,$04,$08,$10,$fe,$0e,$58,$30,$58,$ce,$88
	.byt $88,$48,$38,$4c,$06,$4c,$f8,$2a,$15,$2a,$15,$2a,$15,$2a,$15,$40
	.byt $08,$3c,$3e,$3c,$c8,$00,$38,$07,$3f,$a9,$b9,$2c,$0d,$02,$10,$02
	.byt $a9,$9d,$a0,$00,$84,$00,$85,$01,$98,$48,$20,$b2,$fe,$68,$18,$69
	.byt $01,$c9,$40,$d0,$f4,$a5,$01,$e9,$03,$85,$0c,$e9,$04,$85,$01,$a9
	.byt $8f,$a0,$fb,$85,$02,$84,$03,$a0,$00,$a2,$00,$a1,$02,$aa,$e6,$02
	.byt $d0,$02,$e6,$03,$20,$9f,$fe,$8a,$29,$c0,$f0,$ed,$c9,$c0,$f0,$08
	.byt $c9,$40,$f0,$06,$20,$9f,$fe,$2c,$a2,$00,$20,$9f,$fe,$d0,$da,$8a
	.byt $29,$3f,$91,$00,$c8,$d0,$0a,$e6,$01,$a5,$01,$c5,$0c,$d0,$02,$68
	.byt $68,$60,$a2,$03,$86,$02,$48,$29,$03,$aa,$bd,$45,$fe,$91,$00,$c8
	.byt $91,$00,$c8,$a6,$02,$e0,$02,$f0,$07,$91,$00,$c8,$d0,$02,$e6,$01
	.byt $68,$4a,$4a,$c6,$02,$d0,$df,$60,$a0,$05,$2c,$a0,$0b,$a2,$05,$b9
	.byt $eb,$fe,$95,$04,$88,$ca,$10,$f7,$4c,$6c,$cd,$00,$b4,$80,$bb,$00
	.byt $98,$00,$98,$80,$9f,$00,$b4,$18,$24,$38,$66,$00,$85,$15,$84,$16
	.byt $a0,$00,$20,$27,$ff,$f0,$1f,$20,$31,$ff,$e6,$15,$d0,$02,$e6,$16
	.byt $20,$27,$ff,$91,$02,$c8,$c0,$08,$d0,$f6,$98,$18,$65,$15,$85,$15
	.byt $90,$de,$e6,$16,$b0,$da,$60,$24,$00,$10,$03,$b1,$15,$60,$4c,$11
	.byt $04,$a2,$13,$86,$03,$0a,$26,$03,$0a,$26,$03,$0a,$26,$03,$85,$02
	.byt $2c,$0d,$02,$30,$06,$a5,$03,$69,$1c,$85,$03,$60,$c9,$04,$f0,$35
	.byt $c9,$05,$f0,$38,$0a,$29,$06,$85,$00,$aa,$ad,$75,$02,$29,$f9,$05
	.byt $00,$8d,$75,$02,$bd,$90,$ff,$bc,$91,$ff,$85,$2a,$84,$2b,$20,$49
	.byt $fe,$ad,$75,$02,$29,$06,$c9,$04,$d0,$07,$a9,$98,$a0,$ff,$4c,$f9
	.byt $fe,$c9,$02,$d0,$0a,$a9,$aa,$a0,$ff,$4c,$f9,$fe,$4c,$49,$fe,$60
	.byt $3f,$fa,$af,$fa,$1f,$fb,$1f,$fb,$5b,$1c,$22,$1c,$02,$1e,$22,$1e
	.byt $00,$60,$1c,$22,$00,$22,$22,$26,$1a,$00,$7b,$04,$08,$1c,$22,$3e
	.byt $20,$1e,$00,$7d,$10,$08,$1c,$22,$3e,$20,$1e,$00,$40,$10,$08,$1c
	.byt $02,$1e,$22,$1e,$00,$5c,$00,$00,$1e,$20,$20,$20,$1e,$04,$7c,$10
	.byt $08,$22,$22,$22,$26,$1a,$00,$7e,$1c,$22,$1c,$22,$3e,$20,$1c,$00
	.byt $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byt $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,
#define NMI_VECTOR $fffa
#define IRQ_VECTOR $fffe
	
	.byt $00,$2f
	.byt $00,$c0
	.byt $fa,$02

