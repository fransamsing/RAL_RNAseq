## Differential Expression from Counts matrix

# Install packages using 
# BiocManager::install("DESeq2")
# BiocManager::install('EnhancedVolcano')

library(DESeq2)
library(EnhancedVolcano)

# Upload count matrix and metadata
counts_matrix <- as.matrix(read.table("Results/count_matrix.csv", row.names = 1, sep = ',', header = TRUE))
samples <- read.table("ral_hemoRNAseq_metadata.csv", header = TRUE, sep = ",")
samples$time <- as.factor(samples$time)
str(samples) # check the structure 

# Add a column to metadata file to include all contrasts
samples$groups <- paste(samples$treatment, samples$time, sep = "")
samples$groups <- as.factor(samples$groups)

# Create the DESeq object from count_matrix 
dds <- DESeqDataSetFromMatrix(countData = counts_matrix,
                              colData = samples,
                              design = ~ groups)

# Pre-filtering
keep <- rowSums(counts(dds)) >= 10
dds <- dds[keep,]

## Create the DESeq object for differential expression 
dds <- DESeq(dds) ## takes for ever! 

## Transform counts for data visualization and gene ranking
rld <- rlog(dds, blind=FALSE) ## takes for ever! 

## Plot PCA 
plotPCA(rld, intgroup=c("treatment", "time"))
plotPCA(rld, intgroup = c("groups")) ## should be the same as previous


## Heatmap of the count matrix
library("pheatmap")

select <- order(rowMeans(counts(dds,normalized=TRUE)),
                decreasing=TRUE)[1:100]

df <- as.data.frame(colData(dds)[,c("treatment", "time")])
assay(rld)[select,]

mat_data <- assay(rld)[select,]

pheatmap(mat_data, cluster_rows=FALSE, cluster_cols=FALSE, annotation_col=df, show_rownames = FALSE)

## Results 
## contrasts should be retrieved using: 
## results(dds, contrast=c("condition","treated","untreated"))
res_15 <- results(dds, contrast = c("groups", "nq15", "con15"), alpha = 0.05)
summary(res_15)

res_30 <- results(dds, contrast = c("groups", "nq30", "con30"), alpha = 0.05)
summary(res_30)

res_60 <- results(dds, contrast = c("groups", "nq60", "con60"), alpha = 0.05)
summary(res_60)

## Volcano Plots

EnhancedVolcano(res_30,
                lab = rownames(res_30),
                x = 'log2FoldChange',
                y = 'pvalue',
                xlim = c(-5, 10),
                ylim = c(0,100),
                pCutoff = 10e-12,
                FCcutoff = 1.5,
                cutoffLineType = 'twodash',
                cutoffLineWidth = 0.8,
                colAlpha = 1,
                title = "Control vs Treated",
                subtitle = "30 mins post-treatment",
                legendPosition = 'none')

EnhancedVolcano(res_60,
                lab = rownames(res_60),
                x = 'log2FoldChange',
                y = 'pvalue',
                xlim = c(-5, 10),
                ylim = c(0,100),
                pCutoff = 10e-12,
                FCcutoff = 1.5,
                cutoffLineType = 'twodash',
                cutoffLineWidth = 0.8,
                colAlpha = 1,
                title = "Control vs Treated",
                subtitle = "60 mins post-treatment",
                legendPosition = 'none')




