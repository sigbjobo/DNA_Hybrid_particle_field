import numpy as np
import sys

def fix_bond(i,j):
    i1=int(i)
    if(i1==0):
        return "0"
    return "%d"%(i1+j)


fp_in  = open('fort.5','r')
fp_out = open('fort.5_2','w')
NX=int(sys.argv[1])
NY=int(sys.argv[2])
NZ=int(sys.argv[3])

lines=fp_in.readlines()

# number of atoms in fort.5
Natoms1=int(lines[-1].split()[0])
Nmols1=int(lines[4].split()[0])

# box size of fort.5
[LX,LY,LZ] = [float(i) for i in lines[1].split()]

fp_out.write('box:\n')
fp_out.write('%f'%(NX*LX))
fp_out.write(' %f'%(NY*LY))
fp_out.write(' %f\n'%(NZ*LZ))
fp_out.write('0.0\n')
fp_out.write('molecules_total_number:\n')
fp_out.write('%d\n'%(NX*NY*NZ*Nmols1))

molnr=0
atomnr=0
boxnr=0
lines=lines[5:]
mol_start=0
atom_start=0
for ix in range(NX):
    for iy in range(NY):
        for iz in range(NZ):
            
            for l in lines:
                ls=l.split()
                if(len(ls)==2):
                    ls[1]="%d"%(int(ls[1])+mol_start)
                if(len(ls)==1):
                    ls[0]="%d"%(int(ls[0]))
                if(len(ls)>5):
                    # fix atom nr
                    ls[0]="%d"%(int(ls[0])+atom_start)
                 
                    # fix positions
                    ls[4]="%f"%(float(ls[4].replace('D','E')) +(ix-1)*LX)
                    ls[5]="%f"%(float(ls[5].replace('D','E')) +(iy-1)*LY)
                    ls[6]="%f"%(float(ls[6].replace('D','E')) +(iz-1)*LZ)

                    # fix bonds
                    ls[10:]=[fix_bond(i,atom_start) for i in ls[10:]]
                l_out=' '.join(ls)
                fp_out.write("%s\n"%(l_out))
            mol_start  = mol_start + Nmols1
            atom_start = atom_start + Natoms1

fp_out.close()
fp_in.close()


