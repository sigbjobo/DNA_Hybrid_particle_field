#!/bin/bash
 
# #SBATCH --job-name=DNA
# #SBATCH --account=nn4654k
# #SBATCH --partition=singlenode
# #SBATCH --time=7-0:00:00
# #SBATCH --mem-per-cpu=3000M 
# #SBATCH --nodes=1
# #SBATCH --ntasks-per-node=4


# ## Set up job environment
# #source /cluster/bin/jobsetup

# # Set up node file for namd run :
# module load python
# module load FFTW
n=48
PYTHON_PATH="/home/sigbjobo/Projects/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/python"
SHELL_PATH="/home/sigbjobo/Projects/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/shell"
#bash setup_FF.sh $1
kphi=$1
names[1]=P-S-P-S
phi0[1]=-154.80
names[2]=S-P-S-P
phi0[2]=-179.17
names[3]=S-P-S-A
phi0[3]=50.69
names[4]=A-S-P-S
phi0[4]=-22.60
names[5]=S-P-S-T
phi0[5]=54.69
names[6]=T-S-P-S
phi0[6]=-33.42
names[7]=S-P-S-C
phi0[7]=54.5000
names[8]=C-S-P-S
phi0[8]=-32.72
names[9]=S-P-S-G
phi0[9]=50.66
names[10]=G-S-P-S
phi0[10]=-22.30

#mkdir $kphi
#cp ../start_files/* . #$kphi/

#cd $kphi

mkdir FF
cp fort.5 fort_old.5

for i in $(seq 1 10) 
do
    #Set up first simulation
    echo ${names[$i]}, ${phi0[$i]}
    python ${PYTHON_PATH}/make_pot.py $n ${kphi} ${phi0[$i]} ${names[$i]}_pot.dat
    python ${PYTHON_PATH}/make_coef.py ${names[$i]}_pot.dat ${names[$i]} ${names[$i]}_1_pot_after.dat
    mv ${names[$i]}_PROP.dat FF/
done
 

for i in $(seq 1 1) 
do
    cp fort_old.5 fort.5
    for j in $(seq 1 20) 
    do
	./occamcg_pol
	
	python ${PYTHON_PATH}/remove_w.py fort.8
	python ${PYTHON_PATH}/center.py
	cat fort_center.xyz>>sim.xyz    
	cp fort.9 fort.5
    done
    # python ${s_folder}/comp_angles.py sim.xyz 0 
    # python ${s_folder}/sep.py bond_data.dat
    # python ${s_folder}/comp_averages.py
    # for j in $(seq 1 10) 
    # do
    # 	python ${s_folder}/make_hist.py ${names[$j]}.txt $n ${names[$j]}_${i}_hist.dat
    # done
    # mkdir ${i}_bond
    
    # mv *.txt    ${i}_bond/
    # mv *_${i}_* ${i}_bond/
    # mv *.dat    ${i}_bond/
    # mv sim.xyz  ${i}_bond/
done
 
