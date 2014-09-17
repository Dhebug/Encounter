/*
ASTEROID4 Movie
17-09-2014 started work
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
#define FRAMEWIDTH 31
#define FRAMEHEIGHT 84
#define FRAMECOUNT 1
/* Definition of Global variables */
extern unsigned char ASTEROID400[];	
extern unsigned char ASTEROID401[];		
extern unsigned char ASTEROID402[];	
extern unsigned char ASTEROID403[];
extern unsigned char ASTEROID404[];		
extern unsigned char ASTEROID405[];		 
extern unsigned char ASTEROID406[];		
extern unsigned char ASTEROID407[];		
extern unsigned char ASTEROID408[];	
extern unsigned char ASTEROID409[];	

extern unsigned char ASTEROID410[];		
extern unsigned char ASTEROID411[];	
extern unsigned char ASTEROID412[];		
extern unsigned char ASTEROID413[];		 
extern unsigned char ASTEROID414[];		
extern unsigned char ASTEROID415[];		
extern unsigned char ASTEROID416[];	
extern unsigned char ASTEROID417[];	
extern unsigned char ASTEROID418[];		
extern unsigned char ASTEROID419[];	
	
extern unsigned char ASTEROID420[];	
extern unsigned char ASTEROID421[];		
extern unsigned char ASTEROID422[];	
extern unsigned char ASTEROID423[];
extern unsigned char ASTEROID424[];		
extern unsigned char ASTEROID425[];		 
extern unsigned char ASTEROID426[];		
extern unsigned char ASTEROID427[];		
extern unsigned char ASTEROID428[];	
extern unsigned char ASTEROID429[];
	
extern unsigned char ASTEROID430[];		
extern unsigned char ASTEROID431[];	
extern unsigned char ASTEROID432[];		
extern unsigned char ASTEROID433[];		 
extern unsigned char ASTEROID434[];		
extern unsigned char ASTEROID435[];		
extern unsigned char ASTEROID436[];	
extern unsigned char ASTEROID437[];	
extern unsigned char ASTEROID438[];		
extern unsigned char ASTEROID439[];	

extern unsigned char ASTEROID440[];	
//extern unsigned char ASTEROID441[];	
/*
char* frame[]={
	"ASTEROID400",
	"ASTEROID401",
	"ASTEROID402",
	"ASTEROID403",
	"ASTEROID404",
	"ASTEROID405",
	"ASTEROID406",
	"ASTEROID407",
	"ASTEROID408",
	"ASTEROID409",
	"ASTEROID410",
	"ASTEROID411",
	"ASTEROID412",
	"ASTEROID413",
	"ASTEROID414",
	"ASTEROID415",
	"ASTEROID416",
	"ASTEROID417",
	"ASTEROID418",
	"ASTEROID419",
	"ASTEROID420",
	"ASTEROID421",
	"ASTEROID422",
	"ASTEROID423",
	"ASTEROID424",
	"ASTEROID425",
	"ASTEROID426",
	"ASTEROID427",
	"ASTEROID428",
	"ASTEROID429",
	"ASTEROID430",
	"ASTEROID431",
	"ASTEROID432",
	"ASTEROID433",
	"ASTEROID434",
	"ASTEROID435",
	"ASTEROID436",
	"ASTEROID437",
	"ASTEROID438",
	"ASTEROID439",
	"ASTEROID440"
};
unsigned char frameCount=0; 
unsigned char totalFrames=40;
*/
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
	InkColor=GREEN; VideoInkLeft();	// set ink to right of video
	//PauseTime=900;
	for(;;){
		PlayVideo();
	}
}


/* Definition of Functions */

void PlayVideo(){
  MaxFrame=MAXFRAME; // this gets reset at end of PlayChunk so can be freely changed
  /*
  for (frameCount = 0 ; frameCount <= totalFrames ; frameCount++ ){
	  PlayChunk(*frame[frameCount]);
  }
  for (frameCount =totalFrames-1; frameCount >= 0 ; frameCount--){
	  PlayChunk(*frame[frameCount]);
  }*/
  
  PlayChunk(ASTEROID400);
  //PlayChunk(ASTEROID401);
  PlayChunk(ASTEROID402);
  //PlayChunk(ASTEROID403);
  PlayChunk(ASTEROID404); 
  //PlayChunk(ASTEROID405);
  PlayChunk(ASTEROID406);
  //PlayChunk(ASTEROID407);
  PlayChunk(ASTEROID408);
  //PlayChunk(ASTEROID409);
  
  PlayChunk(ASTEROID410);
  //PlayChunk(ASTEROID411);
  PlayChunk(ASTEROID412); 
  //PlayChunk(ASTEROID413);
  PlayChunk(ASTEROID414);
  //PlayChunk(ASTEROID415);
  PlayChunk(ASTEROID416); 
  //PlayChunk(ASTEROID417);
  PlayChunk(ASTEROID418);
  //PlayChunk(ASTEROID419);
  
  //PlayChunk(ASTEROID420);
  PlayChunk(ASTEROID421);
  PlayChunk(ASTEROID422); 
  //PlayChunk(ASTEROID423);
  PlayChunk(ASTEROID424);
  //PlayChunk(ASTEROID425);
  PlayChunk(ASTEROID426); 
  //PlayChunk(ASTEROID427);
  PlayChunk(ASTEROID428);
  //PlayChunk(ASTEROID429);
  
  PlayChunk(ASTEROID430);
  //PlayChunk(ASTEROID431);
  PlayChunk(ASTEROID432); 
  //PlayChunk(ASTEROID433);
  PlayChunk(ASTEROID434);
  //PlayChunk(ASTEROID435);
  PlayChunk(ASTEROID436); 
  //PlayChunk(ASTEROID437);
  PlayChunk(ASTEROID438);
  //PlayChunk(ASTEROID439);
  
  PlayChunk(ASTEROID440);
  
 // now play in reverse order
   PlayChunk(ASTEROID439);
  //PlayChunk(ASTEROID438);
  PlayChunk(ASTEROID437);
  //PlayChunk(ASTEROID436); 
  PlayChunk(ASTEROID435);
  //PlayChunk(ASTEROID434);
  PlayChunk(ASTEROID433);
  //PlayChunk(ASTEROID432); 
  PlayChunk(ASTEROID431);
  //PlayChunk(ASTEROID430);
  PlayChunk(ASTEROID429);
  //PlayChunk(ASTEROID428);
  PlayChunk(ASTEROID427);
  //PlayChunk(ASTEROID426); 
  PlayChunk(ASTEROID425);
  //PlayChunk(ASTEROID424);
  PlayChunk(ASTEROID423);
  //PlayChunk(ASTEROID422); 
  PlayChunk(ASTEROID421);
  //PlayChunk(ASTEROID420);
  PlayChunk(ASTEROID419);
  //PlayChunk(ASTEROID418);
  PlayChunk(ASTEROID417);
  //PlayChunk(ASTEROID416); 
  PlayChunk(ASTEROID415);
  //PlayChunk(ASTEROID414);
  PlayChunk(ASTEROID413);
  //PlayChunk(ASTEROID412); 
  PlayChunk(ASTEROID411);
  //PlayChunk(ASTEROID410);
  PlayChunk(ASTEROID409);
  //PlayChunk(ASTEROID408);
  PlayChunk(ASTEROID407);
  //PlayChunk(ASTEROID406);
  PlayChunk(ASTEROID405);
  //PlayChunk(ASTEROID404); 
  PlayChunk(ASTEROID403);
  //PlayChunk(ASTEROID402);
  PlayChunk(ASTEROID401);
  //PlayChunk(ASTEROID400);

 
   
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




