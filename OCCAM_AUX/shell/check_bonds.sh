PYTHON_PATH="/cluster/home/sigbjobo/DNA/HPF/OCCAM_AUX/python"

rm bp.dat

array=($(ls -d sim*/1_bond))
for ai in "${array[@]}"
do
    cd $ai
    python3 ${PYTHON_PATH}/comp_bonds.py sim.xyz
    rm bonds.xvg
    awk '{print $1}' bonds.dat > bonds.xvg
    awk '{print $2}' bonds.dat > angs.xvg 
    a="$(echo $ai | tr -s '_' | cut -d '_' -f 2 |tr -s '/' | cut -d '/' -f 1)"
    
    b=$(python3 ${PYTHON_PATH}/box_whis.py bonds.xvg)
    c=$(python3 ${PYTHON_PATH}/box_whis.py angs.xvg)
    echo "$a $b $c" >> ../../bp.dat
    cd ../../
done
sort -k1 -n bp.dat > a.dat
mv a.dat bp.dat

