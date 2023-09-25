/*

The 6502 Linker, for the lcc or similar, that produce .s files to be processed later by a cross assembler
(See infos.h for details and version history)

*/
#include "infos.h"

#define _GNU_SOURCE 1 /* for fcloseall() */
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <memory.h>
#include <ctype.h>

#ifndef POSIX
#include <direct.h>
#else
#include <unistd.h>
#include <limits.h>
#define stricmp strcasecmp
#define _MAX_PATH PATH_MAX
#endif


#include "common.h"

// Disable the warning C4706 -> assignment within conditional expression
// Allow us to use Warning level 4 instead of level 3
#pragma warning( disable : 4706)
#pragma warning( disable : 4786)	// Debug symbols thing

#include <vector>
#include <string>
#include <set>
#include <cctype>
#include <map>

#define NB_ARG	2


#define MAX_LINE_SIZE	4096	// XA is limited to 2048


enum LabelState
{
  e_NoLabel,
  e_NewLabel,
  e_LabelReference
};



// Structure for labels in a pair of : label_name/resolved_flag
struct ReferencedLabelEntry
{
  bool		    m_IsResolved = false;
  std::string label_name;
  std::string file_name;
  int         line_number = 0;
  int         reference_count = 0;
};

// Lib index structure in pair of : label_name/file_containing_label
struct LabelEntry
{
  std::string label_name;
  std::string file_name;
};

class FileEntry
{
public:
  std::string	m_FileName;
  int			    m_SortPriority = 0;  ///< 1 for file given in command line or 0 for files given from lib file index, 2 for tail. It's used for sort...
};



const char* gLabelPattern=" *+-;:\\\n/\t,()";




class Linker : public ArgumentParser
{
public:
  Linker(int argc, char* argv[])
    : ArgumentParser(argc, argv)
  {
  }

  int Main();

  bool ParseFile(const std::string& filename, const std::vector<std::string>& searchPaths);
  LabelState Parseline(char* inpline, bool parseIncludeFiles);

  bool LoadLibrary(const std::string& path_library_files);

  void AddInputFile(const std::string& filePath, int sortPriority);

  void FilterLine(const std::string& sourceLine, bool keepQuotedStrings);

public:
  bool m_FlagKeepComments = false;			        ///< Use -C option to control
  bool m_FlagIncludeHeader = true;			        ///< Use -B option to force to 0
  bool m_FlagEnableFileDirective = false;	      ///< Use -F option to enable (force to one)
  bool m_FlagVerbose = false;				            ///< Use -V option to enable
  bool m_FlagQuiet = false;					            ///< Use -Q option to enable (note: seems to work the other way arround !)
  bool m_FlagLibrarian = false;				          ///< Use -L option to enable

  char *m_CurrentToken = nullptr;               ///< Contains the last value read from strtok while parsing files

  // Init the path_library_files variable with default library directory and the output_file_name var with the default go.s
  std::string m_PathLibraryFiles = "lib6502\\";         ///< Directory to find library files (Set by -d)
  std::string m_PathSourceFiles = "";                   ///< Directory to find source files (set by -s)
  std::vector<std::string> m_PathHeaderFiles = {""};    ///< Directories to find header files (set by -i)
  std::string m_OutputFileName = "go.s";                ///< Output file (set by -o)

  bool m_FlagInCommentBloc = false;			                    ///< Used by the parser to know that we are currently parsing a bloc of comments
  const char* m_InputLinePtr = nullptr;                     ///< Used by the parser to fetch characters from the source
  std::string m_FilteredLine;                               ///< Contains the output after FilterLine has been called
  std::map<std::string, std::string>  m_StringReplacement;  ///< Used for fancy manipulations of text, including localization (replacing accentuated characters by others)

  std::vector<FileEntry>			m_InputFileList;                ///< contains filenames to be linked based on 'm_SortPriority' for the order.
  std::vector<LabelEntry>			m_LibraryReferencesList;
  std::vector<ReferencedLabelEntry>	m_ReferencedLabelsList;
  std::set<std::string>				m_DefinedLabelsList;
};


void Linker::FilterLine(const std::string& sourceLine,bool keepQuotedStrings)
{
  m_FilteredLine.clear();
  m_FilteredLine.reserve(MAX_LINE_SIZE);

  bool foundNonWhiteSpace = false;
  m_InputLinePtr=sourceLine.c_str();
  while (char car=*m_InputLinePtr++)
  {
    if (m_FlagInCommentBloc)						// In a C block comment - that one may have been started on another line
    {
      if ( (car=='*') && (*m_InputLinePtr=='/') )
      {
        // Found end of C block comment
        m_InputLinePtr++;
        m_FlagInCommentBloc=false;
      }
    }
    else
    {
      if ((car == ' ') || (car == '\t'))
      {
        // White space
        m_FilteredLine += car;
      }
      else
      {
        // Not white space
        if (car == '#')
        {
          bool addCar = true;
          if (!foundNonWhiteSpace)
          {
            // This # is the first character of the line, so it must be a #define, #include, #ifdef, #pragma, etc...
            std::string line(StringTrim(m_InputLinePtr));
            std::string token = StringTrim(StringSplit(line, " \t"));
            if (token=="pragma")
            {
              token = StringTrim(StringSplit(line, " \t"));
              if (token == "osdk")
              {
                token = StringTrim(StringSplit(line, " \t"));
                if (token == "replace_characters")
                {
                  m_StringReplacement.clear();

                  std::string separator = StringTrim(StringSplit(line, " \t"));
                  if (!separator.empty())
                  {                
                    while (true)
                    {
                      std::string replacementPair = StringTrim(StringSplit(line, " \t"));
                      if (replacementPair.empty())
                      {
                        break;
                      }
                      std::string searchedToken = StringTrim(StringSplit(replacementPair, separator));
                      std::string replaceToken = replacementPair;
                      m_StringReplacement[searchedToken] = replaceToken;
                    }
                  }
                }
                m_InputLinePtr = sourceLine.c_str() + sourceLine.length();
                addCar = false;
              }
            }
            foundNonWhiteSpace = foundNonWhiteSpace;
          }

          if (addCar)
          {
            // Probably a # in some immediate assembler value
            m_FilteredLine += car;
          }
        }
        else
        if (car=='\"')
        {
          // Found start of quoted string
          do
          {
            if (keepQuotedStrings)
            {
              m_FilteredLine+=car;
            }
            car=*m_InputLinePtr++;
          }
          while (car && (car!='\"'));
          if (car && keepQuotedStrings)
          {
            m_FilteredLine+=car;
          }
        }
        else
        if (car==';')
        {
          // Found start of assembler line comment - just stop here
          return;
        }
        else
        if ( (car=='/') && (*m_InputLinePtr=='*') )
        {
          // Found start of C block comment
          m_InputLinePtr++;
          m_FlagInCommentBloc=true;
        }
        else
        if ( (car=='/') && (*m_InputLinePtr=='/') )
        {
          // Found start of C++ line comment - just stop here
          return;
        }
        else
        {
          // Any other character
          m_FilteredLine+=car;
        }
        foundNonWhiteSpace = true;
      }
    }
  }

  // Definitely not optimal: If a replacement table is active, just brute force replacing the characters
  if (!m_StringReplacement.empty())
  {
    for (const auto& replacementPair : m_StringReplacement)
    {
      StringReplace(m_FilteredLine, replacementPair.first, replacementPair.second);
    }
  }
}


void Linker::AddInputFile(const std::string& filePath, int sortPriority)
{
  FileEntry fileEntry;
  fileEntry.m_FileName = filePath;
  fileEntry.m_SortPriority = sortPriority;
  m_InputFileList.push_back(fileEntry);
}

//
// Parse a line. Mask out comment lines and null lines.
// Clear ending comments.
// Return defined labels in label var, with return value of 1
// Return labels used by JSR, JMP, LDA, STA in label var, with ret value of 2
//
LabelState Linker::Parseline(char* inpline,bool parseIncludeFiles)
{
  const int len=strlen(inpline);

  //
  // Return if comment line or too small line
  //
  if (inpline[0] ==';')	  return e_NoLabel;
  if (len < 2)		        return e_NoLabel;

  //
  // Is a label defined..? (first char in line is what we want)
  //
  if ((inpline[0] !=' ') && (inpline[0] != 9))
  {
    m_CurrentToken=strtok(inpline,gLabelPattern);
    if (!m_CurrentToken)
    {
      //
      // No token was found
      //
      return e_NoLabel;
    }

    if (m_CurrentToken[0]=='#')
    {
      //
      // It's a preprocessor directive
      //
      if (!stricmp(m_CurrentToken,"#define"))	// MIKE: Do not need problems with #define (for XA equates)
      {
        //
        // #define is always followed by something that can be considered as a label.
        // For the linker that means that we have to add this 'label' in the list of
        // things to consider as internal linkage. (no need to lookup in the librarie)
        //
        // Read define name
        m_CurrentToken=strtok(NULL,gLabelPattern);
        return e_NewLabel;
      }
      else if (!stricmp(m_CurrentToken,"#include"))
      {
        //
        // Problem with #include is that they may contain labels,
        // but we do not want to insert the content of the file,
        // so basically we should just recurse on the name without
        // including the content.
        // A kind of "label eater", really.
        //
        // Read define name
        //const char* pcFilename=strtok(NULL," \"*+-;\\\n/\t,()");
        const char* filename=strtok(NULL," \"<>");
        if (parseIncludeFiles)
        {
          if (!filename)
          {
            ShowError("Invalid or missing filename after #include directive");
          }
          else
          {
            ParseFile(filename, m_PathHeaderFiles);
          }
        }
        return e_NoLabel;
      }
      //
      // Other '#' directives are not considered as labels.
      //
      return e_NoLabel;
    }
    else
    if ((m_CurrentToken[0]=='.') && ((m_CurrentToken[1]=='(') || (m_CurrentToken[1]==')')) )
    {
      // Opening or closing a local scope, not considered as label
      return e_NoLabel;
    }
    else
    {
      //
      // Something else (probably a label)
      //
      return e_NewLabel;
    }
  }

  //
  // Check for JMP or JSR and for the following label
  //
  int status = 0;
  char* tmp=strtok(inpline,gLabelPattern);
  while (tmp != NULL)
  {
    if (status == 1)
      break;

    if (!stricmp(tmp,"JSR"))		status = 1;
    else
    if (!stricmp(tmp,"JMP"))		status = 1;
    else
    if (!stricmp(tmp,"LDA"))		status = 1;
    else
    if (!stricmp(tmp,"STA"))		status = 1;
    else
    if (!stricmp(tmp,"LDX"))		status = 1;
    else
    if (!stricmp(tmp,"STX"))		status = 1;
    else
    if (!stricmp(tmp,"LDY"))		status = 1;
    else
    if (!stricmp(tmp,"STY"))		status = 1;

    //
    // Get next token in same line. This is the way strtok works
    //
    tmp=strtok(NULL,gLabelPattern);
  }
  if (tmp)
  {
    if ((status == 1)  && tmp[0] != '$' && tmp[0] != '(' && tmp[0] != '#' && !isdigit(tmp[0]))
    {
      m_CurrentToken = tmp;
      return e_LabelReference;
    }
    if ((status == 1) && (tmp[0] == '#') )
    {
      if (tmp[1] == 'H' || tmp[1] == 'L')
      {
        //
        // HIGH / LOW syntax
        //
        tmp=strtok(NULL," *+-;:\\\n/\t,()<>");
        if (tmp != NULL && tmp[0] != '$' && tmp[0] != '(' && tmp[0] != '#' && !isdigit(tmp[0]))
        {
          m_CurrentToken=tmp;
          return e_LabelReference;
        }
      }
      else
      if (tmp[1]=='<' || tmp[1]=='>')
      {
        // < / > syntax
        if (tmp[2])
        {
          tmp+=2;
        }
        else
        {
          tmp=strtok(NULL," *+-;:\\\n/\t,()<>");
        }

        if (tmp != NULL && tmp[0] != '$' && tmp[0] != '(' && tmp[0] != '#' && !isdigit(tmp[0]))
        {
          m_CurrentToken=tmp;
          return e_LabelReference;
        }
      }
    }
  }
  return e_NoLabel;
}



bool Linker::ParseFile(const std::string& filename, const std::vector<std::string>& searchPaths)
{
  std::vector<std::string> textData;
  for (const auto& path : searchPaths)
  {
    if (LoadText(path+filename, textData))
    {
      break;
    }
  }
  if (textData.empty())
  {
    ShowError("\nCannot open %s \n", filename.c_str());
  }

  if (m_FlagVerbose)
    printf("\nScanning file %s " ,filename.c_str());

  bool parseIncludeFiles=false;
  size_t sizeFileName=filename.size();
  if ( (sizeFileName>=2) && 
       (filename[sizeFileName-2]=='.') &&
       std::tolower(filename[sizeFileName-1]=='s')
     )   // Quick hack, we parse the includes in the assembler files, need proper detection of format
  {
    parseIncludeFiles=true;
  }

  // Scanning the file
  m_FlagInCommentBloc = false;
  int line_number = 0;
  for (const std::string& currentLine : textData)
  {
    //  Get line file and parse it
    ++line_number;

    // test
#if 0
    if (currentLine.find("_califragilistic")!=std::string::npos)
    {
      i=0;
    }
#endif

    FilterLine(currentLine, true/*false*/);  // removing quoted strings unfortunately fails on #include...
    std::string filteredLine = m_FilteredLine;

    char inpline[MAX_LINE_SIZE+1];
    assert(sizeof(inpline)>filteredLine.size());
    strncpy(inpline,filteredLine.c_str(),MAX_LINE_SIZE);
    inpline[MAX_LINE_SIZE]=0;
    
    char* nexToken=inpline-1;
    while (nexToken)
    {
      char* tokenPtr=nexToken+1;
      nexToken=strchr(tokenPtr,':');
      LabelState state=Parseline(tokenPtr,parseIncludeFiles);

      std::string foundLabel;
      if ((state!=e_NoLabel) && m_CurrentToken)
      {
        foundLabel=m_CurrentToken;
      }

      //  Oh, a label defined. Stuff it in storage
      if (state == e_NewLabel)
      {
        if (m_DefinedLabelsList.find(foundLabel) != m_DefinedLabelsList.end())
        {
          // Found the label in the list.
          // It's a duplicate definition... does not mean it's an error, because XA handles allows local labels !
          //printf("\nError ! Duplicate label : %s\n",label);
          //outall();
          //exit(1);
          //break;
        }
        else
        {
          // Insert new label in the set
          m_DefinedLabelsList.insert(foundLabel);
        }
      }
      else
      if (state == e_LabelReference)
      {
        // A label reference.
        // Store it if not already in list.
        bool undefinedLabel=true;
        for (auto& labelEntry : m_ReferencedLabelsList)
        {
          if (labelEntry.label_name == foundLabel)
          {
            ++labelEntry.reference_count;    // One more reference
            undefinedLabel=false;
            break;
          }
        }

        if (undefinedLabel)
        {
          // Allocate memory for label name and store it
          ReferencedLabelEntry labelEntry;
          labelEntry.label_name		 = foundLabel;
          labelEntry.m_IsResolved  = false;
          labelEntry.file_name     = filename;         // Store the filename of the first reference to the label
          labelEntry.line_number   = line_number;      // as well as the line number, to make it easier to locate issue
          labelEntry.reference_count = 1;

          m_ReferencedLabelsList.push_back(labelEntry);
        }
      }
    }
  }

  return true;
}




bool Linker::LoadLibrary(const std::string& path_library_files)
{
  std::string ndxstr=path_library_files+"library.ndx";

  std::vector<std::string> textData;
  if (!LoadText(ndxstr.c_str(),textData))
  {
    ShowError("Cannot open Index file : %s \n",ndxstr.c_str());
  }

  if (m_FlagVerbose)
    printf("Reading lib index file\n");

  LabelEntry labelEntry;
  labelEntry.file_name	="";
  labelEntry.label_name	="";

  for (const std::string& lineEntry : textData)
  {
    //  Get line file and parse it
    std::string currentLine=StringTrim(lineEntry);

    if (!currentLine.empty())
    {
      // Lines that indicate files start with -
      if (currentLine[0] == '-')
      {
        // Found a file indicator. Check if already used, if not start using it in table
        labelEntry.file_name=path_library_files+(currentLine.c_str()+1);
        // check for duplicate
        for (const LabelEntry& existingEntry : m_LibraryReferencesList)
        {
          if (labelEntry.file_name == existingEntry.file_name)
          {
            ShowError("Duplicate file %s in lib index\n",labelEntry.file_name.c_str());
          }
        }
      }
      else
      {
        // Found a label. Check if already used, if not put it in table
        if (labelEntry.file_name.size()<2)
        {
          ShowError("Error with file line indicator\n");
        }

        labelEntry.label_name=currentLine;

        // Check if label is duplicate
        for (const LabelEntry& existingEntry : m_LibraryReferencesList)
        {
          if (labelEntry.label_name == existingEntry.label_name)
          {
            ShowError("Duplicate label %s in lib index file\n",labelEntry.label_name.c_str());
          }
        }

        // One more entry in the table
        m_LibraryReferencesList.push_back(labelEntry);
      }
    }
  }

  return true;
}





int Linker::Main()
{
  while (ProcessNextArgument())
  {
    if (IsSwitch("-q") || IsSwitch("-Q"))
    {
      // Quiet mode.
      m_FlagQuiet=true;
    }
    else
    if (IsSwitch("-l") || IsSwitch("-L"))
    {
      // Print out defined labels (Useful when building lib index files)
      m_FlagLibrarian=true;
    }
    else
    if (IsSwitch("-v") || IsSwitch("-V"))
    {
      // Verbose output.
      m_FlagVerbose=true;
    }
    else
    if (IsSwitch("-d") || IsSwitch("-D"))
    {
      // Directory to find library files.Next arg in line is the dir name. e.g : link65 -d /usr/oric/lib/ test.s
      if (!ProcessNextArgument() || !IsParameter())
      {
        printf(" Must have dir name after -d option\n");
        exit(1);
      }
      m_PathLibraryFiles=GetStringValue();
    }
    else
    if (IsSwitch("-s") || IsSwitch("-S"))
    {
      // Directory to find source files.Next arg in line is the dir name
      if (!ProcessNextArgument() || !IsParameter())
      {
        printf(" Must have dir name after -s option\n");
        exit(1);
      }
      m_PathSourceFiles=GetStringValue();
    }
    else
    if (IsSwitch("-i") || IsSwitch("-I"))
    {
      // Directory to find header  files.Next arg in line is the dir name
      if (!ProcessNextArgument() || !IsParameter())
      {
        printf(" Must have dir name after -i option\n");
        exit(1);
      }
      m_PathHeaderFiles.push_back(GetStringValue());
    }
    else
    if (IsSwitch("-o") || IsSwitch("-O"))
    {
      // Output file. Default is go.s . Next arg in line is the file name. e.g : link65 -o out.s test.s
      if (!ProcessNextArgument() || !IsParameter())
      {
        printf(" Must have file name after -o option\n");
        exit(1);
      }
      m_OutputFileName=GetStringValue();
    }
    else
    if (IsSwitch("-b") || IsSwitch("-B"))
    {
      // Bare linking, does not add "header" and "tail" to the list
      m_FlagIncludeHeader=false;
    }
    else
    if (IsSwitch("-f") || IsSwitch("-F"))
    {
      // Enable the #file directive (require expanded XA assembler)
      m_FlagEnableFileDirective=true;
    }
    else
    if (IsParameter())
    {
      // Not a switch
      if (m_FlagIncludeHeader && m_InputFileList.empty())
      {
        // header.s is the first file used.
        // So reserve the 0 place in array for after option scanning, to put there the dir name too if needed.
        AddInputFile(m_PathLibraryFiles + "header.s" ,0);
      }

      //
      // Then we add the new file
      //
      AddInputFile(m_PathSourceFiles + GetStringValue(), 1);
    }
    else
    if (IsSwitch("-c"))
    {
      //comments: [-c]
      //	0 => remove comments
      // 	1 => keep comments
      m_FlagKeepComments=GetBooleanValue(false);
    }
    else
    {
      // Unknown argument
      printf("Invalid option %s \n",GetRemainingStuff());
      exit(1);
    }
  }

  if (GetParameterCount())
  {
    ShowError(0);
  }


  if (!m_FlagQuiet)
  {
    printf("\nLink65: 6502 Linker, by Vagelis Blathras. Version %d.%3d\n\n",TOOL_VERSION_MAJOR,TOOL_VERSION_MINOR);
  }


  if (m_FlagIncludeHeader)
  {
    // Now put the tail.s .
    // Give it nflist of 2 to put it last in file list after the sort
    AddInputFile(m_PathLibraryFiles + "tail.s", 2);
  }


  // Open and scan Index file for labels - file pair list
  LoadLibrary(m_PathLibraryFiles);

  // Scanning files loop
  for (unsigned int k=0;k<m_InputFileList.size();k++)
  {
    // Skip header.s file if gFlagLibrarian option is on
    if (m_FlagLibrarian && k == 0)
    {
      k=1;
    }

    ParseFile(m_InputFileList[k].m_FileName, {""});

    //
    // Check if used labels are defined inside the files
    //
    for  (ReferencedLabelEntry& labelEntry : m_ReferencedLabelsList)
    {
      if (m_DefinedLabelsList.find(labelEntry.label_name) != m_DefinedLabelsList.end())
      {
        // Found the label in the definition list
        labelEntry.m_IsResolved=true;
      }
    }

    if (!m_FlagLibrarian)
    {
      // Check for not resolved labels.
      // If defined in lib file index then insert their file right after in the list
      for (const ReferencedLabelEntry& referencedLabelEntry : m_ReferencedLabelsList)
      {
        // Unresolved label and -l option off. If -l option is on don't care
        if (!referencedLabelEntry.m_IsResolved)
        {
          // Act for unresolved label
          for (const LabelEntry& labelEntry : m_LibraryReferencesList)
          {
            // If in lib file index, take file and put it in gInputFileList if not already there
            if (referencedLabelEntry.label_name==labelEntry.label_name)
            {
              bool labstate=true;
              for (const FileEntry& fileEntry : m_InputFileList)
              {
                if (fileEntry.m_FileName==labelEntry.file_name)
                {
                  labstate=false;
                  break;
                }
              }

              // Not present : labstate == 1 , insert file in list
              if (labstate)
              {
                FileEntry	newEntry;
                m_InputFileList.push_back(newEntry);

                // NICE TRICK : Insert lib file in file list to be processed immediately.
                // With this labels used by the lib file will be resolved, without the need for multiple passes
                for (unsigned int l=m_InputFileList.size()-1;l>k+1;l--)
                {
                  m_InputFileList[l] = m_InputFileList[l-1];
                }
                FileEntry& fileEntry      = m_InputFileList[k+1];
                fileEntry.m_FileName      = labelEntry.file_name;
                fileEntry.m_SortPriority  = 1;
              }
              else
              {
                break;
              }
            }
          }
        }
      }
    }
  }

  if (m_FlagVerbose)
    printf("\nend scanning files \n\n");

  bool gotLinkError = false;

  if (m_FlagLibrarian)
  {
    // If -l option just print labels and then exit
    printf("\nDefined Labels : \n");

    for (const std::string& labelName : m_DefinedLabelsList)
    {
      printf("%s\n",labelName.c_str());
    }
    return 0;
  }
  else
  {
    // Check for Unresolved external references.
    // Print them all before exiting
    for (const ReferencedLabelEntry& referencedLabelEntry : m_ReferencedLabelsList)
    {
      if (!referencedLabelEntry.m_IsResolved)
      {
        printf("Unresolved external: %s, first referenced in %s(%d) [referenced %d times]\n",referencedLabelEntry.label_name.c_str(), referencedLabelEntry.file_name.c_str(), referencedLabelEntry.line_number, referencedLabelEntry.reference_count);
        gotLinkError=true;
      }
    }
  }

  if (gotLinkError)
  {
    ShowError("Errors durink link.\n");
  }


  // Combine all files in list in a nice big juicy go.s or file selected
  FILE *gofile=fopen(m_OutputFileName.c_str(),"wb");
  if (!gofile)
  {
    ShowError("Cannot open output file for writing\n");
  }

  //
  // Add a simple header to the linked file
  //
  fprintf(gofile,
    "//\r\n"
    "// This file was generated by Link65 version %d.%03d \r\n"
    "// Do not edit by hand\r\n"
    "//\r\n"
    ,TOOL_VERSION_MAJOR,TOOL_VERSION_MINOR);


  // Get lines from all files and put them in go.s
  for (const auto& inputFile : m_InputFileList)
  {
    if (m_FlagVerbose)
    {
      printf("Linking %s\n", inputFile.m_FileName.c_str());
    }

    //
    // Then insert the name of the included file
    //
    if (m_FlagEnableFileDirective)
    {
      char current_directory[_MAX_PATH+1];
      char filename[_MAX_PATH];
      char dummy[_MAX_PATH];

      getcwd(current_directory,_MAX_PATH);
      SplitPath(inputFile.m_FileName.c_str(),dummy,dummy,filename,dummy);

      fprintf(gofile,"#file \"%s\\%s.s\"\r\n",current_directory,filename);
    }

    // Mike: The code should really reuse the previously loaded/parsed files
    std::vector<std::string> textData;
    if (!LoadText(inputFile.m_FileName.c_str(),textData))
    {
      ShowError("\nCannot open %s \n", inputFile.m_FileName.c_str());
    }

    m_FlagInCommentBloc = false;
    for (const std::string& currentLine : textData)
    {
      //  Get line file and parse it
      if (m_FlagKeepComments)
      {
        fprintf(gofile,"%s\r\n",currentLine.c_str());
      }
      else
      {
        FilterLine(currentLine,true);
        fprintf(gofile,"%s\r\n", m_FilteredLine.c_str());
      }
    }
  }
  return 0;
}



int main(int argc, char* argv[])
{
  try
  {
    //
    // Some initialization for the common library
    //
    SetApplicationParameters(
      "Link65",
      TOOL_VERSION_MAJOR,
      TOOL_VERSION_MINOR,
      "{ApplicationName} - Version {ApplicationVersion} - This program is a part of the OSDK (http://www.osdk.org)\r\n"
      "\r\n"
      "Author:\r\n"
      "  Vagelis Blathras\r\n"
      "Maintainer:\r\n"
      "  Mickael Pointier (aka Dbug)\r\n"
      "  dbug@defence-force.org\r\n"
      "  http://www.defence-force.org\r\n"
      "\r\n"
      "Purpose:\r\n"
      "  Gluing together a set of 6502 assembly source codes, and solve the external\r\n"
      "  references by looking up missing ones in the library files.\r\n"
      "\r\n"
      "Usage : {ApplicationName} [options] file1 file2 ...\n"
      "Options:\r\n"
      "  -d : Directory to find library files.Next arg in line is the dir name.\r\n"
      "       e.g : link65 -d /usr/oric/lib/ test.s\r\n"
      "  -s : Directory to find source files.Next arg in line is the dir name.\r\n"
      "  -i : Directory to find include files.Next arg in line is the dir name.\r\n"
      "  -o : Output file. Default is go.s . Next arg in line is the file name.\r\n"
      "       e.g : link65 -o out.s test.s\r\n"
      "  -l : Print out defined labels.Usefull when building lib index files.\r\n"
      "  -v : Verbose output.\r\n"
      "  -q : Quiet mode.\r\n"
      "  -b : Bare linking (don't include header and tail).\r\n"
      "  -f : Insert #file directives (require expanded XA assembler).\r\n"
      "  -cn: Defines if comments should be kept (-c1) or removed (-c0) [Default]. \r\n"
      );

    Linker linker(argc, argv);
    return linker.Main();
  }

  catch (const std::exception& e)
  {
    ShowError("Exception thrown: %s", e.what());
  }
}
