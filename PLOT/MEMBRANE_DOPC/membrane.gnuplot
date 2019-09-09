#COMMON SETTINGS
set border lw 4

########################
#          KAPPA PART  #
########################
set terminal epslatex size 3.4,2.3 font ",10" standalone header '\usepackage{siunitx}'  


# PLOT PRESSURE AS FUNCTION OF KAPPA 
set output "p_kst_memdopc.tex"
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
set output "a_kst_memdopc.tex"
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


set output "L_NPTdopc.tex"
set xlabel '$t/\si{ns}$'
set ylabel '$L/\si{nm}$'
set xtics 50
set ytics 0.25

set xrange [0:300]
set yrange [12.9:14.1]
#set key at -3,800
plot "PRESSURE_DATA_EQ/lx.dat" u ($1*0.03*1E-3):2 w l t'$L_{xx,yy}$',\
     "PRESSURE_DATA_EQ/lz.dat" u ($1*0.03*1E-3):2 w l t'$L_{zz}$'



set output "P_NPTdopc.tex"
set xlabel '$t/\si{ns}$'
set ylabel '$P/\si{bar}$'
set xtics 50
set ytics 7.5
set key top right
set xrange [0:300]
set yrange [-30:35]

plot "PRESSURE_DATA_EQ/pressavg.dat" u ($1*0.03*1E-3):($2/1E5) w l t'$P$',\
     "PRESSURE_DATA_EQ/pressxxavg.dat" u ($1*0.03*1E-3):($2/1E5) w l t'$P_{L}$',\
     "PRESSURE_DATA_EQ/presszzavg.dat" u ($1*0.03*1E-3):($2/1E5) w l t'$P_{N}$'



# AREA PER LIPID
set output "lipid_area_NPT.tex"
set xlabel '$t/\si{ns}$'
set ylabel '$A_{\si{l}}/\si{nm^2}$'
set xtics 50
set ytics 0.05

set xrange [0:300]
set yrange [0.6:0.75]
set key top right
plot "../MEMBRANE_DOPC/PRESSURE_DATA_EQ/lx.dat" u ($1*0.03*1E-3):(2*$2**2/468) w l t 'DOPC',\
     "../MEMBRANE_DSPC/PRESSURE_DATA_EQ/lx.dat" u ($1*0.03*1E-3):(2*$2**2/528) w l t 'DSPC',\
    
# SURFACE TENSION
set output "mem_tension_kst.tex"
set xrange [-1:16]
set yrange [-150:200]
set ylabel '$\gamma/\si{mJ.m^{-2}}$'
set xlabel '$K_{\text ST}/\si{kJ^{-1}.mol}$'
set xtics 2
set ytics 50
set key  left

Pzz(x) =a1+b1*x +c1*x**2
c1=1800
b1=1
a1=-100

fit Pzz(x)'< paste ../MEMBRANE_DOPC/PRESSURE_DATA/presszzavg_mean.dat ../MEMBRANE_DOPC/PRESSURE_DATA/pressxxavg_mean.dat' u (-$1):(1000*($2-$5)*14E-9) via a1, b1, c1
fit Pxx(x)'< paste ../MEMBRANE_DSPC/PRESSURE_DATA/presszzavg_mean.dat ../MEMBRANE_DSPC/PRESSURE_DATA/pressxxavg_mean.dat' u (-$1):(1000*($2-$5)*14E-9) via a2, b2, c2
set xzeroaxis

plot '< paste ../MEMBRANE_DOPC/PRESSURE_DATA/presszzavg_mean.dat ../MEMBRANE_DOPC/PRESSURE_DATA/pressxxavg_mean.dat' u (-$1):(1000*($2-$5)*14E-9) w p lc 1 t '',\
     '< sort -nk1 ../MEMBRANE_DOPC/PRESSURE_DATA/presszzavg_mean.dat' u (-$1):(Pzz(-$1)) w l lc 1 t 'DOPC',\
     '< paste ../MEMBRANE_DSPC/PRESSURE_DATA/presszzavg_mean.dat ../MEMBRANE_DSPC/PRESSURE_DATA/pressxxavg_mean.dat' u (-$1):(1000*($2-$5)*14E-9) w p lc 2 t '',\
     '< sort -nk1 ../MEMBRANE_DOPC/PRESSURE_DATA/presszzavg_mean.dat ' u (-$1):(Pxx(-$1)) w l lc 2 t 'DSPC'

# a-combined
set ytics 0.25
set yrange [9.25:10]
set output "a_kst_mem.tex"
set ylabel '$a/\si{nm^{-3}}$'
set xlabel '$K_{\text{ST}}/\si{kJ^{-1}.mol}$'

fit kompT(x) 'PRESSURE_DATA/klm_a.dat' u (-$1):2  via a4, b4, c4
a5=a4
b5=b4
c5=c4
Pxx(x) = a5+b5*x +c5*x**2

fit Pxx(x)  '../MEMBRANE_DSPC/PRESSURE_DATA/klm_a.dat' u (-$1):2  via a5, b5, c5

plot 'PRESSURE_DATA/klm_a.dat' u (-$1):2 w p lw 2 lc 1 t '' ,\
     '< sort -nk1 PRESSURE_DATA/klm_a.dat' u (-$1):(kompT(-$1)) w l lw 2 lc 1 t'DOPC',\
     '../MEMBRANE_DSPC/PRESSURE_DATA/klm_a.dat' u (-$1):2 w p lw 2 lc 2 t '' ,\
     '< sort -nk1 ../MEMBRANE_DSPC/PRESSURE_DATA/klm_a.dat' u (-$1):(Pxx(-$1)) w l lw 2 lc 2 t'DSPC'



# pressure profiles
set terminal epslatex size 2.5,1.5 font ",10" standalone header '\usepackage{siunitx}'  


set ylabel 'P/\si{bar}'
set xlabel '$z/$\si{nm}'

set xrange [0:14]
set yrange [-1000:1000]
set ytics 500
set key spacing 0.75
set key samplen 0.5
set key at -2.5,800
set output 'scf_press_dspc.tex'
plot '../MEMBRANE_DSPC/PRESSURE_DATA_EQ/scf_press.dat' u ($1*14):($2/1E5) w l lw 2 t '\tiny$P_0$',\
     '../MEMBRANE_DSPC/PRESSURE_DATA_EQ/scf_press.dat' u ($1*14):(0.5*($3+$4)/1E5) w l lw 2 t '\tiny$P_{1,\si L}$',\
     '../MEMBRANE_DSPC/PRESSURE_DATA_EQ/scf_press.dat' u ($1*14):($5/1E5) w l lw 2 t '\tiny$P_{1,\si N}$',\

set output 'bond_press_dspc.tex'
plot '../MEMBRANE_DSPC/PRESSURE_DATA_EQ/bond_press.dat' u ($1*14):(0.5*($2+$3)/1E5) w l lw 2 t '\tiny$P_{\si{bnd,L}}$',\
     '../MEMBRANE_DSPC/PRESSURE_DATA_EQ/bond_press.dat' u ($1*14):($4/1E5) w l lw 2 t '\tiny$P_{\si{bnd,N}}$'
set output 'ang_press_dspc.tex'
plot '../MEMBRANE_DSPC/PRESSURE_DATA_EQ/angle_press.dat' u ($1*14):(0.5*($2+$3)/1E5) w l lw 2 t '\tiny$P_{\si{ang,L}}$',\
     '../MEMBRANE_DSPC/PRESSURE_DATA_EQ/angle_press.dat' u ($1*14):($4/1E5) w l lw 2 t '\tiny$P_{\si{ang,N}}$'

set output 'scf_press_dopc.tex'
plot '../MEMBRANE_DOPC/PRESSURE_DATA_EQ/scf_press.dat' u ($1*14):($2/1E5) w l lw 2 t '\tiny$P_0$',\
     '../MEMBRANE_DOPC/PRESSURE_DATA_EQ/scf_press.dat' u ($1*14):(0.5*($3+$4)/1E5) w l lw 2 t '\tiny$P_{1,\si L}$',\
     '../MEMBRANE_DOPC/PRESSURE_DATA_EQ/scf_press.dat' u ($1*14):($5/1E5) w l lw 2 t '\tiny$P_{1,\si N}$',\

set output 'bond_press_dopc.tex'
plot '../MEMBRANE_DOPC/PRESSURE_DATA_EQ/bond_press.dat' u ($1*14):(0.5*($2+$3)/1E5) w l lw 2 t '\tiny$P_{\si{bnd,L}}$',\
     '../MEMBRANE_DOPC/PRESSURE_DATA_EQ/bond_press.dat' u ($1*14):($4/1E5) w l lw 2 t '\tiny$P_{\si{bnd,N}}$'
set output 'ang_press_dopc.tex'
plot '../MEMBRANE_DOPC/PRESSURE_DATA_EQ/angle_press.dat' u ($1*14):(0.5*($2+$3)/1E5) w l lw 2 t '\tiny$P_{\si{ang,L}}$',\
     '../MEMBRANE_DOPC/PRESSURE_DATA_EQ/angle_press.dat' u ($1*14):($4/1E5) w l lw 2 t '\tiny$P_{\si{ang,N}}$'



set ylabel '$\phi$/\si{nm^{-3}}'
set xlabel '$z/$\si{nm}'

set xrange [0:14]
set yrange [0:12]
set ytics 200

set output 'density_dopc.tex'
set key at 0,8
plot '../MEMBRANE_DOPC/PRESSURE_DATA_EQ/density.dat' u ($1*14):($2) w l lw 2 t '\tiny N',\
     '../MEMBRANE_DOPC/PRESSURE_DATA_EQ/density.dat' u ($1*14):($3) w l lw 2 t '\tiny P',\
     '../MEMBRANE_DOPC/PRESSURE_DATA_EQ/density.dat' u ($1*14):($4) w l lw 2 t '\tiny G',\
     '../MEMBRANE_DOPC/PRESSURE_DATA_EQ/density.dat' u ($1*14):($5+$6) w l lw 2 t '\tiny C',\
     '../MEMBRANE_DOPC/PRESSURE_DATA_EQ/density.dat' u ($1*14):($7) w l lw 2 t '\tiny W',\
     '../MEMBRANE_DOPC/PRESSURE_DATA/density_0.dat' u ($1*14):($2) w l lw 2 dt 3  lc 1 t '',\
     '../MEMBRANE_DOPC/PRESSURE_DATA/density_0.dat' u ($1*14):($3) w l lw 2 dt 3  lc 2 t '',\
     '../MEMBRANE_DOPC/PRESSURE_DATA/density_0.dat' u ($1*14):($4) w l lw 2 dt 3  lc 3 t '',\
     '../MEMBRANE_DOPC/PRESSURE_DATA/density_0.dat' u ($1*14):($5+$6) w l lw 2 dt 3  lc 4 t '',\
     '../MEMBRANE_DOPC/PRESSURE_DATA/density_0.dat' u ($1*14):($7) w l lw 2 dt 3  lc 5 t ''

set output 'density_dspc.tex'
set key at 0,8
plot '../MEMBRANE_DSPC/PRESSURE_DATA_EQ/density.dat' u ($1*14):($2) w l lw 2 t '\tiny N',\
     '../MEMBRANE_DSPC/PRESSURE_DATA_EQ/density.dat' u ($1*14):($3) w l lw 2 t '\tiny P',\
     '../MEMBRANE_DSPC/PRESSURE_DATA_EQ/density.dat' u ($1*14):($4) w l lw 2 t '\tiny G',\
     '../MEMBRANE_DSPC/PRESSURE_DATA_EQ/density.dat' u ($1*14):($5+$6) w l lw 2 t '\tiny C',\
     '../MEMBRANE_DSPC/PRESSURE_DATA_EQ/density.dat' u ($1*14):($7) w l lw 2 t '\tiny W',\
     '../MEMBRANE_DSPC/PRESSURE_DATA/density_0.dat' u ($1*14):($2) w l lw 2 dt 3  lc 1 t '',\
     '../MEMBRANE_DSPC/PRESSURE_DATA/density_0.dat' u ($1*14):($3) w l lw 2 dt 3  lc 2 t '',\
     '../MEMBRANE_DSPC/PRESSURE_DATA/density_0.dat' u ($1*14):($4) w l lw 2 dt 3  lc 3 t '',\
     '../MEMBRANE_DSPC/PRESSURE_DATA/density_0.dat' u ($1*14):($5+$6) w l lw 2 dt 3  lc 4 t '',\
     '../MEMBRANE_DSPC/PRESSURE_DATA/density_0.dat' u ($1*14):($7) w l lw 2 dt 3  lc 5 t ''



# Large membrane DOPC
set output "lipid_area_large.tex"
set xlabel '$t/\si{ns}$'
set ylabel '$A_{\si{l}}/\si{nm^2}$'
set xtics 10
set ytics 0.002

set xrange [0:30]
set yrange [0.7175:0.7225]
set key top right
plot "../MEMBRANE_DOPC/PRESSURE_DATA_LARGE/lx.dat" u ($1*0.03*1E-3):(2*$2**2/(468*100)) w l t '',\
  
