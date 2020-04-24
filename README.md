PIA commander is the commandline version of the Phylogenetically Informed Annotation pipeline originally implemented in Galaxy (Speiser et al. 2014, BMC Bioinformatics, https://doi.org/10.1186/s12859-014-0350-x). As of 2018 January 31, it only looks for opsins, sorry!

# Things you'll need to do before running PIA commander
Make sure you have the following programs in your path:
* Transdecoder (https://github.com/TransDecoder/TransDecoder)
* Blast+ suite (for blastp and blast_formatter; https://www.ncbi.nlm.nih.gov/books/NBK279671/) 
* Seqtk (https://github.com/lh3/seqtk)
* CD-HIT (http://weizhongli-lab.org/cd-hit/)
* MAFFT (https://mafft.cbrc.jp/alignment/software/)
* RAxML (https://cme.h-its.org/exelixis/web/software/raxml/index.html)

# Usage
***USAGE:*** To run the PIA pipeline, add PIA/opsin_PIA_commander/scripts to your path and run PIA_pipeline.py as an executable like so:
```
PIA_pipeline.py /PATH/TO/PIA/opsin_PIA_commander/
```

* To make the script executable, navigate to the PIA/opsin_PIA_commander/scripts directory and type 
```
chmod +x PIA_pipeline.py
```

* Put copies of your assemblies in the data/assemblies folder with the *.fa extension.

* If you want a more stringent e-value, change that in script 2.

* If you don't like the shortened name given to the various output files, change the "name=..." command to your liking in the shell scripts!

* In general, to run the pipeline, run script 1 first, then script 2, then run the 'PIA' jobs (see note below). These jobs run mafft and then RAxML to place the candidate sequences. _NOTE: This next step will be automatic when using the python wrapper_

* The last step in script 2 creates job files for running with sbatch or qsub. You'll need to change the template job script that creates those files for use with another scheduler. You can also run the scripts locally on your computer by changing the permissions with chmod +x make the jobs executable. But if you're running a bunch of transcriptomes through this pipeline, you'd save time and keep your own computer free by running the jobs in paralell on a supercomputer.

* The output tree with your potential sequences is in a file that starts with "RAxML_labelledTree", one per transcriptome you started with. The blast hits are marked as "QUERY". You should root the tree with Trichoplax opsins (find "no_comment"). Most of the sequences around your queries will be annotated with names that correspond to bilaterian opsin groups from Ramirez et al. 2016 Genome Biology and Evolution.

# Citations
* Speiser DI, et al. 2014. Using phylogenetically-informed annotation (PIA) to search for light-interacting genes in transcriptomes from non-model organisms. BMC Bioinformatics. 15:350.
* Ramirez MD, et al. 2016 The last common ancestor of most bilaterian animals possessed at least nine opsins. Genome Biology and Evolution. 12: 3640–3652. 
* Gingras MA, et al. In prep. Nudibranch opsins: identification, localization, and potential roles in extraocular photoreception and circadian rhythms.

## Citation information for some of the  programs in this pipeline
* Camacho C, et al. 2009. BLAST+: architecture and applications. BMC Bioinformatics. 10: 421.
* Li, W, & Godzik, A. 2006. Cd-hit: a fast program for clustering and comparing large sets of protein or nucleotide sequences. Bioinformatics. 22: 1658-1659.
* Limin F, et al. 2012. CD-HIT: accelerated for clustering the next generation sequencing data. Bioinformatics. 28: 3150-3152. doi: 10.1093/bioinformatics/bts565.
* Katoh K., et al. 2002. MAFFT: a novel method for rapid multiple sequence alignment based on fast Fourier transform. Nucleic acids research. 30: 3059-3066.
* Stamatakis A. 2014. RAxML version 8: a tool for phylogenetic analysis and post-analysis of large phylogenies. Bioinformatics. 10: 1312-1313.
