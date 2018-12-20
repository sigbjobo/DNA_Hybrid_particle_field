#!/bin/bash -l
#SBATCH --account=nn4654k
#SBATCH --job-name=DNA_PARALLEL
#SBATCH --time=20:00:00
#SBATCH --mem-per-cpu=2000M
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
##SBATCH --error M23-39.err
##SBATCH --output M23-39.out
##SBATCH --qos=devel
##SBATCH --partition multinode

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
rm scaling_time.dat
for NPROC in "${NPROCS[@]}"
do
    rm -r sim
    mkdir sim

    #Make occam
    cd ${OCCAM_PATH}
    rm *.o
    make
    cp occamcgmpi ${SLURM_SUBMIT_DIR}/sim
    cd  ${SLURM_SUBMIT_DIR}
    

    cp -r start_files/* sim/
    cd sim 
    cp fort.5 fort.10
    bash ${SHELL_PATH}/prep_iopc1.sh ${NPROC}
    ${OCCAM_PATH}/IOPC_input/iopc
    rm fort.10
    
    t1=$(time mpirun -n ${NPROC} occamcgmpi)
    #IOPC BACK
    bash ${SHELL_PATH}/prep_iopc2.sh ${NPROC}
    ${OCCAM_PATH}/IOPC_input/iopc
    
    cd ..
    echo "${t1} ${NPROC}">>scaling_time.dat
   
done
#wait
exit 0
