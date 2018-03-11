plotdata=clean_holiday_omit[,c(3,14)]
plot(plotdata, cex=0.1)

## linear regression
plotdata_linear=plotdata[holiday_test_linear,]
plotdata_linear$pred=0
plotdata_linear[1:12859,3]=linear_pred
plot(plotdata_linear$price, plotdata_linear$occp_rate_modified, cex=0.1, col="grey")
points(plotdata_linear$price, plotdata_linear$pred, cex=0.2, col="blue")


## lasso
plotdata_lasso=plotdata[holiday_test_lasso,]
plotdata_lasso$pred=0
plotdata_lasso[,3]=lasso_pred
plot(plotdata_lasso$price, plotdata_lasso$occp_rate_modified, cex=0.1, col="grey")
points(plotdata_lasso$price, plotdata_lasso$pred, cex=0.2, col="blue")

## GAM
plotdata_gam=plotdata[holiday_test_gam,]
plotdata_gam$pred=0
plotdata_gam[,3]=gam_pred
plot(plotdata_gam$price, plotdata_gam$occp_rate_modified, cex=0.1, col="grey")
points(plotdata_gam$price, plotdata_gam$pred, cex=0.2, col="blue")

## random forest  # best fit
plotdata_forest=plotdata[holiday_test_forest,]
plotdata_forest$pred=0
plotdata_forest[,3]=bag_pred
plot(plotdata_forest$price, plotdata_forest$occp_rate_modified, cex=0.1, col="grey", ylim=c(0,8),
     xlab="Price", ylab="Occupancy Index", main="Fitted Occupancy Index Using Random Forest Method")
points(plotdata_forest$price, plotdata_forest$pred, cex=0.1, col="indianred1")

plotdata_boost=plotdata[holiday_test_forest,]
plotdata_boost$pred=0
plotdata_boost[,3]=boost_pred
plot(plotdata_boost$price, plotdata_boost$occp_rate_modified, cex=0.1,col="grey", ylim=c(0,8),
     xlab="Price", ylab="Occupancy Index", main="Fitted Occupancy Index Using Boosting Method")
points(plotdata_boost$price, plotdata_boost$pred, cex=0.1, col="indianred1")

## SVM
## random forest
plotdata_svm=plotdata[holiday_test_svm,]
plotdata_svm$pred=0
plotdata_svm[,3]=svm_pred
plot(plotdata_svm$price, plotdata_svm$occp_rate_modified, cex=0.1, col="grey")
points(plotdata_svm$price, plotdata_svm$pred, cex=0.2, col="blue")
