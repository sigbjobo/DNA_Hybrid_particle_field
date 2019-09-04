#!/bin/bash
#SBATCH --job-name=PER_SINGLE
#SBATCH --account=nn4654k
#SBATCH --time=0-12:00:0
##SBATCH --nodes=1
#SBATCH --ntasks=20
#SBATCH --mem-per-cpu=2G
##SBATCH --error=sim.err
#rm sim.err

# JOBSCRIPT FOR RUNNING WATER SIMULATIONS WITH DIFFERENT KAPPA
# AND DETERMINING EQUATION OF STATE


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


function_name () { 
    # Folder

    #pcouple
    pcouple=$1

    #kompressibility
    komp=$2

   
    RHO0=$3
    
    folder=SIM_${komp}
    mkdir $folder
    cd $folder
    cp ../INPUT/* .
    
    a=0 #$(python -c "print((69.24 + 345.39*float('$komp') + 15.56*float('$komp')**0.61)**0.5)")
    echo $komp $a
 
    sed -i "/* compressibility/{n;s/.*/${komp}/}" fort.3
    sed -i "/* rho0:/{n;s/.*/${RHO0}/}" fort.3
    sed -i "/eq_state_dens:/{n;s/.*/${a}/}" fort.1
    sed -i "/ensemble:/{n;s/.*/NVT_Andersen/}" fort.1
    sed -i "/pressure_coupling:/{n;s/.*/${pcouple}/}" fort.1
    bash ${SHELL_PATH}/run_para.sh
    mv fort.9 fort.5
    bash ${SHELL_PATH}/run_para.sh

    cd ..
}

#komp=( "0.03" "0.05" "0.10")
komp=( "0.01" "0.02" "0.03" "0.04" "0.05" "0.06" "0.07" "0.08" "0.09" "0.10")
p=("20")
r=( "8.33" )

rm -rf SIM_* INPUT
cd ${SCRATCH}
mkdir INPUT
cd INPUT
cp ${INPUT_PATH}/WATER/* .
python ${PYTHON_PATH}/water_box.py 10 8.33	    
cd ..
for k in "${komp[@]}";do
    for pi in "${p[@]}";do
	function_name $pi $k $r 
    done
done

bash ${SHELL_PATH}/comp_pressure_stats.sh
python ${PYTHON_PATH}/find_a_para_water.py pressavg_mean.dat
cp  -r SIM_* PRESSURE_DATA ${SLURM_SUBMIT_DIR}/
wait
echo "DONE"

exit 0

 
 
