library(zoo)
library(fBasics)
library(lmtest)
library(lmtest)
library(forecast)
setwd("C:/Users/TG/Documents/CSC 425/Week3 HW")
mydl=read.csv("INDPRO.csv",header=T)

head(mydl)
#Step1
indts=zoo(mydl$growth, as.Date(as.character(mydl$date), format = "%m/%d/%Y"))
rt=coredata(indts)
#Step2 
plot(indts)
#step3 
cindts=coredata(indts)
basicStats(cindts) 
hist(cindts,xlab="Growth returns", prob=TRUE, main="Histogram")
xfit<-seq(min(cindts),max(cindts),length=40) 
yfit<-dnorm(xfit,mean=mean(cindts),sd=sd(cindts)) 
lines(xfit, yfit, col="blue", lwd=2) 
qqnorm(cindts) 
qqline(cindts, col = 2) 

#step4
acf(cindts, plot=T, lag=15)
pacf(cindts,plot=T,lag=15)
Box.test(cindts,lag=20,type='Ljung',fitdf=3)
Box.test(cindts,lag=3,type='Ljung',fitdf=3)
Box.test(cindts,lag=6,type='Ljung',fitdf=3)
  #AR Model
m3=Arima(mydl$growth,order=c(3,0,0))
coeftest(m3)
Box.test(m3$resid,lag=3,type='Ljung-Box',fitdf=3)
Box.test(m3$resid,lag=6,type='Ljung-Box',fitdf=3)
Box.test(m3$resid,lag=9,type='Ljung-Box',fitdf=3)
Box.test(m3$resid,lag=12,type='Ljung-Box',fitdf=3)


  #MA Model
ma1= Arima(cindts, order=c(0,0,5), method='ML', include.mean=T)
coeftest(ma1)
ma2= Arima(cindts, order=c(0,0,3), method='ML', include.mean=T)
coeftest(ma2)






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
