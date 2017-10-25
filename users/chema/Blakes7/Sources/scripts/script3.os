
/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/****************************/

#include "globals.h"

#define ST_INTRO	100


/* Script with the intro to episode 2 		*/
/* I made this script global because else it'd  */
/* get nuked when changing rooms, so this was   */
/* easier...					*/
script 3
{	
	byte i;
	
	// Disable Fade Effects
	scSetFadeEffect(0);
	scClearRoomArea();
	
	scLoadRoom(ROOM_EPISODE2);
	// Set the destination for ESC press
	scSetOverrideJump(here);
	
	scDelay(100);
	
	scClearRoomArea();
	
	// Pic with the exterior of the London ship
	scLoadRoom(200);
	scPlayTune(FEDMARCH_TUNE);
	
	// Prepare everything for camera pan
	scSetCameraAt(120);
	scBreakHere();

	scDelay(50);
	scPanCamera(0);
	scWaitForCamera();
	//scPlaySFX(SFX_MINITUNE1);
	//scWaitForTune();		
	scDelay(80);
	scPrintAt(200,0,8,104);
	scDelay(80);
	scPrintAt(200,1,8,112);
	scDelay(80);
	scPrintAt(200,2,8,120);
	scDelay(80);
	scPrintAt(200,3,8,128);
	scDelay(80);
	scDelay(100);
here:	
	scStopTune();

	// Enable default Fade Effects
	scSetFadeEffect(1+128);
		
	// Load the first room of episode: the cell in the London
	scLoadRoom(ROOM_LONDONCELL);
	
	// Load main characters
	scLoadObjectToGame(JENNA);
	scLoadObjectToGame(VILA);
	//scLoadObjectToGame(AVON);
	scLoadObjectToGame(GAN);	
	
	// Blake is here
	scSetPosition(BLAKE, sfGetCurrentRoom(), 13, 20);
	scLookDirection(BLAKE, FACING_DOWN);
	
	// Vila is entering, forced by a guard
	scSetPosition(GUARD, ROOM_LONDONCELL, 14, 0);
	scSetPosition(VILA, ROOM_LONDONCELL, 14, 1);	
	scLookDirection(GUARD, FACING_RIGHT);
	scLookDirection(VILA, FACING_LEFT);
	/* Door is open */
	scSetAnimstate(200,2);	
	scDelay(10);
	scSetAnimstate(GUARD,12);
	
	
	/* Vila enters the room */
	scSetPosition(VILA,ROOM_LONDONCELL, 14, 2);
	scSetAnimstate(VILA,1);
	scPlaySFX(SFX_STEPA);
	scBreakHere();
	scSetAnimstate(VILA,2);
	scPlaySFX(SFX_STEPA);
	scBreakHere();
	scSetPosition(VILA,ROOM_LONDONCELL, 14, 3);
	scSetAnimstate(VILA,3);
	scPlaySFX(SFX_STEPA);
	scBreakHere();
	scSetAnimstate(VILA,2);
	scPlaySFX(SFX_STEPA);
	scBreakHere();
	scSetPosition(VILA,ROOM_LONDONCELL, 14, 4);	
	scSetAnimstate(VILA,1);
	scPlaySFX(SFX_STEPA);
	scBreakHere();

	scSetAnimstate(VILA,2);
	scPlaySFX(SFX_STEPA);
	scBreakHere();
	scSetPosition(VILA,ROOM_LONDONCELL, 14, 5);
	scSetAnimstate(VILA,3);
	scPlaySFX(SFX_STEPA);
	scBreakHere();
	scSetAnimstate(VILA,2);
	scPlaySFX(SFX_STEPA);
	scBreakHere();
	scSetPosition(VILA,ROOM_LONDONCELL, 14, 6);	
	scSetAnimstate(VILA,1);
	scPlaySFX(SFX_STEPA);
	scBreakHere();
		
	scActorTalk(VILA,ST_INTRO,0);
	scWaitForActor(VILA);
	scActorTalk(VILA,ST_INTRO,1);
	scWaitForActor(VILA);
	scActorTalk(VILA,ST_INTRO,2);
	scWaitForActor(VILA);

	scLookDirection(GUARD, FACING_LEFT);
	scBreakHere();	
	scDelay(10);
	scSetPosition(GUARD, 255, 14, 0);
	scDelay(30);
	
	// The door closes
	scPlaySFX(SFX_DOOR);
	scDelay(10);
	scSetAnimstate(200,1);
	scDelay(10);
	scSetAnimstate(200,0);
	scDelay(10);

	// Walks towards Blake
	scActorWalkTo(VILA,sfGetCol(BLAKE)-6, sfGetRow(BLAKE));
	scWaitForActor(VILA);
	scLookDirection(VILA,FACING_RIGHT);
	scLookDirection(BLAKE,FACING_LEFT);
	scBreakHere();
	
	for (i=3;i<=6;i=i+2){
		scActorTalk(VILA,ST_INTRO,i);
		scWaitForActor(VILA);
		scActorTalk(BLAKE,ST_INTRO,i+1);
		scWaitForActor(BLAKE);
	}
	
	for(i=7;i<=12;i=i+1){
		scActorTalk(VILA,ST_INTRO,i);
		scWaitForActor(VILA);		
	}
	
	scActorTalk(JENNA,ST_INTRO,13);
	scWaitForActor(JENNA);
	scActorTalk(BLAKE,ST_INTRO,14);
	scWaitForActor(BLAKE);
	scActorTalk(BLAKE,ST_INTRO,15);
	scWaitForActor(BLAKE);
	scActorTalk(JENNA,ST_INTRO,16);
	scWaitForActor(JENNA);
	scActorTalk(BLAKE,ST_INTRO,17);
	scWaitForActor(BLAKE);
	scActorTalk(VILA,ST_INTRO,18);
	scWaitForActor(VILA);
	scActorTalk(VILA,ST_INTRO,19);
	scWaitForActor(VILA);
	scActorTalk(JENNA,ST_INTRO,20);
	scWaitForActor(JENNA);
	scActorTalk(VILA,ST_INTRO,21);
	scWaitForActor(VILA);

	scLookDirection(BLAKE,FACING_DOWN);
	scDelay(20);
	scActorTalk(BLAKE,ST_INTRO,22);
	scWaitForActor(BLAKE);	
	scActorTalk(JENNA,ST_INTRO,23);
	scWaitForActor(JENNA);
	scActorTalk(JENNA,ST_INTRO,24);
	scWaitForActor(JENNA);	
	scActorTalk(VILA,ST_INTRO,25);
	scLookDirection(BLAKE,FACING_LEFT);	
	scWaitForActor(VILA);
	scActorTalk(VILA,ST_INTRO,26);
	scWaitForActor(VILA);
	scActorTalk(VILA,ST_INTRO,27);
	scWaitForActor(VILA);
	scActorTalk(JENNA,ST_INTRO,28);
	scWaitForActor(JENNA);

	// Avon is loaded here to get some space (his costume is not
	// in memory...)
	scLoadObjectToGame(AVON);

	bGanIntroduced=false;
	bAvonIntroduced=false;
	bAskedAvonForLock=false;
	bHijackSaid=false;
	bPlanDeveloped=false;
	bTimeToGetCard=false;
	bCardTaken=false;
	bBandCut=false;
	bSinkUsed=false;
	bCloggingSeen=false;
	bDrainUnclogged=false;
	
	bBallDefeated=false;
	nFailsCatapult=0;
	
	bDroneTaken=false;
	
	bTelIntroduced=false;
	bCygnusOrbit=false;	
	bGunSeen=false;
	bBraceletSeen=false;
	bCrusaderCutscene=false;
	bCorpseClean=false;
	bRopeTied=false;
	bPulleyDone=false;
	bLampSet=false;
	
	bCenteroOrbit=false;
	
	bEnergyCellSeen=false;
	bEnergyCellTaken=false;
	

	// Display verbs
	scShowVerbs(true);
	// Make Vila be nearby
	scSpawnScript(200);
	scSave();
}






	