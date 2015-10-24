#include "AssertException.h"
#include <cstring>

namespace UnitTest
{

  AssertException::AssertException(char const* description, char const* filename, int lineNumber)
    : m_lineNumber(lineNumber)
  {
    using namespace std;

    strncpy(m_description, description,sizeof(m_description));
    m_description[sizeof(m_description)-1]=0;
    strncpy(m_filename, filename,sizeof(m_filename));
    m_filename[sizeof(m_filename)-1]=0;
  }

  AssertException::~AssertException() throw()
  {
  }

  char const* AssertException::what() const throw()
  {
    return m_description;
  }

  char const* AssertException::Filename() const
  {
    return m_filename;
  }

  int AssertException::LineNumber() const
  {
    return m_lineNumber;
  }

}
