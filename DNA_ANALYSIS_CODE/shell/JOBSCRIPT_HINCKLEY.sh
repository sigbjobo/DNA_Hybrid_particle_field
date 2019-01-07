#!/bin/bash
#SBATCH --job-name=DNA_HINCKLEY
#SBATCH --account=nn4654k
#SBATCH --time=7-0:00:00
#SBATCH --partition=singlenode
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --mem-per-cpu=2000M
# ## Set up job environment


# Set up node file for namd run :
module load Python/3.6.4-intel-2018a
module load intel/2017.01
module load OpenMPI/2.0.1-iccifort-2017.1.132-GCC-5.4.0-2.26
module load FFTW/3.3.2

SHELL_PATH="/home/sigbjobo/Projects/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/shell"
INPUT_PATH="/home/sigbjobo/Projects/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/INPUT_FILES"
SCRATCH_DIRECTORY=/global/work/${USER}/${SLURM_JOBID}.stallo-adm.uit.no
SLURM_SUBMIT_DIR=$(pwd)

rm ${SLURM_SUBMIT_DIR}/sim -r
mkdir ${SLURM_SUBMIT_DIR}/sim
cd ${SLURM_SUBMIT_DIR}/sim
cp ${INPUT_PATH}/PARA/* .
k_phi=7
alpha=10
beta=-10
b=0.8
dna_seq=ATGCAATGCTACATATTCGCTTTTTGCGAATATGTAGCATTGCAT

#Set dna sequence
bash ${SHELL_PATH}/single_ss.sh ${dna_seq} 15 100

#Set alpha
sed -i "s/alpha/${alpha}/g" fort.3

#Set beta
sed -i "s/beta/${beta}/g" fort.3


#Set number of atoms
N=$(tail fort.5 -n 1 | awk '{print $1}')
sed -i "s/NATOMS/$N/g" fort.1

#Set number of grid points
L=$(head  fort.5 -n 2 | tail -n 1 | awk '{print $1}')
M=$(python -c "print(int($L / 0.8))") 
sed -i "s/MM/$M/g" fort.3

#bash ${SHELL_PATH}/run_sim.sh $k_phi
cd ${SLURM_SUBMIT_DIR}/




mkdir -p ${SCRATCH_DIRECTORY}
cp -r ${SLURM_SUBMIT_DIR}/sim ${SCRATCH_DIRECTORY}/
cd ${SCRATCH_DIRECTORY}/sim
bash ${SHELL_PATH}/setup_FF.sh 7
bash ${SHELL_PATH}/run_para.sh 4
cp -r ${SCRATCH_DIRECTORY}/sim ${SLURM_SUBMIT_DIR}
rm -rf ${SCRATCH_DIRECTORY}
#SBATCH --signal=B:USR1@500
your_cleanup_function()
{
echo "function your_cleanup_function called at $(date)"
cp -r ${SCRATCH_DIRECTORY}/sim ${SLURM_SUBMIT_DIR}
rm -rf ${SCRATCH_DIRECTORY}
}
# call your_cleanup_function once we receive USR1 signal
trap 'your_cleanup_function' USR1
echo "starting calculation at $(date)"
sleep 500 &
wait
 


exit 0







#######

