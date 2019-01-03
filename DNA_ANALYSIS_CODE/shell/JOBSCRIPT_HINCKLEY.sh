#!/bin/bash
#SBATCH --job-name=DNA_HINCKLEY
#SBATCH --account=nn4654k
#SBATCH --partition=singlenode
#SBATCH --time=7-0:00:00
#SBATCH --mem-per-cpu=2000M 
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
 

# ## Set up job environment


# Set up node file for namd run :
module load Python/3.6.4-intel-2018a
module load FFTW

rm sim -r
mkdir sim
cd sim
cp ../start_files/* .
SHELL_PATH="/home/sigbjobo/Projects/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/shell"

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
cd ../




SCRATCH_DIRECTORY=/global/work/${USER}/${SLURM_JOBID}.stallo-adm.uit.no
SLURM_SUBMIT_DIR=$(pwd)
mkdir -p ${SCRATCH_DIRECTORY}
cp -r ${SLURM_SUBMIT_DIR}/sim ${SCRATCH_DIRECTORY}/
cd ${SCRATCH_DIRECTORY}/sim

bash ${SHELL_PATH}/run_sim.sh ${k_phi}
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

