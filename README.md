# motifpizza
Screen tf motif within provided regions.

## Requirement and installation

### Requirement

+ [FIMO](http://meme-suite.org/doc/download.html?man_type=web)
+ [BEDTOOLS](https://github.com/arq5x/bedtools2/)

### Installation

```bash
git clone git@github.com:zhoujj2013/motifpizza.git
```

## Configuration

Edit configuration at bin/config.txt
Write the configure file, please refer to the format [here](https://github.com/zhoujj2013/motifpizza/blob/master/bin/config.txt).

## Example

```bash
perl $MotifInstallDir/ScanMotifWithBed.pl region.bed none tf.lst human out_prefix > log 2>err
```

## Result

Motifpizza will store scanning result in out_prefix.all.motif.bed.

```bash
# chr start end motif_site_id score strand
chr1    7078860 7078878 Ahr_1   4.11009 +
chr1    7079079 7079097 Ahr_2   4.10092 +
chr1    12602157        12602175        Ahr_3   5.17431 +
chr1    13650235        13650253        Ahr_4   6.09174 +
chr1    16334792        16334810        Ahr_5   4.86239 -
chr1    20681581        20681599        Ahr_6   12.3853 +
chr1    20992263        20992281        Ahr_7   8.44954 -
chr1    20999204        20999222        Ahr_8   9.90826 +
chr1    20999339        20999357        Ahr_9   9.59633 -
chr1    21042468        21042486        Ahr_10  4.45872 +
```

## Motif database

Motif source from:

http://genome.cshlp.org/content/26/3/385.full

Berger et al. 2008; Wei et al. 2010; Robasky and Bulyk 2011; Jolma et al. 2013; Mathelier et al. 2014

http://hocomoco.autosome.ru/

## Reference

Charles E. Grant, Timothy L. Bailey, and William Stafford Noble, "FIMO: Scanning for occurrences of a given motif", Bioinformatics 27(7):1017–1018, 2011.

Saint-André, Violaine, et al. "Models of human core transcriptional regulatory circuitries." Genome research 26.3 (2016): 385-396.

Zhou, Jiajian, et al. "LncFunNet: an integrated computational framework for identification of functional long noncoding RNAs in mouse skeletal muscle cells." Nucleic acids research (2017).

