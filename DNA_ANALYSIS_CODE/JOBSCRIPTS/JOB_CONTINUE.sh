#!/bin/bash
#SBATCH --job-name=OPTIMIZE_DNA
#SBATCH --account=nn4654k
#SBATCH --time=3-0:0:0
#SBATCH --nodes=6 --ntasks-per-node=32
##SBATCH --qos=devel

#MANDATORY SETTINGS
export NPROC=192 #192
export COMPILE=0
export NSOLUTE=1



 
#SETTINGS SPECIFIC TO BAYSIAN OPTIMIZATION
export NSTEPS=100000000
export dna_seq=AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA

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

#PREPARE SIMULATION DIRECTORY
mkdir -p ${SCRATCH_DIRECTORY}
cd ${SCRATCH_DIRECTORY}

folder=$1
mkdir ${folder}
cd ${folder}
cp -r ${SLURM_SUBMIT_DIR}/${folder}/*
cp fort.5 fort.5_store
mv fort.9 fort.5
mv fort.8 sim.xyz

#Set number of atoms                                                                                                    
sed -i "/number_of_steps:/{n;s/.*/$NSTEPS/}" fort.1

#RUN SIMULATION
bash ${SHELL_PATH}/run_para.sh
cat fort.8 >> sim.xyz


#SAVE DATA
cp -r ${SCRATCH_DIRECTORY}/${folder} ${SLURM_SUBMIT_DIR}/${folder}


exit 0



#######

