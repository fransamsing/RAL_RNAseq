#!/bin/bash

#Download files from Macrogen 

cd /OSM/CBR/AF_RIDLEYWP4/work/ral_hemoRNAseq_rawDATA

for x in P1A2_1.fastq.gz P1A3_1.fastq.gz P1B2_1.fastq.gz P1B3_1.fastq.gz P1C2_1.fastq.gz P1C3_1.fastq.gz P2A2_1.fastq.gz P2A3_1.fastq.gz P2B2_1.fastq.gz P2B3_1.fastq.gz P2C2_1.fastq.gz P2C3_1.fastq.gz P3A2_1.fastq.gz P3A3_1.fastq.gz P3B2_1.fastq.gz P3B3_1.fastq.gz P3C2_1.fastq.gz P3C3_1.fastq.gz P1A2_2.fastq.gz P1A3_2.fastq.gz P1B2_2.fastq.gz P1B3_2.fastq.gz P1C2_2.fastq.gz P1C3_2.fastq.gz P2A2_2.fastq.gz P2A3_2.fastq.gz P2B2_2.fastq.gz P2B3_2.fastq.gz P2C2_2.fastq.gz P2C3_2.fastq.gz P3A2_2.fastq.gz P3A3_2.fastq.gz P3B2_2.fastq.gz P3B3_2.fastq.gz P3C2_2.fastq.gz P3C3_2.fastq.gz; do wget -b http://data.macrogen.com/~macro3/HiSeq02//20200507/HN00126866/$x; done
