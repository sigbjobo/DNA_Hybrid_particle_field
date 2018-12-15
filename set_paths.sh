# sets path for scripts
A=$(pwd)
SHELL_PATH="${A}/DNA_ANALYSIS_CODE/shell"
PYTHON_PATH="${A}/DNA_ANALYSIS_CODE/python"


#FIX SHELL SCRIPTS
sed -i 's|PYTHON_PATH=.*|PYTHON_PATH="'"$PYTHON_PATH"'"|g' ${SHELL_PATH}/*.sh
sed -i 's|SHELL_PATH=.*|SHELL_PATH="'"$SHELL_PATH"'"|g' ${SHELL_PATH}/*.sh


#FIX PYTHON
p=sys.path.append
EXTRA_PATH="home/sigbjobo/Stallo/Projects/DNA/DNA_CODE_PLOT/DNA_ANALYSIS_CODE/python"
sed -i "s|${p}.*|${p}(\"${PYTHON_PATH}\")|g" ${PYTHON_PATH}/*.py
sed -i "1,\|${p}|{s|${p}.*|${p}(\"${EXTRA_PATH}\")|g}" ${PYTHON_PATH}/*py



