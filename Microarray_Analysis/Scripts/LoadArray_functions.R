# Functions for loading array data.



#' Load and background correct array data.
#'
#' @description This function takes as input a data set name, reads the
#' corresponding CEL files, and performs background correction. It does NOT
#' normalize the data.
#'
#' @param data_set The name of the data set referenced.
load_arrays <- function(data_set){
  # Load the metadata.
  source(file.path("Scripts", "ReadMetadata_functions.R"))
  metadata <- load_metadata(data_set)

  # Define the input directory.
  source("Parameters.R")
  indir <- param$cel_dir[[data_set]]

  # Define the output file names.
  outfile_rds <- file.path("Cache", paste0("Array_bg_", data_set, ".rds"))
  outfile_csv <- file.path("Cache", paste0("Array_bg_", data_set, ".csv"))

  # Retrieve the CEL file names.
  samples <- rownames(metadata)

  # Create the sample suffixes.
  sample_suffixes <- paste0(samples, ".CEL")

  # Generate the path to the files.
  filenames <- file.path(indir, sample_suffixes)

  # Determine the array type used.
  source("Parameters.R")
  array_type <- param$array_type[[data_set]]

  #######################
  # Load the array data.
  #######################

  # HuGene-2_0 (MAMC_DCI studies).
  if(array_type == "HuGene-2_0"){
    # Read the array files.
    invisible(
      {
        raw_data <- oligo::read.celfiles(
          filenames = filenames,
          phenoData = metadata,
          verbose = FALSE
        )
      }
    )
  }


  # HG-U133_Plus_2 (Horne lab study).
  if(array_type == "HG-U133_Plus_2"){
    # Read array data. Note that this is a different array type than used in
    # the MAMC_DCI studies so the methods necessarily differ slightly. This
    # should be taken into account during interpretation of the results.
    invisible(
      {
        raw_data <- affy::justRMA(
          filenames = filenames,
          phenoData = metadata,
          verbose = FALSE,
          background = TRUE,
          normalize = FALSE
        )
      }
    )
  }

  #############################################################################
  # Save the non-normalized, but background-corrected array data as an object
  # and as an expression table.
  saveRDS(raw_data, file = outfile_rds)

  # Save the expression table.
  readr::write_csv(
    oligo::exprs(raw_data) %>% as.data.frame(),
    outfile_csv
  )

  # Return the raw_data object.
  return(raw_data)
}
