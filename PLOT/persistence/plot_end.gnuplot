set terminal epslatex size 3.4,2.3 font ",10" standalone header '\usepackage{siunitx}'  
#3.42.3
#bending

set border lw 2
set ylabel '$R_{\si{ee}}/\si{nm}$'
set xlabel '$t/\si{ns}$'
#set yrange [0:26]

set key bottom right maxrow 3 samplen 1 spacing 1 width -4

set output 'end_end.tex'
plot "PLOT_DATA/5_end.dat"   using 1:(0.1*$7) w l lw 2 title '\footnotesize $k_{\phi}=\SI{5}{kJ.mol^{-1}}$',\
     "PLOT_DATA/6_end.dat"   using 1:(0.1*$8) w l lw 2 title '\footnotesize $k_{\phi}=\SI{6}{kJ.mol^{-1}}$',\
     "PLOT_DATA/7_end.dat"   using 1:(0.1*$2) w l lw 2 title '\footnotesize $k_{\phi}=\SI{7}{kJ.mol^{-1}}$',\
     "PLOT_DATA/8_end.dat"   using 1:(0.1*$2) w l lw 2 title '\footnotesize $k_{\phi}=\SI{8}{kJ.mol^{-1}}$',\
     "PLOT_DATA/9_end.dat"   using 1:(0.1*$2) w l lw 2 title '\footnotesize $k_{\phi}=\SI{9}{kJ.mol^{-1}}$',\
     "PLOT_DATA/10_end.dat"  using 1:(0.1*$2) w l lw 2 title '\footnotesize $k_{\phi}=\SI{10}{kJ.mol^{-1}}$' 

set output 'end_end_dist.tex'
set xlabel '$R_{\si{ee}}/\si{nm}$'
set ylabel '$P(R_{\si{ee}})$'
plot "PLOT_DATA/5.xvg"   using (0.1*$1):(10*$2) w l lw 2 title '\footnotesize $k_{\phi}=\SI{5}{kJ.mol^{-1}}$',\
     "PLOT_DATA/6.xvg"   using (0.1*$1):(10*$2) w l lw 2 title '\footnotesize $k_{\phi}=\SI{6}{kJ.mol^{-1}}$',\
     "PLOT_DATA/7.xvg"   using (0.1*$1):(10*$2) w l lw 2 title '\footnotesize $k_{\phi}=\SI{7}{kJ.mol^{-1}}$',\
     "PLOT_DATA/8.xvg"   using (0.1*$1):(10*$2) w l lw 2 title '\footnotesize $k_{\phi}=\SI{8}{kJ.mol^{-1}}$',\
     "PLOT_DATA/9.xvg"   using (0.1*$1):(10*$2) w l lw 2 title '\footnotesize $k_{\phi}=\SI{9}{kJ.mol^{-1}}$',\
     "PLOT_DATA/10.xvg"  using (0.1*$1):(10*$2) w l lw 2 title '\footnotesize $k_{\phi}=\SI{10}{kJ.mol^{-1}}$' 


set output 'end_end_mean.tex'
set xlabel '$k_{\phi}/\si{kJ.mol^{-1}}$'
set ylabel '$l_{\si{p}}/\si{nm}$'
set xrange [4:9]
L=68*0.34
plot "PLOT_DATA/mean.dat"   using 1:((0.1*$2)**2/(2*L)):($2*0.1/L*$3) w errorbars lw 2 title ''
    

 