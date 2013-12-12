
#include "infos.h"

#include <stdlib.h>
#include <stdio.h>
#include <sstream>
#include <iostream>
#include <string.h>

#include <assert.h>

#include "Floppy.h"

#include "common.h"



// BORN.DSK=537856 bytes
// 17*358=6086
// *2=12172
// *44=537856

// Boot sector at offset 793 (Confirmed)
// Loader at offset 0x734 (1844) - Confirmed

// 793-256-156=381
// 381-256=125

// offset=256+156; // on ajoute le header
// offset+=track*6400; // On avance à la bonne piste
// offset+=(taille_secteur+nb_oct_after_sector+nb_oct_before_sector)*(sector-1);
//
// So: Offset = 256+156 + (track*6400) + (taille_secteur+nb_oct_after_sector+nb_oct_before_sector)*(sector-1)
//            = 256+156 + (track*6400) + (256+43+59)*(sector-1)
//            = 412     + (track*6400) + (358)*(sector-1)


FloppyHeader::FloppyHeader()
{
  assert(sizeof(*this)==256);
  memset(this,0,sizeof(*this));
}

FloppyHeader::~FloppyHeader()
{
}

bool FloppyHeader::IsValidHeader() const
{
  if (memcmp(m_Signature,"MFM_DISK",8)!=0)    return false;

  int sideNumber=GetSideNumber();
  if ((sideNumber<1) || (sideNumber>2))       return false;

  int trackNumber=GetTrackNumber();
  if ((trackNumber<30) || (trackNumber>82))   return false;

  return true;
}

int FloppyHeader::GetSideNumber() const
{
  int sideNumber= ( ( ( ( (m_Sides[3]<<8) | m_Sides[2]) << 8 ) | m_Sides[1]) << 8 ) | m_Sides[0];
  return sideNumber;
}

int FloppyHeader::GetTrackNumber() const
{
  int trackNumber= ( ( ( ( (m_Tracks[3]<<8) | m_Tracks[2]) << 8 ) | m_Tracks[1]) << 8 ) | m_Tracks[0];
  return trackNumber;
}




FileEntry::FileEntry() :
  m_FloppyNumber(0),
  m_StartSide(0),
  m_StartTrack(0),
  m_StartSector(1),
  m_SectorCount(0),
  m_LoadAddress(0),
  m_TotalSize(0)
{
}

FileEntry::~FileEntry()
{
}




Floppy::Floppy() :
  m_Buffer(0),
  m_BufferSize(0),
  m_TrackNumber(0),
  m_SectorNumber(0),
  m_CurrentTrack(0),
  m_CurrentSector(1)
{
}


Floppy::~Floppy()
{
  delete m_Buffer;
}


bool Floppy::LoadDisk(const char* fileName)
{
  if (LoadFile(fileName,m_Buffer,m_BufferSize))
  {
    const FloppyHeader& header(*((FloppyHeader*)m_Buffer));
    if (header.IsValidHeader())
    {
      m_TrackNumber =header.GetTrackNumber();
      m_SideNumber  =header.GetSideNumber();
      m_SectorNumber=17;    // Can't figure out that from the header Oo
      return true;
    }
  }
  return false;
}


bool Floppy::SaveDisk(const char* fileName) const
{
  assert(m_Buffer);
  return SaveFile(fileName,m_Buffer,m_BufferSize);
}

/*
Début de la piste (facultatif): 80 [#4E], 12 [#00], [#C2 #C2 #C2 #FC] et 50 [#4E] (soit 146 octets selon
la norme IBM) ou 40 [#4E], 12 [#00], [#C2 #C2 #C2 #FC] et 40 [#4E] (soit 96 octets pour SEDORIC).

Pour chaque secteur: 12 [#00], 3 [#A1] [#FE #pp #ff #ss #tt CRC], 22 [#4E], 12 [#00], 3 [#A1], [#FB],
les 512 octets, [CRC CRC], 80 octets [#4E] (#tt = #02) (soit 141 + 512 = 653 octets selon la norme IBM)
ou 12 [#00], 3 [#A1] [#FE #pp #ff #ss #01 CRC CRC], 22 [#4E], 12 [#00], 3 [#A1], [#FB], les 256
octets, [CRC CRC], 12, 30 ou 40 octets [#4E] (selon le nombre de secteurs/piste). Soit environ 256 + (72
à 100) = 328 à 356 octets pour SEDORIC.

Fin de la piste (facultatif): un nombre variable d'octets [#4E

Selon NIBBLE, 
une piste IBM compte 146 octets de début de piste + 9 secteurs de 653 octets + 257 octets de fin de piste = 6280 octets. 
Une piste SEDORIC, formatée à 17 secteurs, compte 96 octets de début de piste + 17 secteurs de 358 octets + 98 octets de fin de piste = 6280 octets. 
Une piste SEDORIC, formatée à 19 secteurs, compte 0 octet de début de piste + 19 secteurs de 328 octets + 48 octets de fin de piste = 6280 octets. 
On comprend mieux le manque de fiabilité du formatage en 19 secteurs/piste dû à la faible largeur des zones de sécurité (12 [#4E] entre chaque secteur et 48 octets entre le dernier et le premier).

Lors de l'élaboration du tampon de formatage SEDORIC, les octets #C2 sont remplacés par des octets
#F6, les octets #A1 sont remplacés par des octets #F5 et chaque paire de 2 octets [CRC CRC] et
remplacée par un octet #F7. Comme on le voit, nombre de variantes sont utilisées, sauf la zone 22 [#4E],
12 [#00], 3 [#A1] qui est strictement obligatoire.

// From DskTool:
15, 16 or 17 sectors: gap1=72; gap2=34; gap3=50;
          18 sectors: gap1=12; gap2=34; gap3=46;
*/
unsigned int Floppy::GetDskImageOffset()
{
  unsigned int offset=256+156;     // Add the header
  offset+=m_CurrentTrack*6400;     // And move to the correct track
  offset+=(taille_secteur+nb_oct_after_sector+nb_oct_before_sector)*(m_CurrentSector-1);
  return offset;
}


// 0x0319 -> 793
void Floppy::WriteSector(const char *fileName)
{
  std::string filteredFileName(StringTrim(fileName," \t\f\v\n\r"));

  void*      buffer;
  size_t     bufferSize;

  if (LoadFile(filteredFileName.c_str(),buffer,bufferSize))
  {
    if (bufferSize>256)
    {
      ShowError("File for sector is too large. %d bytes (%d too many)",bufferSize,bufferSize-256);
    }

    unsigned int sectorOffset=GetDskImageOffset();
    if (m_BufferSize>sectorOffset+256)
    {
      memcpy((char*)m_Buffer+sectorOffset,buffer,bufferSize);
    }
    printf("Boot sector '%s' installed, %d free bytes remaining in this sector.\n",filteredFileName.c_str(),256-bufferSize);

    MoveToNextSector();
  }
  else
  {
    ShowError("Boot Sector file '%s' not found",filteredFileName.c_str());
  }
}

int Floppy::WriteFile(const char *fileName,int loadAddress)
{
  FileEntry fileEntry;
  fileEntry.m_FloppyNumber=0;     // 0 for a single floppy program

  if (!m_FileEntries.empty())
  {
    code_adress_low  << ",";
    code_adress_high << ",";

    code_sector << ",";
    code_track << ",";
    code_nombre_secteur << ",";
  }
  code_adress_low  << "<" << loadAddress;
  code_adress_high << ">" << loadAddress;

  if (m_CurrentTrack>41) // face 2
  {
    fileEntry.m_StartSide=1;
    code_track << m_CurrentTrack-42+128;
  }
  else
  {
    fileEntry.m_StartSide=0;
    code_track << m_CurrentTrack;
  }
  code_sector << m_CurrentSector;

  void*      fileBuffer;
  size_t     fileSize;
  if (!LoadFile(fileName,fileBuffer,fileSize))
  {
    ShowError("Error can't open file '%s'\n",fileName);
  }

  int nb_sectors_by_files=(fileSize+255)/256;

  fileEntry.m_StartTrack =m_CurrentTrack;           // 0 to 42 (80...)
  fileEntry.m_StartSector=m_CurrentSector;          // 1 to 17 (or 16 or 18...)
  fileEntry.m_SectorCount=nb_sectors_by_files;      // Should probably be the real length
  fileEntry.m_LoadAddress=loadAddress;
  fileEntry.m_TotalSize=fileSize;
  fileEntry.m_FilePath   =fileName;

  unsigned char* fileData=(unsigned char*)fileBuffer;
  while (fileSize)
  {
    unsigned int offset=SetPosition(m_CurrentTrack,m_CurrentSector);

    int sizeToWrite=256;
    if (fileSize<256)
    {
      sizeToWrite=fileSize;
    }
    fileSize-=sizeToWrite;

    memset((char*)m_Buffer+offset,0,256);
    memcpy((char*)m_Buffer+offset,fileData,sizeToWrite);
    fileData+=sizeToWrite;

    MoveToNextSector();
  }
  free(fileBuffer);

  code_nombre_secteur << nb_sectors_by_files;

  m_FileEntries.push_back(fileEntry);

  return nb_sectors_by_files;
}


bool Floppy::SaveDescription(const char* fileName) const
{
  std::stringstream layoutInfo;
  layoutInfo << "//\n";
  layoutInfo << "// Floppy layout generated by FloppyBuilder " << TOOL_VERSION_MAJOR << "." << TOOL_VERSION_MINOR << "\n";
  layoutInfo << "//\n";
  layoutInfo << "\n";

  layoutInfo << "#ifdef ASSEMBLER\n";
  layoutInfo << "//\n";
  layoutInfo << "// Information for the Assembler\n";
  layoutInfo << "//\n";

  layoutInfo << "FileStartSector .byt ";
  layoutInfo << code_sector.str() << "\n";

  layoutInfo << "FileStartTrack .byt ";
  layoutInfo << code_track.str() << "\n";

  layoutInfo << "FileSectorCount .byt ";
  layoutInfo << code_nombre_secteur.str() << "\n";

  layoutInfo << "FileLoadAdressLow .byt ";
  layoutInfo << code_adress_low.str() << "\n";

  layoutInfo << "FileLoadAdressHigh .byt ";
  layoutInfo << code_adress_high.str() << "\n";

  layoutInfo << "#else\n";
  layoutInfo << "//\n";
  layoutInfo << "// Information for the Compiler\n";
  layoutInfo << "//\n";
  layoutInfo << "#endif\n";

  layoutInfo << "\n";
  layoutInfo << "//\n";
  layoutInfo << "// Summary for this floppy building session:\n";
  layoutInfo << "#define FLOPPY_TRACK_NUMBER " << m_TrackNumber << "    // Number of tracks\n";
  layoutInfo << "#define FLOPPY_SECTOR_PER_TRACK " << m_SectorNumber <<  "   // Number of sectors per track\n";
  layoutInfo << "//\n";

  layoutInfo << "// List of files written to the floppy\n";
  int counter=0;
  for (auto it(m_FileEntries.begin());it!=m_FileEntries.end();++it)
  {
    layoutInfo << "// - Entry #" << counter << " '"<< it->m_FilePath << " ' loads at address " << it->m_LoadAddress << " starts on track " << it->m_StartTrack<< " sector "<< it->m_StartSector <<" and is " << it->m_SectorCount << " sectors long (" << it->m_TotalSize << " bytes).\n";
    ++counter;
  }
  layoutInfo << "//\n";

  if (m_DefineList.empty())
  {
    layoutInfo << "// No defines set\n";
  }
  else
  {
    for (auto it(m_DefineList.begin());it!=m_DefineList.end();++it)
    {
      layoutInfo << "#define " << it->first << " " << it->second << "\n";
      ++counter;
    }
  }

  if (!SaveFile(fileName,layoutInfo.str().c_str(),layoutInfo.str().length()))
  {
    ShowError("Can't save '%s'\n",fileName);
  }

  return true;
}


bool Floppy::AddDefine(std::string defineName,std::string defineValue)
{
  // Ugly token replacement, can do more optimal but as long as it works...
  {
    std::stringstream tempValue;
    tempValue << m_FileEntries.size();
    StringReplace(defineName ,"{FileIndex}",tempValue.str());
    StringReplace(defineValue,"{FileIndex}",tempValue.str());
  }

  m_DefineList.push_back(std::pair<std::string,std::string>(defineName,defineValue));
  return true;
}