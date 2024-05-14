
#include "params.h"

_gSaveGameFile                   ; Same address than _gHighScores
_gHighScores          .dsb 512   ; 456 bytes of actual score data, padded to 512 bytes for the saving system

