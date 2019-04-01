import sys
#Setting paths                                                                                                            
SHELL_PATH="/cluster/home/sigbjobo/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/shell"
PYTHON_PATH="/cluster/home/sigbjobo/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/python"
EXTRA_PATH="/home/sigbjobo/Stallo/Projects/DNA/DNA_Hybrid_particle_field/DNA_CODE_PLOT/DNA_ANALYSIS_CODE/python"
sys.path.append(SHELL_PATH)
sys.path.append(PYTHON_PATH)
sys.path.append(EXTRA_PATH)
import numpy as np
import ana_prot as ANA


n_nuc=15
fp = open(sys.argv[1],'r')

frame=1
not_empty=1
fp2=open('end_end.dat','w')

[fp, rp, rs, rn, L, not_empty] = ANA.read_frame(fp)
while(not_empty):
    rp = ANA.array_period(rp, L)
    fp2.write("%5d %4.1f\n" %(frame,ANA.bond(rp[0],rp[-1])))
       
    frame += 1
    [fp, rp, rs, rn, L, not_empty] = ANA.read_frame(fp)
fp2.close()

  
    
