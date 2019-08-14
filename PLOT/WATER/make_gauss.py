import numpy as np
from scipy.optimize import curve_fit
def gaus(x,a,x0,sigma):
    return a*np.exp(-(x-x0)**2/(2*sigma**2))
kappa=["0.01","0.03","0.05","0.1"]
fns=["density/phi_%s.dat"%(ki) for ki in kappa]

fp_out=open('sigmas.dat','w')
for i in range(len(kappa)):
    A=np.loadtxt(fns[i])
    popt,pcov = curve_fit(gaus,A[:,0],A[:,1],p0=[1,8.3,1])
    fp_out.write('%e\t%e\n'%(float(kappa[i]),popt[2]))

    vol=0.65E-9**3
    mean = popt[1]
    var  = popt[2]**2
    print(mean,var)
    komp = vol/(4.11E-21)*var**2/mean**2
    print(kappa[i],komp)
fp_out.close()
