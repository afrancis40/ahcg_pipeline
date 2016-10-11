#!/bin/bash
#Alicia Francis
#Check Test file sample test* is original and test*1 is 1,000 downsize
TRIM=Trimmomatic-0.36/trimmomatic-0.36.jar 
BOW=bowtie2-2.2.9/bowtie2
READ=test*5.fastq 
GENOME=hg19/hg19 
VCF=dbsnp/dbsnp_138.hg19.vcf.gz 
REF=hg19/hg19.fa 
ADAPTER=Trimmomatic-0.36/adapters/TruSeq2-PE.fa 


python3 ahcg_pipeline.py \
-t ~/ahcg_pipeline/lib/$TRIM \
-b ~/ahcg_pipeline/lib/$BOW \
-p ~/ahcg_pipeline/lib/picard.jar \
-g ~/ahcg_pipeline/lib/GenomeAnalysisTK.jar \
-i ~/ahcg_pipeline/$READ \ 
-w ~/ahcg_pipeline/resources/genome/$GENOME \
-d ~/ahcg_pipeline/resources/$VCF \
-r ~/ahcg_pipeline/resources/genome/$REF \
-a ~/ahcg_pipeline/lib/$ADAPTER \
-o ~/ahcg_pipeline/variant
