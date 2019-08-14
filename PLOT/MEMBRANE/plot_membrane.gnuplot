#COMMON SETTINGS
set border lw 4

#############################
# TOTAL PRESSURE COMPONENTS #
#############################
set terminal epslatex size 3.4,2.3 font ",10" standalone header '\usepackage{siunitx}'  

#SET CONSTANTS
patm=101325

#PLOT PRESSURE
set output "P\_ST.tex"
set xrange [-15:0]
#set ytics auto
#set ytic format '%g'
set xlabel "$\K_{\\si{ST}}/\\si{kJ.mol^{-1}}$"
set ylabel "$P/\\si{atm}$"

#FITTING FUNCTION FOR ISOTHERMAL COMPRESSIBILITY
PX(x) = a*x  + c
PZ(x) = a2*x  + c2
fit PX(x) "PRESSURE\_DATA/pressxx\_mean.dat" u ($1):($2/patm)  via a, c
fit PZ(x) "PRESSURE\_DATA/presszz\_mean.dat" u ($1):($2/patm)  via a2, c2

title_f(a,c) = sprintf('\footnotesize $P_{\si L}=%.2fK_{\si{ST}} + %.2f$', a,c)
title_f2(a2,c2) = sprintf('\footnotesize $P_{\si N}=%.2fK_{\si{ST}}%.2f$', a2,c2)
set key bottom right

plot "PRESSURE\_DATA/pressxx\_mean.dat" u ($1):($2/patm) w p lw 2 lc 1 t '',\
     ""				        u ($1):(PX(($1))) w l lw 2 lc 1 t title_f(a,c),\
     "PRESSURE\_DATA/presszz\_mean.dat" u ($1):($2/patm) w p lw 2  lc 2 t '',\
     ""				        u ($1):(PZ(($1))) w l lw 2 lc 2 t title_f2(a2,c2)



# #################
# # PLOT PRESSURE #
# #################

# #DEFINE CONSTANTS
# dp     = 3.441349e+07
# phi    = 8.333E27
# rho0   = 8.333E27
# kiloNA = 6.02214E20
# kT     = 4.11E-21*300./298.
# vcell  = 0.666E-9**3

# #PRESSURE AS FUNCTION OF a
# set xrange [0.01:0.1]
# set yrange [8.3:10.5] 
# set xlabel '$\kappa/\si{kJ^{-1}.mol}$'
# set ylabel '$a/\si{nm^{-3}}$'
# set xtics 0.02

# c1=2*kiloNA*phi*dp*1E-27**2
# c2=phi**2*(1+c*kT/vcell)*1E-27**2
# c3=phi**2*(a*kT/vcell)*1E-27**2
# a_dens2(x) = sqrt(c1*x+c2+c3*x**b)
# a_dens(x)  = (sqrt(2*kiloNA*phi*x*dp+(1+kompT(x)*kT/vcell)*phi**2))*1E-27
# a_dens3(x) = sqrt(69.24 + 345.39*x + 15.56*x**0.61)
# set output "rho_kappa_1atm.tex"

# tit_a=sprintf('\footnotesize $\sqrt{%.2f+%.2f\kappa+%.2f\kappa^{%.2f}}$',c2,c1,c3,b)


# plot a_dens(x) lw 2 t tit_a

# #a_dens(x) lw 2 t '',\
     
 
# #PRESSIRE AS FUNCTION OF a FOR DIFFERENT KAPPA
# set output "WATER_RHO0_P.tex"

# set xrange [8.:10.5]
# set yrange [0:0.5E8]
# set xtics auto
# set ytics auto
# set ylabel '$P/\si{Pa}$'
# set xlabel '$a/\si{nm^{-3}}$'


# g(x,kappa) = dp + ((2.*kiloNA*kappa*rho0)**(-1))*((1+kompT(kappa)*kT/vcell)*phi**2-(x*1E27)**2)
 
# plot  g(x,0.03) w l lw 2 t '$\kappa=0.03$',\
#       g(x,0.05) w l lw 2 t '$\kappa=0.05$',\
#       g(x,0.10) w l lw 2 t '$\kappa=0.10$'




# ##########################
# # PRESSURE CONTROL PLOTS # 
# ##########################
# set xrange [0:2000]
# set xlabel '$t/\si{ps}$'

# set output "WATER_CONTROL_DENS.tex"
# set yrange [0.99:1.11]
# set ylabel '$\rho/\si{g.cm^{-3}}$'


# plot "density-control.dat" u ($1*0.03):($2/1000) w l lw 2 t '$\kappa=0.03,t_p=20$',\
#      "density-control.dat" u ($1*0.03):($4/1000) w l lw 2 t '$\kappa=0.03,t_p=2$',\
#      "density-control.dat" u ($1*0.03):($6/1000) w l lw 2 t '$\kappa=0.05,t_p=20$',\
#      "density-control.dat" u ($1*0.03):($8/1000) w l lw 2 t '$\kappa=0.05,t_p=2$',\
#      "density-control.dat" u ($1*0.03):($10/1000) w l lw 2 t '$\kappa=0.10,t_p=20$',\
#      "density-control.dat" u ($1*0.03):($12/1000) w l lw 2 t '$\kappa=0.10,t_p=2$'


# set output "WATER_CONTROL_PRESS.tex"
# set yrange [-15:500]
# set ylabel '$P/\si{atm}$'

# plot "pressure-control.dat" u ($1*0.03):($2/101325) w l lw 2 t '$\kappa=0.03,t_p=20$',\
#      "pressure-control.dat" u ($1*0.03):($4/101325) w l lw 2 t '$\kappa=0.03,t_p=2$',\
#      "pressure-control.dat" u ($1*0.03):($6/101325) w l lw 2 t '$\kappa=0.05,t_p=20$',\
#      "pressure-control.dat" u ($1*0.03):($8/101325) w l lw 2 t '$\kappa=0.05,t_p=2$',\
#      "pressure-control.dat" u ($1*0.03):($10/101325) w l lw 2 t '$\kappa=0.10,t_p=20$',\
#      "pressure-control.dat" u ($1*0.03):($12/101325) w l lw 2 t '$\kappa=0.10,t_p=2$'

