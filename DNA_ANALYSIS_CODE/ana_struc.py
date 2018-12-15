import sys
import numpy as np
A=np.loadtxt(sys.argv[1])
print "rise/bp = %.3f+/-%.2f nm"%(0.1*np.mean(A[:,1:2]),0.1*np.std(A[:,1:2]))
print "radius = %.3f+/-%.2f nm"%(0.1*np.mean(A[:,3:4]),0.1*np.std(A[:,3:4]))
print "diameter = %.2f+/-%.2f nm"%(2*0.1*np.mean(A[:,3:4]),2*0.1*np.std(A[:,3:4]))
print "ang/bp = %.1f+/-%.1f deg"%(np.mean(A[:,5:6]),np.std(A[:,5:6]))
print "Bases per turn =",360./np.mean(A[:,5:6]),'+/-',360./np.mean(A[:,5:6])**2*np.std(A[:,5:6])

