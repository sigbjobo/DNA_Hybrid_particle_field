import numpy as np
import sys

fp     = open('fort.5','r')
fp_out = open('fort_centered.5','w')

lines=fp.readlines()
LZ=float(lines[1].split()[2])
avgz=0
n=0
for l in lines:
    ls=l.split()
    if(len(ls)>6):
        if(ls[1]=='C'):
            n=n+1
            avgz=avgz+float(ls[6])
fp.close()
avgz=avgz/n
for l in lines:
    ls=l.split()
    if(len(ls)>6):
        z=float(ls[6])
        z=z-avgz+0.5*LZ
    
        if(z>LZ):
            z=z-LZ
        if(z<0):
            z=z+LZ
        ls[6]="%f"%(z)
    fp_out.write("%s\n"%(' '.join(ls)))
fp_out.close()
