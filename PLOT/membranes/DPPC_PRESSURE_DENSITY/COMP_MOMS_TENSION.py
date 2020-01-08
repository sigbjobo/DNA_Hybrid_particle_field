import numpy as np
import sys

LZ=float(sys.argv[1])
data=np.loadtxt('PRESS_TOT.dat')
z= (data[:,0]-0.5)*LZ
PZ=data[:,4]
PXY=0.5*(data[:,2]+data[:,3])
sigma=PZ-PXY

dz=z[1]-z[0]
gamma = 0.5*np.sum(dz*sigma)
ck    = 0.5*np.sum(z*dz*sigma)
K     = 0.5*np.sum(z**2*dz*sigma)

print('Tension:',gamma)
print('Ck:',ck)
print('K:',K)
