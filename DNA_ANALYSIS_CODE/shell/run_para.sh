#!/bin/bash -l

CURRENT_DIREC=$(pwd)
 
#echo "Number of proccessors: ${NPROC}"

#COMPILE OCCAM AND IOPC
if [ "$COMPILE" == "1" ]
then
    echo "COMPILING"
    cd ${OCCAM_PATH}
    rm -f *.o
    rm *.mod
    bash compile_extra.sh
    make
    cd  ${OCCAM_PATH}/IOPC_input
    bash compile.sh
    make
fi

cd ${CURRENT_DIREC}/
cp ${OCCAM_PATH}/occamcgmpi ${CURRENT_DIREC}/
cp ${OCCAM_PATH}/IOPC_input/iopc ${CURRENT_DIREC}/

#PREPARE IOPC FORWARD
cp fort.5 fort.10
bash ${SHELL_PATH}/prep_iopc1.sh

#RUN IOPC FORWARD
${OCCAM_PATH}/IOPC_input/iopc
rm -f fort.10 fort.7

#Run OCCAM in parallel 
srun --mpi=pmi2 -n ${NPROC} occamcgmpi

#PREPARE IOPC BACK
bash ${SHELL_PATH}/prep_iopc2.sh

#RUN IOPC BACK
${OCCAM_PATH}/IOPC_input/iopc

#MAKE A NEW FORT.9 FILE 
python ${PYTHON_PATH}/remake_fort9.py

#REMOVE START FILES FOR PARALLEL VERSION
rm *.[1-9][0-9][0-9]
rm *.[2-9][0-9]
