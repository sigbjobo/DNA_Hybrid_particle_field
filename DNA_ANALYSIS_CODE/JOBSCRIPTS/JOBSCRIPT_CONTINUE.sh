#!/bin/bash
#SBATCH --job-name=PER_SINGLE
#SBATCH --account=nn4654k
#SBATCH --time=3-0:00:0
##SBATCH --ntasks=180
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=40
#SBATCH --mem-per-cpu=2G

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
export NSOLUTE=1
echo "NUMBER OF PROCESSORS USED: $NPROC"

#DIRECTORIES
export SHELL_PATH="/cluster/home/sigbjobo/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/shell"
export INPUT_PATH="/cluster/home/sigbjobo/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/INPUT_FILES"
export PYTHON_PATH="/cluster/home/sigbjobo/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/python"
export OCCAM_PATH="/cluster/home/sigbjobo/DNA/DNA_Hybrid_particle_field/../occam_dna_parallel/"
SCRATCH_DIRECTORY="${SCRATCH}"
SLURM_SUBMIT_DIR=$(pwd)


#PREPARE ${FOLDER}ULATION DIRECTORY
mkdir -p ${SCRATCH_DIRECTORY}
cd ${SCRATCH_DIRECTORY}

#reorder old files
cp -r ${SLURM_SUBMIT_DIR}/* .
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

