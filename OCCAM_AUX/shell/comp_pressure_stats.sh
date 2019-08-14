
rm vol.dat dens.dat press.dat pressxx.dat presszz.dat lx.dat lz.dat etot_W.dat
# echo -e "#\c">>vol.dat
# echo -e "#\c">>dens.dat
# echo -e "#\c">>press.dat
# echo -e "#\c">>pressxx.dat
# echo -e "#\c">>presszz.dat
# echo -e "#\c">>lx.dat
# echo -e "#\c">>lz.dat
# echo -e "#\c">>etot_W.dat
for filename in $(find SIM_* | grep fort.7); do
   
    
    #echo "${filename}"
    folder=$(dirname ${filename})
    # echo -e "\t $folder \t\c">>vol.dat
    # echo -e "\t $folder \t\c">>dens.dat
    # echo -e "\t $folder \t\c">>press.dat
    # echo -e "\t $folder \t\c">>pressxx.dat
    # echo -e "\t $folder \t\c">>presszz.dat
    # echo -e "\t $folder \t\c">>lx.dat
    # echo -e "\t $folder \t\c">>lz.dat
    # echo -e "\t $folder \t\c">>etot_W.dat

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
    cat ${folder}/fort.7 |  grep "pressxx "     | awk  ' {print $1 "\t" $2}' >> ${folder}/PRESSXX_PLOT_DATA.dat 
    cat ${folder}/fort.7 |  grep "presszz "     | awk  ' {print $1 "\t" $2}' >> ${folder}/PRESSZZ_PLOT_DATA.dat 
    cat ${folder}/fort.7 |  grep "etot_W"      | awk  ' {print $1 "\t" $2}' >> ${folder}/ETOT_W_DATA.dat       

done
# echo "">> vol.dat
# echo "">> press.dat
# echo "">> dens.dat
# echo "">> lx.dat
# echo "">> lz.dat
# echo "">> pressxx.dat
# echo "">> presszz.dat
# echo "">> etot_W.dat
rm -rf PRESSURE_DATA/
mkdir PRESSURE_DATA/
paste -d '\t' SIM_*/VOL_PLOT_DATA.dat     >> PRESSURE_DATA/vol.dat     
paste -d '\t' SIM_*/DENS_PLOT_DATA.dat    >> PRESSURE_DATA/dens.dat    
paste -d '\t' SIM_*/PRESS_PLOT_DATA.dat   >> PRESSURE_DATA/press.dat   
paste -d '\t' SIM_*/PRESSXX_PLOT_DATA.dat >> PRESSURE_DATA/pressxx.dat 
paste -d '\t' SIM_*/PRESSZZ_PLOT_DATA.dat >> PRESSURE_DATA/presszz.dat 
paste -d '\t' SIM_*/LX_PLOT_DATA.dat      >> PRESSURE_DATA/lx.dat      
paste -d '\t' SIM_*/LZ_PLOT_DATA.dat      >> PRESSURE_DATA/lz.dat      
paste -d '\t' SIM_*/ETOT_W_DATA.dat       >> PRESSURE_DATA/etot_W.dat  


cd PRESSURE_DATA/
python ${PYTHON_PATH}/combine_press.py vol.dat     
python ${PYTHON_PATH}/combine_press.py dens.dat    
python ${PYTHON_PATH}/combine_press.py press.dat   
python ${PYTHON_PATH}/combine_press.py pressxx.dat 
python ${PYTHON_PATH}/combine_press.py presszz.dat 
python ${PYTHON_PATH}/combine_press.py lx.dat      
python ${PYTHON_PATH}/combine_press.py lz.dat      
python ${PYTHON_PATH}/combine_press.py etot_W.dat  

sort -n -k 1 -o vol.dat     vol.dat     
sort -n -k 1 -o	dens.dat    dens.dat    
sort -n -k 1 -o	press.dat   press.dat   
sort -n -k 1 -o	pressxx.dat pressxx.dat 
sort -n -k 1 -o	presszz.dat presszz.dat 
sort -n -k 1 -o	lx.dat      lx.dat      
sort -n -k 1 -o	lz.dat      lz.dat      
sort -n -k 1 -o	etot_W.dat  etot_W.dat  
cd ..
