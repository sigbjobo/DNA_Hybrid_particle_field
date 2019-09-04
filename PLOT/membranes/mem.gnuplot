
# SURFACE TENSION
set output "mem_tension_kst.tex"
set xrange [-1:16]
set yrange [-150:200]
set ylabel '$\gamma/\si{mJ.m^{-2}}$'
set xlabel '$K_{\text ST}/\si{kJ^{-1}.mol}$'
set xtics 2
set ytics 50
set key  left
plot '< paste DOPC/presszzavg_mean.dat DOPC/presszzavg_mean.dat DOPC/pressxxavg_mean.dat' u (-$1):(1000*($2-$5)*14E-9) w p lc 1 t '',\

