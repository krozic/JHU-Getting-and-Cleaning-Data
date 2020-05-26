if(!file.exists("./data")){dir.create("./data")}
fileUrl <- https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
download.file(fileUrl, "./data/UCI_HAR.zip", method = "curl")
