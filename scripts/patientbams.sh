#!/bin/bash
#For downloading DCM patient bam files

echo Starting Download
mkdir patients
cd patients
#Control1:
wget http://vannberg.biology.gatech.edu/data/DCM/MenCo001DNA/Control1_RG_MD_IR_BQ.bam
wget http://vannberg.biology.gatech.edu/data/DCM/MenCo001DNA/Control1_RG_MD_IR_BQ.bai

#Control2:
wget http://vannberg.biology.gatech.edu/data/DCM/MenCo002DNA/Control2_RG_MD_IR_BQ.bam
wget http://vannberg.biology.gatech.edu/data/DCM/MenCo002DNA/Control2_RG_MD_IR_BQ.bai

#Patient1:
wget http://vannberg.biology.gatech.edu/data/DCM/MenPa001DNA/Patient1_RG_MD_IR_BQ.bam
wget http://vannberg.biology.gatech.edu/data/DCM/MenPa001DNA/Patient1_RG_MD_IR_BQ.bai

#Patient2:
wget http://vannberg.biology.gatech.edu/data/DCM/MenPa002DNA/Patient2_RG_MD_IR_BQ.bam
wget http://vannberg.biology.gatech.edu/data/DCM/MenPa002DNA/Patient2_RG_MD_IR_BQ.bai

#Patient3:
wget http://vannberg.biology.gatech.edu/data/DCM/MenPa003DNA/Patient3_RG_MD_IR_BQ.bam
wget http://vannberg.biology.gatech.edu/data/DCM/MenPa003DNA/Patient3_RG_MD_IR_BQ.bai

#Patient4:
wget http://vannberg.biology.gatech.edu/data/DCM/MenPa004DNA/Patient4_RG_MD_IR_BQ.bam
wget http://vannberg.biology.gatech.edu/data/DCM/MenPa004DNA/Patient4_RG_MD_IR_BQ.bai

echo Complete
cd ../
