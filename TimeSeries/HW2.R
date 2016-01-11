library(zoo)
library(fBasics)
library(lmtest)
library(forecast)
setwd("C:/Users/TG/Documents/CSC 425/Week2 Lab")
mydl=read.csv("oranges.csv",header=T)
head(mydl)

ratedate=zoo(mydl$date,as.Date(mydl$date,format='%m/%d/%Y'))

acf(mydl$date)
pacf(mydl$date)

#AR(4) model

m4=Arima(mydl$rate,order=c(4,0,0))
library(lmtest)
coeftest(m4)
ar(mydl$rate)

#residual analysis - ACF Plot, Ljung box test , normality test using qq plot, roots of the polinomial
#automated correlation function for analysis of residuals
acf(m4$resid)
Box.test(m4$resid,lag=6,type='Ljung-Box',fitdf=4)
Box.test(m4$resid,lag=10,type='Ljung-Box',fitdf=4)

#quantile plot

qqnorm(m4$resid)
qqline(m4$resid)

#roots of the polinomiyal

polyroot(c(1,-m4$coef[1:4]))

#x(1,2)=0.47+1.55i , x(3,4)=-1.55+/-1.25i (|x(1,2|=sqrt(a^2+b^2)) >1)

m4$coef[5]*(1-m4$coef[1]-m4$coef[2]-m4$coef[3]-m4$coef[4])


#forecast

f=forecast.Arima(m4,h=5)
plot(f,include=100)
