/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR en cours	*/
/****************************/

#include "globals.h"

// Scripts for the pit Cygnus Alpha

#define EXIT 		200
#define TREE 		201
#define CLIFF		202
#define STDESC		200

#define TIEDROPE	205

/* Entry script */
script 200{
	if(bRopeTied){
		scLoadObjectToGame(TIEDROPE);
		scSetPosition(TIEDROPE,sfGetCurrentRoom(),16,21);
	}
}

stringpack STDESC{
#ifdef ENGLISH
	/***************************************/
	"Can't see the bottom from here.";
	"But there is a protruding a few meters";
	"below...";
	
	//3
	"This tree looks a bit twisted.";
	
	//4
	"Okay, good idea.";
	"I don't follow you.";

	//6
	"I could climb down...";
#endif

#ifdef FRENCH
	/***************************************/
	"Can't see the bottom from here.";
	"But there is a protruding a few meters";
	"below...";
	
	//3
	"This tree looks a bit twisted.";
	
	//4
	"Okay, good idea.";
	"I don't follow you.";

	//6
	"I could climb down...";
#endif

#ifdef SPANISH
	/***************************************/
	"No se ve el fondo desde aquí.";
	"Pero hay un saliente unos pocos metros";
	"más abajo...";
	
	//3
	"Este árbol está un poco retorcido.";
	
	//4
	"De acuerdo, buena idea.";
	"No te sigo.";

	//6
	"Podría descolgarme y bajar...";
#endif

}

objectcode CLIFF{
	LookAt:
		scCursorOn(false);
		scActorTalk(BLAKE,STDESC,0);
		scWaitForActor(BLAKE);
		scActorTalk(BLAKE,STDESC,1);
		scWaitForActor(BLAKE);
		scActorTalk(BLAKE,STDESC,2);
		scWaitForActor(BLAKE);
		scCursorOn(true);
}

objectcode TREE{
	LookAt:
		scActorTalk(BLAKE,STDESC,3);
		scWaitForActor(BLAKE);
		scStopScript();
	Use:
		if (sfGetActionObject1()==ROPE){
			scCursorOn(false);
			scActorTalk(BLAKE,STDESC,4);
			scWaitForActor(BLAKE);
			bRopeTied=true;
			scRemoveFromInventory(ROPE);
			scChainScript(200);
			scSave();
			scCursorOn(true);
		}
		else{
			scActorTalk(BLAKE,STDESC,5);
			scWaitForActor(BLAKE);
		}
		//scStopScript();
}

objectcode TIEDROPE{
	Use:
		if (sfGetActionObject2()!=255) { scSpawnScript(1); scStopScript();}
	WalkTo:
		scSetPosition(BLAKE,ROOM_CACAVEENTRY,8,18);
		scLookDirection(BLAKE,FACING_DOWN);
		scChangeRoomAndStop(ROOM_CACAVEENTRY);
	LookAt:
		scActorTalk(BLAKE,STDESC,6);
		scWaitForActor(BLAKE);
		scStopScript();
}

objectcode EXIT{
	WalkTo:
		scSetPosition(BLAKE,ROOM_CAEXTERIOR,16,55);
		scLookDirection(BLAKE,FACING_LEFT);
		scChangeRoomAndStop(ROOM_CAEXTERIOR);	
}

