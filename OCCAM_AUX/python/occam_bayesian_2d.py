# /usr/local/bin/python3

#ADDED BY SIGBJORN
import sys, os
sys.path.append(os.environ['SHELL_PATH'])
sys.path.append(os.environ['PYTHON_PATH'])
import RUN_ANA_OCCAM as F

import numpy as np
from math import isnan
from bayes_opt import BayesianOptimization
from bayes_opt.observer import JSONLogger, ScreenLogger
#from bayes_opt.logger import JSONLogger, ScreenLogger
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
                true_function=None, plot=False, load=False):
    
    def wrapper(x, y):
        os.environ['NW'] = "%f"%(x)
        os.environ['NN']  = "%f"%(y)
        res = -F.func_para()
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
            opt.maximize(init_points=init_points, n_iter=0,alpha=1e-5)

    first_step = True
    opt.unsubscribe(Events.OPTMIZATION_END, screen_logger)
    print('')
    if _check_steps_finite(steps):
        for _ in range(steps):
            opt.maximize(init_points=0, n_iter=1,alpha=1e-5)
            if first_step:
                opt.unsubscribe(Events.OPTMIZATION_START, screen_logger)
                first_step = False
    else:
        while True:
            opt.maximize(init_points=0, n_iter=1,alpha=1e-5)
    print("MAX: ", opt.max)
    return opt

def optimize_4d(path=None, steps=None, init_points=None, bounds=None,
                true_function=None, plot=False, load=False):
    
    def wrapper(x, y, z, w):
        os.environ['NW']    = "%f"%(x)
        os.environ['NN']    = "%f"%(y)
        os.environ['PW']    = "%f"%(z)
        os.environ['PP']    = "%f"%(w)
       
        res = -F.func_para()**2
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
 
            opt.maximize(init_points=init_points, n_iter=0,alpha=1e-5)
 
    first_step = True
    opt.probe(
        params={"x": float(os.environ['NW']), "y": float(os.environ['NN']), 'z': float(os.environ['PW']), 'w': float(os.environ['PP'])},
        lazy=True,
    )

    opt.unsubscribe(Events.OPTMIZATION_END, screen_logger)
    print('')
    if _check_steps_finite(steps):
        for _ in range(steps):
            opt.maximize(init_points=0, n_iter=1,alpha=1e-5)
            if first_step:
                opt.unsubscribe(Events.OPTMIZATION_START, screen_logger)
                first_step = False
    else:
        while True:
            opt.maximize(init_points=0, n_iter=1,alpha=1e-5)
    print("MAX: ", opt.max)
    return opt

def optimize_3d(path=None, steps=None, init_points=None, bounds=None,
                true_function=None, plot=False, load=False):
    
    def wrapper(x, y, w):
        os.environ['NW']    = "%f"%(x)
        os.environ['NN']    = "%f"%(y)
        os.environ['PP']    = "%f"%(w)
       
        res = -F.func_para()**2
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
 
            opt.maximize(init_points=init_points, n_iter=0,alpha=1e-5)
 
    first_step = True
    opt.probe(
        params={"x": float(os.environ['NW']), "y": float(os.environ['NN']), 'w': float(os.environ['PP'])},
        lazy=True,
    )

    opt.unsubscribe(Events.OPTMIZATION_END, screen_logger)
    print('')
    if _check_steps_finite(steps):
        for _ in range(steps):
            opt.maximize(init_points=0, n_iter=1,alpha=1e-5)
            if first_step:
                opt.unsubscribe(Events.OPTMIZATION_START, screen_logger)
                first_step = False
    else:
        while True:
            opt.maximize(init_points=0, n_iter=1,alpha=1e-5)
    print("MAX: ", opt.max)
    return opt


def f(x,y,z,w):
        os.environ['NW']    = "%f"%(x)
        os.environ['NN']    = "%f"%(y)
        os.environ['PW']    = "%f"%(z)
        os.environ['PP']    = "%f"%(w)
       
        res = F.func_para()**2
        return res

from skopt import gp_minimize
if __name__ == '__main__':
    bounds=[(0, 10), (-30, 0), (-30, 0), (-30,0)]
    gp_minimize(f,bounds,n_calls=int(os.environ['OPT_STEPS']),random_state=int(os.environ['OPT_INIT_STEPS']))
 
    # opt=optimize_4d(steps=int(os.environ['OPT_STEPS']),
    #                 init_points= int(os.environ['OPT_INIT_STEPS']),
    #                 bounds={'x': (0, 10), 'y': (-30, 0),'z': (-30, 0),
    #                         'w': (-30, 0)}, plot=False)
    # opt=optimize_3d(steps=int(os.environ['OPT_STEPS']),
    #                 init_points=int(os.environ['OPT_INIT_STEPS']),
    #                 bounds={'x': (0, 30), 'y': (-30, 0), 'w': (-30,
    #                                                            0)}, plot=False)

    # opt = optimize_2d(steps=10, init_points=10,
    #                   bounds={'x': (0, 1), 'y': (-0.2, 1)}, load=True)
