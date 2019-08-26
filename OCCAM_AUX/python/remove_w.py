import sys
import numpy as np

#HUSK aNGSTROM

N = int(open(sys.argv[1]).readline())
#z = np.zeros(N)
types = np.array(np.zeros(N),dtype=bool)
lines = ["" for x in range(N+2)]

fp=open(sys.argv[1],'r')

#fp_out=open('mem_center.xyz','w')
fp_nw=open('mem_nowater.xyz','w')

while(True):
    for i in range(N+2):
        lines[i]=fp.readline()

  #  LZ = float(lines[1].split()[-1])

    NW=0
    for i in range(N):

        l=lines[i+2].split()
#        types[i]=(l[0]=='C')
        if(l[0]=='W'):
            NW=NW+1
        
 #       z[i] = np.float(l[-1])

#    z_m = np.mean(z[types])
    
    # fp_out.write("%s\n"%" ".join(lines[0].split()))
    # fp_out.write("%s\n"% " ".join(lines[1].split()))
    fp_nw.write("%d\n"%(N-NW))
    fp_nw.write("%s\n"% " ".join(lines[1].split()))
    
    for i in range(N):
        l=lines[i+2].split()
        # z[i]=z[i] + LZ*0.5 - z_m

        # if(z[i]>LZ):
        #     z[i]=z[i]-LZ
        # elif(z[i]<0.0):
        #     z[i]=z[i]+LZ
        # l[-1]="%f" % z[i]
        
 #       fp_out.write("%s \n"%(" ".join(l)))
        if(not(l[0]=='W')):
            fp_nw.write("%s \n"%(" ".join(l)))
    

