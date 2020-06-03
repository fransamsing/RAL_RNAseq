# RNAseq workflow for RAL hemocytes data
This workflow will align raw RNAseq reads to the *P.monodon* transcriptome using **Salmon** and the following pipeline: 
![Image of workflow](https://github.com/fransamsing/Salmon_align/blob/master/Docs/Analysis_pipeline.png)
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

Hub transcriptome from [Huerlimann et al. 2018](https://www.nature.com/articles/s41598-018-31148-4), can be downloaded from:

* https://sra-download.ncbi.nlm.nih.gov/traces/wgs03/wgs_aux/GG/LH/GGLH01/GGLH01.1.fsa_nt.gz
* Github with code: https://github.com/R-Huerlimann/Pmono_multitissue_transcriptome

## Make an input list

The input list ```STARInputList.csv``` will help you call all samples at the same time when running the alignment script. 

This was creaded in R using the following command: 

```
# Get METADATA with Read 1 and Read 2 in separate columns to create a STAR input list
library(tidyverse)

metadata <- read_csv("METADATA.csv")
metadata$read <- rep(c("1","2"), 18)
read1 <- metadata %>% filter(read == 1)
read2 <- metadata %>% filter(read == 2)

read1 <- read1[,1]
read2 <- read2[,1]

reads_combined <- cbind(read1, read2)
colnames(reads_combined) <- c('read1', 'read2')


STAR_input_files <- reads_combined %>% separate(read1, c('sample_ID', 'file_format'), sep = '_', remove = FALSE)
STAR_input_files <- cbind(STAR_input_files$sample_ID, STAR_input_files$read1, STAR_input_files$read2)

#write.table(STAR_input_files, "STARInputList.csv", row.names = F, col.names = F, sep=",", quote=FALSE)
```
## Alignment of Raw Reads to the hub transcriptoe using Salmon 

- [**Salmon Home Page**](https://combine-lab.github.io/salmon/)
- [**Salmon workflow**](https://hbctraining.github.io/Intro-to-rnaseq-hpc-salmon/lessons/04_quasi_alignment_salmon.html)

Salmon uses the reference transcriptome (in FASTA format) and raw sequencing reads (in FASTQ format) as input to perform both mapping and quantification of the reads.

The link to the **Salmon** paper published in Nature Methods in 2017 can be found [here](https://www.nature.com/articles/nmeth.4197)

### 1. Creating the Transcriptome Index

This step involves creating an index to evaluate the sequences for all possible unique sequences of length k (k-mer) in the transcriptome, which includes all known transcripts/splice isoforms for all genes.

First, make a directory in scratch to save the index. 
```mkdir /scratch1/sam079/RAL_hemoRNAseq/Salmon/Index```

Then, run the ```salmon_index.sh``` script. 

### 2. Mapping and quantification with Salmon

The quasi-mapping approach used by Salmon estimates where the reads best map to on the transcriptome through identifying where informative sequences within the read map to instead of performing base-by-base alignment

After determining the best mapping for each read/fragment using the quasi-mapping method, salmon will generate the final transcript abundance estimates after modeling sample-specific parameters and biases. 

To map and quantify raw reads, run the ```salmon_align.sh``` script. 

In this script: 

- ```-i```: specify the location of the index directory; for us ```/scratch1/sam079/RAL_hemoRNAseq/Salmon/Index```
- ```--useVBOpt```: use variational Bayesian EM algorithm rather than the ‘standard EM’ to optimize abundance estimates (more accurate)
- ```--seqBias```: will enable it to learn and correct for sequence-specific biases in the input data
-```p 8```: number of threads
- ```-l A```: Format string describing the library type. ```A``` will automatically infer the library type (e.g. unstranded)
- ```-1```: sample file, forward reads
- ```-2```: sample file, reverse reads
- ```-o```: output quantification file names

### 3. Salmon output

In the previous mapping step, new directories are created for each sample. A list of them can be found here: 

```ls /scratch1/sam079/RAL_hemoRNAseq/Salmon/Align/```

Inside each directory, there is a ```quant.sf``` file. This is the quantification file in which each row corresponds to a transcript, and the columns correspond to metrics for each transcript. You can inspect the first one using:

```cat /scratch1/sam079/RAL_hemoRNAseq/Salmon/Align/P1A2/quant.sf | head```

The read mapping summary for each sample is found in the ```aux_info/``` directory for each sample, in the ```meta_info.json``` file. You can print this information for each file by running:

```cat /scratch1/sam079/RAL_hemoRNAseq/Salmon/Align/P1A2/aux_info/meta_info.json```

To view other files, just change the directory path to each sample ID. 

Among many other parameters, this meta_info file shows: 

- 'library_types': ['IU'] -> which stands for **Inward** and **Unstranded**. More info [here](https://salmon.readthedocs.io/en/latest/salmon.html#what-s-this-libtype)
- 'percent_mapped': 91.75186622610238 -> which was very good for all files! 

You can also loop through all files running this from the ```Scripts/``` directory:

```
FILENAMES=$(cut -d , -f 1 ../STARInputList.csv)
INPDIR=/scratch1/sam079/RAL_hemoRNAseq/Salmon/Align
for f in $FILENAMES
         do 
         echo ${f}
         grep -r '"percent_mapped":'  ${INPDIR}/${f}/aux_info/meta_info.json
done 
```

## RNAseq-workflow and Differential Expression

**Resources:**
- [RNA-seq workflow](https://bioconductor.org/packages/release/workflows/vignettes/rnaseqGene/inst/doc/rnaseqGene.html)
- [RNAseq using DEseq](https://bioconductor.org/packages/release/bioc/vignettes/DESeq2/inst/doc/DESeq2.html)

### 1. Export quantification files to local machine 

Using [fileZilla](https://filezilla-project.org/) export the files in ```/scratch1/sam079/RAL_hemoRNAseq/Salmon/Align``` to a local machine to run differential expression analysis. You can connect to fileZilla using:

- Host: pearcey.hpc.csiro.au
- Username: your Pearcey username or Ident
- Password: your Ident password
- Port: 22

On your left side, you should have your local machine directory, navigate to the directory where you want to save the files. On your right side, you should have the scratch1 directory ```/scratch1/sam079/RAL_hemoRNAseq/Salmon/Align```

Then simply drag and drop these files into your local directory. 

### 2. Import quantification files into R 

Once the files (one for each sample) are in a local directory ```(Data/Quant_files)```, this can be imported into R using ```tximport```, which can be installed from [Bioconductor](https://bioconductor.riken.jp/packages/3.7/bioc/vignettes/tximport/inst/doc/tximport.html).

The R code to run this is called ```Import_quant_tximport.R```

The output from this code is a file called ```count_matrix.csv```, which can be further processed using DESeq or similar (e.g. EdgeR). 

### 3. Differential Expression Using DESeq2

The start of the differential expression pipeline can be found in ```DESeq_from_count_matrix.R```. 

Example of some of the outputs

**PCA PLOT**

![PCA_plot](https://github.com/fransamsing/Salmon_align/blob/master/Results/PCA_plot.png)

**Volcano Plots**

![30mins](https://github.com/fransamsing/Salmon_align/blob/master/Results/volcano_plot_30mins.png)


![60mins](https://github.com/fransamsing/Salmon_align/blob/master/Results/volcano_plot_60mins.png)










