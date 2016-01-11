#1. LOAD LIBRARIES
library(tseries)
library(fBasics)
library(forecast)
library(lmtest)

#2. IMPORT DATA
#  Load data with variable names into the data frame "myd"
myd=read.table("UNRATE48_2014.csv",header=T, sep=',') 
date = myd[,1]
rate = myd[,2]

# creates time series object 
ratets=ts(rate, start=c(1948,2), freq=12)

#3 COMPUTE SUMMARY STATISTICS
basicStats(rate)

#5 CREATE HISTOGRAM
# creates 2 by 2 display for 4 plots
par(mfcol=c(1,1)) 
hist(rate, xlab="Unemployment rates", prob=TRUE, main="Histogram")
# add approximating normal density curve
xfit<-seq(min(rate),max(rate),length=40)
yfit<-dnorm(xfit,mean=mean(rate),sd=sd(rate))
lines(xfit, yfit, col="blue", lwd=2) 

#6 CREATE NORMAL PROBABILITY PLOT
qqnorm(rate)
qqline(rate, col = 2) 

#7 CREATE TIME PLOT 
# use time series object lnatts to draw time plot indexed with time
plot(ratets, type='l', xlab='time', ylab='Unemployment rates')

#8 COMPUTE ACF and PACF AND PLOT CORRELOGRAM
#prints acf to console
acf(rate, plot=F, lag=20)
# creates 2 by 1 display for 2 plots
par(mfcol=c(1,1)) 
#plots acf (correlogram)
acf(rate, plot=T, lag=20)

# plots pacf values up to lag 15. 
pacf(rate, lag = 15)

# 9. NORMALITY TESTS
# Perform Jarque-Bera normality test.
normalTest(rate,method=c('jb'))  

#10 COMPUTE LJUNG-BOX TEST FOR WHITE NOISE (NO AUTOCORRELATION)
# for Lags 4, 8, 12
Box.test(rate,lag=4,type='Ljung')
Box.test(rate,lag=8,type='Ljung')
Box.test(rate,lag=12,type='Ljung')

#  FIT A MA(5) MODEL 
#
m1= arima(rate, order=c(0,0,5), method='ML', include.mean=T)
m1
# T-tests on coefficients
coeftest(m1)

# RESIDUAL ANALYSIS
Box.test(m1$residuals,lag=6,type='Ljung', fitdf=5)
Box.test(m1$residuals,lag=10,type='Ljung', fitdf=5)
Box.test(m1$residuals,lag=12,type='Ljung', fitdf=5)
acf(m1$residuals)


#  FIT AN MA(5) without lag 1 MODEL 
#
# Use fixed option in arima function to fix parameter values,
# where 0 means fixing the model coefficient to be removed, 
# and NA means parameters to be fitted. The ordering of the paramter 
# can be found using m3$coef. 
# 
# MA(5) Model without MA(1) parameter
m2= arima(rate, order=c(0,0,5), include.mean=T,fixed=c(0,NA, NA, NA,NA, NA))
m2
coeftest(m2)


# RESIDUAL ANALYSIS
Box.test(residuals(m2),lag=6,type='Ljung', fitdf=4)
Box.test(residuals(m2),lag=12,type='Ljung', fitdf=4)
acf(residuals(m2), na.action=na.remove)

#  FIT AN ARMA(2,2) MODEL 
#
auto.arima(rate)
m3= arima(rate, order=c(2,0,2), method='ML', include.mean=T)
m3
# T-tests on coefficients
coeftest(m3)


# RESIDUAL ANALYSIS
Box.test(m3$residuals,lag=6,type='Ljung', fitdf=3)
Box.test(m3$residuals,lag=12,type='Ljung', fitdf=3)
acf(m3$residuals)


# COMPUTE PREDICTIONS USING ARIMA

#you can also use forecast.Arima(model) in forecast package
# h= horizon

forecast.Arima(m2, h=10)

#PLOT PREDICTIONS FOR 10 STEPS AHEAD 
# use plot in forecast package
# include defines the length of observed TS to be plotted
plot(forecast.Arima(m2, h=20), include=200)

# APPLY EACF MODEL SELECTION PROCEDURES
#use TSA package
library(TSA)
#compute eacf values for p<=6 and q<=6
m1=eacf(rate, 6,6)
names(m1)
print(m1$eacf, digits=2)


# AUTO.ARIMA SELECTS ARMA(P,Q) MODEL BASED ON AIC OR BIC
# Load package forecast (if not already available)
# optimal w.r.t. BIC criterion
auto.arima(rate, max.P=8, max.Q=8, ic="bic")
# optimal w.r.t. AIC criterion 
auto.arima(rate, max.P=8, max.Q=8, ic="aic")



