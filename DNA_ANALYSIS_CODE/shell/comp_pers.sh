
rm fold.dat
ls -d SIM_*/ > fold.dat
PYTHON_PATH="/cluster/home/sigbjobo/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/python"
SHELL_PATH="/cluster/home/sigbjobo/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/shell"


rm -r PLOT_DATA/
mkdir PLOT_DATA/
while read fi
do
    a=($(echo "$fi" | tr '/' '\n'))
    cd $fi
    python ${PYTHON_PATH}/persistence.py fort.8

    TRJ_PRINT=$(awk '/trj_print:/{getline; print}' fort.1)
#    echo "${TRJ_PRINT}"
    echo "#time">../pos.dat
    echo "${fi}">end.dat
    cat end_end.dat | awk  '{printf("%.2f\n"),  $1*20000*0.03*0.001 }' >>../pos.dat
    cat end_end.dat | awk  '{printf("%.2f\n"),  $2 }' >>end.dat

    
    mv end_end.dat end_end.xvg
    b=$(gmx analyze -f end_end.xvg -dist -bw 2.5 -b 800 | grep SS1 | awk '{printf("%.2f %.2f\n"),$2 ,$3}')

    a2=$(python -c "print('$a'.split('_')[1])")
    echo "$a2 $b">> ../PLOT_DATA/mean.dat

    grep -v "@\|#" distr.xvg > ../PLOT_DATA/"${a}".xvg
    mv contact.dat ../PLOT_DATA/contact_"${a}".dat

    cd ../
done < fold.dat




paste -d '\t' {pos.dat,SIM_*/end.dat}     >> PLOT_DATA/END_END.dat
