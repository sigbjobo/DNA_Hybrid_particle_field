import sys
import numpy as np
def Average_hist(fn,fn_out,n1=0,n2=100000): 
    #COMPUTE AVERAGE HISTOGRAM FROM HISTOGRAM OF FRAMES
    
    try:
        fp=open(fn)
    except:
        return

    fp2=open('dens_water.dat','w')
    n=len(fp.readline().split())-1
    print(n)
    hist=np.zeros((1000,n))
    hist2=np.zeros((1000,n))
    nframes=0
    i=0
    j=0
    
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
            water=hist2[:,5]
            a=np.linspace(0,1,len(water)+1)
            vol=a[:-1]**3-a[1:]**3
            
            
            vol1=vol[:int(len(water)*0.09)]
            water1=water[:int(len(water)*0.09)]
            vol2=vol[int(len(water)*0.35):int(len(water)*0.5)]
            water2=water[int(len(water)*0.35):int(len(water)*0.5)]
            fp2.write('%d\t%f\t%f\n'%(nframes,np.sum(vol1*water1)/sum(vol1),np.sum(vol2*water2)/sum(vol2)))
            print(np.sum(vol1*water1)/sum(vol1),np.sum(vol2*water2)/sum(vol2))
#            print(np.mean(water1,np.mean(water[int(len(water)*0.4):int(len(water)*0.5)])))#,hist2)
            hist2=np.zeros((j,n))    
            
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
