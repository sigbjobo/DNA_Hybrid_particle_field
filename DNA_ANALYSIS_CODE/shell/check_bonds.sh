
PYTHON_PATH="/home/sigbjobo/Documents/DNA_Project/DNA_CODE_PLOT/DNA_ANALYSIS_CODE/python"
py_prog="${PYTHON_PATH}/comp_bonds.py"
echo $py_prog
rm bp.dat

array=($(ls -d sim*/1_bond))
for ai in "${array[@]}"
do
    cd $ai
    python ${PYTHON_PATH}/comp_bonds.py sim.xyz
    rm bonds.xvg
    awk '{print $1}' bonds.dat > bonds.xvg
    awk '{print $2}' bonds.dat > angs.xvg 
    a="$(echo $ai | tr -s '_' | cut -d '_' -f 2 |tr -s '/' | cut -d '/' -f 1)"
    
    b=$(python ${PYTHON_PATH}/box_whis.py bonds.xvg)
    c=$(python ${PYTHON_PATH}/box_whis.py angs.xvg)
    echo "$a $b $c" >> ../../bp.dat
    cd ../../
done
sort -k1 -n bp.dat > a.dat
mv a.dat bp.dat

