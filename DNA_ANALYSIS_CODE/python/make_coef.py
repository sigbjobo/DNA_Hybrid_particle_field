import numpy as np
#import matplotlib.pyplot as plt
import sys
from scipy.optimize import curve_fit

data = np.loadtxt(sys.argv[1])

def V(theta,k0,k1,k2,k3,k4,k5,k6,k7,d0,d1,d2,d3,d4,d5,d6,d7):
    v=theta*0 
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

theta = data[:,0]*np.pi/180.
popt, pcov = curve_fit(V, theta, data[:,2])
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


