PYTHON_PATH="/cluster/home/sigbjobo/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/python"

rm tors
mkdir tors
ls -d *_bond | xargs -L 1 -n 1 -P 4 bash -c 'cd $0 && python3  ${PYTHON_PATH}/comp_averages.py && cd ../ && cp $0/tor.dat tors/$0.dat'