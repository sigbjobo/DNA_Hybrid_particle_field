import numpy as np
#import matplotlib.pyplot as plt
import sys
import scipy
from scipy.optimize import curve_fit
data = np.loadtxt(sys.argv[1])

def V(theta,k0,k1,k2,k3,k4,k5,k6,k7,d0,d1,d2,d3,d4,d5,d6,d7):
    v=theta*0 
#    K=p[:8]
#    d=p[8:]
    
    k=np.array([k0,k1,k2,k3,k4,k5,k6,k7])
    d=np.array([d0,d1,d2,d3,d4,d5,d6,d7])
    for i in range(len(k)):
        v += k[i]*(1+np.cos(i*theta - d[i]))
    return v

def V_2(theta,p):
    v=theta*0
    K=p[:8]
    d=p[8:]
    for i in range(len(K)):
        v += K[i]*(1+np.cos(i*theta-d[i]))
    return v
#p0=scipy.array([0,0.5*np.max(data[:,2]),0,0,0,0,0,0, 0,data[np.min(data[:,2])==data[:,2],0]*np.pi/180,0,0,0,0,0,0])
#print(p0[:8])
#print(p0[8:])
theta = data[:,0]*np.pi/180.


p0_a=[ 1.00016851e+01, -1.00000000e+01, 1.68930623e-08,    -9.77689730e-08, -4.39138871e-08, 4.67206126e-09, 3.81807324e-09,       1.48322088e-08, 2.59607237e-02, 1.83414906e+01, 9.92431141e-01,       1.35228770e+00, 1.09798267e+00, 9.61690535e-01, 7.90942547e-01,       8.80480693e-01]

phi0=np.atleast_2d(data[np.min(data[:,2])==data[:,2],:])[0][0]
#print('a',p0_a[1],p0_a[9]*180/np.pi)
#p0_a=np.zeros((16))
p0_a[0]=0.5*np.max(data[:,2])
p0_a[1]=-0.5*np.max(data[:,2])
p0_a[9]=np.pi*phi0/180.

#print('b',p0_a[1],p0_a[9]*180/np.pi)

popt, pcov = curve_fit(V, theta, data[:,2],p0=p0_a, method="trf")
#print(popt)
popt=np.array(popt)

p=np.zeros((2,8))
p[0,:]=popt[:8]
p[1,:]=popt[8:]
np.savetxt('%s_PROP.dat'%(sys.argv[2]),p)


dx=data[1,0]-data[0,0]


V_=V_2(theta,popt)
beta=1.0/(2.479*293.15/298.)
P_=np.exp(-beta*V_)
P_=P_/(np.sum(P_)*dx)
fp=open("%s"%sys.argv[3],'w')
V_=V_ -  np.min(V_)
for i in range(len(theta)):
    fp.write('%f %f %f\n' %(data[i,0],P_[i],V_[i]))
fp.close()


