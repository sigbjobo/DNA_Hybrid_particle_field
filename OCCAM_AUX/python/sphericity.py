import numpy as np
import sys
from scipy.spatial import ConvexHull
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from sklearn.cluster import KMeans
from numpy import cross, eye, dot
from scipy.linalg import expm, norm


 
print("filename: %s"%( sys.argv[1]))

fp     = open(sys.argv[1],'r')
fp_out = open("sphericity.dat",'w')

nz=61
start=2

names=['N','P','G','C','D','W','T']
N=np.zeros((nz,len(names)))
l=fp.readline()

r=0
nc=200
m = KMeans(n_clusters=nc)  
end=10000000
while (not (l=="")):
    l= l.split()
    numa=int(l[0])
    l=fp.readline()
    l=l.split()


    LX=float(l[1])*10
    LY=float(l[2])*10
    LZ=float(l[3])*10
    r=r+1
    if(r>end):
        break
    I=np.zeros((3,3))
    n=0
    pos=[]
    for i in range(numa):
        l=fp.readline()
      #  print(l)
        ls=l.split()
        if(not ls[0]=='W' and ls[0]=='C'):
            n=n+1
            rs=[float(ls[1])-0.5*LX,float(ls[2])-0.5*LY,float(ls[3])-0.5*LZ]
            pos.append(rs)



    pos=np.array(pos)
    rcm=np.mean(pos,axis=0)
    pos=pos-rcm


    if(r>1):
        m = KMeans(n_clusters=nc,init=m.cluster_centers_)
        m.fit(pos)
    else:
        m.fit(pos)
    pos2=np.zeros((nc,3))
    for n in range(nc):
        pos2[n,:]=np.mean(pos[m.labels_==n],axis=0)
    cv= ConvexHull(pos2)
    sphericity=np.pi**(1./3)*(6*cv.volume)**(2./3)/cv.area
    rad_kmeans=np.linalg.norm(pos2,axis=1)

#    print(sphericity,np.std(np.linalg.norm(pos2,axis=1)))
    #print(np.max(m.labels_))
    # ax = plt.axes(projection='3d')
    # ax.scatter(pos2[:,0],pos2[:,1],pos2[:,2], 'red',alpha=0.5)
    # # ax.scatter(pos2[cv.simplices,0],pos2[cv.simplices,1],pos2[cv.simplices,2], 'gray')
    # ax.set_aspect('equal')
    # plt.show()
    #print('volume',cv.volume,'area',cv.area,"sphericity",sphericity)
  #  l=fp.readline()
  #  surf(pos,5)
  #        coord_pol=cart2pol(pos)
  #        print(coord_pol)
#    w, v = np.linalg.eig(I)
    rad=np.linalg.norm(pos,axis=1)
    # phi=np.arctan2(pos[:,1],pos[:,0])
    # theta=np.arccos(pos[:,2]/rad)
    
#    [radii,A,V,pos3]=hist(phi,theta,rad,15)
 #   cv= ConvexHull(pos3)
    
    #ax = plt.axes(projection='3d')
 #   print(pos3)
    #ax.scatter(pos3[:,0],pos3[:,1],pos3[:,2], 'red',alpha=0.5)
    #smooth
    #ax.scatter(pos3[cv.simplices,0],pos3[cv.simplices,1],pos3[cv.simplices,2], 'gray')
    #ax.set_aspect('equal')
    #plt.show()
  #  sphericity2=np.pi**(1./3)*(6*cv.volume)**(2./3)/cv.area
   
   # average=np.average(radii)#,weights=A)
    #variance = np.average((radii-average)**2)#, weights=A)
    #print(average,np.sqrt(variance),sphericity2)
    #print(np.mean(rad),np.std(rad))#,sphericity)
 
    fp_out.write('%.3f\t%.3f\t%.3f\t%.3f\t%.5f\n'%(np.mean(rad),np.std(rad),np.mean(rad_kmeans),np.std(rad_kmeans),sphericity))

    #smooth
    # RG=np.sqrt(w[0]+w[1]+w[2])
    # K2=1.5*(w[0]**2+w[1]**2+w[2]**2)/(w[0]+w[1]+w[2])**2-0.5
    # Q=((w[1]-w[0])**2+(w[2]-w[0])**2+(w[2]-w[1])**2)/(2*(w[0]+w[1]+w[2]))
    # w=np.sort(w)
    
    # Q=w[2]-0.5*(w[0]+w[1])
    # pos=np.array(pos)
    # pos[:,0]=pos[:,0] -0.5*LX
    # pos[:,1]=pos[:,1] -0.5*LY
    # pos[:,2]=pos[:,2] -0.5*LZ
    # r_fluc=np.mean(np.abs(np.linalg.norm(pos,axis=1)-RG))
    # [r1,res]=sphereFit(pos[:,0],pos[:,1],pos[:,2])
   
    # fp_out.write('%d\t%.2f\t%.2f\t%.2f\t%.2f\n'%(r,RG,r_fluc,r1,res))
    # print(sphereFit(pos[:,0],pos[:,1],pos[:,2]))
    # print("RG",RG,"Q",Q,"K2",K2)
    l=fp.readline()
 
fp_out.close()    
fp.close()

A=np.loadtxt("sphericity.dat")
print('RG: ',np.mean(A[:,0]),'+/-',np.mean(A[:,1]))
print('R: ',np.mean(A[:,2]),'+/-',np.mean(A[:,3]))
print('Sphericity: ',np.mean(A[:,4]),'+/-',np.std(A[:,4]))
    
    
 

"""
def M(axis, theta):
    return expm(cross(eye(3), axis/norm(axis)*theta))

#from scipy.interpolate import Rbf
# def cart2pol(pos):
#     coord_pol=np.zeros((len(pos),3))
#     coord_pol[:,0] = np.linalg.norm(pos,axis=1)
#     coord_pol[:,1] = np.arctan(pos[:,1]/pos[:,0])
#     coord_pol[:,2] = np.arccos(pos[:,2]/coord_pol[:,0])    
#     return coord_pol


# def surf(pos,n):
#     coord_pol=cart2pol(pos)
#     phi_bin   = np.linspace(0,2*np.pi,n+1)
#     theta_bin = np.linspace(-0.5*np.pi,0.5*np.pi,n+1)
    
#     # print("phi",np.min(coord_pol[:,1]),np.max(coord_pol[:,1]))
#     # print("theta",np.min(coord_pol[:,2]),np.max(coord_pol[:,2]))

#     dphi   = 2*np.pi/n
#     dtheta = np.pi/n
#     phi_   = np.array(coord_pol[:,1]//dphi-1,dtype=int)
#     theta_ = np.array((0.5*np.pi+coord_pol[:,2])//dtheta-1,dtype=int)
#     print(theta_)
#     r=np.zeros((n,n))
#     phi=np.zeros((n,n))
#     theta=np.zeros((n,n))
#     for i in range(n):
#         for j in range(n):
#             phi[i,j]=0.5*(phi_bin[i]+phi_bin[i+1])
#             theta[i,j]=0.5*(theta_bin[j]+theta_bin[j+1])
#             index=np.array((phi_==i)*(theta_==j),dtype=bool)
#             print(np.sum(index))
#             r[i,j]=np.mean(coord_pol[index,0])

#     print(r)#     return [r,phi,theta]
    

#fit a sphere to X,Y, and Z data points
#returns the radius and center points of
#the best fit sphere
def hist(a,b,c,N):
    bi_edge=-(np.arccos(np.linspace(-1,1,N+1))-np.pi)
    ai_edge=np.linspace(-np.pi,np.pi,2*N+1)
    ci, bi, ai   = np.histogram2d(b, a,bins=[bi_edge,ai_edge],  weights=c, normed=False)
    counts, _, _ = np.histogram2d(b, a,bins=[bi_edge,ai_edge])
    #    ci, bi, ai = np.histogram2d(b, a,bins=(N//3,N),  weights=c, normed=False)
#    counts, _, _ = np.histogram2d(b, a,bins=(N//3,N))
    r = ci / counts
 #   bi_edge=np.acos(np.cos(np.linspace(0,np.pi)),N)
#    print("bi",np.min(bi),np.max(bi))
#    print("ai",np.min(ai),np.max(ai))
    ai, bi = np.meshgrid(ai, bi, sparse=False)#, indexing='ij')
    amid=0.5*(ai[1:,1:]+ai[:-1,:-1])
    bmid=0.5*(bi[1:,1:]+bi[:-1,:-1])
    da=ai[1,1]-ai[0,0]
    db=bi[1,1]-bi[0,0]
    A=r**2*da*db*np.sin(bmid)
    V=r**3/3*da*db*np.sin(bmid)
    # r=np.zeros((N,N))
    # xedges=np.linspace(np.min(a),np.max(a),N+1)
    # yedges=np.linspace(np.min(b),np.max(b),N+1)
    # for i in range(N):
    #     for j in range(N):
    #         r[i,j]=np.mean(c[np.array((xedges[i]>a and a<xedges[i+1])*(yedges[j]>b and b<yedges[j+1]),dtype=bool)])

    
    x=r*np.sin(bmid)*np.sin(amid)
    y=r*np.sin(bmid)*np.cos(amid)
    z=r*np.cos(bmid)
    pos=np.zeros((len(x[0,:])*len(x[:,0]),3))
   # print(x)
    pos[:,0]=x.flatten()
    pos[:,1]=y.flatten()
    pos[:,2]=z.flatten()
    #pos=np.array([x.flatten(),y.flatten(),z.flatten()])
    return [r,A,V,pos]
def sphereFit(spX,spY,spZ):
    #   Assemble the A matrix
    spX = np.array(spX)
    spY = np.array(spY)
    spZ = np.array(spZ)
    A = np.zeros((len(spX),4))
    A[:,0] = spX*2
    A[:,1] = spY*2
    A[:,2] = spZ*2
    A[:,3] = 1

    #   Assemble the f matrix
    f = np.zeros((len(spX),1))
    f[:,0] = (spX*spX) + (spY*spY) + (spZ*spZ)
    C, residules, rank, singval = np.linalg.lstsq(A,f)

    #   solve for the radius
    t = (C[0]*C[0])+(C[1]*C[1])+(C[2]*C[2])+C[3]
    radius = np.sqrt(t)

    
    return radius, np.sqrt(residules/len(pos))

"""
