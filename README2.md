Alicia Francis
# run_pipeline
Variant calling pipeline for genomic data analysis

## Requirements

1. [Python3 - version 3.4.1](https://www.python.org/download/releases/3.4.1/)
2. [Trimmomatic - version 0.36](http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.36.zip)
3. [Bowtie2 - version 2.2.9](https://sourceforge.net/projects/bowtie-bio/files/bowtie2/2.2.9/)
4. [Picard tools - version 2.6.0](https://github.com/broadinstitute/picard/releases/download/2.6.0/picard.jar)
5. [GATK - version 3.4](https://software.broadinstitute.org/gatk/download/)


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


## Required datasets

1. Reference genomes can be downloaded from [Illumina iGenomes](http://support.illumina.com/sequencing/sequencing_software/igenome.html)
   UCSC-hg19 reference genome was used for this dataset
2. Test dataset as a patient bam file

        Use the following protocol to download and prepare test dataset for Patient1:

        wget http://vannberg.biology.gatech.edu/data/DCM/MenPa001DNA/Patient1_RG_MD_IR_BQ.bam
        wget http://vannberg.biology.gatech.edu/data/DCM/MenPa001DNA/Patient1_RG_MD_IR_BQ.bai
3. GATK bundle for VSQR step
	https://software.broadinstitute.org/gatk/download/bundle
	--OR--
	Hapmap
	http://vannberg.biology.gatech.edu/data/ahcg2016/gatk/hapmap_3.3.hg19.sites.vcf.gz
	http://vannberg.biology.gatech.edu/data/ahcg2016/gatk/hapmap_3.3.hg19.sites.vcf.gz.tbi

	Omni
	http://vannberg.biology.gatech.edu/data/ahcg2016/gatk/1000G_omni2.5.hg19.sites.vcf.gz
	http://vannberg.biology.gatech.edu/data/ahcg2016/gatk/1000G_omni2.5.hg19.sites.vcf.gz.tbi

	1000G Phase I
	http://vannberg.biology.gatech.edu/data/ahcg2016/gatk/1000G_phase1.snps.high_confidence.hg19.sites.vcf.gz
	http://vannberg.biology.gatech.edu/data/ahcg2016/gatk/1000G_phase1.snps.high_confidence.hg19.sites.vcf.gz.tbi

	dbSNP
	http://vannberg.biology.gatech.edu/data/ahcg2016/gatk/dbsnp.vcf.gz
	http://vannberg.biology.gatech.edu/data/ahcg2016/gatk/dbsnp.vcf.gz.tbi


##Obtaining the Gene List
	Source: http://www.nature.com/gim/journal/vaop/ncurrent/full/gim201690a.html#results
	DCM gene list:
		LMNA    NM_170707
		MYBPC3  NM_000256
		MYH7    NM_000257
		MYH6    NM_002471
		SCN5A   NM_198056
		TNNT2   NM_001001430	
	Convert .txt to .bed file:
		awk '{print $2}' genelist.txt > nm_filename.txt
		grep -f nm_filename.txt hg19_refGene.txt > dcm_genelist.txt
		conver_bed.py -i dcm_genelist.txt -o dcm_genelist.bed


##Clinical data comparison using Clinvar
	Download: ftp://ftp.ncbi.nlm.nih.gov/pub/clinvar/vcf_GRCh37/clinvar.vcf.gz
	*Gunzip file
	add "chr" to get correct match
	awk '{if($0 !~ /^#/) print "chr"$0; else print $0}' clinvar.vcf > chr_clinvar.vcf
	#File is in script	

## Run Pipeline:
	Help for pipeline
		run_pipeline.sh (-h)
		
	VariantCaller options 
		-b (genelist in bed file name)
		-i (input patient bam file)  
		-o (output name for directory) 
	Output: .vcf file
