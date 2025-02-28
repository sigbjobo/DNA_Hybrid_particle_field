import numpy as np
import sys

data  = np.loadtxt(sys.argv[1])
a0    = float(sys.argv[2])
kappa = float(sys.argv[3])
P1 = 1.00*6.022*1E-2
P0 = data[:,1]/1E5*6.022*1E-2
#print(P0,P1)
a1=np.sqrt(-(P1 - P0)*2*kappa*8.33 + a0**2)

print(data[:,0],a1)



fp=open('klm_a.dat','w')

for i in range(len(a1)):
    fp.write('%f %f\n'%(data[i,0],a1[i]))
fp.close()
