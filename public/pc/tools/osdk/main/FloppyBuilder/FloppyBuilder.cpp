
#include <cstdlib>
#include <stdio.h>
#include <string.h>
#include <sstream>
#include <iostream>
#include <vector>

#include "infos.h"
#include "common.h"
#include "Floppy.h"


// while (std::getline(iss,item,' '))
bool GetNextToken(std::string& returnedToken,std::string& restOfLine,int lineNumber)
{
  returnedToken.clear();

  const char* startOfLine    =restOfLine.c_str();
  const char* currentPosition=startOfLine;
  char car;

  // First skip all the white space stuff
  while ( (car=*currentPosition) &&  ( (car==' ') || (car=='\t') )  )
  {
    ++currentPosition;
  }

  // Then depending of the character we have, we need a terminator token
  if (car)
  {
    char match =0;

    if (car=='"')
    {
      match='"';
    }
    else
    if (car=='{')
    {
      match='}';
    }
    else
    if (car=='[')
    {
      match =']';
    }

    if (match)
    {
      // Push the starting character
      returnedToken.push_back(car);
      ++currentPosition;
    }

    while ( (car=*currentPosition) && ( (match && (car!=match)) || ( (!match) && ((car!=' ') && (car!='\t')) ) ) )      
    {
      returnedToken.push_back(car);
      ++currentPosition;
    }

    if (match && (car==match))
    {
      // Including the matching character
      returnedToken.push_back(car);
      ++currentPosition;
      car=*currentPosition;
    }

    if (car)
    {
      // We have reach the end of the token, just make sure there's a white space behind
      if ((car==' ') || (car=='\t'))
      {
        restOfLine=currentPosition;
      }
      else
      {
        // Parse error
        ShowError("Parse error line '%d'\n",lineNumber);
      }
    }
    else
    {
      // End of Line
      restOfLine.clear();
    }
    return true;
  }
  return false;
}

int main(int argc, char *argv[])
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
    "  {ApplicationName} <init|build|extract> <description file path>\r\n"
    "\r\n"
    );

  // makedisk filetobuild.txt default.dsk ..\build\%OSDKDISK%

  long param=1;

  if (argc>1)
  {
    for (;;)
    {
      long nb_arg=argc;
      //const char *ptr_arg=argv[param];

      if (nb_arg==argc)   break;
    }
  }


  if (argc!=3)
  {
    ShowError(nullptr);
  }

  Floppy floppy;

  bool extract=false;
  if (!strcmp(argv[param],"init"))
  {
    floppy.AllowMissingFiles(true);
  }
  else
  if (!strcmp(argv[param],"extract"))
  {
    floppy.AllowMissingFiles(true);
    extract=true;
  }
  else
  if (!strcmp(argv[param],"build"))
  {
    floppy.AllowMissingFiles(false);
  }
  else
  {
    ShowError("The first parameter should be either 'init' or 'build'.");
  }
  param++;


  //
  // Open the description file
  //
  const char* description_name(argv[param]);
  std::vector<std::string> script;
  if (!LoadText(description_name,script))
  {
    ShowError("Can't load script file '%s'\n",description_name);
  }


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

    std::map<std::string,std::string>   metadata;
    std::string item;
    std::vector<std::string> tokens;
    //while (std::getline(iss,item,' '))
    while (GetNextToken(item,currentLine,lineNumber))
    {
      // Remove eventual superfluous spaces and tabs
      item=StringTrim(item);
      if (!item.empty())
      {
        if ( ((*item.begin())=='[') && ((*item.rbegin())==']') )
        {
          // Let's say it's metadata
          std::string metaItem=StringTrim(item,"[]");
          std::size_t found = metaItem.find(":");
          if (found!=std::string::npos)
          {
            // Comments, just skip them
            std::string key  =metaItem.substr(0,found);
            std::string value=metaItem.substr(found+1);
            metadata[key]=value;
          }
          else
          {
            ShowError("Syntax error line (%d), found invalid '%s' metadata format, should be '[key:value]'\n",lineNumber,item.c_str());
          }
        }
        else
        {
          // Let's say it's an actual parameter
          item=StringTrim(item,"\"");
          tokens.push_back(item);
        }
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

		  /*
          if ( numberOfTracks!=42 )
          {
            ShowError("Syntax error line (%d), numberOfTracks has to be 42 (so far)\n",lineNumber);
          }
		  */

	  if ( numberOfSectors!=17 )
          {
            ShowError("Syntax error line (%d), numberOfSectors has to be 17 (so far)\n",lineNumber);
          }

          if (!floppy.CreateDisk(numberOfSides,numberOfTracks,numberOfSectors))
          {
            ShowError("Can't create the requested disk format\n");
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
          if (!floppy.WriteFile(fileName.c_str(),loadAddress,false,metadata))
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
          if (!floppy.WriteFile(fileName.c_str(),-1,true,metadata))
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
      if (tokens[0]=="SaveFile")
      {
        // ; SaveFile "File_0.bin"  $80 $01 $47  ; Name Track Sector Lenght adress
        if (tokens.size()==5)
        {
          std::string fileName=tokens[1];
          int trackNumber =ConvertAdress(tokens[2].c_str());
          int sectorNumber=ConvertAdress(tokens[3].c_str());
          int sectorCount =ConvertAdress(tokens[4].c_str());
          if (!floppy.ExtractFile(fileName.c_str(),trackNumber,sectorNumber,sectorCount))
          {
            ShowError("Error line (%d), could not extract file '%s' from disk. Make sure you have a valid floppy format declared and some available disk space. \n",lineNumber,fileName.c_str());
          }
        }
        else
        {
          ShowError("Syntax error line (%d), syntax is 'ExtractFile FilePath TrackNumber SectorNumber SectorCount' \n",lineNumber);
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


  if (!extract)
  {
    // We write the resulting files only in 'init' or 'build' mode
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
}
