y#!/bin/bash
#SBATCH --job-name=OPTIMIZE_DNA
#SBATCH --account=nn4654k
#SBATCH --time=1-0:0:0
#SBATCH --nodes=6 --ntasks-per-node=32
##SBATCH --qos=devel

#MANDATORY SETTINGS
export NPROC=192 #192
export COMPILE=0
export NSOLUTE=1


export kphi=$1


 
#SETTINGS SPECIFIC TO BAYSIAN OPTIMIZATION
export NSTEPS=40000000
export NTRAJ=20000
export NW=19
export NN=-12.7
export PP=-4.2
export PW=-7.2
export dna_seq=AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA

#DIRECTORIES
export SHELL_PATH="/cluster/home/sigbjobo/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/shell"
export INPUT_PATH="/cluster/home/sigbjobo/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/INPUT_FILES"
export PYTHON_PATH="/cluster/home/sigbjobo/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/python"
export OCCAM_PATH="/cluster/home/sigbjobo/DNA/DNA_Hybrid_particle_field/../occam_dna_parallel/"
SCRATCH_DIRECTORY="/cluster/work/jobs/${SLURM_JOB_ID}"
SLURM_SUBMIT_DIR=$(pwd)

#LOAD MODULES
module purge
module load intel/2018b
module load FFTW/3.3.8-intel-2018b
module load Python/3.6.4-intel-2018a



#PREPARE SIMULATION DIRECTORY
mkdir -p ${SCRATCH_DIRECTORY}
cd ${SCRATCH_DIRECTORY}

folder=SIM_${kphi}
mkdir ${folder}
cd ${folder}
 
#MAKE SYSTEM
cp -r ${INPUT_PATH}/PARA/* .

bash ${SHELL_PATH}/single_ss.sh ${dna_seq} 20 100

python ${PYTHON_PATH}/set_chi.py fort.3

L=$(head  fort.5 -n 2 | tail -n 1 | awk '{print $1}')
M=$(python -c "print(int($L / 0.67))")
sed -i "s/MM/$M/g" fort.3

#Set number of atoms                                                                                                      
N=$(tail fort.5 -n 1 | awk '{print $1}')
sed -i "s/NATOMS/$N/g" fort.1
sed -i "/number_of_steps:/{n;s/.*/$NSTEPS/}" fort.1
sed -i '/pot_calc_freq:/{n;s/.*/500/}' fort.1
sed -i '/SCF_lattice_update:/{n;s/.*/50/}' fort.1
sed -i "/trj_print:/{n;s/.*/$NTRAJ/}" fort.1
sed -i '/out_print:/{n;s/.*/10000/}' fort.1

# SET STRENGTH OF TORSIONAL POTENTIAL                                        
bash ${SHELL_PATH}/setup_FF.sh ${kphi}

#RUN SIMULATION
bash ${SHELL_PATH}/run_para.sh



#SAVE DATA
cp -r ${SCRATCH_DIRECTORY}/${folder} ${SLURM_SUBMIT_DIR}/${folder}


exit 0



#######
