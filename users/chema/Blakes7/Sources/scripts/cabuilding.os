/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR en cours	*/
/****************************/

#include "globals.h"

// Scripts for the exterior of the sect building of Cygnus Alpha


#define DOOR 		201
#define PATH		200
#define ROBE		202

#define STDESC		200

#define MONK	MONK1

/* Entry script */
script 200{
	scLoadObjectToGame(202);
}

stringpack STDESC{
	/***************************************/
#ifdef ENGLISH
	"Looks strong.";
	"I can hear people behind...";
	//2
	"Better find another way in.";
	
	//3
	"They are still a bit wet...";
	
	//4
	"Hello, brother. Any problem?";
	"You know you cannot enter until the";
	"end of the shift. Go back to your";
	"duties, and let He bless you.";
	
	//8
	"It is getting dark. I'd better put the";
	"lamp in its place. I've been repairing";
	"it all the evening.";
	"Perfect. Now we won't fear the grues.";
#endif

#ifdef FRENCH
	"Looks strong.";
	"I can hear people behind...";
	//2
	"Better find another way in.";
	
	//3
	"They are still a bit wet...";
	
	//4
	"Hello, brother. Any problem?";
	"You know you cannot enter until the";
	"end of the shift. Go back to your";
	"duties, and let He bless you.";
	
	//8
	"It is getting dark. I'd better put the";
	"lamp in its place. I've been repairing";
	"it all the evening.";
	"Perfect. Now we won't fear the grues.";
#endif

#ifdef SPANISH
	"Parece fuerte.";
	"Se oye gente detrás...";
	//2
	"Mejor busco otra manera de entrar.";
	
	//3
	"Todavía están algo húmedas...";
	
	//4
	"Hola, hermano. ¿Algún problema?";
	"Sabes que no puedes entrar hasta el";
	"fin de tu turno. Vuelve a tus";
	"quehaceres y que El te bendiga.";
	
	//8
	"Está oscureciendo. Mejor que ponga la";
	"lámpara en su sitio. La he estado";
	"reparando toda la tarde.";
	"Perfecto. Ya no temeremos a las grues."; 
#endif
}

// Handles the Monk opening the door and putting the lamp sequence
script 210{
	byte i;
	
	scCursorOn(false);
	scSetAnimstate(DOOR,1);
	scLoadObjectToGame(MONK);
	scSetPosition(MONK,36,15,35);
	scLookDirection(MONK, FACING_LEFT);
	
	for(i=4;i<=10;i=i+1){
		scActorTalk(MONK,STDESC,i);
		scWaitForActor(MONK);
		if (i==4) scDelay(20);
		if(i==7){
			scLookDirection(MONK,FACING_RIGHT);
			scDelay(50);
		}
	}
	scActorWalkTo(MONK,41,15);
	scWaitForActor(MONK);
	scLookDirection(MONK,FACING_UP);
	// Put the lamp on the wall!
	scLoadObjectToGame(LAMP);
	scDelay(50);
	scLookDirection(MONK,FACING_LEFT);
	scActorTalk(MONK,STDESC,11);
	scWaitForActor(MONK);
	scActorWalkTo(MONK,36,15);
	scWaitForActor(MONK);
	scLookDirection(MONK,FACING_UP);
	scBreakHere();
	scRemoveObjectFromGame(MONK);
	scSetAnimstate(DOOR,0);
	
	scSave();
	bLampSet=true;
	scCursorOn(true);
}

objectcode DOOR{
	LookAt:
		scActorTalk(BLAKE,STDESC,0);
		scStopScript();
	Use:
		if (sfGetActionObject2()!=255) { scSpawnScript(1); scStopScript();}
	Open:	
	Push:
	Pull:
		if ((!bLampSet) && (sfGetCostumeID(BLAKE)!=0)){
			scSpawnScript(210);
		}
		else{
			scCursorOn(false);
			scActorTalk(BLAKE,STDESC,1);
			scWaitForActor(BLAKE);
			scLookDirection(BLAKE,FACING_DOWN);
			scActorTalk(BLAKE,STDESC,2);
			scWaitForActor(BLAKE);
			scCursorOn(true);
			//scStopScript();	
		}
}


objectcode PATH{
	WalkTo:
		scSetPosition(BLAKE,ROOM_CAEXTERIOR,16,0);
		scLookDirection(BLAKE,FACING_RIGHT);
		scChangeRoomAndStop(ROOM_CAEXTERIOR);
		
}

objectcode ROBE{
	byte an;
	LookAt:
		scActorTalk(BLAKE,STDESC,3);
		scStopScript();
	Use:
		if (sfGetActionObject2()!=255) { scSpawnScript(1); scStopScript();}
	PickUp:
		an=sfGetAnimstate(BLAKE);
		scSetCostume(BLAKE,16,0);
		scSetAnimstate(BLAKE,an);
		scSave();
}


