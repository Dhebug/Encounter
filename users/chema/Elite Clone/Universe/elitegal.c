

#define maxlen (20) /* Length of strings */

#define galsize (256)
#define AlienItems (16)
#define lasttrade AlienItems

unsigned int base0=0x5A4A;
unsigned int base1=0x0248;
unsigned int base2=0xB753;  /* Base seed for galaxy 1 */



#undef maxlen


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
plansys hyp_system;


/* Player workspace */
unsigned int   shipshold[lasttrade+1];  /* Contents of cargo bay */
unsigned char  currentplanet;           /* Current planet */
unsigned char  galaxynum;               /* Galaxy number (1-8) */
unsigned long  cash;                    /* four bytes for cash */
unsigned int   fuel;                    /* Amount of fuel, can this be a byte? */    
unsigned char  fluct;                   /* price fluctuation */



unsigned char quantities[lasttrade+1];
unsigned int prices[lasttrade+1];
unsigned int   holdspace;
//seedtype localseed;
plansys cpl_system;


unsigned char dest_num;
unsigned char current_name[9]; 


#define SCR_MARKET  1
#define SCR_SYSTEM  2
#define SCR_GALAXY  3
#define SCR_CHART   4

unsigned char current_screen;

//markettype localmarket;
//int fuelcost =2; /* 0.2 CR/Light year */
//int maxfuel =70; /* 7.0 LY tank */



extern void tweakseed();
extern void makesystem();
extern void print_colonial();
extern void infoplanet();
extern void printsystem();
extern void search_planet(char * name);
extern void move_cross_v(int dist);


void jump()
{
    
    printf("Jumping to planet %s (%d)\n",hyp_system.name,dest_num);
    currentplanet=dest_num;
    //savename(current_name,hyp_system.name);
    strcpy(current_name,hyp_system.name);
    cpl_system=hyp_system;
    genmarket();
    displaymarket();
}


main()
{

    unsigned int i;
    char n[12];

    char * p;
    p=(char *)0x24e;  
    *p=5;
    p=(char *)0x24f;  
    *p=1; 

   
    //plot_galaxy();

    hires();

    init_print();

    galaxynum=1;
    dest_num=7;
    infoplanet();
    makesystem();
    /*printsystem();*/
    
    jump();    
    fluct=0;
    genmarket();
    
    //getchar();getchar();
    //genmarket(0);
    //displaymarket();
    //printf("\n--\n");
    //getchar();
    i=0;

    for (;;)
    {
    i=getchar();

    switch(i)
    {
        case 'M':
            current_screen=SCR_MARKET;
            displaymarket();
            break;
        case 'J':
            jump();
            break;
        case 'H':
            enter_next_galaxy();
            jump();   
            break;

        case 'P':
            current_screen=SCR_SYSTEM;
            printsystem();
            break;
        case 'R':
            //current_screen=SCR_SYSTEM;
            printf("Search planet? ");
            gets(n);
            search_planet(n);
            //printsystem();
            break;
        case 'Z':
            current_screen=SCR_SYSTEM;
            printf("New planet? ");
            scanf("%d",&dest_num);
            printf("\n\n");
            infoplanet();
            makesystem();
            printsystem();
            break;
        case 'G':
            current_screen=SCR_GALAXY;
            plot_galaxy();
            break;
        case 'C':
            current_screen=SCR_CHART;
            plot_chart();
            break;
    
        case 'Q':
            move_cross_v(-2);
            break;
        case 'A':
            move_cross_v(2);
            break;
        case 'S':
            move_cross_h(-2);
            break;
        case 'D':
            move_cross_h(2);
            break;
        case ' ':
            find_planet();
            break;

    }
    }
         
   
}


