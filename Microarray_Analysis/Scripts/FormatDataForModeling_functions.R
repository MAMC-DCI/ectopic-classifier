# Functions for formatting data for modeling.



#' Format data for modeling.
#'
#' @description This function takes as input a cache_prefix, the name of the
#' data set of interest, and a vector of the genes of interest.
#'
#' @param cache_prefix The prefix of the cache file to load.
#' @param data_set The name of the data set of interest.
#' @param genes A character vector of the genes of interest.
#' @param reference The reference level. It will be assigned a value of 0. The
#' other level will be assigned a value of 1.
#' @param addendum Any additional text to insert before the file extension.
format_data_for_model <- function(
  cache_prefix = "Array_filt_norm_",
  data_set,
  genes,
  reference = "AIUP",
  addendum = ""
){
  # Retrieve parameters.
  source("Parameters.R")

  # Load the expression matrix.
  data_file <- file.path("Cache", paste0(cache_prefix, data_set, ".rds"))
  df <- readRDS(data_file)

  # Load the metadata.
  source(file.path("Scripts", "ReadMetadata_functions.R"))
  metadata <- load_metadata(data_set)

  # Define the outfile.
  outfile_rds <- file.path(
    "Cache", paste0(
      "Model_values_", cache_prefix, data_set, paste0("_", addendum, ".rds")
    )
  )
  outfile_csv <- file.path(
    "Cache", paste0(
      "Model_values_", cache_prefix, data_set, paste0("_", addendum, ".csv")
    )
  )

  #############################################################################
  # Format the data for modeling.

  # Subset the genes of interest.
  df <- df[,genes]

  # Insert sample and group data.
  df$Location <- as.numeric(
    factor(
      Biobase::pData(metadata)$Group,
      levels = c("AIUP","EP")
    )
  ) - 1
  df$Sample <- rownames(Biobase::pData(metadata))

  #############################################################################
  # Save the formatted data as an rds file and as a csv file.
  saveRDS(df, file = outfile_rds)

  # Save the formatted tibble.
  readr::write_csv(
    df,
    outfile_csv
  )

  # Return the formatted tibble.
  return(df)
}
