import sys

if(len(sys.argv)>1):
    fp=open(sys.argv[1],'r')
else:
    fp=open('fort.8','r')
fp_out=open('fort_center.8','w')



zcms=[]
LZS=[]
while(1):
    ls=fp.readline().split()
    if(len(ls)<1):
        break

    NTOT=int(ls[0])
    ls=fp.readline().split()
    LZ=float(ls[-1])*10

    zcm=0.0
    nc =0
    for i in range(NTOT):
        ls=fp.readline().split()
        if(ls[0]=='C' or ls[0]=='D' or ls[0]=='T'):
           zcm+=float(ls[-1])
           nc+=1
    zcm=zcm/nc
 #   print(zcm)
    zcms.append(zcm)
    LZS.append(LZ)
fp.close()
if(len(sys.argv)>1):
    fp=open(sys.argv[1],'r')
else:
    fp=open('fort.8','r')
if(len(sys.argv)>2):
    fp_out2=open('ZCMs.dat', 'w')


frame=0
while(1):
    ls=fp.readline().split()
    if(len(ls)<1):
        break
    NTOT=int(ls[0])    
    fp_out.write('%s\n'%(' '.join(ls)))
    ls=fp.readline().split()
    #LZ=float(ls[-1])*10

    fp_out.write('%s\n'%(' '.join(ls)))
    
    for i in range(NTOT):
        ls=fp.readline().split()
        z=float(ls[-1])
        z=z-zcms[frame]+0.5*LZS[frame]
        if(z>=LZS[frame]):
            z=z-LZS[frame]
        if(z<0):
            z=z+LZS[frame]
        ls[-1]="%f"%(z)
        fp_out.write('%s\n'%(' '.join(ls)))
    if(len(sys.argv)>2):
        fp_out2.write('%f\t%f\n'%(zcms[frame],LZS[frame]))
    
    frame=frame+1
    #print(frame)
#print(zcms,LZS)