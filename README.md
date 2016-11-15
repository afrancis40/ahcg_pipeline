Alicia Francis
# ahcg_pipeline
Variant calling pipeline for genomic data analysis

## Requirements

1. [Python3 - version 3.4.1](https://www.python.org/download/releases/3.4.1/)
2. [Trimmomatic - version 0.36](http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.36.zip)
3. [Bowtie2 - version 2.2.9](https://sourceforge.net/projects/bowtie-bio/files/bowtie2/2.2.9/)
4. [Picard tools - version 2.6.0](https://github.com/broadinstitute/picard/releases/download/2.6.0/picard.jar)
5. [GATK - version 3.4](https://software.broadinstitute.org/gatk/download/)

## Reference genome

Reference genomes can be downloaded from [Illumina iGenomes](http://support.illumina.com/sequencing/sequencing_software/igenome.html)


## Preparing VMbox, BaseSpace, and Shell:

	Setting up VMbox
		Download VirtualBox if not installed already
		-http://download.virtualbox.org/virtualbox/5.1.6/VirtualBox-5.1.6-110634-Win.exe
	Setting up BaseSpace:
		-Download BaseSpace Native AppVM(.ova file) [url: ] 
		-Import to VMBox
		-Have BaseSpace opened before puTTY
	
	Access BaseSpace through a shell
		-Download puTTY [url: ]
		-Enter hostname: vagrant@localhost
		-Port: 2222 , Ps: vagrant
		*Use if puTTY is missing download -> sudo apt-get install

	Download pipeline from github
		-Git clone https://github.com/shashidhar22/ahcg_pipeline.git
		-Fork on github 

	Download genomic reference and dbSNP file using command:
		- wget www.prism.gatech.edu/~sravishankar9/resources.tar.gz [27m]
		- tar -zxvf file.tar.gz

## Before Starting the Pipeline Build Indexes for Reference Genome:
	
	1) Bowtie index
		-wget http://bowtie-bio.sourceforge.net/bowtie2/manual.shtml#the-bowtie2-build-indexer
		Command: bowtie2-build -f hg19.fa -o 3[offset index rate] hg19 [name for index refgen] -> hg19*.bt2
		-or-
		wget ftp://ftp.ccb.jhu.edu/pub/data/bowtie2_indexes/hg19.zip -> hg19.zip  [37m]

	2) Fasta index 
		-Resources: Fasta index using Samtools faidx [url: http://www.htslib.org/doc/samtools.html]
		sudo apt-get install samtools
		Command: samtools faidx [file.fa] -> fasta file.fai

	3) Genome dictionary file 
		-Resorces: Genome dict file using picard [url: https://broadinstitute.github.io/picard/command-line-overview.html#CreateSequenceDictionary]
		Used to download java8:
		sudo apt-get install software-properties-common python-software-properties
		sudo add-apt-repository ppa:webupd8team/java
		sudo apt-get update
		sudo apt-get install oracle-java8-installer

		- R : reference file
		- O : output file
		Command: java -jar ~/ahcg_pipeline/lib/picard.jar CreateSequenceDictionary \ 
		R=hg19.fa \ O=reference.dict

## Download Test Data:
Use the following protocol to download and prepare test dataset from NIST sample NA12878

	ftp://ftp-trace.ncbi.nih.gov/giab/ftp/data/NA12878/Garvan_NA12878_HG001_HiSeq_Exome/NIST7035_TAAGGCGA_L001_R1_001.fastq.gz
	ftp://ftp-trace.ncbi.nih.gov/giab/ftp/data/NA12878/Garvan_NA12878_HG001_HiSeq_Exome/NIST7035_TAAGGCGA_L001_R2_001.fastq.gz
	gunzip NIST7035_TAAGGCGA_L001_R1_001.fastq.gz
 	gunzip NIST7035_TAAGGCGA_L001_R2_001.fastq.gz
 	head -100000 NIST7035_TAAGGCGA_L001_R1_001.fastq > test_r1.fastq
 	head -100000 NIST7035_TAAGGCGA_L001_R2_001.fastq > test_r2.fastq

## Run Pipeline:
	-sudo apt-get install python3-minimal
	-sudo apt-get install unzip 
	-unzip hg19.zip --->for hg19.zip error

	Help for pipeline
		ahcg_pipeline.py (-h)
		
	VariantCaller options
		-t (trimmomatic path) 
		-b (bowtie path)
		-p (picard path)
		-g (gatk path)
		-i (input to pe)  
		-w (bowtie index ref path) 
		-d (dbsnp path .vcf)
		-r (ref path)
		-a (adapter file) 
		-o (output path to directory) 

	Place in background
	screen
		python3 ahcg_pipeline.py 
		-t ~/ahcg_pipeline/lib/Trimmomatic-0.36/trimmomatic-0.36.jar \
		-b ~/ahcg_pipeline/lib/bowtie2-2.2.9/bowtie2 \
		-p ~/ahcg_pipeline/lib/picard.jar \
		-g ~/ahcg_pipeline/lib/GenomeAnalysisTK.jar \
		-i ~/ahcg_pipeline/test*.fastq \ 
		-w ~/ahcg_pipeline/resources/genome/hg19 \
		-d ~/ahcg_pipeline/resources/dbsnp/dbsnp_138.hg19.vcf \
		-r ~/ahcg_pipeline/resources/genome/hg19.fa \
		-a ~/ahcg_pipeline/lib/Trimmomatic-0.36/adapters/TruSeq2-PE.fa \
		-o ~/ahcg_pipeline/variant
	Ctrl + A Ctrl + D

	To resume
		screen -r 
	Output: .vcf file

## Setting up Github:

	1. Steps to change the remote url for git repositories
		- git clone https://github.com/shashidhar22/ahcg_pipeline.git
		- fork on github
		- ls -a
		- cd .git
		- vim config
		- find url line
		- git remote set-url origin htttps://github.com/username/otherrepository.git
			- change the username to your own
		- git remote -v (to check if remote URL has changed)
	2. To share a project
		- git push -u origin 

	3. To not share a project
		- ls -a 
		- vi .gitignore 
		- to not push certain files add filenames 	
			Ex: *.a - no .a files
			Ex: !lib.a - no track lib.a files

	4. Commit the file that you have changed in your local repository
		-git add "file name"  <----DO THIS ONE
                EXTRA -git config --global user.name "Your Name"
                EXTRA -git config --global user.email email@blah.com
		-git commit -m "Add existing file"  ....and add small message what you changed
		
	5. Update on Github
		-git push origin master (from shell to github)
		-git pull origin master (from github to shell)

## Extracting BRCA1 Sequences:

	1. Download gene coordinates file for hg19
		wget http://vannberg.biology.gatech.edu/data/ahcg2016/reference_genome/hg19_refGene.txt

	2. Find variant NM_007294 from BRCA1
		grep 'BRCA1' hg19_refGene.txt > brca.fa 
		grep 'NM_007294' brca.fa > brca_variant.fa 
	        *NM_007294 had more complete exomes 
	3. Download bedtools
                wget https://github.com/arq5x/bedtools2/releases/download/v2.25.0/bedtools-2.25.0.tar.gz
                tar -zxvf bedtools-2.25.0.tar.gz
                cd bedtools2
                make
                *Make sure to place /path/to/lib/folder in .profile

	4. Convert .txt to .bed
		Command:
	5. Use fastaFromBed

## Extracting Variants Mapping to NA12878

## How to Get NM numbers for Gene List

##Create Variant bed file & Compare VCF file

	1) Extract regions from the gene list found within the reference file
		awk '{print $2}' genelist.txt > nm_filename.txt
		grep -f nm_filename.txt hg19_refGene.txt > genecoords.txt	

	2) Create bed file from the gene list
		Command: conver_bed.py -i genecoords.txt -o nm_hg19_coord.bed
	
	3) Find variants from the coordinate files
		bedtools intersect -a NA12878_variants.vcf -b nm_hg19_coord.bed > NA12878_hg19compare.vcf
	
	4) Compare GIAB to variant file
		*GIAB does not hae chr like .vcf so put in the file
		awk '{if($0 !~ /^#/) print "chr"$0; else print $0}' NA12878_GIAB_highconf_CG-IllFB-IllGATKHC-Ion-Solid-10X_CHROM1-X_v3.3_highconf.vcf > giabCHR.vcf
		bedtools intersect -header -a giabCHR.vcf -b nm_hg19_coord.bed > giab_chr_compare_varVCF.vcf 

	5) Compare intersecting VCF files
		bedtools intersect -a NA12878_hg19compare.vcf -b giab_chr_compare_varVCF.vcf > morevariants.vcf

## Run VSQR
	
	1) The files you'll need are the following:
	https://software.broadinstitute.org/gatk/download/bundle
	dbSNP: 
	ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/2.8/hg19/dbsnp_138.hg19.vcf.gz

	HapMap:
	ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/2.8/hg19/hapmap_3.3.hg19.sites.vcf.gz
	ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/2.8/hg19/hapmap_3.3.hg19.sites.vcf.idx.gz

	Omni:
	ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/2.8/hg19/1000G_omni2.5.hg19.sites.vcf.gz
	ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/2.8/hg19/1000G_omni2.5.hg19.sites.vcf.idx.gz

	1000G Phase 1:
	ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/2.8/hg19/1000G_phase1.snps.high_confidence.hg19.sites.vcf.gz
	ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/2.8/hg19/1000G_phase1.snps.high_confidence.hg19.sites.vcf.idx.gz

	2) Create a tabix indexed vcf file
		a) bgzip the vcf file
			bzgip <file.vcf>
		b) tabix index the compressed vcf file
			tabix -p vcf sample.vcf.gz
		*use: cksum <filename> to see if file downloaded correctly
		*See script ...

	3) VariantRecalibrator
		- https://software.broadinstitute.org/gatk/gatkdocs/org_broadinstitute_gatk_tools_walkers_variantrecalibration_VariantRecalibrator.php
		*Look within the variant files for look at the lines that resemble --> -an DP -an AD -an GQ and put the -an for what is there
		*See script run_variantrecal.sh

	4) Apply Recalibration
		*Used to check if correct variants are called

#Create BRCA1 clinical report
	1) Match variants from vcf with clinical risks
		python comp.py NA12878_variants.vcf BRCA1_brca_exchange_variants.csv BRCA2_brca_exchange_variants.csv \
		| tee brcaxref_clin.txt [62 results]

                cat brcaxref_clin.txt \|awk 'BEGIN {FS="\t"} {split($0, coord, ":"); 
		printf("%s\t%s\t%s\t%s\n", coord[1], coord[2], coord[2], $2)}' \|
                sed -E -e 's/^([^c].*)/chr\1/' > benign_brcaxref.bed

	2) Obtain Report
		samtools view -L [variant bed file] -b project.NIST_NIST7035_H7AP8ADXX_TAAGGCGA_1_NA12878.bwq.markDuplicates.bam > new.bam
		bedtools genomecov -ibam new.bam -bga [patient bed file]
		bedtools intersect -split -a [gene bed file] -b [patient bed file] -bed > output.bed
		bedtools intersect -a brcadepth.bed -b benign_brcaxref.bed -wo > brca1_report.bed
		cat brca1_report.bed | cut -f4,5,7,8,10 > brca1_Report.bed [5 results]

#DCM Gene List and Coordinates So Far...
Disease	Gene	Nmid		Variant-c		Variant-p	rsid	coordinates-hg38 (variant)	
DCM	LMNA	NM_170707.3	c.961C>T		p.Arg321Ter	rs267607554	chr1 : 156135925	nonsense
DCM	LMNA	NM_170707.4	c.149G>C		p.Arg50Pro	rs60695352	chr1 : 156115067	missense
DCM	LMNA	NM_170707.5	c178C>G			p.Arg60Gly	rs28928900	chr1 : 156115096	missense
DCM	MYBPC3	NM_000256					
DCM	MYH7	NM_000257
DCM	MYH6	NM_002471					
DCM	SCN5A	NM_198056.2	c.5872C>T	p.Arg1958Ter	rs757532106	chr3 : 38550500			nonsense
DCM	TNNT2	NM_001001430.2	c.629_631delAGA	p.Lys210del	rs121964859	chr1 : 201361971 - 201361973	deletion
