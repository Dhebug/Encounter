/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR:laurentd75	*/
/****************************/

#include "globals.h"

/* Object command script and strings */

stringpack VARGAS{
#ifdef ENGLISH	
	"He's completely mad. And armed!";
	"Maybe if he entered the cabin...";
	
	"Nice try! But useless.";
	"I will kill you NOW!";
#endif
#ifdef FRENCH	
	"Il est complétement fou. Et armé!";
	"Mais s'il entrait dans la cabine...";
	"Bien essayé, mais en vain.";
	"Je vais te tuer MAINTENANT!";
#endif
#ifdef SPANISH
	"Completamente loco. ¡Y armado!";
	"Quizá si entrase en la cabina...";
	
	"Buen intento, pero inútil.";
	"Te mataré ¡AHORA!";
#endif	
}

objectcode VARGAS{
	LookAt:
		scActorTalk(BLAKE,VARGAS,0);
		scWaitForActor(BLAKE);
		scActorTalk(BLAKE,VARGAS,1);
		scWaitForActor(BLAKE);
		scStopScript();
	Push:
		scChainScript(254);
}


script 254{
	byte i;
	
	scShowVerbs(false);
	
	scSetAnimstate(BLAKE,3);
	//scDelay(10);
	scSetCostume(VARGAS,17,0);	
	scBreakHere();
	
	for(i=4;i>=2;i=i-2){
		scSetPosition(VARGAS,ROOM_LIBTELEPORT, 14, i);		
		scSetAnimstate(VARGAS,1);
		scPlaySFX(SFX_STEPA);
		if(i==4) scSetAnimstate(BLAKE,0);
		scBreakHere();
		scSetAnimstate(VARGAS,2);
		scPlaySFX(SFX_STEPA);
		scBreakHere();
		scSetPosition(VARGAS,ROOM_LIBTELEPORT, 14, i-1);		
		scSetAnimstate(VARGAS,3);
		scPlaySFX(SFX_STEPA);
		scBreakHere();
		scSetAnimstate(VARGAS,2);
		scPlaySFX(SFX_STEPA);
		scBreakHere();		
	}
	
	scSetCostume(VARGAS,17,1);
	scBreakHere();
	scActorTalk(VARGAS,VARGAS,2);
	scWaitForActor(VARGAS);
	scActorTalk(VARGAS,VARGAS,3);
	scWaitForActor(VARGAS);
	
	scSetEvents(4);
}