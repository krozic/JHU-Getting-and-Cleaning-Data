Q1. 

json1 = content(req)
json2 = jsonlite::fromJSON(toJSON(json1))

json2[json2$name == "datasharing", ]$created_at

Q2.

acs[acs$AGEP < 50, ]$pwgtp1

#(Check)
sum(acs$AGEP < 50)
str(acs[acs$AGEP < 50, ]$pwgtp1)
#(should be the same)

install.packages("sqldf")
library("sqldf")
options(sqldf.driver = "SQLite")
#It defaults to using RMySQL if it's loaded first

A:
sqldf("select pwgtp1 from acs where AGEP < 50")

(check)
sum(
    sqldf("select pwgtp1 from acs where AGEP < 50") 
    == acs[acs$AGEP < 50, ]$pwgtp1
            )
mean(
    sqldf("select pwgtp1 from acs where AGEP < 50") 
    == acs[acs$AGEP < 50, ]$pwgtp1
            )


Q3.

sqldf("select distinct AGEP from acs")

#Check

sum(
    as.vector(unlist(sqldf("select distinct AGEP from acs"))) 
    == unique(acs$AGEP)) 
    == length(unique(acs$AGEP)
              )

Q4.

url <- "http://biostat.jhsph.edu/~jleek/contact.html"
parsedHtml <- htmlParse(content(GET(url)))#scratch this

readLines(url)[10]

lines <- c(readLines(url)[10], 
           readLines(url)[20], 
           readLines(url)[30], 
           readLines(url)[100]
                  )
nchar(lines)


Q5.

data <- readLines("https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for")
len <- length(data)
data[3:len, ]

data[5]
[5]" 03JAN1990     23.4-0.4     25.1-0.3     26.6 0.0     28.6 0.3"

#Scrap all this. Can't make columns with this data

file <- url("https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for")
#url() makes a connection

data <- read.fwf(file, 
                 skip = 4, 
                 widths = c(10, 9, 9, 4, 9, 4, 9, 4, 4)
                )
#Widths is manually counted. 
#Include white space in variables, best to mix them with numbers
sum(data[, 4])


