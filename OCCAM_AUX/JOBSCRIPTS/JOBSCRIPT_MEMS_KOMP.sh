#!/bin/bash
#SBATCH --job-name=MEMBRANES
#SBATCH --account=nn4654k
#SBATCH --time=0-2:00:0
#SBATCH --nodes=1 --ntasks-per-node=20
#SBATCH  --mem-per-cpu=2G
##SBATCH --qos=devel
set -o errexit # exit on errors

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

rm  -rf SIM_*


#REMOVE OLD SIMULATIONS
a=0

function_name () { 
    
    #pcouple
    case 
mem=$1
    klm=$2
    komp=$3
    
    folder=SIM_${klm}
    mkdir $folder
    cd $folder
    cp  ${INPUT_PATH}/MEMBRANE/${mem}/* .
   
    
    #SET fort.1
    ${SHELL_PATH}/change_fort1 eq_state_dens: ${a}
    ${SHELL_PATH}/change_fort1 simulated_ensemble: NVT_Andersen
    ${SHELL_PATH}/change_fort1 number_of_steps: 100000
    
    sed  -i "/* compressibility/{n;s/.*/${komp}/}" fort.3
    sed -i -e "s/KLM/${klm}/g" fort.3
    python3 $PYTHON_PATH/fix_fort3.py


    bash ${SHELL_PATH}/run_para.sh
    cp fort.9 fort.5
    bash ${SHELL_PATH}/run_para.sh
    python3 ${PYTHON_PATH}/COMP_PRESSURE_PROFILES.py 1
    cd ..    
}


KLM=("0" "-2"  "-4" "-5" "-6" "-7" "-8" "-9" "-10" "-12" "-15" )

MEMS=("DOPC"    "DPPC" "DSPC"   "DMPC")
KOMP=("0.03"   "0.05" "0.05"   "0.05") 

#for i in {1..3};do
i=$1
komp=$2
memi="${MEMS[i]}"
tempi="${TEMPS[i]}"
#  kompi="${KOMP[i]}"
cd ${SCRATCH_DIRECTORY}

echo "SIMULATION ON MEMBRANE ${memi}"
for klm in "${KLM[@]}";do
    function_name $memi ${klm} $komp
done

rm -rf ${SLURM_SUBMIT_DIR}/${memi}_${komp}
mkdir ${SLURM_SUBMIT_DIR}/${memi}_${komp}
mv  ${SCRATCH_DIRECTORY}/SIM_* ${SLURM_SUBMIT_DIR}/${memi}_${komp}/

cd  ${SLURM_SUBMIT_DIR}/${memi}_${komp}
bash ${SHELL_PATH}/comp_pressure_stats.sh
cd PRESSURE_DATA/
python3 ${PYTHON_PATH}/find_a_para.py pressavg_mean.dat 0 $kompi $tempi
python3 ${PYTHON_PATH}/fit_polynomial.py klm_a.dat
python3 ${PYTHON_PATH}/fit_polynomial.py pressxxavg_mean.dat
python3 ${PYTHON_PATH}/fit_polynomial.py presszzavg_mean.dat
klm=$(python3 ${PYTHON_PATH}/solve_poly.py presszzavg_mean_polyfit.dat pressxxavg_mean_polyfit.dat)
a=$(python3 ${PYTHON_PATH}/polyfit_value.py klm_a_polyfit.dat $klm)

echo "TENSIONLESS MEMBRANE: Klm=$klm a=$a"
echo $klm $a > tensionless_para.dat
cd ..

#done 
wait
echo "DONE"

exit 0



