import sys
import numpy as np


l=sys.argv[1]
N_nuc=len(l)
names=['A','T','C','G']


#N_nuc = int(sys.argv[1])
L=float(sys.argv[2])

comp=bool(int(sys.argv[3]))
sign=1.
if(comp):
    sign=-1.
rP=0.8918 
rS=0.6981 

rA=0.0773 
rT=0.2349 
rC=0.2296 
rG=0.0828 
rN=[rA,rT,rG,rC] 


thetaP=94.038*np.pi/180. 
thetaS=70.197*np.pi/180.

thetaA=41.905*np.pi/180. 
thetaT=86.119*np.pi/180. 
thetaC=85.027*np.pi/180. 
thetaG=40.691*np.pi/180. 
thetaN=[thetaA,thetaT,thetaG,thetaC]

zP=0.2186 
zS=0.1280 

zA=0.0051 
zT=0.0191 
zC=0.0187 
zG=0.0053 
zN=[zA,zT,zG,zC]

z0=1
theta0=0


lines=[]
lines.append('box:\n')

lines.append('%f %f %f\n'%(L,L,L))
lines.append('0.00\n')
lines.append('Number of molecules:\n')
lines.append('1\n')
lines.append('mol nr. 1\n')
lines.append('%d \n'%(N_nuc*3+1))


theta0=0.
z0=0
#theta0=theta+np.pi*36./180.

z0=z0+0.338
if(comp):
    z0=(N_nuc+2)*0.338+zP-0.1937712#+0.557

#rP=np.array([1,1,1])
lines.append("1 P 1 1 %.3f %.3f %.3f 0.000 0.000 0.000 2 0 0 0 0 0\n"%(0.5*L+rP*np.cos(theta0+thetaP),0.5*L+sign*rP*np.sin(theta0+thetaP),z0+sign*zP))
for i in range(N_nuc):
    theta0=theta0+np.pi*36./180.
    z0=z0+sign*0.338
    # if(i==0):
    #     lines.append("1 P 1 1 %.3f %.3f %.3f 2 0 0 0 0 0\n"%(0.5*L+rP*np.cos(theta0+thetaP),0.5*L+rP*np.sin(theta0+thetaP),z0+zP))
    # else:

    lines.append("%d S 2 3 %.3f %.3f %.3f %.3f %.3f %.3f %d %d %d 0 0 0\n"%(i*3+2,0.5*L+rS*np.cos(theta0+thetaS),0.5*L+sign*rS*np.sin(theta0+thetaS),z0+sign*zS,0,0,0,3*i+1,3*i+3,3*i+4))
    
    ncl=l[i] 
    idx=names.index(ncl)+3
   # rN=rS+drN[names.index(ncl)]
    id_nuc=names.index(ncl)
    lines.append("%d %s %d 1 %.3f %.3f %.3f %.3f %.3f %.3f %d %d %d 0 0 0\n"%(i*3+3,ncl,idx,0.5*L+rN[id_nuc]*np.cos(theta0+thetaN[id_nuc]),0.5*L+sign*rN[id_nuc]*np.sin(theta0+thetaN[id_nuc]),z0+sign*zN[id_nuc],0,0,0,3*i+2,0,0))
    # print(i*3+3,"N",3,1,x,y,zn,3*i+2,0,0)
    if(i==N_nuc-1):
        lines.append("%d P 1 1 %.3f %.3f %.3f %.3f %.3f %.3f %d %d %d 0 0 0\n"%(3*i+4,0.5*L+rP*np.cos(theta0+thetaP),0.5*L+rP*np.sin(theta0+thetaP),z0+sign*zP,0,0,0,i*3+2,0,0))
    else:
        lines.append("%d P 1 2 %.3f %.3f %.3f %.3f %.3f %.3f %d %d %d 0 0 0\n"%(3*i+4,0.5*L+rP*np.cos(theta0+thetaP),0.5*L+sign*rP*np.sin(theta0+thetaP),z0+sign*zP,0,0,0,i*3+2, i*3+5,0))



# i=i+1
# lines.append("%d P 1 1 %.3f %.3f %.3f %d %d %d 0 0 0\n"%(3*i+1,0.5*L+rP*np.cos(theta0+thetaP),0.5*L+rP*np.sin(theta0+thetaP),z0+zP,i*3-1, 0,0))

fp=open('fort.5','w')
for l in lines:
    fp.write(l)

fp.close()
