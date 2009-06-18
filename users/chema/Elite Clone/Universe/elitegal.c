

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
unsigned long  cash;
unsigned int   fuel;

unsigned char quantities[lasttrade+1];
unsigned int prices[lasttrade+1];
unsigned int   holdspace;
//seedtype localseed;
plansys cpl_system;

unsigned char fluct;

unsigned char dest_num;
unsigned char current_name[9]; 

//markettype localmarket;
//int fuelcost =2; /* 0.2 CR/Light year */
//int maxfuel =70; /* 7.0 LY tank */



extern void tweakseed();
extern void makesystem();
extern void print_colonial();
extern void infoplanet(int num);
extern void printsystem();
extern void search_planet(char * name);
extern void move_cross_v(int dist);

/*
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
 printf(" Population: %f Billion\n",(float)(system.population)/10);//(system.population)>>3);
 printf("(");
 print_colonial();
 printf("s)\n");
 printf("--\n");
 
 rnd_seed = system.goatsoupseed;
 // goat_soup("\x8F is \x97.",&system);
 goat_soup2("\x8F is \x97.");
 printf("--\n");
}

*/
/*
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
*/

/*   int i,x,y;

void plot_galaxy()
{
 

    hires();

    gotoplanet(0);
    
    
    for (i=0;i<256;i++)
    {
     x=((seed.w1)>>8)&0xff;
     y=((seed.w0)>>8)&0xff;
     x=x>>1&0xff;
     x=x>>2&0xff;
     curset(x+30,y+30,1);

     tweakseed();
     tweakseed();
     tweakseed();
     tweakseed();

    }


}*/

void jump()
{
    
    printf("Jumping to planet %s (%d)\n",hyp_system.name,dest_num);
    currentplanet=dest_num;
    //savename(current_name,hyp_system.name);
    strcpy(current_name,hyp_system.name);
    cpl_system=hyp_system;
    genmarket(0);
    displaymarket();
}

/*
void savename(char * dest, char * name)
{
    unsigned int k=0;
    unsigned int i;

    for (i=0;name[i];i++)
    {
      if (name[i]!='.') dest[k++]=name[i];
    }
    dest[k]=0;
}*/
/*
void search_planet(char * name)
{
   unsigned int i;
   unsigned char found=0;
 
   for (i=0;i<256;i++)
   {
    infoplanet(i);
    makesystem();
    if (!strcmp(name,hyp_system.name)){
        found=1;
        break;
    }

    }

   if (!found){
     printf("System not found\n");
     infoplanet(dest_num);
     makesystem();
    }
  else{
    dest_num=i;
    //makesystem();
    }  

}*/

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

    infoplanet(7);
    makesystem();
    printsystem();
    dest_num=7;
    jump();    
    genmarket(0);
    
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
            displaymarket();
            break;
        case 'J':
            jump();
            break;
        case 'P':
            printsystem();
            break;
        case 'R':
            printf("Search planet? ");
            gets(n);
            search_planet(n);
            //printsystem();
            break;
        case 'Z':
            printf("New planet? ");
            scanf("%d",&dest_num);
            printf("\n\n");
            infoplanet(dest_num);
            makesystem();
            printsystem();
            break;
        case 'G':
            plot_galaxy();
            break;
        case 'C':
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


