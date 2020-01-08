import numpy as np
def center_press(fn):
    newname=fn.split('.')
    newname="%s_center.%s"%(newname[0],newname[1])
    fp=open(fn,'r')
    fp_out=open(newname,'w')
    nframe=0
    zcms  = np.loadtxt('ZCMs.dat')[:,0]
    LZs = np.loadtxt('ZCMs.dat')[:,1]
    zcms_=zcms/LZs
    
    while(1):        
        try:
            line=fp.readline()
        except:
            break
        if(line==' \n'):
            i=0 
            
            nframe+=1
            fp_out.write('\n')
        else:
            dat=line.split()
            if(len(dat)<3):
                break
            
            z=np.abs(float(dat[0]))
            
            z=z-zcms_[nframe]+0.5
            if(z>1):
                z=z-1
            if(z<0):
                z=z+1
            fp_out.write("%f\t%s\n"%(z,"\t".join(dat[1:])))

def center_scf(fn):
    newname=fn.split('.')
    newname="%s_center.%s"%(newname[0],newname[1])
    fp=open(fn,'r')
    fp_out=open(newname,'w')
    NN=0
    #COUNT NZ
    NZ=0
    while(1):
        try:
            line=fp.readline()
            ls=line.split()
        except:
            break
        if(len(ls)>3):
            NZ+=1
        else:
            break
    fp.close()

    #CENTER ALL PROFILES
    fp=open(fn,'r')
    nframe=0
    zcms  = np.loadtxt('ZCMs.dat')[:,0]
    LZs = np.loadtxt('ZCMs.dat')[:,1]
    zcms_=zcms/LZs
    while(1):        

        line=fp.readline()
        
        if(line==''):
                break
        if(line==' \n'):
            i=0 
            
            nframe+=1
            fp_out.write('\n')
        else:
            dat=line.split()
            z=(float(dat[0])-1)/NZ
            
            z=z-zcms_[nframe]+0.5
            if(z>1):
                z=z-1
            if(z<0):
                z=z+1
            fp_out.write("%f\t%s\n"%(z,"\t".join(dat[1:])))
        

#CENTER BONDED
center_scf('fort.14')
center_press('fort.16')                         
center_press('fort.17')
center_press('fort.18')
