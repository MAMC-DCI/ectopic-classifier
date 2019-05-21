# Functions for making predictions using a fitted model.



#' Make a single set of predictions on a data set given a model.
#'
#' @description This function takes as input data set and model names.
#'
#' @param model_name The name of the model as it is saved in the Cache folder.
#' @param data_set The name of the data set of interest.
#' @param cache_prefix The name of the cache prefix.
make_predictions <- function(
  cache_prefix,
  data_set,
  model_name = "KNN_"
){
  # Define the output file paths.
  outfile_rds <- file.path(
    "Cache",paste0("Predictions_",model_name,data_set,".rds")
  )
  outfile_csv <- file.path(
    "Cache",paste0("Predictions_",model_name,data_set,".csv")
  )

  # Define the input file path.
  df_file <- file.path(
    "Cache", paste0(cache_prefix, data_set, ".rds")
  )
  model_file <- file.path("Cache", paste0(model_name, ".rds"))

  # Load the modeling data and the model itself.
  df <- readRDS(df_file)
  model <- readRDS(model_file)

  #############################################################################
  if(model_name == "KNN_"){
    # Set modeling options.
    k <- 3

    # Make predictions
    predictions <- class::knn(
      train = model[,!(colnames(model) %in% c("Location","Sample"))],
      test = df[,!(colnames(model) %in% c("Location","Sample"))],
      cl = model$Location,
      k = k,
      prob = TRUE
    )

    prob <- attr(predictions, "prob")
    prob[as.character(predictions) != "1"] <- (1-prob)[
      as.character(predictions) != "1"
      ]

    # Create the output object.
    output <- dplyr::select(
      df,
      Sample, Location
    ) %>%
      dplyr::mutate(
        .,
        Prediction = predictions,
        Probability = prob
      )
  }

  #############################################################################
  # Save the predictions.
  saveRDS(output, outfile_rds)
  readr::write_csv(
    output,
    outfile_csv
  )

  # Return the output.
  return(output)
}






#' Generate an ROC curve and calculate AUC.
#'
#' @description This function takes as input the output of make_predictions.
#'
#' @param df The output of the make_predictions function.
make_roc <- function(
  df
){
  # Retrieve the sensitivity and specificity values.
  df_pred <- ROCR::prediction(
    as.numeric(as.character(df$Probability)),
    as.numeric(as.character(df$Location))
  )
  df_pred_dat <- ROCR::performance(
    df_pred, "tpr", "fpr"
  )
  df_pred_df <- tibble::data_frame(
    `False positive rate` = df_pred_dat@x.values %>% unlist(),
    `True positive rate` = df_pred_dat@y.values %>% unlist()
  )
  auc <- ROCR::performance(
    df_pred, "auc"
  )

  # Plot the curve.
  plt <- ggplot(
    df_pred_df,
    aes(`False positive rate`, `True positive rate`)
  )+
    geom_point()+
    geom_line()+
    coord_cartesian(xlim = c(0,1), ylim = c(0,1), expand = c(0,0))+
    geom_abline(slope = 1, intercept = 0, col = "black", linetype = "dashed")+
    coord_equal()+
    xlab("False Positive Rate")+ylab("True Positive Rate")

  # Create the output object.
  output <- tibble::lst(
    plt = plt,
    auc = round(auc@y.values %>% unlist(), 2)
  )

  # Return the output.
  return(output)
}





#' Make predictions on bootstrapped samples of a data set given a model.
#'
#' @description This function takes as input data set and model names. It also
#' takes the number of samples to be evaluated.
#'
#' @param model_name The name of the model as it is saved in the Cache folder.
#' @param data_set The name of the data set of interest.
#' @param num_samples The number of bootstrapped samples to evaluate.
#' @param cache_prefix The cache_prefix for the model.
make_bootstrap_predictions <- function(
  model_name,
  data_set,
  num_samples = 100,
  cache_prefix = "norm_"
){
  # Define the output file paths.
  outfile_rds <- file.path(
    "Cache",
    paste0("Prediction_Summary_",model_name,data_set,".rds")
  )
  outfile_csv <- file.path(
    "Cache",
    paste0("Prediction_Summary_",model_name,data_set,".csv")
  )

  # Define the input file path.
  df_file <- file.path(
    "Cache", paste0(cache_prefix, data_set, ".rds")
  )
  model_file <- file.path("Cache", paste0(model_name, ".rds"))

  # Load the modeling data and the model itself.
  df <- readRDS(df_file)
  model <- readRDS(model_file)

  #############################################################################
  # Resample the data set.
  num_observations <- nrow(df)
  df_sampled <- sample(
    1:num_observations,
    num_observations * num_samples,
    replace = TRUE
  )
  indices <- df_sampled
  df_sampled <- df[indices,]

  if(model_name == "KNN_"){
    # Set modeling options.
    k <- 3

    # Make predictions
    predictions <- class::knn(
      train = model[,!(colnames(model) %in% c("Location","Sample"))],
      test = df_sampled[,!(colnames(model) %in% c("Location","Sample"))],
      cl = model$Location,
      k = k
    )

    # Collapse the runs.
    predictions <- matrix(
      predictions == df$Location[indices],
      ncol = num_samples
    )
  }

  # Collapse the data vertically by taking the mean.
  accuracy <- colSums(predictions)/num_observations

  # Create the output object.
  output <- tibble::data_frame(
    Iteration = 1:num_samples,
    Accuracy = accuracy
  )

  #############################################################################
  # Save the predictions.
  saveRDS(output, outfile_rds)
  readr::write_csv(
    output,
    outfile_csv
  )

  # Return the output.
  return(output)
}
