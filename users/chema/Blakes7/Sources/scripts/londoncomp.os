/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR:laurentd75	*/
/****************************/

#include "globals.h"

/* Scripts and other things for the computer room in the London*/

#define ST_MAIN 200
#define ST_LEYSTART 6
#define ST_BLAKEPART 10

script 200{
	// When testing as we jump here, Avon has not been
	// loaded
	scLoadObjectToGame(AVON);
	
	// Bring Blake and Avon here
	scSetPosition(BLAKE, ROOM_LONDONCOMP, 14, 7);
	scSetPosition(AVON, ROOM_LONDONCOMP, 15, 4);
	scLookDirection(AVON,FACING_RIGHT);
	scLookDirection(BLAKE,FACING_RIGHT);
	// The entry script should launch a script to 
	// deal with the scene
	scSpawnScript(201);
	
}

script 201{
	byte i;
	scDelay(20);
	
	for(i=0;i<6;i=i+2){
		scActorTalk(AVON,ST_MAIN,i);
		scWaitForActor(AVON);
		if(i==0){
			scActorWalkTo(AVON, 19,14);
			scWaitForActor(AVON);
			scLookDirection(AVON,FACING_UP);
		}
		scActorTalk(BLAKE,ST_MAIN,i+1);
		scWaitForActor(BLAKE);
		
		if(i==0){
			// Door Closes
			scLoadObjectToGame(201);
			scPlaySFX(SFX_DOOR);
			scDelay(10);
			scSetAnimstate(201,1);
		}
		
		if(i==2){
			// Avon goes to the other panel
			scDelay(50);	
			scPlaySFX(SFX_CHUIC);
			scDelay(5);
			scPlaySFX(SFX_CHUIC);
			scActorWalkTo(AVON,23,15);
			scWaitForActor(AVON);
			scLookDirection(AVON, FACING_RIGHT);
			scDelay(50);
			scLookDirection(AVON, FACING_LEFT);
			scPlaySFX(SFX_SUCCESS);
		} 
	}
	scDelay(30);
	
	// Leylan talks
	scPlaySFX(SFX_BEEPLE);
	scLoadObjectToGame(200);
	scSetAnimstate(200,0);
	scSpawnScript(210);
	for(i=6;i<10;i=i+1){
		scPrint(ST_MAIN,i);
		scDelay(120);
		if(i==6){
			scActorWalkTo(BLAKE,8,14);
			scActorWalkTo(AVON,18,15);
		}
	}
	scTerminateScript(210);
	scSetAnimstate(200,0);
	scDelay(30);
	
	for(i=10;i<20;i=i+1){
		scActorTalk(BLAKE,ST_MAIN,i);
		scWaitForActor(BLAKE);
		if(i==13 || i==14 || i==10) scDelay(50);
	}
	
	scDelay(50);
	scSpawnScript(210);
	for(i=20;i<26;i=i+1){
		scPrint(ST_MAIN,i);
		scDelay(120);
	}
	scTerminateScript(210);
	scSetAnimstate(200,0);	
	scRemoveObjectFromGame(200);
	scPlaySFX(SFX_BEEPLE);
	scDelay(30);
	
	// They surrender
	scActorTalk(BLAKE,ST_MAIN,26);
	scWaitForActor(BLAKE);
	scDelay(20);
	scLookDirection(BLAKE,FACING_LEFT);
	scActorTalk(BLAKE,ST_MAIN,27);
	scWaitForActor(BLAKE);
	scActorTalk(AVON,ST_MAIN,28);
	scWaitForActor(AVON);
	scActorTalk(BLAKE,ST_MAIN,29);
	scWaitForActor(BLAKE);
	
	for(i=30;i<36;i=i+1){
		scActorTalk(AVON,ST_MAIN,i);
		scWaitForActor(AVON);
	}
	
	scLookDirection(BLAKE,FACING_RIGHT);
	scDelay(20);
	
	scActorTalk(BLAKE,ST_MAIN,36);
	scWaitForActor(BLAKE);
	scActorTalk(AVON,ST_MAIN,37);
	scWaitForActor(AVON);	
	scActorTalk(AVON,ST_MAIN,38);
	scWaitForActor(AVON);	
	
	scActorTalk(BLAKE,ST_MAIN,39);
	scWaitForActor(BLAKE);
	scActorTalk(AVON,ST_MAIN,40);
	scWaitForActor(AVON);	
	scActorTalk(BLAKE,ST_MAIN,41);
	scWaitForActor(BLAKE);	
	
	scPlaySFX(SFX_THRILL1);
	scDelay(70);
	scSetBWPalette();
	scDelay(70);
	scClearRoomArea();
	scChangeRoomAndStop(ROOM_LONDONDECK);
	//scFadeToBlack(); Can't fade due to inverse attrs.
}

stringpack ST_MAIN{
#ifdef ENGLISH
	"Okay, let's do it.";
	"Lock the door!";
	"Sure. Done.";
	"Hurry up!";
	"The computer is under our control.";
	"Let's wait for news from the others.";
	
	// 6
	/***************************************/
	" Blake, this is Commander Leylan.";
	" We have arrested your gang.";
	" Your plan is a failure. Surrender now,";
	" and you'll be treated leniently.";

	//10
	"Those are your terms?            ";  // Extra spaces to erase the previous line
	"These are mine. You will hand over all";
	"your weapons to my men. Whilst we hold";
	"the computer, the ship is helpless.";
	"It'll remain that way until you agree.";
	"You will then fly this ship to the";
	"nearest habitable planet where we will";
	"disembark. Any attempt by your men to";
	"break into this room and we'll destroy";
	"the computer. Totally. That's all.";
	
	//20
	" Nice try. But listen.";
	" I'm going to kill one of your friends";
	" every thirty seconds starting now.";
	" I'll stop when you give yourselves up,";
	" or I run out of prisoners.";
	" The talking's over, Blake.";
	
	//26
	"You can't do that! Leylan!";
	"I've failed. Let's open the door.";
	"You're throwing away our only chance.";
	"Open the door!";
	
	//30
	/***************************************/
	"What a fiasco. You could take over the";
	"ship, you said, if I did my bit.";
	"Well, I did my bit, and what happened?";
	"Your troops bumble around looking for";
	"someone to surrender to, and when";
	"they've succeeded, you follow suit.";
	
	"I'll try and do better next time.";
	"We had one chance. You wasted it.";
	"There won't be a next time.";
	"In which case, you can die content.";
	"Content...";
	"Knowing you were right.";
#endif

#ifdef FRENCH
	"Ok, allons-y.";
	"Verrouille la porte!";
	"C'est fait.";
	"Dépeche-toi!";
	"Nous controlons l'ordinateur.";
	"Attendons des nouvelles des autres.";
	
	// 6
	/***************************************/
	" Blake, ici le Commandeur Leylan.";
	" Nous avons arreté votre gang.";
	" Votre plan est un échec. Rendez-vous,";
	" et vous serez traités avec indulgence.";

	//10
	"Ce sont donc vos conditions?           ";  // Extra spaces to erase the previous line
	"Voici les notres. Déposez vos armes.";
	"Tant que nous controlons l'ordinateur,";
	"ce vaisseau est perdu, et le restera";
	"jusqu'a ce que vous vous rendiez.";
	"Vous nous conduirez ensuite jusqu'a";
	"la planete habitable la plus proche,";
	"et vous nous débarquerez. Si vous";
	"tentez d'accéder a cette salle, nous";
	"détruirons l'ordinateur. C'est tout.";
	
	//20
	" Bien essayé. Mais écoutez plutot: je";
	" vais tuer l'un de vos amis toutes les";
	" 30 secondes a partir de maintenant.";
	" J'arreterai lorsque vous vous rendrez";
	" ou lorsque je les aurai tous tués.";
	" La discussion est terminée, Blake.";
	
	//26
	"Vous ne pouvez pas faire ca! Leylan!";
	"Nous avons échoué. Ouvrons la porte.";
	"Mais on va perdre notre seule chance!";
	"Ouvre la porte!";
	
	//30
	/***************************************/
	"Quel fiasco. Tu disais qu'on pouvait";
	"s'emparer du vaisseau si je jouais mon";
	"role. Et bien je l'ai fait et qu'est-il";
	"advenu? Ta petite troupe fait n'importe"; // "advenu? Ton équipe flane, cherchant a";
	"quoi et finit par se faire prendre,";     // "qui se rendre, et quand ils arrivent";
	"et toi, tu leur emboites le pas...";      // "a leur fin, tu leur emboites le pas.";

	"Je ferai mieux la prochaine fois.";
	"Il n'y aura pas de prochaine fois.";  // [laurentd75]: it's better to put this sentence before the following one
	"On avait une chance et tu l'as gachée.";
	"Dans ce cas, tu peux mourir heureux...";
	"Heureux?";
	"...De savoir que tu avais raison.";
#endif

#ifdef SPANISH
	"Venga. Vamos a hacerlo.";
	"¡Cierra la puerta!";
	"Listo.";
	"¡Deprisa!";
	"La computadora es nuestra.";
	"Esperemos noticias del resto.";
	
	// 6
	/***************************************/
	" Blake, soy el Comandante Leylan.";
	" Hemos arrestado a tu banda.";
	" Tu plan es un fracaso, ríndete";
	" y serás tratado con indulgencia.";

	//10
	"Esos son tus términos?           "; // Extra spaces to erase the previous line
	"Estos los míos. Entregarás las armas";
	"a mis hombres. Mientras controlemos la";
	"computadora, la nave está perdida.";
	"Y así estará hasta que cedas.";
	"Luego nos llevarás al planeta más";
	"cercano donde podamos desembarcar.";
	"Si intentan entrar tus hombres aquí,";
	"destruiremos la computadora.";
	"Totalmente. Eso es todo.";
	
	//20
	" Buen intento. Pero escucha.";
	" Voy a matar a uno de tus amigos cada";
	" treinta segundos desde ahora.";
	" Pararé cuando os rindáis o me quede,";
	" sin prisioneros.";
	" Se acabó la conversación, Blake.";
	
	//26
	"¡No puedes hacer eso! Leylan!    ";
	"He fallado. Abre.";
	"¿Y perder nuestra única oportunidad?";
	"¡Abre la puerta!";
	
	//30
	/***************************************/
	"Qué fiasco. Podías hacerte con la nave";
	"dijiste, si hacía mi parte.";
	"Lo hice y ¿qué pasó?";
	"Tus tropas van de acá para allá";
	"buscando alguien a quien rendirse y";
	"cuando lo consiguen, tu vas detrás.";
	
	"Intentaré hacerlo mejor a la próxima.";
	"Hubo una oportunidad. Desperdiciada.";
	"No habrá otra.";
	"En ese caso podrás morir contento.";
	"Contento...";
	"Sabiendo que tenías razón.";
#endif
}

script 210{
	scDelay(5);
	scSetAnimstate(200,sfGetRandInt(0,2));
	scDelay(3);
	scDelay(sfGetRandInt(1,3));		
	scSetAnimstate(200,0);
	//scDelay(sfGetRandInt(1,3));
	scRestartScript();
}
