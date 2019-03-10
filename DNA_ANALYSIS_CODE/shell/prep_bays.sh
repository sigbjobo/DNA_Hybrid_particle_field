#!/bin/bash
#Script for setting inital scan before running baysian optimization

# Set up node file for namd run :
module load Python/3.6.4-intel-2018a
module load FFTW/3.3.8-intel-2018b
module load TensorFlow/1.6.0-intel-2018a-Python-3.6.4
PYTHON_PATH="/cluster/home/sigbjobo/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/python"
SHELL_PATH="/cluster/home/sigbjobo/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/shell"

python ${PYTHON_PATH}/BaysianOptPrep.py $1

rm XY.dat
while read LINE
do  
    echo "${LINE}"
    sbatch ${SHELL_PATH}/JOBSCRIPT_BAYS_PREP.sh $LINE
done < X_start.dat    


exit 0







#######

