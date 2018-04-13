/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR:laurentd75	*/
/****************************/

#include "globals.h"

/* Object command script and strings */

stringpack VILA
{
#ifdef ENGLISH	
	"A funny man...";
	/**************************************/
	"There isn't a lock I can't open...";
	"if I'm scared enough.";
	"I don't feel well.";
	"I'm going to be a big handicap.";
	"I've got a condition - a fear of";
	"enclosed spaces."; 
	"There's a name for it...";
	"Cowardice?";
	
#endif
#ifdef FRENCH	
	"C'est un curieux personnage...";
	/**************************************/
	"Il n'y a pas de serrure que je ne";
	"puisse ouvrir... Si j'ai assez peur."; // ou bien: "puisse ouvrir... S'il y va de ma vie.";
	"Je ne me sens pas bien.";
	"Je vais être un gros handicap.";
	"Je souffre d'un grave syndrome: "; // [laurentd75]: "grave syndrome" en français, plutôt que simplement "syndrome"
	"la peur des espaces clos."; 
	"Il y a un autre nom pour ça..."; // préciser "un *autre* nom"  en français est mieux
	"La lâcheté?";
	
#endif
#ifdef SPANISH
	"Un hombre curioso...";
	/**************************************/
	"No hay cierre que no pueda abrir...";
	"si estoy suficientemente asustado.";
	"No me encuentro bien.";
	"Voy a ser un gran handicap.";
	"Tengo un síndrome - miedo a los";
	"espacios cerrados."; 
	"Tiene un nombre...";
	"¿Cobardía?";	
#endif
}

objectcode VILA
{
	byte i;
	LookAt: 
		scActorTalk(BLAKE,VILA,0);
		scWaitForActor(BLAKE);
		scStopScript();

	TalkTo:
		// In the london cell
		if(sfGetCurrentRoom()==ROOM_LONDONCELL)
		{
			scLoadDialog(207);
			if(bAskedAvonForLock && (!sfIsObjectInInventory(205 /* Battery*/)) )
			{
				scActivateDlgOption(1,true);
			}
			scStartDialog();
			scStopScript();
		}	
		
		// Default responses
		if( (sfGetCurrentRoom()==ROOM_SERVICE) && (sfGetRoom(JENNA)==ROOM_SERVICE) && (sfGetRand()>50) ){
			scCursorOn(false);
			scActorTalk(VILA,VILA,4);
			scWaitForActor(VILA);
			scActorTalk(VILA,VILA,5);
			scWaitForActor(VILA);
			scActorTalk(VILA,VILA,6);
			scWaitForActor(VILA);
			scActorTalk(VILA,VILA,7);
			scWaitForActor(VILA);
			scActorTalk(JENNA,VILA,8);
			scWaitForActor(JENNA);
			scCursorOn(true);
			scStopScript();	
		}

		scCursorOn(false);
		if(sfGetRand()>127){
			scActorTalk(VILA,VILA,1);
			scWaitForActor(VILA);
			scActorTalk(VILA,VILA,2);
		}
		else{
			scActorTalk(VILA,VILA,3);
			scWaitForActor(VILA);
			scActorTalk(VILA,VILA,4);
		}
		scCursorOn(true);
		scStopScript();
}
