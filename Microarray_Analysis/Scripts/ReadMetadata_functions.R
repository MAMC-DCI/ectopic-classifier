# Function for processing and loading the metadata associated with different
# data sets.



#' Process and save metadata.
#'
#' @description This function takes as input a data set name, processes the
#' corresponding metadata file, and saves it to the Cache folder. The
#' processed file can then be loaded using the load_metadata functions. For
#' each file there should be both 'Sample' and 'Group' columns.
#'
#' @param data_set The name of the metadata referenced.
#' @param min_rin The minimum RIN score permitted.
process_metadata <- function(data_set, min_rin){
  # Define the output file names.
  outfile_rds <- file.path("Cache", paste0("Metadata_", data_set, ".rds"))
  outfile_bb_rds <- file.path(
    "Cache", paste0("Metadata_", data_set, "_bb", ".rds")
  )

  # Retrieve the input file name.
  source("Parameters.R")
  file_path <- param$meta_dir[[data_set]]

  # Our training study.
  if(
    data_set %in% c(
      "MAMC_DCI__Train", "MAMC_DCI__Train_PUL", "MAMC_DCI__Train_Pilot"
    )
  ){
    # Read the metadata file.
    metadata <- readxl::read_excel(file_path) %>%
      dplyr::select(
        .,
        Sample, Group
      ) %>% # Order the samples numerically.
      dplyr::mutate(., Temp = gsub("MP", "", Sample) %>% as.numeric()) %>%
      dplyr::arrange(., Temp) %>%
      dplyr::select(., -Temp)
  }

  # Our testing study.
  if(
    data_set %in% c(
      "MAMC_DCI__Test", "MAMC_DCI__Test_EctopicT", "MAMC_DCI__Test_RepOfTrain"
    )
  ){
    # Read the metadata file.
    metadata <- readxl::read_excel(file_path)
    if(data_set == "MAMC_DCI__Test"){
      metadata <- dplyr::select(
        metadata,
        Sample, Group, RIN, PUL
      )
    }else{
      metadata <- dplyr::select(
        metadata,
        Sample, Group, RIN
      )
    }
    # Order the samples numerically.
    metadata <-  dplyr::mutate(
      metadata,
      Temp = gsub("PUL", "", Sample) %>% as.numeric()
    ) %>%
      dplyr::arrange(., Temp) %>%
      dplyr::select(., -Temp)
  }

  # Horne lab study.
  if(data_set == "Horne_Lab"){
    # Read the metadata file.
    metadata <- readr::read_tsv(file_path)  %>%
      dplyr::select(
        .,
        Sample, Group
      )
    metadata$Group[metadata$Group == "IUP"] <- "AIUP"
  }

  #############################################################################
  # Reorder the samples to ensure they match the order of CEL files when those
  # are read.
  metadata <- metadata[order(as.character(metadata$Sample)),]

  # Filter on RIN score if present.
  if("RIN" %in% colnames(metadata)){
    metadata <- dplyr::filter(
      metadata,
      RIN >= min_rin
    )
  }

  #############################################################################
  # Save the plain metadata.
  saveRDS(metadata, file = outfile_rds)

  # Load the data as a phenoData object.
  metadata <- Biobase::AnnotatedDataFrame(
    tibble::column_to_rownames(as.data.frame(metadata), "Sample")
  )

  # Save the metadata as an AnnotatedDataFrame.
  saveRDS(metadata, file = outfile_bb_rds)
}


#' Load processed metadata
#'
#' @description This function takes as input a data set name and returns the
#' corresponding processed metadata.
#'
#' @param data_set The name of the metadata referenced. This should be one of
#' MAMC_DCI__Train, MAMC_DCI_Test, MAMC_DCI__PUL, or Horne.
load_metadata <- function(data_set){
  # Define the name of the file to read from Cache.
  infile <- file.path("Cache", paste0("Metadata_", data_set, "_bb.rds"))

  # Read the metadata file.
  metadata <- readRDS(infile)

  # Return the metadata.
  return(metadata)
}
