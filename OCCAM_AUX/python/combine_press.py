import numpy as np
import sys

#
def AVERAGE_FILE(fn,start):

    #READ DATA FILE
    fp = open(fn,'r')

    l = fp.readline()
    names=l.split()[1::2]
    nline=len(l.split())
    on=1
    A = []
    while(1):
        ls = fp.readline().split()
        
        if(len(ls)==nline):
            A.append([float(li) for li in ls[1::2]])
        else:
            break
    A = np.array(A)
   
    fp_out = open("%s_mean.dat"%(fn.split('.')[0]), 'w')
    for i in range(len(names)):
        fp_out.write("%s %f %f\n"%(names[i].split('_')[-1],np.mean(A[start:,i]),np.std(A[start:,i])))
    fp_out.close()

if(len(sys.argv)>2):
    start=int(sys.argv[2])
else:
    start=0
AVERAGE_FILE(sys.argv[1],start)
    
