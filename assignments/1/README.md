# About Pset1

https://jbhender.github.io/Stats506/F20/PS1.html

## Questions
### Question 1 [45 points]

In this question you will use the Linux shell to prepare data from the National Health and Nutrition Examination Survey (NHANES) conducted by the National Center for Health Statistics every two years.

Specifically, we are going to prepare data from the Oral Health Dentition examinations and participant demographics. We will do additional analyses with the data files you create in one or more future problem sets. In your write up tell us how many observations and variables are present in each of the resulting data sets.

- a. [30 points] Write a shell script ps1_q1_ohxden.sh that: downloads the OHXDEN_?.XPT data files for all survey cohorts between 2011-2018 (4 cohorts),
converts these files to csv,
extracts the following columns: id (SEQN), dentition exam status (OHDDESTS), tooth counts (OHXxxTC), and coronal caries (OHXxxCTC),
appends all years into a single file nhanes_ohxden.csv.
- b. [15 points] Write a shell script ps1_q1_demo.sh that repeats the steps from part a for the demographic data and extracts the columns: id (SEQN), age (RIDAGEYR), race/ethnicity (RIDRETH3), education (DMDEDUC2), marital status (DMDMARTL), and variables related to the survey weights (RIDSTATR, SDMVPSU, SDMVSTRA, WTMEC2YR, WTINT2YR). Name the appended file nhanes_demo.csv.

To receive full credit, your solutions should:

- 1. be written in the bash shell,
- 2. use conditional execution to avoid repeating already completed steps,
- 3. verify that the extracted columns are all in the same order prior to appending [5 points, included above]
- 4. Uses looping to avoid unneeded repetition (DRY).

For the style component of the grade, ensure each of your solutions: i. has a complete header and “shebang” (!#), ii. follows style guidelines on line length (≤79 characters) and variable names.

***Hints:***
- Use R via the Rscript utility for converting the XPT format to csv.
- Use the cutnames.sh program from part 2 of the week 1 activity to extract variables. If you use my solution, provide attribution in your write up. If you use your (group’s) solution, include the file with your submission.
- For looping, see the ex_while_read.sh example in the Stats506_F20 repo.
- To check that columns of interest are ordered the same across all files, create a temporary file with only the extracted headers from each data file and adapt the pattern from the ex_check_dup_lines.sh in the Stats506_F20 repo.

### Question 2 [40 points]
In this question you will write functions in R to evaluate binary prediction models using the receiver operator characteristic (ROC) and precision recall curve (PR). You should write your own functions using default packages and/or tidyverse, rather than writing “wrappers” to existing functions for these specific tasks. Try to write vectorized code avoiding loops – a concept we will discuss further in the next few weeks.

- a. [15 points] Write a function perf_roc() taking two required arguments: y for the true binary labels and yhat for a continuous or ordinal predictor which, when combined with a threshold tau, predicts y via yhat >= tau. Also include an argument plot = c("none", "base", "ggplot2")indicating whether to produce a plot showing the ROC curve, and, if so, whether it should be produced with base R graphics or ggplot2. Your function should return a named list containing:

an 7-column data.frame (or tibble) with sorted, unique values of yhat, counts of true/false positives/negatives when tau == yhat for the value of yhat in that row, and the sensitivity and specificity associated with each threshold.

The area under the ROC curve, evaluated using the trapezoidal rule.

- b. [15 points] Write a function perf_pr() similar to perf_roc() but replacing specificity with precision and renaming sensitivity as recall. This function should also compute the area under the precision-recall curve.

- c. [10 points] Use your functions to evaluate the predictions in the file problem_sets/data/isolet_restults.csv in the Stats506_F20 repo. In your write up, report both the AUC-ROC and the AUC-PR and include both the base R and ggplot2 versions of your plots showing the curves.

***Hints:***
- To avoid repeating yourself, consider writing helper functions, e.g. to sort the predictions and count the true/false positives/negatives.
- Be sure to document each of your functions using a comment in the opening lines of the function body. Use the following format:
    - Brief 1-line description of what the function does
    - Write #Inputs then list each with an explanation of what the required classes/types are and what the role of that specific variable is.
    - Write #Outptut and describe the output.
- See the ROC Wikipedia page linked above for the relationship between the AUC ROC and the Gini coefficient to better understand the connection to integration using the trapezoidal rule.
- See ?match.arg() for help in resolving the plot argument.
