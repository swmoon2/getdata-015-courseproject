# getdata-015-courseproject
Course Project submission repository for Getting and Cleaning Data courese.

## analysis.R
> R script for the Course Project of "Getting and Cleaning data" 
> by Sungwook Moon  
> Assumption: project data files are under the folder named "data" of working directory

### Task 1.
> Merges the training and the test sets to create one data set.

1. Read train datasets
2. Read test datasets
3. Merge both datasets and set column names
4. Remove temporary datasets

### Task 2.
> Extracts only the measurements on the mean and standard deviation for each measurement. 

1. Make column names unique before select
2. Select columns which contains "mean" and "std"

### Task 3.
> Uses descriptive activity names to name the activities in the data set

1. Read activity labels from file
2. Change activity levels to factor type with descriptive labels
3. Remove temporary data

### Task 4.
Appropriately labels the data set with descriptive variable names. 
Using gsub function, change the column names of dataset

    names(ds_extracted) <- gsub(".mean","Mean", names(ds_extracted))
    names(ds_extracted) <- gsub(".std","Std", names(ds_extracted))
    names(ds_extracted) <- gsub("\\.","", names(ds_extracted))

# Task 5.
# From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.
## 5.1 Create tidy dataset
ds_tidy <- ddply(ds_extracted, .(subjectID, activity), colwise(mean))

## 5.2 Write dataset to a txt file
write.table(ds_tidy, file="./tidy_dataset.txt", row.names=FALSE, col.names=FALSE, sep="\t", quote=FALSE)

## end of script
