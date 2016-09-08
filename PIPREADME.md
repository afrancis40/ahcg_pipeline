EADME 
#Alicia- Genome reference and dbSNP files

#Setting up VMbox to run pipeline
1) BaseSpace:
BaseSpace Native AppVM(.ova file),the latest Native Apps Virtual Machine
can be downloaded directly from S3 ...download then import to VMBox
Have BaseSpace opened before puTTY
	->Download VirtualBox if not installed already
2) download puTTY
enter hostname: vagrant@localhost , p: 2222 , ps: vagrant
Use if puTTY is missing download -> sudo apt-get install [blah]

3) Download pipeline from github
- git clone https://github.com/shashidhar22/ahcg_pipeline.git
- fork on github 

4) Download genomic reference and dbSNP file at link:
wget www.prism.gatech.edu/~sravishankar9/resources.tar.gz [27m]
tar -zxvf file.tar.gz

5) Before you start the pipeline, you will need to build the 
a) bowtie index,
Bowtie index : http://bowtie-bio.sourceforge.net/bowtie2/manual.shtml#the-bowtie2-build-indexer
	Command: bowtie2-build -f hg19.fa [name for index refgen] -> refgen.*.bt2
	-or-
	wget ftp://ftp.ccb.jhu.edu/pub/data/bowtie2_indexes/hg19.zip -> hg19.zip  [37m]

b) fasta index 
Fasta index using Samtools faidx : http://www.htslib.org/doc/samtools.html
	sudo apt-get install samtools
	Command: samtools faidx [file.fa] -> fasta file.fai

c) genome dict file for the reference genome. 
Genome dict file using picard : 
https://broadinstitute.github.io/picard/command-line-overview.html#CreateSequenceDictionary
Used to download java8:
	sudo apt-get install software-properties-common python-software-properties
	sudo add-apt-repository ppa:webupd8team/java
	sudo apt-get update
	sudo apt-get install oracle-java8-installer

	Command: java -jar ~/ahcg_pipeline/lib/picard.jar CreateSequenceDictionary \ 
	R=hg19.fa \ O=reference.dict

6) Test Data
wget ftp://ftp-trace.ncbi.nih.gov/giab/ftp/data/NA12878/Garvan_NA12878_HG001_HiSeq_Exome/NIST7035_TAAGGCGA_L001_R1_001.fastq.gz
wget ftp://ftp-trace.ncbi.nih.gov/giab/ftp/data/NA12878/Garvan_NA12878_HG001_HiSeq_Exome/NIST7035_TAAGGCGA_L001_R2_001.fastq.gz
gunzip NIST7035_TAAGGCGA_L001_R1_001.fastq.gz
gunzip NIST7035_TAAGGCGA_L001_R2_001.fastq.gz
head -100000 NIST7035_TAAGGCGA_L001_R1_001.fastq > test_r1.fastq
head -100000 NIST7035_TAAGGCGA_L001_R2_001.fastq > test_r2.fastq

7) Run
sudo apt-get install python3-minimal
sudo apt-get install unzip 
unzip hg19.zip --->for hg19.zip error

python3 ahcg_pipeline.py  (-h)
VariantCaller -t (trimmomatic path) 
	-b (bowtie path) ...
	-p (picard path)
	-g (gatk path)
	-i (input to pe)  ..,..
	-w (bowtie index ref path) 
	-d (dbsnp path .vcf)
	-r (ref path)
	-a (adapter file) 
	-o (output path to directory) 

#Place in background
screen
python3 ahcg_pipeline.py -t ~/ahcg_pipeline/lib/Trimmomatic-0.36/trimmomatic-0.36.jar \
-b ~/ahcg_pipeline/lib/bowtie2-2.2.9/bowtie2 \
-p ~/ahcg_pipeline/lib/picard.jar \
-g ~/ahcg_pipeline/lib/GenomeAnalysisTK.jar \
-i ~/ahcg_pipeline/test*1.fastq \ 
-w ~/ahcg_pipeline/resources/genome/hg19 \
-d ~/ahcg_pipeline/resources/dbsnp/dbsnp_138.hg19.vcf.gz \
-r ~/ahcg_pipeline/resources/genome/hg19.fa \
-a ~/ahcg_pipeline/lib/Trimmomatic-0.36/adapters/TruSeq2-PE.fa \
-o ~/ahcg_pipeline/variant
Ctrl + A Ctrl + D

#To resume
screen -r 
