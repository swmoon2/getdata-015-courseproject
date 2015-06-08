# R script for the Course Project of "Getting and Cleaning data" 
# by Sungwook Moon  
# assumption: project data files are under the folder named "data" of working directory

## load packages required
library(plyr)
library(dplyr)
library(tidyr)

# Task 1.
# Merges the training and the test sets to create one data set.
## 1.0 Download project file
temp <- tempfile()
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, temp, method="curl")

## 1.1 Read train datasets
subject_train <- read.table(unz(temp, "UCI HAR Dataset/train/subject_train.txt"), stringsAsFactors=FALSE)
ylabel_train <- read.table(unz(temp, "UCI HAR Dataset/train/y_train.txt")) 
ds_train <- read.table(unz(temp, "UCI HAR Dataset/train/X_train.txt"))  # read train dataset 7,352 obs.
ds_train <- cbind(subject_train, ylabel_train, ds_train)

## 1.2 Read test datasets
subject_test <- read.table(unz(temp, "UCI HAR Dataset/test/subject_test.txt"), stringsAsFactors=FALSE)
ylabel_test <- read.table(unz(temp, "UCI HAR Dataset/test/y_test.txt"))
ds_test <- read.table(unz(temp, "UCI HAR Dataset/test/X_test.txt"))  # read test dataset 2,947 obs.
ds_test <- cbind(subject_test, ylabel_test, ds_test)

## 1.3 Merge both datasets and set column names
ds_merged <- rbind(ds_train, ds_test)
hdr <- read.table(unz(temp, "UCI HAR Dataset/features.txt"), stringsAsFactors=FALSE)  # read column header
names(ds_merged) <- c("subjectID", "activity", hdr$V2) # set column names for the merged dataset

## 1.4 Remove temporary datasets
rm(subject_train, ylabel_train, ds_train, subject_test, ylabel_test, ds_test, hdr) 

# Task 2.
# Extracts only the measurements on the mean and standard deviation for each measurement. 
## 2.1 Make column names unique before select
names(ds_merged) <- make.names(names=names(ds_merged), unique=TRUE)

## 2.2 Select columns which contains "mean" and "std"
ds_extracted <- select(ds_merged, subjectID, activity, 
                       contains(".mean"), contains(".std"), -contains(".meanFreq"))

# Task 3.
# Uses descriptive activity names to name the activities in the data set
## 3.1 Read activity labels from file
activity_labels <- read.table(unz(temp, "UCI HAR Dataset/activity_labels.txt"), stringsAsFactors=FALSE)

## 3.2 Change activity levels to factor type with descriptive labels
ds_extracted$activity <- as.factor(ds_extracted$activity)
levels(ds_extracted$activity) <- activity_labels$V2

## 3.3 Remove temporary data
rm(activity_labels)

# Task 4.
# Appropriately labels the data set with descriptive variable names. 
names(ds_extracted) <- gsub(".mean","Mean", names(ds_extracted))
names(ds_extracted) <- gsub(".std","Std", names(ds_extracted))
names(ds_extracted) <- gsub("\\.","", names(ds_extracted))
names(ds_extracted) <- gsub("BodyBody","Body", names(ds_extracted))

# Task 5.
# From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.
## 5.1 Create tidy dataset
ds_tidy <- ddply(ds_extracted, .(subjectID, activity), colwise(mean))

## 5.2 Write dataset to a txt file
write.table(ds_tidy, file="./tidy_dataset.txt", row.names=FALSE, col.names=TRUE, sep="\t", quote=FALSE)

## Finally disconnect and remove tempfile
unlink(temp)
rm(temp,fileUrl)
## end of script
