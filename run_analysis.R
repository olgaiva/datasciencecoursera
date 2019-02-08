# run_analysis.R

library("tidyverse")
run_analysis <- function(){
    # 1. MERGE SETS
    # Get data from train folder
    X_train <- read.table("./train/X_train.txt")
    activity_train <- read.table("./train/y_train.txt")
    subject_train <- read.table("./train/subject_train.txt")
    
    # Get data from test folder
    X_test <- read.table("./test/X_test.txt")
    activity_test <- read.table("./test/y_test.txt")
    subject_test <- read.table("./test/subject_test.txt")
    
    # Merge data
    X_full <- rbind(X_test, X_train)
    activity_full <- rbind(activity_test, activity_train)
    subject_full <- rbind(subject_test, subject_train)
    
    
    # 2. EXTRACT ONLY MEASUREMENTS ON MEAN AND STD DEVIATION
    # Extract column names from features.txt
    X_names_list <- read.table("features.txt")
    X_names <- as.vector(X_names_list[["V2"]])
    
    # Name the 561 columns
    colnames(X_full) <- X_names
    
    # Get subset of X_full where column names contain "mean" or "std"
    X_mean_std <- X_full[,unique(c(grep("mean", colnames(X_full)), grep("std", colnames(X_full))))]
    
    
    # 3. USE DESCRIPTIVE ACTIVITY NAMES TO NAME THE ACTIVITIES
    # I think that the names in activity_labels are descriptive enough
    
    # Name columns in activity_full to do the merge
    colnames(activity_full) <- c("activity_num")
    
    # Get lookup table from activity_labels.txt
    activity_lookup <- read.table("activity_labels.txt")
    colnames(activity_lookup) <- c("activity_num", "activity_name")
    
    # Left join gives names for each num value in lookup table
    activity_full <- dplyr::left_join(activity_full, activity_lookup)
    
    # "Clean up" format of activity data for next parts of script
    activity_full <- dplyr::select(activity_full, -activity_num)
    activity_full[["activity_name"]] <- as.character(activity_full[["activity_name"]])
    
    
    # 4. LABEL DATA SET WITH DESCRIPTIVE VARIABLE NAMES
    # Activities, acceleration/time variables have all been given descriptive names,
    # so all that's left to do is to name the subject column
    colnames(subject_full) <- c("subject_id")
    
    
    # 5. CREATE SECOND, INDEPENDENT TIDY DATASET WITH AVERAGE OF EACH VARIABLE
    #    FOR EACH ACTIVITY AND EACH SUBJECT
    
    # Create one large dataset out of all the columns
    tidy_data_full <- cbind(subject_full, activity_full, X_mean_std)
    
    # Convert to a tibble
    tidy_tbl_full <- dplyr::tbl_df(tidy_data_full)
    
    # Group data by subject and activity, return average for each group
    tidy_tbl_grouped <- dplyr::group_by(tidy_tbl_full, subject_id, activity_name)
    dplyr::summarize_all(tidy_tbl_grouped, mean)
    
}

