#!/bin/bash
#SBATCH --job-name=DNA_HINCKLEY
#SBATCH --account=nn4654k
#SBATCH --time=0-3:00:00
##SBATCH --mem-per-cpu=2000M
#SBATCH --partition=normal
#SBATCH --nodes=6 --ntasks-per-node=32
##SBATCH --qos=devel
NPROC=192
# Set up node file for namd run :
module purge
module load intel/2018b
module load FFTW/3.3.8-intel-2018b
module load Python/3.6.4-intel-2018a

SHELL_PATH="/cluster/home/sigbjobo/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/shell"
INPUT_PATH="/cluster/home/sigbjobo/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/INPUT_FILES"
SCRATCH_DIRECTORY="/cluster/work/jobs/${SLURM_JOB_ID}"
SLURM_SUBMIT_DIR=$(pwd)

rm ${SLURM_SUBMIT_DIR}/sim -rf
mkdir ${SLURM_SUBMIT_DIR}/sim
cd ${SLURM_SUBMIT_DIR}/sim
cp ${INPUT_PATH}/PARA/* .
k_phi=7
alpha=10
beta=-10

dna_seq=ATGCAATGCTACATATTCGCTTTTTGCGAATATGTAGCATTGCAT

#Set dna sequence
bash ${SHELL_PATH}/single_ss.sh ${dna_seq} 15 100

L=$(head  fort.5 -n 2 | tail -n 1 | awk '{print $1}')
M=$(python -c "print(int($L / 0.675))")
sed -i "s/MM/$M/g" fort.3
sed -i "s/alpha/${alpha}/g" fort.3
sed -i "s/beta/${beta}/g" fort.3

#Changing fort.1
N=$(tail fort.5 -n 1 | awk '{print $1}')
sed -i "s/NATOMS/$N/g" fort.1
sed -i '/number_of_steps:/{n;s/.*/34000000/}' fort.1
sed -i '/pot_calc_freq:/{n;s/.*/1000/}' fort.1
sed -i '/SCF_lattice_update:/{n;s/.*/100/}' fort.1
sed -i '/trj_print:/{n;s/.*/5000/}' fort.1
sed -i '/out_print:/{n;s/.*/10000/}' fort.1


#bash ${SHELL_PATH}/run_sim.sh $k_phi
cd ${SLURM_SUBMIT_DIR}/

mkdir -p ${SCRATCH_DIRECTORY}

cp -r ${SLURM_SUBMIT_DIR}/sim ${SCRATCH_DIRECTORY}/
cd ${SCRATCH_DIRECTORY}/sim
bash ${SHELL_PATH}/setup_FF.sh ${k_phi}
bash ${SHELL_PATH}/run_para.sh ${NPROC}
cp -r ${SCRATCH_DIRECTORY}/sim/{fort.7,fort.8,fort.9} ${SLURM_SUBMIT_DIR}/sim
mkdir -p /cluster/projects/nn4654k/sigbjobo/${SLURM_JOB_ID}
cp -r ${SCRATCH_DIRECTORY}/sim /cluster/projects/nn4654k/sigbjobo/${SLURM_JOB_ID}/

rm -rf ${SCRATCH_DIRECTORY}



exit 0







#######

