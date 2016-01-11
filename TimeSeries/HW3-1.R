#1. LOAD LIBRARIES
library(tseries)
library(fBasics)
library(forecast)
library(lmtest)

#2. IMPORT DATA
#  Load data with variable names into the data frame "myd"
myd=read.table("INDPRO.csv",header=T, sep=',') 
date = myd[,1]
growth = myd[,2]

# creates time series object 
growthts=ts(rate, start=c(1970,2), freq=12)

#3 COMPUTE SUMMARY STATISTICS
basicStats(growth)

#5 CREATE HISTOGRAM
# creates 2 by 2 display for 4 plots
par(mfcol=c(1,1)) 
hist(growth, xlab="Growth rates", prob=TRUE, main="Histogram")
# add approximating normal density curve
xfit<-seq(min(growth),max(growth),length=40)
yfit<-dnorm(xfit,mean=mean(growth),sd=sd(growth))
lines(xfit, yfit, col="blue", lwd=2) 

#6 CREATE NORMAL PROBABILITY PLOT
qqnorm(growth)
qqline(growth, col = 2) 

#7 CREATE TIME PLOT 
# use time series object lnatts to draw time plot indexed with time
plot(growthts, type='l', xlab='time', ylab='Growth rates')

#8 COMPUTE ACF and PACF AND PLOT CORRELOGRAM
#prints acf to console
acf(growth, plot=F, lag=15)
# creates 2 by 1 display for 2 plots
par(mfcol=c(1,1)) 
#plots acf (correlogram)
acf(growth, plot=T, lag=15)

# plots pacf values up to lag 15. 
pacf(growth, lag = 20)

# 9. NORMALITY TESTS
# Perform Jarque-Bera normality test.
normalTest(growth,method=c('jb'))  

#10 COMPUTE LJUNG-BOX TEST FOR WHITE NOISE (NO AUTOCORRELATION)
# for Lags 4, 8, 12
Box.test(growth,lag=3,type='Ljung')
Box.test(growth,lag=8,type='Ljung')
Box.test(growth,lag=10,type='Ljung')



#  FIT AN ARMA(2,2) MODEL 
#
auto.arima(growth,ic='bic')
m3= Arima(growth, order=c(1,0,1), method='ML', include.mean=T)
m3
# T-tests on coefficients
coeftest(m3)
# RESIDUAL ANALYSIS
Box.test(m3$residuals,lag=4,type='Ljung', fitdf=1)
Box.test(m3$residuals,lag=5,type='Ljung', fitdf=1)
acf(m3$residuals)


# AR Model
m4=Arima(mydl$growth,order=c(3,0,0))
coeftest(m4)
Box.test(m4$resid,lag=3,type='Ljung-Box',fitdf=3)
Box.test(m4$resid,lag=6,type='Ljung-Box',fitdf=3)
Box.test(m4$resid,lag=9,type='Ljung-Box',fitdf=3)
Box.test(m4$resid,lag=12,type='Ljung-Box',fitdf=3)

#  FIT A MA(4) MODEL 
#
m1= Arima(growth, order=c(0,0,4), method='ML', include.mean=T)
m1
# T-tests on coefficients
coeftest(m1)

# RESIDUAL ANALYSIS
Box.test(m1$residuals,lag=5,type='Ljung', fitdf=4)
Box.test(m1$residuals,lag=10,type='Ljung', fitdf=4)
Box.test(m1$residuals,lag=15,type='Ljung', fitdf=4)
acf(m1$residuals)


# COMPUTE PREDICTIONS USING AR,MA,ARMA

#you can also use forecast.Arima(model) in forecast package
# h= horizon

forecast.Arima(m1, h=5)
forecast.Arima(m4, h=5)
forecast.Arima(m3, h=5)

plot(forecast.Arima(m2, h=20), include=200)

basicStats(growth)


#PLOT PREDICTIONS FOR 10 STEPS AHEAD 
# use plot in forecast package
# include defines the length of observed TS to be plotted
plot(forecast.Arima(m1, h=10), include=50)

plot(forecast.Arima(m3, h=10), include=50)

plot(forecast.Arima(m4, h=10), include=50)



