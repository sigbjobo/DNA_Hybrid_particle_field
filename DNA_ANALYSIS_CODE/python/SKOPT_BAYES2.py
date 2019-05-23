# /usr/local/bin/python3

#ADDED BY SIGBJORN
import sys, os
sys.path.append(os.environ['SHELL_PATH'])
sys.path.append(os.environ['PYTHON_PATH'])
import RUN_ANA_OCCAM as F

from skopt import gp_minimize
from skopt import callbacks
from skopt.callbacks import CheckpointSaver
from skopt import Optimizer



import numpy as np

# def f(x):
#         os.environ['NW']    = "%f"%(x[0])
# 	os.environ['NN']    = "%f"%(x[1])
# 	os.environ['PW']    = "%f"%(x[2])
# 	os.environ['PP']    = "%f"%(x[3])
       
# 	res = F.func_para()**2
# 	return res

def f2(x):
	os.environ['NN']    = "%f"%(x[0])
	os.environ['PW']    = "%f"%(x[1])
               
	res = F.func_para()**2
	return res


if __name__ == '__main__':
	
    # FILE FOR SAVING PROGRESS IN SKOPT-FORMAT
    checkpoint_callback = callbacks.CheckpointSaver("./result.pkl")
    checkpoint_saver = CheckpointSaver("./checkpoint.pkl", compress=9)

    # BOUNDS FOR THE FOUR VARIABLES
    bounds=[(0.0, 10.0),
	    (-30.0, 0.0),
	    (-30.0, 0.0), 
	    (-30.0, 0.0)]

    bounds2=[(-30.0, 0.0), 
	     (-30.0, 0.0)]
    

    opt = Optimizer(bounds2, 
		    "ET", acq_optimizer="sampling",
		    noise=float(os.environ['NOISE'])**2)

    for i in range(int(os.environ['OPT_STEPS'])):
	    next_x = opt.ask()
	    f_val = f2(next_x)
	    opt.tell(next_x, f_val)
	    with open('my-optimizer.pkl', 'wb') as file1:
		    pickle.dump(opt, file1)


    # RUN OPTIMIZATION
    # gp_minimize(f2, 
    # 		bounds2, 
    # 		n_calls=int(os.environ['OPT_STEPS']), 
    # 		random_state=int(os.environ['OPT_INIT_STEPS']),
    # 		callback=[checkpoint_callback],
    # 		noise=float(os.environ['NOISE'])**2
    # 		)
 
