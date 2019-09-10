#Sets path for scripts
A=$(pwd)
SHELL_PATH="${A}/OCCAM_AUX/shell"
JOB_PATH="${A}/OCCAM_AUX/JOBSCRIPTS/"
PYTHON_PATH="${A}/OCCAM_AUX/python"
INPUT_PATH="${A}/OCCAM_AUX/INPUT_FILES"
#OCCAM_PATH="${A}/../occam_dna_parallel/"
OCCAM_PATH="${A}/../occam_pressure_parallel/"
#OCCAM_PATH_SERIAL="${A}/../occam_dna/"
#EXTRA_PATH="/home/sigbjobo/Stallo/Projects/HPF/PLOT/python"
SCRATCH_DIRECTORY="\${SCRATCH}"


#FIX SHELL SCRIPTS
# sed -i 's|PYTHON_PATH=.*|PYTHON_PATH="'"$PYTHON_PATH"'"|g' ${SHELL_PATH}/*.sh
# sed -i 's|SHELL_PATH=.*|SHELL_PATH="'"$SHELL_PATH"'"|g' ${SHELL_PATH}/*.sh
# sed -i 's|INPUT_PATH=.*|INPUT_PATH="'"$INPUT_PATH"'"|g' ${SHELL_PATH}/*.sh


#FIX JOB SCRIPTS
sed -i 's|PYTHON_PATH=.*|PYTHON_PATH="'"$PYTHON_PATH"'"|g' ${JOB_PATH}/*.sh
sed -i 's|SHELL_PATH=.*|SHELL_PATH="'"$SHELL_PATH"'"|g' ${JOB_PATH}/*.sh
sed -i 's|INPUT_PATH=.*|INPUT_PATH="'"$INPUT_PATH"'"|g' ${JOB_PATH}/*.sh
sed -i 's|OCCAM_PATH=.*|OCCAM_PATH="'"$OCCAM_PATH"'"|g' ${JOB_PATH}/*.sh
sed -i 's|OCCAM_PRESSURE_PATH=.*|OCCAM_PRESSURE_PATH="'"$OCCAM_PRESSURE_PATH"'"|g' ${JOB_PATH}/*.sh



#sed -i '/\NPROC=/c\\export NPROC=${SLURM_NTASKS}' ${JOB_PATH}/*.sh



#FIX PYTHON SCRIPTS
# sed -i 's|PYTHON_PATH=.*|PYTHON_PATH="'"$PYTHON_PATH"'"|g' ${PYTHON_PATH}/*.py
# sed -i 's|SHELL_PATH=.*|SHELL_PATH="'"$SHELL_PATH"'"|g' ${PYTHON_PATH}/*.py
# sed -i 's|EXTRA_PATH=.*|EXTRA_PATH="'"$EXTRA_PATH"'"|g' ${PYTHON_PATH}/*.py
# sed -i 's|OCCAM_PATH=.*|OCCAM_PATH="'"$OCCAM_PATH"'"|g' ${PYTHON_PATH}/*.py

name_computer=$(uname -n)

#FIX SOME COMMON THINGS
sed -i  "/\bmodule load mpt\b/d" test  ${JOB_PATH}/*.sh


# Stallo
if [ "$name_computer" == "stallo-1.local" ] 
then
    echo 'Fixing jobscripts to fit Stallo'
    sed -i '/module load FFTW*/c\module load FFTW/3.3.8-intel-2018b'     ${JOB_PATH}/*.sh
    sed -i '/module load fftw*/c\module load FFTW/3.3.8-intel-2018b'     ${JOB_PATH}/*.sh
    sed -i '/module load intel*/c\module load intel/2018b'               ${JOB_PATH}/*.sh
    sed -i '/module load Python*/c\module load Python/3.6.6-intel-2018b' ${JOB_PATH}/*.sh 
    sed -i '/module load python*/c\module load Python/3.6.6-intel-2018b' ${JOB_PATH}/*.sh 
fi 

# Fram
if [ "$name_computer" == "login-1-2.fram.sigma2.no" ]
then
      
    echo 'Fixing jobscripts to fit Fram'
    
    sed -i '/module load FFTW*/c\module load FFTW/3.3.8-intel-2018b'      ${JOB_PATH}/*.sh
    sed -i '/module load fftw*/c\module load FFTW/3.3.8-intel-2018b'      ${JOB_PATH}/*.sh

    sed -i '/module load intel*/c\module load intel/2018b'                ${JOB_PATH}/*.sh
    sed -i '/module load Python*/c\module load Python/3.6.6-intel-2018b'  ${JOB_PATH}/*.sh 
    sed -i '/module load python*/c\module load Python/3.6.6-intel-2018b'  ${JOB_PATH}/*.sh 
    sed -i '/\#SBATCH --ntasks-per-node=/c\\#SBATCH --ntasks-per-node=40' ${JOB_PATH}/*.sh
fi

# Saga

# module load intel/2018b
# module load FFTW/3.3.8-intel-2019a
# module load Python/3.6.6-intel-2018b

# Vilje
if [ "$name_computer" == "service0" ]
then
    echo 'Fixing jobscripts to fit Vilje'
    sed -i '/module purge/a module load mpt/2.14'               ${JOB_PATH}/*.sh
    sed -i '/module load FFTW*/c\module load fftw/3.3.5'        ${JOB_PATH}/*.sh
    sed -i '/module load fftw*/c\module load fftw/3.3.5'        ${JOB_PATH}/*.sh
    sed -i '/module load intel*/c\module load intelcomp/17.0.0' ${JOB_PATH}/*.sh
    sed -i '/module load Python*/c\module load python/3.6.3'    ${JOB_PATH}/*.sh 
    sed -i '/module load python*/c\module load python/3.6.3'    ${JOB_PATH}/*.sh 
    
fi

#Abel
if [ "$name_computer" == "login-0-0.local" ] || [ "$name_computer" == "login-0-1.local" ]
then
    echo 'Fixing jobscripts to fit Abel'
    sed -i '/module load FFTW*/c\module load fftw/3.3.4' ${JOB_PATH}/*.sh
    sed -i '/module load fftw*/c\module load fftw/3.3.4' ${JOB_PATH}/*.sh
    sed -i '/module load intel*/c\module load intel/2019.2' ${JOB_PATH}/*.sh
    sed -i '/module load Python*/c\module load python3/3.5.0' ${JOB_PATH}/*.sh
    sed -i '/module load python*/c\module load python3/3.5.0' ${JOB_PATH}/*.sh 
    
fi



# if [ $(pwd | grep -eqcluster | wc | awk '{print $1}') -gt 0 ] 
# then
#     sed -i '/module load FFTW*/c\module load FFTW/3.3.8-intel-2018b' ${JOB_PATH}/*.sh
#     sed -i '/module load intel*/c\module load intel/2018b' ${JOB_PATH}/*.sh
#     sed -i '/\#SBATCH --ntasks=/c\\#SBATCH --nodes=4 --ntasks-per-node=40' ${JOB_PATH}/*.sh
#     sed -i '/module load Python*/c\module load Python/3.6.6-intel-2018b' ${JOB_PATH}/*.sh 
#     sed -i '/module load python*/c\module load Python/3.6.6-intel-2018b' ${JOB_PATH}/*.sh 
# fi
# if [ $(pwd | grep /home/sigbjobo | wc | awk '{print $1}') -gt 0 ] 
# then
#     sed -i '/module load FFTW*/c\module load FFTW/3.3.7-intel-2018a' ${JOB_PATH}/*.sh
#     sed -i '/module load intel*/c\module load intel/2018b' ${JOB_PATH}/*.sh
#     sed -i '/\#SBATCH --nodes=/c\\#SBATCH --ntasks=192' ${JOB_PATH}/*.sh
#     sed -i '/module load Python*/c\module load Python/3.7.0-intel-2018b' ${JOB_PATH}/*.sh 
#     sed -i '/module load python*/c\module load Python/3.7.0-intel-2018b' ${JOB_PATH}/*.sh 
# fi
   
# if [ $(pwd | grep /usit/abel | wc | awk '{print $1}') -gt 0 ] 
# then
#     sed -i '/module load FFTW*/c\module load FFTW' ${JOB_PATH}/*.sh
#     sed -i '/module load intel*/c\module load intel/2019.1' ${JOB_PATH}/*.sh
#     sed -i '/\#SBATCH --ntasks=/c\\#SBATCH --nodes=3 --ntasks-per-node=16' ${JOB_PATH}/*.sh
#     sed -i '/\#SBATCH --nodes=/c\\#SBATCH --nodes=3 --ntasks-per-node=16' ${JOB_PATH}/*.sh
#    sed -i '/module load Python*/c\module load python3/3.7.0' ${JOB_PATH}/*.sh
#    sed -i '/module load python*/c\module load python3/3.7.0' ${JOB_PATH}/*.sh 
## fi


