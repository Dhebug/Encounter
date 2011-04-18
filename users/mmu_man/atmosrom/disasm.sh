#!/bin/sh

TAP=SEDKERN.TAP
TAP2BIN=../lunix/lng/devel_utils/oric/tap2bin
DA65=da65
INFOFILE=atmos.dinfo

#$TAP2BIN $TAP

#$DA65 -i $INFOFILE -o sedkern.s SEDKERN.bin
$DA65 -i $INFOFILE 



