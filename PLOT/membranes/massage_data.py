#python script for preparing data for visualization
import numpy as np
import sys


folder = sys.argv[1]

# SURFACE TENSION
px = np.loadtxt('%s/pressxxavg_mean.dat'%(folder))[:,:2]
pz = np.loadtxt('%s/presszzavg_mean.dat'%(folder))[:,:2]

gamma=(pz-px)*1000.*14E-9
gamma[:,0]=px[:,0]


weights = np.polyfit(gamma[:,0],gamma[:,1],2)
model1  = np.poly1d(weights)
kst=np.linspace(np.min(gamma[:,0]),np.max(gamma[:,0]),100)
gammalin=np.zeros((100,2))
gammalin[:,1]=model1(kst)
gammalin[:,0]=kst

np.savetxt('data/%s_GAMMA_FIT.dat'%(folder),gammalin)
np.savetxt('data/%s_GAMMA.dat'%(folder),gamma)

# a parameter
alin=np.zeros((100,2))
a = np.loadtxt('%s/klm_a.dat'%(folder))[:,:2]
weights = np.polyfit(a[:,0],a[:,1],2)
model1  = np.poly1d(weights)
alin[:,1]=model1(kst)
alin[:,0]=kst
np.savetxt('data/%s_a_FIT.dat'%(folder),alin)
np.savetxt('data/%s_a.dat'%(folder),a)

