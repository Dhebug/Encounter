
/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR:laurentd75	*/
/****************************/

#include "globals.h"

#define STTUTO 	250

#define DOOR		200
#define DRAWER		202
#define LAMP		203
#define BOOK		204
#define BALL		205
#define PICTURE		206
#define SCREEN		207


/* Tutorial */

#define PART1E 	20
#define PART2I	23
#define PART2E	26
#define PART3I	27
#define PART3E	29

script 30{
	byte i;
	
	scCursorOn(false);
	scSetOverrideJump(there);

	for (i=0;i<=PART1E;i=i+1){
		scActorTalk(BLAKE,STTUTO,i);
		scWaitForActor(BLAKE);
	}
	
loop:
	scCursorOn(true);
	while (sfIsNotMoving(BLAKE)){
		scDelay(10);
	}
	
	if ( (sfGetActionVerb()!=VERB_LOOKAT) || (sfGetActionObject1()!=PICTURE)){
		scCursorOn(false);
		scStopCharacterAction(BLAKE);
		scActorWalkTo(BLAKE,14,13);
		scWaitForActor(BLAKE);
		scLookDirection(BLAKE,FACING_DOWN);
		scActorTalk(BLAKE,STTUTO,21);
		scWaitForActor(BLAKE);
		scActorTalk(BLAKE,STTUTO,22);
		scWaitForActor(BLAKE);
		goto loop;
	}
	
	scCursorOn(false);
	scWaitForActor(BLAKE);
	scBreakHere();
	scWaitForActor(BLAKE);
	
	scLookDirection(BLAKE,FACING_DOWN);
	scBreakHere();
	
	for (i=PART2I;i<=PART2E;i=i+1){
		scActorTalk(BLAKE,STTUTO,i);
		scWaitForActor(BLAKE);
	}
	scWaitForActor(BLAKE);
	
there:
	for (i=PART3I;i<=PART3E;i=i+1){
		scActorTalk(BLAKE,STTUTO,i);
		scWaitForActor(BLAKE);
	}

	scCursorOn(true);
	scStopScript();
}


/* Strings for this script */
stringpack 250{
#ifdef ENGLISH
	/**************************************/
	"Before you start playing, let me show";
	"you something about the mechanics of";
	"this game.";
	"You can press ESC to skip this intro.";
	"The user interface is the usual point";
	"and click system of graphic adventures,";
	"with 9 commands. By default, clicking";
	"anywhere on the screen will make me";
	"walk there, if possible. You don't";
	"have to direct me. I'll find my way.";
/*	
	"Selecting an action and clicking on";
	"an object will make me go to there,";
	"if needed, and perform the command.";
	"The current command is composed in";
	"a sentence shown below the picture.";
*/	
	"As most Oric users do not have a mouse";
	"in addition to this method, you can";
	"use shortcuts to actions.";
	"Each verb is assigned a number, from";
	"left to right, top to bottom, so";
	"'Give' is 1, 'Use' is 3 or 'Close' 7.";
	"If you hover the cursor over an object";
	"and press a number, the corresponding";
	"action will be executed.";
	"Look at the picture on your right.";
	"Hover the cursor over it, and press 5.";
	
	//21
	"Select the picture and press 5 to look";
	"at it, please.";
	
	//23
	"Easy, isn't it? You could redefine the";
	"keys to move the cursor with one hand";
	"and give commands with the other.";
	
	"But it is up to you...";
	
	"Now, let's go out and find Ravella.";
	"I have to talk to her about my family.";
	"I fear something is wrong with them.";
#endif

#ifdef FRENCH
	/**************************************/
	"Mais avant de commencer, laissez-moi";
	"vous présenter les mécanismes de base";
	"de ce jeu.";
	"Pour sauter cette intro, pressez ESC.";
	"Le jeu utilise l'interface pointer-";
	"cliquer classique des jeux d'aventure,";
	"avec 9 commandes. Par défaut, cliquer";
	"un point à l'écran a pour effet de m'y";
	"faire déplacer, si c'est possible.";
	"Et je trouve le chemin tout seul!";
/*	
	"Selecting an action and clicking on";
	"an object will make me go to there,";
	"if needed, and perform the command.";
	"The current command is composed in";
	"a sentence shown below the picture.";
*/	
	"Comme presqu'aucun utilisateur Oric";
	"n'a de souris, il y a aussi des";
	"raccourcis-clavier pour les actions.";
	"A chaque verbe est associé un numéro,";
	"de gauche à droite et de haut en bas:";
	"1='Donne', 3='Utilise', 7='Ferme'.";
	"Si vous positionnez le curseur sur un";
	"objet et appuyez sur un chiffre,";
	"l'action associée sera exécutée.";
	"Regardez la photo à votre droite.";
	"Déplacez-y le curseur et appuyez sur 5.";
	
	//21
	"Sélectionnez la photo et appuyez sur 5";
	"pour la regarder, s'il vous plaît.";
	
	//23
	"Facile, n'est-ce pas? Vous pouvez";
	"redéfinir les touches de déplacement";
	"et de commande à votre guise.";
	
	"A vous de voir ce qui vous convient...";
	
	"Allons voir Ravella maintenant. Je dois";
	"lui parler de ma famille, j'ai peur qu'";
	"il ne leur soit arrivé quelque chose...";
#endif


#ifdef SPANISH
	/**************************************/
	"Antes de empezar deja que te enseñe";
	"algo acerca de la mecánica de este";
	"juego.";
	"Pulsa ESC para saltar esta intro.";
	"La interfaz es la típica de apuntar";
	"y pulsar de las aventuras gráficas,";
	"con 9 comandos. Por defecto haciendo";
	"clic en cualquier sitio hará que";
	"camine allí, si es posible. No tienes";
	"que dirigirme. Encuentro yo el camino.";
/*	
	"Selecting an action and clicking on";
	"an object will make me go to there,";
	"if needed, and perform the command.";
	"The current command is composed in";
	"a sentence shown below the picture.";
*/	
	"Como casi ningún usuario de Oric tiene";
	"ratón, también se pueden usar atajos";
	"de teclado para los comandos.";
	"Cada uno tiene asignado un número de";
	"izquierda a derecha y de arriba a abajo";
	"'Dale' es 1, 'Usa' es 3 o 'Cierra' 7.";
	"Si pasas el cursor por un objeto y";
	"pulsas un número, la acción asociada";
	"se ejecutará sobre el objeto.";
	"Mira a la fotografía de tu derecha.";
	"Pon el cursor sobre ella y pulsa 5.";
	
	//21
	"Selecciona la foto y pulsa 5 para";
	"mirarla, por favor.";
	
	//23
	"Fácil, ¿no?. Puedes redefinir las";
	"teclas para moverte con una mano y";
	"dar comandos con la otra.";
	
	"Pero depende de tí...";
	
	"Ahora vamos a por Ravella.";
	"Tengo que hablar con ella.";
	"Temo que algo va mal con mi familia.";
#endif



}
