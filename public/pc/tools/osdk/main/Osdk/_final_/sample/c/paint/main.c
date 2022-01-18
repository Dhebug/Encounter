// 
// C Conversion from the BASIC source code from Geoff Phillips book "Oric Atmos and Oric 1 Graphics and Machine code techniques"
// https://library.defence-force.org/index.php?content=any&page=books&sort_by=name&freesearch=007084743
//
// Total times in hundreds of seconds, divide by 6000 to get in minutes
// - 23572 (3.92 minutes)
// - 22544 (3.75 minutes) - Moved "int a[100]" from local to global
// - 21428 (3.57 minutes) - Changed "int a[100]" to "unsigned char a[100]"
//
#include <lib.h>

extern unsigned char LabelPicture[];

unsigned char a[100];

void paint(int x,int y)    
{ 
    int s=100;
    int uf=0;
    int df=0;
    int rf=0;
    int t=0;
    int r=0;
    int k=0;
    int p;

    a[--s]=255;
    a[--s]=255;

    a[--s]=x;
    a[--s]=y;

    while (1)
    {
        y=a[s++];
        x=a[s++];

        if (x==255)
        {
            return;
        }
    
        if (rf==0)
        {
            uf=1;
            df=1;
        }
    
        t=s;
        r=s;

        while (a[r]!=255)
        {
            if ( (a[r]==y) && (a[r+1]==x) )
            {
                r--;
                k=r;
                do
                {
                    a[k+2]=a[k];
                    k--;
                }
                while (k>=t);
                s+=2;
                break;
            }
            r+=2;
        };

        curset(x,y,1);

        if (y>0)    p=point(x,y-1);
        else        p=1;      
        if (uf && (p==0))
        {        
            a[--s]=x;
            a[--s]=y-1;
        }
        uf=p;

        if (y<199)  p=point(x,y+1);
        else        p=1;      
        if (df && (p==0))
        {        
            a[--s]=x;
            a[--s]=y+1;
        }
        df=p;

        rf=0;
        if ((x>0) && point(x-1,y)==0)
        {        
            a[--s]=x-1;
            a[--s]=y;
            rf=1;
        }

        if ((x<239) && point(x+1,y)==0)
        {        
            a[--s]=x+1;
            a[--s]=y;
            rf=1;
        }
    }
} 


void main()
{
    hires();

	memcpy((unsigned char*)0xa000,LabelPicture,8000);

    doke(630,0);
    paint(120,100);
    printf("Total time: %u",65535-deek(630));   
}

