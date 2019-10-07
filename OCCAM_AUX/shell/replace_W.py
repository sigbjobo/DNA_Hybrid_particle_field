import sys
import subprocess
import os
FileName=sys.argv[1]
NTOT = int(os.popen('tail -1 %s'%(FileName)).read().split()[0])
percent=int(sys.argv[2])
N=int(NTOT*percent/100.)
with open(FileName) as f:
    newText=f.read().replace('W 1', 'C 2',N)

with open(FileName, "w") as f:
    f.write(newText)
