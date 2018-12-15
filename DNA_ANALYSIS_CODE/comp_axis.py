import sys
import numpy as np
from scipy.optimize import minimize
def comp_axis_single(r1,r2,n):
    P1=r1[1:-1]#[:-n]
    CA1=r1[0:-2]#[:-n]
    CA3=r1[2:]#[:-n]
    A = CA1-P1
    B = CA3-P1
    A=A/np.linalg.norm(A,axis=1)[:,None]
    B=B/np.linalg.norm(B,axis=1)[:,None]
    V1 = A+B
    V1 = V1/np.linalg.norm(V1,axis=1)[:,None]


    P2=(r2[1:-1])#[n:]
    CA1=(r2[0:-2])#[n:]
    CA3=(r2[2:])#[n:]
    A = CA1-P2
    B = CA3-P2
    A=A/np.linalg.norm(A,axis=1)[:,None]
    B=B/np.linalg.norm(B,axis=1)[:,None]
    V2 = A+B
    V2 = V2/np.linalg.norm(V2,axis=1)[:,None]


    H = np.cross(V1,V2)
    H=H/np.linalg.norm(H,axis=1)[:,None]
    d=np.sum(H*(P2-P1),axis=1)
    H=H*np.sign(d)[:,None]
    d=np.abs(d)

   # print np.inner((P2-P1),(P2-P1))
    # C1=d**2
    # C2=np.zeros(len(P2))
    # C3=np.zeros(len(P2))
    # for i in range(len(P2)):
    #     C2[i]=np.sum((P2-P1)[i]*(P2-P1)[i])
    #     C3[i]=np.sum((P1-P2)[i]*V2[i])

    r=(d**2  - np.sum((P2-P1)*2,axis=1))/(2*np.sum((P1-P2)*V2,axis=1))
    print r
# r=(C1-C2)/(2*C3)
    
#H=H*np.sign(d)[:,None]
    #d=np.abs(d)
#    print H
#    print d
#    print r
    return [H,d,r] 
def comp_axis_single2(r1,r2):
    H=np.zeros((len(r1)-2,3))
    D=np.zeros(len(r1)-2)
    R=np.zeros(len(r1)-2)
    for i in range(len(r1)-2):
        CA11=r1[i]
        P1=r1[i+1]
        CA21=r1[i+2]
        A1=CA11-P1
        B1=CA21-P1
        A1=A1/sum(A1**2)**0.5
        B1=B1/sum(B1**2)**0.5
        V1=A1+B1
        V1=V1/sum(V1**2)**0.5

        CA12=r2[i]
        P2=r2[i+1]
        CA22=r2[i+2]
        A2=CA12-P2
        B2=CA22-P2
        A2=A2/sum(A2**2)**0.5
        B2=B2/sum(B2**2)**0.5
        V2=A2+B2
        V2=V2/sum(V2**2)**0.5

        h=np.cross(V1,V2)
        h=h/sum(h**2)**0.5
        d=sum(h*(P2-P1))
        h=h*np.sign(d)
        d=d*np.sign(d)
        r=(d**2-sum((P2-P1)**2))/(2*sum((P1-P2)*V2))
        r=np.sign(r)*r
#        print ["%f"%k for k in P2]
#        print P1+r*V1+d*h-r*V2
        H[i]=h
        D[i]=d
        R[i]=r

    return [H,D,R] 
# def aaqvist(r):
#     r0 = np.array([1,0,0])
#     a  = np.array([0,1,0])
#     def d(r,r0,a):
#         return r-r0-np.sum(r*a[:,None])*a[:,None]
def eigen(r):
    r=r-np.mean(r,axis=0)
    M=np.zeros((3,3))
    for i in range(3):
        for j in range(3):
            M[j,i]=np.sum(r[:,i]*r[:,j])
    [l,v]=np.linalg.eig(M)
    v=v[:,np.abs(l)==np.max(np.abs(l))]
    
    v=v/(np.sum(v**2)**0.5)
#    v=np.array([0,0,1])
    z=np.zeros(len(r))#np.sum(r*v[:,None],axis=1)
    for i in range(len(z)):
        z[i]=np.sum(r[i]*v)
 #   print v,l
    print np.mean(z[1:]-z[:-1])
    return [v,np.mean(z[1:]-z[:-1]),1] 

def Parseq(r):
    n = len(r)
    t=np.array(range(n))
    D = np.linalg.det(np.array([[sum(t**2),sum(t)],[sum(t),n]]))
    
    #x
    p = np.zeros(3)
    d = np.zeros(3)
    for i in range(3):
        d[i] = np.linalg.det(np.array([[sum(r[:,i]*t),sum(t)],[sum(r[:,i]),n]]))/D
        p[i] = np.linalg.det(np.array([[sum(t**2),sum(r[:,i]*t)],[sum(t),sum(r[:,i])]]))/D

    radius=0.0
    hs=p[None,:]+t[:,None]*d[None,:]
    radius=np.mean(np.linalg.norm(hs-r,axis=1))
    v1=r[:-1] - hs[:-1]
    v2=r[1:]  - hs[1:]
    v1=v1/np.linalg.norm(v1,axis=1)[:,None]
    v2=v2/np.linalg.norm(v2,axis=1)[:,None]
    #print np.sum(v2*v1,axis=1) 
    ang=np.mean(np.arccos(np.sum(v2*v1,axis=1)))*180./np.pi
    return np.linalg.norm(d),radius,ang
   # px=np.linalg.det(np.array([[sum(t**2),sum(t)],[sum(t),n]]))

def J(x,a,r0):
    d=x-r0-np.dot(x,a)*a
    return np.sum(np.linalg.norm(d-np.mean(d,axis=0),axis=1)) +10.*(np.abs(np.dot(r0,a))+np.dot(r0,a))

def aaquist(x):
    np.minimize(J,x,args=(a,r0) np.optimize()a=np.array([0,0,1])
    



# def J(r0,x,a,o):
#     r=x-o-(np.dot(x,a))*a
#     return np.sum(np.norm(r,axis=1)-r0)**2

# def HELFIT(x):
    
#     r=x-o-(np.dot())
    

def ana_pos(r,L):
   
    r1=r[:len(r)//2]
    r2=r[len(r)//2:]
    min_dist=np.zeros(len(r1))
    for i in range(len(r1)):
        d = np.abs(r1[i]-r2)
        d = d-0.5*L*(d//(0.5*L)) 
        min_dist[i]=np.min(np.linalg.norm(d,axis=1))
    return min_dist

def ana_pos_ang(r,rs,L):
   
    r1=r[:len(r)//2]
    r2=r[len(r)//2:]

    rs1=rs[:len(rs)//2]
    rs2=rs[len(rs)//2:]

    dsr1=r1-rs1
    dsr2=r2-rs2
    dsr1=dsr1-0.5*L*(dsr1//(0.5*L))
    dsr2=dsr2-0.5*L*(dsr2//(0.5*L))
    
    dsr1=dsr1/np.linalg.norm(dsr1,axis=1)[:,np.newaxis]
    dsr2=dsr2/np.linalg.norm(dsr2,axis=1)[:,np.newaxis]


    min_dist=np.zeros(len(r1))
    min_ang=np.zeros(len(r1))
    for i in range(len(r1)):
        d = np.abs(r1[i]-r2)
        d = np.linalg.norm(d - 0.5*L*(d//(0.5*L)),axis=1)

        min_d=np.min(d)
        i2=np.where(d==min_d)
        min_ang[i]=np.arccos(np.dot(dsr1[i],dsr2[i2].T))
        min_dist[i]=min_d
    return min_dist, min_ang
    

def ana_corr(r,L):
    
    corr=np.zeros(len(r)//10)
    dr = r[1:]-r[:-1]
    dr = dr - 0.5*L*(dr//(0.5*L))
    dr = dr/np.linalg.norm(dr,axis=1)[:,np.newaxis]
   # print np.dot(dr,dr.T)
    corr=[]
#    print len(dr)//10
   # print np.dot(dr[10:],dr[:-10].T)
    for i in range(len(dr)//10):
        corr.append(np.mean(np.dot(dr[(i+1)*10:],dr[:-(i+1)*10].T)))
    return np.array(corr)

def comp_radius(r,d):
    d=d/np.linalg.norm(d)
    I=np.zeros((3,3))
    r=r-np.mean(r,axis=0)[None,:]
    print r
    print d
    for i in range(3):
        for j in range(3):
            I[i,j]=sum(r[:,i]*r[:,j])
    print len(r)
    return np.sqrt(np.dot(d,np.dot(I,d.T))/len(r))

            
       
