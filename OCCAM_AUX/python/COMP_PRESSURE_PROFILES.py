import numpy as np
import sys

def comp_hist(fn,fn_out,NZ,b=1):

    #COMPUTE HISTOGRAM FROM VIRIAL AT PARTICLE POSITIONS
    hist=np.zeros((NZ,20))
    try:
        fp=open(fn)
    except:
        return

    nframes=0
    while(1):
        
        line=fp.readline()
        if(line == '\n'):            
            nframes+=1
         #   print(nframes)
        else:
            dat=np.array([float(li) for li in line.split()])
#            print(dat)
            if(len(dat)<3 ):
                break
            #INDEX OF LEFT VERTEX
            IZ=int(dat[0]*NZ)
            
            #WEIGTH ON RIGHT VERTEX
            a = dat[0]*NZ - int(dat[0]*NZ)
           
            #PROJECTION OF PRESSURE ONTO GRID
            hist[IZ,:len(dat)-1]   += (1.-a) * dat[1:]
            hist[np.mod(IZ+1,NZ),:len(dat)-1] +=  a * dat[1:]

    hist=hist[:,:len(dat)-1]
        

    print(nframes)
    #NORMALIZATION TO NUMBER OF FRAMES
    hist=hist/nframes

    #CORRECTING FOR PERIODIC BC
    # hist[0]=hist[0]+hist[-1]
    # hist[-1]=hist[0]
    # hist=hist[:-1]
   
    #NORMALIZE BY NZ, OCCAM WRITES OUT VIR/VOL
    #AND SETTING TO PASCAL
    if(b==1):
        hist=hist*NZ/6.022E-7
    else:
        hist=hist*NZ/6.022E-7
    #WRITING OUT HISTOGRAM
    fp_out=open(fn_out,'w')
#    print(NZ)
    for i in range(NZ):
        fp_out.write('%E'%(i*1./NZ))
        for j in range(len(hist[0])):
            fp_out.write('\t%E'%(hist[i,j]))
        fp_out.write('\n')
    
    fp_out.write('%E'%(1.))
    for j in range(len(hist[0])):
        fp_out.write('\t%E'%(hist[0,j]))
    fp_out.close()
            
def Average_hist(fn,fn_out): 
    #COMPUTE AVERAGE HISTOGRAM FROM HISTOGRAM OF FRAMES
    n=len(open(fn).readline().split())-1
    hist=np.zeros((1000,n))
    nframes=0
    i=0
    try:
        fp=open(fn)
    except:
        return

    while(1):
        try:
            line=fp.readline()
        except:
            break
        if(line==' \n'):
            hist=hist[:i]
            i=0 
            nframes+=1
        else:
            dat=np.array([float(li) for li in line.split()])
            if(len(dat)<3):
                break
            hist[i]=hist[i]+dat[1:]
            i=i+1
    hist=hist/nframes
    hist=hist/6.022E-7

    NZ=len(hist)

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
                    
                            

#UPDATE PROFILES
if(int(sys.argv[1])):
    #SCF
    NZ=48
    # BOND
    if(len(sys.argv)==1):
        comp_hist('fort.16','bond_press.dat',NZ)
        comp_hist('fort.17','angle_press.dat',NZ)
    else:
        comp_hist('fort_center.16','bond_press.dat',NZ)
        comp_hist('fort_center.17','angle_press.dat',NZ)
        comp_hist('fort_center.14','scf_press.dat',NZ,0)
        
    #     Average_hist('fort.14','scf_press.dat')
    # C=np.loadtxt('scf_press.dat')[:,1:]

    # NZ=len(C)-1
    # print(NZ)


    #comp_hist('fort.16','bond_pressx3.dat',3*NZ)

    # # ANGLE

    # #    comp_hist('fort.17','angle_pressx3.dat',NZ*3)
    
    # # dih
    # comp_hist('fort.18','dih_press.dat',NZ)
     
 
#COMPUTE AVERAGE PRESSURES
C=np.loadtxt('scf_press.dat')[:,1:]
NZ=len(C)
A=np.loadtxt('bond_press.dat')[:,1:]
B=np.loadtxt('angle_press.dat')[:,1:]
#D=np.loadtxt('dih_press.dat')[:,1:]



# #TOTAL PRESSURE
# if(np.isnan(D[0,0])):
#     print('No dihedrals present')
#     D=A*0
print(A.shape)
print(B.shape)
print(C.shape)
P_tot= np.sum(A[:,:3]+B[:,:3]+C[:,1:4],axis=1)/3.+C[:,0]+C[:,4]
PXX  = A[:,0]+B[:,0]+C[:,1]+C[:,0]+C[:,4]#+D[:,0]
PYY  = A[:,1]+B[:,1]+C[:,2]+C[:,0]+C[:,4]#+D[:,1]
PZZ  = A[:,2]+B[:,2]+C[:,3]+C[:,0]+C[:,4]#+D[:,2]
print("Pressure tot: %e"%(np.mean(P_tot[:-1])))
print("Pressure XX:  %e"%(np.mean(PXX[:-1])))
print("Pressure YY:  %e"%(np.mean(PYY[:-1])))
print("Pressure ZZ:  %e"%(np.mean(PZZ[:-1])))
 
# #KINETIC ENERGY
print("KIN:          %e"%(np.mean(C[:-1,4])))

# #SCF 
print("HPF TOT:      %e"%(np.mean(C[:-1,0]+np.sum(C[:-1,1:4],axis=1)/3.)))
print("HPF0:         %e"%(np.mean(C[:-1,0])))
print("HPF1 xx:      %e"%(np.mean(C[:-1,1])))
print("HPF1 yy:      %e"%(np.mean(C[:-1,2])))
print("HPF1 zz:      %e"%(np.mean(C[:-1,3])))


# #BOND
print("BOND TOT:     %e"%(np.mean(np.sum(A[:-1,],axis=1)/3.)))
print("BOND xx:      %e"%(np.mean(A[:-1,0])))
print("BOND yy:      %e"%(np.mean(A[:-1,1])))
print("BOND zz:      %e"%(np.mean(A[:-1,2])))

# #ANGLE
print("ANGLE TOT:    %e"%(np.mean(np.sum(B[:-1,],axis=1)/3.)))
print("ANGLE xx:     %e"%(np.mean(B[:-1,0])))
print("ANGLE yy:     %e"%(np.mean(B[:-1,1])))
print("ANGLE zz:     %e"%(np.mean(B[:-1,2])))

# #DIHEDRAL
# print("DIHEDRAL TOT:    %e"%(np.mean(np.sum(D[:-1,],axis=1)/3.)))
# print("DIHEDRAL xx:     %e"%(np.mean(D[:-1,0])))
# print("DIHEDRAL yy:     %e"%(np.mean(D[:-1,1])))
# print("DIHEDRAL zz:     %e"%(np.mean(D[:-1,2])))


# #SAVE COMBINED PROFILES
C=np.loadtxt('scf_press.dat')
fp = open('PRESS_TOT.dat','w')
for i in range(len(C[:,0])):
    fp.write("%E"%(C[i,0]))
    fp.write("\t%E"%(P_tot[i]))
    fp.write("\t%E"%(PXX[i]))
    fp.write("\t%E"%(PYY[i]))
    fp.write("\t%E"%(PZZ[i]))
    fp.write("\n")
# fp.write("%E"%(1))
# fp.write("\t%E"%(P_tot[0]))
# fp.write("\t%E"%(PXX[0]))
# fp.write("\t%E"%(PYY[0]))
# fp.write("\t%E"%(PZZ[0]))
fp.write("\n")

