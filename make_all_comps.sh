#! /usr/bin/env bash


## COMPARE GENOMES
source ~soft_cvi_114/initializes/init_autoflow
GENOME_FILES="/mnt/home/users/pab_001_uma/pedro/proyectos/shewanella/genomes"
PROTEOME="/mnt/home/users/pab_001_uma/pedro/proyectos/shewanella/proteome/prots_clean.fasta"
while read QUERY
do
	sed 's/>/>Q_/g' "$GENOME_FILES/$QUERY" > "$GENOME_FILES/e_$QUERY"
	while read REF
	do
		OUTPUT="comps/$QUERY/$REF"
		mkdir -p $OUTPUT
		sed 's/>/>R_/g' "$GENOME_FILES/$REF" > "$GENOME_FILES/e_$REF"
		VARS=`echo "genomes_path=$GENOME_FILES
		query_genome=e_$QUERY
		ref_genome=e_$REF
		proteins_dataset=$PROTEOME
		coverage_identity_query=85+85
		coverage_identity_ref=85.0+85.0
		genomic=''" | sed 's/^/$/' | tr "\n" "," | tr -d "\t"`
		echo $VARS
		AutoFlow -w workflow_genome_sinteny_with_proteins -c 10 -s -n 'cal' -t '1-00:00:00' $1 -V $VARS -o $OUTPUT
	done < gen_refs
done < gen_queries

