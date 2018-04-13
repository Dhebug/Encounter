/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR:laurentd75	*/
/****************************/

#include "globals.h"

#define EPILOGUE 200


/* Epilogue scripts */

/* Entry script */
script 200{
	byte i;
	byte a;
	
	scLoadObjectToGame(TRAVIS);
	scLoadObjectToGame(SERVALAN);
	scSetPosition(SERVALAN,ROOM_EPILOGUE,15,20);
	scSetPosition(TRAVIS,ROOM_EPILOGUE,15,37);
	scLookDirection(SERVALAN,FACING_LEFT);
	scLookDirection(TRAVIS,FACING_LEFT);
	scBreakHere();
	scActorWalkTo(TRAVIS,32,15);
	scWaitForActor(TRAVIS);
	scDelay(50);
	
	scLookDirection(SERVALAN,FACING_RIGHT);
	scBreakHere();
	
	for(i=0; i<=18; i=i+1){
		if ( (i==4)||(i==8)||(i==16) ) a=TRAVIS;
		else a=SERVALAN;
	
		if(i==2){
			scLookDirection(SERVALAN, FACING_LEFT);
			scDelay(50);
		} 
		if(i==5) scLookDirection(SERVALAN, FACING_RIGHT);
		
		scActorTalk(a,EPILOGUE,i);
		scWaitForActor(a);
	}
	
	scDelay(100);
	scSetBWPalette();
	scPlayTune(ENDEP_TUNE);
	scWaitForTune();
	scClearRoomArea();
	
here2:	
	scSetOverrideJump(end);
here:
	goto here;
end:	
	goto here2;
}



stringpack EPILOGUE{
#ifdef ENGLISH
	/***************************************/
	"Ah, Travis.";
	"Everyone's heard about your fiasco...";
	"You've heard, of course, that there";
	"have been two attempts on my life.";
	
	//4
	"I have. I was very concerned.";
	//5
	"I consider YOU responsible.";
	"Your incompetence has put my life and";
	"my position at risk.";
	
	//8
	"Yes, but this WILL change. I have...";
	
	//9
	"Stop it!";
	"We will capture Blake and his ship";
	"sooner or later, but for now I want";
	"to put all our resources in something";
	"else... something that will put me in";
	"a much more powerful position inside";
	"the Federation High-Command.";
	
	//16
	"Yes?";
	
	//17
	"I want to show you Project ORAC.";
	"I'll debrief you on the details...";
#endif

#ifdef FRENCH
	/***************************************/
	"Ah, Travis.";
	"Tout le monde a appris votre fiasco...";
	"Vous savez, bien sûr, qu'il y a eu";
	"deux attentats sur ma vie?";
	
	//4
	"Oui. J'étais d'ailleurs très inquiet.";
	//5
	"Je VOUS considère comme responsable.";
	"Votre incompétence a mis ma vie et";
	"ma situation en danger.";
	
	//8
	"Oui, mais cela va changer. J'ai...";
	
	//9
	"Taisez-vous!";
	"Nous capturerons Blake et son vaisseau";
	"tôt ou tard, mais désormais je souhaite";
	"consacrer toutes nos ressources à autre";
	"chose... qui m'assurera une situation";
	"de pouvoir bien supérieure au sein du";
	"Haut Commandement de la Fédération.";
	
	//16
	"C'est-à-dire?";
	
	//17
	"Je vais vous présenter le projet ORAC."; // "vais" est mieux que "veux" ici, surtout avec la phrase suivante...
	"Je vous donnerai tous les détails...";
#endif

#ifdef SPANISH
	/***************************************/
	"Ah, Travis.";
	"Todo el mundo sabe ya lo de tu fiasco.";
	"Has oído, seguro que han habido dos";
	"intentos de atentar contra mi vida.";
	
	//4
	"Sí. Estuve muy preocupado.";
	//5
	"Te considero a TI responsable.";
	"Tu incompetencia ha puesto en riesgo";
	"mi vida y mi posición.";
	
	//8
	"Sí, pero eso cambiará. He...";
	
	//9
	"¡Déjalo!";
	"Capturaremos a Blake y su nave antes";
	"o después, pero por ahora quiero poner";
	"nuestros recursos en algo diferente...";
	"algo que me dará mucho más poder y";
	"mejorará mi posición dentro del Alto";
	"Mando de la Federación.";
	
	//16
	"¿Si?";
	
	//17
	"Quiero mostrarte el Proyecto ORAC.";
	"Te informaré de los detalles...";
#endif
}
