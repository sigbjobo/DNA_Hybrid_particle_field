set terminal epslatex size 3.4,2.5 font ",10" standalone header '\usepackage{siunitx}'  
#3.42.3
#bending

#set yrange [0:26]


set border lw 2

set xlabel '$t/\si{ns}$'

# END TO END DISTANCE

set ylabel '$R_{\si{EE}}/\si{nm}$'
set yrange [5:22]

set xtics 1000

set output "EE-DS.tex"


plot "PLOT_DATA/EE_5_.dat"  u 1:($2*0.1) w l lw 2 t '5',\
     "PLOT_DATA/EE_6_.dat"  u 1:($2*0.1) w l lw 2 t '6',\
     "PLOT_DATA/EE_7_.dat"  u 1:($2*0.1) w l lw 2 t '7',\
     "PLOT_DATA/EE_8_.dat"  u 1:($2*0.1) w l lw 2 t '8',\
     "PLOT_DATA/EE_9_.dat"  u 1:($2*0.1) w l lw 2 t '9',\
     "PLOT_DATA/EE_10_.dat" u 1:($2*0.1) w l lw 2 t '10'
#plot      "PLOT_DATA/EE_10_.dat" u 1:($2*0.1) w l lw 2 t ''



# RG

set ylabel '$R_{\si{G}}/\si{nm}$'
set yrange [2.5:6.5]

set output "RG-DS.tex"

plot "PLOT_DATA/RG_5_.dat"  u 1:($2*0.1) w l lw 2 t '5',\
     "PLOT_DATA/RG_6_.dat" u 1:($2*0.1) w l lw 2 t '6',\
     "PLOT_DATA/RG_7_.dat"  u 1:($2*0.1) w l lw 2 t '7',\
     "PLOT_DATA/RG_8_.dat"  u 1:($2*0.1) w l lw 2 t '8',\
     "PLOT_DATA/RG_9_.dat"  u 1:($2*0.1) w l lw 2 t '9',\
     "PLOT_DATA/RG_10_.dat" u 1:($2*0.1) w l lw 2 t '10'




# CORR
f1(x) = exp(-x/a)
set print "lp.dat"
fit f1(x) "PLOT_DATA/CORR_5_.dat" u ($1*0.34):2 via a
print 5, a
fit f1(x) "PLOT_DATA/CORR_6_.dat" u ($1*0.34):2 via a
print 6, a
fit f1(x) "PLOT_DATA/CORR_7_.dat" u ($1*0.34):2 via a
print 7, a
fit f1(x) "PLOT_DATA/CORR_8_.dat" u ($1*0.34):2 via a
print 8, a
fit f1(x) "PLOT_DATA/CORR_9_.dat" u ($1*0.34):2 via a
print 9, a
fit f1(x) "PLOT_DATA/CORR_10_.dat" u ($1*0.34):2 via a
print 10, a
unset print


set ylabel '$\left<\mathbf{t}\cdot\mathbf{t}_l\right>$'
set xlabel '$l/\si{nm}$'

set yrange [0:1]
set xrange [0:20]
set xtics 5
# 5
set output "CORR-DS.tex"

# plot "PLOT_DATA/CORR_5_.dat"  u ($1*0.34):2 w p lw 2 t '5',\
#      "PLOT_DATA/CORR_6_.dat"  u ($1*0.34):2 w p lw 2 t '6',\
#      "PLOT_DATA/CORR_7_.dat"  u ($1*0.34):2 w p lw 2 t '7',\
#      "PLOT_DATA/CORR_8_.dat"  u ($1*0.34):2 w p lw 2 t '8',\
#      "PLOT_DATA/CORR_9_.dat"  u ($1*0.34):2 w p lw 2 t '9',\
#      "PLOT_DATA/CORR_10_.dat" u ($1*0.34):2 w p lw 2 t '10'
plot   "PLOT_DATA/CORR_10_.dat" u ($1*0.34):2 w p lw 2 t ''


set output "LP-DS.tex"
set xtics auto
set ytics auto
set ylabel '$l_{\si{p}}$'
set xlabel '$k_\phi$'
set xrange [4:11]
set yrange [0:100]
plot "lp.dat" t '' w p
