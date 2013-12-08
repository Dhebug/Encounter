
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sstream>
#include <iostream>
#include <vector>

#include "infos.h"
#include "common.h"
#include "Floppy.h"




void main(int argc, char *argv[])
{
  //
  // Some initialization for the common library
  //
  SetApplicationParameters(
    "MakeDisk",
    TOOL_VERSION_MAJOR,
    TOOL_VERSION_MINOR,
    "{ApplicationName} - Version {ApplicationVersion} - This program is a part of the OSDK\r\n"
    "\r\n"
    "Author:\r\n"
    "  (c) 2002 Debrune Jerome for the initial version \r\n"
    "  (c) 2013 Pointier Mickael for the subsequent changes \r\n"
    "\r\n"
    "Purpose:\r\n"
    "  Generating bootable floppies for the Oric computer.\r\n"
    );

  // makedisk filetobuild.txt default.dsk ..\build\%OSDKDISK%

  long param=1;									   

  if (argc>1)
  {
    for (;;)
    {
      long nb_arg=argc;
      const char *ptr_arg=argv[param];

      if (nb_arg==argc)   break;
    }
  }


  if (argc!=4)
  {
    ShowError(nullptr);
  }


  //
  // Copy last parameters
  //
  char	description_name[_MAX_PATH];

  strcpy(description_name,argv[param]);

  char source_name[_MAX_PATH];
  char dest_name[_MAX_PATH];
  param++;
  strcpy(source_name,argv[param]);
  param++;
  strcpy(dest_name,argv[param]);

  //char ligne[900];
  int start=0;

  std::stringstream code_drive;
  std::stringstream code_sector;
  std::stringstream code_track;
  std::stringstream code_nombre_secteur;
  std::stringstream code_adress_low;
  std::stringstream code_adress_high;

  code_drive << "datas_lecteur\n.byt ";
  code_sector << "datas_secteur\n.byt ";
  code_track << "datas_piste\n.byt ";
  code_nombre_secteur << "nombre_secteur\n.byt ";
  code_adress_low << "adresse_chargement_low\n.byt ";
  code_adress_high << "adresse_chargement_high\n.byt ";

  //
  // Open the description file
  //
  std::vector<std::string> script;
  if (!LoadText(description_name,script))
  {
    printf("Can't load script file '%s'\n",description_name);
    exit(1);
  }

  //
  // Copy the floppy disk
  //
  Floppy floppy;
  if (!floppy.Load(source_name))
  {
    printf("FloppyBuilder: Can't load '%s'\n",source_name);
    exit(1);
  }

  // Example of file:
  /*
  1 13
  #load it at 1000
  demo\part_hires_picture.o
  #load it at 0500
  demo\part_hires_picture.o
  #load it at 0500
  demo\part_motherboard_scroller.o
  #new position on disk
  0 5
  #load it at fc00
  demo\loader.o
  #bootsector
  demo\bootsector.o
  */


  // 
  // Set some semi sane 
  //
  int currentTrack =1;
  int currentSector=1;
  floppy.SetOffset(currentTrack,currentSector);

  int lineNumber=0;
  int fileCount=0;
  for (auto it(script.begin());it!=script.end();++it)
  {
    ++lineNumber;

    const std::string currentLine(*it);

    std::istringstream iss(currentLine);

    std::string item;
    std::vector<std::string> tokens;
    while (std::getline(iss, item,' ')) 
    {
      if (!item.empty())
      {
        tokens.push_back(item);
      }
    }

    if (!tokens.empty())
    {
      if (tokens[0][0]==';')
      {
        // Comments, just skip them
      }
      else
      if (tokens[0]=="SetPosition")
      {
        if (tokens.size()==3)
        {
          currentTrack =std::atoi(tokens[1].c_str());
          currentSector=std::atoi(tokens[2].c_str());
          floppy.SetOffset(currentTrack,currentSector);
        }
        else
        {
          printf("Syntax error line (%d), syntax is 'SetPosition TrackNumber SectorNumber' \n",lineNumber);
        }
      }
      else
      if (tokens[0]=="SetBootSector")
      {
        if (tokens.size()==3)
        {
          std::string fileName=tokens[2];
          if (tokens[1]=="Microdisc")
          {
            floppy.writeSector(0,2,fileName.c_str());
          }
          else
          if (tokens[1]=="Jasmin")
          {
            floppy.writeSector(0,1,fileName.c_str());
          }
          else
          {
            printf("Syntax error line (%d), syntax is 'SetBootSector Jasmin|Microdisc FilePath'. '%s' is not a valid type \n",lineNumber,tokens[1].c_str());
          }
        }
        else
        {
          printf("Syntax error line (%d), syntax is 'SetBootSector Jasmin|Microdisc FilePath' \n",lineNumber);
        }
      }
      else
      if (tokens[0]=="AddFile")
      {
        if (tokens.size()==3)
        {
          std::string fileName=tokens[1];
          int loadAddress=ConvertAdress(tokens[2].c_str());

          if (currentSector==taille_piste+1)
          {
            currentSector=1;
            currentTrack++;
          }

          if (fileCount)
          {
            code_adress_low  << ",";
            code_adress_high << ",";

            code_drive << ",";
            code_sector << ",";
            code_track << ",";
            code_nombre_secteur << ",";
          }
          code_adress_low  << "<" << tokens[2];
          code_adress_high << ">" << tokens[2];

          if (currentTrack>41) // face 2
          {
            code_track << currentTrack-42+128;
          }
          else
          {
            code_track << currentTrack;
          }
          code_sector << currentSector;

          code_drive << "0";

          int nb_sectors_by_files=floppy.writeFile(fileName.c_str(),currentTrack,currentSector);
          code_nombre_secteur << nb_sectors_by_files;

          //floppy.SetOffset(currentTrack,currentSector);
          ++fileCount;
        }
        else
        {
          printf("Syntax error line (%d), syntax is 'AddFile FilePath LoadAddress' \n",lineNumber);
        }
      }
      else
      {
        printf("Syntax error line (%d), unknown keyword '%s' \n",lineNumber,tokens[0].c_str());
        exit(1);
      }

    }

  }

  //fscanf(handle_description,"%d %d",&currentTrack,&currentSector);

  /*
  // On saute grosse bidouille
  fgets(ligne,900,handle_description);
  while (fgets(ligne,900,handle_description)!=NULL)
  {
    if (detecte_chaine_renvoi_suite("#bootsector",ligne,sortie)==1)
    {
      fgets(ligne,900,handle_description); // On lit le fichier à installer dans le boot sector
      floppy.install_boot_sector(ligne);
    }
    else
    if (detecte_chaine_renvoi_suite("#new position on disk",ligne,sortie)==1)
    {
      fscanf(handle_description,"%d %d",&currentTrack,&currentSector);
      fgets(ligne,900,handle_description);
      fgets(ligne,900,handle_description);
    }
    else
    if (detecte_chaine_renvoi_suite("#load it at ",ligne,sortie)==1)
    {
      //printf("%s\n",ligne);
      if (start==1)
      {
        code_adress_low  << ",";
        code_adress_high << ",";
      }
      code_adress_high << "$" << sortie[0] << sortie[1];
      code_adress_low  << "$" << sortie[2] << sortie[3];
    }
    else
    {
      if (ligne[strlen(ligne)-1]=='\n') ligne[strlen(ligne)-1]='\0';
      if (currentSector==taille_piste+1)
      {
        currentSector=1;
        currentTrack++;
      }

      if (start==1)
      {
        code_drive << ",";
        code_sector << ",";
        code_track << ",";
        code_nombre_secteur << ",";
      }

      if (currentTrack>41) // face 2
      {
        code_track << currentTrack-42+128;
      }
      else
      {
        code_track << currentTrack;
      }
      code_sector << currentSector;

      code_drive << "0";

      int nb_sectors_by_files=floppy.writeFile(ligne,currentTrack,currentSector);
      code_nombre_secteur << nb_sectors_by_files;

      start=1;
    }
  }
  */

  std::stringstream layoutInfo;
  layoutInfo << code_drive.str() << "\n";
  layoutInfo << "nb_prgm\n";
  layoutInfo << code_sector.str() << "\n";
  layoutInfo << code_track.str() << "\n";
  layoutInfo << code_nombre_secteur.str() << "\n";
  layoutInfo << code_adress_low.str() << "\n";
  layoutInfo << code_adress_high.str() << "\n";

  if (!SaveFile("loader.cod",layoutInfo.str().c_str(),layoutInfo.str().length()))
  {
    printf("FloppyBuilder: Can't save '%s'\n","loader.cod");
    exit(1);
  }

  if (!floppy.Save(dest_name))
  {
    printf("Failed saving '%s'\n",dest_name);
    exit(1);
  }
  else
  {
    printf("Successfully created '%s'\n",dest_name);
  }
  printf("FloppyBuilder:  handle_dsk.dsk built successfully\n");
}
