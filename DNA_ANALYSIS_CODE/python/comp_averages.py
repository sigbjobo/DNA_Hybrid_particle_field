import glob
import numpy as np

from scipy.stats import circmean, circvar
fns=sorted(glob.glob("./*.txt"))
print(fns)


fp1=open('bonds.dat','w')
fp2=open('bend.dat','w')
fp3=open('tor.dat','w')
for f in fns:
    types=f.split('/')[1].split('.')[0]
    d=np.loadtxt(f)
    if(len(types.split('-'))==4):
        fp3.write("%s %f %f\n"%(types, circmean(d,low=-180.,high=180.),np.sqrt(circvar(d,low=-180.,high=180.))))
    elif(len(types.split('-'))==3):
        fp2.write("%s %f %f\n"%(types, np.mean(d),np.std(d)))
    else:
        fp1.write("%s %f %f\n"%(types, np.mean(d)*0.1,np.std(d)*0.1))
    
   
    
