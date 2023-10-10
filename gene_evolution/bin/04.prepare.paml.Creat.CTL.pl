#!/usr/bin/perl
use strict;
use warnings;
use File::Basename;

## created by Yongzhi Yang. 2017/3/20 ##

my $type=shift or die "give the model type: branch or branch-site\n";
my $ID=shift;
my $indir=shift;

my @tree=glob "$indir/$ID/tree.*";
my $sp;

for my $tree (@tree){
    $sp=$1 if($tree=~/\/tree\.([^\/]+)$/);
    if ($type eq 'free'){
        open (F,"ctl/ctl.template")||die"$!";
        open (O,">$indir/$ID/branch.freeratio.ctl");
        while (<F>) {
            chomp;
            if (/^\s+outfile\s+=/){
	s/outfile\s+=/outfile = branch.freeratio.mlc /;
            }elsif(/^\s+treefile\s+=/){
	s/treefile\s+=/treefile = tree.$sp /;
            }elsif(/^\s+model\s+=/){
	s/model\s+=/model = 1 /;
            }elsif(/^\s+NSsites\s+=/){
	s/NSsites\s+=/NSsites = 0 /;
            }elsif(/^\s+fix_omega\s+=/){
	s/fix_omega\s+=/fix_omega = 0 /;
            }elsif(/^\s+omega\s+=/){
	s/omega\s+=/omega = .4 /;
            }
            print O "$_\n";
        }
        close F;
        close O;
        if ($type eq 'branch'){
            open (F,"ctl/ctl.template")||die"$!";
            open (O,">$indir/$ID/branch.oneratio.ctl");
            while (<F>) {
	chomp;
	if (/^\s+outfile\s+=/){
	    s/outfile\s+=/outfile = branch.oneratio.mlc /;
	}elsif(/^\s+treefile\s+=/){
	    s/treefile\s+=/treefile = tree.$sp /;
	}elsif(/^\s+model\s+=/){
	    s/model\s+=/model = 0 /;
	}elsif(/^\s+NSsites\s+=/){
	    s/NSsites\s+=/NSsites = 0 /;
	}elsif(/^\s+fix_omega\s+=/){
	    s/fix_omega\s+=/fix_omega = 0 /;
	}elsif(/^\s+omega\s+=/){
	    s/omega\s+=/omega = .4 /;
	}
	print O "$_\n";
            }
            close F;
            close O;
        }
    }else{
        if ($type eq 'branch'){
            open (F,"ctl/ctl.template")||die"$!";
            open (O,">$indir/$ID/branch.tworatio.ctl");
            while (<F>) {
	chomp;
	if (/^\s+outfile\s+=/){
	    s/outfile\s+=/outfile = branch.tworatio.$sp.mlc /;
	}elsif(/^\s+treefile\s+=/){
	    s/treefile\s+=/treefile = tree.$sp /;
	}elsif(/^\s+model\s+=/){
	    s/model\s+=/model = 2 /;
	}elsif(/^\s+NSsites\s+=/){
	    s/NSsites\s+=/NSsites = 0 /;
	}elsif(/^\s+fix_omega\s+=/){
	    s/fix_omega\s+=/fix_omega = 0 /;
	}elsif(/^\s+omega\s+=/){
	    s/omega\s+=/omega = .4 /;
	}
	print O "$_\n";
            }
            close F;
            close O;
        }elsif($type eq 'branch-site'){
            open (F,"ctl/ctl.template")||die"$!";
            open (O1,">$indir/$ID/branch-site.fix.ctl");
            open (O2,">$indir/$ID/branch-site.nofix.ctl");
            while (<F>) {
	chomp;
	if (/^\s+outfile\s+=/){
	    s/outfile\s+=/outfile = $type.fix.mlc /;
	    print O1 "$_\n";
	    s/$type.fix.mlc/$type.nofix.mlc/;
	    print O2 "$_\n";
	}elsif(/^\s+treefile\s+=/){
	    s/treefile\s+=/treefile = tree.$sp /;
	    print O1 "$_\n";
	    print O2 "$_\n";
	}elsif(/^\s+model\s+=/){
	    s/model\s+=/model = 2 /;
	    print O1 "$_\n";
	    print O2 "$_\n";
	}elsif(/^\s+NSsites\s+=/){
	    s/NSsites\s+=/NSsites = 2 /;
	    print O1 "$_\n";
	    print O2 "$_\n";
	}elsif(/^\s+fix_omega\s+=/){
	    s/fix_omega\s+=/fix_omega = 1 /;
	    print O1 "$_\n";
	    s/fix_omega\s+=\s+1/fix_omega = 0 /;
	    print O2 "$_\n";
	}elsif(/^\s+omega\s+=/){
	    s/omega\s+=/omega = 1 /;
	    print O1 "$_\n";
	    s/omega\s+=\s+1/omega = 1.5 /;
	    print O2 "$_\n";
	}else{
	    print O1 "$_\n";
	    print O2 "$_\n";
	}
            }
            close F;
            close O1;
            close O2;
        }else{
            die "branch | branch-site\n";
        }
    }
}
