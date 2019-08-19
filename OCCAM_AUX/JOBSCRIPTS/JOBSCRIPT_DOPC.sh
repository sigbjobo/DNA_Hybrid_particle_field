#!/bin/bash
#SBATCH --job-name=PER_SINGLE
#SBATCH --account=nn4654k
#SBATCH --time=0-12:00:0
##SBATCH --nodes=1
#SBATCH --ntasks=20
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

rm  -rf SIM_*

cd ${SCRATCH_DIRECTORY}
export a=0

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
    cp -r ${INPUT_PATH}/MEM_DOPC/* .
    
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
cd  ${SLURM_SUBMIT_DIR}/
bash ${SHELL_PATH}/comp_pressure_stats.sh
cd PRESSURE_DATA/
python ${PYTHON_PATH}/find_a_para.py pressavg_mean.dat 0 0.05
python ${PYTHON_PATH}/fit_polynomial.py klm_a.dat
python ${PYTHON_PATH}/fit_polynomial.py pressxxavg_mean.dat
python ${PYTHON_PATH}/fit_polynomial.py presszzavg_mean.dat
klm=$(python ${PYTHON_PATH}/solve_poly.py presszzavg_mean_polyfit.dat pressxxavg_mean_polyfit.dat)
a=$(python ${PYTHON_PATH}/polyfit_value.py klm_a_polyfit.dat $klm)

echo "TENSIONLESS MEMBRANE: Klm=$klm a=$a"
echo $klm $a > tensionless_para.dat
cd ..
wait
echo "DONE"

exit 0

 
 
