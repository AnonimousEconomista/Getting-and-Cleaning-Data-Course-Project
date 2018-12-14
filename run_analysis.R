############## Getting and Cleaning Data Course Project ################

#### Preliminary: get working directory

Directory<-getwd()

#### Step 1: Merge the training and the test sets to create one data set

# Downloading data

fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, file.path(Directory, "zippedFiles.zip"))
unzip(zipfile = "zippedFiles.zip")

# Reading files
activityLabels<-read.table(file.path(Directory, "./UCI HAR Dataset/activity_labels.txt"))
features<-read.table(file.path(Directory, "./UCI HAR Dataset/features.txt"))

trainSubject<-read.table(file.path(Directory, "./UCI HAR Dataset/train/subject_train.txt"), col.names= "GroupCode")
trainSet<-read.table(file.path(Directory, "./UCI HAR Dataset/train/X_train.txt"), col.names = features[,2])
trainLabel<-read.table(file.path(Directory, "./UCI HAR Dataset/train/y_train.txt"), col.names = "activity")

testSubject<-read.table(file.path(Directory, "./UCI HAR Dataset/test/subject_test.txt"), col.names = "GroupCode")
testSet<-read.table(file.path(Directory, "./UCI HAR Dataset/test/X_test.txt"), col.names = features[,2])
testLabel<-read.table(file.path(Directory, "./UCI HAR Dataset/test/y_test.txt"), col.names = "activity")

# Combining files to one single dataset

mergedTrain<-cbind(trainSubject, trainSet, trainLabel)
mergedTest<-cbind(testSubject, testSet, testLabel)
mergedDataSet<-rbind(mergedTrain, mergedTest)

#### Step 2: Extract only the measurements on the mean and standard deviation for each measurement

measurements<-mergedDataSet[,c("GroupCode","activity",grep("mean|std", names(mergedDataSet), value = TRUE))]

#### Step 3: Use descriptive activity names to name the activities in the data set

measurements$activity[measurements$activity == 1] <- "walking"
measurements$activity[measurements$activity == 2] <- "walking_upstairs"
measurements$activity[measurements$activity == 3] <- "walking_downstairs"
measurements$activity[measurements$activity == 4] <- "sitting"
measurements$activity[measurements$activity == 5] <- "standing"
measurements$activity[measurements$activity == 6] <- "laying"

#### Step 4: Appropriately label the data set with descriptive variable names

newnames<-gsub("Acc", "accelerometer",names(measurements))
newnames<-gsub("^t", "time", newnames)
newnames<-gsub("^f", "frequency", newnames)
newnames<-gsub("[Gg]yro", "gyroscope", newnames)
newnames<-gsub("BodyBody", "body", newnames)
names(measurements)<-newnames

#### Step 5: From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.
means <- measurements %>% 
        group_by(GroupCode, activity) %>%
        summarise_all(funs(mean))

tidydata<-write.table(means, file = "tidydata.txt", row.names = FALSE)



