## Copyright (c) 2022 Maastricht University

## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at

## http://www.apache.org/licenses/LICENSE-2.0

## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.

##########################################
# Title: DEG analysis for NHBE (COVID19 vs mock infected)
# Date: 2022-06-24
# Author: Martina Summer-Kutmon, Finterly Hu
##########################################

# Dataset selected: https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE147507
# We take the series 1 from the following dataset (NHBE mock treated versus SARS-CoV-2 infected) 

# ===================================================================

BiocManager::install("DESeq2", update = FALSE)
BiocManager::install("org.Hs.eg.db", update = FALSE)
BiocManager::install("dplyr", update = FALSE)
BiocManager::install("data.table", update = FALSE)
BiocManager::install("EnhancedVolcano", update = FALSE)

library(org.Hs.eg.db)
library(dplyr)
library(DESeq2)
library(data.table)
library(EnhancedVolcano)

setwd(dirname(rstudioapi::getSourceEditorContext()$path))

# ===================================================================
# Adapted from Julio's script on the following URL
# https://github.com/saezlab/Covid19_phospho/blob/master/02_Carnival_Transcriptomics_phosphoprotemicsMann.md

GSE147507_raw_counts <- read.csv("GSE147507_RawReadCounts_Human.tsv", sep = "\t")
GSE147507_raw_counts <- GSE147507_raw_counts[,c(1:7)]

# identifier mapping 
hgnc2entrez <- clusterProfiler::bitr(GSE147507_raw_counts$X, fromType = "SYMBOL",toType = c("ENTREZID","SYMBOL","ENSEMBL"), OrgDb = org.Hs.eg.db)
hgnc2entrez.unique <- hgnc2entrez[!duplicated(hgnc2entrez$SYMBOL), ]

# subset data for two cell lines
NHBE.df <- GSE147507_raw_counts[,c(2:7)]
row.names(NHBE.df) <- GSE147507_raw_counts$X

# clean up
rm(GSE147507_raw_counts, hgnc2entrez)

## define conditions
NHBE.targets <- as.data.frame(matrix(NA,length(names(NHBE.df)),1))
names(NHBE.targets) <- c("condition")
row.names(NHBE.targets) <- names(NHBE.df)
NHBE.targets$condition <- gsub("Series1_", "", row.names(NHBE.targets))
NHBE.targets$condition <- factor(gsub("_[1-3]$", "", NHBE.targets$condition))

# run differential expression analysis
NHBE.dds <- DESeqDataSetFromMatrix(countData = as.matrix(NHBE.df),colData = NHBE.targets, design = ~ condition)
NHBE.dds$condition <- relevel(NHBE.dds$condition, ref = levels(NHBE.targets$condition)[1])
NHBE.dds <- DESeq(NHBE.dds)
NHBE.comp <- resultsNames(NHBE.dds)
NHBE.res <- results(NHBE.dds, name=NHBE.comp[2])

# ===================================================================

# saving differential gene expression result
NHBE.res.df <- as.data.frame(NHBE.res) %>% tibble::rownames_to_column(var = "GeneID") %>% dplyr::select(c(GeneID, log2FoldChange, pvalue, padj, stat)) %>% tibble::column_to_rownames(var = "GeneID")
NHBE.res.df <- data.table:setDT(NHBE.res.df, keep.rownames = TRUE)[]
colnames(NHBE.res.df)[1] <- "SYMBOL"
NHBE.res.df.ids <- merge(NHBE.res.df, hgnc2entrez.unique, by.x = "SYMBOL", by.y="SYMBOL", keep.x = TRUE)
write.table(NHBE.res.df.ids[,c(1,6,7,2:5)], "NHBE-DEG.tsv", quote=FALSE, sep="\t", row.names = FALSE)

# ===================================================================

# result NHBE
print(paste0("Number of genes measured (NHBE): ", nrow(NHBE.res.df.ids)))
NHBE.degs <- NHBE.res.df.ids[NHBE.res.df.ids$pvalue < 0.05 & abs(NHBE.res.df.ids$log2FoldChange) > 0.26, ]
print(paste0("Number of DEG genes (p-val < 0.05 + |log2FC| > 0.26, NHBE): ", nrow(NHBE.res.df.ids[NHBE.res.df.ids$pvalue < 0.05 & abs(NHBE.res.df.ids$log2FoldChange) > 0.26, ])))

# ===================================================================

# volcano plot

EnhancedVolcano(NHBE.res.df.ids, title = "NHBE cell line", lab = NHBE.res.df.ids$SYMBOL, x = 'log2FoldChange', y = 'pvalue', pCutoff = 0.05, FCcutoff = 0.26)
