import numpy as np
import sys

def comp_hist(fn,fn_out,NZ):
    names=['N','P','G','C','D','W','T']
    #COMPUTE HISTOGRAM FROM VIRIAL AT PARTICLE POSITIONS
    hist=np.zeros((NZ+1,len(names)))
    fp=open(fn,'r')
    fp_out=open(fn_out,'w')
    end=100000

    nframes=0
    while (1):
        l=fp.readline()
        l= l.split()
        if(len(l)==0):
            break
        numa=int(l[0])
        l=fp.readline()
        l=l.split()

        LX=float(l[1])*10
        LY=float(l[2])*10
        LZ=float(l[3])*10

        dv=LX*LY*LZ/NZ*1E-3
        nframes+=1
        if(nframes>end):
            break
        
        for i in range(numa):
            l=fp.readline()
            l=l.split()
            
            z=float(l[-1])
            if(len(l)<3):
                break
            #INDEX OF LEFT VERTEX
            z_=z/LZ
            IZ=int(z_*NZ)
            if(z>LZ):
                print(z,LZ)
            #WEIGTH ON RIGHT VERTEX
            a = z_*NZ - int(z_*NZ)
            index=names.index(l[0])

            #PROJECTION OF PRESSURE ONTO GRID
#            print(IZ)
            hist[IZ,index]   += (1.-a)/dv
            hist[IZ+1,index] +=  a/dv 



    #NORMALIZATION TO NUMBER OF FRAMES
    hist=hist/nframes

    #CORRECTING FOR PERIODIC BC
    hist[0]=hist[0]+hist[-1]
    hist[-1]=hist[0]
    hist=hist[:-1]
   
    #NORMALIZE BY NZ, OCCAM WRITES OUT VIR/VOL
    #AND SETTING TO PASCAL
   # hist=N/((r-start)*LZ/nz*LX*LY*0.1**3)
    
    #WRITING OUT HISTOGRAM
    fp_out=open(fn_out,'w')
    for i in range(NZ):
        fp_out.write('%E'%(i*1./NZ))
        for j in range(len(hist[0])):
            fp_out.write('\t%E'%(hist[i,j]))
        fp_out.write('\n')
    
    fp_out.write('%E'%(1.))
    for j in range(len(hist[0])):
        fp_out.write('\t%E'%(hist[0,j]))
    fp_out.close()
nz=31
if(len(sys.argv)>2):
    start = int(sys.argv[2])
if(len(sys.argv)>3):
    nz= int(sys.argv[3])


comp_hist(sys.argv[1],'density.dat',nz)

# print("filename: %s"%( sys.argv[1]))

# fp = open(sys.argv[1],'r')
# nz=61
# start=2
# if(len(sys.argv)>2):
#     start = int(sys.argv[2])
# if(len(sys.argv)>3):
#     nz= int(sys.argv[3])
# if(len(sys.argv)>4):
#     center= bool(sys.argv[4])

# names=['N','P','G','C','D','W','T']
# N=np.zeros((nz,len(names)))
# l=fp.readline()

# r=0

# end=10000000
# while (not (l=="")):
#     l= l.split()
#     numa=int(l[0])
#     l=fp.readline()
#     l=l.split()

#     LX=float(l[1])*10
#     LY=float(l[2])*10
#     LZ=float(l[3])*10
#     if(r>end):
#         break
#     r=r+1
#     for i in range(numa):
#         l=fp.readline()
#         if(r>start):
#             l=l.split()
          
#             z=float(l[3])
#             iz=np.mod(int(nz*z/LZ),nz)
#             #WEIGTH ON RIGHT VERTEX
#             a = dat[0]*NZ - int(dat[0]*NZ)
#             index=names.index(l[0])
#             N[iz,index]+=(1.-a)
#             N[iz+1,index]+=a
#     l=fp.readline()
# fp.close()
# #N=np.divide(N,np.sum(N,axis=1)[:,None])
# N=N/((r-start)*LZ/nz*LX*LY*0.1**3)#np.mean(np.sum(N,axis=1))

# factor=np.mean(0.5*(N[:4,-1]+N[-4:,-1]))/8.33
# z=N[:,-1]>7.8
# if(sum(z)>0):
#     print("water density:",np.mean(N[z,-1]))
#     print('correct water:',int(14000/factor),1./factor)

#     print("total density:",np.mean(np.sum(N,axis=1)))
#     print("factor:",8.33/np.mean(np.sum(N,axis=1)))


# #N[iz,index]=N[iz,index]*1./((r-start)*1E-3*LX*LY*LZ/nz)
# #N[iz,index]=N[iz,index]*1./((r-start)*1E-3*LX*LY*LZ/nz)
# fp=open("density.dat",'w')
# fp.write('#z')
# for n in names:
#     fp.write('\t\t%s'%(n))
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
        
        
    
    
