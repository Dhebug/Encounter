
/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR:laurentd75	*/
/****************************/

#include "globals.h"

#define MAN2 200

// Entry (and only) script
script 200
{
	byte i;
	
	// Time for removing remaining objects
	scRemoveObjectFromGame(INFOMAN);
	
	scShowVerbs(false);
	scActorWalkTo(BLAKE,18,13);
	scDelay(50);
	scActorTalk(MAN2,200,0);
	scWaitForActor(BLAKE);
	scWaitForActor(MAN2);
	scLookDirection(BLAKE,FACING_LEFT);
	scActorTalk(MAN2,200,1);
	scWaitForActor(MAN2);
	scActorTalk(MAN2,200,2);
	scWaitForActor(MAN2);

	scActorTalk(BLAKE,200,3);
	scWaitForActor(BLAKE);
	scActorTalk(BLAKE,200,4);
	scWaitForActor(BLAKE);

	scActorTalk(MAN2,200,5);
	scWaitForActor(MAN2);
	scActorTalk(MAN2,200,6);
	scWaitForActor(MAN2);
	scActorTalk(MAN2,200,7);
	scWaitForActor(MAN2);

	//scActorWalkTo(MAN2,9,10);
	//scActorWalkTo(BLAKE,13,11);
	//scWaitForActor(BLAKE);
	
	scSetBWPalette();
	
	
	scPlayTune(FEDMARCH_TUNE);
	
	scDelay(50);
	scPrintAt(200,20,78,102);
	scPrintAt(200,20,78,106);
	scPrintAt(200,8,78,104);
	scDelay(200);
	for (i=9; i<=19; i=i+1)
	{
		scPrint(200,i);
		scDelay(175);
	}
	//scClearEvents(1);
	//scWaitEvent(1);
	scStopTune();
	
	scSetPosition(BLAKE,ROOM_EXTERIOR,16,53);
	scLookDirection(BLAKE,FACING_LEFT);
	scChangeRoomAndStop(ROOM_EXTERIOR);
}


stringpack 200{
#ifdef ENGLISH
	/**************************************/
	"Blake! You came at last!";
	"I was afraid you were captured.";
	"Where's Ravella?";
	
	"She did not appear. That's why it took";
	"me so long to find a way to come here.";
	
	"That is terrible news!";
	"But come with me, I'll take you to";
	"the rest of the group.";
	
	//8
	" SEC CAM H-233 ";
	"\A_FWWHITE+A_FWGREEN*8+$c0 The plan works, Supreme Commander.";
	//10
	"\A_FWMAGENTA you mean MY plan works, Travis.";
	"\A_FWMAGENTA They could not avoid trying to bring";
	"\A_FWMAGENTA Blake back to their group.";
	"\A_FWMAGENTA He is still a hero.";
	//14
	"\A_FWWHITE+A_FWGREEN*8+$c0 Arresting Ravella was risky.";
	"\A_FWMAGENTA Yes, but Blake has his resources";
	"\A_FWMAGENTA and she was becoming a higher risk.";
	"\A_FWMAGENTA Now prepare your squadron.";
	"\A_FWMAGENTA The resistance will be totally";
	"\A_FWMAGENTA obliterated tonight.";
	
	"               ";//META: Is one just enough?
#endif

#ifdef FRENCH
	/**************************************/
	"Blake! Te voilà enfin!";
	"J'avais peur que tu aies été capturé.";
	"Mais où est Ravella?";
	
	"Je ne l'ai pas vue. C'est pour ça que";
	"j'ai mis si longtemps pour arriver ici.";
	
	"Mais c'est une terrible nouvelle!";
	"Enfin bon, viens avec moi, je vais";
	"te conduire au reste du groupe.";
	
	//8
	" SEC CAM H-233 ";
	"\A_FWWHITE+A_FWGREEN*8+$c0 Le plan fonctionne, Commandant Suprême.";
	//10
	"\A_FWMAGENTA Vous voulez dire MON plan, Travis.";
	"\A_FWMAGENTA Ils n'ont pas pu s'empêcher d'essayer";
	"\A_FWMAGENTA de faire revenir Blake dans le groupe.";
	"\A_FWMAGENTA C'est toujours un héros.";
	//14
	"\A_FWWHITE+A_FWGREEN*8+$c0 Arrêter Ravella était risqué.";
	// [laurentd75]: can't really understand the sense of this sentence: "Yes, but Blake has his resources"
	"\A_FWMAGENTA Oui, mais Blake a ses ressources,"; 
	"\A_FWMAGENTA et elle devenait un danger plus grand.";
	"\A_FWMAGENTA Bon, allez préparer votre escadron.";
	"\A_FWMAGENTA La résistance sera totalement et";
	"\A_FWMAGENTA à jamais annihilée ce soir.";
	
	"               ";//META: Is one just enough?
#endif

#ifdef SPANISH
	/**************************************/
	"¡Blake! ¡Por fin llegas!";
	"Temía que te hubiesen capturado.";
	"¿Dónde está Ravella?";
	
	"No apareció. Por eso me llevó tanto";
	"tiempo llegar hasta aquí.";
	
	"¡Son noticias terribles!";
	"Pero ven conmigo. Te llevaré con el";
	"resto del grupo.";
	
	//8
	" SEC CAM H-233 ";
	"\A_FWWHITE+A_FWGREEN*8+$c0 El plan funciona, Comandante Supremo.";
	//10
	"\A_FWMAGENTA MI plan funciona, Travis.";
	"\A_FWMAGENTA No podían evitar traer a Blake";
	"\A_FWMAGENTA de regreso con el grupo.";
	"\A_FWMAGENTA Aún es un héroe.";
	//14
	             /***************************************/
	"\A_FWWHITE+A_FWGREEN*8+$c0 Arrestar a Ravella fue un riesgo.";
	"\A_FWMAGENTA Sí, pero Blake tiene sus recursos";
	"\A_FWMAGENTA y se estaba volviendo un problema.";
	"\A_FWMAGENTA Ahora prepara tu escuadrón.";
	"\A_FWMAGENTA La resistencia será eliminada por";
	"\A_FWMAGENTA completo y para siempre esta noche.";
	
	"               "; //META: Is one just enough?
#endif

}
