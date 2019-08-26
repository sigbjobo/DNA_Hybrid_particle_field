import numpy as np
from scipy import optimize
import sys

fn1=sys.argv[1]
fn2=sys.argv[2]

w1=np.loadtxt(fn1)[1][::-1]  
w2=np.loadtxt(fn2)[1][::-1]

model1 = np.poly1d(w1)
model2 = np.poly1d(w2)

def func(x):
    return model1(x)-model2(x)

sol = optimize.root(func,x0=0)
print(sol.x[0])

