PIA commander is the commandline version of the Phylogenetically Informed Annotation pipeline originally implemented in Galaxy (Speiser et al. 2014, BMC Bioinformatics, https://doi.org/10.1186/s12859-014-0350-x). As of 2018 January 31, it only looks for opsins, sorry!

# Things you'll need to do before running PIA commander
Make sure you have the following programs in your path:
*transdecoder
*blast+ suite (for blastp and blast_formatter)
*seqtk
*cd-hit
*mafft
*raxml

# Usage
***USAGE:*** To run the PIA pipeline, add PIA/opsin_PIA_commander/scripts to your path and run PIA_pipeline.py as an executable like so: 'PIA_pipeline.py /PATH/TO/PIA/opsin_PIA_commander/

* To make the script executable, navigate to the PIA/opsin_PIA_commander/scripts directory and type 'chmod +x PIA_pipeline.py'

* Put copies of your assemblies in the data/assemblies folder

* If you want a more stringent e-value, change that in script 2.

* If you don't like the shortened name given to the various output files, change the "name=..." command to your liking in the shell scripts!

* In general, to run the pipeline, run script 1 first, then script 2, then run the 'PIA' jobs (see note below). These jobs run mafft and then RAxML to place the candidate sequences. _NOTE: This next step will be automatic when using the python wrapper_

* The last step in script 2 creates job files for running with sbatch or qsub. You'll need to change the template job script that creates those files for use with another scheduler. You can also run the scripts locally on your computer by changing the permissions with chmod +x make the jobs executable. But if you're running a bunch of transcriptomes through this pipeline, you'd save time and keep your own computer free by running the jobs in paralell on a supercomputer.

* The output tree with your potential sequences is in a file that starts with "RAxML_labelledTree", one per transcriptome you started with. The blast hits are marked as "QUERY". You should root the tree with Trichoplax opsins (find "no_comment"). Most of the sequences around your queries will be annotated with names that correspond to bilaterian opsin groups from Ramirez et al. 2016 Genome Biology and Evolution.

# Citations
* Speiser DI, et al. 2014. Using phylogenetically-informed annotation (PIA) to search for light-interacting genes in transcriptomes from non-model organisms. BMC Bioinformatics. 15:350.
* Gingras MA, et al. In review. Nudibranch opsins: identification, localization, and potential roles in extraocular photoreception and circadian rhythms.

