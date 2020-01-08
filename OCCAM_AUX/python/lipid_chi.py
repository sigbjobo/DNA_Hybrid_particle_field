import sys

fn_in  = sys.argv[1]
fn_out = sys.argv[2]

chi1   = float(sys.argv[3]) 



lines  = open(fn_in,'r').readlines()


for i, l in enumerate(lines):
    if('chi' in l):
        s1=i+1
    if('rho' in l):
        e1=i

dim=e1-s1
chi=[]
for l in lines[s1:e1]:
    chi.append([ls for ls in l.split()])


if(dim==5):
    chi[-2][-1]="%.2f"%(chi1)
    chi[-1][-2]="%.2f"%(chi1)
if(dim==6):
    # chi[-2][-1]="%.2f"%(chi1)
    # chi[-1][-2]="%.2f"%(chi1)
    chi[-3][-1]="%.2f"%(chi1)
    chi[-1][-3]="%.2f"%(chi1)

for i,c in enumerate(chi):
    lines[i+s1]='%s\n'%('\t'.join(c))


with open(fn_out, 'w') as fp_out:
    fp_out.writelines(lines)
