#COMMON SETTINGS
set border lw 4

set terminal epslatex size 2.5,1.8 font ",10" standalone header '\usepackage{siunitx}'  
set rmargin 0.5
set tmargin 0.5

# SURFACE TENSION
set output "binary_density.tex"
set xrange [-12.5:32.5]
set yrange [900:1150]
set ylabel '$\rho/\si{kg/m^3}$'
set xlabel '$\tilde \chi_{AB}/\si{kJ^{-1}.mol}$'
set xtics 10
set ytics 50
set key  left width 3
plot 'NPT_HALF/dens_mean.dat' u ($1):($2) with  linespoints lc 7 lw 3 t'',\
     