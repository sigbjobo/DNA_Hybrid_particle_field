set terminal epslatex size 3.4,2.4 font ",10" standalone header '\usepackage{siunitx}'  
#3.42.3
#bending

#set yrange [0:26]


set border lw 2
set ylabel '$\chi_{\si{NW}}/\si{kJ.mol^{-1}}$'
set xlabel '$k_{\phi}/\si{kJ.mol^{-1}}$'
set cblabel '$R_{\si{EE}}/\si{nm}$'

set lmargin at screen 0.15
set rmargin at screen 0.80
set tmargin at screen 0.95
set bmargin at screen 0.25
set pm3d map
#set palette color
#set palette defined 
set xrange [5:15]

set output "ee-mean-pd.tex"
splot "PLOT_DATA/EE_mean_order.dat" u 1:2:($3*0.1)  t ''

set output "rg-mean-pd.tex"
set cblabel '$R_{\si{G}}/\si{nm}$'
splot "PLOT_DATA/RG_mean_order.dat" u 1:2:($3*0.1)  t ''

