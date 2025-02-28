import numpy as np
import sys
if len(sys.argv)>2:
    degree=int(sys.argv[2])
else:
    degree = 2
fn= sys.argv[1]
data=np.loadtxt(fn)
weigths=np.polyfit(data[:,0], data[:,1], degree)[::-1]

fn_out="%s_polyfit.dat"%(fn.split('.')[0])
fp=open(fn_out,'w')
for w in weigths:
    fp.write('%4f '%(w))
fp.write('\n')
for w in weigths:
    fp.write('%e '%(w))
fp.close()
