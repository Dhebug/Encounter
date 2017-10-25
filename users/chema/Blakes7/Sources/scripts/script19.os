
/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/****************************/

#include "globals.h"

#define STLOCAL 	2	// We'll re-use id

/* Villa called to help.	*/
script 19{
	scShowVerbs(false);
	scLockResource(RESOURCE_STRING,STLOCAL);
	
	// Conversation with Jenna
	scActorTalk(BLAKE,STLOCAL,17);
	scWaitForActor(BLAKE);	
	scActorTalk(BLAKE,STLOCAL,18);
	scWaitForActor(BLAKE);	
	scActorTalk(JENNA,STLOCAL,19);
	scWaitForActor(JENNA);	
	scActorTalk(BLAKE,STLOCAL,20);
	scWaitForActor(BLAKE);	
	scActorTalk(BLAKE,STLOCAL,21);
	scWaitForActor(BLAKE);	
	
	scSetPosition(AVON,ROOM_LIBDECK,11,33);
	scLookDirection(AVON,FACING_RIGHT);
	scLoadRoom(ROOM_LIBDECK);
	scSetCameraAt(50);
	scBreakHere();
	
	scActorTalk(GAN,STLOCAL,0);
	scWaitForActor(GAN);
	scActorTalk(GAN,STLOCAL,1);
	scWaitForActor(GAN);
	
	scActorTalk(VILA,STLOCAL,2);
	scWaitForActor(VILA);
	scActorTalk(VILA,STLOCAL,3);
	scWaitForActor(VILA);
	scActorTalk(VILA,STLOCAL,4);
	scWaitForActor(VILA);
	
	scActorTalk(AVON,STLOCAL,5);
	scWaitForActor(AVON);

	scActorTalk(VILA,STLOCAL,6);
	scWaitForActor(VILA);
	scActorTalk(AVON,STLOCAL,7);
	scWaitForActor(AVON);
	scActorTalk(VILA,STLOCAL,8);
	scWaitForActor(VILA);
	scActorTalk(AVON,STLOCAL,9);
	scWaitForActor(AVON);
	scActorTalk(AVON,STLOCAL,10);
	scWaitForActor(AVON);
	
	scActorWalkTo(GAN,17,15);
	scDelay(50);
	scLookDirection(AVON,FACING_LEFT);	
	scActorTalk(AVON,STLOCAL,11);
	scWaitForActor(AVON);
	scWaitForActor(GAN);	
	scLookDirection(GAN,FACING_RIGHT);
	scActorTalk(GAN,STLOCAL,12);
	scWaitForActor(GAN);
	scActorTalk(GAN,STLOCAL,13);
	scWaitForActor(GAN);
	scActorTalk(AVON,STLOCAL,14);
	scWaitForActor(AVON);
	scActorTalk(AVON,STLOCAL,15);
	scWaitForActor(AVON);
	
	scActorTalk(GAN,STLOCAL,16);
	scWaitForActor(GAN);	
	scDelay(50);

	// They teleport to the service room
	scLoadRoom(ROOM_SERVICE);
	scBreakHere();

	scClearEvents(1);
	scPlaySFX(SFX_TELEPORT);
	
	scClearEvents(2);
	tmpParam1=GAN;	
	tmpParam2=14;
	tmpParam3=3;
	scSpawnScript(7);
	scWaitEvent(2);
	tmpParam1=VILA;
	tmpParam2=16;
	tmpParam3=8;
	scChainScript(7);	

	scDelay(20);
	scLookDirection(BLAKE, FACING_LEFT);
	scActorTalk(BLAKE,STLOCAL,22);
	scWaitForActor(BLAKE);	
	scLookDirection(JENNA, FACING_LEFT);
	scActorTalk(JENNA,STLOCAL,23);
	scWaitForActor(JENNA);	
	
	scActorTalk(VILA,STLOCAL,24);
	scWaitForActor(VILA);	
	scActorWalkTo(VILA,8,13);
	//scLookDirection(JENNA, FACING_RIGHT);
	//scLookDirection(BLAKE, FACING_RIGHT);	
	scWaitForActor(VILA);
	scLookDirection(VILA, FACING_RIGHT);
	scDelay(30);
	scActorTalk(VILA,STLOCAL,25);
	scWaitForActor(VILA);	
	scActorTalk(VILA,STLOCAL,26);
	scWaitForActor(VILA);	
	scDelay(60);
	scLoadObjectToGame(TRASPONDER); // Put transponder...
	scSetPosition(TRASPONDER,ROOM_SERVICE,10,12);
	scSetAnimstate(TRASPONDER,0);
	scActorTalk(VILA,STLOCAL,27);
	scWaitForActor(VILA);	
	scActorWalkTo(VILA,4,13);
	scWaitForActor(VILA);
	scLookDirection(VILA, FACING_RIGHT);
	
	scActorTalk(BLAKE,STLOCAL,28);
	scLookDirection(JENNA,FACING_DOWN);
	scWaitForActor(BLAKE);	
	scActorTalk(JENNA,STLOCAL,29);
	scWaitForActor(JENNA);		
	scLookDirection(BLAKE, FACING_LEFT);	
	scActorTalk(BLAKE,STLOCAL,30);
	scWaitForActor(BLAKE);	

	bClockTampered=true;
	scUnlockResource(RESOURCE_STRING,STLOCAL);
	scShowVerbs(true);
	scSave();
}


stringpack STLOCAL{
#ifdef ENGLISH
/***************************************/
// Gan answers
"Understood, Blake.";
"Vila and I will teleport down.";
// Vila rants
"Me? No, wait a minute, it's cold out";
"there and I'm very susceptible to low";
"temperatures. I've got a weak chest!";
// Avon jokes
"The rest of you's not very impressive.";
// They argue 6-10
"Why don't you go?";
"You are expendable.";
"And you're not?";
"No, I am not. I am not expendable,";
"I'm not stupid, and I'm not going.";

// Is it a trap? 11-15
"I'm starting to smell a trap here.";
"It's not a very good one, then.";
"We're suspicious of it already.";
"The test is not whether you are";
"suspicious but whether you are caught.";

// Let's go
"Come on, Vila. Let's go.";

// 17-21 first part with Jenna (I've put this here afterwards)
/***************************************/
"Jenna, we need to hack the clock.";
"Could it be done from here?";
"Sure, but not by me. Vila or Avon can.";

"Okay. Liberator, do you hear me?";
"I need Avon or Vila to come down here.";

// 22
"I need to move the clock forward one";
"hour. Can you do it?";
"Let me check...";
"Yeah. But I need an emitter with...";
"One sec. Gimme the transponder.";
"See? Done!";

"Good. Now wait here for my signal.";
"Take care.";
"Will do.";
#endif
#ifdef SPANISH
/***************************************/
// Gan answers
"Entendido, Blake.";
"Vila y yo iremos.";
// Vila rants
"¿Yo? No, un minuto, hace frío ahí";
"y soy muy susceptible a las bajas";
"temperaturas. ¡Tengo el pecho débil!";
// Avon jokes
"Tampoco el resto es muy impresionante.";
// They argue 6-10
"¿Por qué no vas tú?";
"Tú eres prescindible.";
"¿Y tú no?";
"No. No soy prescindible, no soy";
"estúpido, y no voy a ir.";

// Is it a trap? 11-15
"Empiezo a pensar que hay trampa.";
"No una demasiado buena, entonces.";
"Ya estamos sospechando...";
"La cosa no está en si sospechas,";
"sino en si te cogen.";

// Let's go
"Venga Vila. Vamos.";

// 17-21 first part with Jenna (I've put this here afterwards)
/***************************************/
"Jenna, necesito alterar la hora.";
"¿Se podría hacer desde aquí?";
"Fijo, pero no yo. Vila o Avon podrían.";

"Vale. Libertador, ¿me oís?";
"Necesito a Avon o Vila aquí abajo.";

// 22
"Necesito adelantar el reloj una hora.";
"¿Podrías?";
"Déjame ver...";
"Pues sí, pero necesito un emisor con...";
"Un segundo. Pásame el transpondedor.";
"Ahí está. ¡Hecho!";

"Bien. Esperad a mi señal.";
"Cuídate.";
"Lo haré.";


#endif
}

	