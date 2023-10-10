gene_family_id=$1

# step1: make a new folder for every gene family
mkdir outdir/$gene_family_id
cd outdir/$gene_family_id

# step2: use muscle software to align the protein sequence for one of orthology gene family, get the well-aligned amino acid

# step3: change the protein sequence to nucleic acid sequence based on the site of aligned amino acids
perl bin/pep2cds.pl $gene_family_id PEP/ CDS/ > outdir/$gene_family_id/$gene_family_id.muscle.cds.fa

# step4: produce the gene tree file for this gene family, change each species ID to gene ID
perl bin/pep2tree.pl $gene_family_id PEP/ tree/tree.nwk > outdir/$gene_family_id/tree.$gene_family_id

# step5: retain the conserved blocks with Gblocks
program/Gblocks outdir/$gene_family_id/$gene_family_id.muscle.cds.fa -t=c -b3=2 -b4=30

# step6: produce the input file of phylip format for PAML based on the result of Gblocks
perl bin/02.Gblocks2Paml.pl outdir/$gene_family_id/$gene_family_id.muscle.cds.fa-gb outdir/$gene_family_id/cds.paml

# finally, for the free ratio model we need branch.freeratio.ctl ; 
# for the branch model we need branch.oneratio.ctl,branch.tworatio.ctl ; 
# for the branch-site model we need branch-site.fix.ctl and branch-site.nofix.ctl;
# then we can run the codeml script in paml package 

# step7: prepare ctl files of branchsite model for paml
perl bin/04.prepare.paml.Creat.CTL.pl branch-site $gene_family_id outdir/

# step8: run the codeml script in paml package 
program/paml/bin/codeml outdir/$gene_family_id/branch-site.nofix.ctl
program/paml/bin/codeml outdir/$gene_family_id/branch-site.fix.ctl

# step9: return back to the upper directory
cd outdir