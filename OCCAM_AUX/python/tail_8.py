import sys

fp = open('fort.8','r')
fp_out = open('fort_out.8','w')
pattern         = sys.argv[1]
pattern_replace = sys.argv[2]

while(1):
    lines = []
    ls    = fp.readline().split()
    lines.append(ls)
    if(len(' '.join(ls).strip()) == 0) :
        break
    if(ls[0].isalpha()):
        i=0
        while(ls[0]==pattern[i] and i<len(pattern)-1):
            i=i+1
            ls=fp.readline().split()
            lines.append(ls)
        
#            print(i,len(pattern),a)
        if(i==len(pattern)-1):
            for j in range(i+1):
                lines[j][0]=pattern_replace[j]
                 
    for l in lines:
        fp_out.write('%s\n'%(' '.join(l)))
   
        
