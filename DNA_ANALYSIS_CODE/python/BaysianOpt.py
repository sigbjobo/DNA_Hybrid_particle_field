import numpy as np
import sys
from gpflowopt.domain import ContinuousParameter
#Setting paths                                                                                                            
SHELL_PATH="/home/sigbjobo/Projects/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/shell"
PYTHON_PATH="/home/sigbjobo/Projects/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/python"
EXTRA_PATH="/home/sigbjobo/Stallo/Projects/DNA/DNA_Hybrid_particle_field/DNA_CODE_PLOT/DNA_ANALYSIS_CODE/python"
sys.path.append(SHELL_PATH)
sys.path.append(PYTHON_PATH)
sys.path.append(EXTRA_PATH)
import FUNC as F

from gpflowopt.domain import ContinuousParameter
#import FUNC as FUNC                                                                                                                                                         
domain = ContinuousParameter('x1', -5, 30) + \
         ContinuousParameter('x2', -30, 5)

import gpflow
from gpflowopt.bo import BayesianOptimizer
from gpflowopt.design import LatinHyperCube
from gpflowopt.acquisition import ExpectedImprovement
from gpflowopt.optim import SciPyOptimizer, StagedOptimizer, MCOptimizer

# Use standard Gaussian process Regression
data=np.loadtxt("XY.dat")
#X=LatinHyperCube(10, domain)
#print(X)
X = data[:,:2]
#print(X)
Y =  data[:,-1][:,None]
model = gpflow.gpr.GPR(X, Y, gpflow.kernels.Matern52(2, ARD=True))
model.kern.lengthscales.transform = gpflow.transforms.Log1pe(1e-3)

# Now create the Bayesian Optimizer
alpha = ExpectedImprovement(model)
acquisition_opt = StagedOptimizer([MCOptimizer(domain, 200),
                                   SciPyOptimizer(domain)])

optimizer = BayesianOptimizer(domain, alpha, optimizer=acquisition_opt, verbose=True)

# Run the Bayesian optimization
r = optimizer.optimize(F.func, n_iter=10)
 
