/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
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

}


script 201{
/*	if(!bCallyFound){
		scRemoveObjectFromGame(CALLY);
	}
*/	
}

objectcode DOOR3
{		
	LookAt: scActorTalk(sfGetActorExecutingAction(), STDESC, 0); scStopScript();
	Open:
		if(!sfIsScriptRunning(RESOURCE_SCRIPT,204)) scSpawnScript(202);
		scStopScript();
}

objectcode DOOR2
{	
	Open:
	LookAt: scActorTalk(sfGetActorExecutingAction(), STDESC, 1); scStopScript();
}

objectcode EXIT
{	
	byte actor;
	WalkTo:
		actor=sfGetEgo();
		scSetPosition(actor, ROOM_CELLCORRIDOR, 13, 57);
		scLookDirection(actor, FACING_DOWN);
		scChangeRoomAndStop(ROOM_CELLCORRIDOR);
}

/* We rescue Cally */
script 202{
	byte i;
	
	scCursorOn(false);
	// Open the door
	tmpParam1=DOOR3;
	scChainScript(250);	
	// Cally talks to us
	scLoadObjectToGame(CALLY);
	scSetPosition(CALLY,ROOM_CELLENTRY,13,1);
	scLookDirection(CALLY,FACING_RIGHT);	
	
	scActorTalk(CALLY,STDESC,2);
	scWaitForActor(CALLY);
	scActorTalk(CALLY,STDESC,3);
	scWaitForActor(CALLY);

	scActorTalk(BLAKE,STDESC,4);
	scWaitForActor(BLAKE);

	scActorTalk(CALLY,STDESC,5);
	scWaitForActor(CALLY);

	scActorTalk(BLAKE,STDESC,6);
	scWaitForActor(BLAKE);
	scActorTalk(BLAKE,STDESC,7);
	scWaitForActor(BLAKE);
	scActorTalk(BLAKE,STDESC,8);
	scWaitForActor(BLAKE);
	
	scActorTalk(CALLY,STDESC,9);
	scWaitForActor(CALLY);
	scActorTalk(CALLY,STDESC,10);
	scWaitForActor(CALLY);

	scActorTalk(BLAKE,STDESC,36);
	scWaitForActor(BLAKE);	
	scActorTalk(CALLY,STDESC,37);
	scWaitForActor(CALLY);
	scActorTalk(BLAKE,STDESC,38);
	scWaitForActor(BLAKE);	
	
	

	// Cally walks to cell 2
	scLookDirection(BLAKE,FACING_RIGHT);
	scActorWalkTo(CALLY,16,13);
	scWaitForActor(CALLY);	
	scActorWalkTo(CALLY,16,11);
	scWaitForActor(CALLY);
	scLookDirection(CALLY,FACING_LEFT);
	
	// Open the door
	tmpParam1=DOOR2;
	scChainScript(250);
	
	// Ravella appears
	scLoadObjectToGame(RAVELLA);
	scSetPosition(RAVELLA,ROOM_CELLENTRY,12,12);
	scLookDirection(RAVELLA,FACING_LEFT);
	
	//Conversation..
	scActorTalk(BLAKE,STDESC,11);
	scWaitForActor(BLAKE);
	scActorTalk(RAVELLA,STDESC,12);
	scWaitForActor(RAVELLA);	
	scActorTalk(BLAKE,STDESC,13);
	scWaitForActor(BLAKE);
	scLookDirection(RAVELLA,FACING_RIGHT);
	scDelay(20);
	scActorTalk(RAVELLA,STDESC,14);
	scWaitForActor(RAVELLA);
	scActorTalk(BLAKE,STDESC,15);
	scWaitForActor(BLAKE);
	scActorTalk(RAVELLA,STDESC,16);
	scWaitForActor(RAVELLA);
	scLookDirection(RAVELLA,FACING_LEFT);
	scDelay(20);
	
	scActorTalk(CALLY,STDESC,17);
	scWaitForActor(CALLY);
	scActorTalk(CALLY,STDESC,18);
	scWaitForActor(CALLY);
	scActorTalk(CALLY,STDESC,19);
	scWaitForActor(CALLY);

	scActorTalk(RAVELLA,STDESC,20);
	scWaitForActor(RAVELLA);
	
	scActorTalk(CALLY,STDESC,21);
	scWaitForActor(CALLY);

	scCursorOn(true);	
	scSpawnScript(204);
}

// End sequence... Ravella's been discovered, and Travis enters...
script 203{
	byte i;
	byte a;
	
	scSetCostume(BLAKE,0,0);
	scLookDirection(BLAKE,FACING_RIGHT);
	scDelay(20);

	scActorTalk(CALLY,STDESC,24);
	scWaitForActor(CALLY);
	scActorTalk(BLAKE,STDESC,25);
	scWaitForActor(BLAKE);
	
	// Travis
	scLoadObjectToGame(TRAVIS);
	scSetPosition(TRAVIS,ROOM_CELLENTRY,15,39);
	scLookDirection(TRAVIS,FACING_LEFT);
	scLoadObjectToGame(GUARD);
	scSetPosition(GUARD,ROOM_CELLENTRY,16,40);
	scLookDirection(GUARD,FACING_LEFT);
	scLoadObjectToGame(GUARD2);
	scSetPosition(GUARD2,ROOM_CELLENTRY,14,40);
	scLookDirection(GUARD2,FACING_LEFT);
	
	//scActorTalk(TRAVIS,STDESC,26);
	//scWaitForActor(TRAVIS);
	scPlaySFX(SFX_THRILL1);
	scWaitForTune();
	
	scLookDirection(CALLY,FACING_RIGHT);
	
	scActorWalkTo(TRAVIS,25,15);
	scActorWalkTo(GUARD,29,16);
	scActorWalkTo(GUARD2,32,14);
	scWaitForActor(TRAVIS);
	scWaitForActor(GUARD);
	scWaitForActor(GUARD2);	
	scSetAnimstate(GUARD,12);
	scSetAnimstate(GUARD2,12);

	for(i=26;i<=35;i=i+1){
		if(i==32) a=BLAKE;
		else a=TRAVIS;
		scActorTalk(a,STDESC,i);
		scWaitForActor(a);
	}
	
	scPlaySFX(SFX_MINITUNE1);
	scWaitForTune();
	scFadeToBlack();
	scClearRoomArea();
	scBreakHere();
	scSave();	
	
	// Switch to Avon
	scSpawnScript(20);
}

// Open a door
script 250
{
	byte door;
	byte i;
	door=tmpParam1;
	
	// Check the door is not already being
	// opened or closed.
	if(sfGetAnimstate(door)!=0) scStopScript();

	scPlaySFX(SFX_DOOR);
	
	for(i=1;i<=3;i=i+1){
		scSetAnimstate(door,i);
		scDelay(5);		
	}
}


// Avoid any action but shooting Cally or Ravella
script 204{
	byte i;

	if(sfIsNotMoving(BLAKE)){
		scDelay(10);
		scRestartScript();
	}
	
	scCursorOn(false);
	if(sfGetTalking()==BLAKE) 
		scWaitForActor(BLAKE);
	
	scStopCharacterAction(BLAKE);
	
	if( (sfGetActionVerb()==VERB_USE) && (sfGetActionObject1()==GUN) && (sfGetActionObject2()==CALLY) ){	
		scLookDirection(BLAKE,FACING_RIGHT);		
		scSetCostume(BLAKE,210,0);
		scSetAnimstate(BLAKE,0);
		scDelay(20);
		scActorWalkTo(CALLY,13,12);
		scWaitForActor(CALLY);
		scLookDirection(CALLY,FACING_LEFT);
		scSetAnimstate(CALLY,12);
		scDelay(20);
		scActorTalk(RAVELLA,STDESC,22);
		scWaitForActor(RAVELLA);
		for(i=1;i<=4;i=i+1){
			scSetAnimstate(RAVELLA,i);
			scDelay(5);
		}
		scActorWalkTo(CALLY,17,12);
		scWaitForActor(CALLY);
		scLookDirection(CALLY,FACING_LEFT);
			
		scSpawnScript(203);
		scStopScript();
	}
		
		
	if( (sfGetActionVerb()==VERB_USE) && (sfGetActionObject1()==GUN) && (sfGetActionObject2()==RAVELLA ) ){		
		scLookDirection(BLAKE,FACING_RIGHT);
		scSetCostume(BLAKE,210,0);
		scSetAnimstate(BLAKE,0);
		scDelay(20);

		scActorTalk(RAVELLA,STDESC,23);
		scWaitForActor(RAVELLA);
	
		scPlaySFX(SFX_SHOOT);
		scWaitForTune();
		scPlaySFX(SFX_EXPLOSION);
		for(i=5;i<=9;i=i+1){
			scSetAnimstate(RAVELLA,i);
			scDelay(5);
		}
		scSetAnimstate(RAVELLA,4);
		scWaitForTune();
		scSpawnScript(203);
		scStopScript();
	}
		
	scActorTalk(RAVELLA,STDESC,20);
	scWaitForActor(RAVELLA);
	
	scActorTalk(CALLY,STDESC,21);
	scWaitForActor(CALLY);
	
	scActorWalkTo(BLAKE,7,12);
	scLookDirection(BLAKE,FACING_RIGHT);
	
	scCursorOn(true);
	scDelay(10);
	scRestartScript();
}


stringpack STDESC{
#ifdef ENGLISH
	/***************************************/
	"That is the cell the voice speak about.";
	"That is not the correct cell number.";
	
	// 2
	"My name is Cally. And I am from Auron.";
	"My people are the Auronar.";
	"And so you're telepathic...";
	"And quick. I am a warrior.";
	"My name is Roj Blake.";
	"I came to rescue a member of the";
	"resistance. Her name is Ravella.";
	"They brought someone a few days ago.";
	"It could be her. Come, let's find out.";
	
	//11
	"Ravella...";
	"Blake! You came for me?";
	"Of course. I owe it to you.";
	"Who is she?";
	"She is Cally. She helped me.";
	"I don't trust her...";
	// 17
	"Blake, something's wrong...";
	"I can't contact her... she is not...";
	"She is not a living creature!";
	//20
	"Blake, kill her! She is a spy!";
	"I'm not! She is!";
	"Hey!";
	//23
	"Blake! What are you doing?";	
	"See? She's a Robot!";
	"Now, what's this all about?";
	
	
	//26
	"Be my guest Blake...";
	"That Auronar almost ruined my plan.";
	"But anyway I got you.";
	"It's just that my... little toy did";
	"not end in your ship to capture it";
	"so you'll surrender it, instead.";
	
	"I won't, Travis.";

	"Oh, yes. You will. I have all your";
	"gang arrested. I'll make them suffer";
	"as they've never ever imagined.";
	
	//36
	"Here. Put on one of these bracelets.";
	"What's this for?";
	"You'll see in time...";	
	
		
#endif
#ifdef SPANISH
	/***************************************/
	"La celda que decía la voz.";
	"Esa no es la celda correcta.";
	
	// 2
	"Me llamo Cally y soy del planeta Auron";
	"Mi gente son los Auronar.";
	"Así que eres telépata...";
	"Y rápida. Soy una guerrera.";
	"Me llamo Roj Blake.";
	"Vengo a rescatar a un miembro de la";
	"resistencia. Su nombre es Ravella.";
	"Trajeron a alguien hace unos días.";
	"Podría ser ella. Averiguémoslo.";
	
	//11
	"Ravella...";
	"¡Blake! ¿Viniste a por mí?";
	"Por supuesto. Te lo debía.";
	"¿Quién es ella?";
	"Cally. Me ha ayudado.";
	"No me fío de ella...";
	// 17
	"Blake, algo va mal...";
	/***************************************/	
	"No puedo contactar con ella... como...";
	"¡si no fuese un ser vivo!";
	//20
	"¡Blake, elimínala! ¡es una espía!";
	"¡No lo soy! ¡ella lo es!";
	"¡Eh!";	
	//23
	"¡Blake! ¿Qué haces?";
	"¿Ves? ¡Es un robot!";		
	"¿De qué va todo esto?";
	
	//26
	"Sé mi invitado, Blake...";
	"Esa Auronar casi arruina mi plan.";
	"Pero de todos modos te tengo.";
	"Solo que mi pequeño... juguete no";
	"acabón en tu nave para capturarla";
	"así que la rendirás.";
	
	"No lo haré, Travis.";

	"Oh, sí. Lo harás. Tengo a toda tu";
	"banda capturada. Les haré sufrir como";
	"nunca han imaginado.";

	"Toma. Ponte uno de estos brazaletes.";
	"¿Para qué sirven?";
	"Lo verás en su momento...";	
	
#endif
}

objectcode RAVELLA{

}

