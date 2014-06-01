#!/usr/bin/python
# -*- coding: utf-8 -*-

# (c) 2014, François Revol
# MIT licence

import math

angle = []

y_start = -49
x_start = -19

for y in range(y_start, y_start + 100):
    l = []
    for x in range(x_start, x_start + 40):
        # get the arc-tangent of the (scaled) vector
        # XXX: we should scale x so the corners are at pi/4 ?
        a = math.atan2(y, x)
        # a in [-pi; pi]
        a *= 128 / math.pi
        # a in [-128; 128]
        a += 0.5
        a = int(a)
        if a < -128:
            print "[%d,%d] = %f : %d" % (x, y, a, int(a))
        if a > 128:
            print "[%d,%d] = %f : %d" % (x, y, a, int(a))
        # a in [-127;128]
        # make it unsigned
        a &= 0xff
        #print "[%d,%d] = %f : %d" % (x, y, a, int(a))
        l.append(a)
    angle.append(l)
# ?
#angle.append([0x05])

#print angle
print "/* C dump */"
print "unsigned char angle[] ="
print "{"
for l in angle:
    #print "\t",
    hexbytes = []
    for v in l:
        hexbytes.append("0x%02x" % v)
    hexbytes.append("")
    print ",".join(hexbytes)

#??
print "\t0x05"

print "};"

        
