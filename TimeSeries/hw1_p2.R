#import zoo library
# LOAD LIBRARIES
# 
# To install the package the first time, 
# select Tools from top Menu and select Install Packages 
library(zoo)
library(fBasics)
library(lmtest)
library(forecast)
#set work directory
setwd("~/Courses/CSC425/hwork_f15")
#import data in R
myd=read.table("oranges.csv", header=T, sep=',')
#create price time series using zoo function
myd$pts=zoo(myd$price, as.Date(as.character(myd$date), format="%m/%d/%Y"))

# COMPUTE SUMMARY STATISTICS
basicStats(myd$price) 

# CREATE HISTOGRAM 
# OPTIONAL creates 2 by 1 display for 2 plots 
par(mfcol=c(1,2)) 
hist(myd$price, xlab="Orange Price", prob=TRUE, main="Histogram") 
# add approximating normal density curve 
xfit<-seq(min(myd$price),max(myd$price),length=40) 
yfit<-dnorm(xfit,mean=mean(myd$price),sd=sd(myd$price)) 
lines(xfit, yfit, col="blue", lwd=2) 

# CREATE NORMAL PROBABILITY PLOT 
qqnorm(myd$price)
qqline(myd$price, col = 2) 

# CREATE TIME PLOTS 

# use time series object rts to draw time plot indexed with time 
par(mfcol=c(1,1)) 
plot(myd$pts, ylab="Orange Prices") 

# NORMALITY TESTS 
# Perform Jarque-Bera normality test. 
normalTest(myd$price ,method=c("jb")) 

# COMPUTE ACF AND PLOT CORRELOGRAM 
#prints acf values to console 
acf(as.vector(myd$price) , plot=T) 


# COMPUTE LJUNG-BOX TEST FOR WHITE NOISE (NO AUTOCORRELATION) 
# to Lag 3 
Box.test(myd$price ,lag=3,type='Ljung') 
# to Lag 5 
Box.test(myd$price ,lag=5,type='Ljung') 
# to Lag 7 
Box.test(myd$price ,lag=7,type='Ljung') 

#plot acf values on graph (correlogram) 
acf(myd$price , plot=T) 
pacf(myd$price , plot=T) 

#modeling
ar(myd$price)

#AR(2) model
m1=arima(myd$price, order=c(2,0,0))
coeftest(m1)
#diagnostics
acf(m1$residuals)
qqnorm(m1$residuals)
qqline(m1$residuals)
Box.test(m1$residuals, lag=5, type="Ljung", fitdf=1)
Box.test(m1$residuals, lag=10, type="Ljung", fitdf=1)

#Forecasts

maf=forecast.Arima(m1, h=5)

plot(maf)


