import numpy as np
#import functions as FUNC
import sys

# Script for inserting file 2 into the middle of file 1


#opening files
fp1=open(sys.argv[1],'w')
fp2=open(sys.argv[2],'r')
fp3=open(sys.argv[3],'r')



#Add the rest
lines2 = fp2.readlines()
n_mols2  = int(lines2[4])
n_atoms2 = int(lines2[-1].split()[0])

#New file start with inserted molecule
lines3=fp3.readlines()
n_mols3  = int(lines3[4])
n_atoms3 = int(lines3[-1].split()[0])

lines_out=[]
for l in lines2:
    lines_out.append(' '.join(l.split()))

lines_out[4]='%d'%(n_mols2+n_mols3)

ln=6
mol_nr=n_mols2+1
#natom=lines2[ln]

for i in range(n_mols3):
  lines_out.append("mol nr. %d"%(mol_nr))
  n_atom=int(lines3[ln])
  lines_out.append(lines3[ln])
  for k in range(n_atom):
    ln=ln+1
    l=lines3[ln].split()
    l[0]="%d"%(n_atoms2+int(l[0]))
    connec=[int(r) for r in l[10:]]
    connec=[(r+n_atoms2)*(not (r==0)) for r in connec]
    l[10:]=["%d"%(r) for r in connec]
    lines_out.append(' '.join(l))
  mol_nr=mol_nr+1

for l in lines_out:
    fp1.write("%s\n"%(' '.join(l.split())))



