#!/bin/bash
#SBATCH --job-name=MEMBRANES
#SBATCH --account=nn4654k
#SBATCH --time=0-0:10:0
#SBATCH --ntasks=10
#SBATCH --mem-per-cpu=2G
##SBATCH --qos=devel
#set -o errexit # exit on errors

#LOAD MODULES
# module purge

export LMOD_DISABLE_SAME_NAME_AUTOSWAP=no
module load intel/2018b
module load FFTW/3.3.8-intel-2018b
module load Python/3.6.6-intel-2018b

#DIRECTORIES
export SHELL_PATH="/home/sigbjobo/DNA_PRESSURE/DNA_Hybrid_particle_field/OCCAM_AUX/shell"
export INPUT_PATH="/home/sigbjobo/DNA_PRESSURE/DNA_Hybrid_particle_field/OCCAM_AUX/INPUT_FILES"
export PYTHON_PATH="/home/sigbjobo/DNA_PRESSURE/DNA_Hybrid_particle_field/OCCAM_AUX/python"
export OCCAM_PATH="/home/sigbjobo/DNA_PRESSURE/DNA_Hybrid_particle_field/../occam_pressure_parallel/"
SCRATCH_DIRECTORY="${SCRATCH}"
SLURM_SUBMIT_DIR=$(pwd)

#MANDATORY SETTINGS
export NPROC=${SLURM_NTASKS}
echo "NUMBER OF PROCESSORS USED: $NPROC"

rm  -rf SIM_*

function_name () { 
    mem=$1
    p=$2

# SET a and KLM
    tens=$(cat tensionless_para.dat)
    klm=$(python -c "print('%.2f'%(float('$tens'.split()[0])))")
    a=$(python -c "print('%.2f'%(float('$tens'.split()[1])))")
    
    
    folder=SIM_${p}_${klm}
    mkdir $folder
    cd $folder
    cp  ${INPUT_PATH}/MEMBRANE/${mem}/* .
   
    
    sed -i "/eq_state_dens:/{n;s/.*/${a}/}" fort.1
    sed -i "/ensemble:/{n;s/.*/NPT/}" fort.1   
    sed -i "/pressure_coupling:/{n;s/.*/${p}/}" fort.1
    sed -i "/target_temperature:/{n;s/.*/${temp} 0/}" fort.1
    sed -i "/number_of_steps:/{n;s/.*/100000/}" fort.1
    sed -i "/press_print:/{n;s/.*/20000/}" fort.1
    sed -i "/trj_print:/{n;s/.*/5000/}" fort.1
    sed -i "/out_print:/{n;s/.*/1000/}" fort.1
  

    sed -i -e "s/KLM/${klm}/g" fort.3
    python $PYTHON_PATH/fix_fort3.py

    # bash ${SHELL_PATH}/run_para.sh
    # cp fort.9 fort.5
    bash ${SHELL_PATH}/run_para.sh
    python ${PYTHON_PATH}/COMP_PRESSURE_PROFILES.py 1
    cd ..    
}

MEMS=("DOPC"    "DPPC" "DSPC"   "DMPC" "DPPC_BIG")
pcouple=(  "20" "200" "2000" "20000" )

#Possible loop through membranes
# for i in {0..3};do
# for j in {0..3};do

i=$1
j=$2
memi="${MEMS[i]}"
pi="${pcouple[j]}"
cd ${SCRATCH_DIRECTORY}

echo "SIMULATION ON MEMBRANE ${memi}"

function_name $memi $pi 
mkdir -p ${SLURM_SUBMIT_DIR}/$memi
mv  ${SCRATCH_DIRECTORY}/SIM_* ${SLURM_SUBMIT_DIR}/$memi/



#cd ..

# done 
# done
cd  ${SLURM_SUBMIT_DIR}/$memi
bash ${SHELL_PATH}/comp_pressure_stats.sh
wait
echo "DONE"

exit 0

 
 
