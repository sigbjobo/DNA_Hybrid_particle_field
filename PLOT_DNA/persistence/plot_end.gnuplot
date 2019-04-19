set terminal epslatex size 3.4,2.3 font ",10" standalone header '\usepackage{siunitx}'  
#3.42.3
#bending

set border lw 2
set ylabel '$R_{\si{ee}}/\si{nm}$'
set xlabel '$t/\si{ns}$'
#set yrange [0:26]

set key bottom right maxrow 3 samplen 1 spacing 1 width -4

set output 'end_end.tex'
plot "PLOT_DATA/END_END.dat"   using 1:(0.1*$7) w l lw 2 title '\footnotesize $k_{\phi}=\SI{5}{kJ.mol^{-1}}$',\
     ""		     using 1:(0.1*$8) w l lw 2 title '\footnotesize $k_{\phi}=\SI{8}{kJ.mol^{-1}}$',\
     ""  	     using 1:(0.1*$2) w l lw 2 title '\footnotesize $k_{\phi}=\SI{10}{kJ.mol^{-1}}$' 

set output 'end_end_dist.tex'
set xlabel '$R_{\si{ee}}/\si{nm}$'
set ylabel '$P(R_{\si{ee}})$'
plot "PLOT_DATA/SIM_5.xvg"   using (0.1*$1):(10*$2) w l lw 2 title '\footnotesize $k_{\phi}=\SI{5}{kJ.mol^{-1}}$',\
     "PLOT_DATA/SIM_8.xvg"   using (0.1*$1):(10*$2) w l lw 2 title '\footnotesize $k_{\phi}=\SI{8}{kJ.mol^{-1}}$',\
     "PLOT_DATA/SIM_10.xvg"  using (0.1*$1):(10*$2) w l lw 2 title '\footnotesize $k_{\phi}=\SI{10}{kJ.mol^{-1}}$' 


set output 'end_end_mean.tex'
set xlabel '$k_{\phi}/\si{kJ.mol^{-1}}$'
set ylabel '$R_{\si{ee}}/\si{nm}$'
#set ylabel '$l_p}/\si{nm}$'
set xrange [4:11]
plot "PLOT_DATA/mean.dat"   using 1:(0.1*$2):(0.1*$3) w errorbars lw 2 title '',\
#plot "PLOT_DATA/mean.dat"   using 1:(0.1*$2):(0.1*$3) w errorbars lw 2 title '',\
    

 