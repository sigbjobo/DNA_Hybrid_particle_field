#!/bin/bash
#SBATCH --job-name=OPTIMIZE_DNA
#SBATCH --account=nn4654k
#SBATCH --time=3-1:0:0
#SBATCH --nodes=8 --ntasks-per-node=16 --mem-per-cpu=2G

##SBATCH --qos=devel
set -o errexit # exit on errors

#LOAD MODULES
module purge
module load intel/2019.1
module load FFTW
module load python3/3.7.0

#MANDATORY SETTINGS
export NPROC=${SLURM_NTASKS}
echo "NUMBER OF PROCESSORS USED: $NPROC"
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
export dt=0 #$(python3 -c "print(300./(float(${NSTEPS})+2))")
#export NOISE=0.1


# ANALYZE FRAMES FROM START_STEP
START_STEP=300000
export START_FRAME=$(python3 -c "print(1+int(float(${START_STEP})/(float(${NTRAJ}))))")

#DIRECTORIES
export SHELL_PATH="/usit/abel/u1/sigbjobo/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/shell"
export INPUT_PATH="/usit/abel/u1/sigbjobo/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/INPUT_FILES"
export PYTHON_PATH="/usit/abel/u1/sigbjobo/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/python"
export OCCAM_PATH="/usit/abel/u1/sigbjobo/DNA/DNA_Hybrid_particle_field/../occam_dna_parallel/"
SCRATCH_DIRECTORY="${SCRATCH}"
SLURM_SUBMIT_DIR=$(pwd)


folder=sim_${kphi}

#REMOVE OLD SIMULATIONS
rm ${SLURM_SUBMIT_DIR}/${folder} -rf

#PREPARE ${FOLDER}ULATION DIRECTORY
mkdir -p ${SCRATCH_DIRECTORY}
cd ${SCRATCH_DIRECTORY}
mkdir ${folder}
cd ${folder}

#RUN OPTIMIZATION
python3 -u  ${PYTHON_PATH}/SKOPT_BAYES.py

#SAVE DATA
cp -r ${SCRATCH_DIRECTORY}/${folder} ${SLURM_SUBMIT_DIR}/${folder}


exit 0



#######

