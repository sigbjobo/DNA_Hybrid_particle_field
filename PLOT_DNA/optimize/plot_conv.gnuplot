set terminal epslatex size 3.4,2.3 font ",10" standalone header '\usepackage{siunitx}'  
#3.42.3
#bending
set output 'eta_opt.tex'
set border lw 2
set ylabel '$\eta/\%$'
set xlabel '$N_{\si{it}}/\#$'
#set yrange [0:26]
 
#set key bottom right maxrow 3 samplen 1 spacing 1 width -4

plot "opt.dat"   using 1:6:7 w errorbars lw 2 title ''
 
set output 'eta_opt.tex'
set ylabel '$\chi/\si{kJ.mol^{-1}}$'
plot "opt.dat"   using 1:2 w l lw 2 title ''
     ""		 using 1:3 w l lw 2 title ''
     ""		 using 1:4 w l lw 2 title ''	
     ""		 using 1:5 w l lw 2 title ''


     
