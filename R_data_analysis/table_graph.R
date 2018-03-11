# two predited occupancy table
# table1: price=80
table_pred=table_occupancy[,-c(6,7,16,18,19)]
table_pred_holiday=table_pred[ho1_index,]
table_pred_holiday=na.omit(table_pred_holiday)
# use a teble to test 
test1=clean_holiday_omit
test1$price=80
test1_pred=predict(holiday_boost, newdata=test1, n.trees = 5000)
table_pred_holiday$pred_80=test1_pred

test2=clean_holiday_omit
test2$price=120
test2_pred=predict(holiday_boost, newdata=test2, n.trees = 5000)
table_pred_holiday$pred_120=test2_pred
table_pred_holiday=table_pred_holiday[, c(1,2, 16,17)]

table_location=final1[,c(1,17,18)]
table_location=unique(table_location)
######### from table_location, each listing_id correspond with a location#######3
table_graph=merge(table_pred_holiday, table_location, by="listing_id")

# export data table
library(foreign)
write.csv(table_graph, "/Users/lu/Dropbox/MATH4/6300/Project/data/table_graph.csv")

