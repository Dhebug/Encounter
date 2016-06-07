#!/bin/sh

echo > Fonts.h; for f in *_*.h; do echo "#include \"$f\"" >> Fonts.h; done; echo "" > FontList.h; for f in *_*.h; do echo "	{ \"$f\", ${f/.h/_bits} }," >> FontList.h; done
