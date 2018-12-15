rm tors
mkdir tors
ls -d *_bond | xargs -L 1 -n 1 -P 4 bash -c 'cd $0 && python /home/sigbjobo/Projects/DNA/SIM/continuation/structure/ss/BI/script/comp_averages.py && cd ../ && cp $0/tor.dat tors/$0.dat'
