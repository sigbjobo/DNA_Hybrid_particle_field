NCPU=$1
NMOL=$(head  fort.5 -n 5 | tail -n 1 | awk '{print $1}')
NATOM=$(tail fort.5 -n 1 | awk '{print $1}')
NMOLA=1
NATOMA=205
NMOLB=$(grep -nr "NA" fort.5 | wc | awk '{print $1;}')
NATOMB=1
NMOLC=$(grep -nr "CL" fort.5 | wc | awk '{print $1;}')
NATOMC=1
NMOLD=$(grep -nr "W" fort.5 | wc | awk '{print $1;}')
NATOMD=1

TRJ_PRINT=$(awk '/trj_print:/{getline; print}' fort.1)
STEPS=$(awk '/number_of_steps:/{getline; print}' fort.1)
NCONF=$(python -c "int(${STEPS}//${TRJ_PRINT}+2)")


rm input.txt
echo "1" >>input.txt
echo "$NMOL"   >> input.txt
echo "$NATOM"  >> input.txt
echo "$NMOLA"  >> input.txt
echo "$NATOMA" >> input.txt
echo "$NMOLB"  >> input.txt
echo "$NATOMB" >> input.txt
echo "$NMOLC"  >> input.txt
echo "$NATOMC" >> input.txt
echo "$NMOLD"  >> input.txt
echo "$NATOMD" >> input.txt
echo "1"       >> input.txt
echo "$NCPU"   >> input.txt
#echo "$NCONF"   >> input.txt
