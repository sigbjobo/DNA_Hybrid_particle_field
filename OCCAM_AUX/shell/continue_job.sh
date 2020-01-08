#!/bin/bash
#SBATCH --job-name=MEMBRANES
#SBATCH --account=nn4654k
#SBATCH --time=7-0:00:0
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=20
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

folder=$(pwd)
mv fort.8 sim1.xyz
mv fort.7 sim1.7
cp fort.5 sim1.5
echo "name of simulation folder: $folder"
cd $SCRATCH
cp $folder/{fort.1,fort.9,fort.5,fort.3}  .
mv fort.9 fort.5
python3 $PYTHON_PATH/fix_fort3.py
bash ${SHELL_PATH}/run_para.sh
mv fort.8 sim2.xyz
mv fort.7 sim2.7
mv * ${folder}/
 


wait
echo "DONE"

exit 0

 
 
