# Lab 4 starter file

library(network)
library(ergm)
library(latticeExtra)
library(intergraph)
library(sand)

# Thanks to Benjamin Lind for the data and examples

setwd("C:/Users/TG/Documents/495/lab4/lab4")
source("lab4-utils.R")

ga.gr <- read.graph("ga.graphml", format="graphml")

# Visualize the network
gaplot(ga.gr,names=TRUE)
ga.net<-asNetwork(ga.gr)
# Model 1: Edges and sex
ga.m1<-ergm(ga.net ~ edges+nodemix("sex",base=-2))
summary(ga.m1)


# Question 8: Probability of heterosexual edge
fm.edge.lo<-coef(ga.m1)[1]+coef(ga.m1)[2]
invlogit(fm.edge.lo)


#Step9
ga.sim<-simulate(ga.m1)
gaplot(asIgraph(ga.sim),names=FALSE)

ga.m1.gof<-gof(ga.m1)
plot(ga.m1.gof)
save(ga.m1,file="ga_m1.Rdata")
# Model 2: Add monogamy term
ga.m2<-ergm(ga.net ~ edges+nodemix("sex",base=-2)+degree(1))
summary(ga.m2)
mcmc.diagnostics(ga.m2)
ga.m2.gofm<-gof(ga.m2,FOG=model)
plot(ga.m2.gofm)
ga.m2.gof<-gof(ga.m2)
plot(ga.m2.gof)
save(ga.m2,file="ga_m2.Rdata")

# Model 3: Same as model 2 but increased fitting time
ga.m3<-ergm(ga.net ~ edges+nodemix("sex",base=-2)+degree(1),
            control=control.ergm(MCMC.burnin=50000,MCMC.interval=5000))
summary(ga.m3)
mcmc.diagnostics(ga.m3)
ga.m3.gofm<-gof(ga.m3,FOG=model)
plot(ga.m3.gofm)
ga.m3.gof<-gof(ga.m3)
plot(ga.m3.gof)
save(ga.m3,file="ga_m3.Rdata")

# Model 4: Add birthyear term
ga.m4<-ergm(ga.net ~edges+nodemix("sex",base=-2)+degree(1)+absdiff("birthyear"),
            control=control.ergm(MCMC.burnin=50000,MCMC.interval=5000))
summary(ga.m4)
mcmc.diagnostics(ga.m4)
ga.m4.gofm<-gof(ga.m4,FOG=model)
plot(ga.m4.gofm)
ga.m4.gof<-gof(ga.m4)
plot(ga.m4.gof)

save(ga.m4,file="ga_m4.Rdata")

# Model 5: Differentiate monogamy by sex
ga.m5<-ergm(ga.net ~edges+nodemix("sex",base=-2)+degree(1,"sex")+absdiff("birthyear"),
            control=control.ergm(MCMC.burnin=50000,MCMC.interval=5000))
summary(ga.m5)
mcmc.diagnostics(ga.m5)
ga.m5.gofm<-gof(ga.m5,FOG=model)
plot(ga.m5.gofm)
ga.m5.gof<-gof(ga.m5)
plot(ga.m5.gof)

save(ga.m5,file="ga_m5.Rdata")
gaplot(asIgraph(simulate(ga.m5)),names=FALSE)

edge<-coef(ga.m5)[1]
het<-coef(ga.m5)[2]
deg1f<-coef(ga.m5)[3]
deg1m<-coef(ga.m5)[4]

case1.lo<-edge+het+deg1f+deg1m
case2.lo<-edge+het+deg1f-deg1m
case3.lo<-edge+het-deg1f+deg1m
case4.lo<-edge+het-deg1f-deg1m
case5.lo<-edge+het
df<-data.frame(case1=invlogit(case1.lo),case2=invlogit(case2.lo),
               case3=invlogit(case3.lo),case4=invlogit(case4.lo),
               case5=invlogit(case5.lo))
# Question 22


