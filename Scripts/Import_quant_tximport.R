## Importing Data into DEseq using tximport ## 
# https://bioconductor.riken.jp/packages/3.7/bioc/vignettes/tximport/inst/doc/tximport.html
#BiocManager::install("tximport")
library("tximport")
library("readr")
library("DESeq2")

# Load Metadata file
samples <- read.table("ral_hemoRNAseq_metadata.csv", header = TRUE, sep = ",")
samples$time <- as.factor(samples$time)  # convert time to factor for downstream stats 
str(samples)

# Path to Quant Files from Salmon
dir <- "/Volumes/WINHOME01/Data_work_for_collegues/Tansyn/Data/Quant_files"

files <- file.path(dir, samples$sampleID, "quant.sf")
names(files) <- samples$sampleID

# Import Files using tximport
txi.tx <- tximport(files, type = "salmon", txOut = TRUE)


# Create DEseq object from tximport file
dds <- DESeqDataSetFromTximport(txi.tx,
                                   colData = samples) 

counts_matrix <- assay(dds)
head(counts_matrix)
#write.table(counts_matrix, file="Results/count_matrix.csv", sep=",", quote=F, col.names=NA)