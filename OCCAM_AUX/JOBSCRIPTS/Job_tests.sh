#!/bin/bash
#SBATCH --job-name=PER_SINGLE
#SBATCH --account=nn4654k
#SBATCH --time=0-1:00:0
#SBATCH --ntasks=5
##SBATCH --nodes=1
##SBATCH --ntasks-per-node=20
#SBATCH --mem-per-cpu=2G
#SBATCH --qos=devel
##SBATCH --error=sim.err
set -o errexit # exit on errors

#LOAD MODULES
export LMOD_DISABLE_SAME_NAME_AUTOSWAP=no
module load intel/2019.2
module load fftw/3.3.4
module load python3/3.5.0

#MANDATORY SETTINGS
export NPROC=${SLURM_NTASKS}
export COMPILE=0 #1

echo "NUMBER OF PROCESSORS USED: $NPROC"

#DIRECTORIES
export SHELL_PATH="/usit/abel/u1/sigbjobo/DNA_PRESSURE/DNA_Hybrid_particle_field/OCCAM_AUX/shell"
export INPUT_PATH="/usit/abel/u1/sigbjobo/DNA_PRESSURE/DNA_Hybrid_particle_field/OCCAM_AUX/INPUT_FILES"
export PYTHON_PATH="/usit/abel/u1/sigbjobo/DNA_PRESSURE/DNA_Hybrid_particle_field/OCCAM_AUX/python"
export OCCAM_PATH="/usit/abel/u1/sigbjobo/DNA_PRESSURE/DNA_Hybrid_particle_field/../occam_pressure_parallel/"
SCRATCH_DIRECTORY="${SCRATCH}"
SLURM_SUBMIT_DIR=$(pwd)

bash run_tests.sh
wait

 
exit 0







#######

