gnuplot plot_averages.gnuplot
pdflatex ang_mean.tex
pdflatex bond_mean.tex
pdflatex tor_mean.tex

rm PLOTS/*
mv tor_mean.pdf PLOTS/
mv ang_mean.pdf PLOTS/
mv bond_mean.pdf PLOTS/
rm *aux *eps *log *pdf *~ *tex


