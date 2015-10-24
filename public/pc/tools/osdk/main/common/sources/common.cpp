

#include "common.h"

#include <memory.h>
#include <stdlib.h>
#include <stdio.h>
#include <cctype>
#ifdef WIN32
/* for getch() */
#include <conio.h>
#include <windows.h>

#ifdef DeleteFile
#undef DeleteFile
#endif

#else
/* for getch() */
#include <curses.h>
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


void SetApplicationParameters(const char* pcApplicationName,int nVersionMajor,int nVersionMinor,const char* pcUsageMessage)
{
  g_cApplicationName=pcApplicationName;

  g_nVersionMajor=nVersionMajor;
  g_nVersionMinor=nVersionMinor;
  char cTempBuffer[256];
  sprintf(cTempBuffer,"%d.%03d",nVersionMajor,nVersionMinor);
  g_cVersionString=cTempBuffer;

  g_cUsageMessage=pcUsageMessage;
}



void ShowError(const char *pFormatString,...)
{
  std::string cErrorMessage;

  if (pFormatString)
  {
    // Message will be something like: "MyApplication.exe: Something goes wrong, sorry !"

    va_list va;
    char    temp[4096];

    va_start(va,pFormatString);
    int nChar=vsprintf(temp,pFormatString,va);
    va_end(va);
    if ((unsigned int)nChar>=sizeof(temp))
    {
      temp[sizeof(temp)-1]=0;
    }

    cErrorMessage=g_cApplicationName+": "+ temp;
  }
  else
  {
    cErrorMessage=g_cUsageMessage;
    StringReplace(cErrorMessage,"{ApplicationName}"	,g_cApplicationName);
    StringReplace(cErrorMessage,"{ApplicationVersion}"	,g_cVersionString);
  }

  // Show the resulting message on screen
  printf("\r\n%s\r\n",cErrorMessage.c_str());
  getch();
  exit(1);
}



bool LoadFile(const char* pcFileName,void* &pcBuffer,size_t &cBufferSize)
{
  // get the size of the file
  struct stat file_info;

  if (stat(pcFileName, &file_info)== -1)
  {
    return false;
  }

  // open the file
  cBufferSize=file_info.st_size;
  int nHandle=open(pcFileName,O_BINARY|O_RDONLY,0);
  if (nHandle==-1)
  {
    return false;
  }

  // allocate some memory
  pcBuffer=malloc(cBufferSize+1);
  if (!pcBuffer)
  {
    close(nHandle);
    return false;
  }

  // read file content
  if (read(nHandle,pcBuffer,cBufferSize)!=(int)cBufferSize)
  {
    free(pcBuffer);
    close(nHandle);
    return false;
  }
  close(nHandle);

  // Add a null terminator in the additional byte
  char *pcCharBuffer=(char*)pcBuffer;
  pcCharBuffer[cBufferSize]=0;

  return true;
}


bool SaveFile(const char* pcFileName,const void* pcBuffer,size_t cBufferSize)
{
  // Open file
  int nHandle=open(pcFileName,O_BINARY|O_WRONLY|O_TRUNC|O_CREAT,S_IREAD|S_IWRITE);
  if (nHandle==-1)
  {
    return false;
  }

  // Save data
  if (write(nHandle,pcBuffer,cBufferSize)!=(int)cBufferSize)
  {
    close(nHandle);
    return false;
  }

  // close handle
  close(nHandle);

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
bool LoadText(const char* pcFileName,std::vector<std::string>& cTextData)
{
  cTextData.clear();

  void* ptr_buffer_void;
  size_t file_size;
  if (!LoadFile(pcFileName,ptr_buffer_void,file_size))
  {
    return false;
  }

  const char *ptr_line=(const char *)ptr_buffer_void;
  const char *ptr_read=ptr_line;

  bool flag_new_line=true;

  int line_count=0;
  int longest_line=0;

  while (1)
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
        cTextData.push_back(new_line);

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

    /*
    switch (car)
    {
    case 0:
    case 0x0D:
    {
    //
    // Find a end of line.
    // Patch it with a "0"
    // and insert the line in the container
    //
    int size_line=ptr_read-ptr_line-1;
    std::string	new_line(ptr_line,size_line);
    cTextData.push_back(new_line);

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
    ptr_line=ptr_read;
    flag_new_line=true;
    }
    break;

    case 0x0A:
    if (flag_new_line)
    {
    //
    // Skip leading 0x0A
    //
    ptr_line++;
    }
    break;

    default:
    flag_new_line=false;
    break;
    }
    */
  }
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


int StringReplace(std::string& cMainString,const std::string& cSearchedString,const std::string& cReplaceString)
{
  int nReplaceCount=0;
  std::string::size_type pos=0;
  while (1)
  {
    pos=cMainString.find(cSearchedString,pos);
    if (pos==std::string::npos)
    {
      break;
    }
    cMainString.replace(pos,cSearchedString.size(),cReplaceString);
    pos+=cReplaceString.size();
    ++nReplaceCount;
  }
  return nReplaceCount;
}

std::string StringTrim(const std::string& cInputString,const std::string& cFilteredOutCharacterList)
{
  size_t nStartPos=cInputString.find_first_not_of(cFilteredOutCharacterList);
  if (nStartPos!=std::string::npos)
  {
    size_t nEndPos=cInputString.find_last_not_of(cFilteredOutCharacterList);
    if (nEndPos!=std::string::npos) 
    {
      return cInputString.substr(nStartPos,(nEndPos-nStartPos)+1);
    }
  }
  // Returns an empty string: This case means that basically the input string contains ONLY characters that needed to be filtered out
  return "";
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

const char* ArgumentParser::GetParameter(int nParameterIndex)
{
  int nIndex=m_first_param+nParameterIndex;
  if (nIndex>=m_argc)
  {
    // Wrong !
    return "";
  }
  return m_argv[nIndex];
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
  char cCar=*m_ptr_arg;
  if ((!cCar) || (cCar=='-'))
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

bool ArgumentParser::GetBooleanValue(bool default_value)
{
  int nValue;
  if (default_value)	nValue=1;
  else				nValue=0;
  nValue=::get_value(m_ptr_arg,nValue);
  if (nValue)	return true;
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
  std::string cStringValue=std::string(ptr_arg);
  ptr_arg+=cStringValue.size();
  return cStringValue;
}

int get_value(const char *&ptr_arg,long default_value)
{
  char*ptr_end;
  long value;

  if (!ptr_arg)	return 0;
  value=strtoul(ptr_arg,&ptr_end,10);
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


std::string StringFormat(const char* pFormatString,...)
{
  va_list		va;
  char		temp[4096];

  va_start(va,pFormatString);
  int nChar=vsprintf(temp,pFormatString,va);
  va_end(va);
  if ((unsigned int)nChar>=sizeof(temp))
  {
    temp[sizeof(temp)-1]=0;
  }
  return std::string(temp);
}





class DataReader
{
public:
  DataReader();
  ~DataReader();

  void SetPointer(const void* ptr);
  const void *GetPointer();

  void SetEndian(bool bIsBigEndian);
  bool GetEndian();

  unsigned int GetValue(int nSizeValue);

private:
  const void*	m_ptr;
  bool		m_bReadBigEndian;
};

DataReader::DataReader() :
  m_ptr(0),
  m_bReadBigEndian(false)
{
}

DataReader::~DataReader()
{
}

void DataReader::SetPointer(const void* ptr)
{
  m_ptr=ptr;
}

const void *DataReader::GetPointer()
{
  return m_ptr;
}

void DataReader::SetEndian(bool bIsBigEndian)
{
  m_bReadBigEndian=bIsBigEndian;
}

bool DataReader::GetEndian()
{
  return m_bReadBigEndian;
}

unsigned int DataReader::GetValue(int nSizeValue)
{
  unsigned int nvalue=0;
  unsigned char* ptr=(unsigned char*)m_ptr;

  if (m_bReadBigEndian)
  {
    // Big endian
    // msb...lsb
    switch (nSizeValue)
    {
    case 1:
      nvalue|=(ptr[0]<<0);
      break;

    case 2:
      nvalue|=(ptr[1]<<0);
      nvalue|=(ptr[0]<<8);
      break;

    case 4:
      nvalue|=(ptr[3]<<0);
      nvalue|=(ptr[2]<<8);
      nvalue|=(ptr[1]<<16);
      nvalue|=(ptr[0]<<24);
    }
  }
  else
  {
    // Little endian
    // lsb...msb
    switch (nSizeValue)
    {
    case 1:
      nvalue|=(ptr[0]<<0);
      break;

    case 2:
      nvalue|=(ptr[0]<<0);
      nvalue|=(ptr[1]<<8);
      break;

    case 4:
      nvalue|=(ptr[0]<<0);
      nvalue|=(ptr[1]<<8);
      nvalue|=(ptr[2]<<16);
      nvalue|=(ptr[3]<<24);
    }
  }

  ptr+=nSizeValue;
  m_ptr=(void*)ptr;
  return nvalue;
}




TextFileGenerator::TextFileGenerator() :
  m_nDataSize(1),
  m_nFileType(_eLanguage_Undefined_),
  m_nEndianness(_eEndianness_Little),
  m_nNumericBase(_eNumericBase_Hexadecimal),
  m_nValuesPerLine(16),
  m_bEnableLineNumber(false),
  m_nFirstLineNumber(10),
  m_nIncrementLineNumber(10),
  m_cLabelName("DefaultLabelName")
{
}

TextFileGenerator::~TextFileGenerator()
{
}


std::string TextFileGenerator::ConvertData(const void* pSourceData,size_t nFileSize)
{
  std::string cDestString;

  if ( ((nFileSize/m_nDataSize)*m_nDataSize)!=nFileSize)
  {
    ShowError("The filesize must be a multiple of the data size.");
  }

  DataReader cDataReader;

  cDataReader.SetPointer(pSourceData);
  if (m_nEndianness==_eEndianness_Big)
  {
    cDataReader.SetEndian(true);
  }
  else
  {
    cDataReader.SetEndian(false);
  }

  std::string cHeaderFormatString;
  std::string cFooterFormatString;
  std::string cHeaderPreLine;
  std::string cEntryFormat;
  std::string cEntrySeparator;

  bool bAddSeparatorOnEndOfLine=false;

  switch (m_nFileType)
  {
  case eLanguage_C:
    cHeaderPreLine="\t";
    cEntrySeparator=",";
    bAddSeparatorOnEndOfLine=true;
    m_bEnableLineNumber=false;
    switch (m_nDataSize)
    {
    case 1:
      cHeaderFormatString="unsigned char %s[%d]=\r\n{\r\n";	// unsigned char _SampleQuiTue[]={
      cEntryFormat="0x%02x";
      break;
    case 2:
      cHeaderFormatString="unsigned short %s[%d]=\r\n{\r\n";	// unsigned short _SampleQuiTue[]={
      cEntryFormat="0x%04x";
      break;
    case 4:
      cHeaderFormatString="unsigned long %s[%d]=\r\n{\r\n";	// unsigned long _SampleQuiTue[]={
      cEntryFormat="0x%08x";
      break;
    }
    cFooterFormatString="};";
    break;

  case eLanguage_Assembler:
    cHeaderFormatString=m_cLabelName+"\r\n";	// _SampleQuiTue
    cEntrySeparator=",";
    m_bEnableLineNumber=false;
    switch (m_nDataSize)
    {
    case 1:
      cHeaderPreLine="\t.byt ";
      cEntryFormat="$%02x";
      break;
    case 2:
      cHeaderPreLine="\t.word ";
      cEntryFormat="$%04x";
      break;
    case 4:
      cHeaderPreLine="\t.long ";
      cEntryFormat="$%08x";
      break;
    }
    break;

  case eLanguage_BASIC:
    // Basic supports only uppercase hexadecimal letters !
    cHeaderFormatString=StringFormat("%d REM %s \r\n",m_nFirstLineNumber,m_cLabelName.c_str());	// nnnn REM _SampleQuiTue
    m_nFirstLineNumber+=m_nIncrementLineNumber;
    cHeaderPreLine="DATA ";
    cEntryFormat="#%d";
    m_bEnableLineNumber=true;
    switch (m_nDataSize)
    {
    case 1:
      cEntryFormat="#%02X";
      break;
    case 2:
      cEntryFormat="#%04X";
      break;
    case 4:
      cEntryFormat="#%08X";	// That one will probably fail on most 8 bits basics
      break;
    }
    cEntrySeparator=",";
    break;
  }

  if (m_nNumericBase==_eNumericBase_Decimal)
  {
    // Set to decimal output
    cEntryFormat="%d";
  }

  int file_size=nFileSize;
  int nEntryCount=(file_size+m_nDataSize-1)/m_nDataSize;

  // To avoid numerous memory allocation, pre allocate a string long enough
  cDestString="";
  cDestString.reserve(nFileSize*5);

  // Block header
  cDestString+=StringFormat(cHeaderFormatString.c_str(),m_cLabelName.c_str(),nEntryCount);	// unsigned char _SampleQuiTue[]={
  while (file_size>0)
  {
    // Line numbers
    if (m_bEnableLineNumber)
    {
      cDestString+=StringFormat("%d ",m_nFirstLineNumber);
      m_nFirstLineNumber+=m_nIncrementLineNumber;
    }

    // Line header
    cDestString+=cHeaderPreLine;

    // Content of the line
    for (unsigned long x=0;x<m_nValuesPerLine;x++)
    {
      unsigned long c=cDataReader.GetValue(m_nDataSize);
      file_size-=m_nDataSize;
      cDestString+=StringFormat(cEntryFormat.c_str(),c);
      if ((x!=(m_nValuesPerLine-1)) && file_size)
      {
        cDestString+=cEntrySeparator;
      }
      if (file_size<=0)	break;
    }

    // Optional last separator (for C)
    if (bAddSeparatorOnEndOfLine && (file_size>0))
    {
      cDestString+=cEntrySeparator;
    }

    // End of line carriage return
    cDestString+="\r\n";
  }
  // Block footer
  cDestString+=cFooterFormatString;

  // End of file carriage return
  cDestString+="\r\n";

  return cDestString;
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


