import sys,os

#TAKING INPUT
fn = sys.argv[1]

NW=float(os.environ['alpha'])
AT=float(os.environ['beta'])
GC=AT
PP=float(os.environ['PP'])
PW=float(os.environ['PW'])

#REPEAT INPUT PARAMETERS
print("CHI_NW: %.2f"%(NW))
print("CHI_AT: %.2f"%(AT))
print("CHI_GC: %.2f"%(GC))
print("CHI_PP: %.2f"%(PP))
print("CHI_PW: %.2f"%(PW))

#READ FORT.3
lines = open('fort.3','r').readlines()

#MAKE CHI MATRIX FROM VARIABLES
chi=[]
chi.append('%7.2f%7.2f%7.2f%7.2f%7.2f%7.2f%7.2f%7.2f%7.2f'%(PP,  0,  0,   0,  0,  0,  PW,  0,  0))
chi.append('%7.2f%7.2f%7.2f%7.2f%7.2f%7.2f%7.2f%7.2f%7.2f'%(0,   0,  0,   0,  0,  0,   0,  0,  0))
chi.append('%7.2f%7.2f%7.2f%7.2f%7.2f%7.2f%7.2f%7.2f%7.2f'%(0,   0,  0,  AT,  0,  0,  NW,  0,  0))
chi.append('%7.2f%7.2f%7.2f%7.2f%7.2f%7.2f%7.2f%7.2f%7.2f'%(0,   0, AT,   0,  0,  0,  NW,  0,  0))
chi.append('%7.2f%7.2f%7.2f%7.2f%7.2f%7.2f%7.2f%7.2f%7.2f'%(0,   0,  0,   0,  0, GC,  NW,  0,  0))
chi.append('%7.2f%7.2f%7.2f%7.2f%7.2f%7.2f%7.2f%7.2f%7.2f'%(0,   0,  0,   0, GC,  0,  NW,  0,  0))
chi.append('%7.2f%7.2f%7.2f%7.2f%7.2f%7.2f%7.2f%7.2f%7.2f'%(PW,  0, NW,  NW, NW,  NW,  0,  0,  0))
chi.append('%7.2f%7.2f%7.2f%7.2f%7.2f%7.2f%7.2f%7.2f%7.2f'%(0,   0,  0,   0,  0,  0,   0,  0,  0))
chi.append('%7.2f%7.2f%7.2f%7.2f%7.2f%7.2f%7.2f%7.2f%7.2f'%(0,   0,  0,   0,  0,  0,   0,  0,  0))

#CHANGE THE CHI-MATRIX
for i in range(len(lines)):
    ls = lines[i].split()
    
    try:
        if(ls[0]=='*chi'):
            lines[i]='%s\n'%(' '.join(ls))

            for j in range(len(chi)):
                lines[i+j+1]="%s\n"%(chi[j])
            i=i+len(chi)
  
    except:
        pass

#WRITE OUT FINAL FORT.3
fp=open('fort.3','w')
for l in lines:
    fp.write('%s'%(l))
fp.close()

    
