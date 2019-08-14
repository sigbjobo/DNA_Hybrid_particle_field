import numpy as np
import sys

def comp_hist(fn,fn_out,NZ):
    #COMPUTE HISTOGRAM FROM VIRIAL AT PARTICLE POSITIONS
    hist=np.zeros((NZ,3))
    
    try:
        fp=open(fn)
    except:
        return


    nframes=0
    while(1):
        try:
            line=fp.readline()
        except:
            break
        if(line == ' \n'):
            
            nframes+=1
           
        else:
            dat=np.array([float(li) for li in line.split()])
            if(len(dat)<3):
                break
            #INDEX OF LEFT VERTEX
            IZ=int(dat[0]*NZ)
            
            #WEIGTH ON RIGHT VERTEX
            a = dat[0]*NZ - int(dat[0]*NZ)

            #PROJECTION OF PRESSURE ONTO GRID
            hist[IZ,:]   += (1.-a) * dat[1:]
            hist[IZ+1,:] +=  a * dat[1:]



    #NORMALIZATION TO NUMBER OF FRAMES
    hist=hist/nframes

    #CORRECTING FOR PERIODIC BC
    hist[0]=hist[0]+hist[-1]
    hist[-1]=hist[0]
   
    #NORMALIZE BY NZ, OCCAM WRITES OUT VIR/VOL
    #AND SETTING TO PASCAL
    hist=hist*(NZ-1)/6.022E-7
 
    #WRITING OUT HISTOGRAM
    fp_out=open(fn_out,'w')
    for i in range(NZ):
        fp_out.write('%f'%(i*1./NZ))
        for j in range(len(hist[0])):
            fp_out.write('\t %f'%(hist[i,j]))
        fp_out.write('\n')
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
        if(line == ' \n'):
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
    for i in range(len(hist)):
        fp_out.write('%f'%(i*1./NZ))
        for j in range(len(hist[0])):
            fp_out.write('\t %f'%(hist[i,j]))
        fp_out.write('\n')
    fp_out.close()
   

#UPDATE PROFILES
if(int(sys.argv[1])):

    
    #SCF
    Average_hist('fort.14','scf_press.dat')
    C=np.loadtxt('scf_press.dat')[:,1:]

    NZ=len(C)+1
    # BOND
    comp_hist('fort.16','bond_press.dat',NZ)

    # ANGLE
    comp_hist('fort.17','angle_press.dat',NZ)
    
    # dih
    comp_hist('fort.18','dih_press.dat',NZ)
     

#COMPUTE AVERAGE PRESSURES
C=np.loadtxt('scf_press.dat')[:,1:]
NZ=len(C)+1
A=np.loadtxt('bond_press.dat')[:-1,1:]
B=np.loadtxt('angle_press.dat')[:-1,1:]
D=np.loadtxt('dih_press.dat')[:-1,1:]



#TOTAL PRESSURE
if(np.isnan(D[0,0])):
    print('No dihedrals present')
    D=A*0

P_tot= np.sum(A+B+D+C[:,1:4],axis=1)/3.+C[:,0]+C[:,4]
PXX  = A[:,0]+B[:,0]+C[:,1]+C[:,0]+C[:,4]+D[:,0]
PYY  = A[:,1]+B[:,1]+C[:,2]+C[:,0]+C[:,4]+D[:,1]
PZZ  = A[:,2]+B[:,2]+C[:,3]+C[:,0]+C[:,4]+D[:,2]
print("Pressure tot: %e"%(np.mean(P_tot)))
print("Pressure XX:  %e"%(np.mean(PXX)))
print("Pressure YY:  %e"%(np.mean(PYY)))
print("Pressure ZZ:  %e"%(np.mean(PZZ)))
 
#KINETIC ENERGY
print("KIN:          %e"%(np.mean(C[:,4])))

#SCF 
print("HPF TOT:      %e"%(np.mean(C[:,0]+np.sum(C[:,1:4],axis=1)/3.)))
print("HPF0:         %e"%(np.mean(C[:,0])))
print("HPF1 xx:      %e"%(np.mean(C[:,1])))
print("HPF1 yy:      %e"%(np.mean(C[:,2])))
print("HPF1 zz:      %e"%(np.mean(C[:,3])))


#BOND
print("BOND TOT:     %e"%(np.mean(np.sum(A[:,],axis=1)/3.)))
print("BOND xx:      %e"%(np.mean(A[:,0])))
print("BOND yy:      %e"%(np.mean(A[:,1])))
print("BOND zz:      %e"%(np.mean(A[:,2])))

#ANGLE
print("ANGLE TOT:    %e"%(np.mean(np.sum(B[:,],axis=1)/3.)))
print("ANGLE xx:     %e"%(np.mean(B[:,0])))
print("ANGLE yy:     %e"%(np.mean(B[:,1])))
print("ANGLE zz:     %e"%(np.mean(B[:,2])))

#DIHEDRAL
print("DIHEDRAL TOT:    %e"%(np.mean(np.sum(D[:,],axis=1)/3.)))
print("DIHEDRAL xx:     %e"%(np.mean(D[:,0])))
print("DIHEDRAL yy:     %e"%(np.mean(D[:,1])))
print("DIHEDRAL zz:     %e"%(np.mean(D[:,2])))


#SAVE COMBINED PROFILES
fp = open('PRESS_TOT.dat','w')
for i in range(len(B[:,0])):
    fp.write("%f"%(i*1./NZ))
    fp.write("\t%f"%(P_tot[i]))
    fp.write("\t%f"%(PXX[i]))
    fp.write("\t%f"%(PYY[i]))
    fp.write("\t%f"%(PZZ[i]))
    fp.write("\n")

