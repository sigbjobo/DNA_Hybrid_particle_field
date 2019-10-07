import sys
import numpy as np

fn=sys.argv[1]
NWATER=int(sys.argv[2])
scales=[float(ai) for ai in sys.argv[3:6]]


with open(fn) as fp:
    lines=fp.readlines()


L=[float(li) for li in lines[1].split()]
print('old box size',L)
newL=[L[i]*scales[i] for i in range(3)]

print('new box size',newL)
lines[1]="%4f %4f %4f\n"%(newL[0],newL[1],newL[2])

for i,l in enumerate(lines):
    ls=l.split()
    if(len(ls)>10):
        r=[float(ri.replace('D','E')) for ri in ls[4:7]]
        r=[r[i]*scales[i] for i in range(3)]
        ls[4:7]=["%.4f"%(ri) for ri in r]
        lines[i]='%s\n'%(' '.join(ls))

exlines=lines[-3:]
natom=int(lines[-1].split()[0])
nmol=int(lines[4])
print('old number of atoms and molecules',natom,nmol)
if(NWATER>0):
    #add
    for i in range(NWATER):
        ls=exlines[0].split()
        ls[-1]="%d"%(nmol+1+i)
        newlines='%s\n'%(' '.join(ls))
        lines.append('%s\n'%(' '.join(ls)))
        lines.append(exlines[1])
    

        ls=exlines[2].split()
        ls[0]="%d"%(natom+1+i)
        a=1
        while(a):
            r=np.random.rand(3)
            a=(r[2]>0.3 and r[2]<0.6)
        
        r=[r[i]*newL[i] for i in range(3)]
        ls[4:7]=["%.4f"%(ri) for ri in r]
        lines.append('%s\n'%(' '.join(ls)))

if(NWATER<0):
    lines=lines[:3*NWATER]


natom = natom + NWATER
nmol  = nmol  + NWATER
lines[4]='%d\n'%(nmol)
print('new number of atoms and molecules',natom,nmol)

with open('fort.5_new','w') as fp:
    fp.writelines(lines)
    
