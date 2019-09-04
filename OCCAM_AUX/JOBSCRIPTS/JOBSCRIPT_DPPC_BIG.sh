#!/bin/bash
#SBATCH --job-name=PER_SINGLE
#SBATCH --account=nn4654k
#SBATCH --time=0-48:00:0
#SBATCH --nodes=6
#SBATCH --ntasks-per-node=40
#SBATCH --mem-per-cpu=4G
##SBATCH --error=sim.err
#rm sim.err

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

rm  -rf SIM_*


tens=$(cat tensionless_para.dat)
klm=$(python -c "print('%.2f'%(float('$tens'.split()[0])))")
a=$(python -c "print('%.2f'%(float('$tens'.split()[1])))")

cd ${SCRATCH_DIRECTORY}


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
    cp -r ${INPUT_PATH}/MEM_DSPC/* .
    cp 

    python ${PYTHON_PATH}/multiply_syst.py 4 4 1
    mv fort.5_2 fort.5
    NATOM=$(tail fort.5 -n 1 | awk '{print $1}') 

    #Set compressibility
 
    sed -i "/eq_state_dens:/{n;s/.*/${a}/}" fort.1
    sed -i "/pressure_coupling:/{n;s/.*/${p}/}" fort.1
    sed -i "/ensemble:/{n;s/.*/NVT_Andersen/}" fort.1
    sed -i "/semi_iso:/{n;s/.*/1/}" fort.1
    sed -i "/press_print:/{n;s/.*/1000000/}" fort.1
    sed -i "/trj_print:/{n;s/.*/10000/}" fort.1
    sed -i "/out_print:/{n;s/.*/100/}" fort.1
    sed -i "/number_of_steps:/{n;s/.*/1000/}" fort.1
    sed -i "/atoms:/{n;s/.*/${NATOM}/}" fort.1
	
    
    sed -i -e "s/KLM/${klm}/g" fort.3
    sed -i "/* compressibility/{n;s/.*/${k}/}" fort.3
    bash ${SHELL_PATH}/run_para.sh
    mv fort.9 fort.5
    sed -i "/ensemble:/{n;s/.*/NPT/}" fort.1
    sed -i "/trj_print:/{n;s/.*/50000/}" fort.1
    sed -i "/out_print:/{n;s/.*/10000/}" fort.1
    sed -i "/number_of_steps:/{n;s/.*/1000000/}" fort.1
    bash ${SHELL_PATH}/run_para.sh
	
#    python ${PYTHON_PATH}/COMP_PRESSURE_PROFILES.py 1
    cd ..    
}


KLM=("$klm")

komp=( "0.05" )
pcouple=( "20" )
 
for p in "${pcouple[@]}";do
    for k in "${komp[@]}";do
	for klm in "${KLM[@]}";do
	    function_name $p $k ${klm} 
	done
    done
done 
mv * ${SLURM_SUBMIT_DIR}/
cd  ${SLURM_SUBMIT_DIR}/
bash ${SHELL_PATH}/comp_pressure_stats.sh

wait
echo "DONE"

exit 0

 
 
