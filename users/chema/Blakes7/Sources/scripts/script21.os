/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/****************************/

#include "globals.h"

#define STLOCAL 	2	// We'll re-use id

#define ZENSTART	6

/* Final sequences	*/
script 21{
	byte i;	
	byte actor;

	scSave();

	scLockResource(RESOURCE_STRING,STLOCAL);
	scShowVerbs(false);	
	scSetCostume(BLAKE,0,0);
	scSetCostume(JENNA,1,0);
	scSetCostume(VILA,10,0);
	scSetCostume(GAN,12,0);
	scSetCostume(CALLY,13,0);
	scSetPosition(AVON, ROOM_LIBZEN, 15,19);
	scSetAnimstate(AVON,0);
	scLookDirection(AVON,FACING_RIGHT);
	scSetPosition(BLAKE, ROOM_LIBZEN, 14,5);
	scLookDirection(BLAKE,FACING_DOWN);	
	scFollowActor(BLAKE);
	tmpParam1=0; // To avoid any automatic action when entering room
	scLoadRoom(ROOM_LIBZEN);
	scBreakHere();
	scActorWalkTo(BLAKE,8,15);
	scWaitForActor(BLAKE);
		

	// Zen detects pursuit ships...
/*	
	tmpParam1=ZENSTART;
	scChainScript(202);
	scLookDirection(AVON,FACING_RIGHT);
	tmpParam1=ZENSTART+1;
	scChainScript(202);
	scDelay(30);
	tmpParam1=ZENSTART+2;
	scChainScript(202);
	tmpParam1=ZENSTART+3;
	scChainScript(202);
*/

	for (i=0;i<=10;i=i+1){
		if ((i==0)||(i==2)||(i==4)||(i==5)||(i==8)||(i==10)) actor=BLAKE;
		else actor=AVON;
		scActorTalk(actor,STLOCAL,i);
		scWaitForActor(actor);
		if((i==0)||(i==2)||(i==5)) scLookDirection(AVON,FACING_LEFT);
		if(i==3){
			scLookDirection(AVON,FACING_UP);
			scDelay(20);
			scActorWalkTo(BLAKE,10,15);
			scLookDirection(BLAKE,FACING_RIGHT);
		}
		if(i==7) scLookDirection(AVON,FACING_RIGHT);
		if((i==3)||(i==6) || (i==7) || (i==9)) scDelay(30);
	}

	scLookDirection(AVON, FACING_UP);
	scDelay(20);

	scActorTalk(BLAKE,STLOCAL,11);
	scWaitForActor(BLAKE);
	scLookDirection(AVON,FACING_RIGHT);
	scBreakHere();
	scActorTalk(AVON,STLOCAL,12);
	scWaitForActor(AVON);
	scActorTalk(BLAKE,STLOCAL,13);
	scWaitForActor(BLAKE);
	scDelay(20);
	scLookDirection(AVON,FACING_LEFT);
	scActorTalk(AVON,STLOCAL,14);
	scWaitForActor(AVON);
	scActorTalk(AVON,STLOCAL,15);
	scWaitForActor(AVON);
	scActorTalk(BLAKE,STLOCAL,16);
	scWaitForActor(BLAKE);	
	tmpParam1=13;
	scChainScript(202);	
	scActorTalk(BLAKE,STLOCAL,17);
	scWaitForActor(BLAKE);	
	scActorTalk(BLAKE,STLOCAL,18);
	scWaitForActor(BLAKE);	
	tmpParam1=10;
	scChainScript(202);	
	
	// This is the end, but for the epilogue...
	scSetBWPalette();
	scPlayTune(ENDEP_TUNE);
	scWaitForTune();
	scTerminateScript(201);	
	scDelay(30);
	
	// This prevents user pressing ESC
	scSetOverrideJump(here);
here:	
	scClearRoomArea();
	scBreakHere();
	
	scPlayTune(FINAL_TUNE);
	
#define CREDITSI	19
#define CREDITSE	30
	actor=8;
	for(i=CREDITSI;i<=CREDITSE;i=i+1){
		scPrintAt(STLOCAL,i,42,actor);
		actor=actor+8;
	}
	scDelay(200);
	scDelay(200);
	scDelay(200);
	
	scClearRoomArea();
	scBreakHere();	

#define CREDITSI2	31
#define CREDITSE2	54	
	actor=0;
	for(i=CREDITSI2;i<=CREDITSE2;i=i+1){
		scPrintAt(STLOCAL,i,0,actor);
		actor=actor+8;
	}
	
	scWaitForTune();
	scDelay(200);
	scDelay(200);
	
	scRemoveObjectFromGame(BLAKE);
	scRemoveObjectFromGame(VILA);
	scRemoveObjectFromGame(JENNA);
	scRemoveObjectFromGame(AVON);
	scRemoveObjectFromGame(GAN);
	scRemoveObjectFromGame(CALLY);
	
	scUnlockResource(RESOURCE_STRING,STLOCAL);
	
	scClearRoomArea();
	scShowVerbs(false);
	
	scLoadRoom(ROOM_EPILOGUE);
}

stringpack STLOCAL{
#ifdef ENGLISH
	/***************************************/
	"Avon.";
	"Yes?";
	"Good shot.";
	"I was aiming for his head.";
	"Why did you risk your life for us?";
	"With the Liberator you don't need us.";
	"My odds where 2.5 to 3 on survival.";
	"I checked.";
	"Sounds like a good probability to me.";
	"Yeah. I'm as surprised as you are.";
	"I'm not surprised.";
	
	//11
	"Seven of us can run this ship properly.";
	"Six surely.";
	"You forgot Zen.";
	"You're not counting that machine as a";
	"member of the crew...";
	"Oh, what do you say to that Zen?";
	"Very diplomatic. Set a course for";
	"sector 5,0,2. Speed standard-by-two.";
	
	//19
	
		    /***************************************/
	"\A_FWYELLOW Original TV Series Cast";
	" ";	
	"\A_FWCYAN Blake    \A_FWWHITE Gareth Thomas";
	"\A_FWCYAN Avon     \A_FWWHITE Paul Darrow";
	"\A_FWCYAN Vila     \A_FWWHITE Michael Keating";
	"\A_FWCYAN Jenna    \A_FWWHITE Sally Knyvette";
	"\A_FWCYAN Gan      \A_FWWHITE David Jackson";
	"\A_FWCYAN Cally    \A_FWWHITE Jan Chapell";
	"\A_FWCYAN Zen      \A_FWWHITE Peter Tuddenham";
	"\A_FWCYAN Servalan \A_FWWHITE Jaqueline Pierce";
	"\A_FWCYAN Travis   \A_FWWHITE Stephen Greif";
	"\A_FWCYAN          \A_FWWHITE Brian Croucher";
	//" ";
	//"\A_FWCYAN In memoriam: Gareth Thomas, David Jackson";
	//"\A_FWCYAN Peter Tuddenham and Terry Nation";
	
	
	           /***************************************/
	"\A_FWYELLOW BLAKE'S 7: The Oric Game";
	" ";
	"\A_FWWHITE I hope you enjoyed playing this game";
	"\A_FWWHITE as much as I enjoyed creating it.";
	" ";
	"\A_FWWHITE Many thanks to everyone who helped";
	"\A_FWWHITE with suggestions, feedback, and";
	"\A_FWWHITE encouragement during this process.";
	" ";
	"\A_FWWHITE Special thanks to the incredible";
	"\A_FWWHITE people of RetroWiki, Defence-Force,";
	"\A_FWWHITE and AmigaWave.";
	" ";
	"\A_FWWHITE Thanks to Greymagick, as usual, for";
	"\A_FWWHITE his invaluable advice - and patience.";
	" ";
	"\A_FWWHITE Thanks to jojo073 for his incredible";
	"\A_FWWHITE graphic designs.";
	" ";
	"\A_FWWHITE And thanks to the Oric community for";
	"\A_FWWHITE being there. This time I wanted to";
	"\A_FWWHITE create something really special.";
	" ";
	"\A_FWYELLOW (C)Chema (enguita AT gmail.com) 2017"
	
#endif
#ifdef SPANISH
	/***************************************/
	"Avon.";
	"¿Si?";
	"Buen disparo.";
	"Le apuntaba a la cabeza.";
	"¿Por qué arriesgaste tu vida?";
	"Con el Libertador no nos necesitas.";
	"Mis probabilidades eran bajas.";
	"Sólo 2,5 sobre 3. Lo comprobé.";
	"A mí no me parecen tan bajas.";
	"Ya. Estoy tan sorprendido como tú.";
	"Yo no estoy sorprendido.";
	
	//11
	"Siete pueden manejar esta nave bien.";
	"Quieres decir seis.";
	"Te olvidas de Zen.";
	"No contarás a esa máquina como un";
	"miembro más de la tripulación...";
	"Oh, ¿qué dices a eso Zen?";
	"Muy diplomático. Calcula una ruta al";
	"sector 5,0,2. Velocidad estándar por 2.";
	
	//19
	
		    /***************************************/
	"\A_FWYELLOW Reparto de la serie";
	" ";	
	"\A_FWCYAN Blake    \A_FWWHITE Gareth Thomas";
	"\A_FWCYAN Avon     \A_FWWHITE Paul Darrow";
	"\A_FWCYAN Vila     \A_FWWHITE Michael Keating";
	"\A_FWCYAN Jenna    \A_FWWHITE Sally Knyvette";
	"\A_FWCYAN Gan      \A_FWWHITE David Jackson";
	"\A_FWCYAN Cally    \A_FWWHITE Jan Chapell";
	"\A_FWCYAN Zen      \A_FWWHITE Peter Tuddenham";
	"\A_FWCYAN Servalan \A_FWWHITE Jaqueline Pierce";
	"\A_FWCYAN Travis   \A_FWWHITE Stephen Greif";
	"\A_FWCYAN          \A_FWWHITE Brian Croucher";
	//" ";
	//"\A_FWCYAN In memoriam: Gareth Thomas, David Jackson";
	//"\A_FWCYAN Peter Tuddenham and Terry Nation";
	
	
	           /***************************************/
	"\A_FWYELLOW LOS 7 DE BLAKE: El Juego de Oric";
	" ";
	"\A_FWWHITE Espero que hayas disfrutado jugando";
	"\A_FWWHITE este juego tanto como yo haciéndolo.";
	" ";
	"\A_FWWHITE Gracias a todos los que ayudaron con";
	"\A_FWWHITE sugerencias, opiniones y ánimos";
	"\A_FWWHITE durante todo este proceso.";
	" ";
	"\A_FWWHITE Gracias especialmente a la gente";
	"\A_FWWHITE de RetroWiki, Defence-Force,";
	"\A_FWWHITE y AmigaWave. Sois increíbles.";
	" ";
	"\A_FWWHITE Gracias a Greymagick, como siempre, por";
	"\A_FWWHITE su ayuda - y paciencia - inestimables.";
	" ";
	"\A_FWWHITE Gracias a jojo073 por esos diseños";
	"\A_FWWHITE geniales tuyos.";
	" ";
	"\A_FWWHITE Y gracias a la comunidad Oric por";
	"\A_FWWHITE estar ahí. Esta vez he querido crear";
	"\A_FWWHITE algo realmente especial.";
	" ";
	"\A_FWYELLOW (C)Chema (enguita AT gmail.com) 2017"
#endif
	
}
