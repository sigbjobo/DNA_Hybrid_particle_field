import os, sys,subprocess
import numpy as np
import calculate_rmsd as rmsd

#Setting paths
SHELL_PATH="/cluster/home/sigbjobo/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/shell"
PYTHON_PATH="/cluster/home/sigbjobo/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/python"
EXTRA_PATH="/home/sigbjobo/Stallo/Projects/DNA/DNA_Hybrid_particle_field/DNA_CODE_PLOT/DNA_ANALYSIS_CODE/python"
from scipy.spatial.distance import cdist
sys.path.append(SHELL_PATH)
sys.path.append(PYTHON_PATH)
sys.path.append(EXTRA_PATH)

import ana_prot as ANA

def ana_sim(fn):
    fp = open(fn,'r')
    start=0   
    a=[]
    on=1
    [fp, r_p, _, rn, L, on] = ANA.read_frame(fp)
  

    r0=np.vstack((r_p,_,rn))
#    map0=contact_map(r)
#    rel=(map0>0)
#    a_exact=np.array([100.,10.,0.338,0.94])
 #   ai=np.zeros(4)
 
    z=[]
    while(on):
        #Compute pairs
        # r1 = rn[:len(rn)//2]
        
        # r2 = rn[len(rn)//2:][::-1]        
        # for i in range(len(r2)):
        #     r2[i] = ANA.period_2d(r1[i], r2[i], L)
        # ai[0] = np.mean(np.array(0.1*np.linalg.norm(r1 - r2, axis = 1) < 1, dtype = float))*100.
        
        # rp=np.array(r_p)
        
        # dat1=(r_p[:len(r_p)//2])[3:-3]
        # ANA.kahn(dat1)

        # dat2=(r_p[len(r_p)//2:])[3:-3]
        # [d1, r1, ang1]= ANA.Parseq(dat1)
        # [d2, r2, ang2]= ANA.Parseq(dat2)
        
        # ai[1]=0.5*(np.mean(360./ang1)+np.mean(360./ang2))
        # ai[2]=0.1*0.5*(np.mean(np.linalg.norm(d1))+np.mean(np.linalg.norm(d2)))
        # ai[3]=0.1*0.5*(np.mean(r1)+np.mean(r2))
        r=np.vstack((r_p,_,rn))
       # zi
        #map1=contact_map(r,L)
     #   print(np.mean(np.abs(map0-map1))) 
     #   zi=np.mean(((a_exact-ai)/a_exact)**2)

       
        zi=rmsd_dist(r0,r)#=np.mean(np.abs((map0[rel]-map1[rel])))
        print(zi)
        z.append(zi)
        [fp, r_p, _, rn, L, on] = ANA.read_frame(fp)
    z=z[start:]
    
    return np.mean(z)

def func(x):
    x = np.atleast_2d(x)
    x1 = x[:, 0]
    x2 = x[:, 1]    
    #os.system("bash %s/eval_fun.sh %f %f "%(SHELL_PATH, x1, x2)) 
    subprocess.call("bash %s/eval_fun.sh %f %f "%(SHELL_PATH, x1, x2), shell=True)
    folds = ANA.list_sim_fold()
    z = ana_sim('%s/sim.xyz'%(folds[-1]),'r')
    fp=open('opt.dat','w')
    fp.write("%f %f %f %f\n"%(x1, x2, z, 100*z**0.5))
    return np.atleast_2d(np.mean(z))
 
def func_para(x):
    x = np.atleast_2d(x)
    x1 = x[:, 0]
    x2 = x[:, 1]  
    
    subprocess.call("bash %s/eval_fun_para.sh %f %f "%(SHELL_PATH, x1, x2), shell=True)#    os.system("bash %s/eval_fun_para.sh %f %f "%(SHELL_PATH, x1, x2)) 
    folds = ANA.list_sim_fold()

    z = ana_sim('%s/sim.xyz'%(folds[-1]))
    fp = open('%s/opt.dat'%(folds[-1]),'w')
    fp.write("%f %f %f\n"%(x1, x2, -z ))
    fp.close
    fp = open('opt.dat','a')
    fp.write("%f %f %f\n"%(x1, x2, -z ))
    fp.close()
    return z
#    return np.atleast_2d(z)


def contact_map(r, L=[1000,1000,1000], rc=1.0):
    """
    FUNCTION THAT COMPUTES CONTACTMAP MATRIX
    """
    d = [cdist(r[:,i][:,np.newaxis],r[:,i][:,np.newaxis]) for i in range(len(L))]
    d = [np.abs(d[i] - L[i]*np.around(d[i]/L[i])) for i in range(len(d))]

    #MIGHT INTRODUCE CUTTOFF HERE

    d = np.sum(d, axis = 0)
    
    return d
    
def rmsd_dist(A,B):

    #REMOVE CENTER OF MASS
    A -= rmsd.centroid(A)
    B -= rmsd.centroid(B)

    #FIND ROTATION MATRIX
    U = rmsd.kabsch(A, B)

    # ROTATE TOWARDS B
    A = np.dot(A, U)

    #RETURN ROOT MEAN SQUARE DEVIATION
    return  rmsd.rmsd(A, B)
