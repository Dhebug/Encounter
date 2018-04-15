/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR:laurentd75	*/
/****************************/

#include "globals.h"

/* Object command script and strings */

stringpack BALLROBOT{
#ifdef ENGLISH	
	/***************************************/
	"I have never seen something like that.";
	"It seems to use some kind of mind";
	"trick to neutralize the menace. ";
	"I have to do something or they'll be";
	"lost forever!";
	"That won't work.";
	"I don't understand!";
	"Ouch!";
	"Are you trying to kill me?";
	"Let me do it by myself, will you?";
	"I don't have a projectile.";
#endif
#ifdef FRENCH	
	/***************************************/
	"Je n'ai jamais rien vu de tel.";
	"On dirait qu'il a un pouvoir mental";
	"capable de neutraliser les menaces.";
	"Je dois faire quelque chose, sinon";
	"ils sont perdus à jamais!";
	"Ca ne fonctionnera pas.";
	"Je ne vous comprends pas!";
	"Aïe!";
	"Vous essayez de me tuer, ou quoi?";
	"Laissez-moi faire, plutôt!"; // [laurentd75]: Blake means "let me shoot" here, not "let me kill myself" :-)
	"Je n'ai pas de projectile.";
#endif
#ifdef SPANISH
	/***************************************/
	"Nunca he visto algo como eso.";
	"Parece usar algún truco mental para";
	"neutralizar la amenaza. ";
	"¡Tengo que hacer algo o estarán";
	"perdidos para siempre!";
	"Eso no va a funcionar.";
	"¡No te entiendo!";
	"¡Ay!";
	"¿Intentas matarme?";
	"¡Hala! Déjame a mi...";
	"No tengo un proyectil.";
#endif

}

#define SHOTSPEED 2
objectcode BALLROBOT
{
	byte i;
	byte row;
	byte col;
	
	LookAt:
		scCursorOn(false);
		i=0;
	loop:
		scActorTalk(BLAKE,BALLROBOT,i);
		scWaitForActor(BLAKE);
		i=i+1;
		if(i<=4) goto loop;
		scCursorOn(true);
		scStopScript();
	Use:
		if(sfGetActionObject1()==BALLROBOT){
			// Trying to USE the Robot
			scActorTalk(BLAKE,BALLROBOT,6);
			scWaitForActor(BLAKE);
			scStopScript();
		}
		if(sfGetActionObject1()!=CATPULT){
			// Trying with another object, not the catpult
			scActorTalk(BLAKE,BALLROBOT,5);
			scWaitForActor(BLAKE);
			scStopScript();
		}
		
		// That is it!
		// But do we have the ball?
		if(!sfIsObjectInInventory(BEARING)){
			scActorTalk(BLAKE,BALLROBOT,10);
			scWaitForActor(BLAKE);
			scStopScript();
		}

		scCursorOn(false);
		scSetCostume(BLAKE,14,0);
		scSetAnimstate(BLAKE,5);
		scDelay(5);
		scSetAnimstate(BLAKE,6);
		scDelay(5);
		scSetAnimstate(BLAKE,7);
		scDelay(5);
		//scLoadObjectToGame(250); // Projectile, local in deck
		//scSetAnimstate(250,10);
	shot:	
		i=sfGetCurrentRoom();
		row=sfGetRow(BALLROBOT);
		col=sfGetCol(BLAKE)+1;
		scSetPosition(250,i,row,col);
		scSetAnimstate(BLAKE,5);
		
	loopp:
		scDelay(SHOTSPEED);
		col=col+1;
		scSetPosition(250,i,row,col);

		if(col<(sfGetCol(BALLROBOT)-4)) goto loopp;
		scSetCostume(BLAKE,0,0);
		scSetAnimstate(BLAKE,0);		
		scDelay(SHOTSPEED);
		if(sfGetAnimstate(BALLROBOT)==0){
			// Hit!
			scRemoveObjectFromGame(250);
			scSpawnScript(211);
			scRemoveFromInventory(BEARING);
			scStopScript();
		}
		nFailsCatapult=nFailsCatapult+1;
		scPlaySFX(SFX_PIC);

	looppb:
		// The ball bounces
		col=col-1;
		scSetPosition(250,i,row,col);
		scDelay(SHOTSPEED);
		if(col>(sfGetCol(BLAKE))) goto looppb;
		//scRemoveObjectFromGame(250);
		scSetPosition(250,i,row,100);
		scActorTalk(BLAKE,BALLROBOT,7);
		scWaitForActor(BLAKE);

		if (nFailsCatapult>3){
			// Automate this... 
			scLookDirection(BLAKE,FACING_DOWN);
			scActorTalk(BLAKE,BALLROBOT,8);
			scWaitForActor(BLAKE);
			scActorTalk(BLAKE,BALLROBOT,9);
			scWaitForActor(BLAKE);
			scLookDirection(BLAKE,FACING_RIGHT);
		
			scSetCostume(BLAKE,14,0);
			scSetAnimstate(BLAKE,5);
			scDelay(5);
			scSetAnimstate(BLAKE,6);
			scDelay(5);
			scSetAnimstate(BLAKE,7);
			scDelay(5);
			
			// Wait for the correct time
	loopw:		scBreakHere();
			if(sfGetAnimstate(BALLROBOT)!=2) goto loopw;
			goto shot;
		}
					
		scCursorOn(true);
}


 


