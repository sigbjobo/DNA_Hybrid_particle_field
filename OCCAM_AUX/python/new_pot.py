#!/usr/bin/python  
import numpy as np
import sys

print 'Number of arguments:', len(sys.argv), 'arguments.'
print 'Argument List:', str(sys.argv)
filenamePi    = sys.argv[1]
filenameVi    = sys.argv[2]
filenameV_new = sys.argv[3]

data   = np.loadtxt(sys.argv[4])
theta  = data[:,0]
P      = data[:,1]


#kJ/mol
beta=1.0/(2.479*293.15/298.)

P_i = np.loadtxt(filenamePi)
P_i=P_i[:,1]
Vi  = np.loadtxt(filenameVi)
Vi=Vi[:,2]


V_new = Vi - 0.5/beta*np.log(P/P_i)
V_new = V_new-np.min(V_new)
P_new = np.exp(-beta*V_new)
P_new = P_new/(np.sum(P_new)*(theta[1]-theta[0]))
fp = open(filenameV_new,'w')

for i in range(len(theta)):
    fp.write('%f %f %f\n'%(theta[i],P_new[i],V_new[i]))
fp.close()
