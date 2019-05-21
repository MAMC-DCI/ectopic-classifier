# Functions for plotting the accuracies generated from evaluation of a model on
# bootstrapped samples.



#' Plot the accuracies of evaluation of a model on bootstrapped samples.
#'
#' @description This function takes as input data set and model names, as well
#' as the reference data set name for drawing a vertical line to indicate the
#' accuracy of the naive model.
#'
#' @param model The name of the model as it is saved in the Cache folder.
#' @param data_set The name of the data set of interest.
#' @param display_reference Logical indicating whether a vertical line should
#' be drawn to indicate the accuracy of the naive model for the reference data
#' set.
#' @param reference The name of the reference data set which is used to
#' determine the accuracy of the naive model.
#' @param base_prefix The root of the cache prefix.
plot_bootstrap_accuracies <- function(
  model,
  data_set,
  display_reference = TRUE,
  reference = "MAMC_DCI__Train",
  base_prefix = "norm_"
){
  # Define the input file paths.
  acc_target_in_rds <- file.path(
    "Cache",
    paste0("Prediction_Summary_",model,data_set,".rds")
  )
  acc_reference_in_rds <- file.path(
    "Cache",
    paste0("Prediction_Summary_",model,reference,".rds")
  )
  ref_in_rds <- file.path("Cache",paste0("Predictions_",model,reference,".rds"))

  # Define the output file paths.
  outfile_rds <- file.path("Cache",paste0("Accuracies_",model,data_set,".rds"))
  outfile_csv <- file.path("Cache",paste0("Accuracies_",model,data_set,".csv"))
  outfile_tiff <- file.path(
    "Results",
    paste0("Accuracies_",model,data_set,".tiff")
  )

  # Load the modeling data and the model itself.
  acc_target <- readRDS(acc_target_in_rds)
  acc_ref <- readRDS(acc_reference_in_rds)
  ref_predictions <- readRDS(ref_in_rds)

  # Determine sample size.
  df_file <- file.path(
    "Cache", paste0(base_prefix, data_set, ".rds")
  )
  N <- nrow(readRDS(df_file))

  #############################################################################
  # Determine naive model accuracy on the reference data set.
  naive_accuracy <- max(
    c(
      mean(ref_predictions$Location == 0),
      mean(ref_predictions$Location == 1)
    )
  )

  # Determine the p value for the test that the model is better than the naive
  # model.
  p_val <- mean(acc_target$Accuracy < naive_accuracy)

  # Convert values to percent.
  naive_accuracy <- naive_accuracy*100
  acc_target$Accuracy <- acc_target$Accuracy * 100
  acc_ref$Accuracy <- acc_ref$Accuracy * 100

  # Generate the figure.
  plt <- ggplot(
    acc_target,
    aes(Accuracy)
  )+
    geom_histogram(binwidth = 10, aes(y = ..density..))+
    ylab("Probability Density")+xlab("Accuracy (%)")+
    coord_cartesian(xlim = c(0,110))+
    annotate("segment", x=-Inf, xend=Inf, y=-Inf, yend=-Inf)+
    annotate("segment", x=-Inf, xend=-Inf, y=-Inf, yend=Inf)+
    annotate("segment", x=Inf, xend=-Inf, y=Inf, yend=Inf)+
    annotate("segment", x=Inf, xend=Inf, y=Inf, yend=-Inf)+
    scale_y_continuous(
      limits = c(0,NA),
      expand = expand_scale(
        mult = c(0,0.15),
        add = c(0,0)
      )
    )+
    scale_x_continuous(
      breaks = seq(0,100,20),
      expand = expand_scale(
        mult = c(0,0),
        add = c(0,0)
      )
    )+
    coord_cartesian(xlim = c(0,100))+
    theme(
      plot.margin = margin(t=0.5,b=0.5,l=0.5,r=0.5, unit = "cm"),
      plot.title = element_text(
        size = 14,
        face = "plain"
      )
    )
  # If display_reference is TRUE then add a vertical reference line.
  if(display_reference){
    plt <- plt + geom_vline(
      xintercept = naive_accuracy,
      colour = "red", size = 1.5
    )
  }


  # Create the output object.
  output <- tibble::data_frame(
    model = model,
    target = data_set,
    reference = reference,
    naive_ref_accuracy = naive_accuracy,
    p_val = p_val,
    N = N,
    Mean_Accuracy = mean(acc_target$Accuracy),
    Median_Accuracy = median(acc_target$Accuracy)
  ) %>%
    as.matrix() %>%
    t() %>%
    as.data.frame() %>%
    tibble::rownames_to_column(., "Variable")
  colnames(output) <- c("Variable","Value")

  # Generate the full_output object.
  full_output <- tibble::lst(
    output = output,
    figure = plt
  )

  #############################################################################
  # Save the predictions.
  saveRDS(output, outfile_rds)
  readr::write_csv(
    output,
    outfile_csv
  )

  # Save the figure.
  # cowplot::save_plot(
  #   outfile_tiff,
  #   plt,
  #   base_width = 4, base_height = 4
  # )

  # Return the output.
  return(full_output)
}
