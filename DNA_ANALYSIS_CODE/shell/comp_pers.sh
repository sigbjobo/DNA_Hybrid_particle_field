
rm fold.dat
ls -d SIM_*/ > fold.dat
PYTHON_PATH="/home/sigbjobo/Projects/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/python"
SHELL_PATH="/home/sigbjobo/Projects/DNA/DNA_Hybrid_particle_field/DNA_ANALYSIS_CODE/shell"

module load GROMACS/2018.3-intel-2018b

rm -r PLOT_DATA/
mkdir PLOT_DATA/
while read fi
do
    a=($(echo "$fi" | tr '/' '\n'))
    cd $fi
    python3 ${PYTHON_PATH}/persistence.py fort.8

    TRJ_PRINT=$(awk '/trj_print:/{getline; print}' fort.1)
#    echo "${TRJ_PRINT}"
    echo "#time">pos.dat
    echo "${fi}">end.dat
    cat end_end.dat | awk  '{printf("%.2f\n"),  $1*20000*0.03*0.001 }' >>pos.dat
    cat end_end.dat | awk  '{printf("%.2f\n"),  $2 }' >>end.dat

    a2=$(python3 -c "print('$a'.split('_')[1])")
    a3=$(python3 -c "print('$a'.split('_')[2])")
    test -z $a3 && echo "" || a2="$a2 $a3";
    test -z $a3 && echo "" || a2fn="$a2_$a3";
    

    
    mv end_end.dat end_end.xvg
    mv RG.dat RG.xvg
    b=$(gmx analyze -f end_end.xvg -dist -bw 2.5 -b 800 | grep SS1 | awk '{printf("%.2f %.2f\n"),$2 ,$3}')
        echo "$a2 $b">> ../PLOT_DATA/ee_mean.dat

    grep -v "@\|#" distr.xvg > ../PLOT_DATA/"${a2fn}"_ee_dist.xvg
    
    b=$(gmx analyze -f RG.xvg -dist -bw 2.5 -b 800 | grep SS1 | awk '{printf("%.2f %.2f\n"),$2 ,$3}')
    echo "$a2 $b">> ../PLOT_DATA/RG_mean.dat

    grep -v "@\|#" distr.xvg > ../PLOT_DATA/"${a2fn}"_RG_dist.xvg
    
    mv contact.dat ../PLOT_DATA/contact_"${a2fn}".dat
    paste -d '\t' {pos.dat,end.dat}     >> ../PLOT_DATA/${a2}_end.dat
    cd ../
done < fold.dat




#paste -d '\t' {pos.dat,SIM_*/end.dat}     >> PLOT_DATA/END_END.dat
