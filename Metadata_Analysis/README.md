# Overview


The analysis code contained in *Metadata_Analysis.Rmd* uses data stored in a folder called *Data*. The contents of the *Data* folder are described in the following subsection.


# Data Folder


The *Data* folder contains one file. This file provides the metadata for each individual assayed. The contents of the columns in these files are outlined in the following bullets. Two columns not listed below (EGA_week_component and EGA_day_component) were used to calculate the "EGA (days)". The two columns represent the separation of the week and day component of the clinician's usual textual representation of EGA (i.e. 8 and 4/7 for 8 week and 4 days).


- Sample: The sample ID.
- Label: AIUP or ECT.
- Data: The dataset from which the sample is derived.
- Age (years): The patient's age in years.
- BMI: The patient's BMI.
- Gravidity: The patient's gravidity at the time of presentation.
- EGA (days): The estimated gestational age in days.
- Serum Progesterone (ng/mL): The serum progesterone levels in ng/mL.


# Running the analysis


Start the Docker image used for this analysis (see the upper level README to see how). After navigating to the *Metadata_Analysis* folder and setting it is as the working directory, click "knit".


# Outputs


The step-by-step description of the analysis is contained in *Metadata_Analysis.html*. All tables and figures included in *Metadata_Analysis.html* are stored in the *Results* folder.


# Methods


This analysis compares AIUP and ECT groups with respect to a number of numerical variables by performing two tailed t tests.
