#!/bin/bash -l

module load intel/2018b
module load FFTW/3.3.7-intel-2018a
module load Python/3.6.4-intel-2018a

CURRENT_DIREC=$(pwd)
 
echo "Number of proccessors: ${NPROC}"

#COMPILE OCCAM AND IOPC
if [ COMPILE==1 ]
then
    cd ${OCCAM_PATH}
    rm -f *.o
    rm *.mod
    bash compile_extra.sh
    make
    cd  ${OCCAM_PATH}/IOPC_input
    make
fi

cd ${CURRENT_DIREC}/
cp ${OCCAM_PATH}/occamcgmpi ${CURRENT_DIREC}/
cp ${OCCAM_PATH}/IOPC_input/iopc ${CURRENT_DIREC}/



#PREPARE IOPC FORWARD
cp fort.5 fort.10
bash ${SHELL_PATH}/prep_iopc1.sh ${NPROC}

#RUN IOPC FORWARD
${OCCAM_PATH}/IOPC_input/iopc
rm -f fort.10 fort.7


#Run OCCAM in parallel
srun -n ${NPROC} --mpi=pmi2  occamcgmpi


#PREPARE IOPC BACK
bash ${SHELL_PATH}/prep_iopc2.sh

#RUN IOPC BACK
${OCCAM_PATH}/IOPC_input/iopc

wait
