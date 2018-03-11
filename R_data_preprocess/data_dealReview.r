rm(list = ls())
MAIN_DIR <- "/Users/Andrea/airbnb/OriginData"

datas <- c( "2017-10-02")

get_fileName <- function(wdate, pattern){
  filename <- paste(MAIN_DIR,"/",wdate,"_",pattern,sep="")
  print(filename)
  return(filename)
}

for(data in datas)
{
  detail_review <- read.csv(get_fileName(data,"detail_reviews.csv.gz"))
  detail_review <- data.frame(detail_review$listing_id,detail_review$date,detail_review$id)
  names(detail_review)[1] <- "listing_id"
  names(detail_review)[2] <- "date"
  names(detail_review)[3] <- "review_id"
  
  write.csv(detail_review, file = get_fileName(data,"justreview.csv"),row.names = F)
  
}