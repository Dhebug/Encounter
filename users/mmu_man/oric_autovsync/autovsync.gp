set terminal png nocrop enhanced size 1280,1024 font "arial,8" 
set border 4095 front lt black linewidth 1.000 dashtype solid
unset surface 
set ticslevel 0
set xlabel "X" 
set ylabel "Y" 
set pm3d implicit at s
x = 0.0
set view 50, 120, 1, 1

set title "current line by frame"
set output "out_l.png"
splot "out_l.dat" matrix 
set title "current freq by frame"
set output "out_f.png"
splot "out_f.dat" matrix 
set title "current delta by frame"
set output "out_d.png"
splot "out_d.dat" matrix 

