import sys
#Setting paths                                                                                                            
SHELL_PATH="/cluster/home/sigbjobo/DNA/HPF/OCCAM_AUX/shell"
PYTHON_PATH="/cluster/home/sigbjobo/DNA/HPF/OCCAM_AUX/python"
EXTRA_PATH="/home/sigbjobo/Stallo/Projects/HPF/PLOT/python"
sys.path.append(SHELL_PATH)
sys.path.append(PYTHON_PATH)
sys.path.append(EXTRA_PATH)
import numpy as np
import ana_prot as ANA


#START STATISTICS AFTER
if(len(sys.argv)>2):
    start=int(sys.argv[2])
else:
    start=0

#CHECK IF DOUBLE STRANDED
if(len(sys.argv)>3):
    isdouble=int(sys.argv[3])
else:
    isdouble=0


#INPUT FILE
fp = open(sys.argv[1],'r')

frame=1
not_empty=1
fp2=open('end_end.dat','w')
fp3=open('contact.dat','w')
fp4=open('RG.dat','w')
fp5=open('CORR.dat','w')

correlation=[]


[fp, rp, rs, rn, L, not_empty] = ANA.read_frame(fp)
while(not_empty):
   # rp = ANA.array_period(rp, L)
    
    if(isdouble):
        
        rp1 = ANA.array_period(rp[:len(rp)//2], L)
        rp2 = ANA.array_period(rp[len(rp)//2:], L)
        rp1=rp1[::-1]
        rp=ANA.array_period(rp,L)#np.vstack((rp1,rp2)),L)
        
        
        fp2.write("%5d %4.1f\n" %(frame,0.5*(ANA.bond(rp1[0],rp1[-1])+ANA.bond(rp2[0],rp2[-1]))))
        fp4.write("%5d %4.1f\n" %(frame,ANA.RG(rp)))
        corr=0.5*(ANA.CORR(rp1)+ANA.CORR(rp2))
        fp5.write("%5d %s\n"%(frame,' '.join(['%.4f'%(dr) for dr in  corr])))

    else:
        rp = ANA.array_period(rp, L)
        fp2.write("%5d %4.1f\n" %(frame,ANA.bond(rp[0],rp[-1])))
        fp4.write("%5d %4.1f\n" %(frame,ANA.RG(rp)))
        fp5.write("%5d %s\n"%(frame,' '.join(['%.4f'%(dr) for dr in  ANA.CORR(rp)])))
    try:
        if(isdouble):
            rn = ANA.array_period(rn, L)
           
            rn1=rn[:len(rn)//2]
            rn1=rn1[::-1]
            rn2=rn[len(rn)//2:]

        else:
            rn = ANA.array_period(rn, L)
            #COMPUTE LENGTH BETWEEN NUCLEOBASES, 
            rn1=rn[:len(rn)//2]
            rn1=rn1[::-1]
            if(np.mod(len(rn),2)==0):
                rn2=rn[len(rn)//2:]
            else:
                rn2=rn[1+len(rn)//2:]
        #COMPUTE LENGTH BETWEEN NUCLEOBASES, 
        dist = np.linalg.norm(rn1-rn2,axis=1)
        for i in range(len(dist)):
            di=dist[i]
            fp3.write('%d %f %s\n' %(frame,i,di))
    
        fp3.write('\n')
    except:
        pass



    frame += 1
    [fp, rp, rs, rn, L, not_empty] = ANA.read_frame(fp)
fp.close()
fp2.close()
fp3.close()
fp4.close()  
fp5.close()    


#EXTRA POST PROCCESSING
CORR=np.loadtxt('CORR.dat')[start:,1:]
CORR_MEAN=np.mean(CORR,axis=0)
CORR_STD=np.std(CORR,axis=0)
fp=open('CORR_MEAN.dat','w')
for i in range(len(CORR_MEAN)):
    fp.write('%d %f %f\n'%(i,CORR_MEAN[i],CORR_STD[i]))
fp.close()
