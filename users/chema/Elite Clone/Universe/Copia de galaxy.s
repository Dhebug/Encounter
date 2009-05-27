

; Functions to re-create galaxy and market of Elite
; adapted from the TextElite C source


; Attributes 
#define A_FWBLACK        0
#define A_FWRED          1
#define A_FWGREEN        2
#define A_FWYELLOW       3
#define A_FWBLUE         4
#define A_FWMAGENTA      5
#define A_FWCYAN         6
#define A_FWWHITE        7

;typedef struct
;{ char a,b,c,d;
;} fastseedtype;  /* four byte random number used for planet description */


;typedef struct
;{ int w0;
;  int w1;
;  int w2;
;} seedtype;  /* six byte random number used as seed for planets */



;typedef struct
;{	 
;   unsigned char x;
;   unsigned char y;       /* One byte unsigned */
;   unsigned char economy; /* These two are actually only 0-7  */
;   unsigned char govtype;   
;   unsigned char techlev; /* 0-16 i think */
;   unsigned char population;   /* One byte */
;   unsigned int productivity; /* Two byte */
;   unsigned int radius; /* Two byte (not used by game at all) */
;   fastseedtype	goatsoupseed;
;   char name[12];
;} plansys ;


#define SYSX 0
#define SYSY 1
#define ECONOMY 2
#define GOVTYPE 3
#define TECHLEV 4
#define POPUL   5
#define PROD    6
#define RADIUS  8
#define SEED    10
#define NAME    14




;typedef struct
;{                         /* In 6502 version these were: */
;   unsigned char baseprice;        /* one byte */
;   signed char gradient;         /* five bits plus sign */
;   unsigned char basequant;        /* one byte */
;   unsigned char maskbyte;         /* one byte */
;   unsigned char units;            /* two bits */
;   unsigned char name[20];       /* longest="Radioactives" */
;  } tradegood ;


; Following the original 6502 Elite, this is split into two tables and compressed a bit
; so that the goods characteristics are stored in a 4-byte record.
; However it is usually a good idea to keep everything into separate lists. This is how 
; I will do it. I am wasting 1 byte per record (17 bytes total), but will keep code smaller and easier
; to follow. In addition, we can add more things if necessary.
; Contets of the table are:

;tradegood commodities[]=
;                   {
;                    {0x13,-0x02,0x06,0x01,0,"Food        "},
;                    {0x14,-0x01,0x0A,0x03,0,"Textiles    "},
;                    {0x41,-0x03,0x02,0x07,0,"Radioactives"},
;                    {0x28,-0x05,0xE2,0x1F,0,"Slaves      "},
;                    {0x53,-0x05,0xFB,0x0F,0,"Liquor/Wines"},
;                    {0xC4,+0x08,0x36,0x03,0,"Luxuries    "},
;                    {0xEB,+0x1D,0x08,0x78,0,"Narcotics   "},
;                    {0x9A,+0x0E,0x38,0x03,0,"Computers   "},
;                    {0x75,+0x06,0x28,0x07,0,"Machinery   "},
;                    {0x4E,+0x01,0x11,0x1F,0,"Alloys      "},
;                    {0x7C,+0x0d,0x1D,0x07,0,"Firearms    "},
;                    {0xB0,-0x09,0xDC,0x3F,0,"Furs        "},
;                    {0x20,-0x01,0x35,0x03,0,"Minerals    "},
;                    {0x61,-0x01,0x42,0x07,1,"Gold        "},
;                    {0xAB,-0x02,0x37,0x1F,1,"Platinum    "},
;                    {0x2D,-0x01,0xFA,0x0F,2,"Gem-Strones "},
;                    {0x35,+0x0F,0xC0,0x07,0,"Alien Items "},
;                   };



;genmarket(signed char fluct)
;/* Prices and availabilities are influenced by the planet's economy type
;   (0-7) and a random "fluctuation" byte that was kept within the saved
;   commander position to keep the market prices constant over gamesaves.
;   Availabilities must be saved with the game since the player alters them
;   by buying (and selling(?))
;
;   Almost all operations are one byte only and overflow "errors" are
;   extremely frequent and exploited.
;
;   Trade Item prices are held internally in a single byte=true value/4.
;   The decimal point in prices is introduced only when printing them.
;   Internally, all prices are integers.
;   The player's cash is held in four bytes. 
; */

; Digrams

_pairs0 .asc "ABOUSEITILETSTONLONUTHNO"
_pairs  .asc "..LEXEGEZACEBISO"
        .asc "USESARMAINDIREA."
        .asc "ERATENBERALAVETI"
        .asc "EDORQUANTEISRION" ;Dots should be nullprint characters 


; Goat soup dictionary

; Call entry string
gs_init_str
        .byt $8f
        .asc " is "
        .byt $97
        .asc "."
        .byt 0


; And dictionary
ian_str
    .asc "ian"
    .byt 0

desc_list
;81
    .asc "fabled"
    .byt 0
    .asc "notable"
    .byt 0
    .asc "well known"
    .byt 0
    .asc "famous"
    .byt 0
    .asc "noted"
    .byt 0
;82
    .asc "very"
    .byt 0
    .asc "mildly"
    .byt 0
    .asc "most"
    .byt 0
    .asc "reasonably"
    .byt 0
    .asc " "
    .byt 0

;83	
    .asc "ancient"
    .byt 0
    .byt $95,0
    .asc "great"
    .byt 0
    .asc "vast"
    .byt 0
    .asc "pink"
    .byt 0

;84
    .byt $9E," ", $9D," ",
    .asc "plantations"
    .byt 0
    .asc "mountains"
    .byt 0
    .byt $9C, 0
    .byt $94
    .asc " forests"
    .byt 0
    .asc "oceans"
    .byt 0
;85	
    .asc "shyness"
    .byt 0
    .asc "silliness"
    .byt 0
    .asc "mating traditions"
    .byt 0
    .asc "loathing of "
    .byt $86, 0
    .asc "love for "
    .byt $86,0
;86
    .asc "food blenders"
    .byt 0
    .asc "tourists"
    .byt 0
    .asc "poetry"
    .byt 0
    .asc  "discos"
    .byt 0
    .byt $8E
    .byt 0

;87
    .asc "talking tree"
    .byt 0
    .asc "crab"
    .byt 0
    .asc "bat"
    .byt 0
    .asc "lobst"
    .byt 0
    .byt $B2
    .byt 0

;88
    .asc "beset"
    .byt 0
    .asc "plagued"
    .byt 0
    .asc "ravaged"
    .byt 0
    .asc "cursed"
    .byt 0
    .asc "scourged"
    .byt 0

;89
    .byt $96
    .asc " civil war"
    .byt 0
    .byt $9B," ", $98," ", $99
    .asc "s"
    .byt 0
    .asc "a "
    .byt $9B
    .asc " disease"
    .byt 0
    .byt $96
    .asc " earthquakes"
    .byt 0
    .byt $96
    .asc " solar activity"
    .byt 0

;8A
    .asc "its "
    .byt $83," ", $84
    .byt 0
    .asc "the "
    .byt $B1," ", $98," ", $99
    .byt 0
    .asc "its inhabitants' "
    .byt $9A," ", $85
    .byt 0
    .byt $a1, 0
    .asc "its "
    .byt $8D," ", $8E
    .byt 0

;8B
    .asc "juice"
    .byt 0
    .asc "brandy"
    .byt 0
    .asc "water"
    .byt 0
    .asc "brew"
    .byt 0
    .asc "gargle blasters"
    .byt 0

;8C
    .byt $B2,0
    .byt $B1," ", $99, 0
    .byt $B1," ", $B2, 0
    .byt $B1," ", $9B, 0
    .byt $9B," ", $B2, 0

;8D	
    .asc "fabulous"
    .byt 0
    .asc "exotic"
    .byt 0
    .asc "hoopy"
    .byt 0
    .asc "unusual"
    .byt 0
    .asc "exciting"
    .byt 0

;8E	
    .asc "cuisine"
    .byt 0
    .asc "night life"
    .byt 0
    .asc "casinos"
    .byt 0
    .asc "sit coms"
    .byt 0
    .byt " ", $A1, " ", 0

;8F
    .asc $B0, 0
    .asc "The planet "
    .byt $B0, 0
    .asc "The world "
    .byt $B0, 0
    .asc "This planet"
    .byt 0
    .asc "This world"
    .byt 0

;90
    .asc "n unremarkable"
    .byt 0
    .asc " boring"
    .byt 0
    .asc " dull"
    .byt 0
    .asc " tedious"
    .byt 0
    .asc " revolting"
    .byt 0

;91
    .asc "planet"
    .byt 0
    .asc "world"
    .byt 0
    .asc "place"
    .byt 0
    .asc "little planet"
    .byt 0
    .asc "dump"
    .byt 0

;92
    .asc "wasp"
    .byt 0
    .asc "moth"
    .byt 0
    .asc "grub"
    .byt 0
    .asc "ant"
    .byt 0
    .byt $B2
    .byt 0

;93
    .asc "poet"
    .byt 0
    .asc "arts graduate"
    .byt 0
    .asc "yak"
    .byt 0
    .asc "snail"
    .byt 0
    .asc "slug"
    .byt 0

;94
    .asc "tropical"
    .byt 0
    .asc "dense"
    .byt 0
    .asc "rain"
    .byt 0
    .asc "impenetrable"
    .byt 0
    .asc "exuberant"
    .byt 0

;95
    .asc "funny"
    .byt 0
    .asc "wierd"
    .byt 0
    .asc "unusual"
    .byt 0
    .asc "strange"
    .byt 0
    .asc "peculiar"
    .byt 0

;96
    .asc "frequent"
    .byt 0
    .asc "occasional"
    .byt 0
    .asc "unpredictable"
    .byt 0
    .asc "dreadful"
    .byt 0
    .asc "deadly"
    .byt 0

;97
    .byt $82," ", $81
    .asc " for "
    .byt $8A,0
    .byt $82," ", $81
    .asc " for "
    .byt $8A
    .asc " and "
    .byt $8A
    .byt 0
    .byt $88
    .asc " by "
    .byt $89 ,0
    .byt $82," ", $81
    .asc " for "
    .byt $8A
    .asc " but "
    .byt $88
    .asc " by "
    .byt $89,0
    .asc "a"
    .byt $90," ", $91,0
;98
    .byt $9B
    .byt 0
    .asc "mountain"
    .byt 0
    .asc "edible"
    .byt 0
    .asc "tree"
    .byt 0
    .asc "spotted"
    .byt 0

;99
    .byt $9F
    .byt 0
    .byt $A0
    .byt 0
    .byt $87
    .asc "oid"
    .byt 0
    .byt $93
    .byt 0
    .byt $92
    .byt 0

;9A
    .asc "ancient"
    .byt 0
    .asc "exceptional"
    .byt 0
    .asc "eccentric"
    .byt 0
    .asc "ingrained"
    .byt 0
    .byt $95
    .byt 0

;9B
    .asc "killer"
    .byt 0
    .asc "deadly"
    .byt 0
    .asc "evil"
    .byt 0
    .asc "lethal"
    .byt 0
    .asc "vicious"
    .byt 0

;9C
    .asc "parking meters"
    .byt 0
    .asc "dust clouds"
    .byt 0
    .asc "ice bergs"
    .byt 0
    .asc "rock formations"
    .byt 0
    .asc "volcanoes"
    .byt 0

;9D
    .asc "plant"
    .byt 0
    .asc "tulip"
    .byt 0
    .asc "banana"
    .byt 0
    .asc "corn"
    .byt 0
    .byt $B2
    .asc "weed"
    .byt 0

;9E
    .byt $B2
    .byt 0
    .byt $B1," ", $B2, 0
    .byt $B1," ", $9B, 0
    .asc "inhabitant"
    .byt 0
    .byt $B1, " ", $B2, 0

;9F
    .asc "shrew"
    .byt 0
    .asc "beast"
    .byt 0
    .asc "bison"
    .byt 0
    .asc "snake"
    .byt 0
    .asc "wolf"
    .byt 0

;A0
    .asc "leopard"
    .byt 0
    .asc "cat"
    .byt 0
    .asc "monkey"
    .byt 0
    .asc "goat"
    .byt 0
    .asc "fish"
    .byt 0

;A1
    .byt $8C, " ", $8B, 0
    .byt $B1, " ", $9F, " ", $A2, 0
    .asc "its "
    .byt $8D, " ", $A0, " ", $A2, 0
    .byt $A3, " ", $A4, 0
    .byt $8C, " ", $8B, 0

;A2
    .asc "meat"
    .byt 0
    .asc "cutlet"
    .byt 0
    .asc "steak"
    .byt 0
    .asc "burgers"
    .byt 0
    .asc "soup"
    .byt 0

;A3
    .asc "ice"
    .byt 0
    .asc "mud"
    .byt 0
    .asc "Zero-G"
    .byt 0
    .asc "vacuum"
    .byt 0
    .byt $B1
    .asc " ultra"
    .byt 0

;A4
    .asc "hockey"
    .byt 0
    .asc "cricket"
    .byt 0
    .asc "karate"
    .byt 0
    .asc "polo"
    .byt 0
    .asc "tennis"
    .byt 0

count .byt 0
fluct .byt 0
_genmarket
.(
    ; Keep C parameter passing for now
    ldy #0
    lda (sp),y
    sta fluct
    	
    ;unsigned short i;
    ;for(i=0;i<=lasttrade;i++)

    lda #16
    sta count
loop
      
  ;{
	;signed int q; 
    ;signed int product = (system.economy)*(commodities[i].gradient);
    ;signed int changing = fluct & (commodities[i].maskbyte);
	;	q =  (commodities[i].basequant) + changing - product;	

    lda #0
    ;beq loop
    sta op1+1
    sta op2+1
 
    lda _system+ECONOMY
    sta op1
    ldx count
    lda Gradients,x
    bpl positive2
    dec op2+1
positive2
    sta op2
    jsr mul16 ; SHOUDL USE FAST 8-BIT MULT FROM LIB3D!!
    
     
    ldx count
    lda Maskbytes,x
    and fluct
    pha
    clc
    adc Basequants,x
    sec
    sbc op1

    ;q = q&0xFF;
    ;if(q&0x80) {q=0;};                       /* Clip to positive 8-bit */

    bpl positive
    lda #0
positive    

    ;market.quantity[i] = (unsigned int)(q & 0x3F); /* Mask to 6 bits */
    and #$3f
    sta _quantities,x

    ;q =  (commodities[i].baseprice) + changing + product;
    ;q = q & 0xFF;
    ;market.price[i] = (unsigned int) (q*4);
    pla     ; get changing
    clc
    adc Baseprices,x
    adc op1
    ldy #0
    sty tmp+1
    asl
    rol tmp+1
    asl
    rol tmp+1
    sta tmp
    txa
    asl
    tax
    lda tmp
    sta _prices,x
    lda tmp+1
    sta _prices+1,x
    
    dec count
    bpl loop

    ;}

	;market.quantity[AlienItems] = 0; /* Override to force nonavailability */
	
    ldx #16
    lda #0
    sta _quantities,x

   ;return ;
    rts
.)
                

                
                
;               
;void tweakseed()
;{              
;  unsigned int temp;
;  temp = ((seed).w0)+((seed).w1)+((seed).w2); /* 2 byte aritmetic */
;  (seed).w0 = (seed).w1;
;  (seed).w1 = (seed).w2;
;  (seed).w2 = temp;
;}              
                
_tweakseed      
.(              
    lda _seed ; LO of seed.w0
    clc
    adc _seed+2; LO of seed.w1
    sta tmp
    lda _seed+1; HI of seed.w0
    adc _seed+3; HI of seed.w1
    sta tmp+1
    
    lda _seed+4 ; LO of seed.w2
    clc  
    adc tmp
    sta tmp
    lda _seed+5
    adc tmp+1
    sta tmp+1

    ldx #1
loop
    lda _seed+2,x
    sta _seed,x

    lda _seed+4,x
    sta _seed+2,x

    lda tmp,x
    sta _seed+4,x

    dex
    bpl loop
    rts
    
.)

; Get to a planet number
num .byt 0
;gotoplanet(int num)
_gotoplanet
.(
;  seed.w0=base0; 
;  seed.w1=base1; 
;  seed.w2=base2; /* Initialise seed for galaxy 1 */  ;
    ldx #5
loop
    lda _base0,x
    sta _seed,x
    dex
    bpl loop

    ldy #0
    lda (sp),y
    beq end
    sta num
 
;  for (i=0;i<num;i++){
;    tweakseed();
;    tweakseed();
;;    tweakseed();
;    tweakseed();
; }
    ; Will use reg y, as it is not used in tweakseed
loop3   
    ldy #4    
loop2
    jsr _tweakseed
    dey
    bne loop2
    
    dec num
    bne loop3
end    
    rts 

;}
.)


; /**-Generate system info from seed **/

_makesystem
.(

    ;unsigned int pair1,pair2,pair3,pair4;
    ;unsigned int longnameflag;
    
    ;system.x=((seed.w1)>>8);
    ;system.y=((seed.w0)>>8);
  
    lda _seed+3  ; HI part of seed.w1
    sta _system+SYSX 
    lda _seed+1
    sta _system+SYSY    

    ; system.govtype =(((seed.w1)>>3)&7); /* bits 3,4 &5 of w1 */  
    lda _seed+2
    lsr
    lsr
    lsr
    and #7
    sta _system+GOVTYPE
  
    ;system.economy =(((seed.w0)>>8)&7); /* bits 8,9 &A of w0 */
    lda _seed+1
    and #%00000111
    sta _system+ECONOMY

    ;if (system.govtype <=1)
    ;{ system.economy = ((system.economy)|2);
    ;} 

    lda _system+GOVTYPE
    bpl nothing
    lda _system+ECONOMY
    ora #2
    sta _system+ECONOMY  
nothing  
    ;system.techlev =(((seed.w1)>>8)&3)+((system.economy)^7);
    ;system.techlev +=((system.govtype)>>1);
    ;if (((system.govtype)&1)==1)	system.techlev+=1;
    ;/* C simulation of 6502's LSR then ADC */

    lda _system+ECONOMY
    eor #7
    sta tmp
    lda _seed+3
    and #3
    clc
    adc tmp
    sta tmp
    lda _system+GOVTYPE
    lsr
    adc tmp
    sta _system+TECHLEV
    
    ;system.population = 4*(system.techlev) + (system.economy);
    ;system.population +=  (system.govtype) + 1;
   
;    sta _system+POPUL
;    lda #0
;    sta _system+POPUL+1
; 
;    asl _system+POPUL
;    rol _system+POPUL+1
;    clc
;    asl _system+POPUL
;    rol _system+POPUL+1    
    
;    lda _system+POPUL
    
    asl
    asl

    clc
    adc _system+ECONOMY
;    bne nocarry2
;    inc _system+POPUL+1
;nocarry2
;    sta _system+POPUL
    
;    lda _system+GOVTYPE
;    clc
;    adc _system+POPUL
;    bne nocarry
;    inc _system+POPUL+1
;nocarry
    clc
    adc _system+GOVTYPE
    clc
    adc #1

    sta _system+POPUL

    ;system.productivity = (((system.economy)^7)+3)*((system.govtype)+4);
    ;system.productivity *= (system.population)*8;
    
    lda _system+ECONOMY
    eor #7
    clc
    adc #3
    sta op1
    lda #0
    sta op1+1
    sta op2+1
    
    lda _system+GOVTYPE
    clc
    adc #4
    sta op2

    jsr mul16uc
    ; 16-bit result in op1,op1+1
    
    lda #0
    sta op2+1

    lda _system+POPUL
    
    ldx #3
loop
    asl 
    rol op2+1
    dex
    bne loop

    sta op2

    jsr mul16uc

    lda op1
    sta _system+PROD
    lda op1+1
    sta _system+PROD+1


    ;system.radius = 256*((((seed.w2)>>8)&15)+11) + system.x;  

    lda _seed+5
    and #15
    clc
    adc #11
    sta _system+RADIUS+1
    lda _system+SYSX
    sta _system+RADIUS


	;system.goatsoupseed.a = seed.w1 & 0xFF;;
	;system.goatsoupseed.b = seed.w1 >>8;
	;system.goatsoupseed.c = seed.w2 & 0xFF;
	;system.goatsoupseed.d = seed.w2 >> 8;
    ldx #3
loop3
    lda _seed+2,x
    sta _system+SEED,x
    dex
    bpl loop3    

    jmp name_planet ; This is jsr/rts

    ;return;
    ;rts  
.)  


; Generate planet's name
; Uses a temporal seed
temp_seed .dsb 6

name_planet
.(

     ; Save seed
     ldx #5
loop4
     lda _seed,x
     sta temp_seed,x
     dex
     bpl loop4

    ;longnameflag=(seed.w0)&64;
     lda _seed
     and #64
     pha

     ;pair1=2*(((seed.w2)>>8)&31);  tweakseed();
     ;pair2=2*(((seed.w2)>>8)&31);  tweakseed();
     ;pair3=2*(((seed.w2)>>8)&31);  tweakseed();
     ;pair4=2*(((seed.w2)>>8)&31);	tweakseed();
     ; /* Always four iterations of random number */

     ldx #0
     stx loop2+1
loop2
     ldx #00
   
     lda _seed+5
     and #31
     asl
     sta tmp0,x
     jsr _tweakseed
 
     inc loop2+1
     lda #4
     cmp loop2+1
     bne loop2    

     ;(system.name)[0]=pairs[pair1];
     ;(system.name)[1]=pairs[pair1+1];
     ;(system.name)[2]=pairs[pair2];
     ;(system.name)[3]=pairs[pair2+1];
     ;(system.name)[4]=pairs[pair3];
     ;(system.name)[5]=pairs[pair3+1];
      ; if(longnameflag) /* bit 6 of ORIGINAL w0 flags a four-pair name */
     ;{
     ;(system.name)[6]=pairs[pair4];
     ;(system.name)[7]=pairs[pair4+1];
     ;(system.name)[8]=0;
     ;}
     ;else (system.name)[6]=0;

    ldy tmp0
    lda _pairs,y
    sta _system+NAME
    lda _pairs+1,y
    sta _system+NAME+1
     
    ldy tmp0+1
    lda _pairs,y
    sta _system+NAME+2
    lda _pairs+1,y
    sta _system+NAME+3
 
    ldy tmp0+2
    lda _pairs,y
    sta _system+NAME+4
    lda _pairs+1,y
    sta _system+NAME+5

    pla
    bne cont    
    lda #0  
    sta _system+NAME+6  
    beq end    
cont

    ldy tmp0+3
    lda _pairs,y
    sta _system+NAME+6
    lda _pairs+1,y
    sta _system+NAME+7

    lda #0  
    sta _system+NAME+8  


end
    ; restore seed
     ldx #5
loop1
     lda temp_seed,x
     sta _seed,x
     dex
     bpl loop1


    rts
.)




; Searches for a string. tmp0 holds pointer to base and x holds offset (in strings).
search_string
.(
    txa
    bne cont
    rts
cont
    ldy #0
loop
    lda (tmp0),y
    beq out    ; Search for zero
    iny
    bne loop

out
    ; Found the end. Add length to pointer    
    iny 
    tya
    clc
    adc tmp0
    bcc nocarry
    inc tmp0+1
nocarry
    sta tmp0    

    dex
    bne cont
    
    rts

.)




; Prints the colonial type

_print_colonial
.(

    ;if (hyp_seed.s4 & 0x80) {
    ;// bug-eyed rabbits
 
    lda _seed+4
    bpl humans
    ;and #$80
    ;beq humans

   ;int ct = (hyp_seed.s5/4)&7;
    ;if (ct < 3) {
    ;  text2buffer(FIERCE+ct);
    ;  text2buffer(' ');
    ;  textmod = NAME_CASE;
    ;}

    lda _seed+5
    lsr
    lsr
    and #7
    cmp #3
    bcs cont1

    ; Print Fierce
    tax
    lda #<Fierce
    sta tmp0
    lda #>Fierce
    sta tmp0+1
    jsr search_string
    jsr print2
    jsr put_space

cont1
    
    ;ct = (hyp_seed.s5/32);
    ;if (ct < 6) {
    ;  text2buffer(CREATURE_TYPE+ct);
    ;  text2buffer(' ');
    ;  textmod = NAME_CASE;
    ;}

    lda _seed+5
    lsr
    lsr
    lsr
    lsr
    lsr
    cmp #6
    bcs cont2

    ; Print Type
    tax
    lda #<Type
    sta tmp0
    lda #>Type
    sta tmp0+1
    jsr search_string
    jsr print2
    jsr put_space


cont2
    ;ct = (hyp_seed.s3^hyp_seed.s1)&7;
    ;if (ct < 6) {
    ;  text2buffer(BUG_EYED+ct);
    ;  text2buffer(' ');
    ;  textmod = NAME_CASE;
    ;}

    lda _seed+3
    eor _seed+1
    and #7
    pha
    cmp #6
    bcs cont3

    ; Print bug-eyed
    tax
    lda #<Bugeyed
    sta tmp0
    lda #>Bugeyed
    sta tmp0+1
    jsr search_string
    jsr print2
    jsr put_space

cont3

    ;ct += (hyp_seed.s5&3);
    ;ct &= 7;
    ;text2buffer(RODENT+ct);
    pla
    sta tmp
    lda _seed+5
    and #3
    clc
    ;adc _seed+5
    adc tmp
    and #7

    ; Print race
    tax
    lda #<Race
    sta tmp0
    lda #>Race
    sta tmp0+1
    jsr search_string
    jsr print2
    rts



;  } else {
;    text2buffer(HUMAN_COLONIAL);
;  }


humans
    lda #<HumanCol
    sta tmp0
    lda #>HumanCol
    sta tmp0+1
    jsr print2
    rts



.)






;; Let's go with my own version of goat_soup....
;; Should be consistent with TXTELITE...

gs_planet_name
.(
;  int i=1;
;  putchar(psy->name[0]);//printf("%c",psy->name[0]);
;  while(psy->name[i]!='\0') putchar(tolower(psy->name[i++]));//printf("%c",tolower(psy->name[i++]));

    ldx #0
firstloop
    lda _system+NAME,x
    cmp #"."
    bne printfirst
    inx
    bne firstloop
printfirst
    stx savx+1
    jsr put_char
savx
    ldx #0
    inx
loop
    lda _system+NAME,x
    beq end
    cmp #"."
    beq noprint
    ora #$20 ; lowcase it
    stx savx2+1
    jsr put_char
savx2
    ldx #0  ; again sfc
noprint
    inx
    jmp loop
end
    rts
.)

gs_planet_nameian
.(
;                       int i=1;
;   					printf("%c",psy->name[0]);
;   					while(psy->name[i]!='\0')
;   					{	if((psy->name[i+1]!='\0') || ((psy->name[i]!='E')	&& (psy->name[i]!='I')))
;   						putchar(tolower(psy->name[i]));//printf("%c",tolower(psy->name[i]));
;   						i++;
;   					}
;   					printf("ian");
    ldx #0
firstloop
    lda _system+NAME,x
    cmp #"."
    bne printfirst
    inx
    bne firstloop
printfirst
    stx savx+1
    jsr put_char
savx
    ldx #0
    inx
loop
    lda _system+NAME,x
    beq end
    cmp #"."
    beq noprint
    ldy _system+NAME+1,x
    bne nocheck
    cmp #"I"
    beq noprint
    cmp #"E"
    beq noprint
nocheck
    ora #$20 ; lowcase it
    stx savx2+1
    jsr put_char
savx2
    ldx #0  ; again sfc
noprint
    inx
    jmp loop
end

    ; print "ian"
    lda #<ian_str
    sta tmp0
    lda #>ian_str
    sta tmp0+1
    jsr print2
    rts

.)

gs_random_name
.(
    ;int i;
	;int len = gen_rnd_number() & 3;
	jsr _gen_rnd_number
    and #3
    sta index
    ;for(i=0;i<=len;i++)
    lda #0
    sta lowcase
loop
	;{	int x = gen_rnd_number() & 0x3e;
    jsr _gen_rnd_number
    and #$3e
    tay
    ;	if(pairs0[x]!='.') printf("%c",pairs0[x]);
    lda _pairs0,y
    ;beq l1
    cmp #"."
    beq notthis
    ora lowcase
l1
    ldx #$20
    stx lowcase
    jsr put_char
notthis
	;	if(i && (pairs0[x+1]!='.')) printf("%c",pairs0[x+1]);
    lda index
    beq notthat
    iny
    lda _pairs0,y
    ;beq l2
    cmp #"."
    beq notthat
    ora lowcase
l2
    ldx #$20
    stx lowcase
    jsr put_char
notthat

    dec index
    bpl loop
	;}

    rts    
index .byt 00
lowcase .byt 00
.)

gs_jump_lo .byt <gs_planet_name,<gs_planet_nameian,<gs_random_name
gs_jump_hi .byt >gs_planet_name,>gs_planet_nameian,>gs_random_name



#define gs_sourcep tmp6


gs_index .byt 0

;   void goat_soup(const char *source,plansys * psy)
;   {	
; Pass parameters as pointer in x (hi) a (lo)
goat_soup
.(
    
    sta gs_sourcep
    stx gs_sourcep+1
    lda #0
    sta gs_index

main_loop       

;       unsigned char c;
;       for(;;)
;   	{	
;           c=*(source); source++;
;   		if(c=='\0')	break;
    ldy gs_index
    lda (gs_sourcep),y
    bne cont
    rts
cont
;   		if(c<(unsigned char)0x80) putchar(c);//printf("%c",c);

    bmi decode
    jsr put_char
    jmp next
decode
;   		else
;   		{
    ; It is a code...
;       	if (c <=(unsigned char)0xA4)
;   			{	int rnd = gen_rnd_number();
;   				goat_soup(desc_list[c-0x81].option[(rnd >= (unsigned char)0x33)+(rnd >= (unsigned char)0x66)+(rnd >= (unsigned char)0x99)+(rnd >= (unsigned char)0xCC)],psy);
;   			}
    
    cmp #$a5
    bcs code_str
    
    pha
    jsr _gen_rnd_number

    pha        
    lda #0
    sta tmp
    pla

    cmp #$33
    bcc next1
    inc tmp
next1
    cmp #$66
    bcc next2
    inc tmp
next2
    cmp #$99
    bcc next3
    inc tmp
next3
    cmp #$cc
    bcc next4
    inc tmp
next4
    
    ; Multiply c-$81 by 5
    pla
    sec
    sbc #$81
    sta tmp+1
    asl
    asl
    clc
    adc tmp+1
    
    ; Add tmp
    adc tmp

    ; Search for string
    tax
    lda #<desc_list
    sta tmp0
    lda #>desc_list
    sta tmp0+1
    jsr search_string
    
    ; Prepare re-entrant call to goat_soup

    lda gs_index
    pha
    lda gs_sourcep
    pha
    lda gs_sourcep+1
    pha

    lda tmp0
    ldx tmp0+1
    jsr goat_soup

    ; Recover previous params
    pla
    sta gs_sourcep+1
    pla
    sta gs_sourcep
    pla
    sta gs_index

    jmp next
code_str
    ; It is an string code
;   			else switch(c)
;   			{ case 0xB0: /* planet name */
;  		 		{
;                       int i=1;
;   					putchar(psy->name[0]);//printf("%c",psy->name[0]);
;   					while(psy->name[i]!='\0') putchar(tolower(psy->name[i++]));//printf("%c",tolower(psy->name[i++]));
;   				}	break;
;   				case 0xB1: /* <planet name>ian */
;   				{ 
;                       int i=1;
;   					printf("%c",psy->name[0]);
;   					while(psy->name[i]!='\0')
;   					{	if((psy->name[i+1]!='\0') || ((psy->name[i]!='E')	&& (psy->name[i]!='I')))
;   						putchar(tolower(psy->name[i]));//printf("%c",tolower(psy->name[i]));
;   						i++;
;   					}
;   					printf("ian");
;   				}	break;
;   				case 0xB2: /* random name */
;   				{	
;                       int i;
;   					int len = gen_rnd_number() & 3;
;   					for(i=0;i<=len;i++)
;   					{	int x = gen_rnd_number() & 0x3e;
;   						if(pairs0[x]!='.') putchar(pairs0[x]);//printf("%c",pairs0[x]);
;   						if(i && (pairs0[x+1]!='.')) putchar(pairs0[x+1]);//printf("%c",pairs0[x+1]);
;   					}
;   				}	break;
;   				default: printf("<bad char in data [%X]>",c); return;
;   			}	/* endswitch */
    ; Implement this as a jump table
    sec
    sbc #$b0
    tax
    lda gs_jump_lo,x
    sta jump+1
    lda gs_jump_hi,x
    sta jump+2
jump
    jsr $1234   ; This is self-modified...

;   		}	/* endelse */
;   	}	/* endwhile */
;   }	/* endfunc */
;   
;   /**+end **/

next   
    inc gs_index
    jmp main_loop    
.)


;; Elite random function

;int gen_rnd_number (void)
; This is inspired in the reverse engineered
; source of eliteagb
_gen_rnd_number
.(
    ;int A = (g_rand_seed.r0*2)|(*carry!=0);
    ;int X = A&0xff;
    ;A = (X + g_rand_seed.r2 + (A>0xff)); // carry from this used below
    ;g_rand_seed.r0 = A;

    lda _rnd_seed
    rol   ; It is commented that this is the exact code in original Elite, and not asl
    tax
    adc _rnd_seed+2        
    sta _rnd_seed   
  
    ;g_rand_seed.r2 = X;
    txa
    sta _rnd_seed+2
    
    ;A = (g_rand_seed.r1 + g_rand_seed.r3 + (A>0xff));
    ;*carry = (A>0xff);
    ;A&=0xff;
    lda _rnd_seed+1
    clc
    adc _rnd_seed+3
    ;X = g_rand_seed.r1;
    ldx _rnd_seed+1
    
    ;g_rand_seed.r1 = A;
    ;g_rand_seed.r3 = X;
    sta _rnd_seed+1
    stx _rnd_seed+3
    ;return A;
    rts

.)



#define STR_DATA        0
#define STR_DISTANCE    1
#define STR_ECONOMY     2
#define STR_GOV         3
#define STR_TECH        4
#define STR_GROSS       5
#define STR_RADIUS      6
#define STR_POP         7
#define STR_KM          8
#define STR_BILLION     9
#define STR_LY         10
#define STR_CR         11 


diff
.(
    lda tmp
    cmp tmp+1
    bcs ok
    pha
    lda tmp+1
    sta tmp
    pla
    sta tmp+1

ok
    lda tmp
    sec
    sbc tmp+1
    rts

.)

_printsystem
.(

    ; Clear hires and draw frame
    jsr clr_hires

    ; Print title: Data on <planetname>
    lda #1
    sta capson

    ldx #STR_DATA
    jsr printtitle
    jsr gs_planet_name    

    lda #0
    sta capson

    jsr perform_CRLF
    jsr perform_CRLF

    ; Print name
    ; Draw a line
    ; If distance <> 0 print distance
;    lda #0
;dbug
;    beq dbug


    lda _localseed+3  ; Current X pos
    sta tmp
    lda _system+SYSX
    sta tmp+1
    jsr diff
 
    sta op1

    lda _localseed+1
    sta tmp
    lda _system+SYSY    
    sta tmp+1
    jsr diff

    sta sav_a+1
    ora op1
    beq same
    
    ; Show distance as 4*sqrt(x*x+y*y/4)
    lda #0
    sta op1+1
    sta op2+1
    lda op1
    lsr
    sta op1
    sta op2
    jsr mul16

    lda op1
    sta tmp
    lda op1+1
    sta tmp+1
sav_a    
    lda #0
    lsr
    lsr
    sta op1
    sta op2
    lda #0
    sta op1+1
    sta op2+1
    jsr mul16
    
    clc
    lda tmp
    adc op1
    sta op1
    lda tmp+1
    adc op1+1
    sta op1+1
    jsr SqRoot
    
    ; Print distance (at last!)
    ldx #STR_DISTANCE
    jsr printtitle
    lda op2
    asl
    rol op2+1
    asl
    rol op2+1
    asl
    rol op2+1
    sta op2
    jsr print_float  
    ldx #STR_LY
    jsr printtail
    jsr perform_CRLF


same
    ; Print economy        
    ldx #STR_ECONOMY
    jsr printtitle
    ldx _system+ECONOMY
    lda #<econnames
    sta tmp0
    lda #>econnames
    sta tmp0+1
    jsr search_string
    lda tmp0
    ldx tmp0+1
    jsr printnl
    
    ; Print Government
    ldx #STR_GOV
    jsr printtitle
    ldx _system+GOVTYPE
    lda #<govnames
    sta tmp0
    lda #>govnames
    sta tmp0+1
    jsr search_string
    lda tmp0
    ldx tmp0+1
    jsr printnl
    
    ; Print tech level
    ldx #STR_TECH
    jsr printtitle
    lda _system+TECHLEV
    sta op2
    lda #0
    sta op2+1
    jsr print_num
    jsr perform_CRLF
    
    ; Print population
    ldx #STR_POP
    jsr printtitle
    lda _system+POPUL
    sta op2
    lda #0
    sta op2+1
    jsr print_float
    jsr put_space
    ldx #STR_BILLION
    jsr printtail
    jsr perform_CRLF
    jsr perform_CRLF
    jsr put_space
    lda #"("
    jsr put_char
    jsr _print_colonial
    lda #"s"
    jsr put_char
    lda #")"
    jsr put_char
    jsr perform_CRLF
 
   
    ; Print productivity
    ldx #STR_GROSS
    jsr printtitle
    lda _system+PROD
    sta op2
    lda _system+PROD+1
    sta op2+1
    jsr print_num
    ldx #STR_CR
    jsr printtail
    jsr perform_CRLF

     ; Print radius
    ldx #STR_RADIUS
    jsr printtitle
    lda _system+RADIUS
    sta op2
    lda _system+RADIUS+1
    sta op2+1
    jsr print_num
    ldx #STR_KM
    jsr printtail
    jsr perform_CRLF    
    jsr perform_CRLF    

    ; Goatsoup
    ldx #3
loop
    lda _system+SEED,x
    sta _rnd_seed,x
    dex
    bpl loop    
    
    lda #<gs_init_str
    ldx #>gs_init_str
    jsr goat_soup
    
    rts

.)


print_float
.(
    jsr itoa
loop
    ldx #0
text
    lda bufconv+1,x
    beq butone
    lda bufconv,x
    jsr put_char
    inx
    bne text

butone
    lda bufconv,x
    pha
    lda #"."
    jsr put_char
    pla
    jmp put_char    ; This is jsr/rts
    
.)

print_num
.(
    jsr itoa
    lda #<bufconv
    ldx #>bufconv
    jmp print
.)

printtitle
.(

    jsr perform_CRLF

    lda #(A_FWGREEN+A_FWYELLOW*16+128)
    jsr put_code
.)
printtail
.(
    lda #<str_data
    sta tmp0
    lda #>str_data
    sta tmp0+1
    jsr search_string
    lda tmp0    
    ldx tmp0+1
    jsr print

    ;jmp put_space ; This is jsr/rts
    lda #A_FWWHITE
    jmp put_code
    ;rts
.)



;;;; Math functions needed to perform some calculations. These should be revised...


;;; Here goes mul16.  It takes two 16-bit parameters and multiplies them to a 32-bit signed number. The assignments are:
;;;	op1:	multiplier
;;;	op2:	multiplicand
;;; Results go:
;;;	op1:	result LSW
;;;	tmp1:	result HSW
;;; The algorithm used is classical shift-&-add, so the timing depends largely on the number of 1 bits on the multiplier.
;;; This is based on Leventhal / Saville, "6502 Assembly Language Subroutines", as it's compact and general enough, but
;;; it's optimized for speed, sacrificing generality instead.
;;; Max time taken ($ffff * $ffff) is 661 cycles.  Average time is around max time for 8-bit numbers.
;;; Max time taken for 8-bit numbers ($ff * $ff) is 349 cycles.  Average time is 143 cycles.  That's fast enough too.

; Subroutine starts here.

sign .byt 0


mul16
.(
	lda #0
	sta sign

	lda op1+1
	bpl positive1
	
	sec
	lda #0
	sbc op1
	sta op1
	lda #0
	sbc op1+1
	sta op1+1

	lda sign
	eor #$ff
	sta sign

positive1
	lda op2+1
	bpl positive2

	sec
	lda #0
	sbc op2
	sta op2
	lda #0
	sbc op2+1
	sta op2+1

	lda sign
	eor #$ff
	sta sign

positive2

	jsr mul16uc
 
	lda sign
	beq end
	
	; Put sign back
	sec
	lda #0
	sbc op1
	sta op1
	lda #0
	sbc op1+1
	sta op1+1
	lda #0
	sbc tmp1
	sta tmp1
	lda #0
	sbc tmp1+1
	sta tmp1+1

end
	rts

.)

mul16uc
.(
	lda #0
	sta tmp1
	sta tmp1+1
	ldx #17
	clc
_m16_loop
	ror tmp1+1
	ror tmp1
	ror op1+1
	ror op1
	bcc _m16_deccnt
	clc
	lda op2
	adc tmp1
	sta tmp1
	lda op2+1
	adc tmp1+1
	sta tmp1+1
_m16_deccnt
	dex
	bne _m16_loop
	rts
.)



; Calculates the 8 bit root and 9 bit remainder of a 16 bit unsigned integer in
; op1. The result is always in the range 0 to 255 and is held in
; op2, the remainder is in the range 0 to 511 and is held in tmp0
;
; partial results are held in templ/temph
;
; This routine is the complement to the integer square program.
;
; Destroys A, X registers.

; variables - must be in RAM

#define Numberl op1     ; number to find square root of low byte
#define Numberh op1+1   ; number to find square root of high byte
#define Reml    tmp0    ; remainder low byte
#define Remh    tmp0+1	; remainder high byte
#define templ	tmp		; temp partial low byte
#define temph   tmp+1	; temp partial high byte
#define Root	op2		; square root


SqRoot
.(
	LDA	#$00		; clear A
	STA	Reml		; clear remainder low byte
	STA	Remh		; clear remainder high byte
	STA	Root		; clear Root
	LDX	#$08		; 8 pairs of bits to do
Loop
	ASL	Root		; Root = Root * 2

	ASL	Numberl		; shift highest bit of number ..
	ROL	Numberh		;
	ROL	Reml		; .. into remainder
	ROL	Remh		;

	ASL	Numberl		; shift highest bit of number ..
	ROL	Numberh		;
	ROL	Reml		; .. into remainder
	ROL	Remh		;

	LDA	Root		; copy Root ..
	STA	templ		; .. to templ
	LDA	#$00		; clear byte
	STA	temph		; clear temp high byte

	SEC			; +1
	ROL	templ		; temp = temp * 2 + 1
	ROL	temph		;

	LDA	Remh		; get remainder high byte
	CMP	temph		; comapre with partial high byte
	BCC	Next		; skip sub if remainder high byte smaller

	BNE	Subtr		; do sub if <> (must be remainder>partial !)

	LDA	Reml		; get remainder low byte
	CMP	templ		; comapre with partial low byte
	BCC	Next		; skip sub if remainder low byte smaller

				; else remainder>=partial so subtract then
				; and add 1 to root. carry is always set here
Subtr
	LDA	Reml		; get remainder low byte
	SBC	templ		; subtract partial low byte
	STA	Reml		; save remainder low byte
	LDA	Remh		; get remainder high byte
	SBC	temph		; subtract partial high byte
	STA	Remh		; save remainder high byte

	INC	Root		; increment Root
Next
	DEX			; decrement bit pair count
	BNE	Loop		; loop if not all done

	RTS
.)



