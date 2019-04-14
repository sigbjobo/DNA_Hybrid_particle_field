#!/bin/bash
#SBATCH --job-name=OPTIMIZE_DNA
#SBATCH --account=nn4654k
#SBATCH --time=3-0:0:0
#SBATCH --nodes=6 --ntasks-per-node=32
##SBATCH --qos=devel

#MANDATORY SETTINGS
export NPROC=192
export COMPILE=0
export NSOLUTE=2

#SETTINGS SPECIFIC TO BAYSIAN OPTIMIZATION
export NSTEPS=4000000
export NTRAJ=5000
export OPT_INIT_STEPS=10 
export OPT_STEPS=40
export kphi=10
export NW=10
export NN=-10
export PP=0
export PW=-3.6

#DIRECTORIES
export SHELL_PATH="/cluster/home/sigbjobo/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/shell"
export INPUT_PATH="/cluster/home/sigbjobo/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/INPUT_FILES"
export PYTHON_PATH="/cluster/home/sigbjobo/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/python"
export OCCAM_PATH="/cluster/home/sigbjobo/DNA/DNA_Hybrid_particle_field/../occam_dna_parallel/"
SCRATCH_DIRECTORY="/cluster/work/jobs/${SLURM_JOB_ID}"
SLURM_SUBMIT_DIR=$(pwd)

#LOAD MODULES
module purge
module load intel/2018b
module load FFTW/3.3.8-intel-2018b
module load Python/3.6.4-intel-2018a


#REMOVE OLD SIMULATIONS
rm ${SLURM_SUBMIT_DIR}/sim -rf

#PREPARE SIMULATION DIRECTORY
mkdir -p ${SCRATCH_DIRECTORY}
cd ${SCRATCH_DIRECTORY}
mkdir sim
cd sim

#RUN OPTIMIZATION
python ${PYTHON_PATH}/occam_bayesian_2d.py 

#SAVE DATA
cp -r ${SCRATCH_DIRECTORY}/sim ${SLURM_SUBMIT_DIR}/sim


exit 0



#######

