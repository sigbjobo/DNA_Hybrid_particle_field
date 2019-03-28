#!/bin/bash
#SBATCH --job-name=OPTIMIZE_DNA
#SBATCH --account=nn4654k
#SBATCH --time=0-0:30:00
#SBATCH --nodes=4 --ntasks-per-node=32
#SBATCH --qos=devel

export NPROC=128 #128
export NSTEPS=1000000
export NTRAJ=2500
export OPT_INIT_STEPS=1 #10 # 0
export OPT_STEPS=0 #30
export kphi=20

# Set up node file for namd run :
module purge
module load intel/2018b
module load FFTW/3.3.8-intel-2018b
module load Python/3.6.4-intel-2018a

SHELL_PATH="/cluster/home/sigbjobo/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/shell"
INPUT_PATH="/cluster/home/sigbjobo/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/INPUT_FILES"
PYTHON_PATH="/cluster/home/sigbjobo/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/python"
SCRATCH_DIRECTORY="/cluster/work/jobs/${SLURM_JOB_ID}"
SLURM_SUBMIT_DIR=$(pwd)

rm ${SLURM_SUBMIT_DIR}/sim -rf
mkdir -p ${SCRATCH_DIRECTORY}
cd ${SCRATCH_DIRECTORY}
mkdir sim
cd sim

#RUN OPTIMIZATION
python ${PYTHON_PATH}/occam_bayesian_2d.py ${OPT_INIT_STEPS} ${OPT_STEPS} ${kphi}

cp -r ${SCRATCH_DIRECTORY}/sim ${SLURM_SUBMIT_DIR}/sim
mkdir -p /cluster/projects/nn4654k/sigbjobo/${SLURM_JOB_ID}
cp -r ${SCRATCH_DIRECTORY}/sim /cluster/projects/nn4654k/sigbjobo/${SLURM_JOB_ID}/

rm -rf ${SCRATCH_DIRECTORY}

exit 0



#######

