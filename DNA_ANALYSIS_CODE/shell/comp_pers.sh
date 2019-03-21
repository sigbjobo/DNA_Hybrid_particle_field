

ls -d sim_*/1_bond/ > fold.dat
PYTHON_PATH="/cluster/home/sigbjobo/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/python"
SHELL_PATH="/cluster/home/sigbjobo/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/shell"

while read fi
do
    a=($(echo "$fi" | tr '/' '\n'))
    cd $fi
    python ${PYTHON_PATH}/persistence.py sim.xyz
    cp end_end.dat ../../${a[0]}.dat 
    cd ../../
done < fold.dat

