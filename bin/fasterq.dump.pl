#!/usr/bin/perl -w
use strict;
use warnings;
my $BEGIN_TIME=time();
use Getopt::Long;
my ($fin,$dsh,$fout);
use Data::Dumper;
use FindBin qw($Bin $Script);
use File::Basename qw(basename dirname);
my $version="1.0.0";
GetOptions(
	"help|?" =>\&USAGE,
	"int:s"=>\$fin,
	"out:s"=>\$fout,
	"dsh:s"=>\$dsh,
			) or &USAGE;
&USAGE unless ($fout);
mkdir $fout if (!-d $fout);
$fout=ABSOLUTE_DIR($fout);
$dsh||="work_sh";
mkdir "$fout/$dsh" if (!-d $dsh);
#$dsh=ABSOLUTE_DIR($dsh);
open In,$fin;
open Out,">$fout/$dsh/fasterq.dump.sh";
open OUT,">$fout/$dsh/gzip.sh";
open LN,">$fout/$dsh/mv.sh";
open LS,">$fout/fq.list";
while (<In>) {
	chomp;
	my($name,undef)=split/\./,$_;
	print Out "cd $fout && fasterq-dump --split-3 $_ -e 16 -o $name \n";
	print OUT "cd $fout && gzip $name\_1.fastq \n";
	print OUT "cd $fout && gzip $name\_2.fastq \n";
	print LN "cd $fout && mv $name\_1.fastq.gz $name\_S1_L001_R1_001.fastq.gz \n";
	print LN "cd $fout && mv $name\_2.fastq.gz $name\_S1_L001_R2_001.fastq.gz \n";
	print LS "$name $fout/$name\_S1_L001_R1_001.fastq.gz\t$fout/$name\_S1_L001_R2_001.fastq.gz\n";
	#print LS "$name $fout/$name\_S1_L001_R1_001.fastq.gz\t$fout/$name\_S1_L001_R2_001.fastq.gz\n";
}
close OUT;
close Out;
close LN;
close LS;
#my $job="qsub-slurm.pl $dsh/fasterq.dump.sh --Resource mem=20G --CPU 8 ";
#`$job`;
#my $job="qsub-slurm.pl $dsh/gzip.sh --Resource mem=10G --CPU 3 ";
#`$job`;
#my $job="qsub-slurm.pl $dsh/mv.sh --Resource mem=3G ";
#`$job`;
#######################################################################################
print STDOUT "\nDone. Total elapsed time : ",time()-$BEGIN_TIME,"s\n";
#######################################################################################
sub ABSOLUTE_DIR #$pavfile=&ABSOLUTE_DIR($pavfile);
{
	my $cur_dir=`pwd`;chomp($cur_dir);
	my ($in)=@_;
	my $return="";
	if(-f $in){
		my $dir=dirname($in);
		my $file=basename($in);
		chdir $dir;$dir=`pwd`;chomp $dir;
		$return="$dir/$file";
	}elsif(-d $in){
		chdir $in;$return=`pwd`;chomp $return;
	}else{
		warn "Warning just for file and dir \n$in";
		exit;
	}
	chdir $cur_dir;
	return $return;
}
sub USAGE {#
        my $usage=<<"USAGE";
Contact:        meng.luo\@majorbio.com;
Script:			$Script
Description:

	eg: perl $Script -int log -out ./
	
Usage:
  Options:
	-int input file name
	-out output file name 
	-dsh out work dir
	-h         Help

USAGE
        print $usage;
        exit;
}
