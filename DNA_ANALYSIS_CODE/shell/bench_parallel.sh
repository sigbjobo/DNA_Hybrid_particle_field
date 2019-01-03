#!/bin/bash -l

#SBATCH --account=nn4654k
#SBATCH --job-name=DNA_PARALLEL
#SBATCH --time=5:30:00
#SBATCH --mem-per-cpu=2000M
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
##SBATCH --error M23-39.err
##SBATCH --output M23-39.out
##SBATCH --qos=devel
##SBATCH --partition multinode

set -o errexit # exit on errors
module load intel/2017.01
module load OpenMPI/2.0.1-iccifort-2017.1.132-GCC-5.4.0-2.26
module load FFTW/3.3.2
SHELL_PATH="/home/sigbjobo/Projects/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/shell"
OCCAM_PATH="/home/sigbjobo/Projects/DNA/OCCAM_DNA_parallel"



NPROCS[0]="1"
NPROCS[2]="2"
NPROCS[3]="4"
NPROCS[4]="8"
NPROCS[5]="16"
rm -f scaling_time.dat
for NPROC in "${NPROCS[@]}"
do
    echo "${NPROC}"
    rm -rf sim
    mkdir sim

    #Make occam
    cd ${OCCAM_PATH}
    rm -f *.o
    make
   
    cp occamcgmpi ${SLURM_SUBMIT_DIR}/sim

    cd  ${OCCAM_PATH}/IOPC_input
    make

    cd  ${SLURM_SUBMIT_DIR}
    
 
    cp -r start_files/* sim/
    cd sim 
    cp fort.5 fort.10
    bash ${SHELL_PATH}/prep_iopc1.sh ${NPROC}
    ${OCCAM_PATH}/IOPC_input/iopc
    rm -f fort.10
    
    start=`date +%s`
    mpirun -n ${NPROC} occamcgmpi
    end=`date +%s`
    t1=$((end-start))

    wait 
    #IOPC BACK
    bash ${SHELL_PATH}/prep_iopc2.sh ${NPROC}
    ${OCCAM_PATH}/IOPC_input/iopc
     
    cd ${SLURM_SUBMIT_DIR}
    echo "${NPROC} ${t1}" >> scaling_time.dat
    echo "${NPROC} ${t1}"
done
#wait
exit 0
