rm(list = ls())
library(data.table)
library(lubridate)
MAIN_DIR <- "/Users/Andrea/airbnb/data/"


get_fileName <- function(folder, wdate, pattern){
  filename <- paste(MAIN_DIR,folder,"/",wdate,"_",pattern,sep="")
  print(filename)
  return(filename)
}


listings <- read.csv(get_fileName("newR","final","newListings.csv"))
finalTable <- data.frame(listing_id = character(0),years = numeric(0), isholiday = numeric(0))

table1 <- data.frame(c(listings$listing_id,listings$listing_id,listings$listing_id),c(2015,2015,2015),c(0,1,2))
table2 <- data.frame(c(listings$listing_id,listings$listing_id,listings$listing_id),c(2016,2016,2016),c(0,1,2))
table3 <- data.frame(c(listings$listing_id,listings$listing_id,listings$listing_id),c(2017,2017,2017),c(0,1,2))

names(table1) <- c("listing_id","years","isholiday")
names(table2) <- c("listing_id","years","isholiday")
names(table3) <- c("listing_id","years","isholiday")

finalTable <- rbind(finalTable ,table1,table2,table3)

write.csv(finalTable, file = get_fileName("newR","","finalTable.csv"),row.names = F)









