# Overview


The analysis code contained in *Expression_Analysis.Rmd* uses data stored in a folder called *Data*. The contents of the *Data* folder are described in the following subsection.


# Data Folder


The *Data* folder contains four files. Each file includes the normalized expression level data for the genes of interest for the corresponding platform. There are two files for microarray data, one contains the internal data and the other other external data.


- Label: AIUP or ECT.
- Expression: The expression level on (0, Inf).
- Gene: The gene symbol.
- Sample: The sample ID.
- Source: Microarray, nCounter, or qPCR.


# Running the analysis


Start the Docker image used for this analysis (see the upper level README to see how). After navigating to the *Expression_Analysis* folder and setting it is as the working directory, click "knit".


# Outputs


The step-by-step description of the analysis is contained in *Expression_Analysis.html*. All tables and figures included in *Expression_Analysis.html* are stored in the *Results* folder.


# Methods


This analysis plots the expression levels and associated p values for two sided Wilcox tests as described elsewhere.
