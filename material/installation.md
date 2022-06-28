# Installation instructions

### Day 1

Please install the following tools (available on all platforms):
* PathVisio requires the installation of [Java 8](https://www.oracle.com/java/technologies/javase/javase8u211-later-archive-downloads.html) - you might need to create an Oracle account (free) before you can download it.
* [PathVisio v3.3.0](https://pathvisio.org/downloads)

Download the following databases:
* BridgeDb human mapping databases - [Overiew](https://bridgedb.github.io/data/gene_database/) 
  * Download the database for Homo sapiens: Hs_Derby_Ensembl_105.bridge
  * Download the metabolites database: metabolites_20210109.bridge

<hr/>

### Day 2

Please install the following tools (available on all platforms):
* [Cytoscape v3.9.1](https://cytoscape.org/download.html)

Open Cytoscape and go to App > App Manager
* Install the WikiPathways app
* Install the CyTargetLinker app
* Install the stringApp
* Install the clusterMaker2 app

<hr/>

### Day 3

Please install the following tools (available on all platforms):
* [R v4.2.1](https://cloud.r-project.org/)
* [RStudio](https://www.rstudio.com/products/rstudio/download/#download)

Install required R-packages**

Open RStudio after installing R and RStudio and install BioCManager and required packages (you can copy the code and run it in RStudio)
```R
install.packages("BiocManager")
BiocManager::install("RCy3") 
BiocManager::install("rWikiPathways") 
BiocManager::install("clusterProfiler") 
BiocManager::install("org.Hs.eg.db") 
BiocManager::install("RColorBrewer") 
BiocManager::install("EnhancedVolcano") 
BiocManager::install("dplyr") 
BiocManager::install("tidyverse") 
BiocManager::install("clusterProfiler") 
BiocManager::install("DESeq2") 

install.packages("rstudioapi") 
install.packages("readr") 
install.packages("data.table")
```

<hr/>

**Contact**

Feel free to contact us in case you have problems installing the software or packages (ideally before the workshop!).<br/>
Submit an issue in the [Issue Tracker](https://github.com/BIGCAT-COVID19/Workshop-July2022/issues) and we will get back to you as soon as possible.
