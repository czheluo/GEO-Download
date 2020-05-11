#!/usr/bin/perl -w
use strict;
use warnings;
my $BEGIN_TIME=time();
use Getopt::Long;
my ($fin,$fout,$proname,$geo);
use Data::Dumper;
use FindBin qw($Bin $Script);
use File::Basename qw(basename dirname);
my $version="1.0.0";
GetOptions(
	"help|?" =>\&USAGE,
	"GEO:s"=>\$geo,
	"out:s"=>\$fout,
	"proname:s"=>\$proname,
			) or &USAGE;
&USAGE unless ($fout);
mkdir $fout if (!-d $fout);
$fout=ABSOLUTE_DIR($fout);
open In,"<$fout/$proname/$geo\_SRA.csv";
#print "$fout/$proname/$geo\_SRA.csv";die;
open OUT,">$fout/geo.sh";
open Out,">$fout/lanes.sh";
my %stat;
while(<In>){
	chomp;
	#print $_;die;
	next if($_ =~ "Run");
	my @all=split/\,/,$_;
	#print $all[9];die;
	#print $all[1];die;
	#my @name=split/\//,$all[9];
	#print $all[0];die;
	#my $id1=;
	#my $id2=$all[0];
	#print $all[10];die;
	#next if($all[10]=~ "");
	#print "$all[10]";
	push @{$stat{$all[10]}},join(",",$all[0]);#sample name $all[25]
	print Out "mkdir -p $all[10] && mv $all[0]\* $all[10]\n";	
	print OUT "cd $fout && python $Bin/bin/check_download_log.py --instr $all[9] \n";
}
print %stat;
foreach my $key (sort keys %stat){
	print "$$key\t$stat{$key}\n";
}
open SA,">$fout/$proname/sample.list";
foreach my $key (sort keys %stat){
	print SA "$$key\t$stat{$key}\n";
}
close SA;
close Out;
close OUT;
close In;
#`cd $fout && split -n 6 geo.sh && nohup sh geo.sh`;

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

	eg: perl -int filename -out filename 
	
Usage:
  Options:
  	"GEO:s"=>\$geo,
	"out:s"=>\$fout,
	"proname:s"=>\$proname,
	-int input file name
	-out output file name 
	-h         Help

USAGE
        print $usage;
        exit;
}
