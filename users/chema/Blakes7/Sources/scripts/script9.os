
/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR:laurentd75	*/
/****************************/

#include "globals.h"

/* The stringpack is contained here. As there is a scLoadRoom call it cannot be local
 or it would be discarded. It can be given any global id, as long as there is no other 
 stringpack resource with the same one. And still it should be locked before calling
 scLoadRoom and unlocked afterwards */


#define STLOCAL	100


/* Script that handles the scene where Avon
 suggests Jenna they should leave Blake behind. */
 
 script 9{
	 
	byte i;

	scShowVerbs(false);

	scSetPosition(JENNA, ROOM_LIBTELEPORT, 14, 18);
	scLookDirection(JENNA,FACING_RIGHT);
	
	scLockResource(RESOURCE_STRING,STLOCAL);
	scLoadRoom(ROOM_LIBTELEPORT);
	scUnlockResource(RESOURCE_STRING,STLOCAL);
	scPrint(STLOCAL,24);	
	scDelay(100);
	scPrint(STLOCAL,25);
	
	for(i=0;i<14;i=i+2){
		scActorTalk(JENNA,STLOCAL,i);
		scWaitForActor(JENNA);
		scActorTalk(AVON,STLOCAL,i+1);
		scWaitForActor(AVON);
	}
 
	for(i=14;i<18;i=i+1){
		scActorTalk(AVON,STLOCAL,i);
		scWaitForActor(AVON);
	}
	
	scActorTalk(JENNA,STLOCAL,18);
	scWaitForActor(JENNA);
	scActorTalk(AVON,STLOCAL,19);
	scWaitForActor(AVON);

	for(i=20;i<23;i=i+1){
		scActorTalk(JENNA,STLOCAL,i);
		scWaitForActor(JENNA);
	}	
	scActorTalk(AVON,STLOCAL,23);
	scWaitForActor(AVON);
	
	scDelay(50);
	
	scSetPosition(JENNA, ROOM_LIBDECK, 12, 17);
	
	scLoadRoom(ROOM_CACAVE);
	scSetCameraAt(40);
	scShowVerbs(true);
	//scChangeRoomAndStop(ROOM_CACAVE);
  }

 stringpack STLOCAL{
#ifdef ENGLISH
	/***************************************/
	"Did Blake find the others?";
	"Not yet. I bet he'll end up killed.";
	"Quit that.";
	"This ship is worth billions.";
	"Sure.";
	"You could buy anything with this.";
	"Probably...";
	"Anything at all. Think of it Jenna.";
	"But what about Blake?";
	"What about him.";
	"No.";
	"We could own our own planet.";
	"We're not leaving him here.";
	"We have to. He's a crusader.";
	
	//14
	/***************************************/
	"He'll look upon all this as just a";
	"weapon to use against the Federation.";
	"And he can't win. You know he can't.";
	"What do you want to be, rich or dead?"; // [aurentd75] added comma
	
	//18
	"An hour. We'll wait an hour.";
	"Why? Why wait?";
	"Because that way I can convince myself";
	"that we gave him a fair chance.";
	"If he's not back by then...";
	"All right.";
	
	" Meanwhile, in The Liberator...";
	" ";
#endif

#ifdef FRENCH
	/***************************************/
	"Blake a-t-il trouvé les autres?";
	"Pas encore. Il va se faire tuer...";
	"Arrête avec ça.";
	"Ce vaisseau vaut des milliards.";
	"J'imagine.";
	"On pourrait s'acheter ce qu'on veut...";
	"Probablement...";
	"Tout ce qu'on veut... Pense-y, Jenna.";
	"Oui, mais, et Blake alors?";
	"Tant pis, on s'en fiche..."; // [laurentd75]: ou alors: "Peu m'importe"
	"Non.";
	"On pourrait avoir une planète à nous.";
	"Pas question de le laisser ici.";
	"On devrait... C'est un idéaliste.";  // [laurentd75] crusader=un croisé, au sens chevaleresque, idéaliste, militant, activiste...
	
	//14
	/***************************************/
	"Lui, il voit ce vaisseau uniquement";
	"comme une arme contre la Fédération.";
	"Mais il ne peut pas gagner, tu le sais.";
	"Que préfères-tu, être riche, ou morte?";
	
	//18
	"Une heure. Attendons juste une heure.";
	"Mais pourquoi? Pourquoi attendre?";
	"Parce qu'ainsi, je pourrai considérer";
	"qu'on lui a laissé une chance.";
	"S'il n'est pas revenu d'ici là...";
	"D'accord.";
	
	" Pendant ce temps, dans le Libérateur.."; // [laurentd75] ou bien: " Au meme moment, dans le Libérateur..."
	" ";
#endif

#ifdef SPANISH

	/***************************************/
	"¿Encontró Blake al resto?";
	"Aun no. Apuesto a que acabará muerto.";
	"Para con eso.";
	"Esta nave vale billones.";
	"Fijo.";
	"Podrías comprar lo que quisieses.";
	"Probablemente...";
	"Todo. Piénsalo Jenna.";
	"¿Y Blake?";
	"Qué pasa con él.";
	"No.";
	"Podríamos tener un planeta propio.";
	"No lo vamos a dejar aquí.";
	"Pero debemos. Es un cruzado.";
	
	//14
	/***************************************/
	"Mirará todo esto y sólo vera un arma";
	"para utilizar contra la Federación.";
	"Y no puede ganar. Sabes que no puede.";
	"¿Prefieres ser rica o estar muerta?";
	
	//18
	"Una hora. Esperaremos una hora.";
	"¿Por qué? ¿para qué esperar?";
	"Para convencerme a mí misma de que le";
	"dimos una oportunidad.";
	"Si no ha vuelto para entonces...";
	"Está bien.";
	
	" Mientras, en El Liberador...";
	" ";
#endif

}
 
