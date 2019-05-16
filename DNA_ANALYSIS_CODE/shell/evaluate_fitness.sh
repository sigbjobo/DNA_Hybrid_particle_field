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


CreateFolder

#Setup simulation
cd $foldername

cp -r ${INPUT_PATH}/PARA/* .
#bash ${SHELL_PATH}/double_ds.sh ATACAAAGGTGCGAGGTTTCTATGCTCCCACG CGTGGGAGCATAGAAACCTCGCACCTTTGTAT 15 100
cp ${INPUT_PATH}/OPTIMIZATION/START.5 fort.5

#New parameters
python ${PYTHON_PATH}/set_chi.py fort.3 

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

#Temperature
dt=$(python -c "print(-300./float(${NTRAJ}))")
sed -i "/target_temperature:/{n;s/.*/300     ${dt}/}" fort.1


#SET STRENGTH OF TORSIONAL POTENTIAL
bash ${SHELL_PATH}/setup_FF.sh ${kphi}

#RUN SIMULATION IN PARALLEL
bash ${SHELL_PATH}/run_para.sh 

#CENTER THE DNA
python ${PYTHON_PATH}/center.py fort.8
mv fort_center.xyz sim.xyz

cd ..




