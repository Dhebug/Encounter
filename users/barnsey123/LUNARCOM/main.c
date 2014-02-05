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
extern unsigned char YouFuck[];		// video "you fuck"
unsigned char Frame;				// Frame of video to play
int PauseTime,p;					// amount of time to Pause
unsigned char* PtrGraphic;			// pointer to byte values of loaded picture
unsigned char InkColor;
/* Listing of Functions */

void Pause();		// adds pause to video playback
void PlayLookRight();	// Look Right
void PlayLookRightA();	
void PlayTears();	// Pretend Tears
void PlayTearsA();
void PlayYouFuck();	// Go away you nasty man
void PlayYouFuckA();
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
  PlayTears();
  PlayYouFuck();
  
}
void Pause(){
  for (p=0; p<PauseTime;p++){};
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

