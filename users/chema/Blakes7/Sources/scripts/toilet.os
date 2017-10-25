/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/****************************/

#include "globals.h"

#define EXIT		200
#define SCRIBBLE1	201
#define SCRIBBLE2	202
#define SCRIBBLE3	203
#define SCRIBBLE4	204
#define SCRIBBLE5	205
#define MAN		206
#define SIGN		207
#define TOILET		208
#define BASIN		209


// String pack for descriptions in this room
#define STDESC  	200
#define STCOUPLETS	201


// Entry script
script 200{
	// Reset the message variable to select the
	// descriptions
	nScribbleMsg=0;
}

objectcode EXIT{
	WalkTo:
		scSetPosition(sfGetActorExecutingAction(),ROOM_CORRIDOR,14,21);
		scLookDirection(sfGetActorExecutingAction(),FACING_DOWN);
		scChangeRoomAndStop(ROOM_CORRIDOR);
}

objectcode MAN{
	LookAt:
		scActorTalk(sfGetEgo(),STDESC,0);
}

objectcode SIGN{
	LookAt:
		scActorTalk(sfGetEgo(),STDESC,15);
}

objectcode TOILET{
	LookAt:	
		scActorTalk(sfGetEgo(),STDESC,1);
		scStopScript();
	Use:
		scActorTalk(sfGetEgo(),STDESC,2);		
}


objectcode BASIN{
	LookAt:	
		scActorTalk(sfGetEgo(),STDESC,3);
		scStopScript();
	Use:
		if(sfGetActionObject1()==CUP){
			// Using the Cup with the basin
			// If still empty...
			if(sfGetState(CUP)==0){
				scActorTalk(BLAKE,STDESC,17);	
				scSetState(CUP,1);
			}
			else{
				scActorTalk(BLAKE,STDESC,16);	
			}
			scStopScript();
		}
		else
			scActorTalk(sfGetEgo(),STDESC,4);		
}


objectcode SCRIBBLE1{
	byte a;
	LookAt:
		scChainScript(210);
		a=sfGetEgo();
	
		scActorTalk(a,STCOUPLETS,0);
		scWaitForActor(a);
		scActorTalk(a,STCOUPLETS,1);
		scWaitForActor(a);
	
		scChainScript(211);
		if(!bCouplet1Known){
			bCouplet1Known=true;
			scSave();
		}
}

objectcode SCRIBBLE2{
	byte a;
	LookAt:
		scChainScript(210);
		a=sfGetEgo();
		
		scActorTalk(a,STCOUPLETS,2);
		scWaitForActor(a);
		scActorTalk(a,STCOUPLETS,3);
		scWaitForActor(a);
	
		scChainScript(211);
		if(!bCouplet2Known){
			bCouplet2Known=true;
			scSave();
		}

}

objectcode SCRIBBLE3{
	byte a;
	LookAt:
		scChainScript(210);
		a=sfGetEgo();

		scActorTalk(a,STCOUPLETS,4);
		scWaitForActor(a);
		scActorTalk(a,STCOUPLETS,5);
		scWaitForActor(a);
	
		scChainScript(211);
		if(!bCouplet3Known){
			bCouplet3Known=true;
			scSave();
		}

}
objectcode SCRIBBLE4{
	byte a;
	LookAt:
		scChainScript(210);
		a=sfGetEgo();
	
		scActorTalk(a,STCOUPLETS,6);
		scWaitForActor(a);
		scActorTalk(a,STCOUPLETS,7);
		scWaitForActor(a);
	
		scChainScript(211);
		if(!bCouplet4Known){
			bCouplet4Known=true;
			scSave();
		}

}
objectcode SCRIBBLE5{
	byte a;
	LookAt:
		scChainScript(210);
		a=sfGetEgo();	
		scActorTalk(a,STCOUPLETS,8);
		scWaitForActor(a);
		scActorTalk(a,STCOUPLETS,9);
		scWaitForActor(a);
		scChainScript(211);
		if(!bCouplet5Known){
			bCouplet5Known=true;
			scSave();
		}
}

// Scripts handling the descriptions of the scribbles
script 210{
	byte a;
	scCursorOn(false);
	// First part of description
	a=sfGetEgo();
	scActorTalk(a,STDESC,5+nScribbleMsg);
	scWaitForActor(a);	
}

script 211{
	byte a;
	// Second part
	a=sfGetEgo();
	scActorTalk(a,STDESC,6+nScribbleMsg);
	scWaitForActor(a);		
	nScribbleMsg=nScribbleMsg+2;
	if(nScribbleMsg>=10) nScribbleMsg=8;
	scCursorOn(true);
}


stringpack STDESC{
#ifdef ENGLISH
/***************************************/
"It is a stickman.";
"What can I say? It is a WC...";
"No, thanks. No need now.";
"It is a washbasin. Nothing unusual.";
"I don't need to wash my hands.";

//5
"There are scribbles everywhere.";
"Anyway...";

"Look, this one says:";
"That is a bad one.";

"Let's see...";
"I think all of them are terrible.";

"This is difficult to read...";
"Oh, my...";

"Will this one be better?";
"No. It wasn't.";

"It reads: Out of Order.";

"It is already full.";
"Okay, I'll fill it up with water.";

#endif

#ifdef SPANISH
/***************************************/
"Es un muñeco de palitos.";
"¿Qué puedo decir? Es un váter.";
"No, gracias. No tengo ganas.";
"Es un lavabo. Nada inusual.";
"No necesito lavarme las manos";
//5
"Está todo lleno de garabatos. Dice:";
"Vaya tela.";

"Mira, este dice:";
"¡Qué malo!.";

"Veamos...";
"Creo que todos son malísimos.";

"Este se lee mal...";
"Madre mía...";

"¿Será este mejor?";
"Pues no. No lo era.";

"Pone: Fuera de Servicio.";

"Ya está llena.";
"De acuerdo, la llenaré de agua.";

#endif
	
}

stringpack STCOUPLETS{
#ifdef ENGLISH
	/***************************************/
	"'My feelings for you no words can tell";
	"Except for maybe go to hell'.";
	"'Oh loving beauty you float with grace";
	"If only you could hide your face.'";
	"'Kind, intelligent, loving and hot";
	"This describes everything you are not.'";
	"'I love your smile, face, and eyes";
	"Damn, I'm good at telling lies!'";
	"'I see your face when I am dreaming";
	"That's why I always wake up screaming.'";
#endif
#ifdef SPANISH
	/***************************************/
	"'Debajo del río amarillo";
	"no hay quien encienda un pitillo.'";
	"'El kilo de sardineta";
	"ha subido otra peseta.'";
	"'Esos tipos con bigote";
	"tienen cara de hotentote.'";
	"'Los tipos que fuman puro";
	"tienen cara de canguro.'";
	"'Cuando llueve en Almería";
	"se moja hasta mi tía.'"; 
#endif
}

/*
My feelings for you no words can tell / Except for maybe "go to hell
Oh loving beauty you float with grace / If only you could hide your face
Kind, intelligent, loving and hot / This describes everything you are not 
I love your smile, your face, and your eyes / Damn, I'm good at telling lies!
I see your face when I am dreaming / That's why I always wake up screaming 


Debajo del río amarillo / no hay quien encienda un pitillo
El kilo de sardineta / ha subido otra peseta
Esos tipos con bigote / tienen cara de hotentote
Los tipos que fuman puro / tienen cara de canguro
Cuando llueve en Almería / se moja hasta mi tía 

*/




