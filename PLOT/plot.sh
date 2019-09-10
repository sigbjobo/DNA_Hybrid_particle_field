
rm PLOTS/*

compile_plot(){

    # CHANGE DIRECTORY TO DIRECTORY CONTAINING PLOTING-SCRIPTS
    cd $1

    # RUN GNULOT
    for i in $(find .  | grep .gnuplot); do gnuplot   $i;done
    
    # RUN PDFLATEX
    for i in $(find .  | grep .tex); do pdflatex -interaction=batchmode  $i;done

    # MOVE FINAL PLOT FILES TO COMMON AREA
    for i in $(find . | grep -v "converted" |  grep .pdf); do mv $i ../PLOTS/;done

    # REMOVE RESIDUAL FILES
    rm *aux *eps *log *pdf *~ *tex

    cd ..
}


# COMPILE EACH DIRECTORY
compile_plot single_pd
compile_plot persistence_double
compile_plot plot_intra
compile_plot k_bonds
compile_plot alpha_bonds
compile_plot beta_bonds
compile_plot salt_bonds
compile_plot persistence
compile_plot benchmark
compile_plot optimize
compile_plot hairpin
compile_plot water_eq_state
compile_plot membranes

