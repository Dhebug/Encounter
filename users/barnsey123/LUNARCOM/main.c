/*
Tycho Blue
A Moon Adventure for the Oric Atmos by Neil Barnes
Chapter X. Introduction of Agents Green and Blue, the Agency Boss, 
Blondie and the Rebel Commander

SCENES:

SceneA: Debrief of Agent Blue about the failed mission to protect the US Confederate
ambassador to UK and the disappearance of Agent Green. Who? Why? What?
SceneB: Thermal Imaging of both The Assasination , The Chase and the disappearance of 
Agent Green near a mothballed US Air Base. Text of Blue's account.
SceneC: Agent Blue receives phone call from a shadowy figure known as the
Rebel Commander. "We have him. Don't get in our way" 
SceneD: Flashback: Pyong Yang: Rescue of Blue by Green from the Chinese Army of
Occupation. 

History
04/02/2014 Started work with first few vids and sorted out display routines
05/02/2014 added more vids
*/
#include <lib.h>
#define BLACK 0
#define RED	1
#define GREEN 2
#define YELLOW 3
#define BLUE 4
#define MAGENTA 5
#define CYAN 6
#define WHITE 7
/* Definition of Global variables */
extern unsigned char Tears[];		// video talking 
extern unsigned char LookRight[];	// video looking right
extern unsigned char Yabber[];		// video talking
extern unsigned char YouFuck[];		// video "you fuck"
extern unsigned char Whoops[];		// video whoops
extern unsigned char NodYes[];		// video nodding
extern unsigned char LeanForward[];	// video leaning forward
unsigned char Frame;				// Frame of video to play
int PauseTime,p;					// amount of time to Pause
unsigned char* PtrGraphic;			// pointer to byte values of loaded picture
unsigned char InkColor;
/* Listing of Functions */

void Pause();		// adds pause to video playback
void PlayLeanForward();	// LeanForward
void PlayLeanForwardA();	
void PlayLookRight();	// Look Right
void PlayLookRightA();	
void PlayNodYes();	// Nod yes
void PlayNodYesA();
void PlayTears();	// Pretend Tears
void PlayTearsA();
void PlayYabber();	// general talking
void PlayYabberA();
void PlayYouFuck();	// Go away you nasty man
void PlayYouFuckA();
void PlayWhoops();	// Did I swear?
void PlayWhoopsA();
void PlayVideo();	// play all video

/* Main Program */

void main(){
	hires();
	InkColor=CYAN; VideoInkLeft();	// set ink to right of video
	PauseTime=900;
	for(;;){
		PlayVideo();
	}
}


/* Definition of Functions */

void PlayVideo()	{
  /*PtrGraphic=BlahBlah;	// pointer to byte values of loaded video	
  for (Frame=0;Frame<12;Frame++){
    DisplayFrame();	// print a frame	
    PauseTime=900;	// define length of Pause
    //Pause();		// add a pause
    //getchar();
  }	*/
  // Look Right and back
  // look right
  PlayLookRight();
  PlayYabber();PlayYabber();PlayYabber();
  PlayTears();
  PlayYouFuck();
  PlayWhoops();
  PlayYabber();PlayYabber();
  PlayNodYes();
  PlayLeanForward();
  
  /*PlayTears();
  PlayYouFuck();
  PlayLookRight();
  PlayLeanForward();
  PlayWhoops();
  PlayNodYes();*/
  
}
void Pause(){
  for (p=0; p<PauseTime;p++){};
}
void PlayLeanForward(){
	// look right
	for (Frame=0;Frame<6;Frame++){
	  PlayLeanForwardA();
  	}
  	// look back
  	for (Frame=5;Frame>0;Frame--){
	  PlayLeanForwardA();
  	}
}
void PlayLeanForwardA(){
	PtrGraphic=LeanForward;
	DrawFrame();  
	Pause();
}

void PlayLookRight(){
	// look right
	for (Frame=0;Frame<6;Frame++){
	  PlayLookRightA();
  	}
  	// look back
  	for (Frame=5;Frame>0;Frame--){
	  PlayLookRightA();
  	}
}
void PlayLookRightA(){
	PtrGraphic=LookRight;
	DrawFrame();  
	Pause();
}

void PlayNodYes(){
	// tears
	for (Frame=0;Frame<6;Frame++){
	  PlayNodYesA();
  	}
  	// tears back
  	for (Frame=5;Frame>0;Frame--){
	  PlayNodYesA();
  	}
}
void PlayNodYesA(){
	PtrGraphic=NodYes;
	DrawFrame();  
	Pause();
}

void PlayTears(){
	// tears
	for (Frame=0;Frame<6;Frame++){
	  PlayTearsA();
  	}
  	// tears back
  	for (Frame=5;Frame>0;Frame--){
	  PlayTearsA();
  	}
}
void PlayTearsA(){
	PtrGraphic=Tears;
	DrawFrame();  
	Pause();
}

void PlayYabber(){
	// tears
	for (Frame=0;Frame<6;Frame++){
	  PlayYabberA();
  	}
  	// tears back
  	for (Frame=5;Frame>0;Frame--){
	  PlayYabberA();
  	}
}
void PlayYabberA(){
	PtrGraphic=Yabber;
	DrawFrame();  
	Pause();
}
void PlayYouFuck(){
	// tears
	for (Frame=0;Frame<6;Frame++){
	  PlayYouFuckA();
  	}
  	// tears back
  	for (Frame=5;Frame>0;Frame--){
	  PlayYouFuckA();
  	}
}
void PlayYouFuckA(){
	PtrGraphic=YouFuck;
	DrawFrame();  
	Pause();
}

void PlayWhoops(){
	// tears
	for (Frame=0;Frame<6;Frame++){
	  PlayWhoopsA();
  	}
  	// tears back
  	for (Frame=5;Frame>0;Frame--){
	  PlayWhoopsA();
  	}
}
void PlayWhoopsA(){
	PtrGraphic=Whoops;
	DrawFrame();  
	Pause();
}

