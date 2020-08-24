# Overview


The analysis code contained in *qPCR_Analysis.Rmd* uses data stored in a folder called *Data*. The contents of the *Data* folder are described in the following subsection.


# Data Folder


- formatted.csv: The first three columns are titled "Sample" and "Label". These columns are described in the bullets below. The remaining columns are titled by gene name. Each cell in these columns contains a value that can be obtained by dividing the average of technical replicates by the average expression of RPL19 for the corresponding sample.
 - Sample: The sample number with the "PUL_" prefix.
  - Label: AIUP or ECT.


# Running the analysis


Start the Docker image used for this analysis (see the upper level README to see how). After navigating to the *qPCR_Analysis* folder and setting it is as the working directory, click "knit".


# Outputs


The step-by-step description of the analysis is contained in *qPCR_Analysis.html*. All tables and figures included in *qPCR_Analysis.html* are stored in the *Results* folder.


# Methods


One-tailed Wilcoxon rank-sum tests were performed on normalized data, testing whether classifier gene expression was elevated in ECT samples. To normalize qPCR data the ΔCt values of technical replicates were averaged and the expression levels divided by the average ΔCt value for the corresponding RPL19 loading control.
