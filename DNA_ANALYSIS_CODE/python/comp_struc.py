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
from scipy.spatial import distance
from scipy.interpolate import interp1d
fp_out2=open('data.xyz','w')
def write_xyz(r1,r2,fp):
    fp.write('%d\n'%(len(r1)+len(r2)))
    fp.write('0 %f %f %f\n'%(20,20,20))
    for i in range(len(r1)):
        fp.write('%s %f %f %f \n'%('P',r1[i][0],r1[i][1],r1[i][2]))
    for i in range(len(r2)):
        fp.write('%s %f %f %f \n'%('P',r2[i][0],r2[i][1],r2[i][2]))

def minor_major(r1,r2):
    dists=[]
    
    n=np.linspace(0,1,len(r1))
    resolution=40
    add=0.5
    n2=np.linspace(0,1,len(r1)*resolution)
   
    R1func=interp1d(n,r1,axis=0,kind='cubic')
    R2func=interp1d(n,r2,axis=0,kind='cubic')
    R1=R1func(n2)
    R2=R2func(n2)
   # write_xyz(R1,R2,fp_out2)
    

    for i in range(4,len(r1)-5):
        # d0=np.linalg.norm(r1[i]-r2[i-3])
        # d1=np.linalg.norm(r1[i]-r2[i+5])

        RA=R1[int(np.ceil((i-add)*resolution)):int(np.floor((i+add)*resolution))]
        RB=R2[int(np.ceil((i-3-add)*resolution)):int(np.floor((i-3+add)*resolution))]
        RC=R2[int(np.ceil((i+5-add)*resolution)):int(np.floor((i+5+add)*resolution))]


        d0=np.min(distance.cdist(RA,RB))
        d1=np.min(distance.cdist(RA,RC))
#        print(d0,d1)
       # print(np.min(di))
       # inside=np.r_[True, di[1:] < di[:-1]] & np.r_[di[:-1] < di[1:], True]
    
        dists.append([d0,d1])
#        print(inside)
        #if(len(di[inside])==2):
        #    dists.append(di[inside])
    
    return np.array(dists)
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
    
        dat1=(r_p[:len(r_p)//2])#[2:-2]
        dat2=(r_p[len(r_p)//2:])#[2:-2]
        [d1,r1,ang1,d]= AXIS.Parseq(dat1)
        [d2,r2,ang2,d]= AXIS.Parseq(dat2)
        dists=minor_major(dat1,dat2[::-1])
        dists=np.mean(dists,axis=0)
        fp_out.write('%d %f %f %f %f %f %f %f %f\n'%(n_frames, d1, d2, r1, r2, ang1, ang2,dists[0],dists[1]))



     
