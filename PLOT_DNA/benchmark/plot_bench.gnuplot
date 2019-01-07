set terminal epslatex size 3.4,2.3 font ",10" standalone header '\usepackage{siunitx}'  
#3.42.3
#bending
set output "bench_scaling.tex"
set border lw 2
set ylabel '$t/\si{s}$'
set xlabel '$N_{\si{proc}}$'
set yrange [0.0001:]
set logscale y
plot "data/66666.dat"   using ($1):($2/50000) w l lw 2 notitle 