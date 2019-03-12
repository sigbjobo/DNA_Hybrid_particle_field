#!/bin/bash
 
kphi=$1
n=48
PYTHON_PATH="/cluster/home/sigbjobo/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/python"
names[1]=P-S-P-S
phi0[1]=-179.17
names[2]=S-P-S-P
phi0[2]=-154.80
names[3]=S-P-S-A
phi0[3]=-22.60
names[4]=A-S-P-S
phi0[4]=50.69
names[5]=S-P-S-T
phi0[5]=-33.42
names[6]=T-S-P-S
phi0[6]=54.69
names[7]=S-P-S-C
phi0[7]=-32.72
names[8]=C-S-P-S
phi0[8]=54.5000
names[9]=S-P-S-G
phi0[9]=-22.30
names[10]=G-S-P-S
phi0[10]=50.66

mkdir FF

for i in $(seq 1 10) 
do
    echo ${names[$i]}, ${phi0[$i]}
    python ${PYTHON_PATH}/make_pot.py $n ${kphi} ${phi0[$i]} ${names[$i]}_pot.dat
    python ${PYTHON_PATH}/make_coef.py ${names[$i]}_pot.dat ${names[$i]} ${names[$i]}_1_pot_after.dat
    mv ${names[$i]}_PROP.dat FF/
done
rm *_pot.dat *_pot_after.dat

