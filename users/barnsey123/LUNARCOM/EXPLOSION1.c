/*
Explosion 1 Movie
18-02-2014 started work
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
#define MAXFRAME 1
#define FRAMEWIDTH 16
#define FRAMEHEIGHT 72
#define FRAMECOUNT 1
/* Definition of Global variables */
extern unsigned char EXPLOSION100[];	
extern unsigned char EXPLOSION101[];		
extern unsigned char EXPLOSION102[];	
extern unsigned char EXPLOSION103[];
extern unsigned char EXPLOSION104[];		
extern unsigned char EXPLOSION105[];		 
extern unsigned char EXPLOSION106[];		
extern unsigned char EXPLOSION107[];		
extern unsigned char EXPLOSION108[];	

extern unsigned char EXPLOSION109[];	
extern unsigned char EXPLOSION110[];		
extern unsigned char EXPLOSION111[];	
extern unsigned char EXPLOSION112[];		
extern unsigned char EXPLOSION113[];		 
extern unsigned char EXPLOSION114[];		
extern unsigned char EXPLOSION115[];		
	 
	 


unsigned char UnPack[FRAMEWIDTH*FRAMEHEIGHT*FRAMECOUNT]; // where the image data gets unpacked to
unsigned char Frame, MaxFrame;	// Frame of video to play up to MaxFrame
//int PauseTime,PauseCount;			// amount of time to Pause
unsigned char* PtrGraphic;			// pointer to byte values of picture
unsigned char* PtrUnPack;			// pointer to byte values of unpacked picture
unsigned char InkColor;
/* Listing of Functions */
//void Pause();		// adds pause to video playback
void PlayChunk(unsigned char Chunk[]);	// play part of video
void PlayVideo();	// play all video

/****************/
/* Main Program */
/****************/
void main(){
	hires();
	InkColor=RED; VideoInkLeft();	// set ink to right of video
	//PauseTime=900;
	for(;;){
		PlayVideo();
	}
}


/* Definition of Functions */

void PlayVideo(){
  MaxFrame=MAXFRAME; // this gets reset at end of PlayChunk so can be freely changed
  PlayChunk(EXPLOSION100);
  PlayChunk(EXPLOSION101);
  PlayChunk(EXPLOSION102);
  PlayChunk(EXPLOSION103);
  PlayChunk(EXPLOSION104); 
  PlayChunk(EXPLOSION105);
  PlayChunk(EXPLOSION106);
  PlayChunk(EXPLOSION107);
  PlayChunk(EXPLOSION108);
  
  PlayChunk(EXPLOSION109);
  PlayChunk(EXPLOSION110);
  PlayChunk(EXPLOSION111);
  PlayChunk(EXPLOSION112); 
  PlayChunk(EXPLOSION113);
  PlayChunk(EXPLOSION114);
  PlayChunk(EXPLOSION115);

}

// Chunk[] contains packed data (e.g Yabber.s)
void PlayChunk(unsigned char Chunk[]){
	PtrUnPack=UnPack;				// set the pointer to UnPack (destination of unpacked data)
	file_unpack(PtrUnPack,Chunk);	// Unpack gets populated with unpacked Chunk
	// Play frames sequentually
	//for (Frame=0;Frame<MaxFrame; Frame++){
		PtrGraphic=UnPack;			// point to start of unpack
		DrawFrame();				// PtrGraphic and Frame used in this ASM function
		//Pause();					// Stop frames playing too fast
	//}
	// Play Frames in reverse order
	/*for (Frame=MaxFrame-1;Frame>0;Frame--){
		PtrGraphic=UnPack;			// point to start of unpack
		DrawFrame();				// PtrGraphic and Frame used in this ASM function
		Pause();					// Stop frames playing too fast
	}*/
	//MaxFrame=MAXFRAME;				// reset MaxFrame to be default value
}
/*
void Pause(){
  for (PauseCount=0; PauseCount<PauseTime;PauseCount++){};
}*/




