
library(forecast)

####################################################################
#Question 1 + QUestion 2
####################################################################


#Reading datset
nasa_Data<-read.csv("C:\\Users\\urvipalvankar\\Urvi\\Master of Management Analytics\\867 - Predictive Modelling\\Assignment 2\\NASA\\nasa_clean.csv", header=TRUE, sep=",")

#Defining time series of the dataset
nasa_ts <- ts(nasa_Data$Avg_Anomaly_deg_C,start=c(1880,01), frequency=12)


###
#Decomposing Time Series datset
###

#Decompose using STL (Season and trend using Loess)
decomp_3 <- stl(nasa_ts, t.window=12, s.window="periodic") 
plot(decomp_3)

#checking for autocorrelation and determining an estimate for p and q
Acf(nasa_ts,main="")
Acf(diff(log(nasa_ts,12)),main="")

###
#Tbats
###

#Train model on full dataset
nasa_tbats <- tbats(nasa_ts,season=TRUE)
nasa_tbats

#Forecasting using TBATS
nasa_tbats_pred <- forecast(nasa_tbats, h=969, level=c(0.8, 0.95))
plot(nasa_tbats_pred)
Acf(residuals(nasa_tbats))

#Split train and test and check for accuracy
train<-window(nasa_ts, start=c(1880,01), end=c(2004,12))
test<-window(nasa_ts, start=c(2005,01))
nasa_tbats_acc<- tbats(train,season=TRUE)
nasa_tbats_pred_acc <- forecast(nasa_tbats_acc, h=182, level=c(0.8, 0.95))
accuracy(nasa_tbats_pred_acc,test)

#Plot Decomposition
plot(nasa_tbats)

#Cross Validation for TBATS
f_TBATS  <- function(y, h) forecast(tbats(y), h = h)
errors_TBATS_full <- tsCV(nasa_ts, f_TBATS, h=1, window=1500)
mean(abs(errors_TBATS_full/nasa_ts), na.rm=TRUE)*100
sqrt(mean(errors_TBATS_full^2, na.rm=TRUE))


###
#ARIMA
###

#Train model on full dataset
arima_nasa <- auto.arima(nasa_ts, seasonal = TRUE,stepwise = FALSE,approximation = FALSE)
arima_nasa

#Forecasting using auto.arima
forecasted_temp<-data.frame(forecast(arima_nasa,h=969,level=c(0.8, 0.90)))
plot(forecast(arima_nasa,h=969))
Acf(residuals(arima_nasa))
write.csv(forecasted_temp,"C:\\Users\\urvipalvankar\\Urvi\\Master of Management Analytics\\867 - Predictive Modelling\\Assignment 2\\NASA\\forecasted_values_Q1.csv")

#Split train and test and check for accuracy
train<-window(nasa_ts, start=c(1880,01), end=c(2004,12))
test<-window(nasa_ts, start=c(2005,01))
arima_nasa_acc <- auto.arima(train, seasonal = TRUE,stepwise = FALSE,approximation = FALSE )
arima_nasa_acc_pred <- forecast(arima_nasa_acc, h=182, level=c(0.8, 0.95))
accuracy(arima_nasa_acc_pred,test)

#crossvalidation for arima model
f_arima_anomalies <- function(y, h) forecast(auto.arima(y,seasonal = TRUE,stepwise = FALSE,approximation = FALSE ), h = h)
errors_arima_anomalies_full <- tsCV(nasa_ts, f_arima_anomalies, h=1,window = 1500)
mean(abs(errors_arima_anomalies_full/nasa_ts), na.rm=TRUE)*100
sqrt(mean(errors_arima_anomalies_full^2, na.rm=TRUE))

#######################################################################
#Question 6
#######################################################################


#Split train and test
train_1<-window(nasa_ts, start=c(1880,01), end=c(2006,12))
test_1<-window(nasa_ts, start=c(2007,01), end=c(2017,12))

#Building ARIMA model on train set and forecasting test set
nasa_arima_split <- auto.arima(train_1, seasonal = TRUE,stepwise = FALSE,approximation = FALSE )
nasa_arima_split_pred <- forecast(nasa_arima_split, h=132, level=c(0.8, 0.90))
plot(forecast(nasa_arima_split, h=132, level=c(0.8, 0.95)))

forecasted_anomalies_q6<-data.frame(nasa_arima_split_pred)
write.csv(forecasted_anomalies_q6,"C:\\Users\\urvipalvankar\\Urvi\\Master of Management Analytics\\867 - Predictive Modelling\\Assignment 2\\NASA\\forecasted_values_Q6.csv")

#Checking for accuracy of the model
accuracy(nasa_arima_split_pred,test_1)


#######################################################################
#Question 7
#######################################################################

#Split train and test
train_2<-window(nasa_ts, start=c(1880,01), end=c(1999,12))
test_2<-window(nasa_ts, start=c(2000,01))

#Building ARIMA model on train set and forecasting test set
nasa_arima_split_2 <- auto.arima(train_2, seasonal = TRUE,stepwise = FALSE,approximation = FALSE )
nasa_arima_split_pred_2 <- forecast(nasa_arima_split_2, h=243, level=c(0.8, 0.90))

forecasted_anomalies_q7<-data.frame(nasa_arima_split_pred_2)
write.csv(forecasted_anomalies_q7,"C:\\Users\\urvipalvankar\\Urvi\\Master of Management Analytics\\867 - Predictive Modelling\\Assignment 2\\NASA\\forecasted_values_Q7.csv")

#Checking for accuracy of the model
accuracy(nasa_arima_split_pred_2,test_2)
