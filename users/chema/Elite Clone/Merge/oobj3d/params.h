#ifndef PARAMS_H
#define PARAMS_H

#define CLIP_BORDER	1
//40

//#define CLIP_LEFT	(CLIP_BORDER)
//#define CLIP_RIGHT	(239-CLIP_BORDER)
//#define CLIP_TOP	(CLIP_BORDER)
//#define CLIP_BOTTOM	(199-CLIP_BORDER)

//#define CLIP_LEFT	(CLIP_BORDER)
//#define CLIP_RIGHT	(239-CLIP_BORDER)
//#define CLIP_TOP	100
//#define CLIP_BOTTOM	(199-CLIP_BORDER)


//#define CLIP_LEFT	0
//#define CLIP_TOP	100

//#define CLIP_RIGHT	239
//#define CLIP_BOTTOM	199


//#define FILLEDPOLYS

#ifdef FILLEDPOLYS

#define CLIP_LEFT	11
#define CLIP_RIGHT	(239)
#define CLIP_TOP	5
#define CLIP_BOTTOM	(127-1)


#else

#define CLIP_LEFT	5
#define CLIP_RIGHT	(239-5)
#define CLIP_TOP	5
#define CLIP_BOTTOM	(127-1)

#endif


#define USE_ACCURATE_CLIPPING

#endif









