
set terminal epslatex size 3.4,2.3 font ",10" standalone header '\usepackage{siunitx}'  
#3.42.3
#bending

set border lw 2
set ylabel 'Base pair number'
set xlabel '$t/\si{ns}$'
set yrange [0:21]
set xrange [0:1000]
set cblabel '$d_{\si{bp}}/\si{nm}$'
set output "hairpin-form.tex"
set dgrid3d 22,53 qnorm 2
set lmargin at screen 0.15
set rmargin at screen 0.8
set tmargin at screen 0.95
set bmargin at screen 0.25
set pm3d map
set palette color
set palette defined 
splot 'PLOT_DATA/contact_SIM_10.dat'using ($1*20000*0.03*1E-3):2:(0.1*$3) t ''
     
