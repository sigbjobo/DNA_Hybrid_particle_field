import numpy as np


#SET DNA 
L = np.array([15,15,15])
A = np.loadtxt('start.xyz')
A = 0.1*A
A = A-np.mean(A,axis=0)+0.5*L

#PUT INTO OLD DNA FORT.5 FILE

lines=open('fort.5').readlines()
N=len(A)//2
i=7
for i in range(N):
    #SPLIT LINES OF FIRST STRAND
    ls = lines[i+7].split()
    ls[4:7]=['%.4f'%(ai) for ai in A[i]]
    lines[i+7]=' '.join(ls)

    ls = lines[i+104].split()
    ls[4:7]=['%.4f'%(ai) for ai in A[i+N]]
    lines[i+104]=' '.join(ls)

fp=open('START.5', 'w')
for l in lines:
    fp.write('%s\n'%(' '.join(['%s'%(li) for li in l.split()])))
fp.close()
