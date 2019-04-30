
rm PLOTS/*


# Single chain phase diagram
cd single_pd
gnuplot plot_pd.gnuplot
gnuplot plot_pd_single.gnuplot


a=$(find .  | grep .tex)
for i in $a; do pdflatex -interaction=batchmode  $i;done

a=$(find . | grep -v "converted" |  grep .pdf)
for i in $a; do mv $i ../PLOTS/;done

rm *aux *eps *log *pdf *~ *tex
cd ..

# Double strand persistence
cd persistence_double
gnuplot plot_ds_per.gnuplot

a=$(find .  | grep .tex)
for i in $a; do pdflatex -interaction=batchmode  $i;done

a=$(find . | grep -v "converted" |  grep .pdf)
for i in $a; do mv $i ../PLOTS/;done

rm *aux *eps *log *pdf *~ *tex
cd ..


cd plot_intra
gnuplot plot_averages.gnuplot
pdflatex -interaction=batchmode  ang_mean.tex
pdflatex -interaction=batchmode  bond_mean.tex
pdflatex -interaction=batchmode  tor_mean.tex

mv tor_mean.pdf ../PLOTS/
mv ang_mean.pdf ../PLOTS/
mv bond_mean.pdf ../PLOTS/
rm *aux *eps *log *pdf *~ *tex

cd ..

#k_phi and basepairs
cd k_bonds
gnuplot basepair.gnuplot

pdflatex -interaction=batchmode  basepairs.tex
pdflatex -interaction=batchmode  basepairs_ang.tex

mv basepairs.pdf ../PLOTS/
mv basepairs_ang.pdf ../PLOTS/
rm *aux *eps *log *pdf *~ *tex
cd ..

cd alpha_bonds
gnuplot basepair.gnuplot

pdflatex -interaction=batchmode  basepairs.tex
pdflatex -interaction=batchmode  basepairs_ang.tex

mv basepairs.pdf ../PLOTS/bp_alpha.pdf
mv basepairs_ang.pdf ../PLOTS/bp_ang_alpha.pdf
rm *aux *eps *log *pdf *~ *tex
cd ..

cd beta_bonds
gnuplot basepair.gnuplot

pdflatex -interaction=batchmode  basepairs.tex
pdflatex -interaction=batchmode  basepairs_ang.tex

mv basepairs.pdf ../PLOTS/bp_beta.pdf
mv basepairs_ang.pdf ../PLOTS/bp_ang_beta.pdf
rm *aux *eps *log *pdf *~ *tex
cd ..


cd salt_bonds
gnuplot basepair.gnuplot

pdflatex -interaction=batchmode  basepairs.tex
pdflatex -interaction=batchmode  basepairs_ang.tex

mv basepairs.pdf ../PLOTS/bp_salt.pdf
mv basepairs_ang.pdf ../PLOTS/bp_ang_salt.pdf
rm *aux *eps *log *pdf *~ *tex
cd ..

#End-end distance
cd persistence
gnuplot plot_end.gnuplot
pdflatex -interaction=batchmode  end_end.tex
pdflatex -interaction=batchmode  end_end_dist.tex
pdflatex -interaction=batchmode  end_end_mean.tex

mv end_end.pdf ../PLOTS/
mv end_end_dist.pdf ../PLOTS/
mv end_end_mean.pdf ../PLOTS/

rm *aux *eps *log *pdf *~ *tex
cd ..

cd benchmark
gnuplot plot_bench.gnuplot

pdflatex -interaction=batchmode  bench_scaling.tex
mv bench_scaling.pdf ../PLOTS/

rm *aux *eps *log *pdf *~ *tex
cd ..


cd optimize
gnuplot plot_conv.gnuplot

pdflatex -interaction=batchmode  eta_opt.tex
pdflatex -interaction=batchmode  chi_opt.tex


mv *_opt.pdf ../PLOTS/
rm *aux *eps *log *pdf *~ *tex
cd ..


#HAIRPIN
cd hairpin
gnuplot plot_hairpin.gnuplot
pdflatex -interaction=batchmode  hairpin-form.tex

mv hairpin-form.pdf ../PLOTS/
rm *aux *eps *log *pdf *~ *tex
cd ..
