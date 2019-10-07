import sys
import subprocess
import numpy as np
import os
FileName=sys.argv[1]
percent=float(sys.argv[2])

L=np.array([float(a) for a in os.popen('head -n2 %s | tail -n1 '%(FileName)).read().split()])
NTOT  = int(os.popen('tail -1 %s'%(FileName)).read().split()[0])

N=int(NTOT*percent/100.)
center=L/2.
vol_sphere=L[0]**3*percent/100.
rad_sphere=(3.*vol_sphere/(4.*np.pi))**(1./3.)
fp_out=open('fort_sphere.5','w')
count=0
f=open(FileName)
while(1):
    l=f.readline()
   
    ls=l.split()
    if(len(ls)==0):
        break
    
    if(len(ls)>10):
        r=[float(li) for li in ls[4:7]]
            
        if(np.linalg.norm(r-center)<=rad_sphere):
            l=l.replace('W 1', 'C 2')
            count=count+1

    fp_out.write(l)
f.close()

#     newText=f.read().replace('W 1', 'C 2',N)

# with open(FileName, "w") as f:
#     f.write(newText)


# with open(FileName) as f:
#     newText=f.read().replace('W 1', 'C 2',N)

# with open(FileName, "w") as f:
#     f.write(newText)
