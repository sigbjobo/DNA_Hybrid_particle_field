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
    [fp, rp, rs, rn, L, on] = ANA.read_frame(fp)
  
    #MAKE Nx3 VECTOR CONTAINING POSITIONS OF INITIAL STRUCTURE
    r0= np.vstack((rp,rs,rn))

    #VECTOR CONTAINING FITNESS
    z=[]
    while(on):
        
        r=np.vstack((rp,rs,rn))

        #RMSD OF FRAME
        rmsd=ANA.rmsd_dist(r0,r)*0.1
        
        #GROOVES                                                                                                                                    
        meangrooves = ANA.minor_major(rp)*0.1
      
        #FITNESS OF FRAME
        zi = rmsd**2 # np.sqrt(0.5*((meangrooves[0]-1.18)**2+(meangrooves[1]-1.71)**2)+rmsd**2)
        z.append(zi)

        #READ NEW FRAME
        [fp, rp, rs, rn, L, on] = ANA.read_frame(fp)

    #REMOVE FRAMES
    z=z[start:]
    
    return np.mean(z), np.std(z)

 
def func_para():

    #START SIMULATION 
    subprocess.call("bash %s/evaluate_fitness.sh"%(os.environ["SHELL_PATH"]), shell=True)

    #LIST ALL SIMULATIONS
    folds = ANA.list_sim_fold()

    #ANALYZE CURRENT SIMULATION
    z,z_std = ana_sim('%s/sim.xyz'%(folds[-1]),start=39)

    #STORE FITNESS
    fp = open('opt.dat','a')
    fp.write("%s %s %s %s %f %f\n"%(os.environ['NW'], os.environ['NN'], os.environ['PW'], os.environ['PP'], -z, z_std))
    fp.close()

    #RETURN FITNESS
    return z



