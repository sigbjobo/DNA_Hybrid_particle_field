rm XY.dat
ls -ld sim_* | awk '{print $9}' > folds.dat
while read p; do
    echo $p
    cd ${p}
    a=$(tail -n 6 fort.3 | head -n 1 | awk '{print $7 " " $6}')
    
    b=$(python ../eval_fit.py sim.xyz)
    cd ..

    echo $a $b >> XY.dat
done <folds.dat
rm folds.dat