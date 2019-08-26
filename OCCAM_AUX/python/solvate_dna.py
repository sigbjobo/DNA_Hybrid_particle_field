import numpy as np
#import random
import sys
# Mass of water

filename1 = str(sys.argv[1])
filename2 = str(sys.argv[2])
n_NA      = int(sys.argv[3])
n_CL      = int(sys.argv[4])

rad=0

MW = 72
with open('fort.3') as f:
    lines = f.read().splitlines()

numAtoms = int(lines[1].split()[0])

names = []
ids   = []
mass  = []

for i in range(numAtoms):
    line=lines[i+3].split()
    ids.append(int(line[0]))
    names.append(line[1]) 
    mass.append(float(line[2]))
f.close()

ids2 = np.zeros(max(ids))
mass2 = np.zeros(max(ids))
for i in range(len(ids)):
    ids2[ids[i]-1] = int(i) 


with open(filename1) as f:
    lines = f.read().splitlines()
line=lines[1].split()
nAtoms=int(lines[-1].split()[0])

XYZ = np.array([float(line[0]),float(line[1]),float(line[2])])
vol = XYZ[0]*XYZ[1]*XYZ[2]
nMol = int(lines[4])
mass_tot = 0
n_solv=int(vol/0.120-nAtoms)

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
TOTNATOM=nAtoms 
for i in range(n_solv):
    nMol = nMol+1
    line = " atoms in molecule: %d" % (nMol)
    lines.append(line)
    lines.append('1')
    TOTNATOM = TOTNATOM + 1
    if(K<n_NA):
        line= "%d %s %d %d %.3f %.3f %.3f %.3f %.3f %.3f %d %d %d %d %d %d"\
            %(TOTNATOM,'NA',names.index('W')+2,0,r[K,0],r[K,1],r[K,2],0,0,0,0,0,0,0,0,0)
    elif(K<n_NA+n_CL):
        line= "%d %s %d %d %.3f %.3f %.3f %.3f %.3f %.3f %d %d %d %d %d %d"\
            %(TOTNATOM,'CL',names.index('W')+3,0,r[K,0],r[K,1],r[K,2],0,0,0,0,0,0,0,0,0)
    else:
        line= "%d %s %d %d %.3f %.3f %.3f %.3f %.3f %.3f %d %d %d %d %d %d"\
            %(TOTNATOM,'W',names.index('W')+1,0,r[K,0],r[K,1],r[K,2],0,0,0,0,0,0,0,0,0)
    lines.append(line)
    K=K+1

lines[4] = "%d" % (nMol)
fp = open(filename2, 'w')

for i in lines: fp.write(i+'\n')

