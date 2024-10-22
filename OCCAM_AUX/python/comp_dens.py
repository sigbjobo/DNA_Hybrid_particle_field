import numpy as np
import sys

print("filename: %s"%( sys.argv[1]))

fp = open(sys.argv[1],'r')
fp_z=open('Zs.dat','w')
nz=61
start=2
if(len(sys.argv)>2):
    start = int(sys.argv[2])
if(len(sys.argv)>3):
    nz= int(sys.argv[3])
if(len(sys.argv)>4):
    center= bool(sys.argv[4])

names=['N','P','G','C','D','W','T']
N=np.zeros((nz,len(names)))
l=fp.readline()

r=0

end=10000000
while (not (l=="")):
    l= l.split()
    numa=int(l[0])
    l=fp.readline()
    l=l.split()

    LX=float(l[1])*10
    LY=float(l[2])*10
    LZ=float(l[3])*10

    if(r>end):
        break
    r=r+1
    for i in range(numa):
        l=fp.readline()
        l=l.split()
      
        iz=np.mod(int(nz*float(l[3])/LZ),nz)
        index=names.index(l[0])
        if(r>start):
            N[iz,index]+=1
    l=fp.readline()
    fp_z.write('%f\n'%(LZ))

fp_z.close()
fp.close()
#N=np.divide(N,np.sum(N,axis=1)[:,None])
N=N/((r-start)*LZ/nz*LX*LY*0.1**3)#np.mean(np.sum(N,axis=1))

factor=np.mean(0.5*(N[:4,-1]+N[-4:,-1]))/8.33
z=N[:,-1]>7.8
if(sum(z)>0):
    print("water density:",np.mean(N[z,-1]))
    print('correct water:',int(14000/factor),1./factor)

    print("total density:",np.mean(np.sum(N,axis=1)))
    print("factor:",8.33/np.mean(np.sum(N,axis=1)))


#N[iz,index]=N[iz,index]*1./((r-start)*1E-3*LX*LY*LZ/nz)
#N[iz,index]=N[iz,index]*1./((r-start)*1E-3*LX*LY*LZ/nz)
fp=open("density.dat",'w')
fp.write('#z')
for n in names:
    fp.write('\t\t%s'%(n))
fp.write('\n')

for i in range(nz):
    fp.write("%f" %((i+0.5)/nz))
    for j in range(len(names)):
        fp.write("\t%f"%(N[i,j]))
    fp.write('\n')

#Z=np.zeros((nz,len(N[0][:]+1)))
#Z[:,1:] = N
#Z[:,0]  = np.linspace(0.5*LZ/nz,LZ-0.5*LZ/nz,nz)
#fp=open('density_tot.dat','w')

#np.savetxt('density_tot.dat',N)
        
        
    
    
