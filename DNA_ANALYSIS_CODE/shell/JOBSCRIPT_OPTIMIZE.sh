#!/bin/bash

#SBATCH --job-name=OPTIMIZE_DNA
#SBATCH --account=nn4654k
#SBATCH --partition=singlenode
#SBATCH --time=7-0:00:00
#SBATCH --mem-per-cpu=3000M 
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1


# Set up node file for namd run :
module load Python/3.6.4-intel-2018a
module load FFTW
module load TensorFlow/1.6.0-intel-2018a-Python-3.6.4
PYTHON_PATH="/home/sigbjobo/Projects/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/python"

python ${PYTHON_PATH}/BaysianOpt.py


exit 0







#######

