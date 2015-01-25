# used packages...
library(stringr)
library(dplyr)


if(!file.exists("./data")){dir.create("./data")}


# Set up files, if 'UCI HAR Dataset' folder is not already on the './data' folder
if(!file.exists("./data/UCI HAR Dataset")){
    
    if(!file.exists("./data/getdata-projectfiles-UCI-HAR-Dataset.zip")){
    
        ## downloads project files
        fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        zipfile <- "./data/getdata-projectfiles-UCI-HAR-Dataset.zip"
        download.file(fileUrl, destfile=zipfile)
    }

    # 
    unzip (zipfile, exdir = "./data")
}



# creates a function that processes the files, given the dataset: "test" ou "train"
processDataSet <- function(dataset){

    #1) Read the Features table
    features <- read.table("./data/UCI HAR Dataset/features.txt", header = FALSE, stringsAsFactors = FALSE)
    
    #2) Build a logical vector indicating if the feature contains the 
    # text 'mean()' OR 'std()'. (Please attention here, I don't look 
    # for the 'Mean' text, since I understand that only the ones containing 
    # the text 'mean()' are "(...)the measurements on the mean (...) for each measurement" 
    # asked on assignment item 2)
    rowsMeanStd <- str_detect(features[,2], fixed("mean()")) | str_detect(features[,2], fixed("std()"))
    
    #3) get a vector of all columns I'll need to get from the X file.
    colsOfInterest <- features[rowsMeanStd, 1]
    
    #4) and their names:
    featuresColNames <- features[rowsMeanStd, 2]
    
    #5) better names:
    featuresColNames <- gsub(x = featuresColNames, fixed = TRUE, pattern = "()", replacement = "") 
    featuresColNames <- gsub(x = featuresColNames, fixed = TRUE, pattern = "-", replacement = "_") 
    featuresColNames <- gsub(x = featuresColNames, fixed = TRUE, pattern = "BodyBody", replacement = "Body") 
    
    
    
    # 6) read the X data
    xFileName <- sprintf("./data/UCI HAR Dataset/%s/X_%s.txt", 
                         as.character(dataset), as.character(dataset))
    
    X  <- read.table(xFileName, header = FALSE)
    X <- X[,colsOfInterest] #just the interesting columns
    names(X) <- featuresColNames #rename the variables


    
    # 7) Add the subject column, from the 'subject_[dataset].txt' file.
    subjectFileName <- sprintf("./data/UCI HAR Dataset/%s/subject_%s.txt", 
                         as.character(dataset), as.character(dataset))
    subject <- read.table(subjectFileName, header = FALSE)
    names(subject) <- "subject"
    X <- cbind(X, subject)
    
    
    # 8) set up activity labels
    
    # 8.1) read the right Y file (test or train)
    yFileName <- sprintf("./data/UCI HAR Dataset/%s/Y_%s.txt", 
                         as.character(dataset), as.character(dataset))
    Y <- read.table(yFileName, header = FALSE)

    
    # 8.2) add 'idactivity' column
    names(Y) <- "idactivity"
    X <- cbind(X, Y)
    
    
    # 8.3) merge with activity_labels
    activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt", header = FALSE)
    names(activity_labels) <- c("id", "activity")
    X <- merge(x = X, y = activity_labels, by.x = "idactivity", by.y = "id")
    
    # 8.4) remove column idactivity
    X <- select(X, -idactivity)
    
    
    # 9) add the 'data_set' column:
    X <- mutate(X, data_set = as.character(dataset))

    # return the processed data
    X
}


run_analysis <- function(){
    
    
    testdata <- processDataSet(dataset = "test")
    traindata <- processDataSet(dataset = "train")
    
    #this is my step 1 merged data (only mean and std columns)
    alldata <- rbind(testdata, traindata) 
    
    
    #summarize grouped data set
    tidyDataForStep5 <- summarise(group_by(alldata, subject, activity), 
            meanOf_tBodyAcc_mean_X = mean(tBodyAcc_mean_X),
            meanOf_tBodyAcc_mean_Y = mean(tBodyAcc_mean_Y),
            meanOf_tBodyAcc_mean_Z = mean(tBodyAcc_mean_Z),
            meanOf_tBodyAcc_std_X = mean(tBodyAcc_std_X),
            meanOf_tBodyAcc_std_Y = mean(tBodyAcc_std_Y),
            meanOf_tBodyAcc_std_Z = mean(tBodyAcc_std_Z),
            meanOf_tGravityAcc_mean_X = mean(tGravityAcc_mean_X),
            meanOf_tGravityAcc_mean_Y = mean(tGravityAcc_mean_Y),
            meanOf_tGravityAcc_mean_Z = mean(tGravityAcc_mean_Z),
            meanOf_tGravityAcc_std_X = mean(tGravityAcc_std_X),
            meanOf_tGravityAcc_std_Y = mean(tGravityAcc_std_Y),
            meanOf_tGravityAcc_std_Z = mean(tGravityAcc_std_Z),
            meanOf_tBodyAccJerk_mean_X = mean(tBodyAccJerk_mean_X),
            meanOf_tBodyAccJerk_mean_Y = mean(tBodyAccJerk_mean_Y),
            meanOf_tBodyAccJerk_mean_Z = mean(tBodyAccJerk_mean_Z),
            meanOf_tBodyAccJerk_std_X = mean(tBodyAccJerk_std_X),
            meanOf_tBodyAccJerk_std_Y = mean(tBodyAccJerk_std_Y),
            meanOf_tBodyAccJerk_std_Z = mean(tBodyAccJerk_std_Z),
            meanOf_tBodyGyro_mean_X = mean(tBodyGyro_mean_X),
            meanOf_tBodyGyro_mean_Y = mean(tBodyGyro_mean_Y),
            meanOf_tBodyGyro_mean_Z = mean(tBodyGyro_mean_Z),
            meanOf_tBodyGyro_std_X = mean(tBodyGyro_std_X),
            meanOf_tBodyGyro_std_Y = mean(tBodyGyro_std_Y),
            meanOf_tBodyGyro_std_Z = mean(tBodyGyro_std_Z),
            meanOf_tBodyGyroJerk_mean_X = mean(tBodyGyroJerk_mean_X),
            meanOf_tBodyGyroJerk_mean_Y = mean(tBodyGyroJerk_mean_Y),
            meanOf_tBodyGyroJerk_mean_Z = mean(tBodyGyroJerk_mean_Z),
            meanOf_tBodyGyroJerk_std_X = mean(tBodyGyroJerk_std_X),
            meanOf_tBodyGyroJerk_std_Y = mean(tBodyGyroJerk_std_Y),
            meanOf_tBodyGyroJerk_std_Z = mean(tBodyGyroJerk_std_Z),
            meanOf_tBodyAccMag_mean = mean(tBodyAccMag_mean),
            meanOf_tBodyAccMag_std = mean(tBodyAccMag_std),
            meanOf_tGravityAccMag_mean = mean(tGravityAccMag_mean),
            meanOf_tGravityAccMag_std = mean(tGravityAccMag_std),
            meanOf_tBodyAccJerkMag_mean = mean(tBodyAccJerkMag_mean),
            meanOf_tBodyAccJerkMag_std = mean(tBodyAccJerkMag_std),
            meanOf_tBodyGyroMag_mean = mean(tBodyGyroMag_mean),
            meanOf_tBodyGyroMag_std = mean(tBodyGyroMag_std),
            meanOf_tBodyGyroJerkMag_mean = mean(tBodyGyroJerkMag_mean),
            meanOf_tBodyGyroJerkMag_std = mean(tBodyGyroJerkMag_std),
            meanOf_fBodyAcc_mean_X = mean(fBodyAcc_mean_X),
            meanOf_fBodyAcc_mean_Y = mean(fBodyAcc_mean_Y),
            meanOf_fBodyAcc_mean_Z = mean(fBodyAcc_mean_Z),
            meanOf_fBodyAcc_std_X = mean(fBodyAcc_std_X),
            meanOf_fBodyAcc_std_Y = mean(fBodyAcc_std_Y),
            meanOf_fBodyAcc_std_Z = mean(fBodyAcc_std_Z),
            meanOf_fBodyAccJerk_mean_X = mean(fBodyAccJerk_mean_X),
            meanOf_fBodyAccJerk_mean_Y = mean(fBodyAccJerk_mean_Y),
            meanOf_fBodyAccJerk_mean_Z = mean(fBodyAccJerk_mean_Z),
            meanOf_fBodyAccJerk_std_X = mean(fBodyAccJerk_std_X),
            meanOf_fBodyAccJerk_std_Y = mean(fBodyAccJerk_std_Y),
            meanOf_fBodyAccJerk_std_Z = mean(fBodyAccJerk_std_Z),
            meanOf_fBodyGyro_mean_X = mean(fBodyGyro_mean_X),
            meanOf_fBodyGyro_mean_Y = mean(fBodyGyro_mean_Y),
            meanOf_fBodyGyro_mean_Z = mean(fBodyGyro_mean_Z),
            meanOf_fBodyGyro_std_X = mean(fBodyGyro_std_X),
            meanOf_fBodyGyro_std_Y = mean(fBodyGyro_std_Y),
            meanOf_fBodyGyro_std_Z = mean(fBodyGyro_std_Z),
            meanOf_fBodyAccMag_mean = mean(fBodyAccMag_mean),
            meanOf_fBodyAccMag_std = mean(fBodyAccMag_std),
            meanOf_fBodyAccJerkMag_mean = mean(fBodyAccJerkMag_mean),
            meanOf_fBodyAccJerkMag_std = mean(fBodyAccJerkMag_std),
            meanOf_fBodyGyroMag_mean = mean(fBodyGyroMag_mean),
            meanOf_fBodyGyroMag_std = mean(fBodyGyroMag_std),
            meanOf_fBodyGyroJerkMag_mean = mean(fBodyGyroJerkMag_mean),
            meanOf_fBodyGyroJerkMag_std = mean(fBodyGyroJerkMag_std))
    
    
    #return of function
    tidyDataForStep5
}    