import numpy as np
import sys
w1=np.loadtxt(sys.argv[1])[1][::-1]
model1 = np.poly1d(w1)
print(model1(float(sys.argv[2])))