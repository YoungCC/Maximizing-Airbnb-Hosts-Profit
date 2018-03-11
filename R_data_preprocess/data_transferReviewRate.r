rm(list = ls())
library(data.table)
library(lubridate)
MAIN_DIR <- "/Users/Andrea/airbnb/data/"

datas <- c( "2015-06-01", "2015-05-01", "2015-04-01",
            "2015-03-01")


get_fileName <- function(folder, wdate, pattern){
  filename <- paste(MAIN_DIR,folder,"/",wdate,"_",pattern,sep="")
  print(filename)
  return(filename)
}

for(data in datas)
{
  listings <- read.csv(get_fileName("newListing",data,"newListing.csv"))
  everydays <- read.csv(get_fileName("everyday",data,"everyDay.csv"))
  
  ned <- data.frame(listings$listing_id,listings$review_rate)
  names(ned) <- c("listing_id","review_rate")
  
  everydays <- merge(everydays,ned,by="listing_id")
  
  listings <- listings[,-10]
  
  write.csv(everydays, file = get_fileName("newR",data,"everyDay.csv"),row.names = F)
  write.csv(listings, file = get_fileName("newR",data,"newListing.csv"),row.names = F)
}



