
#define ASSEMBLER
#include "floppy_description.h"
#include "defines.h"

	.text

#ifdef OSDKNAME_techtech

_RastersPaper
	.byt 0,0,0,0,0,0,0,0
	.byt 0,0,0,0,0,0,0,0
	.byt 0,0,0,0,0,0,0,0
	.byt 0,0,0,0,0,0,0,0
	.byt 0,0,0,0,0,0,0,0
	.byt 0,0,0,0,0,0,0,0
	.byt 0,0,0,0,0,0,0,0
	.byt 0,0,0,0,0,0,0,0
	.byt 0,0,0,0,0,0,0,0
	.byt 0,0,0,0,0,0,0,0
	.byt 0,0,0,0,0,0,0,0
	.byt 0,0,0,0,0,0,0,0
	.byt 0,0,0,0,0,0,0,0
	.byt 0,0,0,0,0,0,0,0
	.byt 0,0,0,0,0,0,0,0
	.byt 4,4,6,7,6,4,4,0 	; Raster bar over the text scroller

_RastersInk
	.byt 4,4,4,6,4,4,6,4
	.byt 6,6,4,6,6,6,6,6
	.byt 6,6,6,7,6,6,7,6
	.byt 7,7,6,7,7,7,7,7
	.byt 7,7,7,3,7,7,3,7
	.byt 3,3,7,3,3,3,3,3
	.byt 3,3,3,1,3,3,1,3
	.byt 1,1,3,1,1,1,1,1
	.byt 1,1,1,5,1,1,5,1
	.byt 5,5,1,5,5,5,5,5
	.byt 5,5,5,2,5,5,2,5
	.byt 2,2,5,2,2,2,2,2
	.byt 2,2,2,6,2,2,6,2
	.byt 6,6,2,6,6,6,6,6
	.byt 6,6,6,4,6,6,4,4
	.byt 4,4,6,7,6,4,4,0 	; Raster bar over the text scroller

#endif


#ifdef OSDKNAME_intro

_GradientRainbow
	.byt 1,1,1,5,1,5,5,5
	.byt 3,5,5,3,3,5,3,3
	.byt 2,3,3,2,2,3,2,2
	.byt 3,1,3,3,1,1,3,1

_GradientVip
	.byt 0,4,0,0,0,0,4,0
	.byt 4,4,4,4,4,4,4,4
	.byt 4,4,4,4,4,4,4,4
	.byt 4,4,4,4,4,4,4,4

_SoundWarningPicture 		.dsb LOADER_SOUND_WARNING_SIZE

#endif

#ifdef OSDKNAME_techtech
	.dsb 256-(*&255)

_BufferCharset			.dsb CHARMAP_SIZE			; LOADER_VIP_SCROLL_SIZE (the end part is going to be overwritten)
_BufferCharset30x40		.dsb BIGFONT_SIZE           ;LOADER_FONT_30x40_SIZE	; BIGFONT_SIZE			; LOADER_FONT_30x40_SIZE (the end part is going to be overwritten)
_BufferInverseVideo     .dsb LOADER_OVERLAY_SIZE	; INVERSE_SIZE	;LOADER_OVERLAY_SIZE                
#endif

_EndDemoData

#echo Remaining space in the demo code:
#print ($fd00 - _EndDemoData) 


	.bss 

#ifdef OSDKNAME_intro
;
; VIP intro sequence with MYM music player 
;
	*=$400

_PlayerBuffer				.dsb 256*14			; About 3.5 kilobytes somewhere in memory, we put the music file in overlay memory
_PlayerBufferEnd

_MusicData 					.dsb LOADER_INTRO_MUSIC_SIZE
_CloudPicture 				.dsb LOADER_CLOUD_SIZE
_RainDropPicture 			.dsb LOADER_RAINDROP_SIZE
_VipLogoPicture 			.dsb LOADER_VIP_LOGO_SIZE
_LongScrollerPicture 		.dsb LOADER_LONG_SCROLLER_SIZE
_EndNormalData

#endif

#ifdef OSDKNAME_techtech
;
; TechTech effect data
;
	*=$400

_SampleSound 				.dsb LOADER_SAMPLE_BOOMTSCHACK_SIZE
_SampleSoundDefence			.dsb LOADER_SAMPLE_DEFENCE_SIZE
_SampleSoundForce			.dsb LOADER_SAMPLE_FORCE_SIZE
_SampleSoundChimeStart		.dsb LOADER_SAMPLE_CHIME_START_SIZE
_SampleSoundChimeEnd		.dsb LOADER_SAMPLE_CHIME_END_SIZE
_SampleSoundMusicNonStop    .dsb LOADER_SAMPLE_MUSIC_NON_STOP_SIZE
_SampleSoundTechnoPop		.dsb LOADER_SAMPLE_TECHNO_POP_SIZE

_SampleSoundEnd
#endif


	*=$9800+256

_StdCharset	

;	*=$fc00
;_Loader	

