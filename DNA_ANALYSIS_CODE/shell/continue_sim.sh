#!/bin/bash 
#SBATCH --job-name=DNA_CONTINUE
#SBATCH --account=nn4654k
#SBATCH --partition=singlenode
#SBATCH --time=7-0:00:00
#SBATCH --mem-per-cpu=3000M 
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4

module load FFTW
n=48
PYTHON_PATH="/home/sigbjobo/Projects/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/python"
SHELL_PATH="/home/sigbjobo/Projects/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/shell"

for j in $(seq 1 20) 
do
    ./occamcg_pol    
    python ${PYTHON_PATH}/remove_w.py fort.8
    python ${PYTHON_PATH}/center.py
    cat fort_center.xyz>>sim.xyz    
    cp fort.9 fort.5
done
