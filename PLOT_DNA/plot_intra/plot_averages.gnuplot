set terminal epslatex size 3.4,2.3 font ",10" standalone header '\usepackage{siunitx}'  
#3.42.3
#bending
set output 'bond_mean.tex'
set border lw 2
set xlabel 'Bond'
set ylabel '$r/\si{nm}$'
#set format "\\rotatebox"
set boxwidth 0.25
set xtics rotate by 60 right
set yrange [0:0.9]
set xrange [-0.5:4.5]
set key top left
plot "bonds_exact.dat"   using ($0-0.125):2:3:xtic(1) with boxerrorbars  lw 1 lc 'black' title '\small PDB',\
     "bonds/sim_6.dat"   using ($0-0.125+0.25):2:3 with boxerrorbars lw 1 lc 'red' title '\small OCCAM' 


#bending
unset yrange
set output 'ang_mean.tex'
set xlabel 'Bending angle'
set ylabel '$\angle/^\circ$'
#set format "\\rotatebox"
set boxwidth 0.25
set xtics rotate by 60 right 
set xrange [-0.5:9.5]
set key top left
plot "bend_exact.dat"   using ($0-0.125):2:3:xtic(1) with boxerrorbars  lw 1 lc 'black' title '\small PDB' ,\
     "bends/sim_6.dat"   using ($0-0.125+0.25):2:3 with boxerrorbars lw 1 lc 'red' title '\small OCCAM'

unset terminal
set terminal epslatex size 5,3 font ",10" standalone header '\usepackage{siunitx}'  
#torsional
set output 'tor_mean.tex'
set xlabel 'Torsional angle'
set ylabel '$\angle/^\circ$'
#set format "\\rotatebox"
set boxwidth 0.15
set xtics rotate by 60 right 
set xrange [-0.5:10]
set key top left
set ytics 60
set mytics 3
set key maxrows 3
set key width -5

set yrange [-180:180]
plot "tor_exact.dat"    using ($0-0.125):2:3 with boxerrorbars  lw 1 lc 'black' title '\footnotesize PDB',\
     "tors/sim_5.dat"   using ($0-0.125+0.15):2:3 with boxerrorbars lw 1 lc 'red' title '\footnotesize $k_\phi=\SI{5}{kJ.mol^{-1}}$',\
     "tors/sim_6.dat"   using ($0-0.125+0.3):2:3 with boxerrorbars lw 1 lc 'green' title '\footnotesize $k_\phi=\SI{6}{kJ.mol^{-1}}$',\
     "tors/sim_7.dat"   using ($0-0.125+0.45):2:3:xtic(1) with boxerrorbars lw 1 lc 'blue' title '\footnotesize $k_\phi=\SI{7}{kJ.mol^{-1}}$',\
     "tors/sim_8.dat"  using ($0-0.125+0.60):2:3 with boxerrorbars lw 1 lc 'purple' title '\footnotesize $k_\phi=\SI{8}{kJ.mol^{-1}}$',\
     "tors/sim_9.dat"  using ($0-0.125+0.75):2:3 with boxerrorbars lw 1 lc 'orange' title '\footnotesize $k_\phi=\SI{9}{kJ.mol^{-1}}$'