import sys
#Setting paths                                                                                                            
SHELL_PATH="/cluster/home/sigbjobo/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/shell"
PYTHON_PATH="/cluster/home/sigbjobo/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/python"
EXTRA_PATH="/home/sigbjobo/Stallo/Projects/DNA/DNA_Hybrid_particle_field/DNA_CODE_PLOT/DNA_ANALYSIS_CODE/python"
sys.path.append(SHELL_PATH)
sys.path.append(PYTHON_PATH)
sys.path.append(EXTRA_PATH)
import numpy as np
import struc_prop as AXIS


fp     = open(sys.argv[1],'r')
n_start=int(sys.argv[2])
fp_out = open('struc.dat','w')

n=11
n_frames=0
while(1):
    n_frames=n_frames+1
    line = fp.readline()
    nAtoms=int(line)
    L=np.array([float(d) for d in fp.readline().split()[1:]])
    r=[]
    r_s=[]
    r_p=[]
    for i in range(nAtoms):
        l = fp.readline().split()
        if(n_frames>=n_start):
            if(l[0]=='A' or l[0]=='T' or l[0]=='G' or l[0]=='C'):
                r.append([float(d) for d in l[1:]])
            elif(l[0]=='S'):
                r_s.append([float(d) for d in l[1:]])
            elif(l[0]=='P'):
                r_p.append([float(d) for d in l[1:]])

    if(n_frames>=n_start):
        r_p=np.array(r_p)
        dat1=(r_p[:len(r_p)//2])[3:-3]
        dat2=(r_p[len(r_p)//2:])[3:-3]
        [d1,r1,ang1,d]= AXIS.Parseq(dat1)
        [d2,r2,ang2,d]= AXIS.Parseq(dat2)
        fp_out.write('%d %f %f %f %f %f %f\n'%(n_frames, d1, d2, r1, r2, ang1, ang2))
