/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/****************************/

#include "globals.h"

/* Object command script and strings */


stringpack AVON
{	
#ifdef ENGLISH
	/**************************************/
	"An aloof man...";
	"He is in shock! I must hurry!";
	
	"Your hero attitude is becoming a risk.";
	
	"I'm finished. Staying with you";
	"requires a degree of stupidity of";
	"which I no longer feel capable.";
	
	"I have never understood why it should";
	"be necessary to become irrational in";
	"order to prove that you care, or,";
	"indeed, why it should be necessary";
	"to prove it at all.";
	
	//11
	"You handle them very skilfully.";
	"Do I?";
	"But one death will do it.";
	"Then you'd better be very careful.";
	"It would be ironic if it were yours.";
	
	//16
	"Have you got any better ideas?";
	"As a matter of fact, no, I haven't.";
	"Does that mean you agree?";
	"Do I have a choice?";
	"Yes.";
	"Then I agree.";	

	//22
	"What is that disguise?";
#endif
#ifdef SPANISH
	"Un hombre solitario...";
	"¡Está en shock! ¡debo darme prisa!";
	"Tu actitud de héroe se hace peligrosa.";

	/**************************************/
	"Se acabó. Quedarse junto a tí requiere";
	"un grado de estupidez del que ya no";
	"me siento capaz.";
	
	"Nunca he entendido por qué es";
	"necesario volverse irracional sólo";
	"para probar que alguien te importa,";
	"o, de hecho, por qué es necesario";
	"siquiera probarlo.";
	
	//11
	"Los manejas con mucha habilidad.";
	"¿Tu crees?";
	"Pero una muerte será suficiente.";
	"Entonces deberías de tener cuidado.";
	"Sería irónico que fuese la tuya.";
	
	"¿Tienes alguna idea mejor?";
	"En realidad no. No la tengo.";
	"¿Eso significa que estás de acuerdo?";
	"¿Tengo elección?";
	"Sí.";
	"Entonces estoy de acuerdo.";	

	//22	
	"¿Qué es ese disfraz?";	
	
#endif
}

objectcode AVON
{
	byte i;
	LookAt: 
		if((!bBallDefeated) && (sfGetCurrentRoom()==ROOM_LIBDECK)){
			// He is shocked
			scActorTalk(BLAKE,AVON,1);
			scStopScript();
		}
	
		if(!bAvonIntroduced) {
			scSpawnScript(202);
			scStopScript();
		}
		scActorTalk(BLAKE,AVON,0);
		//scWaitForActor(BLAKE);
		scStopScript();
	TalkTo:
		if(!bAvonIntroduced) {
			scSpawnScript(202);
			scStopScript();
		}
		if(sfGetCurrentRoom()==ROOM_LONDONCELL)
		{
			scLoadDialog(206);
			if( (!bHijackSaid) && bGanIntroduced)
				scActivateDlgOption(2,true);
			scStartDialog();
			scStopScript();
		}		
		
		// If Blake is dressed up...
		if(sfGetCostumeID(BLAKE)!=0){
			scActorTalk(AVON,AVON,22);
			scWaitForActor(AVON);
			scDelay(30);
		}
		
		if(bCygnusOrbit){
			scActorTalk(AVON,200,5);
			scStopScript();
		}
		
		// Default responses
		i=sfGetRandInt(0,4);
		scCursorOn(false);
		if(i==0){
			scActorTalk(AVON,AVON,2);
			scWaitForActor(AVON);
		}
		if(i==1){
			scActorTalk(AVON,AVON,3);
			scWaitForActor(AVON);
			scActorTalk(AVON,AVON,4);
			scWaitForActor(AVON);
			scActorTalk(AVON,AVON,5);	
			scWaitForActor(AVON);
		}
		if(i==2){
			scActorTalk(AVON,AVON,6);
			scWaitForActor(AVON);
			scActorTalk(AVON,AVON,7);
			scWaitForActor(AVON);
			scActorTalk(AVON,AVON,8);
			scWaitForActor(AVON);
			scActorTalk(AVON,AVON,9);
			scWaitForActor(AVON);
			scActorTalk(AVON,AVON,10);
			scWaitForActor(AVON);			
		}
		if(i==3){
			scActorTalk(AVON,AVON,11);
			scWaitForActor(AVON);
			scActorTalk(BLAKE,AVON,12);
			scWaitForActor(BLAKE);
			scActorTalk(AVON,AVON,13);
			scWaitForActor(AVON);
			scActorTalk(BLAKE,AVON,14);
			scWaitForActor(BLAKE);			
			scActorTalk(BLAKE,AVON,15);
			scWaitForActor(BLAKE);
		}
		
		if(i==4){
			scActorTalk(BLAKE,AVON,16);
			scWaitForActor(BLAKE);			
			scActorTalk(AVON,AVON,17);
			scWaitForActor(AVON);
			scActorTalk(BLAKE,AVON,18);
			scWaitForActor(BLAKE);
			scActorTalk(AVON,AVON,19);
			scWaitForActor(AVON);
			scActorTalk(BLAKE,AVON,20);
			scWaitForActor(BLAKE);			
			scActorTalk(AVON,AVON,21);
			scWaitForActor(AVON);
		}
		scCursorOn(true);
}
