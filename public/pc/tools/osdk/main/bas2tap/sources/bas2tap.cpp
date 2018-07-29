
#include "infos.h"

#include "common.h"
#include <map>
#include <set>
#include <string>

#include <stdlib.h>
#include <stdio.h>
#ifdef _WIN32
#include <conio.h>
#else
#define memicmp strncasecmp
#endif
#include <string.h>

//
// Things to do:
// - Handle auto-numeration and labels
// - Option to optimize the programs (truncate variables to two characters, remove comments)
//

const char *keywords[]=
{
  // 128-246: BASIC keywords
  "END","EDIT","STORE","RECALL","TRON","TROFF","POP","PLOT",
  "PULL","LORES","DOKE","REPEAT","UNTIL","FOR","LLIST","LPRINT","NEXT","DATA",
  "INPUT","DIM","CLS","READ","LET","GOTO","RUN","IF","RESTORE","GOSUB","RETURN",
  "REM","HIMEM","GRAB","RELEASE","TEXT","HIRES","SHOOT","EXPLODE","ZAP","PING",
  "SOUND","MUSIC","PLAY","CURSET","CURMOV","DRAW","CIRCLE","PATTERN","FILL",
  "CHAR","PAPER","INK","STOP","ON","WAIT","CLOAD","CSAVE","DEF","POKE","PRINT",
  "CONT","LIST","CLEAR","GET","CALL","!","NEW","TAB(","TO","FN","SPC(","@",
  "AUTO","ELSE","THEN","NOT","STEP","+","-","*","/","^","AND","OR",">","=","<",
  "SGN","INT","ABS","USR","FRE","POS","HEX$","&","SQR","RND","LN","EXP","COS",
  "SIN","TAN","ATN","PEEK","DEEK","LOG","LEN","STR$","VAL","ASC","CHR$","PI",
  "TRUE","FALSE","KEY$","SCRN","POINT","LEFT$","RIGHT$","MID$"
  // 247- : Error messages
};

enum TokenCodes
{
  Token_END=0,
  Token_EDIT,
  Token_STORE,
  Token_RECALL,
  Token_TRON,
  Token_TROFF,
  Token_POP,
  Token_PLOT,
  Token_PULL,
  Token_LORES,
  Token_DOKE,
  Token_REPEAT,
  Token_UNTIL,
  Token_FOR,
  Token_LLIST,
  Token_LPRINT,
  Token_NEXT,
  Token_DATA,
  Token_INPUT,
  Token_DIM,
  Token_CLS,
  Token_READ,
  Token_LET,
  Token_GOTO,
  Token_RUN,
  Token_IF,
  Token_RESTORE,
  Token_GOSUB,
  Token_RETURN,
  Token_REM,
  Token_HIMEM,
  Token_GRAB,
  Token_RELEASE,
  Token_TEXT,
  Token_HIRES,
  Token_SHOOT,
  Token_EXPLODE,
  Token_ZAP,
  Token_PING,
  Token_SOUND,
  Token_MUSIC,
  Token_PLAY,
  Token_CURSET,
  Token_CURMOV,
  Token_DRAW,
  Token_CIRCLE,
  Token_PATTERN,
  Token_FILL,
  Token_CHAR,
  Token_PAPER,
  Token_INK,
  Token_STOP,
  Token_ON,
  Token_WAIT,
  Token_CLOAD,
  Token_CSAVE,
  Token_DEF,
  Token_POKE,
  Token_PRINT,
  Token_CONT,
  Token_LIST,
  Token_CLEAR,
  Token_GET,
  Token_CALL,
  Token_SymbolExclamation,
  Token_NEW,
  Token_TAB,
  Token_TO,
  Token_FN,
  Token_SPC,
  Token_SymbolArobase,
  Token_AUTO,
  Token_ELSE,
  Token_THEN,
  Token_NOT,
  Token_STEP,
  Token_SymbolPlus,
  Token_SymbolMinus,
  Token_SymbolMultiply,
  Token_SymbolDivide,
  Token_SymbolExponent,
  Token_AND,
  Token_OR,
  Token_SymbolMore,
  Token_SymbolEqual,
  Token_SymbolLess,
  Token_SGN,
  Token_INT,
  Token_ABS,
  Token_USR,
  Token_FRE,
  Token_POS,
  Token_HEX,
  Token_SymbolAmpersand,
  Token_SQR,
  Token_RND,
  Token_LN,
  Token_EXP,
  Token_COS,
  Token_SIN,
  Token_TAN,
  Token_ATN,
  Token_PEEK,
  Token_DEEK,
  Token_LOG,
  Token_LEN,
  Token_STR,
  Token_VAL,
  Token_ASC,
  Token_CHR,
  Token_PI,
  Token_TRUE,
  Token_FALSE,
  Token_KEY,
  Token_SCRN,
  Token_POINT,
  Token_LEFT,
  Token_RIGHT,
  Token_MID
};



unsigned char head[14]={ 0x16,0x16,0x16,0x24,0,0,0,0,0,0,5,1,0,0 };




void Tap2Bas(unsigned char *ptr_buffer,size_t file_size,const char *destFile)
{
  unsigned int i, car;

  FILE *out = stdout;
  if (destFile && (strlen(destFile) != 0))
  {
    out = fopen(destFile, "wb");
  }  
  if (out == NULL)
  {
    printf("Can't open file for writing\n");
    exit(1);
  }


  if (ptr_buffer[0]!=0x16 || ptr_buffer[3]!=0x24)
  {
    ShowError("Not an Oric file");
  }
  if (ptr_buffer[6])
  {
    ShowError("Not a BASIC file");
  }
  i=13;
  while (ptr_buffer[i++]);
  while (ptr_buffer[i] || ptr_buffer[i+1])
  {
    i+=2;
    fprintf(out," %u ",ptr_buffer[i]+(ptr_buffer[i+1]<<8));
    i+=2;
    while ((car=ptr_buffer[i++]))
    {
      if (car<128)
        fputc(car,out);
      else
      if (car < 247)
      {
        fprintf(out,"%s", keywords[car - 128]);
      }
      else
      {
        // Probably corrupted listing
        // 247 : NEXT WITHOUT FOR
        fprintf(out,"CORRUPTED_ERROR_CODE_%u", car);
      }
    }
    fputc('\r',out);
    fputc('\n', out);
  }

  fclose(out);
}



// tap2bas
int search_keyword(const char *str)
{
  for (unsigned int i=0;i<sizeof(keywords)/sizeof(char *);i++)
  {
    if (strncmp(keywords[i],str,strlen(keywords[i]))==0)
    {
      return i;
    }
  }
  return -1;
}



// New routine
struct LineData
{
  LineData()
  {
    trimmedLine = "";
    sourceNumber = -1;
    basicNumber = -1;
  }

  std::string   trimmedLine;
  int           sourceNumber;
  int           basicNumber;
};




char ProcessOptionalWhiteSpace(unsigned char*& bufPtr, const char*& ligne,bool optimize)
{
  char car;
  while (car = *ligne)
  {
    if (car == ' ')  // Space
    {
      if (!optimize)
      {
        *bufPtr++ = car;
      }
      ligne++;
    }
    else
    if (car == '\t') // Tab
    {
      if (!optimize)
      {
        *bufPtr++ = car;
      }
      ligne++;
    }
    else
    {
      //ligne++;
      return car;
    }
  }

  return car;
}


bool IsValidLineNumber(char car)
{
  if ((car >= '0') && (car <= '9')) return true;
  return false;
}

bool IsValidLabelName(char car)
{
  if (((car >= 'a') && (car <= 'z')) ||
    ((car >= 'A') && (car <= 'Z')) ||
    (car == '_'))  return true;
  return false;
}



class BasicTokenizer
{
public:



std::string GetPotentialSymbolName(const char*& ligne)
{
  std::string potentialLabelName;
  char car;
  while ((IsValidLabelName(car = *ligne) || IsValidLineNumber(*ligne)) && (search_keyword(ligne)<0))
  {
    potentialLabelName += car;
    ligne++;
  }
  return potentialLabelName;
}


void ProcessPossibleLineNumber(unsigned char*& bufPtr, const char*& ligne,bool shouldValidateLineNumber, bool optimize)
{
  // Should have one or more (comma separated) numbers, variables, or labels.
  char car = ProcessOptionalWhiteSpace(bufPtr, ligne,optimize);
  if (IsValidLineNumber(car))
  {
    // Line  Number
    int lineNumber = 0;
    while (IsValidLineNumber(car = *ligne))
    {
      lineNumber = (lineNumber * 10) + (car - '0');
      *bufPtr++ = car;
      ligne++;
    }
    if (shouldValidateLineNumber && (m_ValidLineNumbers.find(lineNumber) == m_ValidLineNumbers.end()))
    {
      ShowError("Can't find line number %d referred by jump instruction in file %s line number line %d", lineNumber, m_CurrentFileName.c_str(), m_CurrentLineNumber);
    }
  }
  else
  if (IsValidLabelName(car))
  {
    // Label Name (or variable)
    std::string potentialLabelName = GetPotentialSymbolName(ligne);
    /*
    std::string potentialLabelName;
    while ((IsValidLabelName(car = *ligne) || IsValidLineNumber(*ligne)) && (search_keyword(ligne)<0))
    {
      potentialLabelName += car;
      ligne++;
    }
    */

    if (!potentialLabelName.empty())
    {
      std::string valueToWrite;

      auto findIt = m_Labels.find(potentialLabelName);
      if (findIt != m_Labels.end())
      {
        // Found the label \o/
        // We replace the value by the stringified line number
        int lineNumber = findIt->second;
        bufPtr += sprintf((char*)bufPtr, "%d", lineNumber);
      }
      else
      {
        // Did not find the label...
        // ...maybe it's a define?
        auto findIt = m_Defines.find(potentialLabelName);
        if (findIt != m_Defines.end())
        {
          // Found a matching define \o/
          // We replace the value by the actual value
          std::string defineValue = findIt->second;
          bufPtr += sprintf((char*)bufPtr, "%s", defineValue.c_str());
        }
        else
        {
          // Not a define either... probably a variable then...?
          // Just write it "as is"
          bufPtr += sprintf((char*)bufPtr, "%s", potentialLabelName.c_str());
        }
      }
    }
  }
}



void Bas2Tap(const char *sourceFile, const char *destFile, bool autoRun, bool useColor, bool optimize)
{
  unsigned char buf[48192];
  unsigned int end, adr;

  bool useExtendedBasic = false;


  // Mike: Need to improve the parsing of this with a global function to split
  // a text file in separate lines.
  std::vector<std::string> textData;
  if (!LoadText(sourceFile, textData))
  {
    ShowError("Unable to load source file");
  }

  {
    //
    // First pass: Get the labels and line numbers
    //
    int lastLineNumber = 0;
    int incrementStep = 5;


    m_CurrentFileName = sourceFile;
    std::string labelName = "";
    LineData lineData;
    lineData.sourceNumber = 0;
    std::vector<std::string>::const_iterator lineIt = textData.begin();
    while (lineIt != textData.end())
    {
      const std::string& currentLine(*lineIt);
      ++lineIt;
      lineData.sourceNumber++;
      if (!currentLine.empty())
      {
        char firstCar = currentLine[0];
        bool startsByWhiteSpace = (firstCar == ' ') || (firstCar == '\t');

        bool shouldSkip = false;

        lineData.trimmedLine = StringTrim(currentLine, " \t\f\v\n\r\xEF\xBB\xBF\xFF\xFE");

        if (!lineData.trimmedLine.empty())
        {
          const char* ligne = lineData.trimmedLine.c_str();
          if (ligne[0] == '#')
          {
            // Preprocessor directive
            if (memicmp(ligne, "#file", 5) == 0)
            {
              //"#file font.BAS""
              // Very approximative "get the name of the file and reset the line counter" code.
              // Will clean up that when I will have some more time.
              ligne += 5;
              m_CurrentFileName = ligne;
              lineData.sourceNumber = 0;
            }
            else
            if (memicmp(ligne, "#labels", 7) == 0)
            {
              //"#labels"
              useExtendedBasic = true;
              shouldSkip = true;
            }
            else
            if (memicmp(ligne, "#optimize", 7) == 0)
            {
              //"#optimize"
              optimize = true;
              shouldSkip = true;
            }
            else
            if (memicmp(ligne, "#define", 7) == 0)
            {
              //"#define DEFINE_NAME REPLACEMENT_VALUE"
              ligne += 7;
              std::string line(StringTrim(ligne));
              std::string defineName  = StringTrim(StringSplit(line, ": \t"));
              std::string defineValue = StringTrim(line);

              const char* ptrDefineName = defineName.c_str();
              std::string potentialUsableName = GetPotentialSymbolName(ptrDefineName);
              if (potentialUsableName != defineName)
              {
                int keyw = search_keyword(ptrDefineName);
                if (keyw >= 0)
                {
                  ShowError("Define named '%s' in file %s line number line %d contains the name of a BASIC instruction '%s'", defineName.c_str(), m_CurrentFileName.c_str(), lineData.sourceNumber, keywords[keyw]);
                }
              }


              m_Defines[defineName] = defineValue;

              shouldSkip = true;
            }
            else
            {
              ShowError("Unknown preprocessor directive in file %s line number line %d", m_CurrentFileName.c_str(), lineData.sourceNumber);
            }
          }
          else
          {
            // Standard line
            int number = get_value(ligne, -1);
            if (number<0)
            {
              char car = ligne[0];
              if (car != 0)
              {
                char car2 = ligne[1];
                if ((car == '\'') || (car == ';') || ((car == '/') && (car2 == '/')))
                {
                  // We accept the usual C, Assembler and BASIC comments are actual comments that do not count as normal lines
                  // Technically we could have used a decent pre-processor, or even a full file filter, but I'm aiming at "more bangs for the bucks" approach.
                  // If necessary we can refactor later
                  continue;
                }
              }

              // Mike: Need to add better diagnostic here
              if (useExtendedBasic)
              {
                if (startsByWhiteSpace)
                {
                  // Normal line, missing a line number, we generate one
                  number = lastLineNumber + incrementStep;
                }
                else
                {
                  // Possibly a label
                  std::string line(ligne);
                  labelName = StringTrim(StringSplit(line, ": \t"));
                  if (labelName.empty())
                  {
                    // Not a label, so maybe a line of basic without line number
                    ShowError("Missing label information in file %s line %d", m_CurrentFileName.c_str(), lineData.sourceNumber);
                    break;
                  }
                  else
                  {
                    // Definitely a label, or something unfortunately detected as a label because of the ":" at the end :p
                    if (m_Labels.find(labelName) != m_Labels.end())
                    {
                      ShowError("Label '%s' found in file %s line %d is already defined", labelName.c_str(), m_CurrentFileName.c_str(), lineData.sourceNumber);
                      break;
                    }

                    bool hasSetIncrement = false;
                    bool hasSetNumber = false;

                    while (!line.empty())
                    {
                      std::string lineOrIncrement = StringTrim(StringSplit(line, ": \t"));
                      if (!lineOrIncrement.empty())
                      {
                        char car  = lineOrIncrement[0];
                        char car2 = (lineOrIncrement.size()>=2)?lineOrIncrement[1]:0;
                        if ( (car == '\'') || (car == ';') || ((car == '/') && (car2 == '/')) )
                        {
                          // Comment
                          break;
                        }
                        else
                        if (car == '+')
                        {
                          // Increment
                          if (hasSetIncrement)
                          {
                            ShowError("Line increment value for label '%s' found in file %s line %d was already set to %d", labelName.c_str(), m_CurrentFileName.c_str(), lineData.sourceNumber, incrementStep);
                          }
                          lineOrIncrement = lineOrIncrement.substr(1);
                          incrementStep = std::stoi(lineOrIncrement);
                          hasSetIncrement = true;
                        }
                        else
                        {
                          // Line number
                          if (hasSetNumber)
                          {
                            ShowError("Line number value for label '%s' found in file %s line %d was already set to %d", labelName.c_str(), m_CurrentFileName.c_str(), lineData.sourceNumber, lastLineNumber);
                          }
                          char* endPtr = nullptr;
                          const char* startPtr = lineOrIncrement.c_str();
                          lastLineNumber = std::strtol(startPtr,&endPtr,10);
                          if (startPtr == endPtr)
                          {
                            ShowError("Invalid line number value '%s' for label '%s' found in file %s line %d", startPtr, labelName.c_str(), m_CurrentFileName.c_str(), lineData.sourceNumber);
                          }
                          
                          m_Labels[labelName] = lastLineNumber;
                          hasSetNumber = true;
                        }
                      }
                    }

                    if (!hasSetNumber)
                    {
                      m_Labels[labelName] = lastLineNumber + incrementStep;
                    }
                    shouldSkip = true;
                  }
                }
              }
              else
              {
                ShowError("Missing line number in file %s line %d", m_CurrentFileName.c_str(), lineData.sourceNumber);
                break;
              }
            }
            else
            {
              // We have a valid line number, if we have a pending label, record it
              if (!labelName.empty())
              {
                m_Labels[labelName] = number;
                labelName.clear();
              }
              lineData.trimmedLine = StringTrim(ligne);
            }
            if (number >= 0)
            {
              lineData.basicNumber = number;
              lastLineNumber = number;
              m_ValidLineNumbers.insert(number);
            }
          }
          if (!shouldSkip)
          {
            // No need to add labels as actual lines to parse
            m_ActualLines.push_back(lineData);
          }
        }
      }
    }
  }

  unsigned char* bufPtr = buf;
  m_CurrentFileName = sourceFile;

  {
    //
    // Second pass: Solve the labels
    //
    int previousLineNumber = -1;

    std::vector<LineData>::const_iterator lineIt = m_ActualLines.begin();
    while (lineIt != m_ActualLines.end())
    {
      const LineData& lineData(*lineIt);
      std::string currentLine = lineData.trimmedLine;
      m_CurrentLineNumber = lineData.sourceNumber;

      if (lineData.basicNumber < previousLineNumber)
      {
        ShowError("BASIC line number %d in file %s line number line %d is smaller than the previous line %d", lineData.basicNumber, m_CurrentFileName.c_str(), m_CurrentLineNumber, previousLineNumber);
      }
      previousLineNumber = lineData.basicNumber;

      if (!currentLine.empty())
      {
        const char* ligne = currentLine.c_str();
        if (ligne[0] == '#')
        {
          // Preprocessor directive
          if (memicmp(ligne, "#file", 5) == 0)
          {
            //"#file font.BAS""
            // Very approximative "get the name of the file and reset the line counter" code.
            // Will clean up that when I will have some more time.
            ligne += 5;
            m_CurrentFileName = ligne;
            m_CurrentLineNumber = 0;
          }
          else
          {
            ShowError("Unknown preprocessor directive in file %s line number line %d", m_CurrentFileName.c_str(), m_CurrentLineNumber);
          }
        }
        else
        {
          // Standard line
          unsigned char* lineStart = bufPtr;

          *bufPtr++ = 0;
          *bufPtr++ = 0;

          *bufPtr++ = lineData.basicNumber & 0xFF;
          *bufPtr++ = lineData.basicNumber >> 8;

          bool color          = useColor;
          bool isComment      = false;
          bool isQuotedString = false;
          bool isData         = false;


          while (*ligne == ' ') ligne++;


          while (*ligne)
          {
            unsigned char car = *ligne;
            unsigned char car2 = *(ligne + 1);

            if (isComment)
            {
              char value = *ligne++;
              if (!optimize)
              {
                if (color)
                {
                  color = false;
                  *bufPtr++ = 27;	// ESCAPE
                  *bufPtr++ = 'B';	// GREEN labels
                }
                *bufPtr++ = value;
              }
            }
            else
            if (isQuotedString)
            {
              if (car == '"')
              {
                isQuotedString = false;
              }
              if (car == '~')
              {
                // Special control code
                if ( (car2>=96) && (car2 <= 'z') )  // 96=arobase ('a'-1)
                {
                  *bufPtr++ = car2-96;
                  ligne+=2;
                }
                else
                if ((car2 >= '@') && (car2 <= 'Z'))
                {
                  *bufPtr++ = 27;      // ESCAPE
                  *bufPtr++ = car2;    // Actual control code
                  ligne+=2;
                }
                else
                {
                  ShowError("The sequence '~%c' in file %s line number line %d is not a valid escape sequence ", car2, m_CurrentFileName.c_str(), m_CurrentLineNumber);
                }

              }
              else
              {
                *bufPtr++ = *ligne++;
              }
            }
            else
            if (isData)
            {
              if (car == ':')
              {
                isData = false;
              }
              *bufPtr++ = *ligne++;
            }
            else
            {
              ProcessOptionalWhiteSpace(bufPtr, ligne, optimize);

              int keyw = search_keyword(ligne);
              if (keyw == Token_REM || (*ligne == '\''))
              {
                // REM
                isComment = true;
                if (optimize)
                {
                  continue;
                }
              }
              else
              if (keyw == Token_DATA) 
              {
                // DATA
                isData = true;                      
              }

              car  = *ligne;
              car2 = *(ligne+1);

              if (car == '"')
              {
                isQuotedString = true;
              }
              else
              if ( (car == 0xA7) || ((car == 0xC2) && (car2 == 0xA7)) )
              {
                //
                // Special '§' symbol that get replaced by the current line number.
                // Appears in encodings as either "C2 A7" or "A7"
                //
                bufPtr += sprintf((char*)bufPtr, "%d", lineData.basicNumber);
                ++ligne;
                if (car == 0xC2)
                {
                  // Need to skip two characters...
                  ++ligne;
                }
                continue;
              }
              else
              if (car == '(')
              {
                *bufPtr++ = *ligne++;  // Open parenthesis
                ProcessPossibleLineNumber(bufPtr, ligne, false, optimize);
                continue;
              }
              else
              if (car == ',')
              {
                *bufPtr++ = *ligne++;  // comma
                ProcessPossibleLineNumber(bufPtr, ligne, false, optimize);
                continue;
              }

              if (keyw >= 0)
              {
                *bufPtr++ = keyw | 128;
                ligne += strlen(keywords[keyw]); 
                ProcessOptionalWhiteSpace(bufPtr, ligne, optimize);

                //
                // Note: This bunch of tests should be replaced by actual flags associated to keywords to define their behavior:
                // - Can be followed by a line number
                // - Can be the complementary part of an expression (and thus should not be part of a symbol)
                // - ...
                //
                if (useExtendedBasic && 
                       ((keyw == Token_GOTO) 
                     || (keyw == Token_GOSUB) 
                     || (keyw == Token_RESTORE) 
                     || (keyw == Token_SymbolEqual)
                     || (keyw == Token_SymbolMinus)
                     || (keyw == Token_SymbolPlus)
                     || (keyw == Token_SymbolDivide)
                     || (keyw == Token_SymbolPlus)
                     || (keyw == Token_THEN) 
                     || (keyw == Token_ELSE)))
                {
                  if ((keyw == Token_THEN) || (keyw == Token_ELSE))
                  {
                    if (search_keyword(ligne) >= 0)
                    {
                      // THEN and ELSE instructions can be followed directly by a line number... but they can also have an instruction like PRINT 
                      ProcessOptionalWhiteSpace(bufPtr, ligne, optimize);
                      continue;
                    }
                  }
                  // Should have one or more (comma separated) numbers, variables, or labels.
                  bool shouldValidateLineNumber = ! ( (keyw == Token_SymbolEqual) || (keyw == Token_SymbolMinus) || (keyw == Token_SymbolPlus) || (keyw == Token_SymbolMultiply) || (keyw == Token_SymbolDivide));
                  ProcessPossibleLineNumber(bufPtr, ligne, shouldValidateLineNumber,optimize);
                  ProcessOptionalWhiteSpace(bufPtr, ligne, optimize);
                }
              }
              else
              {
                *bufPtr++ = *ligne++;
              }
            }
          }

          if (optimize)
          {
            // Remove any white space at the end of the line
            while (((bufPtr-1) > (lineStart+4)) && (bufPtr[-1] == ' '))
            {
              --bufPtr;
            }
          }
          if (bufPtr == lineStart + 4)
          {
            // If the line is empty, we add a REM token...
            *bufPtr++ = Token_REM | 128;
          }

          *bufPtr++ = 0;

          adr = 0x501 + bufPtr-buf;

          *lineStart++ = adr & 0xFF;
          *lineStart++ = adr >> 8;

        }
      }
      ++lineIt;
    }
    *bufPtr++ = 0;
    *bufPtr++ = 0;
  }

  //following line modified by Wilfrid AVRILLON (Waskol) 06/20/2009
  //It should follow this rule of computation : End_Address=Start_Address+File_Size-1
  //Let's assume a 1 byte program, it starts at address #501 and ends at address #501 (Address=Address+1-1) !
  //It was a blocking issue for various utilities (tap2wav for instance)
  //end=0x501+i-1;	        //end=0x501+i;
  int i = bufPtr - buf;
  end = 0x501 + i;

  if (autoRun)	head[7] = 0x80;	// Autorun for basic :)
  else		head[7] = 0;

  head[8] = end >> 8;
  head[9] = end & 0xFF;

  //
  // Save file
  //
  FILE *out = fopen(destFile, "wb");
  if (out == NULL)
  {
    printf("Can't open file for writing\n");
    exit(1);
  }
  fwrite(head, 1, 13, out);
  // write the name
  if (m_CurrentFileName.length() > 0)
  {
    char *currentFileDup = strdup(m_CurrentFileName.c_str());
    char *fileName = currentFileDup;
    // only take the file name from the path
    // try to find '\\'
    char *lastsep = strrchr(fileName, '\\');
    if (lastsep != NULL)
    {
      // if there is something after the separator
      if (lastsep + 1 != 0)
        fileName = lastsep + 1;
    }
    else
    {
      // try to find /
      lastsep = strrchr(fileName, '/');
      if (lastsep != NULL)
      {
        // if there is something after the separator
        if (lastsep + 1 != 0)
          fileName = lastsep + 1;
      }
    }
    // remove the extension if there is one
    char *lastdot = strrchr(fileName, '.');
    if (lastdot != NULL)
      *lastdot = 0;
    fwrite(fileName, 1, strlen(fileName), out);
    free(currentFileDup);
  }
  fwrite("\x00", 1, 1, out);
  fwrite(buf, 1, i + 1, out);
  // oricutron bug work around
  //fwrite("\x00", 1, 1, out);
  fclose(out);
}



public:
  std::map<std::string, int>  m_Labels;            // Name to resolved line number
  std::set<int>               m_ValidLineNumbers;  // Useful to know if a GOTO or GOSUB refers to an invalid line number

  std::map<std::string,std::string>  m_Defines;    // Very primitive macro expansion system (only support direct replacement at the moment)

  std::vector<LineData>       m_ActualLines;

  std::string                 m_CurrentFileName;
  int                         m_CurrentLineNumber;
};



#define NB_ARG	2

int main(int argc, char **argv)
{
  //
  // Some initialization for the common library
  //
  SetApplicationParameters(
    "Bas2Tap",
    TOOL_VERSION_MAJOR,
    TOOL_VERSION_MINOR,
    "{ApplicationName} - Version {ApplicationVersion} - This program is a part of the OSDK\r\n"
    "\r\n"
    "Authors:\r\n"
    "  Fabrice Frances (original version) \r\n"
    "  Mickael Pointier (extended BASIC features) \r\n"
    "\r\n"
    "Purpose:\r\n"
    "  Converting a text file containing a BASIC source code to a binary\r\n"
    "  encoded TAPE file that can be loaded using the CLOAD command.\r\n"
    "  (and the opposite operation as well).\r\n"
    "\r\n"
    "Parameters:\r\n"
    "  <options> <sourcefile> <destinationfile>\r\n"
    "\r\n"
    "Options:\r\n"
    "  -b2t[0|1] for converting to tape format with autorun (1) or not (0)\r\n"
    "  -t2b for converting from tape format text\r\n"
    "  -color[0|1] for enabling colored comments\r\n"
    "  -optimize[0|1] for allowing for optimizations (disabling comments, etc...)\r\n"
    "\r\n"
    "Source Commands:\r\n"
    "  #labels to enable labels and auto numbering\r\n"
    "  #optimize to enable optimization\r\n"
    "  #defines to define symbols\r\n"
    "  'tilde' to escape sequences and 'paragraph' to insert current line number\r\n"
    "\r\n"
    "Example:\r\n"
    "  {ApplicationName} -b2t1 final.txt osdk.tap\r\n"
    "  {ApplicationName} -t2b osdk.tap program.txt\r\n"
    );

  bool basicToTape=true;
  bool autoRun=true;
  bool useColor=false;
  bool optimize = false;

  ArgumentParser argumentParser(argc,argv);

  while (argumentParser.ProcessNextArgument())
  {
    if (argumentParser.IsSwitch("-t2b"))
    {
      // Tape to BASIC source code
      basicToTape=false;
    }
    else
    if (argumentParser.IsSwitch("-b2t"))
    {
      // BASIC source code to tape
      basicToTape=true;
      autoRun=argumentParser.GetBooleanValue(true);
    }
    else
    if (argumentParser.IsSwitch("-color"))
    {
      // Handling of color codes
      useColor=argumentParser.GetBooleanValue(false);
    }
    else
    if (argumentParser.IsSwitch("-optimize"))
    {
      // Handling of optimization (disables color if enabled)
      optimize =argumentParser.GetBooleanValue(false);
    }
  }

  if (argumentParser.GetParameterCount()!=NB_ARG)
  {
    ShowError(0);
  }


  std::string nameSrc(argumentParser.GetParameter(0));
  std::string nameDst(argumentParser.GetParameter(1));

  if (basicToTape)
  {
    BasicTokenizer tokenizer;
    tokenizer.Bas2Tap(nameSrc.c_str(), nameDst.c_str(), autoRun, useColor, optimize);
  }
  else
  {
    // Load the source file
    void* ptr_buffer_void;
    size_t file_size;
    if (!LoadFile(nameSrc.c_str(),ptr_buffer_void,file_size))
    {
      ShowError("Unable to load the source file");
    }
    unsigned char *ptr_buffer=(unsigned char*)ptr_buffer_void;

    Tap2Bas(ptr_buffer,file_size,nameDst.c_str());
  }

  exit(0);
}
