#!/usr/bin/env python3
#
# This file is a python wrapper to run the full PIA pipeline for transcriptome data
# Dependencies: BLAST+ (with makeblastdb), Transdecoder, Seqtk, CD-HIT, Mafft, RAxML (with pthreads option), and qsub or sbatch command
#
# Python wrapper written by: Jessica A. Goodheart
#
# Citations: 
#
# (1) Speiser DI, et al. 2014. Using phylogenetically-informed annotation (PIA) to search for light-interacting genes in transcriptomes from non-model organisms. BMC Bioinformatics. 15:350.
# (2) Gingras MA, et al. In review. Nudibranch opsins: identification, localization, and potential roles in extraocular photoreception and circadian rhythms.
#
# USAGE: PIA_pipeline.py /PATH/TO/PIA/opsin_PIA_commander/ 
#
# NOTE: Prior to running this wrapper, all transcriptomes (or symbolic links to transcriptomes), must be placed in the /PIA/opsin_PIA_commander/data/assemblies/ directory.
# NOTE: Make program executable with 'chmod a+x' if script is not working

import sys
import subprocess
import argparse

parser = argparse.ArgumentParser(description='This script is a python wrapper to run the full PIA pipeline for transcriptome data.')
parser.add_argument('path', help='provide /PATH/TO/PIA/opsin_PIA_commander/')
args = parser.parse_args()
path = args.path

programs = ['makeblastdb', 'TransDecoder.LongOrfs', 'blastp', 'blast_formatter', 'seqtk', 'cd-hit', 'mafft', 'raxmlHPC-PTHREADS']

######### Begin dependency check #######
print('\nChecking for dependencies...')
failed = []
cmd = 'which'
for i in programs:
    try:
        str(subprocess.check_output([cmd, i]))
    except subprocess.CalledProcessError as e:
        failed.append(i)
        print('\n')

queue = 0
sbatch = 'sbatch'
qsub = 'qsub'
try:
    str(subprocess.check_output([cmd, sbatch]))
except subprocess.CalledProcessError as e:
    try: 
        str(subprocess.check_output([cmd, sbatch]))
        queue = 1
    except subprocess.CalledProcessError as e:
        queue = 2

if len(failed) != 0:
    sys.exit("\n\nPIA RUN FAILED: Missing dependencies, please check above output")
else:
    print("SUCCESS! All dependencies found.\n")
######### End dependency check #########


######### Begin PIA Pipeline ########### 
# Running first bash script, 1_transdecoder_makeblastdb.sh
print('Making blast protein database for each transcriptome...\n')
script1 = "sh " + path + "scripts/1_transdecoder_makeblastdb.sh " + path
subprocess.run(script1, shell=True)

# Running second bash script, 2_blast_tidy_headers_cdhit_make_PIA_jobs_*.sh depending on whether sbathc or qsub is present
print('Identifying candidates and starting RAxML analysis...\n')

if queue == 0:
    script2 = "sh " + path + "scripts/2_blast_tidy_headers_cdhit_make_PIA_jobs_sbatch.sh " + path
    subprocess.run(script2, shell=True)
elif queue == 1:
    script2 = "sh " + path + "scripts/2_blast_tidy_headers_cdhit_make_PIA_jobs_qsub.sh " + path
    subprocess.run(script2, shell=True)
elif queue == 2:
    script2 = "sh " + path + "scripts/2_blast_tidy_headers_cdhit_make_PIA_jobs_local.sh " + path
    subprocess.run(script2, shell=True)

######### End PIA Pipeline #############

print('PIA run complete! Output files will be in /PIA/opsin_PIA_commander/analysis/PIA/ once RAxML run has completed.\n')

