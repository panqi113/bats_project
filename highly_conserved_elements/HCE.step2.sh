#get the initialization of the nonconserved model with 4d sites
program/phast/bin/phyloFit --tree 4d.treefile --msa-format SS output_dir/all.4d-sites.ss -out-root output_dir/4d.nonconserved

#split the maf file into 2M length
program/phast/bin/msa_split lastz.result/lastz.maf --in-format MAF  --windows 2000000,0 --out-root output_dir/split --out-format SS --min-informative 1000 --between-blocks 10000

#then estimate the conserved model for each fragment
ls output_dir/split/*.ss > ss.list
for ss in `cat ss.list`;do program/phast/bin/phastCons --target-coverage 0.25 --expected-length 20 --estimate-trees $ss --no-post-probs $ss output_dir/4d.nonconserved.mod;
done

#this step is used to obtain average parameters of conserved and nonconserved models for the fragments
program/phast/bin/phyloBoot --read-mods output_dir/split/*.ss.cons.mod --output-average output_dir/split/average.cons.mod;
program/phast/bin/phyloBoot --read-mods output_dir/split/*.ss.noncons.mod --output-average output_dir/split/average.noncons.mod;

#get the conserved regions
program/phast/bin/phastCons --most-conserved output_dir/bat.conserved.bed --score --msa-format MAF lastz.result/lastz.maf output_dir/split/average.cons.mod,output_dir/split/average.noncons.mod > output_dir/bat.conserved.wig
