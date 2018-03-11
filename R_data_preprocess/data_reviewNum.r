rm(list = ls())
library(data.table)
library(lubridate)
MAIN_DIR <- "/Users/Andrea/airbnb/data/"

datas <- c("2017-08-02")


get_fileName <- function(folder, wdate, pattern){
  filename <- paste(MAIN_DIR,folder,"/",wdate,"_",pattern,sep="")
  print(filename)
  return(filename)
}

for(data in datas)
{
  reviews <- read.csv(get_fileName("justreviews","2017-10-02","justreview.csv"))
  everydays <- read.csv(get_fileName("everyday",data,"everyDay.csv"))
  reviewNum <- c(1:nrow(everydays))
  reviewNum <- 0
  everydays <- data.frame(everydays,reviewNum)
  everydays$date <- as.Date(everydays$date)
  reviews$date <- as.Date(reviews$date)
  
  #hisww <- subset(reviews, reviews$listing_id == everydays[1,1] & reviews$date == as.Date(everydays[1,2]))
  
  for(i in 1:nrow(everydays))
  {
    everydays[i,5] <- nrow(subset(reviews, reviews$listing_id == everydays[i,1] & reviews$date == as.Date(everydays[i,2])))
    
  }

  write.csv(everydays, file = get_fileName("newR",data,"everyDay.csv"),row.names = F)
}



