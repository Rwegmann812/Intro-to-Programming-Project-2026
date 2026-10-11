# Intro-to-Programming-Project-2026
This project investigates the correlation between tumor size (cm) and patient age (years) in the MAINZ breast cancer cohort. The project will also focus on how sample size influences the stability of the Pearson's correlation coefficient. The dataset is public and published on Bioconductor by Schroeder et al. in 2026
## Research Question
How does sample size influence an  estimated linear relationship between patient age and tumor size in the MAINZ breast cancer cohort?
## Dataset
**Source:** Schroeder, M., Haibe-Kains, B., Culhane, A., Sotiriou, C., Bontempi, G., & Quackenbush, J.
(2026). breastCancerMAINZ: Gene expression dataset published by Schmidt et al. [2008]
(MAINZ) (Version 1.50.0) [R package]. Bioconductor.
https://doi.org/10.18129/B9.bioc.breastCancerMAINZ

**Original Paper:** Schmidt, M., Böhm, D., von Törne, C., Steiner, E., Puhl, A., Pilch, H., Lehr, H. A.,Hengstler, J. G., Kölbl, H., & Gehrmann, M. (2008). The humoral immune system has a key
prognostic impact in node-negative breast cancer. Cancer research, 68(13), 5405–5413.
https://doi.org/10.1158/0008-5472.CAN-07-5206
## What the script does
- loads the data
- creates a scatter plot with a fitted linear regression line and Pearson's correlation coefficient for all 200 patients
- performs random subsampling by randomly selecting groups of 20, 40, 80, and 160 patients without replacement and repeating the correlation 1000 times for each sample size. set.seed(123) makes the random subsampling reproducible
- calculates the standard deviation of the correlation estimates for each sample size
- generates boxplots showing how the distribution of correlation estimates changes with sample size using the full cohort as a reference
## Output 
The script generates and saves to a folder called 'plots': 
- Age_vs_Tumor_Size.png
- Subsampling_Pearson_Correlation.png
## How to run 
- if the packages have not been installed yet, install them through Bioconductor
(BiocManager). Instructions taken from Bioconductor (Schroeder,2026) 
- install BiocManager if it is not already installed
  
if (!requireNamespace("BiocManager", quietly = TRUE))

install.packages("BiocManager")
- install the required Bioconductor packages and data
  
BiocManager::install("breastCancerMAINZ")

BiocManager::install("Biobase")

  
- install ggplot2 (Wickham, 2016)

  install.packages("ggplot2")
- the script will retrieve the packages from the library
- set the working directory to the project folder


