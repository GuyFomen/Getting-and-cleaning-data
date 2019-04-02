###################### Getting an Cleaning Data Project###############
######################################################################

setwd()# getting working directory
library(dplyr) # loading the dply package

#### Merging train's Data
# loading data into vectors

Xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt") # loading
subjecttrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")
ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt")
mergetrain <- cbind(subjecttrain,ytrain,Xtrain)
str(mergetrain)

### Merging test's Data
# loading Data
Xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")
subjecttest <- read.table("./UCI HAR Dataset/test/subject_test.txt")
ytest <- read.table("./UCI HAR Dataset/test/y_test.txt")
mergetest <- cbind(subjecttest, ytest, Xtest)
str(mergetest) # to check 

## merging all in one
mergeData <- rbind(mergetest, mergetrain)
str(mergeData)
View(mergeData) # have a view 

## feature.txt and changing the columns names
feature <- read.table("./UCI HAR Dataset/features.txt")
v <- grep("std",feature$V2)
w <- grep("mean",feature$V2)

col_names <- c("id", "activity",as.character(feature$V2[c(v,w)]))
mergeData2 <-mergeData[,c(1,2,v,w)]
colnames(mergeData2) <- col_names

### activity_labels and the activities'columns
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

mergeData2$activity <- sapply(mergeData2$activity,function(x) activity_labels$V2[x]) 
# removing special charcters in columns'names
t <- sub("\\()","",colnames(mergeData2)) 
colnames(mergeData2)<- tolower(gsub("-","",t)) 
colnames(mergeData2)
## first Tidy Data
View(mergeData2)


### independent Tidy data with grouped id activities and averages' columns

TidyData <- mergeData2%>%group_by(id, activity)%>%summarise_each(funs = mean,colnames(mergeData2)[c(-1,-2)])
write.table(TidyData,file = "TdiyData.txt", row.names =FALSE, sep = "\t ")
View(TidyData)
