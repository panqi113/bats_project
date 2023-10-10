my $ID=shift;
my $muscle_dir=shift;
my $cds_dir=shift;

my ($id,$id2,$seq,$seq2,$seq3,$sample);
my (%hash1,%hash2);

open IN, "$muscle_dir/$ID.pep.fa" or die $!;
while(<IN>)
{
	chomp;
	if($_=~/^>/)
	{
		$id=(split /\s+/,$_)[0];
		$id=~s/>//g;
		$hash1{$id}=1;
	}
}
close IN;

my @infile = glob "$cds_dir/*.cds.fa";
foreach (@infile)
{
	$sample=(split /\//,$_)[-1];
	$sample=~ s/\.cds\.fa//g;

        open IN, "$_" or die $!;
        $/=">";<IN>;$/="\n";
        while(<IN>)
        {
                chomp;
                ($id=$_)=~s/\s+.*$//;
				$id2="$sample\_$id";	
	
                $/=">";
                $seq=<IN>;
                chomp $seq;
                $seq=~s/\s+//g;
                $/="\n";

                $hash2{$id2}=$seq if(exists $hash1{$id2});
        }
        close IN;
}

open IN, "$muscle_dir/$ID.pep.fa" or die $!;
$/=">";<IN>;$/="\n";
while(<IN>)
{
        chomp;
        ($id=$_)=~s/\s+.*$//;

        $/=">";
        $seq=<IN>;
        chomp $seq;
		$seq=~s/\s+//g;
        $/="\n";

        $seq2=$hash2{$id};
		$seq3=&pepmfa_to_cdsmfa($seq2, $seq);
		print ">$id\n$seq3\n";
}
close IN;

sub pepmfa_to_cdsmfa {
        my ($h_cds, $h_pep)=@_;
        my $len_prot = length($h_pep);
        my $j = 0;
        my $cds="";
        my $aa="";
        for (my $i=0; $i<$len_prot; $i++) {
                $aa = substr($h_pep,$i,1);
                if ($aa ne '-') {
                        $cds.= substr($h_cds,$j,3);
                        $j += 3;
                } else {
                        $cds.= '---';
                }
        }
        return $cds;
}
