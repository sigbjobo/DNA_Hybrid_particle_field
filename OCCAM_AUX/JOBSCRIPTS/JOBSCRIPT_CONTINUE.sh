#!/bin/bash
#SBATCH --job-name=PER_SINGLE
#SBATCH --account=nn4654k
#SBATCH --time=3-0:00:0
#SBATCH --ntasks=192
#SBATCH --ntasks=192
#SBATCH --ntasks-per-node=40
#SBATCH --mem-per-cpu=2G

set -o errexit # exit on errors

#LOAD MODULES
#module purge
module load mpt/2.14
module load intelcomp/17.0.0
module load intelcomp/17.0.0
export LMOD_DISABLE_SAME_NAME_AUTOSWAP=no
module load intelcomp/17.0.0
module load fftw/3.3.5
module load python/3.6.3

#MANDATORY SETTINGS
export NPROC=${SLURM_NTASKS}
export NSOLUTE=1
echo "NUMBER OF PROCESSORS USED: $NPROC"

#DIRECTORIES
export SHELL_PATH="/home/ntnu/sigbjobo/DNA_PRESSURE/DNA_Hybrid_particle_field/OCCAM_AUX/shell"
export INPUT_PATH="/home/ntnu/sigbjobo/DNA_PRESSURE/DNA_Hybrid_particle_field/OCCAM_AUX/INPUT_FILES"
export PYTHON_PATH="/home/ntnu/sigbjobo/DNA_PRESSURE/DNA_Hybrid_particle_field/OCCAM_AUX/python"
export OCCAM_PATH="/home/ntnu/sigbjobo/DNA_PRESSURE/DNA_Hybrid_particle_field/../occam_pressure_parallel/"
SCRATCH_DIRECTORY="${SCRATCH}"
SLURM_SUBMIT_DIR=$(pwd)


#PREPARE ${FOLDER}ULATION DIRECTORY
mkdir -p ${SCRATCH_DIRECTORY}
cd ${SCRATCH_DIRECTORY}

#reorder old files
cp -r ${SLURM_SUBMIT_DIR}/* .
[ -f sim.xyz ] && mv sim.xyz fort.8
mv fort.8 sim.xyz
cp fort.5 old.5
mv fort.9 fort.5

#RUN SIMULATION IN PARALLEL
bash ${SHELL_PATH}/run_para.sh 
cat fort.8 >> sim.xyz
rm fort.8

#SAVE DATA
cp -r ${SCRATCH_DIRECTORY}/* ${SLURM_SUBMIT_DIR}/

wait
 
exit 0







#######

