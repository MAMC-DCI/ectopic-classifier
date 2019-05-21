(function(){
  # Load parameters.
  source(file.path("Parameters.R"))

  # Load packages.
  library(magrittr)
  library(oligo)
  library(limma)
  library(hugene20sttranscriptcluster.db)
  library(affycoretools)
  library(caret)
  library(cowplot)
  library(plotly)

  # Read the metadata.
  meta_cache_file <- file.path("Cache","metadata_de_for_knn.csv")
  meta_cache <- readxl::read_excel(param$meta_dir$MAMC_DCI__Train) %>%
    as.data.frame()
  rownames(meta_cache) <- meta_cache$Sample
  pd.PUL <- AnnotatedDataFrame(
    meta_cache
  )

  cels.PUL <- file.path(
    param$cel_dir$MAMC_DCI__Train,
    paste0(Biobase::pData(pd.PUL)$Sample, ".CEL")
  )
  data.PUL <- oligo::read.celfiles( cels.PUL, phenoData = pd.PUL )

  # Perform RMA normalization.
  eset.PUL <- rma(data.PUL, target = "core")

  #Remove control probes
  eset.PUL <- getMainProbes(eset.PUL)

  # Load probe annotations.
  # GeneChip Array Annotation files for our study (HuGene-2_0-st-v1 Probeset
  # Annotations, CSV Format, Release 36) were downloaded from ThermoFisher
  # Scientific on August 30, 2018.
  probeFile <- read.csv(
    file.path(
      "Data", "Arrays", "MAMC_DCI", "Probeset_annotations",
      "HuGene-2_0-st-v1.na36.hg19.probeset.csv",
      "HuGene-2_0-st-v1.na36.hg19.probeset.csv"
    ),
    header = TRUE,
    comment.char = "#"
  )
  probeList <- as.character(probeFile$probeset_id)

  # Remove probes that were not condensed into probesets.
  eset.PUL <- eset.PUL[!(featureNames(eset.PUL) %in% probeList),]

  # Save the normalized data.
  saveRDS(eset.PUL, file = file.path("Cache","knn_all_MAMC_DCI__Train.rds"))

  # Extract expression levels.
  RMA.PUL <- exprs(eset.PUL)

  # Create the experimental design object.
  location.PUL <- factor(pData(pd.PUL)[,"Group"], levels = c("AIUP", "EP"))
  design.PUL <- model.matrix(~location.PUL)
  colnames(design.PUL) <- c("(Intercept)", "EP")
  attr(design.PUL, "contrasts") <- "location"

  # Perform differential expression analysis.
  fit.PUL <- lmFit(eset.PUL, design.PUL)
  efit.PUL <- eBayes(fit.PUL)

  # Retrieve feature annotations.
  gns.PUL <- AnnotationDbi::select(
    hugene20sttranscriptcluster.db,
    featureNames(eset.PUL),
    c("ENSEMBL", "ENSEMBLTRANS", "ENSEMBLPROT", "SYMBOL", "GENENAME")
  )
  gns.PUL <- gns.PUL[!duplicated(gns.PUL[,1]),] # Remove duplicate annotations.
  efit.PUL$genes <- gns.PUL # Insert the annotations into the DE results object.

  # Export all differentially expressed gene data.
  top.PUL <- topTable(
    efit.PUL,
    coef = "EP",
    number = Inf,
    p.value = Inf,
    lfc = 0
  ) %>%
    dplyr::filter(
      !is.na(SYMBOL)
    )
  writexl::write_xlsx(
    top.PUL,
    file.path("Results", "All_DEA.xlsx")
  )

  # Subset the top differentially expressed gene data.
  top.PUL <- topTable(
    efit.PUL,
    coef = "EP",
    number = 1000,
    p.value = 0.1,
    lfc = 0.5
  ) %>%
    dplyr::filter(
      !is.na(SYMBOL)
    )
  writexl::write_xlsx(
    top.PUL,
    file.path("Results", "TOP_DEA.xlsx")
  )

  # Write the results to a file.
  de_for_knn_top_genes_file <- file.path(
    "Cache", "de_for_knn_top_genes.txt"
  )
  subtop <- top.PUL[!duplicated(top.PUL$ENSEMBL),]
  subtop <- subtop[ ,-c(3,4)]
  rownames(subtop) <- NULL
  dim(subtop)
  write.table(subtop, de_for_knn_top_genes_file)

  # Read in the above data.
  PUL.DEG <- read.table(de_for_knn_top_genes_file)

  # Retrieve gene symbols related to cilia from the Sergeeva lab list.
  sergeeva_list_file <- file.path(
    "Data","Reference","Sergeeva_Lab","journal.pone.0035618.s010.XLS"
  )
  DEG.genes <- PUL.DEG$SYMBOL
  known.set <- (readxl::read_excel(sergeeva_list_file) %>%
                  tidyr::drop_na())$Symbol

  # Identify genes found in both data sets.
  known.DEG <- intersect(DEG.genes, known.set)
  num.known <- length(known.DEG)

  # Add missed genes.
  known.DEG <- c(known.DEG, "CFAP47", "CFAP126")
  feature.probes <- PUL.DEG[(DEG.genes %in% known.DEG),1]
  feature.set <- RMA.PUL[as.character(feature.probes),]

  # Save the genes of interest.
  saveRDS(known.DEG, file = file.path("Cache","knn_genes_of_interest.rds"))
})()
