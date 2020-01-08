import sys
import numpy as np
from scipy.optimize import curve_fit

def func(x, *params):
    y = np.zeros_like(x)
    for i in range(0, len(params), 3):
        ctr = params[i]
        amp = params[i+1]
        wid = params[i+2]
        y = y + amp * np.exp( -((x - ctr)/wid)**2)
    return y

def properties(x,hist,guess):
    #COMPUTES PROPERTIES FROM SINGLE PROFILE
    
    P=hist[:,1]
    
    popt, pcov = curve_fit(func, x, P, p0=guess)
    return popt
    

def Average_hist(fn,fn_out,n1=0,n2=100000): 
    #COMPUTE AVERAGE HISTOGRAM FROM HISTOGRAM OF FRAMES
    
    try:
        fp=open(fn)
    except:
        return

    fp2=open('dens_water.dat','w')
    fp3=open('prop.dat','w')
    LZ=np.loadtxt('Zs.dat')

    n=len(fp.readline().split())-1
#    print(n)
    hist=np.zeros((1000,n))
    hist2=np.zeros((1000,n))
    nframes=0
    i=0
    j=0
    guess = [1.74261759e-01,  6.24293876e+02,  1.96827610e-02,  2.67105224e-01,
  4.62409155e+02, -1.94083808e-02]
    K=0
    while(1):
        try:
            line=fp.readline()
        except:
            break
        #print(line)
        if(len(line)==2):
#            hist=hist[:i]
            j=np.max([i,j]) 
            i=0
            nframes+=1
            hist=hist[:j]
            hist2=hist2[:j]
            #print(hist2)
            if(nframes>=n2):
                break
            #print(j)
            hist2=hist2[:j]

            
            x1=np.linspace(0.5*1./len(hist2),1-0.5*1./len(hist2),len(hist2))

            guess=properties(x1,hist2,guess)
            mid=(guess[0]+guess[3])*0.5*LZ[K]/10.
            print("mid",mid)

            x=np.linspace(0,1,len(hist2)+1)*LZ[K]/10.
            x2=0.5*(x[1:]+x[:-1])
            K=K+1
            
            vol=4*np.pi/3.*(x[1:]**3-x[0:-1]**3)
            P_LOW_SUM  = sum(hist2[x2<mid,1]*vol[x2<mid])
           # print(P_LOW_SUM)
            P_HIGH_SUM  = sum(hist2[x2>mid,1]*vol[x2>mid])
            P_LOW_POS  = np.average(x2[x2<mid],weights=hist2[x2<mid,1])
            P_HIGH_POS  = np.average(x2[x2>mid],weights=hist2[x2>mid,1])
            W_INSIDE=sum(hist2[x2<mid,5]*vol[x2<mid])

            fp3.write('%d\t%f\t%f\t%f\t%f\t%f\t%f\t%f\n'%(K,P_LOW_POS,P_HIGH_POS,0.5*(P_LOW_POS+P_HIGH_POS),P_HIGH_POS-P_LOW_POS,P_LOW_SUM,P_HIGH_SUM,W_INSIDE))
            # print(P_LOW_SUM,P_HIGH_SUM)
            # print(P_LOW_POS,P_HIGH_POS,P_HIGH_POS-P_LOW_POS)
            # print("water inside:",sum(hist2[x2<mid,5]*vol[x2<mid]))
            hist2*=0
            #,weights=x[x<mid])
           # P_LOW_POS  = np.sum((hist2[:,1]*x)[x<mid])/P_LOW_SUM
          #  P_HIGH_SUM = sum(hist2[x2>mid,1]*vol)
           # P_HIGH_POS = np.sum((hist2[:,1]*x)[x>mid])/P_HIGH_SUM
           # print(P_LOW_SUM,P_HIGH_SUM)
 
    #         water=hist2[:,5]
#             a=np.linspace(0,1,len(water)+1)
#             vol=a[:-1]**3-a[1:]**3
            
            
#             vol1=vol[:int(len(water)*0.09)]
#             water1=water[:int(len(water)*0.09)]
#             vol2=vol[int(len(water)*0.35):int(len(water)*0.5)]
#             water2=water[int(len(water)*0.35):int(len(water)*0.5)]
#             fp2.write('%d\t%f\t%f\n'%(nframes,np.sum(vol1*water1)/sum(vol1),np.sum(vol2*water2)/sum(vol2)))
#             print(np.sum(vol1*water1)/sum(vol1),np.sum(vol2*water2)/sum(vol2))
# #            print(np.mean(water1,np.mean(water[int(len(water)*0.4):int(len(water)*0.5)])))#,hist2)
#             hist2=np.zeros((j,n))    
            
        else:
            dat=np.array([float(li) for li in line.split()])
            
        
            if(len(dat)<2):
                break
            #print(nframes>=n1)
            if(nframes>=n1 and nframes<=n2):
             #   print(dat)
                hist[i]+=dat[1:]
                hist2[i]+=+dat[1:]
            i=i+1
            
    hist=hist[:j]

    hist=hist/nframes
    hist=hist

    NZ=len(hist)

    fp_out=open(fn_out,'w')
    for i in range(NZ):
        fp_out.write('%E'%(i*1./NZ))
        for j in range(len(hist[0])):
            fp_out.write('\t%E'%(hist[i,j]))
        fp_out.write('\n')
    
    # fp_out.write('%E'%(1.))
    # for j in range(len(hist[0])):
    #     fp_out.write('\t%E'%(hist[0,j]))
    fp_out.close()

    hist=hist[:j]
  

Average_hist(sys.argv[1],sys.argv[2])
