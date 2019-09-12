#!/bin/bash
#SBATCH --job-name=MEMBRANES
#SBATCH --account=nn4654k
#SBATCH --time=0-24:00:0
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=16
#SBATCH --mem-per-cpu=2G
##SBATCH --qos=devel
#set -o errexit # exit on errors

#LOAD MODULES
# module purge

export LMOD_DISABLE_SAME_NAME_AUTOSWAP=no
module load intel/2018b
module load FFTW/3.3.8-intel-2019a
module load Python/3.6.6-intel-2018b

#DIRECTORIES
export SHELL_PATH="/cluster/home/sigbjobo/DNA_PRESSURE/DNA_Hybrid_particle_field/OCCAM_AUX/shell"
export INPUT_PATH="/cluster/home/sigbjobo/DNA_PRESSURE/DNA_Hybrid_particle_field/OCCAM_AUX/INPUT_FILES"
export PYTHON_PATH="/cluster/home/sigbjobo/DNA_PRESSURE/DNA_Hybrid_particle_field/OCCAM_AUX/python"
export OCCAM_PATH="/cluster/home/sigbjobo/DNA_PRESSURE/DNA_Hybrid_particle_field/../occam_pressure_parallel/"
SCRATCH_DIRECTORY="${SCRATCH}"
SLURM_SUBMIT_DIR=$(pwd)

#MANDATORY SETTINGS
export NPROC=${SLURM_NTASKS}
echo "NUMBER OF PROCESSORS USED: $NPROC"


# SINGLE SIMULATION
function_name () { 
    mem=$1
    p=$2
    update=$3
    cd $SCRATCH
    rm -rf temp/
    mkdir -p temp
    cd temp
    cp  ${INPUT_PATH}/MEMBRANE/${mem}/* .
     # SET a and KLM
    tens=$(cat tensionless_para_27.dat)
    klm=$(python3 -c "print('%.2f'%(float('$tens'.split()[0])))")
    a=$(python3 -c "print('%.2f'%(float('$tens'.split()[1])))")

    #SET fort.1
    bash ${SHELL_PATH}/change_fort1.sh eq_state_dens: ${a}
    bash ${SHELL_PATH}/change_fort1.sh simulated_ensemble: NPT
    bash ${SHELL_PATH}/change_fort1.sh number_of_steps: 1000000
    bash ${SHELL_PATH}/change_fort1.sh pressure_coupling: ${p}
    bash ${SHELL_PATH}/change_fort1.sh trj_print: 10000
    bash ${SHELL_PATH}/change_fort1.sh out_print: 5000
    bash ${SHELL_PATH}/change_fort1.sh print_pressure: 0
    bash ${SHELL_PATH}/change_fort1.sh virial_start: 1
    bash ${SHELL_PATH}/change_fort1.sh SCF_lattice_update: $update
    bash ${SHELL_PATH}/change_fort1.sh num_config_acc: 1

    #SET fort.3
    sed -i -e "s/KLM/${klm}/g" fort.3
    python3 $PYTHON_PATH/fix_fort3.py

   # bash ${SHELL_PATH}/run_para.sh
   # cp fort.9 fort.5
    bash ${SHELL_PATH}/run_para.sh
   
    folder=SIM_$update
    
    mkdir -p ${SLURM_SUBMIT_DIR}/$memi/$folder
    rm -rf ${SLURM_SUBMIT_DIR}/$memi/$folder/*
    mv * ${SLURM_SUBMIT_DIR}/$memi/$folder/
}


# SIMULATION SPECIFICATIONS
MEMS=("DOPC"    "DPPC" "DSPC"  "DMPC" "DOPC_BIG"    "DPPC_BIG" "DSPC_BIG"  "DMPC_BIG" )
pcouple=("3")
TEMPS=("303.00" "325"  "338.00" "323.00" "303.00" "325"  "338.00" "323.00")


#LOOPS
#Possible loop through membranes
# for i in {0..3};do
echo "SIMULATION ON MEMBRANE ${memi}"
# for j in {0..2};do
#j 
i=$1
j=$2
update=$3

memi="${MEMS[i]}"
pi="${pcouple[j]}"

cd ${SCRATCH_DIRECTORY}



function_name $memi $pi 


#done 

# POST ANALYSIS
cd ${SLURM_SUBMIT_DIR}/$memi/
bash ${SHELL_PATH}/comp_pressure_stats.sh
cd PRESSURE_DATA/
python3 $PYTHON_PATH/area_compressibility.py $tempi > area_compress.dat
cd ..

  # done 

wait
echo "DONE"

exit 0

 
 
