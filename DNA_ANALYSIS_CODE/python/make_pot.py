import numpy as np
import sys
N    = int(sys.argv[1])
K    = float(sys.argv[2])
phi0 = float(sys.argv[3])
fp=open(sys.argv[4],'w')

_=np.array(range(N+1))
_=-180+360./(len(_)-1)*_
phi=0.5*(_[1:]+_[:-1])
dx=phi[1]-phi[0]
dphi=phi-phi0

dphi[dphi>180]=dphi[dphi>180]-360
dphi[dphi<-180]=dphi[dphi<-180]+360
fac=180/np.pi
V = K*(1-np.exp(-((dphi)**2)/(2.*17.1887338539**2)))
kt=2.479*293.15/298.

P=np.exp(-V/kt)
P=P/(np.sum(P)*dx)

for i in range(len(P)):
    fp.write('%f %f %f\n'%(phi[i],P[i],V[i]))
fp.close()



