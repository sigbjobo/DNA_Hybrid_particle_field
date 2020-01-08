#COMMON SETTINGS
set border lw 4
set format y '\fontfamily{cmss}%g' 
set format y2 '\textcolor{red}{\fontfamily{cmss}%g}' 

set format x '\fontfamily{cmss}%g' 
set ylabel offset  5
set lmargin 8
set rmargin 4
 
set style line 1  lt 8
set style line 2  lt 7
set style line 3  lt 6
set style line 4  lt 5

set terminal epslatex size 2,1.5 font "cmss,10" standalone header "\\usepackage{siunitx}" 


# SURFACE TENSION
set output "dppc_gamma.tex"
set xrange [-5:31]
set yrange [-60:100]
set ylabel '$\gamma/\si{mJ.m^{-2}}$'
set xlabel '$K_{\text ST}/\si{kJ^{-1}.mol}$'
set xtics 5
set ytics 40
set key  left width 3


set ylabel offset  6.75
set lmargin 5.25
set rmargin 1.25
set xzeroaxis  lw 4
plot 'data/dppc_40x40_GAMMA.dat' u (-$1):2 with linespoints lw 4 lc 7 t''
unset xzeroaxis

set ylabel offset  6
set lmargin 8
set rmargin 4

     # 'data/DOPC_GAMMA_FIT.dat' u (-$1):2 w l lc 1 t'',\
     # 'data/DSPC_GAMMA.dat' u (-$1):2 w p lc 2 t'DSPC',\
     # 'data/DSPC_GAMMA_FIT.dat' u (-$1):2 w l lc 2 t'',\
     # 'data/DPPC_GAMMA.dat' u (-$1):2 w p lc 3 t'DPPC',\
     # 'data/DPPC_GAMMA_FIT.dat' u (-$1):2 w l lc 3 t'',\
     # 'data/DMPC_GAMMA.dat' u (-$1):2 w p lc 4 t'DMPC',\
     # 'data/DMPC_GAMMA_FIT.dat' u (-$1):2 w l lc 4 t''

# A parameter
set output "mem_a_kst.tex"
set xrange [-1:16]
set yrange [8.75:11]
set ylabel '$a/\si{nm^{-3}}$'
set xlabel '$K_{\text{ST}}/\si{kJ^{-1}.mol}$'
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

# Density profiles
set terminal epslatex size 2,1.5 font "cmss,10" standalone header "\\usepackage{siunitx}" 
#\
#   \\usepackage[T1]{fontenc}\n\\usepackage{mathptmx}\n\\usepackage{cmss}"  
#'\usepackage{siunitx}'  

set output "dppc_density.tex"
set xrange [-4.5:4.5]
set yrange [0:10]
set xlabel '$z/\si{nm}$'
set ylabel '$\phi/\si{nm^{-3}}$'
set xtics 2
set mxtics 1
set ytics 2
set mytics 1.
#unset key
plot "DPPC_PRESSURE_DENSITY/density_sym.dat" u (($1-0.5)*21.16):2 w l lw 3 t 'N',\
     "DPPC_PRESSURE_DENSITY/density_sym.dat" u (($1-0.5)*21.16):3 w l lw 3 t 'P',\
     "DPPC_PRESSURE_DENSITY/density_sym.dat" u (($1-0.5)*21.16):4 w l lw 3 t 'G',\
     "DPPC_PRESSURE_DENSITY/density_sym.dat" u (($1-0.5)*21.16):($5+$6) w l lw 3 t 'C',\
     "DPPC_PRESSURE_DENSITY/density_sym.dat" u (($1-0.5)*21.16):7 w l lw 3 t 'W' #,\
     #  "DPPC_PRESSURE_DENSITY/density_sym.dat" u (($1-0.5)*21.16):2 w l lw 3 t 'N',\	
     # "DPPC_PRESSURE_DENSITY/density_sym.dat" u (($1-0.5)*21.16):3 w l lw 3 t 'P',\
     # "DPPC_PRESSURE_DENSITY/density_sym.dat" u (($1-0.5)*21.16):4 w l lw 3 t 'G',\
     # "DPPC_PRESSURE_DENSITY/density_sym.dat" u (($1-0.5)*21.16):($5+$6) w l lw 3 t 'C',\
     "DPPC_PRESSURE_DENSITY/density_sym.dat" u (($1-0.5)*21.16):7 w l lw 3 t 'W' 
set output "dmpc_density.tex"
plot "DMPC_PRESSURE_DENSITY/density_sym.dat" u (($1-0.5)*21.83):2 w l lw 3 t 'N',\
     "DMPC_PRESSURE_DENSITY/density_sym.dat" u (($1-0.5)*21.83):3 w l lw 3 t 'P',\
     "DMPC_PRESSURE_DENSITY/density_sym.dat" u (($1-0.5)*21.83):4 w l lw 3 t 'G',\
     "DMPC_PRESSURE_DENSITY/density_sym.dat" u (($1-0.5)*21.83):($5+$6) w l lw 3 t 'C',\
     "DMPC_PRESSURE_DENSITY/density_sym.dat" u (($1-0.5)*21.83):7 w l lw 3 t 'W'
set output "dopc_density.tex"
plot "DOPC_PRESSURE_DENSITY/density_sym.dat" u (($1-0.5)*21.97):2 w l lw 3 t 'N',\
     "DOPC_PRESSURE_DENSITY/density_sym.dat" u (($1-0.5)*21.97):3 w l lw 3 t 'P',\
     "DOPC_PRESSURE_DENSITY/density_sym.dat" u (($1-0.5)*21.97):4 w l lw 3 t 'G',\
     "DOPC_PRESSURE_DENSITY/density_sym.dat" u (($1-0.5)*21.97):($5+$6) w l lw 3 t 'C',\
     "DOPC_PRESSURE_DENSITY/density_sym.dat" u (($1-0.5)*21.97):7 w l lw 3 t 'W'
set output "dspc_density.tex"
plot "DSPC_PRESSURE_DENSITY/density_sym.dat" u (($1-0.5)*21.55):2 w l lw 3 t 'N',\
     "DSPC_PRESSURE_DENSITY/density_sym.dat" u (($1-0.5)*21.55):3 w l lw 3 t 'P',\
     "DSPC_PRESSURE_DENSITY/density_sym.dat" u (($1-0.5)*21.55):4 w l lw 3 t 'G',\
     "DSPC_PRESSURE_DENSITY/density_sym.dat" u (($1-0.5)*21.55):($5+$6) w l lw 3 t 'C',\
     "DSPC_PRESSURE_DENSITY/density_sym.dat" u (($1-0.5)*21.55):7 w l lw 3 t 'W'


set terminal epslatex size 3.4,2.3 font "cmss,10" standalone header "\\usepackage{siunitx}"

set yrange [0:350]
set xlabel '$z/\si{nm}$'
set ylabel '$\phi_e/\si{nm^{-3}}$'
set xtics 2
set mxtics 1
set ytics 100
set mytics 1.
set key  center left samplen 2 width -0.2
set output "dppc_el_density.tex"
set ylabel ''
plot "DPPC_PRESSURE_DENSITY/density_sym.dat" u (($1-0.5)*21.83):($2*42) w l lw 3 lt 8 t 'N',\
     "DPPC_PRESSURE_DENSITY/density_sym.dat" u (($1-0.5)*21.83):($3*55) w l lw 3 lt 7 t 'P',\
    "DPPC_PRESSURE_DENSITY/density_sym.dat" u (($1-0.5)*21.83):($4*38) w l lw 3 lt 6 t 'G',\
     "DPPC_PRESSURE_DENSITY/density_sym.dat" u (($1-0.5)*21.83):(($5+$6)*32+$8*25)  w l  lw 3 lt 4 t 'C',\
    "DPPC_PRESSURE_DENSITY/density_sym.dat" u (($1-0.5)*21.83):($7*40) w l lw 3  lt 5 t 'W',\
    "fig6/B/fig-6-B-N.dat"      u 1:2 w l dt 3 lw 3 lt 8 t '',\
    "fig6/B/fig-6-B-P.dat"      u 1:2 w l dt 3 lw 3 lt 7 t '',\
    "fig6/B/fig-6-B-G.dat"      u 1:2 w l dt 3 lw 3 lt 6 t '',\
     "<paste fig6/B/fig-6-B-C-tail.dat fig6/B/fig-6-B-C-end.dat" u 1:($2+$4) w l dt 3 lw 3 lt 4 t '',\
     "fig6/B/fig-6-B-water.dat"  u 1:2 w l dt 3 lw 3 lt 5 t ''

    #  "DPPC_PRESSURE_DENSITY/density_sym.dat" u (($1-0.5)*21.83):($3*55) w l lw 3 t 'P',\
    #  "DPPC_PRESSURE_DENSITY/density_sym.dat" u (($1-0.5)*21.83):($4*38) w l lw 3 t 'G',\
    #  "DPPC_PRESSURE_DENSITY/density_sym.dat" u (($1-0.5)*21.83):(($5+$6)*32+$8*25) w l lw 3 t 'C',\
    #  "DPPC_PRESSURE_DENSITY/density_sym.dat" u (($1-0.5)*21.83):($7*40) w l lw 3 t 'W' 
set ylabel '$\phi_e/\si{nm^{-3}}$'
     
set output "dspc_el_density.tex"
plot "DSPC_PRESSURE_DENSITY/density_sym.dat" u (($1-0.5)*21.97):($2*42) w l lw 3 t 'N',\
     "DSPC_PRESSURE_DENSITY/density_sym.dat" u (($1-0.5)*21.97):($3*55) w l lw 3 t 'P',\
     "DSPC_PRESSURE_DENSITY/density_sym.dat" u (($1-0.5)*21.97):($4*38) w l lw 3 t 'G',\
     "DSPC_PRESSURE_DENSITY/density_sym.dat" u (($1-0.5)*21.97):(($5+$6)*32+$8*25) w l lw 3 t 'C',\
     "DSPC_PRESSURE_DENSITY/density_sym.dat" u (($1-0.5)*21.97):($7*40) w l lw 3 t 'W'
set output "dmpc_el_density.tex"
plot "DMPC_PRESSURE_DENSITY/density_sym.dat" u (($1-0.5)*21.83):($2*42) w l lw 3 t 'N',\
     "DMPC_PRESSURE_DENSITY/density_sym.dat" u (($1-0.5)*21.83):($3*55) w l lw 3 t 'P',\
     "DMPC_PRESSURE_DENSITY/density_sym.dat" u (($1-0.5)*21.83):($4*38) w l lw 3 t 'G',\
     "DMPC_PRESSURE_DENSITY/density_sym.dat" u (($1-0.5)*21.83):(($5+$6)*32+$8*25) w l lw 3 t 'C',\
     "DMPC_PRESSURE_DENSITY/density_sym.dat" u (($1-0.5)*21.83):($7*40) w l lw 3 t 'W' 
set output "dopc_el_density.tex"
plot "DOPC_PRESSURE_DENSITY/density_sym.dat" u (($1-0.5)*21.83):($2*42) w l lw 3 t 'N',\
     "DOPC_PRESSURE_DENSITY/density_sym.dat" u (($1-0.5)*21.83):($3*55) w l lw 3 t 'P',\
     "DOPC_PRESSURE_DENSITY/density_sym.dat" u (($1-0.5)*21.83):($4*38) w l lw 3 t 'G',\
     "DOPC_PRESSURE_DENSITY/density_sym.dat" u (($1-0.5)*21.83):(($5+$6)*32+$8*25) w l lw 3 t 'C',\
     "DOPC_PRESSURE_DENSITY/density_sym.dat" u (($1-0.5)*21.83):($7*40) w l lw 3 t 'W' 



set terminal epslatex size 3.4,2.3 font "cmss,10" standalone header "\\usepackage{siunitx} \\usepackage{xcolor}"
set output "dmpc_el_tot.tex"
set yrange [100:500]
set format y '\fontfamily{cmss}%g' 
set format x '\fontfamily{cmss}%g' 
set ylabel offset  5
set lmargin 8
set key bottom left width -4
plot "fig15A/fig-15-A-experimental.dat" u 1:2  w l lt 8 lw 4 t '\scriptsize exp',\
     "fig15A/fig-15-A-particle-field.dat" u 1:2  w linespoints lt 7 lw 4 t '\scriptsize hPF(old)',\
     "DMPC_PRESSURE_DENSITY/density_sym.dat" u (($1-0.5)*21.83):($2*42+$3*55+$4*38+($5+$6)*32+$7*40 + $8*25) w linespoints lt 6 lw 4 t '\scriptsize hPF-MD-2',\
     "fig15A/fig-15-A-particle-particle.dat" u 1:2  w linespoints lt 2 lw 4 t '\scriptsize MARTINI'

set output "dopc_el_tot.tex"
plot	   "fig15B/fig-15-B-experimental.dat" u 1:2  w l lt 8 lw 4 t '\scriptsize exp',\
	   "fig15B/fig-15-B-particle-field.dat" u 1:2  w linespoints lt 7 lw 4 t '\scriptsize hPF(new)',\
	   "DOPC_PRESSURE_DENSITY/density_sym.dat" u (($1-0.5)*21.97):($2*42+$3*55+$4*38+($5+$6)*32+$7*40+$8*25) w linespoints lt 6 lw 4 t '\scriptsize hPF-MD-2',\
	   "fig15B/fig-15-B-particle-particle.dat" u 1:2  w linespoints lt 2 lw 4 t '\scriptsize MARTINI'
set output "dppc_el_tot.tex"
plot	   "fig3/D/fig3-D-experimental.dat" u 1:2  w l lt 8 lw 4 t '\scriptsize experiment',\
	   "fig3/D/fig3-D-particle-field.dat" u 1:2  w linespoints lt 7 lw 4 t '\scriptsize hPF (old)',\
	   "DPPC_PRESSURE_DENSITY/density_sym.dat" u (($1-0.5)*21.97):($2*42+$3*55+$4*38+($5+$6)*32+$7*40+$8*25) w linespoints lt 6 lw 4 t '\scriptsize hPF (new)',\
	   "fig3/D/fig3-D-particle-particle.dat" u 1:2  w linespoints lt 2 lw 4 t '\scriptsize MARTINI'



set output "dppc_press_tot.tex"
unset border #right lt 7 lw 4
set yrange [-1.5:1.5]
set ytics 0.5
set key center bottom  width -4
set y2tics tc 'red'
set ytics nomirror 
set arrow 1 from 10, -1 to 10, 1 nohead lt 3
#set border lines 8 lc 7 dt 3
#set y2axis dt 3
set y2range [-6:6]

set arrow 1 from -4.5,-1.5 to  -4.5,1.5 lw 4 lt 8 nohead
set arrow 2 from -4.5,-1.5 to  +4.5,-1.5 lw 4 lt 8 nohead
set arrow 3 from  4.5,-1.5 to  +4.5,1.5 lw 4 lt 7 dt 3 nohead
set arrow 4 from  4.5,1.5 to  -4.5,1.5 lw 4 lt 8 nohead


#-4.5 from 4.5, -1.5 to 1.5, 1 nohead lt 3
#set y2tics lc 7
set ylabel '$(P_{\si N}-P_{\si L})/\SI{100}{bar}$'
plot	    "DPPC_PRESSURE_DENSITY/PRESS_TOT_sym.dat" u (($1-0.5)*21.97):((-0.5*($3+$4)+$5)/1E7)  w l lt 8 lw 4 t '\scriptsize hPF',\
	    "press_dppc_edholm.dat" u ($1-3):(-$2/100) axis x1y2 w l dt 3 lt 7 lw 4 t '\scriptsize Lindahl'

set output "dppc_press_contributions.tex"
set border #lines lw 4
set border lw 4
unset arrow 1
unset arrow 4
unset arrow 3
unset arrow 2
set ytics mirror
set yrange [-6:6]
set ytics 2
unset y2tics
#unset y2axis

set ylabel ''
plot	  "DPPC_PRESSURE_DENSITY/scf_press_sym.dat" u (($1-0.5)*21.97):((-0.5*($3+$4)+$5)/1E7)  w l dt 2 lt 7 lw 4 t '\scriptsize field',\
	  "DPPC_PRESSURE_DENSITY/bond_press_sym.dat" u (($1-0.5)*21.97):((-0.5*($2+$3)+$4)/1E7)  w l dt 3 lt 6 lw 4 t '\scriptsize bond',\
	  "DPPC_PRESSURE_DENSITY/angle_press_sym.dat" u (($1-0.5)*21.97):((-0.5*($2+$3)+$4)/1E7)  w l dt 5 lt 2 lw 4 t '\scriptsize ang',\




# Pressure profiles

set xrange [-5:5]
set yrange [-8:5]
set xlabel '$z/\si{nm}$'
set ylabel '$P/\SI{100}{bar}$'
set xtics 2
set mxtics 1
set ytics 2
 set mytics 1
unset key
set output "dppc_press.tex"
plot "DPPC_PRESSURE_DENSITY/PRESS_TOT_sym.dat" u (($1-0.5)*21.16):(($5-0.5*($3+$4))/1E7) w l lw 3 t '$\Delta P$',\
     "DPPC_PRESSURE_DENSITY/PRESS_TOT_sym.dat" u (($1-0.5)*21.16):(0.5*($3+$4)/1E7) w l lw 3 t '$P_L$',\
     "DPPC_PRESSURE_DENSITY/PRESS_TOT_sym.dat" u (($1-0.5)*21.16):(($5)/1E7) w l lw 3 t '$P_N$'
set output "dmpc_press.tex"
plot "DMPC_PRESSURE_DENSITY/PRESS_TOT_sym.dat" u (($1-0.5)*21.83):(($5-0.5*($3+$4))/1E7) w l lw 3 t '$\Delta P$',\
     "DMPC_PRESSURE_DENSITY/PRESS_TOT_sym.dat" u (($1-0.5)*21.83):(0.5*($3+$4)/1E7) w l lw 3 t '$P_L$',\
     "DMPC_PRESSURE_DENSITY/PRESS_TOT_sym.dat" u (($1-0.5)*21.83):(($5)/1E7) w l lw 3 t '$P_N$'
set output "dspc_press.tex"
plot "DSPC_PRESSURE_DENSITY/PRESS_TOT_sym.dat" u (($1-0.5)*21.55):(($5-0.5*($3+$4))/1E7) w l lw 3 t '$\Delta P$',\
     "DSPC_PRESSURE_DENSITY/PRESS_TOT_sym.dat" u (($1-0.5)*21.55):(0.5*($3+$4)/1E7) w l lw 3 t '$P_L$',\
     "DSPC_PRESSURE_DENSITY/PRESS_TOT_sym.dat" u (($1-0.5)*21.55):(($5)/1E7) w l lw 3 t '$P_N$'
set output "dopc_press.tex"
plot "DOPC_PRESSURE_DENSITY/PRESS_TOT_sym.dat" u (($1-0.5)*21.97):(($5-0.5*($3+$4))/1E7) w l lw 3 t '$\Delta P$',\
     "DOPC_PRESSURE_DENSITY/PRESS_TOT_sym.dat" u (($1-0.5)*21.97):(0.5*($3+$4)/1E7) w l lw 3 t '$P_L$',\
     "DOPC_PRESSURE_DENSITY/PRESS_TOT_sym.dat" u (($1-0.5)*21.97):(($5)/1E7) w l lw 3 t '$P_N$'


#"DPPC_PRESSURE_DENSITY/PRESS_TOT.dat" u (($1-0.5)*21.97):(($2)/1E5) w l lw 3 t 'P',\

