#Load new parameters
alpha=$1
beta=$2

function CreateFolder(){
    #Creates a folder with unique name one number higher than last one
    A=$(ls -l|grep sim_| wc | awk '{print $1}' )
    A=$(python -c "print(int($A+1))")
    foldername=$( echo $A | awk '{printf ("sim_%03i", $1)}' )

    {
        mkdir $foldername
    } || {
        CreateFolder
    }
}


PYTHON_PATH="/home/sigbjobo/Documents/DNA_Project/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/python"
SHELL_PATH="/home/sigbjobo/Documents/DNA_Project/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/shell"
INPUT_PATH="/home/sigbjobo/Documents/DNA_Project/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/INPUT_FILES"
CreateFolder

#Setup simulation
cd $foldername

cp -r ${INPUT_PATH}/PARA/* .
bash ${SHELL_PATH}/double_ds.sh ATACAAAGGTGCGAGGTTTCTATGCTCCCACG CGTGGGAGCATAGAAACCTCGCACCTTTGTAT 15 100


#New parameters
sed -i "s/alpha/${alpha}/g" fort.3
sed -i "s/beta/${beta}/g"   fort.3
L=$(head  fort.5 -n 2 | tail -n 1 | awk '{print $1}')
M=$(python -c "print(int($L / 0.67))")
sed -i "s/MM/$M/g" fort.3
  
#Set number of atoms
N=$(tail fort.5 -n 1 | awk '{print $1}')
sed -i "s/NATOMS/$N/g" fort.1
sed -i '/number_of_steps:/{n;s/.*/100000/}' fort.1
sed -i '/pot_calc_freq:/{n;s/.*/500/}' fort.1
sed -i '/SCF_lattice_update:/{n;s/.*/20/}' fort.1
sed -i '/trj_print:/{n;s/.*/10000/}' fort.1
sed -i '/out_print:/{n;s/.*/10000/}' fort.1

# SET STRENGTH OF TORSIONAL POTENTIAL
bash ${SHELL_PATH}/setup_FF.sh 10.00

#Run simulation in parallel
bash ${SHELL_PATH}/run_para_many.sh ${NPROC} 2


mv fort.8 sim.xyz

#python ${PYTHON_PATH}/center.py
#mv fort_center.xyz sim.xyz
cd ..




