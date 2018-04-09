/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR:laurentd75	*/
/****************************/

#include "globals.h"

// Scripts for the cells in Cygnus Alpha
#define STCELLS 200

stringpack STCELLS{
#ifdef ENGLISH
	/***************************************/
	"Vila! Gan!";
	
	"Hello brother. I wondered if you...";
	"It's me! Blake!";
	
	//3
	"Blake! What are you doing here?";
	"I came for you. I've got a spaceship!";
	"And how will we escape this building?";
	
	//6
	"With these bracelets. Put them on.";
	
	"Strange... I thought I had three...";
	"I must have lost one...";
	
	"Okay, what now?";
#endif

#ifdef FRENCH
	/***************************************/
	"Vila! Gan!";
	"Bonjour Frere, je me demandais si..."; // [laurentd75]: prisoner talking to a monk here.
	"C'est moi! Blake!";
	
	//3
	"Blake! Que fais-tu ici?";
	"Je suis la pour vous, j'ai un vaisseau!";
	"Et comment allons-nous nous échapper?";
	
	//6
	"Avec ces bracelets. Mettez-les.";
	"Bizarre, je croyais en avoir trois...";
	"Je dois en avoir égaré un...";
	
	"C'est bon, et maintenant?";
#endif

#ifdef SPANISH
	/***************************************/
	"¡Vila! ¡Gan!";
	
	"Hola hermano, me pregunto si tú...";
	"¡Soy yo! ¡Blake!";
	
	//3
	"¡Blake! ¿Qué haces aquí?";
	"Vengo a por vosotros. ¡Tengo una nave!";
	"¿Y cómo vamos a escapar de aquí?";
	
	//6
	"Con estas pulseras. Ponéoslas.";

	"Qué raro. Pensaba que traía tres...";	
	"Habré perdido una en algún sitio.";
	
	"Listo, ¿y ahora?";	
#endif
}


// Entry script
script 200{
	// These are not needed, as they have been loaded,
	// but make no harm...
	scCursorOn(false);
	scLoadObjectToGame(VILA);
	scLoadObjectToGame(GAN);
	
	scSetPosition(VILA,ROOM_CACELLS,14,4);
	scLookDirection(VILA,FACING_DOWN);
	scSetPosition(GAN,ROOM_CACELLS,15,8);
	scLookDirection(GAN,FACING_LEFT);
	
	scActorTalk(BLAKE,STCELLS,0);
	scWaitForActor(BLAKE);
	scLookDirection(VILA,FACING_RIGHT);
	scLookDirection(GAN,FACING_RIGHT);
	scActorWalkTo(BLAKE,27,14);
	scWaitForActor(BLAKE);
	scLookDirection(BLAKE,FACING_LEFT);
	
	scActorTalk(VILA,STCELLS,1);
	scWaitForActor(VILA);
	
	scActorTalk(BLAKE,STCELLS,2);
	scWaitForActor(BLAKE);
	scSetCostume(BLAKE,0,0);

	scActorWalkTo(VILA,18,14);
	

	scActorTalk(GAN,STCELLS,3);
	scWaitForActor(GAN);	
	
	scActorTalk(BLAKE,STCELLS,4);
	scWaitForActor(BLAKE);
	
	scWaitForActor(VILA);
	scLookDirection(VILA,FACING_RIGHT);
	
	scActorTalk(VILA,STCELLS,5);
	scWaitForActor(VILA);

	scActorWalkTo(BLAKE,22,14);
	scWaitForActor(BLAKE);
	
	scActorTalk(BLAKE,STCELLS,6);
	scWaitForActor(BLAKE);	

	scRemoveFromInventory(BRACELETS);
	scDelay(50);

	scActorTalk(BLAKE,STCELLS,7);
	scWaitForActor(BLAKE);	
	scActorTalk(BLAKE,STCELLS,8);
	
	scActorWalkTo(VILA,11,14);
	scWaitForActor(VILA);
	scWaitForActor(BLAKE);	
	scLookDirection(VILA, FACING_RIGHT);
		
	scActorTalk(GAN,STCELLS,9);
	scWaitForActor(GAN);
	scCursorOn(true);
	
}

