
/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/****************************/

#include "globals.h"

#define ST_INTRO	106

#define TIMING		120

/* Script with the intro to episode 3 		*/
/* I made this script global because else it'd  */
/* get nuked when changing rooms, so this was   */
/* easier...					*/
script 15
{	
	byte i;
	byte a;
	
	// Disable Fade Effects
	scSetFadeEffect(0);
	scClearRoomArea();
	
	// Lock string resources
	scLockResource(RESOURCE_STRING,ST_INTRO);
	
	scLoadRoom(ROOM_EPISODE3);
	// Set the destination for ESC press
	scSetOverrideJump(here);
	
	scDelay(100);
	
	scClearRoomArea();
	
	// Pic with the exterior of the Federation station
	scLoadRoom(200);
	scPlayTune(FEDMARCH_TUNE);

	
	// Prepare everything for camera pan
	scSetCameraAt(120);
	scBreakHere();

	//scDelay(50);
	scPanCamera(0);
	scWaitForCamera();
	//scPlaySFX(SFX_MINITUNE1);
	//scWaitForTune();		
	scDelay(50);
	scPrintAt(ST_INTRO,0,8,120);
	scDelay(80);
	scDelay(100);
here:
	scStopTune();

	scSetOverrideJump(here2);
	scLoadObjectToGame(TRAVIS);
	scLoadObjectToGame(SERVALAN);
	scSetPosition(SERVALAN,201,15,20);
	scSetPosition(TRAVIS,201,15,37);
	scLookDirection(SERVALAN,FACING_LEFT);
	scLookDirection(TRAVIS,FACING_LEFT);
	scLoadRoom(201);
	scActorWalkTo(TRAVIS,32,15);
	scWaitForActor(TRAVIS);
	scDelay(50);

	a=SERVALAN;
	for(i=1;i<=60;i=i+1){
		if(i>=14) a=TRAVIS;
		//if(i>=25) a=SERVALAN;
		
		if(i==25){
			scLoadRoom(210);
			scDelay(60);
			for (i=25;i<=32;i=i+1)
			{
				scPrint(ST_INTRO,i);
				scDelay(TIMING);
			}
			scPrint(ST_INTRO,61);
			scLoadRoom(201);
		}
		
		//if(i>=33) a=TRAVIS;
		if(i==33){
			scLoadRoom(211);
			scDelay(60);
			for (i=33;i<=38;i=i+1)
			{
				scPrint(ST_INTRO,i);
				scDelay(TIMING);
			}
			scPrint(ST_INTRO,61);
			scLoadRoom(201);
		}		
		if(i>=39) a=SERVALAN;
		if(i==43) a=TRAVIS;
		if(i>=44) a=SERVALAN;
		if(i>=48) a=TRAVIS;
		if(i>=50) a=SERVALAN;
		if(i==52) a=TRAVIS;
		if(i>=53) a=SERVALAN;
		if(i==57) a=TRAVIS;
		if(i>=58) a=SERVALAN;
		if(i==60) a=TRAVIS;
		
		if((i==5)||(i==25)||(i==44)){
			scLookDirection(SERVALAN,FACING_RIGHT);
			scDelay(30);
		} 
		
		if((i==39)||(i==58)){
			scLookDirection(SERVALAN,FACING_LEFT);
			scDelay(30);			
		}
		
		if(i==17){
			scActorWalkTo(SERVALAN,20,14);
			scWaitForActor(SERVALAN);
		} 
		
		if(i==33){
			scLookDirection(SERVALAN,FACING_UP);
			scActorWalkTo(TRAVIS,30,15);
			scDelay(30);			
		}
		
		
		scActorTalk(a,ST_INTRO,i);
		scWaitForActor(a);
	}
	
here2:	
	scUnlockResource(RESOURCE_STRING,ST_INTRO);

	// Launch 2nd part of the intro
	scDelay(50);
	scClearRoomArea();
	scRemoveObjectFromGame(TRAVIS);
	scRemoveObjectFromGame(SERVALAN);
	scSpawnScript(16);
}


stringpack ST_INTRO{
#ifdef ENGLISH
"\A_FWMAGENTA+A_FWCYAN*8+128 Federation Space Headquarters.";
	
/***************************************/
"Ah, Travis. Come in. My department has";
"done all in its power to suppress";
"information about Blake and his";
"actions, but still the stories get out.";
"They spread by word of mouth, by rumour";
"each time the story is told it is";
"elaborated upon.";
"Any damage to the Federation is";
"attributed to Blake. The smallest";
"incident is exaggerated until it";
"becomes a major event.";
"Blake is becoming a legend.";
"He must be stopped.";

//14
/***************************************/
"I am aware of the danger should Blake";
"become a legend. But let us keep this";
"matter in its correct perspective.";
"It is true that Blake has command of";
"a superb space vehicle, but he is just";
"a man, backed by a handful of";
"criminals, and that is all. He is not";
"invulnerable, nor is he superhuman.";
"He is just a man, who has been";
"extremely lucky to evade capture";
"--- so far.";

//25
/***************************************/
"\A_FWMAGENTA I am aware of the facts. They are";
"\A_FWMAGENTA simply that with all the resources";
"\A_FWMAGENTA that the Federation can call upon,";
"\A_FWMAGENTA this one vulnerable, lucky man is still";
"\A_FWMAGENTA free to cause havoc. I think you should";
"\A_FWMAGENTA know that there's been considerable";
"\A_FWMAGENTA criticism of your handling of the";
"\A_FWMAGENTA Blake affair.";

//33
/***************************************/
"\A_FWWHITE+A_FWGREEN*8+$c0 That's not entirely just. There have";
"\A_FWWHITE+A_FWGREEN*8+$c0 been two occasions where I could have";
"\A_FWWHITE+A_FWGREEN*8+$c0 destroyed Blake. It was only the";
"\A_FWWHITE+A_FWGREEN*8+$c0 Administration's insistence that the";
"\A_FWWHITE+A_FWGREEN*8+$c0 Liberator be captured undamaged that";
"\A_FWWHITE+A_FWGREEN*8+$c0 stopped me.";

//39
/***************************************/
"I have made that point in your";
"defence but I can't go on making";
"excuses. I've been under considerable";
"pressure to replace you.";

//43
/***************************************/
"Ohh?";

//44
/***************************************/
"Oh, so far I have resisted that";
"pressure. But now, I need your";
"reassurance that my confidence has not";
"been misplaced.";

//48
/***************************************/
"I think my latest plan will silence";
"the critics.";

//50
/***************************************/
"It does seem an excellent plan. It";
"should have every chance of success.";

//52
"I'm glad you approve.";

//53
"Oh, Travis, you know better than that.";
"In my position one never approves";
"anything until it is an undisputed";
"success.";

//57
"Yeh.";
//58
"However, you have my full support,";
"unofficially, of course.";
//60
"Of course.";
//61
" ";	
#endif
#ifdef SPANISH
	"\A_FWMAGENTA+A_FWCYAN*8+128 Federación. Comandancia del Espacio.";

/***************************************/
"Ah, Travis. Pasa. Mi departamento ha";
"hecho lo posile para eliminar toda la";
"información sobre Blake y su grupo,";
"pero las historias se propagan...";
"A tavés del boca a boca, del rumor,";
"cada vez que se cuenta se vuelve más";
"elaborada y exagerada.";
"Cualquier daño a la Federación se";
"atribuye a Blake. El incidente más";
"pequeño se exagera hasta que se";
"convierte en algo heróico.";
"Blake se hace una leyenda.";
"Hay que detenerle.";

//14
/***************************************/
"Soy consciente del peligro de que se";
"vuelva una leyenda, pero no hay que";
"perder la perspectiva.       ";
"Es cierto que Blake comanda una nave";
"soberbia, pero no es más que un hombre";
"ayudado por un puñado de criminales.";
"Nada más. No es invulnerable, ni es";
"tampoco un superhombre.";
"Sólo es un hombre que ha tenido una";
"suerte extrema para evitar su captura";
"-- por el momento.";

//25
/***************************************/
"\A_FWMAGENTA Soy consciente de los hechos. Es que";
"\A_FWMAGENTA simplemente con todos los recursos de";
"\A_FWMAGENTA que la Federación puede disponer, este";
"\A_FWMAGENTA hombre vulnerable, pero afortunado,";
"\A_FWMAGENTA todavía está causando problemas.";
"\A_FWMAGENTA Deberías saber que empieza a haber";
"\A_FWMAGENTA muchas críticas a tu forma de manejar";
"\A_FWMAGENTA el asunto Blake.";


//33
/***************************************/
"\A_FWWHITE+A_FWGREEN*8+$c0 Eso no es del todo justo. Hubo dos";
"\A_FWWHITE+A_FWGREEN*8+$c0 ocasiones en las que pude haber acabado";
"\A_FWWHITE+A_FWGREEN*8+$c0 con Blake. Sólo la insistencia que";
"\A_FWWHITE+A_FWGREEN*8+$c0 muestra la Administración en que el";
"\A_FWWHITE+A_FWGREEN*8+$c0 Libertador se capture sin daño alguno";
"\A_FWWHITE+A_FWGREEN*8+$c0 me detuvo.";

//39
/***************************************/
"Ya hice esa observación en tu defensa,";
"pero ya no puedo seguir poniendo más";
"excusas. Me encuentro bajo una presión";
"considerable para reemplazarte.";


//43
/***************************************/
"¿Eh?";

//44
/***************************************/
"Oh, hasta ahora he resistido esta";
"presión. Pero ahora necesito que me";
"demuestres que no he depositado mi";
"confianza en la persona equivocada.";

//48
/***************************************/
"Creo que mi último plan silenciará";
"todas las críticas.";

//50
/***************************************/
"Sí que parece un plan excelente. Tiene";
"todas las papeletas para ser un éxito.";

//52
"Me alegro de que lo apruebe.";
//53
"Oh, Travis, deberías saberlo mejor.";
"En mi posición una nunca aprueba nada";
"hasta que no se ha convertido en un";
"éxito sin paliativos.";

//57
"Lo sé.";
//58
"Sin embargo, tienes mi total apoyo,";
"extraoficialmente, por supuesto.";
//60
"Por supuesto.";
//61
" ";		
#endif
	
}



