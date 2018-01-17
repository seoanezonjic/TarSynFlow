# Installation

In order to use TarSynFlow you must:
 * 1) Clone this repository. Code: `git clone https://github.com/seoanezonjic/TarSynFlow`
 * 2) Install ruby. We recommend to use the RVM manager:  [RVM](https://rvm.io/)
 * 3) Install AutoFlow. Code: `gem install autoflow`
 * 4) Install scbi_distributed_blast. Code: `gem install scbi_distributed_blast`
 * 5) Install AutoFlow. Code: `gem install make_circos`
 * 6) Install [cd-hit](http://weizhongli-lab.org/cd-hit/)        
 * 7) Install [CIRCOS](http://circos.ca/distribution/circos-0.67-7.tgz)        
 * 8) Install blast plus => ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.2.30
 * 9) Install prosplign => ftp://ftp.ncbi.nlm.nih.gov/genomes/TOOLS/ProSplign/prosplign.tar.gz
 * 10) Install [R](https://www.r-project.org/)
 * 11) Make PATH accesible all the installed software.

# Usage

## Configuration
There  are four bash file that perform the whole analysis onto the selected genomes:
 * 1) get_seqs.sh: Create the input folders and download from Uniprot the protein sequences that will be used in the blast analysis.
 * 2) reduce_prot_redundancy.sh: Remove all the sequence redundance to aviod overlapping hits in dwonstream analysis.
 * 3) make_all_comps.sh: Perfom all the genome comparations.
 * 4) get_all_results.sh: Collect all the CIRCOS diagrams, list the common proteins for each analyzed category for all the input genomes.
 * 5) get_seqs.sh: Extract the sequences and give the coordinates for the genome specific matches across by each analysed genome. Useful for instance, for PCR analysis.
Each one must be edited in order to configure the pipeline to the desired data.

### get_seqs.sh
In this file, the user must edit the following line:
`'http://www.uniprot.org/uniprot/?sort=score&desc=&compress=yes&query=organism:`**shewanella+putrefaciens**`&fil=&format=fasta&force=yes'`
The bold words are the keywords to search in Uniprot. Use the character + as space character. These keywords must correspond to a known taxon.
This script create the genomes folder. Copy or symlink the genomes to analyse in this folder.

### reduce_prot_redundancy.sh
To tune the sequence redundancy removing step, this line can be edited: 
`cd-hit -i proteome/prots.fasta -o proteome/prots_clean.fasta` **-c 0.6 -M 0 -n 4**

The -c parameter means a 60% of sequence identity. It can be changed it is described in the CD-HIT documentation. -M 0 paremeter means no limit in use RAM memory.

### make_all_comps.sh
Before edit the script, it is necessary to define the genome groups. One reference group and one query group. To do this the following files must be created in the directory of this script:
 * 1) gen_refs
 * 2) gen_queries

Place a list of genome fastas placed in the genome folder as you wish in these files. Only file name, one per line and only in one of the files. We  recommend only one query genome and use the remaining genomes as references.

Then you can edit the following variables:
```bash
GENOME_FILES="/mnt/home/users/pab_001_uma/pedro/proyectos/shewanella/genomes"
PROTEOME="/mnt/home/users/pab_001_uma/pedro/proyectos/shewanella/proteome/prots_clean.fasta"
```
Change these paths to current genomes and proteome folders located in your file system.
Also, you can comment the source line, that only works in our own computer resources.
The last step is to edit the high similarity profiles applied to each genome group. Keep the float formats when the parameters are repeated in the ref profile. It is a little hack to avoid certain issues when autoflow is executed.
```bash
coverage_identity_query=85+85
coverage_identity_ref=85.0+85.0
```

### get_all_results.sh
Comment the _source_ and _module load_ lines, only works in our own computer resources.
You can edit this line:
```bash
min_count=7
```
Change this variable to a number that you consider as significant for your amount of genomes. For instance, if you perform 10 comparisons and you want to be absollutely sure that a protein is only in the refrence genomes but not in query genomes, set this variable to 10 in order to ask for the presence of this protein in all the comparisons in the reference genomes.

### extract_seqs.sh
Edit the following lines:
```bash
coord_table="comps/Pdp11_1.fasta/"`head -n 1 gen_refs`"/procompart_0000/coord_table_with_strand"
genome="genomes/e_Pdp11_1.fasta"
coord_table_path="comps/Pdp11_1.fasta"
```
Change **Pdp11_1.fasta** (our case study) to a representant genome of the query genomes group.

## Execution
Once edited each sh file and satisfied the described requirements, execute each one of them:

```bash
./get_seqs.sh
./reduce_prot_redundancy.sh
./make_all_comps.sh
./get_all_results.sh
./extract_seqs.sh
```

## Citation


