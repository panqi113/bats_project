spe=$1
dir=$2
bin=$3

mkdir $dir/$spe
cd $dir/$spe
perl $bin/pep2cds.pl $spe $OrthoFinder/Results_Nov22_2/MultipleSequenceAlignments $cds_dir/CDS > $spe.muscle.cds.fa
perl $bin/pep2tree.pl $spe $OrthoFinder/Results_Nov22_2/MultipleSequenceAlignments $bin/tree.nwk > tree.$spe
Gblocks $spe.muscle.cds.fa -t=c -b3=2 -b4=45
perl $bin/02.Gblocks2Paml.pl $spe.muscle.cds.fa-gb cds.paml
perl $bin/04.prepare.paml.Creat.CTL.pl branch-site $spe $outdir $bin
paml/codeml branch-site.nofix.ctl
paml/codeml branch-site.fix.ctl
cd $dir