set terminal epslatex size 3.4,2. font ",10" standalone header '\usepackage{siunitx}'  
#3.42.3
#bending

#set yrange [0:26]


set border lw 2

set xlabel '$t/\si{ns}$'

# END TO END DISTANCE

set ylabel '$R_{\si{EE}}/\si{nm}$'
set yrange [0:30]

# 5
set output "ee-5.tex"
set title '$k_\phi=\SI{5}{kJ.mol^{-1}}$'
plot "PLOT_DATA/EE_5_0.dat"  u 1:($2*0.1) w l t '0',\
     "PLOT_DATA/EE_5_5.dat"  u 1:($2*0.1) w l t '5',\
     "PLOT_DATA/EE_5_10.dat" u 1:($2*0.1) w l t '10',\
     "PLOT_DATA/EE_5_20.dat" u 1:($2*0.1) w l t '20'

# 7.5
set output "ee-7_5.tex"
set title '$k_\phi=\SI{7.5}{kJ.mol^{-1}}$'
plot "PLOT_DATA/EE_7.5_0.dat"  u 1:($2*0.1) w l t '0',\
     "PLOT_DATA/EE_7.5_5.dat"  u 1:($2*0.1) w l t '5',\
     "PLOT_DATA/EE_7.5_10.dat" u 1:($2*0.1) w l t '10',\
     "PLOT_DATA/EE_7.5_20.dat" u 1:($2*0.1) w l t '20'

# 10
set output "ee-10.tex"
set title '$k_\phi=\SI{10}{kJ.mol^{-1}}$'
plot "PLOT_DATA/EE_10_0.dat"  u 1:($2*0.1) w l t '0',\
     "PLOT_DATA/EE_10_5.dat"  u 1:($2*0.1) w l t '5',\
     "PLOT_DATA/EE_10_10.dat" u 1:($2*0.1) w l t '10',\
     "PLOT_DATA/EE_10_20.dat" u 1:($2*0.1) w l t '20'

# 15
set output "ee-15.tex"
set title '$k_\phi=\SI{15}{kJ.mol^{-1}}$'
plot "PLOT_DATA/EE_15_0.dat"  u 1:($2*0.1) w l t '0',\
     "PLOT_DATA/EE_15_5.dat"  u 1:($2*0.1) w l t '5',\
     "PLOT_DATA/EE_15_10.dat" u 1:($2*0.1) w l t '10',\
     "PLOT_DATA/EE_15_20.dat" u 1:($2*0.1) w l t '20'

# RG

set ylabel '$R_{\si{G}}/\si{nm}$'
set yrange [1.5:8]


# 5
set output "RG-5.tex"
set title '$k_\phi=\SI{5}{kJ.mol^{-1}}$'
plot "PLOT_DATA/RG_5_0.dat"  u 1:($2*0.1) w l t '0',\
     "PLOT_DATA/RG_5_5.dat"  u 1:($2*0.1) w l t '5',\
     "PLOT_DATA/RG_5_10.dat" u 1:($2*0.1) w l t '10',\
     "PLOT_DATA/RG_5_20.dat" u 1:($2*0.1) w l t '20'

# 7.5
set output "RG-7_5.tex"
set title '$k_\phi=\SI{7.5}{kJ.mol^{-1}}$'
plot "PLOT_DATA/RG_7.5_0.dat"  u 1:($2*0.1) w l t '0',\
     "PLOT_DATA/RG_7.5_5.dat"  u 1:($2*0.1) w l t '5',\
     "PLOT_DATA/RG_7.5_10.dat" u 1:($2*0.1) w l t '10',\
     "PLOT_DATA/RG_7.5_20.dat" u 1:($2*0.1) w l t '20'

# 10
set output "RG-10.tex"
set title '$k_\phi=\SI{10}{kJ.mol^{-1}}$'
plot "PLOT_DATA/RG_10_0.dat"  u 1:($2*0.1) w l t '0',\
     "PLOT_DATA/RG_10_5.dat"  u 1:($2*0.1) w l t '5',\
     "PLOT_DATA/RG_10_10.dat" u 1:($2*0.1) w l t '10',\
     "PLOT_DATA/RG_10_20.dat" u 1:($2*0.1) w l t '20'

# 15
set output "RG-15.tex"
set title '$k_\phi=\SI{15}{kJ.mol^{-1}}$'
plot "PLOT_DATA/RG_15_0.dat"  u 1:($2*0.1) w l t '0',\
     "PLOT_DATA/RG_15_5.dat"  u 1:($2*0.1) w l t '5',\
     "PLOT_DATA/RG_15_10.dat" u 1:($2*0.1) w l t '10',\
     "PLOT_DATA/RG_15_20.dat" u 1:($2*0.1) w l t '20'

