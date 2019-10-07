import sys

names=[]
vals=[]
unique_names=[]
fp=open(sys.argv[1],'r')
try:
    while(1):
        l=fp.readline().split()
        if l[0] not in unique_names:
            unique_names.append(l[0])
    
except:
    pass
fp.close()
fps=[open('%s.txt'%(n),'w') for n in unique_names]

fp=open(sys.argv[1],'r')
try:
    while(1):
        l=fp.readline().split()
        fps[unique_names.index(l[0])].write('%s\n'%(l[1]))
except:
    pass
