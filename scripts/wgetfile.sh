#!/bin/bash
#If you are having issue with the the broad institute server, you can download it from the following links.

echo Downloading bundle files for Recalibration
#Hapmap
mkdir bundle2
cd bundle2
wget http://vannberg.biology.gatech.edu/data/ahcg2016/gatk/hapmap_3.3.hg19.sites.vcf.gz
wget http://vannberg.biology.gatech.edu/data/ahcg2016/gatk/hapmap_3.3.hg19.sites.vcf.gz.tbi
echo Hapmap donwload done

#Omni
wget http://vannberg.biology.gatech.edu/data/ahcg2016/gatk/1000G_omni2.5.hg19.sites.vcf.gz
wget http://vannberg.biology.gatech.edu/data/ahcg2016/gatk/1000G_omni2.5.hg19.sites.vcf.gz.tbi
echo Omin download done

#1000G Phase I
wget http://vannberg.biology.gatech.edu/data/ahcg2016/gatk/1000G_phase1.snps.high_confidence.hg19.sites.vcf.gz
wget http://vannberg.biology.gatech.edu/data/ahcg2016/gatk/1000G_phase1.snps.high_confidence.hg19.sites.vcf.gz.tbi
echo "1000G done. Two more to go."

#dbSNP
wget http://vannberg.biology.gatech.edu/data/ahcg2016/gatk/dbsnp.vcf.gz
wget http://vannberg.biology.gatech.edu/data/ahcg2016/gatk/dbsnp.vcf.gz.tbi
echo "dbSNP is done"

#Genome file
wget http://vannberg.biology.gatech.edu/data/ahcg2016/reference_genome/genome.fa
echo "Genome file done"

echo "Gunzipping files"
for a in $(ls *.gz); do
	cksum $a >> ./checkMygzFile.txt
	gunzip $a
done

echo Gunzip finished. Bgzipping VCF files

for b in $(ls *.vcf); do
	cksum $b >> ./checkMyvcfFile.txt
	bgzip $b
done

echo Complete. #Will Tabix vcf.gz file
#for c in $(ls *.vcf.gz);do
#	tabix -p vcf $c
#done
#echo tabix complete

echo Rnning Variant Recal
cd ../
