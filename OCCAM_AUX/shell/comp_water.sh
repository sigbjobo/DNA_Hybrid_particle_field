
rm vol.dat dens.dat press.dat pressxx.dat presszz.dat lx.dat lz.dat etot_W.dat
for filename in $(find SIM_* | grep fort.7); do
    folder=$(dirname ${filename})

    echo -e "#\t$folder\t">${folder}/VOL_PLOT_DATA.dat     
    echo -e "#\t$folder\t">${folder}/DENS_PLOT_DATA.dat    
    echo -e "#\t$folder\t">${folder}/PRESS_PLOT_DATA.dat        
    echo -e "#\t$folder\t">${folder}/LX_PLOT_DATA.dat      
    echo -e "#\t$folder\t">${folder}/LZ_PLOT_DATA.dat      
    echo -e "#\t$folder\t">${folder}/PRESSXX_PLOT_DATA.dat      
    echo -e "#\t$folder\t">${folder}/PRESSZZ_PLOT_DATA.dat 
    echo -e "#\t$folder\t">${folder}/ETOT_W_DATA.dat       
    


    cat ${folder}/fort.7 |  grep "vol"         | awk  ' {print $1 "\t" $2}' >> ${folder}/VOL_PLOT_DATA.dat     
    cat ${folder}/fort.7 |  grep "    dens"    | awk  ' {print $1 "\t" $2}' >> ${folder}/DENS_PLOT_DATA.dat    
    cat ${folder}/fort.7 |  grep "    press "  | awk  ' {print $1 "\t" $2}' >> ${folder}/PRESS_PLOT_DATA.dat   
    cat ${folder}/fort.7 |  grep "L_x"         | awk  ' {print $1 "\t" $2}' >> ${folder}/LX_PLOT_DATA.dat      
    cat ${folder}/fort.7 |  grep "L_z"         | awk  ' {print $1 "\t" $2}' >> ${folder}/LZ_PLOT_DATA.dat      
    cat ${folder}/fort.7 |  grep "pressxx"     | awk  ' {print $1 "\t" $2}' >> ${folder}/PRESSXX_PLOT_DATA.dat 
    cat ${folder}/fort.7 |  grep "presszz"     | awk  ' {print $1 "\t" $2}' >> ${folder}/PRESSZZ_PLOT_DATA.dat 
    cat ${folder}/fort.7 |  grep "etot_W"      | awk  ' {print $1 "\t" $2}' >> ${folder}/ETOT_W_DATA.dat       

done

paste -d '\t' SIM_*/VOL_PLOT_DATA.dat >> vol.dat
paste -d '\t' SIM_*/DENS_PLOT_DATA.dat >> dens.dat
paste -d '\t' SIM_*/PRESS_PLOT_DATA.dat >> press.dat
paste -d '\t' SIM_*/PRESSXX_PLOT_DATA.dat >> pressxx.dat
paste -d '\t' SIM_*/PRESSZZ_PLOT_DATA.dat >> presszz.dat
paste -d '\t' SIM_*/LX_PLOT_DATA.dat >> lx.dat
paste -d '\t' SIM_*/LZ_PLOT_DATA.dat >> lz.dat
paste -d '\t' SIM_*/ETOT_W_DATA.dat >> etot_W.dat

