#extract 4d sites from the alignment of lastz
program/phast/bin/msa_view lastz.result/lastz.maf --in-format MAF --4d --features human.gff > output_dir/4d-codons.ss
program/phast/bin/msa_view output_dir/4d-codons.ss --in-format SS --out-format SS --tuple-size 1 > output_dir/4d-sites.ss
program/phast/bin/msa_view --unordered-ss --out-format SS --aggregate Sample1,Sample2,Sample3,Sample4,Sample5,Sample6 output_dir/4d-sites.ss > output_dir/all.4d-sites.ss
program/phast/bin/msa_view output_dir/all.4d-sites.ss --in-format SS --out-format FASTA > output_dir/all.4d-sites.fa
#use "all.4d-sites.fa" to build phylogenetic tree "4d.treefile"