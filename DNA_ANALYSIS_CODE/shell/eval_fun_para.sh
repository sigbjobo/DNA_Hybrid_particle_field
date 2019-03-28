#Load new parameters
#alpha=$1
#beta=$2
#kphi=$3
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

cp -r ${INPUT_PATH}/PARA/* .
#bash ${SHELL_PATH}/double_ds.sh ATACAAAGGTGCGAGGTTTCTATGCTCCCACG CGTGGGAGCATAGAAACCTCGCACCTTTGTAT 15 100
cp ${INPUT_PATH}/OPTIMIZATION/START.5 fort.5

#New parameters
NW=$alpha
AT=$beta
PP=0
PW=-3.6
python ${PYTHON_PATH}/set_fort3.py fort.3 $NW $AT $PP $PW
#sed -i "s/alpha/${alpha}/g" fort.3
#sed -i "s/beta/${beta}/g"   fort.3

L=$(head  fort.5 -n 2 | tail -n 1 | awk '{print $1}')
M=$(python -c "print(int($L / 0.67))")
sed -i "s/MM/$M/g" fort.3
  
#Set number of atoms
N=$(tail fort.5 -n 1 | awk '{print $1}')
sed -i "s/NATOMS/$N/g" fort.1
sed -i "/number_of_steps:/{n;s/.*/$NSTEPS/}" fort.1
sed -i '/pot_calc_freq:/{n;s/.*/500/}' fort.1
sed -i '/SCF_lattice_update:/{n;s/.*/20/}' fort.1
sed -i "/trj_print:/{n;s/.*/$NTRAJ/}" fort.1
sed -i '/out_print:/{n;s/.*/10000/}' fort.1

# SET STRENGTH OF TORSIONAL POTENTIAL
bash ${SHELL_PATH}/setup_FF.sh ${kphi}

#Run simulation in parallel
bash ${SHELL_PATH}/run_para_many.sh ${NPROC} 2


mv fort.8 sim.xyz

cd ..




