# /usr/local/bin/python3
#SIGBJORN ADDONS
import sys
SHELL_PATH="/cluster/home/sigbjobo/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/shell"
PYTHON_PATH="/cluster/home/sigbjobo/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/python"
EXTRA_PATH="/home/sigbjobo/Stallo/Projects/DNA/DNA_Hybrid_particle_field/DNA_CODE_PLOT/DNA_ANALYSIS_CODE/python"
sys.path.append(SHELL_PATH)
sys.path.append(PYTHON_PATH)
sys.path.append(EXTRA_PATH)

import numpy as np
from math import isnan
from bayes_opt import BayesianOptimization

from visualize_2d import PlotProgress_2D


param_file_name = 'param.dat'
result_file_name = 'res.dat'
import FUNC as F


def _check_steps_finite(steps):
    if isnan(steps) or np.isnan(steps):
        return False
    elif steps < 0:
        return False
    else:
        return True


def change_parameters(*params):
    """Sets the parameters for the current simulation run"""
    with open(param_file_name, 'w') as out_file:
        for p in params:
            out_file.write(str(p) + '\n')


def run_simulation():
    """Start the actual simulation run"""
    params = []
    with open(param_file_name, 'r') as in_file:
        for line in in_file:
            params.append(float(line))

    with open(result_file_name, 'w') as out_file:
        f = franke(*tuple(params))
        out_file.write(str(f))


def extract_results():
    """Extracts the results from the last simulation run"""
    res = []
    with open(result_file_name, 'r') as in_file:
        for line in in_file:
            res.append(float(line))
    return res


def cost(result, target):
    """Cost function to maximize"""
    return - (result - target)**2


def optimize_2d(path=None, steps=None, init_points=None, bounds=None,
                true_function=None, plot=False):
    target = 0.

    def wrapper(x, y):
       # change_parameters(x, y)
       # res=F.func_para([x,-10]) 
      #  run_simulation()
      #  res = extract_results()
        return -F.func_para([x,y])
    
    opt = BayesianOptimization(f=wrapper,
                               pbounds=bounds,
                               verbose=2,
                               random_state=92898)
    if plot:
        pp2 = PlotProgress_2D(opt, true_function=true_function,
                              cost=lambda x: cost(x, target))
    opt.maximize(init_points=init_points, n_iter=0)

    if plot:
        pp2.plot()

    if _check_steps_finite(steps):
        for _ in range(steps):
            opt.maximize(init_points=0, n_iter=1)
            if plot:
                pp2.plot()
    else:
        while True:
            opt.maximize(init_points=0, n_iter=1)
            if plot:
                pp2.plot()


if __name__ == '__main__':
    optimize_2d(steps=20, init_points=5,
                bounds={'x': (0, 30), 'y': (-15, 0)},
                 plot=False)
