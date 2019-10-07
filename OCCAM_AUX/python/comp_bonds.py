import sys
import numpy as np
def ana_pos(r,L):   
    #r1=r[:len(r)//2]
    #r2=r[len(r)//2:]
    #min_dist=np.zeros(len(r1))
    #for i in range(len(r1)):
       # r2_=period1(r1[i],r2[i],L)
        #d = np.abs(r1[i]-r2_)
        #d = d-L*(d//(0.5*L)) 
        #min_dist[i]=np.min(np.linalg.norm(d,axis=1))
    return min_dist
def period1(r1, r2, L):
#    print (r2-r1)
    return r2-L*np.sign((r2-r1))*(np.abs((r2-r1))//(0.5*L))
def ana_pos_ang(r,rs,L):
    r1 = r[:len(r)//2]
    r2 = r[len(r)//2:][::-1]
    rs1=rs[:len(r)//2]
    rs2=rs[len(r)//2:][::-1]
#    print np.linalg.norm(r1-r2,axis=1)
    rs1=period1(r1,rs1,L)
    rs2=period1(rs1,rs2,L)
    r2=period1(rs2,r2,L)
    
    d  = np.linalg.norm(r1-r2, axis=1)# - 0.5*L*(d // (0.5*L[:,np.newaxis]))

    # rs1=rs[:len(r)//2]
    # rs2=rs[len(r)//2:]
    dsr1 = r1-rs1
    dsr2 = r2-rs2
    
    dsr1    = dsr1/np.linalg.norm(dsr1,axis=1)[:,np.newaxis]
    dsr2    = dsr2/np.linalg.norm(dsr2,axis=1)[:,np.newaxis]
    min_ang = np.arccos(np.sum(dsr1*dsr2,axis=1))
    return d, min_ang#print len(min_ang, d
  #  print min_ang
    #   print d
    #  print 0.5*L*(d//(0.5*L[:,np.newaxis]))
  
 #   d  = d - 0.5*L*(d//(0.5*L))  
#    )
   
    

    
    # rs1=rs[:len(rs)//2]
    # rs2=rs[len(rs)//2:]

    # dsr1=dsr1-0.5*L*(dsr1//(0.5*L))
    # dsr2=dsr2-0.5*L*(dsr2//(0.5*L))
    
    
    # min_dist=np.zeros(len(r1))
  #   min_ang=np.zeros(len(r1))
  #  for i in range(len(r1)):
        # d = np.abs(r1[i]-r2[-i])
        # d = np.linalg.norm(d - 0.5*L*(d//(0.5*L)),axis=1)

        # # min_d       = np.min(d)
        # # i2          = np.where(d==min_d)
        # min_ang[i]  = np.arccos(np.dot(dsr1[i],dsr2[-i].T))
       # min_dist[i] = min_d

    # for i in range(len(r1)):
    #     d = np.abs(r1[i]-r2)
    #     d = np.linalg.norm(d - 0.5*L*(d//(0.5*L)),axis=1)

    #     min_d=np.min(d)
    #     i2=np.where(d==min_d)
    #     min_ang[i]=np.arccos(np.dot(dsr1[i],dsr2[i2].T))
    #     min_dist[i]=min_d
#    return d, min_ang
    

def ana_corr(r,L):
    
    corr=np.zeros(len(r)//10)
    dr = r[1:]-r[:-1]
    dr = dr - 0.5*L*(dr//(0.5*L))
    dr = dr/np.linalg.norm(dr,axis=1)[:,np.newaxis]
    corr=[]
    for i in range(len(dr)//10):
        corr.append(np.mean(np.dot(dr[(i+1)*10:],dr[:-(i+1)*10].T)))
    return np.array(corr)


            
fp     = open(sys.argv[1],'r')
fp_out = open('bonds.dat','w')
fp_corr = open('corr.dat','w')

frame=1
line=''
while(1):
    try:
        line = fp.readline()
        nAtoms=int(line)
        line=fp.readline()
        L=np.array([float(d) for d in line.split()[1:]])

    except:
        break
 #   print line
    r=[]
    r_s=[]
    r_p=[]
    for i in range(nAtoms):
        l = fp.readline().split()
        if(l[0]=='A' or l[0]=='T' or l[0]=='G' or l[0]=='C'): 
            r.append([float(d) for d in l[1:]])
        elif(l[0]=='S'):
            r_s.append([float(d) for d in l[1:]])
        elif(l[0]=='P'):
            r_p.append([float(d) for d in l[1:]])

    [d_min, ang_min] = ana_pos_ang(np.array(r),np.array(r_s),L)
    
    #fp_out.write("%d\n"%(frame))
    for i in range(len(d_min)):
        fp_out.write("%.3f %.3f\n"%(0.1*d_min[i],ang_min[i]*180/np.pi))
    frame = frame + 1     

    corr = ana_corr(np.array(r_p[:len(r_p)//2]),L)
    fp_corr.write('%s\n'%(' '.join(['%.3f'%(c) for c in corr])))
    
