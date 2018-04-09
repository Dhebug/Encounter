/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR:laurentd75	*/
/****************************/

#include "globals.h"

// Scripts for the exterior landscape of Cygnus Alpha

// META: This define and the entry script are unused.

#define SHIPSPEED 5

#define SIGN 		201
#define CORPSE 		202
#define CLEARING	203
#define BUILDING	204
#define STDESC		200

/* Entry script */
script 200{
	scStopScript();
}

stringpack STDESC{
	/***************************************/
#ifdef ENGLISH
	"It reads:";
	"This is the fate of the non-believers.";
	"Creepy...";
	
	//3
	"This man has been tortured and left";
	"to die here, tied to the post with a";
	"large, thick rope.";
	"Nasty bugs cover everything.";
	
	//7
	"You're kidding. I won't touch the rope";
	"while covered with those nasty bugs.";
	//9
	"It works! The bugs are running away.";
	"I could take the rope for later...";
	"I don't know what you mean.";
	"Not the corpse, I'll take the rope.";
	"There is nothing left of interest.";
#endif

#ifdef FRENCH
	"Il est écrit:";
	"Tel est le destin des non-croyants.";
	"Ca fait peur...";
	
	//3
	"Cet homme a été torturé et on l'a";
	"laissé mourir, attaché a ce poteau";
	"avec cette longue corde épaisse.";
	"Il est couvert d'insectes répugnants.";
	
	//7
	"Pas question de toucher a cette corde";
	"recouverte de ces insectes ignobles.";
	//9
	"Ca marche, les insectes décampent!";
	"La corde pourrait m'etre utile...";
	"Je ne comprends pas.";
	"Le corps non, mais je prends la corde.";
	"Il n'y a plus rien d'intéressant.";
#endif

#ifdef SPANISH
	"Pone:";
	"Este es el destino de los no creyentes.";
	"Horripilante.";
	
	//3
	"A este hombre le han torturado y";
	"dejado morir atado al poste con";
	"una cuerda larga y gruesa.";
	"Bichos repulsivos lo cubren todo";
	
	//7
	/***************************************/
	"Estás de coña. No voy a tocar la";
	"cuerda cubierta de todos esos bichos.";
	//9
	"¡Funciona! ¡Los bichos huyen!";
	"Podría coger la cuerda para luego...";
	"No sé qué quieres decir.";
	"El cadáver no, pero la cuerda la cojo.";
	"No queda nada interesante.";
#endif	
}

objectcode SIGN{
	LookAt:
		scCursorOn(false);
		scActorTalk(BLAKE,STDESC,0);
		scWaitForActor(BLAKE);
		scActorTalk(BLAKE,STDESC,1);
		scWaitForActor(BLAKE);
		scLookDirection(BLAKE,FACING_DOWN);
		scActorTalk(BLAKE,STDESC,2);
		scWaitForActor(BLAKE);
		scCursorOn(true);
		//scStopScript();	
}

objectcode CORPSE{
	Use:
		if(sfGetActionObject1()==CORPSE){
			scActorTalk(BLAKE,STDESC,10);
			scWaitForActor(BLAKE);
			scStopScript();
		}
		if(sfGetActionObject1()==SPRAY){
			scActorTalk(BLAKE,STDESC,9);
			scWaitForActor(BLAKE);
			bCorpseClean=true;
			scRemoveFromInventory(SPRAY);
			scSave();
			scStopScript();			
		}
		scActorTalk(BLAKE,STDESC,11);
		scWaitForActor(BLAKE);
		scStopScript();			
	LookAt:
		scCursorOn(false);
		scActorTalk(BLAKE,STDESC,3);
		scWaitForActor(BLAKE);
		scActorTalk(BLAKE,STDESC,4);
		scWaitForActor(BLAKE);
		scActorTalk(BLAKE,STDESC,5);
		scWaitForActor(BLAKE);
		if(!bCorpseClean){
			scActorTalk(BLAKE,STDESC,6);
			scWaitForActor(BLAKE);
		}
		scCursorOn(true);
		scStopScript();	
	PickUp:
		if(!bCorpseClean){
			scCursorOn(false);
			scActorTalk(BLAKE,STDESC,7);
			scWaitForActor(BLAKE);
			scActorTalk(BLAKE,STDESC,8);
			scWaitForActor(BLAKE);
			scCursorOn(true);
			scStopScript();
		}
		if((bCorpseClean) && (!sfIsObjectInInventory(ROPE)) && (!bRopeTied)){
			scActorTalk(BLAKE,STDESC,12);
			scWaitForActor(BLAKE);
			scPutInInventory(ROPE);
			scSave();
		}
		else{
			scActorTalk(BLAKE,STDESC,13);
			scWaitForActor(BLAKE);
		}
		scStopScript();				
}


objectcode CLEARING{
	WalkTo:
		scSetPosition(BLAKE,ROOM_CAPIT,15,0);
		scLookDirection(BLAKE,FACING_RIGHT);
		scChangeRoomAndStop(ROOM_CAPIT);
		
}

objectcode BUILDING{
	WalkTo:
		scSetPosition(BLAKE,ROOM_CABUILDING,15,68);
		scLookDirection(BLAKE,FACING_LEFT);
		scChangeRoomAndStop(ROOM_CABUILDING);
		
}

