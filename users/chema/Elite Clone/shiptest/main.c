#include <stdio.h>
#include <string.h>


//#define FILLEDPOLYS


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


extern char MinX[255];
extern char MaxX[255];
extern char PolyY0;
extern char PolyY1;
extern char CurrentPattern;

extern char CurrentPixelX;
extern char CurrentPixelY;
extern char OtherPixelX;
extern char OtherPixelY;
extern void DrawLine();



main()
{
   
    char * p;
    unsigned int delay;
    int i,j,k;


   

    //printf("Press key to start \n"); getchar();getchar();
    //InitTestCode();


    p=(char *)0x24e;  
    *p=5;
    p=(char *)0x24f;  
    *p=1; 

    hires();


    curset(5,5);
    draw(0,123,1);
    draw(230,0,1);
    draw(0,-123,1);
    draw(-230,0,1);

    printf("O to get closer, L to get further\nIf too close, it dissappears!");

#ifdef FILLEDPOLYS
    ComputeDivMod();
    InitTables();   /* For filled polys */
#else
    GenerateTables(); /* For Wireframe*/
#endif

    InitTestCode();
    
    FirstFrame();

    RunDemo();

    //FirstFrame();
    //TestLoop();


}




void print()
{
  //printf("POS: %d,%d,%d\n",*(int *)pointer,*((int *)(pointer)+2),*((int *)(pointer)+4));
    printf("POS: %d,%d,%d\n",pointer->CenterX,pointer->CenterY,pointer->CenterZ);

}


