
 .zero

_ptr_src 		.dsb 2 
_ptr_dst 		.dsb 2 
_start_offset	.dsb 1
_start_position	.dsb 1
_draw_size		.dsb 1


 .text
 
	 	
			/*
			ptr_src=GradientRainbow;
			for (y=0;y<48+16;y++)
			{
				*ptr_dst=*ptr_src++;
				ptr_dst+=40;
			}
			*/
	
_DrawGradientSlice  
.(
  ldx #0
  ldy #0
loop
  lda _GradientRainbow,x
  sta (_ptr_dst),y
  
  clc
  lda _ptr_dst+0
  adc #40
  sta _ptr_dst+0
  bcc skip
  inc _ptr_dst+1
skip  
  
  inx
  cpx #48+16
  bne loop
  rts
.)


  
/* 
	for (y=0;y<66;y++)
	{
		unsigned char* screen;
		
		screen=ptr_src;				
		
    	for (x=0;x<17;x++)
		{
			*screen++=*ptr_dst++;
		}
		ptr_src+=40;
	}
*/
 

;	ptr_src=(unsigned char*)0xa000+7;
;	ptr_src+=(100-30)*40;

#define COMPUTERPOS $a000+7+40*70

;102x66=17*66=1122 bytes -> 4.38 * 256
; Max amplitude = 6 scanlines, 6*40=240, so can use an index register

; 102x62=17*62=1054 bytes -> 4.11*256

_DrawAtmos
.(
  .(
  ldx #0
  ldy _start_position
loop_x
  lda _Atmos96x68+17*0,x
  sta COMPUTERPOS+40*0,y
  lda _Atmos96x68+17*1,x
  sta COMPUTERPOS+40*1,y
  lda _Atmos96x68+17*2,x
  sta COMPUTERPOS+40*2,y
  lda _Atmos96x68+17*3,x
  sta COMPUTERPOS+40*3,y
  lda _Atmos96x68+17*4,x
  sta COMPUTERPOS+40*4,y
  lda _Atmos96x68+17*5,x
  sta COMPUTERPOS+40*5,y
  lda _Atmos96x68+17*6,x
  sta COMPUTERPOS+40*6,y
  lda _Atmos96x68+17*7,x
  sta COMPUTERPOS+40*7,y
  lda _Atmos96x68+17*8,x
  sta COMPUTERPOS+40*8,y
  lda _Atmos96x68+17*9,x
  sta COMPUTERPOS+40*9,y
  iny
  inx
  cpx _draw_size
  bne loop_x
end  
  .)
  
  .(
  ldx #0
  ldy _start_position
loop_x   
  lda _Atmos96x68+17*10,x
  sta COMPUTERPOS+40*10,y
  lda _Atmos96x68+17*11,x
  sta COMPUTERPOS+40*11,y
  lda _Atmos96x68+17*12,x
  sta COMPUTERPOS+40*12,y
  lda _Atmos96x68+17*13,x
  sta COMPUTERPOS+40*13,y
  lda _Atmos96x68+17*14,x
  sta COMPUTERPOS+40*14,y
  lda _Atmos96x68+17*15,x
  sta COMPUTERPOS+40*15,y
  lda _Atmos96x68+17*16,x
  sta COMPUTERPOS+40*16,y
  lda _Atmos96x68+17*17,x
  sta COMPUTERPOS+40*17,y
  lda _Atmos96x68+17*18,x
  sta COMPUTERPOS+40*18,y
  lda _Atmos96x68+17*19,x
  sta COMPUTERPOS+40*19,y
  iny
  inx
  cpx _draw_size
  bne loop_x
end  
  .)
  
  .(
  ldx #0
  ldy _start_position
loop_x  
  lda _Atmos96x68+17*20,x
  sta COMPUTERPOS+40*20,y
  lda _Atmos96x68+17*21,x
  sta COMPUTERPOS+40*21,y
  lda _Atmos96x68+17*22,x
  sta COMPUTERPOS+40*22,y
  lda _Atmos96x68+17*23,x
  sta COMPUTERPOS+40*23,y
  lda _Atmos96x68+17*24,x
  sta COMPUTERPOS+40*24,y
  lda _Atmos96x68+17*25,x
  sta COMPUTERPOS+40*25,y
  lda _Atmos96x68+17*26,x
  sta COMPUTERPOS+40*26,y
  lda _Atmos96x68+17*27,x
  sta COMPUTERPOS+40*27,y
  lda _Atmos96x68+17*28,x
  sta COMPUTERPOS+40*28,y
  lda _Atmos96x68+17*29,x
  sta COMPUTERPOS+40*29,y
  iny
  inx
  cpx _draw_size
  bne loop_x
end  
  .)
    
  .(
  ldx #0
  ldy _start_position
loop_x      
  lda _Atmos96x68+17*30,x
  sta COMPUTERPOS+40*30,y
  lda _Atmos96x68+17*31,x
  sta COMPUTERPOS+40*31,y
  lda _Atmos96x68+17*32,x
  sta COMPUTERPOS+40*32,y
  lda _Atmos96x68+17*33,x
  sta COMPUTERPOS+40*33,y
  lda _Atmos96x68+17*34,x
  sta COMPUTERPOS+40*34,y
  lda _Atmos96x68+17*35,x
  sta COMPUTERPOS+40*35,y
  lda _Atmos96x68+17*36,x
  sta COMPUTERPOS+40*36,y
  lda _Atmos96x68+17*37,x
  sta COMPUTERPOS+40*37,y
  lda _Atmos96x68+17*38,x
  sta COMPUTERPOS+40*38,y
  lda _Atmos96x68+17*39,x
  sta COMPUTERPOS+40*39,y
  iny
  inx
  cpx _draw_size
  bne loop_x
end  
  .)
    
  .(
  ldx #0
  ldy _start_position
loop_x
  lda _Atmos96x68+17*40,x
  sta COMPUTERPOS+40*40,y
  lda _Atmos96x68+17*41,x
  sta COMPUTERPOS+40*41,y
  lda _Atmos96x68+17*42,x
  sta COMPUTERPOS+40*42,y
  lda _Atmos96x68+17*43,x
  sta COMPUTERPOS+40*43,y
  lda _Atmos96x68+17*44,x
  sta COMPUTERPOS+40*44,y
  lda _Atmos96x68+17*45,x
  sta COMPUTERPOS+40*45,y
  lda _Atmos96x68+17*46,x
  sta COMPUTERPOS+40*46,y
  lda _Atmos96x68+17*47,x
  sta COMPUTERPOS+40*47,y
  lda _Atmos96x68+17*48,x
  sta COMPUTERPOS+40*48,y
  lda _Atmos96x68+17*49,x
  sta COMPUTERPOS+40*49,y
  iny
  inx
  cpx _draw_size
  bne loop_x
end  
  .)
    
  .(
  ldx #0
  ldy _start_position
loop_x
  lda _Atmos96x68+17*50,x
  sta COMPUTERPOS+40*50,y
  lda _Atmos96x68+17*51,x
  sta COMPUTERPOS+40*51,y
  lda _Atmos96x68+17*52,x
  sta COMPUTERPOS+40*52,y
  lda _Atmos96x68+17*53,x
  sta COMPUTERPOS+40*53,y
  lda _Atmos96x68+17*54,x
  sta COMPUTERPOS+40*54,y
  lda _Atmos96x68+17*55,x
  sta COMPUTERPOS+40*55,y
  lda _Atmos96x68+17*56,x
  sta COMPUTERPOS+40*56,y
  lda _Atmos96x68+17*57,x
  sta COMPUTERPOS+40*57,y
  lda _Atmos96x68+17*58,x
  sta COMPUTERPOS+40*58,y
  lda _Atmos96x68+17*59,x
  sta COMPUTERPOS+40*59,y
      
  lda _Atmos96x68+17*60,x
  sta COMPUTERPOS+40*60,y
  lda _Atmos96x68+17*61,x
  sta COMPUTERPOS+40*61,y
  lda _Atmos96x68+17*62,x
  sta COMPUTERPOS+40*62,y
  lda _Atmos96x68+17*63,x
  sta COMPUTERPOS+40*63,y
  lda _Atmos96x68+17*64,x
  sta COMPUTERPOS+40*64,y
  lda _Atmos96x68+17*65,x
  sta COMPUTERPOS+40*65,y
  ;lda _Atmos96x68+17*66,x
  ;sta COMPUTERPOS+40*66,y
  
  iny
  inx
  cpx _draw_size
  beq end
  jmp loop_x
end  
  .)
  rts
.)  
  
  

 
 
_RotateBitMask
.(
 lda _BitMask
 cmp #128
 rol _BitMask
 
 ldx _WaveOffset
 inx
 txa
 and #15
 sta _WaveOffset
 rts
.) 

_BitMask
 .byt %00110011

_WaveOffset
 .byt 0
 
_GradientRainbow
 ; sky
 .byt 16+6
 .byt 16+6
 .byt 16+6
 .byt 16+6
 .byt 16+6
 .byt 16+6
 .byt 16+6
 .byt 16+6
 ; red
 .byt 16+1
 .byt 16+6
 .byt 16+1
 .byt 16+1
 .byt 16+1
 .byt 16+3
 .byt 16+1
 .byt 16+1
 ; orange
 .byt 16+3
 .byt 16+1
 .byt 16+3
 .byt 16+1
 .byt 16+3
 .byt 16+1
 .byt 16+3
 .byt 16+1
 ; yellow
 .byt 16+3
 .byt 16+3
 .byt 16+1
 .byt 16+3
 .byt 16+3
 .byt 16+2
 .byt 16+3
 .byt 16+3
 ; green
 .byt 16+2
 .byt 16+3
 .byt 16+2
 .byt 16+2
 .byt 16+3
 .byt 16+2
 .byt 16+2
 .byt 16+2
 ; blue
 .byt 16+4
 .byt 16+2
 .byt 16+4
 .byt 16+4
 .byt 16+4
 .byt 16+5
 .byt 16+4
 .byt 16+4
 ; magenta
 .byt 16+5
 .byt 16+4
 .byt 16+5
 .byt 16+5
 .byt 16+4
 .byt 16+5
 .byt 16+6
 .byt 16+5
 ; sky
 .byt 16+6
 .byt 16+6
 .byt 16+6
 .byt 16+6
 .byt 16+6
 .byt 16+6
 .byt 16+6
 .byt 16+6

_RainbowWave
 .byt 40*0
 .byt 40*1 
 .byt 40*2
 .byt 40*3 
 .byt 40*4
 .byt 40*5 
 .byt 40*4
 .byt 40*3 
 .byt 40*2
 .byt 40*1 
 .byt 40*2
 .byt 40*3 
 .byt 40*4
 .byt 40*3 
 .byt 40*2
 .byt 40*1 
 
_RainbowNewOffset
 ; New position
 .byt 40*0
 ; Old position
_RainbowOffsets
 .byt 40*0
 .byt 40*0
 .byt 40*0
 .byt 40*0
 .byt 40*0
 .byt 40*0
 .byt 40*0
 .byt 40*0
 .byt 40*0
 .byt 40*0
 .byt 40*0
 .byt 40*0
 .byt 40*0
 .byt 40*0
 .byt 40*0
 .byt 40*0

 
_StarBits
 .byt %100000 
 .byt %010000 
 .byt %001000 
 .byt %000100  
 .byt %000010 
 .byt %000001 
 .byt %100000 
 .byt %010000  
 
_StarBytes
 .byt 1
 .byt 20
 .byt 5
 .byt 36
 .byt 2
 .byt 15
 .byt 27
 .byt 9

_StarLineOffset
 .byt 40*6
 .byt 40*6
 .byt 40*6
 .byt 40*6
 .byt 40*6
 .byt 40*6
 .byt 40*6
 .byt 40*6
  
 
_Drawstars
.(
  lda #<$a000+40*10
  sta _ptr_dst+0
  lda #>$a000+40*10
  sta _ptr_dst+1
  
  ldx #0
loop

  ; Scanline offset
  clc
  lda _ptr_dst+0
  adc _StarLineOffset,x
  sta _ptr_dst+0
  bcc skip
  inc _ptr_dst+1
skip  

  ; Line offset  
  ldy _StarBytes,x

  lda #16+6
  sta (_ptr_dst),y
  iny
    
  ; Bit pattern
  lda _StarBits,x
  ora #64  
  sta (_ptr_dst),y
  iny
  
  lda #6
  sta (_ptr_dst),y
    
  lda _StarBits,x
  lsr
  sta _StarBits,x
  cmp #0
  bne no_end_byte
  
  lda #%000001
  sta _StarBits,x
  
  inc _StarBytes,x
  lda _StarBytes,x
  cmp #38
  bne no_end_line
  lda #1
  sta _StarBytes,x
no_end_line  
  
  
no_end_byte
  
  inx
  cpx #8
  bne loop  
  
  rts
.) 
 
 
 