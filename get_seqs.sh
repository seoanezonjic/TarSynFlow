#! /usr/bin/env bash
mkdir proteome
mkdir genomes
wget 'http://www.uniprot.org/uniprot/?sort=score&desc=&compress=yes&query=organism:shewanella+putrefaciens&fil=&format=fasta&force=yes' -O proteome/prots.fasta.gz
gunzip proteome/prots.fasta.gz
