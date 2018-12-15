import numpy as np
import sys
sys.path.append('/home/sigbjobo/Projects/DNA/SIM/continuation/structure/ss/BI/script/')
sys.path.append('/home/sigbjobo/Stallo/Projects/DNA/SIM/continuation/structure/ss/BI/script/')
import ana_prot as ANA
filename = sys.argv[1]

fp1=open('fort.5','r')
lines=fp1.readlines()
names=[]
L=10*np.array([float(li) for li in lines[1].split()[0:]])
print L
for li in lines:
    l=li.split()
    if (len(l)==13 or len(l)==16 ):
        names.append(l[1])

fp       = open('fort.10')
lines    = fp.readlines()
 

r0=[]
bond_index=[]
ang_index=[]
tor_index=[]
bonds_on=0
angles_on=0
tor_on=0
for i in lines:
    
    if(i.split()[0]=='BONDS'):
        bonds_on=1
    if(i.split()[0]=='ANGLES'):
        angles_on=1
        bonds_on=0
    if(i.split()[0]=='TORSIONS'):
        tor_on=1
        angles_on=0
    try:
        if(len(i.split())==5 and bonds_on): 
            bond_index.append([int(j) for j in i.split()[1:3]])
        if(len(i.split())==6 and angles_on): 
            ang_index.append([int(j) for j in i.split()[1:4]])
        if(tor_on and int(i.split()[4])==1): 
            tor_index.append([int(j) for j in i.split()[:-1]])
    except:
        pass

fpw=open('bond_data.dat','w')
fp       = open(filename,'r')
lines    = fp.readlines()
fp.close()
N=int(lines[0])
N_frames=len(lines)//(N+2)
fac=180/np.pi

for i in range(N_frames):
    for j in range(2,len(bond_index)-2):
        i1=bond_index[j][0]-1
        i2=bond_index[j][1]-1
        
        r1 = np.array([float(k) for k in  lines[i*(N+2)+2+i1].split()[1:]])
        r2 = np.array([float(k) for k in  lines[i*(N+2)+2+i2].split()[1:]])
        r2 = ANA.period(r1, r2, L)

        try:
            fpw.write("%s-%s     %f\n"%(names[i1],names[i2],ANA.bond(r1,r2)))
        except:
            pass

    for j in range(2,len(ang_index)-2):
        i1=ang_index[j][0]-1
        i2=ang_index[j][1]-1
        i3=ang_index[j][2]-1
        r1 = np.array([float(k) for k in  lines[i*(N+2)+2+i1].split()[1:]])
        r2 = np.array([float(k) for k in  lines[i*(N+2)+2+i2].split()[1:]])
        r3 = np.array([float(k) for k in  lines[i*(N+2)+2+i3].split()[1:]])
        r2 = ANA.period(r1, r2, L)
        r3 = ANA.period(r2, r3, L)
        try:
            fpw.write("%s-%s-%s   %f\n"%(names[i1],names[i2],names[i3],fac*ANA.ang(r1,r2,r3)))
        except:
            pass


    
    
    for j in range(2,len(tor_index)-2):
        i1=tor_index[j][0]-1
        i2=tor_index[j][1]-1
        i3=tor_index[j][2]-1
        i4=tor_index[j][3]-1
        r1 = np.array([float(k) for k in  lines[i*(N+2)+2+i1].split()[1:]])
        r2 = np.array([float(k) for k in  lines[i*(N+2)+2+i2].split()[1:]])
        r3 = np.array([float(k) for k in  lines[i*(N+2)+2+i3].split()[1:]])
        r4 = np.array([float(k) for k in  lines[i*(N+2)+2+i4].split()[1:]])
        r2 = ANA.period(r1, r2, L)
        r3 = ANA.period(r2, r3, L)
        r4 = ANA.period(r3, r4, L)
        
        try:
            fpw.write("%s-%s-%s-%s %f\n"%(names[i1],names[i2],names[i3],names[i4],fac*ANA.torsional(r1,r2,r3,r4)))
        except:
            pass
fpw.close()
