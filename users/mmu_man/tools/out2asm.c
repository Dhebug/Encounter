#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static FILE *fi = 0;
static FILE *fo = 0;
static char *fin = 0;
static char *fon = 0;

static int quit = 0;

static unsigned char getb(void)
{
    int c = fgetc(fi);
    if(-1==c)
        quit = 1;
    return (unsigned char)(0xFF & c);
}

static void convert(void)
{
    unsigned char data;
    fprintf(fo,".text\n\n",data);
    fprintf(fo,"_AYData\n",data);
    while(1)
    {
        data = getb();

        if(quit)
            break;

        fprintf(fo,"    .byte   $%.2X,",data);

        data = getb();
        //fprintf(fo," $%.2X,",data);

        data = getb();
        fprintf(fo," $%.2X,",data);

        data = getb();
        fprintf(fo," $%.2X\n",data);
    }
    fprintf(fo,"\n_AYData_End\n",data);
    fprintf(fo,"\n_AYData_Size    .word (_AYData_End - _AYData)\n",data);
}


static void cleanup(void)
{
    if(fin)
    {
        free(fin);
        fin = 0;
    }
    if(fon)
    {
        free(fon);
        fon = 0;
    }

    if(fi)
    {
        fflush(fi);
        fclose(fi);
        fi = 0;
    }
    if(fo)
    {
        fflush(fo);
        fclose(fo);
        fo = 0;
    }
}

int main(int argc, char** argv)
{

    if(2==argc)
    {
        int l;
        char *p;
        fin = strdup(argv[1]);
        p = strrchr(fin,'.');
        if(p)
        {
            l = (p - fin) + 2 + 1;
            fon = malloc(l);
            strncpy(fon,fin,p-fin);
            strcat(fon,".S");
        }
        else
        {
            l = strlen(fin) + 2 + 1;
            fon = malloc(l);
            strcpy(fon,fin);
            strcat(fon,".S");
        }
        fi = fopen(fin,"rb");
        if(!fi)
        {
            perror("can't open input file\n");
            cleanup();
            return -1;
        }
        fo = fopen(fon,"wt");
        if(!fo)
        {
            perror("can't open output file\n");
            cleanup();
            return -1;
        }

        /*
         *        fprintf(stderr,"input: %s\n", fin);
         *        fprintf(stderr,"output: %s\n", fon);
         */

        convert();
        cleanup();
        return 0;
    }
    else if(3==argc)
    {
        fin = strdup(argv[1]);
        fon = strdup(argv[2]);

        fi = fopen(fin,"rb");
        if(!fi)
        {
            perror("can't open input file\n");
            cleanup();
            return -1;
        }
        fo = fopen(fon,"wt");
        if(!fo)
        {
            perror("can't open output file\n");
            cleanup();
            return -1;
        }

        /*
         *        fprintf(stderr,"input: %s\n", fin);
         *        fprintf(stderr,"output: %s\n", fon);
         */

        convert();
        cleanup();
        return 0;
    }


    perror("bad params\n");
    return -1;
}
