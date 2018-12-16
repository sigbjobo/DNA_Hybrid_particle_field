import os, sys
import numpy as np
#Setting paths
SHELL_PATH="/home/sigbjobo/Projects/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/shell"
PYTHON_PATH="/home/sigbjobo/Projects/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/python"
EXTRA_PATH="/home/sigbjobo/Stallo/Projects/DNA/DNA_Hybrid_particle_field/DNA_CODE_PLOT/DNA_ANALYSIS_CODE/python"
sys.path.append(SHELL_PATH)
sys.path.append(PYTHON_PATH)
sys.path.append(EXTRA_PATH)

import ana_prot as ANA

def func(x):
    x = np.atleast_2d(x)
    x1 = x[:, 0]
    x2 = x[:, 1]    
    start=200
#Run simulation
 
    os.system("bash %s/eval_fun.sh %f %f "%(SHELL_PATH,x1, x2)) 
    folds = ANA.list_sim_fold()
    fp = open('%s/sim.xyz'%(folds[-1]),'r')
    
    a=[]
    on=1
    [fp, r_p, _, rn, L, on] = ANA.read_frame(fp)
    
    a_exact=np.array([100.,10.,0.34,0.94])
    ai=np.zeros(4)
    z=[]
    while(on):
        #Compute pairs
        r1 = rn[:len(rn)//2]
        r2 = rn[len(rn)//2:][::-1]        
        for i in range(len(r2)):
            r2[i] = ANA.period_2d(r1[i], r2[i], L)
        ai[0] = np.mean(np.array(0.1*np.linalg.norm(r1 - r2, axis = 1) < 0.75, dtype = float))*100.
        
        rp=np.array(r_p)
        dat1=(r_p[:len(r_p)//2])[3:-3]
        dat2=(r_p[len(r_p)//2:])[3:-3]
        [d1, r1, ang1]= ANA.Parseq(dat1)
        [d2, r2, ang2]= ANA.Parseq(dat2)
        
        ai[1]=0.5*(np.mean(360./ang1)+np.mean(360./ang2))
        ai[2]=0.1*0.5*(np.mean(np.linalg.norm(d1))+np.mean(np.linalg.norm(d2)))
        ai[3]=0.1*0.5*(np.mean(r1)+np.mean(r2))
        
        zi=np.mean(100*(np.abs((a_exact-ai)/a_exact)))
        z.append(zi)
        [fp, r_p, _, rn, L, on] = ANA.read_frame(fp)
    fp=open('opt.dat','w')
    z=z[start:]
    fp.write("%f %f %f"%(x1, x2, np.mean(z)))
    return np.atleast_2d(np.mean(z))

 
