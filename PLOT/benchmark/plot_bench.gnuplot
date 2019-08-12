set terminal epslatex size 3.4,2.3 font ",10" standalone header '\usepackage{siunitx}'  
#3.42.3
#bending
set output "bench_scaling.tex"
set border lw 2
set ylabel 'steps/\si{s}'
set xlabel '$N_{\si{proc}}$'
set logscale x 2
set logscale y
plot "data/66666.dat"   using ($1):(25000/$2) with linespoints lw 2 lc black notitle 