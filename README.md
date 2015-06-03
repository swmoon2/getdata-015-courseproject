# getdata-015-courseproject
Course Project submission repository for Getting and Cleaning Data courese.

## analysis.R
R script for the Course Project of "Getting and Cleaning data" 
by Sungwook Moon  
Assumption: project data files are under the folder named "data" of working directory

### Task 1.
Merges the training and the test sets to create one data set.

1. Read train data files which are under the folder train and bind subject id, activity level and train data

        subject_train <- read.table("./data/train/subject_train.txt", stringsAsFactors=FALSE)
        ylabel_train <- read.table("./data/train/y_train.txt") 
        ds_train <- read.table("./data/train/X_train.txt")
        ds_train <- cbind(subject_train, ylabel_train, ds_train)

2. Read test data files which are under the folder test and bind subject id, activity level and test data

        subject_test <- read.table("./data/test/subject_test.txt", stringsAsFactors=FALSE)
        ylabel_test <- read.table("./data/test/y_test.txt") 
        ds_test <- read.table("./data/test/X_test.txt")
        ds_test <- cbind(subject_test, ylabel_test, ds_test)

3. Merge both datasets and set column names

        ds_merged <- rbind(ds_train, ds_test)
        hdr <- read.table("./data/features.txt", stringsAsFactors=FALSE)
        names(ds_merged) <- c("subjectID", "activity", hdr$V2)

### Task 2.
Extracts only the measurements on the mean and standard deviation for each measurement. 

1. Make column names unique before select

    names(ds_merged) <- make.names(names=names(ds_merged), unique=TRUE)

2. Select columns which contains "mean" and "std"

            ds_extracted <- select(ds_merged, subjectID, activity, 
                               contains(".mean"), contains(".std"), -contains(".meanFreq"))

### Task 3.
Uses descriptive activity names to name the activities in the data set

1. Read activity labels from file
        
        activity_labels <- read.table("./data/activity_labels.txt", stringsAsFactors=FALSE)

2. Change activity levels to factor type with descriptive labels
        
        ds_extracted$activity <- as.factor(ds_extracted$activity)
        levels(ds_extracted$activity) <- activity_labels$V2

### Task 4.
Appropriately labels the data set with descriptive variable names. 
Using gsub function, change the column names of dataset

    names(ds_extracted) <- gsub(".mean","Mean", names(ds_extracted))
    names(ds_extracted) <- gsub(".std","Std", names(ds_extracted))
    names(ds_extracted) <- gsub("\\.","", names(ds_extracted))

### Task 5.
From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

1. Create tidy dataset

            ds_tidy <- ddply(ds_extracted, .(subjectID, activity), colwise(mean))

2. Write dataset to a txt file

            write.table(ds_tidy, file="./tidy_dataset.txt", row.names=FALSE, col.names=FALSE, sep="\t", quote=FALSE)

That is it. 
