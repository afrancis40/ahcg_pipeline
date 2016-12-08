#!/bin/bash
#This script runs Variant Recalibrator 
REF=~/ahcg_pipeline/resources/genome/hg19/hg19.fa
VAR=~/ahcg_pipeline/resources/NA12878_variants.vcf
GATK=~/ahcg_pipeline/lib/GenomeAnalysisTK.jar 
DBSNP=~/ahcg_pipeline/resources/dbsnp/dbsnp_138.hg19.vcf
HAP=~/ahcg_pipeline/resources/bundle/hapmap_3.3.hg19.sites.vcf.gz 
OMNI=~/ahcg_pipeline/resources/bundle/1000G_omni2.5.hg19.sites.vcf.gz
PHASE=~/ahcg_pipeline/resources/bundle/1000G_phase1.snps.high_confidence.hg19.sites.vcf.gz

java -Xmx4g -jar $GATK \
   -T VariantRecalibrator \
   -R $REF \
   -input $VAR \
   -resource:hapmap,known=false,training=true,truth=true,prior=15.0 $HAP \
   -resource:omni,known=false,training=true,truth=false,prior=12.0 $OMNI \
   -resource:1000G,known=false,training=true,truth=false,prior=10.0 $PHASE \
   -resource:dbsnp,known=true,training=false,truth=false,prior=2.0 $DBSNP \
   -an DP -an MQRankSum -an ReadPosRankSum -an MQ -an QD -an SOR \
   -mode SNP \
   -recalFile output.recal \
   -tranchesFile output.tranches \
   -rscriptFile output.plots.R

#Make sure file names are right 
 java -Xmx4g -jar GenomeAnalysisTK.jar \
   -T ApplyRecalibration \
   -R reference.fasta \
   -input raw_variants.vcf \
   --ts_filter_level 99.0 \
   -tranchesFile output.tranches \
   -recalFile output.recal \
   -mode SNP \
   -o path/to/output.recalibrated.filtered.vcf
