/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR:laurentd75	*/
/****************************/

#include "globals.h"

#define ST_CYGNUS	254

/* Script witht he events where they arrive
at Cygnus Alpha */

// Scripts for the exterior landscape of Cygnus Alpha
#define SHIPSPEED 5

script 8{
	//scShowVerbs(false);
	scLoadObjectToGame(VARGAS);
	scLoadObjectToGame(MONK1);
	scLoadObjectToGame(MONK2);
	scSetPosition(VARGAS, sfGetCurrentRoom(), 16, 27);
	scSetPosition(MONK2, sfGetCurrentRoom(), 16, 21);
	scSetPosition(MONK1, sfGetCurrentRoom(), 16, 12);
	scLookDirection(VARGAS,FACING_LEFT);
	scLookDirection(MONK1,FACING_LEFT);
	scLookDirection(MONK2,FACING_LEFT);	
	
	scActorWalkTo(VARGAS,13,16);
	scActorWalkTo(MONK1,3,16);
	scActorWalkTo(MONK2,8,16);
	
	scWaitForActor(MONK2);
	scWaitForActor(MONK1);
	scWaitForActor(VARGAS);
	
	scLookDirection(MONK1,FACING_RIGHT);

	scBreakHere();
	scActorTalk(MONK1,ST_CYGNUS,0);
	scDelay(80);
	
	scLookDirection(VARGAS,FACING_RIGHT);
	scLookDirection(MONK2,FACING_RIGHT);

	scLoadObjectToGame(200); // Ship
	while(sfGetCol(200)<38){
		//scSetAnimstate(200,0);
		scDelay(SHIPSPEED);
		scSetAnimstate(200,1);
		scDelay(SHIPSPEED);
		scSetAnimstate(200,0);
		scSetPosition(200, sfGetCurrentRoom(), sfGetRow(200)+1, sfGetCol(200)+5);
	}
	scRemoveObjectFromGame(200);
	scWaitForActor(MONK1);
	scActorTalk(MONK1,ST_CYGNUS,1);

	scDelay(50);
	scWaitForActor(MONK1);
	scActorTalk(MONK1,ST_CYGNUS,2);
	scWaitForActor(MONK1);
	scActorTalk(MONK1,ST_CYGNUS,3);
	scWaitForActor(MONK1);
	
	scDelay(20);
	scLookDirection(VARGAS,FACING_LEFT);
	scActorTalk(VARGAS,ST_CYGNUS,4);
	scWaitForActor(VARGAS);
	scDelay(20);
	scActorTalk(VARGAS,ST_CYGNUS,5);
	scWaitForActor(VARGAS);
	scDelay(50);
	scActorWalkTo(VARGAS,10,16);
	scActorWalkTo(MONK1,1,16);
	scActorWalkTo(MONK2,5,16);
	scWaitForActor(MONK2);
	//scShowVerbs(true);
}



stringpack 254{
#ifdef ENGLISH
	/**************************************/
	"There...";
	"There it is.";
	"The Federation ship bringing in";
	"prisoners.";
	"Prisoners?";
	"New souls for The Faith.";
#endif

#ifdef FRENCH
	/**************************************/
	"Ah, le voilà...";
	"Il est là...";
	"Le vaisseau de la Fédération qui amène";
	"de nouveaux prisonniers.";
	"Des prisonniers?";
	"De nouvelles Ames pour la Foi, plutôt.";
#endif

#ifdef SPANISH
	/**************************************/
	"Ahí...";
	"Ahí está.";
	"La nave de la Federación tayendo";
	"nuevos prisioneros.";
	"¿Prisoneros?";
	"Nuevas almas para La Fé.";
#endif
}

