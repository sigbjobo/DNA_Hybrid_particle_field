import numpy as np
import sys

#l=open(sys.argv[1]).readline().split()[1::2]
if(len(sys.argv)>3):
    N=int(sys.argv[3])
else:
    N=0
#box size in m
#lx=np.loadtxt(sys.argv[1])[N:,1::2]*1E-9
lx=np.loadtxt(sys.argv[1])[N:,1]*1E-9
A=lx**2
#print(A)
mean_a=np.mean(A,axis=0)

var_a=np.var(A,axis=0)
print(mean_a,np.std(A))
#print(var_a)
K=1000*4.11E-21*(float(sys.argv[2])/298.)*mean_a/var_a


#or i in range(len(l)):
print( K)



