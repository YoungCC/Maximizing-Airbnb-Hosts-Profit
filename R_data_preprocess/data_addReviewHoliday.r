rm(list = ls())
library(data.table)
library(lubridate)
MAIN_DIR <- "/Users/Andrea/airbnb/data/"

manyHolidays2 <- c("2015-02-13", "2015-02-14", "2015-02-15", "2015-04-04", "2015-04-05", "2015-04-06", 
                   "2015-11-25", "2015-11-26", "2015-11-27", "2016-02-13", "2016-02-14", "2016-02-15", 
                   "2016-03-27", "2016-03-26", "2016-03-28", "2016-11-23", "2016-11-24", "2016-11-25",
                   "2017-02-13", "2017-02-14", "2017-02-15", "2017-04-15", "2017-04-16", "2015-04-17",
                   "2015-10-08", "2015-10-09", "2015-10-10", "2015-10-11", "2016-10-06", "2016-10-07",
                   "2016-10-08", "2016-10-09", "2017-10-05", "2017-10-06", "2017-10-07", "2017-10-08"
)

get_fileName <- function(folder, wdate, pattern){
  filename <- paste(MAIN_DIR,folder,"/",wdate,"_",pattern,sep="")
  print(filename)
  return(filename)
}

everyday <- read.csv(get_fileName("justreviews","2017-10-02","justreview.csv"))
isholiday <- c(1:nrow(everyday))
isholiday <- 0
everyday <- data.frame(everyday,isholiday)
everyday$date <- as.Date(everyday$date,"%Y-%m-%d")

for (holiday2 in manyHolidays2)
{
  everyday$isholiday[everyday$date == as.Date(holiday2)] <- 2
}

everyday$isholiday[everyday$date >= as.Date("2015-12-23") & everyday$date<=as.Date("2016-01-03")] <- 1
everyday$isholiday[everyday$date >= as.Date("2016-12-23") & everyday$date<=as.Date("2017-01-03")] <- 1
everyday$isholiday[everyday$date >= as.Date("2015-05-01") & everyday$date<=as.Date("2015-06-30")] <- 1
everyday$isholiday[everyday$date >= as.Date("2016-05-01") & everyday$date<=as.Date("2016-06-30")] <- 1
everyday$isholiday[everyday$date >= as.Date("2017-05-01") & everyday$date<=as.Date("2017-06-30")] <- 1
everyday$isholiday[everyday$date >= as.Date("2015-09-01") & everyday$date<=as.Date("2015-10-31")] <- 1
everyday$isholiday[everyday$date >= as.Date("2016-09-01") & everyday$date<=as.Date("2016-10-31")] <- 1
everyday$isholiday[everyday$date >= as.Date("2017-09-01") & everyday$date<=as.Date("2017-10-31")] <- 1

everyday$date <- as.Date(everyday$date)
everyday$isholiday <- as.numeric(everyday$isholiday)
years <- c(1:nrow(everyday))
years <- 0
everyday <- data.frame(everyday,years)

if(nrow(everyday[everyday$date >= as.Date("2017-01-01")&everyday$date <= as.Date("2017-12-31"),]) != 0)
{
  everyday[everyday$date >= as.Date("2017-01-01")&everyday$date <= as.Date("2017-12-31"),]$years <- 2017
}
if(nrow(everyday[everyday$date >= as.Date("2016-01-01")&everyday$date <= as.Date("2016-12-31"),]) != 0)
{
  everyday[everyday$date >= as.Date("2016-01-01")&everyday$date <= as.Date("2016-12-31"),]$years <- 2016
}
if(nrow(everyday[everyday$date >= as.Date("2015-01-01")&everyday$date <= as.Date("2015-12-31"),])!=0)
{
  everyday[everyday$date >= as.Date("2015-01-01")&everyday$date <= as.Date("2015-12-31"),]$years <- 2015
}

everyday <- everyday[,-2]


everyday$review_id <- 1 

write.csv(everyday, file = get_fileName("justreviews","2017-10-02","justreview1.csv"),row.names = F)

#count reviews
reviewss <- read.csv(get_fileName("justreviews","2017-10-02","justreview1.csv"))
reviewss <- reviewss[reviewss$years>0,]
reviewss <- aggregate(reviewss[,c(2)],reviewss[,c(1,3,4)],sum)
price <- c(1:nrow(reviewss))
price <- 0
review_rate <- c(1:nrow(reviewss))
review_rate <- 0
avaliLength <- c(1:nrow(reviewss))
avaliLength <- 0
reviewss <- data.frame(reviewss[,1:3],price,review_rate,avaliLength,reviewss$x)
names(reviewss)[7] = "reviews"

#aggregate the sum of reviews
finalData <- read.csv(get_fileName("newR","","finalTable.csv"))
reviews <- c(1:nrow(finalData))
reviews <- 0
finalData <- data.frame(finalData,reviews)

finalData <- rbind(finalData,reviewss)

finalData <- aggregate(finalData[,c(4:7)],finalData[,c(1,2,3)],sum)

write.csv(finalData, file = get_fileName("newR","","finalTable.csv"),row.names = F)

#finalData$reviews <- finalData$reviews/0.72*5.1

#





