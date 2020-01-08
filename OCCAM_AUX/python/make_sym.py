import sys
import numpy as np
data=np.loadtxt(sys.argv[1])
#print len(data[:len(data)//2+1 ,0])
#print len(data[len(data)//2:,0 ])
#print data

if(len(data)%2 == 0):
   mid1=int(len(data)//2)
   mid2=int(len(data)//2)
else:
   mid1=int(len(data)//2)+1
   mid2=int(len(data)//2)
left=data[:mid1]
left=left[::-1]
right=data[mid2:]
x=data[:,0]
# x=right[:,0]-left[0,0]
# data2=np.zeros((len(x),len(data[:])))
# #pressure
sym=0.5*(left[:,1:] + right[:,1:])
data2=data*0
data2[:,0]=x
data2[:mid1,1:]=sym[::-1]
data2[mid2:,1:]=sym
#data2=0.5*(left[:,1:] + right[:,1:])
np.savetxt('%s_sym.dat'%(sys.argv[1].split('.')[0]),data2)
