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
	.byt $4f,$c7,$52,$58 ;  racine du generateur aleatoire, soit 0,811630249
	lda #$E8 ; %11101000 soit banque 0 
	sta $0321 ;  dans V2DRA 
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
; $c4d6
lc4d6
loop
.(
	dey 
	bne loop ; 
.)
lc4d9
	lda $0310 ;  ordre traite 
lc4db
	lsr 
lc4dc
	bcs $C4D9 ; non 
lc4de	
	rts  ; oui, on sort 
lc4df

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
	
	.byt $2c
	

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
	.byt $00,$00
	jmp $04AF ;  $0411 . lecture d'une donnee Durant BRK 
	jmp $0000 ;  $0414 . vecteur d'execution inter-banque VEXBNK 
	.byt $00,$00
	
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
	; dsqdsq 

	
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
	
/******************************/

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
	clc  ; C=0 et A est intact 
	rts 
	pla  ; ecriture ratee, C=1, A restaure 
	rts 
	
	clc  ; ($C5A6) 
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
	rts  ; position dans le buffer 

		.byt $c4
	.byt $c5,$80,$c6,$80,$c6,$00,$c8,$00,$c8,$00,$ca,$00,$ca,$00,$d2
	
	

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
	rts  ; et on sort si l'imprimante n'a pas repondu 
	
		/**********************************************/	
	

	
	lda $020D ;  
	ora #$02 ; on indique imprimante detectee 
	sta $020D ;  dans FLGTEL 
	rts  ; 2et on sort 

			
	ldx #$00 ; pour canal 0 
	.byt $2c
	ldx #$04 ; pour canal 1 
	.byt $2c
	ldx #$08 ; pour canal 2 
	.byt $2c
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
	rts  ; En sortie, A contient l'E/S 
	
	
	
	
	/*
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
	rts  ; l'E/S n'etait pas ouverte 
	
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
	
	*****
	
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
	
	 ;  
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
	*/




	
	.byt $a0,$0f,$d9,$ae,$02,$f0,$0f,$88,$10,$f8,$86
	.byt $19,$48,$a0,$80,$aa,$20,$1c,$c8,$a6,$19,$68,$9d,$ae,$02,$18,$60
	
	.byt $a2,$00,$2c,$a2,$04,$2c,$a2,$08,$2c,$a2,$0c,$a0,$03,$c9,$00,$f0
	.byt $1d,$dd,$ae,$02,$f0,$05,$e8,$88,$10,$f7,$60
	
	.byt $5e,$ae,$02,$a2,$0f
	.byt $dd,$ae,$02,$f0,$f5,$ca,$10,$f8,$aa,$a0,$81,$4c,$1c,$c8,$5e,$ae
	.byt $02,$e8,$88,$10,$f9,$60
	
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

	
	
	.byt $a2,$00,$2c,$a2,$04,$2c,$a2,$08
	.byt $2c,$a2,$0c,$86,$1c,$85,$15,$84,$16,$a5,$1c,$85,$19,$a0,$00,$20
	.byt $11,$04,$f0,$e3,$20,$72,$c7,$e6,$15,$d0,$ee,$e6,$16,$d0,$ea,$a9
	.byt $00,$2c,$a9,$04,$2c,$a9,$08,$2c,$a9,$0c,$85,$19,$a9,$04,$85,$1a
	.byt $8a,$48,$98,$48,$a6,$19,$bd,$ae,$02,$10,$0e,$c9,$88,$b0,$0a,$aa
	.byt $a0,$40,$20,$1c,$c8,$85,$1d,$90,$06,$e6,$19,$c6,$1a,$d0,$e5,$68
	.byt $a8,$68,$aa,$a5,$1d,$60
	
	.byt $a9,$00,$2c,$a9,$04,$2c,$a9,$08,$2c,$a9
	.byt $0c,$85,$1b,$a5,$1b,$20,$da,$c7,$b0,$f9,$38,$60
	
	.byt $84,$17,$84,$18
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
	.byt $1e,$03,$29,$f3,$90,$02,$29,$fe,$8d,$1e,$03,$68,$a8,$60
	
	.byt $ce,$15
	.byt $02,$d0,$50,$a9,$04,$8d,$15,$02,$2c,$8a,$02,$10,$03,$20,$2f,$ca
	.byt $a5,$44,$d0,$02,$c6,$45,$c6,$44,$38,$ee,$10,$02,$ad,$10,$02,$e9
	.byt $0a,$90,$30,$8d,$10,$02,$2c,$14,$02,$10,$03,$20,$75,$ca,$ee,$11
	.byt $02,$a5,$42,$d0,$02,$c6,$43,$c6,$42,$ad,$11,$02,$e9,$3c,$90,$13
	.byt $8d,$11,$02,$ee,$12,$02,$ad,$12,$02,$e9,$3c,$90,$06,$8d,$12,$02
	.byt $ee,$13,$02,$ce,$16,$02,$d0,$19,$a9,$0a,$8d,$16,$02,$ad,$17,$02
	.byt $49,$80,$8d,$17,$02,$2c,$48,$02,$10,$07,$70,$05,$a6,$28,$4c,$2d
	.byt $de,$60
	
	
	.byt $ad,$0d,$03,$29,$20,$f0,$20,$ad,$8f,$02,$ac,$90,$02,$8d
	.byt $08,$03,$8c,$09,$03,$ad,$8c,$02,$4a,$90,$06,$20,$85,$e0,$4c,$b9
	.byt $c8,$a9,$ff,$8d,$09,$03,$4c,$b9,$c8,$2c,$0d,$03,$30,$0e,$24,$1e
	.byt $10,$07,$a6,$22,$a4,$23,$4c,$00,$04,$4c,$b6,$c8,$46,$1e,$2c,$0d
	.byt $03,$50,$4c,$2c,$04,$03,$20,$1e,$c9,$ce,$a6,$02,$d0,$22,$20,$df
	.byt $d7,$20,$bf,$c8,$2c,$70,$02,$10,$07,$a9,$14,$8d,$a7,$02,$d0,$0b
	.byt $ad,$a8,$02,$2c,$a7,$02,$30,$05,$ce,$a7,$02,$a9,$01,$8d,$a6,$02
	.byt $2c,$8c,$02,$10,$06,$20,$fa,$df,$2c,$8c,$02,$50,$03,$20,$fb,$df
	.byt $ad,$8c,$02,$4a,$90,$03,$20,$e1,$e0,$4c,$b9,$c8,$4c,$92,$c9,$ad
	.byt $0d,$03,$29,$02,$f0,$f6,$2c,$01,$03,$20,$2f,$ca,$4c,$b9,$c8,$a2
	.byt $24,$20,$18,$c5,$90,$08,$0e,$8a,$02,$38,$6e,$8a,$02,$60
	
	.byt $8d,$01
	.byt $03,$ad,$00,$03,$29,$ef,$8d,$00,$03,$09,$10,$8d,$00,$03,$0e,$8a
	.byt $02,$4e,$8a,$02,$60
	
	.byt $a9,$00,$a2,$04,$9d,$10,$02,$ca,$10,$fa,$a9
	.byt $01,$8d,$15,$02,$60
	
	.byt $4e,$14,$02,$60
		
	
	
	
	/*

	
	

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
	sec  ; C=1 
	rts  ; on gere le code 

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


*/
	
	

	.byt $08,$78,$85,$40,$84,$41,$38
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

