#COMMON SETTINGS
set border lw 4

########################
#          KAPPA PART  #
########################
set terminal epslatex size 3.4,2.3 font ",10" standalone header '\usepackage{siunitx}'  


# PLOT PRESSURE AS FUNCTION OF KAPPA 
set output "p_kst_memdspc.tex"
set xtics 2
set xrange [-1:16]
set ylabel '$P/\si{bar}$'
set xlabel '$K_{\text ST}/\si{kJ^{-1}.mol}$'
Pzz(x) =a1+b1*x +c1*x**2
c1=1800
b1=1
a1=-100
Pxx(x) =a2+b2*x +c2*x**2
#c2=1800
#b2=1
#a2=-100
P(x) = a3+b3*x +c3*x**2
a3=1800
b3=10
c3=-10


fit Pzz(x) 'PRESSURE_DATA/presszzavg_mean.dat' u (-$1):($2/1E5)  via a1, b1, c1
fit Pxx(x) 'PRESSURE_DATA/pressxxavg_mean.dat' u (-$1):($2/1E5)  via a2, b2, c2
fit P(x)   'PRESSURE_DATA/pressavg_mean.dat'   u  (-$1):($2/1E5)  via a3, b3, c3
# title_p(a3,b3,c3)   = sprintf('\tiny{ $P=$%.1f +%.2f$K_{\text ST}$%.3f$K_{\text ST}^2$}', a3, b3,c3)
# title_pxx(a2,b2,c2) = sprintf('\tiny{ $P_{xx}=$%.1f +%.2f$K_{\text ST}$%.3f$K_{\text ST}^2$}', a2, b2,c2)
# title_pzz(a1,b1,c1) = sprintf('\tiny{ $P_{zz}=$%.1f +%.2f$K_{\text ST}$%.3f$K_{\text ST}^2$}', a1, b1,c1)

set key left
plot 'PRESSURE_DATA/pressavg_mean.dat' u (-$1):($2/1E5) w p lw 2 lc 1 t '',\
     '< sort -nk1 PRESSURE_DATA/pressavg_mean.dat' u   (-$1):(P(-$1)) w l lw 2 lc 1 t "$P$",\
     'PRESSURE_DATA/pressxxavg_mean.dat' u (-$1):($2/1E5) w p lw 2 lc 2 t '',\
     '< sort -nk1 PRESSURE_DATA/pressxxavg_mean.dat' u   (-$1):(Pxx(-$1)) w l lw 2 lc 2 t '$P_{\si L}$',\
     'PRESSURE_DATA/presszzavg_mean.dat' u (-$1):($2/1E5) w p lw 2 lc 3 t '',\
     '< sort -nk1 PRESSURE_DATA/presszzavg_mean.dat' u   (-$1):(Pzz(-$1)) w l lw 2 lc 3 t '$P_{\si N}$'





# CROSSING AT klm=-5.46


# PLOT PRESSURE AS FUNCTION OF KAPPA 
set ytics 0.25
set yrange [9:10]
set output "a_kst_memdspc.tex"
set ylabel '$a/\si{nm^{-3}}$'
set xlabel '$K_{\text{ST}}/\si{kJ^{-1}.mol}$'
kompT(x) = a4+b4*x +c4*x**2
a4=1800
b4=10
c4=-10
#kompT(x) = a*x**b +c
#c=9
#b=0.5
fit kompT(x) 'PRESSURE_DATA/klm_a.dat' u (-$1):2  via a4, b4, c4
#set key 
#title_f(a4,b4,c4)  = sprintf('\tiny $a=$%.2f +%.2E$K_{\text ST}$%.2E$K_{\text ST}^2$', a4, b4,c4)
plot 'PRESSURE_DATA/klm_a.dat' u (-$1):2 w p lw 2 lc 1 t '' ,\
     '< sort -nk1 PRESSURE_DATA/klm_a.dat' u (-$1):(kompT(-$1)) w l lw 2 lc 1 t''  # title_f(a4,b4,c4)



# NPT


set output "L_NPTdspc.tex"
set xlabel '$t/\si{ps}$'
set ylabel '$L/\si{nm}$'
set xtics 500
set ytics 0.25

set xrange [0:3000]
set yrange [12.9:14.1]
set key center right
plot "PRESSURE_DATA_EQ/lx.dat" u ($1*0.03):2 w l t'$L_{xx,yy}$',\
     "PRESSURE_DATA_EQ/lz.dat" u ($1*0.03):2 w l t'$L_{zz}$'


set output "P_NPTdspc.tex"
set xlabel '$t/\si{ps}$'
set ylabel '$P/\si{bar}$'
set xtics 500
set ytics 7.5
set key top right
set xrange [0:3000]
set yrange [-30:35]

plot "PRESSURE_DATA_EQ/pressavg.dat" u ($1*0.03):($2/1E5) w l t'$P$',\
     "PRESSURE_DATA_EQ/pressxxavg.dat" u ($1*0.03):($2/1E5) w l t'$P_{L}$',\
     "PRESSURE_DATA_EQ/presszzavg.dat" u ($1*0.03):($2/1E5) w l t'$P_{N}$'
     				