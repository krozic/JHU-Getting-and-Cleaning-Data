library(plyr)
library(dplyr)

#create the directory, download the file, and extract the contents
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists("./data/UCI_HAR.zip")){download.file(fileUrl, "./data/UCI_HAR.zip", method = "curl")}
if(!file.exists("./data/UCI HAR Dataset/")){unzip("./data/UCI_HAR.zip", "./data/UCI HAR Dataset/")}

#read in all the files
testX <- read.table("./UCI HAR Dataset/test/X_test.txt")
testy <- read.table("./UCI HAR Dataset/test/y_test.txt")
subjectTest <- read.table("./UCI HAR Dataset/test/subject_test.txt")
trainX <- read.table("./UCI HAR Dataset/train/X_train.txt")
trainy <- read.table("./UCI HAR Dataset/train/y_train.txt")
subjectTrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")
features <- read.table("./UCI HAR Dataset/features.txt")
activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt")

#name the variables
names(testX) <- features$V2
names(trainX) <- features$V2
names(testy) <- "activity"
names(trainy) <- "activity"
names(subjectTest) <- "subject"
names(subjectTrain) <- "subject"

#assemble the data parts
testset <- cbind(subjectTest, testy, testX)
trainset <- cbind(subjectTrain, trainy, trainX)
fullset <- rbind(testset, trainset)

#substitute activity with descriptive labels
# include? activityLabels$V2 <- tolower(activityLabels$V2)
for (i in 1:6) {
        fullset$activity <- gsub(i, activityLabels$V2[i], fullset$activity)
}

#get mean and std indeces
meanindeces <- grep("[Mm][Ee][Aa][Nn]", names(fullset))
stdindeces <- grep("[Ss][Tt][Dd]", names(fullset))

#subset the data
indeces <- sort(c(1:2, meanindeces, stdindeces))
tidyset <- fullset[, indeces]

#rename variables with descriptive titles
names(tidyset) <- gsub("^t", "Time", names(tidyset))
names(tidyset) <- gsub("^f", "Frequency", names(tidyset))
names(tidyset) <- gsub("Acc", "Accelerometer", names(tidyset))
names(tidyset) <- gsub("Gyro", "Gyroscope", names(tidyset))
names(tidyset) <- gsub("Mag", "Magnitude", names(tidyset))
names(tidyset) <- gsub("BodyBody", "Body", names(tidyset))
names(tidyset) <- gsub("-mean", "Mean", names(tidyset))
names(tidyset) <- gsub("-std", "STD", names(tidyset))
names(tidyset) <- gsub("Freq\\(\\)", "Frequency", names(tidyset))
names(tidyset) <- gsub("\\(\\)", "", names(tidyset))
names(tidyset) <- gsub("gravity", "Gravity", names(tidyset))
names(tidyset) <- gsub("angle", "Angle", names(tidyset))
names(tidyset) <- gsub("\\(t", "(Time", names(tidyset))
names(tidyset) <- gsub("\\),|,", "_", names(tidyset))

#make final dataset
tidysetMeans <- tidyset %>% group_by(subject, activity) %>% summarise_all(list(mean))
write.table(tidysetMeans, "data.txt", row.name = FALSE)


