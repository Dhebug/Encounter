
/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/****************************/

#include "globals.h"

/* Main script: entry point to the game */
script 0
{
	// Initialize flags and variables
	bReadMapPoster=false;
	bManTalkedBoutCoffee=false;
	bMetRavella=false;
	bMapContactGiven=false;
	bTradeInitiated=false;
	bMugGiven=false;
	bMapPrinted=false;
	bGotMap=false;
	bEscapeFromNurse=false;
	bNurseGaveLaxative=false;	
	bCouchPushed=false;	
	bAutoExit=false;
	bGuardWentForCoffee=false;
	bSnoringHeard=false;
	bSandwichGiven=false;
	bTechcamOut=false;
	bCoinStuck=false;
	bGuardInCtrlRoom=false;
	bDecafReady=false;
	bCamDeactivated=false;
	bCamCodeSeen=false;
	bGratingOpen=false;
	bEnvelopeExamined=false;
	// This is for Ep 3, but cell must be taken in Ep 2
	bCellPlaced=false;
	
	nPushMachine=0; // Times the coffee machine with a coin stuck has been pushed
	nMsgInfo=0;
	
	// Load default strings for failed actions & lock
	scLoadResource(RESOURCE_STRING,0);
	scLockResource(RESOURCE_STRING,0);
	
	// Same for default actions
	scLoadResource(RESOURCE_SCRIPT,1);
	scLockResource(RESOURCE_SCRIPT,1);
	
	// Run intro
	scChainScript(2);
	
	// Prepare main actor as ego
	scLoadObjectToGame(BLAKE);
	scSetEgo(BLAKE);
	scFollowActor(BLAKE);
	scLockResource(RESOURCE_COSTUME,0);
	
	// Load global objects
	scLoadObjectToGame(GUARD);	
	scLoadObjectToGame(SANDWICH);
	scLoadObjectToGame(MUG);
	scLoadObjectToGame(TECHCAM);
	scLoadObjectToGame(INFOMAN);
	
	// Set fade effect & Load initial room
	scSetFadeEffect(1+128);
	scLoadRoom(INITIAL_ROOM);

	// I am setting the costume for these objects here
	// because that way they can be local, saving
	// entries in disk. Anyway they are not used
	// anywhere else.
	scSetCostume(SANDWICH,210,0);
	scSetCostume(MUG,211,0);
	scSetAnimstate(SANDWICH,0);
	scSetAnimstate(MUG,0);

	scSetPosition(BLAKE, INITIAL_ROOM, 13,14);
	scLookDirection(BLAKE, FACING_DOWN);
	scBreakHere();	// Give time to render the scene
	
	// Make Blake say the initial sentence
	scActorTalk(BLAKE,200,0);
	scWaitForActor(BLAKE);
	scActorTalk(BLAKE, 200,1);
	scWaitForActor(BLAKE);
	
	// Display verbs
	scShowVerbs(true);
	
	// Initial help with shortcuts
	scChainScript(30);
	
	//==================================================
	// Testing
	
	// Final of Episode I

//#define EPISODE2	
//#define CYGNUS
//#define LIBERATOR

//#define EPISODE3HID
//#define EPISODE3CORR
//#define EPISODE3CALLY
//#define EPISODE3
//#define EPISODE3END

#ifdef EPISODE3END
	scLoadObjectToGame(AVON);
	scLoadObjectToGame(JENNA);
	scLoadObjectToGame(GAN);
	scLoadObjectToGame(CALLY);
	scLoadObjectToGame(VILA);
	scSpawnScript(21);
	scStopScript();
#endif

#ifdef EPISODE3CALLY
	bBallDefeated=true;
	bCenteroOrbit=true;
	bGuardLeftCells=true;
	bClockTampered=true;
	bCellFound=true;
	scLoadObjectToGame(TRASPONDER); 
	scSetPosition(TRASPONDER,ROOM_SERVICE,10,12);
	scPutInInventory(BRACELET);
	scPutInInventory(GUN);	
	//scSetPosition(BLAKE,ROOM_CORRIDOR,15,97);
	//scLookDirection(BLAKE,FACING_LEFT);		
	//scChangeRoomAndStop(ROOM_CORRIDOR);
	scSetPosition(BLAKE,ROOM_CELLENTRY,8,33);
	scLookDirection(BLAKE,FACING_LEFT);		
	scChangeRoomAndStop(ROOM_CELLENTRY);
#endif

#ifdef EPISODE3CORR
	scPutInInventory(UNIFORM);
	bClockTampered = true;
	scSetPosition(BLAKE,ROOM_CORRIDOR,15,97);
	scLookDirection(BLAKE,FACING_LEFT);		
	scChangeRoomAndStop(ROOM_CORRIDOR);
#endif

#ifdef EPISODE3
	scShowVerbs(false);
	scPutInInventory(ECELL);
	bEnergyCellTaken=true;
	bGanIntroduced=true;
	bAvonIntroduced=true;
	bGunSeen=true;
	bBraceletSeen=true;
	bBallDefeated=true;
	bTelIntroduced=true;
	bDrainUnclogged=true;
	bCloggingSeen=true;
	bSinkUsed=true;
	scSpawnScript(15);
#endif


#ifdef EPISODE3HID
	scLoadObjectToGame(JENNA);

	scSetPosition(BLAKE,ROOM_HIDEOUT,16,11);
	scPutInInventory(ECELL);
	bGanIntroduced=true;
	bAvonIntroduced=true;	
	scLookDirection(BLAKE,FACING_UP);		
	scChangeRoomAndStop(ROOM_HIDEOUT);		
#endif


#ifdef CYGNUS
	// Jenna and Avon need to exist. Let's
	// put them in their positions and
	// signal Avon's been introduced to avoid problems
	scLoadObjectToGame(AVON);
	scLoadObjectToGame(JENNA);
	scSetPosition(AVON,24,15,32);
	scLookDirection(AVON, FACING_LEFT);
	scSetPosition(JENNA,22,16,5);
	bAvonIntroduced=true;
	
	scPutInInventory(SPRAY);
	scPutInInventory(BRACELET);
	scPutInInventory(BRACELETS);
	scPutInInventory(GUN);
	
	scPutInInventory(LAMP);
	scPutInInventory(ROPE);
	
	//scSetPosition(BLAKE,31,14,1);
	//scChangeRoomAndStop(31);
	
	scSetPosition(BLAKE,ROOM_CACELLS,15,32);
	scChangeRoomAndStop(37);
#endif


#ifdef EPISODE2
	scPutInInventory(COIN);
	scSetPosition(BLAKE,7,13,14);
	scChangeRoomAndStop(7);
	
#endif	
#ifdef LIBERATOR
	// Episode II start
	
	//scPutInInventory(CATPULT);
	//scPutInInventory(BEARING);

	
	//scShowVerbs(false);
	//scChangeRoomAndStop(12); // Cell
	//scChangeRoomAndStop(17); // Computer
	
	
	// Test Liberator Deck
	//scSetPosition(BLAKE,22,13,2);
	//scChangeRoomAndStop(22);
	
	// Test Liberator Passageway

	// Jenna and Avon need to exist. Let's
	// put them in the entrance at least and
	// signal Avon's been introduced to avoid problems
	scLoadObjectToGame(AVON);
	scLoadObjectToGame(JENNA);
	scSetPosition(AVON,22,16,18);
	scSetPosition(JENNA,22,16,5);
	bAvonIntroduced=true;	
	
	scLoadObjectToGame(SCISSORS); 
	scSetAnimstate(SCISSORS,1);
	scLoadObjectToGame(WRENCH);
	scSetAnimstate(WRENCH,4);
	scLoadObjectToGame(PLIERS);
	scSetAnimstate(PLIERS,3);
	scLoadObjectToGame(SPRAY);
	scSetAnimstate(SPRAY,2);


	scPutInInventory(CATPULT);
	scPutInInventory(BEARING);
	

	
	scSetPosition(BLAKE,20,16,18);
	scLookDirection(BLAKE,FACING_UP);
	scChangeRoomAndStop(20);
	
#endif	

	
}


