
#include "infos.h"

#include <stdlib.h>
#include <stdio.h>
#include <sstream>
#include <iostream>
#include <string.h>

#include <assert.h>

#include "Floppy.h"

#include "common.h"




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


void FloppyHeader::Clear()
{
  memset(this,0,sizeof(FloppyHeader));
}

void FloppyHeader::SetSignature(char signature[8])
{
  memcpy(m_Signature,signature,8);
}


void FloppyHeader::SetSideNumber(int sideNumber)
{
  m_Sides[0]=(sideNumber>>0)&255;
  m_Sides[1]=(sideNumber>>8)&255;
  m_Sides[2]=(sideNumber>>16)&255;
  m_Sides[3]=(sideNumber>>24)&255;
}

int FloppyHeader::GetSideNumber() const
{
  int sideNumber= ( ( ( ( (m_Sides[3]<<8) | m_Sides[2]) << 8 ) | m_Sides[1]) << 8 ) | m_Sides[0];
  return sideNumber;
}


void FloppyHeader::SetTrackNumber(int trackNumber)
{
  m_Tracks[0]=(trackNumber>>0)&255;
  m_Tracks[1]=(trackNumber>>8)&255;
  m_Tracks[2]=(trackNumber>>16)&255;
  m_Tracks[3]=(trackNumber>>24)&255;
}

int FloppyHeader::GetTrackNumber() const
{
  int trackNumber= ( ( ( ( (m_Tracks[3]<<8) | m_Tracks[2]) << 8 ) | m_Tracks[1]) << 8 ) | m_Tracks[0];
  return trackNumber;
}

void FloppyHeader::SetGeometry(int geometry)
{
  m_Geometry[0]=(geometry>>0)&255;
  m_Geometry[1]=(geometry>>8)&255;
  m_Geometry[2]=(geometry>>16)&255;
  m_Geometry[3]=(geometry>>24)&255;
}

int FloppyHeader::GetGeometry() const
{
  int geometry= ( ( ( ( (m_Geometry[3]<<8) | m_Geometry[2]) << 8 ) | m_Geometry[1]) << 8 ) | m_Geometry[0];
  return geometry;
}

int FloppyHeader::FindNumberOfSectors(int& firstSectorOffset,int& sectorInterleave) const
{
  firstSectorOffset=0;
  sectorInterleave=0;

  /*
  Format of a track:
  6400 bytes in total
  - gap1: 72/12 bytes at the start of the track (with zeroes)
  Then for each sector:
  - ?:             4 bytes (A1 A1 A1 FE)
  - track number:  1 byte (0-40-80...)
  - side number:   1 byte (0-1)
  - sector number: 1 byte (1-18-19)
  - one:           1 byte (1)
  - crc:           2 bytes (crc of the 8 previous bytes)
  - gap2:          34 bytes (22xAE , 12x00)
  - ?:             4 bytes (A1 A1 A1 FB)
  - data:          256 bytes
  - crc:           2 bytes (crc of the 256+4 previous bytes)
  - gap3:          50/46 bytes
  */
  unsigned char* trackDataStart=(unsigned char*)(this+1);
  unsigned char* trackData   =trackDataStart;
  unsigned char* trackDataEnd=trackDataStart+6400;

  int lastSectorFound=0;
  while (trackData<(trackDataEnd-16))
  {
    if ( (trackData[0]==0xa1) && (trackData[1]==0xa1) && (trackData[2]==0xa1) && (trackData[3]==0xfe) )
    {
      // Found a marker for a synchronization sequence for a sector [#A1 #A1 #A1], [#FE Track Side Sector tt CRC CRC] 
      int sectorNumber=trackData[6];
      if (sectorNumber==(lastSectorFound+1))
      {
        lastSectorFound=sectorNumber;
      }
      else
      {
        ShowError("There's something wrong in the track structure of the floppy, the sector id does not make sense.");
      }
      trackData+=10;  // Skip synchronization sequence
      trackData+=34;  // - gap2:          34 bytes (22xAE , 12x00)
      trackData+=4;   // - ?:             4 bytes (A1 A1 A1 FB)

      if (sectorNumber==1)
      {
        firstSectorOffset=trackData-trackDataStart;
      }
      else
      if (sectorNumber==2)
      {
        sectorInterleave=trackData-trackDataStart-firstSectorOffset;
      }
      trackData+=256; // Sector data
    }
    else
    {
      trackData++;
    }
  }

  return lastSectorFound;
}



FileEntry::FileEntry() :
  m_FloppyNumber(0),
  m_StartSide(0),
  m_StartTrack(0),
  m_StartSector(1),
  m_SectorCount(0),
  m_LoadAddress(0),
  m_FinalFileSize(0),
  m_CompressionMode(e_CompressionNone),
  m_StoredFileSize(0)
{
}

FileEntry::~FileEntry()
{
}




Floppy::Floppy() :
  m_AllFilesAreResolved(true),
  m_AllowMissingFiles(false),
  m_Buffer(0),
  m_BufferSize(0),
  m_TrackNumber(0),
  m_SectorNumber(0),
  m_CurrentTrack(0),
  m_CurrentSector(1),
  m_LastFileWithMetadata(0),
  m_CompressionMode(e_CompressionNone),
  m_OffsetFirstSector(156),   // 156 (Location of the first byte of data of the first sector)
  m_InterSectorSpacing(358)   // 358 (Number of bytes to skip to go to the next sector: 256+59+43)
{
}


Floppy::~Floppy()
{
  delete m_Buffer;
}


unsigned int crctab[256] =
{
  0x0000, 0x1021, 0x2042, 0x3063, 0x4084, 0x50A5, 0x60C6, 0x70E7,
  0x8108, 0x9129, 0xA14A, 0xB16B, 0xC18C, 0xD1AD, 0xE1CE, 0xF1EF,
  0x1231, 0x0210, 0x3273, 0x2252, 0x52B5, 0x4294, 0x72F7, 0x62D6,
  0x9339, 0x8318, 0xB37B, 0xA35A, 0xD3BD, 0xC39C, 0xF3FF, 0xE3DE,
  0x2462, 0x3443, 0x0420, 0x1401, 0x64E6, 0x74C7, 0x44A4, 0x5485,
  0xA56A, 0xB54B, 0x8528, 0x9509, 0xE5EE, 0xF5CF, 0xC5AC, 0xD58D,
  0x3653, 0x2672, 0x1611, 0x0630, 0x76D7, 0x66F6, 0x5695, 0x46B4,
  0xB75B, 0xA77A, 0x9719, 0x8738, 0xF7DF, 0xE7FE, 0xD79D, 0xC7BC,
  0x48C4, 0x58E5, 0x6886, 0x78A7, 0x0840, 0x1861, 0x2802, 0x3823,
  0xC9CC, 0xD9ED, 0xE98E, 0xF9AF, 0x8948, 0x9969, 0xA90A, 0xB92B,
  0x5AF5, 0x4AD4, 0x7AB7, 0x6A96, 0x1A71, 0x0A50, 0x3A33, 0x2A12, 
  0xDBFD, 0xCBDC, 0xFBBF, 0xEB9E, 0x9B79, 0x8B58, 0xBB3B, 0xAB1A, 
  0x6CA6, 0x7C87, 0x4CE4, 0x5CC5, 0x2C22, 0x3C03, 0x0C60, 0x1C41, 
  0xEDAE, 0xFD8F, 0xCDEC, 0xDDCD, 0xAD2A, 0xBD0B, 0x8D68, 0x9D49, 
  0x7E97, 0x6EB6, 0x5ED5, 0x4EF4, 0x3E13, 0x2E32, 0x1E51, 0x0E70,
  0xFF9F, 0xEFBE, 0xDFDD, 0xCFFC, 0xBF1B, 0xAF3A, 0x9F59, 0x8F78, 
  0x9188, 0x81A9, 0xB1CA, 0xA1EB, 0xD10C, 0xC12D, 0xF14E, 0xE16F,
  0x1080, 0x00A1, 0x30C2, 0x20E3, 0x5004, 0x4025, 0x7046, 0x6067, 
  0x83B9, 0x9398, 0xA3FB, 0xB3DA, 0xC33D, 0xD31C, 0xE37F, 0xF35E,
  0x02B1, 0x1290, 0x22F3, 0x32D2, 0x4235, 0x5214, 0x6277, 0x7256,
  0xB5EA, 0xA5CB, 0x95A8, 0x8589, 0xF56E, 0xE54F, 0xD52C, 0xC50D,
  0x34E2, 0x24C3, 0x14A0, 0x0481, 0x7466, 0x6447, 0x5424, 0x4405,
  0xA7DB, 0xB7FA, 0x8799, 0x97B8, 0xE75F, 0xF77E, 0xC71D, 0xD73C,
  0x26D3, 0x36F2, 0x0691, 0x16B0, 0x6657, 0x7676, 0x4615, 0x5634,
  0xD94C, 0xC96D, 0xF90E, 0xE92F, 0x99C8, 0x89E9, 0xB98A, 0xA9AB,
  0x5844, 0x4865, 0x7806, 0x6827, 0x18C0, 0x08E1, 0x3882, 0x28A3,
  0xCB7D, 0xDB5C, 0xEB3F, 0xFB1E, 0x8BF9, 0x9BD8, 0xABBB, 0xBB9A,
  0x4A75, 0x5A54, 0x6A37, 0x7A16, 0x0AF1, 0x1AD0, 0x2AB3, 0x3A92,
  0xFD2E, 0xED0F, 0xDD6C, 0xCD4D, 0xBDAA, 0xAD8B, 0x9DE8, 0x8DC9,
  0x7C26, 0x6C07, 0x5C64, 0x4C45, 0x3CA2, 0x2C83, 0x1CE0, 0x0CC1,
  0xEF1F, 0xFF3E, 0xCF5D, 0xDF7C, 0xAF9B, 0xBFBA, 0x8FD9, 0x9FF8,
  0x6E17, 0x7E36, 0x4E55, 0x5E74, 0x2E93, 0x3EB2, 0x0ED1, 0x1EF0
};

void compute_crc(unsigned char *ptr,int count)
{
  int i;
  unsigned short crc=0xFFFF,byte;
  for (i=0;i<count;i++) {
    byte= *ptr++;
    crc=(crc<<8)^crctab[(crc>>8)^byte];
  }
  *ptr++=crc>>8;
  *ptr++=crc&0xFF;
}


bool Floppy::CreateDisk(int numberOfSides,int numberOfTracks,int numberOfSectors)
{
  // Heavily based on MakeDisk and Tap2DSk
  int gap1,gap2,gap3;

  switch (numberOfSectors) 
  {
  case 15: case 16: case 17:
    gap1=72; gap2=34; gap3=50;
    break;

  case 18:
    gap1=12; gap2=34; gap3=46;
    break;

  default:
    ShowError("Unrealistic sectors per track number\n");
  }

  m_BufferSize=256+numberOfSides*numberOfTracks*6400;
  m_Buffer=malloc(m_BufferSize);
  if (m_Buffer)
  {
    m_TrackNumber =numberOfTracks;      // 42
    m_SectorNumber=numberOfSectors;     // 17
    m_SideNumber  =numberOfSides;       // 2

    FloppyHeader& header(*((FloppyHeader*)m_Buffer));
    header.Clear();
    header.SetSignature("MFM_DISK");
    header.SetSideNumber(numberOfSides);
    header.SetTrackNumber(numberOfTracks);
    header.SetGeometry(1);

    unsigned char* trackbuf=(unsigned char*)m_Buffer+256;
    for (int s=0;s<numberOfSides;s++)
    {
      for (int t=0;t<numberOfTracks;t++) 
      {
        {
          int i;
          int offset=0;
          for (i=0;i<gap1-12;i++) 
          {
            trackbuf[offset++]=0x4E;
          }
          for (int j=0;j<numberOfSectors;j++) 
          {
            for (i=0;i<12;i++) trackbuf[offset++]=0;
            for (i=0;i<3;i++) trackbuf[offset++]=0xA1;
            trackbuf[offset++]=0xFE;
            for (i=0;i<6;i++) offset++;
            for (i=0;i<gap2-12;i++) trackbuf[offset++]=0x22;
            for (i=0;i<12;i++) trackbuf[offset++]=0;
            for (i=0;i<3;i++) trackbuf[offset++]=0xA1;
            trackbuf[offset++]=0xFB;
            for (i=0;i<258;i++) offset++;
            for (i=0;i<gap3-12;i++) trackbuf[offset++]=0x4E;
          }

          while (offset<6400) 
          {
            trackbuf[offset++]=0x4E;
          }
        }
        int offset=gap1;
        for (int i=0;i<numberOfSectors;i++)
        {
          trackbuf[offset+4]=t;
          trackbuf[offset+5]=s;
          trackbuf[offset+6]=i+1;
          trackbuf[offset+7]=1;
          compute_crc(trackbuf+offset,4+4);
          offset+=4+6;
          offset+=gap2;
          memset(trackbuf+offset+4,0,256);
          compute_crc(trackbuf+offset,4+256);
          offset+=256+6;
          offset+=gap3;
        }
        trackbuf+=6400;
      }
    }
    if (header.IsValidHeader())
    {
      m_SectorNumber=header.FindNumberOfSectors(m_OffsetFirstSector,m_InterSectorSpacing);   //17;    // Can't figure out that from the header Oo
      return true;
    }
  }

  return false;
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
      m_SectorNumber=header.FindNumberOfSectors(m_OffsetFirstSector,m_InterSectorSpacing);   //17;    // Can't figure out that from the header Oo
      return true;
    }
  }
  return false;
}


bool Floppy::SaveDisk(const char* fileName) const
{
  if (m_Buffer)
  {
    return SaveFile(fileName,m_Buffer,m_BufferSize);
  }
  return false;
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
// Header secteur
#define nb_oct_before_sector  59      // Cas de 17 secteurs/pistes !
#define nb_oct_after_sector   43      //#define nb_oct_after_sector 31

unsigned int Floppy::GetDskImageOffset()
{
  unsigned int offset=256;         // Add the DSK file header size
  offset+=m_CurrentTrack*6400;     // And move to the correct track
  offset+=m_OffsetFirstSector;     // Add the offset from the start of track to the data of the first sector
  offset+=m_InterSectorSpacing*(m_CurrentSector-1);
  return offset;
}


// 0x0319 -> 793
bool Floppy::WriteSector(const char *fileName)
{
  if (!m_Buffer)
  {
    return false;
  }

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
    MarkCurrentSectorUsed();
    printf("Boot sector '%s' installed, %d free bytes remaining in this sector.\n",filteredFileName.c_str(),256-bufferSize);

    MoveToNextSector();
  }
  else
  {
    m_AllFilesAreResolved=false;
    if (!m_AllowMissingFiles)
    {
      ShowError("Boot Sector file '%s' not found",filteredFileName.c_str());
    }
  }
  return true;
}


class TapeInfo
{
public:
  TapeInfo() 
    : m_StartAddress(0)
    , m_EndAddress(0)
    , m_FileType(0)
    , m_AutoStarts(false)
    , m_PtrData(nullptr)
    , m_DataSize(0)
  {

  }

  bool ParseHeader(void* fileBuffer,size_t fileSize)
  {
    m_DataSize=fileSize;
    m_PtrData =(unsigned char*)fileBuffer;
    while (m_DataSize && (m_PtrData[0]==0x16))
    {
      m_DataSize--;
      m_PtrData++;
    }
    if (m_DataSize>8 && (m_PtrData[0]==0x24) && (m_PtrData[1]==0x00) && (m_PtrData[2]==0x00) )
    {
      // At this point at least we have a valid synchro sequence and we know we have a usable header
      m_FileType    = m_PtrData[3];
      m_AutoStarts  =(m_PtrData[4]!=0);
      m_EndAddress  =(m_PtrData[5]<<8)|m_PtrData[6];
      m_StartAddress=(m_PtrData[7]<<8)|m_PtrData[8];

      m_DataSize-=9;
      m_PtrData+=9;

      if (m_DataSize && (m_PtrData[0]==0x00) )
      {
        // Skip the zero
        m_DataSize--;
        m_PtrData++;

        // Now we read the name
        while (m_DataSize && (m_PtrData[0]!=0x00))
        {
          m_FileName+=m_PtrData[0];
          m_DataSize--;
          m_PtrData++;
        }
        if (m_DataSize && (m_PtrData[0]==0x00) )
        {
          // Skip the zero
          m_DataSize--;
          m_PtrData++;

          // Now ptr points on the actual data
          return true;
        }
      }
    }
    // Not a valid tape file
    return false;
  }

public:
  unsigned char*  m_PtrData;
  int             m_DataSize;
  int             m_StartAddress;
  int             m_EndAddress;
  int             m_FileType;
  bool            m_AutoStarts;
  std::string     m_FileName;
};


bool Floppy::WriteFile(const char *fileName,int loadAddress,bool removeHeaderIfPresent,const std::map<std::string,std::string>& metadata)
{
  if (!m_Buffer)
  {
    return false;
  }

  void*      fileBuffer;
  size_t     fileSize;
  if (!LoadFile(fileName,fileBuffer,fileSize))
  {
    m_AllFilesAreResolved=false;
    if (!m_AllowMissingFiles)
    {
      ShowError("Error can't open file '%s'\n",fileName);
    }
    const char* message="Place holder file generated by FloppyBuilder";
    fileBuffer=strdup(message);
    fileSize  =strlen(message);
  }

  unsigned char* fileData=(unsigned char*)fileBuffer;

  if (removeHeaderIfPresent)
  {
    TapeInfo tapeInfo;
    if (!tapeInfo.ParseHeader(fileBuffer,fileSize))
    {
      ShowError("File '%s' is not a valid tape file\n",fileName);
    }
    // If the file was a valid tape header, then we use these new information
    fileData=tapeInfo.m_PtrData;
    fileSize=tapeInfo.m_DataSize;
    loadAddress=tapeInfo.m_StartAddress;
  }

  FileEntry fileEntry;
  fileEntry.m_FloppyNumber=0;     // 0 for a single floppy program

  if (m_CurrentTrack>41) // face 2
  {
    fileEntry.m_StartSide=1;
  }
  else
  {
    fileEntry.m_StartSide=0;
  }

  fileEntry.m_StartTrack =m_CurrentTrack;           // 0 to 42 (80...)
  fileEntry.m_StartSector=m_CurrentSector;          // 1 to 17 (or 16 or 18...)
  fileEntry.m_LoadAddress=loadAddress;
  fileEntry.m_StoredFileSize=fileSize;
  fileEntry.m_FinalFileSize   =fileSize;
  fileEntry.m_SectorCount=(fileSize+255)/256;
  fileEntry.m_FilePath   =fileName;
  fileEntry.m_CompressionMode=e_CompressionNone;

  if (!metadata.empty())
  {
    fileEntry.m_Metadata = metadata;
    m_LastFileWithMetadata=m_FileEntries.size();
  }

  for (auto metadataIt(metadata.begin());metadataIt!=metadata.end();++metadataIt)
  {
    m_MetadataCategories.insert(metadataIt->first);
  }

  std::vector<unsigned char> compressedBuffer;
  if (m_CompressionMode==e_CompressionFilepack)
  {
    // So the user requested FilePack compression.
    // Great, we can do that.
    compressedBuffer.resize(fileSize);
    gLZ77_XorMask=0;
    size_t compressedFileSize=LZ77_Compress(fileData,compressedBuffer.data(),fileSize);
    if (compressedFileSize<fileSize)
    {
      // We actually did manage to compress the data
      fileData=compressedBuffer.data();
      fileSize=compressedFileSize;

      fileEntry.m_CompressionMode=e_CompressionFilepack;
      fileEntry.m_StoredFileSize=compressedFileSize;
      fileEntry.m_SectorCount=(fileSize+255)/256;
    }
  }

  //
  // Finally write the data to the disk structure
  //
  while (fileSize)
  {
    unsigned int offset=SetPosition(m_CurrentTrack,m_CurrentSector);

    int sizeToWrite=256;
    if (fileSize<256)
    {
      sizeToWrite=fileSize;
    }
    fileSize-=sizeToWrite;

    MarkCurrentSectorUsed();
    memset((char*)m_Buffer+offset,0,256);
    memcpy((char*)m_Buffer+offset,fileData,sizeToWrite);
    fileData+=sizeToWrite;

    if (!MoveToNextSector())
    {
      ShowError("Floppy disk is full, not enough space to store '%s'.\n",fileName);
    }
  }
  free(fileBuffer);

  m_FileEntries.push_back(fileEntry);

  return true;
}

void Floppy::MarkCurrentSectorUsed()
{
  int magicValue=(m_SectorNumber*m_CurrentTrack)+m_CurrentSector;
  if (m_SectorUsageMap.find(magicValue)!=m_SectorUsageMap.end())
  {
    ShowError("Sector %d was already allocated",magicValue);
  }
  m_SectorUsageMap.insert(magicValue);
}

bool Floppy::SaveDescription(const char* fileName) const
{
  std::stringstream layoutInfo;
  layoutInfo << "//\n";
  layoutInfo << "// Floppy layout generated by FloppyBuilder " << TOOL_VERSION_MAJOR << "." << TOOL_VERSION_MINOR << "\n";
  if (!m_AllFilesAreResolved)
  {
    layoutInfo << "// (The generated floppy is missing some files, a new build pass is required)\n";
  }
  layoutInfo << "//\n";
  layoutInfo << "\n";
  
  layoutInfo << "#ifdef ASSEMBLER\n";
  layoutInfo << "//\n";
  layoutInfo << "// Information for the Assembler\n";
  layoutInfo << "//\n";
  layoutInfo << "#ifdef LOADER\n";

  std::stringstream code_sector;
  std::stringstream code_track;
  std::stringstream code_compressed;
  std::stringstream code_size_low;
  std::stringstream code_size_high;
  std::stringstream code_stored_size_low;
  std::stringstream code_stored_size_high;
  std::stringstream code_adress_low;
  std::stringstream code_adress_high;

  std::map<std::string,std::stringstream>     metadata_content;

  std::set<std::string>                       metadata_entries;

  {
    for (auto metadataIt(m_MetadataCategories.begin());metadataIt!=m_MetadataCategories.end();metadataIt++)
    {
      const std::string& metadataCategoryName(*metadataIt);
      metadata_content[metadataCategoryName+"_Low"] << "_MetaData_" << metadataCategoryName << "_Low .byt ";
      metadata_content[metadataCategoryName+"_High"] << "_MetaData_" << metadataCategoryName << "_High .byt ";
    }
  }


  std::stringstream file_list_summary;

  int counter=0;
  for (auto it(m_FileEntries.begin());it!=m_FileEntries.end();++it)
  {
    const FileEntry& fileEntry(*it);

    if (it!=m_FileEntries.begin())
    {
      code_adress_low  << ",";
      code_adress_high << ",";

      code_stored_size_low << ",";
      code_stored_size_high << ",";

      code_size_low << ",";
      code_size_high << ",";

      code_sector << ",";
      code_track << ",";

      code_compressed << ",";

      if (counter<=m_LastFileWithMetadata)
      {
        for (auto metadataIt(metadata_content.begin());metadataIt!=metadata_content.end();metadataIt++)
        {
          metadataIt->second << ",";
        }
      }
    }
    code_adress_low  << "<" << fileEntry.m_LoadAddress;
    code_adress_high << ">" << fileEntry.m_LoadAddress;

    code_size_low << "<" << fileEntry.m_FinalFileSize;
    code_size_high << ">" << fileEntry.m_FinalFileSize;

    code_stored_size_low << "<" << fileEntry.m_StoredFileSize;
    code_stored_size_high << ">" << fileEntry.m_StoredFileSize;

    code_sector << fileEntry.m_StartSector;

    file_list_summary << "// Entry #" << counter << " '"<< fileEntry.m_FilePath << "'\n";
    file_list_summary << "// - Loads at address " << fileEntry.m_LoadAddress;
    if (fileEntry.m_StartTrack<m_TrackNumber)
    {
      // First side
      file_list_summary << " starts on track " << fileEntry.m_StartTrack;
      code_track << fileEntry.m_StartTrack;
    }
    else
    {
      // Second side
      file_list_summary << " starts on the second side on track " << (fileEntry.m_StartTrack-m_TrackNumber);
      code_track << fileEntry.m_StartTrack-m_TrackNumber+128;
    }
    file_list_summary << " sector " << fileEntry.m_StartSector << " and is " << fileEntry.m_SectorCount << " sectors long ";

    if (fileEntry.m_CompressionMode==e_CompressionNone)
    {
      // Uncompressed file
      file_list_summary << "(" << fileEntry.m_FinalFileSize << " bytes).\n";
    }
    else
    {
      // Compressed file
      file_list_summary << "(" << fileEntry.m_StoredFileSize << " compressed bytes: " << (fileEntry.m_StoredFileSize*100)/fileEntry.m_FinalFileSize << "% of " << fileEntry.m_FinalFileSize << " bytes).\n";
    }

    if (counter<=m_LastFileWithMetadata)
    {
      if (!fileEntry.m_Metadata.empty())
      {
        file_list_summary << "// - Associated metadata: ";
      }
      for (auto metadataIt(m_MetadataCategories.begin());metadataIt!=m_MetadataCategories.end();metadataIt++)
      {
        const std::string& metadataCategoryName(*metadataIt);

        std::string metadataLabelEntry;
        std::string metadataEntry;

        auto fileMetadataIt=fileEntry.m_Metadata.find(metadataCategoryName);
        if (fileMetadataIt==fileEntry.m_Metadata.end())
        {
          // No entries for that one
          metadataLabelEntry="metadata_none";
          metadataEntry=metadataLabelEntry+" .byt \"\",0";
        }
        else
        {
          const std::string& key(fileMetadataIt->first);
          const std::string& value(fileMetadataIt->second);
          file_list_summary << key << "='" << value << "' ";

          std::string labelValue(StringMakeLabel(value));
          metadataLabelEntry="metadata_"+key+"_"+labelValue;
          metadataEntry=metadataLabelEntry+" .byt \""+value+"\",0";
        }
        metadata_entries.insert(metadataEntry);
        metadata_content[metadataCategoryName+"_Low"] << "<" << metadataLabelEntry;
        metadata_content[metadataCategoryName+"_High"] << ">" << metadataLabelEntry;
      }
      if (!fileEntry.m_Metadata.empty())
      {
        file_list_summary << "\n";
      }
    }

	/*
    if (!fileEntry.m_Metadata.empty())
    {
      for (auto metaIt(fileEntry.m_Metadata.begin());metaIt!=fileEntry.m_Metadata.end();++metaIt)
      {
      }
    }
	file_list_summary << "\n";
	*/

    ++counter;
  }


  layoutInfo << "FileStartSector .byt ";
  layoutInfo << code_sector.str() << "\n";

  layoutInfo << "FileStartTrack .byt ";
  layoutInfo << code_track.str() << "\n";

  layoutInfo << "FileStoredSizeLow .byt ";
  layoutInfo << code_stored_size_low.str() << "\n";

  layoutInfo << "FileStoredSizeHigh .byt ";
  layoutInfo << code_stored_size_high.str() << "\n";

  layoutInfo << "FileSizeLow .byt ";
  layoutInfo << code_size_low.str() << "\n";

  layoutInfo << "FileSizeHigh .byt ";
  layoutInfo << code_size_high.str() << "\n";

  layoutInfo << "FileLoadAdressLow .byt ";
  layoutInfo << code_adress_low.str() << "\n";

  layoutInfo << "FileLoadAdressHigh .byt ";
  layoutInfo << code_adress_high.str() << "\n";
  

  layoutInfo << "#endif // LOADER\n";

  layoutInfo << "#else\n";
  layoutInfo << "//\n";
  layoutInfo << "// Information for the Compiler\n";
  layoutInfo << "//\n";
  layoutInfo << "#endif\n";

  layoutInfo << "\n";
  layoutInfo << "//\n";
  layoutInfo << "// Summary for this floppy building session:\n";
  layoutInfo << "//\n";
  layoutInfo << "#define FLOPPY_SIDE_NUMBER " << m_SideNumber << "    // Number of sides\n";
  layoutInfo << "#define FLOPPY_TRACK_NUMBER " << m_TrackNumber << "    // Number of tracks\n";
  layoutInfo << "#define FLOPPY_SECTOR_PER_TRACK " << m_SectorNumber <<  "   // Number of sectors per track\n";

  layoutInfo << "\n";
  layoutInfo << "//\n";
  layoutInfo << "// List of files written to the floppy\n";
  layoutInfo << "//\n";
  layoutInfo << file_list_summary.str();
  layoutInfo << "//\n";

  int totalAvailableSpace=m_TrackNumber*m_SectorNumber*m_SideNumber;
  layoutInfo << "// " << m_SectorUsageMap.size() << " sectors used, out of " << totalAvailableSpace << ". (" << (m_SectorUsageMap.size()*100)/totalAvailableSpace << "% of the total available size used)\n";
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

  layoutInfo << "\n";
  layoutInfo << "//\n";
  layoutInfo << "// Metadata\n";
  layoutInfo << "//\n";
  layoutInfo << "#ifdef METADATA_STORAGE\n";

  {
    for (auto metadataIt(metadata_entries.begin());metadataIt!=metadata_entries.end();metadataIt++)
    {
      layoutInfo << *metadataIt << "\n";
    }
  }
  layoutInfo << "\n";

  {
    for (auto metadataIt(metadata_content.begin());metadataIt!=metadata_content.end();metadataIt++)
    {
      layoutInfo << metadataIt->second.str() << "\n";
    }
  }
  layoutInfo << "#endif // METADATA_STORAGE\n";
  layoutInfo << "\n";

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