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
07/02/2014 New PlayChunk routine (more efficient), more vids
09/02/2014 Using file_unpack to compress the video images
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
#define MAXFRAME 6
#define FRAMEWIDTH 12
#define FRAMEHEIGHT 48
#define FRAMECOUNT 6
/* Definition of Global variables */
extern unsigned char CheckWatch[];	// video check the watch
extern unsigned char Disdain[];		// video "don't care/not bothered"
extern unsigned char LeanForward[];	// video leaning forward
extern unsigned char LookRight[];	// video looking right
extern unsigned char NodYes[];		// video nodding
extern unsigned char Tears[];		// video talking 
extern unsigned char Whoops[];		// video whoops
extern unsigned char Yabber[];		// video talking
extern unsigned char YouFuck[];		// video "you fuck"
unsigned char UnPack[FRAMEWIDTH*FRAMEHEIGHT*FRAMECOUNT]; // where the image data gets unpacked to
unsigned char Frame, MaxFrame;	// Frame of video to play up to MaxFrame
int PauseTime,PauseCount;			// amount of time to Pause
unsigned char* PtrGraphic;			// pointer to byte values of picture
unsigned char* PtrUnPack;			// pointer to byte values of unpacked picture
unsigned char InkColor;
/* Listing of Functions */
void Pause();		// adds pause to video playback
void PlayChunk(unsigned char Chunk[]);	// play part of video
void PlayVideo();	// play all video

/****************/
/* Main Program */
/****************/
void main(){
	hires();
	InkColor=CYAN; VideoInkLeft();	// set ink to right of video
	PauseTime=900;
	for(;;){
		PlayVideo();
	}
}


/* Definition of Functions */

void PlayVideo(){
  MaxFrame=MAXFRAME; // this gets reset at end of PlayChunk so can be freely changed
  PlayChunk(Yabber);PlayChunk(Yabber);
  MaxFrame=4;PlayChunk(LookRight); 
  PlayChunk(Yabber);
  PlayChunk(CheckWatch);
  PlayChunk(Yabber);PlayChunk(Yabber);
  MaxFrame=4;PlayChunk(YouFuck);
  PlayChunk(Yabber);
  PlayChunk(Tears);
  //PlayChunk(LookRight);
  PlayChunk(LeanForward);
  PlayChunk(Yabber);PlayChunk(Yabber);
  PlayChunk(Whoops);
  MaxFrame=3;PlayChunk(LookRight);
  PlayChunk(Yabber);
  PlayChunk(NodYes);
  PlayChunk(Yabber);PlayChunk(Yabber);
  PlayChunk(Disdain);
  PlayChunk(Yabber);
  PlayChunk(CheckWatch);
  PlayChunk(YouFuck);
}

// Chunk[] contains packed data (e.g Yabber.s)
void PlayChunk(unsigned char Chunk[]){
	PtrUnPack=UnPack;				// set the pointer to UnPack (destination of unpacked data)
	file_unpack(PtrUnPack,Chunk);	// Unpack gets populated with unpacked Chunk
	// Play frames sequentually
	for (Frame=0;Frame<MaxFrame; Frame++){
		PtrGraphic=UnPack;			// point to start of unpack
		DrawFrame();				// PtrGraphic and Frame used in this ASM function
		Pause();					// Stop frames playing too fast
	}
	// Play Frames in reverse order
	for (Frame=MaxFrame-1;Frame>0;Frame--){
		PtrGraphic=UnPack;			// point to start of unpack
		DrawFrame();				// PtrGraphic and Frame used in this ASM function
		Pause();					// Stop frames playing too fast
	}
	MaxFrame=MAXFRAME;				// reset MaxFrame to be default value
}

void Pause(){
  for (PauseCount=0; PauseCount<PauseTime;PauseCount++){};
}




