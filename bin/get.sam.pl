#!/usr/bin/perl -w
use strict;
use warnings;
my $BEGIN_TIME=time();
use Getopt::Long;
my ($fin,$fout);
use Data::Dumper;
use FindBin qw($Bin $Script);
use File::Basename qw(basename dirname);
my $version="1.0.0";
GetOptions(
	"help|?" =>\&USAGE,
	"int:s"=>\$fin,
	"out:s"=>\$fout,
			) or &USAGE;
&USAGE unless ($fout);
$fout=ABSOLUTE_DIR($fout);
open In,$fin;
my %stat;
while (<In>) {
	chomp;
	my ($id1,$id2)=split/\s+/,$_;
	#print "$id1\t$id2\n";
	push @{$stat{$id2}},join(",",$id1);
	#my $all=join("\t",@{$chrs{$chr}{$dis}});
	#push @{$chrs{$chr}{$dis}},join("\t",$mark);
}

close In;
open Out,">$fout/fastq.list";
foreach my $key (sort keys %stat) {
	#print Dumper %stat;die;
	my $all=join(",",@{$stat{$key}});
	my @all=split/\,/,$all;
	#print $all[0];die;
	print Out "$key\t$fout\/$key\t",join(",",@{$stat{$key}}),"\n";
	#print Out "$key\t$fout\/$key\t$fout\/$key\/$all[0]\_S1_L001_R2_001.fastq.gz\t",join(",",@{$stat{$key}}),"\n";
}
close Out;

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

	eg: pperl $Script -int trash/sample.list -out ./
	
Usage:
  Options:
	-int input file name
	-out output file name 
	-h         Help

USAGE
        print $usage;
        exit;
}
