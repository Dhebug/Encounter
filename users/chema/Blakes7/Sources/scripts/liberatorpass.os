/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR:laurentd75	*/
/****************************/

#include "globals.h"


/* Scripts for the Liberator passageway */

objectcode 200{
	WalkTo:
		scSetPosition(sfGetActorExecutingAction(),ROOM_LIBWORKSHOP,15,34);
		scLookDirection(sfGetActorExecutingAction(),FACING_LEFT);
		scChangeRoomAndStop(ROOM_LIBWORKSHOP);
}

objectcode 201{
	WalkTo:
		scSetPosition(sfGetActorExecutingAction(),ROOM_LIBCARGO,15,1);
		scChangeRoomAndStop(ROOM_LIBCARGO);
}

objectcode 202{
	WalkTo:
		scSetPosition(sfGetActorExecutingAction(),ROOM_LIBDECK,14,2);
		scLookDirection(sfGetActorExecutingAction(),FACING_RIGHT);
		scChangeRoomAndStop(ROOM_LIBDECK);
}



stringpack 200{
#ifdef ENGLISH
	/***************************************/
	"Strange interior... Impressive.";
	"Could we refuse to do this?";
	"The alternative is summary execution.";
	"I've had worse offers...";
	"Execution may have some appeal.";
	"Okay, let's go";
#endif

#ifdef FRENCH
	/***************************************/
	"Quel étrange intérieur. Impressionnant.";
	"Pouvons-nous refuser de faire ça?";
	"L'alternative est l'exécution sommaire.";
	"J'ai déjà eu des offres bien pires...";
	"L'exécution pourrait être séduisante.";
	"Bon, assez parlé, allons-y!";
#endif

#ifdef SPANISH
	/***************************************/
	"Extraño interior... Impresionante.";
	"¿Podemos negarnos a hacer esto?";
	"La alternativa es la ejecución.";
	"He tenido peores ofertas...";
	"La ejecución puede ser atractiva.";
	"De acuerdo, vamos allá.";
#endif
}


/* Test for teleport animation */
#ifdef TESTTELEPORT
script 200{
	scLoadObjectToGame(VILA);
	scSetPosition(VILA,0,10,10);	
	
	scBreakHere();
	scCursorOn(false);

	/* Teleport Blake out */
	
	scClearEvents(1);
	scPlaySFX(SFX_TELEPORT);
	tmpParam1=BLAKE;
	scChainScript(6);

	scDelay(200);
	
	/* Teleport Blake and Vila in */

	scClearEvents(1);
	scPlaySFX(SFX_TELEPORT);
	
	tmpParam1=VILA;
	tmpParam2=15;
	tmpParam3=5;
	
	/* Need to use the events to make sure the params are collected */
	scClearEvents(2);
	scSpawnScript(7);
	scWaitEvent(2);	
	
	tmpParam1=BLAKE;
	tmpParam2=16;
	tmpParam3=18;
	scChainScript(7);

	scCursorOn(true);
}

#endif

