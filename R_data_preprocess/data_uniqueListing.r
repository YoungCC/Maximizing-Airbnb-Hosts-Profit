rm(list = ls())
library(data.table)
library(lubridate)
MAIN_DIR <- "/Users/Andrea/airbnb/data/"

datas <- c( "2017-09-02", "2017-08-02", "2017-07-02", "2017-06-02",
            "2017-05-02", "2017-04-02", "2017-03-02", "2017-02-02", "2017-01-01",
            "2016-12-03", "2016-11-02", "2016-10-01", "2016-09-02", "2016-08-02",
            "2016-07-02", "2016-06-02", "2016-05-02", "2016-04-03", "2016-02-02",
            "2016-01-01", "2015-12-02", "2015-11-20", "2015-11-01", "2015-10-01", 
            "2015-09-01", "2015-08-01")


get_fileName <- function(folder, wdate, pattern){
  filename <- paste(MAIN_DIR,folder,"/",wdate,"_",pattern,sep="")
  print(filename)
  return(filename)
}

nlistings <- read.csv(get_fileName("newListing","2017-10-02", "newListing.csv"))

for(data in datas)
{
 
  listings <- read.csv(get_fileName("newListing",data,"newListing.csv"))
  nlistings <- rbind(listings, nlistings) 
 
  nlistings <- nlistings[!duplicated(nlistings$listing_id), ]
}

write.csv(nlistings, file = get_fileName("newR","final","newListing.csv"),row.names = F)

names(nlistings)

listings <- read.csv(get_fileName("newR","final","newListing1.csv"))
listings$amenities <- "{}"
nlistings <- rbind(listings, nlistings) 
nlistings <- nlistings[!duplicated(nlistings$listing_id), ]

write.csv(nlistings, file = get_fileName("newR","final","newListings.csv"),row.names = F)

