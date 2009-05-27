#define maxlen (20) /* Length of strings */

#define galsize (256)
#define AlienItems (16)
#define lasttrade AlienItems

unsigned int base0=0x5A4A;
unsigned int base1=0x0248;
unsigned int base2=0xB753;  /* Base seed for galaxy 1 */

char pairs0[]="ABOUSEITILETSTONLONUTHNO";
/* must continue into .. */
char pairs[] = "..LEXEGEZACEBISO"
               "USESARMAINDIREA."
               "ERATENBERALAVETI"
               "EDORQUANTEISRION"; /* Dots should be nullprint characters */


char govnames[][maxlen]={"Anarchy","Feudal","Multi-gov","Dictatorship",
                    "Communist","Confederacy","Democracy","Corporate State"};

char econnames[][maxlen]={"Rich Ind","Average Ind","Poor Ind","Mainly Ind",
                      "Mainly Agri","Rich Agri","Average Agri","Poor Agri"};



char unitnames[][5] ={"t","kg","g"};

//#define CMARKET

#ifdef CMARKET

typedef struct
{                         /* In 6502 version these were: */
   unsigned char baseprice;        /* one byte */
   signed char gradient;         /* five bits plus sign */
   unsigned char basequant;        /* one byte */
   unsigned char maskbyte;         /* one byte */
   unsigned char units;            /* two bits */
   unsigned char name[20];       /* longest="Radioactives" */
  } tradegood ;

/* Data for DB's price/availability generation system */
/*                   Base  Grad Base Mask Un   Name
                     price ient quant     it              */ 

#define POLITICALLY_CORRECT	0
/* Set to 1 for NES-sanitised trade goods */

tradegood commodities[]=
                   {
                    {0x13,-0x02,0x06,0x01,0,"Food        "},
                    {0x14,-0x01,0x0A,0x03,0,"Textiles    "},
                    {0x41,-0x03,0x02,0x07,0,"Radioactives"},
#if POLITICALLY_CORRECT
                    {0x28,-0x05,0xE2,0x1F,0,"Robot Slaves"},
                    {0x53,-0x05,0xFB,0x0F,0,"Beverages   "},
#else
                    {0x28,-0x05,0xE2,0x1F,0,"Slaves      "},
                    {0x53,-0x05,0xFB,0x0F,0,"Liquor/Wines"},
#endif 
                    {0xC4,+0x08,0x36,0x03,0,"Luxuries    "},
#if POLITICALLY_CORRECT
                    {0xEB,+0x1D,0x08,0x78,0,"Rare Species"},
#else
                    {0xEB,+0x1D,0x08,0x78,0,"Narcotics   "},
#endif 
                    {0x9A,+0x0E,0x38,0x03,0,"Computers   "},
                    {0x75,+0x06,0x28,0x07,0,"Machinery   "},
                    {0x4E,+0x01,0x11,0x1F,0,"Alloys      "},
                    {0x7C,+0x0d,0x1D,0x07,0,"Firearms    "},
                    {0xB0,-0x09,0xDC,0x3F,0,"Furs        "},
                    {0x20,-0x01,0x35,0x03,0,"Minerals    "},
                    {0x61,-0x01,0x42,0x07,1,"Gold        "},
                    {0xAB,-0x02,0x37,0x1F,1,"Platinum    "},
                    {0x2D,-0x01,0xFA,0x0F,2,"Gem-Strones "},
                    {0x35,+0x0F,0xC0,0x07,0,"Alien Items "},
                   };




typedef struct
{
  unsigned char quantity[lasttrade+1];
  unsigned int price[lasttrade+1];
} markettype ;

#else

/* This two are needed due to the C printing function. Will be deleted once it is
   done in assembly */

char Names[][20]={
    "Food        ",
    "Textiles    ",
    "Radioactives",
    "Slaves      ",
    "Liquor/Wines",
    "Luxuries    ",
    "Narcotics   ",
    "Computers   ",
    "Machinery   ",
    "Alloys      ",
    "Firearms    ",
    "Furs        ",
    "Minerals    ",
    "Gold        ",
    "Platinum    ",
    "Gem-Strones ",
    "Alien Items ",
};

unsigned int Units[]={ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 2, 0  };


#endif

typedef struct
{ char a,b,c,d;
} fastseedtype;  /* four byte random number used for planet description */


typedef struct
{ int w0;
  int w1;
  int w2;
} seedtype;  /* six byte random number used as seed for planets */


typedef struct
{	 
   unsigned char x;
   unsigned char y;       /* One byte unsigned */
   unsigned char economy; /* These two are actually only 0-7  */
   unsigned char govtype;   
   unsigned char techlev; /* 0-16 i think */
   unsigned char population;   /* One byte */
   unsigned int productivity; /* Two byte */
   unsigned int radius; /* Two byte (not used by game at all) */
   fastseedtype	goatsoupseed;
   char name[12];
} plansys ;

seedtype seed;
fastseedtype rnd_seed;
plansys system;


/* Player workspace */
unsigned int   shipshold[lasttrade+1];  /* Contents of cargo bay */
//unsigned char  currentplanet;           /* Current planet */
//unsigned char  galaxynum;               /* Galaxy number (1-8) */
//unsigned long   cash;
//unsigned int   fuel;
//markettype localmarket;
#ifdef CMARKET
markettype market;
#else
unsigned char quantities[lasttrade+1];
unsigned int prices[lasttrade+1];
#endif
//unsigned int   holdspace;

int fuelcost =2; /* 0.2 CR/Light year */
int maxfuel =70; /* 7.0 LY tank */



extern void tweakseed();
extern void makesystem();
extern void print_colonial();
extern void goat_soup2(const char *source);
extern void gotoplanet(int num);

#ifdef 0
void goat_soup(const char *source,plansys * psy);
#endif

printsystem()
{
 printf("\n\nSystem:  ");
 printf(system.name);
 printf(" position (%d,",(int)system.x);
 printf("%d)",system.y);
 printf("\nEconomy: (%d) ",system.economy);
 printf(econnames[system.economy]);
 printf("\nGovernment: (%d) ",system.govtype);
 printf(govnames[system.govtype]);
 printf("\nTech Level: %d ",(system.techlev)+1);
 printf("Turnover: %d",(unsigned int)(system.productivity));
 printf("\nRadius: %d",system.radius);
 //printf("\nPopulation: %d Billion",(system.population)>>3);
 printf("\nPopulation: %f Billion\n",(float)(system.population)/10);//(system.population)>>3);
 //	printf("--\n");
 show_human_colonial();

 rnd_seed = system.goatsoupseed;
 // goat_soup("\x8F is \x97.",&system);
 goat_soup2("\x8F is \x97.");
 //getchar();
}


void show_human_colonial(void) {
 
  printf("(");
  print_colonial();
  printf("s)\n");
  
}

#ifdef 0
gotoplanet(int num)
{
  int i;
  printf ("(%d %d) ",i,num);

  seed.w0=base0; 
  seed.w1=base1; 
  seed.w2=base2; /* Initialise seed for galaxy 1 */  

  for (i=0;i<num;i++){
    tweakseed();
    tweakseed();
    tweakseed();
    tweakseed();
 }

}
#endif

#ifdef CMARKET
genmarket(signed char fluct)
/* Prices and availabilities are influenced by the planet's economy type
   (0-7) and a random "fluctuation" byte that was kept within the saved
   commander position to keep the market prices constant over gamesaves.
   Availabilities must be saved with the game since the player alters them
   by buying (and selling(?))

   Almost all operations are one byte only and overflow "errors" are
   extremely frequent and exploited.

   Trade Item prices are held internally in a single byte=true value/4.
   The decimal point in prices is introduced only when printing them.
   Internally, all prices are integers.
   The player's cash is held in four bytes. 
 */

{	
  unsigned short i;
  for(i=0;i<=lasttrade;i++)
  {	signed int q; 
    signed int product = (system.economy)*(commodities[i].gradient);
    signed int changing = fluct & (commodities[i].maskbyte);
		q =  (commodities[i].basequant) + changing - product;	
    q = q&0xFF;
    if(q&0x80) {q=0;};                       /* Clip to positive 8-bit */

    market.quantity[i] = (unsigned int)(q & 0x3F); /* Mask to 6 bits */

    q =  (commodities[i].baseprice) + changing + product;
    q = q & 0xFF;
    market.price[i] = (unsigned int) (q*4);
  }
	market.quantity[AlienItems] = 0; /* Override to force nonavailability */
	return ;
}



void displaymarket()
{	unsigned short i;
 	for(i=0;i<=lasttrade;i++)
 	{ printf("\n");
   printf(commodities[i].name);
   printf("   %f",((float)(market.price[i])/10));
   printf("   %d",market.quantity[i]);
   printf(unitnames[commodities[i].units]);
   printf("   %d",shipshold[i]);
 }
}	

#else
void displaymarket()
{	unsigned short i;
 	for(i=0;i<=lasttrade;i++)
 	{ printf("\n");
   printf(Names[i]);
   printf("   %f",(float)prices[i]/10);
   printf("   %d",quantities[i]);
   printf(unitnames[Units[i]]);
   printf("   %d",shipshold[i]);
 }
}	

#endif

main()
{

    int i;
    unsigned int dest;
 
    printf("-- Elite universe --\n");
    
    gotoplanet(7);
    makesystem();
    printsystem();

    //getchar();getchar();
    genmarket(0);
    displaymarket();
    //printf("\n--\n");
    //getchar();
 

    for (;;)
    {
     //getchar();
     printf("\n");
     printf("New planet? "); 
     scanf("%d",&dest);
     printf("\n");
     gotoplanet(dest);
     makesystem();
     printsystem();
     //getchar();
     genmarket(0);
     displaymarket();
     //printf("\n--\n");
     //getchar();
     //printf("%d,%d,%d\n",(unsigned int)seed.w0,(unsigned int)seed.w1,(unsigned int)seed.w2);
    }


}


#ifdef 0
/* "Goat Soup" planetary description string code - adapted from Christian Pinder's
  reverse engineered sources. */

struct desc_choice {	const char *option[5];};

struct desc_choice desc_list[] =
{
/* 81 */	{"fabled", "notable", "well known", "famous", "noted"},
/* 82 */	{"very", "mildly", "most", "reasonably", ""},
/* 83 */	{"ancient", "\x95", "great", "vast", "pink"},
/* 84 */	{"\x9E \x9D plantations", "mountains", "\x9C", "\x94 forests", "oceans"},
/* 85 */	{"shyness", "silliness", "mating traditions", "loathing of \x86", "love for \x86"},
/* 86 */	{"food blenders", "tourists", "poetry", "discos", "\x8E"},
/* 87 */	{"talking tree", "crab", "bat", "lobst", "\xB2"},
/* 88 */	{"beset", "plagued", "ravaged", "cursed", "scourged"},
/* 89 */	{"\x96 civil war", "\x9B \x98 \x99s", "a \x9B disease", "\x96 earthquakes", "\x96 solar activity"},
/* 8A */	{"its \x83 \x84", "the \xB1 \x98 \x99","its inhabitants' \x9A \x85", "\xA1", "its \x8D \x8E"},
/* 8B */	{"juice", "brandy", "water", "brew", "gargle blasters"},
/* 8C */	{"\xB2", "\xB1 \x99", "\xB1 \xB2", "\xB1 \x9B", "\x9B \xB2"},
/* 8D */	{"fabulous", "exotic", "hoopy", "unusual", "exciting"},
/* 8E */	{"cuisine", "night life", "casinos", "sit coms", " \xA1 "},
/* 8F */	{"\xB0", "The planet \xB0", "The world \xB0", "This planet", "This world"},
/* 90 */	{"n unremarkable", " boring", " dull", " tedious", " revolting"},
/* 91 */	{"planet", "world", "place", "little planet", "dump"},
/* 92 */	{"wasp", "moth", "grub", "ant", "\xB2"},
/* 93 */	{"poet", "arts graduate", "yak", "snail", "slug"},
/* 94 */	{"tropical", "dense", "rain", "impenetrable", "exuberant"},
/* 95 */	{"funny", "wierd", "unusual", "strange", "peculiar"},
/* 96 */	{"frequent", "occasional", "unpredictable", "dreadful", "deadly"},
/* 97 */	{"\x82 \x81 for \x8A", "\x82 \x81 for \x8A and \x8A", "\x88 by \x89", "\x82 \x81 for \x8A but \x88 by \x89","a\x90 \x91"},
/* 98 */	{"\x9B", "mountain", "edible", "tree", "spotted"},
/* 99 */	{"\x9F", "\xA0", "\x87oid", "\x93", "\x92"},
/* 9A */	{"ancient", "exceptional", "eccentric", "ingrained", "\x95"},
/* 9B */	{"killer", "deadly", "evil", "lethal", "vicious"},
/* 9C */	{"parking meters", "dust clouds", "ice bergs", "rock formations", "volcanoes"},
/* 9D */	{"plant", "tulip", "banana", "corn", "\xB2weed"},
/* 9E */	{"\xB2", "\xB1 \xB2", "\xB1 \x9B", "inhabitant", "\xB1 \xB2"},
/* 9F */	{"shrew", "beast", "bison", "snake", "wolf"},
/* A0 */	{"leopard", "cat", "monkey", "goat", "fish"},
/* A1 */	{"\x8C \x8B", "\xB1 \x9F \xA2","its \x8D \xA0 \xA2", "\xA3 \xA4", "\x8C \x8B"},
/* A2 */	{"meat", "cutlet", "steak", "burgers", "soup"},
/* A3 */	{"ice", "mud", "Zero-G", "vacuum", "\xB1 ultra"},
/* A4 */	{"hockey", "cricket", "karate", "polo", "tennis"}
};

/* B0 = <planet name>
	 B1 = <planet name>ian
	 B2 = <random name>
*/

int gen_rnd_number (void)
{	int a,x;
	x = (rnd_seed.a * 2) & 0xFF;
	a = x + rnd_seed.c;
	if (rnd_seed.a > 127)	a++;
	rnd_seed.a = a & 0xFF;
	rnd_seed.c = x;

	a = a / 256;	/* a = any carry left from above */
	x = rnd_seed.b;
	a = (a + x + rnd_seed.d) & 0xFF;
	rnd_seed.b = a;
	rnd_seed.d = x;
	return a;
}

void goat_soup(const char *source,plansys * psy)
{	
    unsigned char c;
    for(;;)
	{	c=*(source); source++;
		if(c=='\0')	break;
		if(c<(unsigned char)0x80) putchar(c);//printf("%c",c);
		else
		{	if (c <=(unsigned char)0xA4)
			{	int rnd = gen_rnd_number();
				goat_soup(desc_list[c-0x81].option[(rnd >= (unsigned char)0x33)+(rnd >= (unsigned char)0x66)+(rnd >= (unsigned char)0x99)+(rnd >= (unsigned char)0xCC)],psy);
			}
			else switch(c)
			{ case 0xB0: /* planet name */
		 		{ int i=1;
					putchar(psy->name[0]);//printf("%c",psy->name[0]);
					while(psy->name[i]!='\0') putchar(tolower(psy->name[i++]));//printf("%c",tolower(psy->name[i++]));
				}	break;
				case 0xB1: /* <planet name>ian */
				{ int i=1;
					printf("%c",psy->name[0]);
					while(psy->name[i]!='\0')
					{	if((psy->name[i+1]!='\0') || ((psy->name[i]!='E')	&& (psy->name[i]!='I')))
						putchar(tolower(psy->name[i]));//printf("%c",tolower(psy->name[i]));
						i++;
					}
					printf("ian");
				}	break;
				case 0xB2: /* random name */
				{	int i;
					int len = gen_rnd_number() & 3;
					for(i=0;i<=len;i++)
					{	int x = gen_rnd_number() & 0x3e;
						if(pairs0[x]!='.') putchar(pairs0[x]);//printf("%c",pairs0[x]);
						if(i && (pairs0[x+1]!='.')) putchar(pairs0[x+1]);//printf("%c",pairs0[x+1]);
					}
				}	break;
				default: printf("<bad char in data [%X]>",c); return;
			}	/* endswitch */
		}	/* endelse */
	}	/* endwhile */
}	/* endfunc */

/**+end **/

#endif