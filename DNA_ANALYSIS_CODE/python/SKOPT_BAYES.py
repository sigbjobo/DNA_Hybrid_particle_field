## /usr/local/bin/python3

#ADDED BY SIGBJORN
import sys, os
sys.path.append(os.environ['SHELL_PATH'])
sys.path.append(os.environ['PYTHON_PATH'])
import RUN_ANA_OCCAM as F

from skopt import dump
from skopt import gp_minimize
#from skopt import callbacks
#from skopt.callbacks import CheckpointSaver



import numpy as np

# def f(x):
#       os.environ['NW']    = "%f"%(x[0])
# 	os.environ['NN']    = "%f"%(x[1])
# 	os.environ['PW']    = "%f"%(x[2])
# 	os.environ['PP']    = "%f"%(x[3])
       
# 	res = F.func_para()**2
# 	return res

# def f2(x):
# 	os.environ['NN']    = "%f"%(x[0])
# 	os.environ['PW']    = "%f"%(x[1])
# 	os.environ['PW']    = "%f"%(x[1])
	
# 	print(x)
# #	res = F.func_para()**2

# 	res = (x[0]+1.)**2 +(x[1]+10.)**2
# 	print(x,res)
# 	return res
 
def f3(x):
    os.environ['NW']    = "%f"%(x[0])
    os.environ['NN']    = "%f"%(x[1])
    os.environ['PW']    = "%f"%(x[2])

    res = F.func_para()**2

    #Turn of compilation
    os.environ['COMPILE']    = "%d"%(0)



    return res


if __name__ == '__main__':	
    # FILE FOR SAVING PROGRESS IN SKOPT-FORMAT
    # checkpoint_callback = callbacks.CheckpointSaver("./result.pkl")
    # checkpoint_saver = CheckpointSaver("./checkpoint.pkl", compress=9)
	
    # BOUNDS FOR THE FOUR VARIABLES
    bounds=[(0.0, 10.0),
	    (-30.0, 0.0),
	    (-30.0, 0.0), 
	    (-30.0, 0.0)]
    bounds3=[(0.0, 15.0),
	    (-30.0, 0.0),
	    (-30.0, 0.0)]

    bounds2=[(-30.0, 0.0), 
	     (-30.0, 0.0)]

    # bounds3=[(0.0, 10.0)
    # 	     (-30.0, 0.0), 
    # 	     (-30.0, 0.0)]
    


    nstart = int(os.environ['OPT_INIT_STEPS'])
    ncalls = int(os.environ['OPT_STEPS'])
  #  noise  = float(os.environ['NOISE'])**2 
    xstart = [float(os.environ['NN']),float(os.environ['PW'])]
    
    print('Starting optimization....')
    print('Number of intial steps: %d'%(nstart))
    print('Number of optimization steps: %d'%(ncalls))
#    print('Noise used: %f'%(noise))
 
    # RUN OPTIMIZATION
    res=gp_minimize(f3, 
		bounds3,
		n_calls=ncalls, 
		n_random_starts=nstart)
#		callback=[checkpoint_callback])
#		noise=noise

    dump(res, 'final.pkl',store_objective=False)
    print(res)
