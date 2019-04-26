import numpy as np
import copy, glob, sys
from scipy.spatial import distance
import calculate_rmsd as rmsd
from scipy.spatial import distance
from scipy.interpolate import interp1d

def torsional(x1,x2,x3,x4):
    #computes torsional angle
    v1 = x1-x2
    v2 = x3-x2
    v3 = x4-x3
    return torsional2(v1,v2,v3)

def torsional2(v1,v2,v3):
    v2m = -v2
    a=np.cross(v1,v2m)
    b=np.cross(v3,v2m)

    rasq=sum(a*a)
    rbsq=sum(b*b)
    rgsq=sum(v2m*v2m)
    rg=np.sqrt(rgsq)
    
    if (rg > 0.0 and rasq > 0.0 and rbsq > 0.0 ):
        rginv = 1.0/rg
        ra2inv = 1.0/rasq
        rb2inv = 1.0/rbsq
    else:
        print('ERROR')
        a=0/0
        
    rabinv = np.sqrt(ra2inv*rb2inv)

    c = sum(a*b)*rabinv
    s = rg*rabinv*sum(a*v3)

    if (c > 1.0):
        c =  1.0
        print('ERROR')
        a=0/0
    
    if (c < -1.0):
        print('ERROR')
        a=0/0
        c = -1.0
    
    return np.arctan2(s,c)


def ang(x1,x2,x3):
    #compute bending angle
    v1 = x1-x2
    v1 = v1/np.linalg.norm(v1)
    v2 = x3-x2
    v2 = v2/np.linalg.norm(v2)
    return np.arccos(np.dot(v1,v2))

def bond(x1,x2):
    # compute bond length
    return np.linalg.norm(x1-x2)


def period(x1, x2, L):
    #correct for periodicity
    dx = x2 - x1 
    dx = dx - L*np.around(dx/L)
    return x1 + dx

def period_2d(x1, x2, L):
    #correct for periodicity
    dx = x2 - x1 
    dx = dx - L[np.newaxis,:]*np.around(dx/L[np.newaxis,:])
    return x1 + dx

def array_period(xs, L):
    #corrects a position array for periodicity
    for i in range(len(xs) - 1):
        xs[i + 1] = period(xs[i], xs[i + 1], L)
    return xs

def read_frame(fp):
    #reads the positions of single frame
    rp=[]
    rs=[]
    rn=[]
    try:
        line = fp.readline()
        nAtoms=int(line)
    
        L=np.array([float(d) for d in fp.readline().split()[1:]])
        for i in range(nAtoms):
            l = fp.readline().split()
            d=[float(d) for d in l[1:]]
            if(l[0]=='P'):
                rp.append(d)
            elif(l[0]=='S'):
                rs.append(d)    
            elif(l[0]=='A' or l[0]=='T' or l[0]=='C' or l[0]=='G'):
                rn.append(d)
        return [fp, np.squeeze(rp), np.squeeze(rs), np.squeeze(rn), L, 1]
    except:
        return [fp,rp,rs,rn,[0.,0.,0.],0]
    
def auto_corr(d):
    #computes autocorrelation function from a array of vectors 
    corr = np.zeros(len(d))
    for i in range(len(d)):
        corr[i] = np.mean(np.sum(d[:len(d)-i]*d[i:],axis=1))
    return corr


def Parseq(r):
    #Parseq method for computing properties of helix
    n = len(r)
    t=np.array(range(n))

    D = np.linalg.det(np.array([[sum(t**2),sum(t)],[sum(t),n]]))
    
    p = np.zeros(3)

    #Compute normal
    d = np.zeros(3)
    for i in range(3):
        d[i] = np.linalg.det(np.array([[sum(r[:,i]*t),sum(t)],[sum(r[:,i]),n]]))/D
        p[i] = np.linalg.det(np.array([[sum(t**2),sum(r[:,i]*t)],[sum(t),sum(r[:,i])]]))/D


    #Compute radius
    radius=0.0
    hs=p[None,:]+t[:,None]*d[None,:]
    radius=np.mean(np.linalg.norm(hs-r,axis=1))

    #Compute angle
    v1=r[:-1] - hs[:-1]
    v2=r[1:]  - hs[1:]
    v1=v1/np.linalg.norm(v1,axis=1)[:,None]
    v2=v2/np.linalg.norm(v2,axis=1)[:,None]
    ang=np.mean(np.arccos(np.sum(v2*v1,axis=1)))*180./np.pi


    return d, radius, ang

def kahn(rp):
    V=[]
    P=[]
    for i in range(1,len(rp)-1):
        a=rp[i-1]-rp[i]
        b=rp[i+1]-rp[i]
        a=a/np.linalg.norm(a)
        b=b/np.linalg.norm(b)
        p=rp[i]

        v=a+b
        v=v/np.linalg.norm(v)
        V.append(v)
        P.append(p)
    H=np.cross(V[0],V[3])
    p2 =P[-1]-P[0]
    p2=p2/np.linalg.norm(p2)
    
    print(p2,H/np.linalg.norm(H))

def BOX_WHISKER(fn):
    #Computes box and whiskers for a single column file
    data=np.loadtxt(fn)
    median = np.median(data)
    upper_quartile = np.percentile(data, 75)
    lower_quartile = np.percentile(data, 25)
    iqr = upper_quartile - lower_quartile
    upper_whisker = data[data<=upper_quartile+1.5*iqr].max()
    lower_whisker = data[data>=lower_quartile-1.5*iqr].min()
    print(lower_whisker,lower_quartile,median,upper_quartile,upper_whisker)

def make_hist(fn,_):
    fp = open(fn,'r')
    bw = _[1]-_[0]
    P = np.zeros(len(_))
    while(1):
        try:
            phi = float(fp.readline())
        except:
            break
        li = int(phi//bw)
        li2= int((phi+180.)//bw)
        l  = (phi - bw*li)/bw
        
        P[li2]   += 1 - l
        P[li2+1] += l

    #Setting periodic bc                                                                                                                             
    P[0]  = P[0] + P[-1]
    P[-1] = P[0]

    return P

def list_sim_fold():
    #List all folders name sim_* in  sorted order
    folders  = glob.glob('sim_*')
    folders2 = copy.copy(folders)
    numb    = np.array([int(fi.split('_')[1]) for fi in folders], dtype=int)
    
    numb    = np.argsort(numb)
  
    for i in range(len(numb)):
        folders[i]=folders2[numb[i]]
    return folders



def comp_rad_ang(r1, v1, r2, L):
    #From directionality of molecule v1, and position r1 and position r2 
    #distances and angles beteween molecules are calculated

    d     = r2[:,np.newaxis,:]-r1[:,:,np.newaxis]
    d     = np.array([d[i] - L[i]*np.around(d[i]/L[i]) for i in range(len(d))])
    dist  = np.linalg.norm(d, axis=0)
    d     = d/dist[np.newaxis]
    v_dir = v1/np.linalg.norm(v1, axis=0)
    calpha = np.sum(v_dir[:,:,np.newaxis]*d,axis=0)

    return [dist, calpha]


def hist_d_calpha(d, calpha, p, L):
    #makes 2d histogram form d and alpha
    max_d    = p[0]
    n_d      = p[1]
    n_alpha  = p[2]

    d=np.ravel(d)
    calpha=np.ravel(calpha)
    d_edges = np.linspace(0,max_d, n_d + 1)
    
    calpha_edges = np.linspace(-1., 1., n_alpha + 1)
    H, d_edges, calpha_edges = np.histogram2d(d, calpha, bins=(d_edges, calpha_edges))
    
    #Volume per cell
    
    dv = (2.*np.pi*(-calpha_edges[:-1]+calpha_edges[1:])[:,np.newaxis]/3.*(d_edges[1:]**3-d_edges[:-1]**3)).T
 
    #Normalization of H 
    #Such that each angle-distance element goes to 1 for long distances 
    H=H/(dv*len(d)/(L[0]*L[1]*L[2]))

    #To get g(r): np.mean(H,axis=1)
    #To get density rho(r,calpha): H*rho_0
    #Where rho_0 is the density of for which you measure the density of, for instance salt concentration.
    return [H, d_edges, calpha_edges]

def contact_map(r, L=[1000,1000,1000], rc=1.0):
    """
    FUNCTION THAT COMPUTES CONTACTMAP MATRIX
    """
    d = [cdist(r[:,i][:,np.newaxis],r[:,i][:,np.newaxis]) for i in range(len(L))]
    d = [np.abs(d[i] - L[i]*np.around(d[i]/L[i])) for i in range(len(d))]

    #MIGHT INTRODUCE CUTTOFF HERE

    d = np.sum(d, axis = 0)
    
    return d

def rmsd_VEC(A,B):

    #REMOVE CENTER OF MASS
    A -= rmsd.centroid(A)
    B -= rmsd.centroid(B)

    #FIND ROTATION MATRIX
    U = rmsd.kabsch(A, B)

    # ROTATE TOWARDS B
    A = np.dot(A, U)

    #RETURN ROTATED ARRAY
    return  A
    
def rmsd_dist(A,B):
    
    #REMOVE CENTER OF MASS
    A -= rmsd.centroid(A)
    B -= rmsd.centroid(B)

    #FIND ROTATION MATRIX
    U = rmsd.kabsch(A, B)

    # ROTATE TOWARDS B
    A = np.dot(A, U)

    #RETURN ROOT MEAN SQUARE DEVIATION
    return  rmsd.rmsd(A, B)

def write_rmsd(fp,fp2,A,B):
    A -= rmsd.centroid(A)
    B -= rmsd.centroid(B)

    fp2.write('%d\n'%(len(A)))
    fp2.write('\n')
    for i in range(len(A)):
        fp2.write('A %f %f %f\n'%(A[i,0],A[i,1],A[i,2]))


    #FIND ROTATION MATRIX
    U = rmsd.kabsch(A, B)

    # ROTATE TOWARDS B
    A = np.dot(A, U)
    fp.write('%d\n'%(len(A)))
    fp.write('\n')
    for i in range(len(A)):
        fp.write('A %f %f %f\n'%(A[i,0],A[i,1],A[i,2]))
  
    return fp
    
    
def minor_major(r_p):
    r1=(r_p[:len(r_p)//2])
    r2=(r_p[len(r_p)//2:])
    r2=r2[::-1]
    dists=[]

    n=np.linspace(0,1,len(r1))
    resolution=40
    add=1
    n2=np.linspace(0,1,len(r1)*resolution)

    R1func=interp1d(n,r1,axis=0,kind='cubic')
    R2func=interp1d(n,r2,axis=0,kind='cubic')
    R1=R1func(n2)
    R2=R2func(n2)

    for i in range(4,len(r1)-5):
    
        RA=R1[int(np.ceil((i-add)*resolution)):int(np.floor((i+add)*resolution))]
        RB=R2[int(np.ceil((i-3-add)*resolution)):int(np.floor((i-3+add)*resolution))]
        RC=R2[int(np.ceil((i+5-add)*resolution)):int(np.floor((i+5+add)*resolution))]


        d0=np.min(distance.cdist(RA,RB))
        d1=np.min(distance.cdist(RA,RC))

        dists.append([d0,d1])
    dists=np.array(dists)

    #COMPUTE MEAN  OF MINOR AND MAJOR GROOVE
    mean = np.mean(dists,axis=0)
    
    return mean
