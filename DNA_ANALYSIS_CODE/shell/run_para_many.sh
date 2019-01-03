#!/bin/bash -l
NPROC=$1
NMOLA=$2
#Setting directory to the current one
CURRENT_DIREC=$(pwd)
SHELL_PATH="/home/sigbjobo/Projects/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/shell"
OCCAM_PATH="/home/sigbjobo/Projects/DNA/OCCAM_DNA_parallel"
#NPROC=$(nproc)

echo "Number of proccessors: ${NPROC}"


#Compile OCCAM and IOPC
cd ${OCCAM_PATH}
rm -f *.o
make
cp occamcgmpi ${CURRENT_DIREC}/

#Compile IOPC
cd  ${OCCAM_PATH}/IOPC_input
make
cp iopc ${CURRENT_DIREC}/


cd ${CURRENT_DIREC}/



#IOPC FORWARD
cp fort.5 fort.10
bash ${SHELL_PATH}/prep_iopc1_many.sh ${NPROC}  ${NMOLA}
${OCCAM_PATH}/IOPC_input/iopc
rm -f fort.10 fort.7

#Run OCCAM in parallel
mpirun -n ${NPROC} ./occamcgmpi

#IOPC BACK
bash ${SHELL_PATH}/prep_iopc2.sh ${NPROC}
${OCCAM_PATH}/IOPC_input/iopc


wait 
exit 0
