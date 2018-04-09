/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR:laurentd75	*/
/****************************/

#include "globals.h"

/* Scripts for map room */

#define EXIT 		200
#define POSTER 		201
#define COMPUTER 	202
#define PRINTER		203
#define BOOKS		204
#define BOXES		205
#define MUGS		206

#define STDESC		200

stringpack STDESC
{
#ifdef ENGLISH
	/*+++++++++++++++++++++++++++++++++++++*/
	"I am sure I played that long time ago.";
	"You had to rescue a damsel who had";
	"been kidnapped by a giant ape.";
	"The monster threw barrels and other";
	"things at you as you climbed up.";
	"It was quite fun!";
	"And more difficult than this game.";
	"Now concentrate on our task, please.";
	
	//8
	"I wouldn't know how to use it.";
	
	"A printer. A small model.";
	"There is a printout on the tray";
	"I cannot do that.";
	
	//12
	"A good collection of sci-fi books.";
	"Strange looking boxes.";
	"Mugs of all sizes with nerd symbols.";	
	
	//15
	"Not without the map!";
#endif

#ifdef FRENCH
	/*+++++++++++++++++++++++++++++++++++++*/
	"J'ai déja joué a ca il y a longtemps.";
	"Il fallait secourir une demoiselle qui";
	"avait été capturée par un singe géant.";
	"Le monstre vous lancait des tonneaux";
	"et d'autres objets tandis que vous"; 
	"essayiez de grimper. C'était amusant!";
	"Et bien plus difficile que ce jeu-la..";
	"Mais concentrons-nous ici maintenant!";
	
	//8
	"Je ne saurais pas comment l'utiliser.";
	
	"Une imprimante. De petit format.";
	"Il y a une impression dans le bac.";
	"Je ne peux pas faire cela.";
	
	//12
	"Une belle collection de livres de SF.";
	"Des boites a l'aspect tres bizarre.";
	"Des mugs avec des symboles de geeks.";	
	
	//15
	"Pas sans le plan!";
#endif

#ifdef SPANISH
	/*+++++++++++++++++++++++++++++++++++++*/
	"Jugué a ese juego hace mucho tiempo.";
	"Tenías que rescatar a una dama que";
	"tenía capturada un gorila gigante.";
	"El monstruo te lanzaba barriles";
	"según tu intentabas trepar.";
	"¡Era muy divertido!";
	"Y más difícil que este juego.";
	"Ahora concéntrate en esto, venga.";
	
	//8
	"No sabría cómo usarlo.";
	
	"Una impresora. Un modelo pequeño.";
	"Hay una hoja impresa en la bandeja.";
	"No puedo hacer eso.";
	
	//12
	"Una buena colección de ci-fi.";
	"Cajas de lo más extraño.";
	"Tazas con símbolos de lo más friki.";	
	
	//15
	"¡No sin el mapa!";
#endif
}


objectcode EXIT
{
	byte actor;
	WalkTo:
		actor=sfGetActorExecutingAction();
		/* Prevent the player to exit without taking the map
		if it has been printed. */
		if(actor==BLAKE && bMapPrinted && !bGotMap)
		{
			scActorTalk(BLAKE,STDESC,15);
			scWaitForActor(BLAKE);
			scStopScript();
		}
		scSetPosition(actor, ROOM_HALLWAY, 13, 95);
		scLookDirection(actor, FACING_DOWN);
		scChangeRoomAndStop(ROOM_HALLWAY);
}

objectcode POSTER
{
	byte i;
	
	LookAt:
		scCursorOn(false);
		i=0;
	loopdesc:
		/* Use a goto, because loops are not working
		in the compiler when inside object code */
		scActorTalk(BLAKE, STDESC, i);
		scWaitForActor(BLAKE);
		i=i+1;
		if(i<=7) goto loopdesc;
		scCursorOn(true);
		scStopScript();
}

objectcode COMPUTER
{
	
	Use:
		if (sfGetActionObject2()!=255) { scSpawnScript(1); scStopScript();}	
	LookAt:
		scActorTalk(BLAKE,STDESC,8);
		scWaitForActor(BLAKE);
		scStopScript();
}

objectcode PRINTER
{
	LookAt:
		scCursorOn(false);
		scActorTalk(BLAKE,STDESC,9);
		scWaitForActor(BLAKE);
		if(bMapPrinted)
		{
			scActorTalk(BLAKE,STDESC,10);
			scWaitForActor(BLAKE);
		}
		scCursorOn(true);
		scStopScript();
	Use:
		if (sfGetActionObject2()!=255) { scSpawnScript(1); scStopScript();}	
	PickUp:
		if(bMapPrinted)
		{
			bGotMap=true;
			bMapPrinted=false;
			scTerminateScript(210);
			scSetAnimstate(PRINTER,0);
			scPutInInventory(MAP);
			bMapContactGiven=false; // Cannot enter again
		}
		else
		{
			scActorTalk(BLAKE,STDESC,11);
			scWaitForActor(BLAKE);
		}
		scStopScript();
}

objectcode BOOKS
{
	LookAt:
		scActorTalk(BLAKE,STDESC,12);
		scWaitForActor(BLAKE);		
		scStopScript();
}

objectcode BOXES
{
	LookAt:
		scActorTalk(BLAKE,STDESC,13);
		scWaitForActor(BLAKE);		
		scStopScript();
}

objectcode MUGS
{
	LookAt:
		scActorTalk(BLAKE,STDESC,14);
		scWaitForActor(BLAKE);		
		scStopScript();
}

// Printer light when ready
script 210{
	scSetAnimstate(PRINTER,1);
	scDelay(25);
	scSetAnimstate(PRINTER,0);
	scDelay(25);
	scRestartScript();
}

/* Let's test these as local */
/* Dialog with man */
#define DIALOG_1		200
#define DIALOG_2		201
#define DIALOG_SCRIPT		201
#define DIALOG_SCRIPT2 		202
#define MAN1 			INFOMAN
#define DIALOG_STRINGS 		201
#define DIALOG_OPTIONS  	202
#define DIALOG_OPTIONS2  	203


/* Script to handle giving him our mug for trade. Called from object code */
script 250
{
	byte i;
	
	// If the player has not talked to the man before, launch the dialog.
	if(!bTradeInitiated)
	{
		scActorTalk(MAN1, DIALOG_STRINGS,1);
		scWaitForActor(MAN1);
		scLoadDialog(DIALOG_1);
		scStartDialog();
		scStopScript();
	}

	scCursorOn(false);
	if(sfGetActionObject1()!=MUG)
	{
		// No mug, no deal
		for(i=2;i<=4;i=i+1)
		{
			scActorTalk(MAN1, DIALOG_STRINGS,i);
			scWaitForActor(MAN1);		
		}
		scCursorOn(true);
		scStopScript();
	}
		
	// If it is not the first time, do not say all the dialog.
	if(!bMugGiven)
	{
		// Deal
		for(i=5;i<=7;i=i+1)
		{
			scActorTalk(MAN1, DIALOG_STRINGS,i);
			scWaitForActor(MAN1);		
		}	
		bMugGiven=true;
		scSave();
	}
	else
	{
		scActorTalk(MAN1, DIALOG_STRINGS,16);
		scWaitForActor(MAN1);						
	}
	scActorTalk(MAN1, DIALOG_STRINGS,17);
	scWaitForActor(MAN1);						
	/* Start dialog for exit number */
	scLoadDialog(DIALOG_2);
	bWrongMapExit=false;
	scStartDialog();
	/* The dialog is run as a separate thread in paralell, so 
	to make this one wait for it to finish, we need to use synchronization
	with events. */
	scClearEvents(1);
	scWaitEvent(1);
	/* At this point the dialog has finished and we have
	bWrongMapExit set to true or false depending on the user
	input. */
	//scCursorOn(false);
	scLookDirection(MAN1,FACING_UP);
	scDelay(50);
	if(bWrongMapExit)
	{
		scActorTalk(MAN1,DIALOG_STRINGS,20);
		scWaitForActor(MAN1);
		scLookDirection(MAN1,FACING_RIGHT);
		scActorTalk(MAN1,DIALOG_STRINGS,21);
		scWaitForActor(MAN1);								
	}
	else
	{
		scActorTalk(MAN1,DIALOG_STRINGS,18);
		scWaitForActor(MAN1);
		scActorTalk(MAN1,DIALOG_STRINGS,19);
		scWaitForActor(MAN1);	
		scDelay(50);
		scLookDirection(MAN1,FACING_RIGHT);
		scActorTalk(MAN1,DIALOG_STRINGS,8);
		scWaitForActor(MAN1);
		bMapPrinted=true;
		scSpawnScript(210);
		scRemoveFromInventory(MUG);
		scRemoveObjectFromGame(MUG);
		scSave();
	}
	scEndDialog();
	scCursorOn(true);
}
	

dialog DIALOG_2: script DIALOG_SCRIPT2 stringpack DIALOG_OPTIONS2{
#ifdef ENGLISH
	option "Yes, it's one hundred..." active -> goodh;
	option "Yes, it's two hundred..." active -> badh;
	option "Yes, it's three hundred..." active -> badh;
	option "Yes, it's four hundred..." active -> badh;

	option "... and twenty..." inactive ->badd;
	option "... and thirty..." inactive ->badd;
	option "... and forty..." inactive ->badd;
	option "... and fifty..." inactive ->badd;
	option "... and sixty..." inactive ->badd;
	option "... and seventy..." inactive ->goodd;
	
	option "... one!" inactive ->badu;
	option "... two!" inactive ->goodu;
	option "... three!" inactive ->badu;
	option "... four!" inactive ->badu;
	option "... five!" inactive ->badu;
#endif
#ifdef FRENCH
	option "Oui, c'est cent..." active -> goodh;
	option "Oui, c'est deux cent..." active -> badh;
	option "Oui, c'est trois cent..." active -> badh;
	option "Oui, c'est quatre cent..." active -> badh;

	option "... vingt..." inactive ->badd;
	option "... trente..." inactive ->badd;
	option "... quarante..." inactive ->badd;
	option "... cinquante..." inactive ->badd;
	option "... soixante..." inactive ->goodd;  // [laurentd75] : changed return value from "badd" to "goodd"
	// [laurentd75] NOTE: for the French version I chose to replace 172 by 162
	// (as the code from the dog-eared page number in "blakesroom.os" script) 
	// so that the number spelling rules will work.
	// (the problem in French is that for the seventies numbers the units are spelt irregularly, see below)
	// Therefore, I also chose to REMOVE the choice of seventies numbers for the French version
	// ... But still had to provide a 6th option otherwise there is a graphical bug (copyright sign displayed on last line)
	// ... So I chose the "eighties" numbers as the units are spelt regularly
	//option "... soixante-dix..." inactive ->goodd;  // [laurentd75]: commented out, see above
	option "... quatre-vingt..." inactive ->badd;  // [laurentd75]: need to add 6 options otherwise graphic bug
	// [laurentd75]: this won't work in French for numbers 71..75:
	// 71 is spelt "soixante et onze", not "soixante-dix et un"... 
	// ... same thing thru to 75, spelt "soixante quinze", rather than "soixante-dix cinq" !! :-(
	// Which is why I commented out the choice of "seventy" for the tens above
	option "... et un!" inactive ->badu; 
	option "... deux!" inactive ->goodu;
	option "... trois!" inactive ->badu;
	option "... quatre!" inactive ->badu;
	option "... cinq!" inactive ->badu;
#endif
#ifdef SPANISH
	option "¡Sí, es ciento..." active -> goodh;
	option "¡Sí, es doscientos..." active -> badh;
	option "¡Sí, es trescientos..." active -> badh;
	option "¡Sí, es cuatrocientos..." active -> badh;

	option "... veinti..." inactive ->badd;
	option "... treinta y..." inactive ->badd;
	option "... cuarenta y..." inactive ->badd;
	option "... cincuenta y..." inactive ->badd;
	option "... sesenta y..." inactive ->badd;
	option "... setenta y..." inactive ->goodd;
	
	option "... uno!" inactive ->badu;
	option "... dos!" inactive ->goodu;
	option "... tres!" inactive ->badu;
	option "... cuatro!" inactive ->badu;
	option "... cinco!" inactive ->badu;
#endif
}

script DIALOG_SCRIPT2
{
	actd:
		scActivateDlgOption(0,false);
		scActivateDlgOption(1,false);
		scActivateDlgOption(2,false);
		scActivateDlgOption(3,false);

		scActivateDlgOption(4,true);
		scActivateDlgOption(5,true);
		scActivateDlgOption(6,true);
		scActivateDlgOption(7,true);
		scActivateDlgOption(8,true);
		scActivateDlgOption(9,true);
		scWaitForActor(BLAKE);		
		scStartDialog();
		scStopScript();
	actu:
		scActivateDlgOption(4,false);
		scActivateDlgOption(5,false);
		scActivateDlgOption(6,false);
		scActivateDlgOption(7,false);
		scActivateDlgOption(8,false);
		scActivateDlgOption(9,false);
		
		scActivateDlgOption(10,true);
		scActivateDlgOption(11,true);
		scActivateDlgOption(12,true);
		scActivateDlgOption(13,true);
		scActivateDlgOption(14,true);
		scWaitForActor(BLAKE);		
		scStartDialog();
		scStopScript();
	
	export badh:
		bWrongMapExit=true;
	export goodh:
		goto actd;
	export badd:
		bWrongMapExit=true;
	export goodd:
		goto actu;
	export badu:
		bWrongMapExit=true;
	export goodu: 
		scWaitForActor(BLAKE);	
		//scEndDialog();
		scSetEvents(1);
		scStopScript();	 
}


dialog DIALOG_1: script DIALOG_SCRIPT stringpack DIALOG_OPTIONS{
#ifdef ENGLISH
	option "Aren't you the guy of the info desk?" active -> seenhim;
	option "I need info on the city exits." active -> exits;
	option "Nothing, thank you." active -> bye;
#endif

#ifdef FRENCH
	option "Vous etes la personne de l'accueil non?" active -> seenhim;
	option "J'ai besoin d'infos sur les sorties." active -> exits;
	option "Rien, merci." active -> bye;
#endif

#ifdef SPANISH
	option "¿No eres el tipo de información?" active -> seenhim;
	option "Necesito datos de las salidas." active -> exits;
	option "Nada, gracias." active -> bye;
#endif
}

/* Script that controls the dialog above */
script DIALOG_SCRIPT{
	byte i;
export seenhim:
	for(i=10;i<=12;i=i+1)
	{
		scActorTalk(MAN1, DIALOG_STRINGS,i);
		scWaitForActor(MAN1);		
	}
	scActivateDlgOption(0,false);
	scStartDialog();
	scStopScript();
export exits:
	for(i=13;i<=15;i=i+1)
	{
		scActorTalk(MAN1, DIALOG_STRINGS,i);
		scWaitForActor(MAN1);		
	}	
	bTradeInitiated=true;
	scSave();
	scEndDialog();
	scStopScript();
export bye:
	scActorTalk(MAN1, DIALOG_STRINGS,9);
	scWaitForActor(MAN1);
	scEndDialog();
}

stringpack DIALOG_STRINGS
{
#ifdef ENGLISH
	// Description and initial sentences
	/*++++++++++++++++++++++++++++++++++++++*/
	"I have seen this face before.";
	"Hello. Looking for something?";
	
	//2
	//"Mmmm...";
	//"I'm not interested in that.";
	//"Anything else?";
	"What?";
	"What would I want that for?";
	"I already told you: 100 credits.";
	
	//5
	"Hey!!";
	"That one is missing in my collection!";
	"You have a deal. One second.";
	"Your map is printed. Take it.";
	
	//9
	"Okay. I'm always ready to trade.";
	
	//10
	"Uh... well...";
	"No. He looks like me, but he wouldn't";
	"be involved in anything... un-legal.";
	
	//13
	"I could provide that information...";
	//"but you'll need to have something to";
	//"trade. Make an offer.";
	"but it would cost you 100 credits.";
	"A fair price, if you ask me.";
	
	//16
	"Ah, you are back. Good.";
	"Tell me the exit number.";
	
	// 18
	"This one seems to be quite near...";
	"Okay, I'll get the mug..."; // [laurentd75]: should be "I'll take" instead of "I'll get" !
	
	//20
	"Mmmm... something's wrong.";
	"Can't find that exit number";
	
	//22
	"Your map is in the printer.";
#endif

#ifdef FRENCH
	// Description and initial sentences
	/*++++++++++++++++++++++++++++++++++++++*/
	"J'ai déja vu ce visage quelque part...";
	"Bonjour, vous cherchez quelque chose?";
	
	//2
	"Comment?";
	"Et pourquoi aurais-je besoin de ca?";
	"Je vous l'ai déja dit: 100 crédits.";
	
	//5
	"Hé!!";
	"Celui-ci manque a ma collection!";
	"Marché conclu. Un instant.";
	"Votre plan est imprimé. Prenez-le.";
	
	//9
	"Ok. Je suis toujours pret a négocier.";
	
	//10
	"Héhé... et bien, en fait...";
	"Non. Il me ressemble, mais lui, il ne";
	"ferait jamais rien... d'illégal...";
	
	//13
	"Je peux vous fournir cette information.";
	"... mais ca vous coutera 100 crédits.";
	"Un prix tres honnete, selon moi.";
	
	//16
	"Ah, vous etes de retour. Tres bien.";
	"Donnez-moi le numéro de la sortie.";
	
	// 18
	"Celle-ci semble etre assez proche...";
	"D'accord, je prends le mug..."; // [laurentd75]: NB: ES and EN versions differ on this one !!??
	
	//20
	"Hmmm... il y a un probleme.";
	"Je ne trouve pas ce numéro de sortie.";
	
	//22
	"Votre plan est a l'imprimante.";
#endif

#ifdef SPANISH
	// Description and initial sentences
	/*++++++++++++++++++++++++++++++++++++++*/
	"He visto esa cara antes.";
	"Hola ¿buscas algo?";
	
	//2
	"¿Qué?";
	"¿Para qué querría yo eso?";
	"Ya te dije. 100 créditos.";
	
	//5
	"¡Eh!";
	"¡Ese no lo tengo en la colección!";
	"Trato hecho. Un segundo.";
	"Tu mapa está listo. En la impresora.";
	
	//9
	"Siempre estoy dispuesto a negociar.";
	
	//10
	"Eh... bueno...";
	"No. Se parece a mi, pero no estaría";
	"involucrado en nada... alegal.";
	
	//13
	"Podría darte información...";
	"perto te costará 100 créditos.";
	"Un precio justo, si me preguntas.";
	
	//16
	"Ah, estás de vuelta. Bien.";
	"Dime el número de la salida.";
	
	// 18
	"Mira, esa está aquí cerca...";
	"De acuerdo, me quedo con la taza...";
	
	//20
	"Mmmm. Hay algo mal.";
	"No encuentro ese número de salida.";
	
	//22
	"Tienes el mapa en la impresora.";
#endif

}

