/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR:laurentd75	*/
/****************************/

#include "globals.h"

#define EXIT		200
#define DOOR3		201
#define DOOR2		202

#define RAVELLA 	250

// String pack for descriptions in this room
#define STDESC  	200

// Entry & exit scripts
script 200{
		scLoadObjectToGame(JENNA);
		scSetCostume(JENNA,251,0);
		scLookDirection(JENNA,FACING_RIGHT);		
		scSetAnimstate(JENNA,2);
		scLoadObjectToGame(GAN);
		scSetCostume(GAN,251,0);
		scLookDirection(GAN,FACING_RIGHT);		
		scSetAnimstate(GAN,3);		
		scLoadObjectToGame(VILA);
		scSetCostume(VILA,251,0);
		scLookDirection(VILA,FACING_RIGHT);		
		scSetAnimstate(VILA,4);	
		scSetCostume(CALLY,251,0);
		scLookDirection(CALLY,FACING_RIGHT);		
		scSetAnimstate(CALLY,1);
		scSetCostume(BLAKE,251,0);
		scLookDirection(BLAKE,FACING_RIGHT);		
		scSetAnimstate(BLAKE,0);		
		
		scSetPosition(CALLY,ROOM_CELLENTRY2,15,0);
		//scLookDirection(CALLY,FACING_RIGHT);
		scSetPosition(BLAKE,ROOM_CELLENTRY2,13,2);
		//scLookDirection(BLAKE,FACING_RIGHT);		
		scSetPosition(JENNA,ROOM_CELLENTRY2,12,6);
		//scLookDirection(JENNA,FACING_RIGHT);
		scSetPosition(GAN,ROOM_CELLENTRY2,11,12);
		//scLookDirection(GAN,FACING_RIGHT);
		scSetPosition(VILA,ROOM_CELLENTRY2,11,17);
		//scLookDirection(VILA,FACING_RIGHT);
		
		scSetPosition(TRAVIS,ROOM_CELLENTRY2,15,25);
		scSetPosition(GUARD,ROOM_CELLENTRY2,16,29);
		scSetPosition(GUARD2,ROOM_CELLENTRY2,14,32);
		
		scBreakHere();
		scActorWalkTo(AVON,30,8);
		scActorTalk(TRAVIS,STDESC,2);		
		scWaitForActor(TRAVIS);
		scSetCostume(TRAVIS,250,0);
		scSetAnimstate(TRAVIS,0);
		scWaitForActor(AVON);
		scLookDirection(AVON,FACING_LEFT);
		scBreakHere();
		scSpawnScript(205);

}


stringpack STDESC{
#ifdef ENGLISH
	//36
	/**************************************/
	"Travis is about to shoot!            ";
	"I have to do something!";
	
	//38
	"I'll start by killing that Auronar!";
	"What!?";
	"Shoot! Kill them all!";
	"Zen, Turn the air conditioning on...";

	//6
	"Blake. I will get you.";
	"No matter how long it takes.";
	"I swear by my honour I will get you.";
		
#endif
#ifdef FRENCH
	//36
	/**************************************/
	"Travis est sur le point de tirer!    ";
	"Je dois faire quelque chose!";
	
	//38
	"Commencons par tuer cette Auronar!"; // "Je vais déja tuer cette Auronar!";
	"Mais!?";
	"Tirez! Tuez-les tous!!";
	"Zen, branche la climatisation...";

	//6
	"Blake! Je t'aurai!";
	"Peu importe le temps que ca prendra,";
	"je jure sur l'honneur que je t'aurai!";
		
#endif
#ifdef SPANISH
	/**************************************/
	"¡Travis está a punto de disparar!    ";
	"¡Tengo que hacer algo!";	
	
	//2
	"¡Empezaré por eliminar a la Auronar!";	
	"¡¿Qué?!";
	"¡Disparad! ¡Matadlos a todos!";
	"Zen, enciende el aire acondicionado.";
	
	//6
	"Blake. Te atraparé.";
	"No importa el tiempo que me lleve.";
	"Juro por mi honor que te atraparé.";
#endif
}

// Avoid any action but shooting Travis (this is run when Avon enters)
script 205{
	if(sfIsNotMoving(AVON)){
		scDelay(10);
		scRestartScript();
	}
	
	scCursorOn(false);
	if(sfGetTalking()==AVON) 
		scWaitForActor(AVON);
	
	scStopCharacterAction(AVON);
	
	if( (sfGetActionVerb()==VERB_USE) && (sfGetActionObject1()==GUN) && (sfGetActionObject2()==TRAVIS) ){	
		scSpawnScript(206);
		scStopScript(); 
	}
		
	scActorTalk(AVON,STDESC,0);
	scWaitForActor(AVON);
	scActorTalk(AVON,STDESC,1);
	scWaitForActor(AVON);
	scActorWalkTo(AVON,30,8);
	scWaitForActor(AVON);
	scLookDirection(AVON,FACING_LEFT);
	
	scCursorOn(true);
	scDelay(10);
	scRestartScript();
}

script 206{
	byte i;
	
	scLookDirection(AVON,FACING_LEFT);
	scSetCostume(AVON,210,0);
	scSetAnimstate(AVON,1);
	scDelay(20);

	scPlaySFX(SFX_SHOOT);
	scWaitForTune();
	scPlaySFX(SFX_EXPLOSION);
	for(i=1;i<=5;i=i+1){
		scSetAnimstate(TRAVIS,i);
		scDelay(10);
	}
	scWaitForTune();
	scDelay(50);
	scSetCostume(AVON,11,0);
	scSetAnimstate(AVON,0);
	scLookDirection(AVON,FACING_LEFT);

	scSetCostume(TRAVIS,7,0);
	scLookDirection(TRAVIS,FACING_LEFT);
	scActorTalk(TRAVIS,STDESC,3);
	scWaitForActor(TRAVIS);
	scActorTalk(TRAVIS,STDESC,4);
	scWaitForActor(TRAVIS);
		
	scActorTalk(AVON,STDESC,5);
	scWaitForActor(AVON);
		
	// Teleport everyone!
	scLoadResource(RESOURCE_COSTUME,14);
	scLockResource(RESOURCE_COSTUME,14);
	scClearEvents(1);
	scPlaySFX(SFX_TELEPORT);
	tmpParam1=VILA;
	scClearEvents(2);
	scSpawnScript(6);
	scWaitEvent(2);	
	tmpParam1=GAN;
	scClearEvents(2);
	scSpawnScript(6);
	scWaitEvent(2);	
	tmpParam1=JENNA;
	scClearEvents(2);
	scSpawnScript(6);
	scWaitEvent(2);	
	tmpParam1=CALLY;
	scClearEvents(2);
	scSpawnScript(6);
	scWaitEvent(2);	
	tmpParam1=BLAKE;
	scClearEvents(2);
	scSpawnScript(6);
	scWaitEvent(2);	
	tmpParam1=AVON;
	scChainScript(6);
	
	scUnlockResource(RESOURCE_COSTUME,14);
	scDelay(100);
	scActorTalk(TRAVIS,STDESC,6);
	scWaitForActor(TRAVIS);
	scDelay(30);
	scActorTalk(TRAVIS,STDESC,7);
	scWaitForActor(TRAVIS);
	scActorTalk(TRAVIS,STDESC,8);
	scWaitForActor(TRAVIS);
		
	scPlaySFX(SFX_SUCCESS);
	scWaitForTune();
	//scSave();
	
	// Call a global script with the final sequences (hooooraaaay!)
	scSpawnScript(21);
}

