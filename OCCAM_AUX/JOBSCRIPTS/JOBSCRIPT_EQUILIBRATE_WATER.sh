#!/bin/bash
#SBATCH --job-name=PER_SINGLE
#SBATCH --account=nn4654k
#SBATCH --time=0-12:00:0
##SBATCH --nodes=1
#SBATCH --ntasks=5
#SBATCH --mem-per-cpu=2G
##SBATCH --error=sim.err
#rm sim.err

#set -o errexit # exit on errors

#LOAD MODULES
# module purge
module load mpt/2.14

export LMOD_DISABLE_SAME_NAME_AUTOSWAP=no
module load intelcomp/17.0.0
module load fftw/3.3.5
module load python/3.6.3

#DIRECTORIES
export SHELL_PATH="/home/ntnu/sigbjobo/DNA_PRESSURE/DNA_Hybrid_particle_field/OCCAM_AUX/shell"
export INPUT_PATH="/home/ntnu/sigbjobo/DNA_PRESSURE/DNA_Hybrid_particle_field/OCCAM_AUX/INPUT_FILES"
export PYTHON_PATH="/home/ntnu/sigbjobo/DNA_PRESSURE/DNA_Hybrid_particle_field/OCCAM_AUX/python"
export OCCAM_PATH="/home/ntnu/sigbjobo/DNA_PRESSURE/DNA_Hybrid_particle_field/../occam_pressure_parallel/"
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
    
    folder=SIM_${komp}_${pcouple}
    mkdir $folder
    cd $folder
    cp ../INPUT/* .
    
#    a=$(python -c "print((69.24 + 345.39*float('$komp') + 15.56*float('$komp')**0.61)**0.5)")
    a=$(python -c "print(15.02*float('$komp')**0.86 +8.296)")
    echo $komp $a
 
    sed -i "/* compressibility/{n;s/.*/${komp}/}" fort.3
    sed -i "/* rho0:/{n;s/.*/${RHO0}/}" fort.3
    sed -i "/eq_state_dens:/{n;s/.*/${a}/}" fort.1
    sed -i "/pressure_coupling:/{n;s/.*/${pcouple}/}" fort.1
    bash ${SHELL_PATH}/run_para.sh
    
    cd ..
   

}


#pcouple=("2" "5" "20" "100" "200")
#komp=("0.1" "0.05" "0.03")
komp=( "0.03" "0.05" "0.10")
p=("20" )
r=( "8.33" )

rm -rf SIM_* INPUT
cd ${SCRATCH}
mkdir INPUT
cd INPUT
cp ${INPUT_PATH}/WATER/* .
python ${PYTHON_PATH}/water_box.py 9.688 9.163	    
cd ..
for k in "${komp[@]}";do
    for pi in "${p[@]}";do
	function_name $pi $k $r 
    done
done

cp -r SIM_* ${SLURM_SUBMIT_DIR}/

cd ${SLURM_SUBMIT_DIR}/
bash ${SHELL_PATH}/comp_pressure_stats.sh
wait
echo "DONE"

exit 0

 
 
