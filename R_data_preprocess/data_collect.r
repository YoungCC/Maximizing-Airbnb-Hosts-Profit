
MAIN_DIR <- "/Users/Andrea/airbnb"
ifelse(!dir.exists(MAIN_DIR), dir.create(MAIN_DIR), FALSE)
setwd(MAIN_DIR)

BASE_URL <- "http://data.insideairbnb.com/united-states/ny/new-york-city"
datas <- c("2017-10-02", "2017-09-02", "2017-08-02", "2017-07-02", "2017-06-02",
           "2017-05-02", "2017-04-02", "2017-03-02", "2017-02-02", "2017-01-01",
           "2016-12-03", "2016-11-02", "2016-10-01", "2016-09-02", "2016-08-02",
           "2016-07-02", "2016-06-02", "2016-05-02", "2016-04-03", "2016-02-02",
           "2016-01-01", "2015-12-02", "2015-11-20", "2015-11-01", "2015-10-01", 
           "2015-09-01", "2015-08-01", "2015-06-01", "2015-05-01", "2015-04-01",
           "2015-03-01", "2015-01-01"
           )
file_names <- c("listings.csv.gz", "calendar.csv.gz", "reviews.csv.gz", 
                "listings.csv", "reviews.csv","neighbourhoods.csv", 
                "neighbourhoods.geojson")

# Download data
for(data in datas)
{
  for(file_name in file_names)
  {
    # According to the file name, setting file_type for URL
    ifelse(length(grep("csv.gz", file_name)), 
           file_type <- "data", 
           file_type <- "visualisations")
    URL <- paste(BASE_URL, data, file_type, file_name, sep="/")
    # When "csv.gz" included in file name, this is detail data.
    # To avoid conflict when unzip those gz file, we add "detail" in the name
    ifelse(length(grep("csv.gz", file_name)), 
           destfile <- paste(data, "detail", file_name, sep="_"), 
           destfile <- paste(data, file_name, sep="_"))
    #print(URL)
    #print(destfile)
    download.file(URL, destfile)
  }
}