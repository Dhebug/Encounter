/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR:laurentd75	*/
/****************************/

#include "globals.h"

/* Object command script and strings */

stringpack CUP{
#ifdef ENGLISH	
	/***************************************/
	"A big coffee cup.";
	"It's empty.";
	"It's full of water.";
	"It's full of coffee.";
	"I can't use the cup like that.";
#endif
#ifdef FRENCH	
	/***************************************/
	"Un grand gobelet de café.";	// [laurentd75]: c'est un gobelet (en papier) de café en fait, pas une tasse
	"Il est vide.";
	"Il est plein d'eau.";
	"Il est plein de café.";
	"Je ne peux l'utiliser de cette facon.";
#endif
#ifdef SPANISH
	/***************************************/
	"Una taza de café grande.";
	"Está vacía.";
	"Está llena de agua.";
	"Está llena de café.";
	"No puedo usar la taza así.";
#endif
}

objectcode CUP
{
	byte a;
	LookAt:
		a=sfGetEgo();
		scActorTalk(a,CUP,0);
		scWaitForActor(a);
		if(sfGetState(CUP)==0) scActorTalk(a,CUP,1);
		if(sfGetState(CUP)==1) scActorTalk(a,CUP,2);
		if(sfGetState(CUP)==2) scActorTalk(a,CUP,3);
		scStopScript();
	Use:		
		if( (sfGetActionObject2()!=GUARD2) || (sfGetState(CUP)!=2)){
			scActorTalk(BLAKE,CUP,4);
			scStopScript();
		}
		// Empty it over the guard!
		
}

