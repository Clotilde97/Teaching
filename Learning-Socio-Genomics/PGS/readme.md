Some notes on PGS construction:
===============================


## LPred

### [From the AJHG article](http://www.cell.com/ajhg/pdf/S0002-9297(15)00365-1.pdf)

Polygenic risk scores have shown great promise in predicting complex disease risk and will become more accurate as training sample sizes increase.

The standard approach for calculating risk scores involves linkage disequilibrium (LD)-based marker pruning and applying a p value threshold to association statistics, but this discards information and can reduce predictive accuracy. LDpred is a method that infers the posterior mean effect size of each marker by using a prior on effect sizes and LD information from an external reference panel. Theory and simulations show that LDpred outperforms the approach of pruning followed by thresholding, particularly at large sample sizes. Accordingly, predicted R2 increased from 20.1% to 25.3% in a large schizophrenia dataset and from 9.8% to 12.0% in a large multiple sclerosis dataset.

Polygenic risk scores (PRSs) computed from genome-wide association study (GWAS) summary statistics have proven valuable for predicting disease risk and understanding the genetic architecture of complex traits.

LDpred: a Bayesian PRS that estimates posterior mean causal effect sizes from GWAS summary statistics by assuming a prior for the genetic architecture and LD information from a reference panel.

A key feature of LDpred is that it relies on GWAS summary statistics, which are often available even when raw genotypes are not.

In practice, the prediction accuracy is improved if the markers are LD pruned and p value pruned a priori. Informed LD pruning (also known as LD clumping), which preferentially prunes the less significant marker, often yields much more accurate predictions than pruning random markers.

A LD radius of approximately M/3,000 (the default value in LDpred), where M is the total number of SNPs used in the analysis, works well in practice; this corresponds to a 2 Mb LD window on average in the genome.

The second parameter is the fraction p of non-zero effects in the prior. This parameter is analogous to the p value threshold used in PxT. The recommendation is to try a range of values for p (e.g., 1,0.3, 0.1, 0.03, 0.01, 0.003, 0.001, 3E4, 1E4, 3E5, 1E5; theseare default values in LDpred).

PxT risk scores for different p value thresholds by using grid values (1E8, 1E6, 1E5, 3E5, 1E4, 3E4, 1E3, 3E3, 0.01, 0.03, 0.1, 0.3, 1), were compared with mixture probability (fraction of causal markers) values (1E4, 3E4, 1E3, 3E3, 0.01, 0.03, 0.1, 0.3, 1).

Nagelkerke R2, observed-scale R2, liability-scale R2, and the area under the curve (AUC) were the primary measurement metrics.

PRSs are likely to become clinically useful as GWAS sample sizes continue to grow. However, unless LD is appropriately modeled, their predictive accuracy will fall short of their maximal potential.

As sample sizes increase and polygenic predictions become more accurate, their value increases, both in clinical settings and for understanding genetics.  

### Syntax (when configured/pip installed locally)

```bash
python ldpred/coord_genotypes.py --gf=test_data/LDpred_data_p0.001_test_0 --ssf=test_data/LDpred_data_p0.001_ss_0.txt --N=100 --out=bogus.hdf5
python ldpred/LDpred.py --coord=bogus.hdf5 --ld_radius=1 --PS=0.3 --N=100 --out=ldpredoutput
python ldpred/validate.py --vgf=test_data/LDpred_cc_data_p0.001_train_0 --rf=ldpredoutput --out=pgsoutputs
```

## Some Notes on PRSice

### [From the BioInformatics Article](https://academic.oup.com/bioinformatics/article/31/9/1466/200539/PRSice-Polygenic-Risk-Score-software)

A polygenic risk score (PRS) is a sum of trait-associated alleles across many genetic loci, typically weighted by effect sizes estimated from a genome-wide association study

A PRS for an individual is a summation of their genotypes at variants genome-wide, weighted by effect sizes on a trait of interest. Effect sizes are typically estimated from published GWAS results, and only variants exceeding a P-value threshold, PT, are included.

This technique was first applied by the International Schizophrenia Consortium (2009), demonstrating that genetic risk for schizophrenia (SCZ) is a predictor of bipolar disorder. This study also acted as a proof-of-principle for PRS, showing that PRS based on thousands of common variants genome-wide, including many with no effect and using effect size estimates from published GWAS, can provide a reliable indicator of genetic liability.

### [From the Manual](http://prsice.info/PRSice_MANUAL_v1.25.pdf)

PRSice is a software package written in R, including wrappers for bash data management scripts and PLINK2 to minimise computational time; thus much of its functionality relies entirely on computations written originally by Shaun Purcell in PLINK 1 and Christopher Chang in PLINK 2. PRSice runs as a command-line program, compatible for Unix/Linux/Mac OS, with a variety of user-options and is freely available for download from: http://PRSice.info.

Inputs:
1. PRSice.R file: includes R scripts, bash and PLINK2 wrappers
2. PLINK2 executable files (Linux and Mac). If the PLINK2 executable file is not in the working directory then the path to it must be given.
3. Base data set: GWAS summary results, which the PRS is based on. *Must* contain SNP, OR or Beta, A1, P.
4. Target data set: Raw genotype data of ‘target phenotype’. The target data set must be supplied in PLINK binary format, with the extensions .bed (compressed), .bim, .fam 

Outputs
1. Figures illustrating the model fit of the PRS analyses: model fit of the PRS at different broad thresholds, the model fit calculated at a large number thresholds, and optional Quantile plot.
2. Data on the model-fit of the PRS analyses - this is stored as threshold, P-value, variance in target phenotype explained, r2, and number of SNPs at this threshold.
3. PRS for each individual in the target data (for best-fit PRS as default): either 'best-fit' or `all-thresholds' as required.

Strand flips are automatically detected and accounted for. fastscore T is the option which only outputs a 'low resolution' (bars) of the p-value threshold grid.

The pipeline goes like this:
1. GWAS results obtaind on pheno of interest.
2. Target dataset obtaind containing geno and pheno (pheno may be same or different).
3. SNPs present in only one dataset are removed as are ambiguous SNPs and those in LD with local SNP with smallest GWAS p-value.
4. PGS calculated for individuals in target data as sum of `risk alleles' across SNPs.
5. Regression performed to test association between PRS and target pheno, potentially including covariates.
6. Model fit and significance indicated via plots.

Examples using the toy dataset from the Vignette:

```bash
R -q --file=./PRSice_v1.25.R --args \
base TOY_BASE_GWAS.assoc \
target TOY_TARGET_DATA \
slower 0 \
supper 0.5 \
sinc 0.01 \
covary F \
clump.snps F \
plink ./plink_1.9_linux_160914 \
figname EXAMPLE_1


R -q --file=./PRSice_v1.25.R --args \
base TOY_BASE_GWAS.assoc \
target TOY_TARGET_DATA \
slower 0 \
supper 0.5 \
sinc 0.01 \
covary F \
clump.snps F \
plink ./plink_1.9_linux_160914 \
figname EXAMPLE_3_QUANTILES_1 \
quantiles T
```

[The next step in PRS?](https://www.nature.com/articles/srep41262)

