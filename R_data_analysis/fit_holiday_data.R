# already got a table: table_clean with modified occpancy rate 
########## from here, use table_clean to train the model##########
# linear model
clean_linear=lm(occp_rate_modified~., data=table_clean)
# from the simple can find being in holiday has effect on the occupancy

#take out the holiday data and look at holiday only ################
ho1_index=which(table_clean$isholiday==1)
clean_holiday=table_clean[ho1_index,]

############## from here, use clean_holiday data ###############
# plot the holiday data between price and occuancy, plot different year as different color
year=as.factor(clean_holiday$years)
index_2015=which(table_clean$years==2015)
index_2016=which(table_clean$years==2016)
index_2017=which(table_clean$years==2017)
plot(clean_holiday$price, clean_holiday$occp_rate_modified, cex=0.5, col=year)

clean_holiday_omit=na.omit(clean_holiday)
# method 1: simple regression
# divide into train and test sets
set.seed(1)
holiday_train_linear=sample(1:nrow(clean_holiday_omit), nrow(clean_holiday_omit)/2)
holiday_test_linear=(-holiday_train_linear)
holiday_linear=lm(occp_rate_modified~., data=clean_holiday_omit[holiday_train_linear,])
linear_pred=predict(holiday_linear, data=clean_hloiday_omit[holiday_test_linear,], type = "response")
linear_mse=mean((linear_pred-clean_holiday_omit$occp_rate_modified[holiday_test_linear])^2)
linear_mse  #3.83

# method 2: lasso regression (with feature selection)
# need to omit na's first
x_lasso=model.matrix(occp_rate_modified~., data=clean_holiday_omit)[,-1] # delete the intercept
y_lasso=clean_holiday_omit$occp_rate_modified
grid_lasso=10^seq(10,-2, length =100)
set.seed(1)
holiday_train_lasso=sample(1:nrow(clean_holiday_omit), nrow(clean_holiday_omit)/2)
holiday_test_lasso=(-holiday_train_lasso)
library(glmnet)
holiday_lasso=glmnet(x_lasso[holiday_train_lasso, ], y_lasso[holiday_train_lasso], alpha=1, lambda=grid)
lasso_out=cv.glmnet(x_lasso[holiday_train_lasso, ], y_lasso[holiday_train_lasso],alpha=1)
bestlam_holiday_lasso=lasso_out$lambda.min
bestlam_holiday_lasso #0.003257489
lasso_pred=predict(holiday_lasso, s=bestlam_holiday_lasso, newx=x_lasso[holiday_test_lasso,])
mse_lasso=mean((lasso_pred-y_lasso[holiday_test_lasso])^2)
mse_lasso  #3.89

# use GAM to add other predictors
# use spline for price 
set.seed(1)
holiday_train_gam=sample(1:nrow(clean_holiday_omit), nrow(clean_holiday_omit)/2)
holiday_test_gam=(-holiday_train_gam)
library(splines)
price_spline=smooth.spline(clean_holiday_omit$price[holiday_train_gam],clean_holiday_omit$occp_rate_modified[holiday_train_gam], cv=TRUE)
price_spline$df
library(gam)
holiday_gam=lm(occp_rate_modified~s(price,9.3)+factor(years)+review_rate+distance
               +accommodates+house_sum, data=clean_holiday_omit[holiday_train_gam,])
gam_pred=predict(holiday_gam, newdata=clean_holiday_omit[holiday_test_gam,])
mse_gam=mean((gam_pred-clean_holiday_omit$occp_rate_modified[holiday_test_gam])^2)
mse_gam # 3.89

# regression tree
library(tree)
holiday_tree=tree(occp_rate_modified~., clean_holiday_omit, subset=holiday_train_forest)
summary(holiday_tree)
plot(tree.holiday)
text(tree.holiday,pretty=0)

# method 3: random forest 
library(randomForest)
set.seed(1)
holiday_train_forest=sample(1:nrow(clean_holiday_omit), nrow(clean_holiday_omit)/2)
holiday_test_forest=(-holiday_train_forest)
holiday_forest=randomForest(occp_rate_modified~., clean_holiday_omit, subset=holiday_train_forest, mtry=4, importance=TRUE)
forest_pred=predict(holiday_forest, newdata=clean_holiday_omit[holiday_test_forest,])
mse_forest=mean((forest_pred-clean_holiday_omit$occp_rate_modified[holiday_test_forest])^2)
mse_forest  ## 3.84
importance(holiday_forest) # price is the most important factor
varImpPlot(holiday_forest)
plot(holiday_forest)

## boosting
library(gbm)
set.seed(1)
holiday_boost=gbm(occp_rate_modified~., data=clean_holiday_omit[holiday_train_forest,],distribution="gaussian", n.trees=5000, interaction.depth=8)
summary(holiday_boost)
boost_pred=predict(holiday_boost, newdata=clean_holiday_omit[holiday_test_forest,], n.trees = 5000)
mse_boost=mean((boost_pred-clean_holiday_omit$occp_rate_modified[holiday_test_forest])^2)
mse_boost  #3.76

# test the study case using bosting
test_pred=predict(holiday_boost, newdata=table_test_exp, n.trees=5000)
table_test_exp$profit=table_test_exp$price*test_pred
which.max(table_test_exp$profit)
plot(table_test_exp$price, table_test_exp$profit, cex=ifelse(table_test_exp$price==186.8, 1, 0.1), col=ifelse(table_test_exp$price==186.8, "red", "black"), xlab="Price", ylab="Profit", main="Price and Profit Trad-Off")
# method 4: SVM with CV
library(e1071)
set.seed(1)
holiday_train_svm=sample(1:nrow(clean_holiday_omit), nrow(clean_holiday_omit)/2)
holiday_test_svm=(-holiday_train_svm)
holiday_svm=svm(occp_rate_modified~., data=clean_holiday_omit[holiday_train_svm,], cost=1)
svm_pred=predict(holiday_svm, newdata=clean_holiday_omit[holiday_test_svm,])
mse_svm=mean((svm_pred-clean_holiday_omit$occp_rate_modified[holiday_test_forest])^2)
mse_svm  ## 4.03

############# Boosting has the best prediction  #################

