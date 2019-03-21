#!/bin/bash -l
NPROC=$1
NMOLA=$2
#Setting directory to the current one
module load intel/2018b
module load FFTW/3.3.7-intel-2018a
module load Python/3.6.4-intel-2018a
CURRENT_DIREC=$(pwd)
SHELL_PATH="/home/sigbjobo/Documents/DNA_Project/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/shell"
OCCAM_PATH="/home/sigbjobo/Documents/DNA_Project/DNA_Hybrid_particle_field/../occam_dna_parallel/"
#NPROC=$(nproc)

echo "Number of proccessors: ${NPROC}"

#Compile OCCAM and IOPC
cd ${OCCAM_PATH}
rm -f *.o
rm *.mod
#bash compile_extra.sh
#make
cp occamcgmpi ${CURRENT_DIREC}/

#Compile IOPC
cd  ${OCCAM_PATH}/IOPC_input
#make
cp iopc ${CURRENT_DIREC}/


cd ${CURRENT_DIREC}/

#IOPC FORWARD
cp fort.5 fort.10
bash ${SHELL_PATH}/prep_iopc1_many.sh ${NPROC}  ${NMOLA}
${OCCAM_PATH}/IOPC_input/iopc
rm -f fort.10 fort.7

#Run OCCAM in parallel
srun -n ${NPROC} --mpi=pmi2  occamcgmpi
#IOPC BACK
bash ${SHELL_PATH}/prep_iopc2.sh ${NPROC}
${OCCAM_PATH}/IOPC_input/iopc

wait
