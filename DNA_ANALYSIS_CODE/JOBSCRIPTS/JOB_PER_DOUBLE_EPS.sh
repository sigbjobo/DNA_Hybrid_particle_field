#!/bin/bash
#SBATCH --job-name=DS_PER
#SBATCH --account=nn4654k
#SBATCH --time=3-2:0:0
#SBATCH --nodes=3 --ntasks-per-node=16

set -e


#MANDATORY SETTINGS
NPROCS=${SLURM_NTASKS}
export COMPILE=0
export NSOLUTE=2

export kphi=$1


 
#SETTINGS SPECIFIC TO BAYSIAN OPTIMIZATION
NSTEPS=150000000
export NTRAJ=20000
export NW=19
export NN=-12.7
export PP=-4.2
export PW=-7.2
export dna_seq=CCGCCAGCGGCGTTATTACATTTAATTCTTAAGTATTATAAGTAATATGGCCGCTGCGCC
export rev_dna_seq=GGCGCAGCGGCCATATTACTTATAATACTTAAGAATTAAATGTAATAACGCCGCTGGCGG

#DIRECTORIES
export SHELL_PATH="/home/sigbjobo/Projects/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/shell"
export INPUT_PATH="/home/sigbjobo/Projects/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/INPUT_FILES"
export PYTHON_PATH="/home/sigbjobo/Projects/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/python"
export OCCAM_PATH="/home/sigbjobo/Projects/DNA/DNA_Hybrid_particle_field/../occam_dna_parallel/"
SCRATCH_DIRECTORY="${SCRATCH}"
SLURM_SUBMIT_DIR=$(pwd)

#LOAD MODULES
module purge
module load intel/2019.1
module load FFTW
module load python3/3.7.0

#PREPARE SIMULATION DIRECTORY
mkdir -p ${SCRATCH_DIRECTORY}
cd ${SCRATCH_DIRECTORY}

folder=SIM_${kphi}
mkdir ${folder}
cd ${folder}
 
#MAKE SYSTEM
cp -r ${INPUT_PATH}/PARA/* .

bash ${SHELL_PATH}/double_ds.sh ${dna_seq} ${rev_dna_seq} 20 150

python3 ${PYTHON_PATH}/set_chi.py fort.3

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
sed -i '/target_temperature:/{n;s/.*/1000     0.000/}' fort.1

# SET STRENGTH OF TORSIONAL POTENTIAL                                        
bash ${SHELL_PATH}/setup_FF.sh ${kphi}