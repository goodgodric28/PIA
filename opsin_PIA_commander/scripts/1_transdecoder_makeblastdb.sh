#!/bin/bash

COMMANDER_HOME=$1

cd "$COMMANDER_HOME"/data/assemblies/

# This one does all the files if they end in .fa
LIST="$(ls *.fa)"

# uses bash to find files, but beware of hidden files and path in the names!
#LIST="$(find . -type f -maxdepth 0)"

for assembly in $LIST
do

cd "$COMMANDER_HOME"/data/peptides/

TransDecoder.LongOrfs -t "$COMMANDER_HOME"/data/assemblies/"$assembly" -m 50

cd "$COMMANDER_HOME"/data/peptides/"$assembly".transdecoder_dir/

makeblastdb -in longest_orfs.pep -dbtype prot -parse_seqids -out "$COMMANDER_HOME"/data/blast_dbs/"$assembly".blastdb

cd "$COMMANDER_HOME"/data/assemblies

done
