# Functions for applying quantile normalization.



#' Perform quantile normalization.
#'
#' @description This function takes as input an array data object (i.e.,
#' ExpressionSet or GeneFeatureSet) and the data_set name.
#'
#' @param reference The name of the data set to normalize to.
#' @param target The name of the data set to be normalized.
#' @param cache_prefix The prefix for the files output to the Cache folder.
quant_norm <- function(reference, target, cache_prefix = "Array_filt_"){
  # Retrieve parameters.
  source("Parameters.R")
  reference_file <- file.path("Cache", paste0(cache_prefix, reference, ".rds"))
  target_file <- file.path("Cache", paste0(cache_prefix, target, ".rds"))

  # Define the outfile.
  outfile_rds <- file.path(
    "Cache",
    paste0(cache_prefix,"norm_", target, ".rds")
  )
  outfile_csv <- file.path(
    "Cache",
    paste0(cache_prefix,"norm_", target, ".csv")
  )

  # Load data.
  reference_df <- readRDS(reference_file)
  target_df <- readRDS(target_file)

  # Create the reference vector.
  reference_vector <- reference_df[,colnames(reference_df) != "Sample"] %>%
    as.matrix() %>%
    as.vector() %>%
    sort()

  # Identify columns of interest
  data_cols <- colnames(target_df)[colnames(target_df) != "Sample"]

  # Extract data to normalize.
  norm_data <- target_df[,data_cols] %>%
    as.matrix()

  # Store dimnames.
  norm_data_dimnames <- dimnames(norm_data)

  # Perform quantile normalization.
  norm_data <- preprocessCore::normalize.quantiles.use.target(
    x = t(norm_data),
    target = reference_vector
  ) %>%
    t()

  # Insert the dimnames again.
  dimnames(norm_data) <- norm_data_dimnames

  # Convert norm_data to a tibble.
  norm_data <- as.data.frame(norm_data) %>%
    tibble::as_tibble()

  # Add back the sample names.
  norm_data$Sample <- target_df$Sample

  #############################################################################
  # Save the background-corrected and now filtered array data as an object
  # and as an expression table.
  saveRDS(norm_data, file = outfile_rds)

  # Save the expression table.
  readr::write_csv(
    norm_data,
    outfile_csv
  )

  # Return the norm_data object.
  return(norm_data)
}






#' Perform quantile normalization on the KNN data.
#'
#' @description This function takes as input an ExpressionSet object, the
#' data_set name, and a probeset annotation file.
#'
#' @param reference The name of the data set to normalize to.
#' @param target The name of the data set to be normalized.
#' @param probe_file The contents of the probeset annotation file.
#' @param ref_cache_prefix The cache_prefix for the reference data.
#' @param tar_cache_prefix The cache_prefix for the target data.
knn_quant_norm <- function(
  reference, target,
  probe_file,
  ref_cache_prefix = "knn_all_",
  tar_cache_prefix = "Array_bg_"
){
  # Retrieve parameters.
  source("Parameters.R")
  reference_file <- file.path(
    "Cache", paste0(ref_cache_prefix, reference, ".rds")
  )
  target_file <- file.path(
    "Cache", paste0(tar_cache_prefix, target, ".rds")
  )

  # Define the outfile.
  outfile_rds <- file.path(
    "Cache",
    paste0("knn_norm_", target, ".rds")
  )
  outfile_csv <- file.path(
    "Cache",
    paste0("knn_norm_", target, ".csv")
  )

  # Load data.
  reference_df <- readRDS(reference_file)
  target_df <- readRDS(target_file)

  # Reduce the target to probesets.
  target_df <- oligo::rma(target_df, background = FALSE, normalize = FALSE)

  # Remove invalid probes.
  target_df[
    !(Biobase::featureNames(target_df) %in%
        as.character(probe_file$probeset_id)) &
      (Biobase::featureNames(target_df) %in%
         Biobase::featureNames(reference_df))
    ,
  ]

  # Extract expression data.
  reference_df_samples <- Biobase::pData(reference_df)$Sample
  reference_df <- oligo::exprs(reference_df) %>%
    t() %>%
    as.data.frame()
  reference_df$Sample <- reference_df_samples

  target_df_samples <- Biobase::pData(target_df)$Sample
  target_df <- oligo::exprs(target_df) %>%
    t() %>%
    as.data.frame()
  target_df$Sample <- target_df_samples

  # Create the reference vector.
  reference_vector <- reference_df[,colnames(reference_df) != "Sample"] %>%
    as.matrix() %>%
    as.vector() %>%
    sort()

  # Identify columns of interest
  data_cols <- colnames(target_df)[colnames(target_df) != "Sample"]

  # Extract data to normalize.
  norm_data <- target_df[,data_cols] %>%
    as.matrix()

  # Store dimnames.
  norm_data_dimnames <- dimnames(norm_data)

  # Perform quantile normalization.
  norm_data <- preprocessCore::normalize.quantiles.use.target(
    x = t(norm_data),
    target = reference_vector
  ) %>%
    t()

  # Insert the dimnames again.
  dimnames(norm_data) <- norm_data_dimnames

  # Convert norm_data to a tibble.
  norm_data <- as.data.frame(norm_data) %>%
    tibble::as_tibble()

  # Add back the sample names.
  norm_data$Sample <- target_df$Sample

  #############################################################################
  # Save the background-corrected and now filtered array data as an object
  # and as an expression table.
  saveRDS(norm_data, file = outfile_rds)

  # Save the expression table.
  readr::write_csv(
    norm_data,
    outfile_csv
  )

  # Return the norm_data object.
  return(norm_data)
}
