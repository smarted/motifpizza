#!/usr/bin/perl -w

use strict;
use Getopt::Long;
use FindBin qw($Bin $Script);
use File::Basename qw(basename dirname);
use File::Path qw(make_path);
use Data::Dumper;
use Cwd qw(abs_path);

&usage if @ARGV<1;

sub usage {
        my $usage = << "USAGE";

        Find motifs by FIMO.
        Author: zhoujj2013\@gmail.com 
        Usage: $0 XX.meme seq.fa seq.bed prefix

USAGE
print "$usage";
exit(1);
};

my $motif=shift;
my $fasta=shift;
my $bed=shift;
my $prefix=shift;
my $spe=shift;

my $conf="$Bin/config.txt";
my %conf;
&load_conf($conf, \%conf);

my $motifname=basename($motif,".meme");

unless(-d "./fimo"){
	mkdir "fimo"
}

# fimo
`$conf{FIMO} --thresh 1e-4 -text $motif $fasta >./fimo/$prefix.fimo.txt 2> ./fimo/$prefix.fimo.err`;

#  2. recover coordinate for motif position
`perl $Bin/recover_offset_fimo.pl $bed ./fimo/$prefix.fimo.txt > ./fimo/$prefix.insilico.bed`;

#########################
sub load_conf
{
    my $conf_file=shift;
    my $conf_hash=shift; #hash ref
    open CONF, $conf_file || die "$!";
    while(<CONF>)
    {
        chomp;
        next unless $_ =~ /\S+/;
        next if $_ =~ /^#/;
        #warn "$_\n";
        my @F = split"\t", $_;  #key->value
        $conf_hash->{$F[0]} = $F[1];
    }
    close CONF;
}
