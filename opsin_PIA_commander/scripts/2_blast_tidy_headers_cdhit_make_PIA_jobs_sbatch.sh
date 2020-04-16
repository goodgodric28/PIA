#!/bin/bash

COMMANDER_HOME=$1

cd "$COMMANDER_HOME"/data/assemblies

LIST="$(ls *.fa)"

for assembly in $LIST

do

name="$(echo "$assembly" | awk -F "." '{print $1}' | awk -F "_" 'BEGIN{OFS="_";} {print $1,$2}')"

cd "$COMMANDER_HOME"/analysis

#performs blast. You can change the e-value, but then it would be best to find/replace the e-value in the file names to keep multiple blast searches straight. This outputs in the blast archive format.
blastp -db "$COMMANDER_HOME"/data/blast_dbs/"$assembly".blastdb -query "$COMMANDER_HOME"/data/blast_baits/opsin_baits.fasta -out ./blast_results/"$name".opsin_blast_e-5_archive -evalue 1e-5 -outfmt 11

# converts the archive format to a table with the transcriptome sequence IDs that blasted to the baits.
blast_formatter -archive blast_results/"$name".opsin_blast_e-5_archive -outfmt "6 sseqid" -out blast_results/"$name".opsin_e-5.6sseqid

# creates a new file with only the unique sequence IDs for blast hits
sort -u blast_results/"$name".opsin_e-5.6sseqid > blast_results/"$name".opsin_unique_IDs_e-5.list

# uses the sequence IDs to find the actual transcript sequence from the transcriptomes you blasted.
seqtk subseq "$COMMANDER_HOME"/data/peptides/"$assembly".transdecoder_dir/longest_orfs.pep ./blast_results/"$name".opsin_unique_IDs_e-5.list > ./blast_results/"$name".opsin_seqs_e-5.fa

# creates a 'tidy' header for each sequence that adds the source transcriptome name to each sequence ID
cat blast_results/"$name".opsin_seqs_e-5.fa | awk -F' ' '{print $1,opsin}' | sed 's/\*//g' | sed 's/|/_/g' | sed 's/::/_/g' | sed "s/>/>$name\_/g" | sed 's/\./_/g' > cdhit/"$name".opsin_seqs_e-5_tidy.fa

done

cd "$COMMANDER_HOME"/analysis/cdhit

LIST="$(ls *tidy.fa)"

for i in $LIST

do

# runs CD-HIT to cluster highly similar sequences to 90% sequence identity. This can be changed, see CD-HIT manual for more info.
cd-hit -i "$i" -o 90_"$i" -c 0.9 -n 5 -M 16000 -d 0 -T 8

done

# creates a new list of the < 90% similar sequence fasta files in the cdhit folder
LIST="$(ls 90_*.fa)"

for seqs in $LIST

do

cd "$COMMANDER_HOME"/analysis/PIA
# creates a separate job file for each species/transcriptome so that they can be queued and run in parallel on cluster.
echo "#!/bin/bash

#SBATCH --job-name=PIA-raxml
#SBATCH --cpus-per-task=8
#SBATCH --time=24:00:00

cd "$COMMANDER_HOME"/analysis/PIA

mafft --add "$COMMANDER_HOME"/analysis/cdhit/"$seqs" --reorder "$COMMANDER_HOME"/analysis/PIA_gene_alignments/ramirez_metazoan_opsin_tidy_final.aln > "$seqs"_MAFFT_opsin_aligned.fa

raxmlHPC-PTHREADS -f v -s "$COMMANDER_HOME"/analysis/PIA/"$seqs"_MAFFT_opsin_aligned.fa -t "$COMMANDER_HOME"/analysis/PIA_gene_trees/ramirez_metazoan_opsin_phylo_final.treefile -m PROTGAMMAWAG -n "$seqs" -T 8

" > "$COMMANDER_HOME"/analysis/PIA/"$seqs".PIA.job

sbatch "$seqs".PIA.job
done
