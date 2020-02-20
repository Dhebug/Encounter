
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


class FloppyBuilder : public ArgumentParser
{
public:
  FloppyBuilder(int argc,char *argv[])
    : ArgumentParser(argc,argv)
  {
  }

  int Main();


private:
  std::string                         m_FormatVersion;
};


int main(int argc, char *argv[])
{
  try
  {
    //
    // Some initialization for the common library
    //
    SetApplicationParameters(
      "FloppyBuilder",
      TOOL_VERSION_MAJOR,
      TOOL_VERSION_MINOR,
      "{ApplicationName} - Version {ApplicationVersion} - This program is a part of the OSDK (http://www.osdk.org)\r\n"
      "\r\n"
      "Author:\r\n"
      "  (c) 2002 Debrune Jerome for the initial version \r\n"
      "  (c) 2015 Pointier Mickael for the subsequent changes \r\n"
      "\r\n"
      "Purpose:\r\n"
      "  Generating bootable floppies for the Oric computer.\r\n"
      "\r\n"
      "Usage:\r\n"
      "  {ApplicationName} [switches] <init|build|extract> <description file path>\r\n"
      "\r\n"
      "Switches:\r\n"
      " -Dname=value Add define\r\n"
      "       -DTEST=23 \r\n"
      "\r\n"
      );

    FloppyBuilder floppyBuilder(argc,argv);
    return floppyBuilder.Main();
  }

  catch (std::exception& e)
  {
    ShowError("Exception thrown: %s",e.what());
  }
}



int FloppyBuilder::Main()
{
  Floppy floppy;

  while (ProcessNextArgument())
  {
    if (IsSwitch("-D"))
    {
      // One more define
      std::string defineName=GetStringValue();
      std::string defineValue;
      std::size_t found = defineName.find("=");
      if (found!=std::string::npos)
      {
        defineValue =defineName.substr(found+1);
        defineName  =defineName.substr(0,found);
      }
      floppy.AddDefine(defineName,defineValue);
      //printf("--------------> %s=%s\r\n",defineName.c_str(),defineValue.c_str());
    }
  }

  if (GetParameterCount()!=2)
  {
    ShowError(nullptr);
  }

  bool extract=false;
  const char* sequence=GetParameter(0);
  if (!strcmp(sequence,"init"))
  {
    floppy.AllowMissingFiles(true);
  }
  else
  if (!strcmp(sequence,"extract"))
  {
    floppy.AllowMissingFiles(true);
    extract=true;
  }
  else
  if (!strcmp(sequence,"build"))
  {
    floppy.AllowMissingFiles(false);
  }
  else
  {
    ShowError("The first parameter should be either 'init', 'build' or 'extract'.");
  }


  //
  // Open the description file
  //
  const char* description_name(GetParameter(1));
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
      if (tokens[0]=="FormatVersion")
      {
        if (tokens.size()==2)
        {
          m_FormatVersion=tokens[1];
          // We found a version string, let's analyze what we can do with it.
          char* end;
          int majorVersion =std::strtoul(m_FormatVersion.c_str(),&end,10);
          if (end && end[0]=='.')
          {
            ++end;
            int minorVersion =std::strtoul(end,&end,10);
            if ( (majorVersion>TOOL_VERSION_MAJOR) || ( (majorVersion==TOOL_VERSION_MAJOR) && (minorVersion>TOOL_VERSION_MINOR) ) )
            {
              ShowError("This is FloppyBuilder %u.%u, not able to handle the requested future FormatVersion %u.%u' \n",TOOL_VERSION_MAJOR,TOOL_VERSION_MINOR,majorVersion,minorVersion);
            }
            else
            {
              // This is at least a version equal to ours.
              switch (majorVersion)
              {
              default:
              case 0:
                switch (minorVersion)
                {
                default:
                case 19:  ShowError("AddFile does not have a size parameter anymore\n");
                case 20:
                  break;
                }
                break;
              }
            }
          }
          else
          {
            ShowError("Syntax error line (%d), syntax is 'FormatVersion major.minor' \n",lineNumber);
          }
        }
        else
        {
          ShowError("Syntax error line (%d), syntax is 'FormatVersion major.minor' \n",lineNumber);
        }
      }
      else
      {
        if (m_FormatVersion.empty())
        {
          ShowError("A 'FormatVersion major.minor' instruction is required at the start of the script\n");
        }

        if (tokens[0]=="LoadDiskTemplate")
        {
          if (tokens.size()==2)
          {
            const std::string& templateDisk(tokens[1]);
            if (!floppy.LoadDisk(templateDisk.c_str()))
            {
              ShowError("Can't load '%s'\n",templateDisk.c_str());
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
          if ((tokens.size()==4) || (tokens.size()==5))
          {
            int numberOfSides   =std::atoi(tokens[1].c_str());
            int numberOfTracks  =std::atoi(tokens[2].c_str());
            int numberOfSectors =std::atoi(tokens[3].c_str());

            int sectorInterleave=1;
            if ((tokens.size()==5))
            {
              sectorInterleave =std::atoi(tokens[4].c_str());
            }

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

	    if ( sectorInterleave>=numberOfSectors )
            {
              ShowError("Syntax error line (%d), the sector interleave value makes no sense\n",lineNumber);
            }

            if (!floppy.CreateDisk(numberOfSides,numberOfTracks,numberOfSectors,sectorInterleave))
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
        if (tokens[0]=="WriteLoader")
        {
          if (tokens.size()==3)
          {
            std::string fileName=tokens[1];
            int loadAddress=ConvertAdress(tokens[2].c_str());
            if (!floppy.WriteLoader(fileName.c_str(),loadAddress))
            {
              ShowError("Error line (%d), could not write file '%s' to disk. Make sure you have a valid floppy format declared. \n",lineNumber,fileName.c_str());
            }
          }
          else
          {
            ShowError("Syntax error line (%d), syntax is 'WriteLoader FilePath LoadAddress' \n",lineNumber);
          }
        }
        else
        if (tokens[0]=="AddFile")
        {
          if (tokens.size()==2)
          {
            std::string fileName=tokens[1];
            if (!floppy.WriteFile(fileName.c_str(),false,metadata))
            {
              ShowError("Error line (%d), could not write file '%s' to disk. Make sure you have a valid floppy format declared. \n",lineNumber,fileName.c_str());
            }
          }
          else
          {
            ShowError("Syntax error line (%d), syntax is 'AddFile FilePath' \n",lineNumber);
          }
        }
        else
        if (tokens[0]=="AddTapFile")
        {
          if (tokens.size()==2)
          {
            std::string fileName=tokens[1];
            if (!floppy.WriteFile(fileName.c_str(),true,metadata))
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
        if (tokens[0]=="ReserveSectors")
        {
          if ( (tokens.size()==2) || (tokens.size()==3) )
          {
            int sectorCount=ConvertAdress(tokens[1].c_str());
            int fillValue=0;
            if (tokens.size()==3)
            {
              fillValue=ConvertAdress(tokens[2].c_str());
            }
            if (!floppy.ReserveSectors(sectorCount,fillValue,metadata))
            {
              ShowError("Error line (%d), could not reserve %u sectors on the disk. Make sure you have a valid floppy format declared. \n",lineNumber,sectorCount);
            }
          }
          else
          {
            ShowError("Syntax error line (%d), syntax is 'ReserveSectors SectorCount [FillValue]' \n",lineNumber);
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
  return 0;
}
