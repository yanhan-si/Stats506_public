#' ---
#' title: "R Script for Stats 506, F20 HW 1"
#' author: "Yanhan Si"
#' date: "`r format.Date(Sys.Date(), '%b %d, %Y')`"
#' output: 
#'   html_document:
#'     code_folding: hide
#' ---

## R Script for Stats 506, F20 HW 1
##
## (Brief Description)
## This script contains code for HW1 Question#2
## 
## ##
## (Additional Details)
## 1. functions defined:
## - make_prediction
## - evaluation_metric
## - perf_roc
## - perf_pr
## Author(s): Yanhan Si
## Updated: September 28, 2020

# 79: -------------------------------------------------------------------------

# libraries: ------------------------------------------------------------------
library(tidyverse)

# directories: ----------------------------------------------------------------
path = './'

# data: -----------------------------------------------------------------------
file_path = sprintf('%s/isolet_results.csv', path)
raw = read_csv(file_path)

# 79: -------------------------------------------------------------------------

## Part a. b.
make_prediction <- function(tau, yhat) {
  # Calculate y label given tau and yhat
  # Input:
  #   tau: prediction threshold
  #   yhat: a vector
  # Output:
  #   y_pred: a vector
  y_pred = if_else(yhat >= tau, 1, 0)
  y_pred
}

evaluation_metric <- function(y_true, y_pred) {
  # Evaluate the preformance of the predictiton
  # Input:
  #   y_true: a binary vector
  #   y_pred: a binary vector
  # Output:
  #   Vector: true_positives, false_negatives, false_positives, 
  #                       true_negatives, sensitivity, specificity
  df = tibble::tibble(y_true = y_true, y_pred = y_pred)

  df_pos_label <-  filter(df, y_true==1)
  
  df_true_pos_pred <- df_pos_label %>% filter(y_pred==1)
  df_false_neg_pred <- df_pos_label %>% filter(y_pred==0)
  
  true_positives = nrow(df_true_pos_pred) / nrow(df_pos_label)
  false_negatives = nrow(df_false_neg_pred) / nrow(df_pos_label)
  
  df_neg_label <- df %>% filter(y_true==0)
  
  df_fasle_pos_pred <- df_neg_label %>% filter(y_pred==1)
  df_true_neg_pred <- df_neg_label %>% filter(y_pred==0)
  
  false_positives = nrow(df_fasle_pos_pred) / nrow(df_neg_label)
  true_negatives = nrow(df_true_neg_pred) / nrow(df_neg_label)
  
  sensitivity = nrow(df_true_pos_pred) / ( nrow(df_true_pos_pred) 
                                           + nrow(df_false_neg_pred) )
  specificity = nrow(df_true_neg_pred) / ( nrow(df_true_neg_pred) 
                                           + nrow(df_fasle_pos_pred) )
  
  precision = nrow(df_true_pos_pred) / ( nrow(df_true_pos_pred) 
                                         + nrow(df_fasle_pos_pred) )
  recall = sensitivity
  return(
    c(true_positives, false_negatives, false_positives, true_negatives,
      sensitivity, specificity, precision)
  )
}

perf_roc <- function(y, yhat, plot = c("none", "base", "ggplot2")) {
  # Plot the ROC and calculate the AUC-ROC
  # Inputs:
  #   y: a vector of true labels
  #   yhat: a vector of predicted labels
  #   plot: plot arguments
  # Outputs:
  #   lists:
  #     auc: area under the ROC curve
  #     df: dataframe containing yhat and evaluation metrics
  df = tibble::tibble(
    yhat = yhat,
    ytrue = y, 
    true_positives = 0,
    false_negatives = 0,
    false_positives = 0,
    true_negatives = 0,
    sensitivity = 0,
    specificity = 0
    )
  
  df = arrange(df, yhat) # sort in ascending order
  for (i in 1:nrow(df)) {
    tau = df[[i, "yhat"]]
    y_pred = make_prediction(tau, df$yhat)
    df[i, 3:8] = as.list(evaluation_metric(df$ytrue, y_pred)[-7])
  }
  df <- df %>% select(-ytrue)
  
  plot_option = match.arg(plot,c("none", "base", "ggplot2"), several.ok = TRUE)
  
  if ("base" %in% plot_option) {
    plot(df$false_positives, df$true_positives, type = "l",
         xlab = "False positives", 
         ylab = "True positives",
         main = "ROC")
  }
  if ("ggplot2" %in% plot_option) {
    fig <- df %>% ggplot(aes(false_positives, true_positives)) +
      geom_line() +
      xlab("False positives") +
      ylab("True positives") +
      theme_bw() +
      ggtitle("ROC")
    show(fig)
  }
  interval1 = diff(df$false_positives)
  interval1[length(interval1)+1] = 0
  df$interval1 = -interval1
  auc1 = sum(df$interval1 * df$true_positives)
  
  interval2 = c(0, interval1[-length(interval1)])
  df$interval2 = -interval2
  
  auc2 = sum(df$interval2 * df$true_positives)
  auc = (auc1 + auc2)/2
  
  list(auc = auc, df = df)
  }

perf_pr <- function(y, yhat, plot = c("none", "base", "ggplot2")) {
  # Plot the PC and calculate the AUC-PC
  # Inputs:
  #   y: a vector of true labels
  #   yhat: a vector of predicted labels
  #   plot: plot arguments
  # Outputs:
  #   lists:
  #     auc: area under the PC curve
  #     df: dataframe containing yhat and evaluation metrics
  df = tibble::tibble(
    yhat = yhat,
    ytrue = y, 
    true_positives = 0,
    false_negatives = 0,
    false_positives = 0,
    true_negatives = 0,
    recall = 0,
    precision = 0
  )
  
  df = arrange(df, yhat) # sort in ascending order
  for (i in 1:nrow(df)) {
    tau = df[[i, "yhat"]]
    y_pred = make_prediction(tau, df$yhat)
    df[i, 3:8] = as.list(evaluation_metric(df$ytrue, y_pred)[-6])
  }
  df <- df %>% select(-ytrue)
  
  plot_option = match.arg(plot,c("none", "base", "ggplot2"), several.ok = TRUE)
  if ("base" %in% plot_option) {
    plot(df$recall, df$precision, type = "l",
         xlab = "Recall", 
         ylab = "Rrecision",
         main = "PR")
  } 
  if ("ggplot2" %in% plot_option) {
    fig <- df %>% ggplot(aes(recall, precision)) +
      geom_line() +
      xlab("Recall") +
      ylab("Rrecision") +
      theme_bw() +
      ggtitle("PR")
    show(fig)
  }
  interval1 = diff(df$recall)
  interval1[length(interval1)+1] = 0
  df$interval1 = -interval1
  
  auc1 = sum(df$interval1*df$precision)
  
  interval2 = c(0, interval1[-length(interval1)])
  df$interval2 = -interval2
  
  auc2 = sum(df$interval2*df$precision)
  
  auc = (auc1 + auc2)/2
  list(auc = auc, df = df)
}


## Part c.

result_roc = perf_roc(raw$y, raw$yhat, c("base","ggplot2"))
result_pr = perf_pr(raw$y, raw$yhat, c("base","ggplot2"))

## The AUC-ROC is
result_roc$auc
## The AUC-PC is
result_pr$auc

