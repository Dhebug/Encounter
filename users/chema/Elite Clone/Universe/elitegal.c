

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
unsigned char  name[32]="Jameson";      /* Commander's name */
unsigned int   shipshold[lasttrade+1];  /* Contents of cargo bay */
unsigned char  currentplanet;           /* Current planet */
unsigned char  galaxynum=1;             /* Galaxy number (1-8) */
unsigned char  cash[4]={0xd0,0x07,0,0}; /* four bytes for cash */
unsigned char  fuel=70;                 /* Amount of fuel, can this be a byte? */    
unsigned char  fluct;                   /* price fluctuation */
unsigned int   holdspace=20;            /* Current space used? */
unsigned char  legal_status=50;         /* Current legal status 0=Clean, <50=Offender, >50=Fugitive */
unsigned int   score=60000;             /* Score. Can this be just two bytes? */
unsigned char  mission=0;               /* Current mission */
unsigned int   equip=0xfff;             /* Equipment flags */



unsigned char quantities[lasttrade+1];
unsigned int prices[lasttrade+1];
//seedtype localseed;
plansys cpl_system;


unsigned char dest_num;
//unsigned char current_name[9]; 


#define SCR_INFO    0
#define SCR_MARKET  1
#define SCR_SYSTEM  2
#define SCR_GALAXY  3
#define SCR_CHART   4
#define SCR_EQUIP   5

unsigned char current_screen=0;

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


/*void jump()
{
    
    //printf("Jumping to planet %s (%d)\n",hyp_system.name,dest_num);
    currentplanet=dest_num;
    //savename(current_name,hyp_system.name);
    //strcpy(current_name,hyp_system.name);
    cpl_system=hyp_system;
    genmarket();
    displaymarket();
    current_screen=SCR_MARKET;

}*/


main()
{

    unsigned int i;
    char n[12];

    char * p;
    p=(char *)0x24e;  
    *p=8;
    p=(char *)0x24f;  
    *p=1; 

    hires();

    init_print();

    galaxynum=1;
    dest_num=7;
    infoplanet();
    makesystem();
    /*printsystem();*/
    
    jump();
    fluct=0;
    current_screen=SCR_MARKET;

    //holdspace=20;
    
 /*   cash[0]=0xd0;  
    cash[1]=0x7;
    cash[2]=0;
    cash[3]=0;*/

/*
    cash[0]=0;//0xd0;  
    cash[1]=0xc2;//0x7;
    cash[2]=0xeb;//0;
    cash[3]=0xb;//0; */
    //genmarket();
    //displaymarket();
    //current_screen=SCR_MARKET;

    
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
        case 'E':
            current_screen=SCR_EQUIP;
            displayequip();
            break;
        case 'L':
            current_screen=SCR_INFO;
            displayinfo();
            break;
        case 'M':
            current_screen=SCR_MARKET;
            displaymarket();
            break;
        case 'J':
            jump();
            current_screen=SCR_MARKET;
            break;
        case 'H':
            enter_next_galaxy();
            current_screen=SCR_MARKET;
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
            if (current_screen == SCR_MARKET)
                dec_sel();
            else
                move_cross_v(-2);
            break;
        case 'A':
            if (current_screen == SCR_MARKET)
                inc_sel();
            else
                move_cross_v(2);
            break;
        case 'S':
            if (current_screen == SCR_MARKET)
                sell();
            else
                move_cross_h(-2);
            break;
        case 'D':
            if (current_screen == SCR_MARKET)
                buy();
            else
                move_cross_h(2);
            break;
        case ' ':
            find_planet();
            break;

    }
    }
         
   
}


