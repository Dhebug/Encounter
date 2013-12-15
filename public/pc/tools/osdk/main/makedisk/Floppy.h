#ifndef FLOPPY_H_
#define FLOPPY_H_

#include <vector>
#include <map>
#include <sstream>
#include <iostream>



// This class is meant to be mapped on memory area supposed to be of MFM disk format.
// The header is 256 bytes long, so this class memory usage should be similar in size and structure.
class FloppyHeader
{
public:
  FloppyHeader();
  ~FloppyHeader();

  void Clear();

  bool IsValidHeader() const;

  void SetSignature(char signature[8]);

  void SetSideNumber(int sideNumber);
  int GetSideNumber() const;

  void SetTrackNumber(int trackNumber);
  int GetTrackNumber() const;

  void SetGeometry(int geometry);
  int GetGeometry() const;

  int FindNumberOfSectors(int& firstSectorOffset,int& sectorInterleave) const;    ///< Note: This function will expect valid data to exist past the padding because it needs to scan the data...

private:
  char          m_Signature[8];   // (MFM_DISK)
  unsigned char m_Sides[4];       // :     4 bytes (2)
  unsigned char m_Tracks[4];      // :    4 bytes (42/$2A)
  unsigned char m_Geometry[4];    // :  4 bytes (1)
  unsigned char m_Padding[236];   // : 236 bytes (000000...00000 )
};


class FileEntry
{
public:
  FileEntry();
  ~FileEntry();

public:
  int         m_FloppyNumber;     // 0 for a single floppy program
  int         m_StartSide;        // 0 or 1
  int         m_StartTrack;       // 0 to 42 (80...)
  int         m_StartSector;      // 1 to 17 (or 16 or 18...)
  int         m_SectorCount;
  int         m_FileSize;
  int         m_LoadAddress;
  std::string m_FilePath;
};


class Floppy
{
public:
  Floppy();
  ~Floppy();

  bool CreateDisk(int numberOfSides,int numberOfTracks,int numberOfSectors);
  bool LoadDisk(const char* fileName);
  bool SaveDisk(const char* fileName) const;
  bool SaveDescription(const char* fileName) const;

  bool WriteSector(const char *fileName);
  bool WriteFile(const char *fileName,int loadAddress,bool removeHeaderIfPresent);
  bool WriteTapeFile(const char *fileName);

  bool AddDefine(std::string defineName,std::string defineValue);

  unsigned int SetPosition(int track,int sector)
  {
    m_CurrentSector=sector;
    m_CurrentTrack =track;
    return GetDskImageOffset();
  }

  void MoveToNextSector()
  {
    m_CurrentSector++;

    if (m_CurrentSector==m_SectorNumber+1) // We reached the end of the track!
    {
      m_CurrentSector=1;
      m_CurrentTrack++;
      if (m_CurrentTrack==m_TrackNumber)
      {
        // Next side is following on the floppy in the DSK format, so technically we should have nothing to do
        // All the hard work is in the loader
      }
    }
  }

private:
  unsigned int GetDskImageOffset();

private:
  void*       m_Buffer;
  size_t      m_BufferSize;
  int         m_TrackNumber;          // 42
  int         m_SectorNumber;         // 17
  int         m_SideNumber;           // 2
  int         m_OffsetFirstSector;    // 156 (Location of the first byte of data of the first sector)
  int         m_InterSectorSpacing;   // 358 (Number of bytes to skip to go to the next sector: 256+59+43)

  int         m_CurrentTrack;
  int         m_CurrentSector;

  std::vector<FileEntry>                            m_FileEntries;
  std::vector<std::pair<std::string,std::string>>   m_DefineList;
};

#endif
