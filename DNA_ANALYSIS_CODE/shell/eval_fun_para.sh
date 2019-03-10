#Load new parameters
alpha=$1
beta=$2
NPROC=4

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


PYTHON_PATH="/cluster/home/sigbjobo/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/python"
SHELL_PATH="/cluster/home/sigbjobo/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/shell"
INPUT_PATH="/cluster/home/sigbjobo/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/INPUT_FILES"
CreateFolder

#Setup simulation
cd $foldername

bash ${SHELL_PATH}/double_ds.sh ATACAAAGGTGCGAGGTTTCTATGCTCCCACG TATGTTTCCACGCTCCAAAGATACGAGGGTGC 15 100
cp -r ${INPUT_PATH}/PARA/* .
#New parameters
sed -i "s/alpha/${alpha}/g" fort.3
sed -i "s/beta/${beta}/g"   fort.3
L=$(head  fort.5 -n 2 | tail -n 1 | awk '{print $1}')
M=$(python -c "print(int($L / 0.8))")
sed -i "s/MM/$M/g" fort.3
#Set number of atoms                                                                                                                                                        
N=$(tail fort.5 -n 1 | awk '{print $1}')
sed -i "s/NATOMS/$N/g" fort.1
bash ${SHELL_PATH}/setup_FF.sh 7.00

#Run simulation in parallel
bash run_para_many.sh ${NPROC} 2
mv fort.8 mem_nowater.xyz
python {PYTHON_PATH}/center.py
mv fort_center.xyz sim.xyz
cd ..




