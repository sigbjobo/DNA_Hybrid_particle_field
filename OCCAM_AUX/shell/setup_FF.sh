#!/bin/bash
 
kphi=$1
n=48
PYTHON_PATH="/cluster/home/sigbjobo/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/python"

#EQUILIBIRUM TORSIONAL ANGLES
names[1]=P-S-P-S
phi0[1]=-154.8
names[2]=S-P-S-P
phi0[2]=-179.2
names[3]=S-P-S-A
phi0[3]=54.8
names[4]=A-S-P-S
phi0[4]=-32.80
names[5]=S-P-S-T
phi0[5]=58.0
names[6]=T-S-P-S
phi0[6]=-44.8
names[7]=S-P-S-C
phi0[7]=57.0
names[8]=C-S-P-S
phi0[8]=-34.1
names[9]=S-P-S-G
phi0[9]=53.9
names[10]=G-S-P-S
phi0[10]=-29.11

mkdir FF

for i in $(seq 1 10) 
do
    {
    echo ${kphi}, ${names[$i]}, ${phi0[$i]}
    python3 ${PYTHON_PATH}/make_pot.py $n ${kphi} ${phi0[$i]} ${names[$i]}_pot.dat 
    python3 ${PYTHON_PATH}/make_coef.py ${names[$i]}_pot.dat ${names[$i]} ${names[$i]}_1_pot_after.dat 
    mv ${names[$i]}_PROP.dat FF/
    }&
done
wait
rm *_pot.dat *_pot_after.dat

