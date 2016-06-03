#unset surface
#unset cblabel

#set pal color
#set xrange [*:*]; set yrange [*:*]
#set title "function 'x+y' using all colors available, 'set pal maxcolors 0'"
#set pal maxcolors 0
##splot x+y
#splot "out_l.dat"

# set terminal png transparent nocrop enhanced size 450,320 font "arial,8" 

# set terminal png transparent nocrop enhanced size 450,320 font "arial,8" 
set terminal png nocrop enhanced size 1280,1024 font "arial,8" 
# set output 'pm3d.35.png'
set border 4095 front lt black linewidth 1.000 dashtype solid
#set format cb "%.01t*10^{%T}" 
#set samples 31, 31
#set isosamples 31, 31
unset surface 
set ticslevel 0
set title "function 'x+y' using all colors available, 'set pal maxcolors 0'" 
set xlabel "X" 
set ylabel "Y" 
set pm3d implicit at s
x = 0.0
## Last datafile plotted: "triangle.dat"
#splot x+y

#set view 2,2
#set iso 10,10
#set size 0.5,1
set view 50, 120, 1, 1

set output "out_l.png"
splot "out_l.dat" matrix 
set output "out_f.png"
splot "out_f.dat" matrix 
set output "out_d.png"
splot "out_d.dat" matrix 

