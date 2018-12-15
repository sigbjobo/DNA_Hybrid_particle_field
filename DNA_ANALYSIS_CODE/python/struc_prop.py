import sys
import numpy as np
from scipy.optimize import minimize
sys.path.append('/home/sigbjobo/Projects/DNA/SIM/continuation/structure/ss/BI/script/')
sys.path.append('/home/sigbjobo/Stallo/Projects/DNA/SIM/continuation/structure/ss/BI/script/')
import ana_prot as ANA
def Parseq(r):
# ref 6
    n = len(r)
    t = np.array(range(n))
    D = np.linalg.det(np.array([[sum(t**2),sum(t)],[sum(t),n]]))
    
    p = np.zeros(3)
    d = np.zeros(3)
    for i in range(3):
        d[i] = np.linalg.det(np.array([[sum(r[:,i]*t),sum(t)],[sum(r[:,i]),n]]))/D
        p[i] = np.linalg.det(np.array([[sum(t**2),sum(r[:,i]*t)],[sum(t),sum(r[:,i])]]))/D

    radius=0.0
    hs=p[None,:]+t[:,None]*d[None,:]
    radius=np.mean(np.linalg.norm(hs-r,axis=1))
    v1=r[:-1] - hs[:-1]
    v2=r[1:]  - hs[1:]
    v1=v1/np.linalg.norm(v1,axis=1)[:,None]
    v2=v2/np.linalg.norm(v2,axis=1)[:,None]
 
    ang=np.mean(np.arccos(np.sum(v2*v1,axis=1)))*180./np.pi
    return np.linalg.norm(d),radius,ang, d

def axis_along(r,n,L):
# Compute axis allong single helix from n consecutive atoms
    ds=np.zeros((len(r)-n,3))
    r=ANA.array_period(r, L)
    for i in range(len(r)-n):
      #  r_period=ANA.array_period(r[i:n], L)
       # print r_period
        [a,b,c,d] = Parseq(r[i:i+n]) 
#        print d
        ds[i]=d
    return ds

 
def auto_corr(d):
    corr = np.zeros(len(d))
    for i in range(len(d)):
        corr[i] = np.mean(np.sum(d[:len(d)-i]*d[i:],axis=1))
    return corr                 

#     res1=np.correlate(d[:,0],d[:,0],mode='same')
#     res2=np.correlate(d[:,1],d[:,1],mode='same')
#     res3=np.correlate(d[:,2],d[:,2],mode='same')
#     res=res1+res2+res3
#     res=res 
#     np.convolve(res,res)
# # norm = np.sum(res[len(res)/2:]**2)
#     return res[len(res)/2:]#/norm[len(res)/2:]

# def ANA.period(r1, r2, L):
#     return r2-L*np.sign((r2-r1))*(np.abs((r2-r1))//(0.5*L))

 
# fp     = open(sys.argv[1],'r')
# n_start=int(sys.argv[2])
# fp_out = open('struc.dat','w')

# n=11
# n_frames=0    
# while(1):
#     n_frames=n_frames+1
#     line = fp.readline()
#     nAtoms=int(line)
#     L=np.array([float(d) for d in fp.readline().split()[1:]])
#     r=[]
#     r_s=[]
#     r_p=[]
#     for i in range(nAtoms):
#         l = fp.readline().split()
#         if(n_frames>=n_start):
#             if(l[0]=='A' or l[0]=='T' or l[0]=='G' or l[0]=='C'): 
#                 r.append([float(d) for d in l[1:]])
#             elif(l[0]=='S'):
#                 r_s.append([float(d) for d in l[1:]])
#             elif(l[0]=='P'):
#                 r_p.append([float(d) for d in l[1:]])
    
#     if(n_frames>=n_start):
#         r_p=np.array(r_p)
#         dat1=(r_p[:len(r_p)//2])[3:-3]
#         dat2=(r_p[len(r_p)//2:])[3:-3]
#         [d1,r1,ang1,d]= Parseq(dat1) 
#         [d2,r2,ang2,d]= Parseq(dat2)
#         fp_out.write('%d %f %f %f %f %f %f\n'%(n_frames, d1, d2, r1, r2, ang1, ang2))
       
 
