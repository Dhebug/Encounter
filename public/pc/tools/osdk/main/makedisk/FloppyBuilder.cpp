
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
    "FloppyBuilder",
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


  if (argc!=3)
  {
    ShowError(nullptr);
  }


  //
  // Copy last parameters
  //
  char	description_name[_MAX_PATH];

  strcpy(description_name,argv[param]);

  char source_name[_MAX_PATH];
  param++;
  strcpy(source_name,argv[param]);

  int start=0;

  //std::string templateFloppyDiskName;
  std::string targetFloppyDiskName;

  //
  // Open the description file
  //
  std::vector<std::string> script;
  if (!LoadText(description_name,script))
  {
    ShowError("Can't load script file '%s'\n",description_name);
  }

  //
  // Copy the floppy disk
  //
  Floppy floppy;
  if (!floppy.LoadDisk(source_name))
  {
    ShowError("FloppyBuilder: Can't load '%s'\n",source_name);
  }

  std::string outputLayoutFileName;

  // 
  // Set some semi sane 
  //
  int currentTrack =1;
  int currentSector=1;
  floppy.SetOffset(currentTrack,currentSector);

  int lineNumber=0;
  for (auto it(script.begin());it!=script.end();++it)
  {
    ++lineNumber;

    std::string currentLine(*it);

    std::size_t found = currentLine.find(";");
    if (found!=std::string::npos)
    {
      // Comments, just skip them
      currentLine=currentLine.substr(0,found);
    }

    std::istringstream iss(currentLine);

    std::string item;
    std::vector<std::string> tokens;
    while (std::getline(iss,item,' ')) 
    {
      if (!item.empty())
      {
        tokens.push_back(item);
      }
    }

    if (!tokens.empty())
    {
      if (tokens[0]=="OutputLayoutFile")
      {
        if (tokens.size()==2)
        {
          outputLayoutFileName=tokens[1];
        }
        else
        {
          ShowError("Syntax error line (%d), syntax is 'OutputLayoutFile FilePath' \n",lineNumber);
        }
      }
      else
      if (tokens[0]=="OutputFloppyFile")
      {
        if (tokens.size()==2)
        {
          targetFloppyDiskName=tokens[1];
        }
        else
        {
          ShowError("Syntax error line (%d), syntax is 'targetFloppyDiskName FilePath' \n",lineNumber);
        }
      }
      else
      if (tokens[0]=="SetPosition")
      {
        if (tokens.size()==3)
        {
          currentTrack =std::atoi(tokens[1].c_str());
          if ( (currentTrack<0) || (currentTrack>41) )
          {
            ShowError("Syntax error line (%d), TrackNumber has to be between 0 and 41' \n",lineNumber);
          }
          currentSector=std::atoi(tokens[2].c_str());
          if ( (currentSector<0) || (currentSector>41) )
          {
            ShowError("Syntax error line (%d), SectorNumber has to be between 1 and 17' \n",lineNumber);
          }
          floppy.SetOffset(currentTrack,currentSector);
        }
        else
        {
          ShowError("Syntax error line (%d), syntax is 'SetPosition TrackNumber SectorNumber' \n",lineNumber);
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
            floppy.WriteSector(0,2,fileName.c_str());
          }
          else
          if (tokens[1]=="Jasmin")
          {
            floppy.WriteSector(0,1,fileName.c_str());
          }
          else
          {
            ShowError("Syntax error line (%d), syntax is 'SetBootSector Jasmin|Microdisc FilePath'. '%s' is not a valid type \n",lineNumber,tokens[1].c_str());
          }
        }
        else
        {
          ShowError("Syntax error line (%d), syntax is 'SetBootSector Jasmin|Microdisc FilePath' \n",lineNumber);
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

          int nb_sectors_by_files=floppy.WriteFile(fileName.c_str(),currentTrack,currentSector,loadAddress);
        }
        else
        {
          ShowError("Syntax error line (%d), syntax is 'AddFile FilePath LoadAddress' \n",lineNumber);
        }
      }
      else
      if (tokens[0]=="AddDefine")
      {
        if (tokens.size()==3)
        {
          floppy.AddDefine(tokens[1],tokens[2]);
        }
        else
        {
          ShowError("Syntax error line (%d), syntax is 'AddDefine DefineName DefineValue' \n",lineNumber);
        }
      }
      else
      {
        ShowError("Syntax error line (%d), unknown keyword '%s' \n",lineNumber,tokens[0].c_str());
      }
    }
  }



  if (!floppy.SaveDescription(outputLayoutFileName.c_str()))
  {
    ShowError("Failed saving description '%s'\n",outputLayoutFileName.c_str());
  }

  if (!floppy.SaveDisk(targetFloppyDiskName.c_str()))
  {
    ShowError("Failed saving disk '%s'\n",targetFloppyDiskName.c_str());
  }
  else
  {
    printf("Successfully created '%s'\n",targetFloppyDiskName.c_str());
  }
}
