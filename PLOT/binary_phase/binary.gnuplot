#COMMON SETTINGS
set border lw 4

set terminal epslatex size 3.4,2.3 font ",10" standalone header '\usepackage{siunitx}'  

# SURFACE TENSION
set output "binary_pressure.tex"
set xrange [-12.5:32.5]
set yrange [1400:2000]
set ylabel '$P/\si{bar}$'
set xlabel '$\tilde \chi_{AB}/\si{kJ^{-1}.mol}$'
#set xtics 2
#set ytics 50
set key  left width 3
plot 'PRESSURE_DATA/pressavg_mean.dat' u ($1):($2/1E5) with  linespoints lc 1 lw 2 t'',\
     