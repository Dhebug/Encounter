# sed script to convert from DA65 output (CA65 syntax) to XA
# only tested on SEDORIC sources so far
# (C) 2008 François Revol, revol@free.fr
# 

# C style comments
s/;\(.*$\)/\/\*\1\*\//
# remove useless
s/^.*\.setcpu.*$//
# change label defs
s/:= /= /
#s/\(.*\):= /#define \1 /
# change pseudo-ops
s/\.byte/\.byt/
s/\.addr/\.word/
# change force non-zeropage modifier
s/\([ 	]\)a:/\1\!/
# remove useless redefinitions
s/^.*\* + \$0000.*$//
# implicit a register
s/asl\([ 	]\+\)a/asl\1 /
s/lsr\([ 	]\+\)a/lsr\1 /
s/rol\([ 	]\+\)a/rol\1 /
s/ror\([ 	]\+\)a/ror\1 /
