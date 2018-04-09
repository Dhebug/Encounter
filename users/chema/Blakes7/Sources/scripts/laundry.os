/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/* Traduction FR:laurentd75	*/
/****************************/

#include "globals.h"

#define EXIT		200
#define ROBOT		201



// String pack for descriptions in this room
#define STDESC  	200

#define DIALOG_SCRIPT 	220
#define DIALOG_OPTIONS 	220
#define DIALOG_1	200

script 200{
	
}

objectcode EXIT{
	WalkTo:
		scSetPosition(sfGetActorExecutingAction(),ROOM_CORRIDOR,14,67);
		scLookDirection(sfGetActorExecutingAction(),FACING_DOWN);
		scChangeRoomAndStop(ROOM_CORRIDOR);	
}

objectcode ROBOT{
	LookAt:
		scActorTalk(sfGetEgo(),STDESC,0);
		scStopScript();
	TalkTo:
		if(bUniformTaken){
			scActorTalk(sfGetEgo(),STDESC,10);
			scStopScript();		
		}
		scCursorOn(false);
		scSpawnScript(201);
		scPrint(STDESC,2);
		scDelay(120);		
		scPrint(STDESC,3);
		scDelay(120);	
		scPrint(STDESC,1);
		scTerminateScript(201);
		scSetAnimstate(ROBOT,0);
		scCursorOn(true);
		scLoadDialog(DIALOG_1);
		scStartDialog();
}


dialog DIALOG_1: script DIALOG_SCRIPT stringpack DIALOG_OPTIONS{
#ifdef ENGLISH
	option "I want to pick up my clothes." active -> pickup;
	option "No. Is there anything I could do?" inactive -> nocode;
	option "Yes, code is SP-1999-CH." inactive -> code;
	option "That's all, thank you. Bye." active -> bye;
#endif

#ifdef FRENCH
	option "Je voudrais recuperer mes vetements." active -> pickup;
	// [laurentd75]: mismatch between ES and EN sentences, choosing the ES version:
	option "Non. Pouvez-vous faire quelque chose?" inactive -> nocode;
	option "Oui, le code est SP-1999-CH." inactive -> code;
	option "Ce sera tout, merci. Au revoir." active -> bye;
#endif

#ifdef SPANISH
	option "Quiero recoger mi ropa." active -> pickup;
	option "No. ¿Puede hacer algo?" inactive -> nocode;
	option "Sí, el código es SP-1999-CH." inactive -> code;
	option "Eso es todo, gracias. Adiós." active -> bye;
#endif
}

/* Script that controls the dialog above */
script DIALOG_SCRIPT{
export pickup: 
	scWaitForActor(sfGetEgo());
	scSpawnScript(201);
	scPrint(STDESC,5);
	scDelay(120);	
	scPrint(STDESC,1);
	scTerminateScript(201);
	scSetAnimstate(ROBOT,0);
	scActivateDlgOption(0,false);
	scActivateDlgOption(1,true);
	if(bLaundryMesgSeen)
		scActivateDlgOption(2,true);
common:
	scStartDialog();
	scStopScript();
export nocode:
	scWaitForActor(sfGetEgo());
	scSpawnScript(201);
	scPrint(STDESC,6);
	scDelay(120);	
	scPrint(STDESC,7);
	scDelay(120);	
	scPrint(STDESC,8);
	scDelay(120);	
	scPrint(STDESC,1);
	scTerminateScript(201);
	scSetAnimstate(ROBOT,0);
	goto bye1;
export code:
	scWaitForActor(sfGetEgo());
	scSpawnScript(201);
	scPrint(STDESC,9);
	scDelay(120);	
	scTerminateScript(201);	
	bUniformTaken=true; 
	/* Give clothes, save ... */
	scPutInInventory(UNIFORM);
	scSave();
export bye:
bye1:
	scWaitForActor(sfGetEgo());
	scSpawnScript(201);
	scPrint(STDESC,4);
	scDelay(120);	
	scPrint(STDESC,1);
	scTerminateScript(201);	
	scSetAnimstate(ROBOT,0);
	/* End dialog, back to commands */
	scEndDialog();
}

// Robot speaking
script 201{
	scSetAnimstate(ROBOT,1);
	scDelay(sfGetRandInt(1,6));
	scSetAnimstate(ROBOT,0);
	scDelay(sfGetRandInt(1,6));	
	scRestartScript();
}
	


stringpack STDESC{
#ifdef ENGLISH
	/***************************************/
	"A strange robot is at the counter.";
	" ";
	" Welcome to Fresh Laundry, sir.";
	" What can I do for you?";
	" At your service. Have a nice day.";
	" Sure, do you have the code?";
	" Sorry.";
	" Check your personal messages,";  // [laurentd75]: correction personnal -> personal
	" you should have received the code.";
	" Sure, sir. Here it is.";
	"I don't need anything from him.";
#endif

#ifdef FRENCH
	/***************************************/
	"Il y a un étrange robot au comptoir.";
	" ";
	" Bienvenue a la Teinturerie Fresh.";
	" Que puis-je faire pour vous monsieur?";
	" A votre service. Bonne journée.";
	" Bien sur, avez-vous le code?";
	" Non, désolé.";
	" Vérifiez vos messages personnels,";
	" vous devriez avoir recu le code.";
	" Merci, voici votre uniforme monsieur."; //
	"Je n'ai rien a lui demander.";
#endif

#ifdef SPANISH
	/***************************************/	
	"Un extraño robot está al mostrador.";
	" ";
	" Bienvenido a Lavandería Fresh, señor.";
	" ¿Qué puedo hacer por usted?";
	" A su servicio. Tenga un buen día.";
	" Por supuesto, ¿tiene el código?";
	" Lo siento.";
	" Compruebe sus mensajes personales,";
	" debería haber recibido el código.";	
	" Claro, señor. Aquí está.";
	"No necesito nada de él.";	
#endif
	
}



