#!/usr/bin/env bash
#SBATCH --cpus=1
#SBATCH --mem=4gb
#SBATCH --time=20:00:00
#SBATCH --error=job.%J.err
#SBATCH --output=job.%J.out
#SBATCH --constraint=cal

hostname
module load cdhit
before=`grep -c '>' proteome/prots.fasta`
time cd-hit -i proteome/prots.fasta -o proteome/prots_clean.fasta -c 0.6 -M 0 -n 4
after=`grep -c '>' proteome/prots_clean.fasta`
echo -e "Downloaded protein\t$before"
echo -e "Final count\t$after"
echo -e "Percentage\t`echo -e "scale=2; $after*100/$before" | bc`"
