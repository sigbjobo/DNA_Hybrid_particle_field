#!/bin/bash -l
#SBATCH --account=nn4654k
#SBATCH --job-name=DNA_PARALLEL
#SBATCH --time=0-24:00:00
#SBATCH --mem-per-cpu=2000M
##SBATCH --partition=singlenode
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4

set -o errexit # exit on errors
module load intel/2017.01
module load OpenMPI/2.0.1-iccifort-2017.1.132-GCC-5.4.0-2.26
module load FFTW/3.3.2
SHELL_PATH="/home/sigbjobo/Projects/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/shell"
OCCAM_PATH="/home/sigbjobo/Projects/DNA/OCCAM_DNA_parallel"
SCRATCH_DIRECTORY=/global/work/${USER}/${SLURM_JOBID}.stallo-adm.uit.no
mkdir ${SLURM_SUBMIT_DIR}/OUTPUT

NPROC=4

cp -rf ${SLURM_SUBMIT_DIR}/{fort.*,FF} ${SCRATCH_DIRECTORY}/
cd $SCRATCH_DIRECTORY
bash ${SHELL_PATH}/run_para.sh $NPROC

cp -rf ${SCRATCH_DIRECTORY}/* ${SLURM_SUBMIT_DIR}/OUTPUT/
rm -rf ${SCRATCH_DIRECTORY}


#SBATCH --signal=B:USR1@500
your_cleanup_function()
{
echo "function your_cleanup_function called at $(date)"
cp -rf ${SCRATCH_DIRECTORY}/* ${SLURM_SUBMIT_DIR}/OUTPUT/
rm -rf ${SCRATCH_DIRECTORY}
}
# call your_cleanup_function once we receive USR1 signal
trap 'your_cleanup_function' USR1
echo "starting calculation at $(date)"
sleep 500 &
wait
#wait
exit 0
