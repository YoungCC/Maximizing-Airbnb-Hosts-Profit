rm(list = ls())
library(data.table)
library(lubridate)
library(stringr)
MAIN_DIR <- "/Users/Andrea/airbnb/OriginData"

datas <- c( "2017-09-02", "2017-08-02", "2017-07-02", "2017-06-02",
            "2017-05-02", "2017-04-02", "2017-03-02", "2017-02-02", "2017-01-01",
            "2016-12-03", "2016-11-02", "2016-10-01", "2016-09-02", "2016-08-02",
            "2016-07-02", "2016-06-02", "2016-05-02", "2016-04-03", "2016-02-02",
            "2016-01-01", "2015-12-02", "2015-11-20", "2015-11-01", "2015-10-01", 
            "2015-09-01", "2015-08-01", "2015-06-01", "2015-05-01", "2015-04-01",
            "2015-03-01", "2015-01-01")

get_fileName <- function(wdate, pattern){
  filename <- paste(MAIN_DIR,"/",wdate,"_",pattern,sep="")
  print(filename)
  return(filename)
}

for(data in datas)
{
  detail_listings <- read.csv(get_fileName(data,"detail_listings.csv.gz"))
  detail_calendar <- read.csv(get_fileName(as.Date(data)-months(2),"detail_calendar.csv.gz"))
  
  # change the date format
  #detail_calendar <- detail_calendar[order(detail_calendar[,2]),] get the order
  detail_calendar$date <- as.Date(detail_calendar$date,"%Y-%m-%d")
  detail_calendar <- subset(detail_calendar,detail_calendar$date <= as.Date(data))
  
  # build a newListing
  # for different months, there is two lines to get data
  #newListing <- data.table(detail_listings$id,detail_listings[,23],detail_listings[,33:39],detail_listings[,57],detail_listings[,30:31])
  #newListing <- data.table(detail_listings$id,detail_listings[,37],detail_listings[,49:56],detail_listings[,77],detail_listings[,46:47])
  newListing <- data.table(detail_listings$id,detail_listings[,40],detail_listings[,52:59],detail_listings[,80],detail_listings[,49:50])
  names(newListing)[1] <- "listing_id"
  names(newListing)[11] <- "review_rate"
  names(newListing)[2] <- "neighbourhood"
  #newListing <- merge(detail_calendar, newListing,by="listing_id")
  
  # add clean fee to price in deail_calendar
  #cleanPrice <- data.table(detail_listings$id,detail_listings$cleaning_fee)
  #cleanPrice$V2 <- cleanPrice$V2 %>% str_replace("[$]","")
  #cleanPrice$V2 <- sub("^$","0.0",cleanPrice$V2)
  #names(cleanPrice)[1] <- "listing_id"
  detail_calendar$price <- detail_calendar$price %>% str_replace("[$]","")
  detail_calendar$price <- sub("^$","0.0",detail_calendar$price)
  detail_calendar$price <- as.numeric(detail_calendar$price)

  # change the price in detail_calendar
  detail_calendar <- detail_calendar[detail_calendar$price>0, ]
  #detail_calendar <- merge(detail_calendar, cleanPrice,by="listing_id")
  #detail_calendar$price <- as.numeric(detail_calendar$price)+as.numeric(detail_calendar$V2)
  #detail_calendar <- detail_calendar[,-5]
  detail_calendar <- detail_calendar[,-3]
  
  write.csv(detail_calendar, file = get_fileName(data,"everyDay.csv"),row.names = F)
  write.csv(newListing, file = get_fileName(data,"newListing.csv"),row.names = F)
  
  
}

#d <- c("2017-10-01","2017-01-01")
#library(timeDate)
#print(holidayNYSE(2013))
#print(isWeekend("2017-02-20"))


