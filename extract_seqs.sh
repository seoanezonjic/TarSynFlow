#! /usr/bin/env bash

coord_table="comps/Pdp11_1.fasta/"`head -n 1 gen_refs`"/procompart_0000/coord_table_with_strand"
genome="genomes/e_Pdp11_1.fasta"
genome_path="genomes"
coord_table_path="comps/Pdp11_1.fasta"

mkdir extracted_seqs
cut -f 1,2,5 results/Query_specific_filtered_annotated_prots.txt | grep -v -i fragment > extracted_seqs/seqs_list_query.txt
cut -f 1  extracted_seqs/seqs_list_query.txt > extracted_seqs/seqs_query.lst
grep -F -f extracted_seqs/seqs_query.lst $coord_table > extracted_seqs/seqs_coords_query.txt
scripts/get_seqs.rb -c extracted_seqs/seqs_coords_query.txt -f $genome -r 150 > extracted_seqs/seqs_query.fasta


cut -f 1,2,5 results/Ref_specific_filtered_annotated_prots.txt | grep -v -i fragment > extracted_seqs/seqs_list_ref.txt
cut -f 1  extracted_seqs/seqs_list_ref.txt > extracted_seqs/seqs_ref.lst

while read REF
do
        grep -F -f extracted_seqs/seqs_ref.lst $coord_table_path"/"$REF"/procompart_0001/coord_table_with_strand" > extracted_seqs/seqs_coords_ref_"$REF".txt
        scripts/get_seqs.rb -c extracted_seqs/seqs_coords_ref_"$REF".txt -f $genome_path"/e_"$REF -r 150 > extracted_seqs/seqs_ref_"$REF".fasta
done < gen_refs

