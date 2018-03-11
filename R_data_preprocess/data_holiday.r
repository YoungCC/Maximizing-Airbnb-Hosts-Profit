rm(list = ls())
library(data.table)
library(lubridate)
MAIN_DIR <- "/Users/Andrea/airbnb/data/everyday"

datas <- c("2017-10-02", "2017-09-02", "2017-08-02", "2017-07-02", "2017-06-02",
           "2017-05-02", "2017-04-02", "2017-03-02", "2017-02-02", "2017-01-01",
           "2016-12-03", "2016-11-02", "2016-10-01", "2016-09-02", "2016-08-02",
           "2016-07-02", "2016-06-02", "2016-05-02", "2016-04-03", "2016-02-02",
           "2016-01-01", "2015-12-02", "2015-11-20", "2015-11-01", "2015-10-01", 
           "2015-09-01", "2015-08-01", "2015-06-01", "2015-05-01", "2015-04-01",
           "2015-03-01")

manyHolidays2 <- c("2015-02-13", "2015-02-14", "2015-02-15", "2015-04-04", "2015-04-05", "2015-04-06", 
                   "2015-11-25", "2015-11-26", "2015-11-27", "2016-02-13", "2016-02-14", "2016-02-15", 
                   "2016-03-27", "2016-03-26", "2016-03-28", "2016-11-23", "2016-11-24", "2016-11-25",
                   "2017-02-13", "2017-02-14", "2017-02-15", "2017-04-15", "2017-04-16", "2015-04-17",
                   "2015-10-08", "2015-10-09", "2015-10-10", "2015-10-11", "2016-10-06", "2016-10-07",
                   "2016-10-08", "2016-10-09", "2017-10-05", "2017-10-06", "2017-10-07", "2017-10-08"
                   )

get_fileName <- function(wdate, pattern){
  filename <- paste(MAIN_DIR,"/",wdate,"_",pattern,sep="")
  print(filename)
  return(filename)
}

for(data in datas)
{
  everyday <- read.csv(get_fileName(data,"everyDay.csv"))
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
  
  write.csv(everyday, file = get_fileName(data,"everyDay.csv"),row.names = F)
  
}





