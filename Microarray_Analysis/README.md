# Overview


The analysis code contained in *Microarray_Analysis.Rmd* uses data stored in a folder called *Data*. The contents of the *Data* folder are described in the following subsection. The contents of the *Parameters.R* file specifies mappings between data and annotation files.


# Data Folder


- Arrays: Folder for storing array data. It consists of subfolders.
  - Horne_Lab: Folder for holding array data from the Horne lab publication. Duncan, W. C., Shaw, J. L., Burgess, S., McDonald, S. E., Critchley, H. O., & Horne, A. W. (2011). Ectopic pregnancy as a model to identify endometrial genes and signaling pathways important in decidualization and regulated by local trophoblast. PloS one, 6(8), e23595. doi:10.1371/journal.pone.0023595.
    - A-AFFY-44: Folder containing the data downloaded from ArrayExpress using accession A-AFFY-44.
    - E-MTAB-680: Folder containing the data downloaded from ArrayExpress using accession E-MTAB-680.
    - conditions.txt: A two column tab delimited file with columns as below. The data in this table was derived from table 1 of the associated publication.
      - Sample: Sample ID.
      - Group: IUP or EP for intrauterine and ectopic pregnancy, respectively.
 - MAMC_DCI: Folder for holding array data from the discovery and prospective phases of the project.
  - Probset_annotations: Contains the zipped and unzipped folder containing the probeset annotations for the array used (HuGene-2_0-st-v1.na36.hg19.probeset). Where to download this data is described in the *Microarray_Analysis.Rmd* file.
   - HuGene-2_0-st-v1.na36.hg19.probeset.csv.zip: Zip file downloaded as described above.
   - HuGene-2_0-st-v1.na36.hg19.probeset.csv: The zip file unzipped.
    - GeneArray_NetAffx-CSV-Files.README.txt: Documentation related to the annotations.
    - HuGene-2_0-st-v1.na36.hg19.probeset.csv: The annotation file.
  - Test: Folder for storing the prospective dataset array data and metadata.
   - metadata.xls: Microsoft Excel file for storing metadata. The file contains 4 columns described in the bullets below.
    - Sample: Sample ID prefixed with "PUL_".
    - Group: AIUP or EP for abnormal intrauterine and ectopic pregnancy, respectively.
    - PUL: No value or an "x" to indicate that the sample was originally classified as a PUL.
    - RIN: The RIN score associated with the sample.
   - CEL_files: Folder of .CEL files. File names are the same as those in the *Sample* column of the metadata file with ".CEL" appended.
  - Test_RepOfTrain: Folder for storing data associated with samples that were assayed in both the discovery phase of the experiment and the prospective phase. Samples contained in this folder were assayed at the same time as the samples assayed in the *Test* folder. However, since these samples were collected and also assayed during the discovery phase, these samples are matched to samples in the *Train* folder.
   - metadata.xls: The format is the same as the format of the corresponding file in the *Test* folder, except the *PUL* column is absent.
   - CEL_files: Folder storing .CEL files, as above.
  - Train: Folder for storing data associated with the discovery phase of the project.
   - metadata.xls: The format is the same as the format of the corresponding file in the *Test* folder, except both the *PUL* and *RIN* columns are absent.
   - CEL_files: Folder storing .CEL files, as above.


- Reference: Folder for storing reference data.
  - Sergeeva_Lab: Folder for storing reference data from the Sergeeva lab publication. Ivliev, A. E., 't Hoen, P. A., van Roon-Mom, W. M., Peters, D. J., & Sergeeva, M. G. (2012). Exploring the transcriptome of ciliated cells using in silico dissection of human tissues. PloS one, 7(4), e35618. doi:10.1371/journal.pone.0035618
   - journal.pone.0035618.s010.XLS: Supplementary table 10 of the above publication. It contains a list of cilia-associated genes.


# Running the analysis


Start the Docker image used for this analysis (see the upper level README to see how). After navigating to the *Microarray_Analysis* folder and setting it is as the working directory, click "knit".


# Outputs


The step-by-step description of the analysis is contained in *Microarray_Analysis.html*. All tables and figures included in *Microarray_Analysis.html*, plus many additional ones, are stored in the *Results* folder.
