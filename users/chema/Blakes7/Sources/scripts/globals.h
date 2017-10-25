/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/****************************/

#include "..\resource.h"
#include "..\verbs.h"
#include "..\gameids.h"
#include "..\object.h"
#include "..\language.h"


// Global definitions 


// Game flags
// Episode 1: The Way Out
bool bReadMapPoster;		// The player read about maps in the information area
bool bManTalkedBoutCoffee;	// The man at the info desk already talked about missing coffee
bool bMetRavella;		// The player had the dialog with Ravella
bool bMapContactGiven;		// The player got the contact to buy a map
bool bTradeInitiated;		// The player has been told he need to trade something
bool bMugGiven;			// The player gave the mug to the man for trade
bool bWrongMapExit;		// If the number given as exit is wrong
bool bMapPrinted;		// Map has been printed and ready to collect
bool bGotMap;			// The player acquired the map
bool bEscapeFromNurse;		// The player just escaped the Nurse
bool bNurseGaveLaxative;	// The Nurse gave the player the laxative
bool bCouchPushed;		// The couch has been pushed
bool bAutoExit;			// The player exited to the man hallway automatically and cursor must be restored
bool bGuardWentForCoffee;	// The guard went to search for coffee
bool bSandwichGiven;		// The player gave the sandwich to the technician
bool bTechcamOut;		// The technician made the final scene and disappeared
bool bCoinStuck;		// There is a coin stuck in the coffee machine
bool bGuardInCtrlRoom;		// The guard is in the Control Room
bool bSnoringHeard;		// The player heard the guard snoring
bool bDecafReady;		// The player changed the guard's coffee for decaf
bool bCamDeactivated;		// Camera has been deactivated
bool bCamCodeSeen;		// Player saw the camera code.
bool bGratingOpen;		// Player has unscrewed the grating
bool bTryOpenLockers;		// True when the player has tried to open one locker (used in locker room only)
bool bTryKeyLockers;		// True when the player has tried to use the key in one locker (used in locker room only)
bool bEnvelopeExamined;		// True if the player has just examined the envelope (used in locker room only)


// Episode 2

bool bGanIntroduced;		// True if Gan was introduced to us
bool bAvonIntroduced;		// True if Avon was introduced to us
bool bAskedAvonForLock;		// We asked Avon about the cell lock
bool bHijackSaid;		// We have said we want to hijack the ship
bool bPlanDeveloped;		// The escaping plan and team has been set
bool bTimeToGetCard;		// Set to true if it is the correct moment to steal the card from the guards
bool bCardTaken;		// Vila took the card
bool bBandCut;			// The player cut the elastic band
bool bSinkUsed;			// The player used the sink in the Liberator
bool bCloggingSeen;		// The player noticed the sink is clogged
bool bDrainUnclogged;		// The player unclogged the drain
bool bBallDefeated;		// True if the defensive ball at the Liberator has been defeated

bool bTelIntroduced;		// True if how teleporting works has been told
bool bCygnusOrbit;		// True if in Orbit of Cygnus Alpha
bool bGunSeen;			// True if the player saw the gun's pic
bool bBraceletSeen;		// Idem for the bracelet
bool bCorpseClean;		// True if the player cleans the corpse
bool bRopeTied;			// True if the player tied the rope to the tree
bool bCrusaderCutscene;		// True if the 'he is a crusader' cutscene has been shown
bool bPulleyDone;		// True if the player used the gun to fix the pulley
bool bLampSet;			// True if the monk put the lamp on the wall's hook


// Episode 3
bool bEnergyCellSeen;		// The player saw that there are energy cells in the compartment
bool bEnergyCellTaken;		// The player took the energy cell
bool bCenteroOrbit;		// Are we in orbit of Centero (Episode 3, set to false in ep 2)
bool bLogTaken;			// The player took the log from the forest
bool bCellPlaced;		// The player placed the energy cell in the desk
bool bLed1On;			// Leds in entry to base puzzle
bool bLed2On;			// Leds in entry to base puzzle
bool bLed3On;			// Leds in entry to base puzzle
bool bLed4On;			// Leds in entry to base puzzle
bool bDoorPuzzleDone;		// Door puzzle solved
bool bIntroBaseDone;		// The intro when they enter the base has been played.
bool bCouplet1Known;		// Couplets learned by the player
bool bCouplet2Known;		// Couplets learned by the player
bool bCouplet3Known;		// Couplets learned by the player
bool bCouplet4Known;		// Couplets learned by the player
bool bCouplet5Known;		// Couplets learned by the player
bool bCupTaken;			// Did we take the cup from the common room?
bool bGuardLeftCommon;		// Did the guard leave the common room?
bool bLaundryMesgSeen;		// Have we seen the msg in the computer?
bool bUniformTaken;		// We took the uniform from the laundry
bool bShiftTimeFound;		// Has the guard told us about the time to change shifts?
bool bClockTampered;		// Did we change the clock time?
bool bGuardLeftCells;		// Did the guard at the detention cells leave?
bool bCellFound;		// Did we find the cell number? (Cally)
bool bCallyFound;		// Did we rescue Cally?
bool bDroneTaken;		// Did Avon pick up the Drone?
bool bSwitchInstalled;		// Did Avon install the remote switch?
bool bTransmitterInstalled;	// Did Avon install the transmitter linked to the A/C?

// Global variables
byte tmpParam1; // Parameters for scripts & temp variable
byte tmpParam2;
byte tmpParam3;
byte nPushMachine; // Number of pushes to the coffee machine with the coin stuck inside
byte nMsgInfo;	 // Message last shown on the info in the hallway
byte nFailsCatapult; // Number of fails with the catapult
byte nScribbleMsg;	// To handle the scribble messages
byte nWatchWord;	// Handle the watchword puzzle



