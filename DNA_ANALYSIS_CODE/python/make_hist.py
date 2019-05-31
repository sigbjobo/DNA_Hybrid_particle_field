import numpy as np
import sys
#Setting paths                                                                                                            
SHELL_PATH="/usit/abel/u1/sigbjobo/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/shell"
PYTHON_PATH="/usit/abel/u1/sigbjobo/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/python"
EXTRA_PATH="/home/sigbjobo/Stallo/Projects/DNA/DNA_Hybrid_particle_field/DNA_CODE_PLOT/DNA_ANALYSIS_CODE/python"
sys.path.append(SHELL_PATH)
sys.path.append(PYTHON_PATH)
sys.path.append(EXTRA_PATH)
import ana_prot as ANA

N=int(sys.argv[2])

_=np.array(range(N+1))
_=-180+360./(len(_)-1)*_
dphi=_[1]-_[0]

P= ANA.make_hist(sys.argv[1],_)


kt=2.479*293.15/298.
P[P==0]=np.min(P[P!=0])
P=P/(np.sum(P)*dphi)
V=-kt*np.log(P)
V=V-np.min(V)


fp = open(sys.argv[3], 'w')
theta=0.5*(_[1:]+ _[:-1])
for i in range(len(theta)):
    fp.write('%f %f %f\n'%(theta[i],P[i],V[i]))

 
