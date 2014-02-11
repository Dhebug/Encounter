/*
Shuttle Movie
11-02-2014 started work
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
#define FRAMEWIDTH 33
#define FRAMEHEIGHT 147
#define FRAMECOUNT 1
/* Definition of Global variables */
extern unsigned char SHUTTLE00[];	
extern unsigned char SHUTTLE01[];		
extern unsigned char SHUTTLE02[];	
extern unsigned char SHUTTLE03[];
extern unsigned char SHUTTLE04[];		
extern unsigned char SHUTTLE05[];		 
extern unsigned char SHUTTLE06[];		
extern unsigned char SHUTTLE07[];		
extern unsigned char SHUTTLE08[];	

extern unsigned char SHUTTLE09[];	
extern unsigned char SHUTTLE10[];		
extern unsigned char SHUTTLE11[];	
extern unsigned char SHUTTLE12[];		
extern unsigned char SHUTTLE13[];		 
extern unsigned char SHUTTLE14[];		
extern unsigned char SHUTTLE15[];		
extern unsigned char SHUTTLE16[];	

extern unsigned char SHUTTLE17[];	
extern unsigned char SHUTTLE18[];		
extern unsigned char SHUTTLE19[];	
extern unsigned char SHUTTLE20[];		
extern unsigned char SHUTTLE21[];		 
extern unsigned char SHUTTLE22[];		
extern unsigned char SHUTTLE23[];		
extern unsigned char SHUTTLE24[];	

extern unsigned char SHUTTLE25[];	
extern unsigned char SHUTTLE26[];		
extern unsigned char SHUTTLE27[];	
extern unsigned char SHUTTLE28[];		
extern unsigned char SHUTTLE29[];		 


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
	InkColor=CYAN; VideoInkLeft();	// set ink to right of video
	//PauseTime=900;
	for(;;){
		PlayVideo();
	}
}


/* Definition of Functions */

void PlayVideo(){
  MaxFrame=MAXFRAME; // this gets reset at end of PlayChunk so can be freely changed
  PlayChunk(SHUTTLE00);
  PlayChunk(SHUTTLE01);
  PlayChunk(SHUTTLE02);
  PlayChunk(SHUTTLE03);
  PlayChunk(SHUTTLE04); 
  PlayChunk(SHUTTLE05);
  PlayChunk(SHUTTLE06);
  PlayChunk(SHUTTLE07);
  PlayChunk(SHUTTLE08);
  
  PlayChunk(SHUTTLE09);
  PlayChunk(SHUTTLE10);
  PlayChunk(SHUTTLE11);
  PlayChunk(SHUTTLE12); 
  PlayChunk(SHUTTLE13);
  PlayChunk(SHUTTLE14);
  PlayChunk(SHUTTLE15);
  PlayChunk(SHUTTLE16);
  
  PlayChunk(SHUTTLE17);
  PlayChunk(SHUTTLE18);
  PlayChunk(SHUTTLE19);
  PlayChunk(SHUTTLE20); 
  PlayChunk(SHUTTLE21);
  PlayChunk(SHUTTLE22);
  PlayChunk(SHUTTLE23);
  PlayChunk(SHUTTLE24);
  
  PlayChunk(SHUTTLE25);
  PlayChunk(SHUTTLE26);
  PlayChunk(SHUTTLE27);
  PlayChunk(SHUTTLE28); 
  PlayChunk(SHUTTLE29);

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




