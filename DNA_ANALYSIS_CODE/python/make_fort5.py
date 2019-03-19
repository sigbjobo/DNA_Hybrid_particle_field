import sys
import numpy as np
from numpy import cross, eye, dot
from scipy.linalg import expm, norm
"""
CODE FOR MAKING FORT.5 FILE FOR DNA
FOLLOWS: J. Chem. Phys. 139, 144903 (2013)
"""
def M(axis, theta):
    return expm(cross(eye(3), axis/norm(axis)*theta))
def straight(pos):

    #Direction of straight protein                                                                                                                                       

    #x-direction
    pro_dir = np.array([0,0,1])
    
    
    #x=np.array([1,0,0])
    axis=np.array([1,0,0])#np.cross(z,pro_dir)
    theta=np.pi #np.arccos(np.dot(x,pro_dir))

    #into the middle                                                                                                                                                         
    M0=M(axis,-theta)
    #mean_p=np.mean(pos,axis=0)
    #pos=pos-mean_p
    for i in range(len(pos)):
        pos[i]=np.dot(M0,pos[i])

    return pos#+mean_p

#NEW GEOMETRY
NEW=True

#SEQUENCE ATGC
l=sys.argv[1]

#REVERSE ORDER TO MAKE 3-5
l=l[::-1]



#NUMBER OF NUCLEOTIDES
N_nuc=len(l)

#THE DIFFERENT NUCLEOTIDES
names=['A','T','G','C']


#SIZE OF BOX IN NM
L=float(sys.argv[2])

#OPTION FOR COMPLEMENTARY STRAND
comp=bool(int(sys.argv[3]))
sign=1.
if(comp):
    sign=-1.
    
if(NEW):
    #OPTION FOR HINCKLEY

    #RADI
    #BACKBONE
    rP=0.8918 
    rS=0.6981 

    #NUCLEOTIDES,
    rA=0.2506
    rT=0.3418 
    rG=0.2297
    rC=0.3336

    rN=[rA,rT,rG,rC] 

    #ANGLE
    thetaP=94.035*np.pi/180. 
    thetaS=70.196*np.pi/180.

    thetaA=83.207*np.pi/180. 
    thetaT=93.327*np.pi/180. 
    thetaG=76.349*np.pi/180. 
    thetaC=78.192*np.pi/180. 
    thetaN=[thetaA,thetaT,thetaG,thetaC]

    #
    zP=0.2186 
    zS=0.1280 
    
    zA=0.0204
    zT=0.0272 
    zG=0.0186 
    zC=0.0264 
    zN=[zA,zT,zG,zC]

else:
    #BACKBONE
    rP=0.8918 
    rS=0.6981 

    #NUCLEOTIDES, THIS LOOKS WRONG
    rA=0.0773 
    rT=0.2349 
    rC=0.2296 
    rG=0.0828 
    rN=[rA,rT,rG,rC] 


    thetaP=94.038*np.pi/180. 
    thetaS=70.197*np.pi/180.

    thetaA=41.905*np.pi/180. 
    thetaT=86.119*np.pi/180. 
    thetaC=85.027*np.pi/180. 
    thetaG=40.691*np.pi/180. 
    thetaN=[thetaA,thetaT,thetaG,thetaC]

    zP=0.2186 
    zS=0.1280 
    
    zA=0.0051 
    zT=0.0191 
    zC=0.0187 
    zG=0.0053 
    zN=[zA,zT,zG,zC]


theta0=0


lines=[]
lines.append('box:\n')

lines.append('%f %f %f\n'%(L,L,L))
lines.append('0.00\n')
lines.append('Number of molecules:\n')
lines.append('1\n')
lines.append('mol nr. 1\n')
lines.append('%d \n'%(N_nuc*3-1))


theta0=0.
z0=0
#theta0=theta+np.pi*36./180.

#if(comp):
#    z0=N_nuc*0.338
#if(comp):
z0=-1*0.5*(N_nuc-1)*0.338
#z1=-1*sign*0.5*(N_nuc-1)*0.338
#rP=np.array([1,1,1])

rs=[]
rn=[]
rp=[]
for i in range(N_nuc):
    
    theta0=theta0+np.pi*36./180.
    
    
    #SUGAR
    rs.append([rS*np.cos(theta0+thetaS),rS*np.sin(theta0+thetaS),z0+zS])
    
    ncl=l[i] 
    idx=names.index(ncl)+3
    id_nuc=names.index(ncl)

    #NUCLEOTIDE
    rn.append([rN[id_nuc]*np.cos(theta0+thetaN[id_nuc]),rN[id_nuc]*np.sin(theta0+thetaN[id_nuc]),z0+zN[id_nuc]])
    
    #PHOSPHOR
    rp.append([rP*np.cos(theta0+thetaP),rP*np.sin(theta0+thetaP),z0+zP])
    
    z0=z0+0.338



#MAKE SUGAR START AT 0
# mid = np.mean(np.array(rs[:][2],dtype=float))

# rp[:][2]=[r -mid for r in rp[:][2]]
# rs[:][2]=[r -mid for r in rs[:][2]]
# rn[:][2]=[r -mid for r in rn[:][2]]

#lines.append("1 P 1 1 %.3f %.3f %.3f 0.000 0.000 0.000 2 0 0 0 0 0\n"%(0.5*L+rP*np.cos(theta0+thetaP),0.5*L+sign*rP*np.sin(theta0+thetaP),z0+sign*zP))


#Removing lat phosphor 
rp=rp[:-1]

#REVERSE ORDER
rp = rp[::-1]
rs = rs[::-1]
rn = rn[::-1]
l  =  l[::-1]



#MAKE INTO NUMPY
rp = np.array(rp)
rs = np.array(rs)
rn = np.array(rn)

if(comp):
    rp2 = straight(np.copy(rp))
    rs2 = straight(np.copy(rs))
    rn2 = straight(np.copy(rn))

    dz = rs2[0,2]-rs[-1,2]
    
    
    rs[:,:-1]=rs2[:,:-1]
    rn[:,:-1]=rn2[:,:-1]
    rp[:,:-1]=rp2[:,:-1]
    rs[:,2]=rs2[:,2]+dz
    rn[:,2]=rn2[:,2]+dz
    rp[:,2]=rp2[:,2]+dz
    
rp=rp+0.5*L#A[np.newaxis(),:]
rn=rn+0.5*L#+A[np.newaxis(),:]
rs=rs+0.5*L#+A[np.newaxis(),:]


for i in range(N_nuc):
    if(i==0):
        lines.append("%d S 2 2 %.4f %.4f %.4f %.4f %.4f %.4f %d %d %d 0 0 0\n"%(i*3+1,rs[i][0],rs[i][1],rs[i][2],0,0,0,3*i+2,3*i+3,0))
    elif(i==N_nuc-1):
        lines.append("%d S 2 2 %.4f %.4f %.4f %.4f %.4f %.4f %d %d %d 0 0 0\n"%(i*3+1,rs[i][0],rs[i][1],rs[i][2],0,0,0,3*i+0,3*i+2,0))
    else:    
        lines.append("%d S 2 3 %.4f %.4f %.4f %.4f %.4f %.4f %d %d %d 0 0 0\n"%(i*3+1,rs[i][0],rs[i][1],rs[i][2],0,0,0,3*i+0,3*i+2,3*i+3))
    
    ncl=l[i] 
    idx=names.index(ncl)+3
    id_nuc=names.index(ncl)

    lines.append("%d %s %d 1 %.4f %.4f %.4f %.4f %.4f %.4f %d %d %d 0 0 0\n"%(i*3+2,ncl,idx,rn[i][0],rn[i][1],rn[i][2],0,0,0,3*i+1,0,0))

    # FOR LAST NUCLEOTIDE
    if(i<N_nuc-1):
        lines.append("%d P 1 2 %.4f %.4f %.4f %.4f %.4f %.4f %d %d %d 0 0 0\n"%(3*i+3,rp[i][0],rp[i][1],rp[i][2],0,0,0,i*3+1, i*3+4,0))

fp=open('fort.5','w')
for l in lines:
    fp.write(l)

fp.close()
