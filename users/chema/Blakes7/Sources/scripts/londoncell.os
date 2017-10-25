/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/****************************/

#include "globals.h"

/* Scripts and other things for the cell in the London */


#define DOOR		200
#define ALARM		201
#define BIN		202
#define LOCK		203
#define LOCKERS		204

#define BATTERY		205
#define WRAPPER		206
#define KEYCARD		207

#define ST_INTRO	100
#define SPPLAN  	101
#define DIALOG_EXTRAS	102


/* Object interactions */
stringpack 201{
#ifdef ENGLISH
	// Door
	//++++++++++++++++++++++++++++++++++++++
	"A barred door. We are in a cell.";
	"It is locked.";
	"That is useless.";
	"It is already closed.";
	
	// Lock
	"A sophisticated lock.";
	"I can't operate it.";
	
	// Alarm
	"It looks like a fire alarm.";
	"I can't reach it.";
	
	// Lockers
	"We were told to put our personal";
	"belongings here.";
	"But nobody has any.";
	"Better not touch them.";
	
	// Bin
	"Okay... but this is not the typical";
	"computer adventure where you find";
	"a key inside the bin.";
	"See? Just dozens of gum wrappers.";
	"Probably from a previous lodger.";
	"I'll take one, just in case...";
	"I already have one wrapper.";

	// Wrapper
	"A gum wrapper. Aluminium, I think.";
	"I could wrap something with it.";
	"Oh, I saw this in 'Ultimate Survival'.";

	// Using one with the other...
	"I may have a plan, but I need Avon.";
	"Better talk to him first.";	
	"Let's meet that strong man, first.";
	
	// Battery
	"A backup battery.";
	"I don't know what you want to do.";
	
	// No more needed
	"I don't have to do that again.";
	
	// Keycard
	"A plastic access card.";
	"I'd better keep it.";
#endif

#ifdef SPANISH

	// Door
	//++++++++++++++++++++++++++++++++++++++
	"Una reja. Estamos en una celda.";
	"Está cerrada.";
	"Eso es inútil.";
	"Ya está cerrada.";
	
	// Lock
	"Un cierre sofisticado.";
	"No puedo operarlo.";
	
	// Alarm
	"Parece una alarma anti-incendios.";
	"No llego.";
	
	// Lockers
	"Nos dijeron que guardásemos nuestros";
	"efectos aquí.";
	"Pero nadie tiene nada.";
	"Mejor no tocarlas.";
	
	// Bin
	"Vale, pero no es la típica aventura";
	"donde encuentras una llave tirada";
	"en la papelera.";
	"¿Ves? Sólo papeles de chicle.";
	"Fijo que de un huésped anterior.";
	"Cogeré uno, por si acaso...";
	"Ya tengo un papel de chicle.";

	// Wrapper
	"Papel de chicle. Creo que de aluminio.";
	"Podría envolver algo con esto.";
	//++++++++++++++++++++++++++++++++++++++
	"Eso salió en 'El último superviviente'.";

	// Using one with the other...
	"Tengo una idea, pero necesito a Avon.";
	"Mejor hablo con él primero.";	
	"Vamos a conocer a ese cachas antes.";
	
	// Battery
	"Una batería de repuesto.";
	"No sé qué quieres hacer.";
	
	// No more needed
	"No tengo que repetir eso.";
	
	// Keycard
	"Una tarjeta de acceso.";
	"Mejor la conservo.";
#endif


}


#define S_DOOR 		0
#define S_LOCK		4
#define S_ALARM 	6
#define S_LOCKERS	8
#define S_BIN		12
#define S_WRAPPER	19
#define S_BATTERY	25
#define S_KEYCARD	28	


objectcode DOOR{
	LookAt:
		scActorTalk(BLAKE,201,S_DOOR+0);
		scWaitForActor(BLAKE);
		scStopScript();
	WalkTo:
	Open:
		scActorTalk(BLAKE,201,S_DOOR+1);
		scWaitForActor(BLAKE);
		scStopScript();
	Close:
		scActorTalk(BLAKE,201,S_DOOR+3);
		scWaitForActor(BLAKE);
		scStopScript();
	Push:
	Pull:
		scActorTalk(BLAKE,201,S_DOOR+2);
		scWaitForActor(BLAKE);
		scStopScript();
/*	WalkTo:
		if(sfGetAnimstate(DOOR)!=2)
			goto Open;
		// Move to halway! */
}

		
objectcode LOCK{
	LookAt:
		scActorTalk(BLAKE,201,S_LOCK+0);
		scWaitForActor(BLAKE);
		scStopScript();
	Open:
		scActorTalk(BLAKE,201,S_LOCK+1);
		scWaitForActor(BLAKE);
		scStopScript();
	Push:
	Pull:
		scActorTalk(BLAKE,201,S_DOOR+2); // Useless
		scWaitForActor(BLAKE);
		scStopScript();
	Use:
		if(sfGetActionObject1()!=KEYCARD) goto Open;
		
		// We have the Card, let's hack the computer
		scCursorOn(false);
		scShowVerbs(false);
				
		// The door opens
		scPlaySFX(SFX_DOOR);
		scDelay(10);
		scSetAnimstate(200,1);
		scDelay(10);
		scSetAnimstate(200,2);
		scDelay(10);
		
		// This will be removed later...
		//scSetPosition(BLAKE, ROOM_LONDONCOMP, 14, 6);

		//scShowVerbs(true);
		//scCursorOn(true);
		scShowVerbs(false);
		// Remove the battery and keycard from inventory
		scRemoveFromInventory(BATTERY);
		scRemoveFromInventory(KEYCARD);
		scChangeRoomAndStop(ROOM_LONDONCOMP);
}

objectcode ALARM{
	LookAt:
		scActorTalk(BLAKE,201,S_ALARM+0);
		scWaitForActor(BLAKE);
		scStopScript();
	Open:
	Push:
	Pull:
	Use:
		scActorTalk(BLAKE,201,S_ALARM+1); 
		scWaitForActor(BLAKE);
		scStopScript();

}

objectcode LOCKERS{
	LookAt:
		scCursorOn(false);
		scActorTalk(BLAKE,201,S_LOCKERS+0);
		scWaitForActor(BLAKE);
		scActorTalk(BLAKE,201,S_LOCKERS+1);
		scWaitForActor(BLAKE);
		scActorTalk(BLAKE,201,S_LOCKERS+2);
		scWaitForActor(BLAKE);
		scCursorOn(true);
		scStopScript();
	Open:
	Push:
	Pull:
	Use:
		scActorTalk(BLAKE,201,S_LOCKERS+3); 
		scWaitForActor(BLAKE);
		scStopScript();

}


objectcode BIN{
	LookAt:		
		if(bCardTaken){
			scActorTalk(BLAKE,201,29);
			scStopScript();		
		}
		if(sfIsObjectInInventory(WRAPPER)){
			scActorTalk(BLAKE,201,S_BIN+6);
			scStopScript();
		}
		scCursorOn(false);
		scActorTalk(BLAKE,201,S_BIN+0);
		scWaitForActor(BLAKE);
		scActorTalk(BLAKE,201,S_BIN+1);
		scWaitForActor(BLAKE);
		scActorTalk(BLAKE,201,S_BIN+2);
		scWaitForActor(BLAKE);
		scDelay(80);
		scActorTalk(BLAKE,201,S_BIN+3);
		scWaitForActor(BLAKE);
		scActorTalk(BLAKE,201,S_BIN+4);
		scWaitForActor(BLAKE);
		scActorTalk(BLAKE,201,S_BIN+5);
		scWaitForActor(BLAKE);
		// Put one in inventory
		scPutInInventory(WRAPPER);
		scSave();
		scCursorOn(true);
		scStopScript();
}


objectcode WRAPPER
{
	Use:
		if(sfGetActionObject1()==BATTERY){
			if (!bGanIntroduced){
				scActorTalk(BLAKE,201,S_WRAPPER+5);
				scWaitForActor(BLAKE);
				scStopScript();
			}			
			if (!bHijackSaid){
				scActorTalk(BLAKE,201,S_WRAPPER+3);
				scWaitForActor(BLAKE);
				scActorTalk(BLAKE,201,S_WRAPPER+4);
				scWaitForActor(BLAKE);
				scStopScript();
			}
			// We will make fire!
			// Also do this when WRAPPER used with BATTERY.
			scActorTalk(BLAKE,201,S_WRAPPER+2);
			scWaitForActor(BLAKE);
			scSpawnScript(211);
		}
		else{
			scActorTalk(BLAKE,201,S_WRAPPER+1);
			scWaitForActor(BLAKE);
		}
		scStopScript();
	LookAt: 
		scActorTalk(BLAKE,201,S_WRAPPER);
		scWaitForActor(BLAKE);
		scStopScript();
}

objectcode BATTERY
{
	Open:
	LookAt: 
		scActorTalk(BLAKE,201,S_BATTERY);
		scWaitForActor(BLAKE);
		scStopScript();
	Use:
		if(sfGetActionObject1()==WRAPPER)
			scRunObjectCode(VERB_USE,BATTERY,WRAPPER);
		else{
			scActorTalk(BLAKE,201,S_BATTERY+1);
			scWaitForActor(BLAKE);
		}
}


objectcode KEYCARD
{
	LookAt:
		scActorTalk(BLAKE,201,S_KEYCARD);
		scWaitForActor(BLAKE);
		scStopScript();
	Give:
		scActorTalk(BLAKE,201,S_KEYCARD+1);
		scWaitForActor(BLAKE);
		scStopScript();
}

/* Script that makes Vila be nearby when we walk */
script 200{	
	byte cb;
	byte cv;
	cb=sfGetCol(BLAKE);
	cv=sfGetCol(VILA);
	if( cb>cv )
	{
		if((cb-cv)>10)
			scActorWalkTo(VILA,cb-5,14);
	}
	else
	{	if((cv-cb)>10)
			scActorWalkTo(VILA,cb+5,14);
	}
	scWaitForActor(VILA);
	scDelay(50);
	scRestartScript();
}

/* Vila introduces Gan */
script 201{
		scFreezeScript(200,true);
		scCursorOn(false);
		// Wait for him, if moving.
		scWaitForActor(VILA);
		// Let's go
		if(sfGetCol(BLAKE)>sfGetCol(GAN))
		{
			scActorWalkTo(VILA,sfGetCol(GAN)-5,14);
			scWaitForActor(VILA);		
			scLookDirection(VILA,FACING_RIGHT);
			scLookDirection(GAN,FACING_LEFT);
		}
		else{
			scActorWalkTo(VILA,sfGetCol(GAN)+5,14);
			scWaitForActor(VILA);		
			scLookDirection(VILA,FACING_LEFT);
			scLookDirection(GAN,FACING_RIGHT);			
		}

		scPanCamera(sfGetCol(GAN));
		scWaitForCamera();
		scActorTalk(VILA,ST_INTRO,37);
		scWaitForActor(VILA);
		scActorTalk(VILA,ST_INTRO,38);
		scWaitForActor(VILA);
		scActorTalk(VILA,ST_INTRO,39);
		scWaitForActor(VILA);
		scActorTalk(GAN,ST_INTRO,40);
		scWaitForActor(GAN);
		scLookDirection(GAN,FACING_DOWN);
		scDelay(30);
		scActorTalk(GAN,ST_INTRO,41);
		scWaitForActor(GAN);
		scActorTalk(GAN,ST_INTRO,42);
		scWaitForActor(GAN);
		scActorTalk(VILA,ST_INTRO,43);
		scWaitForActor(VILA);
		scActorTalk(VILA,ST_INTRO,44);
		scWaitForActor(VILA);
		scActorTalk(BLAKE,ST_INTRO,45);
		scWaitForActor(BLAKE);
		scActorTalk(BLAKE,ST_INTRO,46);
		scWaitForActor(BLAKE);	
		bGanIntroduced=true;
		scSave();
		scFreezeScript(200,false);
		scCursorOn(true);
}


/* Vila introduces Avon */
script 202{
		scCursorOn(false);
		scFreezeScript(200,true);
		// Wait for him, if moving.
		scWaitForActor(VILA);
		// Let's go
		scActorWalkTo(VILA,sfGetCol(AVON)-12,14);
		scWaitForActor(VILA);		
		scLookDirection(VILA,FACING_RIGHT);
		scLookDirection(AVON,FACING_LEFT);

		//scPanCamera(sfGetCol(AVON));
		//scWaitForCamera();
		scActorTalk(VILA,ST_INTRO,29);
		scWaitForActor(VILA);
		scActorTalk(VILA,ST_INTRO,30);
		scWaitForActor(VILA);
		scActorTalk(VILA,ST_INTRO,31);
		scWaitForActor(VILA);
		scActorTalk(VILA,ST_INTRO,32);
		scWaitForActor(VILA);
		scActorTalk(BLAKE,ST_INTRO,33);
		scWaitForActor(BLAKE);
		scActorTalk(VILA,ST_INTRO,34);
		scWaitForActor(VILA);

		scActorTalk(BLAKE,ST_INTRO,35);
		scWaitForActor(BLAKE);
		scActorTalk(AVON,ST_INTRO,36);
		scWaitForActor(AVON);
		
		scSave();
		bAvonIntroduced=true;
		scFreezeScript(200,false);
		scCursorOn(true);
}

/* Dialogs in the cell */

#define DLG_JENNA 	205
#define DLG_AVON	206
#define DLG_VILA	207
#define DLG_GAN		208



dialog DLG_JENNA: script DLG_JENNA stringpack DLG_JENNA{
#ifdef ENGLISH
	option "How will Cygnus Alpha be?" active -> cygjenna;
	option "So you're an expert pilot..." active -> pilot;
#endif

#ifdef SPANISH
	option "¿Cómo crees que será Cygnus Alpha?" active -> cygjenna;
	option "Así que eres una piloto experta..." active -> pilot;
#endif
}

/* Script that controls the dialog above */
script DLG_JENNA{
	byte opt;
export pilot: 
	opt=0;
	goto common; 
export cygjenna:
	opt=2;
	//goto common;
common:
	scWaitForActor(BLAKE);
	scActorTalk(JENNA, DIALOG_EXTRAS,opt);
	scWaitForActor(JENNA);
	scActorTalk(JENNA, DIALOG_EXTRAS,opt+1);
	scWaitForActor(JENNA);
	scEndDialog();
}


dialog DLG_AVON: script DLG_AVON stringpack DLG_AVON{
#ifdef ENGLISH
	option "What do you know about Cygnus Alpha?" active -> cygavon;
	option "Do you know how that lock works?" active -> lock;
	option "I plan to hijack this ship." inactive -> hijack;
#endif

#ifdef SPANISH
	      //++++++++++++++++++++++++++++++++++++++
	option "¿Qué sabes de Cygnus Alpha?" active -> cygavon;
	option "¿Sabes cómo funciona esa cerradura?" active -> lock;
	option "Voy a secuestrar esta nave." inactive -> hijack;
#endif
}

/* Script that controls the dialog above */
script DLG_AVON{
	byte opt;
export lock: 
	opt=4;
	bAskedAvonForLock=true;
	scSave();
	goto common; 
export cygavon:
	opt=6;
	goto common;
export hijack:
	scWaitForActor(BLAKE);
	scActorTalk(BLAKE,DIALOG_EXTRAS,23);
	scWaitForActor(BLAKE);
	scActorTalk(BLAKE,DIALOG_EXTRAS,24);
	scWaitForActor(BLAKE);
	scActorTalk(BLAKE,DIALOG_EXTRAS,25);
	scWaitForActor(BLAKE);
	scActorTalk(AVON,DIALOG_EXTRAS,26);
	scWaitForActor(AVON);
	scActorTalk(BLAKE,DIALOG_EXTRAS,27);
	scWaitForActor(BLAKE);
	scActorTalk(AVON,DIALOG_EXTRAS,28);
	scWaitForActor(AVON);
	scLookDirection(BLAKE,FACING_LEFT);
	scActorTalk(BLAKE,DIALOG_EXTRAS,29);
	scActorWalkTo(JENNA,20,16);
	scWaitForActor(BLAKE);
	scWaitForActor(JENNA);
	scLookDirection(JENNA,FACING_RIGHT);
	scActorTalk(JENNA,DIALOG_EXTRAS,30);
	scWaitForActor(JENNA);
	scActorTalk(JENNA,DIALOG_EXTRAS,31);
	scWaitForActor(JENNA);
	scActorTalk(JENNA,DIALOG_EXTRAS,32);
	scWaitForActor(JENNA);

	
	bHijackSaid=true;
	scEndDialog();
	//if(bGanIntroduced && bAvonIntroduced)
	scSpawnScript(210); // Develop plan		
	scStopScript();
common:
	scWaitForActor(BLAKE);
	scActorTalk(AVON, DIALOG_EXTRAS,opt);
	scWaitForActor(AVON);
	scActorTalk(AVON, DIALOG_EXTRAS,opt+1);
	scWaitForActor(AVON);
	scEndDialog();
}

dialog DLG_VILA: script DLG_VILA stringpack DLG_VILA{
#ifdef ENGLISH
	option "Heard anything about Cygnus Alpha?" active -> cygvila;
	option "Are you good at opening locks?" inactive -> lockv;
#endif
#ifdef SPANISH
	      //++++++++++++++++++++++++++++++++++++++
	option "¿Qué has oído de Cygnus Alpha?" active -> cygvila;
	option "¿Eres bueno abriendo cerraduras?" inactive -> lockv;
#endif
}

/* Script that controls the dialog above */
script DLG_VILA{
	byte campos;
	bool moved;
	byte i;
export cygvila:
	moved=false;
	scWaitForActor(BLAKE);
	scActorTalk(VILA, DIALOG_EXTRAS,8);
	scWaitForActor(VILA);
	scActorTalk(VILA, DIALOG_EXTRAS,9);
	scWaitForActor(VILA);
	scActorTalk(VILA, DIALOG_EXTRAS,10);
	scWaitForActor(VILA);
	scActorTalk(VILA, DIALOG_EXTRAS,11);
	scWaitForActor(VILA);
	campos=sfGetCameraCol();
	if( (campos+17)< sfGetCol(AVON) )
	{
		scPanCamera(30);
		scWaitForCamera();
		moved=true;
	}
	scDelay(50);
	scActorTalk(AVON, DIALOG_EXTRAS,12);
	scWaitForActor(AVON);
	if(moved){
		scPanCamera(campos);
		scWaitForCamera();
	}
	scEndDialog();
	scStopScript();
export lockv:
	moved=false;
	scWaitForActor(BLAKE);
	i=13;
loop:
	scActorTalk(VILA, DIALOG_EXTRAS,i);
	scWaitForActor(VILA);
	i=i+1;
	if(i<20) goto loop;

	campos=sfGetCameraCol();
	if( (campos+17)< sfGetCol(AVON) )
	{
		scPanCamera(30);
		scWaitForCamera();
		moved=true;
	}
	scDelay(50);
	scActorTalk(AVON, DIALOG_EXTRAS,20);
	scWaitForActor(AVON);
	if(moved){
		scPanCamera(campos);
		scWaitForCamera();
	}
	/* Give Battery to Blake */
	scPutInInventory(BATTERY);
	scSave();
	scEndDialog();
}


dialog DLG_GAN: script DLG_GAN stringpack DLG_GAN{
#ifdef ENGLISH
	option "Do you think you'll survive in Cygnus?" active -> cyggan;
	option "Will you be willing to attempt escape?" active -> escape;
#endif
#ifdef SPANISH
	      //++++++++++++++++++++++++++++++++++++++
	option "¿Crees que sobrevivirás en Cygnus?" active -> cyggan;
	option "¿Estás dispuesto a intentar escapar?" active -> escape;
#endif
}

/* Script that controls the dialog above */
script DLG_GAN{
	byte opt;
export escape: 
	opt=22;
	goto common; 
export cyggan:
	opt=21;
common:
	scWaitForActor(BLAKE);
	scActorTalk(GAN, DIALOG_EXTRAS,opt);
	scWaitForActor(GAN);
	scEndDialog();
}


stringpack 221{
#ifdef ENGLISH
	"Okay, stay back and quiet.";
	"This alarm is always failing.";
	"I deactivated it three times in our";
	"last trip. It fires for no reason.";
	"Let me check..";
	"Okay. No problem. Let's go.";
	
	//6
	"I said don't move!";
	
	//7
	"(Jenna... the guard...)";
	"(Okay I got you...)";
	"Please, help me get out of here.";
	"I will be REALLY grateful...";
	//11
	"Shut up you scum!";
	"You'll rot in Cygnus!";
	"I will visit you later, anyway.";
	
	//14
	"This time I think I got it!";
	"Here you are...";
#endif

#ifdef SPANISH
	//++++++++++++++++++++++++++++++++++++++
	"De acuerdo. Atrás y silencio.";
	"Esta alarma siempre falla.";
	"La desactivé tres veces en nuestro";
	"viaje anterior. Se dispara sola.";
	"A ver..";
	"Ningún problema. Vamos.";
	
	//6
	"¡Que no te muevas!";
	
	//7
	"(Jenna... el guarda...)";
	"(Ajá, te entiendo...)";
	"Por favor, sácame de aquí.";
	"Estaré MUY agradecida...";
	//11
	"¡Silencio, basura!";
	"¡Te pudrirás en Cygnus!";
	"Te visito luego, de todas formas.";
	
	//14
	"¡Esta vez lo hice!";
	"Aquí tienes...";
#endif
}


/* Script where the plan develops */
script 210
{
	//scCursorOn(false);
	scShowVerbs(false);
	scFreezeAllScripts(true);
	scLookDirection(BLAKE, FACING_DOWN);
	scBreakHere();
	scActorTalk(BLAKE,SPPLAN,0);
	scWaitForActor(BLAKE);
	scActorTalk(BLAKE,SPPLAN,1);
	scWaitForActor(BLAKE);
	scActorTalk(BLAKE,SPPLAN,2);
	scWaitForActor(BLAKE);	
	
	scActorTalk(AVON,SPPLAN,3);
	scWaitForActor(AVON);
	scActorTalk(AVON,SPPLAN,4);
	scWaitForActor(AVON);

	scActorTalk(BLAKE,SPPLAN,5);
	scWaitForActor(BLAKE);
	scActorTalk(BLAKE,SPPLAN,6);
	scWaitForActor(BLAKE);
	scActorTalk(BLAKE,SPPLAN,7);
	scWaitForActor(BLAKE);	

	scActorTalk(AVON,SPPLAN,8);
	scWaitForActor(AVON);
	
	scActorTalk(BLAKE,SPPLAN,9);
	scWaitForActor(BLAKE);	

	scActorTalk(AVON,SPPLAN,10);
	scWaitForActor(AVON);	
	scActorTalk(AVON,SPPLAN,11);
	scWaitForActor(AVON);	
	scActorTalk(AVON,SPPLAN,12);
	scWaitForActor(AVON);	

	scActorTalk(BLAKE,SPPLAN,13);
	scWaitForActor(BLAKE);	

	/*****/

	scActorTalk(JENNA,SPPLAN,14);
	scWaitForActor(JENNA);	

	scActorTalk(BLAKE,SPPLAN,15);
	scWaitForActor(BLAKE);	

	scActorTalk(JENNA,SPPLAN,16);
	scWaitForActor(JENNA);	
	
	scActorTalk(AVON,SPPLAN,17);
	scWaitForActor(AVON);	

	scActorTalk(BLAKE,SPPLAN,18);
	scWaitForActor(BLAKE);
	scActorTalk(BLAKE,SPPLAN,19);
	scWaitForActor(BLAKE);
	scActorTalk(BLAKE,SPPLAN,20);
	scWaitForActor(BLAKE);	

	scActorTalk(JENNA,SPPLAN,21);
	scWaitForActor(JENNA);
	
	scActorTalk(BLAKE,SPPLAN,22);
	scWaitForActor(BLAKE);
	scActorTalk(BLAKE,SPPLAN,23);
	scWaitForActor(BLAKE);
	scActorTalk(BLAKE,SPPLAN,24);
	scWaitForActor(BLAKE);	
	
	scActorTalk(AVON,SPPLAN,25);
	scWaitForActor(AVON);	
	scActorTalk(AVON,SPPLAN,26);
	scWaitForActor(AVON);	
	scActorTalk(AVON,SPPLAN,27);
	scWaitForActor(AVON);	
	scActorTalk(AVON,SPPLAN,28);
	scWaitForActor(AVON);	

	scActorTalk(JENNA,SPPLAN,29);
	scWaitForActor(JENNA);
	scActorTalk(AVON,SPPLAN,30);
	scWaitForActor(AVON);	
	scActorTalk(JENNA,SPPLAN,31);
	scWaitForActor(JENNA);

	//scCursorOn(true);
	scShowVerbs(true);
	scFreezeAllScripts(false);
	scSave();
	
}

/* Script that handles the entrance of guards when the alarm sounds */
script 211 
{
	byte i;

	scCursorOn(false);
	
	/* Move Blake below the alarm, faing down */
	scActorWalkTo(BLAKE, 24,14);
	scPanCamera(16);
	scWaitForActor(BLAKE);
	scLookDirection(BLAKE,FACING_DOWN);
	scWaitForCamera();
	
	/* Make fire... how to do this???? */
	scSetCostume(BLAKE,14,0);
	scSetAnimstate(BLAKE,0);
	scDelay(50);
	//scSetAnimstate(BLAKE,1); This one does not work too well
	//scDelay(50);
	
	for (i=0;i<=5; i=i+1){
		scSetAnimstate(BLAKE,2);
		scDelay(10);
		scSetAnimstate(BLAKE,3);
		scDelay(10);
		scSetAnimstate(BLAKE,4);
		scDelay(10);
		if(i==4) 	scPlaySFX(SFX_ALERT); // Alert sound
	}
		
	scSetCostume(BLAKE,0,0);
	scSetAnimstate(BLAKE,4);
	scRemoveFromInventory(WRAPPER);
	scBreakHere();
	
	/* Move all chars to correct positions */
	scTerminateScript(200); // Vila won't follow Blake anymore
	scActorWalkTo(BLAKE,10,13);
	scActorWalkTo(JENNA,5,13);
	scActorWalkTo(VILA,22,13);
	scWaitForActor(BLAKE);
	scWaitForActor(JENNA);
	scWaitForActor(VILA);
	scLookDirection(BLAKE,FACING_DOWN);
	scLookDirection(JENNA,FACING_RIGHT);
	scLookDirection(VILA,FACING_DOWN);
	
	// The door opens
	scPlaySFX(SFX_DOOR);
	scDelay(10);
	scSetAnimstate(200,1);
	scDelay(10);
	scSetAnimstate(200,2);
	scDelay(10);
	
	
	scSetPosition(GUARD, ROOM_LONDONCELL, 14, 0);
	scLookDirection(GUARD, FACING_RIGHT);
	scActorWalkTo(GUARD,2,14);
	scActorTalk(GUARD,221,0);
	scWaitForActor(GUARD);
	scDelay(10);
	scLoadObjectToGame(GUARD2);
	scSetPosition(GUARD2, ROOM_LONDONCELL, 14, 0);
	scLookDirection(GUARD2, FACING_RIGHT);
	scActorWalkTo(GUARD2,22,14);
	scWaitForActor(GUARD);	
	scSetAnimstate(GUARD,12);
	scWaitForActor(GUARD2);
		
	scActorTalk(GUARD2,221,1);
	scWaitForActor(GUARD2);
	scActorTalk(GUARD2,221,2);
	scWaitForActor(GUARD2);
	scActorTalk(GUARD2,221,3);
	scWaitForActor(GUARD2);
	scActorTalk(GUARD2,221,4);
	scWaitForActor(GUARD2);

	//scDelay(30);

	/* Time to do something */
	// Guard checks Blake does not move
	scSpawnScript(212);	
	scCursorOn(true);
	bTimeToGetCard=true;
	scDelay(200);
	scDelay(200);
	scCursorOn(false);
	bTimeToGetCard=false;
	
	/* Terminate Alarm */
	scStopSFX(SFX_ALERT);
	
	/* Guards leave */
	scActorTalk(GUARD2,221,5);
	scWaitForActor(GUARD2);	
	scActorWalkTo(GUARD2,0,14);
	scWaitForActor(GUARD2);
	scSetPosition(GUARD2, 255, 0, 0);
	scTerminateScript(212);
	scActorWalkTo(GUARD,0,14);
	scWaitForActor(GUARD);
	scSetPosition(GUARD, 255, 0, 0);
	
	
	// The door closes
	scPlaySFX(SFX_DOOR);
	scDelay(10);
	scSetAnimstate(200,1);
	scDelay(10);
	scSetAnimstate(200,0);
	scDelay(10);
	
	/* Vila gives the card to Blake */
	if(bCardTaken){
		scActorWalkTo(VILA,sfGetCol(BLAKE)+5,sfGetRow(BLAKE));
		scWaitForActor(VILA);
		scLookDirection(BLAKE, FACING_RIGHT);
		scActorTalk(VILA,221,14);
		scWaitForActor(VILA);
		scActorTalk(VILA,221,15);
		scWaitForActor(VILA);		
		scPutInInventory(KEYCARD);
	}
		
	scCursorOn(true);
	scBreakHere();
	scSave();
}

// Makes the guard take care if Blake moves
script 212{
	if( (sfGetCol(BLAKE)!=10) || (sfGetRow(BLAKE)!=13) )
	{
		scCursorOn(false);		
		scSetAnimstate(GUARD,0);
		scActorTalk(GUARD,221,6);
		scStopCharacterAction(BLAKE);		
		scWaitForActor(GUARD);
		scSetAnimstate(GUARD,12);
		scActorWalkTo(BLAKE,10,13);
		scWaitForActor(BLAKE);
		scLookDirection(BLAKE,FACING_DOWN);
		scCursorOn(true);
	}
	scDelay(2);
	scRestartScript();
}



/*BLAKE	If you had access to the computer, could you open the doors?
AVON	Of course. Why?
BLAKE	Just wondered how good you really were.
AVON	Don't try and manipulate me, Blake.
BLAKE	Now why should I try and do that?
AVON	You need my help.
BLAKE	Only if you can open the doors.
AVON	I could open every door, blind all the scanners, knock out the security overrides, and control the computer. Control the computer and you control the ship.
BLAKE	Then I do need your help. There's a service channel, runs the whole length of the ship. Every other compartment has an inspection hatch. The last one opens onto the computer section.
AVON	Give me one good reason why I should help you.
BLAKE	You're a civilized man, Avon. On Cygnus Alpha that will not be a survival characteristic.
AVON	An intelligent man can adapt.
BLAKE	Or recognize an alternative.
AVON	I already have one.
BLAKE	A private deal with the ship's crew to fake the running log? You've had four months to think about that. And it didn't take you that long to work out that they would have to kill you afterwards to keep you quiet.
AVON	Whereas you are offering me safety.
BLAKE	I'm offering you the chance of freedom.
AVON	Generous, considering mine will be the most important job.
BLAKE	You'll do it then.



We have less to loose.
AVON	You may have, but I value my life!
JENNA	Assuming they do land us somewhere, what then?
BLAKE	Find a way of getting back to Earth.
JENNA	Back to Earth?
BLAKE	Yes. That's where the heart of the Federation is. I intend to see that heart torn out.
AVON	I thought you were probably insane.
BLAKE	That's possible! They butchered my family, my friends. They murdered my past and gave me tranquilized dreams.
JENNA	At least you're still alive.
BLAKE	No! Not until free men can think and speak. Not until power is back with the honest man.
AVON	Have you ever met an honest man?
JENNA	[Glances at Blake] Perhaps.
AVON	Listen to me. Wealth is the only reality. And the only way to obtain wealth is to take it away from somebody else. Wake up, Blake! You may not be tranquilized any longer, but you're still dreaming.
JENNA	Maybe some dreams are worth having.
AVON	You don't really believe that.
JENNA	No, but I'd like to.
BLAKE	Yes, well, you asked me what I was going to do and I've told you. What you do is up to yourselves.
AVON	Right. A new identity, a job in the Federation Banking System. Three months with their computers, I could lift a hundred million credits and nobody would know where they went. Then let anyone try and touch me.
BLAKE	And the rest?
AVON	Have the same chance as I have.
BLAKE	You don't really believe that.



I'm going to kill one of your friends every thirty seconds starting now. I'll stop when you give yourselves up, or I run out of prisoners.
BLAKE	Raiker! Listen to me! Raiker, damn you, those men are unarmed!
RAIKER	The talking's over, Blake.
BLAKE	Let me talk to Leylan!
[Raiker replaces the communicator, and cuts Blake off]

BLAKE	[Furious] Raiker! Raiker! [Defeated, to Avon] Open the door.
AVON	You're throwing away our only chance.
BLAKE	Open the door!
[Avon opens the door.]

LEYLAN	Hands on your heads. Stand where you are.
BLAKE	Raiker's switched off... Tell him we're coming out... And quickly!
[Leylan nods, and Artix runs off.]

[Leylan, Teague and a guard enter. Teague unties Garton.]

[Artix bursts into the prison compartment and whispers to Raiker that the holdouts have surrendered. Raiker starts for the exit, stops, and calmly shoots another prisoner.]

[Leylan sees what's happened on the screen and doesn't seem impressed.]

LEYLAN	Move it.
[Everyone slowly heads for the exit.]

BLAKE	Commander, your first officer is guilty of murder. I demand that this incident is fully reported in your log.
LEYLAN	Now don't tell me how to run my ship, Blake... Everything that happens here is logged and filed with the Flight Authority and they'll take whatever action they deem necessary.
[Raiker enters]

RAIKER	You could have won, Blake. All you needed was guts.
BLAKE	I'll settle for yours!
[He lunges for Raiker, but is pinned by two guards. Raiker punches him in the chest.]

RAIKER	Take them back. Put them in close confinement. Not the girl. She and I have some unfinished business. [To Jenna] or did you think I'd forgotten?
LEYLAN	[Icily] Mister Raiker! Have you gone completely mad? [To the guard] Put her with the others. [To Artix] Mr. Artix, get a technical squad in there. I want that computer fully functional in ten minutes.
[Artix dashes away]

LEYLAN	Mr. Raiker! This time you went too far. There'll be an official inquiry.
RAIKER	Naturally, Sir. And I'm sure you'll confirm that I was acting with your full authority. There were other officers present who heard you give me permission to do what was necessary.
LEYLAN	Everything that was said or done by everybody... including me... will be in my report.
[Raiker doesn't look so confident]

[Switch to prison compartment]

[Jenna, Blake and Avon are firmly secured into seats by restraints]

JENNA	How do you feel?
BLAKE	Sick.
AVON	So you should. What a fiasco. You could take over the ship, you said, if I did my bit. Well, I did my bit, and what happened? Your troops bumble around looking for someone to surrender to, and when they've succeeded, you follow suit.
JENNA	What do you think they'll do to us?
BLAKE	Something unfriendly.
JENNA	For a while, I really thought we'd made it.
BLAKE	[Sighs] It was my fault.
AVON	We know.
BLAKE	I'll try and do better next time.
AVON	We had one chance. You wasted it. There won't be a next time.
JENNA	In which case, you can die content.
AVON	[Almost laughs] Content.
JENNA	Knowing you were right.

*/


