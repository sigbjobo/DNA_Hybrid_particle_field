set terminal epslatex size 3.4,2.3 font ",10" standalone header '\usepackage{siunitx}'  
#3.42.3
#bending
set output 'end_end.tex'
set border lw 2
set ylabel '$R_{\si{ee}}/\si{nm}$'
set xlabel '$t/\si{ns}$'
set yrange [0:26]

set key bottom right maxrow 3 samplen 1 spacing 1 width -4

plot "end_end/sim_5.dat"   using ($1*0.03):(0.1*$2) w l lw 2 title '\footnotesize $k_{\phi}=\SI{5}{kJ.mol^{-1}}$',\
      "end_end/sim_6.dat"   using ($1*0.03):(0.1*$2) w l lw 2 title '\footnotesize$k_{\phi}=\SI{6}{kJ.mol^{-1}}$',\
      "end_end/sim_7.dat"   using ($1*0.03):(0.1*$2) w l lw 2 title '\footnotesize$k_{\phi}=\SI{7}{kJ.mol^{-1}}$',\
      "end_end/sim_8.dat"   using ($1*0.03):(0.1*$2) w l lw 2 title '\footnotesize$k_{\phi}=\SI{8}{kJ.mol^{-1}}$',\
      "end_end/sim_9.dat"   using ($1*0.03):(0.1*$2) w l lw 2 title '\footnotesize $k_{\phi}=\SI{9}{kJ.mol^{-1}}$',\
      "end_end/sim_10.dat"   using ($1*0.03):(0.1*$2) w l lw 2 title '\footnotesize $k_{\phi}=\SI{10}{kJ.mol^{-1}}$'
     
