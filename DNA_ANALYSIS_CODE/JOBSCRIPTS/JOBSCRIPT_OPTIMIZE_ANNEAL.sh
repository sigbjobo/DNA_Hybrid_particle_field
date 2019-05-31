#!/bin/bash
#SBATCH --job-name=OPTIMIZE_DNA
#SBATCH --account=nn4654k
#SBATCH --time=0-1:0:0
#SBATCH --nodes=3 --ntasks-per-node=16
#SBATCH --qos=devel

#MANDATORY SETTINGS
NPROCS=${SLURM_NTASKS}
export COMPILE=0
export NSOLUTE=2

#SETTINGS SPECIFIC TO BAYSIAN OPTIMIZATION
export NSTEPS=2000 #0
export NTRAJ=25
export OPT_INIT_STEPS=10
export OPT_STEPS=20
export kphi=5
export NW=10
export NN=0
export PP=0
#export PW=-7.2
export PW=0
export dt=$(python3 -c "print(300./(float(${NSTEPS})+2))")

# ANALYZE FRAMES FROM START_STEP
START_STEP=1950
export START_FRAME=$(python3 -c "print(1+int(float(${START_STEP})/(float(${NTRAJ}))))")

export NOISE=0.001

#DIRECTORIES
export SHELL_PATH="/usit/abel/u1/sigbjobo/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/shell"
export INPUT_PATH="/usit/abel/u1/sigbjobo/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/INPUT_FILES"
export PYTHON_PATH="/usit/abel/u1/sigbjobo/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/python"
export OCCAM_PATH="/usit/abel/u1/sigbjobo/DNA/DNA_Hybrid_particle_field/../occam_dna_parallel/"
SCRATCH_DIRECTORY="${SCRATCH}"
SLURM_SUBMIT_DIR=$(pwd)

#LOAD MODULES
module purge
module load intel/2019.1
module load FFTW
module load python3/3.7.0


folder=sim_${kphi}_anneal
#REMOVE OLD SIMULATIONS
rm ${SLURM_SUBMIT_DIR}/${folder} -rf

#PREPARE ${FOLDER}ULATION DIRECTORY
mkdir -p ${SCRATCH_DIRECTORY}
cd ${SCRATCH_DIRECTORY}
mkdir ${folder}
cd ${folder}

#RUN OPTIMIZATION
python3  ${PYTHON_PATH}/SKOPT_BAYES.py

#SAVE DATA
cp -r ${SCRATCH_DIRECTORY}/${folder} ${SLURM_SUBMIT_DIR}/${folder}


exit 0



#######

