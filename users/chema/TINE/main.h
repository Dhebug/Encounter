#ifndef MAIN_H
#define MAIN_H


#define SCR_FRONT   0
#define SCR_INFO    1
#define SCR_MARKET  2
#define SCR_SYSTEM  3
#define SCR_GALAXY  4
#define SCR_CHART   5
#define SCR_EQUIP   6
#define SCR_LOADSAVE 7

/* Attributes */
#define A_FWBLACK        0
#define A_FWRED          1
#define A_FWGREEN        2
#define A_FWYELLOW       3
#define A_FWBLUE         4
#define A_FWMAGENTA      5
#define A_FWCYAN         6
#define A_FWWHITE        7
#define A_BGBLACK       16
#define A_BGRED         17
#define A_BGGREEN       18
#define A_BGYELLOW      19
#define A_BGBLUE        20
#define A_BGMAGENTA     21
#define A_BGCYAN        22
#define A_BGWHITE       23

/* To access plansys records */

//typedef struct
//{	 
//   unsigned char x;
//   unsigned char y;       /* One byte unsigned */
//   unsigned char economy; /* These two are actually only 0-7  */
//   unsigned char govtype;   
//   unsigned char techlev; /* 0-16 i think */
//   unsigned char population;   /* One byte */
//   unsigned int productivity; /* Two byte */
//   unsigned int radius; /* Two byte (not used by game at all) */
//   fastseedtype	goatsoupseed;
//   char name[12];
//} plansys ; 

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



// Player equipment flags
//#define EQ_FUEL			1
//#define EQ_MISSILE		2
#define EQ_PULSELASER	 1
#define EQ_LARGECARGO	 2
#define EQ_ESCAPEPOD	 4
#define EQ_SCOOPS		 8
#define EQ_ECM			 16
#define EQ_ENERGYBOMB	 32
#define EQ_EXTRAENERGY	 64		
#define EQ_GALACTICHYPER 128

// High byte
#define EQ_BEAMLASER	 1
#define EQ_MILLASER		 2
#define EQ_EXTRASPEED	 4
#define EQ_EXTRAMAN		 8
#define EQ_EXTRAFUEL	 16
#define EQ_FUELPROCESSOR 32 

// Missions
#define HAVE_MISSIONS	
#define NUM_SECT_MISSION_CODE 6
#define MISSION_CODE_START	$a000-NUM_SECT_MISSION_CODE*256



#endif


