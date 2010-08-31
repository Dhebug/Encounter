;      
; lib3d extensions
;
; A collection of routines which extends
; the 3d library, adding routines for creating,
; manipulating, and rendering objects.
;
; SLJ March/April 1999
;
; Obj3d
; Oric port Chema 2008
;
;
; Idea Maintain a list of objects.

; Get constants in an include file..

#include "obj3d.h"
#include "params.h"

#define X1 _LargeX0	
#define Y1 _LargeY0
#define X2 _LargeX1	
#define Y2 _LargeY1

#define MAXOBJS     8
#define MAXVERTEX   64



; Now some internal (not visible) variables

_NumObjs
NUMOBJS  .byt 00           ;Number of objects
NUMCENTS .byt 00           ;Number of object senter
CUROBJ   .byt 00           ;Current object
LASTOBJ  .byt 00
ZMAX     .word $2300       ;Maximum range
ZMIN     .byt 50           ;Minimum range
OBJECTS  .word $0800       ;Object records 1227 = 3456 bytes = $0D80


NUMLINES .byt  00          ;This is for the line-drawing... I think. Defined below in the original

;===============================

; Zero page variables

.zero

__obj3d_zeropage_start

RTEMPA    .byt  00
RTEMPX    .byt  00
RTEMPY    .byt  00
TEMP     .word 00          ;two bytes
POINT    .word 00           ;two bytes

; This is for the line-plotting routine
; Coordinates are 16-bit

;#define X1 _LargeX0
;#define X2 _LargeX1
;#define Y1 _LargeY0
;#define Y2 _LargeY1

; This is for polygon drawing or C64 specific ???

;BITMAP   .word $B9          ;Page of bitmap base
;FILLPAT  .word $BB          ;Pointer to fill pattern


__obj3d_zeropage_end

.text

__obj3d_start

;Lines drawn
;speeds up wireframe
; Oric port This is the same I already used. 
; 100 bytes instead of $67.

#define MAXLINES 39;100
LINELO   .dsb 40;100         
LINEHI   .dsb 40;100          

#ifdef USEOBLETS
#define OBHEAD  $2F-1       ;Head of list = $55FF Oric port Just the size of OBLETS
OBLETS   .dsb OBHEAD+1      ;Oblet list
#endif

.dsb 256-(*&255)
PLISTX   .dsb (MAXVERTEX*2)         ;Point lists (projected)
PLISTY   .dsb (MAXVERTEX*2)
PLISTZ   .dsb (MAXVERTEX*2)

// META
VISOBJS  .dsb 129
OBCEN    .dsb MAXOBJS		 ;Center object #
							 ;Note will bug if 128 vis objs

OBJLO    .dsb MAXOBJS         ;Object pointers
OBJHI    .dsb MAXOBJS         ;if 0 then empty

CX       .dsb MAXOBJS          ;Rotated/relative centers
HCX      .dsb MAXOBJS
CY       .dsb MAXOBJS
HCY      .dsb MAXOBJS
CZ       .dsb MAXOBJS
HCZ      .dsb MAXOBJS


; Some stuff from lib3D

#define MATRIX      A11      ; Local rotation Matrix
#define VIEWMAT     VA11     ; Viewpoint rotation matrix


; Now let's go to the code...


;
; Initialize lib3d pointers, variables
;
; On entry .AY = pointer to object records
;

Init3D   
.(         
         STA OBJECTS
         STY OBJECTS+1

         jsr _lib3dInit ; Initialize lib3D Oric Version
/*         
         lda #<PLISTX
         sta PLISTXLO
         lda #<PLISTY
         sta PLISTYLO
         lda #<PLISTZ
         sta PLISTZLO

         lda #>PLISTX
         sta PLISTXLO+1
         lda #>PLISTY
         sta PLISTYLO+1
         lda #>PLISTZ
         sta PLISTZLO+1


         lda #<(PLISTX+MAXVERTEX)
         sta PLISTXHI
         lda #<(PLISTY+MAXVERTEX)
         sta PLISTYHI
         lda #<(PLISTZ+MAXVERTEX)
         sta PLISTZHI

         lda #>(PLISTX+MAXVERTEX)
         sta PLISTXHI+1
         lda #>(PLISTY+MAXVERTEX)
         sta PLISTYHI+1
         lda #>(PLISTZ+MAXVERTEX)
         sta PLISTZHI+1
*/
         LDX #<CX
         STX CXLO
         LDX #<CY
         STX CYLO
         LDX #<CZ
         STX CZLO

         LDX #>CX
         STX CXLO+1
         LDX #>CY
         STX CYLO+1
         LDX #>CZ
         STX CZLO+1


         LDX #<HCX
         STX CXHI
         LDX #<HCY
         STX CYHI
         LDX #<HCZ
         STX CZHI

         LDX #>HCX
         STX CXHI+1
         LDX #>HCY
         STX CYHI+1
         LDX #>HCZ
         STX CZHI+1

         ;LDX #159         ;(0,0) = center of screen
         ;LDY #99
        
         ; Oric port Let's put center in center )

         ldx #CENTER_X
         ldy #CENTER_Y
NOM      STX XOFFSET
         STY YOFFSET


+_EmptyObj3D
         LDA #$FF
         STA CUROBJ
         LDA #00
         STA NUMOBJS
         STA LASTOBJ
         sta NUMCENTS   

         LDY #00          ;Zero out object pointers
         TYA
L1       STA OBJHI,Y
         INY
         ;BPL L1          ;128 entries
         cpy #MAXOBJS
         bne L1

         RTS
.)

;
; AddObj -- Add object to object list
;
; On entry .AY = pointer to object point data
;           .X  = optional ID byte
;
; On exit .AY = pointer to object
;          .X  = object number
;          C set indicates an error
;

AddObj   
.(
         sta RTEMPA
         sty RTEMPY
         stx RTEMPX

         ldx #00          ;Find open slot
         txa
         sta tmp
         clc
loop     ldy OBJHI,x
         beq found
         adc #ObjSize     ;32 bytes per record
         bcc c1
         inc tmp
         clc
c1       inx
         bpl loop
         sec
         rts

found    adc OBJECTS
         sta POINT
         sta OBJLO,x
         lda tmp
         adc OBJECTS+1
         sta POINT+1
         sta OBJHI,x
         inc NUMOBJS
         cpx LASTOBJ
         bcc init
         stx LASTOBJ
init    
         ldy #ObjSize-1   ;Init object
         lda #00
l2       sta (POINT),y
         dey
         bpl l2

         lda #64          ;Identity matrix
         ldy #ObjMat
         sta (POINT),y
         ldy #ObjMat+4
         sta (POINT),y
         ldy #ObjMat+8
         sta (POINT),y

         ldy #ObjID
         lda RTEMPX        ;ID
         sta (POINT),y

         lda RTEMPY        ;Obj data pointer
         dey
         sta (POINT),y
         lda RTEMPA
         dey
         sta (POINT),y

+SetCurOb stx CUROBJ
+GetCurOb ldx CUROBJ
+GetObj   lda OBJLO,x
         ldy OBJHI,x
         clc
         rts

.)


;
; DelObj -- Remove object from list
;           by setting high byte=0
;
; On entry .X = object number
;           C set means serious error!
;

DelObj 
.(       
         LDA #00
         STA OBJHI,X
         LDA NUMOBJS
         BEQ end
         DEC NUMOBJS
         CPX LASTOBJ      ;Last object in list
         BCC end
L1       LDA OBJHI,X
         BNE save_X
         DEX
         BPL L1
         SEC              ;Out of objects!
         INX
save_X   STX LASTOBJ
end      RTS
.)


;
; GetNextOb -- Get next object in list
;
; On exit .X = object number
;          .AY= object pointer
;          C set indicates error
;          Current object set to .X
;
GetNextOb
.(
         ;LDA NUMOBJS
         ;BEQ ERR
         LDX CUROBJ
         ;BMI ERR
         CPX LASTOBJ
         BCC C1
         LDX #$FF
C1       INX
         LDY OBJHI,X
         BEQ C1
         LDA OBJLO,X
         STX CUROBJ
         ;CLC
         RTS
/*
ERR      SEC
         RTS
*/
.)



;-------------------------------
;
; Object manipulation routines
;
;-------------------------------

;
; SetMat -- Calculate matrix for current object
;
; On entry .A = Angle around z-axis
;           .Y = Angle around y-axis
;           .X = Angle around x-axis
;
SetMat
.(   
         JSR CALCMAT      ;Result -> MATRIX
         LDX CUROBJ
         BMI done
         LDA OBJLO,X
         CLC
         ADC #ObjMat      ;Matrix
         STA POINT
         LDA OBJHI,X
         ADC #00
         STA POINT+1

         LDA #00
         LDY #17
L2       STA (POINT),Y    ;Zero remainder
         DEY
         CPY #8
         BNE L2

LOOP     LDA MATRIX,Y
         STA (POINT),Y
         DEY
         BPL LOOP
 
done     RTS
.)


;
; Yaw/Pitch/Roll -- Accumulate a rotation on current object
;
; On entry C clear -> positive rotation
;           C set -> negative rotation
;

GetCurMat
.(
         PHP
         JSR GetCurOb
         CLC
         ADC #ObjMat
         BCC save_P
         INY
save_P   PLP
         RTS

+Pitch    
         JSR GetCurMat
         JMP ACCROTX
+Yaw      
         JSR GetCurMat
         JMP ACCROTY
+Roll     
         JSR GetCurMat
         JMP ACCROTZ
.)


;
; MoveDown/Side/Forwards -- Move object along its
;   (local) X Y or Z axis.
;
; Note that orientation matrix is inverse of object matrix
;
; On entry .A = velocity (signed)
;

.(
MOVRTS   RTS
+MoveDown 
         LDY #ObjMat      ;Row 1
         .byt $2C
+MoveSide 
         LDY #ObjMat+3    ;Row 2
         .byt $2C
+MoveForwards
         LDY #ObjMat+6
         STY RTEMPY        ;Object offset
         CMP #00
         BEQ MOVRTS
         STA MultLo1      ;Plain signed multply
         STA MultHi1
         EOR #$FF
         CLC
         ADC #01
         STA MultLo2
         STA MultHi2

         LDX CUROBJ
         BMI MOVRTS
         LDA OBJLO,X
         STA POINT
         LDA OBJHI,X
         STA POINT+1

         LDA (POINT),Y
         TAY
         LDA #ObjCXRem
         LDX #ObjCX
         JSR MovMult

         LDY RTEMPY
         INY
         STY RTEMPY
         LDA (POINT),Y
         TAY
         LDA #ObjCYRem
         LDX #ObjCY
         JSR MovMult

         LDY RTEMPY
         INY
         LDA (POINT),Y
         TAY
         LDA #ObjCZRem
         LDX #ObjCZ

MovMult  
         STX RTEMPX        ;Coord
         STA RTEMPA        ;Remainder
         LDA (MultLo1),Y
         SEC
         SBC (MultLo2),Y
         STA TEMP
         LDA (MultHi1),Y
         SBC (MultHi2),Y
         CPY #$80         ;Fix up signs
         BCC POS1
         SBC MultLo1
POS1     LDX MultLo1
         BPL DIV
         STY TEMP+1
         SEC
         SBC TEMP+1

DIV      STA TEMP+1       ;Now div by 16
         LDY #00
         AND #$FF
         BPL POSA
         DEY              ;High byte
POSA     TYA
         ASL TEMP
         ROL TEMP+1
         ROL
         ASL TEMP
         ROL TEMP+1
         ROL
         ASL TEMP
         ROL TEMP+1
         ROL
         ASL TEMP
         ROL TEMP+1
         ROL

         TAX
         LDA TEMP
         LDY RTEMPA        ;Remainder
         CLC
         ADC (POINT),Y
         STA (POINT),Y
         LDY RTEMPX        ;Coord
         LDA TEMP+1
         ADC (POINT),Y
         STA (POINT),Y
         INY
         TXA
         ADC (POINT),Y
         STA (POINT),Y
         RTS
.)

;
; GetDown/Side/FrontVec
;
; Get orientation vector
; On entry Current object set
; On exit (.X,.Y,.A) = (X,Y,Z) signed
;          direction vector, length=64
;

GetDownVec
         LDY #ObjMat      ;Row 1
         .byt $2C
GetSideVec
         LDY #ObjMat+3    ;Row 2
         .byt $2C
GetFrontVec
.(
         LDY #ObjMat+6

         LDX CUROBJ
         BMI done
         LDA OBJLO,X
         STA POINT
         LDA OBJHI,X
         STA POINT+1

         LDA (POINT),Y
         TAX
         INY
         INY
         LDA (POINT),Y
         PHA
         DEY
         LDA (POINT),Y
         TAY
         PLA
done     RTS

.)



;-------------------------------
;
; Visualization routines
;
;-------------------------------

ViewObj  .byt 00             ;Viewpoint object
;SOLIDPOL .byt 00             ;Solid/wireframe polygons

; Oric Port There is NO Pattern table, so point anywhere...
;PATTAB   .word $1000         ;Pattern table

;
; SetParms -- Set rendering parameters
;
; On entry .AY = Pointer to pattern table
;           .X  = Bitmap page
;            C set   -> solid polygons
;            C clear -> wireframe
;

;SetParms 
;         ROR SOLIDPOL
;         STA PATTAB
;         STY PATTAB+1
;         STX BITMAP
;         RTS

;
; SetVisParms -- Set visibility parms
;
; On entry .AY = Maximum object range
;           .X  = Minimum object range
;

;SetVisParms
;         STA ZMAX
;         STY ZMAX+1
;         STX ZMIN
;         RTS

;
; CalcView -- Calculate view (Set viewpoint, translate and rotate centers)
;
; On entry .X = viewpoint object
;
; On exit: translated rotated centers
;          in CX/CY/CZ
;

CalcView 
.(
         STX ViewObj
         JSR SetCurOb
         STA POINT
         STY POINT+1

         LDX #8
         LDY #ObjMat+8
loop     
		 LDA (POINT),Y    ;Viewpoint matrix
         STA VIEWMAT,X
         DEY
         DEX
         BPL loop

         LDX #11          ;Set up pointers
cl       LDA CXLO,X
         STA C0XLO,X
         DEX
         BPL cl

         LDX #00
         STX RTEMPX        ;Object index

getloop  JSR GetNextOb
         CPX ViewObj
         BEQ done

         STA TEMP
         STY TEMP+1
         TXA
         LDX RTEMPX
         STA OBCEN,X      ;Object number
         TXA
         LDY #ObjCenPos    ;Position in center list
         STA (TEMP),Y

         LDY #00
         LDA (TEMP),Y     ;Translate
         SEC
         SBC (POINT),Y
         STA CX,X
         INY
         LDA (TEMP),Y
         SBC (POINT),Y
         STA HCX,X

         INY
         LDA (TEMP),Y     ;Translate
         SEC
         SBC (POINT),Y
         STA CY,X
         INY
         LDA (TEMP),Y
         SBC (POINT),Y
         STA HCY,X

         INY
         LDA (TEMP),Y     ;Translate
         SEC
         SBC (POINT),Y
         STA CZ,X
         INY
         LDA (TEMP),Y
         SBC (POINT),Y
         STA HCZ,X

         INC RTEMPX
         BPL getloop
done    
         LDY RTEMPX        ;# of objects
         STY NUMCENTS

         JMP GLOBROT      ;off she goes!
.)



;
; SortVis -- Compute and sort all visible objects
;
; On entry centers stored in CX etc.
;
; On exit VisObjs = linked list of visible objects
;   (farthest objects at start of list)
;
; Visibility conditions
;   x+z>0, x-z<0 (within view area)
;   same for x+y/x-y
;   z > 8192 will be treated as too far away to see
;   z < 180 is treated as being too near.
;

NUMVIS   .byt 00

SortVis  
.(
         LDA #00
         STA NUMVIS
         LDA #$80
         STA VISOBJS+$80
         LDX NUMCENTS
         DEX
         bpl loop
         rts
loop

         LDA CZ,X         ;low byte
         STA TEMP
         LDA HCZ,X        ;high byte
         STA TEMP+1
		 bmi SKIP

         LDA TEMP
         CMP ZMIN
         LDA TEMP+1
         SBC #00
         BCC SKIP

         LDA TEMP         ;x+z>0
         CLC
         ADC CX,X
         LDA TEMP+1
         ADC HCX,X
         BMI SKIP

         LDA TEMP         ;z-x>0
         CMP CX,X
         LDA TEMP+1
         SBC HCX,X
         BMI SKIP

         LDA TEMP         ;y+z>0
         CLC
         ADC CY,X
         LDA TEMP+1
         ADC HCY,X
         BMI SKIP

         LDA TEMP         ;z-y>0
         CMP CY,X
         LDA TEMP+1
         SBC HCY,X
         BMI SKIP

         LDY #$80         ;Head of list
l1       LDA VISOBJS,Y    ;Linked list of objects
         BMI link
         STY RTEMPY
         TAY              ;Next object
         LDA CZ,Y         ;If farther, then
         CMP TEMP         ;move down list
         LDA HCZ,Y
         SBC TEMP+1
         BCS l1
                          ;Nearest objects last in list
         TYA
         LDY RTEMPY        ;Insert into list

link     STA VISOBJS,X    ;X -> rest of list
         TXA
         STA VISOBJS,Y    ;beginning of list -> X
SKIP     DEX
         BPL loop
         LDY #$80
         STY COB          ;Current object
done     RTS

.)



;
; DrawAllVis -- Draw all visible objects
;   in linked list.
;
COB      .byt 00           ;Current object
.(
DrawLoop 
         STY COB
         ldx OBCEN,y    ;Actual object number
        
         JSR RotDraw

         ldy COB
         ldx OBCEN,y

+DrawAllVis
         LDX COB          ;Head = #$80
         LDY VISOBJS,X
         BPL DrawLoop
done    
DrawRTS  RTS



;
; GetNextVis -- Get next object in
;   visible list.
;
; On exit N set indicates end of list
;
+GetNextVis
         LDX COB
         LDY VISOBJS,X
         BMI DrawRTS
         php
         STY COB
         ldx OBCEN,y
         LDA #00
         STA NUMLINES
         jsr SetCurOb
         plp
         rts
.)

;	.dsb 256-(*&255)


;
; RotDraw -- Rotate and draw an object
;
; On entry Object number in .X
;   SetParms already called.
;
DATAP    .word 0             ;Temp pointer
NPOINTS  .byt 00
OBTYPE   .byt 00

NFACES   .byt 00           ;Faces/Oblets

RotDraw  
.(
         LDA OBJLO,X
         STA POINT
         LDA OBJHI,X
         STA POINT+1

         LDY #ObjMat      ;Matrix -> ZP
         LDX #00
         STX NUMLINES
mli      STX TEMP
         LDA #3
         STA TEMP+1
ml       LDA (POINT),Y    ;Take transpose to get
         STA MATRIX,X     ;orientation matrix
         INY
         INX
         INX
         INX
         DEC TEMP+1
         BNE ml
         LDX TEMP
         INX
         CPX #3
         BNE mli

         LDY #ObjCenPos
         LDA (POINT),Y
         STA RTEMPA        ;Position of center in list

         LDY #ObjData     ;Get data pointer for later
         LDA (POINT),Y
         STA DATAP
         TAX
		 INY
         LDA (POINT),Y
         STA DATAP+1
         STA POINT+1
         STX POINT
         LDY #00
         LDA (POINT),Y
         STA OBTYPE       ;Normal/compound
 normalmodel
         INY
         LDA (POINT),Y    ;Number of points
         ;BEQ done
		 bne cont
		 rts
cont
         STA NPOINTS
         INY
         LDA (POINT),Y
         STA NFACES
		 iny
		 tya
		 clc
		 adc POINT
		 sta P0X
		 ldx POINT+1
		 bcc cc1
		 inx
		 clc
cc1
		 stx P0X+1
		 adc NFACES
		 sta P0Y
		 bcc cc2
		 inx
		 clc
cc2
		 stx P0Y+1
		 adc NFACES
		 sta P0Z
		 bcc cc3
		 inx
		 clc
cc3
		 stx P0Z+1

	     lda NFACES
		 beq end_prepare_normals
		 jmp prepare_normals
+end_prepare_normals

		 lda NFACES	; Point pointers
 		 clc
		 adc P0Z
		 sta P0X
		 ldx P0Z+1
         BCC c1
         INX
         CLC
c1       STX P0X+1
         ADC NPOINTS
         STA P0Y
         BCC c2
         INX
         CLC
c2       STX P0Y+1
         ADC NPOINTS
         STA P0Z
         BCC c3
         INX
         CLC
c3       STX P0Z+1
         ADC NPOINTS
         STA FACEPTR
         TXA
         ADC #00
         STA FACEPTR+1

         LDY NPOINTS
         LDX RTEMPA       ;Center index
         SEC              ;Rot and proj
         JSR ROTPROJ

         LDA NFACES       ;Maybe just want tointsate p
         BEQ done
         LDA FACEPTR
         LDY FACEPTR+1
         ;LDX OBTYPE     ; Draw depending on object type.

dloop
    	 jmp DrawFace
+draw_face_end
         DEC NFACES
         BNE dloop
done     RTS

.)


;
; DrawFace -- Draw a polygon
;
; On entry .AY points to face data
; On exit .AY points to next face
;
; Wireframe C clear -> face not drawn
;

NVERTS   .byt 00           ;Number of vertices
FACEPTR  .word 00            ;Pointer to face

DrawFace 
.(
         STA POINT
         STY POINT+1

         LDY #00
         LDA (POINT),Y
         STA NVERTS
         SEC              ;N+1 in list
	     ADC #1           ;(closes on itself)
         ADC POINT
         STA FACEPTR      ;Next face
         LDA #00
         STA TEMP
         ADC POINT+1
         STA FACEPTR+1

;Wireframe routine                          
Wire
	 	lsr facevis+2
		ror facevis+1
		ror facevis
		bcc exit

         ;LDY #2           ;Connect the dots...
		 ldy #1
l2       LDA (POINT),Y
         TAX
         LDA PLISTX,X
         STA X1
         LDA PLISTX+MAXVERTEX,X
         STA X1+1
         LDA PLISTY,X
         STA Y1
         LDA PLISTY+MAXVERTEX,X
         STA Y1+1
         STX RTEMPA

         INY
         LDA (POINT),Y
         TAX
         LDA PLISTX,X
         STA X2
         LDA PLISTX+MAXVERTEX,X
         STA X2+1
         LDA PLISTY,X
         STA Y2
         LDA PLISTY+MAXVERTEX,X
         STA Y2+1
         STY RTEMPY
        

; Check for line connections
; Points in RTEMPA and .X
         LDY #00
loop     CPY NUMLINES
         BEQ store
         TXA
         CMP LINELO,Y
         BNE test2
         LDA RTEMPA
         CMP LINEHI,Y
         BEQ skip
incy     INY
         BPL loop
store    LDA RTEMPA
         STA LINELO,Y
         TXA
         STA LINEHI,Y
         CPY #MAXLINES
         BEQ godraw
         INC NUMLINES

godraw  
         JSR _DrawClippedLine
	
skip     LDY RTEMPY
         DEC NVERTS
         BNE l2
        
           
         SEC
         BCS exit
test2    CMP LINEHI,Y
         BNE incy
         LDA RTEMPA
         CMP LINELO,Y
         BNE incy
         BEQ skip

#endif

exit     LDA FACEPTR
         LDY FACEPTR+1
         ;RTS
		 jmp draw_face_end
.)


#define cx_	tmp3
#define cy_	tmp4
#define cz_	tmp5
#define tempx op2

prepare_normals
.(
    ; Prepare call to ROTPROJ in mode "Rotation only"
    ldy NFACES
    ldx RTEMPA       ;Center index
    clc              ;Rot and NOT proj
    jsr ROTPROJ

    ; Save center coordinates in cx_, cy_, cz_ for later.
    ldx RTEMPA
    lda CX,x
    sta cx_
    lda HCX,x
    sta cx_+1

    lda CY,x
    sta cy_
    lda HCY,x
    sta cy_+1

    lda CZ,x
    sta cz_
    lda HCZ,x
    sta cz_+1

	; If too far we patch code below and avoid calculating the
	; dot product between the normal and the view vector.
	; Just will use the normal Z sign.

	cmp #5
	bcc nopatch

	lda #$18	; clc opcode
	sta _patch_code
	jmp startcheck

nopatch
	lda #$38	; sec opcode
	sta _patch_code

    ; Adjust center coordinates, so they are 7-bit signed and SMULT can be used
loopadj
    lda cx_+1
    beq conty
    bpl shift
    eor #$ff
    bne shift
conty
    lda cy_+1
    beq contz
    bpl shift
    eor #$ff
    bne shift
contz
    lda cz_+1
    beq endloop
shift
    lda cx_+1
    cmp #$80    
    ror cx_+1
    ror cx_
 
    lda cy_+1
    cmp #$80    
    ror cy_+1
    ror cy_

    ; Z is allways positive (or it won't be visible)
    lsr cz_+1
    ror cz_

    jmp loopadj
endloop

    ; We need two more adjustments
    ; To be sure the amount is 7-bit signed (-64..64).
 
    lda cx_+1
    cmp #$80 
	ror
	ror cx_
	cmp #$80
	ror
	ror cx_
	sta cx_+1

    lda cy_+1
    cmp #$80    
	ror
    ror cy_
    cmp #$80    
	ror
    ror cy_
	sta cy_+1

    ; Z is allways positive (or it wouldn't be visible)
    lsr cz_+1
    ror cz_
    lsr cz_+1
    ror cz_

startcheck
    ; Prepare facevis bitfield.

	lda #0
	sta facevis
	sta facevis+1
	sta facevis+2


    ; Loop through face list
 	ldx NFACES
	dex
    stx tempx
loop
    ; First check. If all normals are zero, face is visible
    ldx tempx
    lda PLISTX,x
    ora PLISTY,x
    ora PLISTZ,x
    bne cont
    sec
    jmp vis
cont

_patch_code
	sec	; This is patched to clc or sec
	bcs cont2
	lda PLISTZ,x
	bpl noneg
	clc
	jmp vis
noneg
	sec
	jmp vis
cont2


    ; For each face we need to calculate the dot-product
    ; of the center and the normal.
    ; <cx_,cy_,cz_>*<nx,ny,nz>=
    ; cx_*nx+cy_*ny+cz_*nz.
    ; All within range of SMULT
    ; op1 (2-byte) will store the 16-bit result

    lda #0
    sta op1+1

	lda PLISTX,x
	ldy cx_
	SMULT
	sta op1
	bpl doY
	dec op1+1
doY
	lda #0
	sta tmp
	lda PLISTY,x
	ldy cy_
	SMULT
	bpl noneg1
	dec tmp
noneg1
	clc 
	adc op1
	sta op1
	lda tmp
	adc op1+1
	sta op1+1

doZ
	lda #0
	sta tmp
	lda PLISTZ,x
	ldy cz_
	SMULT
	bpl noneg2
	dec tmp
noneg2
	clc 
	adc op1
	sta op1
	lda tmp
	adc op1+1
	sta op1+1

doneall
    sec
    bmi novis
    lda op1+1
    ora op1
    bne vis
	;bpl	vis
    ;beq vis
novis
	clc
vis
	rol facevis
	rol facevis+1
	rol facevis+2
	dec tempx
	bmi end
    jmp loop
end
	;rts
	jmp end_prepare_normals
.)



.zero
facevis .dsb 3
.text




__obj3d_end

#echo obj3d: Memory usage
#echo obj3d: Zero page:
#print (__obj3d_zeropage_end - __obj3d_zeropage_start)
#echo obj3d: Normal memory:
#print (__obj3d_end - __obj3d_start)





