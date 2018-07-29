
#ifndef _COMMON_H_
#define _COMMON_H_

#ifdef _MSC_VER
// Disable the warning C4706 -> assignment within conditional expression
// Allow us to use Warning level 4 instead of level 3
#pragma warning( disable : 4706)
#pragma warning( disable : 4786)	// Debug symbols thing
#pragma warning( disable : 4996)   // #define _CRT_SECURE_NO_WARNINGS
#endif


#include <string>
#include <vector>

#include <fcntl.h>

#ifndef O_BINARY
#define O_BINARY 0
#endif

#ifdef _WIN32
#define strncasecmp _strnicmp
#include <io.h>
#else
#include <unistd.h>
#endif

#if defined(__GNUC__) && __GNUC__ == 4 && __GNUC_MINOR__ < 6
#define nullptr (NULL)
#endif

//
// Debugging macros
//
#ifdef  _DEBUG
#define _BREAK_				__asm { int 3 }
#define _BREAK_IF_(cond)		if (cond) __asm { int 3 } else ((void)0)
#else
#define _BREAK_				((void)0)
#define _BREAK_IF_(cond)		((void)0)
#endif


//
// Argument parsing, error handling
//
void SetApplicationParameters(const char* pcApplicationName,int nVersionMajor,int nVersionMinor,const char* pcUsageMessage);

void ShowError(const char *pcMessage,...);


class ArgumentParser
{
public:
  ArgumentParser(int argc,char *argv[]);
  ~ArgumentParser() {}

  const char* GetParameter(int nParameterIndex);
  int GetParameterCount();

  bool ProcessNextArgument();

  bool IsSwitch(const char *ptr_switch);
  bool IsParameter();

  std::string GetStringValue();
  int GetIntegerValue(int default_value);
  bool GetBooleanValue(bool default_value);
  bool GetSeparator(const char* ptr_separator_list);
  const char* GetRemainingStuff();

private:
  ArgumentParser();

protected:
  int		m_argc;
  char**	m_argv;
  long		m_first_param;

  int		m_remaining_argc;
  long		m_nb_arg;
  const char*   m_ptr_arg;
};

bool get_switch(const char *&ptr_arg,const char *ptr_switch);
int get_value(const char *&ptr_arg,long default_value);
std::string get_string(const char *&ptr_arg);


//
// File loading and saving
//
bool LoadFile(const char* pcFileName,void* &pcBuffer,size_t &cBufferSize);
bool SaveFile(const char* pcFileName,const void* pcBuffer,size_t cBufferSize);
bool DeleteFile(const char* pcFileName);

bool LoadText(const char* pcFileName,std::vector<std::string>& cTextData);

bool IsUpToDate(const char* sourceFile,const char* targetFile);
bool IsUpToDate(const std::string& sourceFile,const std::string& targetFile);

//
// Batch processing
//
std::string ExpandFilePath(const std::string& sourceFile);
int ExpandFileList(const std::string& sourceFile,std::vector<std::string>& resolvedFileList);

//
// Directory management
//
void SplitPath(const char* Path,char* Drive,char* Directory,char*Filename,char* Extension);
void MakePath(char* Path,const char* Drive,const char* Directory,const char* File,const char* Extension);
int StringCheckFileExtensionList(const std::string& cCompleteFilePath,const std::string& cExtensionsToCheck);



class PathSplitter
{
public:
  PathSplitter()    
  {
    Clear();
  }

  PathSplitter(const std::string &ref_filename)    
  {
    Split(ref_filename);
  }		

  void Clear()
  {
    m_drive="";
    m_directory="";
    m_name="";
    m_extension="";
  }

  void Split(const std::string &ref_filename);

  std::string GetFullFileName() const     //!< Complete filename (including access path and extension)
  {
    return m_drive+m_directory+m_name+m_extension; 
  }

  std::string GetFilePath() const         //!< Drive letter and directory
  {
    return m_drive+m_directory; 
  }

  std::string GetFileNameExtension() const //!< Filename (including extension)
  {
    return m_name+m_extension; 
  }

  const std::string &GetDrive() const
  {
    return m_drive;
  }

  const std::string &GetDirectory() const
  {
    return m_directory;
  }

  const std::string &GetFileName() const   //!< Filename (without extension)
  {
    return m_name;
  }

  const std::string &GetExtension() const
  {
    return m_extension;
  }

  void SetExtension(const std::string& extension) 
  {
    m_extension=extension;
  }

  bool HasExtension(const char* extension) const;
  bool HasExtension(const std::string& extension) const  { return HasExtension(extension.c_str()); }


private:
  std::string	m_drive;	//!< Drive letter
  std::string	m_directory;	//!< Complete directory
  std::string	m_name;		//!< Name of the file (without extension)
  std::string   m_extension;	//!< Extension of the file (including the dot)
};



//
// Compression (moved out FilePack)
//
long LZ77_Compress(void *buf_src,void *buf_dest,long size_buf_src);
void LZ77_UnCompress(void *buf_src,void *buf_dest,long size);
long LZ77_ComputeDelta(unsigned char *buf_comp,long size_uncomp,long size_comp);
extern unsigned char gLZ77_XorMask;

//
// Preprocessing and filtering
//
int StringReplace(std::string& cMainString,const std::string& cSearchedString,const std::string& cReplaceString);
std::string StringTrim(const std::string& inputString,const std::string& filteredOutCharacterList=" \t\f\v\n\r");      ///< Returns a filtered out version of the input string not starting or ending with any of the filter list characters
std::string StringSplit(std::string& inputString,const std::string& filteredOutCharacterList =" \t\f\v\n\r");          ///< Search for the first character present in the filter list, extract this part from the input string and returns it (kind of like strtok)
std::string StringFormat(const char* pFormatString,...);
std::string StringMakeLabel(const std::string& sourceString);

int ConvertAdress(const char *ptr_value);

class TextFileGenerator
{
public:
  enum Language_e
  {
    _eLanguage_Undefined_,
    eLanguage_C,
    eLanguage_Assembler,
    eLanguage_BASIC
  };

  enum Endianness_e
  {
    _eEndianness_Undefined_,
    _eEndianness_Little,
    _eEndianness_Big
  };

  enum NumericBase_e
  {
    _eNumericBase_Undefined_,
    _eNumericBase_Hexadecimal,
    _eNumericBase_Decimal
  };

public:
  TextFileGenerator();
  ~TextFileGenerator();

  void SetDataSize(int nDataSize)			    { m_nDataSize=nDataSize; }
  void SetFileType(Language_e nFileType)		    { m_nFileType=nFileType; }
  void SetEndianness(Endianness_e nEndianness)		    { m_nEndianness=nEndianness; }
  void SetNumericBase(NumericBase_e nNumericBase)	    { m_nNumericBase=nNumericBase; }
  void SetValuesPerLine(unsigned int nValuesPerLine)	    { m_nValuesPerLine=nValuesPerLine; }
  void SetLabel(const std::string& cLabel)		    { m_cLabelName=cLabel; }
  void SetLineNumber(int nLineNumber)			    { m_nFirstLineNumber=nLineNumber; }
  void SetIncrementLineNumber(int nIncrementLineNumber)	    { m_nIncrementLineNumber=nIncrementLineNumber; }

  int GetDataSize()		    { return m_nDataSize; }
  Language_e GetFileType()	    { return m_nFileType; }
  Endianness_e GetEndianness()	    { return m_nEndianness; }
  NumericBase_e GetNumericBase()    { return m_nNumericBase; }
  unsigned int GetValuesPerLine()   { return m_nValuesPerLine; }
  const std::string& GetLabel()	    { return m_cLabelName; }
  int GetLineNumber()		    { return m_nFirstLineNumber; }
  int GetIncrementLineNumber()	    { return m_nIncrementLineNumber; }

  std::string ConvertData(const void* pSourceData,size_t nFileSize);

private:
  int		  m_nDataSize;
  Language_e	  m_nFileType;
  Endianness_e	  m_nEndianness;
  NumericBase_e	  m_nNumericBase;
  unsigned int	  m_nValuesPerLine;

  bool		  m_bEnableLineNumber;
  int		  m_nFirstLineNumber;
  int		  m_nIncrementLineNumber;

  std::string	  m_cLabelName;
};


#endif // _COMMON_H_
