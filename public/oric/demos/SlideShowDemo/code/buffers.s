
	.text

	.dsb 256-(*&255)
	
;
; All the stuff that needs to be aligned on a page boundary
;
_PlayerBuffer		.dsb 256*14			; About 3.5 kilobytes somewhere in memory, we put the music file in overlay memory
_PlayerBufferEnd

_ScreenAddrLow				.dsb 256
_ScreenAddrHigh  			.dsb 256
	
_PictureLoadBufferAddrLow	.dsb 256
_PictureLoadBufferAddrHigh  .dsb 256

_EmptySourceScanLine 		.dsb 256			; Only zeroes, can be used for special effects
_EmptyDestinationScanLine 	.dsb 256			; Only zeroes, can be used for special effects

ScrollTableLeft  	.dsb 256
ScrollTableRight 	.dsb 256
_FontAddrLow		.dsb 128
_FontAddrHigh		.dsb 128	
_FontCharacterWidth .dsb 128

;
; The rest of stuff
;

; This table needs to be aligned on an even address, or at least no element should overlap a page boundary
ScrollerJumpTable
	.word _ScrollerPhase1
	.word _ScrollerPhase2
	.word _ScrollerPhase3
	.word _ScrollerPhase4
	.word _ScrollerPhase5
	.word _ScrollerPhase6

ScrollerBuffer1 	.dsb SCROLLER_BUFFER_WIDTH*16
ScrollerBuffer2		.dsb SCROLLER_BUFFER_WIDTH*16
ScrollerBuffer3 	.dsb SCROLLER_BUFFER_WIDTH*16
ScrollerBuffer4 	.dsb SCROLLER_BUFFER_WIDTH*16
ScrollerBuffer5 	.dsb SCROLLER_BUFFER_WIDTH*16
ScrollerBuffer6 	.dsb SCROLLER_BUFFER_WIDTH*16

	
_FontBuffer					.dsb 3040

_PictureLoadBuffer			.dsb 8000

_DescriptionBuffer 			.dsb 40


	.bss 

;	*=$200
;_SectorBuffer

	*=$c000
_MusicLength

;	*=$fc00
;_LoaderCode
