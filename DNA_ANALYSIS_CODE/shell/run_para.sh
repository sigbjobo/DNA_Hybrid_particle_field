#!/bin/bash -l
NPROCS=$1
#SBATCH --account=nn4654k
#SBATCH --job-name=DNA_PARALLEL
#SBATCH --time=20:00:00
#SBATCH --mem-per-cpu=2000M
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=${NPROC}

module load intel/2017.01
module load OpenMPI/2.0.1-iccifort-2017.1.132-GCC-5.4.0-2.26
module load FFTW/3.3.2
SHELL_PATH="/home/sigbjobo/Projects/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/shell"
OCCAM_PATH="/home/sigbjobo/Projects/DNA/OCCAM_DNA_parallel"

rm -r sim_${NPROC}
mkdir sim_${NPROC}

#Make occam
cd ${OCCAM_PATH}
rm *.o
make
cp occamcgmpi ${SLURM_SUBMIT_DIR}/sim
cd  ${SLURM_SUBMIT_DIR}


cp -r start_files/* sim/
cd sim_${NPROC} 
cp fort.5 fort.10
bash ${SHELL_PATH}/prep_iopc1.sh ${NPROC}
${OCCAM_PATH}/IOPC_input/iopc
rm fort.10

t1=$(time mpirun -n ${NPROC} occamcgmpi)

#IOPC BACK
bash ${SHELL_PATH}/prep_iopc2.sh ${NPROC}
${OCCAM_PATH}/IOPC_input/iopc


cd ..
 

#wait
exit 0
