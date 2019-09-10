#COMMON SETTINGS
set border lw 4

set terminal epslatex size 3.4,2.3 font ",10" standalone header '\usepackage{siunitx}'  

# SURFACE TENSION
set output "mem_tension_kst.tex"
set xrange [-1:16]
set yrange [-150:200]
set ylabel '$\gamma/\si{mJ.m^{-2}}$'
set xlabel '$K_{\text ST}/\si{kJ^{-1}.mol}$'
set xtics 2
set ytics 50
set key  left width 3
plot 'data/DOPC_GAMMA.dat' u (-$1):2 w p lc 1 t'DOPC',\
     'data/DOPC_GAMMA_FIT.dat' u (-$1):2 w l lc 1 t'',\
     'data/DSPC_GAMMA.dat' u (-$1):2 w p lc 2 t'DSPC',\
     'data/DSPC_GAMMA_FIT.dat' u (-$1):2 w l lc 2 t'',\
     'data/DPPC_GAMMA.dat' u (-$1):2 w p lc 3 t'DPPC',\
     'data/DPPC_GAMMA_FIT.dat' u (-$1):2 w l lc 3 t'',\
     'data/DMPC_GAMMA.dat' u (-$1):2 w p lc 4 t'DMPC',\
     'data/DMPC_GAMMA_FIT.dat' u (-$1):2 w l lc 4 t''

# A parameter
set output "mem_a_kst.tex"
set xrange [-1:16]
set yrange [8.75:11]
set ylabel '$a/\si{nm^{-3}}$'
set xlabel '$K_{\text ST}/\si{kJ^{-1}.mol}$'
set xtics 2
set ytics 0.25
plot 'data/DOPC_a.dat' u (-$1):2 w p lc 1 t'DOPC',\
     'data/DOPC_a_FIT.dat' u (-$1):2 w l lc 1 t'',\
     'data/DSPC_a.dat' u (-$1):2 w p lc 2 t'DSPC',\
     'data/DSPC_a_FIT.dat' u (-$1):2 w l lc 2 t'',\
     'data/DPPC_a.dat' u (-$1):2 w p lc 3 t'DPPC',\
     'data/DPPC_a_FIT.dat' u (-$1):2 w l lc 3 t'',\
     'data/DMPC_a.dat' u (-$1):2 w p lc 4 t'DMPC',\
     'data/DMPC_a_FIT.dat' u (-$1):2 w l lc 4 t''


# NPT SIMULATIONS AREA
set output "mem_area_all.tex"
set xrange [0:10]
set yrange [0.55:0.85]
set ylabel '$A_{\si{l}}/\si{nm^{2}}$'
set xlabel '$t/\si{ns}$'
set xtics 2
set ytics 100
plot 'DOPC_NPT/lx.dat' u ($1*0.03/1000):($2**2/(468/2)) t'DOPC',\
     'DSPC_NPT/lx.dat' u ($1*0.03/1000):($2**2/(512/2)) t'DSPC',\
     'DPPC_NPT/lx.dat' u ($1*0.03/1000):($2**2/(528/2)) t'DPPC',\
     'DMPC_NPT/lx.dat' u ($1*0.03/1000):($2**2/(516/2)) t'DMPC',\