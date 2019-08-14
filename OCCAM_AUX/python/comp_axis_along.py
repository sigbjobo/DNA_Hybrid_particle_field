import sys
#Setting paths                                                                                                            
SHELL_PATH="/cluster/home/sigbjobo/DNA/HPF/OCCAM_AUX/shell"
PYTHON_PATH="/cluster/home/sigbjobo/DNA/HPF/OCCAM_AUX/python"
EXTRA_PATH="/home/sigbjobo/Stallo/Projects/HPF/PLOT/python"
sys.path.append(SHELL_PATH)
sys.path.append(PYTHON_PATH)
sys.path.append(EXTRA_PATH)
import numpy as np
import struc_prop as AXIS
import ana_prot as ANA

fp     = open(sys.argv[1],'r')
n_start=int(sys.argv[2])
n = int(sys.argv[3])
ss= bool(sys.argv[4])
fp_out = open('struc_auto.dat','w')
 

n_frames=0
while(1):
    n_frames=n_frames+1
    try:
        line = fp.readline()
        nAtoms=int(line)
    except: 
        break

    L=np.array([float(d) for d in fp.readline().split()[1:]])
    r_p=[]
    for i in range(nAtoms):
        l = fp.readline().split()
        if(n_frames>=n_start):
            if(l[0]=='P'):
                r_p.append([float(d) for d in l[1:]])
                
    if(n_frames>=n_start):
        r_p=np.array(r_p)
        if (ss):
            dat1=r_p#[3:-3]
            #  print len(dat1)
#            print dat1
            d1 = AXIS.axis_along(dat1, n, L)
            d1 = d1/np.linalg.norm(d1,axis=1)[:,None]
            a  = ANA.auto_corr(d1)
        else:
            dat1=(r_p[:len(r_p)//2])[3:-3]
            dat2=(r_p[len(r_p)//2:])[3:-3]
            d1 = AXIS.axis_along(dat1,n,L)
            d2 = AXIS.axis_along(dat2,n,L)
            d1=d1/np.linalg.norm(d1,axis=1)[:,None]
            d2=d2/np.linalg.norm(d2,axis=1)[:,None]
            a = 0.5*(ANA.auto_corr(d1)+ANA.auto_corr(d2))
        autocorr=["%e"%(k) for k in a]
       # print autocorr
        fp_out.write('%d %s\n'%(n_frames, ' '.join(autocorr)))
fp_out.close()
A=np.mean(np.loadtxt('struc_auto.dat')[:,1:],axis=0)

fp_out=open('struc_auto.dat','w')
for i in range(len(A)):
    fp_out.write('%d %e\n'%(i,A[i]))
fp_out.close()
    
