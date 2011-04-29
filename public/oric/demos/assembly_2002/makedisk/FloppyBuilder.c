#include <stdio.h>
#define  DEBUG 0

#define header_dsk 256+156


// Nombre de secteur pour une piste
#define taille_piste 17

#define taille_secteur 256
// Header secteur
#define nb_oct_before_sector 59 // Cas de 17 secteurs/pistes !
//#define nb_oct_after_sector 31
#define nb_oct_after_sector 43

int  formule_disk(int track,int sector)
	{
	int offset;
//        printf("Secteur %d\n",sector);
	offset=header_dsk; // on ajoute le header
	offset+=track*6400; // On avance à la bonne piste

	offset+=(taille_secteur+nb_oct_after_sector+nb_oct_before_sector)*(sector-1);
	return offset;
	}

void  install_boot_sector(FILE *floppy,char *fichier)
	{
	FILE *builder2;
	int i=0;
	char car;
 if (fichier[strlen(fichier)-1]=='\n') fichier[strlen(fichier)-1]='\0';
	builder2=fopen(fichier,"rb");
	if (builder2!=NULL)
		{
if (DEBUG>1)
		printf("\033[35m{!} FloppyBuilder IN BOOT SECTOR : Write %s\n",fichier);

		fseek(floppy,0x0319,SEEK_SET); // On avance de temp
		while (fread (&car,1, 1, builder2)==1)
			{
			if (i==256)
				{
				printf("\033[34m{!} Error File for boot sector is larger than 256 Bytes !\n");
				break;
				}
					    //    car='J';
                        fputc(car,floppy);
			i++;
			}

	 }
		else
		printf("\033[34m{!} Error can't found file %s",fichier);
printf("\033[31m");
//	return 0x0319;
	}

int detecte_chaine_renvoi_suite(char *a_detecter,char *ligne,char sortie[])
{
/*Cherche si la chaine *a_detecter est dans ligne si oui
elle renvoie ce qui suit sinon renvoie chaine vide*/
int i=0,j=0;
char test_chaine[200];

while (ligne[i]==' ' && ligne[i]=='\t') i++;

for(j=0;j<strlen(a_detecter);j++)
  {
  test_chaine[j]=ligne[i];
  i++;
  }
  test_chaine[j]='\0';
if (strcmp(test_chaine,a_detecter)==0)
{
j=0;
while  (ligne[i]!='\0'&&ligne[i]!='\n')
  {
  sortie[j]=ligne[i];
  i++;
  j++;
  }
sortie[j]='\0';
return 1;
}
return -1;
}







main (int argv, char *argc[])

{

int num_prg=0;

FILE *filetobuild;
FILE *builder;
FILE *floppy;
FILE *loader;
int ptr_floppy=0;
char ligne[900];
int num_track=0;
int track=12;
int ptr_track=0;
int sector=17;
int ptr_sector=1;
char car;
int size=0;
int temp;
int i;
int ptr_nb_oct=0;
int jump_to_next_track;
int foireux=0;
int nb_sectors_by_files=0;
int start=0;
char sortie[1500];
char code_drive[1500]="datas_lecteur\n.byt ";
char code_sector[1500]="datas_secteur\n.byt ";
char code_track[1500]="datas_piste\n.byt ";
char code_nombre_secteur[1500]="nombre_secteur\n.byt ";
char code_adress_low[1500]="adresse_chargement_low\n.byt ";
char code_adress_high[1500]="adresse_chargement_high\n.byt ";
char buf_convert[100];
char strbuf[5];
int all_code=0;
int change_track=0;

printf("FloppyBuilder 2001 May By Jede V0.1\n");
printf("FloppyBuilder 2002 May By Jede V0.2 (Current)\n");
//printf("\33[31mBe careful ! Track 42 sector 15-17 is reserved for Booting the program !\n");
printf("\033[37m");
/*Read the conf file*/
filetobuild=fopen("filetobuild.txt","r");

system("cp -f default.dsk 1vip4.dsk");

if (filetobuild==NULL)
        printf("----------------------------------------------------------->FloppyBuilder :Can't open filetobuild.txt\n");
else
	{
        start=0;
        floppy=fopen("1vip4.dsk","rb+");
        printf("FloppyBuilder : 1vip4.dsk is created\n");
        //jump_to_next_track=6400-(taille_secteur+nb_oct_after_sector+nb_oct_before_sector)*taille_piste-1;
//ptr_track*6400+header_dsk+(taille_secteur+nb_oct_after_sector+nb_oct_before_sector)*(ptr_sector-1);
	temp=formule_disk(ptr_track,ptr_sector);

        fseek(floppy,temp,SEEK_SET); // On avance de temp
	//printf("{!} FloppyBuilder : First position at %x\n",temp);
	// On lit la piste et le secteur
        fscanf(filetobuild,"%d %d",&ptr_track,&ptr_sector);
	if (DEBUG>1)
		printf("FloppyBuilder : Write at Track %d sector %d \n",ptr_track,ptr_sector);
        // On saute grosse bidouille
        fgets(ligne,900,filetobuild);
        while (fgets(ligne,900,filetobuild)!=NULL)
		{
		if (detecte_chaine_renvoi_suite("#bootsector",ligne,sortie)==1)
        		{
        		//fscanf(filetobuild,"%d %d",&ptr_track,&ptr_sector);
			printf("Installing in boot sector !\n");
			fgets(ligne,900,filetobuild); // On lit le fichier à installer dans le boot sector
			install_boot_sector(floppy,ligne);
			}
		else
		if (detecte_chaine_renvoi_suite("#new position on disk",ligne,sortie)==1)
        		{
        		fscanf(filetobuild,"%d %d",&ptr_track,&ptr_sector);
        		fgets(ligne,900,filetobuild);
		if (DEBUG>1)
			{
			printf("FloppyBuilder : Change position !!!\n");
        		printf("FloppyBuilder : Write at Track %d sector %d \n",ptr_track,ptr_sector);
			}
	     fgets(ligne,900,filetobuild);
        		}
		else
	        if (detecte_chaine_renvoi_suite("#load it at ",ligne,sortie)==1)
        		{
        		//printf("%s\n",ligne);
             		if (start==1)
                		{
                		strcat(code_adress_low,",");
                		strcat(code_adress_high,",");
                		}
			strbuf[0]='$';
             		strbuf[1]=sortie[0];
             		strbuf[2]=sortie[1];
             		strbuf[3]='\0';
             		strcat(code_adress_high,strbuf);
			strbuf[0]='$';
             		strbuf[1]=sortie[2];
             		strbuf[2]=sortie[3];
             		strbuf[3]='\0';
             		strcat(code_adress_low,strbuf);
		        }
        	else
        		{
		        if (ligne[strlen(ligne)-1]=='\n') ligne[strlen(ligne)-1]='\0';
	if (DEBUG>1)
	{
	printf("\033[37m");
	printf("\033[32m{!} FloppyBuilder : Request to add %s\n",ligne);
	printf("\033[37m");
	printf("FloppyBuilder : Write %s at Track %d sector %d \n",ligne,ptr_track,ptr_sector);
	}
        if (ptr_sector==taille_piste+1)
                {
                ptr_sector=1;
                ptr_track++;
                }



        ptr_nb_oct=0;

        if (start==1)
                {
                strcat(code_drive,",");
                strcat(code_sector,",");
                strcat(code_track,",");
                strcat(code_nombre_secteur,",");

                }
        if (ptr_track>41) // face 2
                {
                sprintf(buf_convert,"%d",ptr_track-42+128);
                 }
        else
        sprintf(buf_convert,"%d",ptr_track);
	temp=formule_disk(ptr_track,ptr_sector);
   //       temp=ptr_track*6400+header_dsk+(taille_secteur+nb_oct_after_sector+nb_oct_before_sector)*(ptr_sector-1);
	if (DEBUG>1)
		printf("{!} FloppyBuilder : Write file at %x\n",temp);
	fseek(floppy,temp,SEEK_SET); // On avance de temp

        strcat(code_track,buf_convert);

        sprintf(buf_convert,"%d",ptr_sector);
        strcat(code_sector,buf_convert);

        strcat(code_drive,"0");
        //

/*LECTURE */

/*********************************ICI on construit la floppy avec le pgrm c ici que le bug se trouve*/
builder=fopen(ligne,"rb");
if (builder==NULL)
	printf("----------------------------------------------------------->FloppyBuilder : Error can't open %s\n",ligne);
else
	{
	if (DEBUG>1)
		printf("\033[32m{!} FloppyBuilder : Write %s\n",ligne);
	nb_sectors_by_files=0;
	while (fread (&car,1, 1, builder)==1)
        	{
                //On écrit un secteur ? On saute le descripteur


		if (ptr_nb_oct==256) // We reached a sector
			{

			fseek(floppy,nb_oct_after_sector+nb_oct_before_sector,SEEK_CUR); // On avance de temp
			ptr_nb_oct=0;
			ptr_sector++;
			nb_sectors_by_files++;
			}

		if (ptr_sector==taille_piste+1) // We reached the end of the track!
			{

//			printf("nb_oct %d\n",ptr_nb_oct);
			//fputc(car,floppy);
			//fread (&car,1, 1, builder);
			ptr_nb_oct=0;
			ptr_sector=1;
			ptr_track++;
			temp=formule_disk(ptr_track,ptr_sector);
			if (DEBUG>1)
				{
				printf("{!} FloppyBuilder : Go to the next track Sector 1 at %x\n",temp);
				}
			fseek(floppy,temp,SEEK_SET); // On avance de temp
			//ptr_nb_oct=1;// On écrit 2 fois l'octet, si on ne le fait pas le disk n'est pas valide
			}




		fputc(car,floppy);
		ptr_nb_oct++;
		ptr_floppy++;
		size++;
		}
	}
	if (DEBUG>1)
		printf("{!} FloppyBuilder : %d bytes written from %s, Sectors written : %d \n",size,ligne,nb_sectors_by_files);
                                all_code+=size;
				//ptr_sector++;
				nb_sectors_by_files++;
				sprintf(buf_convert,"%d",nb_sectors_by_files);
                                strcat(code_nombre_secteur,buf_convert);
                                ptr_sector++;
                                size=0;
                                fclose(builder);
                                num_prg++;


          start=1;
        }// Fin test load it at
/*********************************Fin de construiction du prgm ds la floppy*/
        }            // fin bcl de lecture ds filetobuild
        loader=fopen("loader.cod","w");
printf("{!} FloppyBuilder : nb prg %d\n",num_prg);

                fputs(code_drive,loader);
                fputs("\n",loader);


fputs("nb_prgm\n",loader);
fputs(code_sector,loader);
fputs("\n",loader);
fputs(code_track,loader);
fputs("\n",loader);
fputs(code_nombre_secteur,loader);
fputs("\n",loader);
fputs(code_adress_low,loader);
fputs("\n",loader);
fputs(code_adress_high,loader);
fputs("\n",loader);


        fclose(loader);
        fclose(filetobuild);
        //printf("FloppyBuilder : filetobuild.txt is closed\n");
        fclose(floppy);
        //while (ptr_floppy<SIMPLE_FACE) {fputc(car,floppy);}
        printf("FloppyBuilder : floppy.dsk built successfully\n");
        printf("{!} FloppyBuilder : %d bytes written\n",all_code);

	}

		printf("\033[39m");
}
