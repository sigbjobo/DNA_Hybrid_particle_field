#!/bin/bash
#SBATCH --job-name=DNA_HINCKLEY
#SBATCH --account=nn4654k
#SBATCH --time=0-0:20:00
#SBATCH --mem-per-cpu=2000M
#SBATCH --partition=normal
#SBATCH --ntasks=192
NPROC=192
# Set up node file for namd run :
module purge
module load intel/2017.01
module load FFTW/3.3.4
module load Python/3.6.4-intel-2018a

SHELL_PATH="/home/sigbjobo/Projects/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/shell"
INPUT_PATH="/home/sigbjobo/Projects/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/INPUT_FILES"
SCRATCH_DIRECTORY="/global/work/${USER}/${SLURM_JOBID}.stallo-adm.uit.no"
SLURM_SUBMIT_DIR=$(pwd)

rm ${SLURM_SUBMIT_DIR}/sim -r
mkdir ${SLURM_SUBMIT_DIR}/sim
cd ${SLURM_SUBMIT_DIR}/sim
cp ${INPUT_PATH}/PARA/* .
k_phi=$1
alpha=10
beta=-10

dna_seq=AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA

#Set dna sequence
bash ${SHELL_PATH}/single_ss.sh ${dna_seq} 20 100

L=$(head  fort.5 -n 2 | tail -n 1 | awk '{print $1}')
M=$(python -c "print(int($L / 0.8))")
sed -i "s/MM/$M/g" fort.3
sed -i "s/alpha/${alpha}/g" fort.3
sed -i "s/beta/${beta}/g" fort.3

#Changing fort.1
N=$(tail fort.5 -n 1 | awk '{print $1}')
sed -i "s/NATOMS/$N/g" fort.1
sed -i '/number_of_steps:/{n;s/.*/10000/}' fort.1
sed -i '/pot_calc_freq:/{n;s/.*/1000/}' fort.1
sed -i '/SCF_lattice_update:/{n;s/.*/100/}' fort.1
sed -i '/trj_print:/{n;s/.*/20000/}' fort.1
sed -i '/out_print:/{n;s/.*/20000/}' fort.1


#bash ${SHELL_PATH}/run_sim.sh $k_phi
cd ${SLURM_SUBMIT_DIR}/

mkdir -p ${SCRATCH_DIRECTORY}
cp -r ${SLURM_SUBMIT_DIR}/sim ${SCRATCH_DIRECTORY}/
cd ${SCRATCH_DIRECTORY}/sim
bash ${SHELL_PATH}/setup_FF.sh ${k_phi}
bash ${SHELL_PATH}/run_para.sh ${NPROC}
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

