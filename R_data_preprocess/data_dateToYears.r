rm(list = ls())
library(data.table)
library(lubridate)
MAIN_DIR <- "/Users/Andrea/airbnb/data/"

datas <- c("2017-10-02", "2017-09-02", "2017-08-02", "2017-07-02", "2017-06-02",
           "2017-05-02", "2017-04-02", "2017-03-02", "2017-02-02", "2017-01-01",
           "2016-12-03", "2016-11-02", "2016-10-01", "2016-09-02", "2016-08-02",
           "2016-07-02", "2016-06-02", "2016-05-02", "2016-04-03", "2016-02-02",
           "2016-01-01", "2015-12-02", "2015-11-20", "2015-11-01", "2015-10-01", 
           "2015-09-01", "2015-08-01", "2015-06-01", "2015-05-01", "2015-04-01",
           "2015-03-01")

get_fileName <- function(folder, wdate, pattern){
  filename <- paste(MAIN_DIR,folder,"/",wdate,"_",pattern,sep="")
  print(filename)
  return(filename)
}

alldays <- data.frame(listing_id = character(0), isholiday=numeric(0), years = numeric(0), price = numeric(0), review_rate = numeric(0))
totaldays <- data.frame(listing_id=character(0),years = numeric(0), isholiday=numeric(0), avaliLength=numeric(0))

for(data in datas)
{
  everydays <- read.csv(get_fileName("everyday",data,"everyDay.csv"))
  everydays$date <- as.Date(everydays$date)
  everydays$isholiday <- as.numeric(everydays$isholiday)
  years <- c(1:nrow(everydays))
  years <- 0
  everydays <- data.frame(everydays,years)
  
  if(nrow(everydays[everydays$date >= as.Date("2017-01-01")&everydays$date <= as.Date("2017-12-31"),]) != 0)
  {
    everydays[everydays$date >= as.Date("2017-01-01")&everydays$date <= as.Date("2017-12-31"),]$years <- 2017
  }
  if(nrow(everydays[everydays$date >= as.Date("2016-01-01")&everydays$date <= as.Date("2016-12-31"),]) != 0)
  {
    everydays[everydays$date >= as.Date("2016-01-01")&everydays$date <= as.Date("2016-12-31"),]$years <- 2016
  }
  if(nrow(everydays[everydays$date >= as.Date("2015-01-01")&everydays$date <= as.Date("2015-12-31"),])!=0)
  {
    everydays[everydays$date >= as.Date("2015-01-01")&everydays$date <= as.Date("2015-12-31"),]$years <- 2015
  }
  
  everydays <- everydays[,-2]
  
  avaliLength <- c(1:nrow(everydays))
  avaliLength <- 1
  everydays1 <- data.frame(everydays$listing_id,everydays$years,everydays$isholiday,avaliLength)
  everydays1 <- aggregate(everydays1[,c(4)],everydays1[,c(1,2,3)],sum)
  names(everydays1) <- c("listing_id", "years","isholiday","avaliLength")
  totaldays <- rbind(totaldays,everydays1)
  alldays <- rbind(alldays,aggregate(everydays[,c(2,3)],everydays[,c(1,5,4)],mean))
}

alldays <- aggregate(alldays[,c(4,5)],alldays[,c(1,2,3)],mean)
totaldays <- aggregate(totaldays[,c(4)],totaldays[,c(1,2,3)],sum)
avaliLength <- c(1:nrow(alldays))
avaliLength <- 0
price <- c(1:nrow(totaldays))
price <- 0
review_rate <- c(1:nrow(totaldays))
review_rate <- 0

alldays <- data.frame(alldays,avaliLength)
totaldays <- data.frame(totaldays[,1:3],price,review_rate,totaldays[,4])
names(totaldays)[6] <- c("avaliLength")
alldays <- rbind(alldays,totaldays)
alldays <- aggregate(alldays[,c(4,5,6)],alldays[,c(1,2,3)],sum)


finalPrice <- read.csv(get_fileName("newR","","finalTable.csv"))
price <- c(1:nrow(finalPrice))
price <- 0
review_rate <- c(1:nrow(finalPrice))
review_rate <- 0
avaliLength <- c(1:nrow(finalPrice))
avaliLength <- 0
finalPrice <- data.frame(finalPrice,price,review_rate,avaliLength)

alldays <- rbind(finalPrice,alldays)

finalPrice <- aggregate(alldays[,c(4:6)],alldays[,c(1,2,3)],sum)

write.csv(finalPrice, file = get_fileName("newR","","finalTable.csv"),row.names = F)




