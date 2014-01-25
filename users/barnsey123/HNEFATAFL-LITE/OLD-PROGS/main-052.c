// HNEFATAFL by Neil Barnes (a.k.a. Barnsey123)
// 24-08-2012 NB: Tided up source (removed "bracket hell")
// 27-08-2012 NB: v0.012 Minor changes to save memory
// 27-08-2012 NB: v0.013 Created Priority array and routine to populate it
// 28-08-2012 NB: v0.014 Add hightarget to pacman checkroute (when route to corners are empty)
// 30-08-2012 NB: V0.015 updated pacman routines - added brokenarrow
// 01-09-2012 NB: V0.016 Fixed brokenarrow
// 02-09-2012 NB: v0.017 Compressed - and fixed - checkroute()
// 03-09-2012 NB: v0.018 Rejigged pacman (do a while...to edge)
// 05-09-2012 NB: v0.019 pacman2
// 21-10-2012 NB: v0.020 Fixed bug in gspot
// 22-10-2012 NB: v0.021 Fixed bugs in following:
//						 pacman2 [not calculating hightarget in right place, not doing brokenarrow properly)
//						 sub [not calcing points properly]
// 23-10-2012 NB: v0.022 Removed some redundant code (enemytargetupdate)
// 24-04-2013 NB: v0.023 starting to add DEADPILE
// 25-04-2013 NB: v0.024 Font Changes for deadpile, endgame detection improvements, some memory reduction
// 27-04-2013 NB: v0.025 Some changes to make code clearer
// 29-04-2013 NB v0.026 some more cleary uppy stuff . fixed bug in endgame detection.broken arrow not working.
// 29-04-2013 NB v0.027 adding kingtracker (all the spaces where the king can get to
// 01-05-2013 NB v0.028 Brokenarrow fixed
// 01-05-2013 NB v0.029 Potential Broken Arrow Situation
// 02-05-2013 NB v0.030 Fixed central square "backbone" issue
// 02-05-2013 NB v0.031 Added TRIGGER weighting and changes to brokenarrow
// 04-05-2013 NB v0.032 Replecaed g variable in gspot with kingtoedge array
// 04-05-2013 NB v0.033 Introduced pacman3 and some changes to subpacmanx
// 07-05-2013 NB v0.040 Skip 03x coz of differnt versions floating about 
// 07-05-2013 NB v0.041 Fixed a few bugs, reduced footprint
// 08-05-2013 NB v0.042 resolving the vinegar strokes (trying)
// 08-05-2013 NB v0.043 SHAZAM! One major bug resolved (broken arrow issue)
// 09-05-2013 NB v0.044 Exploiting tzonemode
// 13-05-2013 NB v0.045 Introduction of RED FLAG (vinegar strokes issue 1 resolved) PROBLEM with illegal moves
// 13-05-2013 NB v0.046 released not tested
// 14-05-2013 NB v0.047 bugfix in enemy[][] array testing. Minor font change. Redflag disables full brokenarrow
// 15-05-2013 NB v0.048 Fixed illegal moves.
// 21-05-2013 NB v0.049 improving AI (RingOfSteel), added color to deadpile 
// 03-06-2013 NB v0.050 Addec color cursor (removed dotted type as got messy)
// 03-06-2013 NB v0.051 replace some draw and curset commands
// 04-06-2013 NB v0.052 minor change to brokenarrow
#include <lib.h>
#define NORTH 0
#define SOUTH 1
#define EAST 2
#define WEST 3
#define ENEMYWEIGHT 37
#define DEADPILEA 222
#define DEADPILED 234
#define SIDESTEP 3
#define ATTACKER 1
#define DEFENDER 2
#define KING 3
#define CASTLE 4
#define ENEMYBLOCK 3
#define TAKEWEIGHT 5
#define TRIGGERHIGH 3
#define TRIGGERLOW 7
#define PARTIAL1 0
#define PARTIAL2 1
#define FULL 2
#define NO 0
#define YES 1
//#define VINEGAR 3
extern unsigned char ExplodeTiles[];	// extra graphics to "explode" a piece (animation)
extern unsigned char PictureTiles[];	// standard graphics for pieces and backgrounds
extern unsigned char RunicTiles[];		// Runic alphabet
extern unsigned char TimerTiles[];		// display timer in central square when computer's turn
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
11	Y/J:	Jera		year/harvest
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
//void brokenarrow();				
//void deccounter();			// decrement counter	
//void LookBackInAnger();		// runs subcanbetaken if the piece "behind" an attacker is defender/king and prospective target adjacent to defender/king		
//void subLookBackInAnger();	// runs the various "lookbackinanger" checks			
//void zoneupdate();		// Increment target positions on unnocupied rows/columns (especially the "zone")		
unsigned char cantakepiece();		// returns 0=no, 1 yes		
unsigned char checkroute(); // sets counter to be number of pieces on a given route				
void blinkcursor();			// blinks the cursor to attract attention	
void calccantake();			// can take be made (how many)	
void calchightarget();		// updates value of hightarget (the highest target so far)		
//void calctakeweight();		// calculate the weight of "takeweight"		
void canbetaken(); 			// can I be taken after moving here? returns value (take) 0=no 1=yes	
void canpiecemove();		// can a selected piece move? 0=no, 1=yes		
void cantakeadjust();		// decrement cantake if taken piece is on same plane as king	
void checkbrokenarrow();	// check to see if brokenarrow can be incremented	
void checkend();			// check for end game conditions 	
void checkincroute();		// check to see if OK to incroute		
void computerturn();		// AI for computer		
void cursormodevalid();		// sets modevalid to 1		
void cursormodezero();		// set cursor mode to 0 if 1		
void decpoints();			// decrement points variable	
void decroute();			// decs route	
void pointsplusten();		// ADDS 10 TO POINTS		
void drawarrow();			// draws "arrow"	
void drawboard();			// kicks off drawgrid/drawtiles	
void drawcursor();			// draws cursor 	
void drawpiece();			// draws piece	
void drawplayers();			// draw playing pieces	
void drawtile();			// draw a tile (subroutine of drawtiles)	
void drawtiles();			// draws all tiles at board x,y boxsize z (uses draw*tile functions)	
void enemyzero();			// set enemy value to zero when surrounded=3 	
void explodetile();			// explodes a piece (plays an animation)	
void findpiece();				
void flashscreen();			// flashes screen in selected color for a second or so	
void fliprune();			// flip the rune tiles in title screen	
void gspot();				// count no of targets  from king to edge
//void incbrokenarrow();		// increments the value of brokenarrow
void inccantake();			// increments cantake	
void inccounter();			// inc counter	
void incdefatt();			// increments count of attacker/defenders round king (calls incking...)	
void inckingattacker();		// increments count of attackers round king		
void inckingdefender();		// increments count of defenders round king		
void incmodeone();			// increment the modeonevalid variable (from 0 to 1)	
void incpoints();			// increment points variable	
void incroute();			// incs route	
void incsurround();			// increment "surrounded" variable	
void inctarget();			// inc target[xns][xew]	
void inverse();				// inverse the color in the square
void movecursor2();			// move cursor routine	
void movepiece(); 			// move a piece					
void pacman2();				// update target positions around king (need to develop further)
void pacman3();
void pacman4();
void pacman5();
//void pacman6();				// "vinegar strokes"
void pause();				// wait a certain period of time (pausetime)
void playerturn();			// takes user input to move cursor	
void backbone();			// renamed from "printarrowsorblanks"			
void printdestinations();	// print arrows on tiles where a piece can move			
void printmessage();		// prints message to screen		
void printpossiblemoves();	// Print possible moves			
void printtitles();			// print the title screen (used in titles/menus etc)	
void printturnprompt();		// prints "your turn" message		
void prioritycalc();		// updates priority array		
void setpoints();			// set points to default value	
void subarrows();			// subroutine of arrows or blanks	
void subarrows2();			// subroutine of arrows or blanks (updates ENEMY with direction of enemy)	
void subcanbetaken2(); 		// attempt to reduce memory footprint		
//void subpaceastwest();		// subroutine of pacman	
//unsigned char subpaccrosst();		// sub of pacman2
void subpacmanx();			// grand sub of pacman2	
void subpacmany();			// apply points from the pacman routines
//void subpacnorthsouth();	// subroutine of pacman	
//void subzoneupdate();		// subroutine of pacman				
void surroundcheck();		// inc surrounded under various conditions		
void surroundcount();		// counts the number of attackers surrounding KING (or edges, or central square)		
void surroundpoints();		// increment points around king depending on "surrounded" figure		
void takepiece();			// takes specified piece	
void sidestep();			// add SIDESTEP to target (used in escape routine)		
void targetselect();		// choose a target square		
void tileloop();			// subfunction of explodetile and drawtile	
void timertile();			// print timer	
//void updateroutehightarget();// adds hightarget to targets on route				
void updateroutetarget();	// increment targets on a given route			
void updatetarget();		// updates target array		
void zerocounter();			// set counter=0	
//void zerofoundpiece();	// set foundpiece to 0 (PIECE NOT FOUND)		
void deadpile();			// draw deadpile
void flashred();			// flash screen in red
//void gethightarget();		// without upsetting any other variables
void calccantake2();			// alternative calcantake
/****************** GLOBAL VARIABLES *******************************/
/* Populate array with tile types
Tile types:
0=blank
1=attacker square
2=defender square
3=king square
*/
extern unsigned char tiles[11][11];			// tile description on board
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
extern unsigned char enemy[11][11];		// where the defenders can get to
extern unsigned char computer[11][11];	// where the attackers can get to
//extern unsigned char priority[11][11];	// holds the priority of a piece to move
extern unsigned char kingtracker[11][11]; // where the king can get to
unsigned char players[11][11];			// to be the working copy of baseplayers
unsigned char playertype,piecetype;		// player 1=attacker, 2=defender 
unsigned char ns,ew;		// default north/south position of central square 	(0-10)
unsigned char cx,cy;		// cursor x screen position (pixels across)
unsigned char fb=1;			// foreground/background 0=background, 1=foreground, 2=opposite, 3=nothing							
//unsigned char inversex;		// x position of square to be inversed (to highlight a selected piece)
//unsigned char inversey;		// y position of square to be inversed (to highlight a selected piece)
char mkey;					// code of key pressed (plus loops)
unsigned char cursormode;	// cursor movement mode 0=freeform 1=restricted
unsigned char ons,oew;		// original north/south board pos
unsigned char ocx,ocy;		// original xpos of piece
unsigned char orientation;	// 0=north, 1=south 2=east 3=west
unsigned char tiletype;		// type of tile under inspection (used in arrows)
unsigned char tpns,tpew;	// north-south board location of taken piece (also used for 3) NB:no idea 20/10/2011
unsigned char flashcolor;	// color of ink to flash in
unsigned char flashback;	// color of ink to return to
char game;					// *** MUST NOT BE UNSIGNED ***<=0 means endgame (see checkend for values), 1=GAMEON
unsigned char gamestyle;	// 0=human vs human; 1=human king vs computer; ** NO!!! 2=human vs computer king**; 3=undefined
unsigned char kingns,kingew;// kings position North-South
unsigned char kingattacker[4];	// number of attackers in all four directions from king
unsigned char kingdefender[4];	// number of defenders in all four directions from king
unsigned char kingpieces[4];	// number of pieces in all four directions around king (saves calculating it all the time)
unsigned char surrounded;		// status of king "surrounded" status		//
unsigned char ctns=0;			// Computer Turn north-south board position		
unsigned char ctew=0;			// Computer Turn east-west   board position 
extern char* playertext;
extern char* message;
unsigned char foundpiece;	// has a piece been found (during computer move) that can move to the hightarget square? 0=no, 1=yes&ok, 9=yes!ok
//char xloop=0;				// general purpose loop variable
unsigned char xns=0;		// copy of ns (arrows or blanks, and subarrows)
unsigned char xew=0;		// copy of ew (arrows or blanks, and subarrows)
unsigned char arrow=1;				// used in arrowsorblanks(and subarrows)
unsigned char flag=0;
unsigned char cantake;		// can I take?	(for computer turn)
unsigned char route;
unsigned char row,col;		// used in tile drawing routines and array navigation ( a row in 11x11 grid)
//unsigned char col;		// used in tile drawing routines and array navigation ( a column in 11x11 grid)
unsigned char tiletodraw;	// used in tile drawing routines 0-11 (as at 18-10-2011)
int pausetime;				// amount of time to wait
unsigned char* ptr_draw;	// ptr to board starting position (e.g. 0xa002)
unsigned char* ptr_graph;	// pointer to byte values of loaded picture	
unsigned char points;		// points around king
char counter;				// general purpose counter (*** DO NOT set to UNSIGNED *** NB 24/10/2011)
char uncounter;				// *** MUST BE SIGNED *** general purpose counter (can be negative)
//unsigned char lookcol,lookrow;	// used in lookbackinanger
unsigned char origorient;			// original orientation of a piece under test (which way he is heading)
unsigned char takerow,takecol;		// can I be taken if I stop here?
unsigned char paclevel1,paclevel2;	// used in pacman/subpacmanx either ns/ew
unsigned char surns,surew;			// count of attackers surrounding king n/s used in surroundcount()
unsigned char takena,takenb,takenc,takend,takene;		// used in canbetaken routines
unsigned char ezns1,ezew1;			// used in surroundcount/enemyzero to reset enemy[][] to zero if surrounded=3
// WEIGHTS
//unsigned char enemyweight=37;	// >36. weight of "enemy could get here but piece occupied by attacker"
//char defaulttakeweight=5;		// default weight assigned to a TAKE
//unsigned char takeweight;		// weight assigned to a TAKE (calculated in "calctakeweight") 
//unsigned char cbtweight=4;	// weight to be applied to escape position if can be taken
// End of Weights
//unsigned char pacpointsx,pacpointsy,pacpointsa,pacpointsb; // used to calculate points in subpacmanx	
unsigned char pcheckns1,pcheckns2;	// used in taking pieces and checking for takes
unsigned char pcheckew1,pcheckew2;	// used in taking pieces and checking for takes			
unsigned char startrow,startcol;	// used in checkroute (returns no of pieces on a given path)
unsigned char destrow,destcol;		// used in checkroute (returns no of pieces on a given path)
unsigned char canmovecursor;		// controls wether screen cursor can be moved or not
unsigned char hightarget;			// contains highest value target
unsigned char targetns,targetew;	// used to calc takes
unsigned char x,y,z,a,b,c,d,e,f;	// general purpose variables
/* below used for cursor move routine */
unsigned char multiple;		// concerning central square (how much to multiply the coords to SKIP the square
unsigned char xptrns;		// copy of NS
unsigned char xptrew;		// copy of EW
unsigned char skipns;		// skip to north/south
unsigned char skipew;		// skip to east/west 
unsigned char modeonevalid;	// is OK for mode 1? 0=no, 1=yes
/* above variables used in cursor move routine */
unsigned char gameinput=0;	// 0=undefined 1=play against computer, 2=human vs human
unsigned char take;
unsigned char p1;	// piece type comparison (lower) - used for determining takes - default=attacker
unsigned char p2;	// piece type comparison (upper) - used for determining takes - default=attacker
/* playerturn variables */
unsigned char xkey;			// code of key pressed	
unsigned char canselect;	// 0=no, 1=yes (is the piece selectable?)
char cursormovetype;		// -1=no, 0=yes (n,s,e,w) 1=(north/south only), 2=(east/west only)
unsigned char turn;			// determines end of player turn 1=playerturn, 0=end of playerturn
unsigned char compass[4];	// used in cantake (if compass[NORTH]=1 then means canbetaken if i move here from NORTH
/* end of playerturn variables */
unsigned char xplayers;
unsigned char inkcolor;	// screen color 
unsigned char checkroutemode;	// mode used for checkroute function 
								// 1=count number of pieces on route
								// 2=increment target values on route (if no pieces on route)
								// 3=amount of targets on route
								// 4=Number of "enemy" targets on route (where enemies CAN go)
								// 5= Emergency! Make target=255
unsigned char checkrouterow, checkroutecol, checkroutestart, checkroutedest; // used in checkroute routine
unsigned char subpacc,subpacd;	// used in subpacman5 
unsigned char turncount=0;			// used to count the number of turns
//unsigned char enemytargetcount;	// count of enemy targets on a route
unsigned char brokenarrow[4];	// NORTH/SOUTH/EAST/WEST: 0=OK, 1=BROKENARROW, 2=POTENTIAL BROKEN ARROW in that direction
unsigned char deadattackers, deaddefenders, deadplayers, deadtoggle; deadchar; deadcurset; // count of dead attackers or defenders
unsigned char kingtoedge[4];	// number of TARGETS from king to edge of board
unsigned char tzonemode;		// 0=PARTIAL1, 1=PARTIAL2, 2=FULL
//unsigned char onlycheck;		// restrict check to one route in certain situations
unsigned char redflag;			// raise the red flag to IGNORE "can I be taken"
//unsigned char deadcolor;		// color of deadpiece
//unsigned int deadspace;		// start of deadcolumn
/****************** MAIN PROGRAM ***********************************/
main(){
  //gameinput=0;	// 0=undefined 1=play against computer, 2=human vs human
  CopyFont();  //memcpy((unsigned char*)0xb400+32*8,Font_6x8_runic1_full,768);
  hires();
  //hiresasm();
<<<<<<< .mine
  message="V0.051.IN MEMORY OF:\nJONATHAN 'TWILIGHTE' BRISTOW\nORIC LEGEND: 1968-2013";
=======
  message="V0.052.IN MEMORY OF:\nJONATHAN 'TWILIGHTE' BRISTOW\nORIC LEGEND [1968-2013]";
>>>>>>> .r936
  printmessage();
  setflags(0);	// No keyclick, no cursor, no nothing
  printtitles();
  inkcolor=6;inkasm();
  for(;;){	// endless loop
    //playertype=0;				// 1=attacker, 2=defender (set at zero as incremented within loop)
    drawboard();				// draw the board
    while (gamestyle==3){
      message="PLAYERS:1-2";	// number of players
      printmessage();
      gameinput=getchar();
      if ( gameinput == 49 ) gamestyle=1;	// 1=human vs computer (as DEFENDERS)
      if ( gameinput == 50 ) gamestyle=0;	// 0=human vs human
      if ( gamestyle == 3 ) {flashback=6;flashred();}
    }
    while (game > 0){
      ns=5;			// default north/south position of central square
      ew=5;			// default east/west position of central square
      cx=ew;		// cursor x screen position
      cy=ns;		// cursor y screen position
      playertype++;	// playertype inited as 0 so ++ will make it 1 at start of game
      if ( playertype == 3 ) { playertype = 1; turncount++; } // was defender, set to attacker player, inc turncount
      //if (( gamestyle == 0 )||((gamestyle==1)&&(playertype==2))||((gamestyle==2)&&(playertype==1)))
      if (( gamestyle == 0 )||((gamestyle==1)&&(playertype==2))){
        playerturn();			// player input
      }else{
        computerturn();			// computer has a go...
      }				
      checkend();				// check for end of game conditions
    }
/*
    game=0  King Wins.
    game=-1 Stalemate.
    game=-2 Attacker wins. 																
*/
    message="ATTACKER WINS!"; // default (game=-2)
    // king escapes or all attackers killed
    if ( game == 0 ) message="KING WINS!"; 
    // computer can't move
    if ( game == -1 ) message="STALEMATE"; 
    printmessage();
    message="\nPRESS A KEY:";
    printline();
    getchar();
  }
}

/********************* FUNCTION DEFINITIONS ************************/
void computerturn(){
  //if ( playertype == 1 ) { strcpy(playertext,"ATTACKER");}else{ strcpy(playertext,"KING");}
  message="THINKING...";
  printmessage();
  // 1. initialize target, enemy and computer array to zeroes
  ClearArrays();	// clear target, enemy, priority and computer arrays
  //prioritycalc();	// calculates the priorities of pieces to move
  // 2. Loop through players array searching for pieces - calculating where they can go
  for (fb=4;fb<9;fb++){
	  timertile();
      for (ctns=0;ctns<11;ctns++){
        for (ctew=0;ctew<11;ctew++){
          ns=ctns;ew=ctew;
          // fb=4 means: don't print destinations, just update ENEMY	
          if (( fb == 4 )&&(( players[ctns][ctew] == DEFENDER  )||(players[ctns][ctew] == KING))) printdestinations();	
          // fb=5 (+COMPUTER array):fb=7 (can I be taken) 
	      if (((fb == 5)||(fb == 7))&&( players[ctns][ctew] == ATTACKER))  printdestinations();
	      // fb=6 if computer piece can get here update target values 		
	      if (( fb == 6)&&( computer[ctns][ctew] )) updatetarget();
	      // fb=8 update kingtracker
	      if (( fb == 8)&&( players[ctns][ctew] == KING )) printdestinations();
	    }
    }
  }
  // 3. Increment target positions around King (PACMAN)
  pacman2();
  calchightarget();
  if (hightarget == 0) {
	  game=-1;	// signify END of game: computer cannot move: stalemate 
	  return;
  }
  
  if (redflag == NO ) pacman4(); 	// check for full broken arrow
  //pacman6();	// "vinegar strokes"
  // draw central square (overwriting timer)
  tiletodraw=9;	// KING ON A TILE
  if (players[5][5] != KING) tiletodraw=3; // CASTLE TILE
  row=5;col=5; ptr_graph=PictureTiles;drawtile(); 
  //if ( playertype == 1 ) {pacman();}
  // other routines to go here to update the target array
  // 4,5,6,7..N etc
  // 
  targetselect();			// Choose the highest value target and piece to move to it 
  ns=targetns;ew=targetew;	// make computer move compatible with human move selection
  movepiece();				// make the move
}


void findpiece(){	// find a piece capable of moving to selected target
  if ( foundpiece == 0 ){		
	if (players[a][b] == ATTACKER){  // a=row, b=column (ns,ew = target location)
		//foundpiece=1;
		calccantake2();
		//cantake=0;
		//calccantake();
		//if (( origorient == NORTH ) && ( ns > 1 )) {calccantake();}
		//if (( origorient == SOUTH ) && ( ns < 9 )) {calccantake();}
		//if (( origorient == EAST  ) && ( ew < 9 )) {calccantake();}
		//if (( origorient == WEST  ) && ( ew > 1 )) {calccantake();}
		if (( cantake == 0 )&&( surrounded < 3)) canbetaken(); // if cannot take can I be taken?
		if (compass[origorient] == 0)	foundpiece=1;
		// check NORTH and SOUTH
		if ((foundpiece == 1)&&(redflag == NO)){ // can't be taken so we've found a candidate	
	  		if (a != targetns) {// target is not on same row as candidate
				if ((targetns == kingns)&&((a < 2)||(a > 8))){
					startrow=a;destrow=a;startcol=0;destcol=10;
					//see if by moving a piece we leave the way open for the king to escape
					setcheckmode1();	// set checkroutemode=1 (checkroute will return count of pieces on row or column)
					checkroute(); // returns z
					if (z == 1) setfoundpiece10(); // don't move piece (do NOT leave the "zone" unpopulated)			
				}
				if (a == kingns){ // if candidate is on same row as king (don't move away if only one piece E/W)
					if ((b > kingew)&&(kingpieces[EAST]==1)) setfoundpiece10();
					if ((b < kingew)&&(kingpieces[WEST]==1)) setfoundpiece10();
				}
			}
		}	
		// CHECK EAST AND WEST
		if ((foundpiece == 1)&&(redflag == NO)){ // can't be taken so we've found a candidate
			if ( b != targetew){// target is not on same column as candidate
				if ((targetew == kingew)&&((b < 2)||(b > 8))){
					startrow=0;destrow=10;startcol=b;destcol=b;
					checkroute(); // returns z
					if (z == 1) setfoundpiece10(); // don't move piece (do NOT leave the "zone" unpopulated)			
				}
				if (b == kingew){ // if candidate is on same col as king (don't move away if only one piece N/S)
					if ((a < kingns)&&(kingpieces[NORTH]==1)) setfoundpiece10();
					if ((a > kingns)&&(kingpieces[SOUTH]==1)) setfoundpiece10();
				}
			}
		}
		if (foundpiece == 1){
			if (origorient < EAST){
				ons = a;
			}else{
				oew = b;
			}
		}	
	}
  	if ((players[a][b] == DEFENDER)||(players[a][b] == KING)) foundpiece=9;
  	//if ((players[a][b] == CASTLE)&&(a!=5)) foundpiece=9;
  }
}
/*
CalcHighTarget used to be part of targetselect (and is still called from it) but 
it is also now used in PACMAN so that the kings escape route can always be blocked 
by adding the highest score (so far) onto the necessary targets...
It alters the values of ctns,ctew,targetns,targetew,ons,oew,ns,ew and of course,
hightarget
*/
void calchightarget(){
  hightarget=0;	// highest value target
  for (ctns=0;ctns<11;ctns++){	// find the highest value for target
    for (ctew=0;ctew<11;ctew++){
      if ( target[ctns][ctew] > hightarget ){
        hightarget=target[ctns][ctew];	// make hightarget the highest value
        targetns=ctns;
        targetew=ctew;		
        ons=ctns;		// target is accessible so make ons/oew the default piece position to move
        oew=ctew;		// the ACTUAL piece to move determined below (one of ons or oew will remain same)
        ns=ctns;
        ew=ctew;
      }
    }
  }
}
/*
void gethightarget(){ // without upsetting anything else
	hightarget=0;
	for (ctns=0;ctns<11;ctns++){	// find the highest value for target
    	for (ctew=0;ctew<11;ctew++){
      		if ( target[ctns][ctew] > hightarget ){
	      		hightarget=target[ctns][ctew];	// make hightarget the highest value
      		}
  		}
	}
}
*/
/*
void cleartarget(){ // nukes target array
	for (ctns=0;ctns<11;ctns++){	
    	for (ctew=0;ctew<11;ctew++){
	      	if (target[ctns][ctew]) target[ctns][ctew]=1;	
  		}
	}
}
*/
// TARGETSELECT - find the highest scoring TARGET
void targetselect(){
NEWTARGET:
  calchightarget();
  // having found target we need to select a piece to move
  compass[NORTH]=0;compass[SOUTH]=0;compass[EAST]=0;compass[WEST]=0;	// initialize compass array
  fb=9;
  // NORTH + SOUTH
  b=oew;
  // NORTH
  zerofoundpiece();		// set foundpiece to ZERO "piece not found"
  origorient=NORTH;
  for (mkey=ons-1; mkey>-1; mkey--){a=mkey;findpiece();}
  // SOUTH
  if ( foundpiece != 1 ){ 
	zerofoundpiece();
  	origorient=SOUTH;	
  	for (mkey=ons+1; mkey<11; mkey++)	{a=mkey;findpiece();}
  }	
  // EAST + WEST	
  
  // EAST
  if ( foundpiece != 1 ){
	a=ons;  
	zerofoundpiece();
  	origorient=EAST;
  	for (mkey=oew+1; mkey<11; mkey++)	{b=mkey;findpiece();}
  }	
  // WEST
  if ( foundpiece != 1 ) { 
	zerofoundpiece();
	origorient=WEST;
  	for (mkey=oew-1; mkey>-1; mkey--)	{b=mkey;findpiece();}	
  }
  if ( foundpiece != 1 ) {target[targetns][targetew]=1;goto NEWTARGET;}	// if can still be taken select new target
  //if ( target[targetns][targetew]==2) {zoneupdate(); goto NEWTARGET;} // if nothing useful found update the zone
  cx=oew;				// piece x screen position
  cy=ons;				// piece y screen position
  blinkcursor();		// draw cursor in foreground color at piece to move position cx,cy
  fb=0;
  //drawcursor();	// blank cursor
  cx=targetew;			// target x screen position
  cy=targetns;			// target y screen position
  blinkcursor();		// draw cursor in foreground color at target position cx,cy
  ocx=oew;				// piece to move x screen position
  ocy=ons;				// piece to move y screen position
}
// subroutine of pacman
void subpacmanx(){
  setpoints();		// Set points to 10
  surroundpoints(); // add 10 * surrounded 
  /*
  if (kingpieces[orientation] == 0){
	incpoints();
  	if ((orientation<EAST)&&((kingew<2)||(kingew>8))) pointsplusten();
  	if ((orientation>SOUTH)&&((kingns<2)||(kingns>8))) pointsplusten();
  }
  */
  // TRIGGERHIGH/TRIGGERLOW = Weight to be added depending on kings closeness to border
  /*
  if (( orientation == NORTH )&&(kingns <= TRIGGERLOW)) pointsplusten();
  if (( orientation == SOUTH )&&(kingns >= TRIGGERHIGH)) pointsplusten();
  if (( orientation == EAST ) &&(kingew >= TRIGGERHIGH)) pointsplusten();
  if (( orientation == WEST ) &&(kingew <= TRIGGERLOW)) pointsplusten();
  */
  points+=brokenarrow[orientation]*10;
  //message="NOT SET";
 
  if (( kingpieces[orientation] == 0 )&&(kingtoedge[orientation])){
	  //calchightarget();
	  if ((orientation < EAST)&&((kingew<2)||(kingew>8))) {
		  redflag=YES;	// raise a red flag
		  points=200;
	  }
	  if ((orientation > SOUTH)&&((kingns<2)||(kingns>8))) {
		  redflag=YES;	// raise a red flag
		  points=200;
	  }	  
  }

  subpacmany(); // apply the points
}
void subpacmany(){	// apply the points generated in pacman2-6
// SET UNCOUNTER
  pacman5();				// ensure correct paclevels are set
  uncounter=paclevel2+1;	// if south or east 
  if ((orientation == NORTH ) || ( orientation == WEST)){	
  	uncounter=paclevel2-1;
  }	
  // SET X & Y
  x=paclevel1;  // if EAST or WEST
  y=uncounter;								
  if ( orientation < EAST ){ // IF NORTH OR SOUTH
	  x=uncounter;
  	  y=paclevel1;								
  }
  
  while (((players[x][y] == 0)||(tiles[x][y] == CASTLE)) && ((uncounter > -1)&&(uncounter < 11))){
    if ( target[x][y] ){	// if accessible by attacker	
    	if (( target[x][y] > 1 )||(redflag)){	
	    	//printmessage();getchar();
	      	target[x][y]+=points; 
      	}else{
	      	target[x][y]=points; // can be caught if i go here
	      	if (redflag) target[x][y]-=50;	// take another 50 points if redflag=yes
      	}
    	decpoints();
    }
    //if (z){decpoints();} // only decrement points if route to edge is blocked
    if ( (orientation == NORTH) || (orientation == WEST) ) {uncounter--;}else{uncounter++;}
    if ( orientation < EAST ) {x=uncounter;}else{y=uncounter;}
  }
  /*
  if (tzonemode==VINEGAR){
	  message="VINEGAR STROKES COMPLETE";
	  printmessage();
  }*/
}
void checkbrokenarrow(){
	// f= value of player piece at edge of board (if any)
	// kingtoedge[orientation]= count of targets from king to edge
	// kingpieces[]= count of pieces from king in a given orientation
	unsigned char test=0;
	//unsigned char testreturn=0;
	setcheckmode1(); c=checkroute(); // how many pieces on the route?
	checkroutemode=6; d=checkroute();// can king get to a T-row 0-1
	if (( c == 0 ) && ( d )) {
		f=players[a][b];		// check for piece at edge of board
		if (f == CASTLE) f=0;	// check for corner square
	  	if (( target[a][b] )&&(tzonemode==FULL)) kingtoedge[orientation]--; // decrement kingtoedge(so maybe kingtoedge=zero) - to trigger brokenarrow
		//if (( kingpieces[orientation] == 1) && (f) && (f != ATTACKER)) test=1;
		if (( kingpieces[orientation] == 1) && (f)) test=1;
		if ((kingpieces[orientation] == 0 )||( test )){
			if ( kingtoedge[orientation] == 0){	// no targets on route
				//brokenarrow[orientation]=5;
				message="BROKEN ARROW UPDATE";
				printline();
				message="\nPRESS A KEY";
				printline();
				getchar();
				checkroutemode=5;checkroute();
			}else{
				brokenarrow[orientation]++; // POTENTIAL BROKEN ARROW
				if (tzonemode){				// if tzonemode > PARTIAL1
					brokenarrow[orientation]+=2;  // will be at LEAST 3 if PARTIAL2
				}
				// if we have two PARTIAL1s (possible escape) then brokenarrow will be 2 so need to elevate
				if (brokenarrow[orientation] == 2) brokenarrow[orientation]=4; // 4 beats one PARTIAL2
			}
		}
	}
}

/*
// check the T zone (for broken arrow purposes)
unsigned char subpaccrosst(){
	if ( orientation == NORTH ){
		a=0;b=kingew;startrow=1;destrow=1;startcol=0;destcol=10;
	}
	if ( orientation == SOUTH ){
		a=10;b=kingew;startrow=9;destrow=9;startcol=0;destcol=10;
	}
	if ( orientation == EAST ){
		a=kingns;b=10;startrow=0;destrow=10;startcol=9;destcol=9;
	}
	if ( orientation == WEST ){
		a=kingns;b=0;startrow=0;destrow=10;startcol=1;destcol=1;
	}
return checkroute();
}
*/
void gspot(){
	setcheckmode3();	// count number of targets on route from king to edge
	// NORTH
	startrow=0;destrow=kingns;startcol=kingew;destcol=kingew;	
	kingtoedge[NORTH]=checkroute();  // count of targets from king to edge
	// SOUTH
	startrow=kingns;destrow=10;
	kingtoedge[SOUTH]=checkroute();  // count of targets from king to edge
	// EAST
	destrow=kingns;destcol=10;
	kingtoedge[EAST]=checkroute();
	// WEST
	startcol=0;destcol=kingew;
	kingtoedge[WEST]=checkroute();
}
/*
void gspot(){
	// default=NORTH
	if (( orientation == NORTH )&&(kingns > 1)) {
		startrow=0;destrow=kingns;startcol=kingew;destcol=kingew;
	}
	if (( orientation == SOUTH )&&(kingns < 9)){
		startrow=kingns;destrow=10;startcol=kingew;destcol=kingew;
	}
	if ((orientation == EAST )&&(kingew < 9)){
		startrow=kingns;destrow=kingns;startcol=kingew;destcol=10;
	}
	if ((orientation == WEST) && (kingew > 1)){
		startrow=kingns;destrow=kingns;startcol=0;destcol=kingew;
	}
	setcheckmode3(); g=checkroute();  // count of targets from king to edge
}
*/
/*
void checkbrokenarrowhead(){
	// NORTH
	orientation=NORTH; brokenarrow[orientation]=0;
	a=0;b=kingew;startrow=0;destrow=0;startcol=0;destcol=kingew;
	checkbrokenarrow(); // PARTIAL LEVEL 1 "LEFT"
	startcol=kingew;destcol=10; 
	checkbrokenarrow(); // PARTIAL LEVEL 1 "RIGHT"
	// SOUTH	
	orientation=SOUTH; brokenarrow[orientation]=0;
	a=10;startrow=10;destrow=10;startcol=0;destcol=kingew;
	checkbrokenarrow(); // PARTIAL LEVEL 1 "LEFT"
	startcol=kingew;destcol=10;
	checkbrokenarrow(); // PARTIAL LEVEL 1 "RIGHT"
	// EAST
	orientation=EAST; brokenarrow[orientation]=0;
	a=kingns;b=10;startrow=0; destrow=kingns;startcol=10;
	checkbrokenarrow(); // PARTIAL LEVEL 1 "LEFT"
	startrow=kingns;destrow=10;
	checkbrokenarrow(); // PARTIAL LEVEL 1 "RIGHT"
	// WEST
	orientation=WEST; brokenarrow[orientation]=0;
	b=0; startrow=0;destrow=kingns;startcol=0; destcol=0;
	checkbrokenarrow(); // PARTIAL LEVEL 1 "LEFT"
	startrow=kingns;destrow=10;
	checkbrokenarrow();	// PARTIAL LEVEL 1 "RIGHT"
}*/

void pacman2(){
// improved version of pacman
	redflag=NO;		// at this point no red flag to be waived
	timertile();
	//calchightarget();	// calc highest target so far
	//if (hightarget == 0) return;	// cannot move...
	gspot(); // sets kingtoedge[orientation]=count of targets from king to edge (no of pieces is found in kingpieces[])
	//checkbrokenarrowhead();
	surroundcount();  // set surrounded value (used in subpacmanx - only have to calc once though)	
	for (orientation = 0; orientation < 4; orientation++){
		brokenarrow[orientation]=0;
		tzonemode=PARTIAL1;
		// count of pieces across the "T"
		// PARTIAL LEVEL 1 "LEFT"
		//points=50;	// for level 1
		a=0;b=kingew;startrow=0;destrow=0;startcol=0;destcol=kingew; // NORTH
		if ( orientation ){
			a=10;b=kingew;startrow=10;destrow=10;startcol=0;destcol=kingew; // SOUTH
			if ( orientation == EAST ){
				a=kingns;b=10;startrow=0; destrow=kingns;startcol=10;destcol=10;
			}
			if ( orientation == WEST ){
				a=kingns;b=0; startrow=0; destrow=kingns;startcol=0; destcol=0;
			}
		}
		pacman3();
		// PARTIAL LEVEL 1 "RIGHT"
		if (startrow == destrow){
			startcol=kingew;destcol=10;
		}else{
			startrow=kingns;destrow=10;
		}
		pacman3();	
		// LEVEL 2
		// PARTIAL LEVEL 2 "LEFT"
		// a + b already set in PARTIAL LEVEL 1 
		tzonemode=PARTIAL2;
		startrow=1;destrow=1;startcol=0;destcol=kingew; // NORTH
		if ( orientation ){
			startrow=9;destrow=9;startcol=0;destcol=kingew; // SOUTH
			if ( orientation == EAST ){
				startrow=0; destrow=kingns;startcol=9;destcol=9;
			}
			if ( orientation == WEST ){
				startrow=0; destrow=kingns;startcol=1; destcol=1;
			}
		}
		//points = 100;
		pacman3();
	  	// PARTIAL LEVEL 2 "RIGHT"
	  	if (startrow == destrow){
			startcol=kingew;destcol=10;
	  	}else{
			startrow=kingns;destrow=10;
	  	}
	  	pacman3();	
		subpacmanx(); // add points to target in all directions from king 	
	}
}
void pacman3(){
	//unsigned char test=0;
	unsigned char lower=0;		// row/column lower bound
	unsigned char upper=10;		// row/column upper bound
	pacman5();					// ensure correct paclevels are set
	if (tzonemode){	// if PARTIAL2 or FULL
		lower=1;
		upper=9;
	}
	if ((( orientation == NORTH )||( orientation == WEST ))&&(paclevel2 > lower)) checkbrokenarrow();
	if ((( orientation == SOUTH )||( orientation == EAST ))&&(paclevel2 < upper)) checkbrokenarrow();
	//if ((paclevel1 > 0 )&&(paclevel1 < 10)) test++;
	//if ( test==2 ) checkbrokenarrow(); 
}
void pacman4(){
	// Cross the "T", see if a FULL broken arrow condition could exist (LEVEL 2)
	// FULL LEVEL 2
	tzonemode=FULL;
	points=hightarget+1;
	orientation = NORTH;
	//pacman5();	// NORTH+SOUTH
	a=0;b=kingew;startrow=1;destrow=1;startcol=0;destcol=10;
	pacman3();
	orientation = SOUTH; // SOUTH
	a=10;b=kingew;startrow=9;destrow=9;startcol=0;destcol=10;
	pacman3();
	orientation = EAST; // EAST
	//pacman5();
	a=kingns;b=10;startrow=0;destrow=10;startcol=9;destcol=9;
	pacman3();
	orientation = WEST; // WEST
	a=kingns;b=0;startrow=0;destrow=10;startcol=1;destcol=1;
	pacman3();
}
void pacman5(){
	if (orientation < EAST){	// NORTH AND SOUTH (for pacman3) 
	  	paclevel1=kingew;
  		paclevel2=kingns;
	}else{					// EAST AND WEST
  		paclevel1=kingns;
  		paclevel2=kingew;	
	}
}

// check for endgame conditions
void checkend()	{
/* END OF GAME CONDITIONS
  game=0  King Wins.
  game=-1 Stalemate.
  game=-2 Attacker wins. 																
*/
  // ns and ew contains new board co-ords of last piece moved
  if ((( players[ns][ew] == 3 ) && ( tiles[ns][ew] == 4 ))||( deadattackers > 23)) game=0; // king has escaped
  // check to see if king is surrounded by attackers (first find king)
  if ( players[ns][ew] == 1 ){	// if attacker was last to move
    if ((ns )&&(players[ns-1][ew] == 3 )) 	surroundcount();
    if ((ns < 10 )&&(players[ns+1][ew] == 3 )) 	surroundcount();
	if ((ew < 10 )&&(players[ns][ew+1] == 3 )) 	surroundcount();
	if ((ew )&&(players[ns][ew-1] == 3 )) 		surroundcount(); 
    if ( surrounded == 4 )  game=-2;	// king is surrounded on all sides by attackers or king squares
  }
}

void cursormodezero() {
  if ( cursormode == 0 ) canmovecursor=1;
}


// routine to move the cursor
void movecursor2() {
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
  if ((mkey == 8 )&&( ew )){		// west
    cursormodezero();
    xptrew--;		// decrement copyew
    skipew-=2;
    incmodeone();
  }
  if ((mkey == 9 )&&( ew < 10))	{	// east
    cursormodezero();
    xptrew++;
    skipew+=2;
    incmodeone();
  }
  if ((mkey == 10)&&( ns < 10)){	// south
    cursormodezero();
    xptrns++;
    skipns+=2;
    incmodeone();
  }
  if ((mkey == 11)&&( ns  )){		// north
    cursormodezero();
    xptrns--;
    skipns-=2;
    incmodeone();
  }		
  if (( cursormode ) && ( modeonevalid  )){	// if not at edge of board
    if ( players[xptrns][xptrew] == 0 ) 					canmovecursor=1; // ok if square vacant
    if ( tiles[xptrns][xptrew] == 4 ) 						canmovecursor=0; // !ok if corner
    if (( piecetype == 3 )&&( tiles[xptrns][xptrew] > 2 ))  canmovecursor=1; // ok if KING and corner/central
    if (( xptrns == ons )&&( xptrew == oew )) 		 		canmovecursor=1; // ok if back to self
    // need to check that for non-king pieces wether the central square is vacant and can be skipped
    if (( piecetype < 3 )&&( tiles[xptrns][xptrew] == 3)&&(players[xptrns][xptrew] !=3 )){ // tiles=3(central), tiles=4(corner)	
      if ( players[skipns][skipew]  ) canmovecursor=0;	// cannot skip if otherside occupied
      if ((( skipns == ons )&&( skipew == oew ))||(	players[skipns][skipew] == 0)){			// ok to skip to self
        canmovecursor=1;
        multiple=2; 
      }			
    }	
  }
  if (canmovecursor ){
    fb=0;
    //inversex=cx;
	//inversey=cy;
    //drawcursor();
    inverse();				// print blank cursor (effect=remove dots)
    if ( mkey == 8 ) cx-=multiple;	// left
    if ( mkey == 9 ) cx+=multiple;	// right
    if ( mkey == 10 )cy+=multiple;	// down
    if ( mkey == 11 )cy-=multiple;	// up
    
    fb=1;
    //inversex=cx;
	//inversey=cy;
	//drawcursor();					// print dotted cursor
	inverse();
    if ( mkey == 8 ) ew-=multiple;	// left
    if ( mkey == 9 ) ew+=multiple;	// right
    if ( mkey == 10 )ns+=multiple;	// down
    if ( mkey == 11 )ns-=multiple;	// up
  }
  else{
    if ( cursormode == 0 ) {flashback=6;flashred();}	// flash red: return to cyan:6
    if ( cursormode == 1 ) {flashback=2;flashred();}	// flash red: return to green:2, yellow=3)
  }			
}


//  kicks off functions that print appropriate arrows at all possible 
// destinations and blanks them out afterwards
void printpossiblemoves(){
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
void backbone()	{
  origorient=orientation; // original orientation (for computer turn)
  xns=ns;	// copy of ns
  xew=ew;	// copy of ew
  arrow=1;
  // orientation 0,1,2,3 = N, S, E, W
  takerow=ns;takecol=ew; // will set below to be the opposite of the orientation
  if ( orientation == NORTH ) { xplayers=players[xns-1][xew];takerow=xns+1;} // check north
  if ( orientation == SOUTH ) { xplayers=players[xns+1][xew];takerow=xns-1;} // check south
  if ( orientation == EAST )  { xplayers=players[xns][xew+1];takecol=xew-1;} // check east
  if ( orientation == WEST )  { xplayers=players[xns][xew-1];takecol=xew+1;} // check west
  while (( arrow )&&(fb != 7)){ // keep checking until cannot move
    if (( orientation == NORTH ) && ( xns )){  // check north
      xns--;			// decrement provisional north-south player position
      subarrows();
    }
    if (( orientation == SOUTH ) && ( xns < 10 )){ // check south
      xns++;			// increment provisional north-south player position
      subarrows();
    }
    if ((orientation == EAST ) && ( xew < 10 )){ // check east
      xew++;			// increment provisional east-west player position
      subarrows();
    }
    if ((orientation == WEST ) && ( xew )){ // check west
      xew--;			// decrement provisional east-west player position
      subarrows();
    }
    tiletodraw=tiles[xns][xew];	// obtain type of tile	
    if ( arrow ){ // if MODE is "draw an arrow" (aka: I can move here) arrow=1 or 2
      // NOTE: arrow=2 means piece can cross this square but not occupy it as in case with CASTLE squares
      row=xns;
      col=xew;
      if ( arrow == 1 ){ // don't draw the arrow or update any array if arrow=2
      	if (fb == 1) drawarrow();		// draw arrow
      	if (fb == 4) subarrows2(); 		// enemy can get here, update enemy array (direction specific)
      	if (fb == 5) computer[xns][xew]++;// computer can get here, increment computer array and set default target value
      	if (fb == 0) drawarrow();			// if MODE is "blank an arrow"
      	if (fb == 8) kingtracker[xns][xew]=1; // king can get here...
  	  }
    }	
    // have we reached the end of the board?
    if (( orientation == NORTH ) && ( xns == 0 )) 	 zeroarrow();	// check north
    if (( orientation == SOUTH ) && ( xns == 10 )) 	 zeroarrow();	// check south
    if (( orientation == EAST ) && ( xew == 10 )) 	 zeroarrow();	// check east
    if (( orientation == WEST ) && ( xew == 0 )) 	 zeroarrow();	// check west
  }			
  if ((fb == 7)&&(xplayers > ATTACKER)){	// check to see if an attacker can be caught if he stays where he is
    if ((players[takerow][takecol] == 0)&&(enemy[takerow][takecol] )) {
	    a=takerow;b=takecol;sidestep();
      	if (orientation < EAST){	// if heading north or south
	    	a=xns;
        	if ( xew < 10 )	{b=xew+1;sidestep();}
        	if ( xew  )		{b=xew-1;sidestep();}
      	}
        else{					// if heading east or west
	    	b=xew;
        	if ( xns < 10 )	{a=xns+1;sidestep();}
        	if ( xns   )		{a=xns-1;sidestep();}
      	}
    }
  }
}
// sidestep: take a step sideways if you can be caught where you are...
void sidestep(){
	if (target[a][b] > 1)	target[a][b]+=SIDESTEP;
}

// Multi function depending on value of "fb"
void printdestinations(){
  // check north
  if ( ns ) 	{ orientation=NORTH;backbone();}				
  // check south
  if ( ns < 10 ){ orientation=SOUTH;backbone();}	
  // check east
  if ( ew < 10 ){ orientation=EAST;backbone();}	
  // check west
  if ( ew ) 	{ orientation=WEST;backbone();}			
}


// CAN A SELECTED PIECE MOVE?
void canpiecemove() {
  // returns 0 or 1 depending on wether a piece can move or not
  route=0;
  piecetype=players[ns][ew];	// determine TYPE of selected piece (1=attacker, 2=defendr, 3=king)
  /*  for all piece types determine if adjacent square in any direction is blank or not
  it won't bother checking a particular direction if piece is at edge of board.
  */
  if ( ns ){				// check north
    a=ns-1;b=ew;checkincroute(); 
  }
  if ( ns < 10 ){		// check south
    a=ns+1;b=ew;checkincroute();
  }
  if ( ew < 10 ){		// check east
    a=ns;b=ew+1;checkincroute(); 
  }
  if ( ew  ){				// check west
    a=ns;b=ew-1;checkincroute();
  }
  /* In the case that the central square is unnocupied and a piece is adjacent to that square then - for
  non-KING Pieces only - we need to check to see if the opposite square is occupied or not. 
  ROUTE will be decremented if that piece is occupied (as no piece can occupy the central square except for
  the King but all pieces can traverse it */
  if (( piecetype < 3 ) && ( players[5][5] == 4 )){	// if not a king and central sqr unoccupied
    if ( ns == 5 ) {
      if ( ew == 4 ) {if ( players[5][6]  ) decroute();}	// check east +2	// east occupied, dec route
      if ( ew == 6 ) {if ( players[5][4]  ) decroute();}	// check west +2	// west occupied, dec route
    }
    if ( ew == 5 ){
      if ( ns == 4 ) { if ( players[6][5] ) decroute();}	// check south +2	// south occupied, dec route
      if ( ns == 6 ) { if ( players[4][5]  ) decroute();}	// check north +2	// north occupied, dec route
    }
  }
  if ( route  ) route=1;
  //return route;
}


void checkincroute(){
  if ( players[a][b] == 0 ) 					incroute();
  if ( (a == 5) && (b == 5) && (players[a][b] == 4))	incroute();
  if (( piecetype == 3 )&&(tiles[a][b] == 4 ))	incroute(); // KING: corner square OK 
}


// DRAW ALL THE PIECES ON THE BOARD
void drawplayers() {
  for (row=0;row<11;row++){
    for (col=0;col<11;col++){
      if (( players[row][col]  )&&(players[row][col] < 4))	drawpiece();			
    }
  }
}
// update the deadpile
void deadpile(){
  //curset(212,0,0);
  //hchar('X',0,1);
  //curset(212+6,0,0);
  //hchar('*',0,1);
  //curset(212+12,0,0);
  //hchar('0',0,1);
  //curset(212+18,0,0);
  //hchar('X',0,1);
  if (playertype == 1){
	  deaddefenders++;
	  deadplayers=deaddefenders;
	  deadcurset=DEADPILED;
	  deadchar='(';
  }
  if (playertype == 2){
	  deadattackers++;
	  deadplayers=deadattackers;
	  deadcurset=DEADPILEA;
	  deadchar=')';
  }
  
  if ( deadplayers  ){
	  for (x=0;x<deadplayers;x++){
		  curset(deadcurset,x*8,0);
		  hchar(deadchar,0,deadtoggle);
	  }
  }
 
}

// DRAW THE BOARD
void drawboard(){
  deadtoggle=0;					// ensure deadpile chars drawn in background
  playertype=1;deadpile();	// clear the deadpile of defenders
  playertype=2;deadpile();  // clear the deadpile of attackers
  deadattackers=0;deaddefenders=0; // reset deadpile counts
  game=1;						// game=1 means PLAY GAME
  gamestyle=3;					// 0=play against human, 1=play as DEFENDERS, 2=play as ATTACKERS, 3=nobody  
  kingns=5;kingew=5;			// DEFAULT kings board position
  kingattacker[NORTH]=2;		// count of attackers NORTH of king
  kingattacker[SOUTH]=2;		// count of attackers SOUTH of king
  kingattacker[EAST]=2;			// count of attackers EAST of king
  kingattacker[WEST]=2;			// count of attackers WEST of king
  kingdefender[NORTH]=2;		// count of defenders NORTH of king
  kingdefender[SOUTH]=2;		// count of defenders SOUTH of king
  kingdefender[EAST]=2;			// count of defenders EAST of king
  kingdefender[WEST]=2;			// count of defenders WEST of king
  surrounded=0;					// reset surrounded back to zero
  drawtiles();					// draw the background tiles
  //curset(12,198,1);
  //draw(198,0,1);
  drawbottom();
  drawedge();
  //draw(0,-198,1);
  drawplayers(); 	// draw the players
  deadatt();	// set dead colors attackers
  deaddef();	// set dead colors defenders
  
}


// blinks the cursor a number of times to attract attention
void blinkcursor() {
  //inversex=cx;
  //inversey=cy;
  for (counter=0;counter<5;inccounter()){	// flash the cursor to draw attention to it
    fb=0; 
    //drawcursor();					// draw cursor in background color at cx,cy
    inverse();
    pausetime=500;pause();
    inverse();
   	fb=1; 
   	//drawcursor(); 	// draw cursor in foreground color at cx,cy
   	pausetime=1000;pause();	
  }
  if ((cx==5)&&(cy==5)) inverse();
}
// flashes the screen in the selected ink color
void flashscreen() {
  inkcolor=flashcolor;inkasm();
  pausetime=1500;pause();
  inkcolor=flashback;inkasm();
}
// The human players turn : filter keyboard input
void playerturn(){	
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
  playertext="ATTACKER";
  if ( playertype == 2 ) playertext="KING'S";
  /*
  if ( playertype == 2 ){ 
	playertext="KING'S";
  }
  else{
    playertext="ATTACKER";
  }
  */
  blinkcursor();
  printturnprompt();	// display instructions
  while (turn){			// repeat until move is made
    xkey=getchar();		// get code of pressed key
    mkey=xkey;
    if (( xkey > 7 ) && ( xkey < 12 )){  // 8-11 = cursor keys 
      cursormode=0;  // freeform
      movecursor2();  
    }		
    /*******************************************************/
    /* determine if X or P is selected (to select a piece) */
    /*******************************************************/
    if (( xkey == 88) || ( xkey == 80)){	// if 'X' or 'P' is selected (88=X, 80=P)
      canselect=0;		// set piece to NOT SELECTABLE
      if (( playertype == 1 )&&(players[ns][ew] == 1 ))	canselect=1; // piece is selectable
      if (( playertype == 2 )&&((players[ns][ew] == 2 )||(players[ns][ew] == 3))) canselect=1;// piece is selectable
      if ( canselect  ){
        canpiecemove();
        if (route ) { 
        	flashcolor=2;flashscreen();	// flash 2=green, 3=yellow
          	if ( xkey == 80 ){	// if P is pressed
            	printpossiblemoves();	// Print possible moves
            	printturnprompt();
          	}
        }
        else { 
          flashred();
          canselect=0;		// unselectable, cannot move
        }				
      }
      else { 
	     flashred();	
      }		
      if (( mkey == 88 )&&( canselect  )){	// if piece is SELECTED and CAN move
        inkcolor=2;inkasm(); 				// 2=green, 3=yellow to indicate piece is selected
        flashback=2;
        inverse2();
        //printmessage();
        //strcpy(message,playertext);
        message="PLACE CURSOR ON DESTINATION\nX=SELECT\nR=RESET";
        printmessage();
        //printf("\n\n\n%s Turn X=Select R=Reset",playertext);
        //inversex=cx;
        //inversey=cy;
        //inverse();				// highlight selected square (inverse color)
        mkey=0;					// ensure mkey at known value
        // set Original cursor and board position of selected square
        ocx=cx; ocy=cy; ons=ns; oew=ew;
        while (( mkey != 88 ) && ( mkey != 82)){ // move cursor until X or R selected
        	if (( ons == ns )&&( cursormovetype < 0)) cursormovetype=1; // cursor allowed north-south
          	if (( oew == ew )&&( cursormovetype < 0)) cursormovetype=2; // cursor allowed east-west
          	if (( ons == ns )&&	(oew == ew )) 		cursormovetype=0; // cursor can move 	
          	if (( cursormovetype == 2) && (( mkey == 8)	||(mkey == 9)))	cursormovetype=-1;	//!move 
          	if (( cursormovetype == 1) && (( mkey == 10)||(mkey == 11)))cursormovetype=-1;	//!move
          	if (( cursormovetype == 0) && (( mkey == 8)	||(mkey == 9)))	cursormovetype=1;	//move
          	if (( cursormovetype == 0) && (( mkey == 10)||(mkey == 11)))cursormovetype=2;	//move
          	if ( cursormovetype > 0 ) {
            	cursormode=1;	// restricted
            	movecursor2();
          	}
          	if ( cursormovetype < 0) { flashred();}	// flashscreen red
          	mkey=getchar();
        }
       	if ( mkey == 82 ){ // R has been selected, Reset cursor to original positions
         	fb=0;
         	//drawcursor();		// blank out cursor at current position
         	//inversex=cx;
         	//inversey=cy;
         	inverse();
         	cx=ocx;						// reset coords and board values to original positions
         	cy=ocy;
         	ns=ons;
         	ew=oew;
         	//inversex=cx;
         	//inversey=cy;
         	fb=1;
         	//drawcursor();		// draw cursor at original selected position
         	inverse2();
         	inverse();		// inverse square
       		}
       	if ( mkey == 88 ){				// if X selected
         	//inversex=ocx;
         	//inversey=ocy;
         	inverse();			// inverse original position
         	// X is in original position so return to cursor movement 
         	
         	if (( ons == ns )&&( oew == ew)){
	         	inverse2();
	         	inverse();
           		mkey=0;		// piece de-selected
         	} 
         	else{ 
          		movepiece();	// move selected piece				
           		turn=0;		// player has ended turn
         	}
         	
       	}
      }
      inkcolor=6;inkasm();	// back to cyan	
      flashback=6;
      printturnprompt();		
    }		// key = X or P
  }	// While player turn		
}


// Moves selected piece to new location - updating board arrays and re-drawing tiles where necessary
void movepiece(){ 
  p1=ATTACKER;	// piece type comparison (lower) - used for determining takes - default=attacker
  p2=CASTLE;	// piece type comparison (upper) - used for determining takes - default=attacker
  piecetype=players[ons][oew];	// obtain type of piece
  // move piece
  fb=0;
  //drawcursor();				// blank out cursor at new selected position
  row=ons;
  col=oew;
  tiletodraw=tiles[ons][oew];
  ptr_graph=PictureTiles;drawtile();	//draw tile at original location (blank out square)
  players[ons][oew]=0;					//set original location to zero (unnocupied)
  players[ns][ew]=piecetype;			//update square with player info
  // row, col required for drawpiece function
  row=ns;
  col=ew;
  drawpiece();			// draw piece at new location - 18-10-2011
  if (piecetype == KING){	// update king position (used by AI) 
	  kingns=ns;kingew=ew;
	  if ((kingns != 5)||(kingew != 5)) {
		  players[5][5]=CASTLE; // set central square to be 4 so it can be used in takes
		  tiletodraw=3; row=5;col=5; ptr_graph=PictureTiles;drawtile(); // draw central square
	  }
  }	
  // having moved piece we now need to check for, and implement any TAKES
  if (piecetype > ATTACKER ){	// if defender
    p1=DEFENDER;
    p2=KING;
  }
  tpew=ew;
  if ( ns > 1 ){// check north
    orientation=NORTH;
    if ( cantakepiece()  ) { tpns=ns-1; takepiece(); }
  }
  if ( ns < 9 ){ // check south
    orientation=SOUTH;
    if ( cantakepiece()  ) { tpns=ns+1; takepiece(); }
  }
  tpns=ns;
  if ( ew < 9 ){ // check east
    orientation=EAST;
    if ( cantakepiece() ) { tpew=ew+1; takepiece(); }
  }
  if ( ew > 1 ){ // check west
    orientation=WEST;
    if ( cantakepiece() ) { tpew=ew-1; takepiece(); }
  }
  // update count of attackers around king
  kingattacker[NORTH]=0;		// count of attackers NORTH of king
  kingattacker[SOUTH]=0;		// count of attackers SOUTH of king
  kingattacker[EAST]=0;			// count of attackers EAST of king
  kingattacker[WEST]=0;			// count of attackers WEST of king
  kingdefender[NORTH]=0;		// count of defenders NORTH of king
  kingdefender[SOUTH]=0;		// count of defenders SOUTH of king
  kingdefender[EAST]=0;			// count of defenders EAST of king
  kingdefender[WEST]=0;			// count of defenders WEST of king
  kingpieces[NORTH]=0;
  kingpieces[SOUTH]=0;
  kingpieces[EAST]=0;
  kingpieces[WEST]=0;
  orientation=NORTH;
  cy=kingew;
  for (counter=0;counter<kingns;inccounter()){ 	 
    cx=counter;incdefatt();
  }
  orientation=SOUTH; // SOUTH
  for (counter=kingns+1;counter<11;inccounter()){ 
    cx=counter; incdefatt();
  }
  orientation=EAST; // EAST
  cx=kingns;
  for (counter=kingew+1;counter<11;inccounter()){ 
    cy=counter; incdefatt();
  }
  orientation=WEST; // WEST
  for (counter=0;counter<kingew;inccounter()){ 
    cy=counter; incdefatt();
  }
}

void incdefatt(){
  if (players[cx][cy] == ATTACKER) inckingattacker();
  if (players[cx][cy] == DEFENDER) inckingdefender();
}

void inckingdefender(){
  kingdefender[orientation]++;
  kingpieces[orientation]++;
}

void inckingattacker(){
  kingattacker[orientation]++;
  kingpieces[orientation]++;
}

/*void subcanbetaken(){
target[targetns][targetew]=1;
//if ((ns==kingns)||(ew==kingew)) { target[ns][ew]=3;}  // means acceptable risk
}
*/
// can I be taken after moving here? 
void canbetaken() {
  if ((targetns )&&(targetns < 10)){
    takena=targetns-1;takenb=targetew;takenc=targetns+1;takend=targetew;takene=1;
    subcanbetaken2();
    takena=targetns+1;takenb=targetew;takenc=targetns-1;takend=targetew;takene=5;
    subcanbetaken2();
  }

  if ((targetew )&&(targetew < 10)){
    takena=targetns;takenb=targetew+1;takenc=targetns;takend=targetew-1;takene=10;
    subcanbetaken2();
    takena=targetns;takenb=targetew-1;takenc=targetns;takend=targetew+1;takene=20;
    subcanbetaken2();	
  }
}

// Will return a value (take) who's values will be: 0= no, 1=yes
unsigned char cantakepiece(){
  take=0;
  p1=ATTACKER;			// piece type comparison (lower) - used for determining takes - default=attacker
  p2=CASTLE;			// piece type comparison (upper) - used for determining takes - default=attacker
  pcheckns1=ns-1;	// defaults to north
  pcheckns2=ns-2;
  pcheckew1=ew;
  pcheckew2=ew;
  piecetype=players[ns][ew];	// obtain type of piece
  //if ( fb==3) { piecetype=players[ctns][ctew];} // if computer turn set piecetype to piece being checked
  if ((fb == 3)||(fb == 9)) piecetype=ATTACKER;	// default = ATTACKER
  if (piecetype > ATTACKER ){	// if defender
    p1=DEFENDER;
    p2=KING;
  }
  if ( orientation == SOUTH){	// if south
    pcheckns1=ns+1;
    pcheckns2=ns+2;
  }
  if ( orientation > SOUTH){	// if east or west
    pcheckns1=ns;
    pcheckns2=ns;
    pcheckew1=ew+1;
    pcheckew2=ew+2;
    if ( orientation == WEST){ // if west
      pcheckew1=ew-1;
      pcheckew2=ew-2;
    }
  }
  // RingOfSteel: when fb==6 update target if defender outside it's home zone
  if ((fb == 6)&&(players[pcheckns1][pcheckew1] == DEFENDER)){
	  if (( pcheckns1 < 3 ) || (pcheckns1 > 7) || (pcheckew1 < 3)||(pcheckew1 > 7)){
		  target[ns][ew]+=10;
	  }
  }
  // if a take is possible increment the take counter - if values fall within bounds...
  if ((pcheckns2 > -1)&&(pcheckns2 < 11)&&(pcheckew2 > -1)&&(pcheckew2 < 11)){
    if (( players[pcheckns1][pcheckew1]  )&&(players[pcheckns1][pcheckew1] != p1)&&(players[pcheckns1][pcheckew1] != p2 )&&(players[pcheckns1][pcheckew1] != CASTLE)){	
     	// if ((( players[pcheckns2][pcheckew2] == p1 )||(players[pcheckns2][pcheckew2] == p2 )||(players[pcheckns2][pcheckew2] == 4)&&(pcheckns2!=5)&&(pcheckew2!=5))) // the 5 is to EXCLUDE central square
      if (( players[pcheckns2][pcheckew2] == p1 )||(players[pcheckns2][pcheckew2] == p2 )||(players[pcheckns2][pcheckew2] == CASTLE)){  
        take++;
        //if ((players[pcheckns1][pcheckew1]==3)&&(surrounded<3))take--;	// if possible take is a king but not surrounded
        if (players[pcheckns1][pcheckew1]==KING) take--;// if possible take is a king 

      } 
      if ( computer[pcheckns2][pcheckew2] ) inctarget(); // 31-10-2011 - can possibly take on next turn
    }
  }
  return take;
}

// performs taking/removing a piece
void takepiece() {		
  players[tpns][tpew]=0;			// clear board location
  row=tpns;
  col=tpew;
  inkcolor=6;inkasm();
  explodetile();					// plays animation to "kill" a tile
  tiletodraw=tiles[row][col];		// decide tile to draw
  ptr_graph=PictureTiles;drawtile();// draw tile at location
  // update deadpile
  deadtoggle=1; // ensure deadpiece is drawn in foreground color on deadpile 
  deadpile();
}

void subarrows(){
  if ( tiles[xns][xew] == CASTLE ) arrow=2;
  if ((players[xns][xew])&&(players[xns][xew] < CASTLE)) { 
    arrow=0;	// !ok if piece occupied 
    if ((fb == 4)&&(players[xns][xew] == ATTACKER)) enemy[xns][xew]+=ENEMYWEIGHT;	// means enemy could get here if attacker moved elsewhere
  }
  if (( players[ns][ew] == KING )&&( tiles[xns][xew] == CASTLE )) arrow = 1;  // CASTLE square ok if king	
}

void subarrows2(){
  if ( orientation == NORTH ) enemy[xns][xew]+=5; 	// means enemy can get here from SOUTH
  if ( orientation == SOUTH ) enemy[xns][xew]+=1; 	// means enemy can get here from NORTH
  if ( orientation == EAST ) enemy[xns][xew]+=20; 	// means enemy can get here from WEST
  if ( orientation == WEST )  enemy[xns][xew]+=10; 	// means enemy can get here from EAST
}

void inccantake(){
  z=cantakepiece();
  if (z ){
    cantake+=z;
    cantakeadjust();	// decrement take count if taken piece on same plane as king and taker isn't	
  }
}

// Explodes a tile
void explodetile()	{
  //unsigned char b;
  ptr_graph=ExplodeTiles;		// pointer to byte values of loaded picture	
  for (b=0;b<8;b++){
    tileloop();
    pausetime=900;
    if (b == 5) pausetime=3000; // pause longer on skull&crossbones
    pause();	// add a pause
  }	
}

void timertile(){
	unsigned char timer;
	ptr_graph=TimerTiles;		// pointer to byte values of loaded picture (Timer)
	row=5;col=5;
	for (timer=0;timer<8;timer++){
		tileloop();
		pausetime=250;pause();
	}
}

void drawpiece(){
  tiletodraw=players[row][col];
  if ( tiletodraw ) tiletodraw+=3;
  if ( tiles[row][col]  ) tiletodraw+=3;
  ptr_graph=PictureTiles;drawtile();
}

void drawarrow(){
  if ( fb == 1 ){
    tiletodraw=10;
    if ( tiles[row][col] ) tiletodraw++;      // add another 1 for arrow with background
  }
  else{
    tiletodraw=tiles[row][col];			  // draw original tile (includes blank)
  }
  ptr_graph=PictureTiles;drawtile();
}

void surroundcount(){
  //unsigned char test;
  zerocounter();
  //setpoints();
  surrounded=0;
  if (( kingns == 0)||(kingns == 10)||(kingew == 0)||(kingew == 10)) incsurround(); // added 18/10/2011 (inc surround if at an edge)
  surew=kingew;
  if ( kingns  )	{surns=kingns-1;surroundcheck();}
  if ( kingns < 10 ){surns=kingns+1;surroundcheck();}
  surns=kingns;
  if ( kingew  )	{surew=kingew-1;surroundcheck();} 
  if ( kingew < 10 ){surew=kingew+1;surroundcheck();}
  /*for (test=surrounded;test >0; test--){
	  zap();
  }*/
  // unset any "enemy and target values" ONLY if blank square adjacent to king is accessible
  if (surrounded == 3){	 
    ezew1=kingew;
    if ( kingns  ){		// NORTH
      ezns1=kingns-1;
      enemyzero();
    }
    if ( kingns < 10 ){ // SOUTH
      ezns1=kingns+1;
      enemyzero();
    }
    ezns1=kingns;
    if ( kingew < 10 ){ // EAST
      ezew1=kingew+1;
      enemyzero();
  	}
    if ( kingew  ){
      ezew1=kingew-1;	// WEST
      enemyzero();
    }
  }
}

void pause(){
  int p;
  for (p=0; p<pausetime;p++){};
}


/******************************/

void subcanbetaken2(){	// DO NOT MESS with this (NBARNES 10-01-2012)
  if (players[takena][takenb] > ATTACKER){
    if ((players[takenc][takend] == 0)||(enemy[takenc][takend] > ENEMYWEIGHT)){
      if ((enemy[takenc][takend]-takene)&&((enemy[takenc][takend] < ENEMYWEIGHT)||(enemy[takenc][takend]-ENEMYWEIGHT))){ // 23-12-2011 
        compass[origorient]=1;	// e.g. compass[NORTH]=1 means canbetaken here if moving from NORTH
        if (enemy[takenc][takend]>ENEMYWEIGHT){ // THIS is the business!!!
          if ((origorient < EAST)&&(mkey != takenc)&&(oew != takend)) compass[origorient]=0;
          if ((origorient > SOUTH)&&(ons != takenc)&&(mkey != takend))compass[origorient]=0;
        }
      }
    }
  }
}


void inctarget(){
  target[targetns][targetew]+=2;
  //target[targetns][targetew]++; // 28-04-2013
}


void surroundcheck(){ 
  // if attacker or kingsquare n/s/e/w then inc surrounded
  //if (players[surns][surew]==1)	incsurround();	// is attacker n,s,e,w
  //if (tiles[surns][surew]>2)	incsurround();	// is king square n,s,e,w
  if ((players[surns][surew] == 1)||(tiles[surns][surew] > 2)) {
	  incsurround();
  }
}




// called from "surroundcount()"
void enemyzero() {
  if (( players[ezns1][ezew1] == 0 )&&(target[ezns1][ezew1])){	// if adjacent square n/s/e/w is blank and accessible
    ClearArrays();				// set all arrays to zero (target, enemy, computer)
    target[ezns1][ezew1]=100;	// set big target value to final space by king
  }
}
// Checkroute:	
// Currently only works when "crossing the T" 
// checkroutemode=1 Returns number of pieces on a given route
// 				checkroutemode=2 Increments the target values on route
//				checkroutemode=3 Number of targets on route
//				checkroutemode=4 Number of "enemy" targets on route (where enemies CAN go)
//				checkroutemode=5 Emergency! Make target=hightarget+1
unsigned char checkroute(){
  z=0;
  // a SINGLE COLUMN (North to South) so check each row on it
  checkroutestart=startrow;
  checkroutedest=destrow;
  checkrouterow=startrow;	
  checkroutecol=startcol;	
  if ( startrow == destrow ){   // ELSE a single ROW (EAST to WEST)
	  checkroutestart=startcol; 
	  checkroutedest=destcol;
  }
  for (x=checkroutestart;x<=checkroutedest;x++){
	    //if ( startrow==destrow ) {checkroutecol++;}else{checkrouterow++;}
		switch(checkroutemode){
    		case 1:	if ((players[checkrouterow][checkroutecol] == ATTACKER )||(players[checkrouterow][checkroutecol] == DEFENDER )) z++;break;
      		case 2: if (target[checkrouterow][checkroutecol] )	target[checkrouterow][checkroutecol]+=2;break;
      		case 3: if (target[checkrouterow][checkroutecol] >1 ) z++;break; 
      		case 4: if (enemy[checkrouterow][checkroutecol] ) z+=ENEMYBLOCK;break;
      		case 5: if (target[checkrouterow][checkroutecol]){
	      				target[checkrouterow][checkroutecol]+=points;} // brokenarrow
      				break;
      		//case 6: if (players[checkrouterow][checkroutecol])      z++;break;
      		case 6: if (kingtracker[checkrouterow][checkroutecol]) z++;break;
  		}
  		if ( startrow == destrow ) {checkroutecol++;}else{checkrouterow++;}

  }
  return z;
}

/*
// ORIGINAL 02/09/2012
unsigned char checkroute(){ 
  z=0;
  if (orientation<EAST){			// if checking ROWS (crossing the T) (used for NORTH SOUTH checks)
    for (x=startcol;x<=destcol;x++){ // check row
	  switch(checkroutemode){
      	case 1:	if ((players[startrow][x]==1)||(players[startrow][x]==2)) {z++;}break;
      	case 2: if (target[startrow][x])	{target[startrow][x]+=2;}break;
      	case 3: if (target[startrow][x])	{z++;}break;
      	case 4: if (enemy[startrow][x])		{z+=10;}break;
      	case 5: if (target[startrow][x]) 	{target[startrow][x]=255;}
  	  }
    }
  }
  else	{					// EAST WEST checks (crossing the T)
    for (x=startrow;x<=destrow;x++){ // check accross
	  switch(checkroutemode){
      	case 1: if ((players[x][startcol]==1)||(players[x][startcol]==2)) {z++;}break;
      	case 2: if (target[x][startcol])	{target[x][startcol]+=2;}break;
      	case 3: if (target[x][startcol])	{z++;}break;
      	case 4: if (enemy[x][startcol])		{z++;}break;
      	case 5: if (target[x][startcol]) 	{target[x][startcol]==255;}
  	  }
    }
  }
  return z;
}
*/
// decrements cantake if taken piece is on same plane as king 
// and attacking piece isn't AND only one defender on plane
void cantakeadjust(){							
  flag=0;
  if ((playertype == 1)&&(gamestyle == 1)){	// if computer playing as attacker and his turn
    if (pcheckns1 == kingns){
      flag=1;
      if (ctew < kingew){orientation=WEST;}else{orientation=EAST;}
      //if ((kingattacker[orientation]+kingdefender[orientation])<4){cantake--;}
    }
    if (pcheckew1 == kingew){
      flag=1;
      if (ctns < kingns){orientation=NORTH;}else{orientation=SOUTH;}
      //if ((kingattacker[orientation]+kingdefender[orientation])<4){cantake--;}
    }
    if (flag )		{
      //if ((kingattacker[orientation]+kingdefender[orientation])<4){cantake--;}
      if (kingpieces[orientation] < 4) cantake--; //10-05-2013 if no other pieces on plane
    }

  }
}

void updatetarget(){
  targetns=ctns;targetew=ctew;
  target[targetns][targetew]=2;	// set target to 2 (1=canbetaken if i go here)
  // set "illegal" squares to zero
  target[5][5]=0;		
  target[0][10]=0;
  target[0][0]=0;
  target[10][0]=0;
  target[10][10]=0;
  if ( target[targetns][targetew] ){	// only if target is valid (i.e. not a king square)
  	// increase target if blocking 1 enemy
    if ( enemy[targetns][targetew] ) inctarget();
    // increase taregt if blocking 2 enemies		
    if (( enemy[targetns][targetew] == 6)||(enemy[targetns][targetew] == 11)||(enemy[targetns][targetew] == 21)||(enemy[targetns][targetew] == 15)||(enemy[targetns][targetew] == 25)||(enemy[targetns][targetew] == 30)) inctarget();
    // increase target if blocking 3 enemies
    if (( enemy[targetns][targetew] == 35)||(enemy[targetns][targetew] == 16)||(enemy[targetns][targetew] == 26) || (enemy[targetns][targetew] == 31)) inctarget();
    // calculates how many takes can be made in this position (cantake)
    calccantake2();
    //calccantake();			// calculates how many takes can be made in this position (cantake)
    //y=cantake*TAKEWEIGHT;	// value to be added to target			
    //target[targetns][targetew]+=y; // add cantake (will be zero if cannot take)
    target[targetns][targetew]+=(cantake*TAKEWEIGHT);
    //if (cantake==0)	{canbetaken();}		// sets target to 1 if cannot take but can be taken
  }
}


// calculate how many takes can be made
/*
void calccantake() {
  //unsigned char x;
  //cantake=0;	
  inccantake();	// inc cantake if can take in direction of travel
  //for (x=0;x<4;x++) {
    //if ( x<2 ){ // heading north/south
  if ( origorient < EAST ){ // HEADING NORTH/SOUTH
      if ( ew < 10 ) {orientation=EAST; inccantake();}	// check EAST
      if ( ew > 1 )  {orientation=WEST; inccantake();}	// check WEST
  }else{ 		  // heading east/west
      if ( ns > 1 ) {orientation=NORTH; inccantake();}  // check NORTH
      if ( ns < 9 ) {orientation=SOUTH; inccantake(); }  // check SOUTH
  }
}
*/
void calccantake2(){
	// check all directions from a given target square...
	cantake=0;
	if ( ew < 10 ) {orientation=EAST;  inccantake();}   // check EAST
    if ( ew > 1 )  {orientation=WEST;  inccantake();}   // check WEST
	if ( ns > 1 )  {orientation=NORTH; inccantake();}   // check NORTH
    if ( ns < 9 )  {orientation=SOUTH; inccantake();}   // check SOUTH
}
// print the title screen
void printtitles()		{
  unsigned char f=0;
  inkcolor=3;inkasm();	// yellow, erm...gold
  row=0;c=6;d=11;col=0;
  for (mkey=0;mkey<2;mkey++){	
    for (a=row;a<c;a++){
      col=0;
      if (mkey ) {fliprune();col=1;}   // flip the row		
      for(b=col;b<d;b++){
        tiletodraw=border[a][b];      // get runic chars
        if (f == 1) tiletodraw++;     // get western chars on 2nd pass
        if ( tiletodraw < 99){
          ptr_graph=RunicTiles;	      // pointer to Border Tiles graphics
          drawtile();		      // draw tile
        }
        col++;
      }
      row++;
    }
    row=1;col=1;c=5;d=10;pausetime=26000;pause();
    f++;if (f==2) f=0;
  }
}

// performs the rune flipping sequence in title screen
void fliprune()		{
  for (tiletodraw=30;tiletodraw<35;tiletodraw++){
    for (col=1;col<10;col++){
      if (border[row][col] < 99){
        ptr_graph=RunicTiles;		// pointer to Border Tiles graphics
        drawtile();pausetime=50;pause(); 
      }
    }
  }
}
/*
void subzoneupdate(){	// (updates border targets)
	message="BROKEN ARROW UPDATE";
	printline();
	message="\nPRESS A KEY";
	printline();
	getchar();
	checkroutemode=5;checkroute();	
}
*/
void updateroutetarget(){
//setcheckmode3(); // set the mode of checkroute to 3 (count how many TARGETS are on route)
//pacpointsz=checkroute();
//pacpointsz=25-pacpointsz;	// 20 = max amount of targets on a given route to a corner
	setcheckmode2(); // set the mode of checkroute to 2 (update targets)
	checkroute();
}

// flashes the screen red (goes back to whatever flashback is set to)
void flashred(){
	flashcolor=1;
	flashscreen();
}

/*
void prioritycalc(){ // calculates the priorities of moving a piece
	for(a=0;a<11;a++){
		for (b=0;b<11;b++){
			if (players[a][b]==1){
				// count attackers on row
				for (c=0;c<11;c++){
					if (players[c][b]==1) priority[a][b]++;
				}
				for (d=0;d<11;d++){
					if (players[a][d]==1) priority[a][b]++;	
				}
			}
		}
	}
}
*/