# Overview


The analysis code contained in *Microarray_Analysis.Rmd* uses data stored in a folder called *Data*. The contents of the *Data* folder are described in the following subsection. The contents of the *Parameters.R* file specifies mappings between data and annotation files.


# Data Folder


- CEL: Folder for storing array data. It consists of CEL files from GSE112879, GSE131529, and E-MTAB-680. The latter corresponds to the publication -- Duncan, W. C., Shaw, J. L., Burgess, S., McDonald, S. E., Critchley, H. O., & Horne, A. W. (2011). Ectopic pregnancy as a model to identify endometrial genes and signaling pathways important in decidualization and regulated by local trophoblast. PloS one, 6(8), e23595. doi:10.1371/journal.pone.0023595.
- Annotation_Files: Folder for storing array annotations.
 - A-AFFY-44.adf.txt: The annotation file for the external dataset. It was downloaded from ArrayExpress using accession A-AFFY-44.
 - HuGene-2_0-st-v1.na36.hg19.probeset.csv: The annotation file for the internal dataset.
- metadata.xls: File indicating metadata.
  - Unique_ID: Row number
  - Data_Source: Internal/External
  - Sample: Sample ID (PUL_10, MP11, 1-1, etc.)
  - Group: AIUP/ECT
  - PUL: Whether the sample was identified as a PUL at a later stage
  - Replicate_ID: The *Unique_ID* of the sample's replicate
  - Database: GEO/ArrayExpress
  - Source: GSE112879/GSE131529/E-MTAB-680
  - Annotation_file: Relative path to the annotation file.
  - Annotation_file_skip_lines: How many lines of the corresponding annotation file to skip
  - Path: Path to the CEL file
- Reference: Folder for storing reference data.
  - Sergeeva_Lab: Folder for storing reference data from the Sergeeva lab publication. Ivliev, A. E., 't Hoen, P. A., van Roon-Mom, W. M., Peters, D. J., & Sergeeva, M. G. (2012). Exploring the transcriptome of ciliated cells using in silico dissection of human tissues. PloS one, 7(4), e35618. doi:10.1371/journal.pone.0035618
   - journal.pone.0035618.s010.XLS: Supplementary table 10 of the above publication. It contains a list of cilia-associated genes.


# Running the analysis


Start the Docker image used for this analysis (see the upper level README to see how). After navigating to the *Microarray_Analysis* folder and setting it is as the working directory, click "knit".


# Outputs


The step-by-step description of the analysis is contained in *Microarray_Analysis.html*. All tables and figures included in *Microarray_Analysis.html*, plus many additional ones, are stored in the *Results* folder.


# Methods


Probe intensities measured by GeneChip® Human Gene 2.0 ST arrays for samples in the internal data set were background corrected and quantile normalized using the Robust Multi-array Average (RMA) method implemented in the R package oligo (version 1.46.0) using default parameters (Rafael et al., 2003; Carvalho & Irizarry, 2010; Bolstad et al., 2003). The publicly available microarray data associated with Duncan et al.  (2011) (accession E-MTAB-680), referred to here as the external data set, was downloaded from ArrayExpress (Kolesnikov et al, 2015). Due to differences between chips, the affy package (version 1.60.0) was used to perform RMA normalization on the external data set (Gautier et al., 2004). The annotations for these two microarrays were derived from several sources: the hugene20sttranscriptcluster.db package (version 8.7.0), an annotation file downloaded from ThermoFisher Scientific (Waltham, MA, USA) (HuGene-2_0-st-v1 Probeset Annotations, CSV Format, Release 36), and an annotation file downloaded from ArrayExpress (accession A-AFFY-44 version 1.0) (MacDonald, 2017).


DEA was performed on the internal microarray data by linear modeling using limma (version 3.38.3) with default parameters (Ritchie et al., 2015). Genes were classified as differentially expressed if both 1) their associated Benjamini-Hochberg adjusted p value (false discovery rate, FDR) was less than 0.1 and 2) their associated log2 fold-change was greater than 0.5. The variation in mRNA expression levels of GUSB, PGK1, and RPL19 were evaluated in microarray data to determine whether they would make appropriate loading controls for qPCR and nCounter analyses. The internal data were normalized for this analysis by dividing the expression levels of each gene by the average expression level for the AIUP samples. Since the external data was derived from a different microarray platform, it was normalized separately from the internal data.


Gene ontology analysis was performed using clusterProfiler (version 3.10.1) (Yu et al., 2012). In this analysis, the Benjamini-Hochberg adjusted p value cutoff was 0.05, the minimum gene set size was 5, and the database used was org.Hs.eg.db (version 3.7.0) (Carlson, 2019).


Principal components analysis (PCA) was performed on the internal data using the FactoMineR package (version 1.41) (Le & Husson, 2008). Principal component and scree plots were generated during quality control analyses to determine whether there were any outlier samples and to evaluate the variance captured by the principal components analysis. Unsupervised hierarchical clustering using complete linkage was performed using the stats package (version 3.5.3) (Team RC, 2013).


# References


Bolstad BM, Irizarry RA, Astrand M, Speed TP. A comparison of normalization methods for high density oligonucleotide array data based on variance and bias. Bioinformatics. 2003;19(2):185-93.


Carlson M. Genome wide annotation for Human. orgHsegdb. 2019:R package version 3.8.3.


Carvalho BS, Irizarry RA. A framework for oligonucleotide microarray preprocessing. Bioinformatics. 2010;26(19):2363-7.


Duncan WC, Shaw JL, Burgess S, McDonald SE, Critchley HO, Horne AW. Ectopic pregnancy as a model to identify endometrial genes and signaling pathways important in decidualization and regulated by local trophoblast. PLoS One. 2011;6(8):e23595.


Gautier L, Cope L, Bolstad BM, Irizarry RA. affy--analysis of Affymetrix GeneChip data at the probe level. Bioinformatics. 2004;20(3):307-15.


Kolesnikov N, Hastings E, Keays M, Melnichuk O, Tang YA, Williams E, et al. ArrayExpress update--simplifying data submissions. Nucleic Acids Res. 2015;43(Database issue):D1113-6.


Le SJ, Julie; Husson, Francois. FactoMineR: An R Package for Multivariate Analysis. Journal of Statistical Software. 2008;25.


MacDonald JW. Affymetrix hugene20 annotation data (chip hugene20sttranscriptcluster). hugene20sttranscriptclusterdb. 2017:R package version 8.7.0.


Rafael A. Irizarry BH, Francois Collin, Yasmin D. Beazer-Barclay, Kristen J. Antonellis, Uwe Scherf, Terence P. Speed. Exploration, normalization and summaries of high denisty oligonucleotide array probe level data. Biostatistics. 2003;4(2):249-64.


Ritchie ME, Phipson B, Wu D, Hu Y, Law CW, Shi W, et al. limma powers differential expression analyses for RNA-sequencing and microarray studies. Nucleic Acids Res. 2015;43(7):e47.


Team RC. A language and environment for statistical computing. Foundation for Statistical Computing, Vienna, Austria. 2013.


Yu G, Wang LG, Han Y, He QY. clusterProfiler: an R package for comparing biological themes among gene clusters. OMICS. 2012;16(5):284-7.
