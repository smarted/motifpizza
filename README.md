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

To download database

You can go to: https://www.dropbox.com/sh/i1dtpoec0mlwfty/AAA531Eb3fPS08srSluhyPvda?dl=0, then download motif set for mouse and human.

Write the configure file, please refer to the format [here]().

## Example

```bash
perl $MotifInstallDir/ScanMotifWithBed.pl region.bed none tf.lst human out_prefix > log 2>err
```

## Motif database

Motif source from:

http://genome.cshlp.org/content/26/3/385.full

Berger et al. 2008; Wei et al. 2010; Robasky and Bulyk 2011; Jolma et al. 2013; Mathelier et al. 2014

http://hocomoco.autosome.ru/

## Reference

