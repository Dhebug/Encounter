/****************************/
/* Blake's 7: the Oric game */
/* Using OASIS              */
/* (c) Chema - 2016         */
/****************************/

#include "globals.h"

#define DIALOG_SCRIPT 	220
#define DIALOG_STRINGS	221
#define DIALOG_OPTIONS 	220
#define DIALOG_1	200

#define NURSE 	254

#define EXIT 	221

/* Dialog with the Nurse */
dialog DIALOG_1: script DIALOG_SCRIPT stringpack DIALOG_OPTIONS{
#ifdef ENGLISH
	option "I have a terrible backache." active -> back;
	option "I have a terrible stomachache." active -> stomach;
	option "I have a terrible constipation." active -> constipation;
	option "I have a terrible toothache." active -> tooth;
	option "Nothing, thank you." active -> bye;
#endif
#ifdef SPANISH
	option "Me duele mucho la espalda." active -> back;
	option "El estómago me duele mucho." active -> stomach;
	option "Tengo un estreñimiento horrible." active -> constipation;
	option "Me duele mucho una muela." active -> tooth;
	option "Nada, gracias." active -> bye;
#endif
}

/* Script that controls the dialog above */
script DIALOG_SCRIPT{
	byte opt;
export back: 
	opt=4;
	goto common; 
export stomach:
	opt=5;
	goto common;
export constipation:
	opt=6;
	goto common;	
export tooth:
	opt=7;	
common:
	scWaitForActor(BLAKE);
	scActorTalk(NURSE, DIALOG_STRINGS,2);
	scWaitForActor(NURSE);
	scActorTalk(NURSE, DIALOG_STRINGS,opt);
	scWaitForActor(NURSE);
	scLookDirection(NURSE, FACING_RIGHT);	
	scActorTalk(NURSE, DIALOG_STRINGS,3);
	scWaitForActor(NURSE);
	scActorTalk(BLAKE, DIALOG_STRINGS,8);
	scWaitForActor(BLAKE);
	scActorTalk(BLAKE, DIALOG_STRINGS,9);
	scWaitForActor(BLAKE);
	if((opt==6)&&(!bNurseGaveLaxative))
	{
		scActorTalk(NURSE, DIALOG_STRINGS,10);
		scWaitForActor(NURSE);
		scActorTalk(NURSE, DIALOG_STRINGS,11);
		scWaitForActor(NURSE);
		scPutInInventory(LAXATIVE);
		bNurseGaveLaxative=true;
		scSave();
	}
	bEscapeFromNurse=true;
	goto end;
export bye:
	scActorTalk(NURSE, DIALOG_STRINGS,12);
	scWaitForActor(NURSE);
	scActorTalk(NURSE, DIALOG_STRINGS,13);
	scWaitForActor(NURSE);
	scActorTalk(BLAKE, DIALOG_STRINGS,14);
	scWaitForActor(BLAKE);	
	scActorTalk(NURSE, DIALOG_STRINGS,15);
	scWaitForActor(NURSE);	
end:
	/* End dialog, back to commands */
	bAutoExit=true;	
	//scWaitForActor(BLAKE);
	scLookDirection(NURSE, FACING_DOWN);
	scEndDialog();
	scCursorOn(false);
	scExecuteAction(BLAKE,VERB_WALKTO,EXIT,255);
}

stringpack DIALOG_STRINGS
{
#ifdef ENGLISH
	"Not what I'd call relaxing..";
	"Hello deary. How can I help?";
	
	//2
	"Easy as pie...";
	"and let's proceed NOW.";
	//4
	"Let me get the extra-large syringe";
	"Let me get the gastric tube";
	"Let me get the rectal enema";
	"Let me get the dental forceps";
	
	//8
	"Err.. no thanks.";
	"I am feeling much better now. Bye!";

	//10
	"At least take this laxative.";
	"Just one drop! It's very powerful.";
	
	//12
	/*++++++++++++++++++++++++++++++++++++++*/
	"Do you happen to know if the coffee";
	"machine has been re-filled?";
	"No.";
	"Pity. I need a coffee badly.";
#endif
#ifdef SPANISH
	"No me da mucha tranquilidad...";
	"Hola cariño. ¿Cómo puedo ayudarte?";
	
	//2
	"Eso es un momento...";
	"y procedamos AHORA MISMO.";
	//4
	"Déjame coger la jeringuilla larga";
	"Déjame coger el tubo gástrico";
	"Déjame coger el enema rectal";
	"Déjame coger los fórceps dentales";
	
	//8
	"Eeee... no gracias.";
	"Me encuentro mejor. ¡Adiós!";

	//10
	"Al menos toma este laxante.";
	"¡Sólo una gota! Es muy potente.";
	
	//12
	/*++++++++++++++++++++++++++++++++++++++*/
	"¿Sabes si por casualidad han rellenado";
	"la máquina de café?";
	"No.";
	"Vaya. Me hace falta un café.";
#endif
}


objectcode NURSE
{
	byte actor;
	LookAt: 
		actor=sfGetActorExecutingAction();
		scActorTalk(actor,DIALOG_STRINGS,0);
		scWaitForActor(actor);
		scStopScript();
	TalkTo:
		scCursorOn(false);
		scActorTalk(NURSE,DIALOG_STRINGS,1);
		scWaitForActor(NURSE);
		scCursorOn(true);
		scLoadDialog(DIALOG_1);
		scStartDialog();
}


objectcode EXIT
{
	byte actor;
	WalkTo:
	Use:
		actor=sfGetActorExecutingAction();
		scSetPosition(actor, ROOM_HALLWAY, 13, 72);
		scLookDirection(actor, FACING_DOWN);
		scChangeRoomAndStop(ROOM_HALLWAY);
}
