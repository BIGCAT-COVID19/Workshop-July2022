# Transcriptomics dataset

We selected the following publicly available RNA-seq dataset as an example for workshop days 2-3:

* Primary human lung epithelium (NHBE cells) were mock treated or infected with SARS-CoV-2 (USA-WA1/2020).
* The dataset has been uploaded to GEO - identifier: [GSE147507](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE147507).
* The dataset was used in the publications by Blanco-Melo D. _et. al._ in 2020 (doi: [10.1016/j.cell.2020.04.026](https://doi.org/10.1016/j.cell.2020.04.026)). 
* The dataset looks at different cell lines and exposures. In the workshop, we will focus on Series1 NHBE_SARS-CoV-2 vs. NHBE_Mock.

### Pre-processing and differential analysis

* The pre-processing and statistical anslysis was done with DESeq2 in R (see script here). 
* 21,207 genes were measured.
* 1,333 genes are differentially expressed (p-value < 0.05, |log2FC| > 0.26)

![image](https://user-images.githubusercontent.com/2158343/175516657-f0a184e9-a000-43bd-808e-a802d000d192.png)
