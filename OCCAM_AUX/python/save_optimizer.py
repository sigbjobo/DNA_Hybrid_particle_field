import os
import ast
import types
import json
import numpy as np


def dump_bounds(log_file, bounds):
    log_dir = os.path.dirname(log_file)
    bounds_file = os.path.join(log_dir, 'bounds.json')
    with open(bounds_file, 'w') as out_file:
        json.dump(bounds, out_file)


def new_log_file_name():
    os.makedirs('logs', exist_ok=True)
    files = os.listdir('logs')
    num = 0
    for f in files:
        s = f.split('.')
        if 'log' in s[0] and 'json' in s[-1]:
            s = s[0].split('_')
            num = max(num, int(s[-1])+1)
    return os.path.join('logs', 'log_{n}.json'.format(n=num))


def find_log_files():
    if not os.path.exists('logs'):
        return []
    else:
        files = os.listdir('logs')
        log_files = []
        for f in files:
            if ('log' in f) and ('.json' in f):
                log_files.append(f)
        return [os.path.abspath(os.path.join('logs', f)) for f in log_files]


def _convert_tuple_keys_to_string(dictionary):
    k = dictionary.keys()
    v = dictionary.values()
    k_str = [str(t) for t in k]
    return dict(zip(*[k_str, v]))


def _convert_string_keys_to_tuple(dictionary):
    k = dictionary.keys()
    v = dictionary.values()
    k_tuple = [ast.literal_eval(s) for s in k]
    return dict(zip(*[k_tuple, v]))


def save_optimizer(optimizer, dir_name=None):
    if dir_name is None:
        file_dir = os.path.dirname(__file__)
        save_path = os.path.join(file_dir, 'opt_save')
        if not os.path.exists(save_path):
            os.makedirs(save_path)
    else:
        os.makedirs(dir_name)
        save_path = dir_name

    file_name = os.path.join(save_path, 'opt.json')
    cache_file_name = os.path.join(save_path, 'cache.json')

    variables = optimizer._space.__dict__
    attribute_to_delete = []
    for v in variables:
        if isinstance(variables[v], np.ndarray):
            setattr(optimizer._space, v, variables[v].tolist())

        # Remove the random state and the target function before dumping to
        # .json, since these are not trivially serializable.
        elif (isinstance(variables[v], np.random.mtrand.RandomState)
              or isinstance(variables[v], types.FunctionType)):
            attribute_to_delete.append(v)
    for v in attribute_to_delete:
        delattr(optimizer._space, v)

    # Dictionaries with tuple keys are not .json serializable, so we convert
    # the keys to strings before we dump.
    save_dict = {}
    for v in variables:
        if isinstance(variables[v], dict):
            nested_dict = variables[v]
        else:
            save_dict[v] = variables[v]
    nested_dict = _convert_tuple_keys_to_string(nested_dict)

    with open(file_name, 'w') as out_file:
        json.dump(save_dict, out_file)
    with open(cache_file_name, 'w') as out_file:
        json.dump(nested_dict, out_file)
    return file_name


def load_optimizer(opt, path):
    with open(path, 'r') as in_file:
        save_dict = json.load(in_file)
    cache_file_name = os.path.join(os.path.dirname(path), 'cache.json')
    with open(cache_file_name, 'r') as in_file:
        cache = json.load(in_file)
    cache = _convert_string_keys_to_tuple(cache)

    for v in save_dict:
        setattr(opt._space, v, save_dict[v])
    setattr(opt._space, 'cache', cache)
    return opt
