# Workflow for RAL hemocytes RNAseq dataset

This workflow will align raw RNAseq reads to the *P.monodon* transcriptome using **Salmon** and the following pipeline: 
![Image of workflow](https://github.com/fransamsing/Salmon_align/blob/master/Docs/Analysis_pipeline.png).
First, download and clone this github directory into your home directory in Pearcey using:

``` git clone https://github.com/fransamsing/Salmon_align``` 

After cloning, all scripts are designed to run from the ```Scripts/``` directory.

## Data Download and Storage

Raw data for this project was downloaded from Macrogen into Bowen Cloud (/OSM/CBR/AF_RIDLEYWP4/work/ral_hemoRNAseq_rawDATA) using the ```download_data.sh``` script. 

Raw data was also downloaded into scratch1, which can be accessed here:

```cd /scratch1/sam079/RAL_hemoRNAseq/Data```

## Check quality of download: MD5 sum check

To check that data has been downloaded properly, run ```md5sum_check.sh```. This will create the md5sum check files that can be found in the ```Results/``` directory. 

## Assessing quality of raw RNAseq reads

To assess the quality of RNAseq reads, run ```fastqc.sh```. Results from FastQC can be found in the ```Results/fastqc``` directory. 

The quality of the raw RNAseq data looks really good, so we proceed with the pipeline. 

## Download the *Penaeus monodon* transcriptome

The transcriptomes was downloaded into ```/scratch1/sam079/P_monodon/``` using ```wget```.

**Hub transcriptome from Huerlimann et al. 2018 (https://www.nature.com/articles/s41598-018-31148-4), available here:**

* https://sra-download.ncbi.nlm.nih.gov/traces/wgs03/wgs_aux/GG/LH/GGLH01/GGLH01.1.fsa_nt.gz
* Github with code: https://github.com/R-Huerlimann/Pmono_multitissue_transcriptome

## Make an input list

The input list ```STARInputList.csv``` will help you call all samples at the same time when running the alignment script. 

This was creaded in R using the following command: 

```
# Get METADATA with Read 1 and Read 2 in separate columns to create a STAR input list
library(tidyverse)

metadata <- read_csv("/home/sam079/RAL_hemoRNAseq/METADATA.csv")
metadata$read <- rep(c("1","2"), 18)
read1 <- metadata %>% filter(read == 1)
read2 <- metadata %>% filter(read == 2)

read1 <- read1[,1]
read2 <- read2[,1]

reads_combined <- cbind(read1, read2)
colnames(reads_combined) <- c('read1', 'read2')


STAR_input_files <- reads_combined %>% separate(read1, c('sample_ID', 'file_format'), sep = '_', remove = FALSE)
STAR_input_files <- cbind(STAR_input_files$sample_ID, STAR_input_files$read1, STAR_input_files$read2)

#write.table(STAR_input_files, "/home/sam079/RAL_hemoRNAseq/STARInputList.csv", row.names = F, col.names = F, sep=",", quote=FALSE)
```
















