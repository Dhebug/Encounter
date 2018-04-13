/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR:laurentd75	*/
/****************************/

#include "globals.h"

/* Object command script and strings */

objectcode WSWITCH{
	LookAt:
		scActorTalk(sfGetEgo(),WSWITCH,0);
}


stringpack WSWITCH{
#ifdef ENGLISH
	"A remote operated relay.";
#endif

#ifdef FRENCH
	"Un relais actionné à distance.";
#endif

#ifdef SPANISH
	/***************************************/
	"Un relé operado remotamente.";
#endif
}


