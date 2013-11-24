/*
    mym2ym.c

    Converts MYM files back to upacked YM3.

    31.1.2000 Marq/Lieves!Tuore & Fit (marq@iki.fi)
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define REGS 14
#define FRAG 128    /*  Nuber of rows to compress at a time   */
#define OFFNUM 14   /*  Bits needed to store off+num of FRAG  */

unsigned readbits(int bits,FILE *f);

int main(int argc,char *argv[])
{
    unsigned char   *data[REGS],    /*  The unpacked YM data    */
                    c;

    unsigned    current[REGS];

    FILE    *f;

    long    n,i,row,index,compoff,compnum,
            bytes=0,
            regbits[REGS]={8,4,8,4, 8,4,5,8, 5,5,5,8, 8,8}; /* Bits per PSG reg */

    unsigned long   rows;

    if(argc!=3)
    {
        printf("Usage: mym2ym source.mym destination.ym\n");
        printf("Raw YM files only. Compress with LHA.\n");
        return(EXIT_FAILURE);
    }

    if((f=fopen(argv[1],"rb"))==NULL)
    {
        printf("File open error.\n");
        return(EXIT_FAILURE);
    }

    rows=fgetc(f);    /*  Read the number of rows */
    rows+=fgetc(f)<<8u;

    for(n=0;n<REGS;n++)     /*  Allocate memory for rows    */
    {
        if((data[n]=malloc(rows+FRAG))==NULL)
        {
            printf("Out of memory.\n");
            exit(EXIT_FAILURE);
        }
    }

    for(n=0;n<rows;n+=FRAG) /*  Go through rows...  */
    {
        for(i=0;i<REGS;i++) /*  ... and registers   */
        {
            index=0;
            if(!readbits(1,f))  /*  Totally unchanged fragment */
            {
                for(row=0;row<FRAG;row++)
                    data[i][n+row]=current[i];
                continue;
            }

            while(index<FRAG)   /*  Packed fragment */
            {
                if(!readbits(1,f))  /*  Unchanged register  */
                {
                    
                    data[i][n+index]=current[i];
                    index++;
                }
                else
                {
                    if(readbits(1,f))   /*  Raw data    */
                    {
                        c=readbits(regbits[i],f);
                        current[i]=data[i][n+index]=c;
                        index++;
                    }
                    else    /*  Reference to previous data */
                    {
                        compoff=readbits(OFFNUM/2,f)+index;
                        compnum=readbits(OFFNUM/2,f)+1;

                        for(row=0;row<compnum;row++)
                        {
                            c=data[i][n-FRAG+compoff+row];
                            data[i][n+index]=current[i]=c;
                            index++;
                        }
                    }
                }
            }
        }
    }

    fclose(f);

    if((f=fopen(argv[2],"wb"))==NULL)
    {
        printf("Cannot open destination file.\n");
        return(EXIT_FAILURE);
    }

    /*  Write uncompressed data to YM3 format   */
    fwrite("YM2!",1,4,f);
    for(n=0;n<REGS;n++)
        fwrite(data[n],1,rows,f);
    fclose(f);

    return(EXIT_SUCCESS);
}

/*  Reads bits from a while */
unsigned readbits(int bits,FILE *f)
{
    static unsigned char    byte;

    static int  off=7;

    unsigned    n,data=0;

    /* Go through the bits and read a whole byte if needed */
    for(n=0;n<bits;n++) 
    {
        data<<=1;
        if(++off==8)
        {
            byte=fgetc(f);
            off=0;
        }
        
        if(byte&(0x80>>off))
            data++;
    }
    return(data);
}

/*  EOS */