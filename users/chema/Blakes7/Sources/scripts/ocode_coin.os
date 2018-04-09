/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR:laurentd75	*/
/****************************/

#include "globals.h"

/* Object command script and strings */

objectcode COIN
{
	LookAt:
		scCursorOn(false);
		scActorTalk(BLAKE,COIN,0);
		scWaitForActor(BLAKE);
		scActorTalk(BLAKE,COIN,1);
		scWaitForActor(BLAKE);		
		scCursorOn(true);
		scStopScript();
	Use:
		scActorTalk(BLAKE,COIN,2);

}

stringpack COIN
{
#ifdef ENGLISH
	/*
	 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx */
	"A cent of credit.";
	"A small, thin, useless coin.";
	"It is not useful for this.";
#endif
#ifdef FRENCH
	/*
	 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx */
	"Un centime de crédit.";
	"Une petite piece de monnaie inutile.";
	"Ca n'a aucune utilité pour cela.";
#endif
#ifdef SPANISH
	/*
	 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx */
	"Un céntimo de crédito.";
	"Una moneda fina, pequeña e inútil.";
	"No es útil para esto.";
#endif
	
}

