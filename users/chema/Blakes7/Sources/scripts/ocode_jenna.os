/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/****************************/

#include "globals.h"

/* Object command script and strings */

stringpack JENNA
{
#ifdef ENGLISH
	/***************************************/
	"An exceptional woman...";
	"I'm busy trying to understand these";
	"alien controls. Gimme some more time.";
	"She is in shock! I must hurry!";
	"We must switch on the systems.";
	"Any idea?";
	"I'm with you.";
	"Blake! I barely recognize you!";
#endif
#ifdef SPANISH
	/***************************************/
	"Una mujer excepcional...";
	"Estoy ocupada intentando comprender";
	"estos controles. Dame algo de tiempo.";
	"¡Está en shock! ¡debo darme prisa!";
	"Debemos encender los sistemas.";
	"¿Alguna idea?";
	"Estoy contigo.";
	"¡Blake! ¡Casi no te reconozco.";
#endif
}

objectcode JENNA
{
	LookAt: 
		if((!bBallDefeated) && (sfGetCurrentRoom()==ROOM_LIBDECK)){
			// Se is shocked
			scActorTalk(BLAKE,JENNA,3);
			scStopScript();
		}	
		// Default message
		scActorTalk(BLAKE,JENNA,0);
		scStopScript();

	TalkTo:
		// If in cygnus orbit she is trying to handle the ship
		if(bCygnusOrbit){
			scCursorOn(false);
			
			// If Blake is dressed up...
			if(sfGetCostumeID(BLAKE)!=0){
				scActorTalk(JENNA,JENNA,7);
				scWaitForActor(JENNA);
				scDelay(30);
			}
			scActorTalk(JENNA,JENNA,1);
			scWaitForActor(JENNA);
			scActorTalk(JENNA,JENNA,2);
			scWaitForActor(JENNA);
			scCursorOn(true);
			scStopScript();
		}
		
		// When in the London cell
		if(sfGetCurrentRoom()==ROOM_LONDONCELL){
			// If it is the stealing of the guard's card moment...
			if(bTimeToGetCard ){
				if(bCardTaken) scStopScript();
				scFreezeScript(211,true);
				scCursorOn(false);
				scActorTalk(BLAKE,221,7);
				scWaitForActor(BLAKE);
				scActorTalk(JENNA,221,8);
				scWaitForActor(JENNA);
				scLookDirection(JENNA,FACING_LEFT);
				scActorTalk(JENNA,221,9);
				scWaitForActor(JENNA);
				scActorTalk(JENNA,221,10);
				scWaitForActor(JENNA);
				scLookDirection(GUARD,FACING_UP);
				scActorTalk(GUARD,221,11);
				scWaitForActor(GUARD);
				scActorWalkTo(VILA,18,14);
				scWaitForActor(VILA);				
				scActorTalk(GUARD,221,12);
				scWaitForActor(GUARD);
				scActorWalkTo(VILA,18,13);
				scWaitForActor(VILA);	
				scLookDirection(VILA,FACING_DOWN);
				scActorTalk(GUARD,221,13);
				scWaitForActor(GUARD);
				scLookDirection(GUARD,FACING_RIGHT);
				scSetAnimstate(GUARD,12);
				bCardTaken=true;
				scLookDirection(JENNA,FACING_RIGHT);
				scFreezeScript(211,false);
				scCursorOn(true);
			}
			// Or just the dialog
			else{
				scLoadDialog(205);
				scStartDialog();
			}
			scStopScript();
		}
		
		// When we are in the hideout in Centero
		if(sfGetCurrentRoom()==ROOM_HIDEOUT){
			scActorTalk(JENNA,JENNA,4);
			scWaitForActor(JENNA);
			scStopScript();
		}
		
		// When we are in the Service Room and she suggests to hack the clock
		if( (sfGetCurrentRoom()==ROOM_SERVICE) && (bShiftTimeFound) && (!bClockTampered) ){
			scSpawnScript(19);
			scStopScript();
		}
		
		// Default responses
		scActorTalk(JENNA,JENNA,sfGetRandInt(5,6));
}
