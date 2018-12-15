s_folder=/home/sigbjobo/Stallo/Projects/DNA/SIM/continuation/structure/ss/BI/script

py_prog="${s_folder}/comp_bonds.py"
echo $py_prog
rm bp.dat

array=($(ls -d sim*/1_bond))
for ai in "${array[@]}"
do
    cd $ai
    python $s_folder/comp_bonds.py sim.xyz
    rm bonds.xvg
    awk '{print $1}' bonds.dat > bonds.xvg
    awk '{print $2}' bonds.dat > angs.xvg 
    a="$(echo $ai | tr -s '_' | cut -d '_' -f 2 |tr -s '/' | cut -d '/' -f 1)"
    
    b=$(python $s_folder/box_whis.py bonds.xvg)
    c=$(python $s_folder/box_whis.py angs.xvg)
    echo "$a $b $c" >> ../../bp.dat
    cd ../../
done
sort -k1 -n bp.dat > a.dat
mv a.dat bp.dat

