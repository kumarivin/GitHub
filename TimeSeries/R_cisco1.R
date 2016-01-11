# LOAD LIBRARIES
# you may need to install packages, if this is the first time you # use them. Select Packages > Install Packages in R/RStudio) 
setwd("C:/Users/TG/Documents/CSC 425/GNP_60_12_q")
library(tseries)
library(zoo)
#create new R dataframe
cisco = read.table('unemp_rate_m2005_2015.csv', header=T, sep=',')
# create time series for cisco prices
ciscots = zoo(cisco$rate, as.Date(as.character(cisco$date), format = "%m/%d/%Y"))
#To retrieve only dates use
time(ciscots)
# Retrieve start date
start(ciscots)
# Retrieve End date
end(ciscots)

# sort data in chronological order
# set variable Date as time/date variable
cisco$Date=as.Date(as.character(cisco$Date), format = "%m/%d/%y")
cisco=cisco[order(cisco$Date),]

#Creating new variables 
                      
# create lagged series using function lag(tsobject, k=-1);
pricelag = lag(ciscots, k=-1);
head(pricelag)
# diff = p_t - p_(t-1);
pricedif = diff(ciscots)

#compute simple returns ret = (p_t-p_(t-1))/p_(t-1)
ret=(ciscots-pricelag)/pricelag

#Example of data analysis for cisco dataset
     
#DEFINE LOG RETURNS
#rts is a time series object since it is created from a TS object
rts = diff(log(ciscots))

#to retrieve numerical values from time series use coredata()
# rt is a numerical vector (no date information)
rt=coredata(rts)
#print first 6 values
head(rt)

# LOAD LIBRARIES
# Load fBasics packages into current session
# To install the package the first time, 
# select Tools from top Menu and select Install Packages 
library(fBasics)
                     
# COMPUTE SUMMARY STATISTICS
basicStats(rt) 
           
# CREATE HISTOGRAM 
# OPTIONAL creates 2 by 2 display for 4 plots 
# par(mfcol=c(2,2)) 
hist(rt, xlab="Cisco log returns", prob=TRUE, main="Histogram") 
# add approximating normal density curve 
xfit<-seq(min(rt),max(rt),length=40) 
yfit<-dnorm(xfit,mean=mean(rt),sd=sd(rt)) 
lines(xfit, yfit, col="blue", lwd=2) 
           
# CREATE NORMAL PROBABILITY PLOT 
qqnorm(rt) 
qqline(rt, col = 2) 
                 
# CREATE TIME PLOTS 
# simple plot where x-axis is not labeled with time 
plot(rt) 
# use time series object rts to draw time plot indexed with time 
plot(rts) 
# creates subsets of data for a certain period of time 
rts_10 = window(rts, start = as.Date("2010-01-01"), end = as.Date("2010-12-31")) 
# plot the new subset 
plot(rts_10, type='l', ylab="log returns", main="Plot of 2010 data") 
                     
# NORMALITY TESTS 
# Perform Jarque-Bera normality test. 
normalTest(rts,method=c("jb")) 
               
# COMPUTE ACF AND PLOT CORRELOGRAM 
#prints acf values to console 
acf(rt, plot=F) 
#plot acf values on graph (correlogram) 
acf(rt, plot=T) 
               
# COMPUTE LJUNG-BOX TEST FOR WHITE NOISE (NO AUTOCORRELATION) 
# to Lag 6 
Box.test(rts,lag=6,type='Ljung') 
# to Lag 12 
Box.test(rts,lag=12,type='Ljung') 
                     