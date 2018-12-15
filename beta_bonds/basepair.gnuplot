set terminal epslatex size 2.4,1.8 font ",10" standalone header '\usepackage{siunitx}'  
#3.42.3
#bending
set output 'basepairs.tex'
set border lw 2
#set tics lw 2
set xlabel '$\beta/\si{kJ.mol^{-1}}$'
set ylabel '$d_{\si{bp}}/\si{nm}$'
#set format "\\rotatebox"
#set boxwidth 0.25
set xtics #rotate by 60 right
#set yrange [0:0.9]
set xrange [-0.5:4.5]
set key top left
set bars 4.0
set style fill empty
set key right top
plot 'bp.dat' using 0:3:2:6:5:xticlabels(1) with candlesticks  lt -1 lw 2 title 'Quartiles' whiskerbars , \
     ''         using 0:4:4:4:4:xticlabels(1) with candlesticks  lt -1 lw 2 notitle


#3.42.3
#bending
set output 'basepairs_ang.tex'

set ylabel '$\angle/^{\circ}$'
#set format "\\rotatebox"

set xtics #rotate by 60 right
set yrange [0:180]
set ytics 30
#set xrange [4:11]
set key top left
set bars 4.0
set style fill empty
unset key
plot 'bp.dat' using 0:8:7:11:10:xticlabels(1) with candlesticks  lt -1 lw 2 title 'Quartiles' whiskerbars , \
     ''         using 0:9:9:9:9:xticlabels(1) with candlesticks  lt -1 lw 2 notitle 