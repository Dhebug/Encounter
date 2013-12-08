
#include "assert.h"
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





Floppy::Floppy() :
  m_Buffer(0),
  m_BufferSize(0),
  m_Offset(0),
  m_TrackNumber(0),
  m_SectorNumber(0)
{
}


Floppy::~Floppy()
{
  delete m_Buffer;
}


bool Floppy::Load(const char* fileName)
{
  m_Offset=0;
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


bool Floppy::Save(const char* fileName) const
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
unsigned int Floppy::formule_disk(int track,int sector)
{
  unsigned int offset=256+156;     // on ajoute le header
  offset+=track*6400;     // On avance à la bonne piste
  offset+=(taille_secteur+nb_oct_after_sector+nb_oct_before_sector)*(sector-1);
  return offset;
}


// 0x0319 -> 793
void Floppy::writeSector(int track,int sector,const char *fileName)
{
  std::string filteredFileName(StringTrim(fileName," \t\f\v\n\r"));

  void*      buffer;
  size_t     bufferSize;

  if (LoadFile(filteredFileName.c_str(),buffer,bufferSize))
  {
    if (bufferSize>256)
    {
      printf("File for sector is too large. %d bytes (%d too many)",bufferSize,bufferSize-256);
      exit(1);
    }

    unsigned int bootSectorOffset=formule_disk(track,sector);
    if (m_BufferSize>bootSectorOffset+256)
    {
      memcpy((char*)m_Buffer+bootSectorOffset,buffer,bufferSize);
    }
    printf("Boot sector '%s' installed, %d free bytes remaining\n",filteredFileName.c_str(),256-bufferSize);
  }
  else
  {
    printf("%s",filteredFileName.c_str());
    ShowError("Boot Sector file not found");
  }
}

int Floppy::writeFile(const char *fileName,int& ptr_track,int& ptr_sector)
{
  // ICI on construit la handle_dsk avec le pgrm c ici que le bug se trouve
  void*      fileBuffer;
  size_t     fileSize;
  if (!LoadFile(fileName,fileBuffer,fileSize))
  {
    printf("FloppyBuilder: Error can't open %s\n",fileName);
    exit(1);
  }

  int nb_sectors_by_files=(fileSize+255)/256;

  unsigned char* fileData=(unsigned char*)fileBuffer;
  while (fileSize)
  {
    SetOffset(ptr_track,ptr_sector);

    int sizeToWrite=256;
    if (fileSize<256)
    {
      sizeToWrite=fileSize;
    }
    fileSize-=sizeToWrite;

    memset((char*)m_Buffer+m_Offset,0,256);
    memcpy((char*)m_Buffer+m_Offset,fileData,sizeToWrite);
    fileData+=sizeToWrite;

    ptr_sector++;

    if (ptr_sector==taille_piste+1) // We reached the end of the track!
    {
      ptr_sector=1;
      ptr_track++;
    }
  }
  free(fileBuffer);

  return nb_sectors_by_files;
}

/*

Technical infos about Oric discs and FDC:

The FDC controller can cope with 128, 256, 512 and 1024-bytes sectors. Then it's a matter of programming...
The sector read/write routines of OricDos/Sedoric/Stratsed already are 512-bytes-sector compatible...
Loading a single 512-bytes sector is faster than loading two 256-bytes sectors, and you can safely store nine 512-bytes sectors on a double density disk track, whilst storing eighteen 256-bytes sectors with Stratsed has always brought problems...

Things to check: Fantasmagoric boot sector

Both the microdisc controller and the jasmin controller have electronics to control the MAP and ROMDIS signals on the expansion port. This allows them to switch between the BASIC rom, the overlay ram, and an eprom that reads the OS from the floppy disk. 
As you said, a difference between the microdisc and the jasmin is that at startup, the jasmin electronics lets the Basic rom active. When you press the button, it causes a reset of the CPU (this doesn't reset the ram contents!), and simultaneously the jasmin eprom is made active, and so the eprom reads the boot sector (first sector, track 0), and executes this boot sector. 

Of course, the disc structure is different from the Sedoric one, and even from the OricDos one, but Jasmin and Microdisc discs have the same sector size (256 bytes) and thus can be read on both, sector by sector.


So, I guess it is possible to do a Jasmin and Microdisc compatible disc ?
What about this structure:
- Track 0/sector 1: a Jasmin bootsector
- Track 0/sector 2: a Microdisc bootsector (BOOTUP.COM)
- Track 0/sector 3: a fake Oric dos directory to run BOOTUP.COM

The most annoying thing is to respect the OricDos format imposed by the microdisc eprom (the eprom indeed contains a truncated version of OricDos 0.6). 
OricDos format has obliged the other operating systems to fake a mini-OricDos filesystem at the beginning of the disk. Normally you need at least 3 sectors, but by tweaking a little, you can have all three sectors in a single one, this is what I do in the Fantasmagoric boot sector...



a) Une piste SEDORIC est formée de 16, 17, 18 ou 19 secteurs de 256 octets. Entre ces secteurs de data
proprement dits, se trouvent des "gaps" qui contiennent des informations utiles pour le contrôleur de
lecteur.

b) Le début d'une piste (facultatif) commence par une série de 80 [#4E], 12 [#00], [#C2 #C2 #C2 #FC],
puis par une série de 50 [#4E] (selon la norme IBM) ou 40 [#4E], 12 [#00], [#C2 #C2 #C2 #FC] et 40
[#4E] (SEDORIC, si 16 ou 17 secteurs par piste, sinon rien), soit une économie de 50 à 146 octets.

c) Chaque secteur est alors précédé d'un champ d'identification formé de: 12 [#00], la séquence de
synchronisation [#A1 #A1 #A1], [#FE pp ff ss tt CRC CRC] puis 22 octets [#4E]. Le champ de data est
constitué de 12 octets [#00], la séquence de synchronisation [#A1 #A1 #A1], le marqueur de début de data
[#FB] et enfin les 256 octets du secteur. Chaque secteur est suivi de 80 octets [#4E] (selon la norme IBM
et 40, 30 ou 12 octets [#4E] dans le cas de SEDORIC, selon le nombre de secteurs par piste), soit une
économie de 12 à 42 octets par secteurs. Puis vient le secteur suivant... (NB: #pp = n(piste, #ff = n(face,
#ss = n(secteur, #tt = taille (#01 pour les 256 octets de SEDORIC, #02 pour les 512 octets de l'IBM PC
etc...)

d) La fin de piste est marquée par un nombre très variable d'octets [#4E] (facultatif). La piste étant
circulaire, toutes les valeurs entre la fin de piste et le début de piste sont sans signification

e) Selon le nombre de secteurs par piste, la place disponible pour les "gaps" est variable. Toutes ces
indications sont théoriques, lorsqu'on lit une piste et ses "gaps" avec un utilitaire spécialisé tel que
NIBBLE, on obtient des différences. Le premier des 3 octets de synchronisation par exemple est toujours
faux, puisque la synchronisation n'a pas encore été obtenue! De plus, la zone située entre la fin des data
et les octets de synchronisation de l'en-tête du secteur suivant (soit le "gap" situé entre deux secteurs)
contient souvent n'importe quoi. En fait, ni le contrôleur de drive, ni le drive lui-même, ne répondent
instantanément. Il s'ensuit des bavures lors des changements d'état de la tête de lecture/écriture. C'est la
raison d'être de ces "gaps", qui servent à protéger le secteur suivant. Si l'on voulait augmenter le nombre
de secteurs par piste, il faudrait diminuer la taille des "gaps" et donc la fiabilité.

Soit en résumé:
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




Fantasmagoric boot sector (Fabrice Frances)
-------------------------------------------

org $9fd0-11   ; this allows load_addr to be in $9fd0, see below

page1
; first page of the Fantasmagoric boot sector, containing :
; - Microdisc and Cumana "boot" sector (system parameters)
; - OricDos directory
; - OricDos and Cumana "system", in record format

off_00  db  40          ; Microdisc wants this to be not null (# of tracks)
                        ; this is also used as the track of the next directory sector
                        ; and also the track of the next sector of the loaded file
off_01  db  0           ; next directory sector, and also next sector of file
                        ; a 0 value means no next sector
off_02  db  1      ; only one entry in this directory
off_03  db  0           ; skip this directory entry (things are too intricated here)
; record header
off_04  dw  load_addr   ; where to load this record
off_06  dw  last
off_08  dw  0           ; this should be the exec addr, but it is copied elsewhere and
            ; gets overriden by second page of the sector
off_0A  db  LOW(last)-LOW(load_addr)   ; record size

load_addr       ; load_addr=$9fd0, thus the copyright message starts now (empty)

; Bios Parameter Block for the PC starts here but MSDOS and Windows don't seem
; to use it anymore, and seem to rely on the type byte found in the FAT
off_0B  db  0   ; microdisc copyright message is copied from here to the status line
off_0C  db  0
off_0D  db  0   ; cumana copyright message is copied from here to the status line
off_0E  dw  0
off_10  db  0,0 ; OricDos parameters : first free sector location, but copied to the second part
off_12  db  1   ; OricDos parameters : directory sector #
off_13  db  0   ; OricDos parameters : directory track #
                ; OricDos directory : 0 means skip this directory entry (things are way too intricated here !)
off_14  dw  0   ; OricDos parameters : # of free sectors, copied to the second part
off_16  dw  1   ; OricDos parameters : # of used sectors, copied to the second part
off_18  dw  0
off_1A  dw  0

; definition tables for floppy types 720KB, 180KB, 360KB
; a third table (dataside) use the OricDos directory entry just below
dirsect db  8,6,6
datasect db 6,1,4
        db 0
; here we are more comfortable to store an OricDos directory entry
off_23  string "Boot  3.0"
dataside                ; this saves some place since table is 1,0,1
        db  1           ; BOOT is 1 sector
        db  0,1         ; it starts at track 0 sector 1
        db  0,1         ; so it ends at same sector
        db  0,$80       ; flags


page    equ $40         ; temporary variables in page 0
nbsect  equ $41
addrbuf equ $42
addrbufh equ $43
sector  equ $44
side    equ $45
type    equ $46
fdc_offset   equ $47
machine_type  equ 0
tmp     equ 1

; definitions
buf     equ $A200
FDC_command   equ $0300
FDC_status   equ $0300
FDC_track   equ $0301
FDC_sector   equ $0302
FDC_data   equ $0303


; let's start some code at last

microdisc_start
   sei
   ldx #0
microdisc_move      ; copy the second part of the sector
   lda $C123,x             ; which has not been transfered by the eprom code
   sta page2,x
   inx
   bne microdisc_move
   lda #$40
   sta machine_type   ; flag a microdisc controller
   ldx #$10
   stx fdc_offset
   lda #$84
   sta $0314               ; switch to overlay ram, disables FDC interrupts

all_start         ; here is the common code for all machine types
   lda #$7F
   sta $030E      ; disables VIA interrupts
   ldx #2                  ; first FAT sector
   stx sector
   lda #0
   sta side
   jsr buf_readsect        ; get it in buffer

   lda buf         ; floppy type
   sec
   sbc #$F9
   beq *+4
   sbc #2
   sta type        ; now we have types 0 (720KB), 1 (180KB) , 2 (360KB)
   tax

   jsr search_system

   lda buf+$1C,x   ; compute the number of sectors used, minus 1 (the first one)
   sec      
   sbc #1
   lda buf+$1D,x
   sbc #0
   lsr a
   sta nbsect

                                ; get the location of the first data sector
   ldx type
   lda datasect,x
   sta sector
   lda dataside,x
   sta side
   bne loadfirst
   jsr step_in             ; if it's on side 0 (180KB floppy), it's on track 1

loadfirst                       ; load first data sector
    jsr buf_readsect

   sec         ; initialize transfer address
   lda buf+1
   sbc #5
   sta addrbuf
   lda buf+2
   sbc #0
   sta addrbufh
   sta page

   ldy #5          ; and transfer the first sector (except first 5 bytes)
   ldx #2
moveloop
   lda buf,y
   sta (addrbuf),y
   iny
   bne moveloop
   inc addrbufh
   inc moveloop+2
   dex
   bne moveloop

nextsect         ; compute next sector
   ldx sector
   inx
   cpx #10                 ; # of sectors per track
   bne readnext
   inc side
   ldx type
   lda dataside,x          ; 1 if double-sided disk, 0 if single_sided 
   cmp side
   bcs readnext
   jsr step_in
   ldx #0
   stx side
   inx

readnext         ; read next sector
   stx sector
   inc page
   inc page
try
   lda page
   sta addrbufh
   jsr readsect
   bne try

   dec nbsect
   bne nextsect

   lda machine_type
   jmp (buf+3)      ; start the system
        
last    db  0


; second part (offsets $100-$1ff) of the fantasmagoric boot sector, this contains :
; - boot for Telestrat
; - boot for Jasmin
; - values overriding Microdisc and Cumana variables due to a sector too big

        org page1+$100      ; we are at offset $100 from the beginning
page2

; Jasmin loads the boot sector in $0400, Telestrat loads it in $C100.
; both Telestrat and Jasmin override first page of the sector with second page.
; Jasmin starts exec at offset 0, 
; Telestrat has a five byte header and starts exec at offset 5.

 db 0 ; Telestrat needs 0 at offset 0 for a bootable disk
      ; Microdisc system parameter copy : first free sector being 0 means no sector (lucky me)
      ; Jasmin interprets this instruction as BRK #9, hopefully no harm is done
 db 9 ; Telestrat : # of sectors per track
      ; Microdisc system parameter copy : track # of the first free sector (none, see above)
 db 1 ; Telestrat takes here the number of sectors of the DOS to load
      ; Microdisc system parameter copy : directory sector (lucky again)
      ; Jasmin interprets this instruction as ORA (00,X), again no harm is done
 db 0 ; Telestrat : LSB of DOS loading address, one dummy sector will be read there only
      ; Microdisc system parameter copy : directory sector (lucky again)
 db $2C
      ; Telestrat : MSB of DOS loading address, chosen for the Jasmin usage below
      ; Jasmin interprets this instruction as a BIT nnnn so it skips the following instruction
      ; Microdisc system parameter copy : LSB of # of free sectors (can't be always lucky)
 beq telestrat_start 
      ; flag Z is set when the telestrat does JSR $C105
      ; Microdisc system parameter copy of # of free and used sectors are wrong, hard to do better
 beq jasmin_start
      ; at last we can take control on the Jasmin

off_109 string "Boot  3.0"    ; this matching pattern overrides the one at $C12C on Microdisc
               ; Cumana cannot use a matching pattern with wildcards here
        reserve 6         ; this space could be used for my local variables in the future
off_118 db  0            ; this byte ($C12B) on the microdisc is copied to $C000
        db  $FF
        reserve 2         ; this space could be used for my local variables in the future
off_11C db 0         ; this byte ($C13F) on the microdisc is tested against 0
        reserve 11      ; this space could be used for my local variables in the future
off_128 dw  microdisc_start   ; this word ($C14B) is used as exec addr for microdisc
off_12A dw  microdisc_start   ; this word ($C14D) is used as exec addr for cumana

jasmin_start
   sta $03FB         ; 0->ROMDIS selects ROM
   bit $FFFC
   bmi atmos
   jsr $F888
   bne *+5
atmos jsr $F8B8
   ldy #1
   sty $03FA               ; 1->ORMA selects overlay ram
   lda #4         ; we are curently running in page 4
   sta readboot_jsr+2-page2+$0400   ; so, adjust the JSR address
   ldy #$20         ; flag a Jasmin controller
   ldx #$F4         ; FDC location in page 3
   bne half_sector_only

telestrat_start
   lda #$7F
   sta $032E       ; disable VIA2 interrupts
   sta $031D       ; disable ACIA interrupts too
   lda $031D       ; clear ACIA interrupt in case...

   ldy #$C0      ; flag Telestrat hardware and Microdisc hardware
   ldx #$10      ; FDC location in page 3

half_sector_only      ; load the full boot sector, we only have one half for now ! 
   sei
   sty machine_type
   stx fdc_offset
   ldx #1            ; sector 1
   stx sector
   dex
   stx side                        ; side 0

reloadboot   
   ldy #LOW(page1)
   lda #HIGH(page1)
   sty addrbuf
   sta addrbufh
readboot_jsr
   jsr readsect-page2+$C100   ; the routine is not in its final location yet, so...
   bne reloadboot
   jmp all_start

buf_readsect                ; read a sector in my buffer
   ldy #LOW(buf)
   sty addrbuf
   lda #HIGH(buf)
   sta addrbufh
   jsr readsect
   bne buf_readsect    ; minimal error handling, retry forever until it works
   rts


readsect
   ldx fdc_offset
   lda side
   bit machine_type
   bvc select_side
   asl a
   asl a
   asl a
   asl a
   ora #$84
select_side
   sta $0304,x
   lda sector
   sta FDC_sector,x
   lda #$84
   bne command

step_in
   ldx fdc_offset
   lda #$5B

command
   sta FDC_command,x
   ldy #4
   dey
   bne *-1
   beq wait_command_end

get_data
   lda FDC_data,x
   sta (addrbuf),y
   iny
   bne wait_command_end
   inc addrbufh
wait_command_end
   lda FDC_status,x
   and #3
   lsr a
   bne get_data
   bcs wait_command_end
   lda FDC_status,x
   and #$1C
   rts

search_system
   lda dirsect,x   ; get the first directory sector
   sta sector

   jsr buf_readsect


   ldy #11
compare_name
   lda buf,x
   cmp dos_name,y
   bne next_name
   dex
   dey
   bpl compare_name
   iny
   beq found_name
   rts

cluster_to_physical
   ldx #$ff
compute_cylinder
   inx
   sec
   sbc __sectors_per_cyl
   bcs compute_cylinder
   dey
   bpl compute_cylinder
   adc __sectors_per_cyl

   stx __cylinder
   ldy #0
   cmp __sectors_per_track
   bcc store_side
   iny
   sbc __sectors_per_track
store_side
   sty __side
   tay
   iny
   sty __sector

   rts

   org page2+255
   db 0                            ; thus we have a full 512-bytes loader



MFM_DISK                02 00 00 00 2A 00 00 00 [offset $00]
01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E [offset $100 / 256]

fwrite(new_signature,8,1,fd);
fwrite(&sides,1,4,fd); fwrite(&tracks,1,4,fd); fwrite(&geometry,1,4,fd);
fwrite(header+20,256-20,1,fd);


int offset=header_dsk;  // on ajoute le header
offset+=track*6400;     // On avance à la bonne piste
offset+=(taille_secteur+nb_oct_after_sector+nb_oct_before_sector)*(sector-1);

#define nb_oct_before_sector  59 // Cas de 17 secteurs/pistes !
#define nb_oct_after_sector   43      //#define nb_oct_after_sector 31


Une piste SEDORIC, formatée à 17 secteurs, compte 96 octets de début de piste + 17 secteurs de 358 octets + 98 octets de fin de piste = 6280 octets. 
-> 256+59+43=358


Une piste SEDORIC, formatée à 19 secteurs, compte 0 octet de début de piste + 19 secteurs de 328 octets + 48 octets de fin de piste = 6280 octets. 
On comprend mieux le manque de fiabilité du formatage en 19 secteurs/piste dû à la faible largeur des zones de sécurité (12 [#4E] entre chaque secteur et 48 octets entre le dernier et le premier).

Lors de l'élaboration du tampon de formatage SEDORIC, les octets #C2 sont remplacés par des octets
#F6, les octets #A1 sont remplacés par des octets #F5 et chaque paire de 2 octets [CRC CRC] et
remplacée par un octet #F7. Comme on le voit, nombre de variantes sont utilisées, sauf la zone 22 [#4E],
12 [#00], 3 [#A1] qui est strictement obligatoire.



	for(s=0;s<sides;s++)
        {
	  for(t=0;t<tracks;t++) 
          {
            offset=gap1;
	    for(i=0;i<sectors;i++) 
            {
              trackbuf[offset+4]=t;
              trackbuf[offset+5]=s;
              trackbuf[offset+6]=i+1;
              trackbuf[offset+7]=1;
              compute_crc(trackbuf+offset,4+4);
              offset+=4+6;
              offset+=gap2;
              memcpy(trackbuf+offset+4,bigbuf+((s*tracks+t)*sectors+i)*256,256);
              compute_crc(trackbuf+offset,4+256);
              offset+=256+6;
              offset+=gap3;
	    }
	    fwrite(trackbuf,6400,1,fd);
	  }
        }

  // From DskTool:
  15, 16 or 17 sectors: gap1=72; gap2=34; gap3=50;
  18 sectors: gap1=12; gap2=34; gap3=46;

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



Here is the content of DEFAULT.DSK:
Size: 537856 bytes

Header: 256 bytes:
- Signature: 8 bytes (MFM_DISK)
- Sides:     4 bytes (2)
- Tracks:    4 bytes (42/$2A)
- Geometry:  4 bytes (1)
- Padding: 236 bytes (000000...00000 )

So, 537856-256=537600 bytes of data for the floppy itself.
537600/2 sides  =268800 bytes per side
268800/42 tracks=6400 bytes per track

Sectors identified:
- 0x16C /  364 -> A1 A1 A1 FE Track:00 Side:00 Sector:01 01 CRC:FA 0C
- 0x2D2 /  722 -> A1 A1 A1 FE Track:00 Side:00 Sector:02 01 CRC:AF 5F
- 0x438 / 1080 -> A1 A1 A1 FE Track:00 Side:00 Sector:03 01 CRC:9C 6E

First sector at offset 364, minus 256 bytes header -> 98 bytes start of track.

The boot sector is copied at 0x319
- 0x2C6   -> |00 00 00 00 00 00 00 00 00 00 00 00|A1 A1 A1 FE Track:00 Side:00 Sector:02 01 CRC:AF 5F|4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E|
- 0x2F2   -> |00 00 00 00 00 00 00 00 00 00 00 00|A1 A1 A1 FB [Start of boot sector data]
- 0x302   ->  00 00 FF 00 D0 9F D0 9F 02 B9 01 00 FF 00 00 B9 E4 B9 00 00 E6 12 00[BOOT EXECUTABLE DATA]
                                                                                 ^
                                                                                 +- 00 if Master, 01 if Slave

23 bytes of crap before the actual boot loading address
These 23 bytes seem confirmed by Sedoric a nu (page 489), that would mean we have 256-23=233 bytes in the boot code.

Actual bytes of BOOTSECTOR.O: 78 A9 60 85 00 20 00 00 BA CA 18 BD 00 01 69 22

SYSTEMDOS
BOOTUPCOM


Track header:
4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 
4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 
4E 4E 4E 4E 4E 4E 4E 4E 00 00 00 00 00 00 00 00
00 00 00 00 C2 C2 C2 FC 4E 4E 4E 4E 4E 4E 4E 4E
4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E
4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E
00 00 00 00 00 00 00 00 00 00 00 00

Une piste SEDORIC, formatée à 17 secteurs, compte 96 octets de début de piste + 17 secteurs de 358 octets + 98 octets de fin de piste = 6280 octets. 
-> 256+59+43=358


ou 12 [#00], 3 [#A1] [#FE #pp #ff #ss #01 CRC CRC], 22 [#4E], 12 [#00], 3 [#A1], [#FB], les 256
octets, [CRC CRC], 12, 30 ou 40 octets [#4E] (selon le nombre de secteurs/piste). Soit environ 256 + (72
à 100) = 328 à 356 octets pour SEDORIC.

void compute_crc(unsigned char *ptr,int count)
{
  int i;
  unsigned short crc=0xFFFF,byte;
  for (i=0;i<count;i++) 
  {
    byte= *ptr++;
    crc=(crc<<8)^crctab[(crc>>8)^byte];
  }
  *ptr++=crc>>8;
  *ptr++=crc&0xFF;
}



Mais ce n'est pas tout! Le code de la ROM du MICRODISC cherche à charger ORIC DOS à partir de la
disquette. Or la structure de la disquette "Master" qui contient SEDORIC est bien différente! Si on passe
sur certains détails scabreux (ORIC DOS utilise par exemple des enregistrements de taille variable dans les
secteurs, enregistrements contenant leur propre adresse de chargement), le copyright est extrait d'un
enregistrement factice (situé dans le secteur numéro 2 de la piste zéro) et les fichiers BOOTUP.COM et
SYSTEM.COM sont cherché dans un directory factice (situé dans le troisième secteur de la piste zéro).
C'est au tour de SEDORIC de tromper ORIC DOS! La façon dons les systèmes comme SEDORIC font
croire à L’EPROM du MICRODISC que la disquette est une ORIC DOS est déjà tout un programme...
Le genre d’horreurs nées du souci de compatibilité.

La question suivante est de savoir comment la ROM du MICRODISC est capable de charger SEDORIC,
dont le système de fichiers a une structure différente et qui n'utilise pas d'enregistrements comme
ORICDOS. Ceci est réalisé en bernant la ROM, en lui faisant croire qu'il y a bien une disquette ORICDOS
dans le lecteur. Les trois premiers secteurs des disquettes SEDORIC servent à imiter un système de fichier
ORICDOS. L'ANNEXE suivante vous montre le contenu de ces 3 secteurs. En regardant de plus près, on
voit que dans le troisième secteur de la piste zéro, le fichier BOOTUP.COM est soit disant présent dans
le deuxième secteur de la piste zéro. Ceci est utilisé pour charger un enregistrement qui est finallement
exécuté et ce petit morceau de code est responsable du chargement de SEDORIC en RAM overlay. Bien
sûr, il cela aurait été plus simple si ORICDOS chargeait un secteur de boot et l'exécutait juste après! C'est
ainsi que le TELEMON du TELESTRAT opère.

Les 3 premiers secteurs contiennent n( de version, boot et copyright et sont listés ci-après .

Dump du premier secteur de disquette Master ou Slave (VERSION)
       0 1 2 3 4 5 6 7 8 9 A B C D E F 0123456789ABCDEF
0000- 01 00 00 00 00 00 00 00 20 20 20 20 20 20 20 20
0010- 00 00 03 00 00 00 01 00 53 45 44 4F 52 49 43 20
0020- 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20
0030- 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20
0040- 53 45 44 4F 52 49 43 20 56 33 2E 30 30 36 20 30 SEDORIC V3.006 0
0050- 31 2F 30 31 2F 39 36 0D 0A 55 70 67 72 61 64 65 1/01/96..Upgrade
0060- 64 20 62 79 20 52 61 79 20 4D 63 4C 61 75 67 68 d by Ray McLaugh
0070- 6C 69 6E 20 20 20 20 20 20 20 20 20 0D 0A 61 6E lin ..an
0080- 64 20 41 6E 64 72 7B 20 43 68 7B 72 61 6D 79 20 d André Chéramy
0090- 20 20 20 20 20 20 20 20 20 20 20 20 0D 0A 0D 0A ....
00A0- 53 65 65 20 53 45 44 4F 52 49 43 33 2E 46 49 58 See SEDORIC3.FIX
00B0- 20 66 69 6C 65 20 66 6F 72 20 69 6E 66 6F 72 6D file for inform
00C0- 61 74 69 6F 6E 20 0D 0A 20 20 20 20 20 20 20 20 ation ..
00D0- 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20
00E0- 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20
00F0- 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20

Dump du deuxième secteur de disquette Master ou Slave (COPYRIGHT)
       0 1 2 3 4 5 6 7 8 9 A B C D E F 0123456789ABCDEF
0000- 00 00 FF 00 D0 9F D0 9F 02 B9 01 00 FF 00 00 B9
0010- E4 B9 00 00 E6 12 00 78 A9 7F 8D 0E 03 A9 10 A0 01 si Slave
0020- 07 8D 6B 02 8C 6C 02 A9 86 8D 14 03 A9 BA A0 B9
0030- 20 1A 00 A9 84 8D 14 03 A2 02 BD FD CC 9D F7 CC
0040- CA 10 F7 A2 37 A0 80 A9 00 18 79 00 C9 C8 D0 F9
0050- EE 37 B9 CA D0 F3 A2 04 A8 F0 08 AD 01 B9 A8 D0
0060- 02 A2 3C 84 00 A9 7B A0 B9 8D FE FF 8C FF FF A9
0070- 05 8D 12 03 A9 85 8D 14 03 A9 88 8D 10 03 A0 00
0080- 58 AD 18 03 30 FB AD 13 03 99 00 C4 C8 4C 6C B9
0090- A9 84 8D 14 03 68 68 68 AD 10 03 29 1C D0 D5 EE
00A0- 76 B9 EE 12 03 CA F0 1F AD 12 03 CD 00 B9 D0 C1
00B0- A9 58 8D 10 03 A0 03 88 D0 FD AD 10 03 4A B0 FA
00C0- A9 01 8D 12 03 D0 AA A9 C0 8D 0E 03 4C 00 C4 0C
00D0- 11 53 45 44 4F 52 49 43 20 56 33 2E 30 0A 0D 60 .SEDORIC V3.0..`
00E0- 20 31 39 38 35 20 4F 52 49 43 20 49 4E 54 45 52 1985 ORIC INTER
00F0- 4E 41 54 49 4F 4E 41 4C 0D 0A 00 00 00 00 00 00 NATIONAL........

Cet exemple provient d'une disquette Master vierge, formatée en 42 pistes de 17 secteurs, simple face. Le
seul octet qui diffère de son homologue de la version 1.006 est indiqué en gras. En 00D1, le message de
COPYRIGHT devient:
"SEDORIC V3.0
© 1985 ORIC INTERNATIONAL"
Remarquez le contenu de l'octet n°#16 qui vaut ici #00 et indique qui s'agit d'une disquette Master.
Désassemblage du deuxième secteur de disquette master
Cette routine est probablement mise en jeu lors du BOOT. Elle semble charger SEDORIC en RAM overlay.
Il faudrait connaître la signification des registres d'I/O du contrôleur de disquette pour pouvoir en
comprendre les détails.

+23 !
0017- 78 SEI interdit les interruptions
0018- A9 7F LDA #7F A = 0111 1111
001A- 8D 0E 03 STA 030E b7 de 030E à 0 pour interdire les interruptions
001D- A9 10 LDA #10
001F- A0 07 LDY #07
0021- 8D 6B 02 STA 026B PAPER = #10 (noir)
0024- 8C 6C 02 STY 026C INK = 07 (blanche)
0027- A9 86 LDA #86
0029- 8D 14 03 STA 0314 #86 I/O contrôleur de disquette
002C- A9 BA LDA #BA
002E- A0 B9 LDY #B9 AY = #BAB9
0030- 20 1A 00 JSR 001A afficher la chaîne pointée par AY
0033- A9 84 LDA #84
0035- 8D 14 03 STA 0314 #84 I/O contrôleur de disquette
0038- A2 02 LDX #02 pour copie de 3 octets de CCFD/CCFF en CCF7/CCF9


00 00     "lien" (coordonnées du descripteur suivant). Ici le #0000 pointe sur le secteur n°0 de la piste n°0, ce qui indique qu'il n'y a pas d'autre descripteur, car un numéro de secteur ne peut jamais être nul.
FF        contient #FF (seulement si premier secteur descripteur) (Le pointeur X est positionné sur ce #FF, et permet de lire la suite
00        (C101+X) type de fichier (voir manuel page 100). Ici #40, soit 0100 0000, indique qu'il s'agit d'un fichier de type "Bloc de données" (b6 à 1)
D0 9F     (C102+X et C103+X) adresse (normale) de début (ou nombre de fiches pour un fichier à accès direct). Ici #C400 est le début de la BANQUE n°7 en RAM overlay.
D0 9F     (C104+X et C105+X) adresse (normale) de fin (ou longueur d'une fiche pour un fichier à accès direct). Ici #C7FF est la fin de la BANQUE n°7 en RAM overlay.
02 B9     (C106+X et C107+X) adresse d'exécution si AUTO, #0000 si non AUTO.
01 00     (C108+X et C109+X) nombre de secteurs à charger. La BANQUE n°7 comporte 4 secteurs, d'où le #0004 qui figure ici
FF 00     (C100+Y et C101+Y) liste coordonnées piste/secteur des secteurs à charger. Ici le premier secteur de la BANQUE n°7 se trouve au secteur n°11 (#0B) de la piste n°5 (#05), le dernier au secteur n°14 (#0E) de cette même piste. Dans un premier descripteur il y a de la place pour 122 paires de 2 octets. Si le nombre de secteurs à charger dépasse 122, lorsque Y atteint #00 (fin BUF1), il faut charger le descripteur suivant dont la structure est simplifiée:
00 B9     "lien" (coordonnées du descripteur suivant)
E4 B9 
00 00 E6 12 
00


Les 3 premiers secteurs contiennent n( de version, boot et copyright et sont listés ci-après .

Dump du premier secteur de disquette Master ou Slave (VERSION)
      0 1 2 3 4 5 6 7 8 9 A B C D E F 0123456789ABCDEF
0000- 01 00 00 00 00 00 00 00 20 20 20 20 20 20 20 20
0010- 00 00 03 00 00 00 01 00 53 45 44 4F 52 49 43 20
0020- 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20
0030- 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20
0040- 53 45 44 4F 52 49 43 20 56 33 2E 30 30 36 20 30 SEDORIC V3.006 0
0050- 31 2F 30 31 2F 39 36 0D 0A 55 70 67 72 61 64 65 1/01/96..Upgrade
0060- 64 20 62 79 20 52 61 79 20 4D 63 4C 61 75 67 68 d by Ray McLaugh
0070- 6C 69 6E 20 20 20 20 20 20 20 20 20 0D 0A 61 6E lin ..an
0080- 64 20 41 6E 64 72 7B 20 43 68 7B 72 61 6D 79 20 d André Chéramy
0090- 20 20 20 20 20 20 20 20 20 20 20 20 0D 0A 0D 0A ....
00A0- 53 65 65 20 53 45 44 4F 52 49 43 33 2E 46 49 58 See SEDORIC3.FIX
00B0- 20 66 69 6C 65 20 66 6F 72 20 69 6E 66 6F 72 6D file for inform
00C0- 61 74 69 6F 6E 20 0D 0A 20 20 20 20 20 20 20 20 ation ..
00D0- 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20
00E0- 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20
00F0- 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 2

*/

