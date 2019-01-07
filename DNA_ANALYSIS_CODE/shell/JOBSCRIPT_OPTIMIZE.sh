#!/bin/bash

#SBATCH --job-name=OPTIMIZE_DNA
#SBATCH --account=nn4654k
#SBATCH --time=7-0:00:00
#SBATCH --partition=singlenode
#SBATCH --nodes=1 
#SBATCH --ntasks-per-node=4
#SBATCH --mem-per-cpu=2000M 



# Set up node file for namd run :
module load Python/3.6.4-intel-2018a
module load TensorFlow/1.6.0-intel-2018a-Python-3.6.4
module load intel/2017.01
module load OpenMPI/2.0.1-iccifort-2017.1.132-GCC-5.4.0-2.26
module load FFTW/3.3.2

PYTHON_PATH="/home/sigbjobo/Projects/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/python"

python ${PYTHON_PATH}/BaysianOpt.py

exit 0







#######

