/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/****************************/

#include "globals.h"

/* Object command script and strings */

stringpack GUARD
{
#ifdef ENGLISH
	"Quite menacing...";
	"You must be kidding...";
	"Move along, move along...";
	"He seems to be asleep...";
	"He's busy. Better leave him alone.";
#endif
#ifdef SPANISH
	"Amenazador...";
	"Debes estar bromeando...";
	"Vamos. No se detenga aquí.";
	"Parece estar dormido...";
	"Parece ocupado. Mejor le dejo.";
#endif
}

objectcode GUARD
{
	byte string;
	LookAt: 
		string=0;
		goto sayit;
	TalkTo:
		if(sfGetCurrentRoom()==ROOM_CAMCONTROL)
		{
			string=3;
			goto sayit;
		}
		if(sfGetCurrentRoom()==ROOM_COMMON)
		{
			string=4;
			goto sayit;
		}		
		scActorTalk(GUARD,GUARD,2);
		scWaitForActor(GUARD);
		scStopScript();
	Push:
	Pull:
		string=1;
		goto sayit;
	Use:
		if( (sfGetCurrentRoom()==ROOM_COMMON) && (sfGetActionObject1()==CUP) ){
			// Using the cup over the guard
			scSpawnScript(202);
			scStopScript();
		} 
		scStopScript();

	sayit:
		scActorTalk(BLAKE,GUARD,string);
		scWaitForActor(BLAKE);
		scStopScript();
}
