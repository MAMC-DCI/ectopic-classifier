# Functions for filtering out invalid probes.



#' Remove invalid probes for different arrays.
#'
#' @description This function takes as input an array data object (i.e.,
#'   ExpressionSet or GeneFeatureSet) and the data_set name.
#'
#' @param x The array data object (i.e., ExpressionSet or GeneFeatureSet).
#' @param data_set The name of the data set referenced.
#' @param normalize Whether the data should be RMA normalized. This is argument
#'   is only applicable to the HuGene-2_0 arrays.
filter_arrays <- function(x, data_set, normalize = FALSE){
  # Retrieve parameters.
  source("Parameters.R")
  array_type <- param$array_type[[data_set]]
  probe_map_file <- param$probe_map[[array_type]]

  # Retrieve the probe_map.
  probe_map <- readRDS(probe_map_file)

  # Define the output file names.
  outfile_rds <- file.path("Cache", paste0("Array_filt_", data_set, ".rds"))
  outfile_csv <- file.path("Cache", paste0("Array_filt_", data_set, ".csv"))

  #######################
  # Filter the probes.
  #######################

  # Identify valid probes.
  valid_ensembl <- readRDS(param$valid_ensembl)
  valid_probes <- probe_map$PROBEID[probe_map$ENSEMBL %in% valid_ensembl]

  if(array_type == "HuGene-2_0"){
    # Reduce to probesets.
    x <- oligo::rma(
      x,
      background = FALSE,
      normalize = normalize,
      target = "core"
    )
    x <- affycoretools::getMainProbes(x)

    # Create a PROBEID to ENSEMBL map.
    probe_to_ensembl <- tidyr::drop_na(probe_map[,c("PROBEID","ENSEMBL")]) %>%
      tibble::deframe()

    # Subset the array data to retain only valid probes.
    x <- x[
      (Biobase::featureNames(x) %in% as.character(valid_probes)) &
        (!is.na(Biobase::featureNames(x)))
      ,
      ]

    # Retrieve the ENSEMBL IDs.
    ensembl_ids <- probe_to_ensembl[Biobase::featureNames(x)]

    # Generate the expression tibble.
    x <- as.data.frame(oligo::exprs(x)) %>% # Extract expression
      split(., f = ensembl_ids) %>% # Split by ENSEMBL
      parallel::parLapply(
        parallel::makeCluster(parallel::detectCores()),
        .,
        function(gene_data){ # Return the mean value for each sample.
          out <- apply(gene_data, 2, function(x){prod(x)^(1/length(x))})
          t(as.matrix(out))
        }
      ) %>%
      do.call(rbind, .) %>% # Stack the results.
      t() %>%
      as.data.frame()

    # Insert column names.
    colnames(x) <- levels(factor(ensembl_ids))

    # Subset valid columns.
    x <- x[, valid_ensembl]

    # Add the sample names.
    x <- tibble::rownames_to_column(x, "Sample") %>% # Insert the sample IDs.
      tibble::as_tibble()
  }else if(array_type == "HG-U133_Plus_2"){
    # Create a PROBEID to ENSEMBL map.
    probe_to_ensembl <- tidyr::drop_na(probe_map[,c("PROBEID","ENSEMBL")]) %>%
      tibble::deframe()

    # Subset the array data to retain only valid probes.
    x <- x[
      (Biobase::featureNames(x) %in% as.character(valid_probes)) &
        (!is.na(Biobase::featureNames(x)))
      ,
      ]

    # Retrieve the ENSEMBL IDs.
    ensembl_ids <- probe_to_ensembl[Biobase::featureNames(x)]

    # Generate the expression tibble.
    # Retain the median probe expression level for each probeset
    x <- as.data.frame(oligo::exprs(x)) %>% # Extract expression
      split(., f = ensembl_ids) %>% # Split by ENSEMBL
      parallel::parLapply(
        parallel::makeCluster(parallel::detectCores()),
        .,
        function(gene_data){ # Return the mean value for each sample.
          out <- apply(gene_data, 2, function(x){prod(x)^(1/length(x))})
          t(as.matrix(out))
        }
      ) %>%
      do.call(rbind, .) %>% # Stack the results.
      t() %>%
      as.data.frame()

    # Insert column names.
    colnames(x) <- levels(factor(ensembl_ids))

    # Subset valid columns.
    x <- x[, valid_ensembl]

    x <- tibble::rownames_to_column(x, "Sample") %>% # Insert the sample IDs.
      tibble::as_tibble()
  }

  #############################################################################
  # Save the background-corrected and now filtered array data as an object
  # and as an expression table.
  saveRDS(x, file = outfile_rds)

  # Save the expression table.
  readr::write_csv(
    x,
    outfile_csv
  )

  # Return the raw_data object.
  return(x)
}
