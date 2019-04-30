import numpy as np
import sys

fn=sys.argv[1]
fn_out='%s_order.dat'%(sys.argv[1].split('.')[-2])
fp=open(fn_out,'w')
A=np.loadtxt(sys.argv[1])

x=np.unique(A[:,0])
y=np.unique(A[:,1])

for i in range(len(x)):
    for j in range(len(y)):
        z=np.array((A[:,0]==x[i])*(A[:,1]==y[j]),dtype=bool)
      
        fp.write('%f\t%f\t%f\t%f\n'%(x[i], y[j],A[z,2], A[z,3]))
    fp.write('\n')
