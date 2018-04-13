
/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR:laurentd75	*/
/****************************/

#include "globals.h"

#define STLOCAL 	3	// We'll use the id of sandwich strings, as they are no more needed

#define DOOR1		200

/* Jenna and Blake get to the service room.	*/
script 18{
	scShowVerbs(false);
	
	/* Blake tells about hiding in the service room */
	scSetPosition(BLAKE,ROOM_CORRIDOR,15,96);
	scLookDirection(BLAKE,FACING_LEFT);
	scSetPosition(JENNA,ROOM_CORRIDOR,16,99);
	scLookDirection(JENNA,FACING_LEFT);
	scLockResource(RESOURCE_STRING,STLOCAL);
	scLoadRoom(ROOM_CORRIDOR);	
	scSetCameraAt(99);
	scBreakHere();
	scActorTalk(BLAKE,STLOCAL,0);
	scWaitForActor(BLAKE);
	scActorTalk(BLAKE,STLOCAL,1);
	scWaitForActor(BLAKE);
	
	/* Both walk there */
	scActorWalkTo(BLAKE,85,14);
	scDelay(20);
	scActorWalkTo(JENNA,86,15);
	scWaitForActor(BLAKE);
	// Open the door
	scRunObjectCode(VERB_OPEN, DOOR1, 255);
	scSetPosition(BLAKE,ROOM_SERVICE,16,17);
	scActorWalkTo(JENNA,85,14);
	scWaitForActor(JENNA);
	scSetPosition(JENNA,ROOM_SERVICE,16,9);
	scLoadRoom(ROOM_SERVICE);
	scActorWalkTo(JENNA,14,15);
	scWaitForActor(JENNA);
	scLookDirection(JENNA,FACING_RIGHT);
	scActorTalk(JENNA,STLOCAL,2);
	scWaitForActor(JENNA);
	scActorTalk(JENNA,STLOCAL,3);
	scWaitForActor(JENNA);
	scActorTalk(JENNA,STLOCAL,4);
	scWaitForActor(JENNA);
	scLookDirection(BLAKE,FACING_LEFT);
	scActorTalk(BLAKE,STLOCAL,5);
	scWaitForActor(BLAKE);
	
	scUnlockResource(RESOURCE_STRING,STLOCAL);
	scShowVerbs(true);
	bIntroBaseDone=true;
	scSave();
}

stringpack STLOCAL{
#ifdef ENGLISH	
/***************************************/
"We are inside!";
"Come. Let's hide in there.";	
"Here are the controls of the level.";
"Air conditioning, electrical systems,";
"illumination, time synchronization...";
"Wait here. I'll search for Ravella.";
#endif

#ifdef FRENCH	
/***************************************/
"Nous sommes à l'intérieur!";
"Viens. Cachons-nous ici.";
"Il y a ici les commandes de ce niveau:";
"Climatisation, systèmes électriques,";
"éclairage, synchronisation horaire...";
"Attends ici. Je vais chercher Ravella.";
#endif

#ifdef SPANISH
"¡Estamos dentro!";
"Ven. Escondámonos ahí.";
"Aquí están los controles del nivel.";
"Aire, sistemas eléctricos,";
"iluminación, sincronización horaria...";
"Espera aquí. Voy a buscar a Ravella.";
#endif
}