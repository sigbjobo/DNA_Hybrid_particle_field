#!/bin/bash
#SBATCH --job-name=DNA_HINCKLEY
#SBATCH --account=nn4654k
#SBATCH --time=0-0:20:00
#SBATCH --mem-per-cpu=2000M
#SBATCH --partition=normal
#SBATCH --nodes=3 --ntasks-per-node=16
# Set up node file for namd run :
module purge
module load intel/2019.1
module load FFTW
module load python3/3.7.0

#SET K_PHI
export k_phi=$1
NPROCS=${SLURM_NTASKS}
export NSTEPS=100000
export NTRAJ=10000
export alpha=10
export beta=-10
export dna_seq=AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA

SHELL_PATH="/usit/abel/u1/sigbjobo/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/shell"
INPUT_PATH="/usit/abel/u1/sigbjobo/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/INPUT_FILES"
SCRATCH_DIRECTORY="${SCRATCH}"
SLURM_SUBMIT_DIR=$(pwd)

folder=SIM_${kphi}

#MAKE FORT.5
bash ${SHELL_PATH}/single_ss.sh ${dna_seq} 20 100

#SETTING UP FORT.3
L=$(head  fort.5 -n 2 | tail -n 1 | awk '{print $1}')
M=$(python3 -c "print(int($L / 0.67))")
sed -i "s/MM/$M/g" fort.3
sed -i "s/alpha/${alpha}/g" fort.3
sed -i "s/beta/${beta}/g" fort.3

#SETTING UP fort.1
N=$(tail fort.5 -n 1 | awk '{print $1}')
sed -i "s/NATOMS/$N/g" fort.1
sed -i "/number_of_steps:/{n;s/.*/$NSTEPS/}" fort.1
sed -i '/pot_calc_freq:/{n;s/.*/500/}' fort.1
sed -i '/SCF_lattice_update:/{n;s/.*/50/}' fort.1
sed -i "/trj_print:/{n;s/.*/$NTRAJ/}" fort.1
sed -i '/out_print:/{n;s/.*/10000/}' fort.1

#bash ${SHELL_PATH}/run_sim.sh $k_phi
cd ${SLURM_SUBMIT_DIR}/
mkdir -p ${SCRATCH_DIRECTORY}
cd ${SCRATCH_DIRECTORY}
mkdir ${folder}
cd ${folder}

#ROUTINES FOR RUNNING
bash ${SHELL_PATH}/setup_FF.sh ${k_phi}
bash ${SHELL_PATH}/run_para.sh ${NPROC}

#COPYING BACK FILES
cp -r ${SCRATCH_DIRECTORY}/${folder} ${SLURM_SUBMIT_DIR}

wait
 
exit 0







#######

