#Sets path for scripts
A=$(pwd)
SHELL_PATH="${A}/DNA_ANALYSIS_CODE/shell"
JOB_PATH="${A}/DNA_ANALYSIS_CODE/JOBSCRIPTS/"
PYTHON_PATH="${A}/DNA_ANALYSIS_CODE/python"
INPUT_PATH="${A}/DNA_ANALYSIS_CODE/INPUT_FILES"
OCCAM_PATH="${A}/../occam_dna_parallel/"
OCCAM_PATH_SERIAL="${A}/../occam_dna/"
EXTRA_PATH="/home/sigbjobo/Stallo/Projects/DNA/DNA_Hybrid_particle_field/DNA_CODE_PLOT/DNA_ANALYSIS_CODE/python"

#FIX SHELL SCRIPTS
sed -i 's|PYTHON_PATH=.*|PYTHON_PATH="'"$PYTHON_PATH"'"|g' ${SHELL_PATH}/*.sh
sed -i 's|SHELL_PATH=.*|SHELL_PATH="'"$SHELL_PATH"'"|g' ${SHELL_PATH}/*.sh
sed -i 's|INPUT_PATH=.*|INPUT_PATH="'"$INPUT_PATH"'"|g' ${SHELL_PATH}/*.sh
sed -i 's|OCCAM_PATH=.*|OCCAM_PATH="'"$OCCAM_PATH"'"|g' ${SHELL_PATH}/*.sh

#FIX JOB SCRIPTS
sed -i 's|PYTHON_PATH=.*|PYTHON_PATH="'"$PYTHON_PATH"'"|g' ${JOB_PATH}/*.sh
sed -i 's|SHELL_PATH=.*|SHELL_PATH="'"$SHELL_PATH"'"|g' ${JOB_PATH}/*.sh
sed -i 's|INPUT_PATH=.*|INPUT_PATH="'"$INPUT_PATH"'"|g' ${JOB_PATH}/*.sh
sed -i 's|OCCAM_PATH=.*|OCCAM_PATH="'"$OCCAM_PATH"'"|g' ${JOB_PATH}/*.sh


#FIX PYTHON SCRIPTS
sed -i 's|PYTHON_PATH=.*|PYTHON_PATH="'"$PYTHON_PATH"'"|g' ${PYTHON_PATH}/*.py
sed -i 's|SHELL_PATH=.*|SHELL_PATH="'"$SHELL_PATH"'"|g' ${PYTHON_PATH}/*.py
sed -i 's|EXTRA_PATH=.*|EXTRA_PATH="'"$EXTRA_PATH"'"|g' ${PYTHON_PATH}/*.py
sed -i 's|OCCAM_PATH=.*|OCCAM_PATH="'"$OCCAM_PATH"'"|g' ${PYTHON_PATH}/*.py

if [ $(pwd | grep cluster | wc | awk '{print $1}') -gt 0 ] 
then
    sed -i '/module load FFTW*/c\module load FFTW/3.3.8-intel-2018b' ${JOB_PATH}/*.sh
    sed -i '/module load intel*/c\module load intel/2018b' ${JOB_PATH}/*.sh
    sed -i '/\#SBATCH --mem-per-cpu=2000M/c\\#\#SBATCH --mem-per-cpu=2000M' ${JOB_PATH}/*.sh
    sed -i '/\#SBATCH --ntasks=192/c\\#SBATCH --nodes=12 --ntasks-per-node=16' ${JOB_PATH}/*.sh
    SCRATCH_DIRECTORY=/cluster/work/jobs/\$\{SLURM_JOB_ID\} 
else
    sed -i '/module load FFTW*/c\module load FFTW/3.3.7-intel-2018a' ${JOB_PATH}/*.sh
    sed -i '/\#SBATCH --mem-per-cpu=2000M/c\\#SBATCH --mem-per-cpu=2000M' ${JOB_PATH}/*.sh
    sed -i '/\#SBATCH --nodes=12 --ntasks-per-node=16/c\\#SBATCH --ntasks=192' ${JOB_PATH}/*.sh
    SCRATCH_DIRECTORY=/global/work/\$\{USER\}/\$\{SLURM_JOBID\}.stallo-adm.uit.no
fi
sed -i 's|SCRATCH_DIRECTORY=.*|SCRATCH_DIRECTORY="'"$SCRATCH_DIRECTORY"'"|g' ${JOB_PATH}/*.sh
