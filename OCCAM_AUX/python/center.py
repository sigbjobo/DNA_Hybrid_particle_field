import numpy as np
import sys 

fp  = open(sys.argv[1])
fp2 = open('fort_center.xyz', 'w')
fp3 = open('fort.5')

#size of first molecule
line = fp3.readlines()
N1=int(line[6])

a=0
while True:
    str= fp.readline()
    line= str.strip()
    if line == '':
        # either end of file or just a blank line.....
        # we'll assume EOF, because we don't have a choice with the while loop!
        break
    fp2.write(str)
    N=int(str)
    str = fp.readline()
    fp2.write(str)
    
    str=str.split()
    LX = float(str[1])*10
    LY = float(str[2])*10
    LZ = float(str[3])*10
    data = np.zeros([N,3])
    names = []
    for i in range(N):
        str = fp.readline().split()
        names.append(str[0])
        data[i,0] = float(str[1])
        data[i,1] = float(str[2])
        data[i,2] = float(str[3])
   
    
    
    for l in range(20):
        y= np.abs(data[1:N1,:]-data[0:N1-1,:])>0.5*np.array([LX,LY,LZ])
        if(sum(sum(y))==0):
            break
        if(sum(y[:,0])):
            data[:,0] += LX/4
        if(sum(y[:,1])):
            data[:,1] += LY/4
        if(sum(y[:,2])):
            data[:,2] += LY/4
        data = data - np.array([LX,LY,LZ])*np.floor(data/np.array([LX,LY,LZ]))
                
    data = data - np.array([LX,LY,LZ])*np.floor(data/np.array([LX,LY,LZ]))
    R_CM = np.sum(data[:N1,:],0)/float(N1)
    data = data + 0.5*np.array([LX,LY,LZ])- R_CM
    data = data - np.array([LX,LY,LZ])*np.floor(data/np.array([LX,LY,LZ]))

    for i in range(N):
        str1='%s %f %f %f \n' %(names[i],data[i,0], data[i,1], data[i,2])
        fp2.write(str1)


