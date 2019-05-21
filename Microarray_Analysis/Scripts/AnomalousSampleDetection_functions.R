# Functions for detecting anomalous samples.



#' Detect anomalous samples.
#'
#' @description This function takes as input a tibble of expression values and
#'   returns a plotly object.
#'
#' @param cache_prefix The prefix of the data file type desired in the Cache
#'   folder.
#' @param data_set The name of the data set referenced.
#' @param ref Whether the indicated data set is the reference data set
#'   (Discovery).
do_pca <- function(cache_prefix, data_set, ref = FALSE){
  # Retrieve parameters.
  source("Parameters.R")

  # Load the data.
  dat <- readRDS(file.path("Cache", paste0(cache_prefix, data_set, ".rds")))

  # If "Location" is one of the column names then remove it.
  if("Location" %in% colnames(dat)){
    dat <- dat[,colnames(dat) != "Location"]
  }

  # Define the output file.
  outfile_rds <- file.path(
    "Cache", paste0(cache_prefix, "pca_coords_", data_set, ".rds")
  )

  #######################
  # Determine PCA coordinates.
  #######################
  expr_mat <- dat[, colnames(dat) != "Sample"]
  if(ref){
    # Perform PCA.
    pca <- FactoMineR::PCA(expr_mat, ncp = 2, graph = FALSE)

    # Save the PCA results.
    saveRDS(pca, file.path("Cache", paste0(cache_prefix, "pca_ref.rds")))

    # Extract the PCA coordinates.
    out <- as.data.frame(pca$ind$coord) %>%
      dplyr::mutate(., Sample = dat$Sample, data_set = data_set)
  }else{
    # Read in the reference PCA object.
    pca <- readRDS(file.path("Cache", paste0(cache_prefix, "pca_ref.rds")))

    # Reorder the columns in expr_mat.
    expr_mat <- expr_mat[, rownames(pca$var$coord)]

    # Map the current data to the PCA space.
    out <- FactoMineR::predict.PCA(pca, expr_mat)$coord %>%
      as.data.frame() %>%
      dplyr::mutate(., Sample = dat$Sample, data_set = data_set)
  }

  # Insert the Location information.
  return(out)
  out$Location <- dplyr::filter(
    Biobase::pData(load_metadata(data_set)) %>%
      tibble::rownames_to_column(., "Sample"),
    (Sample %in% out$Sample) | (Sample %in% gsub(".CEL","",out$Sample))
  )$Group

  #############################################################################
  # Save the out object.
  saveRDS(
    out,
    outfile_rds
  )

  # Return the image.
  return(out)
}

