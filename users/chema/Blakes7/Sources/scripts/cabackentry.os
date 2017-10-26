/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/****************************/

#include "globals.h"

// Scripts for the back entry to building
#define CAVE 		200
#define STAIRS 		201
#define PULLEY		202
#define GATE		203
#define STDESC		200

stringpack STDESC{
	/***************************************/
#ifdef ENGLISH
	"It seems to me that it is the system";
	"to open the gate.";
	"Solid bars. I don't think I will be";
	"able to break them.";
	
	//4
	"It seems the stopper is broken.";
	"If I had some kind of hard stick...";
	
	//6
	"That won't help.";
	"I can't, with the gate closed.";
	
	//8
	"Nice idea! It will do the trick!";
	"The gun is keeping the gate up.";
#endif

#ifdef SPANISH
	"Me parece a mí el sistema que hay";
	"para abrir la verja.";
	"Barras sólidas. No creo que pueda";
	"romperlas fácilmente.";
	
	//4
	"Parece que el bloqueador está roto.";
	"Si tuviese algo como un palo duro...";
	
	//6
	"Eso no va a ayudar.";
	"No puedo, con la verja cerrada.";
	
	//8
	"Buena idea! Funcionará!";
	"El arma mantiene la verja arriba.";
#endif
	
}

objectcode CAVE{
	Use:
		if (sfGetActionObject2()!=255) { scSpawnScript(1); scStopScript();}
	WalkTo:
		scSetPosition(BLAKE,ROOM_CACAVE,10,4);
		scLookDirection(BLAKE,FACING_DOWN);
		scChangeRoomAndStop(ROOM_CACAVE);
}

/*
objectcode STAIRS{
	Use:
	WalkTo:
		scSetPosition(BLAKE,ROOM_CAHALL,13,15);
		scLookDirection(BLAKE,FACING_DOWN);
		scChangeRoomAndStop(ROOM_CAHALL);	
}
*/

objectcode PULLEY{
	LookAt:
		if(bPulleyDone)
		{
			scActorTalk(BLAKE,STDESC,9);
			scStopScript();
		}
		scCursorOn(false);
		if(sfGetAnimstate(GATE)==5){
			//Gate is open
			scActorTalk(BLAKE,STDESC,4);
			scWaitForActor(BLAKE);
			scActorTalk(BLAKE,STDESC,5);
		}
		else{
			scActorTalk(BLAKE,STDESC,0);
			scWaitForActor(BLAKE);
			scActorTalk(BLAKE,STDESC,1);
		}
		scCursorOn(true);
		scStopScript();
	Use:
		if (bPulleyDone) goto LookAt;
		if((sfGetActionObject1()==GUN) && sfGetAnimstate(GATE)==5){
			// Ready to lock the chain!
			scCursorOn(false);
			scTerminateScript(202);			
			scLookDirection(BLAKE,FACING_DOWN);
			scActorTalk(BLAKE,STDESC,8);
			scWaitForActor(BLAKE);
			scActorWalkTo(BLAKE,12,11);
			scWaitForActor(BLAKE);
			scLookDirection(BLAKE,FACING_UP);
			scDelay(10);
			scRemoveFromInventory(GUN);
			scSetAnimstate(PULLEY,4);
			bPulleyDone=true;
			scSave();
			//scPlaySFX(SFX_SUCCESS);
			scLookDirection(BLAKE,FACING_DOWN);
			scCursorOn(true);
			scStopScript();
		}
	
		if(sfGetActionObject1()!=PULLEY){
			//Trying to use something on the pulley
			scActorTalk(BLAKE,STDESC,6);
			//scWaitForActor(BLAKE);
			//scActorTalk(BLAKE,STDESC,7);
			//scWaitForActor(BLAKE);
			scStopScript();
		}
	Pull:
		// Repeat this in case the user tries to pull
		// Because Use also runs up to here
		if (bPulleyDone) goto LookAt;

		// Player is trying to open the gate
		if(sfGetAnimstate(GATE)==0){
			//Gate is closed, open it.
			scCursorOn(false);
			scChainScript(200); // Open the gate
			scSpawnScript(202); // Check Blake moves
			scCursorOn(true);
		}
}


objectcode GATE{
	LookAt:
		if (bPulleyDone)
			scActorTalk(BLAKE,STDESC,9);
		else{
			scCursorOn(false);
			scActorTalk(BLAKE,STDESC,2);
			scWaitForActor(BLAKE);
			scActorTalk(BLAKE,STDESC,3);
			scWaitForActor(BLAKE);
			scCursorOn(true);
		}
		scStopScript();
	WalkTo:
		if(sfGetAnimstate(GATE)!=5){
			scActorTalk(BLAKE,STDESC,7);
			scStopScript();
		}

		/*scSetPosition(BLAKE,ROOM_CAHALL,13,15);
		scLookDirection(BLAKE,FACING_DOWN);
		scChangeRoomAndStop(ROOM_CAHALL);			
		*/
		
		scSetPosition(BLAKE,ROOM_CACELLS,15,32);
		scLookDirection(BLAKE,FACING_LEFT);
		scSpawnScript(10);

		//scChangeRoomAndStop(ROOM_CACELLS);			
}

/* Script to open the gate */
script 200{
	byte i;
	byte j;
	
	j=1;
	for(i=1;i<=5;i=i+1){
		scSetAnimstate(GATE,i);
		scSetAnimstate(PULLEY,j);
		if(j==3) 
			j=0;
		else 
			j=j+1;
		scDelay(10);
	}
}

/* Script to close the gate */
script 201{
	byte i;
	byte j;
	

	j=sfGetAnimstate(PULLEY);
	for(i=5;i!=255;i=i-1){
		scSetAnimstate(GATE,i);
		scSetAnimstate(PULLEY,j);
		if(j==0) 
			j=3;
		else
			j=j-1;
		scDelay(2);
	}
}


/* Script to detect Blake leaving the pulley */
script 202{
	byte row;
	byte col;
	
	col=sfGetCol(BLAKE);
	row=sfGetRow(BLAKE);
	
loop:
	if ((sfGetCol(BLAKE)!=col)||(sfGetRow(BLAKE)!=row)){
		// Close the gate:
		scStopCharacterAction(BLAKE);
		scSpawnScript(201);
		scStopScript();
	}
	scBreakHere();
	goto loop;
}

/* Entry script */
script 210{
	if(bPulleyDone){
		scSetAnimstate(PULLEY,4);
		scSetAnimstate(GATE,5);
	}
}
