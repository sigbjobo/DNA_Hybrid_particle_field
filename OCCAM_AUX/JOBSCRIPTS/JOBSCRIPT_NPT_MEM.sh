#!/bin/bash
#SBATCH --job-name=MEMBRANES
#SBATCH --account=nn4654k
#SBATCH --time=0-4:00:0
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --mem-per-cpu=2G
##SBATCH --qos=devel
#set -o errexit # exit on errors

#LOAD MODULES
# module purge

export LMOD_DISABLE_SAME_NAME_AUTOSWAP=no
module load intel/2019.2
module load fftw/3.3.4
module load python3/3.5.0

#DIRECTORIES
export SHELL_PATH="/usit/abel/u1/sigbjobo/DNA_PRESSURE/DNA_Hybrid_particle_field/OCCAM_AUX/shell"
export INPUT_PATH="/usit/abel/u1/sigbjobo/DNA_PRESSURE/DNA_Hybrid_particle_field/OCCAM_AUX/INPUT_FILES"
export PYTHON_PATH="/usit/abel/u1/sigbjobo/DNA_PRESSURE/DNA_Hybrid_particle_field/OCCAM_AUX/python"
export OCCAM_PATH="/usit/abel/u1/sigbjobo/DNA_PRESSURE/DNA_Hybrid_particle_field/../occam_pressure_parallel/"
SCRATCH_DIRECTORY="${SCRATCH}"
SLURM_SUBMIT_DIR=$(pwd)

#MANDATORY SETTINGS
export NPROC=${SLURM_NTASKS}
echo "NUMBER OF PROCESSORS USED: $NPROC"


# SINGLE SIMULATION
function_name () { 
    mem=$1
    p=$2

    cd $SCRATCH
    rm -rf temp/
    mkdir -p temp
    cd temp
    cp  ${INPUT_PATH}/MEMBRANE/${mem}/* .
     # SET a and KLM
    tens=$(cat tensionless_para.dat)
    klm=$(python3 -c "print('%.2f'%(float('$tens'.split()[0])))")
    a=$(python3 -c "print('%.2f'%(float('$tens'.split()[1])))")

    
    sed -i "/eq_state_dens:/{n;s/.*/${a}/}" fort.1
    sed -i "/ensemble:/{n;s/.*/NPT/}" fort.1   
    sed -i "/pressure_coupling:/{n;s/.*/${p}/}" fort.1
   
    sed -i "/number_of_steps:/{n;s/.*/400000/}" fort.1
    sed -i "/press_print:/{n;s/.*/40000/}" fort.1
    sed -i "/trj_print:/{n;s/.*/20000/}" fort.1
    sed -i "/out_print:/{n;s/.*/20000/}" fort.1
    sed -i "/SCF_lattice_update:/{n;s/.*/5/}" fort.1
    sed -i "/num_config_acc:/{n;s/.*/1/}" fort.1
    
    sed -i -e "s/KLM/${klm}/g" fort.3
    python3 $PYTHON_PATH/fix_fort3.py

   bash ${SHELL_PATH}/run_para.sh
   cp fort.9 fort.5
    bash ${SHELL_PATH}/run_para.sh
    python3 ${PYTHON_PATH}/COMP_PRESSURE_PROFILES.py 1
    folder=SIM_${p}_${klm}
    
    mkdir -p ${SLURM_SUBMIT_DIR}/$memi/$folder
    rm -r ${SLURM_SUBMIT_DIR}/$memi/$folder/*
    mv * ${SLURM_SUBMIT_DIR}/$memi/$folder/
}


# SIMULATION SPECIFICATIONS
MEMS=("DOPC"    "DPPC" "DSPC"   "DMPC" "DPPC_BIG")
pcouple=( "0.2" "2" "20" )
TEMPS=("303.00" "325"  "338.00" "323.00")


#LOOPS
#Possible loop through membranes
# for i in {0..3};do
echo "SIMULATION ON MEMBRANE ${memi}"
for j in {0..2};do

i=$1
#j=$2
memi="${MEMS[i]}"
pi="${pcouple[j]}"
tempi="${TEMPS[i]}"

cd ${SCRATCH_DIRECTORY}



function_name $memi $pi 

mkdir -p ${SLURM_SUBMIT_DIR}/$memi
mv  ${SCRATCH_DIRECTORY}/SIM_* ${SLURM_SUBMIT_DIR}/$memi/

#done 

# POST ANALYSIS
cd ${SLURM_SUBMIT_DIR}/$memi/
bash ${SHELL_PATH}/comp_pressure_stats.sh
cd PRESSURE_DATA/
python3 $PYTHON_PATH/area_compressibility.py $tempi > area_compress.dat
cd ..
 done 

wait
echo "DONE"

exit 0

 
 
