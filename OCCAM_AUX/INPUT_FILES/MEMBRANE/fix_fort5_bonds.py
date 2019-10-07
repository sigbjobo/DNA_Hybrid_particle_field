import sys

fix_top=int(sys.argv[1])

fix_vel=int(sys.argv[2])

fix_bond=int(sys.argv[3])

print('fixing fort.5 to fort.9 format:')
if(fix_top):
    print('fixing top')

if(fix_vel):
    print('fixing velocities')

if(fix_bond):
    print('fixing bonds to 6')

fp = open('fort.5', 'r')
fp_out = open('fort.5_fixed', 'w')

l=fp.readline()
fp_out.write(l)
ls=fp.readline().split()
if(fix_top):
    fp_out.write('%s\n'%(' '.join(ls[:-1])))
    fp_out.write('%s\n'%(ls[-1]))
else:
    fp_out.write('%s\n'%(' '.join(ls)))
    l=fp.readline() #dummyline
    fp_out.write('%s'%l)
ls=fp.readline()
fp_out.write('molecules_total_number:\n')
nmol=int(fp.readline())
fp_out.write('%d\n'%nmol)


for i in range(nmol):
    
    ls=fp.readline().split()
    fp_out.write('atoms_in_molecule: %s\n'%(ls[-1]))
    natom=int(fp.readline())
    fp_out.write('%d\n'%(natom))

    for i in range(natom):
        ls=fp.readline().split()
        if(fix_vel):
            ls.insert(7,'0.0')
            ls.insert(7,'0.0')
            ls.insert(7,'0.0')
        if(fix_bond>0):
            for j in range(fix_bond):
                ls = ls + ['0']
        fp_out.write('%s\n'%(' '.join(ls)))
        
fp.close()
fp_out.close()
