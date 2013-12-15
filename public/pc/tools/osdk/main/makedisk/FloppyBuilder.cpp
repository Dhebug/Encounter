
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
    "\r\n"
    "Usage:\r\n"
    "  {ApplicationName} <description file path>\r\n"
    "\r\n"
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


  if (argc!=2)
  {
    ShowError(nullptr);
  }


  //
  // Open the description file
  //
  const char* description_name(argv[param]);
  std::vector<std::string> script;
  if (!LoadText(description_name,script))
  {
    ShowError("Can't load script file '%s'\n",description_name);
  }

  //
  // Copy the floppy disk
  //
  Floppy floppy;

  std::string outputLayoutFileName;
  std::string targetFloppyDiskName;

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
      // Remove eventual superfluous spaces and tabs
      item=StringTrim(item);
      if (!item.empty())
      {
        tokens.push_back(item);
      }
    }

    if (!tokens.empty())
    {
      if (tokens[0]=="LoadDiskTemplate")
      {
        if (tokens.size()==2)
        {
          const std::string& templateFisk(tokens[1]);
          if (!floppy.LoadDisk(templateFisk.c_str()))
          {
            ShowError("Can't load '%s'\n",templateFisk.c_str());
          }

        }
        else
        {
          ShowError("Syntax error line (%d), syntax is 'LoadDiskTemplate FilePath' \n",lineNumber);
        }
      }
      else
      if (tokens[0]=="DefineDisk")
      {
        if (tokens.size()==4)
        {
          int numberOfSides   =std::atoi(tokens[1].c_str());
          int numberOfTracks  =std::atoi(tokens[2].c_str());
          int numberOfSectors =std::atoi(tokens[3].c_str());

          if ( numberOfSides!=2 )
          {
            ShowError("Syntax error line (%d), numberOfSides has to be 2 (so far)\n",lineNumber);
          }

          if ( numberOfTracks!=42 )
          {
            ShowError("Syntax error line (%d), numberOfTracks has to be 42 (so far)\n",lineNumber);
          }

          if ( numberOfSectors!=17 )
          {
            ShowError("Syntax error line (%d), numberOfSectors has to be 17 (so far)\n",lineNumber);
          }

          if (!floppy.CreateDisk(numberOfSides,numberOfTracks,numberOfSectors))
          {
            ShowError("Can't create disk\n");
          }

        }
        else
        {
          ShowError("Syntax error line (%d), syntax is 'DefineDisk numberOfSides numberOfTracks numberOfSectors' \n",lineNumber);
        }
      }
      else
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
          int currentTrack =std::atoi(tokens[1].c_str());
          if ( (currentTrack<0) || (currentTrack>41) )
          {
            ShowError("Syntax error line (%d), TrackNumber has to be between 0 and 41' \n",lineNumber);
          }
          int currentSector=std::atoi(tokens[2].c_str());
          if ( (currentSector<0) || (currentSector>41) )
          {
            ShowError("Syntax error line (%d), SectorNumber has to be between 1 and 17' \n",lineNumber);
          }
          floppy.SetPosition(currentTrack,currentSector);
        }
        else
        {
          ShowError("Syntax error line (%d), syntax is 'SetPosition TrackNumber SectorNumber' \n",lineNumber);
        }
      }
      else
      if (tokens[0]=="WriteSector")
      {
        if (tokens.size()==2)
        {
          std::string fileName=tokens[1];
          if (!floppy.WriteSector(fileName.c_str()))
          {
            ShowError("Error line (%d), could not write file '%s' to disk. Make sure you have a valid floppy format declared. \n",lineNumber,fileName.c_str());
          }
        }
        else
        {
          ShowError("Syntax error line (%d), syntax is 'WriteSector FilePath' \n",lineNumber);
        }
      }
      else
      if (tokens[0]=="AddFile")
      {
        if (tokens.size()==3)
        {
          std::string fileName=tokens[1];
          int loadAddress=ConvertAdress(tokens[2].c_str());
          if (!floppy.WriteFile(fileName.c_str(),loadAddress,false))
          {
            ShowError("Error line (%d), could not write file '%s' to disk. Make sure you have a valid floppy format declared. \n",lineNumber,fileName.c_str());
          }
        }
        else
        {
          ShowError("Syntax error line (%d), syntax is 'AddFile FilePath LoadAddress' \n",lineNumber);
        }
      }
      else
      if (tokens[0]=="AddTapFile")
      {
        if (tokens.size()==2)
        {
          std::string fileName=tokens[1];
          if (!floppy.WriteFile(fileName.c_str(),-1,true))
          {
            ShowError("Error line (%d), could not write file '%s' to disk. Make sure you have a valid floppy format declared. \n",lineNumber,fileName.c_str());
          }
        }
        else
        {
          ShowError("Syntax error line (%d), syntax is 'AddTapFile FilePath' \n",lineNumber);
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
      if (tokens[0]=="SetCompressionMode")
      {
        if (tokens.size()==2)
        {
          if (tokens[1]=="None")
          {
            floppy.SetCompressionMode(e_CompressionNone);
          }
          else
          if (tokens[1]=="FilePack")
          {
            floppy.SetCompressionMode(e_CompressionFilepack);
          }
          else
          {
            ShowError("Syntax error line (%d), '%s' is not a valid compression mode, it should be either 'None' or 'FilePack' \n",lineNumber,tokens[1].c_str());
          }
        }
        else
        {
          ShowError("Syntax error line (%d), syntax is 'SetCompressionMode [None|FilePack]' \n",lineNumber);
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
