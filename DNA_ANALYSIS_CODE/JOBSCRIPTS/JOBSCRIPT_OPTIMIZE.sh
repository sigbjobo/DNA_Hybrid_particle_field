#!/bin/bash
#SBATCH --job-name=OPTIMIZE_DNA
#SBATCH --account=nn4654k
#SBATCH --time=3-0:00:0
#SBATCH --nodes=4 --ntasks-per-node=40
#SBATCH --mem-per-cpu=2G
##SBATCH --qos=devel
set -o errexit # exit on errors

#LOAD MODULES
#module purge
#module load intel/2019a
#module load intel/2018b 
export LMOD_DISABLE_SAME_NAME_AUTOSWAP=no
module load intel/2018b 

module load FFTW/3.3.8-intel-2019a
module load Python/3.6.6-intel-2018b

#MANDATORY SETTINGS
export NPROC=${SLURM_NTASKS}
echo "NUMBER OF PROCESSORS USED: $NPROC"
export COMPILE=0
export NSOLUTE=2

#SETTINGS SPECIFIC TO BAYSIAN OPTIMIZATION
export NSTEPS=5000000 #0
export NTRAJ=5000
export OPT_INIT_STEPS=10 
export OPT_STEPS=100
export kphi=8
export NW=10
export NN=0
export PP=0
#export PW=-7.2
export PW=0
export dt=0 #$(python3 -c "print(300./(float(${NSTEPS})+2))")
#export NOISE=0.1


# ANALYZE FRAMES FROM START_STEP
START_STEP=$(python3 -c "print(int(0.1*${NSTEPS}))")
export START_FRAME=$(python3 -c "print(1+int(float(${START_STEP})/(float(${NTRAJ}))))")

#DIRECTORIES
export SHELL_PATH="/cluster/home/sigbjobo/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/shell"
export INPUT_PATH="/cluster/home/sigbjobo/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/INPUT_FILES"
export PYTHON_PATH="/cluster/home/sigbjobo/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/python"
export OCCAM_PATH="/cluster/home/sigbjobo/DNA/DNA_Hybrid_particle_field/../occam_dna_parallel/"
SCRATCH_DIRECTORY="${SCRATCH}"
SLURM_SUBMIT_DIR=$(pwd)


folder=sim_${kphi}_2

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

