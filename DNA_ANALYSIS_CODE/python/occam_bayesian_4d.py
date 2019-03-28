# /usr/local/bin/python3
#SIGBJORN ADDONS
import sys
SHELL_PATH="/cluster/home/sigbjobo/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/shell"
PYTHON_PATH="/cluster/home/sigbjobo/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/python"
EXTRA_PATH="/home/sigbjobo/Stallo/Projects/DNA/DNA_Hybrid_particle_field/DNA_CODE_PLOT/DNA_ANALYSIS_CODE/python"
sys.path.append(SHELL_PATH)
sys.path.append(PYTHON_PATH)
sys.path.append(EXTRA_PATH)
import FUNC as F

import os
import numpy as np
from math import isnan
from bayes_opt import BayesianOptimization
from bayes_opt.observer import JSONLogger, ScreenLogger
from bayes_opt.event import Events
from bayes_opt.util import load_logs
#from franke import franke
from save_optimizer import new_log_file_name, find_log_files, dump_bounds


param_file_name = 'opt.dat'
result_file_name = 'opt.dat'


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


# def run_simulation():
#     """Start the actual simulation run"""
#     params = []
#     with open(param_file_name, 'r') as in_file:
#         for line in in_file:
#             params.append(float(line))

#     with open(result_file_name, 'w') as out_file:
#         f = franke(params[0], params[1])
#         out_file.write(str(f))


def extract_results():
    """Extracts the results from the last simulation run"""
    res = []
    with open(result_file_name, 'r') as in_file:
        for line in in_file:
            res.append(float(line))
    return res


def cost(result):
    """Cost function to maximize"""
    target = 1.5
    return - (result - target)**2


def optimize_2d(path=None, steps=None, init_points=None, bounds=None,
                true_function=None, plot=False, load=False,extra=20):
    k=extra
    def wrapper(x, y):
        res=-F.func_para([x,y],k)
#        res = extract_results()
        return res

    opt = BayesianOptimization(f=wrapper,
                               pbounds=bounds,
                               verbose=2,
                               random_state=92898)
    log_file = new_log_file_name()
    logger = JSONLogger(path=log_file)
    screen_logger = ScreenLogger(verbose=2)
    opt.subscribe(Events.OPTMIZATION_STEP, logger)
    opt.subscribe(Events.OPTMIZATION_START, screen_logger)
    opt.subscribe(Events.OPTMIZATION_STEP, screen_logger)
    opt.subscribe(Events.OPTMIZATION_END, screen_logger)
    print('Logging to logfile: ', os.path.abspath(log_file))
    dump_bounds(log_file, bounds)

    no_log_files_found = False
    if load:
        files = find_log_files()
        if len(files) > 0:
            print('Loading previous runs from logfile(s):')
            for f in files:
                print(f)
            load_logs(opt, logs=files)
        else:
            no_log_files_found = True
    if (init_points is not None) and (init_points > 0):
        if no_log_files_found or not load:
            opt.maximize(init_points=init_points, n_iter=0)

    first_step = True
    opt.unsubscribe(Events.OPTMIZATION_END, screen_logger)
    print('')
    if _check_steps_finite(steps):
        for _ in range(steps):
            opt.maximize(init_points=0, n_iter=1)
            if first_step:
                opt.unsubscribe(Events.OPTMIZATION_START, screen_logger)
                first_step = False
    else:
        while True:
            opt.maximize(init_points=0, n_iter=1)
    print("MAX: ", opt.max)
    return opt


if __name__ == '__main__':
    # Max (x, y) values of the Franke test function, as computed by Matlab:
    #
    # >> n = 5000; pts = (0:n)/n; [x,y] = ndgrid(pts,pts); z = franke(x,y);
    # >> [m,i] = max(z); [mm,j] = max(m); i(j)/n, j/n
    # (0.2062, 0.2082)
    #
    k = float(sys.argv[3])
    opt=optimize_2d(steps=int(sys.argv[2]), init_points=int(sys.argv[1]),
                    bounds={'x': (0, 20), 'y': (-15, 0),'z': (-15, 0),'u': (-15, 0)},
                 plot=False, extra=k)

    # opt = optimize_2d(steps=10, init_points=10,
    #                   bounds={'x': (0, 1), 'y': (-0.2, 1)}, load=True)
