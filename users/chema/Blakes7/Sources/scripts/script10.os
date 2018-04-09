/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR:laurentd75	*/
/****************************/

#include "globals.h"

/* The stringpack is contained here. As there is a scLoadRoom call it cannot be local
 or it would be discarded. It can be given any global id, as long as there is no other 
 stringpack resource with the same one. And still it should be locked before calling
 scLoadRoom and unlocked afterwards */


#define STLOCAL	100
#define HALLMAIN 200


// Script that handles Vargas finding out we are there...
script 10{
	byte i;

	scShowVerbs(false);
	scLockResource(RESOURCE_STRING,STLOCAL);
	
	// Load hall room. 
	
	scLoadRoom(ROOM_CAHALL);
	scLoadObjectToGame(VARGAS);
	scSetPosition(VARGAS,ROOM_CAHALL,14,14);
	scLookDirection(VARGAS,FACING_LEFT);

	scLoadObjectToGame(MONK1);
	scSetPosition(MONK1,ROOM_CAHALL,14,40);
	scActorWalkTo(MONK1,20,14);
	scWaitForActor(MONK1);
	
	for(i=0;i<9;i=i+3){
		scActorTalk(VARGAS,HALLMAIN,i);
		scWaitForActor(VARGAS);
		scActorTalk(VARGAS,HALLMAIN,i+1);
		scWaitForActor(VARGAS);
		scDelay(20);
		scActorTalk(MONK1,HALLMAIN,i+2);
		scWaitForActor(MONK1);
	}
	
	scDelay(50);
	for(i=9;i<13;i=i+1){
		scActorTalk(MONK1,HALLMAIN,i);		
		scWaitForActor(MONK1);
	}
	scActorTalk(VARGAS,HALLMAIN,13);
	scWaitForActor(VARGAS);
	scActorTalk(VARGAS,HALLMAIN,14);
	scWaitForActor(VARGAS);
	
	scPanCamera(73);
	scLoadObjectToGame(MONK2);
	scSetPosition(MONK2,ROOM_CAHALL,15,72);
	scFollowActor(MONK2);
	scActorWalkTo(MONK2,25,15);
	scWaitForActor(MONK2);

	scPanCamera(0);
	
	scLookDirection(VARGAS,FACING_RIGHT);
	scLookDirection(MONK1,FACING_RIGHT);

	scActorTalk(MONK2,HALLMAIN,15);
	scWaitForActor(MONK2);
	scActorTalk(MONK2,HALLMAIN,16);
	scWaitForActor(MONK2);

	scActorTalk(MONK1,HALLMAIN,17);
	scWaitForActor(MONK1);
	scActorTalk(MONK1,HALLMAIN,18);
	scWaitForActor(MONK1);
	
	scActorTalk(VARGAS,HALLMAIN,19);
	scWaitForActor(VARGAS);
	scActorTalk(VARGAS,HALLMAIN,20);
	scWaitForActor(VARGAS);
	scFollowActor(BLAKE);
	
	// Now let's go to the back entry
	scLoadRoom(ROOM_CABACKENTRY);
	scSetPosition(VARGAS,ROOM_CABACKENTRY,11,5);
	scLookDirection(VARGAS,FACING_RIGHT);
	scSetPosition(MONK1,ROOM_CABACKENTRY,10,1);
	scLookDirection(MONK1,FACING_RIGHT);
	scSetPosition(MONK2,ROOM_CABACKENTRY,10,18);
	scLookDirection(MONK2,FACING_LEFT);
	
	scUnlockResource(RESOURCE_STRING,STLOCAL);	


	for(i=0;i<12;i=i+4){
		scActorTalk(MONK2,STLOCAL,i);
		scWaitForActor(MONK2);
		scActorTalk(MONK2,STLOCAL,i+1);
		scWaitForActor(MONK2);
		scActorTalk(VARGAS,STLOCAL,i+2);
		scWaitForActor(VARGAS);
		scActorTalk(VARGAS,STLOCAL,i+3);
		scWaitForActor(VARGAS);
	}
		
	scShowVerbs(true);
	scChangeRoomAndStop(ROOM_CACELLS);
}


 stringpack STLOCAL{
#ifdef ENGLISH
	/***************************************/
	"There. That thing blocking the chain.";
	"What could it be?";

	"Mmmmmm...";
	"Looks like weapon of some sort...";

	"I also found this on the floor.";
	"It is a bracelet.";

	"Some sort of communication device...";
	"Maybe even more...";
	
	//8
	"They came from the cave, that's";
	"why they stole the lamp.";
	
	"They came to rescue the new souls.";
	"Give me that bracelet and lets go!";
#endif

#ifdef FRENCH
	/***************************************/
	"La... Ce truc qui bloque la chaine...";
	"Qu'est-ce que ca peut bien etre?";

	"Hmmmmm...";
	"On dirait une espece d'arme...";

	"J'ai aussi trouvé ca sur le sol.";
	"C'est un bracelet.";

	"Une sorte d'appareil de communication..";
	"Peut-etre meme plus...";
	
	//8
	"Ils sont arrivés par la grotte, c'est";
	"pour ca qu'ils ont volé la lampe.";
	
	"Ils viennent libérer les Nouvelles Ames";
	"Donne-moi ce bracelet, et allons-y!";
#endif

#ifdef SPANISH
	/***************************************/
	"Ahí. Eso que bloquea la cadena.";
	"¿Qué puede ser?";

	"Mmmmmm...";
	"Parece algún tipo de arma...";

	"También encontré esto en el suelo.";
	"Una pulsera.";

	"Un dispositivo de comunicaciones...";
	"Igual incluso algo más...";
	
	//8
	"Vinieron por la cueva, por eso robaron";
	"la lámpara.";
	
	"Vienen a rescatar las Nuevas Almas.";
	"¡Dame la pulsera! ¡vamos, rápido!";

#endif
 }