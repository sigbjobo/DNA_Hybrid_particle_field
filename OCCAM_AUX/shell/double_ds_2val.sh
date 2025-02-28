
dnaseq=$1
dnaseq2=$2
L=$3 #nm
I=$4 #mM
PYTHON_PATH="/cluster/home/sigbjobo/DNA/HPF/OCCAM_AUX/python"

python3 ${PYTHON_PATH}/make_fort5.py $dnaseq $L 0
mv fort.5 fort_1.5


python3 ${PYTHON_PATH}/make_fort5.py $dnaseq2 $L 1
mv fort.5 fort_2.5


python3 ${PYTHON_PATH}/insert.py fort.5 fort_1.5 fort_2.5
rm fort_2.5 fort_1.5


NP=$(grep -nr "P" fort.5 | wc | awk '{print $1;}')
N_NA=$(python3 -c "print(int(0.25*$I*6.022E23*($L*1E-9)**3+0.5*$NP))")
N_CL=$(python3 -c "print(int(0.25*$I*6.022E23*($L*1E-9)**3))") 
 

python3 ${PYTHON_PATH}/solvate_dna.py fort.5 fort_solv.5 $N_NA $N_CL
echo ""
echo "Number of different bead types:"
echo "Number of A:"
grep -nr "A" fort.5 | wc | awk '{print $1;}'
echo "Number of T:"
grep -nr "T" fort.5 | wc | awk '{print $1;}'
echo "Number of C:"
grep -nr "C" fort.5 | wc | awk '{print $1;}'
echo "Number of G:"
grep -nr "G" fort.5 | wc | awk '{print $1;}'
echo "Number of S:"
grep -nr "S" fort.5 | wc | awk '{print $1;}'
echo "Number of P:"
grep -nr "P" fort.5 | wc | awk '{print $1;}'
echo "Number of W:"
grep -nr "W" fort_solv.5 | wc  | awk '{print $1;}'
echo "Number of NA:"
grep -nr "NA" fort_solv.5 | wc | awk '{print $1;}'
echo "Number of CL:"
grep -nr "CL" fort_solv.5 | wc | awk '{print $1;}'

echo ""
echo "Final salt concentration:"
echo "preset: $I mM"
conc=$(python3 -c "print(4*$N_CL/(6.022E23*($L*1E-9)**3))")
echo "obtained: $conc mM"

mv fort_solv.5 fort.5

