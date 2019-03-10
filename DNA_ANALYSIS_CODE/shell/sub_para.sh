#!/bin/bash -l

#SBATCH --account=nn4654k
#SBATCH --job-name=DNA_PARALLEL
#SBATCH --time=7-0:00:00
##SBATCH --mem-per-cpu=2000M
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4

set -o errexit # exit on errors

module load intel/2018b
module load OpenMPI/2.0.1-iccifort-2017.1.132-GCC-5.4.0-2.26
module load FFTW/3.3.8-intel-2018b

SHELL_PATH="/cluster/home/sigbjobo/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/shell"
OCCAM_PATH="/cluster/home/sigbjobo/DNA/DNA_Hybrid_particle_field/../occam_dna_parallel/"
NPROC=$(nproc)

echo "Number of proccessors: ${NPROC}"
rm -rf sim
mkdir sim


#Compile OCCAM and IOPC
cd ${OCCAM_PATH}
rm -f *.o
make

#Compile IOPC
cd  ${OCCAM_PATH}/IOPC_input
make


cd $SCRATCH
cp -r  ${SLURM_SUBMIT_DIR}/* $SCRATCH/



cp -r start_files/* sim/
cd sim 
cp fort.5 fort.10

#IOPC FORWARD
bash ${SHELL_PATH}/prep_iopc1.sh ${NPROC}
${OCCAM_PATH}/IOPC_input/iopc
rm -f fort.10

#Run OCCAM in parallel
mpirun -n ${NPROC} ${OCCAM_PATH}/occamcgmpi

#IOPC BACK
bash ${SHELL_PATH}/prep_iopc2.sh ${NPROC}
${OCCAM_PATH}/IOPC_input/iopc

#Copy back files
cp ${SCRATCH}/sim/ ${SLURM_SUBMIT_DIR}/
rm -rf ${SCRATCH}

#SBATCH --signal=B:USR1@500
your_cleanup_function()
{
echo "function your_cleanup_function called at $(date)"
cp -r ${SCRATCH}/sim ${SLURM_SUBMIT_DIR}
rm -rf ${SCRATCH}
}

wait 
exit 0
