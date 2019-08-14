import numpy as np
#import random
import sys
# Mass of water

filename1 = "fort.5"
L         =   float(sys.argv[1])
vm        = 1/float(sys.argv[2])
rad=0

MW = 72

XYZ = np.array([L,L,L])
vol = XYZ[0]*XYZ[1]*XYZ[2]
nMol = 0
mass_tot = 0
n_solv=int(vol/vm)

r=np.zeros((n_solv,3))
k=0
m=int(n_solv**(1./3))
for x in range(m):
    for y in range(m):
        for z in range(m):
            r[k]=[(0.5+x)/m,(0.5+y)/m,(0.5+z)/m]
            k=k+1


r[k:,:]=np.random.random((len(r[k:,0]),3))
r[:,0]=r[:,0]*XYZ[0]
r[:,1]=r[:,1]*XYZ[1]
r[:,2]=r[:,2]*XYZ[2]
ind=np.arange(len(r))
np.random.shuffle(ind)
r=r[ind]
K=0
lines=[]
lines.append("box:")
lines.append("%f %f %f"%(L,L,L))
lines.append("0")
lines.append("molecules_total_number:")
lines.append("%d" % (n_solv))

TOTNATOM=0
for i in range(n_solv):
    nMol = nMol+1
    line = " atoms in molecule: %d" % (nMol)
    lines.append(line)
    lines.append('1')
    TOTNATOM = TOTNATOM + 1
    line= "%d %s %d %d %.3f %.3f %.3f %.3f %.3f %.3f %d %d %d %d %d %d"\
        %(TOTNATOM,'W',1,0,r[K,0],r[K,1],r[K,2],0,0,0,0,0,0,0,0,0)
    lines.append(line)
    K=K+1


fp = open(filename1, 'w')

for i in lines: fp.write(i+'\n')

