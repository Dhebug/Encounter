/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR:laurentd75	*/
/****************************/

#include "globals.h"

/* Object command script and strings */

stringpack SCISSORS{
#ifdef ENGLISH	
	"They look strong and sharp.";
	"I can't cut that.";
#endif
#ifdef FRENCH	
	"Ils ont l'air solides et affûtés.";
	"Je ne peux pas couper cela.";
#endif
#ifdef SPANISH
	"Parecen fuertes y afiladas.";
	"No puedo cortar eso.";
#endif	
}

objectcode SCISSORS
{
	LookAt: 
		scActorTalk(BLAKE,SCISSORS,0);
		scWaitForActor(BLAKE);
		scStopScript();
	PickUp:
		scPutInInventory(SCISSORS);
		scStopScript();
	Use:
		scActorTalk(BLAKE,SCISSORS,1);

		
}
