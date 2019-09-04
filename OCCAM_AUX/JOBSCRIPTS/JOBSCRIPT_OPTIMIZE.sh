#!/bin/bash
#SBATCH --job-name=OPTIMIZE_DNA
#SBATCH --account=nn4654k
#SBATCH --time=3-0:00:0
#SBATCH --ntasks=192
#SBATCH --ntasks=192
#SBATCH --mem-per-cpu=2G
##SBATCH --qos=devel
set -o errexit # exit on errors

#LOAD MODULES
#module purge
export LMOD_DISABLE_SAME_NAME_AUTOSWAP=no
module load intel/2019.2

module load fftw/3.3.4
module load python3/3.5.0

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
export EPS=$1
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
export SHELL_PATH="/usit/abel/u1/sigbjobo/DNA_PRESSURE/DNA_Hybrid_particle_field/OCCAM_AUX/shell"
export INPUT_PATH="/usit/abel/u1/sigbjobo/DNA_PRESSURE/DNA_Hybrid_particle_field/OCCAM_AUX/INPUT_FILES"
export PYTHON_PATH="/usit/abel/u1/sigbjobo/DNA_PRESSURE/DNA_Hybrid_particle_field/OCCAM_AUX/python"
export OCCAM_PATH="/usit/abel/u1/sigbjobo/DNA_PRESSURE/DNA_Hybrid_particle_field/../occam_pressure_parallel/"
SCRATCH_DIRECTORY="${SCRATCH}"
SLURM_SUBMIT_DIR=$(pwd)


folder=sim_${kphi}_$EPS

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

