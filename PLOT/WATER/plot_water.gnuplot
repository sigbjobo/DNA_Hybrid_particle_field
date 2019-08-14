#COMMON SETTINGS
set border lw 4

########################
# COMPRESSIBILITY PART #
########################
set terminal epslatex size 3.4,2.3 font ",10" standalone header '\usepackage{siunitx}'  


#PLOT GAUSSIAN DISTRIBUTIONS
set output "phi_kappa.tex"
set ylabel '$P(\rho)/\si{(g.cm^{-3})^{-1}}$'
set xlabel '$\rho/\si{g.cm^{-3}}$'
plot 'density/phi_0.01.dat' u ($1/8.33):($2*8.33) w l lw 2 t '$\kappa=0.01$',\
     'density/phi_0.03.dat' u ($1/8.33):($2*8.33) w l lw 2 t '$\kappa=0.03$',\
     'density/phi_0.05.dat' u ($1/8.33):($2*8.33) w l lw 2 t '$\kappa=0.05$',\
     'density/phi_0.1.dat' u ($1/8.33):($2*8.33) w l lw 2 t  '$\kappa=0.10$'

#PLOT COMPRESSIBILITY
set output "kompT_kappa.tex"
set xrange [0.000:0.1]
set ytics auto
set ytic format '%g'
set xlabel '$\kappa/\si{kJ^{-1}.mol}$'
set ylabel '$\kappa_T/\si{J^{-1}.nm^{3}}$'

#FITTING FUNCTION FOR ISOTHERMAL COMPRESSIBILITY
kompT(x) = a*x**b +c
c=0.00001
b=0.5
fit kompT(x) 'phi_fluc_8.33.dat' u 1:4  via a, b, c

title_f(a,b,c) = sprintf('\footnotesize %.2E$\kappa^{%.2f}$%.3E', a, b,c)
plot "phi_fluc_8.33.dat" u 1:($4) w p lw 2 t '',\
     "phi_fluc_8.33.dat" u 1:(kompT($1)) w l lw 2 t title_f(a,b,c)



#################
# PLOT PRESSURE #
#################

#DEFINE CONSTANTS
dp     = 3.441349e+07
phi    = 8.333E27
rho0   = 8.333E27
kiloNA = 6.02214E20
kT     = 4.11E-21*300./298.
vcell  = 0.666E-9**3

#PRESSURE AS FUNCTION OF a
set xrange [0.01:0.1]
set yrange [8.3:10.5] 
set xlabel '$\kappa/\si{kJ^{-1}.mol}$'
set ylabel '$a/\si{nm^{-3}}$'
set xtics 0.02

c1=2*kiloNA*phi*dp*1E-27**2
c2=phi**2*(1+c*kT/vcell)*1E-27**2
c3=phi**2*(a*kT/vcell)*1E-27**2
a_dens2(x) = sqrt(c1*x+c2+c3*x**b)
a_dens(x)  = (sqrt(2*kiloNA*phi*x*dp+(1+kompT(x)*kT/vcell)*phi**2))*1E-27
a_dens3(x) = sqrt(69.24 + 345.39*x + 15.56*x**0.61)
set output "rho_kappa_1atm.tex"

tit_a=sprintf('\footnotesize $\sqrt{%.2f+%.2f\kappa+%.2f\kappa^{%.2f}}$',c2,c1,c3,b)


plot a_dens(x) lw 2 t tit_a

#a_dens(x) lw 2 t '',\
     
 
#PRESSIRE AS FUNCTION OF a FOR DIFFERENT KAPPA
set output "WATER_RHO0_P.tex"

set xrange [8.:10.5]
set yrange [0:0.5E8]
set xtics auto
set ytics auto
set ylabel '$P/\si{Pa}$'
set xlabel '$a/\si{nm^{-3}}$'


g(x,kappa) = dp + ((2.*kiloNA*kappa*rho0)**(-1))*((1+kompT(kappa)*kT/vcell)*phi**2-(x*1E27)**2)
 
plot  g(x,0.03) w l lw 2 t '$\kappa=0.03$',\
      g(x,0.05) w l lw 2 t '$\kappa=0.05$',\
      g(x,0.10) w l lw 2 t '$\kappa=0.10$'




##########################
# PRESSURE CONTROL PLOTS # 
##########################
set xrange [0:2000]
set xlabel '$t/\si{ps}$'

set output "WATER_CONTROL_DENS.tex"
set yrange [0.99:1.11]
set ylabel '$\rho/\si{g.cm^{-3}}$'


plot "density-control.dat" u ($1*0.03):($2/1000) w l lw 2 t '$\kappa=0.03,t_p=20$',\
     "density-control.dat" u ($1*0.03):($4/1000) w l lw 2 t '$\kappa=0.03,t_p=2$',\
     "density-control.dat" u ($1*0.03):($6/1000) w l lw 2 t '$\kappa=0.05,t_p=20$',\
     "density-control.dat" u ($1*0.03):($8/1000) w l lw 2 t '$\kappa=0.05,t_p=2$',\
     "density-control.dat" u ($1*0.03):($10/1000) w l lw 2 t '$\kappa=0.10,t_p=20$',\
     "density-control.dat" u ($1*0.03):($12/1000) w l lw 2 t '$\kappa=0.10,t_p=2$'


set output "WATER_CONTROL_PRESS.tex"
set yrange [-15:500]
set ylabel '$P/\si{atm}$'

plot "pressure-control.dat" u ($1*0.03):($2/101325) w l lw 2 t '$\kappa=0.03,t_p=20$',\
     "pressure-control.dat" u ($1*0.03):($4/101325) w l lw 2 t '$\kappa=0.03,t_p=2$',\
     "pressure-control.dat" u ($1*0.03):($6/101325) w l lw 2 t '$\kappa=0.05,t_p=20$',\
     "pressure-control.dat" u ($1*0.03):($8/101325) w l lw 2 t '$\kappa=0.05,t_p=2$',\
     "pressure-control.dat" u ($1*0.03):($10/101325) w l lw 2 t '$\kappa=0.10,t_p=20$',\
     "pressure-control.dat" u ($1*0.03):($12/101325) w l lw 2 t '$\kappa=0.10,t_p=2$'

