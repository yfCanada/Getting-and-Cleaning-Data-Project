# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement. 
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names. 
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Load libraries needed
library(dplyr)
library(data.table)
library(reshape2)

# Conbine all the train-data in one data frame
train_Xdata<- read.table("./train/X_train.txt", sep="")
train_Ydata<- read.table("./train/Y_train.txt", sep="")
train_subject<- read.table("./train/subject_train.txt", sep="")
train_data<- cbind(train_subject,train_Ydata,train_Xdata)

# Conbine all the test-data in one data frame
test_Xdata<- read.table("./test/X_test.txt", sep="")
test_Ydata<- read.table("./test/Y_test.txt", sep="")
test_subject<- read.table("./test/subject_test.txt", sep="")
test_data<- cbind(test_subject,test_Ydata,test_Xdata)

# Merges the training and the test sets to create one data set.
all_data<- rbind(train_data,test_data)
names(all_data)[1]<-"Subject_ID"
names(all_data)[2]<-"ActivityNo"

# Uses descriptive activity names to name the activities in the data set
activity<- read.table("activity_labels.txt", sep=" ") # Col names: V1 V2 
activity.names<- as.character(activity$V2)
all_data2<-all_data
#in all_data2, ActivityNo becoome descriptive
all_data2$ActivityNo<- activity.names[all_data2$ActivityNo]
# Rename ActivityNo to Activity
names(all_data2)[2]<-"Activity"

# Appropriately labels the data set with descriptive variable names. 
feature<- read.table("features.txt", sep=" ",stringsAsFactors=FALSE)
names(all_data2)[3:563]<-feature[,2]
#dataintable<-tbl_df(all_data2)

# Extracts only the measurements on the mean and standard deviation for each measurement.
#extrct_data<- select(dataintable,contains("mean"))
extract_data <- all_data2[,c("Subject_ID","Activity", colnames(dataintable)[grep("mean|std", colnames(dataintable))])]

#  Step 5 is unfinished :(
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
dataMelt<- melt(extract_data, id=c("Subject_ID","Activity"),measure.vars = colnames(extract_data)[3:81])
grouped<- group_by(extract_data,Subject_ID,Activity)
grouped_mean<- summarize(grouped, mean())
