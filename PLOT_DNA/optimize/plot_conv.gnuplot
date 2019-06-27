set terminal epslatex size 3.4,2.3 font ",10" standalone header '\usepackage{siunitx}'  
#3.42.3
#bending
set output 'eta_opt.tex'
set border lw 2
set ylabel '$\eta/\si{nm}$'
set xlabel '$N_{\si{it}}/\#$'
set yrange [0.3:10]
set xrange [-1:101] 
set key  maxrow 4 samplen 1 spacing -2 width 2
set logscale y
plot "opt.dat"   using 0:($5) with p lw 2 title '',\
     "opt_best.dat"   using 0:($5) w l lw 2 title ''
 
set output 'chi_opt.tex'
set ylabel '$\chi/\si{kJ.mol^{-1}}$'
unset logscale y
set key above
set xrange [-1:101]
set yrange [-30:15]
plot "opt.dat"   using 0:1 w p lw 2 title '$\chi_{NW}$',\
     ""		 using 0:2 w p lw 2 title '$\chi_{NN}$',\
     ""		 using 0:3 w p lw 2 title '$\chi_{PW}$',\
     "opt_best.dat"   using 0:1 w l lw 2 t '',\
     ""		 using 0:2 w l lw 2 title '',\
     ""		 using 0:3 w l lw 2 title ''



     
