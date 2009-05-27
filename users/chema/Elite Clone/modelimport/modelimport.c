#include <stdio.h>
#include <stdio.h >
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <math.h>

#define TRUE   1
#define FALSE  0

#define MAX_PATH    100
#define MAX_VERTEX	200
#define MAX_FACES   200

typedef struct t_face
{
	unsigned int color;
	int normalX,normalY,normalZ;
	unsigned int numPoints;
	unsigned int pointList[MAX_VERTEX];
}face_t;


typedef struct t_model
{
	char name[10];
	unsigned int frontLaserVertex;
	unsigned int numVertex;
	unsigned int numFaces;
	int VertexX[MAX_VERTEX];
	int VertexY[MAX_VERTEX];
	int VertexZ[MAX_VERTEX];
	face_t faceList[MAX_FACES];
}model_t;

model_t model;
FILE * fin, * fout;
char ships[50][50];
int numModels;


void check_model()
{
	int i,j;
	float dist;
	float maxdist=0;

	printf("Checking model...");
	
	
	for (i=0;i<model.numVertex;i++)
	{
		dist =model.VertexX[i]*model.VertexX[i];
		dist+=model.VertexY[i]*model.VertexY[i];
		dist+=model.VertexZ[i]*model.VertexZ[i];
		dist=sqrt(dist);

		if(dist > 95) 
		{
			printf("\n Vertex %d is too far (%f)\n",i,dist);
			if (dist>maxdist) maxdist=dist;
		}
	}

	if(maxdist)
	{
		printf("Correcting by scalling down a factor of %f...\n",maxdist/95);
		for (i=0;i<model.numVertex;i++)
		{
			model.VertexX[i]=floor((float)model.VertexX[i]*94/maxdist);
			model.VertexY[i]=floor((float)model.VertexY[i]*94/maxdist);
			model.VertexZ[i]=floor((float)model.VertexZ[i]*94/maxdist);
		}
		printf("Recheck %s ship..",model.name);
		check_model();
	}

	printf("done.\n");



}

char IsInverted(int face)
{
	float z1,z2,normX,normY,normZ;
	int res=1;

	// Calculate normal and compare with model description

	int index1=model.faceList[face].pointList[0];
	int index2=model.faceList[face].pointList[1];
	int index3=model.faceList[face].pointList[2];

	
	z1=(model.VertexY[index2]-model.VertexY[index1])*(model.VertexZ[index3]-model.VertexZ[index2]);
	z2=(model.VertexZ[index2]-model.VertexZ[index1])*(model.VertexY[index3]-model.VertexY[index2]);
	normX=z1-z2;

	res=res && (normX<=0 && model.faceList[face].normalX<=0) || (normX>0 && model.faceList[face].normalX>0);

	z1=(model.VertexX[index2]-model.VertexX[index1])*(model.VertexZ[index3]-model.VertexZ[index2]);
	z2=(model.VertexZ[index2]-model.VertexZ[index1])*(model.VertexX[index3]-model.VertexX[index2]);
	normY=-(z1-z2);

	res=res && (normY<=0 && model.faceList[face].normalY<=0) || (normY>0 && model.faceList[face].normalY>0);

	z1=(model.VertexX[index2]-model.VertexX[index1])*(model.VertexY[index3]-model.VertexY[index2]);
	z2=(model.VertexY[index2]-model.VertexY[index1])*(model.VertexX[index3]-model.VertexX[index2]);
	normZ=z1-z2;

	res=res && (normZ<=0 && model.faceList[face].normalZ<=0) || (normZ>0 && model.faceList[face].normalZ>0);


	return (!res);
	
}

void write_model()
{

	int i,j;

	check_model();
	
	fprintf(fout,"; Model of ship %s\n",model.name);
	fprintf(fout,"%s\n",model.name);
	fprintf(fout,"\t.byt 0\t; Ship type\n\t.byt %d\t;Number of vertices\n\t.byt %d\t;Number of faces\n\n",
		model.numVertex,model.numFaces);

	fprintf(fout,";Vertices List - X coordinate\n\t.byt ");
	for (i=0;i<model.numVertex;i++)
	{
		j=-model.VertexX[i];
		if (j<0) 
		{
			j=(256-abs(j));
			j=j&0xff;
		}
		fprintf(fout,"$%.2hX",j);
		if(i<model.numVertex-1) fprintf(fout,",");
	}

	fprintf(fout,"\n\n;Vertices List - Y coordinate\n\t.byt ");
	for (i=0;i<model.numVertex;i++)
	{
		j=-model.VertexY[i];
		if (j<0) 
		{
			j=(256-abs(j));
			j=j&0xff;
		}
		fprintf(fout,"$%.2hX",j);
		if(i<model.numVertex-1) fprintf(fout,",");
	}

	fprintf(fout,"\n\n;Vertices List - Z coordinate\n\t.byt ");
	for (i=0;i<model.numVertex;i++)
	{
		j=-model.VertexZ[i];
		if (j<0) 
		{
			j=(256-abs(j));
			j=j&0xff;
		}
		fprintf(fout,"$%.2hX",j);
		if(i<model.numVertex-1) fprintf(fout,",");
	}

	// Now the faces...
	fprintf(fout,"\n\n; Face data");
	for (i=0;i<model.numFaces;i++)
	{
		fprintf(fout,"\n");
		fprintf(fout,"\t.byt %d\t;Number of points\n",model.faceList[i].numPoints);
		fprintf(fout,"\t.byt 0\t;Fill pattern\n");
		fprintf(fout,"\t.byt ");

		if(IsInverted(i)) //model.faceList[i].normalY<0 )//&& model.faceList[i].normalZ>0)
		{
			for (j=model.faceList[i].numPoints-1;j>=0;j--)
			{
				fprintf(fout,"%d,",model.faceList[i].pointList[j]);
				
			}
			fprintf(fout,"%d ; Inverted",model.faceList[i].pointList[model.faceList[i].numPoints-1]);
		}
		else
		{
			for (j=0;j<model.faceList[i].numPoints;j++)
			{
				fprintf(fout,"%d,",model.faceList[i].pointList[j]);
				
			}
			fprintf(fout,"%d",model.faceList[i].pointList[0]);
		}
		fprintf(fout,"\n\n");
	}

	fprintf(fout,"\n; End of ship %s data\n\n",model.name); 


}



void read_model()
{
	char seps[]   = " ,\t\n";
	char *token;

	
	char cadena[200];
	unsigned int i,j;
	int fin_modelo=0;


	do{
		fin_modelo=(fgets(cadena,200,fin)==NULL);
		if( (token = strtok( cadena, seps )) != NULL)
		{
			if (strcmp("REM",token)) 
			{
				if (*token==':')
				{
					// Ship name, laser vertex and number of vertices and faces...
					fscanf(fin," %s\n",&model.name);
					
					printf("Converting model: %s\n",model.name);
					strcpy(ships[numModels],model.name);
					numModels++;

					fscanf(fin," &%x\n",&model.frontLaserVertex);
					fscanf(fin," &%x,&%x\n",&model.numVertex,&model.numFaces);
					
					// now let's read vertices list
					fscanf(fin," vertices\n");
					
					for (i=0;i<model.numVertex;i++)
					{
						fscanf(fin," &%x,&%x,&%x\n",&model.VertexX[i],&model.VertexY[i],&model.VertexZ[i]);
					}
					
					// now read faces...
					fscanf(fin," faces\n");

					for (i=0;i<model.numFaces ;i++)
					{
						fgets(cadena,200,fin);
						
						token=strtok(cadena,seps);
						//model.faceList[i].color=get_color(*token);
						
						token=strtok(NULL,seps);
						sscanf(token,"&%x",&model.faceList[i].normalX);
						
						token=strtok(NULL,seps);
						sscanf(token,"&%x",&model.faceList[i].normalY);
						
						token=strtok(NULL,seps);
						sscanf(token,"&%x",&model.faceList[i].normalZ);
						
						token=strtok(NULL,seps);
						sscanf(token,"%d",&model.faceList[i].numPoints);
												
						for (j=0;j<model.faceList[i].numPoints;j++)
						{	
							token=strtok(NULL,seps);
							sscanf(token,"%d",&model.faceList[i].pointList[j]);
							
						}
					}


				write_model();	
				fflush(fout);

				}
			}
		}

	}while(!fin_modelo);


}


void main (int argc, char * argv[])
{
   char fileName [MAX_PATH];
   char fileOut  [MAX_PATH];
   int i;

	if (argc < 3)
	{
		printf("Usage: %s <input_file> <output_file>\n",argv[0]);
		exit(-1);
	}

   strcpy(fileOut,argv[2]);
   strcpy(fileName,argv[1]);

   if ((fin = fopen (fileName, "r")) == NULL)
      {  printf("\n\n\a Error Opening Disc File %s", fileName );
         exit (1);
      }


   if ((fout = fopen (fileOut, "w")) == NULL)
      {  printf("\n\n\a Error Creating Disc File %s", fileOut );
         exit (1);
      }


   printf("Importing models from %s, writting data to %s\n",fileName,fileOut);

   fprintf(fout,";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;\n");
   fprintf(fout,"; ==================== Model description file =======================\n");
   fprintf(fout,";Shape Data clawed out from original 6502 elite data files by Ian Bell\n");
   fprintf(fout,";Conversion by modelimport. DO NOT EDIT BY HAND\n");		
   fprintf(fout,";\n;\n");
   fprintf(fout,"; Ship format: type, number of vertices, number of faces\n");
   fprintf(fout,"; Vertices, X coordinates, Y coordinates and Z coordinates\n");
   fprintf(fout,"; Face data: num vertices-1, fill pattern, list of vertices\n"); 
   fprintf(fout,";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;\n\n\n");

   read_model();

   fprintf(fout,"\n\n ; Model pointers:\n");
   fprintf(fout,"\t .byt %d ; Number of models\n",numModels);
   fprintf(fout,"\t .byt");
   for (i=0; i<numModels;i++)
   {
	   fprintf(fout," #<(%s)",ships[i]);
	   if(i<numModels-1) fprintf(fout,",");
   }
   fprintf(fout,"\n");
   fprintf(fout,"\t .byt");
   for (i=0; i<numModels;i++)
   {
	   fprintf(fout," #>(%s)",ships[i]);
	   if(i<numModels-1) fprintf(fout,",");
   }
   fprintf(fout,"\n");


   fflush(fout);

   fclose(fin); fclose(fout);

   exit (0);

}

