my $ID=shift;
my $muscle_dir=shift;
my $tree_dir=shift;

my ($id,$id2,$tree,$seq2,$seq3,$sample);
my (%hash1,%hash2);

open IN, $tree_dir or die $!;
$tree=<IN>;chomp $tree;close IN;

open IN, "$muscle_dir/$ID.pep.fa" or die $!;
while(<IN>)
{
	chomp;
	if($_=~/^>/)
	{
		$id=(split /\s+/,$_)[0];
		$id=~s/>//g;

		$id2=(split /\_/,$id,2)[0];
		$tree=~s/$id2/$id/g;
	}
}
close IN;

print $tree."\n";
