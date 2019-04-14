set terminal epslatex size 3.4,2.3 font ",10" standalone header '\usepackage{siunitx}'  
#3.42.3
#bending
set output 'eta_opt.tex'
set border lw 2
set ylabel '$\eta/\si{nm}$'
set xlabel '$N_{\si{it}}/\#$'
#set yrange [0:26]
set xrange [-1:51] 
set key  maxrow 4 samplen 1 spacing -2 width 2
#set logscale y
plot "opt.dat"   using 0:(-0.1*$5):(0.1*$6) with errorbars lw 2 title ''
 
set output 'chi_opt.tex'
set ylabel '$\chi/\si{kJ.mol^{-1}}$'
#unset logscale y
set key above
set yrange [-20:25]
plot "opt.dat"   using 0:1 w p lw 2 title '$\chi_{NW}$',\
     ""		 using 0:2 w p lw 2 title '$\chi_{NN}$',\
     ""		 using 0:3 w p lw 2 title '$\chi_{PW}$',\
     ""		 using 0:4 w p lw 2 title '$\chi_{PP}$'


     
