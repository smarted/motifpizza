#!/usr/bin/perl -w

use strict;
use Getopt::Long;
use FindBin qw($Bin $Script);
use File::Basename qw(basename dirname);
use Data::Dumper;
use Cwd qw(abs_path);

&usage if @ARGV<1;

sub usage {
        my $usage = << "USAGE";

        Scan TF Motif along specific regions.
        Author: zhoujj2013\@gmail.com
        Usage: $0 region.bed extend[none,100 ... ] ptf spe[mouse/human] prefix
        ptf: tf list to be perform motif search.

USAGE
print "$usage";
exit(1);
};

my ($regionBed, $extend, $ptf, $spe, $prefix) = @ARGV;

my $conf = "$Bin/config.txt";
my %conf;
&load_conf($conf, \%conf);

$ptf = abs_path($ptf);

my $genome;
my $fa;
if($spe eq "mouse"){
	$genome=$conf{MOUSEGENOME};
	$fa=$conf{MOUSEGENOMEFA};
}

if($spe eq "human"){
	$genome=$conf{HUMANGENOME};
	$fa=$conf{HUMANGENOMEFA};
}

my $input_bed;
my $input_fa;
# get promoter
if($extend ne "none"){
	`$conf{BEDTOOLS} slop -b $extend -i $regionBed -g $genome > $prefix.peaks.extend.bed`;
	`$conf{BEDTOOLS} getfasta -name -fi $fa -bed $prefix.peaks.extend.bed -fo $prefix.peaks.extend.fa`;
	`$conf{BEDTOOLS} shuffle -excl $prefix.peaks.extend.bed -i $prefix.peaks.extend.bed -g $genome > $prefix.peaks.extend.shuffle.bed`;
	`$conf{BEDTOOLS} getfasta -name -fi $fa -bed $prefix.peaks.extend.shuffle.bed -fo $prefix.peaks.extend.shuffle.fa`;
	$input_bed = "$prefix.peaks.extend.bed";
	$input_fa = "$prefix.peaks.extend.fa";
}else{
	`$conf{BEDTOOLS} getfasta -name -fi $fa -bed $regionBed -fo $prefix.peaks.extend.fa`;
	$input_bed = "$regionBed";
	$input_fa = "$prefix.peaks.extend.fa";
}

# find motif
if($spe eq "mouse" || $spe eq "human"){
	mkdir "./fimo" unless(-d "./fimo");
	`less $ptf | cut -f 1 | grep -v \"none\" | sort | uniq | while read line; do echo \"perl $Bin/fimoMotif.pl $Bin/../data/$spe/memeMotifSet/\$line.meme $input_fa $input_bed \$line $spe\";done > fimo.sh`;
	`mv fimo.sh fimo.sh.bk`;

	open OUT,">","fimo.sh" || die $!;
	open IN,"fimo.sh.bk" || die $!;
	while(<IN>){
		chomp;
		my @t = split / /;
		if(-e "$t[2]"){
			print OUT "$_\n";
		}
	}
	close IN;
	close OUT;

	`perl $Bin/multi-process.pl -cpu 8 fimo.sh`;
}

`rm fimo.sh.bk`;

`perl $Bin/ReformatMotifProfile.pl $ptf $prefix.all`;


sub load_conf
{
    my $conf_file=shift;
    my $conf_hash=shift; #hash ref
    warn "Read in configure file: begin...\n";
    open CONF, $conf_file || die "$!";
    while(<CONF>)
    {
        chomp;
        next unless $_ =~ /\S+/;
        next if $_ =~ /^#/;
        warn "$_\n";
        my @F = split"\t", $_;  #key->value
        $conf_hash->{$F[0]} = $F[1];
    }
    close CONF;
    warn "Read in configure file: done...\n";
}
