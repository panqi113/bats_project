# step1: merge all the protein fasta files for the target species to one file "all.proteins.fasta", ensure the protein IDs are different among those species 

# step2: all to all blast mapping for all the proteins
program/blast/bin/makeblastdb -in all.proteins.fasta -dbtype prot
program/blast/bin/blastp -db all.proteins.fasta -query all.proteins.fasta -out all-all.blastp.out.m8 -evalue 1e-5 -outfmt 6 -num_threads 24

# install the orthomcl software https://orthomcl.org/orthomcl/app/downloads/software/unsupported/v1.4/

# step3 OrthoMCL analysis from user-provided BLAST result BLAST out file 
# and genome gene relation file telling which genome has which gene, the format like sample file "gene_family_cluster/sample_data/AtHsSc.gg"
program/ORTHOMCLV1.4/bin/orthomcl.pl -mode 3 -blast_file all-all.blastp.out.m8 -gg_file all.species.gg

# the result file name is "all_orthomcl.out", and every line is a cluster including the cluster id and all the proteins belong to this cluster
# the format like sample file "gene_family_cluster/sample_data/all_orthomcl.out"