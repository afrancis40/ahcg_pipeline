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

	
