#!/bin/bash
#SBATCH --job-name=DNA
#SBATCH --account=nn4654k
#SBATCH --partition=singlenode
#SBATCH --time=1-0:00:00
#SBATCH --mem-per-cpu=3000M 
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1


SHELL_PATH="/home/sigbjobo/Projects/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/shell"
PYTHON_PATH="/home/sigbjobo/Projects/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/python"

# Set up node file for namd run :
module load Python/3.6.4-intel-2018a
module load FFTW/3.3.7-intel-2018a
echo "Alpha=$1, Beta=$2"
python ${PYTHON_PATH}/eval_fit.py $1 $2
cat opt.dat >> ../XY.dat
exit 0







#######

