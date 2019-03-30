import os, sys,subprocess
import numpy as np
import calculate_rmsd as rmsd

#ADD PATHS
sys.path.append(os.environ['SHELL_PATH'])
sys.path.append(os.environ['PYTHON_PATH'])


import ana_prot as ANA

def ana_sim(fn, start=10):
    fp = open(fn,'r')
    on=1

    #READ FIRST FRAME
    [fp, r_p, _, rn, L, on] = ANA.read_frame(fp)
  
    #MAKE Nx3 VECTOR CONTAINING POSITIONS OF INITIAL STRUCTURE
    r0= np.vstack((r_p,_,rn))

    #VECTOR CONTAINING FITNESS
    z=[]
    while(on):
        
        r=np.vstack((r_p,_,rn))

        #FITNESS OF FRAME
        zi=ANA.rmsd_dist(r0,r)

        z.append(zi)

        #READ NEW FRAME
        [fp, r_p, _, rn, L, on] = ANA.read_frame(fp)

    #REMOVE FRAMES
    z=z[start:]
    
    return np.mean(z), np.std(z)

 
def func_para():

    #START SIMULATION 
    subprocess.call("bash %s/evaluate_fitness.sh"%(os.environ["SHELL_PATH"]), shell=True)

    #LIST ALL SIMULATIONS
    folds = ANA.list_sim_fold()

    #ANALYZE CURRENT SIMULATION
    z,z_std = ana_sim('%s/sim.xyz'%(folds[-1]))

    #STORE FITNESS
    fp = open('opt.dat','a')
    fp.write("%s %s %s %s %f %f\n"%(os.environ['alpha'], os.environ['beta'], os.environ['PP'], os.environ['PW'], -z, z_std))
    fp.close()

    #RETURN FITNESS
    return z



