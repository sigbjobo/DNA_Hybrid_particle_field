#!/bin/bash
#SBATCH --job-name=OPTIMIZE_DNA
#SBATCH --account=nn4654k
#SBATCH --time=2-:00:00
#SBATCH --ntasks=192 #1 --ntasks-per-node=32
##SBATCH --qos=devel

#MANDATORY SETTING
export NPROC=192
export COMPILE=0
export NSOLUTE=2

#SETTINGS SPECIFIC TO BAYSIAN OPTIMIZATION
export NSTEPS=1000000
export NTRAJ=2500
export OPT_INIT_STEPS=10 
export OPT_STEPS=40 
export kphi=20
export alpha=10
export beta=-10
export PP=0
export PW=-3.6

#DIRECTORIES
export SHELL_PATH="/home/sigbjobo/Projects/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/shell"
export INPUT_PATH="/home/sigbjobo/Projects/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/INPUT_FILES"
export PYTHON_PATH="/home/sigbjobo/Projects/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/python"
SCRATCH_DIRECTORY="/global/work/${USER}/${SLURM_JOBID}.stallo-adm.uit.no"
SLURM_SUBMIT_DIR=$(pwd)

#LOAD MODULES
module purge
module load intel/2018b
module load FFTW/3.3.7-intel-2018a
module load Python/3.6.4-intel-2018a


#REMOVE OLD SIMULATIONS
rm ${SLURM_SUBMIT_DIR}/sim -rf

#PREPARE SIMULATION DIRECTORY
mkdir -p ${SCRATCH_DIRECTORY}
cd ${SCRATCH_DIRECTORY}
mkdir sim
cd sim

#RUN OPTIMIZATION
python ${PYTHON_PATH}/occam_bayesian_2d.py ${OPT_INIT_STEPS} ${OPT_STEPS}

#SAVE DATA
cp -r ${SCRATCH_DIRECTORY}/sim ${SLURM_SUBMIT_DIR}/sim


exit 0



#######
