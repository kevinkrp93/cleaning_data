library(dplyr)

#Download the file and unzip


filename <- "getdata_dataset.zip"

if (!file.exists(filename))
  
{
  
  source <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "

  
  download.file(source, filename)
}  

if (!file.exists("UCI HAR Dataset")) 
{ 
  unzip(filename) 
}


# Read training and test data
training_subjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
training_activity <- read.table("UCI HAR Dataset/train/y_train.txt")
training_values <- read.table("UCI HAR Dataset/train/X_train.txt")

training <- cbind(training_subjects,training_activity,training_values)

test_subjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test_activity <- read.table("UCI HAR Dataset/test/y_test.txt")
test_values <- read.table("UCI HAR Dataset/test/X_test.txt")

test<- cbind(test_subjects,test_activity,test_values)

# Merge training and test data

analysis <- rbind(training,test)

# Read and assign colnames

values_names <- read.table("UCI HAR Dataset/features.txt",as.is = TRUE)

analysis_colnames <- c("Subject","Activity",values_names[,2])

#Rename Columns to make it understandable

analysis_colnames <- gsub("^f", "Frequency Domain ", analysis_colnames)
analysis_colnames <- gsub("^t", "Time Domain ", analysis_colnames)
analysis_colnames <- gsub("Acc", " Accelerometer", analysis_colnames)
analysis_colnames <- gsub("Gyro", " Gyroscope ", analysis_colnames)
analysis_colnames <- gsub("Mag", " Magnitude ", analysis_colnames)
analysis_colnames <- gsub("mean", " Mean ", analysis_colnames)
analysis_colnames <- gsub("std", " Standard Deviation ", analysis_colnames)

analysis_colnames <- gsub("[-()]", "", analysis_colnames)


# Assign the column names to the merged dataset (analysis) 

names(analysis) <- analysis_colnames



#filter only mean and standard deviation columns 

relevent_columns <-  grep("Subject|Activity|.*Mean.*|.*Standard Deviation.*",colnames(analysis))
analysis <- analysis[,relevent_columns]


# Read Activity_labels file and factorise the Activity column in the analysis file using the labels.
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")


analysis$Activity <- factor(analysis$Activity,levels = activity_labels[,1],labels = activity_labels[,2])

# Calculate mean of of each variable for each activity and each subject

analysis_mean <- group_by(analysis,Subject,Activity)
analysis_mean <- summarise_at(analysis_mean,vars(3:ncol(analysis_mean)),mean)

# write analysis_mean to a file
write.csv(analysis_mean,"tidy_data_set.csv",sep = "",row.names = FALSE,quote = FALSE,col.names = TRUE)







