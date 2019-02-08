# Variables:
* **subject_id**: Taken from subject_train, subject_test files
* **activity_name**: Taken from y_train, y_test; names taken from activity_labels
* **79 time and frequency domain variables**: Taken from X_train, X_test files: the names of these variables can be found in the features file. There were originally 561 of these, but only the columns which included "mean" or "std" in the names were used.

The returned tibble should have 180 rows and 81 columns. There is a row for each grouping of subject and activity (30 subjects times 6 activities = 180 rows).

