#!/bin/bash
#SBATCH --job-name=PER_SINGLE
#SBATCH --account=nn4654k
#SBATCH --time=0-12:00:0
#SBATCH --nodes=1
#SBATCH --ntasks=20
#SBATCH --mem-per-cpu=2G
##SBATCH --error=sim.err
#rm sim.err

#set -o errexit # exit on errors

#LOAD MODULES
# module purge

export LMOD_DISABLE_SAME_NAME_AUTOSWAP=no
module load intel/2018b 
module load FFTW/3.3.8-intel-2019a
module load Python/3.6.6-intel-2018b

#DIRECTORIES
export SHELL_PATH="/cluster/home/sigbjobo/DNA/HPF/OCCAM_AUX/shell"
export INPUT_PATH="/cluster/home/sigbjobo/DNA/HPF/OCCAM_AUX/INPUT_FILES"
export PYTHON_PATH="/cluster/home/sigbjobo/DNA/HPF/OCCAM_AUX/python"
export OCCAM_PATH="/cluster/home/sigbjobo/DNA/HPF/../occam_pressure_parallel"
SCRATCH_DIRECTORY="${SCRATCH}"
SLURM_SUBMIT_DIR=$(pwd)

#MANDATORY SETTINGS
export NPROC=${SLURM_NTASKS}
echo "NUMBER OF PROCESSORS USED: $NPROC"

rm  -rf SIM_*

cd ${SCRATCH_DIRECTORY}
export a=9.435 

#REMOVE OLD SIMULATIONS

function_name () { 
    
    #pcouple
    p=$1

    #kompressibility
    k=$2

    klm=$3
    
    folder=SIM_${p}_${k}_${klm}
    mkdir $folder
    cd $folder
    cp -r ${INPUT_PATH}/MEM3/* .
    
    #Set compressibility
    sed -i "/* compressibility/{n;s/.*/${k}/}" fort.3
    sed -i "/eq_state_dens:/{n;s/.*/${a}/}" fort.1
    sed -i "/pressure_coupling:/{n;s/.*/${p}/}" fort.1
    sed -i -e "s/KLM/${klm}/g" fort.3

    bash ${SHELL_PATH}/run_para.sh
    cp fort.9 fort.5
    bash ${SHELL_PATH}/run_para.sh
    python ${PYTHON_PATH}/COMP_PRESSURE_PROFILES.py 1
    cd ..    
}

#

# function_name 20 0.05 0 &
# function_name 20 0.05 1 &
# function_name 20 0.05 2 &
# function_name 20 0.05 3 &
# function_name 20 0.05 4 &
# function_name 20 0.05 5 &
# function_name 20 0.05 6 &

KLM=("0" "-2"  "-4" "-5" "-6" "-7" "-8" "-9" "-10" "-12" "-15" )
komp=( "0.05" )
pcouple=( "20" )
 
for p in "${pcouple[@]}";do
    for k in "${komp[@]}";do
	for klm in "${KLM[@]}";do
	    function_name $p $k ${klm} 
	done
    done
done 
cp -r SIM_* ${SLURM_SUBMIT_DIR}/
bash ${SHELL_PATH}/comp_pressure_stats.sh
wait
echo "DONE"

exit 0

 
 