#!/bin/bash
#SBATCH --job-name=OPTIMIZE_DNA
#SBATCH --account=nn4654k
#SBATCH --time=2-0:0:0
#SBATCH --ntasks=80
##SBATCH --qos=devel

#MANDATORY SETTINGS
export NPROC=80 #192
export COMPILE=0
export NSOLUTE=2

#SETTINGS SPECIFIC TO BAYSIAN OPTIMIZATION
export NSTEPS=1000000 #0
export NTRAJ=10000
export OPT_INIT_STEPS=10 
export OPT_STEPS=60
export kphi=8
export NW=10
export NN=0
export PP=0
#export PW=-7.2
export PW=0
export dt=0 #$(python -c "print(300./(float(${NSTEPS})+2))")
#export NOISE=0.1


# ANALYZE FRAMES FROM START_STEP
START_STEP=300000
export START_FRAME=$(python -c "print(1+int(float(${START_STEP})/(float(${NTRAJ}))))")

#DIRECTORIES
export SHELL_PATH="/home/sigbjobo/Projects/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/shell"
export INPUT_PATH="/home/sigbjobo/Projects/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/INPUT_FILES"
export PYTHON_PATH="/home/sigbjobo/Projects/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/python"
export OCCAM_PATH="/home/sigbjobo/Projects/DNA/DNA_Hybrid_particle_field/../occam_dna_parallel/"
SCRATCH_DIRECTORY="/global/work/${USER}/${SLURM_JOBID}.stallo-adm.uit.no"
SLURM_SUBMIT_DIR=$(pwd)

#LOAD MODULES
module purge
module load intel/2018b
module load FFTW/3.3.7-intel-2018a
module load Python/3.7.0-intel-2018b


folder=sim_${kphi}

#REMOVE OLD SIMULATIONS
rm ${SLURM_SUBMIT_DIR}/${folder} -rf

#PREPARE ${FOLDER}ULATION DIRECTORY
mkdir -p ${SCRATCH_DIRECTORY}
cd ${SCRATCH_DIRECTORY}
mkdir ${folder}
cd ${folder}

#RUN OPTIMIZATION
python -u  ${PYTHON_PATH}/SKOPT_BAYES.py

#SAVE DATA
cp -r ${SCRATCH_DIRECTORY}/${folder} ${SLURM_SUBMIT_DIR}/${folder}


exit 0



#######

