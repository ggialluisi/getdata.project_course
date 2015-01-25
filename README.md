---
title: "Getting and Cleaning Data - Course Project"
author: "Gustavo Gialluisi"
date: "Sunday, January 25, 2015"
---


This file describes my proposed solution for the Course Project of the Getting and Cleaning Data Coursera course[1].


I'll transcribe below the project assignment:


* * * * * * * * *
The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.  

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones [0]

Here are the data for the project: 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

 You should create one R script called run_analysis.R that does the following:

1) Merges the training and the test sets to create one data set.
2) Extracts only the measurements on the mean and standard deviation for each measurement. 
3) Uses descriptive activity names to name the activities in the data set
4) Appropriately labels the data set with descriptive variable names. 
5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Good luck!

* * * * * * * * *




My solution for the assignment is made a bit out of order, I agree with David Hood in his very useful discussion forum post 'David's Project FAQ'[2]: why should I merge all data and after that remove not wanted columns? So I merged only the desired columns. 

What is more, the processing for both test and train data sets are very similar, so I creates the function processDataSet passing "test" or "train" as parameter. That aproach made me have the first item (merged data sets) only in the end of the processing.

So, it's just out of the asked order, but it's working fine.

To run the script, place the file 'run_analysis.R' in your working directory (run getwd() in R case you don't know where is it).

Then run in R:

> source("run_analysis.R")

When you source it, the script will:

0) Run library on stringr and deplyr packages that are pre-requisites to source the 'run_analysis.R' file.

1) Setup project files:

Creates './data' folder if it's not there.

If 'UCI HAR Dataset' folder is not already on the './data' folder then {

	1 - If the file 'getdata-projectfiles-UCI-HAR-Dataset.zip' is not already in the "./data" folder, then the script will download the zip project file to the folder "./data".
    
	2 - Extract the zip file to the folder "./data", creating the './data/UCI HAR Dataset' folder

}

2) Create the processDataSet(dataset) function, that will be described in details below.

3) Create the run_analysis() function, that will get processed data using processDataSet("test") and processDataSet("train"), merge them, and summarize this merged data into the tidy data set asked in the item 5. The funcion returns this tidy data set.


So, view the tidy data running:

> View(run_analysis())


The handed 'tidyDataStep5.txt' file was generated running:

> write.table(run_analysis(), file = "tidyDataStep5.txt", row.names=FALSE)


And it should be read using:

> tidyDataStep5 <- read.table("tidyDataStep5.txt", header = TRUE)




#### Is this data really tidy?

After all course lectures, when I got a lot of columns names containing "_X", "_Y" and "_Z", or "_mean", "_std", it seemed that, for instance "tBodyAcc_mean_X" should be decomposed into 4 variables: 'domain' (time or frequency), 'measure', 'function' (mean, std) and 'axis'(X, Y, Z).

Fortunatelly, we have our discussion groups, and David Antolino, Edward William Kuns and David Hood commented on the thread called 'Tidy data and the assignment'[3], explaining that "tBodyAcc_mean_X" is a single variable.

Quoting:
"(...) tBodyAcc-mean()-X is a single variable.  It is the "time domain" body acceleration average for the X axis.  This is a single measurement. What is a "time domain"?  The time domain is the normal measurement that we would be familiar with.(...)" (Edward William Kuns)

, and

"In addition to Edward's good answer, you would find that if you do try and decompose it the data does not make a complete set. In the male and female example from swirl all of the data fits into a set. This data will keep hitting entries that need NA added, which is a sign that the variable hasn't correctly matched a set of data." (David Hood)

(Thank you guys!)



#### The processDataSet(dataset) function


Given the parameter dataset as "test" or "train", the processDataSet function does the following:

1) Read the Features table

2) Build a logical vector indicating if the feature contains the text 'mean()' OR 'std()'. (Please attention here, I don't look for the 'Mean' text, since I understand that only the ones containing the text 'mean()' are "(...)the measurements on the mean (...) for each measurement" asked on assignment item 2)

3) Based on this logical vector, I get a vector of all columns I'll need to get from the X file.

4) Also based on this logical vector, I get a vector of all columns names for my data set, that are should be exactly the features names.

5) This is the moment I chose to change a bit the column names, I removed all the "()" and changed "-" to "_". Then I keep the meaning of the features names, and I don't have problems calling the summarize function that I would have if there were "()" or "-" on the columns names. I have replaced also "BodyBody" for "Body" that occured on some features names.

6) Then I read the rigth 'X_[dataset]' table, only the columns of interest, and set the columns names.

7) Add the subject column, from the 'subject_[dataset].txt' file.

8) Set up activity labels, following this steps:

8.1) read the right 'Y_[dataset]' file

8.2) add it as 'idactivity' column

8.3) merge with activity_labels

8.4) remove column idactivity


9) Add the 'data_set' column, indicating if it is "test" or "train"

And finally returns the processed data.




#### References:

[0] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

[1] Getting and Cleaning Data
Coursera Course
by Jeff Leek, PhD, Roger D. Peng, PhD, Brian Caffo, PhD. 
https://class.coursera.org/getdata-010/human_grading

[2] David's Project FAQ (discussion forum post)
David Hood
https://class.coursera.org/getdata-010/forum/thread?thread_id=49

[3] Tidy data and the assignment (discussion forum post)
David Hood, very well commented by Edward William Kuns
https://class.coursera.org/getdata-010/forum/thread?thread_id=241