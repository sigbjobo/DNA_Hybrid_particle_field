import numpy as np
import sys

print("filename: %s"%( sys.argv[1]))

fp = open(sys.argv[1],'r')
fp_z=open('Zs.dat','w')
nz=30
start=2
if(len(sys.argv)>2):
    nz= int(sys.argv[2])

names=['N','P','G','C','D','W','T']
N=np.zeros((nz,len(names)))
l=fp.readline()

r=0
fp_out=open("density.dat",'w')
fp_out.write('#r')
for n in names:
    fp_out.write('\t%s'%(n))
fp_out.write('\n')
 
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
    N=np.zeros((nz,len(names)))

    for i in range(numa):
        l=fp.readline()
        l=l.split()

        R=np.sqrt((float(l[1])-0.5*LX)**2+(float(l[2])-0.5*LY)**2+(float(l[3])-0.5*LZ)**2)
        iz=np.mod(int(nz*R/LZ),nz)
        index=names.index(l[0])
        
        N[iz,index]+=1

    r1=np.zeros(nz)
    r2=np.zeros(nz)
    for i in range(nz):
        r1[i]=np.sqrt((0.1*i*LZ/nz)**2)
        r2[i]=np.sqrt((0.1*(i+1)*LZ/nz)**2)
        vol=4*np.pi/3.*(r2**3-r1**3)
    N=N/(vol[:,None])#np.mean(np.sum(N,axis=1))
    for i in range(nz):
        fp_out.write("%f" %((i+0.5)/nz))
        for j in range(len(names)):
            fp_out.write("\t%f"%(N[i,j]))
        fp_out.write('\n')
    fp_out.write(' \n')
    fp_z.write('%f\n'%(LZ))

   
    
    l=fp.readline()
fp.close()
#N=np.divide(N,np.sum(N,axis=1)[:,None])
#shell_volume=
# r1=np.zeros(nz)
# r2=np.zeros(nz)
# for i in range(nz):
#     r1[i]=np.sqrt((0.1*i*LZ/nz)**2)
#     r2[i]=np.sqrt((0.1*(i+1)*LZ/nz)**2)
# vol=4*np.pi/3.*(r2**3-r1**3)
# N=N/((r-start)*vol[:,None])#np.mean(np.sum(N,axis=1))



# #N[iz,index]=N[iz,index]*1./((r-start)*1E-3*LX*LY*LZ/nz)
# #N[iz,index]=N[iz,index]*1./((r-start)*1E-3*LX*LY*LZ/nz)
# fp=open("density.dat",'w')
# fp.write('#r')
# for n in names:
#     fp.write('\t%s'%(n))
# fp.write('\n')
 
# for i in range(nz):
#     fp.write("%f" %((i+0.5)/nz))
#     for j in range(len(names)):
#         fp.write("\t%f"%(N[i,j]))
#     fp.write('\n')

# #Z=np.zeros((nz,len(N[0][:]+1)))
# #Z[:,1:] = N
# #Z[:,0]  = np.linspace(0.5*LZ/nz,LZ-0.5*LZ/nz,nz)
# #fp=open('density_tot.dat','w')

# #np.savetxt('density_tot.dat',N)
        
        
    
    
