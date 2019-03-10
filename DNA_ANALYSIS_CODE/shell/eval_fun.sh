#Load new parameters
alpha=$1
beta=$2

function CreateFolder(){
    A=$(ls -l|grep sim_| wc | awk '{print $1}' )
    A=$(python -c "print(int($A+1))")
    foldername=$( echo $A | awk '{printf ("sim_%03i", $1)}' )

    {
        mkdir $foldername
    } || {
        CreateFolder
    }
}

#folder with scripts
PYTHON_PATH="/cluster/home/sigbjobo/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/python"
SHELL_PATH="/cluster/home/sigbjobo/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/shell"
#Make a new folder for keeping data (maximum 999 function calls!)
CreateFolder

#Setup simulation
cd $foldername
cp -r ../start_files/* .

#SEQUENCE WITH BASE PAIRED COMPLIMENTS
bash ${SHELL_PATH}/double_ds.sh ATACAAAGGTGCGAGGTTTCTATGCTCCCACG TATGTTTCCACGCTCCAAAGATACGAGGGTGC 15 100

#New parameters
sed -i "s/alpha/${alpha}/g" fort.3
sed -i "s/beta/${beta}/g"   fort.3
bash ${SHELL_PATH}/run_sim.sh 7.00 

cd ..




