#!/usr/bin/perl -w

use strict;
use Getopt::Long;
use FindBin qw($Bin $Script);
use File::Basename qw(basename dirname);
use Data::Dumper;

&usage if @ARGV<1;

#open IN,"" ||die "Can't open the file:$\n";
#open OUT,"" ||die "Can't open the file:$\n";

sub usage {
        my $usage = << "USAGE";

        This script designed for add id for bed file.
        Author: zhoujj2013\@gmail.com
        Usage: $0 <tf_list> <prefix>

USAGE
print "$usage";
exit(1);
};

my ($tf_list, $prefix) = @ARGV;

mkdir "./reformat_fimo" unless(-e "./reformat_fimo");

open IN,"$tf_list" || die $!;
while(<IN>){
	chomp;
	my @t = split /\t/;
	my $tf = $t[0];
	my $wc = `wc -l ./fimo/$tf.insilico.bed`;
	my $lnum = $1 if($wc =~ /(\S+)/);
	if($lnum == 0){
		print STDERR "Not exists $tf motif -> ./fimo/$tf.insilico.bed\n";
		next;
	}
	`bedtools sort -i ./fimo/$tf.insilico.bed | /x400ifs-accel/zhoujj/software/BEDTools-Version-2.16.2/bin/bedtools merge -scores max -nms -i - | perl $Bin/replace_bed_column.pl - $tf > ./reformat_fimo/$tf.rf.bed`;
}
close IN;

`cat ./reformat_fimo/*.bed > ./$prefix.motif.bed`;
