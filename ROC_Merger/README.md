# Overview


The analysis code contained in *ROC_Merger.Rmd* uses data stored in a folder called *Data*. The contents of the *Data* folder are described in the following subsection.


# Data Folder


The *Data* folder contains four files. These files contain predictions or probability cutoffs used for different models.


- nCounter_Internal_Samples.xlsx: Predictions made using the nCounter loocv model on the internal data.
- nCounter_Internal_Threshold: The probability cutoff for the above data.
- Microarray_Samples.xlsx: Predictions made using the loocv models on the internal and external data.
- Microarray_Internal_Threshold.xlsx: The probability cutoff used with the internal microarray data model.
- Microarray_External_Threshold.xlsx: The probability cutoff used with the external microarray data model.


# Running the analysis


Start the Docker image used for this analysis (see the upper level README to see how). After navigating to the *ROC_Merger* folder and setting it is as the working directory, click "knit".


# Outputs


The step-by-step description of the analysis is contained in *ROC_Merger.html*. All tables and figures included in *ROC_Merger.html* are stored in the *Results* folder.


# Methods


The code in this analysis uses the files described above to create a single image with all ROC curves.
