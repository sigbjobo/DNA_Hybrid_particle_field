#COMMON SETTINGS
set border lw 4

set terminal epslatex size 3.4,2.3 font ",10" standalone header '\usepackage{siunitx}'  

# SURFACE TENSION
set output "dppc_kst.tex"
set xrange [-5:31]
set yrange [-60:80]
set ylabel '$\gamma/\si{mJ.m^{-2}}$'
set xlabel '$K_{\text ST}/\si{kJ.mol^{-1}.nm^2}$'
set xtics 5
set ytics 20
set xzeroaxis

set key  left width 3
plot 'data/dppc_40x40_GAMMA.dat' u (-$1):2 with linespoints lc 7 lw 3 t'',\
#     'data/dppc_40x40_GAMMA_FIT.dat' u (-$1):2 w l lc 1 lw 3 t''
     
# A parameter
set output "dppc_a_kst.tex"
set xrange [-1:16]
set yrange [9.4:9.9]
set ylabel '$a/\si{nm^{-3}}$'
set xtics 2
set ytics 0.1
plot 'data/DPPC_a.dat' u (-$1):2 w p lc 1 lw 3 t'',\
     'data/DPPC_a_FIT.dat' u (-$1):2 w l lc 1 lw 3 t''
    

# NPT SIMULATIONS AREA
set output "dppc_area.tex"
set xrange [0:150]
set yrange [0.59:0.65]
set ylabel '$A_{\si{l}}/\si{nm^{2}}$'
set xlabel '$t/\si{ns}$'
set xtics 25
set ytics 0.02
set key at screen 0.6, 0.75 
plot      'dppc_large/EQUI-LX_PLOT_DATA.dat' u ($1*0.03/1000):(0.64+$2*0.) w l lw 3  dt 2 lc 8 t 'exp',\
	  'dppc_large/FORT-LX_PLOT_DATA.dat' u (($1+5E5)*0.03/1000):(0.64+$2*0.) w l lw 3  dt 2 lc 8 t '',\
	  'dppc_large/EQUI-LX_PLOT_DATA.dat' u ($1*0.03/1000):($2**2/(33282/2)) w l lw 3 lc 7   t 'sim' ,\
	  'dppc_large/FORT-LX_PLOT_DATA.dat' u (($1+5E5)*0.03/1000):($2**2/(33282/2)) w l lw 3 lc 7   t ''
