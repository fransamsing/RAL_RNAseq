# Workflow for RAL hemocytes RNAseq dataset

This workflow will align the align the raw RNAseq reads to the *P.monodon* transcriptome using **Salmon**.
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

The transcriptomes was downloaded into ```/scratch1/sam079/P_monodon/```.


















