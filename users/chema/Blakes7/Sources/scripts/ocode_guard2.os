/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/****************************/

#include "globals.h"

#define DIALOG_1	200

/* Object command script and strings */

stringpack GUARD2
{
#ifdef ENGLISH
	"Again quite menacing...";
	"You must be kidding...";
	"Yes, comrade?";

#endif
#ifdef SPANISH
	"De nuevo amenazador...";
	"Debes estar bromeando...";
	"¿Si, camarada?";
#endif
}

objectcode GUARD2
{
	byte string;
	LookAt: 
		string=0;
		goto sayit;
	TalkTo:
		/* Can't do this, unless disguised as a guard */
		scActorTalk(GUARD2,GUARD2,2);
		scWaitForActor(GUARD2);
		scLoadDialog(DIALOG_1);
		scStartDialog();
		scStopScript();
	Push:
	Pull:
		string=1;
		goto sayit;
	sayit:
		scActorTalk(BLAKE,GUARD2,string);
		scWaitForActor(BLAKE);
		scStopScript();
}



