

#include "common.h"

#include <memory.h>
#include <stdlib.h>
#include <stdio.h>
#include <cctype>

#ifdef WIN32
/* for getch() */
#include <conio.h>
#include <windows.h>
#include <direct.h>

#ifdef DeleteFile
#undef DeleteFile
#endif

#else
/* for getch() */
#include <curses.h>
#include <unistd.h>
#include <limits.h>
#define stricmp strcasecmp
#define _MAX_PATH PATH_MAX
#define _MAX_DRIVE 3
#define _MAX_DIR PATH_MAX
#define _MAX_FNAME NAME_MAX
#define _MAX_EXT NAME_MAX
#endif

#include <stdio.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <stdarg.h>

#include <assert.h>

static std::string g_cApplicationName;
static std::string g_cUsageMessage;
static std::string g_cVersionString;
static int g_nVersionMajor;
static int g_nVersionMinor;


void SetApplicationParameters(const char* pcApplicationName,int versionMajor,int versionMinor,const char* pcUsageMessage)
{
  g_cApplicationName=pcApplicationName;

  g_nVersionMajor=versionMajor;
  g_nVersionMinor=versionMinor;
  char cTempBuffer[256];
  sprintf(cTempBuffer,"%d.%03d",versionMajor,versionMinor);
  g_cVersionString=cTempBuffer;

  g_cUsageMessage=pcUsageMessage;
}



void ShowError(const char *formatString,...)
{
  std::string errorMessage;

  if (formatString)
  {
    // Message will be something like: "MyApplication.exe: Something goes wrong, sorry !"

    va_list va;
    char    temp[4096];

    va_start(va,formatString);
    const int length=vsprintf(temp,formatString,va);
    va_end(va);
    if ((unsigned int)length>=sizeof(temp))
    {
      temp[sizeof(temp)-1]=0;
    }

    errorMessage=g_cApplicationName+": "+ temp;
  }
  else
  {
    errorMessage=g_cUsageMessage;
    StringReplace(errorMessage,"{ApplicationName}"	,g_cApplicationName);
    StringReplace(errorMessage,"{ApplicationVersion}"	,g_cVersionString);
  }

  // Show the resulting message on screen
  printf("\r\n%s\r\n",errorMessage.c_str());
  //getch();   // Could probably be a command line parameter option the caller can provide to ask to add a pause on error.
  exit(1);
}



bool LoadFile(const char* fileName,void* &pcBuffer,size_t &bufferSize)
{
  // get the size of the file
  struct stat file_info;

  if (stat(fileName, &file_info)== -1)
  {
    return false;
  }

  // open the file
  bufferSize=file_info.st_size;
  const int handle=open(fileName,O_BINARY|O_RDONLY,0);
  if (handle==-1)
  {
    return false;
  }

  // allocate some memory
  pcBuffer=malloc(bufferSize+1);
  if (!pcBuffer)
  {
    close(handle);
    return false;
  }

  // read file content
  if (read(handle,pcBuffer,bufferSize)!=(int)bufferSize)
  {
    free(pcBuffer);
    close(handle);
    return false;
  }
  close(handle);

  // Add a null terminator in the additional byte
  char *pcCharBuffer=(char*)pcBuffer;
  pcCharBuffer[bufferSize]=0;

  return true;
}


bool SaveFile(const char* fileName,const void* pcBuffer,size_t bufferSize)
{
  // Open file
  int handle=open(fileName,O_BINARY|O_WRONLY|O_TRUNC|O_CREAT,S_IREAD|S_IWRITE);
  if (handle==-1)
  {
    return false;
  }

  // Save data
  if (write(handle,pcBuffer,bufferSize)!=(int)bufferSize)
  {
    close(handle);
    return false;
  }

  // close handle
  close(handle);

  return true;
}

bool DeleteFile(const char* pcFileName)
{
  return unlink(pcFileName)==0;
}


/**
* Transforms a raw ascii buffer (0 terminated)
* into a vector of string where each string
* contains one line of the original buffer.
*
* Compute the lenght of the longest line during
* the process
*/
bool LoadText(const std::string& fileName, std::vector<std::string>& textData)
{
  return LoadText(fileName.c_str(), textData);
}

bool LoadText(const char* fileName,std::vector<std::string>& textData)
{
  textData.clear();

  void* ptr_buffer_void;
  size_t file_size;
  if (!LoadFile(fileName,ptr_buffer_void,file_size))
  {
    return false;
  }

  const char *ptr_line=(const char *)ptr_buffer_void;
  const char *ptr_read=ptr_line;

#if 0
  //
  // Check the BOM (Byte Order Mark) in case we got ourself a UTF8 file
  // https://en.wikipedia.org/wiki/Byte_order_mark
  //
  // 0xEF 0xBB 0xBF  -> UTF-8 
  // 0xFF 0xFE       -> UTF-16 (Little Endian)
  // 0xFE 0xFF       -> UTF-16 (Big Endian)
  if (file_size > 1)
  {
    const unsigned char* ptr_bom((const unsigned char*)ptr_read);
    switch (*ptr_bom)
    {
    case 0xEF:  // UTF-8 Check      
      if ( (file_size<3) || (ptr_bom[1]!=0xBB) || (ptr_bom[2] != 0xBF) )
      {
        // Not a valid UTF8 text file
        return false;
      }
      ptr_line += 3;
      ptr_read += 3;
      break;

    case 0xFF:  // UTF-16 LE Check
    case 0xFE:  // UTF-16 BE Check      
      return false;  // We do not yet support UTF-16 for text files (UTF16 is an horrible format anyway).
    }

  }
#endif


  bool flag_new_line=true;

  int line_count=0;
  int longest_line=0;

  while (true)
  {
    char car=*ptr_read++;
    switch (car)
    {
    case 0:
    case 0x0D:
    case 0x0A:
      {
        //
        // Find a end of line.
        // Patch it with a "0"
        // and insert the line in the container
        //
        int size_line=ptr_read-ptr_line-1;
        std::string	new_line(ptr_line,size_line);
        textData.push_back(new_line);

        line_count++;

        if (size_line>longest_line)
        {
          longest_line=size_line;
        }

        if (!car)
        {
          //
          // Finished parsing
          //
          free(ptr_buffer_void);
          return true;
        }
        if ( (car==0x0D) && ((*ptr_read)==0x0A) )
        {
          // If we have a \r\n sequence, we skip the \n
          ptr_read++;
        }
        ptr_line=ptr_read;
        flag_new_line=true;
      }
      break;

    default:
      flag_new_line=false;
      break;
    }
  }
  return true;
}

bool IsUpToDate(const char* sourceFile,const char* targetFile)
{
  struct stat sourceFileInfo;
  struct stat targetFileInfo;

  if (stat(sourceFile,&sourceFileInfo)== -1)
  {
    return false;
  }
  if (stat(targetFile,&targetFileInfo)== -1)
  {
    return false;
  }
  return (targetFileInfo.st_mtime >= sourceFileInfo.st_mtime);
}

bool IsUpToDate(const std::string& sourceFile,const std::string& targetFile)
{
  return IsUpToDate(sourceFile.c_str(),targetFile.c_str());
}


int StringReplace(std::string& mainString,const std::string& rearchedString,const std::string& replaceString)
{
  int nReplaceCount=0;
  std::string::size_type pos=0;
  while (1)
  {
    pos=mainString.find(rearchedString,pos);
    if (pos==std::string::npos)
    {
      break;
    }
    mainString.replace(pos,rearchedString.size(),replaceString);
    pos+=replaceString.size();
    ++nReplaceCount;
  }
  return nReplaceCount;
}

std::string StringTrim(const std::string& inputString,const std::string& filteredOutCharacterList)
{
  const size_t startPos=inputString.find_first_not_of(filteredOutCharacterList);
  if (startPos!=std::string::npos)
  {
    const size_t endPos=inputString.find_last_not_of(filteredOutCharacterList);
    if (endPos!=std::string::npos) 
    {
      return inputString.substr(startPos,(endPos-startPos)+1);
    }
  }
  // Returns an empty string: This case means that basically the input string contains ONLY characters that needed to be filtered out
  return "";
}


std::string StringSplit(std::string& inputString, const std::string& filteredOutCharacterList)
{
  std::string leftSplit;
  const size_t startPos=inputString.find_first_of(filteredOutCharacterList);
  if (startPos!=std::string::npos)
  {
    leftSplit=inputString.substr(0,startPos);
    inputString=inputString.substr(startPos+1);
  }
  else
  {
    std::swap(inputString,leftSplit);
  }
  inputString=StringTrim(inputString, filteredOutCharacterList);
  return leftSplit;
}


std::string StringMakeLabel(const std::string& sourceString)
{
  std::string cleanString;
  for (auto it(sourceString.begin());it!=sourceString.end();it++)
  {
    char car=*it;
    if ( (car>32) && (car<128) && (std::isalpha(car) || std::isdigit(car) ) )
    {
      cleanString.push_back(car);
    }
    else
    {
      cleanString.push_back('_');
    }
  }

  return cleanString;
}


ArgumentParser::ArgumentParser(int argc,char *argv[]) :
  m_argc(argc),
  m_argv(argv),
  m_first_param(1),
  m_nb_arg(-1),
  m_remaining_argc(argc),
  m_ptr_arg(0)
{
  assert(argc>=1);

  // We do not count the implicit first parameter (application name) in the parameter count
  m_remaining_argc--;
}

const char* ArgumentParser::GetParameter(int parameterIndex)
{
  int index=m_first_param+parameterIndex;
  if (index>=m_argc)
  {
    // Wrong !
    return "";
  }
  return m_argv[index];
}

int ArgumentParser::GetParameterCount()
{
  return m_remaining_argc;
}

bool ArgumentParser::ProcessNextArgument()
{
  if ((!m_remaining_argc) || (m_nb_arg==m_remaining_argc))
  {
    // No more arguments
    return false;
  }

  m_nb_arg	=m_remaining_argc;
  m_ptr_arg	=m_argv[m_first_param];

  return true;
}

bool ArgumentParser::IsSwitch(const char *ptr_switch)
{
  if (!::get_switch(m_ptr_arg,ptr_switch))
  {
    return false;
  }
  m_first_param++;
  m_remaining_argc--;
  return true;
}

bool ArgumentParser::IsParameter()
{
  if (!m_ptr_arg)
  {
    return false;
  }
  char car=*m_ptr_arg;
  if ((!car) || (car=='-'))
  {
    return false;
  }

  m_first_param++;
  m_remaining_argc--;
  return true;
}


std::string ArgumentParser::GetStringValue()
{
  return ::get_string(m_ptr_arg);
}

int ArgumentParser::GetIntegerValue(int default_value)
{
  return ::get_value(m_ptr_arg,default_value);
}

double ArgumentParser::GetDoubleValue(double default_value)
{
  return ::get_double(m_ptr_arg,default_value);
}



bool ArgumentParser::GetBooleanValue(bool default_value)
{
  int value;
  if (default_value)	value=1;
  else				value=0;
  value=::get_value(m_ptr_arg,value);
  if (value)	return true;
  else		return false;
}

bool ArgumentParser::GetSeparator(const char* ptr_separator_list)
{
  while (*ptr_separator_list)
  {
    if (*m_ptr_arg==*ptr_separator_list)
    {
      m_ptr_arg++;
      return true;
    }
    ptr_separator_list++;
  }
  return false;
}

const char* ArgumentParser::GetRemainingStuff()
{
  return m_ptr_arg;
}



bool get_switch(const char *&ptr_arg,const char *ptr_switch)
{
  int	lenght=strlen(ptr_switch);

  if ((!ptr_arg) || strncasecmp(ptr_arg,ptr_switch,lenght))
  {
    // Not a match
    return false;
  }
  // Validate the parameter
  ptr_arg+=lenght;
  return true;
}

std::string get_string(const char *&ptr_arg)
{
  if (!ptr_arg)	return 0;
  std::string stringValue=std::string(ptr_arg);
  ptr_arg+=stringValue.size();
  return stringValue;
}

int get_value(const char *&ptr_arg,long default_value)
{
  if (!ptr_arg)	return 0;
  char*ptr_end;
  long value=strtoul(ptr_arg,&ptr_end,10);
  if (ptr_arg==ptr_end)
  {
    value=default_value;
  }
  ptr_arg=ptr_end;
  return value;
}

double get_double(const char *&ptr_arg,double default_value)
{
  if (!ptr_arg)	return 0.0;
  char*ptr_end;
  double value=strtod(ptr_arg,&ptr_end);
  if (ptr_arg==ptr_end)
  {
    value=default_value;
  }
  ptr_arg=ptr_end;
  return value;
}



int ConvertAdress(const char *ptr_value)
{
  int		adress;
  int		base;
  char	car;

  if (ptr_value[0]=='$')
  {
    // Hexadecimal (Assembler style)
    base=16;
    ptr_value++;
  }
  else
  if ( (ptr_value[0]=='0') && (ptr_value[1]=='x') )
  {
    // Hexadecimal (C style)
    base=16;
    ptr_value+=2;
  }
  else
  {
    // Decimal
    base=10;
  }

  adress=0;
  while (car=*ptr_value++)
  {
    if ((car>='0') && (car<='9'))
    {
      adress*=base;
      adress+=car-'0';
    }
    else
    if ((car>='a') && (car<='f'))
    {
    if (base!=16)
    {
        ShowError("Only hexadecimal values prefixed by a '$' can contain letters");
    }
    adress*=base;
    adress+=car-'a'+10;
    }
    else
    if ((car>='A') && (car<='F'))
    {
        if (base!=16)
        {
        ShowError("Only hexadecimal values prefixed by a '$' can contain letters");
        }
        adress*=base;
        adress+=car-'A'+10;
    }
    else
    {
        ShowError("Unknow character in the adress value");
    }
  }

  if ((adress<0x0000) || (adress>0xFFFF))
  {
    ShowError("authorized adress range is $0000 to $FFFF");
  }

  return adress;
}


std::string StringFormat(const char* formatString,...)
{
  va_list		va;
  char		temp[4096];

  va_start(va,formatString);
  const int length=vsprintf(temp,formatString,va);
  va_end(va);
  if ((unsigned int)length>=sizeof(temp))
  {
    temp[sizeof(temp)-1]=0;
  }
  return std::string(temp);
}





class DataReader
{
public:
  DataReader(const void* ptr, size_t bufferSize);

  void SetPointer(const void* ptr, size_t bufferSize);
  const void *GetPointer() const;

  void SetEndian(bool isBigEndian);
  bool GetEndian() const;

  unsigned int GetValue(int sizeValue);

  uint8_t GetU8();
  uint16_t GetU16();

private:
  const unsigned char* m_CurPtr = nullptr;
  const unsigned char* m_EndPtr = nullptr;
  bool		             m_ReadBigEndian = false;
};

DataReader::DataReader(const void* ptr, size_t bufferSize)
{
  SetPointer(ptr, bufferSize);
}

void DataReader::SetPointer(const void* ptr, size_t bufferSize)
{
  m_CurPtr = (const unsigned char*)ptr;
  m_EndPtr = m_CurPtr + bufferSize;
}

const void *DataReader::GetPointer() const
{
  return m_CurPtr;
}

void DataReader::SetEndian(bool isBigEndian)
{
  m_ReadBigEndian=isBigEndian;
}

bool DataReader::GetEndian() const
{
  return m_ReadBigEndian;
}


uint8_t DataReader::GetU8()
{
  if (m_CurPtr < m_EndPtr)
  {
    return *m_CurPtr++;
  }
  return 0;
}

uint16_t DataReader::GetU16()
{
  return (uint16_t)GetValue(2);
}

unsigned int DataReader::GetValue(int sizeValue)
{
  unsigned int value = 0;
  if (m_CurPtr+sizeValue <= m_EndPtr)
  {  
    if (m_ReadBigEndian)
    {
      // Big endian
      // msb...lsb
      switch (sizeValue)
      {
      case 1:
        value|=(m_CurPtr[0]<<0);
        break;

      case 2:
        value|=(m_CurPtr[1]<<0);
        value|=(m_CurPtr[0]<<8);
        break;

      case 4:
        value|=(m_CurPtr[3]<<0);
        value|=(m_CurPtr[2]<<8);
        value|=(m_CurPtr[1]<<16);
        value|=(m_CurPtr[0]<<24);
      }
    }
    else
    {
      // Little endian
      // lsb...msb
      switch (sizeValue)
      {
      case 1:
        value|=(m_CurPtr[0]<<0);
        break;

      case 2:
        value|=(m_CurPtr[0]<<0);
        value|=(m_CurPtr[1]<<8);
        break;

      case 4:
        value|=(m_CurPtr[0]<<0);
        value|=(m_CurPtr[1]<<8);
        value|=(m_CurPtr[2]<<16);
        value|=(m_CurPtr[3]<<24);
      }
    }
    m_CurPtr += sizeValue;
  }
  return value;
}




TextFileGenerator::TextFileGenerator() :
  m_DataSize(1),
  m_FileType(_eLanguage_Undefined_),
  m_Endianness(_eEndianness_Little),
  m_NumericBase(_eNumericBase_Hexadecimal),
  m_ValuesPerLine(16),
  m_EnableLineNumber(false),
  m_FirstLineNumber(10),
  m_IncrementLineNumber(10),
  m_LabelName("DefaultLabelName")
{
}

TextFileGenerator::~TextFileGenerator()
{
}


std::string TextFileGenerator::ConvertData(const void* sourceData,size_t fileSize)
{
  std::string destString;

  if ( ((fileSize/m_DataSize)*m_DataSize)!=fileSize)
  {
    ShowError("The filesize must be a multiple of the data size.");
  }

  DataReader dataReader(sourceData, fileSize);
  if (m_Endianness==_eEndianness_Big)
  {
    dataReader.SetEndian(true);
  }
  else
  {
    dataReader.SetEndian(false);
  }

  std::string headerFormatString;
  std::string footerFormatString;
  std::string headerPreLine;
  std::string entryFormat;
  std::string entrySeparator;

  bool addSeparatorOnEndOfLine=false;

  switch (m_FileType)
  {
  case eLanguage_C:
    headerPreLine="\t";
    entrySeparator=",";
    addSeparatorOnEndOfLine=true;
    m_EnableLineNumber=false;
    switch (m_DataSize)
    {
    case 1:
      headerFormatString="unsigned char %s[%d]=\r\n{\r\n";	// unsigned char _SampleQuiTue[]={
      entryFormat="0x%02x";
      break;
    case 2:
      headerFormatString="unsigned short %s[%d]=\r\n{\r\n";	// unsigned short _SampleQuiTue[]={
      entryFormat="0x%04x";
      break;
    case 4:
      headerFormatString="unsigned long %s[%d]=\r\n{\r\n";	// unsigned long _SampleQuiTue[]={
      entryFormat="0x%08x";
      break;
    }
    footerFormatString="};";
    break;

  case eLanguage_Assembler:
    headerFormatString=m_LabelName+"\r\n";	// _SampleQuiTue
    entrySeparator=",";
    m_EnableLineNumber=false;
    switch (m_DataSize)
    {
    case 1:
      headerPreLine="\t.byt ";
      entryFormat="$%02x";
      break;
    case 2:
      headerPreLine="\t.word ";
      entryFormat="$%04x";
      break;
    case 4:
      headerPreLine="\t.long ";
      entryFormat="$%08x";
      break;
    }
    break;

  case eLanguage_BASIC:
    // Basic supports only uppercase hexadecimal letters !
    headerFormatString=StringFormat("%d REM %s \r\n",m_FirstLineNumber,m_LabelName.c_str());	// nnnn REM _SampleQuiTue
    m_FirstLineNumber+=m_IncrementLineNumber;
    headerPreLine="DATA ";
    entryFormat="#%d";
    m_EnableLineNumber=true;
    switch (m_DataSize)
    {
    case 1:
      entryFormat="#%02X";
      break;
    case 2:
      entryFormat="#%04X";
      break;
    case 4:
      entryFormat="#%08X";	// That one will probably fail on most 8 bits basics
      break;
    }
    entrySeparator=",";
    break;
  }

  if (m_NumericBase==_eNumericBase_Decimal)
  {
    // Set to decimal output
    entryFormat="%d";
  }

  int file_size=fileSize;
  int entryCount=(file_size+m_DataSize-1)/m_DataSize;

  // To avoid numerous memory allocation, pre allocate a string long enough
  destString="";
  destString.reserve(fileSize*5);

  // Block header
  destString+=StringFormat(headerFormatString.c_str(),m_LabelName.c_str(),entryCount);	// unsigned char _SampleQuiTue[]={
  while (file_size>0)
  {
    // Line numbers
    if (m_EnableLineNumber)
    {
      destString+=StringFormat("%d ",m_FirstLineNumber);
      m_FirstLineNumber+=m_IncrementLineNumber;
    }

    // Line header
    destString+=headerPreLine;

    // Content of the line
    for (unsigned long x=0;x<m_ValuesPerLine;x++)
    {
      unsigned long c=dataReader.GetValue(m_DataSize);
      file_size-=m_DataSize;
      destString+=StringFormat(entryFormat.c_str(),c);
      if ((x!=(m_ValuesPerLine-1)) && file_size)
      {
        destString+=entrySeparator;
      }
      if (file_size<=0)	break;
    }

    // Optional last separator (for C)
    if (addSeparatorOnEndOfLine && (file_size>0))
    {
      destString+=entrySeparator;
    }

    // End of line carriage return
    destString+="\r\n";
  }
  // Block footer
  destString+=footerFormatString;

  // End of file carriage return
  destString+="\r\n";

  return destString;
}


std::string ExpandFilePath(const std::string& sourceFile)
{
  char fullPathName[4096];
  fullPathName[0]=0;
#ifdef WIN32
  char* filePosition;
  GetFullPathName(sourceFile.c_str(),sizeof(fullPathName),fullPathName,&filePosition);
  if (filePosition)
  {
    // If there's a filename, cut it out.
    *filePosition=0;
  }
#endif
  return fullPathName;
}

int ExpandFileList(const std::string& sourceFile,std::vector<std::string>& resolvedFileList)
{
  resolvedFileList.clear();
#ifdef WIN32

  WIN32_FIND_DATA findData;
  HANDLE findhandle=FindFirstFile(sourceFile.c_str(),&findData);
  if (findhandle!=INVALID_HANDLE_VALUE)
  {
    do
    {
      resolvedFileList.push_back(findData.cFileName);
    }
    while (FindNextFile(findhandle,&findData));
    FindClose(findhandle);
  }
#endif
  return (int)resolvedFileList.size();
}



void SplitPath(const char* Path,char* Drive,char* Directory,char*Filename,char* Extension)
{
#ifdef WIN32
  _splitpath(Path,Drive,Directory,Filename,Extension);
#else
// From https://groups.google.com/forum/#!topic/gnu.gcc.help/0dKxhmV4voE
  char* CopyOfPath = (char*) Path;
  int Counter = 0;
  int Last = 0;
  int Rest = 0;

  // no drives available in linux .
  // extensions are not common in linux
  // but considered anyway
  Drive = NULL;

  while(*CopyOfPath != '\0')
  {
    // search for the last slash
    while(*CopyOfPath != '/' && *CopyOfPath != '\0')
    {
      CopyOfPath++;
      Counter++;
    }
    if(*CopyOfPath == '/')
    {
      CopyOfPath++;
      Counter++;
      Last = Counter;
    }
    else
      Rest = Counter - Last;
  }
  // directory is the first part of the path until the
  // last slash appears
  strncpy(Directory,Path,Last);
  // strncpy doesnt add a '\0'
  Directory[Last] = '\0';
  // Filename is the part behind the last slahs
  strcpy(Filename,CopyOfPath -= Rest);
  // get extension if there is any
  while(*Filename != '\0')
  {
    // the part behind the point is called extension in windows systems
    // at least that is what i thought apperantly the '.' is used as part
    // of the extension too .
    if(*Filename == '.')
    {
      while(*Filename != '\0')
      {
        *Extension = *Filename;
        Extension++;
        Filename++;
      }
    }
    if(*Filename != '\0')
    {Filename++;}
  }
  *Extension = '\0';
#endif
}


void MakePath(char* Path,const char* Drive,const char* Directory,const char* File,const char* Extension)
{
#ifdef WIN32
  _makepath(Path,Drive,Directory,File,Extension);
#else
// Abstract:   Make a path out of its parts
// Parameters: Path: Object to be made
//             Drive: Logical drive , only for compatibility , notconsidered
//             Directory: Directory part of path
//             Filename: File part of path
//             Extension: Extension part of path (includes the leading point)
// Returns:    Path is changed
// Comment:    Note that the concept of an extension is not available in Linux,
//             nevertheless it is considered
  while(*Drive != '\0' && Drive != NULL)
  {
    *Path = *Drive;
    Path++;
    Drive++;
  }
  while(*Directory != '\0' && Directory != NULL)
  {
    *Path = *Directory;
    Path ++;
    Directory ++;
  }
  while(*File != '\0' && File != NULL)
  {
    *Path = *File;
    Path ++;
    File ++;
  }
  while(*Extension != '\0' && Extension != NULL)
  {
    *Path = *Extension;
    Path ++;
    Extension ++;
  }
  *Path = '\0';
#endif
}



void PathSplitter::Split(const std::string &ref_filename)
{
  char source_drive[_MAX_DRIVE];
  char source_directory[_MAX_DIR];
  char source_name[_MAX_FNAME];
  char source_extension[_MAX_EXT];

  SplitPath(ref_filename.c_str(),source_drive,source_directory,source_name,source_extension);

  m_drive	=source_drive;
  m_directory	=source_directory;
  m_name	=source_name;
  m_extension	=source_extension;
}


bool PathSplitter::HasExtension(const char* extension) const
{
  return stricmp(m_extension.c_str(),extension)==0;
}


std::string GetCurrentDirectory()
{
  char buffer[FILENAME_MAX]; //create string buffer to hold path
#ifdef WIN32
  _getcwd(buffer, FILENAME_MAX);
#else
  getcwd(buffer, FILENAME_MAX);
#endif
  return buffer;
}

bool SetCurrentDirectory(const std::string& fullPath)
{
#ifdef WIN32
  return _chdir(fullPath.c_str()) == 0;
#else
  return chdir(fullPath.c_str()) == 0;
#endif
}


DirectoryChanger::DirectoryChanger()
{
  m_PreviousDirectory = GetCurrentDirectory();
}

DirectoryChanger::DirectoryChanger(const std::string& newPath)
{
  m_PreviousDirectory = GetCurrentDirectory();
  SetCurrentDirectory(newPath);
}


DirectoryChanger::~DirectoryChanger()
{
  SetCurrentDirectory(m_PreviousDirectory);
}



/*
      0x16,	// 0 Synchro
      0x16,	// 1
      0x16,	// 2
      0x24,	// 3

      0x00,	// 4
      0x00,	// 5

      0x80,	// 6

      0x00,	// 7  $80=BASIC Autostart $C7=Assembly autostart

      0xbf,	// 8  End address
      0x40,	// 9

      0xa0,	// 10 Start address
      0x00,	// 11

      0x00	// 12
*/

bool TapeHeader::Read(std::vector<unsigned char> buffer)
{
  return Read(buffer.data(), buffer.size());
}


bool TapeHeader::Read(const void* buffer,size_t bufferSize)
{
  DataReader dataReader(buffer, bufferSize);
  dataReader.SetEndian(true);

  // Skip synchronization bytes
  unsigned char syncBytes;
  while ((syncBytes=dataReader.GetU8()) == 0x16);
  if (syncBytes != 0x24)
  {
    //ShowError("bad header");
    return false;
  }

  dataReader.GetU8();  // Dummy byte
  dataReader.GetU8();  // Dummy byte

  unsigned char programType = dataReader.GetU8();  // $80=BASIC Autostart $C7=Assembly autostart
  unsigned char autoStart   = dataReader.GetU8();  // 
  uint16_t endAddress       = dataReader.GetU16();
  uint16_t startAddress     = dataReader.GetU16();

  dataReader.GetU8();  // Dummy byte

  // Fetch the name
  std::string name;
  unsigned char nameBytes;
  while (nameBytes = dataReader.GetU8())
  {
    name += nameBytes;
  };

  // Store the information
  if (programType == 0x80)
  {
    m_Type = eTypeBASIC;
  }
  else
  {
    m_Type = eTypeBinary;
  }

  if (autoStart == 0xC7)
  {
    m_AutoStart = true;
  }
  else
  {
    m_AutoStart = false;
  }

  m_Name         = name;
  m_StartAddress = startAddress;
  m_EndAddress   = endAddress;
  return true;
}

/*
bool TapeHeader::SkipSynchronizationBytes()
{
  // Skip synchronization bytes
// 16 16 16 24
  while (*ptr_header == 0x16)	ptr_header++;
  if (*ptr_header != 0x24)
  {
    ShowError("bad header");
  }

  return false;
}
*/
