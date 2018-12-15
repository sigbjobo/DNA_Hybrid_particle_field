
rm PLOTS/*

cd plot_intra
gnuplot plot_averages.gnuplot
pdflatex ang_mean.tex
pdflatex bond_mean.tex
pdflatex tor_mean.tex

mv tor_mean.pdf ../PLOTS/
mv ang_mean.pdf ../PLOTS/
mv bond_mean.pdf ../PLOTS/
rm *aux *eps *log *pdf *~ *tex

cd ..

#k_phi and basepairs
cd k_bonds
gnuplot basepair.gnuplot

pdflatex basepairs.tex
pdflatex basepairs_ang.tex

mv basepairs.pdf ../PLOTS/
mv basepairs_ang.pdf ../PLOTS/
rm *aux *eps *log *pdf *~ *tex
cd ..

cd alpha_bonds
gnuplot basepair.gnuplot

pdflatex basepairs.tex
pdflatex basepairs_ang.tex

mv basepairs.pdf ../PLOTS/bp_alpha.pdf
mv basepairs_ang.pdf ../PLOTS/bp_ang_alpha.pdf
rm *aux *eps *log *pdf *~ *tex
cd ..

cd beta_bonds
gnuplot basepair.gnuplot

pdflatex basepairs.tex
pdflatex basepairs_ang.tex

mv basepairs.pdf ../PLOTS/bp_beta.pdf
mv basepairs_ang.pdf ../PLOTS/bp_ang_beta.pdf
rm *aux *eps *log *pdf *~ *tex
cd ..


cd salt_bonds
gnuplot basepair.gnuplot

pdflatex basepairs.tex
pdflatex basepairs_ang.tex

mv basepairs.pdf ../PLOTS/bp_salt.pdf
mv basepairs_ang.pdf ../PLOTS/bp_ang_salt.pdf
rm *aux *eps *log *pdf *~ *tex
cd ..

#End-end distance

cd persistence
gnuplot plot_end.gnuplot

pdflatex end_end.tex
mv end_end.pdf ../PLOTS/

rm *aux *eps *log *pdf *~ *tex
cd ..
