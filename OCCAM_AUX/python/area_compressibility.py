import numpy as np
import sys

l=open('lx.dat').readline().split()[1::2]

#box size in m
lx=np.loadtxt('lx.dat')[:,1::2]*1E-9

A=lx**2
#print(A)
mean_a=np.mean(A,axis=0)
#print(mean_a)
var_a=np.var(A,axis=0)
print(var_a)
K=1000*4.11E-21*(float(sys.argv[1])/298.)*mean_a/var_a


for i in range(len(l)):
    print(l[i], K[i])



