# Overview


The analysis code contained in *Platform_Comparisons.Rmd* uses data stored in a folder called *Data*. The contents of the *Data* folder are described in the following subsection.


# Data Folder


The *Data* folder contains three files. These files contain the normalized expression levels for the discovery and prospective datasets for all three platforms on which they were assayed: microarray, nCounter, and qPCR. The files can be found in the *Results* folder of the corresponding analysis. The files have the same format. The contents of the columns in these files are outlined in the following bullets.


- Sample: The sample ID number prefixed with "PUL_".
- Label: AIUP or ECT.
- Data: The dataset from which the sample is derived.
- Gene: The gene symbol.
- Expression: The expression level relative to the average for AIUP samples on that platform. The values are not in log2 format.
- Source: The platform from which the data was obtained.


# Running the analysis


Start the Docker image used for this analysis (see the upper level README to see how). After navigating to the *Platform_Comparisons* folder and setting it is as the working directory, click "knit".


# Outputs


The step-by-step description of the analysis is contained in *Platform_Comparisons.html*. All tables and figures included in *Platform_Comparisons.html* are stored in the *Results* folder.


# Methods

The data files described above were loaded and Spearman's correlations between sample-wise expression levels were calculated.
