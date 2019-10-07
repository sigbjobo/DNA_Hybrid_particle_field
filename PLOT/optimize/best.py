import numpy as np

A=np.loadtxt('opt.dat')
b=A[:,4]
Z=A*1

best=100
j=0
for i in range(len(b)):
    
    if(b[i]<best):
        best=b[i]
        j=i
    Z[i] = A[j]
#print(Z)    
np.savetxt('opt_best.dat',Z)
