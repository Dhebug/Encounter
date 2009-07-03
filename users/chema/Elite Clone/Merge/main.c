#include <stdio.h>
#include <string.h>


#include "oobj3d/obj3d.h"
#include "tine.h"

/* Prototipes */

typedef struct t_obj
{
  int CenterX,CenterY,CenterZ;
  void * objp;
  char ID;
  char User;
  char XRem, YRem, ZRem;
  char orientation[18];
}t_obj;


extern t_obj * pointer;

/* Polygon test */

extern	void AddLineASM();
extern	void FillTablesASM();
extern	void ClearAndSwapFlag();
extern	void ComputeDivMod();


extern int miDiv(int a,int b);
extern int mimul16(int a, int b);



extern char CurrentPattern;

extern char CurrentPixelX;
extern char CurrentPixelY;
extern char OtherPixelX;
extern char OtherPixelY;
extern void DrawLine();

extern void pixel_address();
extern void put_pixel(int,int);
extern int addr;
extern char scan;


/* Variables to mantain for each space object */
char rotx[MAXSHIPS];
char roty[MAXSHIPS];
char rotz[MAXSHIPS];
char accel[MAXSHIPS];
char speed[MAXSHIPS];
char target[MAXSHIPS];
char flags[MAXSHIPS];
char ttl[MAXSHIPS];
char energy[MAXSHIPS];
char missiles[MAXSHIPS];
char ai_state[MAXSHIPS];
char vertexXLO[MAXSHIPS];
char vertexXHI[MAXSHIPS];
char vertexYLO[MAXSHIPS];
char vertexYHI[MAXSHIPS];



/* Needed in GetVec and GetPos */

extern signed char VX,VY,VZ;
extern int PosX,PosY,PosZ;

/* Used to specify final destination in fly_to_vector */
extern int VectX,VectY,VectZ;


/* For fired lasers */
extern char numlasers;
extern char laser_source[4];
extern char laser_target[4];



extern int SqRoot(int);
extern int abs(int);
extern void GetFrontVector();
extern void GetDownVector();
extern void GetSideVector();
extern void GetShipPos();
extern void SetCurrentObject(char);
extern int dot_product();
extern void fly_to_vector();
extern void norm_big();



space_main()
{
   
    char * p;
    /*unsigned int delay;
    int i,j,k;
    int res1,res2;*/
    
       
    //init_tine();




    p=(char *)0x24e;  
    *p=5;
    p=(char *)0x24f;  
    *p=1; 

      
/*    for (i=0;i<=30000;i+=10000)
        for(j=0;j<=20000;j+=10000)
            for(k=0;k<=20000;k+=10000)
                {
                    VectX=i;VectY=j;VectZ=k;
                    printf("%d, %d, %d ->",VectX,VectY,VectZ); 
                    norm_big();
                    printf("%d, %d, %d\n",VectX,VectY,VectZ); 
                    getchar();
                    
                }
        
*/

    hires();

#ifndef FILLEDPOLYS
    curset(5,5);
    draw(0,123,1);
    draw(230,0,1);
    draw(0,-123,1);
    draw(-230,0,1);
#endif
    printf("A/Z Pitch, Q/W Roll, S/D Yaw\nO/L accel/deccel B missile 1 laser");

    InitTestCode();
    
    FirstFrame();

    RunDemo();

    //FirstFrame();
    //TestLoop();


}


/*
void printHit()
{
    
    //props();
    //printf("  HIT %d \n",ID);
    explode();
    

}*/


void DrawLaser()
{
    curset(10,128,1);
    draw(110,-64,1);    

    curset(230,128,1);
    draw(-110,-64,1);    

}



