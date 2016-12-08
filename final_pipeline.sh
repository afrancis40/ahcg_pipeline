#/bin/bash
#Alicia Francis
#Also includes commands from Wilson script and Namrata Kalsi
#This script generates a VCF file from the BAM file 
#undergoes recalibration
#and calculates the coverage 
#Requires comp.py(Wilson), draw_depth.R(Wilson), clinvar.vcf(.gz), and parse_clinvar.py (Wilson)

#For help
usage() 
{
echo "Usage: $0 [-b dcm_genelist.bed] [-i bam file] [-o output directory name]" >&2
exit 2
} 

#Variables
BED=
BAM=
OUT=
HOME=/home/vagrant/ahcg_pipeline
BUN=$HOME/bundle
VCF=patient1_variant.vcf
RECAL=patient1_recal.vcf
CLIN=$HOME/chr_clinvar.vcf
HAP=$BUN/hapmap_3.3.hg19.sites.vcf.gz
OMNI=$BUN/1000G_omni2.5.hg19.sites.vcf.gz
GATK=$HOME/lib/GenomeAnalysisTK.jar
GENREF=$HOME/resources/genome/hg19/hg19.fa
DBSNP=$HOME/resources/dbsnp/dbsnp_138.hg19.vcf
PHASE=$BUN/1000G_phase1.snps.high_confidence.hg19.sites.vcf.gz

#Get users input
while getopts "hb:i:o:" opt; do
    case $opt in
	 h) usage
	    ;;
	 b) BED="$OPTARG" ;; #Contains genelist in bed file
	 i) BAM="$OPTARG" ;; #Patient bam file
	 o) OUT="$OPTARG" ;; #Output file name
	 \?) 
	    echo "Invalid option: -"$OPTARG"" >&2
	    usage
	    exit 1
	    ;;
	 *)
	    usage
	    exit 1
	    ;;
    esac
done

mkdir -p $HOME/$OUT	 
echo "Starting Variant Pipeline...(~7hrs,1.8G)"
#---------------------------------------------------
#Variant Pipeline
#---------------------------------------------------
java -jar $GATK \
	-R $GENREF \
	-T HaplotypeCaller \
	-I $BAM \
	-o $HOME/$OUT/$VCF  
echo "Variant file created"


#Downloads all the bundle links for Variant recalibrator and runs Variant Recal
#./wgetfile.sh 

echo "Starting Variant Recal...(~1.2hr,1.8G)"
#---------------------------------------------------
#Variant Recalibration step
#----------------------------------------------------
java -Xmx4g -jar $GATK \
   -T VariantRecalibrator \
   -R $GENREF \
   -input $HOME/$OUT/$VCF \
   -resource:hapmap,known=false,training=true,truth=true,prior=15.0 $HAP \
   -resource:omni,known=false,training=true,truth=false,prior=12.0 $OMNI \
   -resource:1000G,known=false,training=true,truth=false,prior=10.0 $PHASE \
   -resource:dbsnp,known=true,training=false,truth=false,prior=2.0 $DBSNP \
   -an DP -an MQRankSum -an ReadPosRankSum -an FS -an MQ -an QD -an SOR \
   -mode SNP \
   -recalFile $HOME/$OUT/output.recal \
   -tranchesFile $HOME/$OUT/output.tranches \
   -rscriptFile $HOME/$OUT/output.plots.R

echo "Variant Recal finished...Starting Apply Recal...(~6min,1.8G)"
#----------------------------------------------------
##Apply Recalibration
#----------------------------------------------------
 java -Xmx4g -jar $GATK \
   -T ApplyRecalibration \
   -R $GENREF \
   -input $HOME/$OUT/$VCF \
   --ts_filter_level 99.0 \
   -tranchesFile $HOME/$OUT/output.tranches \
   -recalFile $HOME/$OUT/output.recal \
   -mode SNP \
   -o $HOME/$OUT/$RECAL

echo "Apply Recal finished....Beginning Coverage Calculation"
#-----------------------------------------------------
##Coverage Calculation
#-----------------------------------------------------
#Filter alignments to those found in bed to bam file
samtools view -l $BED -b $BAM > $HOME/$OUT/genebedf_coverage_p1.bam
#Report genome coverage
bedtools genomecov -ibam $HOME/$OUT/genebedf_coverage_p1.bam -bga > $HOME/$OUT/gene_coverage_p1.bed
#Intersect gene list bed file with genome coverage bed file
#-F takes over the 90% overlaps only 
bedtools intersect -loj -F 0.10 -a $BED -b $HOME/$OUT/gene_coverage_p1.bed > $HOME/$OUT/dcmcoverage_final.bed
#Take out columms needed
awk '{printf("%s\t%s\t%s\t%s\t%s\n", $1, $6, $7, $4, $8)}' $HOME/$OUT/dcmcoverage_final.bed > $HOME/$OUT/final_dcm_cov.bed 

#Calculate Coverage for Each DCM Gene ....sudo apt-get install xvfb
for gene in $(cut -f4 $BED | sort -u | xargs);do
	grep $gene $HOME/$OUT/final_dcm_cov.bed > $HOME/$OUT/${gene}_raw.txt
	python $HOME/comp.py $HOME/$OUT/${gene}_raw.txt $HOME/$OUT/${gene}_finalcov.txt
	.$HOME/draw_depth.R $HOME/$OUT/${gene}_finalcov.txt > $HOME/$OUT/${gene}_finalcov.png
done


#Coverage Script
#python $HOME/comp.py $HOME/$OUT/final_dcm_cov.bed $HOME/$OUT/final_dcm_depth.txt
#R plot script
#echo "Making R plot"
#.$HOME/draw_depth.R $HOME/$OUT/final_dcm_depth.txt $HOME/$OUT/final_dcm_depth.png


echo "Generating Report"
#-----------------------------------------------------
##Generate report
#-----------------------------------------------------
#wget ftp://ftp.ncbi.nlm.nih.gov/pub/clinvar/vcf_GRCh37/clinvar.vcf.gz

#Intersect Clinvar with genelist bed file
bedtools intersect -a $CLIN -b $BED -header > $HOME/$OUT/clinvar_genebed.vcf 
#Get only variants related to DCM genes
bedtools intersect -a $HOME/$OUT/$RECAL -b $BED -header > $HOME/$OUT/final_patient1_dcmRecal.vcf
#Intersect variants with clinvar
bedtools intersect -a $HOME/$OUT/clinvar_genebed.vcf -b $HOME/$OUT/final_patient1_dcmRecal.vcf > $HOME/$OUT/both_inters_patient1_clinvar.vcf  
#Report
python $HOME/parse_clinvar.py -i $HOME/$OUT/both_inters_patient1_clinvar.vcf 2>&1 | tee patient1_report.txt
cut -c 24- patient1_report.txt > $HOME/$OUT/final_Patient1_report.txt

echo "Generating Images"

#Join Images 
#sudo apt-get install pdftk & sudo apt-get install pandoc
#sudo apt-get install texlive-latex-base
convert $HOME/$OUT/*.png $HOME/$OUT/all_gene_pics.pdf
pandoc $HOME/$OUT/final_Patient1_report.txt -o $HOME/$OUT/final_Patient1_report.pdf
pdftk $HOME/$OUT/final_Patient1_report.pdf $HOME/$OUT/all_gene_pics.pdf output DCMReport.pdf

echo "Pipeline completed"
