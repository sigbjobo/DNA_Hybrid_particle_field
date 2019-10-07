import numpy as np
import sys
#from mpl_toolkits.mplot3d import Axes3D
from sklearn.cluster import AgglomerativeClustering 
print("filename: %s"%( sys.argv[1]))
# import matplotlib.pyplot as plt
# fig = plt.figure(0, figsize=(4, 3))
fp = open(sys.argv[1],'r')

start=3
if(len(sys.argv)>2):
    start = int(sys.argv[2])

names=['N','P','G','C','D','W']

l=fp.readline()

r=0
end=10000000
fp_out=open('thickness.dat','w')



# START ANALYSIS
while (not (l=="")):
    l= l.split()
    numa=int(l[0])
    l=fp.readline()
    l=l.split()
    rs=[]
    
    if(r>end):
        break 
    r=r+1

    # ANALYZE FRAME
    for i in range(numa):
        l=fp.readline()
        l=l.split()

        # COLLECT HEADS
        if(r>start):
            if(l[0]=="N"):
                rs.append([float(li) for li in l[1:]])

    #ANALYZE CLUSTERS
    if(r>start):
        rs=np.array(rs)
        cluster_alg=AgglomerativeClustering(n_clusters=2, affinity='euclidean',linkage='single')
        cluster_alg.fit(rs)
        labels = cluster_alg.labels_
        labels=labels.astype(np.int) 
        fp_out.write("%f\n"%(np.abs(np.mean(rs[labels][2])-np.mean(rs[labels==0][2]))))
           
    l=fp.readline()
fp.close()
fp_out.close()
