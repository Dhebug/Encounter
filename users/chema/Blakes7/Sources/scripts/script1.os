#include "globals.h"


/* Script 1: Default responses to
   undefined actions */
#define MAINSTRINGS 0
   
script 1 {
	byte ac;

	ac=sfGetActorExecutingAction();
		
	if(ac==255) ac=sfGetEgo();
	
	// Call object's USE response if not in target
	if(sfGetActionVerb()==VERB_USE){
		// This one for guns and such, to avoid duplicities...
		if(sfGetActionObject1()==GUN || sfGetActionObject1()==CATPULT){
			scActorTalk(ac,MAINSTRINGS,9);
			scStopScript();
		}
		if(sfGetActionObject2()!=255){
			//If arrived here the object 2 did not have an entry, try with the object 1
			scRunObjectCode(VERB_USE,sfGetActionObject1(),255);
			//scActorTalk(sfGetEgo(),MAINSTRINGS,10);
			scStopScript();
		}
		else{
			scActorTalk(sfGetEgo(),MAINSTRINGS,10);
			scStopScript();
		}

	}

	if(sfGetActionVerb()==VERB_LOOKAT){ 
		scActorTalk(ac,MAINSTRINGS,sfGetRandInt(5,8));
		scStopScript();
	}	

	// Default error message
	scActorTalk(ac,MAINSTRINGS,sfGetRandInt(0,4));
}


