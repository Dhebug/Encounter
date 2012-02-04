// main.c by Neil Barnes (a.k.a. Barnsey123)

#include <lib.h>
//#include <math.h>

//#define CHAR_BIT 8
#define NORTH 0
#define SOUTH 1
#define EAST 2
#define WEST 3
#define ENEMYWEIGHT 37

extern unsigned char PictureTiles[];	// standard graphics for pieces and backgrounds
extern unsigned char ExplodeTiles[];	// extra graphics to "explode" a piece (animation)
//extern unsigned char BorderTiles[];		// border on title screens/version screens etc
//extern unsigned char TitleTiles[];		// Defence-Force logo
extern unsigned char RunicTiles[];		// Runic alphabet
/*
; You simply replace the existing font from C doing this:
;
;  extern unsigned char Font_6x8_FuturaFull[1024];
;
; Then to set the HIRES font:
;   memcpy((unsigned char*)0x9800+32*8,Font_6x8_FuturaFull,768);
;
; Or to set the TEXT font:
;   memcpy((unsigned char*)0xb400+32*8,Font_6x8_FuturaFull,768);
;
*/
extern unsigned char Font_6x8_runic1_partial[520]; // runic oric chars (was [1024] 02/02/2012)

/* RUNIC Alphabet Tiles (NOT the runic1 font) ordered as follows :
Actually, the numbers here are not true anymore due to changes in the runes.png file
However, Have left the descriptions for educational purposes...
The Viking "alphabet" begins with "F" and is rEferred to as "FUTHAR" rather than "Alphabet"
0	F: Fehu			Cattle/Gold/General Wealth
1	U: Uruz			Strength/Speed/Good Health
2	TH:	Thurisaz	Norse Giants
3	A:	Ansuz		The Gods, mostly Odin
4	R:	Raido		A long Journey
5	K/C: Kenaz		Torch/Light source
6	G:	Gebo		sACRIFICE/OFFERING TO THE gODS
7	W:	Wunjo		Comfort/Joy/Glory
8	H:	Hagalaz		Hail/Missile
9	N:	Nauthiz		Need/Necessity
10	I:	Isa			ICE
11	Y:	Jera		year/harvest
12	EI:	Eithwaz		Sacred Yew tree
13	P:	Perth		Unknown
14	Z:	Algiz		Defence/Protection/Self-Preservation
15	S:	Sowilo		The Sun
16	T:	Tiwaz		The War God, TYR
17	B: 	Berkano		Birch Tree/LDUN(goddess of spring/fertility)
18	E:	Ehwaz		Horse
19	M:	Mannaz		Man/Mankind
20	L:	Laguz		Water
21	NG:	Ingwaz		the Danes (and danish hero ING)
22	D:	Dagaz		Day/Daylight
23	O:	Othila		Inheritance (of property or knowledge)
*/
/******************* Function Declarations ************************/
void drawcursor();			// draws cursor 
void inverse();				// inverse the color in the square
void drawtiles();			// draws all tiles at board x,y boxsize z (uses draw*tile functions)
void drawboard();			// kicks off drawgrid/drawtiles
void playerturn();			// takes user input to move cursor
void drawplayers();			// draw playing pieces
void flashscreen();			// flashes screen in selected color for a second or so
void canpiecemove();		// can a selected piece move? 0=no, 1=yes
void printdestinations();	// print arrows on tiles where a piece can move
void printpossiblemoves();	// Print possible moves
void printarrowsorblanks();	// PRINT ARROWS/BLANK EM OUT	
void movecursor2();			// move cursor routine
void movepiece(); 			// move a piece
char cantakepiece();		// returns 0=no, 1 yes
void takepiece();			// takes specified piece
void blinkcursor();			// blinks the cursor to attract attention
void checkend();			// check for end game conditions 
void computerturn();		// AI for computer
void pacman();				// update target positions around king (need to develop further)
void targetselect();		// choose a target square
void findpiece();
//void findpiecens();			// findpiece north-south
//void findpieceew();			// findpiece east-west
void canbetaken(); 			// can I be taken after moving here? returns value (take) 0=no 1=yes
void subarrows();			// subroutine of arrows or blanks
void subarrows2();			// subroutine of arrows or blanks (updates ENEMY with direction of enemy)
void subpacman();			// subroutine of pacman
void subpacman2();			// subroutine of pacman
//void subpacman3();			// sub of subpacman
//void subpacman4();			// sub of subpacman2
void subpacman5();
void subpacmanx();			// grand sub of pacman
//void subcanbetaken();		// sub of canbetaken
void inccantake();			// increments cantake
void incroute();			// incs route
void decroute();			// decs route
void drawtile();			// draw a tile (subroutine of drawtiles)
void drawpiece();			// draws piece
void drawarrow();			// draws "arrow"
void printmessage();		// prints message to screen
void printturnprompt();		// prints "your turn" message
void surroundcount();		// counts the number of attackers surrounding KING (or edges, or central square)
void incsurround();			// increment "surrounded" variable
void explodetile();			// explodes a piece (plays an animation)
void pause();				// wait a certain period of time (pausetime)
void tileloop();			// subdir of explodetile and drawtile
void surroundpoints();		// increment points around king depending on "surrounded" figure
void incpoints();			// increment points variable
void decpoints();			// decrement points variable
void setpoints();			// set points to default value
void zerocounter();			// set counter=0
void inccounter();			// inc counter
//void deccounter();			// decrement counter
void doublepoints();		// doubles points
//void LookBackInAnger();		// runs subcanbetaken if the piece "behind" an attacker is defender/king and prospective target adjacent to defender/king
//void subLookBackInAnger();	// runs the various "lookbackinanger" checks
void inctarget();			// inc target[xns][xew]
void subcanbetaken2(); 		// attempt to reduce memory footprint
void surroundcheck();		// inc surrounded under various conditions
void calctakeweight();		// calculate the weight of "takeweight"
void enemyzero();			// set enemy value to zero when surrounded=3 
char checkroute(); 			// sets counter to be number of pieces on a given route
void updatetarget();		// updates target array
void cantakeadjust();		// decrement cantake if taken piece is on same plane as king
void inckingattacker();		// increments count of attackers round king		
void inckingdefender();		// increments count of defenders round king
void incdefatt();			// increments count of attacker/defenders round king (calls incking...)
void cursormodezero();		// set cursor mode to 0 if 1
void cursormodevalid();		// sets modevalid to 1
void calccantake();			// can take be made (how many)
void printborder();			// print the border screen (used in titles/menus etc)
//void printtitles();			// print the border screen and titles 
void fliprune();			// flip the rune tiles in title screen
void subpacnorthsouth();		// subroutine of pacman
void subpaceastwest();			// subroutine of pacman
void checkincroute();			// check to see if OK to incroute
void incmodeone();			// increment the modeonevalid variable (from 0 to 1)
void zerofoundpiece();		// set foundpiece to 0 (PIECE NOT FOUND)
/****************** GLOBAL VARIABLES *******************************/
/* Populate array with tile types
Tile types:
0=blank
1=attacker square
2=defender square
3=king square
*/
extern const unsigned char tiles[11][11];	// tile description on board
extern unsigned char target[11][11];		// uninitialized variable (will calc on fly) - target values of square
extern const unsigned char border[6][11];	// border (of title screens/menus etc)
//extern unsigned char presents[8];	// array of runic chars that spell "presents"
//extern unsigned char hnefatafl[9]; // array of runic chars that spell "hnefatafl"
/* populate array with places of players 
Players:
0=vacant
1=attacker resident
2=defender resident
3=king resident
4=corner square	// added 21/04/2011
*/
//extern char baseplayers[11][11];			// BASEPLAYERS - the starting board positions. PLAYERS is the working COPY of BASEPLAYERS 

// ARRAY ENEMY unititialized variable (will calc on fly) - can enemy reach a square?
// values:
// +1 Can be reached from NORTH
// +5 can be reached from SOUTH
// +10 can be reached from EAST
// +20 can be reached from WEST 
extern char enemy[11][11];		// where the defenders can get to
extern char unsigned computer[11][11];	// where the attackers can get to
unsigned char players[11][11];			// to be the working copy of baseplayers
unsigned char playertype,piecetype;			// player 1=attacker, 2=defender 
unsigned char ns,ew;		// default north/south position of central square 	(0-10)
unsigned char cx,cy;			// cursor x screen position (pixels across)
unsigned char fb=1;				// foreground/background 0=background, 1=foreground, 2=opposite, 3=nothing							
unsigned char inversex;		// x position of square to be inversed (to highlight a selected piece)
unsigned char inversey;		// y position of square to be inversed (to highlight a selected piece)
char mkey;					// code of key pressed (plus loops)
unsigned char cursormode;			// cursor movement mode 0=freeform 1=restricted
unsigned char ons,oew;		// original north/south board pos
unsigned char ocx,ocy;		// original xpos of piece
unsigned char orientation;	// for arrows - 0=north, 1=south 2=east 3=west
unsigned char tiletype;				// type of tile under inspection (used in arrows)
unsigned char tpns,tpew;	// north-south board location of taken piece (also used for 3) NB:no idea 20/10/2011
unsigned char flashcolor;			// color of ink to flash in
unsigned char flashback;				// color of ink to return to
char game;					// *** MUST NOT BE UNSIGNED ***<=0 means endgame (see checkend for values), 1=GAMEON
unsigned char gamestyle;				// 0=human vs human; 1=human king vs computer; ** NO!!! 2=human vs computer king**; 3=undefined
unsigned char kingns,kingew;				// kings position North-South
unsigned char kingattacker[4];	// number of attackers in all four directions from king
unsigned char kingdefender[4];	// number of defenders in all four directsions from king
unsigned char surrounded;			// status of king "surrounded" status		//
unsigned char ctns=0;				// Computer Turn north-south board position		
unsigned char ctew=0;				// Computer Turn east-west   board position 
extern char* playertext;
extern char* message;
char foundpiece=0;	// has a piece been found (during computer move) that can move to the hightarget square? 0=no, 1=yes&ok, 9=yes!ok
//char xloop=0;				// general purpose loop variable
char xns=0;					// copy of ns (arrows or blanks, and subarrows)
char xew=0;					// copy of ew (arrows or blanks, and subarrows)
char arrow=1;				// used in arrowsorblanks(and subarrows)
unsigned char flag=0;
char cantake;				// can I take?	(for computer turn)
char route;
unsigned char row,col;			// used in tile drawing routines and array navigation ( a row in 11x11 grid)
//unsigned char col;			// used in tile drawing routines and array navigation ( a column in 11x11 grid)
unsigned char tiletodraw;	// used in tile drawing routines 0-11 (as at 18-10-2011)
int pausetime;				// amount of time to wait
unsigned char* ptr_draw;	// ptr to board starting position (e.g. 0xa002)
unsigned char* ptr_graph;	// pointer to byte values of loaded picture	
unsigned char points;		// points around king
char counter;				// general purpose counter (*** DO NOT set to UNSIGNED *** NB 24/10/2011)
char uncounter;				// *** MUST BE SIGNED *** general purpose counter (can be negative)
//unsigned char lookcol,lookrow;	// used in lookbackinanger
unsigned char origorient;			// original orientation of a piece under test (which way he is heading)
unsigned char takerow,takecol;				// can I be taken if I stop here?
unsigned char paclevel1,paclevel2;			// used in pacman/subpacmanx either ns/ew
unsigned char surns,surew;					// count of attackers surrounding king n/s used in surroundcount()
unsigned char takena,takenb,takenc,takend,takene;		// used in canbetaken routines
unsigned char ezns1,ezew1;			// used in surroundcount/enemyzero to reset enemy[][] to zero if surrounded=3
// WEIGHTS
//unsigned char enemyweight=37;		// >36. weight of "enemy could get here but piece occupied by attacker"
//char defaulttakeweight=5;	// default weight assigned to a TAKE
unsigned char takeweight;			// weight assigned to a TAKE (calculated in "calctakeweight") 
//unsigned char cbtweight=4;	// weight to be applied to escape position if can be taken
unsigned char pacpointsx,pacpointsy,pacpointsa,pacpointsb;		// used to calculate points in subpacmanx	
unsigned char pcheckns1,pcheckns2;		// used in taking pieces and checking for takes
unsigned char pcheckew1,pcheckew2;		// used in taking pieces and checking for takes			
unsigned char startrow,startcol;		// used in checkroute (returns no of pieces on a given path)
unsigned char destrow,destcol;		// used in checkroute (returns no of pieces on a given path)
unsigned char canmovecursor;	// controls wether screen cursor can be moved or not
unsigned char hightarget;	// contains highest value target
unsigned char targetns,targetew;		// used to calc takes
unsigned char x,y,z,a,b,c,d;						// general purpose variables
//char cannotbetaken,icanbetaken;			// used in canbetaken routine
/* below used for cursor move routine */
unsigned char multiple;	// concerning central square (how much to multiply the coords to SKIP the square
unsigned char xptrns;		// copy of NS
unsigned char xptrew;		// copy of EW
unsigned char skipns;		// skip to north/south
unsigned char skipew;		// skip to east/west 
unsigned char modeonevalid;	// is OK for mode 1? 0=no, 1=yes
/* above variables used in cursor move routine */
//unsigned char gamekey=89;	// controls "play again?"
unsigned char gameinput=0;	// 0=undefined 1=play against computer, 2=human vs human
//unsigned int startpos;		// USED when drawing tiles (position in tile file from which to draw)
unsigned char take;
unsigned char p1;	// piece type comparison (lower) - used for determining takes - default=attacker
unsigned char p2;	// piece type comparison (upper) - used for determining takes - default=attacker
/* playerturn variables */
unsigned char xkey;			// code of key pressed	
unsigned char canselect;	// 0=no, 1=yes (is the piece selectable?)
char cursormovetype;		// -1=no, 0=yes (n,s,e,w) 1=(north/south only), 2=(east/west only)
unsigned char turn;				// determines end of player turn 1=playerturn, 0=end of playerturn
unsigned char compass[4];	// used in cantake (if compass[NORTH]=1 then means canbetaken if i move here from NORTH
//unsigned char funca,funcb,funcc,funcd,funce,funcf;	// general purpose variables used in functions
/* end of playerturn variables */
unsigned char xplayers;
//unsigned char tileheight;	// height of tile in pixles
//unsigned char tilewidth;	// width of tile in 6 pixel chunks

/****************** MAIN PROGRAM ***********************************/
main()
{
  //gamekey=89;	// controls "play again?"
  //gameinput=0;	// 0=undefined 1=play against computer, 2=human vs human
  CopyFont();  //memcpy((unsigned char*)0xb400+32*8,Font_6x8_runic1_full,768);
  paper(0);
  ink(5);				// color of TEXT in text box at bottom
  hires();
  setflags(0);	// No keyclick, no cursor, no nothing
  printborder();
  ink(6);				// boardcolor 0=black, 1=red, 2=green, 3=yellow, 4=blue, 5=magenta, 6=cyan,7=white
  //while (gamekey==89)
  for(;;)
  {
    playertype=0;				// set to 0 as inited later
    drawboard();				// draw the board
    //printf("%c",19);			// turn off screen output (means cursor movement doesn't affect oric cursor
    while (gamestyle==3)
    {
      message="ENTER NUMBER OF HUMANS:";
      printmessage();
      gameinput=getchar();
      if ( gameinput == 49 ) gamestyle=1;	// 1=human vs computer (as DEFENDERS)
      if ( gameinput == 50 ) gamestyle=0;	// 0=human vs human
      if ( gamestyle == 3 ) ping();
    }
    while (game>0)
    {
      ns=5;						// default north/south position of central square
      ew=5;						// default east/west position of central square
      cx=ew;	// cursor x screen position
      cy=ns;	// cursor y screen position
      playertype++;				// playertype inited as 0 so ++ will make it 1 at start of game
      if ( playertype == 3 ) { playertype = 1; } // was defender, set to attacker player
      //if (( gamestyle == 0 )||((gamestyle==1)&&(playertype==2))||((gamestyle==2)&&(playertype==1)))
      if (( gamestyle == 0 )||((gamestyle==1)&&(playertype==2)))
      {
        playerturn();			// player input
      }
      else
      {
        computerturn();			// computer has a go...
      }				
      checkend();					// check for end of game conditions
    }	
    if ( game == 0 ) 
    { 
      message="KING ESCAPED! KING WINS!\nPRESS A KEY:";
      printmessage();
    }
    else 
    { 
      message="KING CAPTURED! ATTACKER WINS!\nPRESS A KEY:";
      printmessage();
    }
    getchar();
    //if (gamekey==89)	// if "Y"
    {
      //printf("%c",19);	// turn output ON
    }
  }
}

/********************* FUNCTION DEFINITIONS ************************/
void computerturn()
{
  //unsigned int xrand=srandom(deek(630));	// seed random number generator
  //if ( playertype == 1 ) { strcpy(playertext,"ATTACKER");}else{ strcpy(playertext,"KING");}
  message="ORIC IS THINKING...";
  printmessage();
  //printf("\n\n\nORIC IS THINKING..");
  // 1. initialize target, enemy and computer array to zeroes
  ClearArrays();	// clear target, enemy and computer arrays
  // 2. Loop through players array searching for enemy pieces - calculating where they can go
  //fb=5;
  //pacman1:
  for (fb=4;fb<8;fb++)
  {
    for (ctns=0;ctns<11;ctns++)
    {
      for (ctew=0;ctew<11;ctew++)
      {
        ns=ctns;ew=ctew;
        if ( fb==4 )	// fb=4 means: don't print destinations, just update ENEMY
        {	
          if (( players[ctns][ctew]==2 )||(players[ctns][ctew]==3)) // if enemy found
          {
            printdestinations();	// update enemy array of possible locations
          }
        }
        if ((fb==5)||(fb==7))			// fb=5 (+COMPUTER array):fb=7 (can I be taken) 
        {
          if ( players[ctns][ctew]==1) // if attacker found
          {
            printdestinations();		
          }
        }
        if ( fb==6)	
        {
          if ( computer[ctns][ctew] ) // if computer piece can get here update target values
          {
            updatetarget();			// update target value
          }
        }
      }
    }
  }
  // 3. Increment target positions around King (PACMAN)
  pacman();
  //if ( playertype == 1 ) {pacman();}
  // other routines to go here to update the target array
  // 4,5,6,7..N etc
  // 
  targetselect();	// Choose the highest value target 
  ns=targetns;ew=targetew;	// make computer move compatible with human move selection
  movepiece();	// make the move
}


void findpiece()
{
  if ( foundpiece == 0 )	
  {		
	if (players[a][b]==1)
	{
	  calccantake();
	  if (( cantake==0 )&&(surrounded<3)) canbetaken(); // if cannot take can I be taken?
	//if ((funcc==funcd)&&(funce!=funcd)&&(kingattacker[origorient]==1)) compass[origorient]=1;	// don't move from plane of king
	  if (compass[origorient]==0)
	   {
	   foundpiece=1;
	   if (origorient < EAST) {ons=mkey;}else{oew=mkey;}
	   }
	}
  if ((players[a][b]==2)||(players[a][b]==3)) {foundpiece=9;}
  }
}


// find piece NORTH-SOUTH
/*
void findpiecens()	
{
  if ( foundpiece == 0 )	
  {
    if (players[mkey][oew]==1)
    {
      ns=targetns;ew=targetew;orientation=origorient;calccantake();
      if (( cantake==0 )&&(surrounded<3)) canbetaken(); // if cannot take can I be taken?
      //if ((mkey==kingns)&&(targetns!=kingns)&&(kingattacker[origorient]<3)) compass[origorient]=1;	// don't move from plane of king if less than 3 attackers
      if (compass[origorient]==0)
      {
        foundpiece=1;
        ons=mkey;
      }
    }
    if ((players[mkey][oew]==2)||(players[mkey][oew]==3)) {foundpiece=9;}
  }
}
// find piece EAST-WEST
void findpieceew()	
{
  if ( foundpiece == 0 )	
  {		
    if (players[ons][mkey]==1)
    {
      ns=targetns;ew=targetew;orientation=origorient;calccantake();
      if (( cantake==0 )&&(surrounded<3)) canbetaken(); // if cannot take can I be taken?
      //if ((mkey==kingew)&&(targetew!=kingew)&&(kingattacker[origorient]<3)) compass[origorient]=1;	// don't move from plane of king if less than 3 attackers
      if (compass[origorient]==0)
      {
        foundpiece=1;
        oew=mkey;
      }
    }

    if ((players[ons][mkey]==2)||(players[ons][mkey]==3)) {foundpiece=9;}		
  }
}
*/


// TARGETSELECT - find the highest scoring TARGET
void targetselect()
{
  //unsigned char xloop;
NEWTARGET:
  hightarget=0;	// contains highest value target
  for (ctns=0;ctns<11;ctns++)	// find the highest value for target
  {
    for (ctew=0;ctew<11;ctew++)
    {
      if ( target[ctns][ctew] > hightarget )
      {
        hightarget=target[ctns][ctew];	// make hightarget the highest value
        targetns=ctns;
        targetew=ctew;		
        ons=ctns;	// target is accessible so make ons/oew the default piece position to move
        oew=ctew;	// the ACTUAL piece to move determined below (one of ons or oew will remain same)
        ns=ctns;
        ew=ctew;
      }
    }
  }
  // having found target we need to select a piece to move
  compass[NORTH]=0;compass[SOUTH]=0;compass[EAST]=0;compass[WEST]=0;	// initialize compass array
  fb=9;zerofoundpiece();		// set findpiece to ZERO "piece not found"
  origorient=NORTH;
  b=oew;
  for (mkey=ons-1; mkey>-1; mkey--){a=mkey;findpiece();}	
  if ( foundpiece != 1 ) { zerofoundpiece();target[targetns][targetew]=hightarget; }
  origorient=SOUTH;														
  for (mkey=ons+1; mkey<11; mkey++){a=mkey;findpiece();}	
  if ( foundpiece != 1 ) { zerofoundpiece();target[targetns][targetew]=hightarget; }
  origorient=EAST;
  a=ons;
  for (mkey=oew+1; mkey<11; mkey++){b=mkey;findpiece();}	
  if ( foundpiece != 1 ) { zerofoundpiece();target[targetns][targetew]=hightarget; }
  origorient=WEST;
  for (mkey=oew-1; mkey>-1; mkey--){b=mkey;findpiece();}	
  if ( foundpiece != 1 ) {target[targetns][targetew]=1;goto NEWTARGET;}	// if can still be taken select new target

  cx=oew;	// piece x screen position
  cy=ons;	// piece y screen position
  blinkcursor();			// draw cursor in foreground color at piece to move position cx,cy
  fb=0;drawcursor();		// blank cursor
  cx=targetew;	// target x screen position
  cy=targetns;	// target y screen position
  blinkcursor();			// draw cursor in foreground color at target position cx,cy
  ocx=oew;	// piece to move x screen position
  ocy=ons;	// piece to move y screen position
  //printf("%cNS=%d,EW=%d,ONS=%d,OEW=%d%c",19,ns,ew,ons,oew,19);
  //loop=getchar();
}


// subroutine of pacman
void subpacmanx()		
{
  z=kingattacker[orientation]+kingdefender[orientation];	// count of pieces on route to edge (attackers&defenders)
  a=pacpointsx+pacpointsy; // count of pieces to two corners
  b=pacpointsa+pacpointsb; // count of pieces to squares adjacent to corners
  setpoints();
  //x=paccount1*3;	// x=number of attackers * 3
  //y=x+paccount2;	// y=(number of attackers *3)+(defenders * 1)
  //if ((points-y) < 0) {points=1;}else{points-=y;}	// subtract two points for every attacker and 1 point for every defender
  if ( z==0 )				// no pieces in the direction from king
  {
    doublepoints();							// double points if blank route to edge
    if (pacpointsx==0){ doublepoints();}	// double if route to one corner
    if (pacpointsy==0){ doublepoints();}	// double if route to two corners
  }
  if ( z<2 )
  {
    if (pacpointsa==0){ doublepoints();}	// double if route to one square adjacent to corner
    if (pacpointsb==0){ doublepoints();}	// double if route to two squares adjacent to corners
  }
  if ((paclevel2<3)||(paclevel2>7)) { incpoints(); } // if close to an edge in orientation
  if ((paclevel1<2)||(paclevel2>8)) { incpoints(); } // if "left or rightside" in a "winning position"
  if ((orientation == NORTH) || (orientation == WEST))	// if north or west
  {
    uncounter=paclevel2-1;
    if ( paclevel2 < 5 ) { incpoints();} // add weight to north or west if king in north or west side of board	
  }
  else											// if south east
  { 
    uncounter=paclevel2+1;
    if ( paclevel2 > 5 ) { incpoints();} // add weight to south or east if king in south or east side of board
  }
  if ( kingattacker[orientation] == 0 ) { incpoints();}		// inc points if no attackers on path	
  surroundpoints();
  // default north/south
  x=uncounter;
  y=paclevel1;
  if ( orientation > SOUTH) // if east/west
  {
    x=paclevel1;
    y=uncounter;
  }
  flag=1;
  while (((players[x][y]==0)||(tiles[x][y]==3))&&((uncounter>-1)&&(uncounter<11)))
  {
    if (computer[x][y] )	// if accessible by attacker	
    { // only update target if cannot be taken OR king has clear route to corner
      if ((a==0)||(pacpointsx==0)||(pacpointsy==0)||(pacpointsa==0)||(pacpointsb==0))
      {
        target[x][y]+=points;
        flag=0;
      }
      else
      {
        if (target[x][y] > 1){target[x][y]=points;flag=0;}
      }
    }
    else 
    {	
      if ((flag)&&(players[x][y]==0))	// if blank)
      {
        if (orientation < EAST) { subpacman();}else{subpacman2();} // if north/south else east/west
      }
    }
    decpoints();
    //if (z){decpoints();} // only decrement points if route to edge is blocked
    if ( (orientation == NORTH) || (orientation==WEST) ) {uncounter--;}else{uncounter++;}
    if ( orientation < EAST ) {x=uncounter;}else{y=uncounter;}
  }
}


void subpacnorthsouth()
{
  startrow=a;startcol=0;destrow=a;destcol=kingew;
  pacpointsx=checkroute();
  startcol=kingew;destcol=10;
  pacpointsy=checkroute();
  startrow=d;startcol=0;destrow=d;destcol=kingew;
  pacpointsa=checkroute();
  startcol=kingew;destcol=10;
  pacpointsb=checkroute();
}


void subpaceastwest()
{
  startrow=0;startcol=b;destrow=kingns;destcol=b;
  pacpointsx=checkroute();
  startrow=kingns;destrow=10;
  pacpointsy=checkroute();
  startrow=0;startcol=c;destrow=kingns;destcol=c;
  pacpointsa=checkroute();
  startrow=kingns;destrow=10;
  pacpointsb=checkroute();
}


// PACMAN	( increment target positions around king )	
void pacman()		
{
  //int xrand=random()/1000;	// random number between 0-32
  surroundcount();		// updates "surrounded"

  // NORTH
  orientation=NORTH;
  paclevel1=kingew;
  paclevel2=kingns;
  a=0; d=1;  
  subpacnorthsouth(); // check routes to escape positions
  subpacmanx();

  //SOUTH
  orientation=SOUTH;
  a=10; d=9; 
  subpacnorthsouth();
  subpacmanx();

  // EAST
  orientation=EAST;
  paclevel1=kingns;
  paclevel2=kingew;
  b=10;c=9;
  subpaceastwest();
  subpacmanx();

  // WEST
  orientation=WEST;
  b=0;c=1;
  subpaceastwest();
  subpacmanx();

}


// increase target positions that LEAD to a king target
void subpacman()		
{
  c=x;
  flag=0;
  for (mkey=kingew-1;mkey>-1;mkey--){d=mkey;subpacman5();} // subpacman3
  flag=0;
  for (mkey=kingew+1;mkey<11;mkey++){d=mkey;subpacman5();} // subpacman3
}


void subpacman2()
{
  d=y;
  flag=0;
  for (mkey=kingns-1;mkey>-1;mkey--){c=mkey;subpacman5();} // subpacman4
  flag=0;
  for (mkey=kingns+1;mkey<11;mkey++){c=mkey;subpacman5();} // subpacman4	
}
/*****************************/
//void subpacman3()
//{
//if ( players[counter][mkey]==0 ) { flag=1;}
//if ((flag==0)&&(target[counter][mkey]>1 )) { target[counter][mkey]++;}
//}
/******************************/
//void subpacman4()
//{
//if ( players[mkey][counter]==0 ) { flag=1;}
//if ((flag==0)&&(target[mkey][counter]>1 )) { target[mkey][counter]++;}
//}
/******************************/
void subpacman5()
{
  if ( players[c][d] == 0) {flag=1;}
  if (( flag == 0)&&(target[c][d] > 1 )) { target[c][d]++;}
}


// check for endgame conditions
void checkend()	
{
  /* Victory Conditions 
  game=0 King escapes. 										// DONE
  game=-1 King Surrounded in open play or by central square 	// DONE
  game=-2 King surrounded by attackers and corner squares		// DONE
  game=-3 King surrounded by attackers and edge of board		// DONE
  game=-4 defenders cannot move (stalemate)					// TBD
  game=-5 attackers cannot move (stalemate)					// TBD
  game=-6 all attackers eliminated 							// TBD
  */
  //char kingfound=0;	// 0=king not found 1=king found 
  // ns and ew contains new board co-ords of last piece moved
  if (( players[ns][ew] == 3 ) && ( tiles[ns][ew] == 4 )) { game=0; }		// king has escaped
  // check to see if king is surrounded by attackers (first find king)
  if ( players[ns][ew] == 1 )	// if attacker was last to move
  {
    if (((ns)&&(players[ns-1][ew] == 3 ))||((ns < 10 )&&(players[ns+1][ew]==3 ))||((ew < 10 )&&(players[ns][ew+1]==3 ))||((ew)&&(players[ns][ew-1]==3 ))) 
    {
      surroundcount();
    }
    if ( surrounded == 4 ) { game=-1;}	// king is surrounded on all sides by attackers or king squares
  }
}


void cursormodezero()
{
  if ( cursormode == 0 ) { canmovecursor=1;}
}


// routine to move the cursor
void movecursor2() 
{
  /*
  cursormode = [0 or 1] 0=unrestricted (move anywhere), 1= restricted (only move to possible destinations)
  */
  multiple=1;	// concerning central square (how much to multiply the coords to SKIP the square
  xptrns=ns;		// copy of NS
  xptrew=ew;		// copy of EW
  skipns=ns;		// skip to north/south
  skipew=ew;		// skip to east/west 
  modeonevalid=0;	// is OK for mode 1? 0=no, 1=yes
  canmovecursor=0;	
  piecetype=players[ons][oew];	// determines the piece type that is currently selected (used in mode 1)
  if ((mkey == 8 )&&( ew))		// west
  {
    cursormodezero();
    xptrew--;		// decrement copyew
    skipew-=2;
    incmodeone();
    //modeonevalid=1;
  }
  if ((mkey == 9 )&&( ew < 10))		// east
  {
    cursormodezero();
    xptrew++;
    skipew+=2;
    incmodeone();
    //modeonevalid=1;
  }
  if ((mkey == 10)&&( ns < 10))		// south
  {
    cursormodezero();
    xptrns++;
    skipns+=2;
    incmodeone();
    //modeonevalid=1;
  }
  if ((mkey == 11)&&( ns ))		// north
  {
    cursormodezero();
    xptrns--;
    skipns-=2;
    incmodeone();
    //modeonevalid=1;
  }		
  if (( cursormode ) && ( modeonevalid ))	// if not at edge of board
  {
    if ( players[xptrns][xptrew] == 0 ) 					{canmovecursor=1;} // ok if square vacant
    if ( tiles[xptrns][xptrew] == 4 ) 						{canmovecursor=0;}	// !ok if corner
    if (( piecetype == 3 )&&( tiles[xptrns][xptrew] > 2 ))  {canmovecursor=1;} // ok if KING and corner/central
    if (( xptrns == ons )&&( xptrew == oew )) 		 		{canmovecursor=1;} // ok if back to self
    // need to check that for non-king pieces wether the central square is vacant and can be skipped
    if (( piecetype < 3 )&&( tiles[xptrns][xptrew] == 3)&&(players[xptrns][xptrew] == 0 ))  // tiles=3(central), tiles=4(corner)
    {	
      if ( players[skipns][skipew] ) {canmovecursor=0;}	// cannot skip if otherside occupied
      if ((( skipns == ons )&&( skipew == oew ))||(	players[skipns][skipew]==0))			// ok to skip to self
      {
        canmovecursor=1;
        multiple=2; 
      }			
    }	
  }
  if (canmovecursor)
  {
    fb=0;
    drawcursor();				// print blank cursor (effect=remove dots)
    if ( mkey == 8 ) {cx-=multiple;}	// left
    if ( mkey == 9 ) {cx+=multiple;}	// right
    if ( mkey == 10 ){cy+=multiple;}	// down
    if ( mkey == 11 ){cy-=multiple;}	// up
    fb=1;
    drawcursor();				// print dotted cursor
    if ( mkey == 8 ) {ew-=multiple;}		// left
    if ( mkey == 9 ) {ew+=multiple;}		// right
    if ( mkey == 10 ){ns+=multiple;}		// down
    if ( mkey == 11 ){ns-=multiple;}		// up
  }
  else
  {
    flashcolor=1;
    if ( cursormode == 0 ) {flashback=6;flashscreen();}	// flash red: return to cyan:6
    if ( cursormode == 1 ) {flashback=2;flashscreen();}	// flash red: return to green:2)
  }			
}


//  kicks off functions that print appropriate arrows at all possible 
// destinations and blanks them out afterwards
void printpossiblemoves()
{
  char k;	// key entered
  fb=1;
  printdestinations();	// print arrows on all destinations	
  message="* PRESS ANY KEY TO PROCEED *";
  printmessage();
  k=getchar();
  fb=0;
  printdestinations();	// blank out arrows on all destinations
}


// used in printdestinations
void printarrowsorblanks()	
{
  //char xplayers;		// player type at square under test 
  //zns=ns;		// another copy of ns (for computer turn)
  //zew=ew;		// another copy of ew (for computer turn)
  origorient=orientation; // original orientation (for computer turn)
  //char cantake=0;		// can I take?	(for computer turn)
  //unsigned char subloop=0;
  //cantake=0;
  xns=ns;	// copy of ns
  xew=ew;	// copy of ew
  arrow=1;
  //arrowsx=cx+1;
  //arrowsy=cy+1;
  // orientation 0,1,2,3 = N, S, E, W
  takerow=ns;takecol=ew; // will set below to be the opposite of the orientation
  if ( orientation == NORTH ) { xplayers=players[xns-1][xew];takerow=xns+1;} // check north
  if ( orientation == SOUTH ) { xplayers=players[xns+1][xew];takerow=xns-1;} // check south
  if ( orientation == EAST ) { xplayers=players[xns][xew+1];takecol=xew-1;} // check east
  if ( orientation == WEST ) { xplayers=players[xns][xew-1];takecol=xew+1;}  // check west
  while (( arrow == 1 )&&(fb!=7)) // keep checking until cannot move
  {
    if (( orientation == NORTH ) && ( xns ))  // check north
    {
      xns--;			// decrement provisional north-south player position
      subarrows();
    }
    if (( orientation == SOUTH ) && ( xns < 10 )) // check south
    {
      xns++;			// increment provisional north-south player position
      subarrows();
    }
    if ((orientation == EAST ) && ( xew < 10 )) // check east
    {
      xew++;			// increment provisional east-west player position
      subarrows();
    }
    if ((orientation == WEST ) && ( xew )) // check west
    {
      xew--;			// decrement provisional east-west player position
      subarrows();
    }
    tiletodraw=tiles[xns][xew];				// obtain type of tile	
    if ( arrow == 1 )						// if MODE is "draw an arrow" (aka: I can move here)
    {
      row=xns;
      col=xew;
      if (fb==1) {drawarrow();}		// draw arrow
      if (fb==4) {subarrows2();} 		// enemy can get here, update enemy array (direction specific)
      if (fb==5) {computer[xns][xew]++;} // computer can get here, increment computer array 
      if (fb==0) {drawarrow();}		// if MODE is "blank an arrow"
    }	
    // have we reached the end of the board?
    if (( orientation == NORTH ) && ( xns == 0 )) 	{ arrow=0;}	// check north
    if (( orientation == SOUTH ) && ( xns == 10 )) 	{ arrow=0;}	// check south
    if (( orientation == EAST ) && ( xew == 10 )) 	{ arrow=0;}	// check east
    if (( orientation == WEST ) && ( xew == 0 )) 	{ arrow=0;}	// check west
  }			
  if ((fb==7)&&(xplayers>1))	// check to see if an attacker can be caught if he stays where he is
  {
    if ((players[takerow][takecol]==0)&&(enemy[takerow][takecol])) 
    {
      target[takerow][takecol]+=4; // update adjacent target to provide escape route or place for someone else to occupy
      if (orientation < EAST)	// if heading north or south
      {
        if ( xew<10 ){if (target[xns][xew+1]>1){target[xns][xew+1]+=4;}}
        if ( xew  ){if (target[xns][xew-1]>1){target[xns][xew-1]+=4;}}
      }
      else					// if heading east or west
      {
        if ( xns<10 ){if (target[xns+1][xew]>1){target[xns+1][xew]+=4;}}
        if ( xns  ){if (target[xns-1][xew]>1){target[xns-1][xew]+=4;}}	
      }
    }
  }
}


// print appropriate arrows at all possible destinations (or blanks em out)
void printdestinations()
{
  
  // check north
  if ( ns ) { orientation=NORTH;printarrowsorblanks();}	// draws arrows/blanks em out (0=north)			
  // check south
  if ( ns < 10 ){ orientation=SOUTH;printarrowsorblanks();}	// draws arrows/blanks em out (1=south)
  // check east
  if ( ew < 10 ){ orientation=EAST;printarrowsorblanks();}	// draws arrows/blanks em out (2=east)
  // check west
  if ( ew ) { orientation=WEST;printarrowsorblanks();}	// draws arrows/blanks em out (3=west)	
}


// CAN A SELECTED PIECE MOVE?
void canpiecemove() 
{
  // returns 0 or 1 depending on wether a piece can move or not
  // int route=0;				// number of possible routes
  route=0;
  piecetype=players[ns][ew];	// determine TYPE of selected piece (1=attacker, 2=defendr, 3=king)
  /*  for all piece types determine if adjacent square in any direction is blank or not
  it won't bother checking a particular direction if piece is at edge of board.
  */
  if ( ns )		// check north
  {
    a=ns-1;b=ew;checkincroute();
    //if ( players[ns-1][ew] == 0 ) incroute();
    //if (( piecetype == 3 )&&(players[ns-1][ew] == 4 )) incroute(); // KING: corner square OK 
  }
  if ( ns < 10 )		// check south
  {
    a=ns+1;b=ew;checkincroute();
    //if ( players[ns+1][ew] == 0 ) incroute(); 
    //if (( piecetype == 3 )&&(players[ns+1][ew] == 4 )) incroute(); // KING: corner square OK 
  }
  if ( ew < 10 )		// check east
  {
    a=ns;b=ew+1;checkincroute();
    //if ( players[ns][ew+1] == 0 ) incroute(); 
    //if (( piecetype == 3 )&&(players[ns][ew+1] == 4 )) incroute(); // KING: corner square OK 
  }
  if ( ew )		// check west
  {
    a=ns;b=ew-1;checkincroute();
    //if ( players[ns][ew-1] == 0 ) incroute(); 
    //if (( piecetype == 3 )&&(players[ns][ew-1] == 4 )) incroute(); // KING: corner square OK 
  }
  /* In the case that the central square is unnocupied and a piece is adjacent to that square then - for
  non-KING Pieces only - we need to check to see if the opposite square is occupied or not. 
  ROUTE will be decremented if that piece is occupied (as no piece can occupy the central square except for
  the King but all pieces can traverse it */
  if (( piecetype < 3 ) && ( players[5][5] == 0 ))	// if not a king and central sqr unoccupied
  {
    if ( ns == 5 ) 				
    {
      if ( ew == 4 ) {if ( players[5][6] ) decroute();}	// check east +2	// east occupied, dec route
      if ( ew == 6 ) {if ( players[5][4] ) decroute();}	// check west +2	// west occupied, dec route
    }
    if ( ew == 5 )
    {
      if ( ns == 4 ) { if ( players[6][5] ) decroute();}	// check south +2	// south occupied, dec route
      if ( ns == 6 ) { if ( players[4][5] ) decroute();}	// check north +2	// north occupied, dec route
    }
  }
  if ( route > 0 ) route=1;
  //return route;
}


void checkincroute()
{
  if ( players[a][b] == 0 ) incroute();
  if (( piecetype == 3 )&&(players[a][b] == 4 )) incroute(); // KING: corner square OK 
}


// DRAW ALL THE PIECES ON THE BOARD
void drawplayers() 
{
  for (row=0;row<11;row++)
  {
    for (col=0;col<11;col++)
    {
      if (( players[row][col] )&&(players[row][col] < 4)){drawpiece();}			
    }
  }
}


// DRAW THE BOARD
void drawboard()	
{
  //tileheight=18;tilewidth=3;
  game=1;				// game=1 means PLAY GAME
  gamestyle=3;		// 0=play against human, 1=play as DEFENDERS, 2=play as ATTACKERS, 3=nobody  
  kingns=5;kingew=5;	// DEFAULT kings board position
  /*
  for (counter=0;counter<4;counter++)	// this routine uses up more memory (100bytes extra)
  {
  kingattacker[counter]=2;
  kingdefender[counter]=2;
  }
  */
  kingattacker[NORTH]=2;		// count of attackers NORTH of king
  kingattacker[SOUTH]=2;		// count of attackers SOUTH of king
  kingattacker[EAST]=2;			// count of attackers EAST of king
  kingattacker[WEST]=2;			// count of attackers WEST of king
  kingdefender[NORTH]=2;			// count of defenders NORTH of king
  kingdefender[SOUTH]=2;			// count of defenders SOUTH of king
  kingdefender[EAST]=2;			// count of defenders EAST of king
  kingdefender[WEST]=2;			// count of defenders WEST of king
  surrounded=0;		// reset surrounded back to zero
  drawtiles();	// draw the background tiles
  curset(12,198,1);
  draw(198,0,1);
  draw(0,-198,1);
  drawplayers(); 	// draw the players
  //printf("%c",19);// turn output to screen off
}


// blinks the cursor a number of times to attract attention
void blinkcursor() 
{
  //char curloop;
  //unsigned int subloop;
  for (counter=0;counter<5;inccounter())	// flash the cursor to draw attention to it
  {
    fb=0; drawcursor();					// draw cursor in background color at cx,cy
    pausetime=250;pause();
    fb=1; drawcursor();					// draw cursor in foreground color at cx,cy
    pausetime=2000;pause();
  }
}


// flashes the screen in the selected ink color
void flashscreen() 
{
  /* Colors are as follows:
  0=black, 1=red, 2=green, 3=yellow, 4=blue, 5=magenta, 6=cyan,7=white
  */
  ink(flashcolor);	// flash in color
  pausetime=1500;pause();
  ink(flashback);	// back to original
}


// The human players turn : filter keyboard input
void playerturn()	
{	
  /*
  unsigned char key;			// code of key pressed	
  unsigned char canselect;		// 0=no, 1=yes (is the piece selectable?)
  char cursormovetype=-1;			// -1=no, 0=yes (n,s,e,w) 1=(north/south only), 2=(east/west only)
  char turn=1;					// determines end of player turn 1=playerturn, 0=end of playerturn
  */
  cursormovetype=-1;	// -1=no, 0=yes (n,s,e,w) 1=(north/south only), 2=(east/west only)
  turn=1;					// determines end of player turn 1=playerturn, 0=end of playerturn
  ons=ns;			// original ns board position
  oew=ew;			// original ew board position
  ocx=cx;			// original x screen position
  ocy=cy;			// original y screen position
  flashback=6;
  if ( playertype == 2 )
  { 
    playertext="KING'S";
  }
  else
  {
    playertext="ATTACKER";
  }
  blinkcursor();
  printturnprompt();			// display instructions
  while (turn)				// repeat until move is made
  {
    xkey=getchar();		// get code of pressed key
    mkey=xkey;
    if (( xkey > 7 ) && ( xkey < 12 ))  // 8-11 = cursor keys 
    {
      cursormode=0;  // freeform
      movecursor2();  
    }		
    /*******************************************************/
    /* determine if X or P is selected (to select a piece) */
    /*******************************************************/
    if (( xkey == 88) || ( xkey == 80))	// if 'X' or 'P' is selected (88=X, 80=P)
    {
      canselect=0;		// set piece to NOT SELECTABLE
      if (( playertype == 1 )&&(players[ns][ew] == 1 )) { canselect=1;} // piece is selectable
      if (( playertype == 2 )&&((players[ns][ew] == 2 )||(players[ns][ew] == 3 ))) { canselect=1;} // piece is selectable
      if ( canselect )
      {
        canpiecemove();
        if (route) 
        { 
          //piecetype=players[ns][ew];
          flashcolor=2;flashscreen();	// flash green
          if ( xkey == 80 )		// if P is pressed
          { 
            printpossiblemoves();	// Print possible moves
            printturnprompt();
            //strcpy(message,playertext);
            //strcat(message,turntext);
            //printmessage();
            //printf ("\n\n\n* %s Turn:Use cursor keys.\nX:Select P:Possible",playertext);
          }
        }
        else 
        { 
          flashcolor=1;flashscreen();	// flash red
          canselect=0;		// unselectable, cannot move
        }				
      }
      else { flashcolor=1;flashscreen();}	// flash red			
      if (( mkey == 88 )&&( canselect ))	// if piece is SELECTED and CAN move
      {
        ink(2); 				// green to indicate piece is selected
        flashback=2;
        //printmessage();
        //strcpy(message,playertext);
        message="PLACE CURSOR ON DESTINATION\nX=SELECT\nR=RESET";
        printmessage();
        //printf("\n\n\n%s Turn X=Select R=Reset",playertext);
        inversex=cx;
        inversey=cy;
        inverse();				// highlight selected square (inverse color)
        mkey=0;					// ensure mkey at known value
        // set Original cursor and board position of selected square
        ocx=cx; ocy=cy; ons=ns; oew=ew;
        while (( mkey != 88 ) && ( mkey != 82)) // move cursor until X or R selected
        {
          if (( ons == ns )&&( cursormovetype<0)) { cursormovetype=1; }// cursor allowed north-south
          if (( oew == ew )&&( cursormovetype<0)) { cursormovetype=2; }// cursor allowed east-west
          if (( ons == ns )&&	(oew == ew )) { cursormovetype=0;} 	 	 // cursor can move 	
          if (( cursormovetype == 2) && (( mkey == 8)	||(mkey == 9)))	{cursormovetype=-1;}//!move 
          if (( cursormovetype == 1) && (( mkey == 10)||(mkey == 11))){cursormovetype=-1;}//!move
          if (( cursormovetype == 0) && (( mkey == 8)	||(mkey == 9)))	{cursormovetype=1;}	//move
          if (( cursormovetype == 0) && (( mkey == 10)||(mkey == 11))){cursormovetype=2;}	//move
          if ( cursormovetype > 0 ) 
          {
            cursormode=1;	// restricted
            movecursor2();
          }
          if ( cursormovetype < 0) { flashcolor=1;flashscreen();}	// flashscreen red
          mkey=getchar();
        }
        if ( mkey == 82 ) // R has been selected, Reset cursor to original positions
        {
          fb=0;
          drawcursor();		// blank out cursor at current position
          cx=ocx;						// reset coords and board values to original positions
          cy=ocy;
          ns=ons;
          ew=oew;
          inversex=cx;
          inversey=cy;
          inverse();		// inverse square
          fb=1;
          drawcursor();		// draw cursor at original selected position
        }
        if ( mkey == 88 )				// if X selected
        {
          inversex=ocx;
          inversey=ocy;
          inverse();			// inverse original position
          if (( ons == ns )&&( oew == ew))// X is in original position so return to cursor movement 
          {
            mkey=0;		// piece de-selected
          } 
          else{ 
            movepiece();	// move selected piece				
            turn=0;		// player has ended turn
          }
        }
      }
      ink(6);	// back to cyan	
      flashback=6;
      printturnprompt();		
    }		// key = X or P
  }	// While player turn		
}


// Moves selected piece to new location - updating board arrays and re-drawing tiles where necessary
void movepiece()
{ 
  p1=1;	// piece type comparison (lower) - used for determining takes - default=attacker
  p2=1;	// piece type comparison (upper) - used for determining takes - default=attacker
  piecetype=players[ons][oew];	// obtain type of piece
  // move piece
  fb=0;
  drawcursor();				// blank out cursor at new selected position
  row=ons;
  col=oew;
  tiletodraw=tiles[row][col];
  ptr_graph=PictureTiles;drawtile();					// draw tile at original location (blank out square)
  players[ons][oew]=0;		// set original location to zero (unnocupied)
  players[ns][ew]=piecetype;	// update square with player info
  row=ns;
  col=ew;
  //printf("%cENEMY[%d][%d]=%d%c\n",19,ons,oew,enemy[ons][oew],19);getchar();
  drawpiece();				// draw piece at new location - 18-10-2011
  if (piecetype==3)	{ kingns=ns;kingew=ew;}	// update king position (used by AI)
  // having moved piece we now need to check for, and implement any TAKES
  if (piecetype > 1 )	// if defender
  {
    p1=2;
    p2=3;
  }
  tpew=ew;
  if ( ns > 1 ) // check north
  {
    orientation=NORTH;
    if ( cantakepiece() ) { tpns=ns-1; takepiece(); }
  }
  if ( ns < 9 ) // check south
  {
    orientation=SOUTH;
    if ( cantakepiece() ) { tpns=ns+1; takepiece(); }
  }
  tpns=ns;
  if ( ew < 9 ) // check east
  {
    orientation=EAST;
    if ( cantakepiece() ) { tpew=ew+1; takepiece(); }
  }
  if ( ew > 1 ) // check west
  {
    orientation=WEST;
    if ( cantakepiece() ) { tpew=ew-1; takepiece(); }
  }
  // update count of attackers around king
  /*
  for (counter=0;counter<4;counter++)	// this routine uses 100 extra bytes than assigning manually
  {
  kingattacker[counter]=0;
  kingdefender[counter]=0;
  }
  */
  kingattacker[NORTH]=0;		// count of attackers NORTH of king
  kingattacker[SOUTH]=0;		// count of attackers SOUTH of king
  kingattacker[EAST]=0;			// count of attackers EAST of king
  kingattacker[WEST]=0;			// count of attackers WEST of king
  kingdefender[NORTH]=0;			// count of defenders NORTH of king
  kingdefender[SOUTH]=0;			// count of defenders SOUTH of king
  kingdefender[EAST]=0;			// count of defenders EAST of king
  kingdefender[WEST]=0;			// count of defenders WEST of king
  orientation=NORTH;
  cy=kingew;
  for (counter=0;counter<kingns;inccounter()) 	
  { 
    cx=counter;incdefatt();
  }
  orientation=SOUTH;
  for (counter=kingns+1;counter<11;inccounter()) 
  { 
    cx=counter; incdefatt();
  }
  orientation=EAST;
  cx=kingns;
  for (counter=kingew+1;counter<11;inccounter())	
  { 
    cy=counter; incdefatt();
  }
  orientation=WEST;
  for (counter=0;counter<kingew;inccounter()) 	
  { 
    cy=counter; incdefatt();
  }
}


void incdefatt()
{
  if (players[cx][cy]==1) {inckingattacker();}
  if (players[cx][cy]==2) {inckingdefender();}
}


void inckingdefender()
{
  kingdefender[orientation]++;
}


void inckingattacker()
{
  kingattacker[orientation]++;
}

/*void subcanbetaken()
{
target[targetns][targetew]=1;
//if ((ns==kingns)||(ew==kingew)) { target[ns][ew]=3;}  // means acceptable risk
}
*/
// can I be taken after moving here? 
void canbetaken() 
{
  if ((targetns>0)&&(targetns<10))
  {
    takena=targetns-1;takenb=targetew;takenc=targetns+1;takend=targetew;takene=1;
    subcanbetaken2();
    takena=targetns+1;takenb=targetew;takenc=targetns-1;takend=targetew;takene=5;
    subcanbetaken2();
  }

  if ((targetew>0)&&(targetew<10))
  {
    takena=targetns;takenb=targetew+1;takenc=targetns;takend=targetew-1;takene=10;
    subcanbetaken2();
    takena=targetns;takenb=targetew-1;takenc=targetns;takend=targetew+1;takene=20;
    subcanbetaken2();	
  }
}


// Will return a value (take) who's values will be: 0= no, 1=yes
char cantakepiece()
{
  take=0;
  p1=1;			// piece type comparison (lower) - used for determining takes - default=attacker
  p2=4;			// piece type comparison (upper) - used for determining takes - default=attacker
  pcheckns1=ns-1;	// defaults to north
  pcheckns2=ns-2;
  pcheckew1=ew;
  pcheckew2=ew;
  piecetype=players[ns][ew];	// obtain type of piece
  //if ( fb==3) { piecetype=players[ctns][ctew];} // if computer turn set piecetype to piece being checked
  if ((fb==3)||(fb==9)) { piecetype=1;}	// default = ATTACKER
  if (piecetype > 1 )	// if defender
  {
    p1=2;
    p2=3;
  }
  if ( orientation == SOUTH)	// if south
  {
    pcheckns1=ns+1;
    pcheckns2=ns+2;
  }
  if ( orientation > SOUTH)	// if east or west
  {
    pcheckns1=ns;
    pcheckns2=ns;
    pcheckew1=ew+1;
    pcheckew2=ew+2;
    if ( orientation == WEST) // if west
    {
      pcheckew1=ew-1;
      pcheckew2=ew-2;
    }
  }
  // if a take is possible increment the take counter - if values fall within bounds...
  if ((pcheckns2>-1)&&(pcheckns2<11)&&(pcheckew2>-1)&&(pcheckew2<11))
  {
    if (( players[pcheckns1][pcheckew1] )&&(players[pcheckns1][pcheckew1] != p1)&&(players[pcheckns1][pcheckew1] != p2 )&&(players[pcheckns1][pcheckew1] != 3))
    {	
      if ((( players[pcheckns2][pcheckew2] == p1 )||(players[pcheckns2][pcheckew2] == p2 )||(players[pcheckns2][pcheckew2] == 4)&&(pcheckns2!=5)&&(pcheckew2!=5))) // the 5 is to EXCLUDE central square
      {
        take++;
      } 
      if ( computer[pcheckns2][pcheckew2] ) {inctarget();} // 31-10-2011 - can possibly take on next turn
    }
  }
  if ( piecetype == 3 ) // if king and next to attacker and opposite square is a king square
  {
    if ((players[pcheckns1][pcheckew1] == 1 )&&(tiles[pcheckns2][pcheckew2] > 2)) { take++;}
  }
  return take;
}


// performs taking/removing a piece
void takepiece() 
{
  players[tpns][tpew]=0;			// zero players
  row=tpns;
  col=tpew;
  ink(6);
  explodetile();					// plays animation to "kill" a tile
  tiletodraw=tiles[row][col];		// decide tile to draw
  ptr_graph=PictureTiles;drawtile();						// draw tile at location
}


void subarrows()
{
  if (players[xns][xew]) 
  { 
    arrow = 0;	// !ok if piece occupied or corner square
    if ((fb==4)&&(players[xns][xew]==1)) {enemy[xns][xew]+=ENEMYWEIGHT;}	// means enemy could get here if attacker moved elsewhere
  }
  if (( players[ns][ew] == 3)&&(tiles[xns][xew] == 4)) { arrow = 1; } // corner ok if king	
}


void subarrows2()
{
  if ( orientation==NORTH ) { enemy[xns][xew]+=5; }	// means enemy can get here from SOUTH
  if ( orientation==SOUTH ) { enemy[xns][xew]+=1; }	// means enemy can get here from NORTH
  if ( orientation==EAST ) { enemy[xns][xew]+=20; }	// means enemy can get here from WEST
  if ( orientation==WEST ) { enemy[xns][xew]+=10; }	// means enemy can get here from EAST
}


void inccantake()
{
  z=cantakepiece();
  if (z)
  {
    cantake+=z;
    cantakeadjust();	// decrement take count if taken piece on same plane as king and taker isn't	
  }
}

// Explodes a tile
void explodetile()	
{
  //unsigned char b;
  ptr_graph=ExplodeTiles;					// pointer to byte values of loaded picture	
  for (b=0;b<8;b++)
  {
    tileloop();
    pausetime=900;
    if (b==5) {pausetime=3000;} // pause longer on skull&crossbones
    pause();	// add a pause
  }	
}


void drawpiece()
{
  tiletodraw=players[row][col];
  if ( tiletodraw>0) { tiletodraw+=3;}
  if ( tiles[row][col]>0 ) { tiletodraw+=3; }
  ptr_graph=PictureTiles;drawtile();
}


void drawarrow()
{
  if ( fb==1 )
  {
    tiletodraw=10;
    if ( tiles[row][col] ) tiletodraw++;      // add another 1 for arrow with background
  }
  else
  {
    tiletodraw=tiles[row][col];			  // draw original tile (includes blank)
  }
  ptr_graph=PictureTiles;drawtile();
}


void surroundcount()
{
  zerocounter();
  setpoints();
  surrounded=0;
  if (( kingns==0)||(kingns==10)||(kingew==0)||(kingew==10))	{incsurround();} // added 18/10/2011
  surew=kingew;
  if ( kingns )			{ surns=kingns-1;surroundcheck(); }
  if ( kingns < 10 )	{ surns=kingns+1;surroundcheck(); }
  surns=kingns;
  if ( kingew )	{ surew=kingew-1;surroundcheck(); }
  if ( kingew < 10 )	{ surew=kingew+1;surroundcheck(); }
  if (surrounded==3)	// unset any "enemy and target values" 
  {
    ezew1=kingew;
    if ( kingns )
    {
      ezns1=kingns-1;
      enemyzero();
    }
    if ( kingns < 10 )
    {
      ezns1=kingns+1;
      enemyzero();
    }
    ezns1=kingns;
    if ( kingew )
    {
      ezew1=kingew-1;
      enemyzero();
    }
    if ( kingew < 10 )
    {
      ezew1=kingew+1;
      enemyzero();
    }
  }
}

void pause()
{
  int p;
  for (p=0; p<pausetime;p++){};
}


/******************************/
/****************************/
/*
void LookBackInAnger()		// returns the value of the piece "behind" an attacker
{
flag=0;			// status of foundpiece 0=no, 1=yes
if ( origorient == 0 ) 
{
for ( lookrow=mkey-1;lookrow>-1;lookrow--)
{
subLookBackInAnger();
}
}
if ( origorient == 1 ) 
{
for ( lookrow=mkey+1;lookrow<11;lookrow++)
{
subLookBackInAnger();
}
}
if ( origorient == 2 ) 
{
for ( lookcol=mkey+1;lookcol<11;lookcol++)
{
subLookBackInAnger();
}
}
if ( origorient == 3 ) 
{
for ( lookcol=mkey-1;lookcol>-1;lookcol--)
{
subLookBackInAnger();
}
}
}
*/


/*
void subLookBackInAnger()	// subroutine of LookBackInAnger
{
if (players[lookrow][lookcol]==1) { flag=1;}
if ( (flag==0)&&((players[lookrow][lookcol]==2)||(players[lookrow][lookcol]==3))) { target[ons][oew]=1;}
}
*/
void subcanbetaken2()	// DO NOT MESS with this (NBARNES 10-01-2012)
{
  if (players[takena][takenb]>1)
  {
    if ((players[takenc][takend]==0)||(enemy[takenc][takend]>ENEMYWEIGHT))
    {
      if ((enemy[takenc][takend]-takene)&&((enemy[takenc][takend]<ENEMYWEIGHT)||(enemy[takenc][takend]-ENEMYWEIGHT))) // 23-12-2011 
      {
        compass[origorient]=1;	// e.g. compass[NORTH]=1 means canbetaken here if moving from NORTH
        if (enemy[takenc][takend]>ENEMYWEIGHT) // THIS is the business!!!
        {
          if ((origorient<EAST)&&(mkey!=takenc)&&(oew!=takend)) {compass[origorient]=0;}
          if ((origorient>SOUTH)&&(ons!=takenc)&&(mkey!=takend)) {compass[origorient]=0;}
        }
      }
    }
  }
}


void inctarget()
{
  target[targetns][targetew]+=2;
}


void surroundcheck()
{
  if (players[surns][surew]==1)		{incsurround();} 	// is attacker n,s,e,w
  if (tiles[surns][surew]>2)			{incsurround();}	// is king square n,s,e,w
}


// calculate the weight that should be applied to TAKES
void calctakeweight()			
{
  takeweight=7;		// default
  // don't worry about TAKES if the king has unbroken line of sight to edge of board
  for (x=0;x<4;x++)
  {
    if ((kingattacker[x]==0)&&(kingdefender[x]==0)){takeweight=0;}
  }
  //if (((kingnorth==0)&&(defnorth==0))||((kingsouth==0)&&(defsouth==0))||((kingeast==0)&&(defeast==0))||((kingwest==0)  && (defwest==0))) {takeweight=0;}
}


// called from "surroundcount()"
void enemyzero()    
{
  if (( players[ezns1][ezew1] == 0 )&&(target[ezns1][ezew1]))	// if adjacent square n/s/e/w is blank and accessible
  {
    ClearArrays();				// set all arrays to zero (target, enemy, computer)
    target[ezns1][ezew1]=100;	// set big target value to final space by king
  }
}


// returns number of pieces on a given route
char checkroute()	
{
  z=0;
  if (orientation<EAST) 			// if checking ROWS (crossing the T) (used for NORTH SOUTH checks)
  {
    for (x=startcol;x<=destcol;x++)	// check row
    {
      if ((players[startrow][x])&&(players[startrow][x]<3)) {z++;}
    }
  }
  else						// EAST WEST checks (crossing the T)
  {
    for (x=startrow;x<=destrow;x++) // check accross
    {
      if ((players[x][startcol])&&(players[x][startcol]<3)) {z++;}
    }
  }
  return z;
}


// decrements cantake if taken piece is on same plane as king 
// and attacking piece isn't AND only one defender on plane
void cantakeadjust()		
{							
  flag=0;
  if ((playertype==1)&&(gamestyle==1))	// if computer playing as attacker and his turn
  {
    if (pcheckns1==kingns)
    {
      flag=1;
      if (ctew<kingew){orientation=WEST;}else{orientation=EAST;}
      //if ((kingattacker[orientation]+kingdefender[orientation])<4){cantake--;}
    }
    if (pcheckew1==kingew)
    {
      flag=1;
      if (ctns<kingns){orientation=NORTH;}else{orientation=SOUTH;}
      //if ((kingattacker[orientation]+kingdefender[orientation])<4){cantake--;}
    }
    if (flag)		
    {
      if ((kingattacker[orientation]+kingdefender[orientation])<4){cantake--;}
    }

  }
}


void updatetarget()
{
  targetns=ctns;targetew=ctew;
  target[targetns][targetew]=2;	// set target to 2
  target[5][5]=0;		// set "illegal" squares to zero
  target[0][10]=0;
  target[0][0]=0;
  target[10][0]=0;
  target[10][10]=0;
  if (target[targetns][targetew])	// only if target is valid (i.e. not a king square)
  {
    if (enemy[targetns][targetew]){inctarget();}	// increase target if blocking an enemy	
    if ((enemy[targetns][targetew]==6)||(enemy[targetns][targetew]==11)||(enemy[targetns][targetew]==21)||(enemy[targetns][targetew]==15)||(enemy[targetns][targetew]==25)||(enemy[targetns][targetew]==30)){inctarget();}
    if ((enemy[targetns][targetew]==35)||(enemy[targetns][targetew]==16)||(enemy[targetns][targetew]==26)){target[targetns][targetew]+=2;}
    calccantake();			// calculates how many takes can be made in this position (cantake)
    calctakeweight();		// calculate weight that should be applied to takes	
    y=cantake*takeweight;	// value to be added to target			
    target[targetns][targetew]+=y; // add cantake (will be zero if cannot take)

    //if (cantake==0)	{canbetaken();}		// sets target to 1 if cannot take but can be taken
  }
}


// calculate how many takes can be made
void calccantake()			
{
  //unsigned char x;
  cantake=0;	
  inccantake();	// inc cantake if can take in direction of travel
  for (x=0;x<4;x++)
  {
    if ( x<2 ) // heading north/south
    {
      orientation=EAST; inccantake();
      orientation=WEST; inccantake();	
    }
    if ( x>1 ) // heading east/west
    {
      orientation=NORTH; inccantake();
      orientation=SOUTH; inccantake();
    }
  }
}


// print the border around title screen/menus etc
void printborder()		
{
  unsigned char f=0;
  ink(3);	// yellow, erm...gold
  row=0;c=6;d=11;col=0;
  for (mkey=0;mkey<5;mkey++)
  {	
    for (a=row;a<c;a++)
    {
      col=0;
      if (mkey) {fliprune();col=1;}   // flip the row		
      for(b=col;b<d;b++)
      {
        tiletodraw=border[a][b];      // get runic chars
        if (f==1) {tiletodraw++;}     // get western chars on 2nd pass
        if ( tiletodraw < 99)
        {
          ptr_graph=RunicTiles;	      // pointer to Border Tiles graphics
          drawtile();		      // draw tile
        }
        col++;
      }
      row++;
    }
    row=1;col=1;c=5;d=10;pausetime=26000;pause();
    f++;if (f==2){f=0;}
  }
}


// performs the rune flipping sequence in title screen
void fliprune()		
{
  for (tiletodraw=30;tiletodraw<35;tiletodraw++)
  {
    for (col=1;col<10;col++)
    {
      if (border[row][col] < 99)
      {
        ptr_graph=RunicTiles;		// pointer to Border Tiles graphics
        drawtile();pausetime=50;pause(); 
      }
    }
  }
}
