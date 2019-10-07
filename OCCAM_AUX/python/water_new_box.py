import sys
import numpy as np

fn=sys.argv[1]
newLZ=float(sys.argv[2])



with open(fn) as fp:
    lines=fp.readlines()

 
L=[float(li) for li in lines[1].split()]
newL=L.copy()
newL[-1]=newLZ

print('new box size',newL)
lines[1]="%4f %4f %4f\n"%(newL[0],newL[1],newL[2])

NW_OLD=0
for i,l in enumerate(lines):
    ls=l.split()
    if(len(ls)>10):
        r=[float(ri.replace('D','E')) for ri in ls[4:7]]
        #r=[r[i]*scales[i] for i in range(3)]
        ls[4:7]=["%.4f"%(ri) for ri in r]
        lines[i]='%s\n'%(' '.join(ls))
                   
exlines=lines[-3:]
natom=int(lines[-1].split()[0])
nmol=int(lines[4])
print('old number of atoms and molecules',natom,nmol)

newVol= newL[0]*newL[1]*newL[2]
vol   = L[0]*L[1]*L[2]
NWATER_ADD1=int((newVol-vol)/8.33)
NWATER_ADD1=NWATER_ADD1+int((8.33-(natom + NWATER_ADD1)/newVol)*newVol)
print('TOTAL ADDED WATER')

if(NWATER_ADD1>0):
    #add
    for i in range(NWATER_ADD1):
        ls=exlines[0].split()
        ls[-1]="%d"%(nmol+1+i)
        newlines='%s\n'%(' '.join(ls))
        lines.append('%s\n'%(' '.join(ls)))
        lines.append(exlines[1])
    

        ls=exlines[2].split()
        ls[0]="%d"%(natom+1+i)
        a=1
        
        r=np.random.rand(3)
        
        
        r=[r[i]*newL[i] for i in range(3)]
        r[2]=L[2]+(newL[2]-L[2])*r[2]
        ls[4:7]=["%.4f"%(ri) for ri in r]
        lines.append('%s\n'%(' '.join(ls)))
    
natom = natom + NWATER_ADD1
nmol  = nmol  + NWATER_ADD1


lines[4]='%d\n'%(nmol)
print('new number of atoms and molecules',natom,nmol)

with open('fort.5_new','w') as fp:
    fp.writelines(lines)
    
