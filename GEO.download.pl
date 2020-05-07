#!/usr/bin/perl -w
use strict;
use warnings;
my $BEGIN_TIME=time();
use Getopt::Long;
my ($fout,$proname,$dsh,$geo);
use Data::Dumper;
use FindBin qw($Bin $Script);
use File::Basename qw(basename dirname);
my $version="1.0.0";
GetOptions(
	"help|?" =>\&USAGE,
	"GEO:s"=>\$geo,
	"out:s"=>\$fout,
	"proname:s"=>\$proname,
	"dsh:s"=>\$dsh,
			) or &USAGE;
&USAGE unless ($fout);
$dsh||="work_sh";
mkdir $fout if (!-d $fout);
$fout=ABSOLUTE_DIR($fout);
mkdir $dsh if (!-d $dsh);
$dsh=ABSOLUTE_DIR($dsh);
open Out,">$dsh/geo.sh";
#print Out "ascp -T -l 100 -i /mnt/ilustre/centos7users/dna/.aspera/connect/etc/asperaweb_id_dsa.openssh --mode recv --host  ftp-private.ncbi.nlm.nih.gov";
#print Out " --user anonftp --file-list ./download.list ./";
print Out "geofetch -i $geo --just-metadata -m $fout -n $proname && ";
print Out "perl $Bin/bin/get.URL.pl -geo $geo -proname $proname -out $fout";
close Out;
my $job="cd $dsh && nohup sh geo.sh";
`job`;


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

	eg:  perl $Script -geo GSE107585 -proname GSE107585 -out ./
	
Usage:
  Options:
	-geo geo number
	-out output dir
	-proname project name
	-dsh work dir shell
	-h         Help

USAGE
        print $usage;
        exit;
}
