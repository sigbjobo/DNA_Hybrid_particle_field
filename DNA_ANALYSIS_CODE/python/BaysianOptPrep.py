import numpy as np
import sys
import os
from gpflowopt.domain import ContinuousParameter
import FUNC as FUNC 
domain = ContinuousParameter('x1', -20, 0) + \
         ContinuousParameter('x2', 0, 30) 

import gpflow
from gpflowopt.bo import BayesianOptimizer
from gpflowopt.design import LatinHyperCube
from gpflowopt.acquisition import ExpectedImprovement
from gpflowopt.optim import SciPyOptimizer, StagedOptimizer, MCOptimizer

# Use standard Gaussian process Regression
lhd = LatinHyperCube(int(sys.argv[1]), domain)
X   = lhd.generate()

np.savetxt('X_start.dat',X)
