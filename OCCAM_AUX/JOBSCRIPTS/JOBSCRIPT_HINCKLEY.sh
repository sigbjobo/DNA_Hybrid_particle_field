#!/bin/bash
#SBATCH --job-name=PER_SINGLE
#SBATCH --account=nn4654k
#SBATCH --time=3-0:00:0
#SBATCH --ntasks=192
#SBATCH --ntasks-per-node=40
#SBATCH --mem-per-cpu=2G

set -o errexit # exit on errors

#LOAD MODULES
#module purge
module load intel/2018b
export LMOD_DISABLE_SAME_NAME_AUTOSWAP=no
module load intel/2018b
module load FFTW/3.3.7-intel-2018a
module load Python/3.7.0-intel-2018b

#MANDATORY SETTINGS
export NPROC=${SLURM_NTASKS}
echo "NUMBER OF PROCESSORS USED: $NPROC"
export COMPILE=0
export NSOLUTE=1


#SIMULATION SETTINGS
export NSTEPS=34000000 #0
export NTRAJ=5000
TEMP=293.15
export kphi=8
export NW=6.28
export NN=-23.59
export PP=0
export PW=-6.08
dna_seq=ATGCAATGCTACATATTCGCTTTTTGCGAATATGTAGCATTGCAT

export k_phi=8

#DIRECTORIES
export SHELL_PATH="/cluster/home/sigbjobo/DNA/HPF/OCCAM_AUX/shell"
export INPUT_PATH="/cluster/home/sigbjobo/DNA/HPF/OCCAM_AUX/INPUT_FILES"
export PYTHON_PATH="/cluster/home/sigbjobo/DNA/HPF/OCCAM_AUX/python"
export OCCAM_PATH="/cluster/home/sigbjobo/DNA/HPF/../occam_dna_parallel/"
SCRATCH_DIRECTORY="${SCRATCH}"
SLURM_SUBMIT_DIR=$(pwd)

folder=sim

#REMOVE OLD SIMULATIONS
rm ${SLURM_SUBMIT_DIR}/${folder} -rf

#PREPARE ${FOLDER}ULATION DIRECTORY
mkdir -p ${SCRATCH_DIRECTORY}
cd ${SCRATCH_DIRECTORY}
mkdir ${folder}
cd ${folder}

#COPY INPUT
cp -r ${INPUT_PATH}/PARA/* .
python3 ${PYTHON_PATH}/set_chi.py fort.3 

#MAKE FORT.5
bash ${SHELL_PATH}/single_ss.sh ${dna_seq} 15 100
 


L=$(head  fort.5 -n 2 | tail -n 1 | awk '{print $1}')
M=$(python3 -c "print(int($L / 0.67))")
sed -i "s/MM/$M/g" fort.3

#Set number of atoms
N=$(tail fort.5 -n 1 | awk '{print $1}')
sed -i "s/NATOMS/$N/g" fort.1
sed -i "/number_of_steps:/{n;s/.*/$NSTEPS/}" fort.1
sed -i '/pot_calc_freq:/{n;s/.*/500/}' fort.1
sed -i '/SCF_lattice_update:/{n;s/.*/50/}' fort.1
sed -i "/trj_print:/{n;s/.*/$NTRAJ/}" fort.1
sed -i '/out_print:/{n;s/.*/10000/}' fort.1

#Temperature
sed -i "/target_temperature:/{n;s/.*/${TEMP}     0/}" fort.1

#SET STRENGTH OF TORSIONAL POTENTIAL
bash ${SHELL_PATH}/setup_FF.sh ${kphi}

#RUN SIMULATION IN PARALLEL
bash ${SHELL_PATH}/run_para.sh 


#SAVE DATA
cp -r ${SCRATCH_DIRECTORY}/${folder} ${SLURM_SUBMIT_DIR}/${folder}

wait
 
exit 0







#######

