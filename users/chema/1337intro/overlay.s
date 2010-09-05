

	.bss

*=$c000


; Tables used by lib3D
tab_multLO	.dsb 256
tab_multLO2 .dsb 512
tab_multHI	.dsb 256
tab_multHI2	.dsb 512

tab_sindelta	.dsb 256
tab_sindeltarem	.dsb 256
tab_cosdelta	.dsb 256
tab_cosdeltarem	.dsb 256
tab_projtab		.dsb 256
tab_projtabrem	.dsb 256
tab_rotmath		.dsb 512
tab_sin			.dsb 32
tab_cos			.dsb 128

dummy			.dsb $da
MusicData		.dsb 2889

    .dsb 256-(*&255)
_HiresAddrLow           .dsb Y_SIZE
    .dsb 256-(*&255)
_HiresAddrHigh          .dsb Y_SIZE
    .dsb 256-(*&255)
    .byt 0
_TableDiv6				.dsb X_SIZE
    .dsb 256-(*&255)
    .byt 0

_BufferUnpack 
	.dsb 4000
buffer 
	.dsb 4000

#define X_SIZE      240
#define Y_SIZE      200
#define ROW_SIZE    X_SIZE/6

	*=$f000
_TableMod6	 .dsb 256
_TableDiv6b	 .dsb 256

BitMaskTable			.dsb 256
BitShiftTable			.dsb 256
_Patterns				.dsb 256
_XIncTableLow			.dsb 256
_XIncTableHigh			.dsb 256

    .text
