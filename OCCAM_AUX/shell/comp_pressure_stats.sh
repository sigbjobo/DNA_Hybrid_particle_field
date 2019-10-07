

# Analyze fort.7
function_name () { 
    fn=$1
    search_name=$2    
    name=$(python3 -c "print('${search_name}'.replace('_','').replace(' ','').upper())")
    folder=$(dirname ${filename})

    rm -f ${name}_PLOT_DATA.dat
    echo -e "#\t$folder\t">${folder}/${name}_PLOT_DATA.dat  
#    echo "$search_name"
    cat ${folder}/fort.7 |  grep "$search_name"         | awk  ' {print $1"\t"$2}' >> ${folder}/${name}_PLOT_DATA.dat         
}

search_names=("vol" "    dens" "    press " "L_x" "L_z" "pressxx " "presszz " "etot_W" "  press_avg" "pressxx_avg" "presszz_avg")
for filename in $(find SIM_* | grep fort.7); do
   
    for sn in "${search_names[@]}";do
	function_name $filename "$sn"
    done
  
done

rm -rf PRESSURE_DATA/
mkdir PRESSURE_DATA/
cd PRESSURE_DATA/
# COMBINE ALL FILES
for sn in "${search_names[@]}";do    
    name1=$(python3 -c "print('${sn}'.replace('_','').replace(' ','').upper())")
    name2=$(python3 -c "print('${sn}'.replace('_','').replace(' ','').lower())")
    paste -d '\t' ../SIM_*/${name1}_PLOT_DATA.dat     >> ${name2}.dat     
    sort -n -k 1 -o ${name2}.dat     ${name2}.dat     
    python3 ${PYTHON_PATH}/combine_press.py ${name2}.dat      
done
cd ..
