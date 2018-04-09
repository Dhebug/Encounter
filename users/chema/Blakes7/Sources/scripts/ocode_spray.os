/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR:laurentd75	*/
/****************************/

#include "globals.h"

/* Object command script and strings */

stringpack SPRAY{
#ifdef ENGLISH	
	/***************************************/
	"Bug repellent spray.";
	"The label says: specifically designed";
	"for infestation of tribbles.";
	"Use with caution.";
#endif
#ifdef FRENCH	
	/***************************************/
	// [laurentd75]: better translate to "nuisibles" (pests) instead of "insectes" (bugs), since the spray
	// is actually designed against tribbles (fictional hairy balls in Star Trek) rather than insects
	"Spray répulsif pour nuisibles.";			
	"L'étiquette précise: spécialement prévu";
	"pour les infestations de Tribules.";	// [laurentd75]: see https://fr.wikipedia.org/wiki/Tribble
	"Utiliser avec précaution.";
#endif
#ifdef SPANISH
	/***************************************/
	"Repelente de bichos. La etiqueta pone:";
	"Especialmente indicado para control de";
	"plagas de tribbles.";
	"Usar con precaución.";
#endif
	
}

objectcode SPRAY
{
	byte i;
	LookAt:
		i=0;
		scCursorOn(false);

	loop:
		scActorTalk(BLAKE,SPRAY,i);
		scWaitForActor(BLAKE);
		i=i+1;
		if(i<4) goto loop;
		scCursorOn(true);
		scStopScript();
	PickUp:
		scPutInInventory(SPRAY);	

}



