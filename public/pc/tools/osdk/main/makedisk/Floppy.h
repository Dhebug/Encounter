#ifndef FLOPPY_H_
#define FLOPPY_H_

#include <vector>

// File structure:
// MFM_DISK

#define header_dsk 256+156

// Nombre de secteur pour une piste
#define taille_piste			17
#define taille_secteur			256
// Header secteur
#define nb_oct_before_sector  59 // Cas de 17 secteurs/pistes !
#define nb_oct_after_sector   43      //#define nb_oct_after_sector 31


// This class is meant to be mapped on memory area supposed to be of MFM disk format.
// The header is 256 bytes long, so this class memory usage should be similar in size and structure.
class FloppyHeader
{
public:
  FloppyHeader();
  ~FloppyHeader();

  bool IsValidHeader() const;

  int GetSideNumber() const;
  int GetTrackNumber() const;


private:
  char          m_Signature[8];       // (MFM_DISK)
  unsigned char m_Sides[4];     // :     4 bytes (2)
  unsigned char m_Tracks[4];    // :    4 bytes (42/$2A)
  unsigned char m_Geometry[4];  // :  4 bytes (1)
  unsigned char m_Padding[236]; // : 236 bytes (000000...00000 )
};


class Floppy
{
public:
  Floppy();
  ~Floppy();

  bool Load(const char* fileName);
  bool Save(const char* fileName) const;

  unsigned int formule_disk(int track,int sector);

  void writeSector(int track,int sector,const char *fileName);

  int writeFile(const char *fileName,int& track,int& sector);   // Returns the number of sectors

  void SetOffset(int track,int sector)
  {
    m_Offset=formule_disk(track,sector);
  }

  void SetOffset(size_t offset)
  {
    m_Offset=offset;
  }

private:
  void*       m_Buffer;
  size_t      m_BufferSize;
  size_t      m_Offset;
  int         m_TrackNumber;      // 42
  int         m_SectorNumber;     // 17
  int         m_SideNumber;       // 2
};

#endif
